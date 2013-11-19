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
package com.raytheon.uf.edex.datadelivery.registry.web;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;

import javax.xml.bind.JAXBException;

import org.apache.commons.lang.exception.ExceptionUtils;

import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.raytheon.uf.common.datadelivery.registry.web.IRegistryAvailableRestService;
import com.raytheon.uf.common.datadelivery.registry.web.IRegistryDataAccessService;
import com.raytheon.uf.common.registry.constants.RegistryAvailability;
import com.raytheon.uf.common.registry.services.RegistryRESTServices;
import com.raytheon.uf.common.registry.services.RegistryServiceException;
import com.raytheon.uf.common.status.IUFStatusHandler;
import com.raytheon.uf.common.status.UFStatus;

/**
 * <pre>
 * 
 * Set of Data Delivery specific REST services
 * 
 * SOFTWARE HISTORY
 * 
 * Date         Ticket#     Engineer    Description
 * ------------ ----------  ----------- --------------------------
 * 10/30/2013    1538       bphillip    Initial Creation
 * </pre>
 * 
 * @author bphillip
 * @version 1
 **/
public class DataDeliveryRESTServices extends RegistryRESTServices {

    /** Path to these services */
    private static final String DATA_DELIVERY_REST_SERVICE_PATH = "/dataDelivery";

    /**
     * The logger
     */
    private static final IUFStatusHandler statusHandler = UFStatus
            .getHandler(RegistryRESTServices.class);

    /** Map of known registry availability services */
    private LoadingCache<String, IRegistryAvailableRestService> registryAvailabilityServiceMap = CacheBuilder
            .newBuilder().expireAfterAccess(5, TimeUnit.MINUTES)
            .build(new CacheLoader<String, IRegistryAvailableRestService>() {
                public IRegistryAvailableRestService load(String url) {
                    return getPort(url + DATA_DELIVERY_REST_SERVICE_PATH,
                            IRegistryAvailableRestService.class);
                }
            });

    /** Map of known registry data access services */
    private LoadingCache<String, IRegistryDataAccessService> registryDataAccessServiceMap = CacheBuilder
            .newBuilder().expireAfterAccess(5, TimeUnit.MINUTES)
            .build(new CacheLoader<String, IRegistryDataAccessService>() {
                public IRegistryDataAccessService load(String url) {
                    return getPort(url + DATA_DELIVERY_REST_SERVICE_PATH,
                            IRegistryDataAccessService.class);
                }
            });

    public DataDeliveryRESTServices() throws JAXBException {
        super();
    }

    /**
     * Gets the registry available service implementation
     * 
     * @param baseURL
     *            The base URL of the registry
     * @return THe registry available service implementation
     */
    public IRegistryAvailableRestService getRegistryAvailableService(
            String baseURL) {
        try {
            return registryAvailabilityServiceMap.get(baseURL);
        } catch (ExecutionException e) {
            throw new RegistryServiceException(
                    "Error getting Registry Availability Rest Service", e);
        }
    }

    /**
     * Check if the registry at the given URL is available
     * 
     * @param baseURL
     *            The base URL of the registry
     * @return True if the registry services are available
     */
    public boolean isRegistryAvailable(String baseURL) {
        String response = null;
        try {
            response = getRegistryAvailableService(baseURL)
                    .isRegistryAvailable();
            if (RegistryAvailability.AVAILABLE.equals(response)) {
                return true;
            } else {
                statusHandler.info("Registry at [" + baseURL
                        + "] not available: " + response);
            }
            return RegistryAvailability.AVAILABLE.equals(response);
        } catch (Throwable t) {
            if (response == null) {
                response = ExceptionUtils.getRootCauseMessage(t);
            }
            statusHandler.error("Registry at [" + baseURL + "] not available: "
                    + response);
            return false;
        }
    }

    /**
     * Gets the data access service for the specified registry URL
     * 
     * @param baseURL
     *            The baseURL of the registry
     * @return The data access service for the specified registry URL
     */
    public IRegistryDataAccessService getRegistryDataAccessService(
            String baseURL) {
        try {
            return registryDataAccessServiceMap.get(baseURL);
        } catch (ExecutionException e) {
            throw new RegistryServiceException(
                    "Error getting Registry Availability Rest Service", e);
        }
    }
}