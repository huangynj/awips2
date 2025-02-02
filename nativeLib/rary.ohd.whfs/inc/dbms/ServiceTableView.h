// This is a view record !
/*
    File: ServiceTableView.h
    Author  : CDBGEN
    Created : Wed Aug 06 12:34:16 EDT 2008 using database hd_ob83empty
    Description: This header file is associated with its .pgc file 
            and defines functions and the table's record structure.
*/
#ifndef ServiceTableView_h
#define ServiceTableView_h


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <memory.h>
#include "DbmsAccess.h"
#include "DbmsUtils.h"
#include "List.h"
#include "GeneralUtil.h"
#include "dbmserrs.h"
#include "datetime.h"
#include "time_convert.h"



typedef struct _ServiceTableView
{
    Node		node;
    char		lid[9];
    char		name[51];
    char		stream[33];
    char		state[3];
    char		county[21];
    char		hsa[4];
    List		list;
} ServiceTableView;
/*
    Function Prototypes
*/
    ServiceTableView* GetServiceTableView(const char * where);
    ServiceTableView* SelectServiceTableView(const char * where);
    int SelectServiceTableViewCount(const char * where);
    void FreeServiceTableView(ServiceTableView * structPtr);
    DbStatus * GetServiceTableViewDbStatus();
    void SetServiceTableViewErrorLogging(int value);
#endif
