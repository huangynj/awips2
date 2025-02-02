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
package com.raytheon.edex.plugin.satellite.dao;

import java.awt.Rectangle;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.geotools.coverage.grid.GridGeometry2D;

import com.raytheon.uf.common.dataplugin.PluginDataObject;
import com.raytheon.uf.common.dataplugin.PluginException;
import com.raytheon.uf.common.dataplugin.persist.IPersistable;
import com.raytheon.uf.common.dataplugin.satellite.SatMapCoverage;
import com.raytheon.uf.common.dataplugin.satellite.SatelliteRecord;
import com.raytheon.uf.common.datastorage.DataStoreFactory;
import com.raytheon.uf.common.datastorage.IDataStore;
import com.raytheon.uf.common.datastorage.StorageException;
import com.raytheon.uf.common.datastorage.StorageProperties;
import com.raytheon.uf.common.datastorage.records.IDataRecord;
import com.raytheon.uf.common.geospatial.interpolation.GridDownscaler;
import com.raytheon.uf.common.numeric.buffer.BufferWrapper;
import com.raytheon.uf.common.numeric.dest.DataDestination;
import com.raytheon.uf.common.time.TimeRange;
import com.raytheon.uf.edex.core.dataplugin.PluginRegistry;
import com.raytheon.uf.edex.database.DataAccessLayerException;
import com.raytheon.uf.edex.database.plugin.DownscaleStoreUtil;
import com.raytheon.uf.edex.database.plugin.DownscaleStoreUtil.IDataRecordCreator;
import com.raytheon.uf.edex.database.plugin.PluginDao;
import com.raytheon.uf.edex.database.query.DatabaseQuery;

/**
 * Data access object used for retrieving satellite data
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * 
 * Date          Ticket#  Engineer    Description
 * ------------- -------- ----------- --------------------------
 * Feb 11, 2009           bphillip    Initial creation
 * Jul 09, 2012  798      jkorman     Modified datastore population.
 * Mar 25, 2013  1823     dgilling    Modified getSatelliteData() and 
 *                                    getSatelliteInventory() to allow optional
 *                                    input arguments.
 * Jun 24, 2013  2044     randerso    Added methods to get data by TimeRange and 
 *                                    getInventory with maxRecord limit
 * Nov 14, 2013  2393     bclement    moved interpolation code to parent class
 * Mar 07, 2014  2791     bsteffen    Move Data Source/Destination to numeric
 *                                    plugin.
 * Nov 04, 2014  2714     bclement    removed GINI specific DAOs
 * Apr 15, 2014  4388     bsteffen    Preserve fill value across interpolation levels.
 * Jul 07, 2015  4279     rferrel     Override delete to clean up orphan entries in satellite_spatial table.
 * Aug 11, 2015  4673     rjpeter     Remove use of executeNativeSql.
 * Sep 17, 2015  4279     rferrel     Do not purge the newest satellite_spatial entries.
 * Apr 29, 2016  ----     mjames      Force 1 interpolationLevels for NEXRCOMP products
 *                                    since def. (5) is pixeled and load time is similar.
 * 
 * </pre>
 * 
 * @author bphillip
 * @version 1.0
 */
public class SatelliteDao extends PluginDao {

    /**
     * Creates a new satellite data access object
     * 
     * @param pluginName
     *            The plugin name. Should be "satellite"
     * @throws PluginException
     *             If a data access object cannot be created
     */
    public SatelliteDao(String pluginName) throws PluginException {
        super(pluginName);
    }

    /**
     * Populated a given IDataStore object with the data record to be persisted.
     * 
     * @param dataStore
     *            Storage object to be populated.
     * @param record
     *            The persistable record containing the data to be persisted.
     * @return The populated data storage object.
     */
    @Override
    protected IDataStore populateDataStore(IDataStore dataStore,
            IPersistable record) throws StorageException {
        final SatelliteRecord satRecord = (SatelliteRecord) record;

        IDataRecord storageRecord = (IDataRecord) satRecord.getMessageData();
        if (storageRecord != null) {
            final StorageProperties props = new StorageProperties();
            String compression = PluginRegistry.getInstance()
                    .getRegisteredObject(pluginName).getCompression();
            if (compression != null) {
                props.setCompression(StorageProperties.Compression
                        .valueOf(compression));
            }
            storageRecord.setProperties(props);
            storageRecord.setCorrelationObject(satRecord);
            final Map<String, Object> attributes = storageRecord
                    .getDataAttributes();
            if (storageRecord.getFillValue() == null) {
                Number fillValue = getAttribute(attributes,
                        SatelliteRecord.SAT_FILL_VALUE, 0.0f);
                storageRecord.setFillValue(fillValue);
            }
            final Number fillValue = storageRecord.getFillValue();

            // Store the base record.
            dataStore.addDataRecord(storageRecord);

            SatMapCoverage coverage = satRecord.getCoverage();

            GridDownscaler downScaler = new GridDownscaler(
                    coverage.getGridGeometry());

            Rectangle fullScale = downScaler.getDownscaleSize(0);
            BufferWrapper dataSource = BufferWrapper.wrapArray(
                    storageRecord.getDataObject(), fullScale.width,
                    fullScale.height);

            int levels = DownscaleStoreUtil.storeInterpolated(dataStore,
                    downScaler, dataSource, new IDataRecordCreator() {

                        @Override
                        public IDataRecord create(Object data,
                                int downScaleLevel, Rectangle size)
                                throws StorageException {
                            IDataRecord dr = createDataRecord(satRecord, data,
                                    downScaleLevel, size);
                            // Set the attributes and properties from the parent
                            // data.
                            dr.setDataAttributes(attributes);
                            dr.setProperties(props);
                            dr.setFillValue(fillValue);
                            return dr;
                        }

                        @Override
                        public double getFillValue() {
                            // always the same fill value
                            return fillValue.doubleValue();
                        }

                        @Override
                        public boolean isSigned() {
                            return false;
                        }

                    });
            
            // If these are 1-4km UCAR NEXRCOMP composites, show full res (no tiling)
            if (satRecord.getSectorID().equals("NEXRCOMP")){
            	satRecord.setInterpolationLevels(1);
            } else {
            	satRecord.setInterpolationLevels(levels);
            }

        }
        return dataStore;
    }

    /**
     * Retrieves fully populated SatelliteRecords using the provided criteria
     * 
     * @param source
     *            The source of the satellite data
     * @param creatingEntity
     *            The creating entity of the satellite data
     * @param sectorID
     *            The sector ID of the satellite data
     * @param physicalElement
     *            The physical element of the satellite data
     * @param dates
     *            The dates to retrieve data for
     * @return A list of SatelliteRecords corresponding to the provided criteria
     * @throws DataAccessLayerException
     *             If errors occur while retrieving the data
     */
    public List<SatelliteRecord> getSatelliteData(String source,
            String creatingEntity, String sectorID, String physicalElement,
            List<Date> dates) throws DataAccessLayerException {

        List<SatelliteRecord> satRecords = new ArrayList<SatelliteRecord>();

        List<Date> inventory = getSatelliteInventory(source, creatingEntity,
                sectorID, physicalElement);

        for (Date theDate : dates) {
            if (!inventory.contains(theDate)) {
                continue;
            }
            DatabaseQuery query = new DatabaseQuery(SatelliteRecord.class);
            if (source != null) {
                query.addQueryParam("source", source);
            }
            if (creatingEntity != null) {
                query.addQueryParam("creatingEntity", creatingEntity);
            }
            if (sectorID != null) {
                query.addQueryParam("sectorID", sectorID);
            }
            if (physicalElement != null) {
                query.addQueryParam("physicalElement", physicalElement);
            }
            query.addQueryParam("dataTime.refTime", theDate);
            query.addOrder("dataTime.refTime", true);
            try {
                PluginDataObject[] pdos = this.getFullRecord(query, 0);
                for (PluginDataObject pdo : pdos) {
                    pdo.setMessageData(((IDataRecord[]) pdo.getMessageData())[0]);
                    satRecords.add((SatelliteRecord) pdo);
                }
            } catch (Exception e) {
                throw new DataAccessLayerException(
                        "Error retrieving satellite data!", e);
            }
        }
        return satRecords;
    }

    /**
     * Retrieves fully populated SatelliteRecords using the provided criteria
     * for GFE
     * 
     * @param sectorID
     *            The sector ID of the satellite data
     * @param physicalElement
     *            The physical element of the satellite data
     * @param timeRanges
     *            The timeRanges to retrieve data for
     * @return A list of SatelliteRecords corresponding to the provided criteria
     * @throws DataAccessLayerException
     *             If errors occur while retrieving the data
     */
    public List<SatelliteRecord> getSatelliteData(String sectorID,
            String physicalElement, List<TimeRange> timeRanges)
            throws DataAccessLayerException {

        List<SatelliteRecord> satRecords = new ArrayList<SatelliteRecord>();

        List<Date> inventory = getSatelliteInventory(null, null, sectorID,
                physicalElement);

        List<Date> dates = new ArrayList<Date>(timeRanges.size());
        for (TimeRange tr : timeRanges) {
            for (Date inv : inventory) {
                if (tr.contains(inv)) {
                    dates.add(inv);
                    break;
                }
            }
        }

        for (Date theDate : dates) {
            DatabaseQuery query = new DatabaseQuery(SatelliteRecord.class);
            if (sectorID != null) {
                query.addQueryParam("sectorID", sectorID);
            }
            if (physicalElement != null) {
                query.addQueryParam("physicalElement", physicalElement);
            }
            query.addQueryParam("dataTime.refTime", theDate);
            query.addOrder("dataTime.refTime", true);
            try {
                PluginDataObject[] pdos = this.getFullRecord(query, 0);
                for (PluginDataObject pdo : pdos) {
                    pdo.setMessageData(((IDataRecord[]) pdo.getMessageData())[0]);
                    satRecords.add((SatelliteRecord) pdo);
                }
            } catch (Exception e) {
                throw new DataAccessLayerException(
                        "Error retrieving satellite data!", e);
            }
        }
        return satRecords;
    }

    /**
     * Gets the inventory of satellite data contained in the data repository for
     * the given criteria
     * 
     * @param source
     *            The source of the satellite data
     * @param creatingEntity
     *            The creating entity of the satellite data
     * @param sectorID
     *            The sector ID of the satellite data
     * @param physicalElement
     *            The physical element of the satellite data
     * @return A List of Dates describing the inventory
     * @throws DataAccessLayerException
     *             If errors occur while querying the data repository
     */
    public List<Date> getSatelliteInventory(String source,
            String creatingEntity, String sectorID, String physicalElement)
            throws DataAccessLayerException {
        DatabaseQuery query = new DatabaseQuery(this.daoClass);
        if (source != null) {
            query.addQueryParam("source", source);
        }
        if (creatingEntity != null) {
            query.addQueryParam("creatingEntity", creatingEntity);
        }
        if (sectorID != null) {
            query.addQueryParam("sectorID", sectorID);
        }
        if (physicalElement != null) {
            query.addQueryParam("physicalElement", physicalElement);
        }
        query.addReturnedField("dataTime.refTime");
        query.addOrder("dataTime.refTime", true);

        @SuppressWarnings("unchecked")
        List<Date> times = (List<Date>) this.queryByCriteria(query);
        return times;
    }

    /**
     * Gets the inventory of satellite data contained in the data repository for
     * the given criteria
     * 
     * @param source
     *            The source of the satellite data
     * @param creatingEntity
     *            The creating entity of the satellite data
     * @param sectorID
     *            The sector ID of the satellite data
     * @param physicalElement
     *            The physical element of the satellite data
     * @param maxRecords
     *            max number of records to retrieve, -1 for all
     * @return A List of Dates describing the inventory
     * @throws DataAccessLayerException
     *             If errors occur while querying the data repository
     */
    public List<Date> getSatelliteInventory(String source,
            String creatingEntity, String sectorID, String physicalElement,
            int maxRecords) throws DataAccessLayerException {
        DatabaseQuery query = new DatabaseQuery(this.daoClass);
        if (source != null) {
            query.addQueryParam("source", source);
        }
        if (creatingEntity != null) {
            query.addQueryParam("creatingEntity", creatingEntity);
        }
        if (sectorID != null) {
            query.addQueryParam("sectorID", sectorID);
        }
        if (physicalElement != null) {
            query.addQueryParam("physicalElement", physicalElement);
        }
        if (maxRecords > 0) {
            query.setMaxResults(maxRecords);
        }
        query.addReturnedField("dataTime.refTime");
        query.addOrder("dataTime.refTime", false);

        @SuppressWarnings("unchecked")
        List<Date> times = (List<Date>) this.queryByCriteria(query);
        return times;
    }

    /**
     * Create the {@link IDataRecord} from the {@link DataDestination} using the
     * original satellite data, size and
     * 
     * @param satRec
     *            The original satellite data record.
     * @param data
     *            The down-scaled data.
     * @param downscaledLevel
     *            The level identifier for this data.
     * @param size
     *            Size of the down-scaled data.
     * @return The created data record to be stored.
     * @throws PluginException
     */
    private IDataRecord createDataRecord(SatelliteRecord satRec, Object data,
            int downscaleLevel, Rectangle size) {
        long[] sizes = new long[] { size.width, size.height };
        IDataRecord rec = DataStoreFactory.createStorageRecord(
                String.valueOf(downscaleLevel), satRec.getDataURI(), data, 2,
                sizes);
        rec.setCorrelationObject(satRec);
        rec.setGroup(DataStoreFactory.createGroupName(satRec.getDataURI(),
                SatelliteRecord.SAT_DATASET_NAME, true));

        return rec;
    }

    /**
     * Get the value of an named attribute.
     * 
     * @param attrs
     *            Attributes that contain the value.
     * @param attrName
     *            Name of the attribute.
     * @param defValue
     *            A default value.
     * @return
     */
    public static Number getAttribute(Map<String, Object> attrs,
            String attrName, Float defValue) {
        Number retValue = defValue;
        if ((attrs != null) && (attrName != null)) {
            retValue = (Number) attrs.get(attrName);
        }
        return retValue;
    }

    @Override
    public void delete(List<PluginDataObject> objs) {
        super.delete(objs);

        /*
         * Delete orphan entries in the satellite_spatial table.
         */
        try {
            /*
             * Keep the newest satellite_spatial entries. May be part of a
             * record not fully committed.
             */
            String sqlCmd = "DELETE FROM satellite_spatial WHERE"
                    + " gid NOT IN (SELECT DISTINCT coverage_gid FROM satellite)"
                    + " AND gid < (SELECT max(gid)-25 FROM satellite_spatial) ;";
            this.executeSQLUpdate(sqlCmd);
        } catch (Exception e) {
            logger.error("Error purging orphaned satellite_spatial entries", e);
        }
    }
}
