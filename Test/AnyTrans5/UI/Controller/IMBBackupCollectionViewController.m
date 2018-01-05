//
//  IMBBackupCollectionViewController.m
//  AnyTrans
//
//  Created by smz on 17/10/16.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBBackupCollectionViewController.h"
#import "IMBPhotoManager.h"
#import "IMBPhotoEntity.h"
#import "IMBTracksCollectionViewController.h"
#import "IMBPhotosPreviewWindowController.h"
#import "IMBFileSystem.h"
#import "IMBNotificationDefine.h"
#import "IMBGetThumbnailData.h"
@interface IMBBackupCollectionViewController ()

@end

@implementation IMBBackupCollectionViewController
@synthesize defaultImage = _defaultImage;
@synthesize dataArr = _dataArr;
@synthesize curEntity = _curEntity;
@synthesize toolTip = _toolTip;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (id)initWithNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate WithProductVersion:(SimpleNode *)node WithIMBBackupDecryptAbove4:(IMBBackupDecryptAbove4 *)abve4{
    if ([super initWithNodesEnum:category withDelegate:delegate WithProductVersion:node WithIMBBackupDecryptAbove4:abve4]) {
        _isbackup = YES;
        currentIndex = 0;
        _dataArr = [[NSMutableArray alloc] init];
        _dataSourceArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        [self configNoDataView];
    });
}

- (void)changeSkin:(NSNotification *)notification {
    [self configNoDataView];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    if (_category == Category_CameraRoll) {
        for (IMBPhotoEntity *entity in _dataSourceArray) {
            if (entity.cloudLocalState == 6) {
                entity.iCloudImage = [StringHelper imageNamed:@"iCloud_collection"];
            }else {
                entity.iCloudImage = nil;
            }
        }
    }
    [_photoSelectedView setImage:[StringHelper imageNamed:@"photo_selected"]];
    if (_defaultImage != nil) {
        [_defaultImage release];
        _defaultImage = nil;
    }
    _defaultImage = [[StringHelper imageNamed:@"photo_show"] retain];
    [_loadingAnimationView setNeedsDisplay:YES];
    NSIndexSet *set = [_collectionView selectionIndexes];
    [_arrayController removeObjects:_dataSourceArray];
    [_arrayController addObjects:_dataSourceArray];
    [_arrayController setSelectionIndexes:set];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_photoSelectedView setImage:[StringHelper imageNamed:@"photo_selected"]];
    [_downLoadMenuItem setHidden:YES];
    [_upLoadMenuItem setHidden:YES];
    
    
    if (_category == Category_PhotoVideo || _category == Category_TimeLapse || _category == Category_SlowMove) {
        [_preViewMenuItem setHidden:YES];
    }else {
        [_preViewMenuItem setHidden:NO];
        
    }
    if (_category == Category_PhotoLibrary || _category == Category_MyAlbums) {
        [_addMenuItem setHidden:NO];
    }else {
        [_addMenuItem setHidden:YES];
    }
    
        [_loadingAnimationView startAnimation];
        [_mainBox setContentView:_loadingView];
        [_refreshMenuItem setHidden:YES];
        [_toDeviceMenuItem setHidden:YES];
        [_deleteMenuItem setHidden:YES];
        [_toiCloudMenuItem setHidden:YES];
        [_toAlbumMenuItem setHidden:YES];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        IMBPhotoManager *phtotmanage = [[IMBPhotoManager alloc]initWithAMDevice:nil backupfilePath:_simpleNode.backupPath withDBType:_simpleNode.productVersion WithisEncrypted:_simpleNode.isEncrypt withBackUpDecrypt:_decryptAbove];
            NSMutableArray *albumInfo = [phtotmanage getAlbumsInfo];
            albumInfo = [phtotmanage queryAlbumPhotosCount:albumInfo];
            for (IMBPhotoEntity *entity in albumInfo) {
                if (_category == Category_CameraRoll) {
                    if (entity.albumType == CameraRoll){
                        if (entity.albumSubType == OtherType) {
                            _dataSourceArray = [[phtotmanage getPhotoInfoByAlbum:entity] retain];
                        }
                    }
                }else if (_category == Category_PhotoVideo){
                    
                    if (entity.albumType == VideoAlbum) {
                        if (entity.albumSubType == OtherType) {
                            _dataSourceArray = [[phtotmanage getPhotoInfoByAlbum:entity] retain];
                        }
                    }
                }else{
                    IMBGetThumbnailData *thumbData = [[IMBGetThumbnailData alloc]initWithAMDevice:nil backupfilePath:_simpleNode.backupPath withDBType:_simpleNode.productVersion WithisEncrypted:NO withBackUpDecrypt:nil];
                    [thumbData querySqliteDBContent];
                    _dataSourceArray = [thumbData.dataAry retain];
                }
            }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadingAnimationView endAnimation];
            NSString *promptStr = @"";
            if (_isbackup) {
                if (_category == Category_CameraRoll) {
                    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)];
                    [_textView setSelectable:NO];
                }
                else if (_category == Category_PhotoVideo) {
                    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_24", nil)];
                    [_textView setSelectable:NO];
                }else if (_category == Category_Thumil) {
                    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"Thumbnails_id", nil)];
                    [_textView setSelectable:NO];
                }else if (_category == Category_iCloudDriver){
                    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"icloud_drive", nil)];
                    [_textView setSelectable:NO];
                }else if (_category == Category_Photo) {
                    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)];
                    [_textView setSelectable:NO];
                }
            }
            
            nc = [NSNotificationCenter defaultCenter];
            if (_dataSourceArray.count == 0) {
                    [_mainBox setContentView:_noDataView];
            }else {
                    [_mainBox setContentView:_detailView];
            }
            [self configNoDataView];
            _defaultImage = [[StringHelper imageNamed:@"photo_show"] retain];
            [nc addObserver:self selector:@selector(openPhotoPreview:) name:NOTIFY_OPEN_PHOTO_PREVIEW object:nil];
            [_scrollView setHastopBorder:NO leftBorder:NO BottomBorder:NO rightBorder:NO];
            [_scrollView setListener:_collectionView];
            [_collectionView setListener:self];
            currentRow = 0;
            queue = [[NSOperationQueue alloc] init];
            [queue setMaxConcurrentOperationCount:8];
            [self loadCollectionView:NO];
            
        });
    });
}

- (void)loadCollectionView:(BOOL)isFrist {
    [self loadItem];
    [_collectionView setTotalCount:(int)_dataArr.count];
    [_collectionView setRefresh:YES];
    [_collectionView showVisibleRextPhoto];
    
}

//加载没有加载的item
//如果_itemArray count 大于120 每次加载120 一直到加载完成为止
- (void)loadItem
{
    NSMutableArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }
    if (currentIndex < [displayArray count]) {
        if ([displayArray count] - currentIndex>=120&&currentIndex<[displayArray count]) {
            NSRange range;
            range.location = currentIndex;
            range.length = 120;
            NSMutableIndexSet *set =  [[NSMutableIndexSet alloc]initWithIndexesInRange:NSMakeRange(0, [_collectionView content].count)];
            [set addIndexesInRange:range];
            currentIndex = currentIndex+120;
            _arrayController.selectsInsertedObjects = NO;
            [_arrayController  addObjects:[displayArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]]];
            
            [set release];
        }else
        {
            NSRange range;
            range.location = currentIndex;
            range.length = [displayArray count] - currentIndex;
            NSMutableIndexSet *set =  [[NSMutableIndexSet alloc]initWithIndexesInRange:NSMakeRange(0, [_collectionView content].count)];
            [set addIndexesInRange:range];
            currentIndex = currentIndex + (int)range.length;
            _arrayController.selectsInsertedObjects = NO;
            NSArray *disArr = [displayArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
            [_arrayController addObjects:disArr];
            [set release];
        }
    }
}

#pragma mark - NSTextView
- (void)configNoDataView {
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_photo"]];
    [_textView setDelegate:self];
    NSString *promptStr = @"";
    NSString *overStr  = CustomLocalizedString(@"NO_DATA_TITLE_2", nil);
    if (_category == Category_CameraRoll) {
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)];
        [_textView setSelectable:NO];
    }else if (_category == Category_PhotoStream) {
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)];
        [_textView setSelectable:NO];
    }else if (_category == Category_PhotoLibrary) {
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)] stringByAppendingString:overStr];
        [_textView setSelectable:YES];
    }else if (_category == Category_PhotoVideo) {
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_24", nil)];
        [_textView setSelectable:NO];
    }else if (_category == Category_Panoramas) {
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)];
        [_textView setSelectable:NO];
    }else if (_category == Category_TimeLapse) {
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_29", nil)];
        [_textView setSelectable:NO];
    }else if (_category == Category_SlowMove) {
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_29", nil)];
        [_textView setSelectable:NO];
    }else if (_category == Category_MyAlbums || _category == Category_PhotoShare || _category == Category_ContinuousShooting) {
        if (_curEntity.albumType == SyncAlbum) {
            promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)] stringByAppendingString:overStr];
            [_textView setSelectable:YES];
        }else {
            promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)];
            [_textView setSelectable:NO];
        }
    }else{
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"DeviceView_id_6", nil)];
        [_textView setSelectable:NO];
    }
    
    
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_textView setLinkTextAttributes:linkAttributes];
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = [promptStr rangeOfString:overStr];
    [promptAs addAttribute:NSLinkAttributeName value:overStr range:infoRange];
    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_textView textStorage] setAttributedString:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;
}

#pragma mark -- IMBImageRefreshCollectionListener
-(void)loadingCollectionThumbnilImage:(NSRange)oldVisibleRows withNewVisibleRows:(NSRange)newVisibleRows {
    int contentOffset = _scrollView.documentVisibleRect.origin.y;
    NSView *doView = (NSView *)_scrollView.documentView;
    if (contentOffset != 0 && contentOffset > doView.frame.size.height - _scrollView.contentView.frame.size.height - 2) {
        [self loadItem];
        [_collectionView setTotalCount:(int)_dataArr.count];
    }
    if (_dataArr.count <= 0) {
        return;
    }
    [queue cancelAllOperations];
    NSMutableArray *_visibleItems = (NSMutableArray *)[[_dataArr subarrayWithRange:newVisibleRows] retain];
    
    NSRange range;
    if (newVisibleRows.location > 10) {
        range = NSMakeRange(0, newVisibleRows.location - 1);
        NSArray *array = [_dataArr subarrayWithRange:range];
        if (array != nil) {
            for (IMBPhotoEntity *entity in array) {
                @autoreleasepool {
                    if (entity.loadingImage == 0) {
                        
                        entity.photoImage = [StringHelper imageNamed:@"photo_show"];
                        
                    }
                }
            }
        }
    }
    if (newVisibleRows.location + newVisibleRows.length + 10 < _dataArr.count && _dataSourceArray.count > 10) {
        range = NSMakeRange(newVisibleRows.location + newVisibleRows.length + 8, _dataArr.count - 9 - (newVisibleRows.location + newVisibleRows.length));
        NSArray *array = [_dataArr subarrayWithRange:range];
        if (array != nil) {
            for (IMBPhotoEntity *entity in array) {
                @autoreleasepool {
                    if (entity.loadingImage == 0) {
                        entity.photoImage = [StringHelper imageNamed:@"photo_show"];
                    }
                }
            }
        }
    }
    
    if (_visibleItems != nil && _visibleItems.count > 0) {
        for (id entity in _visibleItems) {
            [self loadImage:entity];
        }
    }
    [_visibleItems release];
}

- (void)loadImage:(id)phEntity {
    @synchronized (phEntity) {
        [queue addOperationWithBlock:^(void) {
            @autoreleasepool {
                IMBPhotoEntity *entity = nil;
                if (phEntity && [phEntity isKindOfClass:[IMBPhotoEntity class]]) {
                    entity = (IMBPhotoEntity *)phEntity;
                }
                if (entity.loadingImage == 0) {
                    entity.loadingImage = 1;
                    NSImage *photoImage = nil;
                    NSData *data = nil;
                    
                    if ([entity.albumTitle isEqualToString:@"Photo Video"]) {
                        NSImage *thumimage = [[NSImage alloc] initWithContentsOfFile:entity.thumbPath];
                        NSData *imageda = [TempHelper scalingImage:thumimage withLenght:150];
                        photoImage = [[NSImage alloc] initWithData:imageda];
                        [thumimage release];
                    }else{
                        NSImage *thumimage = [[NSImage alloc] initWithContentsOfFile:entity.thumbImagePath];
                        NSData *imageda = [TempHelper scalingImage:thumimage withLenght:150];
                        photoImage = [[NSImage alloc] initWithData:imageda];
                        [thumimage release];
                    }

                        NSImage *image = nil;
                    
                        if (photoImage != nil) {
                                image = [photoImage retain];
                        }

                        if (image) {
                            entity.loadingImage = 2;
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                entity.photoImage = image;
                            });
                        }else {
                            entity.loadingImage = 0;
                        }
                        [image release];
                        image = nil;
                        [photoImage release];
                        photoImage = nil;
                        //此线程写图片到本地
                        dispatch_async(dispatch_queue_create("com.ConcurrentQueue", NULL), ^{
                            @autoreleasepool {
                                if (entity.catchName == nil) {
                                    NSTimeInterval dateTime = [[NSDate date] timeIntervalSince1970];
                                    NSString *name = [[NSString stringWithFormat:@"%@_%f.jpg",[entity.photoName stringByDeletingPathExtension],dateTime] retain];
                                    entity.catchName = name;
                                    [name release];
                                }
                                
                                NSString *imageCatchBasePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"imageCatch"];
                                NSFileManager *fm = [NSFileManager defaultManager];
                                if (![fm fileExistsAtPath:imageCatchBasePath]) {
                                    [fm createDirectoryAtPath:imageCatchBasePath withIntermediateDirectories:NO attributes:nil error:nil];
                                }
                                NSString *imagefilepath = [imageCatchBasePath stringByAppendingPathComponent:entity.catchName];
                                if ([fm fileExistsAtPath:imagefilepath]) {
                                    imagefilepath = [TempHelper getFilePathAlias:imagefilepath];
                                    entity.catchName = [imagefilepath lastPathComponent];
                                }
                                [fm createFileAtPath:imagefilepath contents:data attributes:nil];
                            }
                        });
                    
                    [data release];
                    data = nil;
                }else if (entity.loadingImage == 2) {
                    NSString *imageCatchBasePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"imageCatch"];
                    NSString *imagefilepath = [imageCatchBasePath stringByAppendingPathComponent:entity.catchName];
                    NSFileManager *fm = [NSFileManager defaultManager];
                    if ([fm fileExistsAtPath:imagefilepath]) {
                        NSImage *image = nil;
                        NSData *imageData= nil;
                        if (_isbackup) {
                            NSImage *thumimage = [[NSImage alloc] initWithContentsOfFile:entity.thumbImagePath];
                            NSData *imageda = [TempHelper scalingImage:thumimage withLenght:150];
                            image = [[NSImage alloc] initWithData:imageda];
                            [thumimage release];
                        }
                        
                        if (image) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                entity.photoImage = image;
                            });
                        }
                        [image release];
                        [imageData release];
                    }else {
                        entity.loadingImage = 0;
                        entity.photoImage = [StringHelper imageNamed:@"photo_show"];
                        
                    }
                }
                
            }
        }];
    }
}

#pragma mark OperationActions
- (void)openPhotoPreview:(NSNotification *)notification {
    NSDictionary *userinfo = [notification userInfo];
    if (userinfo != nil) {
        if (_dataSourceArray.count == 0) {
            return;
        }
        //userDic
        IMBPhotoEntity *stEntity = [_dataSourceArray objectAtIndex:0];
        IMBPhotoEntity *entity = [userinfo objectForKey:@"ENTITY"];
        if (entity.albumZpk == stEntity.albumZpk && entity.photoKind != 1) {
            NSMutableArray *preArray = [[NSMutableArray alloc]init];
            if (_dataSourceArray != nil) {
                for (IMBPhotoEntity *pe in _dataSourceArray) {
                    if (pe.photoKind != 1) {
                        [preArray addObject:pe];
                    }
                }
            }
            IMBPhotosPreviewWindowController *photoController = [[IMBPhotosPreviewWindowController alloc] initWithArray:preArray withIpod:_ipod WithPhotoEntity:entity ];
            [NSApp runModalForWindow:[photoController window]];
            [photoController release];
            [preArray release];
        }
    }
}

- (void)changePhotosCollectionLanguage:(NSNotification *)notification {

}

#pragma mark - search
- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _searchFieldBtn = searchBtn;
    _isSearch = YES;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"photoName CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
    }
    
    if (_dataSourceArray != nil ) {
        [_arrayController removeObjects:_dataArr];
    }
    
    currentIndex = 0;
    [self loadItem];
    [_collectionView setTotalCount:(int)_dataArr.count];
    [_collectionView setRefresh:YES];
    [_collectionView showVisibleRextPhoto];
}

- (IBAction)doPreViewMenu:(id)sender {
    NSIndexSet *set = [_collectionView selectionIndexes];
    if (set.count < 1) {
        return;
    }
    NSInteger index = [set firstIndex];
    IMBPhotoEntity *entity = [_dataSourceArray objectAtIndex:index];
    
    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:entity, @"ENTITY", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_OPEN_PHOTO_PREVIEW object:nil userInfo:userDic];
}

- (void)setToolBar:(IMBToolBarView *)toolBar{
    _toolBar = toolBar;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_OPEN_PHOTO_PREVIEW object:nil];
    [_defaultImage release],_defaultImage = nil;
    [queue release], queue = nil;
    [_dataArr release],_dataArr = nil;
    [super dealloc];
}

@end

@implementation IMBBackupCollectionViewItem

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    IMBBlankDraggableCollectionView *blankCollectionView = (IMBBlankDraggableCollectionView *)[self.view superview];
    NSArray *itemArray = [blankCollectionView subviews];
    NSArray *allArray = [blankCollectionView content];
    NSUInteger index = [itemArray indexOfObject:self.view];
    if (allArray.count > index) {
        IMBPhotoEntity *photoEntity = [allArray objectAtIndex:index];
        photoEntity.checkState = selected;
        photoEntity.isHiddenSelectImage = !selected;
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end

@implementation IMBBackupPhotoImageView
@synthesize isSelected = _isSected;
@synthesize loadImage = _loadImage;
@synthesize isload = _isload;
@synthesize isfree = _isfree;
@synthesize exist = _exist;
- (void)awakeFromNib
{
    
}

- (void)dealloc
{
    if (_loadImage != nil) {
        [_loadImage release];
        _loadImage = nil;
    }
    [super dealloc];
}
@end

