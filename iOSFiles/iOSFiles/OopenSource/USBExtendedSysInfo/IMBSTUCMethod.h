//
//  IMBSTUCMethod.h
//  iPodSCSIInfoRead
//
//  Created by Pallas on 3/27/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STUCMethod.h"

#import <mach/mach.h>
#import <mach/mach_error.h>
#import <IOKit/IOKitLib.h>
#import <IOKit/IOCFPlugIn.h>
#import <IOKit/usb/IOUSBLib.h>
#import <IOKit/IOBSD.h>

#import "IMBSTUCMethod.h"
#import <IOKit/scsi/SCSICmds_INQUIRY_Definitions.h>

#import <DiskArbitration/DiskArbitration.h>

@interface IMBSTUCMethod : NSObject

+ (BOOL)createExtendedInfoByMountPath:(NSString*)mountPath extendedInfoPath:(NSString*)extendedInfoPath;

@end

