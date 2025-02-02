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

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;


/**
 * Adjustfactor generated by hbm2java
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
@Table(name = "adjustfactor")
@com.raytheon.uf.common.serialization.annotations.DynamicSerialize
public class Adjustfactor extends com.raytheon.uf.common.dataplugin.persist.PersistableDataObject implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private AdjustfactorId id;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Shefpe shefpe;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Shefts shefts;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Shefex shefex;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Shefdur shefdur;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Double divisor;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Double base;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Double multiplier;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Double adder;

    public Adjustfactor() {
    }

    public Adjustfactor(AdjustfactorId id, Shefpe shefpe, Shefts shefts,
            Shefex shefex, Shefdur shefdur) {
        this.id = id;
        this.shefpe = shefpe;
        this.shefts = shefts;
        this.shefex = shefex;
        this.shefdur = shefdur;
    }

    public Adjustfactor(AdjustfactorId id, Shefpe shefpe, Shefts shefts,
            Shefex shefex, Shefdur shefdur, Double divisor, Double base,
            Double multiplier, Double adder) {
        this.id = id;
        this.shefpe = shefpe;
        this.shefts = shefts;
        this.shefex = shefex;
        this.shefdur = shefdur;
        this.divisor = divisor;
        this.base = base;
        this.multiplier = multiplier;
        this.adder = adder;
    }

    @EmbeddedId
    @AttributeOverrides( {
            @AttributeOverride(name = "lid", column = @Column(name = "lid", nullable = false, length = 8)),
            @AttributeOverride(name = "pe", column = @Column(name = "pe", nullable = false, length = 2)),
            @AttributeOverride(name = "dur", column = @Column(name = "dur", nullable = false)),
            @AttributeOverride(name = "ts", column = @Column(name = "ts", nullable = false, length = 2)),
            @AttributeOverride(name = "extremum", column = @Column(name = "extremum", nullable = false, length = 1)) })
    public AdjustfactorId getId() {
        return this.id;
    }

    public void setId(AdjustfactorId id) {
        this.id = id;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "pe", nullable = false, insertable = false, updatable = false)
    public Shefpe getShefpe() {
        return this.shefpe;
    }

    public void setShefpe(Shefpe shefpe) {
        this.shefpe = shefpe;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "ts", nullable = false, insertable = false, updatable = false)
    public Shefts getShefts() {
        return this.shefts;
    }

    public void setShefts(Shefts shefts) {
        this.shefts = shefts;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "extremum", nullable = false, insertable = false, updatable = false)
    public Shefex getShefex() {
        return this.shefex;
    }

    public void setShefex(Shefex shefex) {
        this.shefex = shefex;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "dur", nullable = false, insertable = false, updatable = false)
    public Shefdur getShefdur() {
        return this.shefdur;
    }

    public void setShefdur(Shefdur shefdur) {
        this.shefdur = shefdur;
    }

    @Column(name = "divisor", precision = 17, scale = 17)
    public Double getDivisor() {
        return this.divisor;
    }

    public void setDivisor(Double divisor) {
        this.divisor = divisor;
    }

    @Column(name = "base", precision = 17, scale = 17)
    public Double getBase() {
        return this.base;
    }

    public void setBase(Double base) {
        this.base = base;
    }

    @Column(name = "multiplier", precision = 17, scale = 17)
    public Double getMultiplier() {
        return this.multiplier;
    }

    public void setMultiplier(Double multiplier) {
        this.multiplier = multiplier;
    }

    @Column(name = "adder", precision = 17, scale = 17)
    public Double getAdder() {
        return this.adder;
    }

    public void setAdder(Double adder) {
        this.adder = adder;
    }

}
