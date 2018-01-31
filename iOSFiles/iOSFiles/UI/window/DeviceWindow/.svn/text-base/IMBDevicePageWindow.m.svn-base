//
//  IMBDevicePageWindow.m
//  iOSFiles
//
//  Created by 龙凡 on 2018/1/31.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBDevicePageWindow.h"
//#import "IMBNoTitleBarWindow.h"
#import "IMBDrawOneImageBtn.h"
#import "IMBToolbarWindow.h"
#import "IMBiPod.h"
#import "IMBInformation.h"
#import "IMBInformationManager.h"
#import "IMBCommonEnum.h"
#import "IMBTrack.h"
#import "IMBPhotoEntity.h"
#import "IMBDeviceConnection.h"

@interface IMBDevicePageWindow ()
{
    @private
    IMBInformation *_information;
}
@end

@implementation IMBDevicePageWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (id)initWithiPod:(IMBiPod *)ipod {
    if ([super initWithWindowNibName:@"IMBDevicePageWindow"]) {
        _iPod = [ipod retain];
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    
    NSButton *btn =  [self.window standardWindowButton:NSWindowCloseButton];
//    [btn setFrame:NSMakeRect(2,4, 20, 20)];
//    NSButton *btn1 =  [self.window standardWindowButton:NSWindowMiniaturizeButton];
//    [btn1 setFrame:NSMakeRect(6,10, 20, 20)];
    NSButton *btn2 =  [self.window standardWindowButton:NSWindowZoomButton];
    [btn2 setFrame:NSMakeRect(44,4, 20, 20)];
//    [btn setHidden:YES];
//    [btn1 setHidden:YES];
    [btn2 setHidden:YES];
    
    
    [btn setAction:@selector(closeWindow:)];
    [btn setTarget:self];
//    IMBDrawOneImageBtn *button = [[IMBDrawOneImageBtn alloc]initWithFrame:NSMakeRect(12, 2, 12, 12)];
//    [button mouseDownImage:[NSImage imageNamed:@"windowclose3"] withMouseUpImg:[NSImage imageNamed:@"windowclose"] withMouseExitedImg:[NSImage imageNamed:@"windowclose"] mouseEnterImg:[NSImage imageNamed:@"windowclose2"]];
//    [button setEnabled:YES];
//    [button setTarget:self];
//    [button setAction:@selector(closeWindow:)];
//    [button setBordered:NO];
//    [[(IMBToolbarWindow *)self.window titleBarView ]addSubview:button];


}

- (void)setup {
    _information = [[IMBInformation alloc] initWithiPod:_iPod];
    if (_information) {
        [_iPod startSync];
        [_information refreshMedia];
        NSArray *trackArray = [[NSMutableArray alloc] initWithArray:[_information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_Music]]];
//        NSArray *photoArray = [[_information photoSelfiesArray] retain];
        IMBFLog(@"%@",trackArray);
        for (IMBTrack *track in trackArray) {
            IMBFLog(@"%@",track);
        }
        [_iPod endSync];
//        for (IMBPhotoEntity *photo in photoArray) {
//            IMBFLog(@"%@",photo);
//        }
    }
}

-(void)dealloc {
    
    [_information release];
    _information = nil;
    if (_iPod) {
        [_iPod release];
        _iPod = nil;
    }
    
    [super dealloc];
}

- (void)closeWindow:(id)sender {
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
        if ([baseInfo.uniqueKey isEqualToString:_iPod.uniqueKey]) {
            baseInfo.isSelected = NO;
        }
    }
    [self.window close];
}


@end
