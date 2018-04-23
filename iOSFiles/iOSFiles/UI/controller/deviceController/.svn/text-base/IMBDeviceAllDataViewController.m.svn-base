//
//  IMBiCloudDriverViewController.m
//  iOSFiles
//
//  Created by smz on 18/3/14.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBDeviceAllDataViewController.h"
#import "CNGridViewItemLayout.h"
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
#import "IMBBookEntity.h"
#import "IMBAirSyncImportTransfer.h"
#import "IMBDeleteTrack.h"
#import "IMBDeleteApps.h"
#import "IMBBetweenDeviceHandler.h"
#import "IMBCommonTool.h"
#import "IMBPhotoFileExport.h"
#import "IMBiBooksExport.h"
#import "IMBMediaFileExport.h"
#import "IMBAppExport.h"
#import "IMBCommonTool.h"
#import "IMBDevicePageViewController.h"
#import "SystemHelper.h"
#import "IMBDevicePopoverViewController.h"
#import "IMBFileSystemExport.h"


#import "IMBViewManager.h"

@implementation IMBDeviceAllDataViewController

- (id)initWithCategoryNodesEnum:(CategoryNodesEnum )nodeEnum withiPod:(IMBiPod *)iPod WithDelegete:(id)delegete {
    if (self = [super initWithNibName:@"IMBDeviceAllDataViewController" bundle:nil]) {
        _categoryNodeEunm = nodeEnum;
        _iPod = iPod;
        _delegate = delegete;
    }
    return self;
}

- (void)dealloc {
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
    if (_editTextField) {
        [_editTextField release];
        _editTextField = nil;
    }
    [IMBNotiCenter removeObserver:self name:NOTIFY_SHOW_DEVICEDETAIL object:nil];
    
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_loadLeftMaskView setIsLeftToRight:YES];
    [_loadLeftMaskView setNeedsDisplay:YES];
    
    [_loadRightMaskView setIsLeftToRight:YES];
    [_loadRightMaskView setIsUpWhiteToClear:YES];
    [_loadRightMaskView setNeedsDisplay:YES];
    
    [(NSButtonCell *)_closeDetailBtn.cell setHighlightsBy:NSNoCellMask];
    [self configNoDataView];
    _currentSelectView = 1;
    [self changeToolButtonsIsSelectedIntems:NO];
    
    [_rightLineView setBackgroundColor:COLOR_TEXT_LINE];
    [_rightContentView setWantsLayer:YES];
    [_leftContentView setWantsLayer:YES];
    [_leftContentView setFrame:NSMakeRect(0, 0, 1096, 548)];
    [_rightContentView setFrame:NSMakeRect(1096, 0, 282, 548)];
    
    _oldWidthDic = [[NSMutableDictionary alloc] init];
    _oldDocwsidDic = [[NSMutableDictionary alloc] init];
    _tempDic = [[NSMutableDictionary alloc] init];
    [self configSelectPathButtonWithButtonTag:1 WithButtonTitle:_iPod.deviceInfo.deviceName];
    if (_categoryNodeEunm == Category_CameraRoll || _categoryNodeEunm == Category_PhotoStream || _categoryNodeEunm == Category_PhotoLibrary) {
        [self configSelectPathButtonWithButtonTag:2 WithButtonTitle:[StringHelper getCategeryStr:Category_Photos]];
        [self configSelectPathButtonWithButtonTag:3 WithButtonTitle:[StringHelper getCategeryStr:_categoryNodeEunm]];
    } else {
        [self configSelectPathButtonWithButtonTag:2 WithButtonTitle:[StringHelper getCategeryStr:_categoryNodeEunm]];
    }
    
    [IMBNotiCenter addObserver:self selector:@selector(showDeviceDetailView:) name:NOTIFY_SHOW_DEVICEDETAIL object:nil];
    
    _doubleclickCount = 2;
    [_topLineView setBackgroundColor:COLOR_TEXT_LINE];
    
    _gridView.itemSize = NSMakeSize(154, 154);
    _gridView.backgroundColor = [NSColor whiteColor];
    _gridView.scrollElasticity = NO;
    _gridView.allowsDragAndDrop = YES;
    _gridView.allowsMultipleSelection = YES;
    _gridView.allowsMultipleSelectionWithDrag = YES;
    _gridView.allowClickMultipleSelection = NO;
    [_gridView setIsFileManager:YES];
    _gridView.commandADown = ^{
        //commandA
        IMBFLog(@"commandA");
        [_gridView selectAllItems];
        [self setAllselectState:1];
        [self changeToolButtonsIsSelectedIntems:YES];
    };
    [_tableViewBgView setBackgroundColor:[NSColor whiteColor]];
    
    _itemTableViewcanDrop = YES;
    [_itemTableView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    [_itemTableView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:YES];
    //注册该表的拖动类型
    [_itemTableView registerForDraggedTypes:[NSArray arrayWithObjects:NSFilesPromisePboardType,NSFilenamesPboardType,nil]];
    _chooseLogModelEnmu = DeviceLogEnum;
    IMBTranferViewController *tranferVC = [IMBTranferViewController singleton];
    tranferVC.delegate = self;
    tranferVC.reloadDelegate = self;
    if (_categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
        _currentDevicePath = @"/";
        [_loadAnimationView startAnimation];
        [_contentBox setContentView:_loadingView];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _systemManager = [[IMBFileSystemManager alloc] initWithiPodByExport:_iPod];
            [_systemManager setDelegate:self];
            if (_categoryNodeEunm == Category_Storage) {
                _dataSourceArray = [(NSMutableArray *)[_systemManager recursiveDirectoryContentsDics:@"/general_storage"] retain];
                 _currentDevicePath = @"/general_storage";
            }else {
                _dataSourceArray = [(NSMutableArray *)[_systemManager recursiveDirectoryContentsDics:@"/"] retain];
                 _currentDevicePath = @"/";
            }
           
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_oldDocwsidDic setObject:_currentDevicePath forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
                [_tempDic setObject:_dataSourceArray forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
                
                if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
                    [_itemTableView reloadData];
                    [_gridView reloadData];
                    [_contentBox setContentView:_gridBgView];
                } else {
                    [_contentBox setContentView:_nodataView];
                }
                [_loadAnimationView endAnimation];
                [_itemTableView reloadData];
                [_gridView reloadData];
            });
        });
    }else {
        [self loadDataAry];
        if (_categoryNodeEunm == Category_Media) {
            [self setInitlializationViewWithIsDataLoadCompleted:_iPod.mediaLoadFinished];
        }else if (_categoryNodeEunm == Category_Video) {
            [self setInitlializationViewWithIsDataLoadCompleted:_iPod.videoLoadFinished];
        }else if (_categoryNodeEunm == Category_iBooks) {
            [self setInitlializationViewWithIsDataLoadCompleted:_iPod.bookLoadFinished];
        }else if (_categoryNodeEunm == Category_Applications ) {
            [self setInitlializationViewWithIsDataLoadCompleted:_iPod.appsLoadFinished];
        }else if (_categoryNodeEunm == Category_PhotoStream) {
            [self setInitlializationViewWithIsDataLoadCompleted:_iPod.photoLoadFinished];
        }else if (_categoryNodeEunm == Category_appDoucment) {
            [self setInitlializationViewWithIsDataLoadCompleted:_iPod.appDoucmentFinished];
        }else if (_categoryNodeEunm == Category_PhotoLibrary) {
            [self setInitlializationViewWithIsDataLoadCompleted:_iPod.photoLoadFinished];
        }else if (_categoryNodeEunm == Category_CameraRoll) {
            [self setInitlializationViewWithIsDataLoadCompleted:_iPod.photoLoadFinished];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoLoadFinished:) name:DeviceDataLoadCompletePhoto object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appLoadFinished:) name:DeviceDataLoadCompleteApp object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bookLoadFinished:) name:deviceDataLoadCompleteBooks object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaLoadFinished:) name:deviceDataLoadCompleteMedia object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoLoadFinished:) name:DeviceDataLoadCompleteVideo object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDoumentLoadFinished:) name:DeviceDataLoadCompleteAppDoucment object:nil];

    }
    if (_categoryNodeEunm == Category_appDoucment) {
        _isSmipNode = YES;
    }
    _editTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 296, 60)];
}

- (void)loadApplicationsData {
    if (_isSmipNode) {
        _isSmipNode = NO;
        if (_dataSourceArray) {
            [_dataSourceArray release];
            _dataSourceArray = nil;
        }
        _dataSourceArray = [_information.appArray retain];
        if (_currentSelectView == 0) {
            [_itemTableView reloadData];
        }else {
            [_gridView reloadData];
        }
    }
}

- (void)setInitlializationViewWithIsDataLoadCompleted:(BOOL)isCompleted {
    if (isCompleted) {
        if (_dataSourceArray != nil && _dataSourceArray.count > 0 ) {
            if (_currentSelectView == 0) {
                [_contentBox setContentView:_tableViewBgView];
            }else {
                [_contentBox setContentView:_gridBgView];
            }
        } else {
            [_contentBox setContentView:_nodataView];
        }
        [_itemTableView reloadData];
        [_gridView reloadData];
    }else {
        [_toolBarButtonView toolBarButtonIsEnabled:NO];
        [_loadAnimationView startAnimation];
        [_contentBox setContentView:_loadingView];
    }
}

- (void)loadDataAry {
    IMBInformationManager *inforManager = [IMBInformationManager shareInstance];
    _information = [inforManager.informationDic objectForKey:_iPod.uniqueKey];
    if (_categoryNodeEunm == Category_Photos) {
        _dataSourceArray = [_information.allPhotoArray retain];
    }else if (_categoryNodeEunm == Category_Media) {
        _dataSourceArray = [_information.mediaArray retain];
    }else if (_categoryNodeEunm == Category_Video) {
        _dataSourceArray = [_information.videoArray retain];
    }else if (_categoryNodeEunm == Category_iBooks) {
        _dataSourceArray = [_information.allBooksArray retain];
    }else if (_categoryNodeEunm == Category_Applications ) {
        _dataSourceArray = [_information.appArray retain];
        if ([_iPod.deviceInfo.productVersion isVersionMajorEqual:@"8.3"]) {
            _currentDevicePath = @"/Documents";
        }else {
            _currentDevicePath = @"/";
        }
        [_oldDocwsidDic setObject:_currentDevicePath forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
        if (_dataSourceArray) {
            [_tempDic setObject:_dataSourceArray forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
        }
    }else if (_categoryNodeEunm == Category_appDoucment){
        _dataSourceArray = [_information.appDoucmentArray retain];
//        [_oldDocwsidDic setObject:_currentDevicePath forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
        if (_dataSourceArray) {
            [_tempDic setObject:_dataSourceArray forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
        }
    }else if (_categoryNodeEunm == Category_PhotoStream) {
        _dataSourceArray = [_information.photostreamArray retain];
    }else if (_categoryNodeEunm == Category_PhotoLibrary) {
        _dataSourceArray = [_information.photolibraryArray retain];
    }else if (_categoryNodeEunm == Category_CameraRoll) {
        _dataSourceArray = [_information.allPhotoArray retain];
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

#pragma mark - 搜索
- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchView {
    _searhView = searchView;
    _isSearch = YES;
    NSDictionary *dimensionDict = nil;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = nil;
        if (_categoryNodeEunm == Category_Media||_categoryNodeEunm == Category_Video) {
            @autoreleasepool {
                [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                dimensionDict = [[TempHelper customDimension] copy];
            }
            predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ ",searchStr];
        }else if (_categoryNodeEunm == Category_iBooks) {
            @autoreleasepool {
                [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                dimensionDict = [[TempHelper customDimension] copy];
            }
            predicate = [NSPredicate predicateWithFormat:@"bookName CONTAINS[cd] %@ ",searchStr];
        }else if (_categoryNodeEunm == Category_Applications || _categoryNodeEunm == Category_appDoucment) {
            @autoreleasepool {
                [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                dimensionDict = [[TempHelper customDimension] copy];
            }
            if (_isSmipNode) {
                predicate = [NSPredicate predicateWithFormat:@"fileName CONTAINS[cd] %@ ",searchStr];
            }else {
                predicate = [NSPredicate predicateWithFormat:@"appName CONTAINS[cd] %@ ",searchStr];
            }
        }else if (_categoryNodeEunm == Category_System||_categoryNodeEunm == Category_Storage) {
            @autoreleasepool {
                [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                dimensionDict = [[TempHelper customDimension] copy];
            }
            predicate = [NSPredicate predicateWithFormat:@"fileName CONTAINS[cd] %@ ",searchStr];
        }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
            @autoreleasepool {
                [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                dimensionDict = [[TempHelper customDimension] copy];
            }
            predicate = [NSPredicate predicateWithFormat:@"photoName CONTAINS[cd] %@ ",searchStr];
        }
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
    }
    [ATTracker event:CDevice action:ASearch label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
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

- (void)transferBtn:(IMBHoverChangeImageBtn *)transferBtn {
    _transferBtn = transferBtn;
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
    if (_categoryNodeEunm == Category_CameraRoll || _categoryNodeEunm == Category_PhotoStream || _categoryNodeEunm == Category_PhotoLibrary) {
        if (buttonTag == 3) {
            [button setEnabled:NO];
        }
    } else {
        if (buttonTag == 2 && _categoryNodeEunm != Category_System &&( _categoryNodeEunm != Category_Applications|| _categoryNodeEunm != Category_appDoucment) &&_categoryNodeEunm != Category_Storage) {
            [button setEnabled:NO];
        }
    }
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
    if (tag == 1 || _categoryNodeEunm == Category_CameraRoll || _categoryNodeEunm == Category_PhotoStream || _categoryNodeEunm == Category_PhotoLibrary) {
        [_delegate backAction:sender];
    } else {
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
                }
                _doubleclickCount = i;
                
                break;
            }
        }
        
        if (_doubleclickCount == 2) {
            _isSmipNode = NO;
            [self changeToolButtonsIsSelectedIntems:NO];
        }else {
            _isSmipNode = YES;
        }
        if ([_oldDocwsidDic.allKeys containsObject:[NSString stringWithFormat:@"%d",tag]]) {
            _currentDevicePath = [_oldDocwsidDic objectForKey:[NSString stringWithFormat:@"%d",tag]];
        }
    }
    
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
    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    [_itemTableView reloadData];
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
    if (_gridView.selectedItems.count > 0) {
        [self changeToolButtonsIsSelectedIntems:YES];
    }else {
        [self changeToolButtonsIsSelectedIntems:NO];
    }
    
    if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
        if (_currentSelectView == 0) {
            [_contentBox setContentView:_tableViewBgView];
        } else {
            [_contentBox setContentView:_gridBgView];
        }
    } else {
        [_contentBox setContentView:_nodataView];
    }
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
    item.isFileManager = YES;
    
    if (_categoryNodeEunm == Category_Media || _categoryNodeEunm == Category_Video) {
        IMBTrack *track = [array objectAtIndex:index];
        if (_categoryNodeEunm == Category_Media) {
            item.bgImg = [NSImage imageNamed:@"cnt_fileicon_music"];
        } else {
            item.bgImg = [NSImage imageNamed:@"cnt_fileicon_video"];
        }
        item.itemTitle = track.title;
        item.selected = track.checkState;
        
        if (track.thumbImage) {
            item.itemImage = track.thumbImage;
        } else {
            NSData *data = [self createThumbImage:track];
            NSImage *itemImage = [[NSImage alloc] initWithData:data];
            item.itemImage = itemImage;
            if (itemImage) {
                track.thumbImage = itemImage;
            } else {
                track.thumbImage = item.bgImg;
            }
        }
        
        if (track.checkState == Check) {
            if (![gridView.selectedItems containsObject:item]) {
                [[gridView getSelectedItemsDic] setObject:item forKey:@(item.index)];
            }
        }else{
            if ([gridView.selectedItems containsObject:item]) {
                [[gridView getSelectedItemsDic] removeObjectForKey:@(item.index)];
            }
        }
    }else if (_categoryNodeEunm == Category_iBooks) {
        
        IMBBookEntity *bookEntity = [array objectAtIndex:index];
        item.bgImg = [NSImage imageNamed:@"cnt_fileicon_books"];
        item.itemTitle = bookEntity.bookName;
        item.selected = bookEntity.checkState;
        item.itemImage = bookEntity.coverImage;
        if (bookEntity.checkState == Check) {
            if (![gridView.selectedItems containsObject:item]) {
                [[gridView getSelectedItemsDic] setObject:item forKey:@(item.index)];
            }
        }else{
            if ([gridView.selectedItems containsObject:item]) {
                [[gridView getSelectedItemsDic] removeObjectForKey:@(item.index)];
            }
        }
    }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
        
        id entity = [array objectAtIndex:index];
        if ([entity isKindOfClass:[IMBAppEntity class]]) {
            IMBAppEntity *appEntity = (IMBAppEntity *)entity;
            item.bgImg = [NSImage imageNamed:@"folder_icon_app"];
            item.itemTitle = appEntity.appName;
            item.selected = appEntity.checkState;
            item.itemImage = appEntity.appIconImage;
            if (appEntity.checkState == Check) {
                if (![gridView.selectedItems containsObject:item]) {
                    [[gridView getSelectedItemsDic] setObject:item forKey:@(item.index)];
                }
            }else{
                if ([gridView.selectedItems containsObject:item]) {
                    [[gridView getSelectedItemsDic] removeObjectForKey:@(item.index)];
                }
            }
        }else if ([entity isKindOfClass:[SimpleNode class]]) {
            SimpleNode *fileEntity = (SimpleNode *)entity;
            item.bgImg = [NSImage imageNamed:@"folder_icon_app"];
            item.itemTitle = fileEntity.fileName;
            item.selected = fileEntity.checkState;
            item.itemImage = fileEntity.image;
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
        }
    }else if (_categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
        SimpleNode *simpleNode = [array objectAtIndex:index];
        item.bgImg = [NSImage imageNamed:@"cnt_fileicon_common"];
        item.itemTitle = simpleNode.fileName;
        item.selected = simpleNode.checkState;
        item.itemImage = simpleNode.image;
        item.isEdit = simpleNode.isEdit;
        item.entity = simpleNode;
        item.category = _categoryNodeEunm;
        if (simpleNode.checkState == Check) {
            if (![gridView.selectedItems containsObject:item]) {
                [[gridView getSelectedItemsDic] setObject:item forKey:@(item.index)];
            }
        }else{
            if ([gridView.selectedItems containsObject:item]) {
                [[gridView getSelectedItemsDic] removeObjectForKey:@(item.index)];
            }
        }
    }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
        IMBPhotoEntity *photoEntity = [array objectAtIndex:index];
        item.bgImg = [NSImage imageNamed:@"cnt_fileicon_img"];
        item.itemTitle = photoEntity.photoName;
        item.selected = photoEntity.checkState;
        if (photoEntity.photoImage) {
            item.itemImage = photoEntity.photoImage;
        } else {
            NSData *imageData = [self createImageToTableView:photoEntity];
            NSImage *photoImage = [[NSImage alloc] initWithData:imageData];
            item.itemImage = photoImage;
            if (photoImage) {
                photoEntity.photoImage = photoImage;
            } else {
                photoEntity.photoImage = item.bgImg;
            }
            
            [photoImage release];
        }
        
        if (photoEntity.checkState == Check) {
            if (![gridView.selectedItems containsObject:item]) {
                [[gridView getSelectedItemsDic] setObject:item forKey:@(item.index)];
            }
        }else{
            if ([gridView.selectedItems containsObject:item]) {
                [[gridView getSelectedItemsDic] removeObjectForKey:@(item.index)];
            }
        }
    }
    return item;
}

#pragma mark - CNGridView Delegate
- (void)gridView:(CNGridView *)gridView didSelectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
    [self changeToolButtonsIsSelectedIntems:YES];
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    if (index < array.count) {
        if (_categoryNodeEunm == Category_Media || _categoryNodeEunm == Category_Video) {
            IMBTrack *track = [array objectAtIndex:index];
            track.checkState = Check;
        }else if (_categoryNodeEunm == Category_iBooks) {
            IMBBookEntity *bookEntity = [array objectAtIndex:index];
            bookEntity.checkState = Check;
        }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
            id entity = [array objectAtIndex:index];
            if ([entity isKindOfClass:[IMBAppEntity class]]) {
                IMBAppEntity *appEntity = (IMBAppEntity *)entity;
                appEntity.checkState = Check;
            }else if ([entity isKindOfClass:[SimpleNode class]]) {
                SimpleNode *fileEntity = (SimpleNode *)entity;
                fileEntity.checkState = Check;
            }
        }else if (_categoryNodeEunm == Category_System||_categoryNodeEunm == Category_Storage) {
            SimpleNode *simpleNode = [array objectAtIndex:index];
            simpleNode.checkState = Check;
        }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
            IMBPhotoEntity *photoEnity = [array objectAtIndex:index];
            photoEnity.checkState = Check;
        }
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
        if (_categoryNodeEunm == Category_Media || _categoryNodeEunm == Category_Video) {
            IMBTrack *track = [array objectAtIndex:index];
            track.checkState = UnChecked;
        }else if (_categoryNodeEunm == Category_iBooks) {
            IMBBookEntity *bookEntity = [array objectAtIndex:index];
            bookEntity.checkState = UnChecked;
        }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
            id entity = [array objectAtIndex:index];
            if ([entity isKindOfClass:[IMBAppEntity class]]) {
                IMBAppEntity *appEntity = (IMBAppEntity *)entity;
                appEntity.checkState = UnChecked;
            }else if ([entity isKindOfClass:[SimpleNode class]]) {
                SimpleNode *fileEntity = (SimpleNode *)entity;
                fileEntity.checkState = UnChecked;
            }
        }else if (_categoryNodeEunm == Category_System||_categoryNodeEunm == Category_Storage) {
            SimpleNode *simpleNode = [array objectAtIndex:index];
            simpleNode.checkState = UnChecked;
        }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
            IMBPhotoEntity *photoEnity = [array objectAtIndex:index];
            photoEnity.checkState = UnChecked;
            
        }
    }
}

- (void)gridViewDidDeselectAllItems:(CNGridView *)gridView {
    if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment || _categoryNodeEunm == Category_System ||_categoryNodeEunm == Category_Storage) {
        if ((_isSmipNode || _categoryNodeEunm == Category_System||_categoryNodeEunm == Category_Storage) && _curEntity) {
            SimpleNode *node = [(SimpleNode *)_curEntity retain];
            if (node.isEdit && !node.isCreating) {
                NSArray *selectArr = [_gridView keyedVisibleItems];
                NSString *newName = @"";
                CNGridViewItem *curItem = nil;
                for (CNGridViewItem *item in selectArr) {
                    if (item.isEdit) {
                        curItem = item;
                        break;
                    }
                }
                BOOL isDelete = NO;
                NSDictionary *dimensionDict = nil;
                if (curItem) {
                    if (![StringHelper stringIsNilOrEmpty:curItem.editText.stringValue] ) {
                        NSString *str = curItem.editText.stringValue;
                        if (node.extension && !node.container){
                            newName = [[str stringByAppendingString:@"."] stringByAppendingString:node.extension];
                        }else {
                            newName = str;
                        }
                        if (node.isCreate) {
                            node.isCreating = YES;
                            BOOL ret = NO;
                            if (_categoryNodeEunm == Category_System||_categoryNodeEunm == Category_Storage) {
                                ret = [_systemManager createFolder:[_currentDevicePath stringByAppendingPathComponent:newName]];
                                @autoreleasepool {
                                    [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                                    dimensionDict = [[TempHelper customDimension] copy];
                                }
                            }else {
                                AFCApplicationDirectory *afcAppmd = [_iPod.deviceHandle newAFCApplicationDirectory:_appKey];
                                ret = [[_information applicationManager] createAppFolder:[_currentDevicePath stringByAppendingPathComponent:newName] appAFC:afcAppmd];
                                [afcAppmd close];
                            }
                            node.isCreating = NO;
                            [_promptLabel setTextColor:COLOR_TEXT_PRIORITY];
                            if (ret) {
                                [ATTracker event:CDevice action:ACreateFolder label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                                node.fileName = curItem.editText.stringValue;
                                node.path = [_currentDevicePath stringByAppendingPathComponent:newName];
                                [self addPromptCustomView:CustomLocalizedString(@"prompt_create_floder_success", nil)];
                            }else {
                                [ATTracker event:CDevice action:ACreateFolder label:LFailed labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                                [self addPromptCustomView:CustomLocalizedString(@"prompt_create_floder_failed", nil)];
                                [_dataSourceArray removeObject:node];
                                isDelete = YES;
                                _curEntity = nil;
                            }
                                    node.isCreating = NO;
                                    [_promptLabel setTextColor:COLOR_TEXT_PRIORITY];
                                    if (ret) {
                                        node.fileName = curItem.editText.stringValue;
                                        node.path = [_currentDevicePath stringByAppendingPathComponent:newName];
                                        [_promptImageView setImage:[NSImage imageNamed:@"message-box-success"]];
                                        [self addPromptCustomView:CustomLocalizedString(@"prompt_create_floder_success", nil)];
                                    }else {
                                        [_promptImageView setImage:[NSImage imageNamed:@"message-box-error"]];
                                        [self addPromptCustomView:CustomLocalizedString(@"prompt_create_floder_failed", nil)];
                                        [_dataSourceArray removeObject:node];
                                        isDelete = YES;
                                        _curEntity = nil;
                                    }
                        } else {
                            BOOL ret = NO;
                            if (_categoryNodeEunm == Category_System||_categoryNodeEunm == Category_Storage) {
                                @autoreleasepool {
                                    [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                                    dimensionDict = [[TempHelper customDimension] copy];
                                }
                                ret = [_systemManager rename:node withfileName:newName];
                            }else {
                                AFCApplicationDirectory *afcAppmd = [_iPod.deviceHandle newAFCApplicationDirectory:_appKey];
                                ret = [[_information applicationManager] rename:node.path withfileName:newName appAFC:afcAppmd];
                                [afcAppmd close];
                            }
                            if (ret) {
                                [ATTracker event:CDevice action:ARename label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                                NSString *newfilePath = [[node.path stringByDeletingLastPathComponent] stringByAppendingPathComponent:newName];
                                node.fileName = str;
                                node.path = newfilePath;
                            }else {
                                [ATTracker event:CDevice action:ARename label:LFailed labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                            }
                        }
                    }else {
                        if (node.isCreate) {
                            node.isCreating = YES;
                            BOOL ret = NO;
                            if (_categoryNodeEunm == Category_System||_categoryNodeEunm == Category_Storage) {
                                @autoreleasepool {
                                    [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                                    dimensionDict = [[TempHelper customDimension] copy];
                                }
                                
                                ret = [_systemManager createFolder:[_currentDevicePath stringByAppendingPathComponent:newName]];
                            }else {
                                AFCApplicationDirectory *afcAppmd = [_iPod.deviceHandle newAFCApplicationDirectory:_appKey];
                                ret = [[_information applicationManager] createAppFolder:[_currentDevicePath stringByAppendingPathComponent:newName] appAFC:afcAppmd];
                                [afcAppmd close];
                            }
                            node.isCreating = NO;
                            [_promptLabel setTextColor:COLOR_TEXT_PRIORITY];
                            if (ret) {
                                [ATTracker event:CDevice action:ACreateFolder label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                                node.fileName = curItem.editText.stringValue;
                                node.path = [_currentDevicePath stringByAppendingPathComponent:newName];
                                [self addPromptCustomView:CustomLocalizedString(@"prompt_create_floder_success", nil)];
                            }else {
                                [ATTracker event:CDevice action:ACreateFolder label:LFailed labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                                [self addPromptCustomView:CustomLocalizedString(@"prompt_create_floder_failed", nil)];
                                [_dataSourceArray removeObject:node];
                                isDelete = YES;
                                _curEntity = nil;
                            }
                                    node.isCreating = NO;
                                    [_promptLabel setTextColor:COLOR_TEXT_PRIORITY];
                                    if (ret) {
                                        node.fileName = curItem.editText.stringValue;
                                        node.path = [_currentDevicePath stringByAppendingPathComponent:newName];
                                        [_promptImageView setImage:[NSImage imageNamed:@"message-box-success"]];
                                        [self addPromptCustomView:CustomLocalizedString(@"prompt_create_floder_success", nil)];
                                    }else {
                                        [_promptImageView setImage:[NSImage imageNamed:@"message-box-error"]];
                                        [self addPromptCustomView:CustomLocalizedString(@"prompt_create_floder_failed", nil)];
                                        [_dataSourceArray removeObject:node];
                                        isDelete = YES;
                                        _curEntity = nil;
                                    }
                        }
                    }
                }
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                if (!isDelete) {
                    node.isEditing = NO;
                    node.isEdit = NO;
                    node.isCreate = NO;
                }
                [_toolBarButtonView toolBarButtonIsEnabled:YES];
                [_gridView reloadData];
            }
        }
    }
    
    [self changeToolButtonsIsSelectedIntems:NO];
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    if (_categoryNodeEunm == Category_Media || _categoryNodeEunm == Category_Video) {
        for (IMBTrack *track in array) {
            track.checkState = UnChecked;
        }
    }else if (_categoryNodeEunm == Category_iBooks) {
        for (IMBBookEntity *bookEntity in array) {
            bookEntity.checkState = UnChecked;
        }
    }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
        for (id entity in array) {
            if ([entity isKindOfClass:[IMBAppEntity class]]) {
                IMBAppEntity *appEntity = (IMBAppEntity *)entity;
                appEntity.checkState = UnChecked;
            }else if ([entity isKindOfClass:[SimpleNode class]]) {
                SimpleNode *fileEntity = (SimpleNode *)entity;
                fileEntity.checkState = UnChecked;
            }
        }
    }else if (_categoryNodeEunm == Category_System||_categoryNodeEunm == Category_Storage) {
        for (SimpleNode *simpleNode in array) {
            simpleNode.checkState = UnChecked;
        }
    }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
        for (IMBPhotoEntity *photoEnity in array) {
            photoEnity.checkState = UnChecked;
        }
    }
    [_gridView reloadSelecdImage];
}

- (void)gridView:(CNGridView *)gridView didDoubleClickItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
    [_itemTableView changeHeaderCheckState:UnChecked];
    [self hideFileDetailView:nil];
    
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    if ((int)index >= 0 && index < array.count) {
        if (_categoryNodeEunm == Category_System||_categoryNodeEunm ==Category_Storage) {
            SimpleNode *selectedNode = [array objectAtIndex:index];
            if (!selectedNode.container) {
                return;
            }
            _isSearch = NO;
            [_researchdataSourceArray removeAllObjects];
            [_searhView setStringValue:@""];
            
            [_loadAnimationView startAnimation];
            [_contentBox setContentView:_loadingView];
            if (selectedNode.container) {
                _doubleclickCount ++;
                [self configSelectPathButtonWithButtonTag:_doubleclickCount WithButtonTitle:selectedNode.fileName];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    @autoreleasepool {
                        NSArray *array = [_systemManager recursiveDirectoryContentsDics:selectedNode.path];
                        _currentDevicePath = selectedNode.path;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (_dataSourceArray) {
                                [_dataSourceArray release];
                                _dataSourceArray = nil;
                            }
                            _dataSourceArray = [(NSMutableArray *)array retain];
                            [_oldDocwsidDic setObject:_currentDevicePath forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
                            [_tempDic setObject:_dataSourceArray forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
                            
                            if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
                                if (_currentSelectView == 0) {
                                    [_contentBox setContentView:_tableViewBgView];
                                }else {
                                    [_contentBox setContentView:_gridBgView];
                                }
                            } else {
                                [self changeToolButtonsIsSelectedIntems:NO];
                                [_contentBox setContentView:_nodataView];
                            }
                            [_gridView reloadData];
                        });
                    }
                });
            }else {
                
            }
        }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
            id entity = [array objectAtIndex:index];
            if ([entity isKindOfClass:[IMBAppEntity class]]) {
                _isSearch = NO;
                [_researchdataSourceArray removeAllObjects];
                [_searhView setStringValue:@""];
                
                [_loadAnimationView startAnimation];
                [_contentBox setContentView:_loadingView];
                _doubleclickCount ++;
                IMBAppEntity *appEntity = (IMBAppEntity *)entity;
                [self configSelectPathButtonWithButtonTag:_doubleclickCount WithButtonTitle:appEntity.appName];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    @autoreleasepool {
                        NSString *parPath = _currentDevicePath;
                        if ([StringHelper stringIsNilOrEmpty:parPath]) {
                            if ([_iPod.deviceInfo.productVersion isVersionMajorEqual:@"8.3"]) {
                                parPath = @"/Documents";
                            }else {
                                parPath = @"/";
                            }
                        }
                        NSArray *array = [[_information applicationManager] recursiveDirectoryContentsDics:parPath appBundle:appEntity.appKey];
                        _appKey = appEntity.appKey;
                        _currentDevicePath = parPath;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            _isSmipNode = YES;
                            [self changeToolButtonsIsSelectedIntems:NO];
                            if (_dataSourceArray) {
                                [_dataSourceArray release];
                                _dataSourceArray = nil;
                            }
                            _dataSourceArray = [(NSMutableArray *)array retain];
                            [_oldDocwsidDic setObject:_currentDevicePath forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
                            [_tempDic setObject:_dataSourceArray forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
                            
                            if ( _dataSourceArray != nil && _dataSourceArray.count > 0) {
                                if (_currentSelectView == 0) {
                                    [_contentBox setContentView:_tableViewBgView];
                                    [_itemTableView reloadData];
                                }else {
                                    [_contentBox setContentView:_gridBgView];
                                    [_gridView reloadData];
                                }
                            } else {
                                [_contentBox setContentView:_nodataView];
                            }
                            
                        });
                    }
                });
            }else if ([entity isKindOfClass:[SimpleNode class]]) {
                SimpleNode *fileEntity = (SimpleNode *)entity;
                if (fileEntity.container) {
                    _isSearch = NO;
                    [_researchdataSourceArray removeAllObjects];
                    [_searhView setStringValue:@""];
                    
                    [_loadAnimationView startAnimation];
                    [_contentBox setContentView:_loadingView];
                    _doubleclickCount ++;
                    [self configSelectPathButtonWithButtonTag:_doubleclickCount WithButtonTitle:fileEntity.fileName];
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        @autoreleasepool {
                            NSArray *array = [[_information applicationManager] recursiveDirectoryContentsDics:fileEntity.path  appBundle:_appKey];
                            _currentDevicePath = fileEntity.path;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (_dataSourceArray) {
                                    [_dataSourceArray release];
                                    _dataSourceArray = nil;
                                }
                                _dataSourceArray = [(NSMutableArray *)array retain];
                                [_oldDocwsidDic setObject:_currentDevicePath forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
                                [_tempDic setObject:_dataSourceArray forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
                                
                                if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
                                    if (_currentSelectView == 0) {
                                        [_contentBox setContentView:_tableViewBgView];
                                    }else {
                                        [_contentBox setContentView:_gridBgView];
                                    }
                                } else {
                                    [_contentBox setContentView:_nodataView];
                                }
                                _isSmipNode = YES;
                                [_gridView reloadData];
                                
                            });
                        }
                    });
                }else {
                    
                }
            }
        }
    }
}

- (void)tableViewSingleClick:(NSTableView *)tableView row:(NSInteger)index {
    [self executeRenameOrCreate];
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
            if (_categoryNodeEunm == Category_Media||_categoryNodeEunm == Category_Video) {
                key = @"title";
            }else if (_categoryNodeEunm == Category_iBooks) {
                key = @"bookName";
            }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
                if (_isSmipNode) {
                    key = @"fileName";
                }else {
                    key = @"appName";
                }
            }else if (_categoryNodeEunm == Category_System||_categoryNodeEunm == Category_Storage) {
                key = @"fileName";
            }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
                key = @"photoName";
            }
        }else if ([str isEqualToString:CustomLocalizedString(@"List_Header_id_Date", nil)]) {
            if (_categoryNodeEunm == Category_Media||_categoryNodeEunm == Category_Video) {
                key = @"dateLastModified";
            }else if (_categoryNodeEunm == Category_iBooks) {
                key = @"";
            }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
                if (_isSmipNode) {
                    key = @"creatDate";
                }else {
                    key = @"";
                }
            }else if (_categoryNodeEunm == Category_System||_categoryNodeEunm == Category_Storage) {
                key = @"creatDate";
            }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
                key = @"photoDateData";
            }
        }else if ([str isEqualToString:CustomLocalizedString(@"List_Header_id_Type", nil)]) {
            if (_categoryNodeEunm == Category_Media||_categoryNodeEunm == Category_Video) {
                key = @"extension";
            }else if (_categoryNodeEunm == Category_iBooks) {
                key = @"extension";
            }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
                if (_isSmipNode) {
                    key = @"extension";
                }else {
                    key = @"";
                }
            }else if (_categoryNodeEunm == Category_System||_categoryNodeEunm == Category_Storage) {
                key = @"extension";
            }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
                key = @"extension";
            }
        }else if ([str isEqualToString:CustomLocalizedString(@"List_Header_id_Size", nil)]) {
            if (_categoryNodeEunm == Category_Media||_categoryNodeEunm == Category_Video) {
                key = @"fileSize";
            }else if (_categoryNodeEunm == Category_iBooks) {
                key = @"size";
            }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
                if (_isSmipNode) {
                    key = @"itemSize";
                }else {
                    key = @"appSize";
                }
            }else if (_categoryNodeEunm == Category_System||_categoryNodeEunm == Category_Storage) {
                key = @"itemSize";
            }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
                key = @"photoSize";
            }
        }
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        [disPalyAry sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [_gridView reloadData];
        [sortDescriptor release];
    }
}

- (void)showFileDetailViewWithEntity:(IMBBaseEntity *)entity {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:CDevice action:ADetail label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
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
        _isShowTranfer = NO;
        tranferView.reloadDelegate = self;
        [tranferView transferBtn:_transferBtn];
        [tranferView.view setFrame:NSMakeRect([_delegate window].contentView.frame.size.width - tranferView.view.frame.size.width + 8, -8, 360, tranferView.view.frame.size.height)];
        
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
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            [view setHidden:YES];
            [view.layer removeAllAnimations];
            [tranferView.view removeFromSuperview];
            [tranferView.view.layer removeAllAnimations];
            [tranferView.view setFrame:NSMakeRect([_delegate window].contentView.frame.size.width +8, -8, 360, tranferView.view.frame.size.height)];
        });
    }
}

- (void)configDetailViewWith:(IMBBaseEntity *)entity {
    [_detailCreateTime setHidden:NO];
    [_detailCreateTimeContent setHidden:NO];
    [_detailSize setHidden:NO];
    [_detailSizeContent setHidden:NO];

    [_detailSize setStringValue:CustomLocalizedString(@"List_Header_id_Size", nil)];
    [_detailCreateTime setStringValue:CustomLocalizedString(@"List_Header_id_Date", nil)];
    
    [_detailSize setTextColor:COLOR_TEXT_ORDINARY];
    [_detailCreateTime setTextColor:COLOR_TEXT_ORDINARY];
    [_detailTitle setTextColor:COLOR_TEXT_ORDINARY];
    
    [_detailSizeContent setTextColor:COLOR_TEXT_ORDINARY];
    [_detailCreateTimeContent setTextColor:COLOR_TEXT_ORDINARY];
    
    [_detailImageView setFrame:NSMakeRect(101, 375, 80, 60)];
    if (_categoryNodeEunm == Category_Media || _categoryNodeEunm == Category_Video) {
        IMBTrack *track = (IMBTrack *)entity;
        [_detailImageView setImage:track.thumbImage];
        [_detailTitle setStringValue:track.title];
        [_detailSizeContent setStringValue:[StringHelper getFileSizeString:track.fileSize reserved:2]];
        if (track.dateLastModified == 0) {
            [_detailCreateTimeContent  setStringValue:@"--"];
        }else{
            [_detailCreateTimeContent  setStringValue:[DateHelper dateFrom1970ToString:track.dateLastModified  withMode:2]];
        }
    }else if (_categoryNodeEunm == Category_iBooks) {
        IMBBookEntity *bookEntity = (IMBBookEntity *)entity;
        [_detailImageView setImage:bookEntity.coverImage];
        [_detailTitle setStringValue:bookEntity.bookName];
        [_detailSizeContent setStringValue:[StringHelper getFileSizeString:bookEntity.size reserved:2]];
        [_detailCreateTimeContent  setStringValue:@"--"];
    }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
        if ([entity isKindOfClass:[IMBAppEntity class]]) {
            IMBAppEntity *appEntity = (IMBAppEntity *)entity;
            [_detailImageView setImage:appEntity.appIconImage];
            [_detailTitle setStringValue:appEntity.appName];
            [_detailSizeContent setStringValue:[StringHelper getFileSizeString:appEntity.appSize reserved:2]];
            [_detailCreateTimeContent  setStringValue:@"--"];
        }else if ([entity isKindOfClass:[SimpleNode class]]) {
            SimpleNode *fileEntity = (SimpleNode *)entity;
            [_detailImageView setImage:fileEntity.image];
            [_detailTitle setStringValue:fileEntity.fileName];
            [_detailSizeContent setStringValue:[StringHelper getFileSizeString:fileEntity.itemSize reserved:2]];
            [_detailCreateTimeContent  setStringValue:@"--"];
        }
    }else if (_categoryNodeEunm == Category_System||_categoryNodeEunm == Category_Storage) {
        SimpleNode *simpleNode = (SimpleNode *)entity;
        [_detailImageView setImage:simpleNode.image];
        [_detailTitle setStringValue:simpleNode.fileName];
        [_detailSizeContent setStringValue:[StringHelper getFileSizeString:simpleNode.itemSize reserved:2]];
        if (![StringHelper stringIsNilOrEmpty:simpleNode.creatDate]) {
            [_detailCreateTimeContent  setStringValue:simpleNode.creatDate];
        }else{
            [_detailCreateTimeContent  setStringValue:@"--"];
        }
        [_detailCreateTimeContent  setStringValue:simpleNode.creatDate];
    }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
        IMBPhotoEntity *photoEnity = (IMBPhotoEntity *)entity;
        [_detailImageView setImage:photoEnity.photoImage];
        [_detailTitle setStringValue:photoEnity.photoName];
        [_detailSizeContent setStringValue:[StringHelper getFileSizeString:photoEnity.photoSize reserved:2]];
        if (photoEnity.photoDateData == 0) {
            [_detailCreateTimeContent  setStringValue:@"--"];
        }else{
            [_detailCreateTimeContent  setStringValue:[DateHelper dateFrom2001ToString:photoEnity.photoDateData withMode:2]];
        }
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
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    if (_categoryNodeEunm == Category_Media || _categoryNodeEunm == Category_Video) {
        IMBTrack *track = [array objectAtIndex:row];
        if ([@"Type" isEqualToString:tableColumn.identifier]){
            return  track.extension;
        }else if ([@"Date" isEqualToString:tableColumn.identifier]){
            if (track.dateLastModified == 0) {
                return @"--";
            }else{
                return [DateHelper dateFrom1970ToString:track.dateLastModified  withMode:2];
            }
        }else if ([@"Size" isEqualToString:tableColumn.identifier]){
            return [StringHelper getFileSizeString:track.fileSize reserved:2];
        }else if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
            return [NSNumber numberWithInt:track.checkState];
        }
    }else if (_categoryNodeEunm == Category_iBooks) {
        IMBBookEntity *bookEntity = [array objectAtIndex:row];
        if ([@"Type" isEqualToString:tableColumn.identifier]){
            if (![StringHelper stringIsNilOrEmpty:bookEntity.extension]) {
                return bookEntity.extension;
            }else {
                return @"--";
            }
        }else if ([@"Date" isEqualToString:tableColumn.identifier]){
            if ([StringHelper stringIsNilOrEmpty:@""]) {
                return @"--";
            }else{
                return @"";
            }
        }else if ([@"Size" isEqualToString:tableColumn.identifier]){
            return [StringHelper getFileSizeString:bookEntity.size reserved:2];
        }else if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
            return [NSNumber numberWithInt:bookEntity.checkState];
        }
    }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
        id entity = [array objectAtIndex:row];
        if ([entity isKindOfClass:[IMBAppEntity class]]) {
            IMBAppEntity *appEntity = (IMBAppEntity *)entity;
            if ([@"Type" isEqualToString:tableColumn.identifier]){
                if (![StringHelper stringIsNilOrEmpty:@""]) {
                    return @"";
                }else {
                    return @"";
                }
            }else if ([@"Date" isEqualToString:tableColumn.identifier]){
                if ([StringHelper stringIsNilOrEmpty:@""]) {
                    return @"--";
                }else{
                    return @"";
                }
            }else if ([@"Size" isEqualToString:tableColumn.identifier]){
                return [StringHelper getFileSizeString:appEntity.appSize reserved:2];
            }else if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
                return [NSNumber numberWithInt:appEntity.checkState];
            }
        }else if ([entity isKindOfClass:[SimpleNode class]]) {
            SimpleNode *fileEntity = (SimpleNode *)entity;
            if ([@"Type" isEqualToString:tableColumn.identifier]){
                if (![StringHelper stringIsNilOrEmpty:fileEntity.extension]) {
                    return fileEntity.extension;
                }else {
                    return @"--";
                }
            }else if ([@"Date" isEqualToString:tableColumn.identifier]){
                if (![StringHelper stringIsNilOrEmpty:fileEntity.creatDate]) {
                    return fileEntity.creatDate;
                }else{
                    return @"--";
                }
            }else if ([@"Size" isEqualToString:tableColumn.identifier]){
                if (fileEntity.itemSize == 0) {
                    return @"--";
                }else {
                    return [StringHelper getFileSizeString:fileEntity.itemSize reserved:2];
                }
            }else if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
                return [NSNumber numberWithInt:fileEntity.checkState];
            }
        }
    }else if (_categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
        SimpleNode *simpleNode = [array objectAtIndex:row];
        if ([@"Type" isEqualToString:tableColumn.identifier]){
            if (![StringHelper stringIsNilOrEmpty:simpleNode.extension]) {
                return simpleNode.extension;
            }else {
                return @"--";
            }
        }else if ([@"Date" isEqualToString:tableColumn.identifier]){
            if (![StringHelper stringIsNilOrEmpty:simpleNode.creatDate]) {
                return simpleNode.creatDate;
            }else{
                return @"--";
            }
        }else if ([@"Size" isEqualToString:tableColumn.identifier]){
            if (simpleNode.itemSize == 0) {
                return @"--";
            }else {
                return [StringHelper getFileSizeString:simpleNode.itemSize reserved:2];
            }
        }else if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
            return [NSNumber numberWithInt:simpleNode.checkState];
        }
    }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
        IMBPhotoEntity *photoEnity = [array objectAtIndex:row];
        if ([@"Type" isEqualToString:tableColumn.identifier]){
            if (![StringHelper stringIsNilOrEmpty:[photoEnity.photoName pathExtension]]) {
                photoEnity.extension = [photoEnity.photoName pathExtension];
                return photoEnity.extension;
            }else {
                return @"--";
            }
        }else if ([@"Date" isEqualToString:tableColumn.identifier]){
            if (photoEnity.photoDateData == 0) {
                return @"--";
            }else{
                return [DateHelper dateFrom2001ToString:photoEnity.photoDateData withMode:2];
            }
        }else if ([@"Size" isEqualToString:tableColumn.identifier]){
            return [StringHelper getFileSizeString:photoEnity.photoSize reserved:2];
        }else if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
            return [NSNumber numberWithInt:photoEnity.checkState];
        }
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
    if ([tableColumn.identifier isEqualToString:@"Name"] && row < array.count) {
        if (_categoryNodeEunm == Category_Media||_categoryNodeEunm == Category_Video) {
            IMBTrack *track = [array objectAtIndex:row];
            IMBImageAndTextFieldCell *curCell = (IMBImageAndTextFieldCell *)cell;
            if ([IMBHelper stringIsNilOrEmpty:track.title]) {
                curCell.imageText = CustomLocalizedString(@"mediaView_id_5", nil);
            }else {
                curCell.imageText = track.title;
            }
            [curCell setImageSize:NSMakeSize(34, 34)];
            curCell.image = track.thumbImage;
            [curCell setIsDataImage:YES];
            curCell.marginX = 12;
        }else if (_categoryNodeEunm == Category_iBooks) {
            IMBBookEntity *bookEntity = [array objectAtIndex:row];
            IMBImageAndTextFieldCell *curCell = (IMBImageAndTextFieldCell *)cell;
            [curCell setImageSize:NSMakeSize(34, 34)];
            curCell.image = bookEntity.coverImage;
            curCell.imageText = bookEntity.bookName;
            [curCell setIsDataImage:YES];
            curCell.marginX = 12;
        }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
            id entity = [array objectAtIndex:row];
            if ([entity isKindOfClass:[IMBAppEntity class]]) {
                IMBAppEntity *appEntity = (IMBAppEntity *)entity;
                IMBImageAndTextFieldCell *curCell = (IMBImageAndTextFieldCell *)cell;
                [curCell setImageSize:NSMakeSize(34, 34)];
                curCell.image = appEntity.appIconImage;
                curCell.imageText = appEntity.appName;
                [curCell setIsDataImage:YES];
                curCell.marginX = 12;
            }else if ([entity isKindOfClass:[SimpleNode class]]) {
                SimpleNode *simpleNode = (SimpleNode *)entity;
                IMBImageAndTextFieldCell *curCell = (IMBImageAndTextFieldCell *)cell;
                [curCell setImageSize:NSMakeSize(34, 34)];
                curCell.image = simpleNode.image;
                curCell.imageText = simpleNode.fileName;
                [curCell setIsDataImage:YES];
                curCell.marginX = 12;
            }
        }else if (_categoryNodeEunm == Category_System||_categoryNodeEunm == Category_Storage) {
            SimpleNode *simpleNode = [array objectAtIndex:row];
            IMBImageAndTextFieldCell *curCell = (IMBImageAndTextFieldCell *)cell;
            [curCell setImageSize:NSMakeSize(34, 34)];
            curCell.image = simpleNode.image;
            curCell.imageText = simpleNode.fileName;
            [curCell setIsDataImage:YES];
            curCell.marginX = 12;
        }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
            IMBPhotoEntity *photoEnity = [array objectAtIndex:row];
            IMBImageAndTextFieldCell *curCell = (IMBImageAndTextFieldCell *)cell;
            [curCell setImageSize:NSMakeSize(34, 34)];
            if (photoEnity.photoImage) {
                curCell.image = photoEnity.photoImage;
            } else {
                NSData *imageData = [self createImageToTableView:photoEnity];
                NSImage *photoImage = [[NSImage alloc]initWithData:imageData];
                curCell.image = photoImage;
                if (photoImage) {
                    photoEnity.photoImage = photoImage;
                    curCell.image = photoImage;
                } else {
                    curCell.image = [NSImage imageNamed:@"cnt_fileicon_img"];
                }
                [photoImage release];
            }
            curCell.imageText = photoEnity.photoName;
            [curCell setIsDataImage:YES];
            curCell.marginX = 12;
        }
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 60;
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
        if (_categoryNodeEunm == Category_Media || _categoryNodeEunm == Category_Video) {
            for (IMBTrack *track in dataArr) {
                track.checkState = Check;
            }
        }else if (_categoryNodeEunm == Category_iBooks) {
            for (IMBBookEntity *bookEntity in dataArr) {
                bookEntity.checkState = Check;
            }
        }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
            for (id entity in dataArr) {
                if ([entity isKindOfClass:[IMBAppEntity class]]) {
                    IMBAppEntity *appEntity = (IMBAppEntity *)entity;
                    appEntity.checkState = Check;
                }else if ([entity isKindOfClass:[SimpleNode class]]) {
                    SimpleNode *fileEntity = (SimpleNode *)entity;
                    fileEntity.checkState = Check;
                }
            }
        }else if (_categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
            for (SimpleNode *simpleNode in dataArr) {
                simpleNode.checkState = Check;
            }
        }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
            for (IMBPhotoEntity *photoEnity in dataArr) {
                photoEnity.checkState = Check;
            }
        }
        if (dataArr.count == 1) {
            _curEntity = [dataArr objectAtIndex:0];
            if (_isShow) {
                [self configDetailViewWith:_curEntity];
            }
        }
    }
    if (_categoryNodeEunm == Category_Media || _categoryNodeEunm == Category_Video) {
        for (IMBTrack *track in disPalyAry) {
            if (![dataArr containsObject:track]) {
                track.checkState = UnChecked;
            }
        }
        for (IMBTrack *track in _dataSourceArray) {
            if (track.checkState) {
                [self changeToolButtonsIsSelectedIntems:YES];
                break;
            }
        }
    }else if (_categoryNodeEunm == Category_iBooks) {
        for (IMBBookEntity *bookEntity in disPalyAry) {
            if (![dataArr containsObject:bookEntity]) {
                bookEntity.checkState = UnChecked;
            }
        }
        for (IMBBookEntity *bookEntity in _dataSourceArray) {
            if (bookEntity.checkState) {
                [self changeToolButtonsIsSelectedIntems:YES];
                break;
            }
        }
    }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
        for (id entity in disPalyAry) {
            if ([entity isKindOfClass:[IMBAppEntity class]]) {
                IMBAppEntity *appEntity = (IMBAppEntity *)entity;
                if (![dataArr containsObject:appEntity]) {
                    appEntity.checkState = UnChecked;
                }
            }else {
                SimpleNode *fileEntity = (SimpleNode *)entity;
                if (![dataArr containsObject:fileEntity]) {
                    fileEntity.checkState = UnChecked;
                }
            }
        }
        for (id entity in _dataSourceArray) {
            if ([entity isKindOfClass:[IMBAppEntity class]]) {
                IMBAppEntity *appEntity = (IMBAppEntity *)entity;
                if (appEntity.checkState) {
                    [self changeToolButtonsIsSelectedIntems:YES];
                    break;
                }
            }else {
                SimpleNode *fileEntity = (SimpleNode *)entity;
                if (fileEntity.checkState) {
                    [self changeToolButtonsIsSelectedIntems:YES];
                    break;
                }
            }
        }
    }else if (_categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
        for (SimpleNode *simpleNode in disPalyAry) {
            if (![dataArr containsObject:simpleNode]) {
                simpleNode.checkState = UnChecked;
            }
        }
        for (SimpleNode *simpleNode in _dataSourceArray) {
            if (simpleNode.checkState) {
                [self changeToolButtonsIsSelectedIntems:YES];
                break;
            }
        }
    }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
        for (IMBPhotoEntity *photoEnity in disPalyAry) {
            if (![dataArr containsObject:photoEnity]) {
                photoEnity.checkState = UnChecked;
            }
        }
        for (IMBPhotoEntity *photoEnity in _dataSourceArray) {
            if (photoEnity.checkState) {
                [self changeToolButtonsIsSelectedIntems:YES];
                break;
            }
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
    
    if ( [@"Name" isEqualToString:identify] || [@"Type" isEqualToString:identify] || [@"Date" isEqualToString:identify] || [@"Size" isEqualToString:identify]) {
        if ([cell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *customHeaderCell = (IMBCustomHeaderCell *)cell;
            if (customHeaderCell.ascending) {
                customHeaderCell.ascending = NO;
            }else {
                customHeaderCell.ascending = YES;
            }
            [self sort:customHeaderCell.ascending key:identify dataSource:disPalyAry];
        }
    }
    [_itemTableView reloadData];
}

- (void)sort:(BOOL)isAscending key:(NSString *)key dataSource:(NSMutableArray *)array {
    if ([key isEqualToString:@"Name"]) {
        if (_categoryNodeEunm == Category_Media||_categoryNodeEunm == Category_Video) {
            key = @"title";
        }else if (_categoryNodeEunm == Category_iBooks) {
            key = @"bookName";
        }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
            if (_isSmipNode) {
                key = @"fileName";
            }else {
                key = @"appName";
            }
        }else if (_categoryNodeEunm == Category_System ||_categoryNodeEunm == Category_Storage) {
            key = @"fileName";
        }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
            key = @"photoName";
        }
    }else if ([key isEqualToString:@"Date"]) {
        if (_categoryNodeEunm == Category_Media||_categoryNodeEunm == Category_Video) {
            key = @"dateLastModified";
        }else if (_categoryNodeEunm == Category_iBooks) {
            key = @"";
        }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
            if (_isSmipNode) {
                key = @"creatDate";
            }else {
                key = @"";
            }
        }else if (_categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
            key = @"creatDate";
        }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
            key = @"photoDateData";
        }
    }else if ([key isEqualToString:@"Type"]) {
        if (_categoryNodeEunm == Category_Media||_categoryNodeEunm == Category_Video) {
            key = @"extension";
        }else if (_categoryNodeEunm == Category_iBooks) {
            key = @"extension";
        }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
            if (_isSmipNode) {
                key = @"extension";
            }else {
                key = @"";
            }
        }else if (_categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
            key = @"extension";
        }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
            key = @"extension";
        }
    }else if ([key isEqualToString:@"Size"]) {
        if (_categoryNodeEunm == Category_Media||_categoryNodeEunm == Category_Video) {
            key = @"fileSize";
        }else if (_categoryNodeEunm == Category_iBooks) {
            key = @"size";
        }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
            if (_isSmipNode) {
                key = @"itemSize";
            }else {
                key = @"appSize";
            }
        }else if (_categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
            key = @"itemSize";
        }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
            key = @"photoSize";
        }
    }

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    [_itemTableView reloadData];
    
    [sortDescriptor release];
    [sortDescriptors release];
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
    
    
    NSArray *disPalyAry = nil;
    if (_isSearch) {
        disPalyAry = _researchdataSourceArray;
    }else {
        disPalyAry = _dataSourceArray;
    }
    
    if (_categoryNodeEunm == Category_Media||_categoryNodeEunm == Category_Video) {
        for (int i=0;i<[disPalyAry count]; i++) {
            IMBTrack *item= [disPalyAry objectAtIndex:i];
            [item setCheckState:checkState];
        }
    }else if (_categoryNodeEunm == Category_iBooks) {
        for (int i=0;i<[disPalyAry count]; i++) {
            IMBBookEntity *item= [disPalyAry objectAtIndex:i];
            [item setCheckState:checkState];
        }
    }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
        for (int i=0;i<[disPalyAry count]; i++) {
            id item= [disPalyAry objectAtIndex:i];
            if ([item isKindOfClass:[IMBAppEntity class]]) {
                IMBAppEntity *appEntity = (IMBAppEntity *)item;
                [appEntity setCheckState:checkState];
            }else {
                SimpleNode *fileEntity = (SimpleNode *)item;
                [fileEntity setCheckState:checkState];
            }
        }
    }else if (_categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
        for (int i=0;i<[disPalyAry count]; i++) {
            SimpleNode *simpleNode = [disPalyAry objectAtIndex:i];
            [simpleNode setCheckState:checkState];
        }
        
    }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
        for (int i=0;i<[disPalyAry count]; i++) {
            IMBPhotoEntity *item= [disPalyAry objectAtIndex:i];
            [item setCheckState:checkState];
        }
    }
    
    
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
            
            if (_categoryNodeEunm == Category_Media || _categoryNodeEunm == Category_Video) {
                
                IMBTrack *item= [_dataSourceArray objectAtIndex:i];
                if (item.checkState == Check) {
                    [set addIndex:i];
                }
            }else if (_categoryNodeEunm == Category_iBooks) {
                IMBBookEntity *item= [_dataSourceArray objectAtIndex:i];
                if (item.checkState == Check) {
                    [set addIndex:i];
                }
            }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
                id item= [_dataSourceArray objectAtIndex:i];
                if ([item isKindOfClass:[IMBAppEntity class]]) {
                    IMBAppEntity *appEntity = (IMBAppEntity *)item;
                    if (appEntity.checkState == Check) {
                        [set addIndex:i];
                    }
                }else {
                    SimpleNode *fileEntity = (SimpleNode *)item;
                    if (fileEntity.checkState == Check) {
                        [set addIndex:i];
                    }
                }
            }else if (_categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
                SimpleNode *simpleNode = [_dataSourceArray objectAtIndex:i];
                if (simpleNode.checkState == Check) {
                    [set addIndex:i];
                }
            }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
                IMBPhotoEntity *item= [_dataSourceArray objectAtIndex:i];
                if (item.checkState == Check) {
                    [set addIndex:i];
                }
            }
        }
        _currentSelectView = 0;
        [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
        [_itemTableView reloadData];
        
    }else if (segBtn.switchBtnState == 0) {
        _currentSelectView = 1;
        if (_dataSourceArray.count > 0) {
            [_contentBox setContentView:_gridBgView];
            [_gridView reloadData];
        }else {
            [_contentBox setContentView:_nodataView];
        }
        
    }
    [_toolBarButtonView loadButtons:_toolBarArr Target:self DisplayMode:_currentSelectView];
    [self configRightKeyMenuItemWithConfigArr:_toolBarArr];
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
            if (_categoryNodeEunm == Category_Media || _categoryNodeEunm == Category_Video) {
                IMBTrack *entity = [disAry objectAtIndex:i];
                if (entity.checkState == Check||entity.checkState == SemiChecked) {
                    [sets addIndex:i];
                }
            }else if (_categoryNodeEunm == Category_iBooks) {
                IMBBookEntity *entity = [disAry objectAtIndex:i];
                if (entity.checkState == Check||entity.checkState == SemiChecked) {
                    [sets addIndex:i];
                }
            }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
                id item= [disAry objectAtIndex:i];
                if ([item isKindOfClass:[IMBAppEntity class]]) {
                    IMBAppEntity *appEntity = (IMBAppEntity *)item;
                    if (appEntity.checkState == Check||appEntity.checkState == SemiChecked) {
                        [sets addIndex:i];
                    }
                }else {
                    SimpleNode *fileEntity = (SimpleNode *)item;
                    if (fileEntity.checkState == Check||fileEntity.checkState == SemiChecked) {
                        [sets addIndex:i];
                    }
                }
            }else if (_categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
                SimpleNode *entity = [disAry objectAtIndex:i];
                if (entity.checkState == Check||entity.checkState == SemiChecked) {
                    [sets addIndex:i];
                }
            }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
                IMBPhotoEntity *entity = [disAry objectAtIndex:i];
                if (entity.checkState == Check||entity.checkState == SemiChecked) {
                    [sets addIndex:i];
                }
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

- (void)dropToCollectionViewTableViewWithpaths:(NSMutableArray *)paths {
    IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
    tranferView.reloadDelegate = self;
    [tranferView transferBtn:_transferBtn];
    [tranferView deviceAddDataSoure:paths WithIsDown:NO WithiPod:_iPod withCategoryNodesEnum:_categoryNodeEunm isExportPath:nil withSystemPath:_currentDevicePath];
}

#pragma mark - Notification
- (void)photoLoadFinished:(NSNotification *)object {
    dispatch_async(dispatch_get_main_queue(), ^{
        IMBiPod *ipod = (IMBiPod *)object.object;
        IMBInformationManager *inforManager = [IMBInformationManager shareInstance];
        _information = [inforManager.informationDic objectForKey:_iPod.uniqueKey];
        
        if ([ipod.uniqueKey isEqualToString: _iPod.uniqueKey]) {
            if (_dataSourceArray) {
                [_dataSourceArray release];
                _dataSourceArray = nil;
            }
            if (_categoryNodeEunm == Category_PhotoStream) {
                _dataSourceArray = [_information.photostreamArray retain];
            }else if (_categoryNodeEunm == Category_PhotoLibrary) {
                _dataSourceArray = [_information.photolibraryArray retain];
            }else if (_categoryNodeEunm == Category_CameraRoll) {
                _dataSourceArray = [_information.allPhotoArray retain];
            }else{
                return ;
            }
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
                    if (_currentSelectView == 0) {
                        [_contentBox setContentView:_tableViewBgView];
                    }else {
                        [_contentBox setContentView:_gridBgView];
                    }
                } else {
                    [_contentBox setContentView:_nodataView];
                }
                [_toolBarButtonView toolBarButtonIsEnabled:YES];
                [_loadAnimationView endAnimation];
            });
            [_gridView reloadData];
            [_itemTableView reloadData];
        }
    });
}

- (void)appLoadFinished:(NSNotification *)object {
    IMBInformationManager *inforManager = [IMBInformationManager shareInstance];
    _information = [inforManager.informationDic objectForKey:_iPod.uniqueKey];
    IMBiPod *ipod = (IMBiPod *)object.object;
    if (_categoryNodeEunm == Category_Applications) {
        if ([ipod.uniqueKey isEqualToString: _iPod.uniqueKey]) {
            if (_dataSourceArray) {
                [_dataSourceArray release];
                _dataSourceArray = nil;
            }
            _dataSourceArray = [_information.appArray retain];
            if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
                if (_currentSelectView == 0) {
                    [_contentBox setContentView:_tableViewBgView];
                }else {
                    [_contentBox setContentView:_gridBgView];
                }
            } else {
                [_contentBox setContentView:_nodataView];
            }
        }
        [_toolBarButtonView toolBarButtonIsEnabled:YES];
        [_gridView reloadData];
        [_itemTableView reloadData];
        [_loadAnimationView endAnimation];
    }
}

- (void)appDoumentLoadFinished:(NSNotification *)object {
    IMBInformationManager *inforManager = [IMBInformationManager shareInstance];
    _information = [inforManager.informationDic objectForKey:_iPod.uniqueKey];
    IMBiPod *ipod = (IMBiPod *)object.object;
    if (_categoryNodeEunm == Category_appDoucment) {
        if ([ipod.uniqueKey isEqualToString: _iPod.uniqueKey]) {
            if (_dataSourceArray) {
                [_dataSourceArray release];
                _dataSourceArray = nil;
            }
            _dataSourceArray = [_information.appDoucmentArray retain];
            if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
                if (_currentSelectView == 0) {
                    [_contentBox setContentView:_tableViewBgView];
                }else {
                    [_contentBox setContentView:_gridBgView];
                }
            } else {
                [_contentBox setContentView:_nodataView];
            }
        }
        [_toolBarButtonView toolBarButtonIsEnabled:YES];
        [_gridView reloadData];
        [_itemTableView reloadData];
        [_loadAnimationView endAnimation];
    }
}

- (void)bookLoadFinished:(NSNotification *)object {
    dispatch_async(dispatch_get_main_queue(), ^{
        IMBInformationManager *inforManager = [IMBInformationManager shareInstance];
        _information = [inforManager.informationDic objectForKey:_iPod.uniqueKey];
        IMBiPod *ipod = (IMBiPod *)object.object;
        if (_categoryNodeEunm == Category_iBooks) {
            if ([ipod.uniqueKey isEqualToString: _iPod.uniqueKey]) {
                if (_dataSourceArray) {
                    [_dataSourceArray release];
                    _dataSourceArray = nil;
                }
                _dataSourceArray = [_information.allBooksArray retain];
                if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
                    if (_currentSelectView == 0) {
                        [_contentBox setContentView:_tableViewBgView];
                    }else {
                        [_contentBox setContentView:_gridBgView];
                    }
                } else {
                    [_contentBox setContentView:_nodataView];
                }
            }
            [_toolBarButtonView toolBarButtonIsEnabled:YES];
            [_gridView reloadData];
            [_itemTableView reloadData];
            [_loadAnimationView endAnimation];
        }
    });
}

- (void)mediaLoadFinished:(NSNotification *)object {
    IMBInformationManager *inforManager = [IMBInformationManager shareInstance];
    _information = [inforManager.informationDic objectForKey:_iPod.uniqueKey];
    IMBiPod *ipod = (IMBiPod *)object.object;
    if (_categoryNodeEunm == Category_Media) {
        if ([ipod.uniqueKey isEqualToString: _iPod.uniqueKey]) {
            if (_dataSourceArray) {
                [_dataSourceArray release];
                _dataSourceArray = nil;
            }
            _dataSourceArray = [_information.mediaArray retain];
            if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
                if (_currentSelectView == 0) {
                    [_contentBox setContentView:_tableViewBgView];
                }else {
                    [_contentBox setContentView:_gridBgView];
                }
            } else {
                [_contentBox setContentView:_nodataView];
            }
        }
        [_toolBarButtonView toolBarButtonIsEnabled:YES];
        [_gridView reloadData];
        [_itemTableView reloadData];
        [_loadAnimationView endAnimation];
    }
}

- (void)videoLoadFinished:(NSNotification *)object {
    IMBInformationManager *inforManager = [IMBInformationManager shareInstance];
    _information = [inforManager.informationDic objectForKey:_iPod.uniqueKey];
    IMBiPod *ipod = (IMBiPod *)object.object;
    if (_categoryNodeEunm == Category_Video) {
        if ([ipod.uniqueKey isEqualToString: _iPod.uniqueKey]) {
            if (_dataSourceArray) {
                [_dataSourceArray release];
                _dataSourceArray = nil;
            }
            _dataSourceArray = [_information.videoArray retain];
            if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
                if (_currentSelectView == 0) {
                    [_contentBox setContentView:_tableViewBgView];
                }else {
                    [_contentBox setContentView:_gridBgView];
                }
            } else {
                [_contentBox setContentView:_nodataView];
            }
        }
        [_toolBarButtonView toolBarButtonIsEnabled:YES];
        [_gridView reloadData];
        [_itemTableView reloadData];
        [_loadAnimationView endAnimation];
    }
}

#pragma mark - reload toolButton
- (void)changeToolButtonsIsSelectedIntems:(BOOL)isSelected {
    if (_toolBarArr != nil) {
        [_toolBarArr release];
        _toolBarArr = nil;
    }
    if (isSelected) {
        switch (_categoryNodeEunm) {
            case Category_Media:
            {
                _toolBarArr = [[NSArray alloc] initWithObjects:@(AddFunctionType),@(ToMacFunctionType),@(ToDeviceFunctionType),@(ToiCloudFunction),
                               @(DeleteFunctionType),@(ReloadFunctionType),@(DeviceDatailFunctionType),@(PreviewFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil];
            }
                break;
            case Category_Video:
            {
                _toolBarArr = [[NSArray alloc] initWithObjects:@(AddFunctionType),@(ToMacFunctionType),@(ToDeviceFunctionType),@(ToiCloudFunction),
                               @(DeleteFunctionType),@(ReloadFunctionType),@(DeviceDatailFunctionType),@(PreviewFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil];
            }
                break;
            case Category_iBooks:
            {
                _toolBarArr = [[NSArray alloc] initWithObjects:@(AddFunctionType),@(ToMacFunctionType),@(ToDeviceFunctionType),@(ToiCloudFunction),
                               @(DeleteFunctionType),@(ReloadFunctionType),@(DeviceDatailFunctionType),@(PreviewFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil];
            }
                break;
            case Category_appDoucment:
            {
                if (_isSmipNode) {
                    _toolBarArr = [[NSArray alloc] initWithObjects:@(ToMacFunctionType),@(ReloadFunctionType),@(DeviceDatailFunctionType),@(PreviewFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil];
                }else {
                    _toolBarArr = [[NSArray alloc] initWithObjects:@(ReloadFunctionType),@(DeviceDatailFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil];
                }
            }
                break;
            case Category_Applications:
            {
                if (_isSmipNode) {
                    _toolBarArr = [[NSArray alloc] initWithObjects:@(AddFunctionType),@(ToMacFunctionType),@(RenameFunctionType),@(ToiCloudFunction),@(NewGroupFuntion),@(MoveFileFuntion),@(DeleteFunctionType),@(ReloadFunctionType),@(DeviceDatailFunctionType),@(PreviewFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil];
                }else {
                    _toolBarArr = [[NSArray alloc] initWithObjects:@(ReloadFunctionType),@(DeviceDatailFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil];
                }
            }
                break;
            case Category_PhotoStream:
            case Category_CameraRoll:
            {
                _toolBarArr = [[NSArray alloc] initWithObjects:@(ToMacFunctionType),@(ToDeviceFunctionType),@(ToiCloudFunction),@(ReloadFunctionType),@(DeviceDatailFunctionType),@(PreviewFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil];
            }
                break;
            case Category_Storage:
            case Category_System:
            {
                _toolBarArr = [[NSArray alloc] initWithObjects:@(AddFunctionType),@(ToMacFunctionType),@(RenameFunctionType),@(ToiCloudFunction),@(NewGroupFuntion),@(MoveFileFuntion),@(DeleteFunctionType),@(ReloadFunctionType),@(DeviceDatailFunctionType),@(PreviewFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil];
            }
                break;
            case Category_PhotoLibrary:
            {
                _toolBarArr = [[NSArray alloc] initWithObjects:@(AddFunctionType),@(ToMacFunctionType),@(ToDeviceFunctionType),@(ToiCloudFunction),
                               @(DeleteFunctionType),@(ReloadFunctionType),@(DeviceDatailFunctionType),@(PreviewFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil];
            }
                break;
                
            default:
                break;
        }
    }else {
        switch (_categoryNodeEunm) {
            case Category_PhotoStream:
            case Category_CameraRoll:
            {
                _toolBarArr = [[NSArray alloc] initWithObjects:@(ReloadFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil];
            }
                break;
            case Category_appDoucment:
            {
                if (_isSmipNode) {
                    _toolBarArr = [[NSArray alloc] initWithObjects:@(ReloadFunctionType),@(SortFunctionType),@(SwitchFunctionType), nil];
                }else {
                    _toolBarArr = [[NSArray alloc] initWithObjects:@(ReloadFunctionType),@(SortFunctionType),@(SwitchFunctionType), nil];
                }
            }
                break;
            case Category_Applications:
            {
                if (_isSmipNode) {
                    _toolBarArr = [[NSArray alloc] initWithObjects:@(ReloadFunctionType),@(AddFunctionType),@(NewGroupFuntion),@(SortFunctionType),@(SwitchFunctionType), nil];
                }else {
                    _toolBarArr = [[NSArray alloc] initWithObjects:@(ReloadFunctionType),@(SortFunctionType),@(SwitchFunctionType), nil];
                }
            }
                break;
            case  Category_Storage:
            case Category_System:
            {
                _toolBarArr = [[NSArray alloc] initWithObjects:@(ReloadFunctionType),@(AddFunctionType),@(NewGroupFuntion),@(SortFunctionType),@(SwitchFunctionType),nil];
            }
                break;
            default:
                _toolBarArr = [[NSArray alloc] initWithObjects:@(ReloadFunctionType),@(AddFunctionType),@(SortFunctionType),@(SwitchFunctionType),nil];
                break;
        }
    }
    [_toolBarButtonView loadButtons:_toolBarArr Target:self DisplayMode:_currentSelectView];
    [self configRightKeyMenuItemWithConfigArr:_toolBarArr];
}

#pragma mark - operation action
- (void)showDetailView:(id)sender {
    if (_curEntity) {
        _isShow = YES;
        [self showFileDetailViewWithEntity:_curEntity];
    }
}

- (void)showDeviceDetailView:(id)sender {
    if (_isShow) {
        [_detailSize setStringValue:CustomLocalizedString(@"List_Header_id_Size", nil)];
        [_detailCreateTime setStringValue:CustomLocalizedString(@"List_Header_id_Date", nil)];
        
        [_detailSize setTextColor:COLOR_TEXT_ORDINARY];
        [_detailCreateTime setTextColor:COLOR_TEXT_ORDINARY];
        [_detailTitle setTextColor:COLOR_TEXT_ORDINARY];
        
        [_detailSizeContent setTextColor:COLOR_TEXT_ORDINARY];
        [_detailCreateTimeContent setTextColor:COLOR_TEXT_ORDINARY];
        
        [_detailSizeContent setStringValue:[NSString stringWithFormat:@"%@ / %@",[StringHelper getFileSizeString:_iPod.deviceInfo.totalDataAvailable reserved:2],[StringHelper getFileSizeString:_iPod.deviceInfo.totalDataCapacity reserved:2]]];
        
        [_detailImageView setFrame:NSMakeRect(69, 360, 144, 180)];
        NSString *familyString = _iPod.deviceInfo.familyNewString;
        if ([familyString isEqualToString:@"iPhoneN"]) {
            [_detailImageView setImage:[NSImage imageNamed:@"mod_device_detail_iphoneN"]];
        }else if ([familyString isEqualToString:@"iPhoneX"]) {
            [_detailImageView setImage:[NSImage imageNamed:@"mod_device_detail_iphoneX"]];
        }else {
            [_detailImageView setImage:[NSImage imageNamed:@"mod_device_detail_ipad"]];
        }
        [_detailTitle setStringValue:_iPod.deviceInfo.deviceName];
        
        [_detailCreateTime setHidden:YES];
        [_detailCreateTimeContent setHidden:YES];
//        [_detailSize setHidden:YES];
//        [_detailSizeContent setHidden:YES];
    }
}


- (void)reload:(id)sender {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:CDevice action:ARefresh label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    _curEntity = nil;
    _isSearch = NO;
    [_researchdataSourceArray removeAllObjects];
    [_searhView setStringValue:@""];
    [_toolBarButtonView toolBarButtonIsEnabled:NO];
    [_contentBox setContentView:_loadingView];
    [_loadAnimationView startAnimation];
    NSOperationQueue *opQueue = [[[NSOperationQueue alloc] init] autorelease];
    switch (_categoryNodeEunm) {
        case Category_Media:
        {
            [opQueue addOperationWithBlock:^{
                [_dataSourceArray removeAllObjects];
                [_information refreshMedia];
                NSArray *audioArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:(int)Audio],nil];
                NSArray *trackArray = [[NSMutableArray alloc] initWithArray:[_information getTrackArrayByMediaTypes:audioArray]];
                
                [_dataSourceArray addObjectsFromArray:trackArray];
                [trackArray release];
                trackArray = nil;
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [self reloadEnd];
                });
            }];
        }
            break;
        case Category_Video:
        {
            [opQueue addOperationWithBlock:^{
                
                [_dataSourceArray removeAllObjects];
                [_information refreshMedia];
                NSArray *videoArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:(int)Video],
                                       [NSNumber numberWithInt:(int)TVShow],
                                       [NSNumber numberWithInt:(int)MusicVideo],
                                       [NSNumber numberWithInt:(int)HomeVideo],
                                       nil];
                NSArray *trackArray = [[NSMutableArray alloc] initWithArray:[_information getTrackArrayByMediaTypes:videoArray]];
                [_dataSourceArray addObjectsFromArray:trackArray];
                [trackArray release];
                trackArray = nil;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self reloadEnd];
                });
                
            }];
        }
            break;
        case Category_iBooks:
        {
            [opQueue addOperationWithBlock:^{
                [_dataSourceArray removeAllObjects];
                [_information loadiBook];
                NSArray *ibooks = [[_information allBooksArray] retain];
                [IMBCommonTool loadbookCover:ibooks ipod:_iPod];
                [_dataSourceArray addObjectsFromArray:ibooks];
                
                [ibooks release];
                ibooks = nil;
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self reloadEnd];
                });
                
            }];
        }
            break;
        case  Category_appDoucment:
            [opQueue addOperationWithBlock:^{
                [_dataSourceArray removeAllObjects];
                if (_isSmipNode) {
                    [[_information applicationManager] loadAppDoucmentArray];
                   _information.appDoucmentArray = (NSMutableArray *)[[_information applicationManager] appDoucmentArray];
                    if (_information.appDoucmentArray.count) {
                        [_dataSourceArray addObjectsFromArray:_information.appDoucmentArray];
                    }
                }else {
                    IMBApplicationManager *appManager = [[_information applicationManager] retain];
                    [appManager loadAppArray];
                    NSArray *appArray = [appManager appEntityArray];
                    [_dataSourceArray addObjectsFromArray:appArray];
                    
                    [appArray release];
                    appArray = nil;
                    
                    [appManager release];
                    appManager = nil;
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self reloadEnd];
                });
                
            }];

            break;
        case Category_Applications:
        {
            [opQueue addOperationWithBlock:^{
                [_dataSourceArray removeAllObjects];
                if (_isSmipNode) {
                    NSArray *array = [[_information applicationManager] recursiveDirectoryContentsDics:_currentDevicePath  appBundle:_appKey];
                    if (array.count) {
                        [_dataSourceArray addObjectsFromArray:array];
                    }
                }else {
                    IMBApplicationManager *appManager = [[_information applicationManager] retain];
                    [appManager loadAppArray];
                    NSArray *appArray = [appManager appEntityArray];
                    [_dataSourceArray addObjectsFromArray:appArray];
                    
                    [appArray release];
                    appArray = nil;
                    
                    [appManager release];
                    appManager = nil;
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self reloadEnd];
                });
                
            }];
        }
            break;
        case Category_PhotoStream:
        {
            [opQueue addOperationWithBlock:^{
                [_dataSourceArray removeAllObjects];
                [_information refreshPhotoStream];
                NSArray *photoArr = [_information photostreamArray];
                if (photoArr.count) {
                    [_dataSourceArray addObjectsFromArray:photoArr];
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self reloadEnd];
                });
            }];
        }
            break;
        case Category_CameraRoll:
        {
            [opQueue addOperationWithBlock:^{
                [_dataSourceArray removeAllObjects];
                [_information refreshCameraRoll];
                [_information refreshVideoAlbum];
                NSMutableArray *cameraRoll = [[NSMutableArray alloc] init];
                [cameraRoll addObjectsFromArray:[_information camerarollArray] ? [_information camerarollArray] : [NSArray array]];
                [cameraRoll addObjectsFromArray:[_information photovideoArray] ? [_information photovideoArray] : [NSArray array]];
                [cameraRoll addObjectsFromArray:[_information photoSelfiesArray] ? [_information photoSelfiesArray] : [NSArray array]];
                [cameraRoll addObjectsFromArray:[_information screenshotArray] ? [_information screenshotArray] : [NSArray array]];
                [cameraRoll addObjectsFromArray:[_information slowMoveArray] ? [_information slowMoveArray] : [NSArray array]];
                [cameraRoll addObjectsFromArray:[_information timelapseArray] ? [_information timelapseArray] : [NSArray array]];
                [cameraRoll addObjectsFromArray:[_information panoramasArray] ? [_information panoramasArray] : [NSArray array]];
                if (cameraRoll.count) {
                    [_dataSourceArray addObjectsFromArray:cameraRoll];
                }
                [cameraRoll release];
                cameraRoll = nil;
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self reloadEnd];
                });
            }];
        }
            break;
        case Category_PhotoLibrary:
        {
            [opQueue addOperationWithBlock:^{
                [_dataSourceArray removeAllObjects];
                [_information refreshPhotoLibrary];
                NSArray *photoArr = [_information photolibraryArray];
                if (photoArr.count) {
                    [_dataSourceArray addObjectsFromArray:photoArr];
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self reloadEnd];
                });
            }];
        }
            break;
        case Category_Storage:
        case Category_System:
        {
            [opQueue addOperationWithBlock:^{
                [_dataSourceArray removeAllObjects];
                NSArray *array = [_systemManager recursiveDirectoryContentsDics:_currentDevicePath];
                if (array.count) {
                    [_dataSourceArray addObjectsFromArray:array];
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self reloadEnd];
                });
            }];
        }
            break;
        default:
            break;
    }
}

- (void)reloadEnd {
    [_gridView reloadData];
    
    [_toolBarButtonView toolBarButtonIsEnabled:YES];
    [self changeToolButtonsIsSelectedIntems:NO];
    if (_currentSelectView == 0) {
        if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
            [_contentBox setContentView:_tableViewBgView];
        } else {
            [_contentBox setContentView:_nodataView];
        }
        
    } else {
        if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
            [_contentBox setContentView:_gridBgView];
        } else {
            [_contentBox setContentView:_nodataView];
        }
    }
    [_loadAnimationView endAnimation];
    [_toolBarButtonView toolBarButtonIsEnabled:YES];
    
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
    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    [_itemTableView reloadData];
    
}

/**
 *  到电脑
 */
- (void)toMac:(id)sender {

    [self toMacSettingsWithInformation:_information];
}

- (void)toMacSettingsWithInformation:(IMBInformation *)information {
    NSIndexSet *selectedSet = [self selectedItems];
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else {
        displayArr = _dataSourceArray;
    }
    
    if (!selectedSet || selectedSet.count == 0) {
        [IMBCommonTool showSingleBtnAlertInMainWindow:_iPod.uniqueKey btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil) btnClickedBlock:nil];
    }else {
        NSOpenPanel *openPanel = [NSOpenPanel openPanel];
        [openPanel setCanChooseFiles:NO];
        [openPanel setCanChooseDirectories:YES];
        [openPanel setCanCreateDirectories:YES];
        [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
            if (NSModalResponseOK == result) {
                [_transferBtn startTranfering];
                NSString *path = [[openPanel URL] path];
                [self transferToMacWithPath:path withSelecteSet:selectedSet withAry:displayArr];
            }
        }];
    }
}

- (void)transferToMacWithPath:(NSString *)path withSelecteSet:(NSIndexSet *)selectedSet withAry:(NSArray *)displayArr {
    NSString *filePath = [path stringByAppendingString:@"/"];
    NSMutableArray *exportArray = [NSMutableArray array];
    NSDictionary *dimensionDict = nil;
    switch (_categoryNodeEunm) {
        case Category_CameraRoll:
        case Category_PhotoStream:
        case Category_PhotoLibrary:
        {
            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                IMBPhotoEntity *photo = [[displayArr objectAtIndex:idx] retain];
                [exportArray addObject:photo];
                [photo release];
                photo = nil;
            }];
            
            IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
            [tranferView transferBtn:_transferBtn];
            tranferView.reloadDelegate = self;
            [tranferView deviceAddDataSoure:exportArray WithIsDown:YES WithiPod:_iPod withCategoryNodesEnum:_categoryNodeEunm isExportPath:filePath withSystemPath:nil];
            @autoreleasepool {
                [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                dimensionDict = [[TempHelper customDimension] copy];
            }
        }
            break;
        case Category_iBooks:
        {
            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                IMBBookEntity *book = [[displayArr objectAtIndex:idx] retain];
                [exportArray addObject:book];
                [book release];
            }];
            IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
             tranferView.reloadDelegate = self;
            [tranferView transferBtn:_transferBtn];
            [tranferView deviceAddDataSoure:exportArray WithIsDown:YES WithiPod:_iPod withCategoryNodesEnum:_categoryNodeEunm isExportPath:filePath withSystemPath:nil];
            @autoreleasepool {
                [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                dimensionDict = [[TempHelper customDimension] copy];
            }
        }
            break;
        case Category_Media:
        {
            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                IMBTrack *track = [[displayArr objectAtIndex:idx] retain];
                [exportArray addObject:track];
                [track release];
            }];
            
            IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
            [tranferView transferBtn:_transferBtn];
             tranferView.reloadDelegate = self;
            [tranferView deviceAddDataSoure:exportArray WithIsDown:YES WithiPod:_iPod withCategoryNodesEnum:_categoryNodeEunm isExportPath:filePath withSystemPath:nil];
            @autoreleasepool {
                [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                dimensionDict = [[TempHelper customDimension] copy];
            }
        }
            break;
        case Category_appDoucment:
        case Category_Applications:
        {
            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                if (_isSmipNode) {
                    SimpleNode *fileEntity = [[displayArr objectAtIndex:idx] retain];
                    [exportArray addObject:fileEntity];
                    [fileEntity release];
                }else {
                    IMBAppEntity *app = [[displayArr objectAtIndex:idx] retain];
                    [exportArray addObject:app];
                    [app release];
                }
            }];
            IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
            [tranferView transferBtn:_transferBtn];
             tranferView.reloadDelegate = self;
            tranferView.appKey = _appKey;
            [tranferView deviceAddDataSoure:exportArray WithIsDown:YES WithiPod:_iPod withCategoryNodesEnum:_categoryNodeEunm isExportPath:filePath withSystemPath:nil];
            @autoreleasepool {
                [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                dimensionDict = [[TempHelper customDimension] copy];
            }
            //TODO:toMac测试
            SimpleNode *fileEntity = [exportArray objectAtIndex:0];
            AFCApplicationDirectory *afcAppmd = [_iPod.deviceHandle newAFCApplicationDirectory:_appKey];
            [[_information applicationManager] exportAppDocumentToMac:path withSimpleNode:fileEntity appAFC:afcAppmd];
            [afcAppmd close];
        }
            break;
        case Category_Video:
        {
            
            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                IMBTrack *track = [[displayArr objectAtIndex:idx] retain];
                [exportArray addObject:track];
                [track release];
            }];
            IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
            [tranferView transferBtn:_transferBtn];
             tranferView.reloadDelegate = self;
            [tranferView deviceAddDataSoure:exportArray WithIsDown:YES WithiPod:_iPod withCategoryNodesEnum:_categoryNodeEunm isExportPath:filePath withSystemPath:nil];
            @autoreleasepool {
                [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                dimensionDict = [[TempHelper customDimension] copy];
            }
        }
            break;
        case  Category_Storage:
        case Category_System:
        {
            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                SimpleNode *track = [[displayArr objectAtIndex:idx] retain];
                [exportArray addObject:track];
                [track release];
            }];
            IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
            [tranferView transferBtn:_transferBtn];
             tranferView.reloadDelegate = self;
            [tranferView deviceAddDataSoure:exportArray WithIsDown:YES WithiPod:_iPod withCategoryNodesEnum:_categoryNodeEunm isExportPath:filePath withSystemPath:_currentDevicePath];
            @autoreleasepool {
                [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                dimensionDict = [[TempHelper customDimension] copy];
            }
        }
            break;
        default:
            break;
    }
    [ATTracker event:CDevice action:ADownload label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
}

- (void)delayCollectionViewTableViewdragToMac:(NSDictionary *)param {
    NSIndexSet *selectedSet = [self selectedItems];
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else {
        displayArr = _dataSourceArray;
    }
    
    if (!selectedSet || selectedSet.count == 0) {
        [IMBCommonTool showSingleBtnAlertInMainWindow:_iPod.uniqueKey btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil)btnClickedBlock:nil];
    }else {
        NSString *url = [param objectForKey:@"url"];
        [self transferToMacWithPath:url withSelecteSet:selectedSet withAry:displayArr];
    }
}

- (void)downloadToMac:(id)sender {
    
    _openPanel = [NSOpenPanel openPanel];
    [_openPanel setAllowsMultipleSelection:YES];
    [_openPanel setCanChooseFiles:YES];
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode== NSFileHandlingPanelOKButton) {
            NSArray *urlArr = [_openPanel URLs];
            NSMutableArray *paths = [NSMutableArray array];
            for (NSURL *url in urlArr) {
                [paths addObject:url.path];
            }
            [self performSelector:@selector(downloadWithPath:) withObject:paths afterDelay:0.3];
        }
    }];
}

- (void)downloadWithPath:(NSMutableArray *)paths {
    
    NSString *pathStr = [paths objectAtIndex:0];
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
    [tranferView transferBtn:_transferBtn];
     tranferView.reloadDelegate = self;
    [tranferView deviceAddDataSoure:preparedArray WithIsDown:YES WithiPod:_iPod withCategoryNodesEnum:_categoryNodeEunm isExportPath:pathStr withSystemPath:nil];
}
/**
 *  到设备
 */
- (void)toDevice:(id)sender {

    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    NSMutableArray *deviceAry = [[NSMutableArray alloc]init];
    for (IMBBaseInfo *baseinfo in deviceConnection.allDevices) {
        if (baseinfo.chooseModelEnum == DeviceLogEnum) {
            [deviceAry addObject:baseinfo];
        }
    }
    if (deviceAry.count > 2) {
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
        
    }else if (deviceAry.count == 2){
        //当链接三个或者以上设备的时候，需要让用户选择到底传输到哪一个设备，这里现在暂时还没加
        IMBDeviceConnection *conn = [IMBDeviceConnection singleton];
        IMBiPod *desIpod = nil;
        for (IMBiPod *ipod in conn.alliPods) {
            if (![ipod.uniqueKey isEqualToString:_iPod.uniqueKey]) {
                desIpod = ipod;
                break;
            }
        }
        [self toDeviceSettingsWithInformation:_information withdesIpod:desIpod];
    }else {
        [self showAlertWithoutMultiDevices];
    }
    [deviceAry release];
    deviceAry = nil;
}

- (void)chooseDeviceBtnClick:(id)sender {
    if (_devChoosePopover != nil) {
        [_devChoosePopover close];
    }
    IMBBaseInfo *baseInfo = (IMBBaseInfo *)sender;
    IMBInformationManager *manager = [IMBInformationManager shareInstance];
    IMBInformation *desInformation = [manager.informationDic objectForKey:baseInfo.uniqueKey];
    //    [manager.informationDic setObject:information forKey:baseInfo.uniqueKey];
    [self toDeviceSettingsWithInformation:_information withdesIpod:desInformation.ipod];
}

- (void)toDeviceSettingsWithInformation:(IMBInformation *)information withdesIpod:(IMBiPod *)desIpod{
    [_transferBtn startTranfering];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *selectAry = [NSMutableArray array];
        NSIndexSet *selectedSet = [self selectedItems];
        IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
        if (_categoryNodeEunm == Category_Media) {
            model.categoryNodes = Category_Music;
        }else if (_categoryNodeEunm == Category_Video) {
            model.categoryNodes = Category_Movies;
        }else {
            model.categoryNodes = _categoryNodeEunm;
        }
        
        NSArray *displayArr = nil;
        if (_isSearch) {
            displayArr = _researchdataSourceArray;
        }else {
            displayArr = _dataSourceArray;
        }
        NSDictionary *dimensionDict = nil;
        switch (_categoryNodeEunm) {
            case Category_PhotoStream:
            case Category_PhotoLibrary:
            case Category_CameraRoll:
            {
                if (desIpod.photoLoadFinished) {
                    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                        IMBPhotoEntity *pe = [displayArr objectAtIndex:idx];
                        [selectAry addObject:pe];
                    }];
                    
                    IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
                    [tranferView transferBtn:_transferBtn];
                     tranferView.reloadDelegate = self;
                    [tranferView toDeviceAddDataSorue:selectAry withCategoryNodesEnum:_categoryNodeEunm srciPodKey:information.ipod.uniqueKey desiPodKey:desIpod.uniqueKey];
                    
                }else {
                    [self showAlertLoadingAnotherDeviceData];
                }
                @autoreleasepool {
                    [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                    dimensionDict = [[TempHelper customDimension] copy];
                }
            }
                break;
            case Category_iBooks:
            {
                if (desIpod.bookLoadFinished) {
                    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                        IMBBookEntity *be = [displayArr objectAtIndex:idx];
                        [selectAry addObject:be];
                    }];
                    
                    IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
                    [tranferView transferBtn:_transferBtn];
                     tranferView.reloadDelegate = self;
                    [tranferView toDeviceAddDataSorue:selectAry withCategoryNodesEnum:_categoryNodeEunm srciPodKey:information.ipod.uniqueKey desiPodKey:desIpod.uniqueKey];
                }else {
                    [self showAlertLoadingAnotherDeviceData];
                }
                @autoreleasepool {
                    [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                    dimensionDict = [[TempHelper customDimension] copy];
                }
            }
                break;
            case Category_appDoucment:
            case Category_Applications:
                //没有to Device功能
                break;
            case Category_Media:
            {
                if (desIpod.mediaLoadFinished) {
                    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                        //TODO
                        IMBTrack *track = [displayArr objectAtIndex:idx];
                        [selectAry addObject:track];
                    }];
                    IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
                    [tranferView transferBtn:_transferBtn];
                     tranferView.reloadDelegate = self;
                    [tranferView toDeviceAddDataSorue:selectAry withCategoryNodesEnum:_categoryNodeEunm srciPodKey:information.ipod.uniqueKey desiPodKey:desIpod.uniqueKey];
                }else {
                    [self showAlertLoadingAnotherDeviceData];
                }
                @autoreleasepool {
                    [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                    dimensionDict = [[TempHelper customDimension] copy];
                }
            }
                break;
            case Category_Video:
            {
                if (desIpod.videoLoadFinished) {
                    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                        //TODO
                        IMBTrack *track = [displayArr objectAtIndex:idx];
                        [selectAry addObject:track];
                    }];
                    IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
                    [tranferView transferBtn:_transferBtn];
                     tranferView.reloadDelegate = self;
                    [tranferView toDeviceAddDataSorue:selectAry withCategoryNodesEnum:_categoryNodeEunm srciPodKey:information.ipod.uniqueKey desiPodKey:desIpod.uniqueKey];
                }else {
                    [self showAlertLoadingAnotherDeviceData];
                }
                @autoreleasepool {
                    [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                    dimensionDict = [[TempHelper customDimension] copy];
                }
            }
                break;
            default:
                break;
        }
        [ATTracker event:CDevice action:AToDevice label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [model release];
        model = nil;
    });
    
    
}
/**
 *  显示提示连接多设备的下拉框
 */
- (void)showAlertWithoutMultiDevices {
    dispatch_async(dispatch_get_main_queue(), ^{

       [IMBCommonTool showSingleBtnAlertInMainWindow:_iPod.uniqueKey btnTitle:CustomLocalizedString(@"Button_Ok", nil)  msgText:CustomLocalizedString(@"Nothave_toDevices", nil) btnClickedBlock:nil];

    });
}
- (void)showAlertLoadingAnotherDeviceData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [IMBCommonTool showSingleBtnAlertInMainWindow:_iPod.uniqueKey btnTitle:CustomLocalizedString(@"Button_Ok", nil)  msgText:CustomLocalizedString(@"AlertView_RemindTo_Loading_Data", nil) btnClickedBlock:nil];
    });
}
/**
 *  添加
 */
- (void)addItems:(id)sender {
    [self addToDeviceSettingsWithInformation:_information];
}

- (void)addToDeviceSettingsWithInformation:(IMBInformation *)information {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setAllowsMultipleSelection:YES];
    
    [openPanel setAllowedFileTypes:[IMBCommonTool getOpenPanelSuffxiWithCategory:_categoryNodeEunm]];
    
    [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (NSModalResponseOK == result) {
            [_transferBtn startTranfering];
            NSMutableArray *paths = [NSMutableArray array];
            for (NSURL *urlPath in openPanel.URLs) {
                [paths addObject:urlPath.path];
            }
            IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
            [tranferView transferBtn:_transferBtn];
             tranferView.reloadDelegate = self;
            [tranferView setAppKey:_appKey];
            [tranferView deviceAddDataSoure:paths WithIsDown:NO WithiPod:_iPod withCategoryNodesEnum:_categoryNodeEunm isExportPath:nil withSystemPath:_currentDevicePath];
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:CDevice action:AUpload label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
//            //TODO:测试APP增加files
//            NSString *path = [paths objectAtIndex:0];
//            AFCApplicationDirectory *afcAppmd = [_iPod.deviceHandle newAFCApplicationDirectory:_appKey];
//            [[_information applicationManager] importCopyFromLocal:path ToApp:afcAppmd ToPath:_currentDevicePath];
//            [afcAppmd close];
        }
    }];
}

/**
 *  删除
 */
- (void)deleteItems:(id)sender {
    [self deleteSettings];
}

- (void)deleteSettings {
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
    if (!preparedArray || preparedArray.count == 0) {
        [IMBCommonTool showSingleBtnAlertInMainWindow:_iPod.uniqueKey btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil) btnClickedBlock:nil];
    }else {
        
        [IMBCommonTool showTwoBtnsAlertInMainWindow:_iPod.uniqueKey firstBtnTitle:CustomLocalizedString(@"Button_Cancel", nil) secondBtnTitle:CustomLocalizedString(@"Button_Ok", nil)  msgText:CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete", nil) firstBtnClickedBlock:nil secondBtnClickedBlock:^{
            [_toolBarButtonView toolBarButtonIsEnabled:NO];
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:CDevice action:ADelete label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            if (_categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
                [_loadAnimationView startAnimation];
                [_contentBox setContentView:_loadingView];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    AFCMediaDirectory *afcMedia = [_iPod.deviceHandle newAFCMediaDirectory];
                    [_systemManager removeFiles:preparedArray afcMediaDir:afcMedia];
                    [_dataSourceArray removeObjectsInArray:preparedArray];
                    [afcMedia close];
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [_loadAnimationView endAnimation];
                        if (_currentSelectView == 0) {
                            [_contentBox setContentView:_tableViewBgView];
                            [_itemTableView reloadData];
                        }else {
                            [_contentBox setContentView:_gridBgView];
                            [_gridView reloadData];
                        }
                    });
                });
                
            }else {
                NSOperationQueue *opQueue = [[[NSOperationQueue alloc] init] autorelease];
                [opQueue addOperationWithBlock:^{
                    NSMutableArray *delArray = [[NSMutableArray alloc] init];
                    switch (_categoryNodeEunm) {
                        case Category_CameraRoll:
                            return;
                            break;
                        case Category_PhotoLibrary:
                        {
                            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                                IMBPhotoEntity *photo = [[displayArr objectAtIndex:idx] retain];
                                IMBTrack *track = [[IMBTrack alloc] init];
                                track.photoZpk = photo.photoZpk;
                                [track setMediaType:Photo];
                                [delArray addObject:track];
                                [track release];
                                [photo release];
                            }];
                        }
                            break;
                        case Category_iBooks:
                        {
                            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                                IMBBookEntity *bookEntity = [[displayArr objectAtIndex:idx] retain];
                                IMBTrack *newTrack = [[IMBTrack alloc] init];
                                int64_t dbid = 0;
                                if ([self isUnusualPersistentID:bookEntity.bookID]) {
                                    [newTrack setIsUnusual:YES];
                                    [newTrack setHexPersistentID:bookEntity.bookID];
                                }else{
                                    dbid = [bookEntity.bookID longLongValue];
                                }
                                [newTrack setArtist:bookEntity.author];
                                [newTrack setGenre:bookEntity.genre];
                                
                                NSString *path = [NSString stringWithFormat:@"Books/%@",[bookEntity.path lastPathComponent]];
                                
                                [newTrack setAlbumArtist:bookEntity.album];
                                [newTrack setTitle:bookEntity.bookName.length == 0 ? @"0":bookEntity.bookName];
                                [newTrack setFilePath:path];
                                [newTrack setIsVideo:NO];
                                NSString *publisherUniqueID = bookEntity.publisherUniqueID;
                                NSString *packageHash = bookEntity.packageHash;
                                MediaTypeEnum type;
                                if ([[path pathExtension].lowercaseString isEqualToString:@"epub"]) {
                                    type = Books;
                                    [newTrack setFileSize:(uint)[[_iPod fileSystem] getFolderSize:[[[_iPod fileSystem] driveLetter] stringByAppendingPathComponent:[NSString stringWithFormat:@"Books/%@",[path lastPathComponent]]]]];
                                }else{
                                    type = PDFBooks;
                                    [newTrack setFileSize:(uint)[[_iPod fileSystem] getFileLength:[[[_iPod fileSystem] driveLetter] stringByAppendingPathComponent:[NSString stringWithFormat:@"Books/%@",[path lastPathComponent]]]]];
                                }
                                [newTrack setMediaType:type];
                                newTrack.dbID = dbid;
                                newTrack.uuid = publisherUniqueID;
                                newTrack.mediaType = type;
                                newTrack.packageHash = packageHash;
                                [delArray addObject:newTrack];
                                [newTrack release];
                                newTrack = nil;
                            }];
                        }
                            break;
                        case Category_appDoucment:
                        case Category_Applications:
                        {
                            [_loadAnimationView startAnimation];
                            [_contentBox setContentView:_loadingView];
                            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                                if (_isSmipNode) {
                                    SimpleNode *fileEntity = [[displayArr objectAtIndex:idx] retain];
                                    [delArray addObject:fileEntity];
                                    [fileEntity release];
                                    fileEntity = nil;
                                }else {
                                    IMBAppEntity *app = [[displayArr objectAtIndex:idx] retain];
                                    [delArray addObject:app];
                                    [app release];
                                    app = nil;
                                }
                            }];
                            
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{

                                AFCApplicationDirectory *afcAppmd = [_iPod.deviceHandle newAFCApplicationDirectory:_appKey];
                                [[_information applicationManager] removeAppDoucment:delArray appAFC:afcAppmd];
                                [afcAppmd close];

                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    [_loadAnimationView endAnimation];
                                    [_toolBarButtonView toolBarButtonIsEnabled:YES];
                                    if (_currentSelectView == 0) {
                                        [_contentBox setContentView:_tableViewBgView];
                                        [_itemTableView reloadData];
                                    }else {
                                        [_contentBox setContentView:_gridBgView];
                                        [_gridView reloadData];
                                    }
                                });
                            });
                            
                            return;
                        }
                            break;
                        case Category_Media:
                        {
                            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                                IMBTrack *track = [[displayArr objectAtIndex:idx] retain];
                                [delArray addObject:track];
                                [track release];
                                track = nil;
                            }];
                        }
                            break;
                        case Category_Video:
                        {
                            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                                IMBTrack *track = [[displayArr objectAtIndex:idx] retain];
                                [delArray addObject:track];
                                [track release];
                                track = nil;
                            }];
                        }
                            break;
                        case Category_Storage:
                        case Category_System:
                            break;
                        default:
                            break;
                    }
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [_contentBox setContentView:_loadingView];
                        [_loadAnimationView startAnimation];
                    });
                    IMBDeleteTrack *deleteTrack = [[IMBDeleteTrack alloc] initWithIPod:_iPod deleteArray:delArray Category:_categoryNodeEunm];
                    [deleteTrack setDelegate:self];
                    [deleteTrack startDelete];
                    [deleteTrack release];
                    [delArray release];
                    delArray = nil;
                    
                    
                }];
                
            }
        }];
    }
}

/**
 *  to iCloud
 */
- (void)toiCloud:(id)sender {
    if (_devChoosePopover != nil) {
        [_devChoosePopover close];
    }

    NSMutableArray *deviceAry = [[NSMutableArray alloc]init];
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
        if (baseInfo.chooseModelEnum != DeviceLogEnum) {
            [deviceAry addObject:baseInfo];
        }
    }
    if (deviceAry.count ==1) {
        for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
            if (baseInfo.chooseModelEnum != DeviceLogEnum) {
                baseInfo.isSelected = YES;
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                if ([baseInfo chooseModelEnum] == iCloudLogEnum) {
                    [ATTracker event:CDevice action:AToiCloudDrive label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                }else if ([baseInfo chooseModelEnum] == DropBoxLogEnum) {
                    [ATTracker event:CDevice action:AToDropbox label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                }
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                [deviceAry addObject:baseInfo];
            }
        }
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
        [_transferBtn startTranfering];
        IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
        tranferView.appKey = _appKey;
         tranferView.reloadDelegate = self;

        [tranferView transferBtn:_transferBtn];
        [tranferView downDeviceDataSoure:preparedArray WithIsDown:NO WithiPod:_iPod withCategoryNodesEnum:_categoryNodeEunm isExportPath:[TempHelper getAppTempPath] withSystemPath:nil];

    }else if (deviceAry.count == 0) {
        [IMBCommonTool showSingleBtnAlertInMainWindow:_iPod.uniqueKey btnTitle:CustomLocalizedString(@"Button_Ok", nil)  msgText:CustomLocalizedString(@"iCloudBackup_View_Loggin_Tips", nil) btnClickedBlock:nil];
    }else {
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
        [_devicePopoverViewController setAction:@selector(chooseiCloudBtnClick:)];
        [_devicePopoverViewController release];
        NSButton *targetButton = (NSButton *)sender;
        NSRectEdge prefEdge = NSMaxYEdge;
        NSRect rect = NSMakeRect(targetButton.bounds.origin.x, targetButton.bounds.origin.y, targetButton.bounds.size.width, targetButton.bounds.size.height);
        [_devChoosePopover showRelativeToRect:rect ofView:sender preferredEdge:prefEdge];
    }
}

- (void)chooseiCloudBtnClick:(id)sender {
//    if (_devChoosePopover.isShown) {
        [_devChoosePopover close];
//    }
    
    IMBBaseInfo *selectedBaseInfo = (IMBBaseInfo *)sender;
    [selectedBaseInfo setIsSelected:YES];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    if ([selectedBaseInfo chooseModelEnum] == iCloudLogEnum) {
        [ATTracker event:CDevice action:AToiCloudDrive label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }else if ([selectedBaseInfo chooseModelEnum] == DropBoxLogEnum) {
        [ATTracker event:CDevice action:AToDropbox label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
//    NSString *filePath = [TempHelper getAppTempPath];
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
    [_transferBtn startTranfering];
    IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
    [tranferView transferBtn:_transferBtn];
     tranferView.reloadDelegate = self;
    [tranferView downDeviceDataSoure:preparedArray WithIsDown:NO WithiPod:_iPod withCategoryNodesEnum:_categoryNodeEunm isExportPath:[TempHelper getAppTempPath] withSystemPath:nil];

}
/**
 *  预览
 */
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
        for (int i = 0; i < preparedArray.count; ) {
            id item = [preparedArray objectAtIndex:i];
            [self previewFile:item];
            break;
        }
    }
}

- (void)previewFile:(id)entity {
    _isPreview = YES;
    [_promptLabel setTextColor:COLOR_TEXT_EXPLAIN];
    [_promptImageView setImage:[NSImage imageNamed:@"message-box-progress"]];
    [self addPromptCustomView:CustomLocalizedString(@"prompt_perview_file", nil)];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:CDevice action:APreview label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSString *tempPath = [IMBHelper getAppTempPath];
    DriveItem *downloaditem = [[DriveItem alloc] init];
    [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    if (_categoryNodeEunm == Category_Media || _categoryNodeEunm == Category_Video) {
        IMBTrack *item = (IMBTrack *)entity;
        downloaditem.isDownLoad = YES;
        downloaditem.fileName = item.title;
        downloaditem.oriPath = item.filePath;
        downloaditem.fileSize = item.fileSize;
        downloaditem.photoDateData = item.dateLastModified;
        downloaditem.localPath = [tempPath stringByAppendingPathComponent:downloaditem.fileName];
        
        IMBMediaFileExport *baseTransfer = [[IMBMediaFileExport alloc] initWithIPodkey:_iPod.uniqueKey exportTracks:[NSArray arrayWithObject:downloaditem] exportFolder:tempPath withDelegate:self];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [baseTransfer startTransfer];
            [baseTransfer release];
        });
    }else if (_categoryNodeEunm == Category_iBooks) {
        IMBBookEntity *item = (IMBBookEntity *)entity;
        downloaditem.isDownLoad = YES;
        downloaditem.fileName = item.bookName;
        downloaditem.oriPath = item.path;
        downloaditem.isBigFile = item.isPurchase;
        downloaditem.extension = item.extension;
        downloaditem.fileSize = item.size;
        downloaditem.allPath = item.fullPath;
        downloaditem.localPath = [tempPath stringByAppendingPathComponent:downloaditem.fileName];
        
        IMBiBooksExport *baseTransfer = [[IMBiBooksExport alloc] initWithIPodkey:_iPod.uniqueKey exportTracks:[NSArray arrayWithObject:downloaditem] exportFolder:tempPath withDelegate:self];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [baseTransfer startTransfer];
            [baseTransfer release];
        });
    }else if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment) {
        if (_isSmipNode) {
            SimpleNode *item = (SimpleNode *)entity;
            downloaditem.isFolder = item.container;
            downloaditem.oriPath = item.path;
            downloaditem.fileName = item.fileName;
            downloaditem.localPath = [tempPath stringByAppendingPathComponent:downloaditem.fileName];
            
            IMBAppExport *baseTransfer = [[IMBAppExport alloc] initWithIPodkey:_iPod.uniqueKey exportTracks:[NSArray arrayWithObject:downloaditem] exportFolder:tempPath withDelegate:self];
            baseTransfer.appKey = _appKey;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [baseTransfer fileStartTransfer];
                [baseTransfer release];
            });
        }
    }else if (_categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
        SimpleNode *item = (SimpleNode *)entity;
        downloaditem.isFolder = item.container;
        downloaditem.oriPath = item.path;
        downloaditem.fileName = item.fileName;
        downloaditem.localPath = [tempPath stringByAppendingPathComponent:downloaditem.fileName];
        
        IMBFileSystemExport *baseTransfer = [[IMBFileSystemExport alloc] initWithIPodkey:_iPod.uniqueKey exportTracks:[NSArray arrayWithObject:downloaditem] exportFolder:tempPath withDelegate:self];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [baseTransfer startTransfer];
            [baseTransfer release];
        });
    }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
        IMBPhotoEntity *item = (IMBPhotoEntity *)entity;
        downloaditem.isDownLoad = YES;
        downloaditem.fileName = item.photoName;
        downloaditem.allPath = item.allPath;
        downloaditem.photoPath = item.photoPath;
        downloaditem.kindSubType = item.kindSubType;
        downloaditem.thumbPath = item.thumbPath;
        downloaditem.oriPath = item.oriPath;
        downloaditem.photoDateData = item.photoDateData;
        downloaditem.fileSize = item.photoSize;
        downloaditem.docwsID = item.photoUUIDString;
        downloaditem.localPath = [tempPath stringByAppendingPathComponent:downloaditem.fileName];
        
        IMBPhotoFileExport *baseTransfer = [[IMBPhotoFileExport alloc] initWithIPodkey:_iPod.uniqueKey exportTracks:[NSArray arrayWithObject:downloaditem] exportFolder:tempPath withDelegate:self];
        [(IMBPhotoFileExport *)baseTransfer setExportType:1];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [baseTransfer startTransfer];
            [baseTransfer release];
        });
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    id <DownloadAndUploadDelegate> item = object;
    if (item.state == DownloadStateComplete) {
        NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
        [workspace openFile:item.localPath];
        [(NSObject*)item removeObserver:self forKeyPath:@"state"];
    }else if (item.state == DownloadStateError){
        
        [(NSObject*)item removeObserver:self forKeyPath:@"state"];
    }
}

/**
 *  移动
 */
- (void)moveToFolder:(id)sender {
    if (_categoryNodeEunm == Category_Applications || _categoryNodeEunm == Category_appDoucment|| _categoryNodeEunm == Category_System ||_categoryNodeEunm == Category_Storage) {
        if (_isSmipNode || _categoryNodeEunm == Category_System||_categoryNodeEunm == Category_Storage) {
            NSArray *displayArr = nil;
            if (_isSearch) {
                displayArr = _researchdataSourceArray;
            }else {
                displayArr = _dataSourceArray;
            }
            NSMutableArray *folderArr = [NSMutableArray array];
            for (SimpleNode *entity in displayArr) {
                if (entity.container && entity.checkState == UnChecked) {
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
    }
}

- (void)startMoveTransferWith:(SimpleNode *)entity {
    if (_categoryNodeEunm == Category_Applications || _categoryNodeEunm == Category_appDoucment|| _categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
        if (_isSmipNode || _categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
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
                [_contentBox setContentView:_loadingView];
                [_loadAnimationView startAnimation];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    AFCApplicationDirectory *afcAppmd = [_iPod.deviceHandle newAFCApplicationDirectory:_appKey];
                    NSDictionary *dimensionDict = nil;
                    for (SimpleNode *itemEntity in preparedArray) {
                        NSString *oriPath = itemEntity.path;
                        NSString *desPath = @"";
                        if (itemEntity.container) {
                            desPath = [entity.path stringByAppendingPathComponent:itemEntity.fileName];
                        }else {
                            desPath = [entity.path stringByAppendingPathComponent:[itemEntity.fileName stringByAppendingPathExtension:itemEntity.extension]];
                        }
                        BOOL ret = NO;
                        if (_categoryNodeEunm == Category_System || _categoryNodeEunm ==Category_Storage) {
                            @autoreleasepool {
                                [TempHelper customViewType:_chooseLogModelEnmu withCategoryEnum:_categoryNodeEunm];
                                dimensionDict = [[TempHelper customDimension] copy];
                            }
                            ret = [_systemManager moveFile:oriPath desPath:desPath isFolder:itemEntity.container];
                        }else {
                            ret = [[_information applicationManager] moveFile:oriPath desPath:desPath isFolder:itemEntity.container appAFC:afcAppmd];
                        }
                        
                        if (ret && [_dataSourceArray containsObject:itemEntity]) {
                            [_dataSourceArray removeObject:itemEntity];
                            [ATTracker event:CDevice action:AMove label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                        }else {
                            [ATTracker event:CDevice action:AMove label:LFailed labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                        }
                    }
                    if (dimensionDict) {
                        [dimensionDict release];
                        dimensionDict = nil;
                    }
                    [afcAppmd close];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_loadAnimationView endAnimation];
                        if (_currentSelectView == 0) {
                            [_contentBox setContentView:_tableViewBgView];
                            [_itemTableView reloadData];
                        }else {
                            [_contentBox setContentView:_gridBgView];
                            [_gridView reloadData];
                        }
                        _curEntity = nil;
                    });
                });
            }
        }
    }
}

/**
 *  创建文件夹
 */
- (void)createNewFloder:(id)sender {
    if ((_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment || _categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage)&&_dataSourceArray != nil) {
        if (_isSmipNode || _categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
            [_gridView deselectAllItems];
            SimpleNode *newEntity = [[SimpleNode alloc] init];
            newEntity.fileName = CustomLocalizedString(@"Function_New_Folder", nil);
            newEntity.container = YES;
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
                [_editTextField setStringValue:[(SimpleNode *)_curEntity fileName]];
                [_editTextField setEditable:YES];
                [_editTextField setSelectable:YES];
                
                [_editTextField setFrameOrigin:NSMakePoint(54, 0)];
                [_itemTableView addSubview:_editTextField];
                [_editTextField becomeFirstResponder];
            }
            [_toolBarButtonView toolBarButtonIsEnabled:NO];
            [newEntity release];
            newEntity = nil;
        }
    }
}

/**
 *  重命名
 */
- (void)rename:(id)sender {
    NSIndexSet *selectedSet = [self selectedItems];
    if (selectedSet.count > 1) {
        [self showAlertText:CustomLocalizedString(@"System_id_1", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    if (_categoryNodeEunm == Category_Applications || _categoryNodeEunm == Category_appDoucment|| _categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
        if (_isSmipNode || _categoryNodeEunm == Category_System||_categoryNodeEunm == Category_Storage) {
            SimpleNode *node = (SimpleNode *)_curEntity;
            if (_currentSelectView == 1) {
                node.isEdit = YES;
                node.isEditing = NO;
                [_gridView reloadData];
            }else {
                _isTableViewEdit = YES;
                NSUInteger row = [_itemTableView selectedRow];
                [_editTextField setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
                [_editTextField setFocusRingType:NSFocusRingTypeDefault];
                [_editTextField setStringValue:node.fileName];
                [_editTextField setEditable:YES];
                [_editTextField setSelectable:YES];
                
                [_editTextField setFrameOrigin:NSMakePoint(54, row*60)];
                [_itemTableView addSubview:_editTextField];
                [_editTextField becomeFirstResponder];
            }
        }
    }
    [_toolBarButtonView toolBarButtonIsEnabled:NO];
}

- (void)executeRenameOrCreate {
    [_editTextField removeFromSuperview];
    if (_categoryNodeEunm == Category_Applications|| _categoryNodeEunm == Category_appDoucment || _categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
        if (_isSmipNode || _categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
            SimpleNode *node = (SimpleNode *)_curEntity;
            if (_isTableViewEdit && !node.isCreating) {
                _isTableViewEdit = NO;
                if (_curEntity) {
                    BOOL isDelete = NO;
                    NSString *newName = _editTextField.stringValue;
                    if (![StringHelper stringIsNilOrEmpty:newName] && ![node.fileName isEqualToString:newName]) {
                        if (node.extension && !node.container){
                            newName = [[newName stringByAppendingString:@"."] stringByAppendingString:node.extension];
                        }
                        if (node.isCreate) {
                            node.isCreating = YES;
//                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            BOOL ret = NO;
                            if (_categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
                                ret = [_systemManager createFolder:[_currentDevicePath stringByAppendingPathComponent:newName]];
                            }else {
                                AFCApplicationDirectory *afcAppmd = [_iPod.deviceHandle newAFCApplicationDirectory:_appKey];
                                ret = [[_information applicationManager] createAppFolder:[_currentDevicePath stringByAppendingPathComponent:newName] appAFC:afcAppmd];
                                [afcAppmd close];
                            }
//                                dispatch_async(dispatch_get_main_queue(), ^{
                                    node.isCreating = NO;
                                    [_promptLabel setTextColor:COLOR_TEXT_PRIORITY];
                                    if (ret) {
                                        node.fileName = _editTextField.stringValue;
                                        node.path = [_currentDevicePath stringByAppendingPathComponent:newName];
                                        [_promptImageView setImage:[NSImage imageNamed:@"message-box-success"]];
                                        [self addPromptCustomView:CustomLocalizedString(@"prompt_create_floder_success", nil)];
                                    }else {
                                        [_promptImageView setImage:[NSImage imageNamed:@"message-box-error"]];
                                        [self addPromptCustomView:CustomLocalizedString(@"prompt_create_floder_failed", nil)];
                                        [_dataSourceArray removeObject:node];
                                        isDelete = YES;
                                        _curEntity = nil;
                                    }
//                                });
//                            });
                        } else {
//                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            BOOL ret = NO;
                            if (_categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
                                ret = [_systemManager rename:node withfileName:newName];
                            }else {
                                AFCApplicationDirectory *afcAppmd = [_iPod.deviceHandle newAFCApplicationDirectory:_appKey];
                                ret = [[_information applicationManager] rename:node.path withfileName:newName appAFC:afcAppmd];
                                [afcAppmd close];
                            }
//                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (ret) {
                                        NSString *newfilePath = [[node.path stringByDeletingLastPathComponent] stringByAppendingPathComponent:newName];
                                        node.fileName = _editTextField.stringValue;
                                        node.path = newfilePath;
                                    }
//                                });
//                            });
                        }
                    }else {
                        if (node.isCreate) {
                            node.isCreating = YES;
//                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            BOOL ret = NO;
                            if (_categoryNodeEunm == Category_System || _categoryNodeEunm == Category_Storage) {
                                ret = [_systemManager createFolder:[_currentDevicePath stringByAppendingPathComponent:newName]];
                            }else {
                                AFCApplicationDirectory *afcAppmd = [_iPod.deviceHandle newAFCApplicationDirectory:_appKey];
                                ret = [[_information applicationManager] createAppFolder:[_currentDevicePath stringByAppendingPathComponent:newName] appAFC:afcAppmd];
                                [afcAppmd close];
                            }
//                                dispatch_async(dispatch_get_main_queue(), ^{
                                    node.isCreating = NO;
                                    [_promptLabel setTextColor:COLOR_TEXT_PRIORITY];
                                    if (ret) {
                                        node.fileName = _editTextField.stringValue;
                                        node.path = [_currentDevicePath stringByAppendingPathComponent:newName];
                                        [_promptImageView setImage:[NSImage imageNamed:@"message-box-success"]];
                                        [self addPromptCustomView:CustomLocalizedString(@"prompt_create_floder_success", nil)];
                                    }else {
                                        [_promptImageView setImage:[NSImage imageNamed:@"message-box-error"]];
                                        [self addPromptCustomView:CustomLocalizedString(@"prompt_create_floder_failed", nil)];
                                        [_dataSourceArray removeObject:node];
                                        isDelete = YES;
                                        _curEntity = nil;
                                    }
//                                });
//                            });
                        }
                    }
                    if (!isDelete) {
                        node.isEdit = NO;
                        node.isEditing = NO;
                        node.isCreate = NO;
                    }
                }
            }
        }
    }
    [_toolBarButtonView toolBarButtonIsEnabled:YES];
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

#pragma mark -- 删除代理方法
- (void)setDeleteProgress:(float)progress withWord:(NSString *)msgStr {
    
}

- (void)setDeleteComplete:(int)success totalCount:(int)totalCount {
    
    if (!_isPreview) {
        _isPreview = NO;
        [self setCompletionWithSuccessCount:success totalCount:totalCount title:@"Delete Completed"];
    }
}

- (void)setCompletionWithSuccessCount:(int)successCount totalCount:(int)totalCount title:(NSString *)title {
    if (![[IMBDeviceConnection singleton] getiPodByKey:_iPod.uniqueKey]) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [IMBCommonTool showSingleBtnAlertInMainWindow:_iPod.uniqueKey btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:[NSString stringWithFormat:CustomLocalizedString(@"MoveFileTips", nil),successCount,totalCount] btnClickedBlock:^{
                [self reload:nil];
            }];
        });
        
        
    });
}

//medie 和video图片获取
- (NSData *)createThumbImage:(IMBTrack *)track {
    NSString *filePath = nil;
    if (track.artwork.count>0) {
        id entityObj = [track.artwork objectAtIndex:0];
        if ([entityObj isKindOfClass:[IMBArtworkEntity class]]) {
            IMBArtworkEntity *entity = (IMBArtworkEntity*)entityObj;
            filePath = entity.filePath;
            if (filePath.length == 0) {
                filePath = entity.localFilepath;
            }
        }
    }else{
        filePath =track.artworkPath;
    }
    NSData *data = [self readFileData:filePath];;
    if (data) {
        NSImage *sourceImage = [[NSImage alloc] initWithData:data];
        NSData *imageData = [IMBHelper createThumbnail:sourceImage withWidth:80 withHeight:60];
        [sourceImage release];
        
        return imageData;
    }else {
        return nil;
    }
}

//photo 图片获取
- (NSData *)createImageToTableView:(IMBPhotoEntity *)entity {
    NSString *filePath = nil;
    if (entity.photoKind == 0) {
        if ([_iPod.deviceHandle.productVersion isVersionMajorEqual:@"7"]) {
            if ([_iPod.fileSystem fileExistsAtPath:entity.thumbPath]) {
                filePath = entity.thumbPath;
            }else {
                filePath = entity.allPath;
            }
        }else {
            if ([_iPod.fileSystem fileExistsAtPath:entity.allPath]) {
                filePath = entity.allPath;
            }
        }
    }else if (entity.photoKind == 1) {
        if ([_iPod.deviceHandle.productVersion isVersionMajorEqual:@"7"]) {
            if ([_iPod.fileSystem fileExistsAtPath:entity.thumbPath]) {
                filePath = entity.thumbPath;
            }else {
                filePath = entity.videoPath;
            }
        }else {
            if ([_iPod.fileSystem fileExistsAtPath:entity.videoPath]) {
                filePath = entity.videoPath;
            }
        }
    }
    
    NSData *data = [self readFileData:filePath];
    NSImage *sourceImage = [[NSImage alloc] initWithData:data];
    
    NSData *imageData = [TempHelper createThumbnail:sourceImage withWidth:80 withHeight:80];
    [sourceImage release];
    
    return imageData;
}

- (int)cacuCount:(NSString *)nodePath{
    AFCMediaDirectory *afcMedia = [_iPod.deviceHandle newAFCMediaDirectory];
    NSArray *array = [afcMedia directoryContents:nodePath];
    [afcMedia close];
    return (int)[array count];
}

- (BOOL)isUnusualPersistentID:(NSString *)persistentID{
    for (int i = 0; i < persistentID.length; i ++) {
        unichar charcode = [persistentID characterAtIndex:i];
        if ((charcode > 'a' && charcode < 'z') || (charcode >= 'A' && charcode <= 'Z')) {
            return YES;
        }
    }
    return NO;
}

- (NSData *)readFileData:(NSString *)filePath {
    if (![_iPod.fileSystem fileExistsAtPath:filePath]) {
        return nil;
    }
    else{
        long long fileLength = [_iPod.fileSystem getFileLength:filePath];
        AFCFileReference *openFile = [_iPod.fileSystem openForRead:filePath];
        const uint32_t bufsz = 10240;
        char *buff = (char*)malloc(bufsz);
        NSMutableData *totalData = [[[NSMutableData alloc] init] autorelease];
        while (1) {
            
            uint64_t n = [openFile readN:bufsz bytes:buff];
            if (n==0) break;
            //将字节数据转化为NSdata
            NSData *b2 = [[NSData alloc] initWithBytesNoCopy:buff length:n freeWhenDone:NO];
            [totalData appendData:b2];
            [b2 release];
        }
        if (totalData.length == fileLength) {
            
        }
        free(buff);
        [openFile closeFile];
        return totalData;
    }
}

- (void)transferComplete:(int)successCount TotalCount:(int)totalCount{
    [_transferBtn endTranfering];
    [self reload:nil];
}

- (void)moveitemsToIndex:(int)index {
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else {
        displayArr = _dataSourceArray;
    }
    SimpleNode *entity = [displayArr objectAtIndex:index];
    if (entity.container && entity.checkState == UnChecked) {
        [self startMoveTransferWith:entity];
    }
}

@end
