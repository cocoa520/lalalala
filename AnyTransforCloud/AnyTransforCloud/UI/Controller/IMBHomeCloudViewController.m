//
//  IMBHomeCloudViewController.m
//  AnyTransforCloud
//
//  Created by ding ming on 18/5/4.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBHomeCloudViewController.h"
#import "IMBCloudManager.h"
#import "IMBBlankDraggableCollectionView.h"

@interface IMBHomeCloudViewController ()

@end

@implementation IMBHomeCloudViewController
@synthesize dataAry = _dataAry;

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLoginCloud:) name:REFRESH_LOGIN_CLOUD object:nil];
    _dataAry = [[NSMutableArray alloc] init];
    [(IMBBlankDraggableCollectionView *)_collectionView setIsFipped:YES];
    [self.view addSubview:_scrollView];
    [_collectionView setWantsLayer:YES];
}

- (void)loadDataAry:(int)showCount {
    [_dataAry removeAllObjects];
    [_scrollView setFrameSize:NSMakeSize(_scrollView.frame.size.width + 90, _scrollView.frame.size.height)];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *driveArray = [IMBCloudManager singleton].driveManager.driveArray;
    for (int i=0;i<showCount-1;i++) {
        if (driveArray.count > i) {
            BaseDrive *baseDrive = [driveArray objectAtIndex:i];
            IMBCloudEntity *cloudEntity = [[IMBCloudEntity alloc] init];
            [TempHelper setDriveDefultImage:baseDrive CloudEntity:cloudEntity];
            NSString *emailStr = @"...";
            long long tSize = 0;
            long long uSize = 0;
            if (![StringHelper stringIsNilOrEmpty:baseDrive.driveEmail]) {
                emailStr = baseDrive.driveEmail;
            }
            tSize = baseDrive.totalCapacity;
            uSize = baseDrive.usedCapacity;
            NSString *totalSize = [StringHelper getFileSizeString:tSize reserved:2];
            NSString *avialbleSize = [StringHelper getFileSizeString:uSize reserved:2];
            NSString *subStr = @"";
            if (tSize == 0 && uSize == 0) {
                subStr = @"--/--";
            }else if (tSize == 0 && uSize != 0) {
                subStr = [NSString stringWithFormat:@"%@/--",avialbleSize];
            }else if (tSize != 0 && uSize == 0) {
                subStr = [NSString stringWithFormat:@"--/%@",totalSize];
            }else {
                subStr = [NSString stringWithFormat:@"%@/%@",avialbleSize,totalSize];
            }
            [cloudEntity setEmail:emailStr];
            [cloudEntity setShowSize:subStr];
            [cloudEntity setIsHidden:NO];
            [cloudEntity setIsAddHidden:YES];
            [array addObject:cloudEntity];
            [cloudEntity release];
            cloudEntity = nil;
        }
    }
    
    //增加按钮
    IMBCloudEntity *cloudEntity = [[IMBCloudEntity alloc] init];
    [cloudEntity setDriveID:@"HomeAddID"];
    [cloudEntity setName:@""];
    [cloudEntity setEmail:@""];
    [cloudEntity setShowSize:@""];
    [cloudEntity setIsHidden:YES];
    [cloudEntity setIsAddHidden:NO];
    [array addObject:cloudEntity];
    [cloudEntity release];
    cloudEntity = nil;
    
    [_arrayController addObjects:array];
    [array release];
}

- (void)refreshLoginCloud:(NSNotification *)notification {
    BaseDrive *baseDrive = notification.object;
    if (baseDrive) {
        for (IMBCloudEntity *entity in _dataAry) {
            if ([entity.driveID isEqualToString:baseDrive.driveID]) {
                long long tSize = baseDrive.totalCapacity;
                long long uSize = baseDrive.usedCapacity;
                NSString *totalSize = [StringHelper getFileSizeString:tSize reserved:2];
                NSString *avialbleSize = [StringHelper getFileSizeString:uSize reserved:2];
                NSString *subStr = @"";
                if (tSize == 0 && uSize == 0) {
                    subStr = @"--/--";
                }else if (tSize == 0 && uSize != 0) {
                    subStr = [NSString stringWithFormat:@"%@/--",avialbleSize];
                }else if (tSize != 0 && uSize == 0) {
                    subStr = [NSString stringWithFormat:@"--/%@",totalSize];
                }else {
                    subStr = [NSString stringWithFormat:@"%@/%@",avialbleSize,totalSize];
                }
                [entity setShowSize:subStr];
                [entity setName:baseDrive.displayName];
                break;
            }
        }
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_LOGIN_CLOUD object:nil];
    [_dataAry release], _dataAry = nil;
    [super dealloc];
}

@end

@implementation IMBHomeCollectionViewItem

@end
