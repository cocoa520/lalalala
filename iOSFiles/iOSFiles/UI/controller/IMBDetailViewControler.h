//
//  IMBDetailViewControler.h
//  iOSFiles
//
//  Created by iMobie on 18/2/2.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMBDevicePageFolderModel;


@interface IMBDetailViewControler : NSViewController

{
    @private
    IMBDevicePageFolderModel *_folderModel;
}

@property(nonatomic, retain)IMBDevicePageFolderModel *folderModel;

@end
