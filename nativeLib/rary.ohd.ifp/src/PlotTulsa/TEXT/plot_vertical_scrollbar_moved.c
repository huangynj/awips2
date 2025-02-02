/* File: plot_vertical_scrollbar_moved.c
 *
 * Moves the scrollbar to the top or bottom of the scroll area in
 * response to a toTop or toBottom scrollbar event.
 *
 * Clears the window and generates an Expose event for each of
 * the plot windows.
 *
 */

#include "plot.h"
#include "ifp_struct.h"

void plot_vertical_scrollbar_moved(w, data, call_data)

  Widget                        w;
  plot_cb_struct                *data;        /* call back graph data structure */
  XmScrollBarCallbackStruct     *call_data;
{
   int  n;                                    /* counter */
   Arg  wargs[5];                             /* window resource data structure array */
/*
 * If a toTop or toBottom scrollbar event, move the scrollbar
 * to the top or bottom of the scroll area
 */
   if(call_data->reason == 7 || call_data->reason == 8)
     {
      n = 0;
      XtSetArg(wargs[n], XmNvalue, call_data->value); n++;
      XtSetValues(w, wargs, n);
     }
/*
 * Clear the window and generate an Expose event for
 *   each of the plot windows.
 * The expose callback will cause the right part of
 *   the pixmaps to be copied into each of the windows.
 */
/*
 *      discharge_axis
 */
  if(XtIsRealized(data->drawing_area_widget[4]))
      XClearArea(XtDisplay(data->drawing_area_widget[4]),
		   XtWindow(data->drawing_area_widget[4]),
		   0, 0, 0, 0, TRUE);
/*
 *      hydrograph
 */
  if(XtIsRealized(data->drawing_area_widget[5]))
      XClearArea(XtDisplay(data->drawing_area_widget[5]),
		   XtWindow(data->drawing_area_widget[5]),
		   0, 0, 0, 0, TRUE);
/*
 *      stage_axis
 */
  if(XtIsRealized(data->drawing_area_widget[6]))
      XClearArea(XtDisplay(data->drawing_area_widget[6]),
		   XtWindow(data->drawing_area_widget[6]),
		   0, 0, 0, 0, TRUE);

/*  ==============  Statements containing RCS keywords:  */
{static char rcs_id1[] = "$Source: /fs/hseb/ob72/rfc/ifp/src/PlotTulsa/RCS/plot_vertical_scrollbar_moved.c,v $";
 static char rcs_id2[] = "$Id: plot_vertical_scrollbar_moved.c,v 1.1 1995/09/08 14:57:43 page Exp $";}
/*  ===================================================  */

}

