/*
 * Copyright (c) 1999-2000 Image Power, Inc. and the University of
 *   British Columbia.
 * Copyright (c) 2001-2002 Michael David Adams.
 * All rights reserved.
 */

/* __START_OF_JASPER_LICENSE__
 * 
 * JasPer Software License
 * 
 * IMAGE POWER JPEG-2000 PUBLIC LICENSE
 * ************************************
 * 
 * GRANT:
 * 
 * Permission is hereby granted, free of charge, to any person (the "User")
 * obtaining a copy of this software and associated documentation, to deal
 * in the JasPer Software without restriction, including without limitation
 * the right to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the JasPer Software (in source and binary forms),
 * and to permit persons to whom the JasPer Software is furnished to do so,
 * provided further that the License Conditions below are met.
 * 
 * License Conditions
 * ******************
 * 
 * A.  Redistributions of source code must retain the above copyright notice,
 * and this list of conditions, and the following disclaimer.
 * 
 * B.  Redistributions in binary form must reproduce the above copyright
 * notice, and this list of conditions, and the following disclaimer in
 * the documentation and/or other materials provided with the distribution.
 * 
 * C.  Neither the name of Image Power, Inc. nor any other contributor
 * (including, but not limited to, the University of British Columbia and
 * Michael David Adams) may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 * 
 * D.  User agrees that it shall not commence any action against Image Power,
 * Inc., the University of British Columbia, Michael David Adams, or any
 * other contributors (collectively "Licensors") for infringement of any
 * intellectual property rights ("IPR") held by the User in respect of any
 * technology that User owns or has a right to license or sublicense and
 * which is an element required in order to claim compliance with ISO/IEC
 * 15444-1 (i.e., JPEG-2000 Part 1).  "IPR" means all intellectual property
 * rights worldwide arising under statutory or common law, and whether
 * or not perfected, including, without limitation, all (i) patents and
 * patent applications owned or licensable by User; (ii) rights associated
 * with works of authorship including copyrights, copyright applications,
 * copyright registrations, mask work rights, mask work applications,
 * mask work registrations; (iii) rights relating to the protection of
 * trade secrets and confidential information; (iv) any right analogous
 * to those set forth in subsections (i), (ii), or (iii) and any other
 * proprietary rights relating to intangible property (other than trademark,
 * trade dress, or service mark rights); and (v) divisions, continuations,
 * renewals, reissues and extensions of the foregoing (as and to the extent
 * applicable) now existing, hereafter filed, issued or acquired.
 * 
 * E.  If User commences an infringement action against any Licensor(s) then
 * such Licensor(s) shall have the right to terminate User's license and
 * all sublicenses that have been granted hereunder by User to other parties.
 * 
 * F.  The JPEG-2000 codec implementation included in the JasPer software
 * is for use only in hardware or software products that are compliant
 * with ISO/IEC 15444-1 (i.e., JPEG-2000 Part 1).  No license or right to
 * this codec implementation is granted for products that do not comply
 * with ISO/IEC 15444-1.
 * 
 * THIS DISCLAIMER OF WARRANTY CONSTITUTES AN ESSENTIAL PART OF THIS LICENSE.
 * NO USE OF THE JASPER SOFTWARE IS AUTHORIZED HEREUNDER EXCEPT UNDER
 * THIS DISCLAIMER.  THE JASPER SOFTWARE IS PROVIDED BY THE LICENSORS AND
 * CONTRIBUTORS UNDER THIS LICENSE ON AN ``AS-IS'' BASIS, WITHOUT WARRANTY
 * OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, WITHOUT LIMITATION,
 * WARRANTIES THAT THE JASPER SOFTWARE IS FREE OF DEFECTS, IS MERCHANTABLE,
 * IS FIT FOR A PARTICULAR PURPOSE OR IS NON-INFRINGING.  THOSE INTENDING
 * TO USE THE JASPER SOFTWARE OR MODIFICATIONS THEREOF FOR USE IN HARDWARE
 * OR SOFTWARE PRODUCTS ARE ADVISED THAT THEIR USE MAY INFRINGE EXISTING
 * PATENTS, COPYRIGHTS, TRADEMARKS, OR OTHER INTELLECTUAL PROPERTY RIGHTS.
 * THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE JASPER SOFTWARE
 * IS WITH THE USER.  SHOULD ANY PART OF THE JASPER SOFTWARE PROVE DEFECTIVE
 * IN ANY RESPECT, THE USER (AND NOT THE INITIAL DEVELOPERS, THE UNIVERSITY
 * OF BRITISH COLUMBIA, IMAGE POWER, INC., MICHAEL DAVID ADAMS, OR ANY
 * OTHER CONTRIBUTOR) SHALL ASSUME THE COST OF ANY NECESSARY SERVICING,
 * REPAIR OR CORRECTION.  UNDER NO CIRCUMSTANCES AND UNDER NO LEGAL THEORY,
 * WHETHER TORT (INCLUDING NEGLIGENCE), CONTRACT, OR OTHERWISE, SHALL THE
 * INITIAL DEVELOPER, THE UNIVERSITY OF BRITISH COLUMBIA, IMAGE POWER, INC.,
 * MICHAEL DAVID ADAMS, ANY OTHER CONTRIBUTOR, OR ANY DISTRIBUTOR OF THE
 * JASPER SOFTWARE, OR ANY SUPPLIER OF ANY OF SUCH PARTIES, BE LIABLE TO
 * THE USER OR ANY OTHER PERSON FOR ANY INDIRECT, SPECIAL, INCIDENTAL, OR
 * CONSEQUENTIAL DAMAGES OF ANY CHARACTER INCLUDING, WITHOUT LIMITATION,
 * DAMAGES FOR LOSS OF GOODWILL, WORK STOPPAGE, COMPUTER FAILURE OR
 * MALFUNCTION, OR ANY AND ALL OTHER COMMERCIAL DAMAGES OR LOSSES, EVEN IF
 * SUCH PARTY HAD BEEN INFORMED, OR OUGHT TO HAVE KNOWN, OF THE POSSIBILITY
 * OF SUCH DAMAGES.  THE JASPER SOFTWARE AND UNDERLYING TECHNOLOGY ARE NOT
 * FAULT-TOLERANT AND ARE NOT DESIGNED, MANUFACTURED OR INTENDED FOR USE OR
 * RESALE AS ON-LINE CONTROL EQUIPMENT IN HAZARDOUS ENVIRONMENTS REQUIRING
 * FAIL-SAFE PERFORMANCE, SUCH AS IN THE OPERATION OF NUCLEAR FACILITIES,
 * AIRCRAFT NAVIGATION OR COMMUNICATION SYSTEMS, AIR TRAFFIC CONTROL, DIRECT
 * LIFE SUPPORT MACHINES, OR WEAPONS SYSTEMS, IN WHICH THE FAILURE OF THE
 * JASPER SOFTWARE OR UNDERLYING TECHNOLOGY OR PRODUCT COULD LEAD DIRECTLY
 * TO DEATH, PERSONAL INJURY, OR SEVERE PHYSICAL OR ENVIRONMENTAL DAMAGE
 * ("HIGH RISK ACTIVITIES").  LICENSOR SPECIFICALLY DISCLAIMS ANY EXPRESS
 * OR IMPLIED WARRANTY OF FITNESS FOR HIGH RISK ACTIVITIES.
 * 
 * 
 * __END_OF_JASPER_LICENSE__
 */

/*
 * MQ Arithmetic Encoder
 *
 * $Id$
 */

#ifndef JPC_MQENC_H
#define JPC_MQENC_H

/******************************************************************************\
* Includes.
\******************************************************************************/

#include "jasper_inc/jas_types.h"
#include "jasper_inc/jas_stream.h"

#include "jpc_inc/jpc_mqcod.h"

/******************************************************************************\
* Constants.
\******************************************************************************/

/*
 * Termination modes.
 */

#define	JPC_MQENC_DEFTERM	0	/* default termination */
#define	JPC_MQENC_PTERM		1	/* predictable termination */

/******************************************************************************\
* Types.
\******************************************************************************/

/* MQ arithmetic encoder class. */

typedef struct {

	/* The C register. */
	uint_fast32_t creg;

	/* The A register. */
	uint_fast32_t areg;

	/* The CT register. */
	uint_fast32_t ctreg;

	/* The maximum number of contexts. */
	int maxctxs;

	/* The per-context information. */
	jpc_mqstate_t **ctxs;

	/* The current context. */
	jpc_mqstate_t **curctx;

	/* The stream for encoder output. */
	jas_stream_t *out;

	/* The byte buffer (i.e., the B variable in the standard). */
	int_fast16_t outbuf;

	/* The last byte output. */
	int_fast16_t lastbyte;

	/* The error indicator. */
	int err;
	
} jpc_mqenc_t;

/* MQ arithmetic encoder state information. */

typedef struct {

	/* The A register. */
	unsigned areg;

	/* The C register. */
	unsigned creg;

	/* The CT register. */
	unsigned ctreg;

	/* The last byte output by the encoder. */
	int lastbyte;

} jpc_mqencstate_t;

/******************************************************************************\
* Functions/macros for construction and destruction.
\******************************************************************************/

/* Create a MQ encoder. */
jpc_mqenc_t *jpc_mqenc_create(int maxctxs, jas_stream_t *out);

/* Destroy a MQ encoder. */
void jpc_mqenc_destroy(jpc_mqenc_t *enc);

/******************************************************************************\
* Functions/macros for initialization.
\******************************************************************************/

/* Initialize a MQ encoder. */
void jpc_mqenc_init(jpc_mqenc_t *enc);

/******************************************************************************\
* Functions/macros for context manipulation.
\******************************************************************************/

/* Set the current context. */
#define	jpc_mqenc_setcurctx(enc, ctxno) \
        ((enc)->curctx = &(enc)->ctxs[ctxno]);

/* Set the state information for a particular context. */
void jpc_mqenc_setctx(jpc_mqenc_t *enc, int ctxno, jpc_mqctx_t *ctx);

/* Set the state information for multiple contexts. */
void jpc_mqenc_setctxs(jpc_mqenc_t *enc, int numctxs, jpc_mqctx_t *ctxs);

/******************************************************************************\
* Miscellaneous functions/macros.
\******************************************************************************/

/* Get the error state of a MQ encoder. */
#define	jpc_mqenc_error(enc) \
	((enc)->err)

/* Get the current encoder state. */
void jpc_mqenc_getstate(jpc_mqenc_t *enc, jpc_mqencstate_t *state);

/* Terminate the code. */
int jpc_mqenc_flush(jpc_mqenc_t *enc, int termmode);

/******************************************************************************\
* Functions/macros for encoding bits.
\******************************************************************************/

/* Encode a bit. */
#if !defined(DEBUG)
#define	jpc_mqenc_putbit(enc, bit)	jpc_mqenc_putbit_macro(enc, bit)
#else
#define	jpc_mqenc_putbit(enc, bit)	jpc_mqenc_putbit_func(enc, bit)
#endif

/******************************************************************************\
* Functions/macros for debugging.
\******************************************************************************/

int jpc_mqenc_dump(jpc_mqenc_t *mqenc, FILE *out);

/******************************************************************************\
* Implementation-specific details.
\******************************************************************************/

/* Note: This macro is included only to satisfy the needs of
  the mqenc_putbit macro. */
#define	jpc_mqenc_putbit_macro(enc, bit) \
	(((*((enc)->curctx))->mps == (bit)) ? \
	  (((enc)->areg -= (*(enc)->curctx)->qeval), \
	  ((!((enc)->areg & 0x8000)) ? (jpc_mqenc_codemps2(enc)) : \
	  ((enc)->creg += (*(enc)->curctx)->qeval))) : \
	  jpc_mqenc_codelps(enc))

/* Note: These function prototypes are included only to satisfy the
  needs of the mqenc_putbit_macro macro.  Do not call any of these
  functions directly. */
int jpc_mqenc_codemps2(jpc_mqenc_t *enc);
int jpc_mqenc_codelps(jpc_mqenc_t *enc);

/* Note: This function prototype is included only to satisfy the needs of
  the mqenc_putbit macro. */
int jpc_mqenc_putbit_func(jpc_mqenc_t *enc, int bit);

#endif
