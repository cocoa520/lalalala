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
@interface IMBDriveWindow ()

@end

@implementation IMBDriveWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (id)initWithDrivemanage:(IMBDriveManage*)driveManage {
    if ([self initWithWindowNibName:@"IMBDriveWindow"]) {
        _drivemanage = [driveManage retain];
    }
    return self;
}

-(void)awakeFromNib{
    NSButton *btn =  [self.window standardWindowButton:NSWindowCloseButton];
    NSButton *btn2 =  [self.window standardWindowButton:NSWindowZoomButton];
    [btn2 setAction:@selector(zoomWindow:)];
    [btn2 setTarget:self];
    
    [btn setAction:@selector(closeWindow:)];
    [btn setTarget:self];
    [(IMBToolbarWindow *)self.window setTitleBarHeight:20];
    _bindArray = [[NSMutableArray alloc]init];
    IMBDriveEntity *driveEntity = [[IMBDriveEntity alloc]init];
    driveEntity.fileName = @"11111";
    [_bindArray addObject:driveEntity];
//    [_bindArray addObjectsFromArray:_drivemanage.driveDataAry];
    [_arrayController addObjects:_bindArray];
}

- (void)zoomWindow:(id)sender {

}

- (void)closeWindow:(id)sender {
    [self.window close];
}

@end
