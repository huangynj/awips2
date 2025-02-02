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
package com.raytheon.uf.common.dataplugin.shef.tables;
// default package
// Generated Oct 17, 2008 2:22:17 PM by Hibernate Tools 3.2.2.GA

import java.util.Date;
import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * Dparadar generated by hbm2java
 * 
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * Oct 17, 2008                        Initial generation by hbm2java
 * Aug 19, 2011      10672     jkorman Move refactor to new project
 * Oct 07, 2013       2361     njensen Removed XML annotations
 * 
 * </pre>
 * 
 * @author jkorman
 * @version 1.1
 */
@Entity
@Table(name = "dparadar")
@com.raytheon.uf.common.serialization.annotations.DynamicSerialize
public class Dparadar extends com.raytheon.uf.common.dataplugin.persist.PersistableDataObject implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private DparadarId id;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Radarloc radarloc;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Short minoff;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Float maxvalh;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Float maxvald;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Float s1BiasValue;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Date producttime;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Short nisolbin;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Short noutint;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Short noutrep;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Float areared;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Float biscanr;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Integer blockBinsReject;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Integer clutterBinsRej;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Integer binsSmoothed;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Float scanBinsFilled;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Float highElevAngle;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Float scanRainArea;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Short nbadscan;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Short nhourout;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Short volcovpat;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Short opermode;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String missper;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Short supplmess;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String gridFilename;

    public Dparadar() {
    }

    public Dparadar(DparadarId id, Radarloc radarloc) {
        this.id = id;
        this.radarloc = radarloc;
    }

    public Dparadar(DparadarId id, Radarloc radarloc, Short minoff,
            Float maxvalh, Float maxvald, Float s1BiasValue, Date producttime,
            Short nisolbin, Short noutint, Short noutrep, Float areared,
            Float biscanr, Integer blockBinsReject, Integer clutterBinsRej,
            Integer binsSmoothed, Float scanBinsFilled, Float highElevAngle,
            Float scanRainArea, Short nbadscan, Short nhourout,
            Short volcovpat, Short opermode, String missper, Short supplmess,
            String gridFilename) {
        this.id = id;
        this.radarloc = radarloc;
        this.minoff = minoff;
        this.maxvalh = maxvalh;
        this.maxvald = maxvald;
        this.s1BiasValue = s1BiasValue;
        this.producttime = producttime;
        this.nisolbin = nisolbin;
        this.noutint = noutint;
        this.noutrep = noutrep;
        this.areared = areared;
        this.biscanr = biscanr;
        this.blockBinsReject = blockBinsReject;
        this.clutterBinsRej = clutterBinsRej;
        this.binsSmoothed = binsSmoothed;
        this.scanBinsFilled = scanBinsFilled;
        this.highElevAngle = highElevAngle;
        this.scanRainArea = scanRainArea;
        this.nbadscan = nbadscan;
        this.nhourout = nhourout;
        this.volcovpat = volcovpat;
        this.opermode = opermode;
        this.missper = missper;
        this.supplmess = supplmess;
        this.gridFilename = gridFilename;
    }

    @EmbeddedId
    @AttributeOverrides( {
            @AttributeOverride(name = "radid", column = @Column(name = "radid", nullable = false, length = 3)),
            @AttributeOverride(name = "obstime", column = @Column(name = "obstime", nullable = false, length = 29)) })
    public DparadarId getId() {
        return this.id;
    }

    public void setId(DparadarId id) {
        this.id = id;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "radid", nullable = false, insertable = false, updatable = false)
    public Radarloc getRadarloc() {
        return this.radarloc;
    }

    public void setRadarloc(Radarloc radarloc) {
        this.radarloc = radarloc;
    }

    @Column(name = "minoff")
    public Short getMinoff() {
        return this.minoff;
    }

    public void setMinoff(Short minoff) {
        this.minoff = minoff;
    }

    @Column(name = "maxvalh", precision = 8, scale = 8)
    public Float getMaxvalh() {
        return this.maxvalh;
    }

    public void setMaxvalh(Float maxvalh) {
        this.maxvalh = maxvalh;
    }

    @Column(name = "maxvald", precision = 8, scale = 8)
    public Float getMaxvald() {
        return this.maxvald;
    }

    public void setMaxvald(Float maxvald) {
        this.maxvald = maxvald;
    }

    @Column(name = "s1_bias_value", precision = 8, scale = 8)
    public Float getS1BiasValue() {
        return this.s1BiasValue;
    }

    public void setS1BiasValue(Float s1BiasValue) {
        this.s1BiasValue = s1BiasValue;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "producttime", length = 29)
    public Date getProducttime() {
        return this.producttime;
    }

    public void setProducttime(Date producttime) {
        this.producttime = producttime;
    }

    @Column(name = "nisolbin")
    public Short getNisolbin() {
        return this.nisolbin;
    }

    public void setNisolbin(Short nisolbin) {
        this.nisolbin = nisolbin;
    }

    @Column(name = "noutint")
    public Short getNoutint() {
        return this.noutint;
    }

    public void setNoutint(Short noutint) {
        this.noutint = noutint;
    }

    @Column(name = "noutrep")
    public Short getNoutrep() {
        return this.noutrep;
    }

    public void setNoutrep(Short noutrep) {
        this.noutrep = noutrep;
    }

    @Column(name = "areared", precision = 8, scale = 8)
    public Float getAreared() {
        return this.areared;
    }

    public void setAreared(Float areared) {
        this.areared = areared;
    }

    @Column(name = "biscanr", precision = 8, scale = 8)
    public Float getBiscanr() {
        return this.biscanr;
    }

    public void setBiscanr(Float biscanr) {
        this.biscanr = biscanr;
    }

    @Column(name = "block_bins_reject")
    public Integer getBlockBinsReject() {
        return this.blockBinsReject;
    }

    public void setBlockBinsReject(Integer blockBinsReject) {
        this.blockBinsReject = blockBinsReject;
    }

    @Column(name = "clutter_bins_rej")
    public Integer getClutterBinsRej() {
        return this.clutterBinsRej;
    }

    public void setClutterBinsRej(Integer clutterBinsRej) {
        this.clutterBinsRej = clutterBinsRej;
    }

    @Column(name = "bins_smoothed")
    public Integer getBinsSmoothed() {
        return this.binsSmoothed;
    }

    public void setBinsSmoothed(Integer binsSmoothed) {
        this.binsSmoothed = binsSmoothed;
    }

    @Column(name = "scan_bins_filled", precision = 8, scale = 8)
    public Float getScanBinsFilled() {
        return this.scanBinsFilled;
    }

    public void setScanBinsFilled(Float scanBinsFilled) {
        this.scanBinsFilled = scanBinsFilled;
    }

    @Column(name = "high_elev_angle", precision = 8, scale = 8)
    public Float getHighElevAngle() {
        return this.highElevAngle;
    }

    public void setHighElevAngle(Float highElevAngle) {
        this.highElevAngle = highElevAngle;
    }

    @Column(name = "scan_rain_area", precision = 8, scale = 8)
    public Float getScanRainArea() {
        return this.scanRainArea;
    }

    public void setScanRainArea(Float scanRainArea) {
        this.scanRainArea = scanRainArea;
    }

    @Column(name = "nbadscan")
    public Short getNbadscan() {
        return this.nbadscan;
    }

    public void setNbadscan(Short nbadscan) {
        this.nbadscan = nbadscan;
    }

    @Column(name = "nhourout")
    public Short getNhourout() {
        return this.nhourout;
    }

    public void setNhourout(Short nhourout) {
        this.nhourout = nhourout;
    }

    @Column(name = "volcovpat")
    public Short getVolcovpat() {
        return this.volcovpat;
    }

    public void setVolcovpat(Short volcovpat) {
        this.volcovpat = volcovpat;
    }

    @Column(name = "opermode")
    public Short getOpermode() {
        return this.opermode;
    }

    public void setOpermode(Short opermode) {
        this.opermode = opermode;
    }

    @Column(name = "missper", length = 1)
    public String getMissper() {
        return this.missper;
    }

    public void setMissper(String missper) {
        this.missper = missper;
    }

    @Column(name = "supplmess")
    public Short getSupplmess() {
        return this.supplmess;
    }

    public void setSupplmess(Short supplmess) {
        this.supplmess = supplmess;
    }

    @Column(name = "grid_filename", length = 20)
    public String getGridFilename() {
        return this.gridFilename;
    }

    public void setGridFilename(String gridFilename) {
        this.gridFilename = gridFilename;
    }

}
