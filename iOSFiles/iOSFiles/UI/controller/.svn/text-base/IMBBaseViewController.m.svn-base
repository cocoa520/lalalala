//
//  IMBBaseViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBBlankDraggableCollectionView.h"
#import "IMBAirSyncImportTransfer.h"
#import "IMBExportSetting.h"
#import "IMBAnimation.h"
#import "IMBCustomHeaderCell.h"
#import "IMBDeleteTrack.h"
#import "IMBNotificationDefine.h"
#import "IMBFileSystem.h"
#import "IMBBookEntity.h"
#import "IMBSyncBookPlistBuilder.h"
#import "IMBDeleteApps.h"
#import "IMBCategoryInfoModel.h"
#import "SystemHelper.h"
#import "IMBMainWindowController.h"
#import "IMBPhotoExportSettingConfig.h"
#import <objc/runtime.h>
#import "IMBSearchView.h"

@implementation IMBBaseViewController
@synthesize researchdataSourceArray = _researchdataSourceArray;
@synthesize dataSourceArray = _dataSourceArray;
@synthesize navigationController = _navigationController;
@synthesize category = _category;
@synthesize itemTableViewcanDrag = _itemTableViewcanDrag;
@synthesize itemTableViewcanDrop = _itemTableViewcanDrop;
@synthesize isPause = _isPause;
@synthesize condition = _condition;
@synthesize isStop = _isStop;
@synthesize isSearch = _isSearch;
@synthesize mainTopLineView = _mainTopLineView;
@synthesize iPod = _iPod;
@synthesize currentSelectView = _currentSelectView;
@synthesize defaultLayout = _defaultLayout;
@synthesize hoverLayout = _hoverLayout;
@synthesize selectionLayout = _selectionLayout;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
}

-(void)dealloc {
    if (_annoyTimer != nil) {
        [_annoyTimer invalidate];
        _annoyTimer = nil;
    }
    if (_researchdataSourceArray != nil) {
        [_researchdataSourceArray release];
        _researchdataSourceArray = nil;
    }
    if (_defaultLayout != nil) {
        [_defaultLayout release];
        _defaultLayout = nil;
    }
    if (_hoverLayout != nil) {
        [_hoverLayout release];
        _hoverLayout = nil;
    }
    if (_selectionLayout != nil) {
        [_selectionLayout release];
        _selectionLayout = nil;
    }
    if (_toolBarArr != nil) {
        [_toolBarArr release];
        _toolBarArr = nil;
    }
    if (_iPod != nil) {
        [_iPod release];
        _iPod = nil;
    }
    if (_delArray != nil) {
        [_delArray release];
        _delArray = nil;
    }
    if (_playlistArray != nil) {
        [_playlistArray release];
        _playlistArray = nil;
    }
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    if (_exportSetting != nil) {
        [_exportSetting release];
        _exportSetting = nil;
    }
    [super dealloc];
}

- (id)init {
    if (self = [super initWithNibName:[self className] bundle:nil]) {
    
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    if (self = [self init]) {
        _iPod = [ipod retain];
        _information = [[IMBInformationManager shareInstance].informationDic objectForKey:_iPod.uniqueKey];
        _category = category;
        _delegate = delegate;
        _delArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)awakeFromNib {
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    _condition = [[NSCondition alloc]init];
    _endRunloop = NO;
    
    _researchdataSourceArray = [[NSMutableArray alloc] init];
    _defaultLayout = [[CNGridViewItemLayout alloc] init];
    _hoverLayout = [[CNGridViewItemLayout alloc] init];
    _selectionLayout = [[CNGridViewItemLayout alloc] init];
    _hoverLayout.backgroundColor = [[NSColor grayColor] colorWithAlphaComponent:0.42];
    _selectionLayout.backgroundColor = [NSColor colorWithCalibratedRed:0.542 green:0.699 blue:0.807 alpha:0.420];
    
    _itemTableView.dataSource = self;
    _itemTableView.delegate = self;
    _itemTableView.allowsMultipleSelection = YES;
    [_itemTableView setListener:self];
    [_itemTableView setFocusRingType:NSFocusRingTypeNone];
    [_toolBarButtonView setHidden:NO];
    [_toolBarButtonView loadButtons:[NSArray arrayWithObjects:@(0),@(17),@(1),@(2),@(4),@(5),@(24),@(12),nil] Target:self DisplayMode:YES];

}

- (void)loadToolBarView:(CategoryNodesEnum) nodesEnum WithDisplayMode:(BOOL)displayMode {
    switch (nodesEnum) {
        case Category_Media:
        {
            [_toolBarButtonView loadButtons:[NSArray arrayWithObjects:@(ReloadFunctionType),@(AddFunctionType),@(DeviceDatailFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil] Target:self DisplayMode:YES];
        }
            break;
        case Category_Video:
        {
            [_toolBarButtonView loadButtons:[NSArray arrayWithObjects:@(ReloadFunctionType),@(AddFunctionType),@(DeviceDatailFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil] Target:self DisplayMode:YES];
        }
            break;
        case Category_iBooks:
        {
            [_toolBarButtonView loadButtons:[NSArray arrayWithObjects:@(ReloadFunctionType),@(DeviceDatailFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil] Target:self DisplayMode:YES];
        }
            break;
        case Category_Applications:
        {
            [_toolBarButtonView loadButtons:[NSArray arrayWithObjects:@(ReloadFunctionType),@(AddFunctionType),@(DeviceDatailFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil] Target:self DisplayMode:YES];
        }
            break;
        case Category_PhotoStream:
            
        case Category_CameraRoll:
        {
            [_toolBarButtonView loadButtons:[NSArray arrayWithObjects:@(ReloadFunctionType),@(DeviceDatailFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil] Target:self DisplayMode:YES];
        }
            break;
        case Category_System:
        {
            [_toolBarButtonView loadButtons:[NSArray arrayWithObjects:@(ReloadFunctionType),@(AddFunctionType),@(ToDeviceFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil] Target:self DisplayMode:YES];
        }
            break;
        case Category_PhotoLibrary:
        {
            [_toolBarButtonView loadButtons:[NSArray arrayWithObjects:@(ReloadFunctionType),@(AddFunctionType),@(DeviceDatailFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil] Target:self DisplayMode:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)setToolBar:(IMBToolButtonView *)toolbar {
    _toolBarButtonView = toolbar;
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchView{
    NSLog(@"search");
}

- (void)reload:(id)sender {
    
}

- (void)addItems:(id)sender {
    
}

- (void)deleteItems:(id)sender {
    
}

- (void)doSwitchView:(id)sender {
    
}

- (void)toMac:(id)sender {
    
}

- (void)deleteItem:(id)sender {
    
}

- (void)toDevice:(id)sender {
    
}

- (void)doEdit:(id)sender {
    
}

- (void)createNewFloder:(id)sender {
    
}

- (void)rename:(id)sender {
    
}

- (void)toiCloud:(id)sender {
    
}

- (void)showDetailView:(id)sender {
    
}

- (void)moveToFolder:(id)sender {
    
}

- (void)downloadToMac:(id)sender {
    
}

- (void)sortBtnClick:(id)sender {
    if (_devPopover != nil) {
        if (_devPopover.isShown) {
            [_devPopover close];
            return;
        }
    }
    if (_devPopover != nil) {
        [_devPopover release];
        _devPopover = nil;
    }
    _devPopover = [[NSPopover alloc] init];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
        _devPopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];
    }else {
        _devPopover.appearance = NSPopoverAppearanceMinimal;
    }
    
    _devPopover.animates = YES;
    _devPopover.behavior = NSPopoverBehaviorTransient;
    _devPopover.delegate = self;
    _sortPopoverViewController = [[IMBSortPopoverViewController alloc]  initWithNibName:@"IMBSortPopoverViewController" bundle:nil withSortTypeAry:[NSMutableArray arrayWithObjects:CustomLocalizedString(@"List_Header_id_Name", nil), CustomLocalizedString(@"List_Header_id_Date", nil),CustomLocalizedString(@"List_Header_id_Type", nil),CustomLocalizedString(@"List_Header_id_Size", nil),nil]];
    if (_devPopover != nil) {
        _devPopover.contentViewController = _sortPopoverViewController;
    }
    [_sortPopoverViewController setTarget:self];
    [_sortPopoverViewController setDelegate:self];
    [_sortPopoverViewController setAction:@selector(sortClick:)];
    [_sortPopoverViewController release];
    NSButton *targetButton = (NSButton *)sender;
    NSRectEdge prefEdge = NSMaxYEdge;
    NSRect rect = NSMakeRect(targetButton.bounds.origin.x, targetButton.bounds.origin.y, targetButton.bounds.size.width, targetButton.bounds.size.height);
    [_devPopover showRelativeToRect:rect ofView:sender preferredEdge:prefEdge];
}

- (void)sortClick:(id)sender {
    
}



- (void)loadSonAryComplete:(NSMutableArray *)sonAry {
    
}

- (void)loadTransferComplete:(NSMutableArray *)transferAry WithEvent:(ActionTypeEnum)actionType {
    
}

//开始移动文件
- (void)startMoveTransferWith:(IMBDriveEntity *)entity {
    
}

#pragma mark - alert action
- (void)showAlertText:(NSString *)alertText OKButton:(NSString *)OkText {
    
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    [_alertViewController showAlertText:alertText WithButtonTitle:OkText WithSuperView:view];
}

@end
