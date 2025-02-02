/* *********************************************************

	plot_write_mods.h

		- include file for Create_mods.c (PlotTulsa)

	Coded by:       Tom Adams
			NWS/Office of Hydrology/HRL
	Date:           03/26/91
	Revisions:      03/27/91
			03/25/93  dp

   ********************************************************* */

#ifndef plot_write_mods_h
#define plot_write_mods_h


#define  MAX_MODS     100
#define  MAX_SEG_TS    50
#define  NUM_DATATYPES 94

void    FindMDH();
int     FindDecimalPlaces();

void    write_Mod_format_A1();
void    write_Mod_format_A2();
void    write_Mod_format_B1();
void    write_Mod_format_B2();
void    write_Mod_format_B3();


typedef struct
	{
	char  datatype[5];
	int   num_dp;
	}   DecPlaces;



/*TS_INFO         ts_info[20];*/
DecPlaces       decimal_places[NUM_DATATYPES];

#endif

