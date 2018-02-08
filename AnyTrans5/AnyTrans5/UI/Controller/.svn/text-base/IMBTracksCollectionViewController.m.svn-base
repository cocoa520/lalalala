//
//  IMBTracksCollectionViewController.m
//  iMobieTrans
//
//  Created by iMobie on 14-5-16.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBTracksCollectionViewController.h"
#import "NSBezierPath+BezierPathQuartzUtilities.h"
//#import "IMBAbstractExportToiTunes.h"
#import "IMBIPodImageFormat.h"
#import "IMBVideoImageByOther.h"
#import "IMBFileSystem.h"
#import "IMBNotificationDefine.h"
#import "StringHelper.h"
#import "SystemHelper.h"
#import "IMBAddTrackToList.h"
#import "IMBDeviceMainPageViewController.h"
#import "IMBBackupCollectionViewController.h"
@implementation IMBTracksCollectionViewController
@synthesize dataArr = _dataArr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    self = [super initWithIpod:ipod withCategoryNodesEnum:category withDelegate:delegate];
    if (self) {
        //默认是track数据
        currentIndex = 0;
        _dataArr = [[NSMutableArray alloc] init];
        
        if (_category == Category_CloudMusic) {
            _dataSourceArray = [[NSMutableArray alloc] initWithArray:[_information cloudTrackArray]];
        }else {
            if (_information.tracks != nil) {
                _dataSourceArray = (NSMutableArray *)[[_information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:_category]] retain];
            }
        }
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
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [self configNoDataView];
    if (_defaultImage != nil) {
        [_defaultImage release];
        _defaultImage = nil;
    }
    _defaultImage = [[StringHelper imageNamed:@"music_show"] retain];
    [_photoSelectedImageView setImage:[StringHelper imageNamed:@"photo_selected"]];
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
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    _nc = [NSNotificationCenter defaultCenter];
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_mainBox setContentView:_contentView];
    }
    [_scrollView setListener:_collectionView];
    [_collectionView setListener:self];
    _tqueue = dispatch_queue_create("com.ConcurrentQueue.track", NULL);
    _collectionView.category = _category;
//    [self loadItem];
    _defaultImage = [[StringHelper imageNamed:@"music_show"] retain];
    [_scrollView setHastopBorder:NO leftBorder:NO BottomBorder:NO rightBorder:NO];
    currentRow = 0;
    queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:8];
//    [[_scrollView contentView] setPostsBoundsChangedNotifications: YES];
//    [[NSNotificationCenter defaultCenter] addObserver: self
//                                             selector: @selector(boundsDidChangeNotification:)
//                                                 name: NSViewBoundsDidChangeNotification
//                                               object: [_scrollView contentView]];
//    
//    [self boundsDidChangeNotification:nil];
//    [self reloadListWithSearchString:_seachField.stringValue];
    [self loadCollectionView:NO];
    [self performSelector:@selector(checkCDBcorrupted) withObject:nil afterDelay:0.01];
    _logManger = [IMBLogManager singleton];


    if (_category == Category_Movies || _category == Category_TVShow || _category == Category_MusicVideo || _category == Category_HomeVideo ) {
        [_addToPlaylistMenuItem setHidden:YES];
    }else if (_category == Category_CloudMusic) {
        [_deleteMenuItem setHidden:YES];
        [_toDeviceMenuItem setHidden:YES];
        [_toiTunesMenuItem setHidden:YES];
        [_addToPlaylistMenuItem setHidden:YES];
        [_addToDeviceMenuItem setHidden:YES];
        [_addMenuItem setHidden:YES];
    }else {
        [_addToPlaylistMenuItem setHidden:NO];
    }
    [self changeAddToPlaylistMenu];
    [_nc addObserver:self selector:@selector(changeAddToPlaylistMenu) name:PLAYLIST_COUNT_CHANGE object:nil];
    [_photoSelectedImageView setImage:[StringHelper imageNamed:@"photo_selected"]];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
}

- (void)changeAddToPlaylistMenu {
    NSArray *array = [_ipod.playlists getPlaylist];
    int i = 0;
    for (IMBPlaylist *playlist in array) {
        if (playlist.isUserDefinedPlaylist) {
            i ++;
        }
    }
    if (i < 1 || _category == Category_Movies || _category == Category_TVShow || _category == Category_MusicVideo || _category == Category_HomeVideo) {
        [_addToPlaylistMenuItem setHidden:YES];
    }else if (_category == Category_CloudMusic) {
        [_deleteMenuItem setHidden:YES];
        [_toDeviceMenuItem setHidden:YES];
        [_toiTunesMenuItem setHidden:YES];
        [_addToPlaylistMenuItem setHidden:YES];
        [_addToDeviceMenuItem setHidden:YES];
        [_addMenuItem setHidden:YES];
    }else {
        [_addToPlaylistMenuItem setHidden:NO];
    }
}

- (void)setTableViewHeadOrCollectionViewCheck{
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    if (_category == Category_CloudMusic) {
        _dataSourceArray = [[NSMutableArray alloc] initWithArray:[_information cloudTrackArray]];
    }else {
        _dataSourceArray = [(NSMutableArray *)[_ipod getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:_category]] retain];
    }
    NSMutableArray *disArrary = nil;
    if (_isSearch) {
        disArrary = _researchdataSourceArray;
    }else{
        disArrary = _dataSourceArray;
    }
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_mainBox setContentView:_contentView];
    }
    
    [self doSearchBtn:_searchFieldBtn.stringValue withSearchBtn:_searchFieldBtn];
    NSMutableIndexSet *sets = [NSMutableIndexSet indexSet];
    for (int i=0;i<[disArrary count]; i++) {
        IMBBaseEntity *entity = [disArrary objectAtIndex:i];
        if (entity.checkState == Check||entity.checkState == SemiChecked) {
            [sets addIndex:i];
        }
    }
    if ([sets count] > 0 && [disArrary count]>0) {
        [_arrayController setSelectionIndexes:sets];
    }
}

- (void)loadCollectionView:(BOOL)isFrist {
    [self loadItem];
    [_collectionView setTotalCount:(int)_dataArr.count];
//    if (!isFrist) {
        [_collectionView setRefresh:YES];
        [_collectionView showVisibleRextPhoto];
//    }
}

//加载没有加载的item
//如果_itemArray count 大于120 每次加载120 一直到加载完成为止
- (void)loadItem
{
    NSArray *displayArray = nil;
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
            [_arrayController addObjects:[displayArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]]];
            [set release];
        }
    }
}

#pragma mark - NSTextView
- (void)configNoDataView {
    [_textView setDelegate:self];
    NSString *promptStr = @"";
    NSString *overStr = CustomLocalizedString(@"NO_DATA_TITLE_2", nil);
    if (_category == Category_Music) {
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_audio"]];
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_1", nil)] stringByAppendingString:overStr];
    }else if (_category == Category_CloudMusic) {
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_audio"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_91", nil)];
    }else if (_category == Category_Movies) {
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_movies"]];
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_70", nil)] stringByAppendingString:overStr];
    }else if (_category == Category_TVShow) {
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_TVshow"]];
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_71", nil)] stringByAppendingString:overStr];
    }else if (_category == Category_MusicVideo) {
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_video"]];
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_78", nil)] stringByAppendingString:overStr];
    }else if (_category == Category_PodCasts) {
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_podcasts"]];
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_72", nil)] stringByAppendingString:overStr];
    }else if (_category == Category_iTunesU) {
         [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_U"]];
         promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_16", nil)] stringByAppendingString:overStr];
    }else if (_category == Category_Audiobook) {
         [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_audiobook"]];
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_73", nil)] stringByAppendingString:overStr];
    }else if (_category == Category_Ringtone) {
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_ringtones"]];
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_79", nil)] stringByAppendingString:overStr];
    }else if (_category == Category_HomeVideo) {
         [_noDataImageView setImage:[StringHelper imageNamed:@"noData_video"]];
         promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_50", nil)] stringByAppendingString:overStr];
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
            for (IMBTrack *track in array) {
                @autoreleasepool {
                    if (_category == Category_Movies) {
                        if (track.loadingImage) {
                            track.thumbImage = [StringHelper imageNamed:@"movies_show"];
                        }
                    }else if (_category == Category_Music||_category == Category_CloudMusic||_category == Category_MusicVideo) {
                        if (track.loadingImage) {
                            track.thumbImage = [StringHelper imageNamed:@"music_show"];
                        }
                    }else if (_category == Category_TVShow) {
                        if (track.loadingImage) {
                            track.thumbImage = [StringHelper imageNamed:@"tv_show"];
                        }
                    }else if (_category == Category_Ringtone) {
                        if (track.loadingImage) {
                            track.thumbImage = [StringHelper imageNamed:@"ringtone_show"];
                        }
                    }else {
                        if (track.loadingImage) {
                            track.thumbImage = [StringHelper imageNamed:@"music_show"];
                        }
                    }
                }
            }
        }
    }
    if (newVisibleRows.location + newVisibleRows.length + 10 < _dataArr.count && _dataSourceArray.count > 10) {
        range = NSMakeRange(newVisibleRows.location + newVisibleRows.length + 8, _dataArr.count - 9 - (newVisibleRows.location + newVisibleRows.length));
        NSArray *array = [_dataArr subarrayWithRange:range];
        if (array != nil) {
            for (IMBTrack *track in array) {
                @autoreleasepool {
                    if (_category == Category_Movies) {
                        if (track.loadingImage) {
                            track.thumbImage = [StringHelper imageNamed:@"movies_show"];
                        }
                    }else if (_category == Category_Music||_category == Category_CloudMusic||_category == Category_MusicVideo) {
                        if (track.loadingImage) {
                            track.thumbImage = [StringHelper imageNamed:@"music_show"];
                        }
                    }else if (_category == Category_TVShow) {
                        if (track.loadingImage) {
                            track.thumbImage = [StringHelper imageNamed:@"tv_show"];
                        }
                    }else if (_category == Category_Ringtone) {
                        if (track.loadingImage) {
                            track.thumbImage = [StringHelper imageNamed:@"ringtone_show"];
                        }
                    }else {
                        if (track.loadingImage) {
                            track.thumbImage = [StringHelper imageNamed:@"music_show"];
                        }
                    }
                }
            }
        }
    }
    
    if (_visibleItems != nil && _visibleItems.count > 0) {
        for (IMBTrack *track in _visibleItems) {
            [self loadImage:track];
        }
    }
    [_visibleItems release];
}

- (void)loadImage:(IMBTrack *)track {
    @synchronized (track) {
        [queue addOperationWithBlock:^(void) {
            @autoreleasepool {
                if (track.loadingImage == NO) {
                    if (_category == Category_Movies) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            track.thumbImage = [StringHelper imageNamed:@"movies_show"];
                        });
                    }else if (_category == Category_Music||_category == Category_CloudMusic||_category == Category_MusicVideo) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            track.thumbImage = [StringHelper imageNamed:@"music_show"];
                        });
                    }else if (_category == Category_TVShow) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            track.thumbImage = [StringHelper imageNamed:@"tv_show"];
                        });
                    }else if (_category == Category_Ringtone) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            track.thumbImage = [StringHelper imageNamed:@"ringtone_show"];
                        });
                    }else {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            track.thumbImage = [StringHelper imageNamed:@"music_show"];
                        });
                    }
                    NSData *data = [[self createThumbImage:track] retain];
                    if (data) {
                        NSImage *image = [[NSImage alloc] initWithData:data];
                        if (image) {
                            track.loadingImage = YES;
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                track.thumbImage = image;
                            });
                        }
                        [image release];
                        
                        //此线程写图片到本地
                        dispatch_async(_tqueue, ^{
                            @autoreleasepool {
                                if (track.catchName == nil) {
                                    NSDate *date = [NSDate date];
                                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                    NSString *str = [formatter stringFromDate:date];
                                    NSString *name = [[NSString stringWithFormat:@"%@_%@.jpg",track.title,str] retain];
                                    track.catchName = name;
                                    [name release];
                                    [formatter release];
                                }
                                NSString *imageCatchBasePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"imageCatch"];
                                NSString *imagefilepath = [imageCatchBasePath stringByAppendingPathComponent:track.catchName];
                                NSFileManager *fm = [NSFileManager defaultManager];
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
                    }
                    [data release];
                }else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        NSString *imageCatchBasePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"imageCatch"];
                        NSString *imagefilepath = [imageCatchBasePath stringByAppendingPathComponent:track.catchName];
                        NSFileManager *fm = [NSFileManager defaultManager];
                        if ([fm fileExistsAtPath:imagefilepath]) {
                            NSData *imageData = [[NSData alloc] initWithContentsOfFile:imagefilepath];
                            NSImage *image = [[NSImage alloc] initWithData:imageData];
                            if (image) {
                                track.thumbImage = image;
                            }
                            [image release];
                            [imageData release];
                        }else {
                            track.loadingImage = NO;
                            if (_category == Category_Movies) {
                                if (track.loadingImage) {
                                    track.thumbImage = [StringHelper imageNamed:@"movies_show"];
                                }
                            }else if (_category == Category_Music||_category == Category_CloudMusic||_category == Category_MusicVideo) {
                                if (track.loadingImage) {
                                    track.thumbImage = [StringHelper imageNamed:@"music_show"];
                                }
                            }else if (_category == Category_TVShow) {
                                if (track.loadingImage) {
                                    track.thumbImage = [StringHelper imageNamed:@"tv_show"];
                                }
                            }else if (_category == Category_Ringtone) {
                                if (track.loadingImage) {
                                    track.thumbImage = [StringHelper imageNamed:@"ringtone_show"];
                                }
                            }else {
                                if (track.loadingImage) {
                                    track.thumbImage = [StringHelper imageNamed:@"music_show"];
                                }
                            }
                        }
                    });
                }
            }
        }];
    }
}

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
        NSMutableData *imageData = [(NSMutableData *)[TempHelper scalingImage:sourceImage withLenght:150] retain];
        [sourceImage release];
        [data release];
        
        return [imageData autorelease];
    }else {
        return nil;
    }
    
}

- (NSData *)readFileData:(NSString *)filePath {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![_ipod.fileSystem fileExistsAtPath:filePath]) {
        if ([fm fileExistsAtPath:filePath]) {
            return [fm contentsAtPath:filePath];
        }
        else{
            return nil;
        }
    }
    else{
        //TODO:fei ios
        if (!_ipod.deviceInfo.isIOSDevice) {
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:filePath]) {
                NSData *data = [fm contentsAtPath:filePath];
                if (data.length > 0) {
                    return data;
                }
                else{
                    return nil;
                }
            }
            else{
                return nil;
            }
            
        }
        else{
            long long fileLength = [_ipod.fileSystem getFileLength:filePath];
            AFCFileReference *openFile = [_ipod.fileSystem openForRead:filePath];
            
            const uint32_t bufsz = 102400;
            char *buff;
            if (fileLength>=bufsz) {
                buff = (char*)malloc(bufsz);
            }else
            {
                buff = (char*)malloc((uint32_t)fileLength);
            }
            
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
                //                NSLog(@"success readData");
            }
            free(buff);
            [openFile closeFile];
            return totalData;
            
        }
    }
}

#pragma mark OperAtionActions
- (void)reload:(id)sender
{
    [self disableFunctionBtn:NO];
    [_loadingAnimationView startAnimation];
    [_mainBox setContentView:_loadingView];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            if (_ipod != nil && _itemTableView == nil&&_collectionView != nil) {
                [_ipod startSync];
                if (_category == Category_CloudMusic) {
                    [_information refreshCloudMusic];
                }else {
                    [_information refreshMedia];
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self disableFunctionBtn:YES];
                    [self refresh];
                });
                [_ipod endSync];
            }
        }
    });
}

- (void)refresh
{
    [_searchFieldBtn setStringValue:@""];
    _isSearch = NO;
    if (_information.tracks != nil) {
        if (_dataSourceArray != nil) {
            [_arrayController removeObjects:_dataArr];
        }
        //更新内存数据
        if (_dataSourceArray != nil) {
            [_dataSourceArray release];
            _dataSourceArray = nil;
        }
        if (_category == Category_CloudMusic) {
            _dataSourceArray = [[NSMutableArray alloc] initWithArray:[_information cloudTrackArray]];
        }else {
            _dataSourceArray = [(NSMutableArray *)[_ipod getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:_category]] retain];
        }
        for (IMBTrack *track in _dataSourceArray) {
            track.checkState = UnChecked;
        }
        if (_dataSourceArray != nil&&_dataSourceArray.count > 0) {
            currentIndex = 0;
            [self loadItem];
               [_mainBox setContentView:_contentView];
        }else{
            [_mainBox setContentView:_noDataView];
            [self configNoDataView];
        }
    }else{
         [_mainBox setContentView:_noDataView];
         [self configNoDataView];
    }
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
        [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
    }
    
    [_loadingAnimationView endAnimation];
    [self loadCollectionView:NO];
}

- (MediaImageType)getTrackType:(IMBTrack *)track
{
    NSArray *supportVideoExtension = [[MediaHelper getSupportFile:Category_Movies supportVideo:YES withiPod:_ipod] componentsSeparatedByString:@";"];
    NSArray *supportImageExtension = [[MediaHelper getSupportFile:Category_PhotoLibrary supportVideo:YES withiPod:_ipod] componentsSeparatedByString:@";"];
    NSArray *supportBookExtension = [[MediaHelper getSupportFile:Category_iBooks supportVideo:YES withiPod:_ipod] componentsSeparatedByString:@";"];
    
    MediaImageType imageType = MusicTypeIcon;
    NSString *extensionString = [NSString stringWithFormat:@"*.%@",track.filePath.pathExtension].lowercaseString;
    if ([supportVideoExtension containsObject:extensionString]) {
        imageType = VideoTypeIcon;
    }
    else if([supportImageExtension containsObject:extensionString]){
        imageType = ImageTypeIcon;
    }
    else if([supportBookExtension containsObject:extensionString]){
        imageType = FileTypeIcon;
    }
    else{
        imageType = MusicTypeIcon;
    }
    return imageType;
}

- (void)changeTractCollectionLanguage:(NSNotification *)notification {
   /* if ([_countDelegate respondsToSelector:@selector(reCaulateItemCount)]) {
        [_countDelegate reCaulateItemCount];
    }*/
}

-(void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _searchFieldBtn = searchBtn;
    _isSearch = YES;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
    }
    
    if (_dataSourceArray != nil) {
        [_arrayController removeObjects:_dataArr];
    }
    
    currentIndex = 0;
    [self loadItem];
    [_collectionView setTotalCount:(int)_dataArr.count];
    [_collectionView setRefresh:YES];
    [_collectionView showVisibleRextPhoto];
}

- (void)initPlaylistMenuItem {
    IMBPlaylist *currentPlaylist = nil;
    [_addToPlaylistMenuItem setTitle:CustomLocalizedString(@"Menu_Playlist", nil)];
    NSMenu *addToPlaylistMenu = _addToPlaylistMenuItem.submenu;
    [addToPlaylistMenu removeAllItems];
    
    [addToPlaylistMenu setAutoenablesItems:NO];
    //    NSIndexSet *indexset = _playlistsTableView.selectedRowIndexes;
    //    if (indexset.count > 0) {
    //        NSInteger integer = indexset.firstIndex;
    //        currentPlaylist = [_playlistArray objectAtIndex:integer];
    //    }
    NSArray *array = [_ipod.playlists getPlaylist];
    int i = 0;
    for (IMBPlaylist *playlist in array) {
        i ++;
        if (playlist.iD != currentPlaylist.iD && playlist.isUserDefinedPlaylist) {
            NSMenuItem *menuItem = nil;
            menuItem = [[NSMenuItem alloc] initWithTitle:playlist.name action:@selector(addToPlaylistMenuAction:) keyEquivalent:@""];
            [menuItem setTag:i];
            [menuItem setTarget:self];
            [menuItem setEnabled:YES];
            
            [addToPlaylistMenu addItem:menuItem];
            
            [menuItem release];
        }
    }
}

- (void)addToPlaylistMenuAction:(id)sender{
    NSMenu *menu = _addToPlaylistMenuItem.submenu;
    for (NSMenuItem *menuItem in menu.itemArray) {
        if (menuItem == sender) {
            IMBPlaylist *playlist = [_ipod.playlists getPlaylistByName:menuItem.title];
            [self addToPlaylist:playlist.iD];
            break;
        }
    }
}

- (void)addToPlaylist:(long long)playlistID{
    NSLog(@"========");
    if (![self checkInternetAvailble]) {
        [_logManger writeInfoLog:[NSString stringWithFormat:@"Do Add Track To Playlist End (checkInternetAvailble = %d)",[self checkInternetAvailble]]];
        return;
    }
    
    IMBPlaylist *playlist = [_ipod.playlists getPlaylistByID:playlistID];
    NSArray *selectItem = [self selectedItemsByPlaylist];
    if (playlist != nil && selectItem.count > 0) {
        IMBAddTrackToList *procedure = [[IMBAddTrackToList alloc] initWithIPodKey:_ipod.uniqueKey tracksArray:selectItem playlistID:playlist.iD];
        //                    [self showRefrshLoading:YES LoadingType:LoadingAddPlaylist];
        
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                [view setHidden:NO];
                break;
            }
        }
        NSString *str = nil;
        if (selectItem.count > 1) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"Playlist_id_17", nil),CustomLocalizedString(@"MSG_Item_id_2", nil)];
        }else {
            str = [NSString stringWithFormat:CustomLocalizedString(@"Playlist_id_17", nil),CustomLocalizedString(@"MSG_Item_id_1", nil)];
        }
        
        [_alertViewController showDeleteAnimationViewAlertText:str SuperView: view];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [procedure startAddTrackToList];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_alertViewController unloadAlertView:_alertViewController.deleteAnimationView];
                [self reload:nil];
            });
            [procedure release];
        });
    }
}

- (NSArray *)selectedItemsByPlaylist{
    NSIndexSet *indexSet = [_collectionView selectionIndexes];
    if (indexSet.count == 0) {
        [self showAlertText:CustomLocalizedString(@"MSG_COM_No_Item_Selected", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return nil;
    }
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    NSMutableArray *items = [NSMutableArray array];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [items addObject:[displayArray objectAtIndex:idx]];
    }];
    return items;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSPhotoCollectionViewBoundsDidChangeNotification object:nil];
    [_nc removeObserver:self name:PLAYLIST_COUNT_CHANGE object:nil];
    [_defaultImage release],_defaultImage = nil;
    [queue release], queue = nil;
    [_dataArr release],_dataArr = nil;
    [super dealloc];
}
@end

@implementation IMBCollectionViewItem
@synthesize index = _index;
- (void)awakeFromNib
{
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
//    if (_imageName == nil) {
//        NSDate *date = [NSDate date];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *str = [formatter stringFromDate:date];
//        _imageName = [[NSString stringWithFormat:@"%d%@.jpg",i,str]retain];
//        [formatter release];
//        i++;
//    }
//    IMBCollectionItemView *itemView = (IMBCollectionItemView *)self.view;
//    IMBPhotoImageView *photoimageView = [itemView viewWithTag:101];
//    IMBPhotoImageView *photoselectedimageView = [itemView viewWithTag:102];
//    
//    [photoselectedimageView.image setSize:NSMakeSize(150, 150)];
//    photoimageView.isSelected = selected;
//    
//    [photoimageView setNeedsDisplay:YES];
//    if (selected) {
//        [photoselectedimageView setHidden:NO];
//    }else
//    {
//        [photoselectedimageView setHidden:YES];
//    }
    
    IMBBlankDraggableCollectionView *blankCollectionView = (IMBBlankDraggableCollectionView *)[self.view superview];
    NSArray *itemArray = [blankCollectionView subviews];
    NSArray *allArray = [blankCollectionView content];
    NSUInteger index = [itemArray indexOfObject:self.view];
    if (allArray.count > index) {
        IMBTrack *track = [allArray objectAtIndex:index];
        track.checkState = selected;
        track.isHiddenSelectImage = !selected;
    }
}


- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSCollectionViewBoundsDidChangeNotification object:nil];
    [super dealloc];
}


@end

@implementation IMBCollectionItemView
@synthesize done = _done;


-(void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    [_bgImageView setImage:[StringHelper imageNamed:@"photo_selected"]];
}

- (void)changeSkin:(NSNotification *)notification {
    [_bgImageView setImage:[StringHelper imageNamed:@"photo_selected"]];
}

- (void)updateTrackingAreas {
	[super updateTrackingAreas];
	if (_trackingArea)
	{
		[self removeTrackingArea:_trackingArea];
		[_trackingArea release];
	}
	
	NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved| NSTrackingActiveInKeyWindow;
	_trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil];
	[self addTrackingArea:_trackingArea];
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint mousePt = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    IMBCollectionImageView *imageView = [self viewWithTag:101];
    BOOL overClose = NSMouseInRect(mousePt,[imageView frame], [self isFlipped]);
    if (overClose) {
        if (theEvent.clickCount == 2) {
            _blankDraggableView = (IMBBlankDraggableCollectionView *)self.superview;
            if ([_blankDraggableView.collectionItem isKindOfClass:[IMBPhotoCollectionViewItem class]]||[_blankDraggableView.collectionItem isKindOfClass:[IMBBackupCollectionViewItem class]]) {
                NSArray *contentArray = _blankDraggableView.content;
                
//                NSPoint initialLocation = [theEvent locationInWindow];
//                NSPoint location = [_blankDraggableView convertPoint:initialLocation fromView:nil];
//                NSInteger index = [_blankDraggableView _indexAtPoint: location];
                NSIndexSet *set= [_blankDraggableView selectionIndexes];
                if (set.count <= 0) {
                    return;
                }
                NSInteger index = [set firstIndex];
                IMBPhotoEntity *entity = [contentArray objectAtIndex:index];

                NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:entity, @"ENTITY", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_OPEN_PHOTO_PREVIEW object:nil userInfo:userDic];
            }
        }else if (theEvent.clickCount == 1) {
            [super mouseDown:theEvent];
        }
    }else
    {
        _blankDraggableView = (IMBBlankDraggableCollectionView *)self.superview;
        [_blankDraggableView setSelectionIndexes:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyDone:) name:NOTIFY_DONE object:nil];
        NSPoint initialLocation = [theEvent locationInWindow];
        
        _done = NO;
        NSUInteger eventMask = (NSLeftMouseUpMask | NSLeftMouseDownMask | NSLeftMouseDraggedMask | NSPeriodicMask);
        NSEvent *lastEvent = theEvent;
        while (!_done) {
            lastEvent = [NSApp nextEventMatchingMask:eventMask untilDate:[NSDate date] inMode:NSEventTrackingRunLoopMode dequeue:YES];
            NSEventType eventType = [lastEvent type];
            NSPoint mouseLocationWin = [lastEvent locationInWindow];
            switch (eventType)
            {
                case NSLeftMouseDown:
                    break;
                case NSLeftMouseDragged:
                    if (fabs(mouseLocationWin.x - initialLocation.x) >= 2
                        || fabs(mouseLocationWin.y - initialLocation.y) >= 2)
                    {
                        [super mouseDown:theEvent];
                    }
                    break;
                case NSLeftMouseUp:
                    //                    [_blankDraggableView _selectWithEvent:theEvent index: index];
                    _done = YES;
                    NSLog(@"mouse up");
                    break;
                default:
                    _done = NO;
                    break;
            }
            
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_DONE object:nil];
    }
}

- (void)notifyDone:(NSNotification *)notification {
    NSNumber *number = [notification object];
    BOOL isDone = [number boolValue];
    [self setDone:isDone];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [super mouseUp:theEvent];
    _done = YES;
}

- (void)mouseExited:(NSEvent *)theEvent {
    if (![[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"13"]) {
        _blankDraggableView = (IMBBlankDraggableCollectionView *)self.superview;
        if (([_blankDraggableView.collectionItem isKindOfClass:[IMBPhotoCollectionViewItem class]]||[_blankDraggableView.collectionItem isKindOfClass:[IMBBackupCollectionViewItem class]]) && _hasLargeImage) {
            CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            animation.fromValue=[NSValue valueWithCATransform3D:
                                 CATransform3DMakeScale(1.1, 1.1, 1.0)];
            animation.toValue=[NSValue valueWithCATransform3D:CATransform3DIdentity];
            animation.duration=0.3;
            animation.autoreverses=NO;
            animation.repeatCount=0;
            animation.removedOnCompletion=NO;
            animation.fillMode=kCAFillModeForwards;
            animation.delegate=self;
            
            for (NSView *view in self.subviews) {
                for (NSView *subView in view.subviews) {
                    if ([subView isKindOfClass:[NSImageView class]]) {
                        NSImageView *imageView = (NSImageView *)subView;
                        if (imageView.tag == 101) {
                            [imageView setWantsLayer:YES];
                            imageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
                            _hasLargeImage = NO;
                            [imageView.layer addAnimation:animation forKey:@"2"];
                        }
                    }
                }
            }
        }
    }
}

- (void)mouseMoved:(NSEvent *)theEvent {
    if (![[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"13"]) {
        [self largeImage:theEvent];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    
}

- (void)largeImage:(NSEvent*)theEvent {
    _blankDraggableView = (IMBBlankDraggableCollectionView *)self.superview;
    if ([_blankDraggableView.collectionItem isKindOfClass:[IMBPhotoCollectionViewItem class]]||[_blankDraggableView.collectionItem isKindOfClass:[IMBBackupCollectionViewItem class]]) {
        NSPoint initialLocation = [theEvent locationInWindow];
        NSPoint location = [_blankDraggableView convertPoint:initialLocation fromView:nil];
        NSInteger index = [_blankDraggableView _indexAtPoint: location];
        NSArray *contentArray = _blankDraggableView.content;
        NSPoint mousePt = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        BOOL inner = NSMouseInRect(mousePt, NSMakeRect(18, 11, 150, 150), [self isFlipped]);
        if (inner) {
            if (!_hasLargeImage) {
                if (index < [_blankDraggableView content].count) {
                    if ([[contentArray objectAtIndex:index] isMemberOfClass:[IMBToiCloudPhotoEntity class]]) {
                        return;
                    }
                    IMBPhotoEntity *entity = [contentArray objectAtIndex:index];
                    if (entity.isexisted) {
                        NSString *str1 = [StringHelper getFileSizeString:entity.photoSize reserved:1];
                        NSString *str = [NSString stringWithFormat:@"%@ %@:%@",entity.photoName,CustomLocalizedString(@"List_Header_id_Size", nil),str1];
                        [self setToolTip:str];
                    }else {
                        [self setToolTip:[NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_File_Not_Exist", nil),entity.photoName]];
                    }
                    
                    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
                    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
                    animation.toValue = [NSValue valueWithCATransform3D:
                                         CATransform3DMakeScale(1.1, 1.1, 1.0)];
                    animation.duration= 0.3;
                    animation.autoreverses=NO;
                    animation.repeatCount=0;
                    animation.removedOnCompletion=NO;
                    animation.fillMode=kCAFillModeForwards;
                    animation.delegate=self;
                    [self setWantsLayer:YES];
                    for (NSView *view in self.subviews) {
                        for (NSView *subView in view.subviews) {
                            if ([subView isKindOfClass:[NSImageView class]]) {
                                NSImageView *imageView = (NSImageView *)subView;
                                if (imageView.tag == 101) {
                                    [imageView setWantsLayer:YES];
                                    imageView.layer.position = NSMakePoint(imageView.frame.origin.x + imageView.frame.size.width / 2.0, imageView.frame.origin.y + imageView.frame.size.height / 2.0);
                                    imageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
                                    _hasLargeImage = YES;
                                    [imageView.layer addAnimation:animation forKey:@"1"];
                                }
                            }
                        }
                    }
                }
            }
        } else {
            [self mouseExited:nil];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_OPEN_PHOTO_PREVIEW object:nil];
    [super dealloc];
}

@end

@implementation IMBCollectionImageView
@synthesize backgroundImage = _backgroundImage;
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setImageScaling:NSImageScaleProportionallyUpOrDown];
}

- (void)dealloc{
    [_backgroundImage release],_backgroundImage = nil;
    [super dealloc];
}

@end
