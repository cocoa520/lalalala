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
#import "IMBMainPageViewController.h"
#define OperationButtonWidth  30
#define OperationButtonHeight 30
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
        [_toiCloud setStatus:4];
        [_upload setStatus:4];
        [_download setStatus:4];
        [_newgroup setStatus:4];
        [_syncTransfer setStatus:4];
        [_createAlbum setStatus:4];
        [_rename setStatus:4];
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
        [_toiCloud setStatus:1];
        [_upload setStatus:1];
        [_download setStatus:1];
        [_createAlbum setStatus:1];
        [_rename setStatus:1];
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
    
    [_toiCloud setEnabled:isenabled];
    [_upload setEnabled:isenabled];
    [_download setEnabled:isenabled];
    [_newgroup setEnabled:isenabled];
    [_syncTransfer setEnabled:isenabled];
    [_createAlbum setEnabled:isenabled];
    [_rename setEnabled:isenabled];
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
    [_toiCloud setNeedsDisplay:YES];
    [_upload setNeedsDisplay:YES];
    [_download setNeedsDisplay:YES];
    [_newgroup setNeedsDisplay:YES];
    [_syncTransfer setNeedsDisplay:YES];
    [_createAlbum setNeedsDisplay:YES];
    [_rename setNeedsDisplay:YES];
    [_segmentedControl setNeedsDisplay:YES];
}

- (void)dealloc {
    [_upload release],_upload = nil;
    [_download release],_download = nil;
    [_moveFile release],_moveFile = nil;
    [_createAlbum release],_createAlbum = nil;
    [_rename release],_rename = nil;
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
    [_toiCloud release],_toiCloud = nil;
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
                    [_reload setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_refresh"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_refresh"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_refresh_hover"]];
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
                    [_delete setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_del "] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_del "] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_del_hover"]];
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
                    [_toMac setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_topc"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_topc"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_topc_hover"]];
                    [_toMac setToolTip:CustomLocalizedString(@"Menu_ToPc", nil)];
                    [_toMac setTag:1004];
                    [_toMac setTarget:Target];
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
                    [_toDevice setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_todevice"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_todevice"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_todevice_hover"]];
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
                    [_setting setToolTip:CustomLocalizedString(@"Menu_Setting", nil)];
                    [_setting setTag:1007];
                    [_setting setTarget:Target];
                    //[_setting setAction:@selector(doSetting:)];
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
                    [_upload setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_upload"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_upload"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_upload_hover"]];
                    [_upload setToolTip:CustomLocalizedString(@"device_toIcloud_title", nil)];
                    [_upload setTag:1111];
                    [_upload setTarget:Target];
                    [_upload setAction:@selector(addItems:)];
                    [buttonsArray addObject:_upload];
                }
            }
                break;
            case DownLoadFunction:
            {
                if (_download) {
                    [_download setTarget:Target];
                    [buttonsArray addObject:_download];
                }else{
                    _download =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_download setAutoresizesSubviews:YES];
                    [_download setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_download setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_download"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_download"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_download_hover"]];
                    [_download setToolTip:CustomLocalizedString(@"Menu_ToPc", nil)];
                    [_download setTag:1004];
                    [_download setTarget:Target];
                    [_download setAction:@selector(downloadToMac:)];
                    [buttonsArray addObject:_download];
                }
            }
                break;
            case ToiCloudFunction:
            {
                if (_toiCloud) {
                    [_toiCloud setTarget:Target];
                    [buttonsArray addObject:_toiCloud];
                }else{
                    _toiCloud =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_toiCloud setAutoresizesSubviews:YES];
                    [_toiCloud setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_toiCloud setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_tocloud"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_tocloud"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_tocloud_hover"]];
                    [_toiCloud setToolTip:CustomLocalizedString(@"Menu_ToiCloud", nil)];
                    [_toiCloud setTag:1005];
                    [_toiCloud setTarget:Target];
                    [_toiCloud setAction:@selector(toiCloud:)];
                    [buttonsArray addObject:_toiCloud];
                }
            }
                break;
            case RenameFunctionType:
            {
                if (_rename) {
                    [_rename setTarget:Target];
                    [buttonsArray addObject:_rename];
                }else{
                    _rename =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_rename setAutoresizesSubviews:YES];
                    [_rename setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_rename setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_rename"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_rename"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_rename_hover"]];
                    [_rename setToolTip:CustomLocalizedString(@"Menu_rename", nil)];
                    [_rename setTag:1005];
                    [_rename setTarget:Target];
                    [_rename setAction:@selector(rename:)];
                    [buttonsArray addObject:_rename];
                }
            }
                break;
            case DeviceDatailFunctionType:
            {
                if (_deviceDatail) {
                    [_deviceDatail setTarget:Target];
                    [buttonsArray addObject:_deviceDatail];
                }else{
                    _deviceDatail =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_deviceDatail setAutoresizesSubviews:YES];
                    [_deviceDatail setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_deviceDatail setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_getinfo"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_getinfo"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_getinfo_hover"]];
                    [_deviceDatail setToolTip:CustomLocalizedString(@"Menu_deviceDetail", nil)];
                    [_deviceDatail setTag:1005];
                    [_deviceDatail setTarget:Target];
                    [_deviceDatail setAction:@selector(showDetailView:)];
                    [buttonsArray addObject:_deviceDatail];
                }
            }
                break;
            case NewGroupFuntion:
            {
                if (_newgroup) {
                    [_newgroup setTarget:Target];
                    [buttonsArray addObject:_newgroup];
                }else{
                    _newgroup =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_newgroup setAutoresizesSubviews:YES];
                    [_newgroup setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_newgroup setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_newfloder"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_newfloder"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_newfloder_hover"]];
                    [_newgroup setToolTip:CustomLocalizedString(@"Menu_newGroup", nil)];
                    [_newgroup setTag:1005];
                    [_newgroup setTarget:Target];
                    [_newgroup setAction:@selector(createNewFloder:)];
                    [buttonsArray addObject:_newgroup];
                }
            }
                break;
            case MoveFileFuntion:
            {
                if (_moveFile) {
                    [_moveFile setTarget:Target];
                    [buttonsArray addObject:_moveFile];
                }else{
                    _moveFile =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_moveFile setAutoresizesSubviews:YES];
                    [_moveFile setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_moveFile setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_moveto"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_moveto"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_moveto_hover"]];
                    [_moveFile setToolTip:CustomLocalizedString(@"Menu_newGroup", nil)];
                    [_moveFile setTag:1005];
                    [_moveFile setTarget:Target];
                    [_moveFile setAction:@selector(moveToFolder:)];
                    [buttonsArray addObject:_moveFile];
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
