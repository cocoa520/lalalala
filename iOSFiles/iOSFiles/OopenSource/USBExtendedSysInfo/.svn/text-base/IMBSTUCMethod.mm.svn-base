//
//  IMBSTUCMethod.m
//  iPodSCSIInfoRead
//
//  Created by Pallas on 3/27/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBSTUCMethod.h"

@implementation IMBSTUCMethod

+ (BOOL)createExtendedInfoByMountPath:(NSString*)mountPath extendedInfoPath:(NSString*)extendedInfoPath {
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:extendedInfoPath]) {
        return NO;
    } else {
        DASessionRef session = DASessionCreate(kCFAllocatorDefault);
        const char * dir = [mountPath UTF8String];
        CFURLRef pathRef = CFURLCreateFromFileSystemRepresentation(kCFAllocatorDefault, (const UInt8 *)dir, strlen(dir), TRUE);
        DADiskRef disk = DADiskCreateFromVolumePath(kCFAllocatorDefault, session, pathRef);
        CFDictionaryRef desDic = DADiskCopyDescription(disk);
        NSDictionary *desDicA = (NSDictionary*)desDic;
        NSString *devicePath = [desDicA objectForKey:@"DADevicePath"];
        if (![self stringIsNilOrEmpty:devicePath]) {
            io_service_t scsiDevice = IORegistryEntryFromPath(kIOMasterPortDefault, [devicePath UTF8String]);
            if (scsiDevice != IO_OBJECT_NULL) {
                [self getiPodXML:scsiDevice filePath:extendedInfoPath];
                return YES;
            }
        } else {
            return NO;
        }
        return NO;
    }
}

+ (void)getiPodXML:(io_service_t)scsiDevice filePath:(NSString*)filePath {
    GetiPodXML(scsiDevice, [filePath UTF8String]);
}

+ (BOOL)stringIsNilOrEmpty:(NSString*)string {
    if (string == nil || [string isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

@end
