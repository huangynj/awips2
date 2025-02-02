/*****************************************************************************
 * myasert.c
 *
 * DESCRIPTION
 *    This file contains the code to handle assert statements.  There is no
 * actual code unless DEBUG is defined.
 *
 * HISTORY
 *   12/2003 Arthur Taylor (MDL / RSIS): Created.
 *
 * NOTES
 *****************************************************************************
 */
#include <stdio.h>
#include <stdlib.h>
#include "degrib_inc/myassert.h"

/*****************************************************************************
 * myAssert() --
 *
 * Arthur Taylor / MDL
 *
 * PURPOSE
 *   This is an Assert routine from "Writing Solid Code" by Steve Maguire.
 *
 * Advantages of this over "assert" is that assert stores the expression
 * string for printing.  Where does assert store it?  Probably in global data,
 * but that means assert is gobbling up space that the program may need for
 * no real advantage.  If you trigger assert, you're going to look in the file
 * and see the code.
 *
 * ARGUMENTS
 *    file = Filename that assert was in. (Input)
 * lineNum = Line number in file of the assert. (Input)
 *
 * FILES/DATABASES: None
 *
 * RETURNS: void
 *
 * HISTORY
 *   8/2003 Arthur Taylor (MDL/RSIS): Created.
 *
 * NOTES
 *****************************************************************************
 */
#ifdef DEBUG
void _myAssert (const char *file, int lineNum)
{
   fflush (NULL);
   fprintf (stderr, "\nAssertion failed: %s, line %d\n", file, lineNum);
   fflush (stderr);
   abort ();
/*      exit (EXIT_FAILURE);*/

/*  ==============  Statements containing RCS keywords:  */
{static char rcs_id1[] = "$Source: /fs/hseb/ob72/rfc/util/src/degrib/RCS/myassert.c,v $";
 static char rcs_id2[] = "$Id: myassert.c,v 1.1 2004/09/16 17:14:09 dsa Exp $";}
/*  ===================================================  */

}
#endif
