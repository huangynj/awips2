package com.raytheon.uf.edex.plugin.ffmp;

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

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map.Entry;

import com.raytheon.uf.common.dataplugin.PluginDataObject;
import com.raytheon.uf.common.dataplugin.PluginException;
import com.raytheon.uf.common.dataplugin.ffmp.FFMPBasin;
import com.raytheon.uf.common.dataplugin.ffmp.FFMPBasinData;
import com.raytheon.uf.common.dataplugin.ffmp.FFMPRecord;
import com.raytheon.uf.common.dataplugin.ffmp.FFMPTemplates;
import com.raytheon.uf.common.dataplugin.ffmp.FFMPVirtualGageBasin;
import com.raytheon.uf.common.dataplugin.ffmp.FFMPVirtualGageBasinMetaData;
import com.raytheon.uf.common.dataplugin.persist.IPersistable;
import com.raytheon.uf.common.datastorage.IDataStore;
import com.raytheon.uf.common.datastorage.records.FloatDataRecord;
import com.raytheon.uf.common.datastorage.records.IDataRecord;
import com.raytheon.uf.common.monitor.config.FFMPRunConfigurationManager;
import com.raytheon.uf.common.monitor.config.FFMPSourceConfigurationManager;
import com.raytheon.uf.common.monitor.config.FFMPSourceConfigurationManager.GUIDANCE_TYPE;
import com.raytheon.uf.common.monitor.xml.DomainXML;
import com.raytheon.uf.common.monitor.xml.SourceXML;
import com.raytheon.uf.common.status.IUFStatusHandler;
import com.raytheon.uf.common.status.UFStatus;
import com.raytheon.uf.common.status.UFStatus.Priority;
import com.raytheon.uf.edex.database.DataAccessLayerException;
import com.raytheon.uf.edex.database.plugin.PluginDao;
import com.raytheon.uf.edex.database.purge.PurgeRuleSet;

/**
 * FFMP specified data access object.
 * 
 * <pre>
 * SOFTWARE HISTORY
 * Date         Ticket#     Engineer    Description
 * ------------ ----------  ----------- --------------------------
 * 07/01/09     2521        dhladky    Initial Creation
 * Jul 15, 2013 2184        dhladky     Remove all HUC's for storage except ALL
 * Oct 1,  2015 4756        dhladky    Custom purging for FFMP.
 * 
 * </pre>
 * 
 * @author dhladky
 * @version 1.0
 */
public class FFMPDao extends PluginDao {
    private static final transient IUFStatusHandler statusHandler = UFStatus
            .getHandler(FFMPDao.class);

    FFMPTemplates template = null;

    FFMPSourceConfigurationManager fscm = null;

    FFMPRunConfigurationManager frcm = null;

    String primaryCWA = null;

    public FFMPDao(String pluginName) throws PluginException {
        super(pluginName);
    }

    public FFMPDao(String pluginName, FFMPTemplates template,
            FFMPSourceConfigurationManager fscm, String primaryCWA)
            throws PluginException {
        super(pluginName);
        this.template = template;
        this.fscm = fscm;
        this.primaryCWA = primaryCWA;
    }

    @Override
    protected IDataStore populateDataStore(IDataStore dataStore,
            IPersistable obj) throws Exception {

        FFMPRecord record = (FFMPRecord) obj;

        if (fscm.getSource(record.getSourceName())
                .getSourceType()
                .equals(FFMPSourceConfigurationManager.SOURCE_TYPE.GAGE
                        .getSourceType())) {

            for (DomainXML domain : template.getDomains()) {

                LinkedHashMap<String, FFMPVirtualGageBasinMetaData> vmap = template
                        .getVirtualGageBasins(record.getSiteKey(),
                                domain.getCwa());

                // ignore data outside of domain
                if (vmap.size() > 0) {

                    FFMPBasinData fbd = record.getBasinData();
                    int size = 0;

                    for (Entry<String, FFMPVirtualGageBasinMetaData> entry : vmap
                            .entrySet()) {
                        if (entry.getValue() != null) {
                            size++;
                        }
                    }

                    float[] dataRec = new float[size];
                    int i = 0;

                    for (Entry<String, FFMPVirtualGageBasinMetaData> entry : vmap
                            .entrySet()) {
                        if (entry.getValue() != null) {
                            FFMPVirtualGageBasin bd = (FFMPVirtualGageBasin) fbd
                                    .get(entry.getValue().getLookupId());
                            dataRec[i] = bd.getValue();
                            i++;
                        }
                    }

                    // NAME | GROUP | array |Dimension | dimensions
                    IDataRecord rec = new FloatDataRecord(FFMPRecord.ALL,
                            record.getDataURI() + "/" + domain.getCwa(),
                            dataRec, 1, new long[] { size });
                    dataStore.addDataRecord(rec);

                } else {
                    statusHandler.handle(Priority.DEBUG, "No VGB's in domain: "
                            + domain.getCwa());

                }
            }
        }

        else {

            if (record.getBasinData() != null) {

                for (DomainXML domain : template.getDomains()) {

                    LinkedHashMap<Long, ?> map = template.getMap(
                            record.getSiteKey(), domain.getCwa(),
                            FFMPRecord.ALL);
                    FFMPBasinData fbd = record.getBasinData();
                    // ignore data outside domain
                    if (map.size() > 0 && fbd.getBasins().size() > 0) {
                        int size = map.size();

                        float[] dataRec = new float[size];
                        int i = 0;
                        // write individual basins, use template, preserves
                        // ordering
                        for (Long pfaf : map.keySet()) {
                            FFMPBasin bd = fbd.get(pfaf);
                            if (bd != null) {
                                dataRec[i] = bd.getValue();
                                i++;
                            }
                        }
                        // NAME | GROUP | array |Dimension | dimensions
                        if (i > 0) {
                            IDataRecord rec = new FloatDataRecord(
                                    FFMPRecord.ALL, record.getDataURI() + "/"
                                            + domain.getCwa(), dataRec, 1,
                                    new long[] { size });
                            dataStore.addDataRecord(rec);
                        }
                    } else {
                        statusHandler.handle(Priority.DEBUG,
                                "Data outside of domain: " + domain.getCwa());
                    }
                }
            }
        }

        statusHandler.handle(Priority.DEBUG, "writing " + record.toString());
        return dataStore;
    }

    @Override
    // FIXME Need to rewrite this to get the correct set of records I think,
    // won't be URI based.
    public List<IDataRecord[]> getHDF5Data(List<PluginDataObject> objects,
            int tileSet) throws PluginException {
        List<IDataRecord[]> retVal = new ArrayList<IDataRecord[]>();

        for (PluginDataObject obj : objects) {
            IDataRecord[] record = null;

            if (obj instanceof IPersistable) {
                /* connect to the data store and retrieve the data */
                try {
                    record = getDataStore((IPersistable) obj).retrieve(
                            obj.getDataURI());
                } catch (Exception e) {
                    throw new PluginException(
                            "Error retrieving FFMP HDF5 data", e);
                }
                retVal.add(record);
            }
        }
        return retVal;
    }

    /**
     * Purge by Guidance Type in FFMP
     */
    protected RuleResult purgeExpiredKey(PurgeRuleSet ruleSet,
            String[] sourceName) throws DataAccessLayerException {

        // We assume the String array only contains 1 sourceName,
        // so we only take sourcName[0] from string array.
        SourceXML source = FFMPSourceConfigurationManager.getInstance()
                .getSource(sourceName[0]);

        if (source != null) {
            if (source.getGuidanceType() != null
                    && source.getGuidanceType().equals(
                            GUIDANCE_TYPE.ARCHIVE.getGuidanceType())) {
                // don't purge ARCHIVE types, return empty sets, 0.
                return new RuleResult(new HashSet<Date>(), new HashSet<Date>(),
                        0);
            } else {
                // All other types follow general FFMP rules for purge. default
                return super.purgeExpiredKey(ruleSet, sourceName);
            }
        } else {
            statusHandler.warn("Encounterd a non-recognized source key: key: "
                    + sourceName +"  Can not be purged!");
            // since it's an unknown source, it can't be purged, so return blank
            return new RuleResult(new HashSet<Date>(), new HashSet<Date>(), 0);
        }
    }

}
