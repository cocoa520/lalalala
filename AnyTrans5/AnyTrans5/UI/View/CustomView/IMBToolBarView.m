//
//  IMBToolBarView.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-14.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBToolBarView.h"
#import "HoverButton.h"
#import "IMBBaseViewController.h"
#import "IMBSegmentedBtn.h"
#import "HoverButton.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
#import "ColorHelper.h"
#define OperationButtonWidth  36
#define OperationButtonHeight 22
#define OperationButtonSeparationWidth 10
@implementation IMBToolBarView
@synthesize toDevice = _toDevice;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
}

-(void) changeBtnTooltipStr{
    [_reload setToolTip:CustomLocalizedString(@"Common_id_1", nil)];
    [_add setToolTip:CustomLocalizedString(@"Common_id_7", nil)];
    [_delete setToolTip:CustomLocalizedString(@"Common_id_9", nil)];
    [_toiTunes setToolTip:CustomLocalizedString(@"Menu_ToiTunes", nil)];
    [_toMac setToolTip:CustomLocalizedString(@"Menu_ToPc", nil)];
    [_toDevice setToolTip:CustomLocalizedString(@"Menu_ToDevice", nil)];
    [_androidtoiOS setToolTip:CustomLocalizedString(@"Menu_ToDevice", nil)];
    [_deviceDatail setToolTip:CustomLocalizedString(@"Menu_DeviceDetail", nil)];
    [_setting setToolTip:CustomLocalizedString(@"Menu_Setting", nil)];
    [_exit setToolTip:CustomLocalizedString(@"Menu_Exit", nil)];
    [_edit setToolTip:CustomLocalizedString(@"Menu_Edit", nil)];
    [_backup setToolTip:CustomLocalizedString(@"backuppagebtntooltip_id", nil)];
    [_icloud setToolTip:CustomLocalizedString(@"MainWindow_id_6", nil)];
    [_back setToolTip:CustomLocalizedString(@"Menu_Back", nil)];
    [_find setToolTip:CustomLocalizedString(@"Menu_Find", nil)];
    [_contactImport setToolTip:CustomLocalizedString(@"Menu_Import_Contact", nil)];
    [_toContact setToolTip:CustomLocalizedString(@"Menu_To_Contact", nil)];
    if (_upload.tag == 1111) {
        [_upload setToolTip:CustomLocalizedString(@"device_toIcloud_title", nil)];
    }else{
        [_upload setToolTip:CustomLocalizedString(@"icloud_upLoad", nil)];
    }
    
    
}
//返回按钮应放在数组最后一位
- (void)loadButtons:(NSArray *)FunctionTypeArray Target:(IMBBaseViewController *)Target DisplayMode:(BOOL)displayMode
{
    NSArray *array = [NSArray arrayWithArray:self.subviews];
    if (array != nil) {
        for (NSView *view in array) {
            if ([view isKindOfClass:[HoverButton class]] || [view isKindOfClass:[IMBSegmentedBtn class]]) {
                [view removeFromSuperview];
            }
        }
    }
    NSMutableArray *buttonsArray = [NSMutableArray array];
    BOOL isHave = NO;
    BOOL isBack = NO;
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
                
            case ToiTunesFunctionType:
            {
                if (_toiTunes) {
                    [_toiTunes setTarget:Target];
                    [buttonsArray addObject:_toiTunes];
                }else{
                    _toiTunes =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_toiTunes setAutoresizesSubviews:YES];
                    [_toiTunes setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_toiTunes setMouseEnteredImage:[StringHelper imageNamed:@"tool_toitunes_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_toitunes_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_toitunes_normal"]];
                    [_toiTunes setIsDrawBorder:YES];
                    [_toiTunes setToolTip:CustomLocalizedString(@"Menu_ToiTunes", nil)];
                    [_toiTunes setTag:1003];
                    [_toiTunes setTarget:Target];
                    [_toiTunes setAction:@selector(toiTunes:)];
                    [buttonsArray addObject:_toiTunes];
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
                
            case DeviceDatailFunctionType:
            {
                if (_deviceDatail) {
                    [_deviceDatail setTarget:Target];
                    [buttonsArray addObject:_deviceDatail];
                }else{
                    _deviceDatail =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_deviceDatail setAutoresizesSubviews:YES];
                    [_deviceDatail setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_deviceDatail setMouseEnteredImage:[StringHelper imageNamed:@"tool_information_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_information_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_information_normal"]];
                    [_deviceDatail setIsDrawBorder:YES];
                    [_deviceDatail setToolTip:CustomLocalizedString(@"Menu_DeviceDetail", nil)];
                    [_deviceDatail setTag:1006];
                    [_deviceDatail setTarget:Target];
                    [_deviceDatail setAction:@selector(doDeviceDetail:)];
                    [buttonsArray addObject:_deviceDatail];
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
            case ExitFunctionType:
            {
                if (_exit) {
                    [_exit setTarget:Target];
                    [buttonsArray addObject:_exit];
                }else{
                    _exit =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_exit setAutoresizesSubviews:YES];
                    [_exit setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_exit setMouseEnteredImage:[StringHelper imageNamed:@"tool_exit_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_exit_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_exit_normal"]];
                    [_exit setIsDrawBorder:YES];
                    [_exit setToolTip:CustomLocalizedString(@"Menu_Exit", nil)];
                    [_exit setTag:1008];
                    [_exit setTarget:Target];
                    [_exit setAction:@selector(doExit:)];
                    [buttonsArray addObject:_exit];
                }
                break;
            }
            case EditFunctionType:
            {
                if (_edit) {
                    [_edit setTarget:Target];
                    [buttonsArray addObject:_edit];
                }else{
                    _edit =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_edit setAutoresizesSubviews:YES];
                    [_edit setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_edit setMouseEnteredImage:[StringHelper imageNamed:@"tool_editor_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_editor_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_editor_normal"]];
                    [_edit setIsDrawBorder:YES];
                    [_edit setToolTip:CustomLocalizedString(@"Menu_Edit", nil)];
                    [_edit setTag:1009];
                    [_edit setTarget:Target];
                    [_edit setAction:@selector(doEdit:)];
                    [buttonsArray addObject:_edit];
                }
            }
                break;
            case BackupFunctionType:
            {
                if (_back) {
                    [_backup setTarget:Target];
                    [buttonsArray addObject:_backup];
                }else{
                    _backup =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_backup setAutoresizesSubviews:YES];
                    [_backup setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_backup setMouseEnteredImage:[StringHelper imageNamed:@"tool_backup_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_backup_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_backup_normal"]];
                    [_backup setIsDrawBorder:YES];
                    [_backup setToolTip:CustomLocalizedString(@"backuppagebtntooltip_id", nil)];
                    [_backup setTag:1010];
                    [_backup setTarget:Target];
                    [_backup setAction:@selector(doBackup:)];
                    [buttonsArray addObject:_backup];
                }
            }
                break;
            case ExitiCloudFunctionType:
            {
                if (_icloud) {
                    [_icloud setTarget:Target];
                    [buttonsArray addObject:_icloud];
                }else{
                    _icloud =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_icloud setAutoresizesSubviews:YES];
                    [_icloud setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_icloud setMouseEnteredImage:[StringHelper imageNamed:@"tool_iCloudexit_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_iCloudexit_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_iCloudexit_normal"]];
                    [_icloud setIsDrawBorder:YES];
                    [_icloud setToolTip:CustomLocalizedString(@"MainWindow_id_6", nil)];
                    [_icloud setTag:1011];
                    [_icloud setTarget:Target];
                    [_icloud setAction:@selector(doExitiCloud:)];
                    [buttonsArray addObject:_icloud];
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
            case BackFunctionType:
            {
                if (_back) {
                    isBack = YES;
                    [_back setTarget:Target];
                    [buttonsArray addObject:_back];
                }else{
                    _back =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    isBack = YES;
                    [_back setAutoresizesSubviews:YES];
                    [_back setAutoresizingMask:NSViewMaxYMargin|NSViewMaxXMargin];
                    [_back setMouseEnteredImage:[StringHelper imageNamed:@"tool_back_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_back_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_back_normal"]];
                    [_back setIsDrawBorder:YES];
                    [_back setTag:100];
                    [_back setToolTip:CustomLocalizedString(@"Menu_Back", nil)];
                    [_back setTarget:Target];
                    [_back setAction:@selector(doBack:)];
                    [buttonsArray addObject:_back];
                    [_back release];
                }
            }
                break;
            case FindFunctionType:
            {
                if (_find) {
                    [_find setTarget:Target];
                    [buttonsArray addObject:_find];
                }else{
                    _find =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_find setAutoresizesSubviews:YES];
                    [_find setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_find setMouseEnteredImage:[StringHelper imageNamed:@"tool_find_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_find_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_find_normal"]];
                    [_find setIsDrawBorder:YES];
                    [_find setToolTip:CustomLocalizedString(@"Menu_Find", nil)];
                    [_find setTag:1013];
                    [_find setTarget:Target];
                    [_find setAction:@selector(dofindPath:)];
                    [buttonsArray addObject:_find];
                }
            }
                break;
            case ContactImportFunction:
            {
                if (_contactImport) {
                    [_contactImport setTarget:Target];
                    [buttonsArray addObject:_contactImport];
                }else{
                    _contactImport =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_contactImport setAutoresizesSubviews:YES];
                    [_contactImport setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_contactImport setMouseEnteredImage:[StringHelper imageNamed:@"tool_import_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_import_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_import_normal"]];
                    [_contactImport setIsDrawBorder:YES];
                    [_contactImport setToolTip:CustomLocalizedString(@"Menu_Import_Contact", nil)];
                    [_contactImport setTag:1014];
                    [_contactImport setTarget:Target];
                    [_contactImport setAction:@selector(doImportContact:)];
                    [buttonsArray addObject:_contactImport];
                }
            }
                break;
            case ToContactFunction:
            {
                if (_toContact) {
                    [_toContact setTarget:Target];
                    [buttonsArray addObject:_toContact];
                }else{
                    _toContact =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_toContact setAutoresizesSubviews:YES];
                    [_toContact setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_toContact setMouseEnteredImage:[StringHelper imageNamed:@"tool_to_contacts"] mouseExitImage:[StringHelper imageNamed:@"tool_to_contacts"] mouseDownImage:[StringHelper imageNamed:@"tool_to_contacts"]];
                    [_toContact setIsDrawBorder:YES];
                    [_toContact setToolTip:CustomLocalizedString(@"Menu_To_Contact", nil)];
                    [_toContact setTag:1015];
                    [_toContact setTarget:Target];
                    [_toContact setAction:@selector(doToContact:)];
                    [buttonsArray addObject:_toContact];
                }
            }
                break;
        }
    }
    for (int i=0;i<[buttonsArray count];i++) {
        HoverButton *button = [buttonsArray objectAtIndex:i];
        if (button.tag == 100) {
            [button setFrameOrigin:NSMakePoint(16, (NSHeight(self.frame) - OperationButtonHeight)/2)];
        }else {
            float ox = 0;
            if (isBack) {
                ox = NSWidth(self.frame) - OperationButtonSeparationWidth - ([buttonsArray count] - 1 - i)*OperationButtonWidth - ([buttonsArray count] - 1 - (i+1))*OperationButtonSeparationWidth;
            }else {
                ox = NSWidth(self.frame) - OperationButtonSeparationWidth - ([buttonsArray count] - i)*OperationButtonWidth - ([buttonsArray count] - (i+1))*OperationButtonSeparationWidth;
            }
            if (isHave) {
                ox = ox - 24;
            }
            [button setFrameOrigin:NSMakePoint(ox, (NSHeight(self.frame) - OperationButtonHeight)/2)];
        }
        [self addSubview:button];
    }
    
}
//返回按钮应放在数组最后一位
- (void)loadiCloudButtons:(NSArray *)FunctionTypeArray Target:(IMBBaseViewController *)Target DisplayMode:(BOOL)displayMode
{
    NSArray *array = [NSArray arrayWithArray:self.subviews];
    if (array != nil) {
        for (NSView *view in array) {
            if ([view isKindOfClass:[HoverButton class]] || [view isKindOfClass:[IMBSegmentedBtn class]]) {
                [view removeFromSuperview];
            }
        }
    }
    NSMutableArray *buttonsArray = [NSMutableArray array];
    BOOL isHave = NO;
    BOOL isBack = NO;
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
                    [_reload setAction:@selector(iCloudReload:)];
                    [buttonsArray addObject:_reload];
                }
            }
                break;
                
            case AddFunctionType:
            {
                if (_iCloudAdd) {
                    [_iCloudAdd setTarget:Target];
                    [buttonsArray addObject:_iCloudAdd];
                }else{
                    _iCloudAdd =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_iCloudAdd setAutoresizesSubviews:YES];
                    [_iCloudAdd setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_iCloudAdd setMouseEnteredImage:[StringHelper imageNamed:@"iCloud_addfiles"] mouseExitImage:[StringHelper imageNamed:@"iCloud_addfiles"] mouseDownImage:[StringHelper imageNamed:@"iCloud_addfiles"]];
                    [_iCloudAdd setIsDrawBorder:YES];
                    [_iCloudAdd setToolTip:CustomLocalizedString(@"Common_id_7", nil)];
                    [_iCloudAdd setTag:1001];
                    [_iCloudAdd setTarget:Target];
                    [_iCloudAdd setAction:@selector(addiCloudItems:)];
                    [buttonsArray addObject:_iCloudAdd];
                }
            }
                break;
            case BackFunctionType:
            {
                if (_back) {
                    isBack = YES;
                    [_back setTarget:Target];
                    [buttonsArray addObject:_back];
                }else{
                    _back =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    isBack = YES;
                    [_back setAutoresizesSubviews:YES];
                    [_back setAutoresizingMask:NSViewMaxYMargin|NSViewMaxXMargin];
                    [_back setMouseEnteredImage:[StringHelper imageNamed:@"tool_back_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_back_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_back_normal"]];
                    [_back setIsDrawBorder:YES];
                    [_back setTag:100];
                    [_back setToolTip:CustomLocalizedString(@"Menu_Back", nil)];
                    [_back setTarget:Target];
                    [_back setAction:@selector(doBack:)];
                    [buttonsArray addObject:_back];
                    [_back release];
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
                    [_delete setAction:@selector(deleteiCloudItems:)];
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
                    [_toMac setTarget:Target];
                    [_toMac setAction:@selector(iClouditemtoMac:)];
                    [buttonsArray addObject:_toMac];
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
                
            case EditFunctionType:
            {
                if (_edit) {
                    [_edit setTarget:Target];
                    [buttonsArray addObject:_edit];
                }else{
                    _edit =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_edit setAutoresizesSubviews:YES];
                    [_edit setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_edit setMouseEnteredImage:[StringHelper imageNamed:@"tool_editor_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_editor_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_editor_normal"]];
                    [_edit setIsDrawBorder:YES];
                    [_edit setToolTip:CustomLocalizedString(@"Menu_Edit", nil)];
                    [_edit setTag:1009];
                    [_edit setTarget:Target];
                    [_edit setAction:@selector(doiClouditemEdit:)];
                    [buttonsArray addObject:_edit];
                }
            }
                break;
                
            case ExitiCloudFunctionType:
            {
                if (_icloud) {
                    [_icloud setTarget:Target];
                    [buttonsArray addObject:_icloud];
                }else{
                    _icloud =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_icloud setAutoresizesSubviews:YES];
                    [_icloud setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_icloud setMouseEnteredImage:[StringHelper imageNamed:@"tool_iCloudexit_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_iCloudexit_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_iCloudexit_normal"]];
                    [_icloud setIsDrawBorder:YES];
                    [_icloud setToolTip:CustomLocalizedString(@"MainWindow_id_6", nil)];
                    [_icloud setTag:1011];
                    [_icloud setTarget:Target];
                    [_icloud setAction:@selector(doExitiCloud:)];
                    [buttonsArray addObject:_icloud];
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
                
                
            case ContactImportFunction:
            {
                if (_contactImport) {
                    [_contactImport setTarget:Target];
                    [buttonsArray addObject:_contactImport];
                }else{
                    _contactImport =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_contactImport setAutoresizesSubviews:YES];
                    [_contactImport setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_contactImport setMouseEnteredImage:[StringHelper imageNamed:@"tool_import_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_import_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_import_normal"]];
                    [_contactImport setIsDrawBorder:YES];
                    [_contactImport setToolTip:CustomLocalizedString(@"Menu_Import_Contact", nil)];
                    [_contactImport setTag:1014];
                    [_contactImport setTarget:Target];
                    [_contactImport setAction:@selector(doiCloudImportContact:)];
                    [buttonsArray addObject:_contactImport];
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
                    [_upload setMouseEnteredImage:[StringHelper imageNamed:@"iCloud_addfiles"] mouseExitImage:[StringHelper imageNamed:@"iCloud_addfiles"] mouseDownImage:[StringHelper imageNamed:@"iCloud_addfiles"]];
                    [_upload setIsDrawBorder:YES];
                    [_upload setToolTip:CustomLocalizedString(@"icloud_upLoad", nil)];
                    [_upload setTag:1015];
                    [_upload setTarget:Target];
                    [_upload setAction:@selector(upLoad:)];
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
                    [_download setMouseEnteredImage:[StringHelper imageNamed:@"iCloud_download"] mouseExitImage:[StringHelper imageNamed:@"iCloud_download"] mouseDownImage:[StringHelper imageNamed:@"iCloud_download"]];
                    [_download setIsDrawBorder:YES];
                    [_download setToolTip:CustomLocalizedString(@"icloud_DownLoad", nil)];
                    [_download setTag:1016];
                    [_download setTarget:Target];
                    [_download setAction:@selector(downLoad:)];
                    [buttonsArray addObject:_download];
                }

            }
                break;
            case MovePictureFuntion:
            {
                if (_movePicture) {
                    [_movePicture setTarget:Target];
                    [buttonsArray addObject:_movePicture];
                }else{
                    _movePicture =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_movePicture setAutoresizesSubviews:YES];
                    [_movePicture setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_movePicture setMouseEnteredImage:[StringHelper imageNamed:@"tool_import_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_import_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_import_normal"]];
                    [_movePicture setIsDrawBorder:YES];
                    [_movePicture setToolTip:CustomLocalizedString(@"Menu_Import_Contact", nil)];
                    [_movePicture setTag:1017];
                    [_movePicture setTarget:Target];
                    [_movePicture setAction:@selector(movePicture:)];
                    [buttonsArray addObject:_movePicture];
                }

            }
                break;
            case CreateAlbumFuntion:
            {
                if (_createAlbum) {
                    [_createAlbum setTarget:Target];
                    [buttonsArray addObject:_createAlbum];
                }else{
                    _createAlbum =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_createAlbum setAutoresizesSubviews:YES];
                    [_createAlbum setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_createAlbum setMouseEnteredImage:[StringHelper imageNamed:@"iCloud_addfolder"] mouseExitImage:[StringHelper imageNamed:@"iCloud_addfolder"] mouseDownImage:[StringHelper imageNamed:@"iCloud_addfolder"]];
                    [_createAlbum setIsDrawBorder:YES];
                    [_createAlbum setToolTip:CustomLocalizedString(@"icloud_greateFile", nil)];
                    [_createAlbum setTag:1018];
                    [_createAlbum setTarget:Target];
                    [_createAlbum setAction:@selector(createAlbum:)];
                    [buttonsArray addObject:_createAlbum];
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
                    [_newgroup setMouseEnteredImage:[StringHelper imageNamed:@"tool_import_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_import_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_import_normal"]];
                    [_newgroup setIsDrawBorder:YES];
                    [_newgroup setToolTip:CustomLocalizedString(@"Menu_Import_Contact", nil)];
                    [_newgroup setTag:1019];
                    [_newgroup setTarget:Target];
                    [_newgroup setAction:@selector(newGroup:)];
                    [buttonsArray addObject:_newgroup];
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
                
            case SyncTransferFuntion:
            {
                if (_syncTransfer) {
                    [_syncTransfer setTarget:Target];
                    [buttonsArray addObject:_syncTransfer];
                }else{
                    _syncTransfer =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_syncTransfer setAutoresizesSubviews:YES];
                    [_syncTransfer setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_syncTransfer setMouseEnteredImage:[StringHelper imageNamed:@"iCloud_toiCloud"] mouseExitImage:[StringHelper imageNamed:@"iCloud_toiCloud"] mouseDownImage:[StringHelper imageNamed:@"iCloud_toiCloud"]];
                    [_syncTransfer setIsDrawBorder:YES];
                    [_syncTransfer setToolTip:CustomLocalizedString(@"icloud_toiCloud", nil)];
                    [_syncTransfer setTag:1020];
                    [_syncTransfer setTarget:Target];
                    [_syncTransfer setAction:@selector(iCloudSyncTransfer:)];
                    [buttonsArray addObject:_syncTransfer];
                }
                
            }
                break;
        }
    }
    for (int i=0;i<[buttonsArray count];i++) {
        HoverButton *button = [buttonsArray objectAtIndex:i];
        if (button.tag == 100) {
            [button setFrameOrigin:NSMakePoint(16, (NSHeight(self.frame) - OperationButtonHeight)/2)];
        }else {
            float ox = 0;
            if (isBack) {
                ox = NSWidth(self.frame) - OperationButtonSeparationWidth - ([buttonsArray count] - 1 - i)*OperationButtonWidth - ([buttonsArray count] - 1 - (i+1))*OperationButtonSeparationWidth;
            }else {
                ox = NSWidth(self.frame) - OperationButtonSeparationWidth - ([buttonsArray count] - i)*OperationButtonWidth - ([buttonsArray count] - (i+1))*OperationButtonSeparationWidth;
            }
            if (isHave) {
                ox = ox - 24;
            }
            [button setFrameOrigin:NSMakePoint(ox, (NSHeight(self.frame) - OperationButtonHeight)/2)];
        }
        [self addSubview:button];
    }

}

//返回按钮应放在数组最后一位
- (void)loadAndriodButtons:(NSArray *)FunctionTypeArray Target:(IMBBaseViewController *)Target DisplayMode:(BOOL)displayMode
{
    NSArray *array = [NSArray arrayWithArray:self.subviews];
    if (array != nil) {
        for (NSView *view in array) {
            if ([view isKindOfClass:[HoverButton class]] || [view isKindOfClass:[IMBSegmentedBtn class]]) {
                [view removeFromSuperview];
            }
        }
    }
    NSMutableArray *buttonsArray = [NSMutableArray array];
    BOOL isHave = NO;
    BOOL isBack = NO;
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
                    [_reload setAction:@selector(androidReload:)];
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
                
            case ToiTunesFunctionType:
            {
                if (_toiTunes) {
                    [_toiTunes setTarget:Target];
                    [buttonsArray addObject:_toiTunes];
                }else{
                    _toiTunes =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_toiTunes setAutoresizesSubviews:YES];
                    [_toiTunes setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_toiTunes setMouseEnteredImage:[StringHelper imageNamed:@"toios_toitunes_normal"] mouseExitImage:[StringHelper imageNamed:@"toios_toitunes_normal"] mouseDownImage:[StringHelper imageNamed:@"toios_toitunes_normal"]];
                    [_toiTunes setIsDrawBorder:YES];
                    [_toiTunes setToolTip:CustomLocalizedString(@"Menu_ToiTunes", nil)];
                    [_toiTunes setTag:1003];
                    [_toiTunes setTarget:Target];
                    [_toiTunes setAction:@selector(androidToiTunes:)];
                    [buttonsArray addObject:_toiTunes];
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
                    [_toMac setTarget:Target];
                    [_toMac setAction:@selector(toMac:)];
                    [buttonsArray addObject:_toMac];
                }
            }
                break;
                
            case ToDeviceFunctionType:
            {
                if (_androidtoiOS) {
                    [_androidtoiOS setTarget:Target];
                    [buttonsArray addObject:_androidtoiOS];
                }else{
                    _androidtoiOS =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_androidtoiOS setAutoresizesSubviews:YES];
                    [_androidtoiOS setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_androidtoiOS setMouseEnteredImage:[StringHelper imageNamed:@"toios_todevice_normal"] mouseExitImage:[StringHelper imageNamed:@"toios_todevice_normal"] mouseDownImage:[StringHelper imageNamed:@"toios_todevice_normal"]];
                    [_androidtoiOS setIsDrawBorder:YES];
                    [_androidtoiOS setToolTip:CustomLocalizedString(@"Menu_ToDevice", nil)];
                    [_androidtoiOS setTag:1005];
                    [_androidtoiOS setTarget:Target];
                    [_androidtoiOS setAction:@selector(androidToDevice:)];
                    [buttonsArray addObject:_androidtoiOS];
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
                    [_deviceDatail setMouseEnteredImage:[StringHelper imageNamed:@"tool_information_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_information_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_information_normal"]];
                    [_deviceDatail setIsDrawBorder:YES];
                    [_deviceDatail setToolTip:CustomLocalizedString(@"Menu_DeviceDetail", nil)];
                    [_deviceDatail setTag:1006];
                    [_deviceDatail setTarget:Target];
                    [_deviceDatail setAction:@selector(doDeviceDetail:)];
                    [buttonsArray addObject:_deviceDatail];
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
            case ExitFunctionType:
            {
                if (_exit) {
                    [_exit setTarget:Target];
                    [buttonsArray addObject:_exit];
                }else{
                    _exit =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_exit setAutoresizesSubviews:YES];
                    [_exit setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_exit setMouseEnteredImage:[StringHelper imageNamed:@"tool_exit_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_exit_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_exit_normal"]];
                    [_exit setIsDrawBorder:YES];
                    [_exit setToolTip:CustomLocalizedString(@"Menu_Exit", nil)];
                    [_exit setTag:1008];
                    [_exit setTarget:Target];
                    [_exit setAction:@selector(doExit:)];
                    [buttonsArray addObject:_exit];
                }
                break;
            }
            case EditFunctionType:
            {
                if (_edit) {
                    [_edit setTarget:Target];
                    [buttonsArray addObject:_edit];
                }else{
                    _edit =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_edit setAutoresizesSubviews:YES];
                    [_edit setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_edit setMouseEnteredImage:[StringHelper imageNamed:@"tool_editor_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_editor_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_editor_normal"]];
                    [_edit setIsDrawBorder:YES];
                    [_edit setToolTip:CustomLocalizedString(@"Menu_Edit", nil)];
                    [_edit setTag:1009];
                    [_edit setTarget:Target];
                    [_edit setAction:@selector(doEdit:)];
                    [buttonsArray addObject:_edit];
                }
            }
                break;
            case BackupFunctionType:
            {
                if (_back) {
                    [_backup setTarget:Target];
                    [buttonsArray addObject:_backup];
                }else{
                    _backup =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_backup setAutoresizesSubviews:YES];
                    [_backup setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_backup setMouseEnteredImage:[StringHelper imageNamed:@"tool_backup_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_backup_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_backup_normal"]];
                    [_backup setIsDrawBorder:YES];
                    [_backup setToolTip:CustomLocalizedString(@"backuppagebtntooltip_id", nil)];
                    [_backup setTag:1010];
                    [_backup setTarget:Target];
                    [_backup setAction:@selector(doBackup:)];
                    [buttonsArray addObject:_backup];
                }
            }
                break;
            case ExitiCloudFunctionType:
            {
                if (_icloud) {
                    [_icloud setTarget:Target];
                    [buttonsArray addObject:_icloud];
                }else{
                    _icloud =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_icloud setAutoresizesSubviews:YES];
                    [_icloud setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_icloud setMouseEnteredImage:[StringHelper imageNamed:@"tool_iCloudexit_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_iCloudexit_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_iCloudexit_normal"]];
                    [_icloud setIsDrawBorder:YES];
                    [_icloud setToolTip:CustomLocalizedString(@"MainWindow_id_6", nil)];
                    [_icloud setTag:1011];
                    [_icloud setTarget:Target];
                    [_icloud setAction:@selector(doExitiCloud:)];
                    [buttonsArray addObject:_icloud];
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
                    [_upload setMouseEnteredImage:[StringHelper imageNamed:@"toios_toiCloud_normal"] mouseExitImage:[StringHelper imageNamed:@"toios_toiCloud_normal"] mouseDownImage:[StringHelper imageNamed:@"toios_toiCloud_normal"]];
                    [_upload setIsDrawBorder:YES];
                    [_upload setToolTip:CustomLocalizedString(@"icloud_addAcount", nil)];
                    [_upload setTag:1111];
                    [_upload setTarget:Target];
                    [_upload setAction:@selector(androidToiCloud:)];
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
            case BackFunctionType:
            {
                if (_back) {
                    isBack = YES;
                    [_back setTarget:Target];
                    [buttonsArray addObject:_back];
                }else{
                    _back =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    isBack = YES;
                    [_back setAutoresizesSubviews:YES];
                    [_back setAutoresizingMask:NSViewMaxYMargin|NSViewMaxXMargin];
                    [_back setMouseEnteredImage:[StringHelper imageNamed:@"tool_back_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_back_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_back_normal"]];
                    [_back setIsDrawBorder:YES];
                    [_back setTag:100];
                    [_back setToolTip:CustomLocalizedString(@"Menu_Back", nil)];
                    [_back setTarget:Target];
                    [_back setAction:@selector(doBack:)];
                    [buttonsArray addObject:_back];
                    [_back release];
                }
            }
                break;
            case FindFunctionType:
            {
                if (_find) {
                    [_find setTarget:Target];
                    [buttonsArray addObject:_find];
                }else{
                    _find =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_find setAutoresizesSubviews:YES];
                    [_find setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_find setMouseEnteredImage:[StringHelper imageNamed:@"tool_find_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_find_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_find_normal"]];
                    [_find setIsDrawBorder:YES];
                    [_find setToolTip:CustomLocalizedString(@"Menu_Find", nil)];
                    [_find setTag:1013];
                    [_find setTarget:Target];
                    [_find setAction:@selector(dofindPath:)];
                    [buttonsArray addObject:_find];
                }
            }
                break;
            case ContactImportFunction:
            {
                if (_contactImport) {
                    [_contactImport setTarget:Target];
                    [buttonsArray addObject:_contactImport];
                }else{
                    _contactImport =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_contactImport setAutoresizesSubviews:YES];
                    [_contactImport setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_contactImport setMouseEnteredImage:[StringHelper imageNamed:@"tool_import_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_import_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_import_normal"]];
                    [_contactImport setIsDrawBorder:YES];
                    [_contactImport setToolTip:CustomLocalizedString(@"Menu_Import_Contact", nil)];
                    [_contactImport setTag:1014];
                    [_contactImport setTarget:Target];
                    [_contactImport setAction:@selector(doImportContact:)];
                    [buttonsArray addObject:_contactImport];
                }
            }
                break;
            case ToContactFunction:
            {
                if (_toContact) {
                    [_toContact setTarget:Target];
                    [buttonsArray addObject:_toContact];
                }else{
                    _toContact =[[HoverButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_toContact setAutoresizesSubviews:YES];
                    [_toContact setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_toContact setMouseEnteredImage:[StringHelper imageNamed:@"tool_to_contacts"] mouseExitImage:[StringHelper imageNamed:@"tool_to_contacts"] mouseDownImage:[StringHelper imageNamed:@"tool_to_contacts"]];
                    [_toContact setIsDrawBorder:YES];
                    [_toContact setToolTip:CustomLocalizedString(@"Menu_To_Contact", nil)];
                    [_toContact setTag:1015];
                    [_toContact setTarget:Target];
                    [_toContact setAction:@selector(doToContact:)];
                    [buttonsArray addObject:_toContact];
                }
            }
                break;
        }
    }
    for (int i=0;i<[buttonsArray count];i++) {
        HoverButton *button = [buttonsArray objectAtIndex:i];
        if (button.tag == 100) {
            [button setFrameOrigin:NSMakePoint(16, (NSHeight(self.frame) - OperationButtonHeight)/2)];
        }else {
            float ox = 0;
            if (isBack) {
                ox = NSWidth(self.frame) - OperationButtonSeparationWidth - ([buttonsArray count] - 1 - i)*OperationButtonWidth - ([buttonsArray count] - 1 - (i+1))*OperationButtonSeparationWidth;
            }else {
                ox = NSWidth(self.frame) - OperationButtonSeparationWidth - ([buttonsArray count] - i)*OperationButtonWidth - ([buttonsArray count] - (i+1))*OperationButtonSeparationWidth;
            }
            if (isHave) {
                ox = ox - 24;
            }
            [button setFrameOrigin:NSMakePoint(ox, (NSHeight(self.frame) - OperationButtonHeight)/2)];
        }
        [self addSubview:button];
    }
    
}

- (void)changeSkin:(NSNotification *)notification {
    
    [_reload setMouseEnteredImage:[StringHelper imageNamed:@"tool_refresh_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_refresh_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_refresh_normal"]];
    [_add setMouseEnteredImage:[StringHelper imageNamed:@"tool_add_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_add_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_add_normal"]];
    [_iCloudAdd setMouseEnteredImage:[StringHelper imageNamed:@"iCloud_addfiles"] mouseExitImage:[StringHelper imageNamed:@"iCloud_addfiles"] mouseDownImage:[StringHelper imageNamed:@"iCloud_addfiles"]];
    [_delete setMouseEnteredImage:[StringHelper imageNamed:@"tool_delete_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_delete_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_delete_normal"]];
    [_toiTunes setMouseEnteredImage:[StringHelper imageNamed:@"tool_toitunes_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_toitunes_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_toitunes_normal"]];
    [_toMac setMouseEnteredImage:[StringHelper imageNamed:@"tool_tomac_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_tomac_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_tomac_normal"]];
    [_toDevice setMouseEnteredImage:[StringHelper imageNamed:@"tool_todevice_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_todevice_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_todevice_normal"]];
    [_deviceDatail setMouseEnteredImage:[StringHelper imageNamed:@"tool_information_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_information_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_information_normal"]];
    [_setting setMouseEnteredImage:[StringHelper imageNamed:@"tool_setting_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_setting_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_setting_normal"]];
    [_exit setMouseEnteredImage:[StringHelper imageNamed:@"tool_exit_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_exit_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_exit_normal"]];
    [_edit setMouseEnteredImage:[StringHelper imageNamed:@"tool_editor_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_editor_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_editor_normal"]];
    [_backup setMouseEnteredImage:[StringHelper imageNamed:@"tool_backup_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_backup_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_backup_normal"]];
    [_icloud setMouseEnteredImage:[StringHelper imageNamed:@"tool_iCloudexit_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_iCloudexit_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_iCloudexit_normal"]];
    [_segmentedControl setMouseEnteredImage:[StringHelper imageNamed:@"tool_sel_list_noemal"] mouseExitImage:[StringHelper imageNamed:@"tool_sel_list_noemal"] mouseDownImage:[StringHelper imageNamed:@"tool_sel_list_down"] rightMouseEnteredImage:[StringHelper imageNamed:@"tool_sel_icons_normal"] rightMouseExitImage:[StringHelper imageNamed:@"tool_sel_icons_normal"] rightMouseDownImage:[StringHelper imageNamed:@"tool_sel_icons_down"]];
    [_back setMouseEnteredImage:[StringHelper imageNamed:@"tool_back_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_back_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_back_normal"]];
    [_find setMouseEnteredImage:[StringHelper imageNamed:@"tool_find_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_find_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_find_normal"]];
    [_contactImport setMouseEnteredImage:[StringHelper imageNamed:@"tool_import_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_import_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_import_normal"]];
    [_toContact setMouseEnteredImage:[StringHelper imageNamed:@"tool_to_contacts"] mouseExitImage:[StringHelper imageNamed:@"tool_to_contacts"] mouseDownImage:[StringHelper imageNamed:@"tool_to_contacts"]];
    [_syncTransfer setMouseEnteredImage:[StringHelper imageNamed:@"iCloud_toiCloud"] mouseExitImage:[StringHelper imageNamed:@"iCloud_toiCloud"] mouseDownImage:[StringHelper imageNamed:@"iCloud_toiCloud"]];
    if (_upload.tag == 1111) {
        [_upload setMouseEnteredImage:[StringHelper imageNamed:@"tool_toiCloud_normal"] mouseExitImage:[StringHelper imageNamed:@"tool_toiCloud_normal"] mouseDownImage:[StringHelper imageNamed:@"tool_toiCloud_normal"]];
    } else {
        [_upload setMouseEnteredImage:[StringHelper imageNamed:@"iCloud_addfiles"] mouseExitImage:[StringHelper imageNamed:@"iCloud_addfiles"] mouseDownImage:[StringHelper imageNamed:@"iCloud_addfiles"]];
    }
    [_androidtoiOS setMouseEnteredImage:[StringHelper imageNamed:@"toios_todevice_normal"] mouseExitImage:[StringHelper imageNamed:@"toios_todevice_normal"] mouseDownImage:[StringHelper imageNamed:@"toios_todevice_normal"]];
    [_download setMouseEnteredImage:[StringHelper imageNamed:@"iCloud_download"] mouseExitImage:[StringHelper imageNamed:@"iCloud_download"] mouseDownImage:[StringHelper imageNamed:@"iCloud_download"]];
    [self setNeedsDisplay:YES];
}

- (void)icloudPhotoEnabledReload:(BOOL)isEnable{
    if (!isEnable) {
        [_reload setStatus:4];
    }else{
        [_reload setStatus:1];
    }
    [_reload setEnabled:isEnable];
    [_reload setNeedsDisplay:YES];
}

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

- (void)dealloc
{
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];

}

- (void)drawRect:(NSRect)dirtyRect
{
//    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
//    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
//    
//    [path fill];

    
    [super drawRect:dirtyRect];
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    [[NSColor clearColor] setFill];
    [path fill];
    [ColorHelper setGrientColorWithRect:dirtyRect withCorner:NO withPart:2];
    
    //画底线
    NSBezierPath *bottomBorderPath = [NSBezierPath bezierPath];
    [bottomBorderPath setLineWidth:2.0];
    [bottomBorderPath moveToPoint:NSMakePoint(0, 0)];
    [bottomBorderPath lineToPoint:NSMakePoint(dirtyRect.size.width, 0)];
    [[NSColor clearColor] setStroke];
    [bottomBorderPath stroke];
    [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setStroke];
    [bottomBorderPath stroke];

}


@end
