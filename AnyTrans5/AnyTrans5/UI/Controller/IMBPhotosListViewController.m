//
//  IMBPhotosListViewController.m
//  iMobieTrans
//
//  Created by iMobie on 7/29/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBPhotosListViewController.h"
#import "IMBImageAndTextCell.h"
#import "IMBFileSystem.h"
//#import "IMBColorDefine.h"
#import "IMBCustomHeaderCell.h"
#import "IMBiCloudPhotoVideoViewController.h"
//#import "IMBPhotosPreviewWindowController.h"

@interface IMBPhotosListViewController ()

@end

@implementation IMBPhotosListViewController
@synthesize curEntity = _curEntity;
@synthesize icloudPhotoDelegate = _icloudPhotoDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePhotosListLanguage:) name:NOTIFY_PHOTOSLIST_CHANGE_LANGUAGE object:nil];
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    self = [super initWithIpod:ipod withCategoryNodesEnum:category withDelegate:delegate];
    if (self) {
        if (_category == Category_CameraRoll) {
            _dataSourceArray = [[_information camerarollArray] retain];
            
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

- (id)initWithiPod:(IMBiPod*)iPod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate withPhotoEntity:(IMBPhotoEntity *)entity {
    self = [super initWithIpod:iPod withCategoryNodesEnum:category withDelegate:delegate];
    if (self) {
        _curEntity = entity;
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
//        _dataArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithiCloudManager:(IMBiCloudManager *)iCloudManager withDelegate:(id)delegate withiCloudView:(BOOL)isiCloudView withCategory:(CategoryNodesEnum)Category  withiCloudPhotoEntity:(IMBToiCloudPhotoEntity *)iCloudPhotoEntity{
    if (self = [super initWithiCloudManager:iCloudManager withDelegate:delegate withiCloudView:isiCloudView withCategory:Category withiCloudPhotoEntity:iCloudPhotoEntity]) {
        _iCloudPhotoEntity = iCloudPhotoEntity;
//        if (_category == Category_PhotoVideo) {
            _dataSourceArray = [iCloudPhotoEntity.subArray retain];
//        }else if (_category == Category_Photo){
//            
//        }
        
    }
    return self;
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_PHOTOSLIST_CHANGE_LANGUAGE object:nil];
    if (queue != nil) {
        [queue release];
        queue = nil;
    }
    [super dealloc];
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        [self configNoDataView];
    });
}

- (void)changeSkin:(NSNotification *)notification {
    [self configNoDataView];
    [_loadingAnimationView setNeedsDisplay:YES];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    if (_category == Category_CameraRoll || _category == Category_PhotoVideo||_category == Category_TimeLapse||_category==Category_Panoramas||_category == Category_SlowMove) {
        if ([_ipod.deviceInfo.getDeviceFloatVersionNumber isVersionMajorEqual:@"8.3"]) {
            [_deleteMenuItem setHidden:YES];
        }else {
            [_deleteMenuItem setHidden:NO];
        }
    }else {
        [_deleteMenuItem setHidden:YES];
    }
    

    if (_isiCloudView) {
        [_deleteMenuItem setHidden:YES];
        [_preViewMenuItem setHidden:YES];
        [_toMacMenuItem setHidden:YES];
        [_toDeviceMenuItem setHidden:YES];
        [_addMenuItem setHidden:YES];
        [_addToDeviceMenuItem setHidden:YES];
        [_toiCloudMenuItem setHidden:NO];
        [_downLoadMenuItem setHidden:NO];
        [_upLoadMenuItem setHidden:NO];
    }else{
        [_toiCloudMenuItem setHidden:YES];
        [_downLoadMenuItem setHidden:YES];
        [_upLoadMenuItem setHidden:YES];
    }
    
    if (_category == Category_PhotoVideo || _category == Category_TimeLapse || _category == Category_SlowMove) {
        [_preViewMenuItem setHidden:YES];
        [_toiCloudMenuItem setHidden:YES];
    }else {
        [_preViewMenuItem setHidden:NO];
        if (_category == Category_MyAlbums) {
            [_toiCloudMenuItem setHidden:YES];
        }else {
            [_toiCloudMenuItem setHidden:NO];
        }
    }
    
    if (_category == Category_PhotoLibrary || _category == Category_MyAlbums) {
        [_addMenuItem setHidden:NO];
    }else {
        [_addMenuItem setHidden:YES];
    }
    
//    [_toiCloudMenuItem setHidden:YES];//屏蔽to iCloud
    
    if (_category == Category_MyAlbums || _category == Category_PhotoShare || _category == Category_ContinuousShooting) {
        [self.view setFrame:NSMakeRect(0, 0, 830, 534)];
        [_containTableView setFrame:NSMakeRect(0, 0, 830, 534)];
        [_scrollVeiw setFrame:NSMakeRect(0, 0, 830, 534)];
        [_itemTableView setFrame:NSMakeRect(0, 0, 830, 516)];
        [_noDataView setFrame:NSMakeRect(0, 0, 830, 534)];
        [_noDataImageView setFrameOrigin:NSMakePoint((_noDataView.frame.size.width - _noDataImageView.frame.size.width)/2, _noDataImageView.frame.origin.y)];
        [_noDataScrollView setFrameOrigin:NSMakePoint((_noDataView.frame.size.width - _noDataScrollView.frame.size.width)/2, _noDataScrollView.frame.origin.y)];
    }
//    if (_isiCloudView) {
//        [_mainBox setContentView:_loadingView];
//        [_loadingAnimationView startAnimation];
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
////            [_iCloudManager getPhotosContent];
//            _dataSourceArray = [_iCloudManager.photoArray retain];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_loadingAnimationView endAnimation];
//                if (_dataSourceArray.count == 0) {
//                    [_mainBox setContentView:_noDataView];
//                    //        [self configNoDataView];
//                }else {
//                    [_mainBox setContentView:_containTableView];
//                }
//            });
//        });
//    }else{
        if (_dataSourceArray.count == 0) {
            if (_isiCloudView) {
                [_mainBox setFrame:NSMakeRect(0, 0, 832, 534)];
                [_noDataView setFrame:NSMakeRect(0, 0, 832, 534)];
                [_noDataImageView setFrame:NSMakeRect((_noDataView.frame.size.width -_noDataImageView.frame.size.width)/2, _noDataImageView.frame.origin.y, _noDataImageView.frame.size.width, _noDataImageView.frame.size.height)];
                [_noDataScrollView setFrame:NSMakeRect((_noDataView.frame.size.width - _noDataScrollView.frame.size.width)/2, _noDataScrollView.frame.origin.y, _noDataScrollView.frame.size.width, _noDataScrollView.frame.size.height)];
                [_noDataLable setFrame:NSMakeRect(0, _noDataLable.frame.origin.y, 832, _noDataLable.frame.size.height)];
                [_noDataScrollView setHidden:YES];
            }else{
                [_noDataLable setHidden:YES];
                [_noDataView setFrame:NSMakeRect(0, 0, 1000, 534)];
                
            }
            [_mainBox setContentView:_noDataView];
            [self configNoDataView];
        }else {
            [_noDataLable setHidden:YES];
            [_mainBox setContentView:_containTableView];
        }
//    }

   // [self configNoDataView];
    _tqueue = dispatch_queue_create("com.ConcurrentQueue.list", NULL);
    [_itemTableView setTarget:self];
    [_itemTableView setAction:@selector(openFullImageFormTab:)];
    queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:8];
    [_itemTableView setListener:self];
    //屏蔽排序图片
    NSTableColumn *column = [_itemTableView tableColumnWithIdentifier:@"Image"];
    IMBCustomHeaderCell *columnHeaderCell = (IMBCustomHeaderCell *) column.headerCell;
    [columnHeaderCell setIsShowTriangle:NO];
    
//    [self reloadListWithSearchString:_seachField.stringValue];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    
}

- (void)setToolBar:(IMBToolBarView *)toolBar{
    _toolBar = toolBar;
}

- (void)setTableViewHeadOrCollectionViewCheck{
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
            _dataSourceArray=[[_information camerarollArray]retain];
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
        }else if (_category == Category_Photo){
            _dataSourceArray = [[_iCloudManager photoArray] retain];
        }
        
//        Category_LivePhoto = 70,
//        Category_Screenshot = 71,
//        Category_PhotoSelfies = 72,
//        Category_Location = 73,
//        Category_Favorite = 74,
    }
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_mainBox setContentView:_containTableView];
    }

    NSIndexSet *set = [self selectedItems];
    [self doSearchBtn:_searchFieldBtn.stringValue withSearchBtn:_searchFieldBtn];
    [_itemTableView showVisibleRextPhoto];
//    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];

    if ([set count] == [_dataSourceArray count]&&[_dataSourceArray count]>0) {
        [_itemTableView changeHeaderCheckState:NSOnState];
    }else if ([set count] == 0)
    {
        [_itemTableView changeHeaderCheckState:NSOffState];
    }else
    {
        [_itemTableView changeHeaderCheckState:NSMixedState];
    }
    [_itemTableView reloadData];
}

- (void)setTableViewHeadCheckBtn{
    NSIndexSet *set = [self selectedItems];
    if ([set count] == [_dataSourceArray count]&&[_dataSourceArray count]>0) {
        [_itemTableView changeHeaderCheckState:NSOnState];
    }else if ([set count] == 0)
    {
        [_itemTableView changeHeaderCheckState:NSOffState];
    }else
    {
        [_itemTableView changeHeaderCheckState:NSMixedState];
    }
    [_itemTableView reloadData];
}

- (void)openFullImageFormTab:(IMBCustomHeaderTableView *)tableView {
 /*   if (tableView == _itemTableView) {
        NSInteger row = [tableView clickedRow];
        if (row == -1) {
            return;
        }
        
        if (tableView.clickNum == 2) {
            IMBPhotoEntity *entity = [_itemArray objectAtIndex:row];
            if (entity.photoKind == 1) {
//                NSAlert *alert = [NSAlert alertWithMessageText:CustomLocalizedString(@"IMB_Warning", nil) defaultButton:CustomLocalizedString(@"MSG_COM_Confirm_OK", nil) alternateButton:nil otherButton: nil informativeTextWithFormat: CustomLocalizedString(@"IMB_Photo_Video_File", nil)];
//                [alert.window center];
//                [alert runModal];
                return;
            }
            NSMutableArray *preArray = [[NSMutableArray alloc]init];
            if (_itemArray != nil) {
                for (IMBPhotoEntity *pe in _itemArray) {
                    if (pe.photoKind != 1) {
                        [preArray addObject:pe];
                    }
                }
            }
            IMBPhotosPreviewWindowController *photoController = [[IMBPhotosPreviewWindowController alloc] initWithArray:preArray withIpod:_ipod WithPhotoEntity:entity];
            [NSApp runModalForWindow:[photoController window]];
            [photoController release];
            [preArray release];
        }
    }*/
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
    }else if (_category == Category_Photo){
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"DeviceView_id_6", nil)];
        [_textView setSelectable:NO];
    }else if (_category == Category_LivePhoto || _category == Category_Screenshot|| _category == Category_PhotoSelfies|| _category == Category_Location|| _category == Category_Favorite){
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)];
        [_textView setSelectable:NO];
    }

    [_noDataLable setStringValue:promptStr];
    [_noDataLable setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
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

#pragma mark - IMBImageRefreshListener
- (void)loadingThumbnilImage:(NSRange)oldVisibleRows withNewVisibleRows:(NSRange)newVisibleRows {
//    NSLog(@"newVisibleRows:%d,  %d",newVisibleRows.location,newVisibleRows.length);
    [queue cancelAllOperations];
//    if (_isSearching && _searchingArray != nil) {
//         _visibleItems = (NSMutableArray *)[[_searchingArray subarrayWithRange:newVisibleRows] retain];
//    }else{
    
         _visibleItems = (NSMutableArray *)[[_dataSourceArray subarrayWithRange:newVisibleRows] retain];
//    }
   
    
    NSRange range;
    if (newVisibleRows.location > 10) {
        range = NSMakeRange(0, newVisibleRows.location - 1);
        NSArray *array = [_dataSourceArray subarrayWithRange:range];
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
    if (newVisibleRows.location + newVisibleRows.length + 10 < _dataSourceArray.count && _dataSourceArray.count > 10) {
        range = NSMakeRange(newVisibleRows.location + newVisibleRows.length + 8, _dataSourceArray.count - 9 - (newVisibleRows.location + newVisibleRows.length));
        NSArray *array = [_dataSourceArray subarrayWithRange:range];
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
                    NSData *data  = nil;
                    if (_isiCloudView) {
                        IMBToiCloudPhotoEntity *icloudPhEntity = nil;
                        if (phEntity && [phEntity isMemberOfClass:[IMBToiCloudPhotoEntity class]]) {
                            icloudPhEntity = (IMBToiCloudPhotoEntity *)phEntity;
                        }
                        data = [[_iCloudManager getPhotoThumbnilDetail:[icloudPhEntity thumbDownloadUrl]] retain];
                    }else{
                        data = [[self createImageToTableView:entity] retain];
                    }
                    if (data) {
                        NSImage *image = [[NSImage alloc] initWithData:data];
                        if (image) {
                            entity.loadingImage = 2;
                            entity.photoImage = image;
                        }else {
                            entity.loadingImage = 0;
                        }
                        [image release];
                        image = nil;
                        //此线程写图片到本地
                        dispatch_async(_tqueue, ^{
                            @autoreleasepool {
                                if (entity.catchName == nil) {
                                    NSDate *date = [NSDate date];
                                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                    NSString *str = [formatter stringFromDate:date];
                                    NSString *name = [[NSString stringWithFormat:@"%@_%@.jpg",[entity.photoName stringByDeletingPathExtension],str] retain];
                                    entity.catchName = name;
                                    [name release];
                                    name = nil;
                                    [formatter release];
                                    formatter = nil;
                                }
                                NSString *imageCatchBasePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"imageCatch"];
                                NSString *imagefilepath = [imageCatchBasePath stringByAppendingPathComponent:entity.catchName];
                                NSFileManager *fm = [NSFileManager defaultManager];
                                if ([fm fileExistsAtPath:imagefilepath]) {
                                    imagefilepath = [TempHelper getFilePathAlias:imagefilepath];
                                    entity.catchName = [imagefilepath lastPathComponent];
                                }
                                if (![fm fileExistsAtPath:imagefilepath]) {
                                    if ([fm createDirectoryAtPath:imageCatchBasePath withIntermediateDirectories:NO attributes:nil error:nil]) {
                                        [fm createFileAtPath:imagefilepath contents:data attributes:nil];
                                    }else
                                    {
                                        [fm createFileAtPath:imagefilepath contents:data attributes:nil];
                                    }
                                }
                            
                            }
                        });
                    }else {
                        entity.loadingImage = 0;
                    }
                    [data release];
                    data = nil;
                }else if (entity.loadingImage == 2) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *imageCatchBasePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"imageCatch"];
                        NSString *imagefilepath = [imageCatchBasePath stringByAppendingPathComponent:entity.catchName];
                        NSFileManager *fm = [NSFileManager defaultManager];
                        if ([fm fileExistsAtPath:imagefilepath]) {
                            NSData *imageData = [[NSData alloc] initWithContentsOfFile:imagefilepath];
                            NSImage *image = [[NSImage alloc] initWithData:imageData];
                            if (image) {
                                entity.photoImage = image;
                            }
                            [imageData release];
                            imageData = nil;
                            [image release];
                            image = nil;
                        }else {
                            entity.loadingImage = 0;
                            entity.photoImage = [StringHelper imageNamed:@"photo_show"];
                        }
                    });
                }
                [self performSelectorOnMainThread:@selector(reloadRowForTableView:) withObject:entity waitUntilDone:NO modes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                NSLog(@"entity count: %ld", entity.retainCount);
//                [entity release];
//                entity = nil;
            }
        }];
    }
}

- (void)reloadRowForTableView:(id)object {
    NSInteger row;
//   if (_isSearching && _searchingArray != nil) {
//       row = [_searchingArray indexOfObject:object];
//    }else
//    {
    if (_isSearch) {
        row = [_researchdataSourceArray indexOfObject:object];
    }else{
        row = [_dataSourceArray indexOfObject:object];
    }
    
//    }
   
    if (row != NSNotFound) {
        [_itemTableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row] columnIndexes:[NSIndexSet indexSetWithIndex:1]];
    }
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSMutableArray *disPalyAry = nil;
    if (_isSearch) {
        disPalyAry = _researchdataSourceArray;
    }else{
        disPalyAry = _dataSourceArray;
    }
    if (disPalyAry.count <= 0) {
        return 0;
    }
    return [disPalyAry count];
}
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <=0) {
        return @"";
    }
    IMBPhotoEntity *entity = [displayArray objectAtIndex:row];
    
    if ([@"Name" isEqualToString:tableColumn.identifier] ) {
        return entity.photoName;
    }
    
    if ([@"Format" isEqualToString:tableColumn.identifier]) {
        return [NSString stringWithFormat:@"%d * %d",entity.photoWidth,entity.photoHeight];
    }
    
    if ([@"TimeDate" isEqualToString:tableColumn.identifier]) {
        if (_isiCloudView) {
            return [DateHelper dateFrom1970ToString:entity.photoDateData withMode:2];
        }else{
            return [DateHelper dateFrom2001ToString:entity.photoDateData withMode:2];
        }
        
    }
    if ([@"Size" isEqualToString:tableColumn.identifier]) {
        return [StringHelper getFileSizeString:entity.photoSize reserved:2];
    }
    if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
        return [NSNumber numberWithInt:entity.checkState];
    }
    return @"";
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <= 0) {
        return ;
    }
//    NSArray *bindingArray = nil;
//    if (_isSearching) {
//        bindingArray = _searchBindingArray;
//    }
//    else{
//        bindingArray = _bindingArray;
//    }
    if ([@"Image" isEqualToString:tableColumn.identifier] ) {
    IMBPhotoEntity *entity = [displayArray objectAtIndex:row];
        IMBImageAndTextCell *curCell = (IMBImageAndTextCell*)cell;
        NSImage *image = nil;
        image = [entity.photoImage retain];
        int W = 58;
        int H = 58;
        if (image.size.width >= image.size.height && image.size.height > 0) {
            W = 58;
            H = (int)(((double)image.size.height / image.size.width) * W);
            if (H < 1.0) {
                H = 1;
            }
        }else if (image.size.height > image.size.width && image.size.width > 0) {
            H = 58;
            W = (int)(((double)image.size.width / image.size.height) * H);
            if (W < 1.0) {
                W = 1;
            }
        }
        [curCell setImageSize:NSMakeSize(W, H)];
        curCell.image = image;
        curCell.paddingX = 2;
        curCell.marginX =(58 - W) / 2 + 6;
        if (entity.cloudLocalState == 6) {
            curCell.iCloudImg = [StringHelper imageNamed:@"iCloud_list"];
            curCell.imageName = @"iCloud_list";
        }else {
            curCell.iCloudImg = nil;
        }
        [image release];
        return;
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 64;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
//    NSMutableArray *disPalyAry = nil;
//    if (_isSearch) {
//        disPalyAry = _researchdataSourceArray;
//    }else{
//        disPalyAry = _dataSourceArray;
//    }
//    if (disPalyAry.count <=0) {
//        return;
//    }
//    NSIndexSet *set = [_itemTableView selectedRowIndexes];
////    for (int i=0; i<[disPalyAry count]; i++) {
////        IMBPhotoEntity *entity = [disPalyAry objectAtIndex:i];
////        if ([set containsIndex:i]) {
////            [entity setCheckState:NSOnState];
////            [entity setIsHiddenSelectImage:NO];
////        }else{
////            [entity setCheckState:NSOffState];
////            [entity setIsHiddenSelectImage:YES];
////        }
////    }
//    if ([set count] == [_dataSourceArray count]&&[_dataSourceArray count]>0) {
//        [_itemTableView changeHeaderCheckState:NSOnState];
//    }else if ([set count] == 0)
//    {
//        [_itemTableView changeHeaderCheckState:NSOffState];
//    }else
//    {
//        [_itemTableView changeHeaderCheckState:NSMixedState];
//    }
    [_itemTableView reloadData];
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
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
            if ([column.identifier isEqualToString:identify] && ![identify isEqualToString: @"Image"]) {
                [columnHeadercell setIsShowTriangle:YES];
            }else {
                [columnHeadercell setIsShowTriangle:NO];
            }
        }
        
    }

	if ( [@"Name" isEqualToString:identify] || [@"Format" isEqualToString:identify] || [@"TimeDate" isEqualToString:identify] || [@"Size" isEqualToString:identify] || [@"DocumentSize" isEqualToString:identify] || [@"Format" isEqualToString:identify]|| [@"Genre" isEqualToString:identify] || [@"Rating" isEqualToString:identify]) {
        if ([cell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *customHeaderCell = (IMBCustomHeaderCell *)cell;
            if (customHeaderCell.ascending) {
                customHeaderCell.ascending = NO;
            }else
            {
                customHeaderCell.ascending = YES;
            }
     
            [self sort:customHeaderCell.ascending key:identify dataSource:disPalyAry];
        }
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (int i=0;i<[disPalyAry count]; i++) {
            IMBTrack *track = [disPalyAry objectAtIndex:i];
            if (track.checkState == NSOnState) {
                [set addIndex:i];
            }
        }
//        [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    }

    [_itemTableView reloadData];
}

- (void)sort:(BOOL)isAscending key:(NSString *)key dataSource:(NSMutableArray *)array {
    if ([key isEqualToString:@"Name"]) {
        key = @"photoName";
    } else if ([key isEqualToString:@"Format"]) {
        key = @"photoWidth";
    }else if ([key isEqualToString:@"TimeDate"]) {
        key = @"photoDateData";
    } else if ([key isEqualToString:@"Size"]) {
        key = @"photoSize";
    } 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    [_itemTableView reloadData];
    
    [sortDescriptor release];
    [sortDescriptors release];
}

#pragma mark - IMBImageRefreshListListener
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
    IMBPhotoEntity *entity = [disPalyAry objectAtIndex:index];
    [entity setIsHiddenSelectImage:entity.checkState];
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
        IMBPhotoEntity *entity = [displayArray objectAtIndex:i];
        [entity setIsHiddenSelectImage:!checkState];
        [entity setCheckState:checkState];
        if (entity.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
//    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    [_itemTableView reloadData];
}

- (NSData *)createImageToTableView:(IMBPhotoEntity *)entity {
    NSString *filePath = nil;
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
    
    NSData *data = [self readFileData:filePath];
    NSImage *sourceImage = [[NSImage alloc] initWithData:data];
    
    
    NSMutableData *imageData = nil;
    if ([_ipod.deviceHandle.productVersion isVersionMajorEqual:@"7"]) {
        imageData = [(NSMutableData *)[TempHelper scalingImage:sourceImage withLenght:140] retain];
    }else {
        imageData = [(NSMutableData *)[TempHelper createThumbnail:sourceImage withWidth:140 withHeight:110] retain];
    }
    [sourceImage release];
    
    return [imageData autorelease];
}

- (NSData *)readFileData:(NSString *)filePath {
    if (![_ipod.fileSystem fileExistsAtPath:filePath]) {
        return nil;
    }
    else{
        long long fileLength = [_ipod.fileSystem getFileLength:filePath];
        AFCFileReference *openFile = [_ipod.fileSystem openForRead:filePath];
        const uint32_t bufsz = 10240;
        char *buff = (char*)malloc(bufsz);
        NSMutableData *totalData = [[[NSMutableData alloc] init] autorelease];
        while (1) {
            
            uint64_t n = [openFile readN:bufsz bytes:buff];
            if (n==0) break;
            //将字节数据转化为NSdata
            NSData *b2 = [[NSData alloc]
                          initWithBytesNoCopy:buff length:n freeWhenDone:NO];
            [totalData appendData:b2];
            [b2 release];
        }
        if (totalData.length == fileLength) {
           // NSLog(@"success readData 1111");
        }
        free(buff);
        [openFile closeFile];
        return totalData;
    }
}

- (void)changePhotosListLanguage:(NSNotification *)notification {
//    [_itemTableView _setupHeaderCell];
//    [_itemTableView reloadData];
//    if ([_countDelegate respondsToSelector:@selector(reCaulateItemCount)]) {
//        
//        [_countDelegate reCaulateItemCount];
//    }
}

- (void)reload:(id)sender {
    [self disableFunctionBtn:NO];
    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            if (_category == Category_CameraRoll) {
                [_information refreshCameraRoll];
            }else if (_category == Category_PhotoLibrary) {
                [_information refreshPhotoLibrary];
            }else if (_category == Category_PhotoStream){
                [_information refreshPhotoStream];
            }else if (_category == Category_PhotoVideo) {
                [_information refreshVideoAlbum];
            }else if (_category == Category_Panoramas) {
                [_information refreshPanoramas];
            }else if (_category == Category_TimeLapse) {
                [_information refreshTimeLapse];
            }else if (_category == Category_SlowMove){
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

- (void)refresh {
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    [_searchFieldBtn setStringValue:@""];
    _isSearch = NO;
    if (_category == Category_CameraRoll) {

        _dataSourceArray=[[_information camerarollArray]retain];
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
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_mainBox setContentView:_containTableView];
        [_itemTableView changeHeaderCheckState:UnChecked];
    }
    if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
        [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
    }
    [_loadingAnimationView endAnimation];
    [_itemTableView reloadData];
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _isSearch = YES;
    _searchFieldBtn = searchBtn;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"photoName CONTAINS[cd] %@ ",searchStr];
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
        IMBPhotoEntity *photoEntity = [disAry objectAtIndex:i];
        if (photoEntity.checkState == NSOnState) {
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
}

#pragma mark - iCloudOperationActions
- (void)initiCloudPhotoAlbumMenuItem{
    [_icloudPhotoDelegate settoAlbumMenuItem:_toAlbumMenuItem];
    [_icloudPhotoDelegate initiCloudPhotoAlbumMenuItem];
}

- (void)iCloudReload:(id)sender {
    [_icloudPhotoDelegate iCloudReload:sender];
//    if (_dataSourceArray != nil) {
//        [_dataSourceArray release];
//        _dataSourceArray = nil;
//    }
//    [_mainBox setContentView:_loadingView];
//    [_loadingAnimationView startAnimation];
//   [_toolBar toolBarButtonIsEnabled:NO];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [_iCloudManager getPhotosContent];
//        _dataSourceArray = [_iCloudManager.photoArray retain];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_toolBar toolBarButtonIsEnabled:YES];
//            [_loadingAnimationView endAnimation];
//            if (_dataSourceArray.count == 0) {
//                [_mainBox setContentView:_noDataView];
//                //        [self configNoDataView];
//            }else {
//                [_mainBox setContentView:_containTableView];
//            }
//        });
//    });
}

- (void)dropicloudToTabView:(NSTableView *)tableView paths:(NSArray *)pathArray{
    [_icloudPhotoDelegate dropicloudToTabView:tableView paths:pathArray];
//    if (_transferController != nil) {
//        [_transferController release];
//        _transferController = nil;
//    }
//    _transferController = [[IMBTransferViewController alloc] initWithType:Category_iCloudDriver withDelegate:self withTransfertype:TransferUpLoading];
//    [_transferController setDelegate:self];
//    _transferController.isicloudView = YES;
//    //    [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:nil];
//    [self animationAddTransferView:_transferController.view];
//    if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
//        [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_9", nil)]];
//    }
//    //            if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
//    //                [_transferController transferProgress:0];
//    //            }
//    _alertViewController.isIcloudOneOpen = YES;
//    if (![IMBSoftWareInfo singleton].isRegistered) {
////        _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
//    }
//    
//    
//    //            NSMutableArray *paths = [NSMutableArray array];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        float updataCot = 0;
//        for (NSString *url in pathArray) {
//            [_condition lock];
//            if (_isPause) {
//                [_condition wait];
//            }
//            [_condition unlock];
//            if (_isStop) {
//                [_iCloudManager cancel];
//                _isStop = NO;
//                return;
//            }
//            
//            //                [paths addObject:url.path];
//            BOOL issucc =  [_iCloudManager uploadPhoto:url];
//            if (issucc) {
//                updataCot ++;
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_transferController transferPrepareFileEnd];
//                float progress = updataCot / pathArray.count *100;
//                if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
//                    [_transferController transferProgress:progress];
//                }
//            });
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_transferController startTransAnimation];
//            if (_annoyTimer != nil) {
//                [_annoyTimer invalidate];
//                _annoyTimer = nil;
//            }
//            if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
//                [_transferController transferComplete:updataCot TotalCount:pathArray.count];
//            }
//        });
//    });

}

- (void)upLoad:(id)sender {
    [_icloudPhotoDelegate upLoad:sender];
//    _isOpen = YES;
//    _openPanel = [NSOpenPanel openPanel];
//    [_openPanel setCanChooseDirectories:YES];
//    [_openPanel setCanChooseFiles:YES];
//    [_openPanel setAllowsMultipleSelection:YES];
//    [_openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"jpg", nil]];
//    _isStop = NO;
////    _istransView = YES;
//    //    _updateCount = 0;
//    [_openPanel beginSheetModalForWindow:[(IMBiCloudMainPageViewController *)_delegate view].window completionHandler:^(NSModalResponse returnCode) {
//        if (returnCode == NSFileHandlingPanelOKButton) {
//            if (_transferController != nil) {
//                [_transferController release];
//                _transferController = nil;
//            }
//            _transferController = [[IMBTransferViewController alloc] initWithType:Category_Photo withDelegate:self withTransfertype:TransferUpLoading];
//            [_transferController setDelegate:self];
//            _transferController.isicloudView = YES;
//            [self animationAddTransferView:_transferController.view];
//            if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
//                [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_9", nil)]];
//            }
//            //            if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
//            //                [_transferController transferProgress:0];
//            //            }
//            _alertViewController.isIcloudOneOpen = YES;
//            if (![IMBSoftWareInfo singleton].isRegistered) {
////                _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
//            }
//            NSArray *pathAry = [_openPanel URLs];
////            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Upload" label:Start transferCount:pathAry.count screenView:@"Photos View" screenColor:[IMBSoftWareInfo singleton].curUseSkin userLanguageName:[TempHelper currentSelectionLanguage] customParameters:nil];
//            
//            //            NSMutableArray *paths = [NSMutableArray array];
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                float upDataCot = 0;
//                for (NSURL *url in pathAry) {
//                    [_condition lock];
//                    if (_isPause) {
//                        [_condition wait];
//                    }
//                    [_condition unlock];
//                    if (_isStop) {
//                        [_iCloudManager cancel];
//                        _isStop = NO;
//                        return;
//                    }
//                    
//                    //                [paths addObject:url.path];
//                    BOOL issucc =  [_iCloudManager uploadPhoto:url.path];
//                    if (issucc) {
//                        upDataCot ++;
//                    }
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [_transferController transferPrepareFileEnd];
//                        
//                        float progress = upDataCot / pathAry.count *100;
//                        if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
//                            [_transferController transferProgress:progress];
//                        }
//                    });
//                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [_transferController startTransAnimation];
//                    if (_annoyTimer != nil) {
//                        [_annoyTimer invalidate];
//                        _annoyTimer = nil;
//                    }
//                    if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
////                        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Upload" label:Finish transferCount:upDataCot screenView:@"Photos View" screenColor:[IMBSoftWareInfo singleton].curUseSkin userLanguageName:[TempHelper currentSelectionLanguage] customParameters:nil];
//                        [_transferController transferComplete:upDataCot TotalCount:pathAry.count];
//                    }
//                });
//            });
//        }
//    }];
}

- (void)icloudDriverError:(NSNotification *)notification{
    
}

- (void)copyInPhotofomationToMac:(NSString *)filePath indexSet:(NSIndexSet *)set{
    [_icloudPhotoDelegate copyInPhotofomationToMac:filePath indexSet:set];
////    dispatch_async(dispatch_get_global_queue(0, 0), ^{
////        dispatch_async(dispatch_get_main_queue(), ^{
//    
//            if (_transferController != nil) {
//                [_transferController release];
//                _transferController = nil;
//            }
//            _transferController = [[IMBTransferViewController alloc] initWithType:Category_iCloudDriver withDelegate:self withTransfertype:TransferDownLoad];
//            [_transferController setDelegate:self];
//            [_transferController setExprtPath:filePath];
//            _alertViewController.isIcloudOneOpen = YES;
//            _transferController.isicloudView = YES;
//            if (![IMBSoftWareInfo singleton].isRegistered) {
////                _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
//            }
//            [self animationAddTransferView:_transferController.view ];
//            if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
//                [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_9", nil)]];
//            }
////        });
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            float i =0;
//            NSIndexSet *selectedSet = set;
//            NSMutableArray *selectedArray = [NSMutableArray array];
//            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
//                [selectedArray addObject:[_dataSourceArray objectAtIndex:idx]];
//            }];
//           
//            for (IMBiCloudPhotoEntity *entity in selectedArray) {
//                [_condition lock];
//                if (_isPause) {
//                    [_condition wait];
//                }
//                [_condition unlock];
//                if (_isStop) {
//                    [_iCloudManager cancel];
//                    _isStop = NO;
//                    return;
//                }
//                BOOL success = [_iCloudManager downloadPhoto:entity withDownloadPath:filePath];
//                if (success ) {
//                    i ++;
//                }
//                [_transferController transferPrepareFileEnd];
//                
//                float progressCount = i/[_dataSourceArray objectsAtIndexes:[self selectedItems]].count*100;
//                if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
//                    [_transferController transferProgress:progressCount];
//                }
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (_annoyTimer != nil) {
//                    [_annoyTimer invalidate];
//                    _annoyTimer = nil;
//                }
//                [_transferController startTransAnimation];
//                if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
//                    [_transferController transferComplete:i TotalCount:selectedArray.count];
//                }
//            });
//        });
}

- (void)downLoad:(id)sender {
    [_icloudPhotoDelegate downLoad:sender];
//    NSIndexSet *selectedSet = [self selectedItems];
//    if ([selectedSet count] <= 0) {
//        //弹出警告确认框
//        NSString *str = nil;
//        if (_dataSourceArray.count == 0) {
//            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_transfer", nil),[StringHelper getCategeryStr:_category]];
//        }else {
//            str = CustomLocalizedString(@"Export_View_Selected_Tips", nil);
//        }
//        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
//    }else {
//        //弹出路径选择框
//        _openPanel = [NSOpenPanel openPanel];
//        _isOpen = YES;
//        [_openPanel setAllowsMultipleSelection:NO];
//        [_openPanel setCanChooseFiles:NO];
//        [_openPanel setCanChooseDirectories:YES];
//        if(_category == Category_Photo) {
//            [_openPanel beginSheetModalForWindow:[(IMBiCloudMainPageViewController *)_delegate view].window completionHandler:^(NSInteger result) {
//                if (result== NSFileHandlingPanelOKButton) {
//                    NSString *path = [[_openPanel URL] path];
//                    path = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:_category]];
//                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                        
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            if (_transferController != nil) {
//                                [_transferController release];
//                                _transferController = nil;
//                            }
//                            _transferController = [[IMBTransferViewController alloc] initWithType:Category_Photo withDelegate:self withTransfertype:TransferDownLoad];
//                            [_transferController setDelegate:self];
//                            [_transferController setExprtPath:path];
//                            _transferController.isicloudView = YES;
//                            _alertViewController.isIcloudOneOpen = YES;
//                            if (![IMBSoftWareInfo singleton].isRegistered) {
////                                _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
//                            }
//                            [self animationAddTransferView:_transferController.view];
//                            if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
//                                [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_9", nil)]];
//                            }
//                        });
//                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                            int i =0;
//                            float count = 0;
////                            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Download" label:Start transferCount:i screenView:@"Photos View" screenColor:[IMBSoftWareInfo singleton].curUseSkin userLanguageName:[TempHelper currentSelectionLanguage] customParameters:nil];
//                            NSArray *dataAry = [_dataSourceArray objectsAtIndexes:[self selectedItems]];
//                            for (IMBiCloudPhotoEntity *entity in dataAry) {
//                                [_condition lock];
//                                if (_isPause) {
//                                    [_condition wait];
//                                }
//                                [_condition unlock];
//                                if (_isStop) {
//                                    [_iCloudManager cancel];
//                                    _isStop = NO;
//                                    return;
//                                }
//                                BOOL success = [_iCloudManager downloadPhoto:entity withDownloadPath:path];
//                                if (success ) {
//                                    i ++;
//                                }
//                                count ++;
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    float progressCount =count/dataAry.count*100;
//                                    [_transferController transferPrepareFileEnd];
//                                    if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
//                                        [_transferController transferProgress:progressCount];
//                                    }
//                                });
//                            }
//                            [_transferController startTransAnimation];
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                if (_annoyTimer != nil) {
//                                    [_annoyTimer invalidate];
//                                    _annoyTimer = nil;
//                                }
//                                if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
////                                    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Download" label:Finish transferCount:i screenView:@"Photos View" screenColor:[IMBSoftWareInfo singleton].curUseSkin userLanguageName:[TempHelper currentSelectionLanguage] customParameters:nil];
//                                    [_transferController transferComplete:i TotalCount:[_dataSourceArray objectsAtIndexes:[self selectedItems]].count];
//                                }
//                            });
//                            
//                        });
//                    });
//                }else{
//                    NSLog(@"other other other");
//                }
//            }];
//        }
//    }
}

- (void)onItemiCloudClicked:(id)sender
{
    [_icloudPhotoDelegate onItemiCloudClicked:sender];
//    [_toDevicePopover close];
//    NSIndexSet *indexSet = [self selectedItems];
//    NSArray *arrayM = [[_dataSourceArray objectsAtIndexes:indexSet] retain];
//
//    if (arrayM.count > 0) {
//        if (_transferController != nil) {
//            [_transferController release];
//            _transferController = nil;
//        }
//        
//        IMBBaseInfo *baseInfo = (IMBBaseInfo *)sender;
//        NSDictionary *iCloudDic = [_delegate getiCloudAccountViewCollection];
//        _otheriCloudManager = [[iCloudDic objectForKey:baseInfo.uniqueKey] iCloudManager];
//        [_otheriCloudManager setDelegate:self];
//        _transferController = [[IMBTransferViewController alloc] initWithType:Category_Photo withDelegate:self withTransfertype:TransferSync];
//        [_transferController setDelegate:self];
//        _transferController.isicloudView = YES;
//        if (![IMBSoftWareInfo singleton].isRegistered) {
////            _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
//        }
//        //        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:nil];
//        [self animationAddTransferView:_transferController.view];
//        if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
//            [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"contact_id_91", nil)]];
//        }
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            float count = 0;
//            for (IMBiCloudPhotoEntity *entity in arrayM) {
//                entity.photoImageData = [_iCloudManager getPhotoThumbnilDetail:entity.oriDownloadUrl];
//                [_otheriCloudManager syncTransferPhoto:entity];
//                count ++;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    float progress = count / arrayM.count *100;
//                    if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
//                        [_transferController transferProgress:progress];
//                    }
//                });
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (_annoyTimer != nil) {
//                    [_annoyTimer invalidate];
//                    _annoyTimer = nil;
//                }
//                if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
//                    [_transferController transferComplete:arrayM.count TotalCount:arrayM.count];
//                }
//            });
//        });
//    }else {
//        //弹出警告确认框
//        NSString *str = nil;
//        str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
//        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
//    }
//    [arrayM release];
}
@end
