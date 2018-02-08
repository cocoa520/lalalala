//
//  IMBiCloudDriverViewListController.h
//  AnyTrans
//
//  Created by m on 17/2/20.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
#import "IMBiCloudDriverViewController.h"
@interface IMBiCloudDriverViewListController : IMBBaseViewController<NSTableViewDelegate, NSTableViewDataSource> {
    NSString *_exportFolder;
@public
    NSTextField *_pathField;
    IMBiCloudDriveFolderEntity *_selectedNode;
    IMBiCloudDriveFolderEntity *_curDriveEntity;
    IMBiCloudDriverViewController *_driverCollectionView;//    此处__weak已删掉 by Gehry
}
- (void)setTableViewSelectStatus;

@end
