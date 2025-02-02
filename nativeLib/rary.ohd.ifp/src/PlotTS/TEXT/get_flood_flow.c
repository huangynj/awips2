/* File: get_flood_flow.c
 *
 * Gets flood flow data.
 *
 * modified from get_warning_flow.c
 *
 * Obtains stage data and converts it to metric and
 * calculates the discharge rate .
 */

#include "plot.h"
#include "ifp_struct.h"
#include "libXifp.h"
#include "mod_struct.h"
#define  ChooseTStypestruct
#include "mods_info.h" 
#include "libXs.h"
#include "ifp_globals.h"

float         stage_to_q();     /* converts stage data to discharge data */

void get_flood_flow(rc_data)
   rc_struct *rc_data;
{
   float     discharge;      /* river discharge rate */
   float     stage_metric;   /* river stage metric data */


   if(rc_data->RC == TRUE)
   {
		if (rc_data->flood_flow > 0.0)
			;
		else if(rc_data->flood_stg > 0.0)
		{
			if(NWSRFS_general_units == 0)
			{
	    		/* convert stage from English to metric then calculate
	    		   discharge (metric) and convert back to English
	    		*/
	    		stage_metric = (rc_data->flood_stg
			    		- rc_data->stg_add_constant)
			    		/ rc_data->stg_mult_conver_factor;
	    		discharge = stage_to_q(stage_metric);
	    		discharge = discharge * rc_data->q_mult_conver_factor +
					rc_data->q_add_constant;
			 }
			 else /* already in metric */
	    		discharge = stage_to_q(rc_data->flood_stg);

			 rc_data->flood_flow = discharge;
		}
   }

/*  ==============  Statements containing RCS keywords:  */
{static char rcs_id1[] = "$Source: /fs/hseb/ob72/rfc/ifp/src/PlotTS/RCS/get_flood_flow.c,v $";
 static char rcs_id2[] = "$Id: get_flood_flow.c,v 1.1 2003/07/10 19:12:07 gzhou Exp $";}
/*  ===================================================  */

}
