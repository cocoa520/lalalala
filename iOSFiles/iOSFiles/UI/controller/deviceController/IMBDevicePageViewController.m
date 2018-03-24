//
//  IMBDevicePageViewController.m
//  iOSFiles
//
//  Created by JGehry on 3/14/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBDevicePageViewController.h"
#import "IMBDevicePageFolderModel.h"
//#import "IMBSystemCollectionViewController.h"
#import "IMBDrawOneImageBtn.h"
#import "IMBSegmentedBtn.h"
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
    [_gridView setWantsLayer:YES];
    [_gridView.layer setBackgroundColor:[NSColor whiteColor].CGColor];
    _gridView.itemSize = NSMakeSize(154, 150);
    _gridView.backgroundColor = [NSColor whiteColor];
    _gridView.scrollElasticity = NO;
    _gridView.allowsDragAndDrop = YES;
    _gridView.allowsMultipleSelection = YES;
    _gridView.allowsMultipleSelectionWithDrag = YES;
    _gridView.allowClickMultipleSelection = YES;
    [_gridView setIsFileManager:YES];
    [_gridView reloadData];
    [_rootBox setContentView:_mainView];
    
    [_toolBarButtonView loadButtons:[NSArray arrayWithObjects:@(0),@(17),@(1),@(2),@(4),@(5),@(12),nil] Target:self DisplayMode:YES];
    
    [_topView setIsBommt:YES];
    [_topView setIsUpline:YES];
    [_backButton setMouseEnteredImage:[StringHelper imageNamed:@"backup_retreat_enter"]  mouseExitImage:[StringHelper imageNamed:@"backup_retreat"] mouseDownImage:[StringHelper imageNamed:@"backup_retreat2"]  forBidImage:[StringHelper imageNamed:@"backup_retreat3"]];
    [_backButton setIsDrawBorder:NO];
    [_backButton setTarget:self];
    [_backButton setAction:@selector(backAction:)];
}

- (void)loadData {
    _dataSourceArray = [[NSMutableArray alloc]init];
    OSType code = UTGetOSTypeFromString((CFStringRef)@"fldr");
    NSImage *picture = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(code)];

    _information = [[IMBInformation alloc] initWithiPod:_iPod];
    IMBDevicePageFolderModel *devicePagePhoto = [[IMBDevicePageFolderModel alloc]init];
    devicePagePhoto.name = CustomLocalizedString(@"Device_MainPage_View_photo", nil);
    devicePagePhoto.image = picture;
    devicePagePhoto.nodesEnum = Category_Photos;
    
    IMBDevicePageFolderModel *devicePageBook = [[IMBDevicePageFolderModel alloc]init];
    devicePageBook.name = CustomLocalizedString(@"Device_MainPage_View_Book", nil);
    devicePageBook.image = picture;
    devicePageBook.nodesEnum = Category_iBooks;
    
    IMBDevicePageFolderModel *devicePageMedia = [[IMBDevicePageFolderModel alloc]init];
    devicePageMedia.name = CustomLocalizedString(@"Device_MainPage_View_Media", nil);
    devicePageMedia.image = picture;
    devicePageMedia.nodesEnum = Category_Media;
    
    IMBDevicePageFolderModel *devicePageVideo = [[IMBDevicePageFolderModel alloc]init];
    devicePageVideo.name = CustomLocalizedString(@"Device_MainPage_View_Video", nil);
    devicePageVideo.image = picture;
    devicePageVideo.nodesEnum = Category_Video;
    
    IMBDevicePageFolderModel *devicePageOther  = [[IMBDevicePageFolderModel alloc]init];
    devicePageOther.name = CustomLocalizedString(@"Device_MainPage_View_System", nil);
    devicePageOther.image = picture;
    devicePageOther.nodesEnum = Category_System;
    
    IMBDevicePageFolderModel *devicePageApp = [[IMBDevicePageFolderModel alloc]init];
    devicePageApp.name = CustomLocalizedString(@"Device_MainPage_View_App", nil);
    devicePageApp.image = picture;
    devicePageApp.nodesEnum = Category_Applications;
    
    
    
    IMBDevicePageFolderModel *cameraRollModel = [[IMBDevicePageFolderModel alloc]init];
    cameraRollModel.name = CustomLocalizedString(@"Device_MainPage_View_CameraRoll", nil);
    cameraRollModel.image = picture;
    cameraRollModel.nodesEnum = Category_CameraRoll;
    
    IMBDevicePageFolderModel *photoStreamModel = [[IMBDevicePageFolderModel alloc]init];
    photoStreamModel.name = CustomLocalizedString(@"Device_MainPage_View_PhotoStream", nil);
    photoStreamModel.image = picture;
    photoStreamModel.nodesEnum = Category_PhotoStream;
    
    
    IMBDevicePageFolderModel *photoLibraryModel = [[IMBDevicePageFolderModel alloc]init];
    photoLibraryModel.name = CustomLocalizedString(@"Device_MainPage_View_PhotoLibrary", nil);
    photoLibraryModel.image = picture;
    photoLibraryModel.nodesEnum = Category_PhotoLibrary;
    
    [devicePagePhoto.subPhotoArray addObject:cameraRollModel];
    [devicePagePhoto.subPhotoArray addObject:photoStreamModel];
    [devicePagePhoto.subPhotoArray addObject:photoLibraryModel];
    [_dataSourceArray addObject:devicePagePhoto];
    [_dataSourceArray addObject:devicePageBook];
    [_dataSourceArray addObject:devicePageMedia];
    [_dataSourceArray addObject:devicePageVideo];
    [_dataSourceArray addObject:devicePageOther];
    [_dataSourceArray addObject:devicePageApp];

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
//    [item setNeedsDisplay:YES];
    item.selected = fileEntity.checkState;
    item.itemImage = fileEntity.image;
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
- (void)gridView:(CNGridView *)gridView didSelectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section{
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    if (index < array.count) {
        IMBDevicePageFolderModel *fielEntity = [array objectAtIndex:index];
        fielEntity.checkState = Check;
        int count = 0;
        for (IMBDevicePageFolderModel *entity in array) {
            if (entity.checkState == Check) {
                count ++ ;
            }
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
    //_resultEntity.selectedCount = 0;
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
    if (fielEntity.nodesEnum == Category_Photos) {
        _isSearch = YES;
        [_researchdataSourceArray addObjectsFromArray:fielEntity.subPhotoArray];
        [_gridView reloadData];
        return;
    }else if (fielEntity.nodesEnum == Category_Media) {
        _baseViewController = [[IMBPhotoViewController alloc]initWithCategoryNodesEnum:fielEntity.nodesEnum withiPod:_iPod];
    }else if (fielEntity.nodesEnum == Category_Video) {
        _baseViewController = [[IMBPhotoViewController alloc]initWithCategoryNodesEnum:fielEntity.nodesEnum withiPod:_iPod];
    }else if (fielEntity.nodesEnum == Category_iBooks) {
        _baseViewController = [[IMBPhotoViewController alloc]initWithCategoryNodesEnum:fielEntity.nodesEnum withiPod:_iPod];
    }else if (fielEntity.nodesEnum == Category_Applications) {
        _baseViewController = [[IMBPhotoViewController alloc]initWithCategoryNodesEnum:fielEntity.nodesEnum withiPod:_iPod];
    }else if (fielEntity.nodesEnum == Category_System) {
//        _baseViewController = [[IMBSystemCollectionViewController alloc] initWithIpod:_iPod withCategoryNodesEnum:0 withDelegate:self];
    }else if (fielEntity.nodesEnum == Category_PhotoStream||fielEntity.nodesEnum == Category_PhotoLibrary||fielEntity.nodesEnum == Category_CameraRoll) {
        _baseViewController = [[IMBPhotoViewController alloc]initWithCategoryNodesEnum:fielEntity.nodesEnum withiPod:_iPod];
    }
    [_rootBox setContentView:_baseViewController.view];
}

- (void)loadToolBarView:(CategoryNodesEnum) nodesEnum{
    if (nodesEnum == Category_Media) {
        [_toolBarButtonView loadButtons:[NSArray arrayWithObjects:@(0),@(17),@(1),@(2),@(4),@(5),@(12),nil] Target:_baseViewController DisplayMode:YES];
    }else if (nodesEnum == Category_Video) {
         [_toolBarButtonView loadButtons:[NSArray arrayWithObjects:@(0),@(17),@(1),@(2),@(4),@(5),@(12),nil] Target:_baseViewController DisplayMode:YES];
    }else if (nodesEnum == Category_iBooks) {
         [_toolBarButtonView loadButtons:[NSArray arrayWithObjects:@(0),@(17),@(1),@(2),@(4),@(5),@(12),nil] Target:_baseViewController DisplayMode:YES];
    }else if (nodesEnum == Category_Applications) {
         [_toolBarButtonView loadButtons:[NSArray arrayWithObjects:@(0),@(17),@(1),@(2),@(4),@(5),@(12),nil] Target:_baseViewController DisplayMode:YES];
    }else if (nodesEnum == Category_System) {
//        _baseViewController = [[IMBSystemCollectionViewController alloc] initWithIpod:_iPod withCategoryNodesEnum:0 withDelegate:self];
    }else if (nodesEnum == Category_PhotoStream||nodesEnum == Category_PhotoLibrary||nodesEnum == Category_CameraRoll) {
         [_toolBarButtonView loadButtons:[NSArray arrayWithObjects:@(0),@(17),@(1),@(2),@(4),@(5),@(12),nil] Target:_baseViewController DisplayMode:YES];
    }
}

#pragma -- mark  Actions
- (void)toMac:(IMBInformation *)information{

}

- (void)addItems:(id)sender  {

}

- (void)doSwitchView:(id)sender {
     IMBSegmentedBtn *segBtn = (IMBSegmentedBtn *)sender;
    if (segBtn.selectedSegment == 0) {
        if (_category == Category_Media) {
        }else if (_category == Category_Video) {
        }else if (_category == Category_iBooks) {
        }else if (_category == Category_Applications) {
            
        }else if (_category == Category_System) {
            
        }else if (_category == Category_PhotoStream||_category == Category_PhotoLibrary||_category == Category_CameraRoll) {
            
        }
    }else if (segBtn.selectedSegment == 1) {
        if (_category == Category_Media) {
            _baseViewController = [[IMBPhotosListViewController alloc] initWithiPod:_iPod category:_category];
        }else if (_category == Category_Video) {
            _baseViewController = [[IMBPhotosListViewController alloc] initWithiPod:_iPod category:_category];
        }else if (_category == Category_iBooks) {
            _baseViewController = [[IMBPhotosListViewController alloc] initWithiPod:_iPod category:_category];
        }else if (_category == Category_Applications) {
            _baseViewController = [[IMBPhotosListViewController alloc] initWithiPod:_iPod category:_category];
        }else if (_category == Category_System) {
            
        }else if (_category == Category_PhotoStream||_category == Category_PhotoLibrary||_category == Category_CameraRoll) {
            _baseViewController = [[IMBPhotosListViewController alloc] initWithiPod:_iPod category:_category];
        }
    }
    [_rootBox setContentView:_baseViewController.view];
}

- (void)backAction:(id)sender {
    _isSearch = NO;
    [_researchdataSourceArray removeAllObjects];
    [_gridView reloadData];
    [_rootBox setContentView:_mainView];
}

- (void)closeWindow:(id)sender {
    [_delegate closeWindow:sender];
}

-(void)dealloc {
    [super dealloc];
}

@end
