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
package com.raytheon.viz.gfe.smarttool;

import com.raytheon.uf.common.dataplugin.gfe.python.GfePyIncludeUtil;
import com.raytheon.viz.gfe.core.script.AbstractScriptUtil;

/**
 * An implementation of PythonFileTemplate for making new Utilities.
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * 
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * May 03, 2011            dgilling    Initial creation
 * Jan 19, 2016  4834      njensen     Removed dead method
 * 
 * </pre>
 * 
 * @author dgilling
 * @version 1.0
 */

public class UtilitiesScriptUtil extends AbstractScriptUtil {

    private static final String TEMPLATE_FILENAME = "utility.vm";

    private static final String SCRIPT_TYPE = "Utility";

    /**
     * Constructor.
     */
    public UtilitiesScriptUtil() {
        super();
    }

    @Override
    public String getScriptType() {
        return SCRIPT_TYPE;
    }

    @Override
    public String getScriptTypePathPrefix() {
        return GfePyIncludeUtil.UTILITIES;
    }

    @Override
    protected String getVelocityTemplateName() {
        return TEMPLATE_FILENAME;
    }

}
