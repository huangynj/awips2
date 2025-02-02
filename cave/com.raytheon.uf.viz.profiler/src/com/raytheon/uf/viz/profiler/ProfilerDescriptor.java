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
package com.raytheon.uf.viz.profiler;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

import com.raytheon.uf.viz.core.PixelExtent;
import com.raytheon.viz.core.graphing.GraphDescriptor;
import com.raytheon.viz.core.slice.request.HeightScale;

/**
 * Handles profiler data
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * Apr 08, 2009  2219        dhladky   Initial creation
 * 
 * </pre>
 * 
 * @author dhladky
 * @version 1.0
 */

@XmlAccessorType(XmlAccessType.NONE)
@XmlType(name = "profilerDescriptor")
public class ProfilerDescriptor extends GraphDescriptor {

    @XmlElement
    private HeightScale heightScale;

    public ProfilerDescriptor() {
        super();
    }

    public ProfilerDescriptor(PixelExtent anExtent) {
        super(anExtent);
    }

    /**
     * @return the heightScale
     */
    public HeightScale getHeightScale() {
        return heightScale;
    }

    /**
     * @param heightScale
     *            the heightScale to set
     */
    public void setHeightScale(HeightScale heightScale) {
        this.heightScale = heightScale;
    }

}
