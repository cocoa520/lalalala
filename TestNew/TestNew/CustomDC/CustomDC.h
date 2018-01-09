//
//  CustomDC.h
//  TestNew
//
//  Created by iMobie on 18/1/9.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
//#import <CoreGraphics/CoreGraphics.h>
//#import "IMBLogManager.h"
#ifdef __cplusplus
extern "C" {
#endif
    
    // Apple's opaque types
    typedef uint32_t afc_error_t;
    typedef uint64_t afc_file_ref;
    //luolei add
#if __x86_64__
    typedef uint64_t	afc_long;
#else
    typedef uint32_t	afc_long;
#endif
    //luolei add
    
    /* opaque structures */
    typedef struct _am_device				*am_device;
    typedef struct _afc_connection			*afc_connection;
    typedef struct _am_device_notification	*am_device_notification;
    
    // on OSX, this is a raw file descriptor, not a pointer - it ends up being
    // passed directly to send()
    //typedef struct _am_service				*am_service;
    //TODO:32位需要改为int
#if __x86_64__
    typedef int64_t		am_service;
#else
    typedef uint32_t  	am_service;
#endif
    
    int startServiceFaildCount;

