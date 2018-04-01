//
//  IMBDevicePageViewController.m
//  iOSFiles
//
//  Created by JGehry on 3/14/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBDevicePageViewController.h"
#import "IMBDevicePageFolderModel.h"
#import "IMBDrawOneImageBtn.h"
#import "IMBDeviceAllDataViewController.h"
#import "IMBiCloudPathSelectBtn.h"
#import "IMBTagImageView.h"

@interface IMBDevicePageViewController ()

@end

@implementation IMBDevicePageViewController

- (id)initWithiPod:(IMBiPod *)ipod withDelegate:(id)delegate{
    if ([super initWithNibName:@"IMBDevicePageViewController" bundle:nil]) {
        _iPod = [ipod retain];
        _delegate = delegate;
    }
    return self;
}

- (void)awakeFromNib {
    [self loadData];
    [super awakeFromNib];
    _sonControllerDic = [[NSMutableDictionary alloc]init];
    [self configSelectPathButtonWithButtonTag:1 WithButtonTitle:_iPod.deviceInfo.deviceName];

    [_topLineView setBackgroundColor:COLOR_TEXT_LINE];
    _gridView.itemSize = NSMakeSize(154, 154);
    _gridView.backgroundColor = [NSColor whiteColor];
    _gridView.scrollElasticity = NO;
    _gridView.allowsDragAndDrop = YES;
    _gridView.allowsMultipleSelection = YES;
    _gridView.allowsMultipleSelectionWithDrag = YES;
    _gridView.allowClickMultipleSelection = NO;
    [_gridView setIsFileManager:YES];
    [_gridView reloadData];
    [_contenBox setContentView:_mainView];
}

- (void)loadData {
    _dataSourceArray = [[NSMutableArray alloc] init];
    _information = [[IMBInformation alloc] initWithiPod:_iPod];
    IMBDevicePageFolderModel *devicePagePhoto = [[IMBDevicePageFolderModel alloc]init];
    devicePagePhoto.name = CustomLocalizedString(@"MenuItem_id_9", nil);
    devicePagePhoto.image = [NSImage imageNamed:@"folder_icon_img"];
    devicePagePhoto.nodesEnum = Category_Photos;
    
    IMBDevicePageFolderModel *devicePageBook = [[IMBDevicePageFolderModel alloc]init];
    devicePageBook.name = CustomLocalizedString(@"MenuItem_id_13", nil);
    devicePageBook.image = [NSImage imageNamed:@"folder_icon_books"];
    devicePageBook.nodesEnum = Category_iBooks;
    
    IMBDevicePageFolderModel *devicePageMedia = [[IMBDevicePageFolderModel alloc]init];
    devicePageMedia.name = CustomLocalizedString(@"Device_MainPage_View_Media", nil);
    devicePageMedia.image = [NSImage imageNamed:@"folder_icon_media"];
    devicePageMedia.nodesEnum = Category_Media;
    
    IMBDevicePageFolderModel *devicePageVideo = [[IMBDevicePageFolderModel alloc]init];
    devicePageVideo.name = CustomLocalizedString(@"MenuItem_id_29", nil);
    devicePageVideo.image = [NSImage imageNamed:@"folder_icon_video"];
    devicePageVideo.nodesEnum = Category_Video;
    
    IMBDevicePageFolderModel *devicePageApp = [[IMBDevicePageFolderModel alloc]init];
    devicePageApp.name = CustomLocalizedString(@"MenuItem_id_33", nil);
    devicePageApp.image = [NSImage imageNamed:@"folder_icon_app"];
    devicePageApp.nodesEnum = Category_Applications;
    
    IMBDevicePageFolderModel *devicePageOther  = [[IMBDevicePageFolderModel alloc]init];
    devicePageOther.name = CustomLocalizedString(@"MenuItem_id_30", nil);
    devicePageOther.image = [NSImage imageNamed:@"folder_icon_others"];
    devicePageOther.nodesEnum = Category_System;
    
    IMBDevicePageFolderModel *cameraRollModel = [[IMBDevicePageFolderModel alloc]init];
    cameraRollModel.name = CustomLocalizedString(@"MenuItem_id_10", nil);
    cameraRollModel.image = [NSImage imageNamed:@"folder_icon_camera"];
    cameraRollModel.nodesEnum = Category_CameraRoll;
    
    IMBDevicePageFolderModel *photoStreamModel = [[IMBDevicePageFolderModel alloc]init];
    photoStreamModel.name = CustomLocalizedString(@"MenuItem_id_11", nil);
    photoStreamModel.image = [NSImage imageNamed:@"folder_icon_screen"];
    photoStreamModel.nodesEnum = Category_PhotoStream;
    
    IMBDevicePageFolderModel *photoLibraryModel = [[IMBDevicePageFolderModel alloc]init];
    photoLibraryModel.name = CustomLocalizedString(@"MenuItem_id_12", nil);
    photoLibraryModel.image = [NSImage imageNamed:@"folder_icon_library"];
    photoLibraryModel.nodesEnum = Category_PhotoLibrary;
    
    [devicePagePhoto.subPhotoArray addObject:cameraRollModel];
    [devicePagePhoto.subPhotoArray addObject:photoStreamModel];
    [devicePagePhoto.subPhotoArray addObject:photoLibraryModel];
    [_dataSourceArray addObject:devicePagePhoto];
    [_dataSourceArray addObject:devicePageBook];
    [_dataSourceArray addObject:devicePageMedia];
    [_dataSourceArray addObject:devicePageVideo];
    [_dataSourceArray addObject:devicePageApp];
    [_dataSourceArray addObject:devicePageOther];

    [devicePagePhoto release];
    [devicePageBook release];
    [devicePageMedia release];
    [devicePageVideo release];
    [devicePageOther release];
    [devicePageApp release];
    [cameraRollModel release];
    [photoStreamModel release];
    [photoLibraryModel release];
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
    
    IMBDevicePageFolderModel *fileEntity = [array objectAtIndex:index];
    item.bgImg = fileEntity.image;
    item.itemTitle = fileEntity.name;
    item.selected = fileEntity.checkState;
    item.isFileManager = YES;
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
        IMBDevicePageFolderModel *fielEntity = [array objectAtIndex:index];
        fielEntity.checkState = Check;
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
        IMBDevicePageFolderModel *fielEntity = [array objectAtIndex:index];
        fielEntity.checkState = UnChecked;
    }
}

- (void)gridViewDidDeselectAllItems:(CNGridView *)gridView {
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    
    for (IMBDevicePageFolderModel *fileEntity in array) {
        fileEntity.checkState = UnChecked;
    }
    [_gridView reloadSelecdImage];
}

- (void)gridView:(CNGridView *)gridView didDoubleClickItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    IMBDevicePageFolderModel *fielEntity = [array objectAtIndex:index];
    _category = fielEntity.nodesEnum;
    if (_category == Category_Photos) {
        [self configSelectPathButtonWithButtonTag:2 WithButtonTitle:[StringHelper getCategeryStr:_category]];
        _isSearch = YES;
        [_researchdataSourceArray addObjectsFromArray:fielEntity.subPhotoArray];
        [_gridView reloadData];
        return;
    }else {
        IMBDeviceAllDataViewController *baseViewController = nil;
        baseViewController = [_sonControllerDic objectForKey:[NSString stringWithFormat:@"%d",_category]];
        if (!baseViewController) {
            baseViewController = [[IMBDeviceAllDataViewController alloc] initWithCategoryNodesEnum:_category withiPod:_iPod WithDelegete:self];
            [baseViewController loadToolBarView:_category WithDisplayMode:YES];
            [_contenBox setContentView:baseViewController.view];
            [_sonControllerDic setObject:baseViewController forKey:[NSString stringWithFormat:@"%d",_category]];
        }else {
            [_contenBox setContentView:baseViewController.view];
        }
    }
}

#pragma mark - path button config
- (void)configSelectPathButtonWithButtonTag:(int)buttonTag WithButtonTitle:(NSString *)buttonTitle {
    NSString *fileName = buttonTitle;
    if (fileName.length > 50) {
        fileName = [[fileName substringWithRange:NSMakeRange(0, 50)] stringByAppendingString:@"..."];
    }
    NSRect textRect = [StringHelper calcuTextBounds:fileName fontSize:14.0];
    int width = textRect.size.width + 10;
    int height = textRect.size.height + 4;
    
    if (buttonTag == 1) {
        if (_button1 != nil) {
            [_button1 release];
            _button1 = nil;
        }
        _button1 = [[IMBiCloudPathSelectBtn alloc] initWithFrame:NSMakeRect(20, (_topView.frame.size.height - height)/2 - 2, width, height)];
        [_button1 setButtonName:fileName];
        [_button1 setToolTip:buttonTitle];
        [_button1 setTag:buttonTag];
        [_button1 setTarget:self];
        [_button1 setAction:@selector(backAction:)];
        [_topView addSubview:_button1];
        
    } else {
        if (_button2 != nil) {
            [_button2 release];
            _button2 = nil;
        }
        _button2 = [[IMBiCloudPathSelectBtn alloc] initWithFrame:NSMakeRect(20 + _button1.frame.size.width + 10, (_topView.frame.size.height - height)/2 - 2, width, height)];
        [_button2 setButtonName:fileName];
        [_button2 setEnabled:NO];
        [_button2 setToolTip:buttonTitle];
        [_button2 setTag:buttonTag];
        [_button2 setTarget:self];
        [_button2 setAction:@selector(backAction:)];
        [_topView addSubview:_button2];
        
        if (_tagImageView != nil) {
            [_tagImageView release];
            _tagImageView = nil;
        }
        _tagImageView = [[IMBTagImageView alloc] initWithFrame:NSMakeRect(_button1.frame.origin.x + _button1.frame.size.width, (_topView.frame.size.height - 9)/2.0 - 3, 10, 9)];
        [_tagImageView setImage:[NSImage imageNamed:@"addcontent_arrowright1"]];
        [_tagImageView setViewTag:buttonTag];
        [_topView addSubview:_tagImageView];
    }
    
}

#pragma - mark back Actions
- (void)backAction:(id)sender {
    int tag = (int)[(IMBiCloudPathSelectBtn *)sender tag];
    if (tag == 1) {
        if (_button2) {
            [_button2 removeFromSuperview];
            [_tagImageView removeFromSuperview];
        }
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
    }
    [_gridView reloadData];
    [_contenBox setContentView:_mainView];
}

- (void)closeWindow:(id)sender {
    [_delegate closeWindow:sender];
}

#pragma mark - 搜索
- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchView {
    _searhView = searchView;
    if (_category != Category_Photos) {
        IMBDeviceAllDataViewController *baseViewController = nil;
        baseViewController = [_sonControllerDic objectForKey:[NSString stringWithFormat:@"%d",_category]];
        [baseViewController doSearchBtn:searchStr withSearchBtn:searchView];
    }
}

-(void)dealloc {
    [super dealloc];
    if (_sonControllerDic) {
        [_sonControllerDic release];
        _sonControllerDic = nil;
    }
}

@end
