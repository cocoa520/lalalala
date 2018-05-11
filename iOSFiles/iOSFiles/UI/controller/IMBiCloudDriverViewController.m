//
//  IMBiCloudDriverViewController.m
//  iOSFiles
//
//  Created by smz on 18/3/14.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBiCloudDriverViewController.h"
#import "CNGridViewItemLayout.h"
#import "IMBDriveEntity.h"
#import "IMBCommonDefine.h"
#import "IMBImageAndTextFieldCell.h"
#import "HoverButton.h"
#import "IMBiCloudPathSelectBtn.h"
#import "IMBTagImageView.h"
#import "TempHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "IMBDownloadListViewController.h"
#import "IMBAnimation.h"
#import "IMBTranferViewController.h"
#import "IMBAlertViewController.h"
#import "IMBiCloudDriveManager.h"
#import "IMBDropBoxManage.h"
#import "IMBDeviceConnection.h"
#import "IMBCommonTool.h"
#import "SystemHelper.h"
#import "IMBMoveTransferManager.h"
#import "AFNetworking.h"

@interface IMBiCloudDriverViewController()

{
    AFNetworkReachabilityManager *_afReachabilityMgr;
}

@end

@implementation IMBiCloudDriverViewController
@synthesize baseInfo = _baseInfo;
- (id)initWithDrivemanage:(IMBDriveBaseManage *)driveManage withDelegete:(id)delegete withChooseLoginModelEnum:(ChooseLoginModelEnum) chooseLogModelEnum{
    if (self = [super initWithNibName:@"IMBiCloudDriverViewController" bundle:nil]) {
        _dataSourceArray = [[NSMutableArray alloc] initWithArray:driveManage.driveDataAry];
        _tempDic  = [[NSMutableDictionary alloc] init];
        [_tempDic setObject:_dataSourceArray forKey:@"1"];
        _driveBaseManage = [driveManage retain];
        _delegate = delegete;
        [_driveBaseManage setDriveWindowDelegate:self];
        _chooseLogModelEnmu = chooseLogModelEnum;
    }
    return self;
}

- (void)dealloc {
    if (_afReachabilityMgr) {
        [_afReachabilityMgr release];
        _afReachabilityMgr = nil;
    }
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    if (_driveBaseManage != nil) {
        [_driveBaseManage release];
        _driveBaseManage = nil;
    }
    if (_oldWidthDic != nil) {
        [_oldWidthDic release];
        _oldWidthDic = nil;
    }
    if (_tempDic != nil) {
        [_tempDic release];
        _tempDic = nil;
    }
    if (_oldDocwsidDic != nil) {
        [_oldDocwsidDic release];
        _oldDocwsidDic = nil;
    }
    if (_oldFileidDic) {
        [_oldFileidDic release];
        _oldFileidDic = nil;
    }
    if (_toolBarArr != nil) {
        [_toolBarArr release];
        _toolBarArr = nil;
    }
    if (_editTextField) {
        [_editTextField release];
        _editTextField = nil;
    }
    if (_devicePopoverViewController) {
        [_devicePopoverViewController release];
        _devicePopoverViewController = nil;
    }
    if (_devChoosePopover) {
        [_devChoosePopover release];
        _devChoosePopover = nil;
    }
    [IMBNotiCenter removeObserver:self name:NOTIFY_SHOW_DEVICEDETAIL object:nil];
    [IMBNotiCenter removeObserver:self name:INSERT_INSETNEWLINE object:nil];
    
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_loadLeftView setIsLeftToRight:YES];
    [_loadLeftView setNeedsDisplay:YES];
    
    [_loadRightView setIsLeftToRight:YES];
    [_loadRightView setIsUpWhiteToClear:YES];
    [_loadRightView setNeedsDisplay:YES];
    
    [(NSButtonCell *)_closeDetailBtn.cell setHighlightsBy:NSNoCellMask];
    [self configNoDataView];
    if (_toolBarArr != nil) {
        [_toolBarArr release];
        _toolBarArr = nil;
    }
    _toolBarArr = [[NSArray alloc]initWithObjects:@(21),@(17),@(0),@(24),@(12), nil];
    [_toolBarButtonView loadButtons:_toolBarArr Target:self DisplayMode:YES];
    [self configRightKeyMenuItemWithConfigArr:_toolBarArr];
    
    [_rightContentView setWantsLayer:YES];
    [_leftContentView setWantsLayer:YES];
    [_leftContentView setFrame:NSMakeRect(0, 0, 1096, 548)];
    [_rightContentView setFrame:NSMakeRect(1096, 0, 282, 548)];
    
    _oldWidthDic = [[NSMutableDictionary alloc] init];
    _oldDocwsidDic = [[NSMutableDictionary alloc] init];
    _oldFileidDic = [[NSMutableDictionary alloc] init];
    if (_chooseLogModelEnmu == iCloudLogEnum) {
        [self configSelectPathButtonWithButtonTag:1 WithButtonTitle:CustomLocalizedString(@"NotConnectiCLoudTitle", nil)];
    }else {
        [self configSelectPathButtonWithButtonTag:1 WithButtonTitle:CustomLocalizedString(@"NotConnectDropBoxTitle", nil)];
    }
    
    [IMBNotiCenter addObserver:self selector:@selector(showDeviceDetailView:) name:NOTIFY_SHOW_DEVICEDETAIL object:nil];
    [IMBNotiCenter addObserver:self selector:@selector(renameTFInsertnewlinedown) name:INSERT_INSETNEWLINE object:nil];
    
    _doubleclickCount = 1;
    _currentDevicePath = @"0";
    _currentGetListPath = @"0";
    [_oldDocwsidDic setObject:_currentDevicePath forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
    [_oldFileidDic setObject:_currentGetListPath forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
//    [_topLineView setWantsLayer:YES];
    [_topLineView setBackgroundColor:COLOR_TEXT_LINE];
    [_rightLineView setBackgroundColor:COLOR_TEXT_LINE];
    
    _itemTableView.dataSource = self;
    _itemTableView.delegate = self;
    _itemTableView.allowsMultipleSelection = YES;
    [_itemTableView setListener:self];
    [_itemTableView setFocusRingType:NSFocusRingTypeNone];
    _itemTableViewcanDrop = YES;
    [_itemTableView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    [_itemTableView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:YES];
    //注册该表的拖动类型
    [_itemTableView registerForDraggedTypes:[NSArray arrayWithObjects:NSFilesPromisePboardType,NSFilenamesPboardType,nil]];
    
    _gridView.itemSize = NSMakeSize(154, 154);
    _gridView.backgroundColor = [NSColor whiteColor];
    _gridView.scrollElasticity = NO;
    _gridView.allowsDragAndDrop = YES;
    _gridView.allowsMultipleSelection = YES;
    _gridView.allowsMultipleSelectionWithDrag = YES;
    _gridView.allowClickMultipleSelection = NO;
    [_gridView setGridDelegate:self];
    _gridView.commandADown = ^{
        //commandA
        IMBFLog(@"commandA");
        [_gridView selectAllItems];
        [self setAllselectState:1];
        [self changeToolbarButton];
    };
    [_gridView setIsFileManager:YES];
    [_gridView reloadData];
    [_itemTableView reloadData];
    [_tableViewBgView setBackgroundColor:[NSColor whiteColor]];
    _currentSelectView = 1;
    if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
        [_contentBox setContentView:_gridBgView];
    } else {
        [_contentBox setContentView:_nodataView];
    }
    
    _editTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 306, 40)];
    
    for (NSTableColumn *column in [_itemTableView tableColumns]) {
        IMBCustomHeaderCell *cell = (IMBCustomHeaderCell *)[column headerCell];
        if ([column.identifier isEqualToString:@"ImageText"]) {
            cell.stringValue = @"";
            [cell setIsShowTriangle:NO];
        }else if ([column.identifier isEqualToString:@"Name"]) {
            [cell setHasLeftTitleBorderLine:NO];
        }
    }
    
    _afReachabilityMgr = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听网络状态的改变
    /*
     AFNetworkReachabilityStatusUnknown          = 未知
     AFNetworkReachabilityStatusNotReachable     = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 3G
     AFNetworkReachabilityStatusReachableViaWiFi = WIFI
     */
    [_afReachabilityMgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                NSString *key = @"";
                if (_chooseLogModelEnmu == iCloudLogEnum) {
                    key = IMBAlertViewiCloudKey;
                }else if (_chooseLogModelEnmu == iCloudLogEnum) {
                    key = IMBAlertViewDropBoxKey;
                }
                [IMBCommonTool showSingleBtnAlertInMainWindow:key btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:@"No Network" btnClickedBlock:nil];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
                
            default:
                break;
        }
    }];
    
    //3.开始监听
    [_afReachabilityMgr startMonitoring];
}
- (void)changeToolbarButton {
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    _toolBarArr = [[NSArray alloc]initWithObjects:@(21),@(17),@(18),@(3),@(19),@(23),@(2),@(0),@(6),@(25),@(24),@(12), nil];
    [_toolBarButtonView loadButtons:_toolBarArr Target:self DisplayMode:YES];
    [self configRightKeyMenuItemWithConfigArr:_toolBarArr];
    
    NSIndexSet *set = [self selectedItems];
    if (set.count) {
        [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            IMBDriveEntity *fileEntity = [array objectAtIndex:idx];
            fileEntity.checkState = YES;
            if (_toolBarArr != nil) {
                [_toolBarArr release];
                _toolBarArr = nil;
            }
            if (fileEntity.isFolder) {
                _toolBarArr = [[NSArray alloc] initWithObjects:@(21),@(17),@(18),@(3),@(19),@(23),@(2),@(0),@(6),@(24),@(12), nil];
                [_toolBarButtonView loadButtons:_toolBarArr Target:self DisplayMode:YES];
                [self configRightKeyMenuItemWithConfigArr:_toolBarArr];
            }
        }];
    }
}
- (void)configNoDataView {
    [_nodataImageView setImage:[StringHelper imageNamed:@"nodata_myfiles"]];
    NSString *promptStr = CustomLocalizedString(@"Nodata_tips", nil);
    NSMutableAttributedString *promptAs = [TempHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:COLOR_TEXT_EXPLAIN];
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [_nodataTextView setEditable:NO];
    [_nodataTextView setSelectable:NO];
    [[_nodataTextView textStorage] setAttributedString:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;
    
}

#pragma mark - path button config
- (void)configSelectPathButtonWithButtonTag:(int)buttonTag WithButtonTitle:(NSString *)buttonTitle {
    NSString *fileName = buttonTitle;
    if (fileName.length > 15) {
        fileName = [[fileName substringWithRange:NSMakeRange(0, 13)] stringByAppendingString:@"..."];
    }
    NSRect textRect = [StringHelper calcuTextBounds:fileName fontSize:14.0];
    int width = textRect.size.width + 10;
    [_oldWidthDic setObject:[NSString stringWithFormat:@"%d",width] forKey:[NSString stringWithFormat:@"%d",buttonTag]];
    int height = textRect.size.height + 4;
    int oldWidth = 0;
    for (int i = 1; i <= buttonTag; i++) {
        if ([_oldWidthDic.allKeys containsObject:[NSString stringWithFormat:@"%d",i - 1]]) {
            oldWidth += [[_oldWidthDic objectForKey:[NSString stringWithFormat:@"%d",i - 1]] intValue];
        }
    }
    
    IMBiCloudPathSelectBtn *button = [[IMBiCloudPathSelectBtn alloc] initWithFrame:NSMakeRect(20 + (buttonTag - 1)*10 + oldWidth, (_topView.frame.size.height - height)/2 - 2, width, height)];

    [button setButtonName:fileName];
    [button setToolTip:buttonTitle];
    [button setTag:buttonTag];
    [button setTarget:self];
    [button setAction:@selector(iCloudButtonClick:)];
    [_topView addSubview:button];
    if (buttonTag - 1) {
        IMBTagImageView *arrowImageView = [[IMBTagImageView alloc] initWithFrame:NSMakeRect(button.frame.origin.x - 10, (_topView.frame.size.height - 9)/2.0 - 3, 10, 9)];
        [arrowImageView setImage:[NSImage imageNamed:@"addcontent_arrowright1"]];
        [arrowImageView setViewTag:buttonTag];
        [_topView addSubview:arrowImageView];
        [arrowImageView release];
        arrowImageView = nil;
    }
    [button release];
    button = nil;
    
}

- (void)iCloudButtonClick:(id)sender {

    _curEntity = nil;
    int tag = (int)((IMBiCloudPathSelectBtn *)sender).tag;
    int viewCount = (int)[_topView subviews].count;
    for (int i = viewCount - 1; i > 0; i--) {
        NSView *subView = [[_topView subviews] objectAtIndex:i];
        if ([subView isKindOfClass:[NSClassFromString(@"IMBiCloudPathSelectBtn") class]]) {
            if (subView.tag > tag) {
                [subView removeFromSuperview];
            }
        }
        if ([subView isKindOfClass:[NSClassFromString(@"IMBTagImageView") class]]) {
            if (((IMBTagImageView *)subView).viewTag > tag) {
                [subView removeFromSuperview];
            }
        }
    }
    
    for (int i = 1; i <= _doubleclickCount; i++) {
        if (tag == i) {
            [self changeContentViewWithDataArr:[_tempDic objectForKey:[NSString stringWithFormat:@"%d",i]]];
            for (int j = i + 1; j <= _doubleclickCount; j++) {
                if ([_tempDic.allKeys containsObject:[NSString stringWithFormat:@"%d",j]]) {
                    [_tempDic removeObjectForKey:[NSString stringWithFormat:@"%d",j]];
                }
                if ([_oldWidthDic.allKeys containsObject:[NSString stringWithFormat:@"%d",j]]) {
                    [_oldWidthDic removeObjectForKey:[NSString stringWithFormat:@"%d",j]];
                }
                if ([_oldDocwsidDic.allKeys containsObject:[NSString stringWithFormat:@"%d",j]]) {
                    [_oldDocwsidDic removeObjectForKey:[NSString stringWithFormat:@"%d",j]];
                }
                if ([_oldFileidDic.allKeys containsObject:[NSString stringWithFormat:@"%d",j]]) {
                    [_oldFileidDic removeObjectForKey:[NSString stringWithFormat:@"%d",j]];
                }
            }
            _doubleclickCount = i;
            
            break;
        }
    }
    
    if ([_oldDocwsidDic.allKeys containsObject:[NSString stringWithFormat:@"%d",tag]]) {
        _currentDevicePath = [_oldDocwsidDic objectForKey:[NSString stringWithFormat:@"%d",tag]];
    }
    if ([_oldFileidDic.allKeys containsObject:[NSString stringWithFormat:@"%d",tag]]) {
        _currentGetListPath = [_oldFileidDic objectForKey:[NSString stringWithFormat:@"%d",tag]];
    }
    [_itemTableView reloadData];
    [self changeCheckboxState];
    
    if (_toolBarArr != nil) {
        [_toolBarArr release];
        _toolBarArr = nil;
    }
    _toolBarArr = [[NSArray alloc]initWithObjects:@(21),@(17),@(5),@(18),@(3),@(19),@(23),@(2),@(0),@(6),@(24),@(12), nil];
    [_toolBarButtonView loadButtons:_toolBarArr Target:self DisplayMode:YES];
    [self configRightKeyMenuItemWithConfigArr:_toolBarArr];
}

#pragma mark - CNGridView DataSource
- (NSUInteger)gridView:(CNGridView *)gridView numberOfItemsInSection:(NSInteger)section {
    if (_isSearch) {
        return _researchdataSourceArray.count;
    }else {
        return _dataSourceArray.count;
    }
}

- (CNGridViewItem *)gridView:(CNGridView *)gridView itemAtIndex:(NSInteger)index inSection:(NSInteger)section {
    static NSString *reuseIdentifier = @"CNGridViewItem";
    
    CNGridViewItem *item = [gridView dequeueReusableItemWithIdentifier:@(index)];
    if (item == nil) {
        item = [[[CNGridViewItem alloc] initWithLayout:self.defaultLayout reuseIdentifier:reuseIdentifier] autorelease];
        item.hoverLayout = self.hoverLayout;
        item.selectionLayout = self.selectionLayout;
    }
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    if (index >= array.count) {
        return item;
    }
    
    IMBDriveEntity *fileEntity = [array objectAtIndex:index];
    item.entity = fileEntity;
    item.category = _category;
    
    item.bgImg = fileEntity.image;
    item.itemTitle = fileEntity.fileName;
    
    item.isFileManager = YES;
    item.selected = fileEntity.checkState;
    item.isEdit = fileEntity.isEdit;
    
    if (fileEntity.checkState == Check) {
        if (![gridView.selectedItems containsObject:item]) {
            [[gridView getSelectedItemsDic] setObject:item forKey:@(item.index)];
        }
    }else{
        if ([gridView.selectedItems containsObject:item]) {
            [[gridView getSelectedItemsDic] removeObjectForKey:@(item.index)];
        }
    }
    return item;
}

#pragma mark - CNGridView Delegate
- (void)gridView:(CNGridView *)gridView didSelectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    if (index < array.count) {
        IMBDriveEntity *fileEntity = [array objectAtIndex:index];
        if (_toolBarArr != nil) {
            [_toolBarArr release];
            _toolBarArr = nil;
        }
        _toolBarArr = [[NSArray alloc]initWithObjects:@(21),@(17),@(5),@(18),@(3),@(19),@(23),@(2),@(0),@(6),@(25),@(24),@(12), nil];
        [_toolBarButtonView loadButtons:_toolBarArr Target:self DisplayMode:YES];
        [self configRightKeyMenuItemWithConfigArr:_toolBarArr];
        fileEntity.checkState = Check;
    }
    NSIndexSet *set = [self selectedItems];
    if (set.count) {
        [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            IMBDriveEntity *fileEntity = [array objectAtIndex:idx];
            if (_toolBarArr != nil) {
                [_toolBarArr release];
                _toolBarArr = nil;
            }
            if (fileEntity.isFolder) {
                _toolBarArr = [[NSArray alloc]initWithObjects:@(21),@(17),@(5),@(18),@(3),@(19),@(23),@(2),@(0),@(6),@(24),@(12), nil];
                [_toolBarButtonView loadButtons:_toolBarArr Target:self DisplayMode:YES];
                [self configRightKeyMenuItemWithConfigArr:_toolBarArr];
            }
        }];
    }
}

- (void)gridView:(CNGridView *)gridView didDeselectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    if (index < array.count) {
        IMBDriveEntity *fielEntity = [array objectAtIndex:index];
        fielEntity.checkState = UnChecked;
    }
    
}

- (void)gridViewDidDeselectAllItems:(CNGridView *)gridView {
    
    if (_curEntity.isEdit && !_curEntity.isCreating) {
        NSArray *selectArr = [_gridView keyedVisibleItems];
        NSDictionary *dic = nil;
        NSString *newName = @"";
        CNGridViewItem *curItem = nil;
        for (CNGridViewItem *item in selectArr) {
            if (item.isEdit) {
                curItem = item;
                break;
            }
        }
        if (curItem) {
            if (![StringHelper stringIsNilOrEmpty:curItem.editText.stringValue] && ![curItem.editText.stringValue isEqualToString:_curEntity.fileName]) {
//                if ([self hasSameNameWithName:curItem.editText.stringValue]) {
//                    
//                    //TODO   添加新名字和已有名字重复的提醒
//                    NSString *key = nil;
//                    NSString *alertString = nil;
//                    switch (_chooseLogModelEnmu) {
//                        case iCloudLogEnum:
//                        {
//                            key = IMBAlertViewiCloudKey;
//                        }
//                            break;
//                        case DropBoxLogEnum:
//                        {
//                            key = IMBAlertViewDropBoxKey;
//                        }
//                            break;
//                            
//                        default:
//                            break;
//                    }
//                    if (_curEntity.isFolder) {
//                        alertString = CustomLocalizedString(@"RenameTipsFolder", nil);
//                    }else {
//                        alertString = CustomLocalizedString(@"RenameTipsFile", nil);
//                    }
//                    [IMBCommonTool showTwoBtnsAlertInMainWindow:key firstBtnTitle:CustomLocalizedString(@"Button_Cancel", nil) secondBtnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:alertString firstBtnClickedBlock:^{
//                        [self setNewNameWithName:[self checkoutName:_curEntity.fileName]];
//                    } secondBtnClickedBlock:^{
//                        [self setNewNameWithName:[self checkoutName:_editTextField.stringValue]];
//                    }];
//                }else {
//                    _curEntity.fileName = [self checkoutName:curItem.editText.stringValue];//curItem.editText.stringValue;
//                    if (_curEntity.extension && !_curEntity.isFolder){
//                        newName = [[_curEntity.fileName stringByAppendingString:@"."] stringByAppendingString:_curEntity.extension];
//                    }else {
//                        newName = _curEntity.fileName;
//                    }
//                    if (_curEntity.isCreate) {
//                        _curEntity.isCreating = YES;
//                        if (_chooseLogModelEnmu == iCloudLogEnum) {
//                            [_driveBaseManage createFolder:newName parent:_currentGetListPath withEntity:_curEntity];
//                        }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
//                            [_driveBaseManage createFolder:newName parent:_currentDevicePath withEntity:_curEntity];
//                        }
//                    } else {
//                        if (_chooseLogModelEnmu == iCloudLogEnum) {
//                            dic = @{@"drivewsid":_curEntity.fileID,@"etag":_curEntity.etag,@"name":newName};
//                            if (dic != nil) {
//                                [(IMBiCloudDriveManager *)_driveBaseManage reNameWithDic:dic];
//                            }
//                        }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
//                            [(IMBDropBoxManage *)_driveBaseManage reName:[[_curEntity.filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newName] idOrPath:_curEntity.fileID];
//                        }
//                    }
//                }
                _curEntity.fileName = [self checkoutName:curItem.editText.stringValue];//curItem.editText.stringValue;
                if (_curEntity.extension && !_curEntity.isFolder){
                    newName = [[_curEntity.fileName stringByAppendingString:@"."] stringByAppendingString:_curEntity.extension];
                }else {
                    newName = _curEntity.fileName;
                }
                if (_curEntity.isCreate) {
                    _curEntity.isCreating = YES;
                    if (_chooseLogModelEnmu == iCloudLogEnum) {
                        [_driveBaseManage createFolder:newName parent:_currentGetListPath withEntity:_curEntity];
                    }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
                        [_driveBaseManage createFolder:newName parent:_currentDevicePath withEntity:_curEntity];
                    }
                } else {
                    if (_chooseLogModelEnmu == iCloudLogEnum) {
                        dic = @{@"drivewsid":_curEntity.fileID,@"etag":_curEntity.etag,@"name":newName};
                        if (dic != nil) {
                            [(IMBiCloudDriveManager *)_driveBaseManage reNameWithDic:dic];
                        }
                    }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
                        [(IMBDropBoxManage *)_driveBaseManage reName:[[_curEntity.filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newName] idOrPath:_curEntity.fileID];
                    }
                }
            }else {
                if (_curEntity.isCreate) {
                    _curEntity.isCreating = YES;
                    _curEntity.fileName = curItem.editText.stringValue;
                    NSString *str = _curEntity.fileName;
                    if (_curEntity.fileName.length < 1) {
                        str = CustomLocalizedString(@"Function_New_Folder", nil);
                    }
                    if (_chooseLogModelEnmu == iCloudLogEnum) {
                        [_driveBaseManage createFolder:str parent:_currentGetListPath withEntity:_curEntity];
                    }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
                        [_driveBaseManage createFolder:str parent:_currentDevicePath withEntity:_curEntity];
                    }
                }
            }
        }
        _curEntity.isEditing = NO;
        _curEntity.isEdit = NO;
        _curEntity.isCreate = NO;
        [_toolBarButtonView toolBarButtonIsEnabled:YES];
        [_gridView reloadData];
    }
    
    NSArray *array = nil;
    
    
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    
    for (IMBDriveEntity *fileEntity in array) {
        fileEntity.checkState = UnChecked;
    }
    
    if (_toolBarArr != nil) {
        [_toolBarArr release];
        _toolBarArr = nil;
    }
    _toolBarArr = [[NSArray alloc]initWithObjects:@(21),@(17),@(0),@(24),@(12), nil];
    [_toolBarButtonView loadButtons:_toolBarArr Target:self DisplayMode:YES];
    [self configRightKeyMenuItemWithConfigArr:_toolBarArr];
    [_gridView reloadSelecdImage];
}

- (void)gridView:(CNGridView *)gridView didDoubleClickItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
    
    [self hideFileDetailView:nil];
    
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    if ((int)index >= 0 && index < array.count) {
        IMBDriveEntity *driveEntity = [array objectAtIndex:index];
        if (driveEntity.isFolder) {
            [_itemTableView changeHeaderCheckState:UnChecked];
            _isSearch = NO;
            [_researchdataSourceArray removeAllObjects];
            [_searhView setStringValue:@""];
            
            if (driveEntity.isCreating || driveEntity.isCreate) {
                //提示正在创建，不能进入
                [_promptLabel setTextColor:COLOR_TEXT_PRIORITY];
                [_promptImageView setImage:[NSImage imageNamed:@"message-box-progress"]];
                [self addPromptCustomView:CustomLocalizedString(@"prompt_creating_floder", nil)];
            }else {
                [_toolBarButtonView toolBarButtonIsEnabled:NO];
                [_contentBox setContentView:_loadingView];
                [_loadAnimationView startAnimation];
                _doubleclickCount ++;
                _doubleClick = YES;
                [self configSelectPathButtonWithButtonTag:_doubleclickCount WithButtonTitle:driveEntity.fileName];
                if (![StringHelper stringIsNilOrEmpty:driveEntity.fileID]) {
                    if (driveEntity.childCount>120) {
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            @autoreleasepool {
                                [_driveBaseManage recursiveDirectoryContentsDics:driveEntity.fileID];
                                if (_chooseLogModelEnmu == iCloudLogEnum) {
                                    _currentDevicePath = driveEntity.docwsid;
                                    _currentGetListPath = driveEntity.fileID;
                                }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
                                     _currentDevicePath = driveEntity.filePath;
                                    _currentGetListPath = driveEntity.fileID;
                                }
                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            [_driveBaseManage recursiveDirectoryContentsDics:driveEntity.fileID];
                            if (_chooseLogModelEnmu == iCloudLogEnum) {
                                _currentDevicePath = driveEntity.docwsid;
                                _currentGetListPath = driveEntity.fileID;
                            }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
                                 _currentDevicePath = driveEntity.filePath;
                                _currentGetListPath = driveEntity.fileID;
                            }
                        
                        });
                    }
                }
            }
        }else {
            [self previewFile:driveEntity];
        }
    }
}

- (void)gridView:(CNGridView *)gridView didClickItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
    if (index < _dataSourceArray.count && (int)index >= 0) {
        _curEntity = [_dataSourceArray objectAtIndex:index];
        if (_isShow) {
            [self showFileDetailViewWithEntity:_curEntity];
        }
    }
}

//排序
- (void)sortClick:(id)sender {
    [_devPopover close];
    NSMutableArray *disPalyAry = nil;
    if (_isSearch) {
        disPalyAry = _researchdataSourceArray;
    }else{
        disPalyAry = _dataSourceArray;
    }
    if (disPalyAry.count <=0) {
        return;
    }
    if([sender isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)sender;
        NSString *key = nil;
        if ([str isEqualToString:CustomLocalizedString(@"List_Header_id_Name", nil)]) {
            key = @"fileName";
        }else if ([str isEqualToString:CustomLocalizedString(@"List_Header_id_Date", nil)]) {
             key = @"lastModifiedDateString";
        }else if ([str isEqualToString:CustomLocalizedString(@"List_Header_id_Type", nil)]) {
            key = @"extension";
        }else if ([str isEqualToString:CustomLocalizedString(@"List_Header_id_Size", nil)]) {
            key = @"fileSize";
        }
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便

        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        [disPalyAry sortUsingDescriptors:sortDescriptors];
        [_gridView reloadData];
        [_itemTableView reloadData];
        [sortDescriptor release];
    }
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_isSearch) {
        if (_researchdataSourceArray != nil && _researchdataSourceArray.count > 0) {
            return _researchdataSourceArray.count;
        }
    }else {
        if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
            return _dataSourceArray.count;
        }
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    IMBDriveEntity *fileEntity = nil;
    if (_isSearch) {
        if (row >= _researchdataSourceArray.count) {
            return @"";
        }
        fileEntity = [_researchdataSourceArray objectAtIndex:row];
    }else {
        if (row >= _dataSourceArray.count) {
            return @"";
        }
        fileEntity = [_dataSourceArray objectAtIndex:row];
    }
    if ([@"Type" isEqualToString:tableColumn.identifier]){
        if (![StringHelper stringIsNilOrEmpty:fileEntity.extension]) {
            if (fileEntity.isFolder) {
                return CustomLocalizedString(@"Bookmark_id_6", nil);
            }else {
               return fileEntity.extension;
            }
        }else {
            return @"--";
        }
    }else if ([@"Name" isEqualToString:tableColumn.identifier]){
        return fileEntity.fileName;
    }else if ([@"Date" isEqualToString:tableColumn.identifier]){
        if ([StringHelper stringIsNilOrEmpty:fileEntity.lastModifiedDateString]) {
            return @"--";
        }else{
            return fileEntity.lastModifiedDateString;
        }
    }else if ([@"Size" isEqualToString:tableColumn.identifier]){
        if (fileEntity.fileSize == 0) {
            return @"--";
        }else {
            return [IMBHelper getFileSizeString:fileEntity.fileSize reserved:2];
        }
    }else if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
        return [NSNumber numberWithInt:fileEntity.checkState];
    }
    return @"";
}

#pragma mark - NSTableViewdelegate
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    if ([tableColumn.identifier isEqualToString:@"ImageText"] && row < array.count) {
        IMBDriveEntity *fileEntity = [array objectAtIndex:row];
        IMBImageAndTextFieldCell *curCell = (IMBImageAndTextFieldCell *)cell;
        [curCell setImageSize:NSMakeSize(24, 24)];
        curCell.image = fileEntity.image;
        curCell.imageText = @"";//fileEntity.fileName;
        [curCell setIsDataImage:YES];
        curCell.marginX = 12;
    }
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (!_curEntity.isEdit) {
        _curEntity.isEdit = YES;
        _curEntity.isEditing = NO;
        [_toolBarButtonView toolBarButtonIsEnabled:NO];
    }
    return YES;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 40;
}

- (void)tableView:(NSTableView *)tableView WithSelectIndexSet:(NSIndexSet *)indexSet {
    NSMutableArray *disPalyAry = nil;
    if (_isSearch) {
        disPalyAry = _researchdataSourceArray;
    }else{
        disPalyAry = _dataSourceArray;
    }
    if (disPalyAry.count <=0) {
        return;
    }
    
    NSArray *dataArr = nil;
    if (indexSet.count > 0) {
        dataArr = [disPalyAry objectsAtIndexes:indexSet];
        for (IMBDriveEntity *entity in dataArr) {
            entity.checkState = Check;
        }
        if (dataArr.count == 1) {
            _curEntity = [dataArr objectAtIndex:0];
            if (_isShow) {
                [self configDetailViewWith:_curEntity];
            }
        }
    }
    for (IMBDriveEntity *entity in disPalyAry) {
        if (![dataArr containsObject:entity]) {
            entity.checkState = UnChecked;
        }
    }
    for (IMBDriveEntity *entity in _dataSourceArray) {
        if (entity.checkState) {
            if (_toolBarArr != nil) {
                [_toolBarArr release];
                _toolBarArr = nil;
            }
            _toolBarArr = [[NSArray alloc]initWithObjects:@(21),@(17),@(5),@(18),@(3),@(19),@(23),@(2),@(0),@(6),@(25),@(24),@(12), nil];
            [_toolBarButtonView loadButtons:_toolBarArr Target:self DisplayMode:NO];
            [self configRightKeyMenuItemWithConfigArr:_toolBarArr];
            break;
        }
    }
    
    NSIndexSet *set = [self selectedItems];
    
    if (set.count == disPalyAry.count) {
        [_itemTableView changeHeaderCheckState:Check];
    }else if (set.count == 0){
        [_itemTableView changeHeaderCheckState:UnChecked];
    }else{
        [_itemTableView changeHeaderCheckState:SemiChecked];
    }
    [_itemTableView reloadData];
}

- (void)tableViewDoubleClick:(NSTableView *)tableView row:(NSInteger)index {
    [self gridView:_gridView didDoubleClickItemAtIndex:index inSection:0];
}

- (void)tableViewSingleClick:(NSTableView *)tableView row:(NSInteger)index {
    [self executeRenameOrCreate];
}

- (void)tableView:(NSTableView *)tableView textDidEndEditing:(NSNotification *)notification {
    if (_curEntity) {
        _curEntity.isEditing = NO;
        _curEntity.isEdit = NO;
        _curEntity.isCreate = NO;
    }
    [_toolBarButtonView toolBarButtonIsEnabled:YES];
}



//排序
- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    //在重命名或者创建文件夹时，点击排序执行相应操作
    [self executeRenameOrCreate];
    
    id cell = [tableColumn headerCell];
    NSString *identify = [tableColumn identifier];
    NSArray *array = [tableView tableColumns];
    NSMutableArray *disPalyAry = nil;
    if (_isSearch) {
        disPalyAry = _researchdataSourceArray;
    }else{
        disPalyAry = _dataSourceArray;
    }
    if (disPalyAry.count <=0) {
        return;
    }
    for (NSTableColumn  *column in array) {
        if ([column.headerCell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *columnHeadercell = (IMBCustomHeaderCell *)column.headerCell;
            if ([column.identifier isEqualToString:identify]) {
                [columnHeadercell setIsShowTriangle:YES];
            }else {
                [columnHeadercell setIsShowTriangle:NO];
            }
        }
        
    }
    
    if ([@"Name" isEqualToString:identify] || [@"Type" isEqualToString:identify] || [@"Date" isEqualToString:identify] || [@"Size" isEqualToString:identify]) {
        if ([cell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *customHeaderCell = (IMBCustomHeaderCell *)cell;
            if (customHeaderCell.ascending) {
                customHeaderCell.ascending = NO;
            }else {
                customHeaderCell.ascending = YES;
            }
            [self sort:customHeaderCell.ascending key:identify dataSource:disPalyAry];
        }
    }else if ([@"ImageText" isEqualToString:identify]) {
        IMBCustomHeaderCell *customHeaderCell = (IMBCustomHeaderCell *)cell;
        [customHeaderCell setIsShowTriangle:NO];
    }
    [_itemTableView reloadData];
}

- (void)sort:(BOOL)isAscending key:(NSString *)key dataSource:(NSMutableArray *)array {
    if ([key isEqualToString:@"Name"]) {
        key = @"fileName";
    } else if ([key isEqualToString:@"Type"]) {
        key = @"extension";
    }else if ([key isEqualToString:@"Size"]) {
        key = @"fileSize";
    }else if ([key isEqualToString:@"Date"]) {
        key = @"lastModifiedDateString";
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    [_itemTableView reloadData];
    
    [sortDescriptor release];
    [sortDescriptors release];
}

- (NSIndexSet *)selectedItems {
    NSIndexSet *selectedItems = nil;
    if (_currentSelectView == 0) {
        NSMutableArray *disAry = nil;
        if (_isSearch) {
            disAry = _researchdataSourceArray;
        }else{
            disAry = _dataSourceArray;
        }
        NSMutableIndexSet *sets = [NSMutableIndexSet indexSet];
        for (int i=0;i<[disAry count]; i++) {
            IMBBaseEntity *entity = [disAry objectAtIndex:i];
            if (entity.checkState == Check||entity.checkState == SemiChecked) {
                [sets addIndex:i];
            }
        }
        selectedItems = sets;
    }else {
        selectedItems = _gridView.selectedIndexes;
    }
    return selectedItems;
}
- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    NSMutableArray *disPalyAry = nil;
    if (_isSearch) {
        disPalyAry = _researchdataSourceArray;
    }else{
        disPalyAry = _dataSourceArray;
    }
    if (disPalyAry.count <=0) {
        return;
    }
    IMBDriveEntity *entity = [disPalyAry objectAtIndex:index];
    entity.checkState = !entity.checkState;
    
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[disPalyAry count]; i++) {
        IMBPhotoEntity *item= [disPalyAry objectAtIndex:i];
        if (item.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
    if (entity.checkState == NSOnState) {
        //        [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    }else if (entity.checkState == NSOffState)
    {
        [_itemTableView deselectRow:index];
    }
    
    if (set.count == disPalyAry.count) {
        [_itemTableView changeHeaderCheckState:Check];
    }else if (set.count == 0){
        [_itemTableView changeHeaderCheckState:UnChecked];
    }else{
        [_itemTableView changeHeaderCheckState:SemiChecked];
    }
    [_itemTableView reloadData];
}

- (void)setAllselectState:(CheckStateEnum)checkState {
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    
    for (int i=0;i<[displayArray count]; i++) {
        IMBDriveEntity *entity = [displayArray objectAtIndex:i];
        [entity setCheckState:checkState];
        if (entity.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    [_itemTableView reloadData];
}
#pragma mark - NSTableView drop and drag
- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    NSArray *fileTypeList = [NSArray arrayWithObject:@"export"];
    [pboard setPropertyList:fileTypeList
                    forType:NSFilesPromisePboardType];
    if (tableView == _itemTableView) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - _itemTableView drag destination support
- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation {
    NSPasteboard *pastboard = [info draggingPasteboard];
    NSArray *fileTypeList = [pastboard propertyListForType:NSFilesPromisePboardType];
    if (fileTypeList == nil) {
        if (_itemTableViewcanDrop && tableView == _itemTableView) {
            return NSDragOperationCopy;
        }else {
            return NSDragOperationNone;
        }
    }else {
        return NSDragOperationNone;
    }
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation {
    NSPasteboard *pastboard = [info draggingPasteboard];
    NSArray *boarditemsArray = [pastboard pasteboardItems];
    NSMutableArray *itemArray = [NSMutableArray array];
    for (NSPasteboardItem *item in boarditemsArray) {
        NSString *urlPath = [item stringForType:@"public.file-url"];
        NSURL *url = [NSURL URLWithString:urlPath];
        NSString *path = [url relativePath];
        if (path == nil) {
            return NO;
        }
        [itemArray addObject:path];
        
    }
    [self dropToCollectionViewTableViewWithpaths:itemArray];
    return YES;
}

- (NSArray *)tableView:(NSTableView *)tableView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination forDraggedRowsWithIndexes:(NSIndexSet *)indexSet {
    NSArray *namesArray = nil;
    //获取目的url
    BOOL iconHide = NO;
    NSString *url = [dropDestination relativePath];
    //此处调用导出方法
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:indexSet,@"indexSet",url,@"url", nil];
    [self performSelector:@selector(delayCollectionViewTableViewdragToMac:) withObject:dic afterDelay:0.1];
    iconHide = YES;
    return namesArray;
}

#pragma mark - drag action
- (NSArray *)gridView:(CNGridView *)gridView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropURL forDraggedItemsAtIndexes:(NSIndexSet *)indexes {
    NSArray *namesArray = nil;
    //获取目的url
    NSString *url = [dropURL relativePath];
    //此处调用导出方法
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:indexes,@"indexSet",url,@"url", nil];
    [self performSelector:@selector(delayCollectionViewTableViewdragToMac:) withObject:dic afterDelay:0.1];
    return namesArray;
}

- (void)delayCollectionViewTableViewdragToMac:(NSDictionary *)param {
    NSString *url = [param objectForKey:@"url"];
    [self downloadWithPath:url];
}

#pragma mark - drop action
- (void)dropToCollectionViewTableViewWithpaths:(NSMutableArray *)pathsAry {
    [self addItemsDelay:pathsAry];
}

- (void)moveitemsToIndex:(int)index {
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else {
        displayArr = _dataSourceArray;
    }
    IMBDriveEntity *entity = [displayArr objectAtIndex:index];
    if (entity.isFolder && entity.checkState == UnChecked) {
        [self startMoveTransferWith:entity];
    }
}

#pragma mark - operation action
- (void)reload:(id)sender {
    __block NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    if (_chooseLogModelEnmu == iCloudLogEnum) {
        [ATTracker event:CiCloud action:ARefresh label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
        [ATTracker event:CDropbox action:ARefresh label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    _curEntity = nil;
    [_toolBarButtonView toolBarButtonIsEnabled:NO];
    [_contentBox setContentView:_loadingView];
    [_loadAnimationView startAnimation];
    [_driveBaseManage recursiveDirectoryContentsDics:_currentGetListPath];
    _isSearch = NO;
    [_researchdataSourceArray removeAllObjects];
    [_searhView setStringValue:@""];
    
    
}

- (void)showDetailView:(id)sender {
    if (_curEntity) {
        _isShow = YES;
        [self showFileDetailViewWithEntity:_curEntity];
    }
}

- (void)showFileDetailViewWithEntity:(IMBDriveEntity *)entity {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    if (_chooseLogModelEnmu == iCloudLogEnum) {
        [ATTracker event:CiCloud action:ADetail label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
        [ATTracker event:CDropbox action:ADetail label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [_rightContentView.layer removeAllAnimations];
    [_leftContentView.layer removeAllAnimations];
    
    if (_rightContentView.frame.origin.x < 820) {
        [self configDetailViewWith:entity];
    }else {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            NSRect rect= NSMakeRect(814, 0, 282, 548);
            NSRect rect2 = NSMakeRect(0, 0, 814, 548);
            [context setDuration:0.3];
            [[_rightContentView animator] setFrame:rect];
            [[_leftContentView animator] setFrame:rect2];
            
        } completionHandler:^{
            [self configDetailViewWith:entity];
        }];
    }
}

- (void)showDeviceDetailView:(NSNotification *)niti {
    if (_isShow) {
        [_detailImageView setFrame:NSMakeRect(96, 360, 90, 90)];
        if (_baseInfo.chooseModelEnum == iCloudLogEnum) {
            [_detailImageView setImage:[NSImage imageNamed:@"mod_iclouddrive"]];
            [_detailSizeContent setStringValue:[NSString stringWithFormat:@"%@ / %@",[StringHelper getFileSizeString:_baseInfo.kyDeviceSize reserved:2],[StringHelper getFileSizeString:_baseInfo.allDeviceSize reserved:2]]];
        }else {
            [_detailImageView setImage:[NSImage imageNamed:@"mod_dropboxdrive"]];
            [_detailSizeContent setStringValue:[NSString stringWithFormat:@"%@ / %@",[StringHelper getFileSizeString:_iPod.deviceInfo.totalDataAvailable reserved:2],[StringHelper getFileSizeString:_iPod.deviceInfo.totalDataCapacity reserved:2]]];
        }
        [_detailTitle setStringValue:_baseInfo.deviceName];
        
        
        [_detailCreateTime setHidden:YES];
        [_detailCreateTimeContent setHidden:YES];
//        [_detailSize setHidden:YES];
//        [_detailSizeContent setHidden:YES];
        [_detailCountContent setHidden:YES];
        [_detailCount setHidden:YES];
    }
}

- (IBAction)hideFileDetailView:(id)sender {
    if (_isShow) {
        [_rightContentView.layer removeAllAnimations];
        [_leftContentView.layer removeAllAnimations];
        
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            NSRect rect = NSMakeRect(1096, 0, 282,548);
            NSRect rect2 = NSMakeRect(0, 0, 1096, 548);
            [context setDuration:0.3];
            [[_rightContentView animator] setFrame:rect];
            [[_leftContentView animator] setFrame:rect2];
        } completionHandler:^{
            _isShow = NO;
        }];
    }
    
    if (_isShowTranfer) {
        IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
        [tranferView setDelegate:self];
        tranferView.reloadDelegate = self;
        [tranferView transferBtn:_transferBtn];
        _isShowTranfer = NO;
        [tranferView.view setFrame:NSMakeRect([_delegate window].contentView.frame.size.width - tranferView.view.frame.size.width + 8, - 8, 360, tranferView.view.frame.size.height)];
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBTranferBackgroundView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        [view setWantsLayer:YES];
        [view addSubview:tranferView.view];
        [tranferView.view setWantsLayer:YES];
        
        [tranferView.view.layer addAnimation:[IMBAnimation moveX:0.5 fromX:[NSNumber numberWithInt:0] toX:[NSNumber numberWithInt:tranferView.view.frame.size.width] repeatCount:1 beginTime:0]  forKey:@"moveX"];
    }
}

- (void)configDetailViewWith:(IMBDriveEntity *)entity {
    [_detailCreateTime setHidden:NO];
    [_detailCreateTimeContent setHidden:NO];
    [_detailSize setHidden:NO];
    [_detailSizeContent setHidden:NO];
    [_detailCountContent setHidden:NO];
    [_detailCount setHidden:NO];
    
    [_detailSize setStringValue:CustomLocalizedString(@"List_Header_id_Size", nil)];
    [_detailCount setStringValue:CustomLocalizedString(@"List_Header_id_Count", nil)];
    [_detailCreateTime setStringValue:CustomLocalizedString(@"List_Header_id_Date", nil)];
    
    [_detailSize setTextColor:COLOR_TEXT_ORDINARY];
    [_detailCount setTextColor:COLOR_TEXT_ORDINARY];
    [_detailCreateTime setTextColor:COLOR_TEXT_ORDINARY];
    [_detailTitle setTextColor:COLOR_TEXT_ORDINARY];
    
    [_detailImageView setFrame:NSMakeRect(101, 395, 80, 60)];
    
    [_detailImageView setImage:entity.image];
    [_detailTitle setStringValue:entity.fileName];
    
    if (entity.isFolder) {
        [_detailCountContent setHidden:NO];
        [_detailCount setHidden:NO];
        [_detailCreateTime setFrameOrigin:NSMakePoint(20, 184)];
        [_detailCreateTimeContent setFrameOrigin:NSMakePoint(130, 184)];
    }else {
        [_detailCountContent setHidden:YES];
        [_detailCount setHidden:YES];
        [_detailCreateTime setFrameOrigin:NSMakePoint(20, 213)];
        [_detailCreateTimeContent setFrameOrigin:NSMakePoint(130, 213)];
    }
    

    if ([StringHelper stringIsNilOrEmpty:entity.lastModifiedDateString]) {
        [_detailCreateTimeContent setStringValue:@"--"];
    } else {
        [_detailCreateTimeContent setStringValue:entity.lastModifiedDateString];
    }
    if (entity.fileSize == 0) {
            [_detailSizeContent setStringValue:@"--"];
    }else {
        [_detailSizeContent setStringValue:[IMBHelper getFileSizeString:entity.fileSize reserved:2]];
    }

    if (entity.childCount == 0) {
        [_detailCountContent setStringValue:@"--"];
    }else {
        [_detailCountContent setStringValue:[NSString stringWithFormat:@"%d",entity.childCount]];
    }
    
    
}

- (void)downloadToMac:(id)sender {
    _openPanel = [NSOpenPanel openPanel];
    [_openPanel setAllowsMultipleSelection:YES];
    [_openPanel setCanChooseFiles:YES];
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode== NSFileHandlingPanelOKButton) {
            [_transferBtn startTranfering];
            NSArray *urlArr = [_openPanel URLs];
            NSMutableArray *paths = [NSMutableArray array];
            for (NSURL *url in urlArr) {
                [paths addObject:url.path];
            }
            NSString *exportPath = [paths objectAtIndex:0];
            [self performSelector:@selector(downloadWithPath:) withObject:exportPath afterDelay:0.3];
        }
    }];
}

- (void)downloadWithPath:(NSString *)path {
    NSString *filePath = [path stringByAppendingString:@"/"];
//    if (_chooseLogModelEnmu == iCloudLogEnum) {
//        filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:@"iCloud"];
//    }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
//        filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:@"DropBox"];
//    }
//   
    NSIndexSet *selectedSet = [self selectedItems];
    NSMutableArray *preparedArray = [NSMutableArray array];
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else {
        displayArr = _dataSourceArray;
    }
    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [preparedArray addObject:[displayArr objectAtIndex:idx]];
    }];
    
    IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
    [tranferView setDelegate:self];
     tranferView.reloadDelegate = self;
    [tranferView transferBtn:_transferBtn];
    [_driveBaseManage setDownloadPath:filePath];
    if (_chooseLogModelEnmu == iCloudLogEnum) {
        [tranferView icloudDriveAddDataSource:preparedArray WithIsDown:YES WithDriveBaseManage:_driveBaseManage withUploadParent:nil withUploadDocID:@""];
    }else {
        [tranferView dropBoxAddDataSource:preparedArray WithIsDown:YES WithDriveBaseManage:_driveBaseManage withUploadParent:nil];
    }
}

-(void)toDevice:(id)sender {
    
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    NSMutableArray *deviceAry = [[NSMutableArray alloc]init];
    for (IMBBaseInfo *baseinfo in deviceConnection.allDevices) {
        if (baseinfo.chooseModelEnum == DeviceLogEnum) {
            [deviceAry addObject:baseinfo];
        }
    }
    if (deviceAry.count > 1) {
        if (_devChoosePopover != nil) {
            if (_devChoosePopover.isShown) {
                [_devChoosePopover close];
                return;
            }
        }
        if (_devChoosePopover != nil) {
            [_devChoosePopover release];
            _devChoosePopover = nil;
        }
        _devChoosePopover = [[NSPopover alloc] init];
        
        if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
            _devChoosePopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];
        }else {
            _devChoosePopover.appearance = NSPopoverAppearanceMinimal;
        }
        
        _devChoosePopover.animates = YES;
        _devChoosePopover.behavior = NSPopoverBehaviorTransient;
        _devChoosePopover.delegate = self;
        
        _devicePopoverViewController = [[IMBDevicePopoverViewController alloc] initWithChooseDeviceNibName:@"IMBDevicePopoverViewController" bundle:nil withDeviceAry:deviceAry withiPod:_iPod];
        if (_devChoosePopover != nil) {
            _devChoosePopover.contentViewController = _devicePopoverViewController;
        }
        [_devicePopoverViewController setTarget:self];
        [_devicePopoverViewController setAction:@selector(chooseDeviceBtnClick:)];
        [_devicePopoverViewController release];
        NSButton *targetButton = (NSButton *)sender;
        NSRectEdge prefEdge = NSMaxYEdge;
        NSRect rect = NSMakeRect(targetButton.bounds.origin.x, targetButton.bounds.origin.y, targetButton.bounds.size.width, targetButton.bounds.size.height);
        [_devChoosePopover showRelativeToRect:rect ofView:sender preferredEdge:prefEdge];
        
    }else if (deviceAry.count == 1){
        IMBDeviceConnection *conn = [IMBDeviceConnection singleton];
        IMBiPod *desIpod = nil;
        for (IMBiPod *ipod in conn.alliPods) {
            desIpod = ipod;
        }
        [self chooseDeviceBtnClick:desIpod];
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [IMBCommonTool showSingleBtnAlertInMainWindow:@"iCloud" btnTitle:CustomLocalizedString(@"Button_Ok", nil)  msgText:CustomLocalizedString(@"Nothave_toDevices", nil) btnClickedBlock:nil];
        });
    }
    [deviceAry release];
    deviceAry = nil;
}

- (void)chooseDeviceBtnClick:(id)sender {
    if (_devChoosePopover != nil) {
        [_devChoosePopover close];
    }
    IMBiPod *ipod = (IMBiPod *)sender;
//    IMBInformationManager *manager = [IMBInformationManager shareInstance];
//    IMBInformation *desInformation = [manager.informationDic objectForKey:baseInfo.uniqueKey];
    NSString *filePath = @"";
    filePath = [IMBHelper getAppRootPath];
    NSIndexSet *selectedSet = [self selectedItems];
    NSMutableArray *preparedArray = [NSMutableArray array];
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else {
        displayArr = _dataSourceArray;
    }
    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [preparedArray addObject:[displayArr objectAtIndex:idx]];
    }];

    IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
    [tranferView setDelegate:self];
    tranferView.reloadDelegate = self;
    [tranferView transferBtn:_transferBtn];
    [_driveBaseManage setDownloadPath:filePath];
    if (_chooseLogModelEnmu == iCloudLogEnum) {
        [tranferView icloudToDriveAddDataSource:preparedArray WithIsDown:YES WithDriveBaseManage:_driveBaseManage withUploadParent:nil withUploadDocID:@"" withiPod:ipod];
    }else {
        [tranferView dropBoxToDeviceAddDataSource:preparedArray WithIsDown:YES WithDriveBaseManage:_driveBaseManage withUploadParent:nil withiPod:ipod];
    }
}

- (void)toiCloud:(id)sender {
    _isDriveToDrive = YES;
    IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
    IMBBaseInfo *iCloudBaseInfo = nil;
    __block NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    if (_chooseLogModelEnmu == iCloudLogEnum) {
        for (IMBBaseInfo *baseInfo in connection.allDevices) {
            if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
                iCloudBaseInfo = baseInfo;
                [ATTracker event:CiCloud action:AToDropbox label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                break;
            }
        }
    }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
        for (IMBBaseInfo *baseInfo in connection.allDevices) {
            if (baseInfo.chooseModelEnum == iCloudLogEnum) {
                iCloudBaseInfo = baseInfo;
                [ATTracker event:CDropbox action:AToiCloudDrive label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                break;
            }
        }
    }
    
    if (iCloudBaseInfo) {
        NSIndexSet *selectedSet = [self selectedItems];
        NSMutableArray *preparedArray = [NSMutableArray array];
        NSArray *displayArr = nil;
        if (_isSearch) {
            displayArr = _researchdataSourceArray;
        }else {
            displayArr = _dataSourceArray;
        }
        [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            [preparedArray addObject:[displayArr objectAtIndex:idx]];
        }];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self driveToDriveDown:preparedArray];
        });
        [_transferBtn startTranfering];
    }else {
        if (_chooseLogModelEnmu == iCloudLogEnum) {
            [IMBCommonTool showSingleBtnAlertInMainWindow:@"iCloud" btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:CustomLocalizedString(@"iCloudBackup_View_Loggin_Tips", nil) btnClickedBlock:nil];

        }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
            [IMBCommonTool showSingleBtnAlertInMainWindow:@"DropBox" btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:CustomLocalizedString(@"iCloudBackup_View_Loggin_Tips", nil) btnClickedBlock:nil];

        }
    }
}

- (void)driveToDriveDown:(NSMutableArray *)ary{
    [_driveBaseManage setDownloadPath:[TempHelper getAppTempPath]];
    for (IMBDriveEntity *driveEntity in ary) {
        DriveItem *downloaditem = [[DriveItem alloc] init];
        [downloaditem setIsDownLoad:YES];
        downloaditem.itemIDOrPath = driveEntity.fileID;
        downloaditem.docwsID = driveEntity.docwsid;
        downloaditem.zone = driveEntity.zone;
        downloaditem.fileSize = driveEntity.fileSize;
        downloaditem.photoImage = [driveEntity.image retain];
        
        downloaditem.toDriveName = CustomLocalizedString(@"TransferDownloading", nil);
        if (driveEntity.isFolder) {
            if (!downloaditem.photoImage) {
                downloaditem.photoImage = [NSImage imageNamed:@"mac_cnt_fileicon_myfile"];
            }
            downloaditem.isFolder = YES;
            downloaditem.fileName = driveEntity.fileName;
        }else {
            downloaditem.isFolder = NO;
            if (driveEntity.extension){
                downloaditem.fileName = [[driveEntity.fileName stringByAppendingString:@"."] stringByAppendingString:driveEntity.extension];
            }else {
                downloaditem.fileName = driveEntity.fileName;
            }
            if (!downloaditem.photoImage) {
                downloaditem.photoImage = [TempHelper loadTransferFileImage:driveEntity.extension];
            }
        }
        
        [downloaditem setLocalPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:downloaditem.fileName]];
        [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        [_driveBaseManage oneDriveDownloadOneItem:downloaditem];
        [downloaditem release];
        downloaditem = nil;
    }
}

- (void)addItems:(id)sender {
    _openPanel = [NSOpenPanel openPanel];
    [_openPanel setAllowsMultipleSelection:YES];
    [_openPanel setCanChooseFiles:YES];
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode== NSFileHandlingPanelOKButton) {
            [_transferBtn startTranfering];
            NSArray *urlArr = [_openPanel URLs];
            NSMutableArray *paths = [NSMutableArray array];
            for (NSURL *url in urlArr) {
                [paths addObject:url.path];
            }
            [self performSelector:@selector(addItemsDelay:) withObject:paths afterDelay:0.3];
        }
    }];
}

- (void)addItemsDelay:(NSMutableArray *)paths {
    
//    [_contentBox setContentView:_loadingView];
//    [_loadAnimationView startAnimation];
//    [_driveBaseManage driveUploadItems:dataArr];
    IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
    [tranferView setDelegate:self];
     tranferView.reloadDelegate = self;
    [tranferView transferBtn:_transferBtn];
//    [_driveBaseManage setDownloadPath:pathStr];
    if (_chooseLogModelEnmu == iCloudLogEnum) {
       
        [tranferView icloudDriveAddDataSource:paths WithIsDown:NO WithDriveBaseManage:_driveBaseManage withUploadParent:_currentGetListPath withUploadDocID:_currentDevicePath];
    }else {
        [tranferView icloudDriveAddDataSource:paths WithIsDown:NO WithDriveBaseManage:_driveBaseManage withUploadParent:_currentGetListPath withUploadDocID:_currentDevicePath];
//        [tranferView dropBoxAddDataSource:preparedArray WithIsDown:YES WithDriveBaseManage:_driveBaseManage];
    }
    
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0/*延迟执行时间*/ * NSEC_PER_SEC));
//    dispatch_after(delayTime, dispatch_get_global_queue(0, 0), ^{
//        [_driveBaseManage recursiveDirectoryContentsDics:_currentDevicePath];
//    });
}

- (void)deleteItems:(id)sender {
    NSString *key = nil;
    if (_chooseLogModelEnmu == iCloudLogEnum) {
        key = IMBAlertViewiCloudKey;
    }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
        key = IMBAlertViewDropBoxKey;
    }
    [IMBCommonTool showTwoBtnsAlertInMainWindow:key firstBtnTitle:CustomLocalizedString(@"Button_Cancel", nil) secondBtnTitle:CustomLocalizedString(@"Button_Ok", nil)  msgText:CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete", nil) firstBtnClickedBlock:nil secondBtnClickedBlock:^{
        NSIndexSet *selectedSet = [self selectedItems];
        NSMutableArray *preparedArray = [NSMutableArray array];
        NSArray *displayArr = nil;
        if (_isSearch) {
            displayArr = _researchdataSourceArray;
        }else {
            displayArr = _dataSourceArray;
        }
        [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            [preparedArray addObject:[displayArr objectAtIndex:idx]];
        }];
        NSMutableArray *folderIdArr = [NSMutableArray array];
        for (IMBDriveEntity *entity in preparedArray) {
            if (_chooseLogModelEnmu == iCloudLogEnum) {
                [folderIdArr addObject:@{@"etag":entity.etag,@"drivewsid":entity.fileID}];
            }else {
                [folderIdArr addObject:entity.fileID];
            }
        }
        if (folderIdArr.count > 0) {
            [_contentBox setContentView:_loadingView];
            [_loadAnimationView startAnimation];
            [_driveBaseManage deleteDriveItem:folderIdArr];
            [_toolBarButtonView toolBarButtonIsEnabled:NO];
        }
    }];
    
}

- (void)doSwitchView:(id)sender {
    HoverButton *segBtn = (HoverButton *)sender;
    if (segBtn.switchBtnState == 1) {
        if (_dataSourceArray.count > 0) {
            [_contentBox setContentView:_tableViewBgView];
        }else {
            [_contentBox setContentView:_nodataView];
        }
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (int i=0;i<[_dataSourceArray count]; i++) {
            IMBDriveEntity *item= [_dataSourceArray objectAtIndex:i];
            if (item.checkState == NSOnState) {
                [set addIndex:i];
            }
        }
        [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
        
        _currentSelectView = 0;
        
    }else if (segBtn.switchBtnState == 0) {
        [_gridView reloadData];
        _currentSelectView = 1;
        if (_dataSourceArray.count > 0) {
            [_contentBox setContentView:_gridBgView];
        }else {
            [_contentBox setContentView:_nodataView];
        }
    }
    [_toolBarButtonView loadButtons:_toolBarArr Target:self DisplayMode:_currentSelectView];
    [self configRightKeyMenuItemWithConfigArr:_toolBarArr];
}

- (void)preBtnClick:(id)sender {
    NSIndexSet *selectedSet = [self selectedItems];
    NSMutableArray *preparedArray = [NSMutableArray array];
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else {
        displayArr = _dataSourceArray;
    }
    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [preparedArray addObject:[displayArr objectAtIndex:idx]];
    }];
    if (preparedArray.count > 0) {
        for (int i = 0; i < preparedArray.count; i ++) {
            IMBDriveEntity *driveEntity = [preparedArray objectAtIndex:i];
            if (!driveEntity.isFolder) {
                [self previewFile:driveEntity];
                break;
            }
        }
    }
}

- (void)changeContentViewWithDataArr:(NSMutableArray *)dataArr {
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    _dataSourceArray = [dataArr retain];
    
    
    
    [_gridView reloadData];
    [_itemTableView deselectAll:nil];
    [_itemTableView reloadData];
    if (_toolBarArr != nil) {
        [_toolBarArr release];
        _toolBarArr = nil;
    }
    _toolBarArr = [[NSArray alloc]initWithObjects:@(21),@(17),@(0),@(24),@(12), nil];
    if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
        if (_currentSelectView == 0) {
            [_contentBox setContentView:_tableViewBgView];
        } else {
            [_contentBox setContentView:_gridBgView];
        }
    } else {
        [_contentBox setContentView:_nodataView];
    }
    [_toolBarButtonView loadButtons:_toolBarArr Target:self DisplayMode:_currentSelectView];
    [self configRightKeyMenuItemWithConfigArr:_toolBarArr];
     [_toolBarButtonView toolBarButtonIsEnabled:YES];
    
    [self changeCheckboxState];
}

- (void)loadTransferComplete:(NSMutableArray *)transferAry WithEvent:(ActionTypeEnum)actionType {
    if (actionType == deleteAction) {
        [_toolBarButtonView toolBarButtonIsEnabled:YES];
        if (transferAry.count > 0) {
            for (NSString *foldId in transferAry) {
                [_dataSourceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([[(IMBDriveEntity *)obj fileID] isEqualToString:foldId]) {
                        [_dataSourceArray removeObject:obj];
                    }
                }];
            }
        }
        
        
        [_gridView reloadData];
        [_itemTableView deselectAll:nil];
        [_itemTableView reloadData];
        if (_toolBarArr != nil) {
            [_toolBarArr release];
            _toolBarArr = nil;
        }
        _toolBarArr = [[NSArray alloc]initWithObjects:@(21),@(17),@(0),@(24),@(12), nil];
        if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
            if (_currentSelectView == 0) {
                [_contentBox setContentView:_tableViewBgView];
            } else {
                [_contentBox setContentView:_gridBgView];
            }
        } else {
            [_contentBox setContentView:_nodataView];
        }
        [_toolBarButtonView loadButtons:_toolBarArr Target:self DisplayMode:_currentSelectView];
        [self configRightKeyMenuItemWithConfigArr:_toolBarArr];
        [_toolBarButtonView toolBarButtonIsEnabled:YES];
        [_loadAnimationView endAnimation];
        _curEntity = nil;
        [self reload:nil];
    }else if (actionType == loadAction) {
        if (_doubleClick) {
            [_oldDocwsidDic setObject:_currentDevicePath forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
            [_oldFileidDic setObject:_currentGetListPath forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
            [_tempDic setObject:transferAry forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
        }
        [self changeContentViewWithDataArr:transferAry];
        [_loadAnimationView endAnimation];
        _curEntity = nil;
    }else if (actionType == createFolder) {
        BOOL ret = [[transferAry objectAtIndex:0] boolValue];
        IMBDriveEntity *entity = [transferAry objectAtIndex:1];
        if (ret) {
            //提示创建成功
            [_promptLabel setTextColor:COLOR_TEXT_PRIORITY];
            [_promptImageView setImage:[NSImage imageNamed:@"message-box-success"]];
            [self addPromptCustomView:CustomLocalizedString(@"prompt_create_floder_success", nil)];
            [_itemTableView reloadData];
            [_gridView reloadData];
        }else {
            //提示创建失败
            [_promptLabel setTextColor:COLOR_TEXT_ERROR];
             [_promptImageView setImage:[NSImage imageNamed:@"message-box-error"]];
            [self addPromptCustomView:CustomLocalizedString(@"prompt_create_floder_failed", nil)];
            [_dataSourceArray removeObject:entity];
            [_itemTableView reloadData];
            [_gridView reloadData];
            _curEntity = nil;
        }
        entity.isCreating = NO;
    }
}

- (void)addPromptCustomView:(NSString *)prompt {
    NSRect rect = [IMBHelper calcuTextBounds:prompt fontSize:14];
    [_promptImageView setFrameOrigin:NSMakePoint(ceil((_promptCustomView.frame.size.width - _promptImageView.frame.size.width - 4 - rect.size.width)/2.0), _promptImageView.frame.origin.y)];
    [_promptLabel setFrameOrigin:NSMakePoint(_promptImageView.frame.origin.x + _promptImageView.frame.size.width + 4, _promptLabel.frame.origin.y)];
    
    [_promptLabel setStringValue:prompt];
    [_promptLabel setFont:[NSFont fontWithName:@"Helvetica Neue Light" size:14]];
    NSRect startFrame = NSMakeRect((_contentBox.frame.size.width - _promptCustomView.frame.size.width)/2, _contentBox.frame.size.height, _promptCustomView.frame.size.width, _promptCustomView.frame.size.height);
    NSRect endFrame = NSMakeRect((_contentBox.frame.size.width - _promptCustomView.frame.size.width)/2, _contentBox.frame.size.height - _promptCustomView.frame.size.height + 12, _promptCustomView.frame.size.width, _promptCustomView.frame.size.height);
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:_promptCustomView,NSViewAnimationTargetKey,NSViewAnimationFadeInEffect,NSViewAnimationEffectKey,[NSValue valueWithRect:startFrame],NSViewAnimationStartFrameKey,[NSValue valueWithRect:endFrame],NSViewAnimationEndFrameKey,nil];
    NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObject:dictionary]];
    
    animation.duration = 0.5;
    [animation setAnimationBlockingMode:NSAnimationNonblocking];
    [animation startAnimation];
    
    [_contentBox addSubview:_promptCustomView];
    [dictionary release];
    [animation release];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:_promptCustomView,NSViewAnimationTargetKey,NSViewAnimationFadeInEffect,NSViewAnimationEffectKey,[NSValue valueWithRect:endFrame],NSViewAnimationStartFrameKey,[NSValue valueWithRect:startFrame],NSViewAnimationEndFrameKey,nil];
        NSViewAnimation *ani1 = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObject:dic1]];
        
        ani1.duration = 0.5;
        [ani1 setAnimationBlockingMode:NSAnimationNonblocking];
        [ani1 startAnimation];
        
        [_contentBox addSubview:_promptCustomView];
        [dic1 release];
        [ani1 release];
    });
}

- (void)rename:(id)sender {
    NSIndexSet *selectedSet = [self selectedItems];
    if (selectedSet.count > 1) {
        [self showAlertText:CustomLocalizedString(@"System_id_1", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    
    if (_currentSelectView == 1) {
        _curEntity.isEdit = YES;
        _curEntity.isEditing = NO;
        [_gridView reloadData];
    }else {
        _isTableViewEdit = YES;
        NSUInteger row = [_itemTableView selectedRow];
        [_editTextField setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
        [_editTextField setFocusRingType:NSFocusRingTypeDefault];
        [_editTextField setStringValue:_curEntity.fileName];
        [_editTextField setEditable:YES];
        [_editTextField setSelectable:YES];
        
        [_editTextField setFrameOrigin:NSMakePoint(44, row*40)];
        [_itemTableView addSubview:_editTextField];
        [_editTextField becomeFirstResponder];
    }
    [_toolBarButtonView toolBarButtonIsEnabled:NO];
}

- (void)createNewFloder:(id)sender {
    if (_dataSourceArray != nil) {
        [_gridView deselectAllItems];
        IMBDriveEntity *newEntity = [[IMBDriveEntity alloc] init];
        newEntity.fileName = CustomLocalizedString(@"Function_New_Folder", nil);
        newEntity.isFolder = YES;
        newEntity.image = [NSImage imageNamed:@"mac_cnt_fileicon_myfile"];
        newEntity.extension = @"Folder";
        newEntity.isEdit = YES;
        newEntity.isCreate = YES;
        newEntity.isEditing = NO;
        newEntity.isCreating = NO;
        newEntity.checkState = Check;
        _curEntity = newEntity;
        [_dataSourceArray insertObject:newEntity atIndex:0];
        if (_currentSelectView == 1) {
            [_contentBox setContentView:_gridBgView];
            [_gridView reloadData];
        }else {
            [_contentBox setContentView:_tableViewBgView];
            [_itemTableView reloadData];
            NSMutableIndexSet *set = [NSMutableIndexSet indexSetWithIndex:0];
            [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
            
            _isTableViewEdit = YES;
            [_editTextField setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
            [_editTextField setFocusRingType:NSFocusRingTypeDefault];
            [_editTextField setStringValue:_curEntity.fileName];
            [_editTextField setEditable:YES];
            [_editTextField setSelectable:YES];

            [_editTextField setFrameOrigin:NSMakePoint(44, 0)];
            [_itemTableView addSubview:_editTextField];
            [_editTextField becomeFirstResponder];
        }
        [_toolBarButtonView toolBarButtonIsEnabled:NO];
        [newEntity release];
        newEntity = nil;
    }
}

- (void)executeRenameOrCreate {
    [_editTextField removeFromSuperview];
    if (_isTableViewEdit && !_curEntity.isCreating) {
        _isTableViewEdit = NO;
        if (_curEntity) {
            [self setNewNameWithName:[self checkoutName:_editTextField.stringValue]];
//            if ([self hasSameNameWithName:_editTextField.stringValue]) {
//                //TODO   添加新名字和已有名字重复的提醒
//                NSString *key = nil;
//                NSString *alertString = nil;
//                switch (_chooseLogModelEnmu) {
//                    case iCloudLogEnum:
//                    {
//                        key = IMBAlertViewiCloudKey;
//                    }
//                        break;
//                    case DropBoxLogEnum:
//                    {
//                        key = IMBAlertViewDropBoxKey;
//                    }
//                        break;
//                        
//                    default:
//                        break;
//                }
//                if (_curEntity.isFolder) {
//                    alertString = CustomLocalizedString(@"RenameTipsFolder", nil);
//                }else {
//                    alertString = CustomLocalizedString(@"RenameTipsFile", nil);
//                }
//                [IMBCommonTool showTwoBtnsAlertInMainWindow:key firstBtnTitle:CustomLocalizedString(@"Button_Cancel", nil) secondBtnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:alertString firstBtnClickedBlock:^{
//                    [self setNewNameWithName:[self checkoutName:_curEntity.fileName]];
//                } secondBtnClickedBlock:^{
//                    [self setNewNameWithName:[self checkoutName:_editTextField.stringValue]];
//                }];
//            }else {
//                [self setNewNameWithName:[self checkoutName:_editTextField.stringValue]];
//            }
            
        }
    }
    
}

- (void)setNewNameWithName:(NSString *)name {
    NSString *newName = [self checkoutName:_editTextField.stringValue];//_editTextField.stringValue;
    _editTextField.stringValue = newName;
    if (![StringHelper stringIsNilOrEmpty:newName] && ![_curEntity.fileName isEqualToString:newName]) {
        _curEntity.fileName = newName;
        if (_curEntity.extension && !_curEntity.isFolder){
            newName = [[newName stringByAppendingString:@"."] stringByAppendingString:_curEntity.extension];
        }
        if (_curEntity.isCreate) {
            _curEntity.isCreating = YES;
            if (_chooseLogModelEnmu == iCloudLogEnum) {
                [_driveBaseManage createFolder:newName parent:_currentGetListPath withEntity:_curEntity];
            }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
                [_driveBaseManage createFolder:newName parent:_currentDevicePath withEntity:_curEntity];
            }
        } else {
            if (_chooseLogModelEnmu == iCloudLogEnum) {
                NSDictionary *dic = @{@"drivewsid":_curEntity.fileID,@"etag":_curEntity.etag,@"name":newName};
                if (dic != nil) {
                    [(IMBiCloudDriveManager *)_driveBaseManage reNameWithDic:dic];
                }
            }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
                [(IMBDropBoxManage *)_driveBaseManage reName:newName idOrPath:_curEntity.fileID];
            }
        }
    }else {
        if (_curEntity.isCreate) {
            _curEntity.isCreating = YES;
            if (newName.length < 1) {
                newName = CustomLocalizedString(@"Function_New_Folder", nil);
            }
            _curEntity.fileName = newName;
            if (_chooseLogModelEnmu == iCloudLogEnum) {
                [_driveBaseManage createFolder:newName parent:_currentGetListPath withEntity:_curEntity];
            }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
                [_driveBaseManage createFolder:newName parent:_currentDevicePath withEntity:_curEntity];
            }
        }
    }
    _curEntity.isEdit = NO;
    _curEntity.isEditing = NO;
    _curEntity.isCreate = NO;
    [_toolBarButtonView toolBarButtonIsEnabled:YES];
}
- (NSString *)checkoutName:(NSString *)originalName {
    if ([originalName isEqualToString:@""] || [originalName isEqualToString:_curEntity.fileName]) {
        return originalName;
    }
    
    NSInteger count = _dataSourceArray.count;
    __block BOOL hasSameName = YES;
    NSMutableArray *sameEntityArr = [NSMutableArray array];
    if (_curEntity.isFolder) {
        for (NSInteger i = 0; i < count; i++) {
            IMBDriveEntity *entity = [_dataSourceArray objectAtIndex:i];
            if (entity.isFolder) {
                [sameEntityArr addObject:entity];
            }
        }
    }
    else {
        for (NSInteger i = 0; i < count; i++) {
            IMBDriveEntity *entity = [_dataSourceArray objectAtIndex:i];
            if ([_curEntity.extension isEqualToString:entity.extension]) {
                [sameEntityArr addObject:entity];
            }
        }
    }
    
    if (sameEntityArr.count) {
        NSInteger sameCount = sameEntityArr.count;
        BOOL isSameName = NO;
        int d = 2;
        for (NSInteger i = 0; i < sameCount; i++) {
            IMBDriveEntity *entity = [sameEntityArr objectAtIndex:i];
            if ([entity.fileName isEqualToString:originalName]) {
                if (entity == _curEntity) {
                    hasSameName = NO;
                    break;
                }
                isSameName = YES;
            }
        }
        while (hasSameName) {
            for (NSInteger i = 0; i < sameCount; i++) {
                IMBDriveEntity *entity = [sameEntityArr objectAtIndex:i];
                if ([entity.fileName isEqualToString:originalName]) {
                    if (entity == _curEntity) {
                        hasSameName = NO;
                        break;
                    }
                    if (d > 2) {
                        NSString *lastStr = [NSString stringWithFormat:@" %d",d-1];
                        originalName = [originalName substringToIndex:originalName.length - lastStr.length];
                    }
                    originalName = [NSString stringWithFormat:@"%@ %d",originalName,d++];
                    break;
                }
                if (i == sameCount - 1) {
                    hasSameName = NO;
                    break;
                }
            }
        }
    }
    
    return originalName;
    
}

- (BOOL)hasSameNameWithName:(NSString *)originalName {
    NSInteger count = _dataSourceArray.count;
    BOOL isSameName = NO;
    NSMutableArray *sameEntityArr = [NSMutableArray array];
    if (_curEntity.isFolder) {
        for (NSInteger i = 0; i < count; i++) {
            IMBDriveEntity *entity = [_dataSourceArray objectAtIndex:i];
            if (entity.isFolder) {
                [sameEntityArr addObject:entity];
            }
        }
    }
    else {
        for (NSInteger i = 0; i < count; i++) {
            IMBDriveEntity *entity = [_dataSourceArray objectAtIndex:i];
            if ([_curEntity.extension isEqualToString:entity.extension]) {
                [sameEntityArr addObject:entity];
            }
        }
    }
    
    if (sameEntityArr.count) {
        NSInteger sameCount = sameEntityArr.count;
        
        for (NSInteger i = 0; i < sameCount; i++) {
            IMBDriveEntity *entity = [sameEntityArr objectAtIndex:i];
            if ([entity.fileName isEqualToString:originalName]) {
                if (entity != _curEntity) {
                    isSameName = YES;
                    break;
                }
                
            }
        }
    }
    return isSameName;
    
}

- (void)moveToFolder:(id)sender {
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else {
        displayArr = _dataSourceArray;
    }
    NSMutableArray *folderArr = [NSMutableArray array];
    for (IMBDriveEntity *entity in displayArr) {
        if (entity.isFolder && entity.checkState == UnChecked) {
            [folderArr addObject:entity];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        if (view) {
            [view setHidden:NO];
            [_alertViewController setDelegete:self];
            [_alertViewController showSelectFolderAlertViewWithSuperView:view WithFolderArray:folderArr];
        }
        
    });
    
}

- (void)startMoveTransferWith:(IMBDriveEntity *)entity {
    [_toolBarButtonView toolBarButtonIsEnabled:NO];
    NSIndexSet *selectedSet = [self selectedItems];
    NSMutableArray *preparedArray = [NSMutableArray array];
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else {
        displayArr = _dataSourceArray;
    }
    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [preparedArray addObject:[displayArr objectAtIndex:idx]];
    }];
    NSMutableArray *moveItemsArr = [NSMutableArray array];
    for (IMBDriveEntity *itemEntity in preparedArray) {
        if (_chooseLogModelEnmu == iCloudLogEnum) {
            [moveItemsArr addObject:@{@"drivewsid":itemEntity.fileID,@"etag":itemEntity.etag,@"clientId":itemEntity.fileID}];
        }else {
            [moveItemsArr addObject:itemEntity.filePath];
        }
        
    }
    if (moveItemsArr.count > 0) {
        [_contentBox setContentView:_loadingView];
        [_loadAnimationView startAnimation];
        if (_chooseLogModelEnmu == iCloudLogEnum) {
            [(IMBiCloudDriveManager *)_driveBaseManage moveToNewParent:entity.fileID itemDics:moveItemsArr];
        }else {
            [(IMBDropBoxManage *)_driveBaseManage moveToNewParent:entity.filePath sourceParent:@"" idOrPaths:moveItemsArr];
        }
    }
    
    
}

- (void)previewFile:(IMBDriveEntity *)driveEntity {
    [_promptLabel setTextColor:COLOR_TEXT_EXPLAIN];
    [_promptImageView setImage:[NSImage imageNamed:@"message-box-progress"]];
    [self addPromptCustomView:CustomLocalizedString(@"prompt_perview_file", nil)];
    
    NSString *tempPath = [IMBHelper getAppTempPath];
    DriveItem *downloaditem = [[DriveItem alloc] init];
    downloaditem.itemIDOrPath = driveEntity.fileID;
    downloaditem.docwsID = driveEntity.docwsid;
    downloaditem.zone = driveEntity.zone;
    downloaditem.fileSize = driveEntity.fileSize;
    downloaditem.photoImage = [driveEntity.image retain];
    downloaditem.toDriveName = CustomLocalizedString(@"TransferDownloading", nil);
    downloaditem.localPath = [tempPath stringByAppendingPathComponent:downloaditem.fileName];
    if (!driveEntity.isFolder) {
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        if (_chooseLogModelEnmu == iCloudLogEnum) {
            [ATTracker event:CiCloud action:APreview label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
            [ATTracker event:CDropbox action:APreview label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        downloaditem.isFolder = NO;
        if (driveEntity.extension){
            downloaditem.fileName = [[driveEntity.fileName stringByAppendingString:@"."] stringByAppendingString:driveEntity.extension];
        }else {
            downloaditem.fileName = driveEntity.fileName;
        }
        [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        
        [_driveBaseManage setDownloadPath:tempPath];
        [_driveBaseManage oneDriveDownloadOneItem:downloaditem];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    id <DownloadAndUploadDelegate> item = object;

    if (_isDriveToDrive) {
        if (item.state == DownloadStateComplete) {
            
            IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
            IMBBaseInfo *iCloudBaseInfo = nil;
            if (_chooseLogModelEnmu == iCloudLogEnum) {
                for (IMBBaseInfo *baseInfo in connection.allDevices) {
                    if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
                        iCloudBaseInfo = baseInfo;
                    }
                }
            }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
                for (IMBBaseInfo *baseInfo in connection.allDevices) {
                    if (baseInfo.chooseModelEnum == iCloudLogEnum) {
                        iCloudBaseInfo = baseInfo;
                    }
                }
            }
//            NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
//            [workspace openFile:item.localPath];
            NSMutableArray *ary = [[NSMutableArray alloc] init];
            [ary addObject:item.localPath];
//                [self addItemsDelay:ary];
            IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
            [tranferView setDelegate:self];
             tranferView.reloadDelegate = self;
            [tranferView transferBtn:_transferBtn];
            [tranferView icloudDriveAddDataSource:ary WithIsDown:NO WithDriveBaseManage:iCloudBaseInfo.driveBaseManage withUploadParent:@"0" withUploadDocID:@"0"];
            [(NSObject*)item removeObserver:self forKeyPath:@"state"];
            [ary release];
            ary = nil;
        }else if (item.state == DownloadStateError){

            [(NSObject*)item removeObserver:self forKeyPath:@"state"];
        }
    }else {
        if (item.state == DownloadStateComplete) {
            NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
            [workspace openFile:item.localPath];
            [(NSObject*)item removeObserver:self forKeyPath:@"state"];
        }else if (item.state == DownloadStateError){
            
            [(NSObject*)item removeObserver:self forKeyPath:@"state"];
        }
    }
}

- (void)changeCheckboxState {
    if (_currentSelectView) return;
    
    NSIndexSet *set = [self selectedItems];
    NSMutableArray *disPalyAry = nil;
    if (_isSearch) {
        disPalyAry = _researchdataSourceArray;
    }else{
        disPalyAry = _dataSourceArray;
    }
    if (disPalyAry.count <=0) {
        return;
    }
    if (set.count == disPalyAry.count) {
        [_itemTableView changeHeaderCheckState:Check];
    }else if (set.count == 0){
        [_itemTableView changeHeaderCheckState:UnChecked];
    }else{
        [_itemTableView changeHeaderCheckState:SemiChecked];
    }
//    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    [_itemTableView reloadData];
}
#pragma mark 搜索 
- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchView {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    if (_chooseLogModelEnmu == iCloudLogEnum) {
        [ATTracker event:CiCloud action:ASearch label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }else if (_chooseLogModelEnmu == DropBoxLogEnum) {
        [ATTracker event:CDropbox action:ASearch label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    _searhView = searchView;
    _isSearch = YES;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fileName CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
    }
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    
    int checkCount = 0;
    for (int i=0; i<[disAry count]; i++) {
        IMBDriveEntity *entity = [disAry objectAtIndex:i];
        if (entity.checkState == NSOnState) {
            checkCount ++;
        }
    }
    if (checkCount == [disAry count]&&[disAry count]>0) {
        [_itemTableView changeHeaderCheckState:NSOnState];
    }else if (checkCount  == 0)
    {
        [_itemTableView changeHeaderCheckState:NSOffState];
    }else
    {
        [_itemTableView changeHeaderCheckState:NSMixedState];
    }
    
    [_itemTableView reloadData];
    [_gridView reloadData];
    
}

#pragma mark 传输按钮
- (void)transferBtn:(IMBHoverChangeImageBtn *)transferBtn {
    _transferBtn = transferBtn;
}

- (void)transferComplete:(int)successCount TotalCount:(int)totalCount {
    [self reload:nil];
    [_transferBtn endTranfering];
}

- (void)selectItemAry:(NSMutableArray *)itemAry {

    NSMutableArray *selectedAry = [[NSMutableArray alloc]init];
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    for (NSString *tag in itemAry) {
        IMBDriveEntity *driveEntity = [disAry objectAtIndex:[tag integerValue]];
        [selectedAry addObject:driveEntity];
    }
    IMBMoveTransferManager *moveManager = [IMBMoveTransferManager singleton];
    moveManager.originChooseModelEnum = _chooseLogModelEnmu;
    moveManager.originDriveBaseManager = _driveBaseManage;
    moveManager.selectedAry = [selectedAry retain];
    [selectedAry release];
    selectedAry = nil;
}

- (void)moveToItemIndex:(int)index {
    IMBMoveTransferManager *moveManager = [IMBMoveTransferManager singleton];
    moveManager.targerDriveBaseManager = _driveBaseManage;
    moveManager.targerChooseModelEnum = _chooseLogModelEnmu;
    if (moveManager.originChooseModelEnum == DeviceLogEnum) {
        IMBDeviceConnection *deivceConnection = [IMBDeviceConnection singleton];
        for (IMBBaseInfo *baseInfo in deivceConnection.allDevices) {
            if (baseInfo.chooseModelEnum == _chooseLogModelEnmu) {
                baseInfo.isSelected = YES;
            }
        }
        IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
        tranferView.reloadDelegate = self;
        [tranferView downDeviceDataSoure:moveManager.selectedAry WithIsDown:NO WithiPod:moveManager.origniPod withCategoryNodesEnum:moveManager.categoryNodeEnum isExportPath:[TempHelper getAppTempPath] withSystemPath:nil];
    }else {
        if (moveManager.originChooseModelEnum != moveManager.targerChooseModelEnum) {
            [moveManager driveToDriveDown:moveManager.selectedAry];
        }
    }
}

#pragma mark - 通知响应方法

- (void)renameTFInsertnewlinedown {
    [self gridViewDidDeselectAllItems:_gridView];
}

@end
