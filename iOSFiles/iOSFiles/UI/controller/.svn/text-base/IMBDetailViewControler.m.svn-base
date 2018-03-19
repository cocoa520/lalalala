//
//  IMBDetailViewControler.m
//  iOSFiles
//
//  Created by iMobie on 18/2/2.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBDetailViewControler.h"
#import "IMBDevicePageFolderModel.h"
#import "IMBPhotoEntity.h"
#import "IMBTrack.h"
#import "IMBBookEntity.h"
#import "IMBAppEntity.h"
#import "StringHelper.h"
#import "IMBInformation.h"
#import "IMBPhotoExportSettingConfig.h"
#import "IMBPhotoFileExport.h"
#import "TempHelper.h"
#import "IMBAirSyncImportTransfer.h"
#import "IMBDeleteTrack.h"
#import "IMBStackBox.h"
#import "LoadingView.h"
#import "IMBDeviceConnection.h"
#import "IMBBetweenDeviceHandler.h"
#import "IMBCategoryInfoModel.h"
#import "IMBToolBarView.h"
#import "IMBiBooksExport.h"
#import "IMBBookToDevice.h"
#import "IMBMediaFileExport.h"
#import "IMBAppExport.h"
#import "IMBDeleteApps.h"
#import "NSString+Category.h"

#import <objc/runtime.h>



@interface IMBDetailViewControler ()<NSTableViewDelegate,NSTableViewDataSource,TransferDelegate>
{
    @private
    IBOutlet NSScrollView *_scrollView;
    IBOutlet NSTableView *_tableView;
    
    NSArray *_headerTitleArr;
    NSIndexSet *_selectedIndexes;
    NSString *_savePath;
    IMBBaseTransfer *_baseTransfer;
    CategoryNodesEnum _category;
    
    IMBStackBox *_rootBox;
    LoadingView *_loadingView;
    IMBToolBarView *_toolMenuView;
    
    BOOL _isToMac;
}
@end

@implementation IMBDetailViewControler

@synthesize folderModel = _folderModel;
//@synthesize iPod = _iPod;


static CGFloat const rowH = 40.0f;
static CGFloat const labelY = 10.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
}

- (void)awakeFromNib {
    
    [self addNotis];
    
    [self setupTableView];
    
}

- (void)setupTableView {
    
    _rootBox = objc_getAssociatedObject(_iPod, &kIMBDevicePageRootBoxKey);
    _toolMenuView = objc_getAssociatedObject(_iPod, &kIMBDevicePageToolBarViewKey);
    
    _toolMenuView.delegate = self;
    _selectedIndexes = nil;
    _scrollView.hasHorizontalScroller = NO;
    
    //设置拖拽
    [_tableView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    [_tableView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:YES];
    [_tableView registerForDraggedTypes:[NSArray arrayWithObjects:NSFilesPromisePboardType,NSFilenamesPboardType,nil]];
    [_tableView setVerticalMotionCanBeginDrag:YES];
    
    [_tableView setAllowsColumnSelection:NO];
    _tableView.allowsMultipleSelection = YES;
    [_tableView setTarget:self];
    [_tableView setDoubleAction:@selector(tableViewDoubleClicked:)];
    [_tableView reloadData];
    NSInteger count = _tableView.tableColumns.count;
    for (NSInteger i = 0; i < count; i++) {
        [_tableView removeTableColumn:_tableView.tableColumns[0]];
    }
    NSString *path = @"";
    switch (_folderModel.idx) {
        case IMBDevicePageWindowFolderEnumPhoto://photo
        case IMBDevicePageWindowFolderEnumPhotoCameraRoll:
        {
            [_toolMenuView setHiddenIndexes:@[@(IMBToolBarViewEnumAddToDevice),@(IMBToolBarViewEnumDelete)]];
            path = [[NSBundle mainBundle] pathForResource:DetailVCHeaderTitlePhotoNamesPlist ofType:nil];
        }
            break;
        case IMBDevicePageWindowFolderEnumPhotoStream:
        {
            [_toolMenuView setHiddenIndexes:@[@(IMBToolBarViewEnumAddToDevice),@(IMBToolBarViewEnumDelete)]];
            path = [[NSBundle mainBundle] pathForResource:DetailVCHeaderTitlePhotoNamesPlist ofType:nil];
        }
            break;
        case IMBDevicePageWindowFolderEnumPhotoLibrary:
        {
            [_toolMenuView setHiddenIndexes:@[@(IMBToolBarNoData)]];
            path = [[NSBundle mainBundle] pathForResource:DetailVCHeaderTitlePhotoNamesPlist ofType:nil];
        }
            break;
        case IMBDevicePageWindowFolderEnumBook://book
            [_toolMenuView setHiddenIndexes:@[@(IMBToolBarNoData)]];
            path = [[NSBundle mainBundle] pathForResource:DetailVCHeaderTitleBookNamesPlist ofType:nil];
            break;
        case IMBDevicePageWindowFolderEnumMedia://media
        case IMBDevicePageWindowFolderEnumVideo://video
            [_toolMenuView setHiddenIndexes:@[@(IMBToolBarNoData)]];
            path = [[NSBundle mainBundle] pathForResource:IMBDetailVCHeaderTitleTrackNamesPlist ofType:nil];
            break;
        case IMBDevicePageWindowFolderEnumOther://other
            
            break;
        case IMBDevicePageWindowFolderEnumApps://apps
            [_toolMenuView setHiddenIndexes:@[@(IMBToolBarNoData)]];
            path = [[NSBundle mainBundle] pathForResource:DetailVCHeaderTitleAppNamesPlist ofType:nil];
            break;
            
        default:
            
            break;
    }
    
    
    _headerTitleArr = [NSArray arrayWithContentsOfFile:path];
    
    if (_headerTitleArr.count) {
        NSInteger count = _headerTitleArr.count;
        CGFloat cW = _tableView.frame.size.width/count;
        for (NSInteger i = 0; i < count; i++) {
            NSTableHeaderCell *cell = [[NSTableHeaderCell alloc] initTextCell:_headerTitleArr[i]];
            cell.alignment = NSCenterTextAlignment;
            NSTableColumn * column = [[NSTableColumn alloc] initWithIdentifier:_headerTitleArr[i]];
            [column setHeaderCell:cell];
            [column setWidth:cW];
            [_tableView addTableColumn:column];
        }
        
    }
}
- (void)tableViewDoubleClicked:(id)sender
{
    NSInteger rowNumber = [_tableView clickedRow];
    NSLog(@"Double Clicked.%ld ",rowNumber);
    // ...
    
}

#pragma mark -- 通知
- (void)addNotis {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshClicked:) name:IMBDevicePageRefreshClickedNoti object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toMacClicked:) name:IMBDevicePageToMacClickedNoti object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToDeviceClicked:) name:IMBDevicePageAddToDeviceClickedNoti object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteClicked:) name:IMBDevicePageDeleteClickedNoti object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toDeviceClicked:) name:IMBDevicePageToDeviceClickedNoti object:nil];
    
}

- (void)removeNotis {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBDevicePageRefreshClickedNoti object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBDevicePageToMacClickedNoti object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBDevicePageAddToDeviceClickedNoti object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBDevicePageDeleteClickedNoti object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBDevicePageToDeviceClickedNoti object:nil];
}
- (void)refresh:(IMBInformation *)information {
    if (![self canContnue:information]) return;
    
    [self refreshWithInfo:information];
}
//- (void)refreshClicked:(NSNotification *)noti {
//    IMBInformation *information = [noti object];
//    if (![self canContnue:information]) return;
//    
//    [self refreshWithInfo:information];
//}

//- (void)refreshWithInfo:(IMBInformation *)information {
//    if (_folderModel) {
//        _selectedIndexes = nil;
//        [_toolMenuView enableBtns:NO];
//        NSOperationQueue *opQueue = [[[NSOperationQueue alloc] init] autorelease];
//        switch (_folderModel.idx) {
//            case IMBDevicePageWindowFolderEnumPhotoStream:
//            {
//                if (_folderModel.subPhotoArray.count) {
//                    [_folderModel.subPhotoArray removeAllObjects];
//                }
//                
//                [_tableView reloadData];
//                [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStartLoadingAnimNoti object:_iPod.uniqueKey];
//                [opQueue addOperationWithBlock:^{
//                    
//                    [information refreshPhotoStream];
//                    NSArray *photoArr = [information photostreamArray];
//                    if (photoArr.count) {
//                      [_folderModel.subPhotoArray addObjectsFromArray:photoArr];
//                    }
//                    
//                    dispatch_sync(dispatch_get_main_queue(), ^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:_iPod.uniqueKey];
//                        [_tableView reloadData];
//                        [_toolMenuView enableBtns:YES];
//                    });
//                    
//                }];
//            }
//                break;
//            case IMBDevicePageWindowFolderEnumPhotoLibrary:
//            {
//                if (_folderModel.subPhotoArray.count) {
//                    [_folderModel.subPhotoArray removeAllObjects];
//                }
//                [_tableView reloadData];
//                [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStartLoadingAnimNoti object:_iPod.uniqueKey];
//                [opQueue addOperationWithBlock:^{
//                    
//                    [information refreshPhotoLibrary];
//                    NSArray *photoArr = [information photolibraryArray];
//                    [_folderModel.subPhotoArray addObjectsFromArray:photoArr];
//                    dispatch_sync(dispatch_get_main_queue(), ^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:_iPod.uniqueKey];
//                        [_tableView reloadData];
//                        [_toolMenuView enableBtns:YES];
//                    });
//                }];
//            }
//                
//                break;
//            case IMBDevicePageWindowFolderEnumPhotoCameraRoll:
//            {
//                if (_folderModel.subPhotoArray.count) {
//                    [_folderModel.subPhotoArray removeAllObjects];
//                }
//                [_tableView reloadData];
//                [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStartLoadingAnimNoti object:_iPod.uniqueKey];
//                [opQueue addOperationWithBlock:^{
//                    
//                    [information refreshCameraRoll];
//                    [information refreshVideoAlbum];
//                    NSMutableArray *cameraRoll = [[NSMutableArray alloc] init];
//                    [cameraRoll addObjectsFromArray:[information camerarollArray] ? [information camerarollArray] : [NSArray array]];
//                    [cameraRoll addObjectsFromArray:[information photovideoArray] ? [information photovideoArray] : [NSArray array]];
//                    [cameraRoll addObjectsFromArray:[information photovideoArray] ? [information photoSelfiesArray] : [NSArray array]];
//                    [cameraRoll addObjectsFromArray:[information photovideoArray] ? [information screenshotArray] : [NSArray array]];
//                    [cameraRoll addObjectsFromArray:[information photovideoArray] ? [information slowMoveArray] : [NSArray array]];
//                    [cameraRoll addObjectsFromArray:[information photovideoArray] ? [information timelapseArray] : [NSArray array]];
//                    [cameraRoll addObjectsFromArray:[information photovideoArray] ? [information panoramasArray] : [NSArray array]];
//                    
//                    [_folderModel.subPhotoArray addObjectsFromArray:cameraRoll];
//                    [cameraRoll release];
//                    cameraRoll = nil;
//                    dispatch_sync(dispatch_get_main_queue(), ^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:_iPod.uniqueKey];
//                        [_tableView reloadData];
//                        [_toolMenuView enableBtns:YES];
//                    });
//                }];
//            }
//                
//                break;
//            case IMBDevicePageWindowFolderEnumBook:
//            {
//                if (_folderModel.booksArray.count) {
//                    _folderModel.booksArray = nil;
//                }
//                [_tableView reloadData];
//                [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStartLoadingAnimNoti object:_iPod.uniqueKey];
//                [opQueue addOperationWithBlock:^{
//                    [information loadiBook];
//                    
//                    NSArray *ibooks = [[information allBooksArray] retain];
//                    _folderModel.booksArray = [ibooks retain];
//                    
//                    [ibooks release];
//                    ibooks = nil;
//                    
//                    dispatch_sync(dispatch_get_main_queue(), ^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:_iPod.uniqueKey];
//                        [_tableView reloadData];
//                        [_toolMenuView enableBtns:YES];
//                    });
//                    
//                }];
//            }
//                
//                break;
//                
//            case IMBDevicePageWindowFolderEnumMedia:
//            {
//                if (_folderModel.trackArray.count) {
//                    _folderModel.trackArray = nil;
//                }
//                [_tableView reloadData];
//                [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStartLoadingAnimNoti object:_iPod.uniqueKey];
//                [opQueue addOperationWithBlock:^{
//                    [information refreshMedia];
//                    NSArray *audioArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:(int)Audio],
//                                           nil];
//                    
//                    NSArray *trackArray = [[NSMutableArray alloc] initWithArray:[information getTrackArrayByMediaTypes:audioArray]];
//                    
//                    _folderModel.trackArray = [trackArray retain];
//                    
//                    [trackArray release];
//                    trackArray = nil;
//                    
//                    dispatch_sync(dispatch_get_main_queue(), ^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:_iPod.uniqueKey];
//                        [_tableView reloadData];
//                        [_toolMenuView enableBtns:YES];
//                    });
//                    
//                }];
//            }
//                
//                break;
//            case IMBDevicePageWindowFolderEnumApps:
//            {
//                if (_folderModel.appsArray.count) {
//                    _folderModel.appsArray = nil;
//                }
//                [_tableView reloadData];
//                [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStartLoadingAnimNoti object:_iPod.uniqueKey];
//                [opQueue addOperationWithBlock:^{
//                    IMBApplicationManager *appManager = [[information applicationManager] retain];
//                    [appManager loadAppArray];
//                    NSArray *appArray = [appManager appEntityArray];
//                    _folderModel.appsArray = [appArray retain];
//                    
//                    [appArray release];
//                    appArray = nil;
//                    
//                    [appManager release];
//                    appManager = nil;
//                    
//                    dispatch_sync(dispatch_get_main_queue(), ^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:_iPod.uniqueKey];
//                        [_tableView reloadData];
//                        [_toolMenuView enableBtns:YES];
//                    });
//                    
//                }];
//            }
//                
//                break;
//            case IMBDevicePageWindowFolderEnumVideo:
//            {
//                if (_folderModel.trackArray.count) {
//                    _folderModel.trackArray = nil;
//                }
//                [_tableView reloadData];
//                [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStartLoadingAnimNoti object:_iPod.uniqueKey];
//                [opQueue addOperationWithBlock:^{
//                    [information refreshMedia];
//                    NSArray *videoArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:(int)Video],
//                                           [NSNumber numberWithInt:(int)TVShow],
//                                           [NSNumber numberWithInt:(int)MusicVideo],
//                                           [NSNumber numberWithInt:(int)HomeVideo],
//                                           nil];
//                    NSArray *trackArray = [[NSMutableArray alloc] initWithArray:[information getTrackArrayByMediaTypes:videoArray]];
//                    _folderModel.trackArray = [trackArray retain];
//                    [trackArray release];
//                    trackArray = nil;
//                    
//                    dispatch_sync(dispatch_get_main_queue(), ^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:_iPod.uniqueKey];
//                        [_tableView reloadData];
//                        [_toolMenuView enableBtns:YES];
//                    });
//                    
//                }];
//            }
//                
//                break;
//                
//            default:
//                break;
//        }
//    }
//    
//}

- (void)toMac:(IMBInformation *)information {
    if (![self canContnue:information]) return;
    
    _isToMac = YES;
    switch (_folderModel.idx) {
        case IMBDevicePageWindowFolderEnumPhotoStream:
        {
            _category = Category_PhotoStream;
            [self toMacSettingsWithInformation:information];
        }
            break;
        case IMBDevicePageWindowFolderEnumPhotoLibrary:
        {
            _category = Category_PhotoLibrary;
            [self toMacSettingsWithInformation:information];
        }
            break;
        case IMBDevicePageWindowFolderEnumPhotoCameraRoll:
        {
            _category = Category_CameraRoll;
            [self toMacSettingsWithInformation:information];
        }
            break;
        case IMBDevicePageWindowFolderEnumBook:
        {
            _category = Category_iBooks;
            [self toMacSettingsWithInformation:information];
        }
            break;
        case IMBDevicePageWindowFolderEnumMedia:
        {
            _category = Category_Music;
            [self toMacSettingsWithInformation:information];
        }
            break;
        case IMBDevicePageWindowFolderEnumApps:
        {
            _category = Category_Applications;
            [self toMacSettingsWithInformation:information];
            
        }
            break;
        case IMBDevicePageWindowFolderEnumVideo:
        {
            _category = Category_Movies;
            [self toMacSettingsWithInformation:information];
            
        }
            break;
            
        default:
            break;
    }
}
//- (void)toMacClicked:(NSNotification *)noti {
//    IMBInformation *information = [noti object];
//    if (![self canContnue:information]) return;
//    
//    _isToMac = YES;
//    switch (_folderModel.idx) {
//        case IMBDevicePageWindowFolderEnumPhotoStream:
//        {
//            _category = Category_PhotoStream;
//            [self toMacSettingsWithInformation:information];
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumPhotoLibrary:
//        {
//            _category = Category_PhotoLibrary;
//            [self toMacSettingsWithInformation:information];
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumPhotoCameraRoll:
//        {
//            _category = Category_CameraRoll;
//            [self toMacSettingsWithInformation:information];
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumBook:
//        {
//            _category = Category_iBooks;
//            [self toMacSettingsWithInformation:information];
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumMedia:
//        {
//            _category = Category_Music;
//            [self toMacSettingsWithInformation:information];
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumApps:
//        {
//            _category = Category_Applications;
//            [self toMacSettingsWithInformation:information];
//            
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumVideo:
//        {
//            _category = Category_Movies;
//            [self toMacSettingsWithInformation:information];
//            
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//    
//
//    
//}
//
//- (void)toMacSettingsWithInformation:(IMBInformation *)information {
//    if (!_selectedIndexes || _selectedIndexes.count == 0) {
//        NSAlert *alert = [NSAlert alertWithMessageText:@"Please select item" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please select item"];
//        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
//            //            if (returnCode == 1) {
//            //                IMBFLog(@"clicked OK button");
//            //            }
//        }];
//    }else {
//        if (_category == Category_Applications) {
//            if ([_iPod.deviceInfo.getDeviceFloatVersionNumber isVersionMajorEqual:@"8.3"]) {
//                NSAlert *alert = [NSAlert alertWithMessageText:@"Warning" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Your device is running iOS 8.3 or higher version, which has disabled this feature in iOS Files."];
//                [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
//                    if (returnCode == 1) {
//                        
//                    }
//                }];
//                return;
//            }
//        }
//        NSOpenPanel *openPanel = [NSOpenPanel openPanel];
//        [openPanel setCanChooseFiles:NO];
//        [openPanel setCanChooseDirectories:YES];
//        [openPanel setCanCreateDirectories:YES];
//        //                [openPanel setAllowsOtherFileTypes:NO];
//        [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
//            if (NSModalResponseOK == result) {
//                NSOperationQueue *opQueue = [[[NSOperationQueue alloc] init] autorelease];
//                [opQueue addOperationWithBlock:^{
//                    NSString *path = [[openPanel URL] path];
//                    NSString *filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:_category]];
//                    NSMutableArray *exportArray = [NSMutableArray array];
//                    switch (_category) {
//                        case Category_CameraRoll:
//                        case Category_PhotoStream:
//                        case Category_PhotoLibrary:
//                        {
//                            [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                                IMBPhotoEntity *photo = [[_folderModel.subPhotoArray objectAtIndex:idx] retain];
//                                [exportArray addObject:photo];
//                                [photo release];
//                                
//                                
//                            }];
//                            _baseTransfer = [[IMBPhotoFileExport alloc] initWithIPodkey:information.ipod.uniqueKey exportTracks:exportArray exportFolder:filePath withDelegate:self];
//                            [(IMBPhotoFileExport *)_baseTransfer setExportType:1];
//                        }
//                            break;
//                        case Category_iBooks:
//                        {
//                            [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                                IMBBookEntity *book = [[_folderModel.booksArray objectAtIndex:idx] retain];
//                                [exportArray addObject:book];
//                                [book release];
//                            }];
//                            _baseTransfer = [[IMBiBooksExport alloc] initWithIPodkey:information.ipod.uniqueKey exportTracks:exportArray exportFolder:filePath withDelegate:self];
//                            
//                        }
//                            break;
//                        case Category_Music:
//                        {
//                            [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                                IMBTrack *track = [[_folderModel.trackArray objectAtIndex:idx] retain];
//                                [exportArray addObject:track];
//                                [track release];
//                            }];
//                            
//                            _baseTransfer = [[IMBMediaFileExport alloc] initWithIPodkey:information.ipod.uniqueKey exportTracks:exportArray exportFolder:filePath withDelegate:self];
//                            
//                        }
//                            break;
//                        case Category_Applications:
//                        {
//                            
//                            [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                                IMBAppEntity *app = [[_folderModel.appsArray objectAtIndex:idx] retain];
//                                [exportArray addObject:app];
//                                [app release];
//                            }];
//                            
//                            _baseTransfer = [[IMBAppExport alloc] initWithIPodkey:information.ipod.uniqueKey exportTracks:exportArray exportFolder:filePath withDelegate:self];
//                            
//                        }
//                            break;
//                        case Category_Movies:
//                        {
//                            
//                            [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                                IMBTrack *track = [[_folderModel.trackArray objectAtIndex:idx] retain];
//                                [exportArray addObject:track];
//                                [track release];
//                            }];
//                            _baseTransfer = [[IMBMediaFileExport alloc] initWithIPodkey:information.ipod.uniqueKey exportTracks:exportArray exportFolder:filePath withDelegate:self];
//                            
//                        }
//                            break;
//                        default:
//                            break;
//                            
//                    }
//                
//                 
//                    [_baseTransfer startTransfer];
//                }];
//            }
//        }];
//    }
//}

- (void)addToDevice:(IMBInformation *)information {
    if (![self canContnue:information]) return;
    
    _isToMac = NO;
    switch (_folderModel.idx) {
        case IMBDevicePageWindowFolderEnumPhotoLibrary:
        {
            _category = Category_PhotoLibrary;
            [self addToDeviceSettingsWithInformation:information];
        }
            break;
        case IMBDevicePageWindowFolderEnumBook:
        {
            _category = Category_iBooks;
            [self addToDeviceSettingsWithInformation:information];
            
        }
            break;
        case IMBDevicePageWindowFolderEnumMedia:
        {
            _category = Category_Music;
            [self addToDeviceSettingsWithInformation:information];
            
        }
            break;
        case IMBDevicePageWindowFolderEnumApps:
        {
            _category = Category_Applications;
            [self addToDeviceSettingsWithInformation:information];
            
        }
            break;
        case IMBDevicePageWindowFolderEnumVideo:
        {
            _category = Category_Movies;
            [self addToDeviceSettingsWithInformation:information];
            
        }
            break;
            
        default:
            break;
    }

}
//- (void)addToDeviceClicked:(NSNotification *)noti {
//    IMBInformation *information = [noti object];
//    if (![self canContnue:information]) return;
//    
//    _isToMac = NO;
//    switch (_folderModel.idx) {
//        case IMBDevicePageWindowFolderEnumPhotoLibrary:
//        {
//            _category = Category_PhotoLibrary;
//            [self addToDeviceSettingsWithInformation:information];
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumBook:
//        {
//            _category = Category_iBooks;
//            [self addToDeviceSettingsWithInformation:information];
//            
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumMedia:
//        {
//            _category = Category_Music;
//            [self addToDeviceSettingsWithInformation:information];
//            
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumApps:
//        {
//            _category = Category_Applications;
//            [self addToDeviceSettingsWithInformation:information];
//            
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumVideo:
//        {
//            _category = Category_Movies;
//            [self addToDeviceSettingsWithInformation:information];
//            
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//}

- (void)addToDeviceSettingsWithInformation:(IMBInformation *)information {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanCreateDirectories:NO];
    [openPanel setAllowsMultipleSelection:YES];
    
    switch (_category) {
        case Category_PhotoLibrary:
        {
            [openPanel setAllowedFileTypes:@[@"png",@"jpg",@"gif",@"bmp",@"tiff",@"jpeg"]];
        }
            break;
        case Category_iBooks:
        {
            [openPanel setAllowedFileTypes:@[@"pdf",@"epub"]];
        }
            break;
        case Category_Music:
        {
            [openPanel setAllowedFileTypes:@[@"mp3",@"m4a",@"wma",@"wav",@"rm",@"mdi",@"m4r",@"m4b",@"m4p",@"flac",@"amr",@"ogg",@"ac3",@"ape",@"aac",@"mka"]];
        }
            break;
        case Category_Applications:
        {
            [openPanel setAllowedFileTypes:@[@"ipa"]];
        }
            break;
        case Category_Movies:
        {
            [openPanel setAllowedFileTypes:@[@"mp4",@"m4v",@"mov",@"wmv",@"rmvb",@"avi",@"flv",@"rm",@"3gp",@"mpg",@"webm"]];
        }
            break;
        default:
            break;
    }
    
    [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (NSModalResponseOK == result) {
            
            NSOperationQueue *opQueue = [[[NSOperationQueue alloc] init] autorelease];
            [opQueue addOperationWithBlock:^{
                NSMutableArray *paths = [NSMutableArray array];
                for (NSURL *urlPath in openPanel.URLs) {
                    [paths addObject:urlPath.path];
                }
                
                
                switch (_category) {
                    case Category_PhotoLibrary:
                    {
                        IMBPhotoEntity *albumEntity = [[IMBPhotoEntity alloc] init];
                        albumEntity.albumZpk = 46;
                        albumEntity.photoCounts = (int)[[information photolibraryArray] count];
                        albumEntity.albumKind = 1551;
                        albumEntity.albumTitle = @"From iOSFiles";
                        albumEntity.albumType = CreateAlbum;
                        albumEntity.photoType = CommonType;
                        _baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:information.ipod.uniqueKey importFiles:paths CategoryNodesEnum:_category photoAlbum:albumEntity playlistID:0 delegate:self];
                        
                        [albumEntity release];
                        albumEntity = nil;
                    }
                        break;
                    case Category_iBooks:
                    case Category_Music:
                    case Category_Applications:
                    case Category_Movies:
                    {
                        _baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:information.ipod.uniqueKey importFiles:paths CategoryNodesEnum:_category photoAlbum:nil playlistID:0 delegate:self];
                    }
                        break;
                    default:
                        break;
                }
                
                [_baseTransfer startTransfer];
                [paths release];
                paths = nil;
                
            }];
        }
    }];
}

- (void)deleteItem:(IMBInformation *)information {
    if (![self canContnue:information]) return;
    
    _isToMac = NO;
    switch (_folderModel.idx) {
        case IMBDevicePageWindowFolderEnumPhotoLibrary:
        {
            _category = Category_PhotoLibrary;
            [self deleteSettingsWithInformation:[information.ipod retain]];
        }
            break;
        case IMBDevicePageWindowFolderEnumPhotoCameraRoll:
            
        {
            _category = Category_CameraRoll;
            [self deleteSettingsWithInformation:[information.ipod retain]];
        }
            break;
        case IMBDevicePageWindowFolderEnumBook:
        {
            _category = Category_iBooks;
            [self deleteSettingsWithInformation:[information.ipod retain]];
        }
            break;
        case IMBDevicePageWindowFolderEnumApps:
        {
            _category = Category_Applications;
            [self deleteSettingsWithInformation:[information.ipod retain]];
        }
            break;
        case IMBDevicePageWindowFolderEnumMedia:
        {
            _category = Category_Music;
            [self deleteSettingsWithInformation:[information.ipod retain]];
        }
            break;
        case IMBDevicePageWindowFolderEnumVideo:
        {
            _category = Category_Movies;
            [self deleteSettingsWithInformation:[information.ipod retain]];
        }
            break;
            
        default:
            break;
    }

}
//- (void)deleteClicked:(NSNotification *)noti {
//    IMBInformation *information = [noti object];
//    if (![self canContnue:information]) return;
//    
//    _isToMac = NO;
//    switch (_folderModel.idx) {
//        case IMBDevicePageWindowFolderEnumPhotoLibrary:
//        {
//            _category = Category_PhotoLibrary;
//            [self deleteSettingsWithInformation:[information.ipod retain]];
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumPhotoCameraRoll:
//            
//        {
//            _category = Category_CameraRoll;
//            [self deleteSettingsWithInformation:[information.ipod retain]];
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumBook:
//        {
//            _category = Category_iBooks;
//            [self deleteSettingsWithInformation:[information.ipod retain]];
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumApps:
//        {
//            _category = Category_Applications;
//            [self deleteSettingsWithInformation:[information.ipod retain]];
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumMedia:
//        {
//            _category = Category_Music;
//            [self deleteSettingsWithInformation:[information.ipod retain]];
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumVideo:
//        {
//            _category = Category_Movies;
//            [self deleteSettingsWithInformation:[information.ipod retain]];
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//}

//- (void)deleteSettingsWithInformation:(IMBiPod *)iPod {
//    if (!_selectedIndexes || _selectedIndexes.count == 0) {
//        NSAlert *alert = [NSAlert alertWithMessageText:@"Please select item" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please select item"];
//        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
//            
//        }];
//    }else {
//        NSAlert *alert = [NSAlert alertWithMessageText:@"Warning" defaultButton:@"OK" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"Are U Sure To Delete?"];
//        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
//            if (returnCode == 1) {
//                IMBFLog(@"clicked OK button");
//                NSOperationQueue *opQueue = [[[NSOperationQueue alloc] init] autorelease];
//                [opQueue addOperationWithBlock:^{
//                    
//                    NSMutableArray *delArray = [[NSMutableArray alloc] init];
//                    switch (_category) {
//                            case Category_CameraRoll:
//                            return;
//                            break;
//                        case Category_PhotoLibrary:
//                        {
//                            [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                                IMBPhotoEntity *photo = [[_folderModel.subPhotoArray objectAtIndex:idx] retain];
//                                IMBTrack *track = [[IMBTrack alloc] init];
//                                track.photoZpk = photo.photoZpk;
//                                [track setMediaType:Photo];
//                                [delArray addObject:track];
//                                [track release];
//                                [photo release];
//                            }];
//                        }
//                            break;
//                        case Category_iBooks:
//                        {
//                            [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                                IMBBookEntity *bookEntity = [[_folderModel.booksArray objectAtIndex:idx] retain];
//                                IMBTrack *newTrack = [[IMBTrack alloc] init];
//                                int64_t dbid = 0;
//                                if ([self isUnusualPersistentID:bookEntity.bookID]) {
//                                    [newTrack setIsUnusual:YES];
//                                    [newTrack setHexPersistentID:bookEntity.bookID];
//                                }else{
//                                    dbid = [bookEntity.bookID longLongValue];
//                                }
//                                [newTrack setArtist:bookEntity.author];
//                                [newTrack setGenre:bookEntity.genre];
//                                
//                                NSString *path = [NSString stringWithFormat:@"Books/%@",[bookEntity.path lastPathComponent]];
//                                
//                                [newTrack setAlbumArtist:bookEntity.album];
//                                [newTrack setTitle:bookEntity.bookName.length == 0 ? @"0":bookEntity.bookName];
//                                [newTrack setFilePath:path];
//                                [newTrack setIsVideo:NO];
//                                NSString *publisherUniqueID = bookEntity.publisherUniqueID;
//                                NSString *packageHash = bookEntity.packageHash;
//                                MediaTypeEnum type;
//                                if ([[path pathExtension].lowercaseString isEqualToString:@"epub"]) {
//                                    type = Books;
//                                    [newTrack setFileSize:(uint)[[iPod fileSystem] getFolderSize:[[[iPod fileSystem] driveLetter] stringByAppendingPathComponent:[NSString stringWithFormat:@"Books/%@",[path lastPathComponent]]]]];
//                                }
//                                else{
//                                    type = PDFBooks;
//                                    [newTrack setFileSize:(uint)[[iPod fileSystem] getFileLength:[[[iPod fileSystem] driveLetter] stringByAppendingPathComponent:[NSString stringWithFormat:@"Books/%@",[path lastPathComponent]]]]];
//                                }
//                                [newTrack setMediaType:type];
//                                newTrack.dbID = dbid;
//                                newTrack.uuid = publisherUniqueID;
//                                newTrack.mediaType = type;
//                                newTrack.packageHash = packageHash;
//                                [delArray addObject:newTrack];
//                                [newTrack release];
//                                newTrack = nil;
//                            }];
//                        }
//                            break;
//                        case Category_Applications:
//                        {
//                            [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                                IMBAppEntity *app = [[_folderModel.appsArray objectAtIndex:idx] retain];
//                                [delArray addObject:app];
//                                [app release];
//                                app = nil;
//                            }];
//                            dispatch_sync(dispatch_get_main_queue(), ^{
//                                [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStartLoadingAnimNoti object:_iPod.uniqueKey];
//                            });
//                            IMBDeleteApps *procedure = [[IMBDeleteApps alloc] initWithIPod:iPod deleteArray:delArray];
//                            [procedure startDelete];
//                            [procedure release];
//                            
//                            [self setCompletionWithSuccessCount:(int)delArray.count totalCount:(int)delArray.count title:@"Delete Success"];
//                            
//                            return;
//                        }
//                            break;
//                        case Category_Music:
//                        {
//                            [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                                IMBTrack *track = [[_folderModel.trackArray objectAtIndex:idx] retain];
//                                [delArray addObject:track];
//                                [track release];
//                                track = nil;
//                            }];
//                        }
//                            break;
//                        case Category_Movies:
//                        {
//                            [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                                IMBTrack *track = [[_folderModel.trackArray objectAtIndex:idx] retain];
//                                [delArray addObject:track];
//                                [track release];
//                                track = nil;
//                            }];
//                        }
//                            break;
//                            
//                        default:
//                            break;
//                    }
//                    
//                    dispatch_sync(dispatch_get_main_queue(), ^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStartLoadingAnimNoti object:_iPod.uniqueKey];
//                    });
//                    IMBDeleteTrack *deleteTrack = [[IMBDeleteTrack alloc] initWithIPod:iPod deleteArray:delArray Category:_category];
//                    [deleteTrack setDelegate:self];
//                    [deleteTrack startDelete];
//                    [deleteTrack release];
//                    [delArray release];
//                    delArray = nil;
//                    
//                }];
//            }
//            
//        }];
//        
//    }
//    
//}

- (void)toDevice:(IMBInformation *)information {
    if (![self canContnue:information]) return;
    
    _isToMac = YES;
    if (!_selectedIndexes || _selectedIndexes.count == 0) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Please select item" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please select item"];
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        return;
    }
    switch (_folderModel.idx) {
        case IMBDevicePageWindowFolderEnumPhotoStream:
        {
            _category = Category_PhotoStream;
            [self toDeviceSettingsWithInformation:information];
        }
            break;
        case IMBDevicePageWindowFolderEnumPhotoLibrary:
        {
            _category = Category_PhotoLibrary;
            [self toDeviceSettingsWithInformation:information];
        }
            break;
        case IMBDevicePageWindowFolderEnumPhotoCameraRoll:
        {
            _category = Category_CameraRoll;
            [self toDeviceSettingsWithInformation:information];
        }
            break;
        case IMBDevicePageWindowFolderEnumBook:
        {
            _category = Category_iBooks;
            [self toDeviceSettingsWithInformation:information];
        }
            break;
        case IMBDevicePageWindowFolderEnumApps:
        {
            _category = Category_Applications;
            [self toDeviceSettingsWithInformation:information];
        }
            break;
        case IMBDevicePageWindowFolderEnumMedia:
        {
            _category = Category_Music;
            [self toDeviceSettingsWithInformation:information];
        }
            break;
        case IMBDevicePageWindowFolderEnumVideo:
        {
            _category = Category_Movies;
            [self toDeviceSettingsWithInformation:information];
        }
            break;
            
        default:
            break;
    }

}
//- (void)toDeviceClicked:(NSNotification *)noti {
//    IMBInformation *information = [noti object];
//    if (![self canContnue:information]) return;
//    
//    _isToMac = NO;
//    switch (_folderModel.idx) {
//        case IMBDevicePageWindowFolderEnumPhotoStream:
//        {
//            _category = Category_PhotoStream;
//            [self toDeviceSettingsWithInformation:information];
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumPhotoLibrary:
//        {
//            _category = Category_PhotoLibrary;
//            [self toDeviceSettingsWithInformation:information];
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumPhotoCameraRoll:
//        {
//            _category = Category_CameraRoll;
//            [self toDeviceSettingsWithInformation:information];
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumBook:
//        {
//            _category = Category_iBooks;
//            [self toDeviceSettingsWithInformation:information];
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumApps:
//        {
//            _category = Category_Applications;
//            [self toDeviceSettingsWithInformation:information];
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumMedia:
//        {
//            _category = Category_Music;
//            [self toDeviceSettingsWithInformation:information];
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumVideo:
//        {
//            _category = Category_Movies;
//            [self toDeviceSettingsWithInformation:information];
//        }
//            break;
//            
//        default:
//            break;
//    }
//}

//- (void)toDeviceSettingsWithInformation:(IMBInformation *)information {
//    IMBDeviceConnection *conn = [IMBDeviceConnection singleton];
//    IMBiPod *desIpod = nil;
//    for (IMBiPod *ipod in conn.alliPods) {
//        if (![ipod.uniqueKey isEqualToString:information.ipod.uniqueKey]) {
//            desIpod = ipod;
//            break;
//        }
//    }
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSMutableArray *selectAry = [NSMutableArray array];
//        IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
//        model.categoryNodes = _category;
//        
//        switch (_category) {
//            case Category_PhotoStream:
//            case Category_PhotoLibrary:
//            case Category_CameraRoll:
//            {
//                if (desIpod.photoLoadFinished) {
//                    [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                        IMBPhotoEntity *pe = [_folderModel.subPhotoArray objectAtIndex:idx];
//                        [selectAry addObject:pe];
//                    }];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_current_queue(), ^{
//                        _baseTransfer = [[IMBBetweenDeviceHandler alloc] initWithSelectedArray:selectAry categoryModel:model srcIpodKey:information.ipod.uniqueKey desIpodKey:desIpod.uniqueKey withPlaylistArray:[NSArray array] albumEntity:nil Delegate:self];
//                        [_baseTransfer startTransfer];
//                    });
//                    
//                }else {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSAlert *alert = [NSAlert alertWithMessageText:@"Warning!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please connect at least 2 devices"];
//                        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
//                            
//                        }];
//                    });
//                }
//                
//            }
//                break;
//            case Category_iBooks:
//            {
//                if (desIpod.bookLoadFinished) {
//                    [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                        IMBBookEntity *be = [_folderModel.booksArray objectAtIndex:idx];
////                        be.path = [NSString stringWithFormat:@"%@.pdf",be.bookName];
//                        [selectAry addObject:be];
//                    }];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_current_queue(), ^{
//                        _baseTransfer = [[IMBBetweenDeviceHandler alloc] initWithSelectedArray:selectAry categoryModel:model srcIpodKey:information.ipod.uniqueKey desIpodKey:desIpod.uniqueKey withPlaylistArray:[NSArray array] albumEntity:nil Delegate:self];
//                        [_baseTransfer startTransfer];
////                        _baseTransfer = [[IMBBookToDevice alloc] initWithSrcIpod:information.ipod desIpod:desIpod bookList:selectAry Delegate:self];
////                        if ([(IMBBookToDevice *)_baseTransfer prepareData]) {
////                            [_baseTransfer startTransfer];
////                        }
//                    });
//                    
//                }else {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSAlert *alert = [NSAlert alertWithMessageText:@"Warning!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please connect at least 2 devices"];
//                        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
//                            
//                        }];
//                    });
//                }
//                
//            }
//                break;
//            case Category_Applications:
//            {
//                if (desIpod.appsLoadFinished) {
//                    [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                        //TODO
//                        IMBAppEntity *be = [_folderModel.appsArray objectAtIndex:idx];
//                        [selectAry addObject:be];
//                    }];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_current_queue(), ^{
//                        _baseTransfer = [[IMBBetweenDeviceHandler alloc] initWithSelectedArray:selectAry categoryModel:model srcIpodKey:information.ipod.uniqueKey desIpodKey:desIpod.uniqueKey withPlaylistArray:[NSArray array] albumEntity:nil Delegate:self];
//                        [_baseTransfer startTransfer];
//                    });
//                    
//                }else {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSAlert *alert = [NSAlert alertWithMessageText:@"Warning!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please connect at least 2 devices"];
//                        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
//                            
//                        }];
//                    });
//                }
//                
//            }
//                break;
//            case Category_Music:
//            {
//                if (desIpod.mediaLoadFinished) {
//                    [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                        //TODO
//                        IMBTrack *track = [_folderModel.trackArray objectAtIndex:idx];
//                        [selectAry addObject:track];
//                    }];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_current_queue(), ^{
//                        _baseTransfer = [[IMBBetweenDeviceHandler alloc] initWithSelectedArray:selectAry categoryModel:model srcIpodKey:information.ipod.uniqueKey desIpodKey:desIpod.uniqueKey withPlaylistArray:[NSArray array] albumEntity:nil Delegate:self];
//                        [_baseTransfer startTransfer];
//                    });
//                    
//                }else {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSAlert *alert = [NSAlert alertWithMessageText:@"Warning!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please connect at least 2 devices"];
//                        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
//                            
//                        }];
//                    });
//                }
//                
//            }
//                break;
//            case Category_Movies:
//            {
//                if (desIpod.videoLoadFinished) {
//                    [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                        //TODO
//                        IMBTrack *track = [_folderModel.trackArray objectAtIndex:idx];
//                        [selectAry addObject:track];
//                    }];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_current_queue(), ^{
//                        _baseTransfer = [[IMBBetweenDeviceHandler alloc] initWithSelectedArray:selectAry categoryModel:model srcIpodKey:information.ipod.uniqueKey desIpodKey:desIpod.uniqueKey withPlaylistArray:[NSArray array] albumEntity:nil Delegate:self];
//                        [_baseTransfer startTransfer];
//                    });
//                    
//                }else {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSAlert *alert = [NSAlert alertWithMessageText:@"Warning!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please connect at least 2 devices"];
//                        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
//                            
//                        }];
//                    });
//                }
//                
//            }
//                break;
//            default:
//                break;
//        }
//        
//        [model release];
//        model = nil;
//    });
//    
//    
//}



- (BOOL)isUnusualPersistentID:(NSString *)persistentID{
    for (int i = 0; i < persistentID.length; i ++) {
        unichar charcode = [persistentID characterAtIndex:i];
        if ((charcode > 'a' && charcode < 'z') || (charcode >= 'A' && charcode <= 'Z')) {
            return YES;
        }
    }
    return NO;
}
#pragma mark -- NSTableViewDelegate,NSTableViewDataSource
#pragma mark -- drag and drop
- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    return YES;
}

- (BOOL)canDragRowsWithIndexes:(NSIndexSet *)rowIndexes atPoint:(NSPoint)mouseDownPoint {
    return YES;
}

- (NSImage *)dragImageForRowsWithIndexes:(NSIndexSet *)dragRows tableColumns:(NSArray<NSTableColumn *> *)tableColumns event:(NSEvent *)dragEvent offset:(NSPointPointer)dragImageOffset {
    switch (_folderModel.idx) {
        case IMBDevicePageWindowFolderEnumPhotoCameraRoll:
        case IMBDevicePageWindowFolderEnumPhotoStream:
        case IMBDevicePageWindowFolderEnumPhotoLibrary:
        {
            IMBPhotoEntity *photo = [[_folderModel.subPhotoArray objectAtIndex:dragRows.firstIndex] retain];
            NSImage *img = [photo.image retain];
            [photo release];
            photo = nil;
            return img;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (void)tableView:(NSTableView *)tableView updateDraggingItemsForDrag:(id<NSDraggingInfo>)draggingInfo {
    
}


//拖文件swf进tableview
-(NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation{
    
//    NSPasteboard *pasteBoard = [info draggingPasteboard];
//    
//    if ([[pasteBoard types]containsObject:NSFilenamesPboardType]) {
//        
//        NSString *supportFormat = @"swf"; //拉进来的文件只能为swf格式文件；
//        
//        NSArray *arrayURL = [pasteBoard propertyListForType:NSFilenamesPboardType];//将剪贴板上的url传进一个数组中
//        
//        for ( NSURL *URL in arrayURL) { //遍历
//            
//            if ([supportFormat containsString:[URL pathExtension]]) {
//    
    return NSDragOperationCopy;//是swf文件，高亮状态；
//            }
//        }
//    }
////
//    return NSDragOperationNone;//否则之；
    
}

-(BOOL)tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation{
    
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
//    NSPasteboard *pasteBoard = [info draggingPasteboard];
//    
//    if ([[pasteBoard types] containsObject:NSFilenamesPboardType]) {
//        
//        NSArray *arrayURL = [pasteBoard propertyListForType:NSFilenamesPboardType];
//        
//        for (NSString *strURL in arrayURL) {
//            
//            NSURL *URL = [[NSURL alloc] initWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            
////            [array_swf_url insertObject:URL atIndex:row];//将拉进来的swf格式文件放在array_swf_url可变数组中；
//            
//        }
//        
    return YES;
//    }
//    return NO;
}

- (NSArray *)tableView:(NSTableView *)tableView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination forDraggedRowsWithIndexes:(NSIndexSet *)indexSet {
    NSArray *namesArray = nil;
    //获取目的url
    BOOL iconHide = NO;
//    NSString *url = [dropDestination relativePath];
    //此处调用导出方法
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:indexSet,@"indexSet",url,@"url",tableView,@"tableView", nil];
//    [self performSelector:@selector(delayTableViewdragToMac:) withObject:dic afterDelay:0.1];
    iconHide = YES;
    return namesArray;
}
#pragma mark -- NSTableViewDataSource

//- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
//    
//    if (!_folderModel) return 0;
//    if (_folderModel.idx == IMBDevicePageWindowFolderEnumPhotoCameraRoll || _folderModel.idx == IMBDevicePageWindowFolderEnumPhotoStream || _folderModel.idx == IMBDevicePageWindowFolderEnumPhotoLibrary || _folderModel.idx == IMBDevicePageWindowFolderEnumBook || _folderModel.idx == IMBDevicePageWindowFolderEnumMedia || _folderModel.idx == IMBDevicePageWindowFolderEnumVideo || _folderModel.idx == IMBDevicePageWindowFolderEnumApps) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageShowToolbarNoti object:_iPod.uniqueKey];
//    }else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageHideToolbarNoti object:_iPod.uniqueKey];
//    }
//    switch (_folderModel.idx) {
//        case IMBDevicePageWindowFolderEnumPhotoCameraRoll:
//        case IMBDevicePageWindowFolderEnumPhotoStream:
//        case IMBDevicePageWindowFolderEnumPhotoLibrary:
//            return _folderModel.subPhotoArray.count;
//            break;
//        case IMBDevicePageWindowFolderEnumBook://book
//            return _folderModel.booksArray.count;
//            break;
//        case IMBDevicePageWindowFolderEnumMedia://media
//        case IMBDevicePageWindowFolderEnumVideo://video
//            return _folderModel.trackArray.count;
//        case IMBDevicePageWindowFolderEnumOther://other
//            return 0;
//            break;
//        case IMBDevicePageWindowFolderEnumApps://apps
//            return _folderModel.appsArray.count;
//            break;
//            
//        default:
//            return 0;
//            break;
//    }
//}




- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return rowH;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    return NO;
}
- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
//    _selectedIndexes = nil;
    
}
- (nullable NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row  {
    NSCell *cell = [tableColumn dataCellForRow:row];
    cell.alignment = NSCenterTextAlignment;
    return cell;
}
- (NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes {
    switch (_folderModel.idx) {
        case IMBDevicePageWindowFolderEnumPhotoStream:
        case IMBDevicePageWindowFolderEnumPhotoLibrary:
        case IMBDevicePageWindowFolderEnumPhotoCameraRoll:
        case IMBDevicePageWindowFolderEnumBook:
        case IMBDevicePageWindowFolderEnumMedia:
        case IMBDevicePageWindowFolderEnumVideo:
        case IMBDevicePageWindowFolderEnumApps:
        {
            _selectedIndexes = [proposedSelectionIndexes retain];
        }
            break;
            
        default:
            break;
    }
    
    return proposedSelectionIndexes;
}


//- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//    if (!_folderModel) return nil;
//    NSString *strIdt = [tableColumn identifier];
//    NSTableCellView *aView = [tableView makeViewWithIdentifier:strIdt owner:self];
//    if (!aView)
//        aView = [[NSTableCellView alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, rowH)];
//    else
//        for (NSView *view in aView.subviews)[view removeFromSuperview];
//    NSTextField *textField = [[NSTextField alloc] initWithFrame:CGRectMake(0, labelY, tableColumn.width, rowH - 2*labelY)];
//    
//    textField.font = [NSFont systemFontOfSize:12.0f];
//    textField.alignment = NSCenterTextAlignment;
//    textField.drawsBackground = NO;
//    textField.bordered = NO;
//    textField.focusRingType = NSFocusRingTypeNone;
//    textField.editable = NO;
//    [aView addSubview:textField];
//    
//    
//    switch (_folderModel.idx) {
//        case IMBDevicePageWindowFolderEnumPhotoCameraRoll:
//        case IMBDevicePageWindowFolderEnumPhotoStream:
//        case IMBDevicePageWindowFolderEnumPhotoLibrary:
//        {
//            IMBPhotoEntity *photo = [_folderModel.subPhotoArray objectAtIndex:row];
//            if ([strIdt isEqualToString:@"Name"]) {
//                textField.stringValue = photo.photoName;
//            }else if ([strIdt isEqualToString:@"Resolution"]) {
//                NSString *resolutionStr = [NSString stringWithFormat:@"%d*%d",photo.photoWidth,photo.photoHeight];
//                textField.stringValue = resolutionStr ? resolutionStr : @"-";
//            }else if ([strIdt isEqualToString:@"Size"]) {
//                textField.stringValue = [StringHelper getFileSizeString:photo.photoSize reserved:2];
//            }
//            
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumBook://book
//        {
//            IMBBookEntity *book = [_folderModel.booksArray objectAtIndex:row];
//            if ([strIdt isEqualToString:@"Name"]) {
//                textField.stringValue = book.bookName;
//            }else if ([strIdt isEqualToString:@"Size"]) {
//                textField.stringValue = [StringHelper getFileSizeString:book.size reserved:2];
//            }
//        }
//            break;
//        case IMBDevicePageWindowFolderEnumMedia://media
//        case IMBDevicePageWindowFolderEnumVideo://video
//        {
//            IMBTrack *track = [_folderModel.trackArray objectAtIndex:row];
//            if ([strIdt isEqualToString:@"Name"]) {
//                textField.stringValue = track.title;
//            }else if ([strIdt isEqualToString:@"Time"]) {
//                textField.stringValue = [[StringHelper getTimeString:track.length] stringByAppendingString:@" "];//@"-";
//            }else if ([strIdt isEqualToString:@"Size"]) {
//                textField.stringValue = [StringHelper getFileSizeString:track.fileSize reserved:2];
//            }
//        }
//        case IMBDevicePageWindowFolderEnumOther://other
//            break;
//        case IMBDevicePageWindowFolderEnumApps://apps
//        {
//            IMBAppEntity *app = [_folderModel.appsArray objectAtIndex:row];
//            if ([strIdt isEqualToString:@"Name"]) {
//                textField.stringValue = app.appName;
//            }else if ([strIdt isEqualToString:@"Version"]) {
//                textField.stringValue = app.version;
//            }else if ([strIdt isEqualToString:@"Size"]) {
//                textField.stringValue = [StringHelper getFileSizeString:app.appSize reserved:2];
//            }else if ([strIdt isEqualToString:@"DocumentSize"]) {
//                textField.stringValue = [StringHelper getFileSizeString:app.documentSize reserved:2];
//            }
//        }
//            break;
//            
//        default:
//            break;
//    }
//    return textField.stringValue;
//}

/*
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (!_folderModel) return nil;
    NSString *strIdt = [tableColumn identifier];
    NSTableCellView *aView = [tableView makeViewWithIdentifier:strIdt owner:self];
    if (!aView)
        aView = [[NSTableCellView alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, rowH)];
    else
        for (NSView *view in aView.subviews)[view removeFromSuperview];
    NSTextField *textField = [[NSTextField alloc] initWithFrame:CGRectMake(0, labelY, tableColumn.width, rowH - 2*labelY)];
    
    textField.font = [NSFont systemFontOfSize:12.0f];
    textField.alignment = NSCenterTextAlignment;
    textField.drawsBackground = NO;
    textField.bordered = NO;
    textField.focusRingType = NSFocusRingTypeNone;
    textField.editable = NO;
    [aView addSubview:textField];
    
    
    
    switch (_folderModel.idx) {
        case IMBDevicePageWindowFolderEnumPhotoCameraRoll:
        case IMBDevicePageWindowFolderEnumPhotoStream:
        case IMBDevicePageWindowFolderEnumPhotoLibrary:
        {
            IMBPhotoEntity *photo = [_folderModel.subPhotoArray objectAtIndex:row];
            if ([strIdt isEqualToString:@"Name"]) {
                textField.stringValue = photo.photoName;
            }else if ([strIdt isEqualToString:@"Resolution"]) {
                NSString *resolutionStr = [NSString stringWithFormat:@"%d*%d",photo.photoWidth,photo.photoHeight];
                textField.stringValue = resolutionStr ? resolutionStr : @"-";
            }else if ([strIdt isEqualToString:@"Size"]) {
                textField.stringValue = [StringHelper getFileSizeString:photo.photoSize reserved:2];
            }
            
        }
            break;
        case IMBDevicePageWindowFolderEnumBook://book
        {
            IMBBookEntity *book = [_folderModel.booksArray objectAtIndex:row];
            if ([strIdt isEqualToString:@"Name"]) {
                textField.stringValue = book.bookName;
            }else if ([strIdt isEqualToString:@"Size"]) {
                textField.stringValue = [StringHelper getFileSizeString:book.size reserved:2];
            }
        }
            break;
        case IMBDevicePageWindowFolderEnumMedia://media
        case IMBDevicePageWindowFolderEnumVideo://video
        {
            IMBTrack *track = [_folderModel.trackArray objectAtIndex:row];
            if ([strIdt isEqualToString:@"Name"]) {
                textField.stringValue = track.title;
            }else if ([strIdt isEqualToString:@"Time"]) {
                textField.stringValue = [[StringHelper getTimeString:track.length] stringByAppendingString:@" "];//@"-";
            }else if ([strIdt isEqualToString:@"Size"]) {
                textField.stringValue = [StringHelper getFileSizeString:track.fileSize reserved:2];
            }
        }
        case IMBDevicePageWindowFolderEnumOther://other
            break;
        case IMBDevicePageWindowFolderEnumApps://apps
        {
            IMBAppEntity *app = [_folderModel.appsArray objectAtIndex:row];
            if ([strIdt isEqualToString:@"Name"]) {
                textField.stringValue = app.appName;
            }else if ([strIdt isEqualToString:@"Version"]) {
                textField.stringValue = app.version;
            }else if ([strIdt isEqualToString:@"Size"]) {
                textField.stringValue = [StringHelper getFileSizeString:app.appSize reserved:2];
            }else if ([strIdt isEqualToString:@"DocumentSize"]) {
                textField.stringValue = [StringHelper getFileSizeString:app.documentSize reserved:2];
            }
        }
            break;
            
        default:
            break;
    }
    return aView;
}
*/
#pragma mark -- 销毁
- (void)dealloc {
    [_folderModel release];
    _folderModel = nil;
    
    if (_iPod) {
        [_iPod release];
        _iPod = nil;
    }
    if (_selectedIndexes) {
        [_selectedIndexes release];
        _selectedIndexes = nil;
    }
    
    [self removeNotis];
    
    [super dealloc];
}


#pragma mark -- transferDelegate
//传输准备进度开始
- (void)transferPrepareFileStart:(NSString *)file {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStartLoadingAnimNoti object:_iPod.uniqueKey];
    });
    
}
//传输准备进度结束
- (void)transferPrepareFileEnd {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:nil];
//        
//    });
}
//传输进度
- (void)transferProgress:(float)progress {
    
}
//当前传输文件的名字或者路径
- (void)transferFile:(NSString *)file {
    
}
//分析进度
- (void)parseProgress:(float)progress {
    
}
//当前分析文件的名字或者路径
- (void)parseFile:(NSString *)file {
    
}
//全部传输成功
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount {
    [self setCompletionWithSuccessCount:successCount totalCount:totalCount title:@"Transfer Completed"];
    
}

//传输出现错误
- (BOOL)transferOccurError:(NSString *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:_iPod.uniqueKey];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSAlert *alert = [NSAlert alertWithMessageText:@"Transfer Error" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Transfer Error"];
            [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                
            }];
        });
    });
    return YES;
}

- (void)transferCurrentSize:(long long)currenSize {
    
}

#pragma mark -- 删除代理方法
- (void)setDeleteProgress:(float)progress withWord:(NSString *)msgStr {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStartLoadingAnimNoti object:nil];
//    });
}

- (void)setDeleteComplete:(int)success totalCount:(int)totalCount {
    [self setCompletionWithSuccessCount:success totalCount:totalCount title:@"Delete Completed"];
}

- (void)setCompletionWithSuccessCount:(int)successCount totalCount:(int)totalCount title:(NSString *)title {
    if (![[IMBDeviceConnection singleton] getiPodByKey:_iPod.uniqueKey]) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:_iPod.uniqueKey];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSAlert *alert = [NSAlert alertWithMessageText:title defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"SuccessCount/TotalCount:%d/%d,we're going to refresh again",successCount,totalCount];
            [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                if (returnCode == 1 && !_isToMac) {
                    IMBInformation *info = [[IMBInformation alloc] initWithiPod:_iPod];
                    [self refreshWithInfo:info];
                    [info release];
                    info = nil;
                }
            }];
        });
        
        
    });
}

#pragma mark -- 开始加载动画
- (void)startLoadingAnim {
    _loadingView = [[LoadingView alloc] initWithFrame:_rootBox.bounds];
    [_rootBox pushView:_loadingView];
    [_loadingView startAnimation];
}

- (void)stopLoadingAnim {
    
    [_loadingView startAnimation];
    [_rootBox popView];
    if (_loadingView) {
        [_loadingView release];
        _loadingView = nil;
    }
    
}

- (BOOL)canContnue:(IMBInformation *)information {
    if (!information || ![information.ipod.uniqueKey isEqualToString:_iPod.uniqueKey]) return NO;
    return YES;
}
@end
