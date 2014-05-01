//------------------------------------------------------------------------------
// Reach :: initialize - initializes data members.
//------------------------------------------------------------------------------
// Copyright:	See the COPYRIGHT file.
//------------------------------------------------------------------------------
// Notes:
//
//------------------------------------------------------------------------------
// History:
// 
// 14 Jan 1998	Daniel Weiler, Riverside Technology, inc
//					Created initial version.
//------------------------------------------------------------------------------
// Variables:	I/O	Description		
//
//
//------------------------------------------------------------------------------
#include "Reach.h"

int Reach :: initialize()
{
	strcpy( _type, "REACH" );

	_outflow = MISSING;
	return(STATUS_SUCCESS);

/*  ==============  Statements containing RCS keywords:  */
/*  ===================================================  */


/*  ==============  Statements containing RCS keywords:  */
{static char rcs_id1[] = "$Source: /fs/hseb/ob81/ohd/ofs/src/resj_topology/RCS/Reach_initialize.cxx,v $";
 static char rcs_id2[] = "$Id: Reach_initialize.cxx,v 1.2 2006/10/26 15:30:26 hsu Exp $";}
/*  ===================================================  */

}
