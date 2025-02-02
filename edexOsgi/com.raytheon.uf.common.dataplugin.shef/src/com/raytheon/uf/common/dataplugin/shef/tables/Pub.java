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
 * Pub generated by hbm2java
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
@Table(name = "pub")
@com.raytheon.uf.common.serialization.annotations.DynamicSerialize
public class Pub extends com.raytheon.uf.common.dataplugin.persist.PersistableDataObject implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private PubId id;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Riverstat riverstat;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Date pend;

    public Pub() {
    }

    public Pub(PubId id, Riverstat riverstat) {
        this.id = id;
        this.riverstat = riverstat;
    }

    public Pub(PubId id, Riverstat riverstat, Date pend) {
        this.id = id;
        this.riverstat = riverstat;
        this.pend = pend;
    }

    @EmbeddedId
    @AttributeOverrides( {
            @AttributeOverride(name = "lid", column = @Column(name = "lid", nullable = false, length = 8)),
            @AttributeOverride(name = "pbegin", column = @Column(name = "pbegin", nullable = false, length = 13)),
            @AttributeOverride(name = "ppub", column = @Column(name = "ppub", nullable = false, length = 25)) })
    public PubId getId() {
        return this.id;
    }

    public void setId(PubId id) {
        this.id = id;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "lid", nullable = false, insertable = false, updatable = false)
    public Riverstat getRiverstat() {
        return this.riverstat;
    }

    public void setRiverstat(Riverstat riverstat) {
        this.riverstat = riverstat;
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "pend", length = 13)
    public Date getPend() {
        return this.pend;
    }

    public void setPend(Date pend) {
        this.pend = pend;
    }

}
