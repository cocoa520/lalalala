//
//  ViewController.h
//  TestNew
//
//  Created by iMobie on 18/1/8.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "MobileDeviceAccess.h"

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

@interface ViewController : NSViewController


@end

    
    /// This class represents an open file on the device.
    /// The caller can read from or write to the file depending on the
    /// file open mode.
@interface AFCFileReference : NSObject
{
@private
    afc_file_ref _ref;
    afc_connection _afc;
    NSString *_lasterror;
}

/// The last error that occurred on this file
///
/// The object remembers the last error that occurred, which allows most other api's
/// to return YES/NO as their failure condition.  If no previous error occurred,
/// this property will be nil.
@property (readonly) NSString *lasterror;

/// Close the file.
/// Any outstanding writes are flushed to disk.
- (bool)closeFile;

/// Change the current position within the file.
/// @param offset is the number of bytes to move by
/// @param mode must be one of the following:
/// - \p SEEK_SET (0) - offset is relative to the start of the file
/// - \p SEEK_CUR (1) - offset is relative to the current position
/// - \p SEEK_END (2) - offset is relative to the end of the file
- (bool)seek:(int64_t)offset mode:(int)mode;

/// Return the current position within the file.
/// The position is suitable to be passed to \p seek: \p mode:SEEK_SET
- (bool)tell:(uint64_t*)offset;

/// Read \p n
/// bytes from the file into the nominated buffer (which must be at
/// least \p n bytes long).  Returns the number of bytes actually read.
- (afc_long)readN:(afc_long)n bytes:(char *)buff;

/// Write \p n bytes to the file.  Returns \p true if the write was
/// successful and \p false otherwise.
- (bool)writeN:(afc_long)n bytes:(const char *)buff;

/// Write the contents of an NSData to the file.  Returns \p true if the
/// write was successful and \p false otherwise
- (bool)writeNSData:(NSData*)data;

/// Set the size of the file
///
/// Truncates the file to the specified size.
- (bool)setFileSize:(uint64_t)size;

// 锁定同步的操作
- (void)lock:(int)tries;

// 取消锁定的同步操作
- (void)unLock;

- (id)initWithPath:(NSString*)path reference:(afc_file_ref)ref afc:(afc_connection)afc;

@end
