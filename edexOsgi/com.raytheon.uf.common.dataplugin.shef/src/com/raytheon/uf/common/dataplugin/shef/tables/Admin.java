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

// Generated Oct 17, 2008 2:22:17 PM by Hibernate Tools 3.2.2.GA

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * Admin generated by hbm2java
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
 * May 16, 2016       5483     bkowal  Added {@link #HSA_LENGTH}.
 * 
 * </pre>
 * 
 * @author jkorman
 * @version 1.1
 */
@Entity
@Table(name = "admin")
@com.raytheon.uf.common.serialization.annotations.DynamicSerialize
public class Admin extends
        com.raytheon.uf.common.dataplugin.persist.PersistableDataObject
        implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    public static final int HSA_LENGTH = 5;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String hsa;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String focalpoint;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String ofc;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String phone;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String region;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String regno;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String cd404;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Date tenyr;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Date oneyr;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Short hsaNum;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String hbPassword;

    public Admin() {
    }

    public Admin(String hsa) {
        this.hsa = hsa;
    }

    public Admin(String hsa, String focalpoint, String ofc, String phone,
            String region, String regno, String cd404, Date tenyr, Date oneyr,
            Short hsaNum, String hbPassword) {
        this.hsa = hsa;
        this.focalpoint = focalpoint;
        this.ofc = ofc;
        this.phone = phone;
        this.region = region;
        this.regno = regno;
        this.cd404 = cd404;
        this.tenyr = tenyr;
        this.oneyr = oneyr;
        this.hsaNum = hsaNum;
        this.hbPassword = hbPassword;
    }

    @Id
    @Column(name = "hsa", unique = true, nullable = false, length = Admin.HSA_LENGTH)
    public String getHsa() {
        return this.hsa;
    }

    public void setHsa(String hsa) {
        this.hsa = hsa;
    }

    @Column(name = "focalpoint", length = 24)
    public String getFocalpoint() {
        return this.focalpoint;
    }

    public void setFocalpoint(String focalpoint) {
        this.focalpoint = focalpoint;
    }

    @Column(name = "ofc", length = 20)
    public String getOfc() {
        return this.ofc;
    }

    public void setOfc(String ofc) {
        this.ofc = ofc;
    }

    @Column(name = "phone", length = 12)
    public String getPhone() {
        return this.phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    @Column(name = "region", length = 20)
    public String getRegion() {
        return this.region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    @Column(name = "regno", length = 1)
    public String getRegno() {
        return this.regno;
    }

    public void setRegno(String regno) {
        this.regno = regno;
    }

    @Column(name = "cd404", length = 8)
    public String getCd404() {
        return this.cd404;
    }

    public void setCd404(String cd404) {
        this.cd404 = cd404;
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "tenyr", length = 13)
    public Date getTenyr() {
        return this.tenyr;
    }

    public void setTenyr(Date tenyr) {
        this.tenyr = tenyr;
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "oneyr", length = 13)
    public Date getOneyr() {
        return this.oneyr;
    }

    public void setOneyr(Date oneyr) {
        this.oneyr = oneyr;
    }

    @Column(name = "hsa_num")
    public Short getHsaNum() {
        return this.hsaNum;
    }

    public void setHsaNum(Short hsaNum) {
        this.hsaNum = hsaNum;
    }

    @Column(name = "hb_password", length = 8)
    public String getHbPassword() {
        return this.hbPassword;
    }

    public void setHbPassword(String hbPassword) {
        this.hbPassword = hbPassword;
    }

}
