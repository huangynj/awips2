/**
 * This software was developed and / or modified by Raytheon Company,
 * pursuant to Contract DG133W-05-CQ-1067 with the US Government.
 * 
 * U.S. EXPORT CONTROLLED TECHNICAL DATA
 * This software product contains export-restricted data whose
 * export/transfer/disclosure is restricted by U.S. law. Dissemination
 * to non-U.S. persons whether in the United States or abroad requires
 * an export license or other authorization.
 * 
 * Contractor Name:        Raytheon Company
 * Contractor Address:     6825 Pine Street, Suite 340
 *                         Mail Stop B8
 *                         Omaha, NE 68106
 *                         402.291.0100
 * 
 * See the AWIPS II Master Rights File ("Master Rights File.pdf") for
 * further licensing information.
 **/
package com.raytheon.uf.edex.gridcoverage;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;

import com.raytheon.uf.common.gridcoverage.GridCoverage;
import com.raytheon.uf.common.gridcoverage.request.GetGridCoverageRequest;
import com.raytheon.uf.common.serialization.comm.IRequestHandler;
import com.raytheon.uf.common.status.IUFStatusHandler;
import com.raytheon.uf.common.status.UFStatus;
import com.raytheon.uf.edex.database.cluster.ClusterLockUtils;
import com.raytheon.uf.edex.database.cluster.ClusterLockUtils.LockState;
import com.raytheon.uf.edex.database.cluster.ClusterTask;
import com.raytheon.uf.edex.database.dao.CoreDao;
import com.raytheon.uf.edex.database.dao.DaoConfig;

/**
 * Handles database access of grid coverage, GetGridCoverageRequest can be used
 * to do spatial lookup and creation.
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * 
 * Date          Ticket#  Engineer    Description
 * ------------- -------- ----------- --------------------------
 * Mar 26, 2012           bsteffen    Initial creation
 * Mar 07, 2013  1771     bsteffen    fix gridcoverage duplicate checks.
 * Mar 20, 2013  2910     bsteffen    Commit transaction within cluster locks.
 * May 10, 2016  5642     rjpeter     Remove transaction nesting.
 * Jun 24, 2016  ASM18440 dfriedman   Fix spatial tolerance for degree values.
 * </pre>
 * 
 * @author bsteffen
 * @version 1.0
 */

public class GetGridCoverageHandler implements
        IRequestHandler<GetGridCoverageRequest> {
    private static final transient IUFStatusHandler statusHandler = UFStatus
            .getHandler(GetGridCoverageHandler.class);

    private final CoreDao dao;

    public GetGridCoverageHandler() {
        dao = new CoreDao(DaoConfig.forClass(GridCoverage.class));
    }

    @Override
    public GridCoverage handleRequest(GetGridCoverageRequest request)
            throws Exception {
        GridCoverage coverage = request.getCoverage();
        GridCoverage rval = checkDatabase(coverage, false);

        if ((rval == null) && request.getCreate()) {
            /*
             * Get cluster lock to ensure only 1 coverage created for a given
             * area
             */
            ClusterTask ct = null;
            do {
                ct = ClusterLockUtils.lock("gridcoverage",
                        "create" + coverage.getProjectionType(), 120000, true);
            } while (!LockState.SUCCESSFUL.equals(ct.getLockState()));

            try {
                rval = checkDatabase(coverage, true);
            } finally {
                ClusterLockUtils.deleteLock(ct.getId().getName(), ct.getId()
                        .getDetails());
            }
        }

        return rval;
    }

    private GridCoverage checkDatabase(GridCoverage coverage, boolean create)
            throws Exception {
        GridCoverage rval = null;
        Session sess = null;
        Transaction trans = null;

        try {
            sess = dao.getSessionFactory().openSession();
            trans = sess.beginTransaction();

            Criteria crit = sess.createCriteria(coverage.getClass());
            double spacingUnitTolerance = coverage.getSpacingUnitTolerance();

            crit.add(Restrictions.eq("nx", coverage.getNx()));
            crit.add(Restrictions.eq("ny", coverage.getNy()));
            crit.add(Restrictions.between("dx", coverage.getDx()
                    - spacingUnitTolerance, coverage.getDx()
                    + spacingUnitTolerance));
            crit.add(Restrictions.between("dy", coverage.getDy()
                    - spacingUnitTolerance, coverage.getDy()
                    + spacingUnitTolerance));
            crit.add(Restrictions.between("la1", coverage.getLa1()
                    - GridCoverage.SPATIAL_TOLERANCE_DEG, coverage.getLa1()
                    + GridCoverage.SPATIAL_TOLERANCE_DEG));
            crit.add(Restrictions.between("lo1", coverage.getLo1()
                    - GridCoverage.SPATIAL_TOLERANCE_DEG, coverage.getLo1()
                    + GridCoverage.SPATIAL_TOLERANCE_DEG));
            List<?> vals = crit.list();

            for (Object val : vals) {
                if (((GridCoverage) val).spatialEquals(coverage)) {
                    rval = (GridCoverage) val;
                }
            }

            if ((rval == null)
                    && ((Math.abs(coverage.getLo1()) > 179) || (Math
                            .abs(coverage.getLa1()) > 89))) {
                /*
                 * if we got here nothing matches, try a query with no la1, and
                 * lo1 in case there are world wrap issues.
                 */
                crit = sess.createCriteria(coverage.getClass());

                crit.add(Restrictions.eq("nx", coverage.getNx()));
                crit.add(Restrictions.eq("ny", coverage.getNy()));
                crit.add(Restrictions.between("dx", coverage.getDx()
                        - spacingUnitTolerance, coverage.getDx()
                        + spacingUnitTolerance));
                crit.add(Restrictions.between("dy", coverage.getDy()
                        - spacingUnitTolerance, coverage.getDy()
                        + spacingUnitTolerance));
                vals = crit.list();
                for (Object val : vals) {
                    if (((GridCoverage) val).spatialEquals(coverage)) {
                        return (GridCoverage) val;
                    }
                }
            }

            // if it still does not exist, create it if requested
            if ((rval == null) && create) {
                coverage.initialize();
                sess.saveOrUpdate(coverage);
                trans.commit();
                rval = coverage;
            }
        } catch (Exception e) {
            statusHandler.error("Error occurred looking up GridCoverage["
                    + coverage.getName() + "]", e);

            if (trans != null) {
                try {
                    trans.rollback();
                } catch (Exception e1) {
                    statusHandler.error(
                            "Error occurred rolling back transaction", e1);
                }
            }

            throw e;
        } finally {
            if (sess != null) {
                try {
                    sess.close();
                } catch (Exception e) {
                    statusHandler.error("Error occurred closing session", e);
                }
            }
        }

        return rval;
    }
}
