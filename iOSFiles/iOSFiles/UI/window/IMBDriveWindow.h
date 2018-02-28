//
//  IMBDriveWindow.h
//  iOSFiles
//
//  Created by JGehry on 2/27/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBDriveManage.h"
#import "IMBBlankDraggableCollectionView.h"
#import "IMBSystemCollectionViewController.h"
@interface IMBDriveWindow : NSWindowController <NSCollectionViewDelegate>
{
    IMBDriveManage *_drivemanage;
    NSMutableArray *_bindArray;
    IBOutlet NSArrayController *_arrayController;
    IBOutlet IMBBlankDraggableCollectionView *_blankCollection;

}
@property (nonatomic,retain) NSMutableArray *bindArray;
- (id)initWithDrivemanage:(IMBDriveManage*)driveManage;
@end
