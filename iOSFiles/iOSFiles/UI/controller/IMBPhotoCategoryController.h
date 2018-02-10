//
//  IMBPhotoCategoryController.h
//  iOSFiles
//
//  Created by iMobie on 18/2/10.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IMBDevicePageFolderModel,IMBiPod;


@interface IMBPhotoCategoryController : NSViewController
{
@private
    IMBDevicePageFolderModel *_folderModel;
    IMBiPod *_iPod;
}

@property(nonatomic, retain)IMBDevicePageFolderModel *folderModel;
@property(nonatomic, retain)IMBiPod *iPod;

@end
