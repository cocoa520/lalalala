//
//  IMBPhotosCollectionViewController.m
//  iMobieTrans
//
//  Created by iMobie on 14-6-11.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBPhotosCollectionViewController.h"
#import "IMBPhotoManager.h"
#import "IMBPhotoEntity.h"
#import "IMBTracksCollectionViewController.h"
#import "IMBPhotosPreviewWindowController.h"
//#import "IMBDeleteCameraRollPhotos.h"
#import "IMBFileSystem.h"
#import "IMBNotificationDefine.h"
#import "IMBGetThumbnailData.h"
#import "IMBiCloudMainPageViewController.h"
#import "IMBiCloudPhotoVideoViewController.h"
@interface IMBPhotosCollectionViewController ()

@end

@implementation IMBPhotosCollectionViewController
@synthesize defaultImage = _defaultImage;
@synthesize dataArr = _dataArr;
@synthesize curEntity = _curEntity;
@synthesize toolTip = _toolTip;
@synthesize icloudPhotoDelegate = _icloudPhotoDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePhotosCollectionLanguage:) name:NOTIFY_PHOTOSCOLLECTION_CHANGE_LANGUAGE object:nil];
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    self = [super initWithIpod:ipod withCategoryNodesEnum:category withDelegate:delegate];
    if (self) {
        currentIndex = 0;
        _dataArr = [[NSMutableArray alloc] init];
        _isbackup = NO;
        if (_category == Category_CameraRoll) {
//              _dataSourceArray = [[_information camerarollArray] retain];
            NSMutableArray *array = [[_information camerarollArray] retain];
            for (IMBPhotoEntity *entity in array) {
                if (entity.cloudLocalState == 6) {
                    entity.iCloudImage = [StringHelper imageNamed:@"iCloud_collection"];
                }else {
                    entity.iCloudImage = nil;
                }
            }
            _dataSourceArray = [array retain];
            [array release],array = nil;
          
        }else if (_category == Category_PhotoStream) {
            _dataSourceArray = [[_information photostreamArray] retain];
        }else if (_category == Category_PhotoLibrary) {
            _dataSourceArray = [[_information photolibraryArray] retain];
        }else if (_category == Category_PhotoVideo) {
            _dataSourceArray = [[_information photovideoArray] retain];
        }else if (_category == Category_Panoramas) {
            _dataSourceArray = [[_information panoramasArray] retain];
        }else if (_category == Category_TimeLapse) {
            _dataSourceArray = [[_information timelapseArray] retain];
        }else if (_category == Category_SlowMove) {
            _dataSourceArray = [[_information slowMoveArray] retain];
        }else if (_category == Category_LivePhoto) {
            _dataSourceArray = [[_information livePhotoArray] retain];
        }else if (_category == Category_Screenshot) {
            _dataSourceArray = [[_information screenshotArray] retain];
        }else if (_category == Category_PhotoSelfies) {
            _dataSourceArray = [[_information photoSelfiesArray] retain];
        }else if (_category == Category_Location) {
            _dataSourceArray = [[_information locationArray] retain];
        }else if (_category == Category_Favorite) {
            _dataSourceArray = [[_information favoriteArray] retain];
        }
    }
    return self;
}

-(id)initiCloudWithiCloudBackUp:(IMBiCloudBackup *)icloudBackup WithDelegate:(id)delegate withCategoryNodesEnum:(CategoryNodesEnum)category{
    if ([super initWithNibName:@"IMBPhotosCollectionViewController" bundle:nil]) {
        _category = category;
        _delegate = delegate;
        _isbackup = NO;
        _iCloudBackup = icloudBackup;
        _isiCloud = YES;
        
        currentIndex = 0;
        _dataArr = [[NSMutableArray alloc] init];
        _dataSourceArray = [[NSMutableArray alloc]init];
        
        _isiCloudView = YES;
       }
    return self;
}


- (id)initWithNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate WithProductVersion:(SimpleNode *)node WithIMBBackupDecryptAbove4:(IMBBackupDecryptAbove4 *)abve4{
    if ([super initWithNodesEnum:category withDelegate:delegate WithProductVersion:node WithIMBBackupDecryptAbove4:abve4]) {
             
        _isbackup = YES;
        _isiCloud = NO;
        currentIndex = 0;
        _dataArr = [[NSMutableArray alloc] init];
        _dataSourceArray = [[NSMutableArray alloc]init];
//        IMBPhotoManager *photoManager = [[IMBPhotoManager alloc] initWithiPod:_ipod];
         }
    return self;
}


- (id)initWithiPod:(IMBiPod*)iPod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate withPhotoEntity:(IMBPhotoEntity *)entity {
    self = [super initWithIpod:iPod withCategoryNodesEnum:category withDelegate:delegate];
    if (self) {
        _isbackup = NO;
        _curEntity = entity;
        currentIndex = 0;
        _dataArr = [[NSMutableArray alloc] init];
        if (_category == Category_MyAlbums) {
            _dataSourceArray = [[_information.albumsDic objectForKey:[NSNumber numberWithInt:entity.albumZpk]] retain];
        } else if (_category == Category_PhotoShare) {
            _dataSourceArray = [[_information.shareAlbumDic objectForKey:[NSNumber numberWithInt:entity.albumZpk]] retain];
        }else if (_category == Category_ContinuousShooting)
        {
            _dataSourceArray = [[_information.continuousShootingDic objectForKey:[NSNumber numberWithInt:entity.albumZpk]] retain];
        }
    }
    return self;
}

- (id)initWithiCloudManager:(IMBiCloudManager *)iCloudManager withDelegate:(id)delegate withiCloudView:(BOOL)isiCloudView withCategory:(CategoryNodesEnum)Category {
    if (self = [super initWithiCloudManager:iCloudManager withDelegate:delegate withiCloudView:isiCloudView withCategory:Category]) {
        _dataArr = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (id)initWithiCloudManager:(IMBiCloudManager *)iCloudManager withDelegate:(id)delegate withiCloudView:(BOOL)isiCloudView withCategory:(CategoryNodesEnum)Category  withiCloudPhotoEntity:(IMBToiCloudPhotoEntity *)iCloudPhotoEntity{
    if (self = [super initWithiCloudManager:iCloudManager withDelegate:delegate withiCloudView:isiCloudView withCategory:Category withiCloudPhotoEntity:iCloudPhotoEntity]) {
        _dataArr = [[NSMutableArray alloc] init];
        _dataSourceArray = [[iCloudPhotoEntity subArray] retain];
        if (_isiCloudView) {
            if (_dataSourceArray.count > 0) {
                for (IMBPhotoEntity *photoEntity in _dataSourceArray) {
                    photoEntity.photoImage = [StringHelper imageNamed:@"photo_show"];
                    
                }
            }
        }
        _iCloudPhotoEntity = iCloudPhotoEntity;
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
//    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
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

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(icloudDriverError:) name:ICLOUD_DOWMLOAD_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(icloudGetUploadProgress:) name:ICLOUD_GetUpload_Progress object:nil];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
//    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_photoSelectedView setImage:[StringHelper imageNamed:@"photo_selected"]];
    [_downLoadMenuItem setHidden:YES];
    [_upLoadMenuItem setHidden:YES];

    if (_category == Category_CameraRoll || _category == Category_PhotoVideo||_category == Category_TimeLapse||_category==Category_Panoramas||_category == Category_SlowMove) {
        if ([_ipod.deviceInfo.getDeviceFloatVersionNumber isVersionMajorEqual:@"8.3"]) {
            [_deleteMenuItem setHidden:YES];
        }else {
            [_deleteMenuItem setHidden:NO];
        }
    }else {
        [_deleteMenuItem setHidden:YES];
    }
    
    if (_category == Category_PhotoVideo || _category == Category_TimeLapse || _category == Category_SlowMove) {
        [_preViewMenuItem setHidden:YES];
        [_toiCloudMenuItem setHidden:YES];
    }else {
        [_preViewMenuItem setHidden:NO];
        if (_category == Category_MyAlbums) {
            [_toiCloudMenuItem setHidden:YES];;
        }else {
            [_toiCloudMenuItem setHidden:NO];
        }
    }
    if (_category == Category_PhotoLibrary || _category == Category_MyAlbums) {
        [_addMenuItem setHidden:NO];
    }else {
        [_addMenuItem setHidden:YES];
    }


    if (_isiCloud ||_isbackup ) {
//        _isiCloudView = YES;
        [_loadingAnimationView startAnimation];
        [_mainBox setContentView:_loadingView];
        [_refreshMenuItem setHidden:YES];
        [_toDeviceMenuItem setHidden:YES];
        [_deleteMenuItem setHidden:YES];
        [_toiCloudMenuItem setHidden:YES];
        [_toAlbumMenuItem setHidden:YES];
    }
    
    
    if (_isiCloudView) {
        if (_category == Category_Photo) {
             [_toAlbumMenuItem setHidden:NO];
        }else{
             [_toAlbumMenuItem setHidden:YES];
        }
        [_deleteMenuItem setHidden:YES];
        [_preViewMenuItem setHidden:YES];
        [_toMacMenuItem setHidden:YES];
        [_toDeviceMenuItem setHidden:YES];
        [_addMenuItem setHidden:YES];
        [_toiCloudMenuItem setHidden:NO];
        [_downLoadMenuItem setHidden:NO];
        [_upLoadMenuItem setHidden:NO];
    }
//    [_toAlbumMenuItem setHidden:YES];
//    [_toiCloudMenuItem setHidden:YES];//屏蔽to icloud
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (_isiCloud) {
            IMBPhotoManager *phtotmanage = [[IMBPhotoManager alloc]initWithiCloudBackup:_iCloudBackup withType:_iCloudBackup.iOSVersion];
            NSMutableArray *albumInfo = [phtotmanage getAlbumsInfo];
            albumInfo = [phtotmanage queryAlbumPhotosCount:albumInfo];
            for (IMBPhotoEntity *entity in albumInfo) {
                if (_category == Category_CameraRoll) {
                    if (entity.albumType == CameraRoll){
                        if (entity.albumSubType == OtherType) {
                            NSMutableArray *array = [[[NSMutableArray alloc] initWithArray:[phtotmanage getPhotoInfoByAlbum:entity]] autorelease];
                            for(IMBPhotoEntity *entity in array) {
                                if (entity.isexisted) {
                                    entity.photoImage = [StringHelper imageNamed:@"photo_show"];
                                    [_dataSourceArray addObject:entity];
                                }
                            }
                        }
                    }
                }else if (_category == Category_PhotoVideo){
                    
                    if (entity.albumType == VideoAlbum) {
                        if (entity.albumSubType == OtherType) {
                            NSMutableArray *array = [[[NSMutableArray alloc] initWithArray:[phtotmanage getPhotoInfoByAlbum:entity]] autorelease];
                            for(IMBPhotoEntity *entity in array) {
                                if (entity.isexisted) {
                                    entity.photoImage = [StringHelper imageNamed:@"photo_show"];
                                    [_dataSourceArray addObject:entity];
                                }
                            }
                        }
                    }
                }
            }
            if (phtotmanage != nil) {
                [phtotmanage release];
                phtotmanage = nil;
            }
        }else if (_isbackup){
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
            if (phtotmanage != nil) {
                [phtotmanage release];
                phtotmanage = nil;
            }
        }
//        else if (_isiCloudView){
////            [_iCloudManager getPhotosContent];
//            _dataSourceArray = [[_iCloudManager photoArray] retain];
//        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadingAnimationView endAnimation];
            NSString *promptStr = @"";
            if (_isbackup || _isiCloud||_isiCloudView) {
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
            [_backUpNoDataTextView setStringValue:promptStr];
            
            nc = [NSNotificationCenter defaultCenter];
            
            if (_isbackup || _isiCloud||_isiCloudView) {
                if (_dataSourceArray.count == 0) {
                    [_mainBox setContentView:_noDataView];
                    //        [self configNoDataView];
                }else {
                    [_mainBox setContentView:_detailView];
                }
            }else{
                if (_dataSourceArray.count == 0) {
                    [_mainBox setContentView:_noDataView];
                    //        [self configNoDataView];
                }else {
                    [_mainBox setContentView:_detailView];
                }
            }
            
            [self configNoDataView];
//            _tqueue = ;
            //    [self loadItem];
            _defaultImage = [[StringHelper imageNamed:@"photo_show"] retain];
            [nc addObserver:self selector:@selector(openPhotoPreview:) name:NOTIFY_OPEN_PHOTO_PREVIEW object:nil];
            [_scrollView setHastopBorder:NO leftBorder:NO BottomBorder:NO rightBorder:NO];
            if (_category == Category_Panoramas) {
                //        [_collectionView setMaxNumberOfColumns:2];
                //        [_collectionView setColumn:2];
            }else
            {
                //        [_collectionView setMaxNumberOfColumns:6];
                //        [_collectionView setColumn:6];
            }
            [_scrollView setListener:_collectionView];
            [_collectionView setListener:self];
            if (_category == Category_Thumil||_category == Category_MyAlbums || _category == Category_PhotoShare||_category == Category_ContinuousShooting || (_category == Category_CameraRoll && _isbackup) || (_category == Category_PhotoVideo && _isbackup)) {
                //        [_collectionView setMaxNumberOfColumns:5];
                //        [_collectionView setColumn:5];
//                [self.view setFrame:NSMakeRect(0, 0, 800, 534)];
//                [_detailView setFrame:NSMakeRect(0, 0, 800, 534)];
//                [_scrollView setFrame:NSMakeRect(0, 0, 800, 534)];
//                [_collectionView setFrame:NSMakeRect(0, 0, 800, 534)];
//                [_noDataView setFrame:NSMakeRect(0, 0, 800, 534)];
//                [_noDataImageView setFrameOrigin:NSMakePoint((_noDataView.frame.size.width - _noDataImageView.frame.size.width)/2, _noDataImageView.frame.origin.y)];
//                [_noDataScrollView setFrameOrigin:NSMakePoint((_noDataView.frame.size.width - _noDataScrollView.frame.size.width)/2, _noDataScrollView.frame.origin.y)];
            }
            
            currentRow = 0;
            queue = [[NSOperationQueue alloc] init];
            if (_isiCloudView) {
                [queue setMaxConcurrentOperationCount:4];
            }else {
                [queue setMaxConcurrentOperationCount:8];
            }
            //    [[_scrollView contentView] setPostsBoundsChangedNotifications: YES];
            //    [nc addObserver: self selector: @selector(boundsDidChangeNotification:) name: NSViewBoundsDidChangeNotification object: [_scrollView contentView]];
            //    [self boundsDidChangeNotification:nil];
            //    [self reloadListWithSearchString:_seachField.stringValue];
            
            [self loadCollectionView:NO];
     
        });
    });
}

- (void)loadCollectionView:(BOOL)isFrist {
    [self loadItem];
    [_collectionView setTotalCount:(int)_dataArr.count];
//    if (!isFrist) {
        [_collectionView setRefresh:YES];
        [_collectionView showVisibleRextPhoto];
//    }
}

- (void)setTableViewHeadOrCollectionViewCheck {
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    if (_isiCloudView) {
        if (_category == Category_PhotoVideo||_category == Category_Photo||_category == Category_ContinuousShooting){
            _dataSourceArray = [[_iCloudPhotoEntity subArray] retain];
        }
    }else{
        if (_category == Category_CameraRoll) {
            //        _dataSourceArray=[[_information camerarollArray]retain];
            NSMutableArray *array = [[_information camerarollArray] retain];
            for (IMBPhotoEntity *entity in array) {
                if (entity.cloudLocalState == 6) {
                    entity.iCloudImage = [StringHelper imageNamed:@"iCloud_collection"];
                }else {
                    entity.iCloudImage = nil;
                }
            }
            _dataSourceArray = [array retain];
            [array release],array = nil;
        }else if (_category == Category_PhotoLibrary)
        {
            _dataSourceArray = [[_information photolibraryArray]retain];
        }else if (_category == Category_PhotoStream)
        {
            _dataSourceArray = [[_information photostreamArray]retain];
        }else if (_category == Category_PhotoVideo) {
            _dataSourceArray = [[_information photovideoArray]retain];
        }else if (_category == Category_Panoramas) {
            _dataSourceArray = [[_information panoramasArray]retain];
        }else if (_category == Category_TimeLapse) {
            _dataSourceArray =[[_information timelapseArray]retain];
        }else if (_category == Category_SlowMove) {
            _dataSourceArray = [[_information slowMoveArray]retain];
        }else if (_category == Category_MyAlbums) {
            _dataSourceArray = [[_information.albumsDic objectForKey:[NSNumber numberWithInt:_curEntity.albumZpk]] retain];
        }else if (_category == Category_PhotoShare) {
            _dataSourceArray = [[_information.shareAlbumDic objectForKey:[NSNumber numberWithInt:_curEntity.albumZpk]] retain];
        }else if (_category == Category_ContinuousShooting) {
            _dataSourceArray = [[_information.continuousShootingDic objectForKey:[NSNumber numberWithInt:_curEntity.albumZpk]] retain];
        }else if (_category == Category_Photo){
            _dataSourceArray = [[_iCloudManager photoArray] retain];
        }else if (_category == Category_LivePhoto) {
            _dataSourceArray = [_information.livePhotoArray retain];
        }else if (_category == Category_Screenshot) {
            _dataSourceArray = [_information.screenshotArray retain];
        }else if (_category == Category_PhotoSelfies) {
            _dataSourceArray = [_information.photoSelfiesArray retain];
        }else if (_category == Category_Location) {
            _dataSourceArray = [_information.locationArray retain];
        }else if (_category == Category_Favorite) {
            _dataSourceArray = [_information.favoriteArray retain];
        }
    }
    
    [self doSearchBtn:_searchFieldBtn.stringValue withSearchBtn:_searchFieldBtn];
    NSMutableArray *disArrary = nil;
    if (_isSearch) {
        disArrary = _researchdataSourceArray;
    }else{
        disArrary = _dataSourceArray;
    }
    NSMutableIndexSet *sets = [NSMutableIndexSet indexSet];
    for (int i=0;i<[disArrary count]; i++) {
        IMBBaseEntity *entity = [disArrary objectAtIndex:i];
        if (entity.checkState == Check||entity.checkState == SemiChecked) {
            [sets addIndex:i];
        }
    }
    if ([sets count] > 0 && [_dataSourceArray count]>0) {
        [_arrayController setSelectionIndexes:sets];
    }
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_mainBox setContentView:_detailView];
    }
    
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
    }else if (_category == Category_LivePhoto ||_category == Category_Screenshot||_category == Category_PhotoSelfies||_category == Category_Location||_category == Category_Favorite) {
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)];
        [_textView setSelectable:NO];
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
                    if (_isbackup) {
                        if ([entity.albumTitle isEqualToString:@"Photo Video"]) {
                            NSImage *thumimage = [[NSImage alloc] initWithContentsOfFile:entity.thumbPath];
//                            NSData *imageda =  [TempHelper createThumbnail:thumimage withWidth:142 withHeight:140];
                            NSData *imageda = [TempHelper scalingImage:thumimage withLenght:150];
                            photoImage = [[NSImage alloc] initWithData:imageda];
                            [thumimage release];
                        }else{
                            NSImage *thumimage = [[NSImage alloc] initWithContentsOfFile:entity.thumbImagePath];
//                            NSData *imageda =  [TempHelper createThumbnail:thumimage withWidth:142 withHeight:140];
                            NSData *imageda = [TempHelper scalingImage:thumimage withLenght:150];
                            photoImage = [[NSImage alloc] initWithData:imageda];
                            [thumimage release];
                        }
     
                    }else if (_isiCloudView) {
                        IMBToiCloudPhotoEntity *icloudPhEntity = nil;
                        if (phEntity && [phEntity isMemberOfClass:[IMBToiCloudPhotoEntity class]]) {
                            icloudPhEntity = (IMBToiCloudPhotoEntity *)phEntity;
                        }else {
                            entity = (IMBPhotoEntity *)phEntity;
                        }
                        data = [[_iCloudManager getPhotoThumbnilDetail:[icloudPhEntity thumbDownloadUrl]] retain];
                        if (!data){
                            data = [[NSData dataWithContentsOfFile:[entity thumbImagePath]] retain];
                        }
                    }else{
                        data = [[self createImageToTableView:entity] retain];
                    }
                    
                    if (data||_isbackup) {
                        NSImage *image = nil;
                        if (_isbackup) {
                            if (photoImage != nil) {
                                image = [photoImage retain];
                            }
                        }else{
                            image = [[NSImage alloc] initWithData:data];
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
                    }else {
                        entity.loadingImage = 0;
                    }
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
//                               NSData *imageda =  [TempHelper createThumbnail:thumimage withWidth:142 withHeight:140];
                            image = [[NSImage alloc] initWithData:imageda];
                            [thumimage release];
                        }else{
                            imageData = [[NSData alloc] initWithContentsOfFile:imagefilepath];
                            image = [[NSImage alloc] initWithData:imageData];
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

- (NSData *)createImageToTableView:(IMBPhotoEntity *)entity {
    NSString *filePath = nil;
    if (_isiCloud) {
        filePath = entity.thumbImagePath;
    }else{
        if (entity.photoKind == 0) {
            if ([_ipod.deviceHandle.productVersion isVersionMajorEqual:@"7"]) {
                if ([_ipod.fileSystem fileExistsAtPath:entity.thumbPath]) {
                    filePath = entity.thumbPath;
                }else {
                    filePath = entity.allPath;
                }
            }else {
                if ([_ipod.fileSystem fileExistsAtPath:entity.allPath]) {
                    filePath = entity.allPath;
                }
            }
        }else if (entity.photoKind == 1) {
            if ([_ipod.deviceHandle.productVersion isVersionMajorEqual:@"7"]) {
                if ([_ipod.fileSystem fileExistsAtPath:entity.thumbPath]) {
                    filePath = entity.thumbPath;
                }else {
                    filePath = entity.videoPath;
                }
            }else {
                if ([_ipod.fileSystem fileExistsAtPath:entity.videoPath]) {
                    filePath = entity.videoPath;
                }
            }
        }

    }
    NSImage *sourceImage = nil;
    NSData *imageData = nil;
    if (_isiCloud){
        imageData  =  [NSData dataWithContentsOfFile:filePath];
        sourceImage = [[NSImage alloc] initWithData:imageData];
    }else{
        imageData = [self readFileData:filePath];
        sourceImage = [[NSImage alloc] initWithData:imageData];
    }

    if ((sourceImage.size.width > 150 || sourceImage.size.height > 150) && sourceImage.size.width != 0 && sourceImage.size.height != 0) {
        imageData = [TempHelper scaleCutImage:sourceImage width:150 height:150 type:@"W"];
    }

    [sourceImage release];
    
    return imageData;
}

#pragma mark OperationActions
- (void)reload:(id)sender
{
//    [_seachField setStringValue:@""];
    [self disableFunctionBtn:NO];
    [_loadingAnimationView startAnimation];
    [_mainBox setContentView:_loadingView];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            if (_category == Category_CameraRoll) {
                [_information refreshCameraRoll];
            }else if (_category == Category_PhotoStream) {
                [_information refreshPhotoStream];
            }else if (_category == Category_PhotoLibrary) {
                [_information refreshPhotoLibrary];
            }else if (_category == Category_PhotoVideo) {
                [_information refreshVideoAlbum];
            }else if (_category == Category_Panoramas) {
                [_information refreshPanoramas];
            }else if (_category == Category_TimeLapse) {
                [_information refreshTimeLapse];
            }else if (_category == Category_SlowMove) {
                [_information refreshSlowMove];
            }else if (_category == Category_LivePhoto) {
                [_information refreshLivePhoto];
            }else if (_category == Category_Screenshot) {
                [_information refreshScreenshot];
            }else if (_category == Category_PhotoSelfies) {
                [_information refreshPhotoSelfies];
            }else if (_category == Category_Location) {
                [_information refreshLocation];
            }else if (_category == Category_Favorite) {
                [_information refreshFavorite];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self disableFunctionBtn:YES];
                [self refresh];
            });
        }
    });
}

- (void)refresh
{
    if (_dataArr != nil) {
        
        [_arrayController removeObjects:_dataArr];
    }
    if (_dataSourceArray != nil) {
       [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    if (_category == Category_CameraRoll) {
//        _dataSourceArray = [[_information camerarollArray] retain];
        NSMutableArray *array = [[_information camerarollArray] retain];
        for (IMBPhotoEntity *entity in array) {
            if (entity.cloudLocalState == 6) {
                entity.iCloudImage = [StringHelper imageNamed:@"iCloud_collection"];
            }else {
                entity.iCloudImage = nil;
            }
        }
        _dataSourceArray = [array retain];
        [array release],array = nil;
    }else if (_category == Category_PhotoLibrary) {
        _dataSourceArray = [[_information photolibraryArray]retain];
    }else if (_category == Category_PhotoStream) {
        _dataSourceArray = [[_information photostreamArray]retain];
    }else if (_category == Category_PhotoVideo) {
        _dataSourceArray = [[_information photovideoArray]retain];
    }else if (_category == Category_Panoramas) {
        _dataSourceArray = [[_information panoramasArray]retain];
    }else if (_category == Category_TimeLapse) {
        _dataSourceArray = [[_information timelapseArray]retain];
    }else if (_category == Category_SlowMove) {
        _dataSourceArray = [[_information slowMoveArray]retain];
    }else if (_category == Category_LivePhoto) {
        _dataSourceArray = [_information.livePhotoArray retain];
    }else if (_category == Category_Screenshot) {
        _dataSourceArray = [_information.screenshotArray retain];
    }else if (_category == Category_PhotoSelfies) {
        _dataSourceArray = [_information.photoSelfiesArray retain];
    }else if (_category == Category_Location) {
        _dataSourceArray = [_information.locationArray retain];
    }else if (_category == Category_Favorite) {
        _dataSourceArray = [_information.favoriteArray retain];
    }

    if (_dataSourceArray != nil) {
        currentIndex = 0;
        [self loadItem];
    }
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_mainBox setContentView:_detailView];
    }
    if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
        [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
    }
    [_loadingAnimationView endAnimation];
    [self loadCollectionView:NO];
}

- (void)openPhotoPreview:(NSNotification *)notification {
    if (_isiCloudView) {
        return;
    }
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
//    if ([_countDelegate respondsToSelector:@selector(reCaulateItemCount)]) {
//        [_countDelegate reCaulateItemCount];
//    }
}

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

#pragma mark - iCloudOperationActions

- (void)initiCloudPhotoAlbumMenuItem{
    [(IMBiCloudPhotoVideoViewController *)_icloudPhotoDelegate settoAlbumMenuItem:_toAlbumMenuItem];
    [_icloudPhotoDelegate initiCloudPhotoAlbumMenuItem];
}

- (void)iCloudReload:(id)sender {
    [_icloudPhotoDelegate iCloudReload:sender];
}

- (void)dropIcloudToCollectionView:(NSCollectionView *)collectionView paths:(NSMutableArray *)pathArray {
    [_icloudPhotoDelegate dropIcloudToCollectionView:collectionView paths:pathArray];

}

- (void)upLoad:(id)sender {
    [_icloudPhotoDelegate upLoad:sender];
}

//上传进度
- (void)icloudGetUploadProgress:(NSNotification *)notification{
}

- (void)icloudDriverError:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [notification userInfo];
        NSString *errorStr = [dic objectForKey:@"Error"];
        if ([errorStr rangeOfString:@"502"].location != NSNotFound) {
            NSString *str = nil;
            str = CustomLocalizedString(@"icloud_photo_noactive", nil);
            int i = [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            if (i) {
                if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                    [_transferController transferComplete:0 TotalCount:_transtotalCount];
                }
            }
        }
        _upLoadDownTotolSize = _upLoadDownTotolSize - _upLoadNowDownSize;
    });
}

- (void)iClouddragDownDataToMac:(NSString *)pathUrl{
    [_icloudPhotoDelegate iClouddragDownDataToMac:pathUrl];
}

- (void)downLoad:(id)sender {
    [_icloudPhotoDelegate downLoad:sender];
}

- (void)continueloadData{
    [_condition lock];
    if(_isPause)
    {
        _isPause = NO;
        [_condition signal];
    }
    [_condition unlock];
}

- (void)downloadDelay:(NSOpenPanel *)panel {
}

- (void)deleteiCloudItems:(id)sender {
    [_icloudPhotoDelegate deleteiCloudItems:sender];
}

- (void)iCloudSyncTransfer:(id)sender {
    [_icloudPhotoDelegate iCloudSyncTransfer:sender];
    
}

- (void)onItemiCloudClicked:(id)sender
{
    [_icloudPhotoDelegate onItemiCloudClicked:sender];
}

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:ICLOUD_GetUpload_Progress object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ICLOUD_DOWMLOAD_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_OPEN_PHOTO_PREVIEW object:nil];
    [_defaultImage release],_defaultImage = nil;
    [queue release], queue = nil;
    [_dataArr release],_dataArr = nil;
    [super dealloc];
}

@end

@implementation IMBPhotoCollectionViewItem
//static int i=0;
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


@implementation IMBPhotoImageView
@synthesize isSelected = _isSected;
@synthesize loadImage = _loadImage;
@synthesize isload = _isload;
@synthesize isfree = _isfree;
@synthesize exist = _exist;
- (void)awakeFromNib
{
//    _isDraw = NO;
//    [super awakeFromNib];
//    [self wantsLayer];

}

- (void)dealloc
{
    if (_loadImage != nil) {
        [_loadImage release];
        _loadImage = nil;
    }

    
    [super dealloc];
}


//- (void)drawRect:(NSRect)dirtyRect
//{
//    [super drawRect:dirtyRect];
//    
//    if (_isDraw) {
//        NSRect imageRect;
//        imageRect.origin = NSZeroPoint;
//        imageRect.size = _loadImage.size;
//        
//        NSRect drRect;
//        drRect.origin = NSMakePoint(0, (dirtyRect.size.height - _loadImage.size.height) / 2);
//        drRect.size = _loadImage.size;
//        
//        [_loadImage drawInRect:drRect fromRect:imageRect operation:NSCompositeDestinationOver fraction:1 respectFlipped:YES hints:nil];
//    }
//    
//    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
//    [[NSColor grayColor] setStroke];
//    [path stroke];
//    if (_isSected) {
//        
//    }
//    self.layer.shadowOpacity = 0.3;
//    self.layer.shadowColor = [NSColor blackColor].CGColor;
//    self.layer.shadowRadius = 3;
//    self.layer.shadowOffset = CGSizeMake(1, 1);
//}

//- (void)drawRect:(NSRect)dirtyRect
//{
//
//    [super drawRect:dirtyRect];
//
//}

//- (void)drawRect:(NSRect)dirtyRect
//{
//    @autoreleasepool {
//         [self.image drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeDestinationOver fraction:1 respectFlipped:YES hints:nil];
//    }
//
//}
@end

