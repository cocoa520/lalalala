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
    [_topLineView setBackgroundColor:COLOR_TEXT_LINE];
    _gridView.itemSize = NSMakeSize(154, 154);
    _gridView.backgroundColor = [NSColor whiteColor];
    _gridView.scrollElasticity = NO;
    _gridView.allowsDragAndDrop = YES;
    _gridView.allowsMultipleSelection = YES;
    _gridView.allowsMultipleSelectionWithDrag = YES;
    _gridView.allowClickMultipleSelection = YES;
    [_gridView setIsFileManager:YES];
    [_gridView reloadData];
    [_rootBox setContentView:_mainView];
    
    [_backButton setMouseEnteredImage:[StringHelper imageNamed:@"backup_retreat_enter"]  mouseExitImage:[StringHelper imageNamed:@"backup_retreat"] mouseDownImage:[StringHelper imageNamed:@"backup_retreat2"]  forBidImage:[StringHelper imageNamed:@"backup_retreat3"]];
    [_backButton setIsDrawBorder:NO];
    [_backButton setTarget:self];
    [_backButton setAction:@selector(backAction:)];
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
    cameraRollModel.image = [NSImage imageNamed:@"folder_icon_img"];
    cameraRollModel.nodesEnum = Category_CameraRoll;
    
    IMBDevicePageFolderModel *photoStreamModel = [[IMBDevicePageFolderModel alloc]init];
    photoStreamModel.name = CustomLocalizedString(@"MenuItem_id_11", nil);
    photoStreamModel.image = [NSImage imageNamed:@"folder_icon_img"];
    photoStreamModel.nodesEnum = Category_PhotoStream;
    
    IMBDevicePageFolderModel *photoLibraryModel = [[IMBDevicePageFolderModel alloc]init];
    photoLibraryModel.name = CustomLocalizedString(@"MenuItem_id_12", nil);
    photoLibraryModel.image = [NSImage imageNamed:@"folder_icon_img"];
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
        _isSearch = YES;
        [_researchdataSourceArray addObjectsFromArray:fielEntity.subPhotoArray];
        [_gridView reloadData];
        return;
    }else {
        _baseViewController = [[IMBDeviceAllDataViewController alloc] initWithCategoryNodesEnum:_category withiPod:_iPod WithDelegete:self];
    }
    [_baseViewController loadToolBarView:_category WithDisplayMode:YES];
    [_rootBox setContentView:nil];
    [_contenBox setContentView:_baseViewController.view];
}

#pragma - mark back Actions
- (void)backAction:(id)sender {
    _isSearch = NO;
    [_researchdataSourceArray removeAllObjects];
    [_gridView reloadData];
    [_rootBox setContentView:_mainView];
    [_contenBox setContentView:nil];
}

- (void)closeWindow:(id)sender {
    [_delegate closeWindow:sender];
}

#pragma mark - 搜索
- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchView {
    _searhView = searchView;
    if (_category != Category_Photos) {
        [_baseViewController doSearchBtn:searchStr withSearchBtn:searchView];
    }
}

-(void)dealloc {
    if (_baseViewController != nil) {
        [_baseViewController release];
        _baseViewController = nil;
    }
    [super dealloc];
}

@end
