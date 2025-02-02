/*******************************************************************************
* FILENAME:             free_dynamic_memory.c
* NUMBER OF MODULES:    1
* GENERAL INFORMATION:
*    MODULE 1:          free_dynamic_memory
* DESCRIPTION:          This routine frees the dynamic memory allocated by the
*                       Hydromap and Mpe routines.  This is done to make
*                       certain that no memory is leaked by this application.
*
* ORIGINAL AUTHOR:      Bryon Lawrence
* CREATION DATE:        February 27, 2002
* ORGANIZATION:         HSEB / OHD
* MACHINE:              HP-Unix  / Dell Linux
* MODIFICATION HISTORY:
*   MODULE #   DATE               PROGRAMMER        DESCRIPTION/REASON
*          1   February 27, 2002  Bryon Lawrence    Created. 
********************************************************************************
*/
#include <stdlib.h>

#include "create_ss_interface_rfcwide.h"
#include "display_field.h"
#include "display_mean_areal_precip.h"
#include "draw_precip_poly_RFCW.h"
#include "gage_table_RFCW.h"
#include "get_loc_latlon.h"
#include "pointcontrol_mgr.h"
#include "pointcontrol_presets.h"
#include "pointcontrol_riverstatus.h"
#include "pointcontrol_show.h"
#include "PointDataPresets.h"
#include "post_functions.h" 
#include "read_netcdf_ffg.h"
#include "read_precip_data.h"
#include "read_radcov_grids.h"
#include "rating_util.h"
#include "stage3.h"
#include "time_lapse_RFCW.h"
#include "jni_calls.h"


/*******************************************************************************
* MODULE NUMBER: 1
* MODULE NAME:   free_dynamic_memory
* PURPOSE:       This routine frees the dynamic memory allocated for data
*                structures used by the Hydromap and Mpe routines.  This
*                is being done as part of an effort to reduce the number
*                of memory leaks caused by this application.
*
* ARGUMENTS:
*    None
*
* RETURNS:
*    None
*
* APIs UTILIZED:
*   NAME                       HEADER FILE                   DESCRIPTION
*   display_field_free_memory  display_field.h               Frees memory used
*                                                            by the display_field
*                                                            routine in
*                                                            displaying the.
*   free_ffg_grids             read_netcdf_ffg.h             Frees memory used
*                                                            to by the ffg data
*                                                            array and the
*                                                            ffg lat/lon lookup
*                                                            array.
*   free_gage_table_memory     gage_table_RFCW.h             Frees memory used
*                                                            by the river gage
*                                                            table. 
*   freeLatLonGrid             post_functions.h              Frees the memory
*                                                            used to create the
*                                                            Latitude/Longitude
*                                                            conversion array.
*   free_radcov_memory         read_radcov_grids.h           Frees the memory
*                                                            used for the
*                                                            radar coverage 
*                                                            data fields.
*   free_time_lapse_memory     time_lapse_RFCW.h             Frees the memory
*                                                            used to create the
*                                                            time lapse.
*   init_draw_data_free_memory create_ss_interface_rfcwide.h Frees the memory
*                                                            used in displaying
*                                                            each panel in the
*                                                            single site window.
*   read_geo_data_free_memory  post_functions.h              Frees the memory
*                                                            used to 
*                                                            contain the
*                                                            basin and county
*                                                            grid to bin data.
*                   
*
* LOCAL DATA ELEMENTS (OPTIONAL):
*   DATA TYPE          NAME               DESCRIPTION 
*   PointDataPresets   pPointDataPresets  A pointer the head of the linked list
*                                         of pointdata preset information.
*
* DATA FILES AND/OR DATABASE:
*    None
*
* ERROR HANDLING:
*    None
*
********************************************************************************
*/

void free_dynamic_memory ( )
{
   PointDataPresets * pPointDataPresets = NULL ; 

   display_field_free_memory ( ) ;
   free_gage_table_memory ( ) ;
   freeLatLonGrid ( ) ;
   free_radcov_memory ( ) ;
   free_time_lapse_memory ( ) ;
   init_draw_data_free_memory ( ) ;
   read_geo_data_free_memory ( ) ;
   free_ffg_grids ( ) ;
   free_ffg_linesegs ( ) ;
   free_rating_curve ( ) ;
   freePixelGrid ( ) ;
   FreeRiverStatusList ( ) ;
   free_derivedPtrs ( ) ;
   free_loc_latlon_list ( ) ;
   free_mean_areal_precip ( ) ;
   free_poly_temp ( );
  
   if ( gage != NULL )
   {
      free ( gage ) ;
      gage = NULL ;
   }

   /* Added 10/21/2004.  Free any memory used by the point data presets. */
   pPointDataPresets = get_PointDataPresetsHead ( ) ;

   if ( pPointDataPresets != NULL )
   {
      FreePointDataPresets ( pPointDataPresets ) ;
   }

   printf("Before closing JVM\n");
   
   closejvm();
    
   printf("After closing JVM\n");
}
