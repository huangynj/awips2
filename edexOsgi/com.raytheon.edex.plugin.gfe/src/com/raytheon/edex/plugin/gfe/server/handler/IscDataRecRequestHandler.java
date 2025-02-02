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
package com.raytheon.edex.plugin.gfe.server.handler;

import com.raytheon.uf.common.dataplugin.gfe.request.IscDataRecRequest;
import com.raytheon.uf.common.dataplugin.gfe.server.message.ServerResponse;
import com.raytheon.uf.common.serialization.SerializationUtil;
import com.raytheon.uf.common.serialization.comm.IRequestHandler;
import com.raytheon.uf.edex.core.EDEXUtil;

/**
 * Thrift request handler for <code>IscDataRecRequest</code>. Takes request and
 * places it on a queue to be executed by <code>IscReceiveSrv</code> .
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * 
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * Oct 26, 2010            dgilling     Initial creation
 * Mar 05, 2012  #361      dgilling     Make call to iscDataRec
 *                                      asynchronous.
 * 
 * </pre>
 * 
 * @author dgilling
 * @version 1.0
 */

public class IscDataRecRequestHandler implements
        IRequestHandler<IscDataRecRequest> {

    /*
     * (non-Javadoc)
     * 
     * @see
     * com.raytheon.uf.common.serialization.comm.IRequestHandler#handleRequest
     * (com.raytheon.uf.common.serialization.comm.IServerRequest)
     */
    @Override
    public ServerResponse<String> handleRequest(IscDataRecRequest request)
            throws Exception {
        ServerResponse<String> sr = new ServerResponse<String>();

        byte[] message = SerializationUtil.transformToThrift(request);
        EDEXUtil.getMessageProducer().sendAsync("iscReceiveRoute", message);
        return sr;
    }

}
