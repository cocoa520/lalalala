//
//  IMBToolButtonView.m
//  iOSFiles
//
//  Created by smz on 18/3/15.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBToolButtonView.h"
#import "HoverButton.h"
#import "StringHelper.h"
#import "IMBSegmentedBtn.h"
//#import "IMBBaseViewController.h"
#import "IMBMainPageViewController.h"
#define OperationButtonWidth  36
#define OperationButtonHeight 22
#define OperationButtonSeparationWidth 10
@implementation IMBToolButtonView
@synthesize segmentedControl = _segmentedControl;
@synthesize delegate = _delegate;
- (void)toolBarButtonIsEnabled:(BOOL) isenabled{
    if (!isenabled) {
        [_reload setStatus:4];
        [_add setStatus:4];
        [_iCloudAdd setStatus:4];
        [_delete setStatus:4];
        [_toiTunes setStatus:4];
        [_toMac setStatus:4];
        [_toDevice setStatus:4];
        [_androidtoiOS setStatus:4];
        [_hideImage setStatus:4];
        [_showImage setStatus:4];
        [_deviceDatail setStatus:4];
        [_setting setStatus:4];
        [_exit setStatus:4];
        [_edit setStatus:4];
        [_backup setStatus:4];
        [_back setStatus:4];
        [_find setStatus:4];
        [_contactImport setStatus:4];
        [_toContact setStatus:4];
        [_icloud setStatus:4];
        [_upload setStatus:4];
        [_download setStatus:4];
        [_newgroup setStatus:4];
        [_syncTransfer setStatus:4];
        [_createAlbum setStatus:4];
        [_segmentedControl setEnabled:NO];
    }else{
        [_syncTransfer setStatus:1];
        [_newgroup setStatus:1];
        [_reload setStatus:1];
        [_add setStatus:1];
        [_iCloudAdd setStatus:1];
        [_delete setStatus:1];
        [_toiTunes setStatus:1];
        [_toMac setStatus:1];
        [_toDevice setStatus:1];
        [_androidtoiOS setStatus:1];
        [_hideImage setStatus:1];
        [_showImage setStatus:1];
        [_deviceDatail setStatus:1];
        [_setting setStatus:1];
        [_exit setStatus:1];
        [_edit setStatus:1];
        [_backup setStatus:1];
        [_back setStatus:1];
        [_find setStatus:1];
        [_contactImport setStatus:1];
        [_toContact setStatus:1];
        [_icloud setStatus:1];
        [_upload setStatus:1];
        [_download setStatus:1];
        [_createAlbum setStatus:1];
        [_segmentedControl setEnabled:YES];
    }
    [_reload setEnabled:isenabled];
    [_add setEnabled:isenabled];
    [_iCloudAdd setEnabled:isenabled];
    [_delete setEnabled:isenabled];
    [_toiTunes setEnabled:isenabled];
    [_toMac setEnabled:isenabled];
    [_toDevice setEnabled:isenabled];
    [_androidtoiOS setEnabled:isenabled];
    [_hideImage setEnabled:isenabled];
    [_showImage setEnabled:isenabled];
    [_deviceDatail setEnabled:isenabled];
    [_exit setEnabled:isenabled];
    [_edit setEnabled:isenabled];
    [_backup setEnabled:isenabled];
    [_setting setEnabled:isenabled];
    [_back setEnabled:isenabled];
    [_find setEnabled:isenabled];
    [_contactImport setEnabled:isenabled];
    [_toContact setEnabled:isenabled];
    
    [_icloud setEnabled:isenabled];
    [_upload setEnabled:isenabled];
    [_download setEnabled:isenabled];
    [_newgroup setEnabled:isenabled];
    [_syncTransfer setEnabled:isenabled];
    [_createAlbum setEnabled:isenabled];
    [_reload setNeedsDisplay:YES];
    [_add setNeedsDisplay:YES];
    [_iCloudAdd setNeedsDisplay:YES];
    [_delete setNeedsDisplay:YES];
    [_toiTunes setNeedsDisplay:YES];
    [_toMac setNeedsDisplay:YES];
    [_toDevice setNeedsDisplay:YES];
    [_androidtoiOS setNeedsDisplay:YES];
    [_showImage setNeedsDisplay:YES];
    [_hideImage setNeedsDisplay:YES];
    [_deviceDatail setNeedsDisplay:YES];
    [_exit setNeedsDisplay:YES];
    [_edit setNeedsDisplay:YES];
    [_backup setNeedsDisplay:YES];
    [_back setNeedsDisplay:YES];
    [_find setNeedsDisplay:YES];
    [_contactImport setNeedsDisplay:YES];
    [_toContact setNeedsDisplay:YES];
    [_setting setNeedsDisplay:YES];
    [_icloud setNeedsDisplay:YES];
    [_upload setNeedsDisplay:YES];
    [_download setNeedsDisplay:YES];
    [_newgroup setNeedsDisplay:YES];
    [_syncTransfer setNeedsDisplay:YES];
    [_createAlbum setNeedsDisplay:YES];
    [_segmentedControl setNeedsDisplay:YES];
}

- (void)dealloc {
    [_upload release],_upload = nil;
    [_download release],_download = nil;
    [_movePicture release],_movePicture = nil;
    [_createAlbum release],_createAlbum = nil;
    [_newgroup release],_newgroup = nil;
    [_syncTransfer release],_syncTransfer = nil;
    [_reload release],_reload = nil;
    [_add release],_add = nil;
    [_iCloudAdd release],_iCloudAdd = nil;
    [_delete release],_delete = nil;
    [_toiTunes release],_toiTunes = nil;
    [_toMac release],_toMac = nil;
    [_toDevice release],_toDevice = nil;
    [_androidtoiOS release],_androidtoiOS = nil;
    [_hideImage release],_hideImage = nil;
    [_showImage release],_showImage = nil;
    [_deviceDatail release],_deviceDatail = nil;
    [_setting release],_setting = nil;
    [_exit release],_exit = nil;
    [_edit release],_edit = nil;
    [_backup release],_back = nil;
    [_icloud release],_icloud = nil;
    [_segmentedControl release],_segmentedControl = nil;
    [_back release],_back = nil;
    [_find release],_find = nil;
    [_contactImport release],_contactImport = nil;
    [_toContact release],_toContact = nil;
    [super dealloc];
    
}

- (void)loadButtons:(NSArray *)FunctionTypeArray Target:(id)Target DisplayMode:(BOOL)displayMode {
    NSArray *array = [NSArray arrayWithArray:self.subviews];
    if (array != nil) {
        for (NSView *view in array) {
            if ([view isKindOfClass:[HoverButton class]]) {
                [view removeFromSuperview];
            }
        }
    }
    NSMutableArray *buttonsArray = [NSMutableArray array];
    BOOL isHave = NO;
    for (NSNumber *number in FunctionTypeArray) {
        switch (number.intValue) {
            case ReloadFunctionType:
            {
                if (_reload) {
                    [_reload setTarget:Target];
                    [buttonsArray addObject:_reload];
                }else{
                    _reload =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_reload setAutoresizesSubviews:YES];
                    [_reload setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_reload setMouseEnteredImage:[StringHelper imageNamed:@"tool_refresh_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_refresh_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_refresh_normal"]];
                    [_reload setIsDrawBorder:YES];
                    [_reload setToolTip:CustomLocalizedString(@"Common_id_1", nil)];
                    [_reload setTag:1000];
                    [_reload setTarget:Target];
                    [_reload setAction:@selector(reload:)];
                    [buttonsArray addObject:_reload];
                }
            }
                break;
            case AddFunctionType:
            {
                if (_add) {
                    [_add setTarget:Target];
                    [buttonsArray addObject:_add];
                }else{
                    _add =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_add setAutoresizesSubviews:YES];
                    [_add setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_add setMouseEnteredImage:[StringHelper imageNamed:@"tool_add_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_add_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_add_normal"]];
                    [_add setIsDrawBorder:YES];
                    [_add setToolTip:CustomLocalizedString(@"Common_id_7", nil)];
                    [_add setTag:1001];
                    [_add setTarget:Target];
                    [_add setAction:@selector(addItems:)];
                    [buttonsArray addObject:_add];
                }
            }
                break;
                
            case DeleteFunctionType:
            {
                if (_delete) {
                    [_delete setTarget:Target];
                    [buttonsArray addObject:_delete];
                }else{
                    _delete =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_delete setAutoresizesSubviews:YES];
                    [_delete setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_delete setMouseEnteredImage:[StringHelper imageNamed:@"tool_delete_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_delete_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_delete_normal"]];
                    [_delete setIsDrawBorder:YES];
                    [_delete setToolTip:CustomLocalizedString(@"Common_id_9", nil)];
                    [_delete setTag:1002];
                    [_delete setTarget:Target];
                    [_delete setAction:@selector(deleteItems:)];
                    [buttonsArray addObject:_delete];
                }
            }
                break;
            case ToMacFunctionType:
            {
                if (_toMac) {
                    [_toMac setTarget:Target];
                    [buttonsArray addObject:_toMac];
                }else{
                    _toMac =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_toMac setAutoresizesSubviews:YES];
                    [_toMac setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_toMac setMouseEnteredImage:[StringHelper imageNamed:@"tool_tomac_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_tomac_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_tomac_normal"]];
                    [_toMac setIsDrawBorder:YES];
                    [_toMac setToolTip:CustomLocalizedString(@"Menu_ToPc", nil)];
                    [_toMac setTag:1004];
                    [_toMac setTarget:self];
                    [_toMac setAction:@selector(toMac:)];
                    [buttonsArray addObject:_toMac];
                }
            }
                break;
                
            case ToDeviceFunctionType:
            {
                if (_toDevice) {
                    [_toDevice setTarget:Target];
                    [buttonsArray addObject:_toDevice];
                }else{
                    _toDevice =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_toDevice setAutoresizesSubviews:YES];
                    [_toDevice setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_toDevice setMouseEnteredImage:[StringHelper imageNamed:@"tool_todevice_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_todevice_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_todevice_normal"]];
                    [_toDevice setIsDrawBorder:YES];
                    [_toDevice setToolTip:CustomLocalizedString(@"Menu_ToDevice", nil)];
                    [_toDevice setTag:1005];
                    [_toDevice setTarget:Target];
                    [_toDevice setAction:@selector(toDevice:)];
                    [buttonsArray addObject:_toDevice];
                }
            }
                break;
            case SettingFunctionType:
            {
                if (_setting) {
                    [_setting setTarget:Target];
                    [buttonsArray addObject:_setting];
                }else{
                    _setting =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_setting setAutoresizesSubviews:YES];
                    [_setting setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_setting setMouseEnteredImage:[StringHelper imageNamed:@"tool_setting_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_setting_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_setting_normal"]];
                    [_setting setIsDrawBorder:YES];
                    [_setting setToolTip:CustomLocalizedString(@"Menu_Setting", nil)];
                    [_setting setTag:1007];
                    [_setting setTarget:Target];
                    [_setting setAction:@selector(doSetting:)];
                    [buttonsArray addObject:_setting];
                    
                }
            }
                break;
            case UpLoadFunction:
            {
                if (_upload) {
                    [_upload setTarget:Target];
                    [buttonsArray addObject:_upload];
                }else{
                    _upload =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_upload setAutoresizesSubviews:YES];
                    [_upload setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_upload setMouseEnteredImage:[StringHelper imageNamed:@"tool_toiCloud_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_toiCloud_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_toiCloud_normal"]];
                    [_upload setIsDrawBorder:YES];
                    [_upload setToolTip:CustomLocalizedString(@"device_toIcloud_title", nil)];
                    [_upload setTag:1111];
                    [_upload setTarget:Target];
                    [_upload setAction:@selector(toiCloud:)];
                    [buttonsArray addObject:_upload];
                }
            }
                break;
            case SwitchFunctionType:
            {
                isHave = YES;
                if (_segmentedControl) {
                    if (displayMode) {
                        [_segmentedControl setSelectedSegment:1];
                    }else {
                        [_segmentedControl setSelectedSegment:0];
                    }
                    [_segmentedControl setTarget:Target];
                    [buttonsArray addObject:_segmentedControl];
                    
                }else{
                    _segmentedControl  = [[IMBSegmentedBtn alloc] initWithFrame:NSMakeRect(0, 0, 60, OperationButtonHeight)];
                    [_segmentedControl setAutoresizesSubviews:YES];
                    [_segmentedControl setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_segmentedControl setEnabled:YES];
                    [_segmentedControl setSegmentStyle:NSSegmentStyleTexturedSquare];
                    [_segmentedControl setSegmentCount:2];
                    if (displayMode) {
                        [_segmentedControl setSelectedSegment:1];
                    }else {
                        [_segmentedControl setSelectedSegment:0];
                    }
                    [_segmentedControl.cell setTrackingMode:NSSegmentSwitchTrackingSelectOne];
                    [_segmentedControl setMouseEnteredImage:[StringHelper imageNamed:@"tool_sel_list_noemal"] mouseExitImage:[StringHelper imageNamed:@"tool_sel_list_noemal"] mouseDownImage:[StringHelper imageNamed:@"tool_sel_list_down"] rightMouseEnteredImage:[StringHelper imageNamed:@"tool_sel_icons_normal"] rightMouseExitImage:[StringHelper imageNamed:@"tool_sel_icons_normal"] rightMouseDownImage:[StringHelper imageNamed:@"tool_sel_icons_down"]];
                    [_segmentedControl setTag:1012];
                    [_segmentedControl setTarget:Target];
                    [_segmentedControl setAction:@selector(doSwitchView:)];
                    [buttonsArray addObject:_segmentedControl];
                    
                }
            }
                break;
        }
    }
    for (int i=0;i<[buttonsArray count];i++) {
        HoverButton *button = [buttonsArray objectAtIndex:i];
        float ox = ox = NSWidth(self.frame) - OperationButtonSeparationWidth - ([buttonsArray count] - i)*OperationButtonWidth - ([buttonsArray count] - (i+1))*OperationButtonSeparationWidth;;
        if (isHave) {
            ox = ox - 24;
        }
        [button setFrameOrigin:NSMakePoint(ox, (NSHeight(self.frame) - OperationButtonHeight)/2)];
        [self addSubview:button];
    }
}

- (void)toMac:(id)sender {
    [_delegate toMac:nil];
}



@end
