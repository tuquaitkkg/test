#ifndef __COMMON_DEFINITION_H__
#define __COMMON_DEFINITION_H__


/* ================================================================ */
// standard header
/* ================================================================ */
#include <stdio.h>
#include <string.h>

/* ================================================================ */
// custom header
/* ================================================================ */
//#define __ANDROID_PROJECT_USED__
//#define __IOS_PROJECT_USED__
#ifdef __ANDROID_PROJECT_USED__
#include <malloc.h>
#include "android/log.h"
#define TRACE() __android_log_print(ANDROID_LOG_INFO, "PDFLIB", "%s(%d)%s", __func__, __LINE__, "\n");
#define LOGD(fmt, ...) __android_log_print(ANDROID_LOG_INFO, "PDFLIB", "%s(%d):" fmt, __func__, __LINE__, ## __VA_ARGS__);
#else
#include <stdlib.h>
#define TRACE() printf("%s(%d)%s", __func__, __LINE__, "\n");
#define LOGD(fmt, ...) printf("%s(%d):" fmt, __func__, __LINE__, ## __VA_ARGS__);
#endif

/* ================================================================ */
// variable
/* ================================================================ */
typedef unsigned char       BYTE;
typedef unsigned short      WORD;
typedef unsigned long       DWORD;

/* ================================================================ */
// element type(N-up)
/* ================================================================ */
static const int ELMTYPE_NONE = 0;
static const int ELMTYPE_JPEG = 1;
static const int ELMTYPE_G4 = 2;
static const int ELMTYPE_G3 = 3;
static const int ELMTYPE_NONECOMP = 4;

/* ================================================================ */
// definition (error case)
/* ================================================================ */
static const int ERROR_NONE = 0;
static const int ERROR_OTHER = -1000;
static const int ERROR_INVALID_PARAM = -1001;
static const int ERROR_FILE = -1;
static const int ERROR_NO_MEMORY = -2;
static const int ERROR_NO_SPACE = -3;
static const int ERROR_NOT_FILE_EXIST = -4;
static const int ERROR_NOT_SPPORT = -5;
static const int ERROR_NO_AUTHORITY = -6;
static const int ERROR_CYPHER_PDF = -7;
static const int ERROR_NOT_SHARP_PDF = -10;
static const int ERROR_INVALID_PARAM_NUP = -11;



/* ================================================================ */
// definition(N-up)
/* ================================================================ */
static const int N_UP_NONE = 0;
static const int N_UP_1 = 1;
static const int N_UP_2 = 2;
static const int N_UP_4 = 4;


/* ================================================================ */
// definition(Paper size definition)
/* ================================================================ */
static const int PAPER_SIZE_A3_WIDE = 0;
static const int PAPER_SIZE_A3 = 1;
static const int PAPER_SIZE_A4 = 2;
static const int PAPER_SIZE_A5 = 3;
static const int PAPER_SIZE_B4 = 4;
static const int PAPER_SIZE_B5 = 5;
static const int PAPER_SIZE_LEDGER = 6;
static const int PAPER_SIZE_LETTER = 7;
static const int PAPER_SIZE_LEGAL = 8;
static const int PAPER_SIZE_EXECUTIVE = 9;
static const int PAPER_SIZE_INVOICE = 10;
static const int PAPER_SIZE_FOOLSCAP = 11;
static const int PAPER_SIZE_S8k = 12;
static const int PAPER_SIZE_S16k = 13;
static const int PAPER_SIZE_DL = 14;
static const int PAPER_SIZE_C5 = 15;
static const int PAPER_SIZE_COM10 = 16;
static const int PAPER_SIZE_MONARCH = 17;
static const int PAPER_SIZE_JPOST = 18;
static const int PAPER_SIZE_KAKUGATA2 = 19;
static const int PAPER_SIZE_CHOKEI3 = 20;
static const int PAPER_SIZE_YOKEI2 = 21;
static const int PAPER_SIZE_YOKEI4 = 22;


/* ================================================================ */
// definition(PDF size)
/* ================================================================ */
static const int PDF_SIZE_MARGIN = 8;
static const int PDF_SIZE_MARGIN_TOP = PDF_SIZE_MARGIN;
static const int PDF_SIZE_MARGIN_BOTTOM = PDF_SIZE_MARGIN;
static const int PDF_SIZE_MARGIN_VERTICAL = (PDF_SIZE_MARGIN_TOP+ PDF_SIZE_MARGIN_BOTTOM);
static const int PDF_SIZE_MARGIN_LEFT = PDF_SIZE_MARGIN;
static const int PDF_SIZE_MARGIN_RIGHT = PDF_SIZE_MARGIN;
static const int PDF_SIZE_MARGIN_HORIZONTAL = (PDF_SIZE_MARGIN_LEFT+ PDF_SIZE_MARGIN_RIGHT);
static const int PDF_SIZE_MARGIN_HEIGHT_BETWEEN = 2;


/* ================================================================ */
// definition(NUP ORDER)
/* ================================================================ */
static const int NUP_ORDER_2UP_LEFT_TO_RIGHT = 0;
static const int NUP_ORDER_2UP_RIGHT_TO_LEFT = 1;
static const int NUP_ORDER_4UP_UPPERLEFT_TO_RIGHT = 2;
static const int NUP_ORDER_4UP_UPPERLEFT_TO_BOTTOM = 3;
static const int NUP_ORDER_4UP_UPPERRIGHT_TO_LEFT = 4;
static const int NUP_ORDER_4UP_UPPERRIGHT_TO_BOTTOM = 5;


/* ================================================================ */
// definition(paper size) [pt]
/* ================================================================ */
static const int PDF_PT_A3WIDE_HEIGHT = 1295;
static const int PDF_PT_A3WIDE_WIDTH = 865;
static const int PDF_PT_A3_HEIGHT = 1191;
static const int PDF_PT_A3_WIDTH = 842;
static const int PDF_PT_A4_HEIGHT = 842;
static const int PDF_PT_A4_WIDTH = 595;
static const int PDF_PT_A5_HEIGHT = 595;
static const int PDF_PT_A5_WIDTH = 420;
static const int PDF_PT_B4_HEIGHT = 1032;
static const int PDF_PT_B4_WIDTH = 729;
static const int PDF_PT_B5_HEIGHT = 729;
static const int PDF_PT_B5_WIDTH = 516;
static const int PDF_PT_LEDGER_HEIGHT = 1224;
static const int PDF_PT_LEDGER_WIDTH = 792;
static const int PDF_PT_LETTER_HEIGHT = 792;
static const int PDF_PT_LETTER_WIDTH = 612;
static const int PDF_PT_LEGAL_HEIGHT = 965;
static const int PDF_PT_LEGAL_WIDTH = 612;
static const int PDF_PT_EXECUTIVE_HEIGHT = 756;
static const int PDF_PT_EXECUTIVE_WIDTH = 522;
static const int PDF_PT_INVOICE_HEIGHT = 612;
static const int PDF_PT_INVOICE_WIDTH = 396;
static const int PDF_PT_FOOLSCAP_HEIGHT = 936;
static const int PDF_PT_FOOLSCAP_WIDTH = 612;
static const int PDF_PT_S8k_HEIGHT = 1106;
static const int PDF_PT_S8k_WIDTH = 765;
static const int PDF_PT_S16k_HEIGHT = 765;
static const int PDF_PT_S16k_WIDTH = 553;
static const int PDF_PT_DL_HEIGHT = 624;
static const int PDF_PT_DL_WIDTH = 312;
static const int PDF_PT_C5_HEIGHT = 649;
static const int PDF_PT_C5_WIDTH = 459;
static const int PDF_PT_COM10_HEIGHT = 684;
static const int PDF_PT_COM10_WIDTH = 297;
static const int PDF_PT_MONARCH_HEIGHT = 540;
static const int PDF_PT_MONARCH_WIDTH = 279;
static const int PDF_PT_JPOST_HEIGHT = 420;
static const int PDF_PT_JPOST_WIDTH = 283;
static const int PDF_PT_KAKUGATA2_HEIGHT = 941;
static const int PDF_PT_KAKUGATA2_WIDTH = 680;
static const int PDF_PT_CHOKEI3_HEIGHT = 666;
static const int PDF_PT_CHOKEI3_WIDTH = 340;
static const int PDF_PT_YOKEI2_HEIGHT = 459;
static const int PDF_PT_YOKEI2_WIDTH = 323;
static const int PDF_PT_YOKEI4_HEIGHT = 666;
static const int PDF_PT_YOKEI4_WIDTH = 298;


/* ================================================================ */
// definition(TIFFG4 page num)
/* ================================================================ */
static const int TIFF_PAGE_MAX = 99;






#endif /* __COMMON_DEFINITION_H__ */
