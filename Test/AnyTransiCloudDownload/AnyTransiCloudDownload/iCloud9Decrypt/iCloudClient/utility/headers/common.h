//
//  common.h
//  InstallClamAV
//
//  Created by Pallas on 6/4/15.
//  Copyright (c) 2015 Pallas. All rights reserved.
//

#include<stdio.h>

#ifndef InstallClamAV_common_h
#define InstallClamAV_common_h

typedef void(* compilecallback)(char *);

typedef long long int INT64;
typedef unsigned long long int UINT64;
typedef unsigned long ULONG32;
typedef int INT32;
typedef unsigned int UINT32;
typedef signed char CHAR;
typedef unsigned char UChar;
typedef short int SINT;
typedef unsigned short int USINT;

typedef enum FileTypes {
    TYPES_UNKNOWN = 0,
    TYPES_FIFO = 1,
    TYPES_CHR = 2,
    TYPES_DIR = 4,
    TYPES_BLK = 6,
    TYPES_REG = 8,
    TYPES_LNK = 10,
    TYPES_SOCK = 12,
    TYPES_WHT = 14
} file_types;

typedef enum Boolx {
    False = 0,
    True = 1
} Bool;

typedef struct stringarray{
    char *content;
    struct stringarray *next;
} string_array;

#if defined(__cplusplus)
#define EXTERN extern "C"
#else
#define EXTERN extern
#endif

#endif
