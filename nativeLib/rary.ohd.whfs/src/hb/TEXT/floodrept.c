/*
** Generated by X-Designer
*/
/*
**LIBS: -lXm -lXt -lX11
*/

#include <stdlib.h>
#include <X11/Xatom.h>
#include <X11/Intrinsic.h>
#include <X11/Shell.h>

#include <Xm/Xm.h>
#include <Xm/DialogS.h>
#include <Xm/DrawingA.h>
#include <Xm/Form.h>
#include <Xm/Frame.h>
#include <Xm/Label.h>
#include <Xm/List.h>
#include <Xm/PushB.h>
#include <Xm/RowColumn.h>
#include <Xm/ScrollBar.h>
#include <Xm/ScrolledW.h>
#include <Xm/Separator.h>
#include <Xm/Text.h>
#include <Xm/TextF.h>
#include <Xm/CascadeBG.h>
#include <Xm/LabelG.h>
#include <Xm/ComboBox.h>


Widget floodreptDS = (Widget) NULL;
Widget floodreptFO = (Widget) NULL;
Widget floodrept_axisDA = (Widget) NULL;
Widget floodrept_lidLA = (Widget) NULL;
Widget floodrept_stageLA = (Widget) NULL;
Widget floodrept_mainSW = (Widget) NULL;
Widget floodrept_mainHSB = (Widget) NULL;
Widget floodrept_mainVSB = (Widget) NULL;
Widget floodrept_mainDA = (Widget) NULL;
Widget floodreptOM = (Widget) NULL;
Widget floodrept_omLA = (Widget) NULL;
Widget floodreptCB = (Widget) NULL;
Widget floodreptPDM = (Widget) NULL;
Widget fr_monPB = (Widget) NULL;
Widget fr_yearPB = (Widget) NULL;
Widget fr_12monPB = (Widget) NULL;
Widget floodrept_omSE = (Widget) NULL;
Widget fr_janPB = (Widget) NULL;
Widget fr_febPB = (Widget) NULL;
Widget fr_marPB = (Widget) NULL;
Widget fr_aprPB = (Widget) NULL;
Widget fr_mayPB = (Widget) NULL;
Widget fr_junPB = (Widget) NULL;
Widget fr_julPB = (Widget) NULL;
Widget fr_augPB = (Widget) NULL;
Widget fr_sepPB = (Widget) NULL;
Widget fr_octPB = (Widget) NULL;
Widget fr_novPB = (Widget) NULL;
Widget fr_decPB = (Widget) NULL;
Widget fr_sep1SE = (Widget) NULL;
Widget floodreptSL = (Widget) NULL;
Widget floodreptHSB = (Widget) NULL;
Widget floodreptVSB = (Widget) NULL;
Widget floodreptLI = (Widget) NULL;
Widget fr_timesFR = (Widget) NULL;
Widget fr_timesLA = (Widget) NULL;
Widget fr_timesFO = (Widget) NULL;
Widget fr_aboveLA = (Widget) NULL;
Widget fr_aboveTE = (Widget) NULL;
Widget fr_crestLA = (Widget) NULL;
Widget fr_crestTE = (Widget) NULL;
Widget fr_belowLA = (Widget) NULL;
Widget fr_belowTE = (Widget) NULL;
Widget fr_insertPB = (Widget) NULL;
Widget fr_stagesSL = (Widget) NULL;
Widget fr_stagesHSB = (Widget) NULL;
Widget fr_stagesVSB = (Widget) NULL;
Widget fr_stagesLI = (Widget) NULL;
Widget fr_sep2SE = (Widget) NULL;
Widget fr_okPB = (Widget) NULL;
Widget fr_refreshPB = (Widget) NULL;
Widget fr_deletePB = (Widget) NULL;
Widget fr_exportPB = (Widget) NULL;
Widget fs_hsaLA = (Widget) NULL;
Widget fr_hsaCBX = (Widget) NULL;
Widget fr_hsaText = (Widget) NULL;
Widget fr_hsaSL = (Widget) NULL;
Widget fr_hsaVSB = (Widget) NULL;
Widget fr_hsaLI = (Widget) NULL;
Widget fr_LocationLA = (Widget) NULL;
Widget fr_crestStageLA = (Widget) NULL;
Widget fr_floodStageLA = (Widget) NULL;
Widget fr_crestTimeLA = (Widget) NULL;



void create_floodreptDS (Widget parent)
{
	Widget children[19];      /* Children to manage */
	Display *display = XtDisplay ( parent );
	Arg al[64];                    /* Arg List */
	register int ac = 0;           /* Arg Count */
	XrmValue from_value, to_value; /* For resource conversion */
	XPointer to_address; /* For Thread-safe resource conversion */ 
	Pixel to_pixel; /* For Thread-safe resource conversion */ 
	XtPointer tmp_value;             /* ditto */
	XmString xmstrings[16];    /* temporary storage for XmStrings */

	XtSetArg(al[ac], XmNwidth, 920); ac++;
	XtSetArg(al[ac], XmNheight, 430); ac++;
	XtSetArg(al[ac], XmNallowShellResize, TRUE); ac++;
	XtSetArg(al[ac], XmNtitle, "Flood Report"); ac++;
	XtSetArg(al[ac], XmNminWidth, 1100); ac++;
	XtSetArg(al[ac], XmNminHeight, 850); ac++;
	XtSetArg(al[ac], XmNmaxWidth, 1100); ac++;
	XtSetArg(al[ac], XmNmaxHeight, 850); ac++;
	XtSetArg(al[ac], XmNdeleteResponse, XmDO_NOTHING); ac++;
	floodreptDS = XmCreateDialogShell ( parent, (char *) "floodreptDS", al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNheight, 870); ac++;
	XtSetArg(al[ac], XmNautoUnmanage, FALSE); ac++;
	floodreptFO = XmCreateForm ( floodreptDS, (char *) "floodreptFO", al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNwidth, 75); ac++;
	XtSetArg(al[ac], XmNheight, 487); ac++;
	if (DefaultDepthOfScreen(DefaultScreenOfDisplay(display)) != 1) {

		from_value.addr = "black" ;
		from_value.size = strlen( from_value.addr ) + 1;
		to_value.size = sizeof(Pixel);
		to_value.addr = (XPointer) &to_pixel;
		XtConvertAndStore (floodreptFO, XmRString, &from_value, XmRPixel, &to_value);

		if ( to_value.addr ) {
			XtSetArg(al[ac], XmNbackground, (*((Pixel*) to_value.addr))); ac++;
		}
	}
	floodrept_axisDA = XmCreateDrawingArea ( floodreptFO, (char *) "floodrept_axisDA", al, ac );
	ac = 0;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Location: ", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	floodrept_lidLA = XmCreateLabel ( floodreptFO, (char *) "floodrept_lidLA", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Stage:                                                                                    ", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_BEGINNING); ac++;
	floodrept_stageLA = XmCreateLabel ( floodreptFO, (char *) "floodrept_stageLA", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNwidth, 545); ac++;
	XtSetArg(al[ac], XmNheight, 517); ac++;
	XtSetArg(al[ac], XmNscrollingPolicy, XmAUTOMATIC); ac++;
	floodrept_mainSW = XmCreateScrolledWindow ( floodreptFO, (char *) "floodrept_mainSW", al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNhorizontalScrollBar, &floodrept_mainHSB); ac++;
	XtSetArg(al[ac], XmNverticalScrollBar, &floodrept_mainVSB); ac++;
	XtGetValues(floodrept_mainSW, al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNmappedWhenManaged, FALSE); ac++;
	if (floodrept_mainVSB)
		XtSetValues ( floodrept_mainVSB, al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNwidth, 545); ac++;
	XtSetArg(al[ac], XmNheight, 496); ac++;
	if (DefaultDepthOfScreen(DefaultScreenOfDisplay(display)) != 1) {

		from_value.addr = "black" ;
		from_value.size = strlen( from_value.addr ) + 1;
		to_value.size = sizeof(Pixel);
		to_value.addr = (XPointer) &to_pixel;
		XtConvertAndStore (floodrept_mainSW, XmRString, &from_value, XmRPixel, &to_value);

		if ( to_value.addr ) {
			XtSetArg(al[ac], XmNbackground, (*((Pixel*) to_value.addr))); ac++;
		}
	}
	floodrept_mainDA = XmCreateDrawingArea ( floodrept_mainSW, (char *) "floodrept_mainDA", al, ac );
	ac = 0;
#if       ((XmVERSION > 1) && (XmREVISION == 1) && (XmUPDATE_LEVEL < 20))
	xmstrings[0] = XmStringGenerate((XtPointer) "Reporting Period", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL);
#else  /* ((XmVERSION > 1) && (XmREVISION == 1) && (XmUPDATE_LEVEL < 20)) */
	xmstrings[0] = XmStringCreateLtoR("Reporting Period", (XmStringCharSet) XmFONTLIST_DEFAULT_TAG);
#endif /* ((XmVERSION > 1) && (XmREVISION == 1) && (XmUPDATE_LEVEL < 20)) */
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	floodreptOM = XmCreateOptionMenu ( floodreptFO, (char *) "floodreptOM", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	floodrept_omLA = XmOptionLabelGadget ( floodreptOM );
	floodreptCB = XmOptionButtonGadget ( floodreptOM );
	floodreptPDM = XmCreatePulldownMenu ( floodreptOM, (char *) "floodreptPDM", al, ac );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Month to Date", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_monPB = XmCreatePushButton ( floodreptPDM, (char *) "fr_monPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Year to Date", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_yearPB = XmCreatePushButton ( floodreptPDM, (char *) "fr_yearPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Last 12 Months", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_12monPB = XmCreatePushButton ( floodreptPDM, (char *) "fr_12monPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	floodrept_omSE = XmCreateSeparator ( floodreptPDM, (char *) "floodrept_omSE", al, ac );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "January", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_janPB = XmCreatePushButton ( floodreptPDM, (char *) "fr_janPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "February", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_febPB = XmCreatePushButton ( floodreptPDM, (char *) "fr_febPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "March", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_marPB = XmCreatePushButton ( floodreptPDM, (char *) "fr_marPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "April", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_aprPB = XmCreatePushButton ( floodreptPDM, (char *) "fr_aprPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "May", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_mayPB = XmCreatePushButton ( floodreptPDM, (char *) "fr_mayPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "June", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_junPB = XmCreatePushButton ( floodreptPDM, (char *) "fr_junPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "July", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_julPB = XmCreatePushButton ( floodreptPDM, (char *) "fr_julPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "August", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_augPB = XmCreatePushButton ( floodreptPDM, (char *) "fr_augPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "September", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_sepPB = XmCreatePushButton ( floodreptPDM, (char *) "fr_sepPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "October", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_octPB = XmCreatePushButton ( floodreptPDM, (char *) "fr_octPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "November", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_novPB = XmCreatePushButton ( floodreptPDM, (char *) "fr_novPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "December", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_decPB = XmCreatePushButton ( floodreptPDM, (char *) "fr_decPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	fr_sep1SE = XmCreateSeparator ( floodreptFO, (char *) "fr_sep1SE", al, ac );
	XtSetArg(al[ac], XmNvisibleItemCount, 19); ac++;
	XtSetArg(al[ac], XmNautomaticSelection, XmAUTO_SELECT); ac++;
	XtSetArg(al[ac], XmNselectionPolicy, XmBROWSE_SELECT); ac++;
	XtSetArg(al[ac], XmNscrollBarDisplayPolicy, XmSTATIC); ac++;
	XtSetArg(al[ac], XmNlistSizePolicy, XmRESIZE_IF_POSSIBLE); ac++;
	floodreptLI = XmCreateScrolledList ( floodreptFO, (char *) "floodreptLI", al, ac );
	ac = 0;
	floodreptSL = XtParent ( floodreptLI );

	XtSetArg(al[ac], XmNhorizontalScrollBar, &floodreptHSB); ac++;
	XtSetArg(al[ac], XmNverticalScrollBar, &floodreptVSB); ac++;
	XtGetValues(floodreptSL, al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNscrollBarPlacement, XmBOTTOM_RIGHT); ac++;
	if (floodreptSL)
		XtSetValues ( floodreptSL, al, ac );
	ac = 0;
	fr_timesFR = XmCreateFrame ( floodreptFO, (char *) "fr_timesFR", al, ac );
	XtSetArg(al[ac], XmNframeChildType, XmFRAME_TITLE_CHILD); ac++;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Details for Selected Event", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_timesLA = XmCreateLabel ( fr_timesFR, (char *) "fr_timesLA", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	fr_timesFO = XmCreateForm ( fr_timesFR, (char *) "fr_timesFO", al, ac );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "AboveFS:", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_aboveLA = XmCreateLabel ( fr_timesFO, (char *) "fr_aboveLA", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNmaxLength, 20); ac++;
	XtSetArg(al[ac], XmNcolumns, 37); ac++;
	XtSetArg(al[ac], XmNeditable, FALSE); ac++;
	XtSetArg(al[ac], XmNcursorPositionVisible, FALSE); ac++;
	fr_aboveTE = XmCreateText ( fr_timesFO, (char *) "fr_aboveTE", al, ac );
	ac = 0;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Crest:", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_crestLA = XmCreateLabel ( fr_timesFO, (char *) "fr_crestLA", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNmaxLength, 40); ac++;
	XtSetArg(al[ac], XmNcolumns, 37); ac++;
	XtSetArg(al[ac], XmNeditable, FALSE); ac++;
	XtSetArg(al[ac], XmNcursorPositionVisible, FALSE); ac++;
	XtSetArg(al[ac], XmNeditMode, XmMULTI_LINE_EDIT); ac++;
	XtSetArg(al[ac], XmNrows, 3); ac++;
	fr_crestTE = XmCreateText ( fr_timesFO, (char *) "fr_crestTE", al, ac );
	ac = 0;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "BelowFS:", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_belowLA = XmCreateLabel ( fr_timesFO, (char *) "fr_belowLA", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNmaxLength, 20); ac++;
	XtSetArg(al[ac], XmNcolumns, 37); ac++;
	XtSetArg(al[ac], XmNeditable, FALSE); ac++;
	XtSetArg(al[ac], XmNcursorPositionVisible, FALSE); ac++;
	fr_belowTE = XmCreateText ( fr_timesFO, (char *) "fr_belowTE", al, ac );
	ac = 0;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Insert into\nCrest Table", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_insertPB = XmCreatePushButton ( fr_timesFO, (char *) "fr_insertPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNvisibleItemCount, 10); ac++;
	XtSetArg(al[ac], XmNautomaticSelection, XmAUTO_SELECT); ac++;
	XtSetArg(al[ac], XmNselectionPolicy, XmBROWSE_SELECT); ac++;
	XtSetArg(al[ac], XmNscrollBarDisplayPolicy, XmAS_NEEDED); ac++;
	XtSetArg(al[ac], XmNlistSizePolicy, XmRESIZE_IF_POSSIBLE); ac++;
	fr_stagesLI = XmCreateScrolledList ( fr_timesFO, (char *) "fr_stagesLI", al, ac );
	ac = 0;
	fr_stagesSL = XtParent ( fr_stagesLI );

	XtSetArg(al[ac], XmNhorizontalScrollBar, &fr_stagesHSB); ac++;
	XtSetArg(al[ac], XmNverticalScrollBar, &fr_stagesVSB); ac++;
	XtGetValues(fr_stagesSL, al, ac );
	ac = 0;
	fr_sep2SE = XmCreateSeparator ( floodreptFO, (char *) "fr_sep2SE", al, ac );
	XtSetArg(al[ac], XmNwidth, 85); ac++;
	XtSetArg(al[ac], XmNheight, 35); ac++;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Close", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_okPB = XmCreatePushButton ( floodreptFO, (char *) "fr_okPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNwidth, 130); ac++;
	XtSetArg(al[ac], XmNheight, 35); ac++;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Compute Latest Data", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_refreshPB = XmCreatePushButton ( floodreptFO, (char *) "fr_refreshPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNwidth, 85); ac++;
	XtSetArg(al[ac], XmNheight, 35); ac++;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Delete Event", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_deletePB = XmCreatePushButton ( floodreptFO, (char *) "fr_deletePB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Save Events to File...", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_exportPB = XmCreatePushButton ( floodreptFO, (char *) "fr_exportPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNy, 45); ac++;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "HSA", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fs_hsaLA = XmCreateLabel ( floodreptFO, (char *) "fs_hsaLA", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNmatchBehavior, XmQUICK_NAVIGATE); ac++;
	XtSetArg(al[ac], XmNpositionMode, XmONE_BASED); ac++;
	fr_hsaCBX = XmCreateDropDownList ( floodreptFO, (char *) "fr_hsaCBX", al, ac );
	ac = 0;
	fr_hsaText = XtNameToWidget ( fr_hsaCBX, (char *) "*Text" );
	fr_hsaLI = XtNameToWidget ( fr_hsaCBX, (char *) "*List" );
	XtSetArg(al[ac], XmNeditable, TRUE); ac++;
	if (fr_hsaText)
		XtSetValues ( fr_hsaText, al, ac );
	ac = 0;
	fr_hsaSL = XtParent ( fr_hsaLI );

	XtSetArg(al[ac], XmNverticalScrollBar, &fr_hsaVSB); ac++;
	XtGetValues(fr_hsaSL, al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNprocessingDirection, XmMAX_ON_BOTTOM); ac++;
	XtSetArg(al[ac], XmNeditable, TRUE); ac++;
	if (fr_hsaVSB)
		XtSetValues ( fr_hsaVSB, al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNautomaticSelection, XmAUTO_SELECT); ac++;
	XtSetArg(al[ac], XmNmatchBehavior, 1); ac++;
	XtSetArg(al[ac], XmNselectionPolicy, XmBROWSE_SELECT); ac++;
	XtSetArg(al[ac], XmNscrollBarDisplayPolicy, XmSTATIC); ac++;
	if (fr_hsaLI)
		XtSetValues ( fr_hsaLI, al, ac );
	ac = 0;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Location", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_BEGINNING); ac++;
	fr_LocationLA = XmCreateLabel ( floodreptFO, (char *) "fr_LocationLA", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Crest Stage", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_END); ac++;
	fr_crestStageLA = XmCreateLabel ( floodreptFO, (char *) "fr_hdrLA2", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Flood Stage", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_floodStageLA = XmCreateLabel ( floodreptFO, (char *) "fr_floodStageLA", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Crest Time", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fr_crestTimeLA = XmCreateLabel ( floodreptFO, (char *) "fr_crestTimeLA", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );


	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_OPPOSITE_WIDGET); ac++;
	XtSetArg(al[ac], XmNtopOffset, 3); ac++;
	XtSetArg(al[ac], XmNtopWidget, floodrept_mainSW); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -511); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 535); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -595); ac++;
	XtSetValues ( floodrept_axisDA, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 5); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -30); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 435); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -590); ac++;
	XtSetValues ( floodrept_lidLA, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 5); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -30); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 630); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -1015); ac++;
	XtSetValues ( floodrept_stageLA, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 40); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -520); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 595); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, 10); ac++;
	XtSetValues ( floodrept_mainSW, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 5); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -40); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -400); ac++;
	XtSetValues ( floodreptOM, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 85); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -100); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 15); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -405); ac++;
	XtSetValues ( fr_sep1SE, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 135); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -475); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -505); ac++;
	XtSetValues ( floodreptSL, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 535); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -740); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -1025); ac++;
	XtSetValues ( fr_timesFR, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 750); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -765); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -1035); ac++;
	XtSetValues ( fr_sep2SE, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 775); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, 20); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -85); ac++;
	XtSetValues ( fr_okPB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 775); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_NONE); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 845); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -1025); ac++;
	XtSetValues ( fr_refreshPB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 490); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -525); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 225); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -400); ac++;
	XtSetValues ( fr_deletePB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 490); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -525); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -190); ac++;
	XtSetValues ( fr_exportPB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 45); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -70); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -45); ac++;
	XtSetValues ( fs_hsaLA, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 45); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_NONE); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 75); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_NONE); ac++;
	XtSetValues ( fr_hsaCBX, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 105); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -130); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -100); ac++;
	XtSetValues ( fr_LocationLA, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 110); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -135); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 220); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -300); ac++;
	XtSetValues ( fr_crestStageLA, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 110); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -135); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 420); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -495); ac++;
	XtSetValues ( fr_floodStageLA, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 110); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -135); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 305); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -395); ac++;
	XtSetValues ( fr_crestTimeLA, al, ac );
	ac = 0;
	if ((children[ac] = floodrept_mainDA) != (Widget) 0) { ac++; }
	if (ac > 0) { XtManageChildren(children, ac); }
	ac = 0;
	XtVaSetValues(floodrept_mainSW,
	              XmNhorizontalScrollBar, floodrept_mainHSB,
	              XmNverticalScrollBar, floodrept_mainVSB,
	              XmNworkWindow, floodrept_mainDA,
	              NULL);
	if ((children[ac] = fr_monPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_yearPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_12monPB) != (Widget) 0) { ac++; }
	if ((children[ac] = floodrept_omSE) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_janPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_febPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_marPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_aprPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_mayPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_junPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_julPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_augPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_sepPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_octPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_novPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_decPB) != (Widget) 0) { ac++; }
	if (ac > 0) { XtManageChildren(children, ac); }
	ac = 0;
	XtSetArg(al[ac], XmNsubMenuId, floodreptPDM); ac++;
	XtSetValues(floodreptCB, al, ac );
	ac = 0;
	if (floodreptLI != (Widget) 0) { XtManageChild(floodreptLI); }

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 20); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -45); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -90); ac++;
	XtSetValues ( fr_aboveLA, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 10); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -45); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 95); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -370); ac++;
	XtSetValues ( fr_aboveTE, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 80); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -105); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 35); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -90); ac++;
	XtSetValues ( fr_crestLA, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 53); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -123); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 94); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -369); ac++;
	XtSetValues ( fr_crestTE, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 145); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -170); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 15); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -90); ac++;
	XtSetValues ( fr_belowLA, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 135); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -170); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 95); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -370); ac++;
	XtSetValues ( fr_belowTE, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 66); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_NONE); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 896); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_NONE); ac++;
	XtSetValues ( fr_insertPB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 5); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -175); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 537); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -882); ac++;
	XtSetValues ( fr_stagesSL, al, ac );
	ac = 0;
	if (fr_stagesLI != (Widget) 0) { XtManageChild(fr_stagesLI); }
	if ((children[ac] = fr_aboveLA) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_aboveTE) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_crestLA) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_crestTE) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_belowLA) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_belowTE) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_insertPB) != (Widget) 0) { ac++; }
	if (ac > 0) { XtManageChildren(children, ac); }
	ac = 0;
	if ((children[ac] = fr_timesLA) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_timesFO) != (Widget) 0) { ac++; }
	if (ac > 0) { XtManageChildren(children, ac); }
	ac = 0;
	if ((children[ac] = floodrept_axisDA) != (Widget) 0) { ac++; }
	if ((children[ac] = floodrept_lidLA) != (Widget) 0) { ac++; }
	if ((children[ac] = floodrept_stageLA) != (Widget) 0) { ac++; }
	if ((children[ac] = floodrept_mainSW) != (Widget) 0) { ac++; }
	if ((children[ac] = floodreptOM) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_sep1SE) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_timesFR) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_sep2SE) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_okPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_refreshPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_deletePB) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_exportPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fs_hsaLA) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_hsaCBX) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_LocationLA) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_crestStageLA) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_floodStageLA) != (Widget) 0) { ac++; }
	if ((children[ac] = fr_crestTimeLA) != (Widget) 0) { ac++; }
	if (ac > 0) { XtManageChildren(children, ac); }
	ac = 0;
}

