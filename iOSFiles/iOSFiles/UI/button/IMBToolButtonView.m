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
#import "IMBMainPageViewController.h"

#define OperationButtonWidth  30
#define OperationButtonHeight 30
#define OperationButtonSeparationWidth 10

@implementation IMBToolButtonView
@synthesize delegate = _delegate;
@synthesize switchButton = _switchButton;

- (void)toolBarButtonIsEnabled:(BOOL) isenabled{
    if (!isenabled) {
        [_reload setStatus:4];
        [_add setStatus:4];
        [_iCloudAdd setStatus:4];
        [_delete setStatus:4];
        [_sortBtn setStatus:4];
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
        [_moveFile setStatus:4];
        [_switchButton setStatus:4];
        [_preBtn setStatus:4];
    }else{
        [_syncTransfer setStatus:1];
        [_newgroup setStatus:1];
        [_reload setStatus:1];
        [_add setStatus:1];
        [_iCloudAdd setStatus:1];
        [_delete setStatus:1];
        [_sortBtn setStatus:1];
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
        [_moveFile setStatus:1];
        [_switchButton setStatus:1];
        [_preBtn setStatus:1];
    }
    [_reload setEnabled:isenabled];
    [_add setEnabled:isenabled];
    [_iCloudAdd setEnabled:isenabled];
    [_delete setEnabled:isenabled];
    [_sortBtn setEnabled:isenabled];
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
    [_moveFile setEnabled:isenabled];
    [_switchButton setEnabled:isenabled];
    [_preBtn setEnabled:isenabled];
    
    [_reload setNeedsDisplay:YES];
    [_add setNeedsDisplay:YES];
    [_iCloudAdd setNeedsDisplay:YES];
    [_delete setNeedsDisplay:YES];
    [_sortBtn setNeedsDisplay:YES];
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
    [_moveFile setNeedsDisplay:YES];
    [_switchButton setNeedsDisplay:YES];
    [_preBtn setNeedsDisplay:YES];
}

- (void)dealloc {
    [_upload release],_upload = nil;
    [_download release],_download = nil;
    [_moveFile release],_moveFile = nil;
    [_switchButton release],_switchButton = nil;
    [_createAlbum release],_createAlbum = nil;
    [_rename release],_rename = nil;
    [_newgroup release],_newgroup = nil;
    [_syncTransfer release],_syncTransfer = nil;
    [_reload release],_reload = nil;
    [_add release],_add = nil;
    [_iCloudAdd release],_iCloudAdd = nil;
    [_delete release],_delete = nil;
    [_sortBtn release],_sortBtn = nil;
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
                    [_reload setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_refresh_hover"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_refresh"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_refresh_hover"]];
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
                    [_add setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_upload_hover"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_upload"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_upload_hover"]];
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
                    [_delete setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_del_hover"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_del"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_del_hover"]];
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
                    [_toMac setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_download_hover"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_download"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_download_hover"]];
                    [_toMac setToolTip:CustomLocalizedString(@"Menu_ToPc", nil)];
                    [_toMac setTag:1003];
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
                    [_toDevice setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_todevice_hover"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_todevice"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_todevice_hover"]];
                    [_toDevice setToolTip:CustomLocalizedString(@"Menu_ToDevice", nil)];
                    [_toDevice setTag:1004];
                    [_toDevice setTarget:Target];
                    [_toDevice setAction:@selector(toDevice:)];
                    [buttonsArray addObject:_toDevice];
                }
            }
                break;
            case UpLoadFunction:
            {
                if (_upload) {
                    [_upload setTarget:Target];
                    [buttonsArray addObject:_upload];
                }else{
                    _upload =[[HoverButton alloc] initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_upload setAutoresizesSubviews:YES];
                    [_upload setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_upload setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_upload_hover"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_upload"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_upload_hover"]];
                    [_upload setToolTip:CustomLocalizedString(@"Common_id_7", nil)];
                    [_upload setTag:1005];
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
                    [_download setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_download_hover"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_download"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_download_hover"]];
                    [_download setToolTip:CustomLocalizedString(@"Menu_ToPc", nil)];
                    [_download setTag:1006];
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
                    [_toiCloud setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_tocloud_hover"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_tocloud"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_tocloud_hover"]];
                    [_toiCloud setToolTip:CustomLocalizedString(@"Common_id_20", nil)];
                    [_toiCloud setTag:1007];
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
                    [_rename setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_rename_hover"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_rename"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_rename_hover"]];
                    [_rename setToolTip:CustomLocalizedString(@"Common_id_8", nil)];
                    [_rename setTag:1008];
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
                    [_deviceDatail setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_getinfo_hover"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_getinfo"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_getinfo_hover"]];
                    [_deviceDatail setToolTip:CustomLocalizedString(@"Common_id_2", nil)];
                    [_deviceDatail setTag:1009];
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
                    [_newgroup setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_newfloder_hover"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_newfloder"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_newfloder_hover"]];
                    [_newgroup setToolTip:CustomLocalizedString(@"Common_id_19", nil)];
                    [_newgroup setTag:1010];
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
                    [_moveFile setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_moveto_hover"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_moveto"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_moveto_hover"]];
                    [_moveFile setToolTip:CustomLocalizedString(@"Common_id_12", nil)];
                    [_moveFile setTag:1011];
                    [_moveFile setTarget:Target];
                    [_moveFile setAction:@selector(moveToFolder:)];
                    [buttonsArray addObject:_moveFile];
                }
            }
                break;
            case SortFunctionType:
            {
                isHave = YES;
                if (_sortBtn) {
                    [_sortBtn setTarget:Target];
                    [buttonsArray addObject:_sortBtn];
                    
                }else{
                    _sortBtn  = [[HoverButton alloc] initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_sortBtn setAutoresizesSubviews:YES];
                    [_sortBtn setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_sortBtn setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_sort_hover"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_sort"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_sort_hover"]];
                    [_sortBtn setToolTip:CustomLocalizedString(@"Common_sort_23", nil)];
                    [_sortBtn setTag:1012];
                    [_sortBtn setTarget:Target];
                    [_sortBtn setAction:@selector(sortBtnClick:)];
                    [buttonsArray addObject:_sortBtn];
                    
                }
            }
                break;
            case SwitchFunctionType:
            {
                if (_switchButton) {
                    if (displayMode) {
                        [_switchButton setSwitchBtnState:1];
                        [_switchButton setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_list1"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_list1_selected"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_list1"]];
                    }else {
                        [_switchButton setSwitchBtnState:0];
                        [_switchButton setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_list2"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_list2_selected"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_list2"]];
                    }
                    [_switchButton setTarget:Target];
                    [buttonsArray addObject:_switchButton];
                    
                }else{
                    _switchButton  = [[HoverButton alloc] initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_switchButton setAutoresizesSubviews:YES];
                    [_switchButton setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    if (displayMode) {
                        [_switchButton setSwitchBtnState:1];
                        [_switchButton setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_list1_selected"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_list1_selected"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_list1"]];
                    }else {
                        [_switchButton setSwitchBtnState:0];
                        [_switchButton setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_list2_selected"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_list2_selected"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_list2"]];
                    }
                    [_switchButton setTag:1013];
                    [_switchButton setTarget:Target];
                    [_switchButton setAction:@selector(doSwitchView:)];
                    [buttonsArray addObject:_switchButton];
                    
                }
            }
                break;
            case PreviewFunctionType:
            {
                if (_preBtn) {
                    [_preBtn setTarget:Target];
                    [buttonsArray addObject:_preBtn];
                    
                }else{
                    _preBtn  = [[HoverButton alloc] initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_preBtn setAutoresizesSubviews:YES];
                    [_preBtn setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_preBtn setMouseEnteredImage:[StringHelper imageNamed:@"toolbar_icon_preview_hover"] mouseExitImage:[StringHelper imageNamed:@"toolbar_icon_preview"] mouseDownImage:[StringHelper imageNamed:@"toolbar_icon_preview_hover"]];
                    [_preBtn setToolTip:CustomLocalizedString(@"Common_id_3", nil)];
                    [_preBtn setTag:1014];
                    [_preBtn setTarget:Target];
                    [_preBtn setAction:@selector(preBtnClick:)];
                    [buttonsArray addObject:_preBtn];
                    
                }
            }
                break;
        }
    }
    for (int i=0;i<[buttonsArray count];i++) {
        HoverButton *button = [buttonsArray objectAtIndex:i];
        float ox = NSWidth(self.frame) - OperationButtonSeparationWidth - ([buttonsArray count] - i)*OperationButtonWidth - ([buttonsArray count] - (i+1))*OperationButtonSeparationWidth;
        ox = ox - 22;
        if (isHave && button.tag == 1012) {
            if (_lineView != nil) {
                [_lineView removeFromSuperview];
            }
            _lineView = [[IMBWhiteView alloc] initWithFrame:NSMakeRect(ox + 4, 8, 1, 30)];
            [_lineView setBackgroundColor:COLOR_TEXT_LINE];
            [self addSubview:_lineView];
            ox = ox + 16;
        } else if (button.tag == 1013) {
            ox = ox + 16;
        }
        [button setFrameOrigin:NSMakePoint(ox, (NSHeight(self.frame) - OperationButtonHeight)/2)];
        [self addSubview:button];
    }
}

- (void)toMac:(id)sender {
    [_delegate toMac:nil];
}



@end
