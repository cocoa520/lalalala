//
//  IMBDriveWindow.m
//  iOSFiles
//
//  Created by JGehry on 2/27/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBDriveWindow.h"
#import "IMBToolbarWindow.h"
#import "IMBDriveEntity.h"
#import "IMBFolderOrFileButton.h"
#import "IMBSelectionView.h"
#import "HoverButton.h"
#import "DriveItem.h"
#import "IMBiCloudNoTitleBarWinodw.h"
#import "IMBCommonDefine.h"
#import "NSColor+Category.h"
#import "IMBDrawOneImageBtn.h"
@interface IMBDriveWindow ()

@end

@implementation IMBDriveWindow
@synthesize downloaditem = _downloaditem;

- (instancetype)initWithWindowNibName:(NSString *)windowNibName {
    if (self = [super initWithWindowNibName:windowNibName]) {
        
    }
    return self;
}

- (id)initWithDrivemanage:(IMBDriveBaseManage*)driveManage withisiCloudDrive:(BOOL) isiCloudDirve {
    if ([self initWithWindowNibName:@"IMBDriveWindow"]) {
        _driveBaeManage = [driveManage retain];
        _bindArray = [_driveBaeManage.driveDataAry retain];
        _isiCloudDirve = isiCloudDirve;
    }
    return self;
}

-(void)awakeFromNib {
    IMBDrawOneImageBtn *button = [[IMBDrawOneImageBtn alloc]initWithFrame:NSMakeRect(12, 20, 12, 12)];
    [button mouseDownImage:[NSImage imageNamed:@"windowclose3"] withMouseUpImg:[NSImage imageNamed:@"windowclose"] withMouseExitedImg:[NSImage imageNamed:@"windowclose"] mouseEnterImg:[NSImage imageNamed:@"windowclose2"]];
    [button setEnabled:YES];
    [button setTarget:self];
    [button setAction:@selector(closeWindow:)];
    [button setBordered:NO];
    [_topView initWithLuCorner:YES LbCorner:NO RuCorner:YES RbConer:NO CornerRadius:5];
    [_topView setBackgroundColor:COLOR_DEVICE_Main_WINDOW_TOPVIEW_COLOR];
    [_topView addSubview:button];

    //顶部控件
    [_topView initWithLuCorner:YES LbCorner:NO RuCorner:YES RbConer:NO CornerRadius:5];
    [_topView setBackgroundColor:COLOR_DEVICE_Main_WINDOW_TOPVIEW_COLOR];
    
    //content View
    if (_isiCloudDirve) {
        _baseViewController = [[IMBiCloudDriverViewController alloc] initWithDrivemanage:_driveBaeManage withDelegete:self];
    } else {
        
    }
    [_rootBox setContentView:_baseViewController.view];
}

- (void)closeWindow:(id)sender {
    [self.window close];
}

- (void)dealloc {
    if (_driveBaeManage != nil) {
        [_driveBaeManage release];
        _driveBaeManage = nil;
    }
    [super dealloc];
}

@end
