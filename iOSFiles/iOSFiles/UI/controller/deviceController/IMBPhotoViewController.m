//
//  IMBPhotoViewController.m
//  iOSFiles
//
//  Created by 龙凡 on 2018/3/16.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBPhotoViewController.h"
#import "IMBTrack.h"
#import "IMBBookEntity.h"
#import "IMBAppEntity.h"
#import "IMBAnimation.h"
@interface IMBPhotoViewController ()

@end

@implementation IMBPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (id)initWithCategoryNodesEnum:(CategoryNodesEnum )nodeEnum withiPod:(IMBiPod *)iPod{
    if ([super initWithNibName:@"IMBPhotoViewController" bundle:nil]) {
        _categoryNodeEunm = nodeEnum;
        _iPod = iPod;
        
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _gridView.itemSize = NSMakeSize(154, 150);
    _gridView.backgroundColor = [NSColor whiteColor];
    _gridView.scrollElasticity = NO;
    _gridView.allowsDragAndDrop = YES;
    _gridView.allowsMultipleSelection = YES;
    _gridView.allowsMultipleSelectionWithDrag = YES;
    _gridView.allowClickMultipleSelection = YES;
    [_gridView setIsFileManager:YES];
    [self loadDataAry];
    [_gridView reloadData];

}

- (void)loadDataAry {
    _dataSourceArray = [[NSMutableArray alloc]init];
    IMBInformationManager *inforManager = [IMBInformationManager shareInstance];
    _information = [inforManager.informationDic objectForKey:_iPod.uniqueKey];
    if (_categoryNodeEunm == Category_Photos) {
        _dataSourceArray = _information.allPhotoArray;
    }else if (_categoryNodeEunm == Category_Media) {
        _dataSourceArray = _information.mediaArray;
    }else if (_categoryNodeEunm == Category_Video) {
        _dataSourceArray = _information.videoArray;
    }else if (_categoryNodeEunm == Category_iBooks) {
        _dataSourceArray = _information.allBooksArray;
    }else if (_categoryNodeEunm == Category_Applications) {
        _dataSourceArray = _information.appArray;
    }else if (_categoryNodeEunm == Category_System) {
//        _dataSourceArray = _information.;
    }else if (_categoryNodeEunm == Category_PhotoStream) {
         _dataSourceArray = _information.photostreamArray;
    }else if (_categoryNodeEunm == Category_PhotoLibrary) {
         _dataSourceArray = _information.photolibraryArray;
    }else if (_categoryNodeEunm == Category_CameraRoll) {
         _dataSourceArray = _information.allPhotoArray;
    }
    [self.view addSubview:_contentView];
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
    
    if (_categoryNodeEunm == Category_Media||_categoryNodeEunm == Category_Video) {
        IMBTrack *track = [array objectAtIndex:index];
        item.bgImg = [NSImage imageNamed:@"app_default"];
        item.itemTitle = track.title;
        //    [item setNeedsDisplay:YES];
        item.selected = track.checkState;
        
        NSData *data = [[self createThumbImage:track] retain];
        NSImage *image = [[NSImage alloc] initWithData:data];
        item.itemImage = image;
        item.isFileManager = YES;
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
        item.bgImg = [NSImage imageNamed:@"app_default"];
        item.itemTitle = bookEntity.bookName;
        //    [item setNeedsDisplay:YES];
        item.selected = bookEntity.checkState;
        item.itemImage = bookEntity.coverImage;
        item.isFileManager = YES;
        if (bookEntity.checkState == Check) {
            if (![gridView.selectedItems containsObject:item]) {
                [[gridView getSelectedItemsDic] setObject:item forKey:@(item.index)];
            }
        }else{
            if ([gridView.selectedItems containsObject:item]) {
                [[gridView getSelectedItemsDic] removeObjectForKey:@(item.index)];
            }
        }
    }else if (_categoryNodeEunm == Category_Applications) {
        IMBAppEntity *appEntit = [array objectAtIndex:index];
        item.bgImg = [NSImage imageNamed:@"app_default"];
        item.itemTitle = appEntit.appName;
        //    [item setNeedsDisplay:YES];
        item.selected = appEntit.checkState;
        item.itemImage = appEntit.appIconImage;
        item.isFileManager = YES;
        if (appEntit.checkState == Check) {
            if (![gridView.selectedItems containsObject:item]) {
                [[gridView getSelectedItemsDic] setObject:item forKey:@(item.index)];
            }
        }else{
            if ([gridView.selectedItems containsObject:item]) {
                [[gridView getSelectedItemsDic] removeObjectForKey:@(item.index)];
            }
        }
    }else if (_categoryNodeEunm == Category_System) {
        //        _dataSourceArray = _information.;
    }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
        IMBPhotoEntity *photoEntity = [array objectAtIndex:index];
        item.bgImg = [NSImage imageNamed:@"app_default"];
        item.itemTitle = photoEntity.photoName;
        //    [item setNeedsDisplay:YES];
        item.selected = photoEntity.checkState;
        NSData *imageData = [self createImageToTableView:photoEntity];
        NSImage *photoImage = [[NSImage alloc]initWithData:imageData];
        item.itemImage = photoImage;
        [photoImage release];
        photoImage = nil;
        item.isFileManager = YES;
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
- (void)gridView:(CNGridView *)gridView didSelectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section{
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    if (index < array.count) {
        
        if (_categoryNodeEunm == Category_Media) {
        }else if (_categoryNodeEunm == Category_Video) {
        }else if (_categoryNodeEunm == Category_iBooks) {
        }else if (_categoryNodeEunm == Category_Applications) {
        }else if (_categoryNodeEunm == Category_System) {
        }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
            IMBPhotoEntity *photoEnity = [array objectAtIndex:index];
            photoEnity.checkState = Check;
            int count = 0;
            for (IMBPhotoEntity *entity in array) {
                if (entity.checkState == Check) {
                    count ++ ;
                }
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
        if (_categoryNodeEunm == Category_Media) {
        }else if (_categoryNodeEunm == Category_Video) {
        }else if (_categoryNodeEunm == Category_iBooks) {
        }else if (_categoryNodeEunm == Category_Applications) {
        }else if (_categoryNodeEunm == Category_System) {
        }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
            IMBPhotoEntity *photoEnity = [array objectAtIndex:index];
            photoEnity.checkState = UnChecked;
      
        }
    }
}

- (void)gridViewDidDeselectAllItems:(CNGridView *)gridView {
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    if (_categoryNodeEunm == Category_Media) {
    }else if (_categoryNodeEunm == Category_Video) {
    }else if (_categoryNodeEunm == Category_iBooks) {
    }else if (_categoryNodeEunm == Category_Applications) {
    }else if (_categoryNodeEunm == Category_System) {
    }else if (_categoryNodeEunm == Category_CameraRoll||_categoryNodeEunm == Category_PhotoLibrary||_categoryNodeEunm == Category_PhotoStream) {
        for (IMBPhotoEntity *photoEnity in array) {
            photoEnity.checkState = UnChecked;
        }
    }
    //_resultEntity.selectedCount = 0;
    [_gridView reloadSelecdImage];
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
    NSString *extension = [filePath pathExtension].lowercaseString;
    BOOL isVideo = false;
    if ([extension isEqualToString:@"mov"] || [extension isEqualToString:@"m4v"] || [extension isEqualToString:@"mp4"]) {
        isVideo = true;
    }
    NSData *data = nil;
    if (!isVideo) {
        data = [[self readFileData:filePath] retain];
    }
    if (data) {
        NSImage *sourceImage = [[NSImage alloc] initWithData:data];
        NSMutableData *imageData = [(NSMutableData *)[TempHelper scalingImage:sourceImage withLenght:60] retain];
        [sourceImage release];
        [data release];
        
        return [imageData autorelease];
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
    
    NSMutableData *imageData = nil;
    if ([_iPod.deviceHandle.productVersion isVersionMajorEqual:@"7"]) {
        imageData = [(NSMutableData *)[TempHelper scalingImage:sourceImage withLenght:60] retain];
    }else {
        imageData = [(NSMutableData *)[TempHelper createThumbnail:sourceImage withWidth:60 withHeight:60] retain];
    }
    [sourceImage release];
    
    return [imageData autorelease];
}




@end
