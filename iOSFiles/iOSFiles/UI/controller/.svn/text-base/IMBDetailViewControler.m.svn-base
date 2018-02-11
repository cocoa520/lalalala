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
#import <objc/runtime.h>
#import "LoadingView.h"
#import "IMBDeviceConnection.h"
#import "IMBBetweenDeviceHandler.h"
#import "IMBCategoryInfoModel.h"
#import "IMBToolBarView.h"


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
}
@end

@implementation IMBDetailViewControler

@synthesize folderModel = _folderModel;
@synthesize iPod = _iPod;


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
    
    _rootBox = objc_getAssociatedObject([NSApplication sharedApplication], &kIMBDevicePageRootBoxKey);
    _toolMenuView = objc_getAssociatedObject([NSApplication sharedApplication], &kIMBDevicePageToolBarViewKey);
    
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
            [_toolMenuView setHiddenIndexes:@[@(IMBToolBarViewEnumAddToDevice)]];
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
            [_toolMenuView setHiddenIndexes:@[]];
            path = [[NSBundle mainBundle] pathForResource:DetailVCHeaderTitlePhotoNamesPlist ofType:nil];
        }
            break;
        case IMBDevicePageWindowFolderEnumBook://book
            path = [[NSBundle mainBundle] pathForResource:DetailVCHeaderTitleBookNamesPlist ofType:nil];
            break;
        case IMBDevicePageWindowFolderEnumMedia://media
        case IMBDevicePageWindowFolderEnumVideo://video
            path = [[NSBundle mainBundle] pathForResource:IMBDetailVCHeaderTitleTrackNamesPlist ofType:nil];
            break;
        case IMBDevicePageWindowFolderEnumOther://other
            
            break;
        case IMBDevicePageWindowFolderEnumApps://apps
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
//    if (_folderModel.idx == IMBDevicePageWindowFolderEnumPhoto) {
//        IMBDevicePageFolderModel *subPhotoModel = [[IMBDevicePageFolderModel alloc] init];
//        subPhotoModel.idx = IMBDevicePageWindowFolderEnumPhotoCameraRoll + rowNumber;
//        NSMutableArray *subArray = [_folderModel.photoArray objectAtIndex:rowNumber];
//        subPhotoModel.subPhotoArray = subArray ? subArray : [[NSMutableArray alloc] init];
//        _folderModel = subPhotoModel;
//        [_tableView reloadData];
//    }
    
}

#pragma mark -- 通知
- (void)addNotis {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshClicked:) name:IMBDevicePageRefreshClickedNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toMacClicked:) name:IMBDevicePageToMacClickedNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToDeviceClicked:) name:IMBDevicePageAddToDeviceClickedNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteClicked:) name:IMBDevicePageDeleteClickedNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toDeviceClicked:) name:IMBDevicePageToDeviceClickedNoti object:nil];
    
}

- (void)removeNotis {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBDevicePageRefreshClickedNoti object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBDevicePageToMacClickedNoti object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBDevicePageAddToDeviceClickedNoti object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBDevicePageDeleteClickedNoti object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBDevicePageToDeviceClickedNoti object:nil];
}

- (void)refreshClicked:(NSNotification *)noti {
    IMBInformation *information = [noti object];
    if (![self canContnue:information]) return;
//    if (!information) return;
//    if (![information.ipod.uniqueKey isEqualToString:_iPod.uniqueKey]) return;
    
    [self refreshWithInfo:information];
}

- (void)refreshWithInfo:(IMBInformation *)information {
    if (_folderModel) {
        NSOperationQueue *opQueue = [[[NSOperationQueue alloc] init] autorelease];
        switch (_folderModel.idx) {
            case IMBDevicePageWindowFolderEnumPhotoStream:
            {
                if (_folderModel.subPhotoArray.count) {
                    [_folderModel.subPhotoArray removeAllObjects];
                }
                
                [_tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStartLoadingAnimNoti object:_iPod.uniqueKey];
                [opQueue addOperationWithBlock:^{
                    
                    [information refreshPhotoStream];
                    NSArray *photoArr = [information photostreamArray];
                    if (photoArr.count) {
                      [_folderModel.subPhotoArray addObjectsFromArray:photoArr];
                    }
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:_iPod.uniqueKey];
                        [_tableView reloadData];
                    });
                    
                }];
            }
                break;
            case IMBDevicePageWindowFolderEnumPhotoLibrary:
            {
                if (_folderModel.subPhotoArray.count) {
                    [_folderModel.subPhotoArray removeAllObjects];
                }
                [_tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStartLoadingAnimNoti object:_iPod.uniqueKey];
                [opQueue addOperationWithBlock:^{
                    
                    [information refreshPhotoLibrary];
                    NSArray *photoArr = [information photolibraryArray];
                    [_folderModel.subPhotoArray addObjectsFromArray:photoArr];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:_iPod.uniqueKey];
                        [_tableView reloadData];
                    });
                }];
            }
                
                break;
            case IMBDevicePageWindowFolderEnumPhotoCameraRoll:
            {
                if (_folderModel.subPhotoArray.count) {
                    [_folderModel.subPhotoArray removeAllObjects];
                }
                [_tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStartLoadingAnimNoti object:_iPod.uniqueKey];
                [opQueue addOperationWithBlock:^{
                    
                    [information refreshCameraRoll];
                    [information refreshVideoAlbum];
                    NSMutableArray *cameraRoll = [[NSMutableArray alloc] init];
                    [cameraRoll addObjectsFromArray:[information camerarollArray] ? [information camerarollArray] : [NSArray array]];
                    [cameraRoll addObjectsFromArray:[information photovideoArray] ? [information photovideoArray] : [NSArray array]];
                    [_folderModel.subPhotoArray addObjectsFromArray:cameraRoll];
                    [cameraRoll release];
                    cameraRoll = nil;
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:_iPod.uniqueKey];
                        [_tableView reloadData];
                    });
                }];
            }
                
                break;
                
            default:
                break;
        }
    }
}
- (void)toMacClicked:(NSNotification *)noti {
    IMBInformation *information = [noti object];
    if (![self canContnue:information]) return;
    
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
            
        default:
            break;
    }

    
}

- (void)addToDeviceClicked:(NSNotification *)noti {
    IMBInformation *information = [noti object];
    if (![self canContnue:information]) return;
    
    
    switch (_folderModel.idx) {
        case IMBDevicePageWindowFolderEnumPhotoLibrary:
        {
            _category = Category_PhotoLibrary;
            [self addToDeviceSettingsWithInformation:information];
        }
            break;
            
        default:
            break;
    }
}

- (void)deleteClicked:(NSNotification *)noti {
    IMBInformation *information = [noti object];
    if (![self canContnue:information]) return;
    
    switch (_folderModel.idx) {
        case IMBDevicePageWindowFolderEnumPhotoLibrary:
        {
            _category = Category_PhotoLibrary;
            [self deleteSettingsWithInformation:[information.ipod retain]];
        }
            break;
            
        default:
            break;
    }
}

- (void)toDeviceClicked:(NSNotification *)noti {
    IMBInformation *information = [noti object];
    if (![self canContnue:information]) return;
    
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
            
        default:
            break;
    }
}

- (void)toMacSettingsWithInformation:(IMBInformation *)information {
    if (!_selectedIndexes || _selectedIndexes.count == 0) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Please select photo" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please select photo"];
        [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
//            if (returnCode == 1) {
//                IMBFLog(@"clicked OK button");
//            }
        }];
    }else {
        NSOpenPanel *openPanel = [NSOpenPanel openPanel];
        [openPanel setCanChooseFiles:NO];
        [openPanel setCanChooseDirectories:YES];
        [openPanel setCanCreateDirectories:YES];
        //                [openPanel setAllowsOtherFileTypes:NO];
        [openPanel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
            if (NSModalResponseOK == result) {
                NSOperationQueue *opQueue = [[[NSOperationQueue alloc] init] autorelease];
                [opQueue addOperationWithBlock:^{
                    NSString *path = [[openPanel URL] path];
                    NSString *filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:_category]];
                    __block NSString *stringName = @"";
                    NSMutableArray *photos = [NSMutableArray array];
                    [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                        IMBPhotoEntity *photo = [[_folderModel.subPhotoArray objectAtIndex:idx] retain];
                        stringName = photo.albumTitle;
                        if ([TempHelper stringIsNilOrEmpty:stringName]) {
                            stringName = @"FromiOSFiles";
                        }
                        [photos addObject:photo];
                        [photo release];
                    }];
                    
                    filePath = [TempHelper createCategoryPath:filePath withString:stringName];
                    _baseTransfer = [[IMBPhotoFileExport alloc] initWithIPodkey:information.ipod.uniqueKey exportTracks:photos exportFolder:filePath withDelegate:self];
                    [(IMBPhotoFileExport *)_baseTransfer setExportType:1];
                    [_baseTransfer startTransfer];
                }];
            }
        }];
    }
}

- (void)addToDeviceSettingsWithInformation:(IMBInformation *)information {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanCreateDirectories:NO];
    [openPanel setAllowedFileTypes:@[@"png",@"jpg",@"gif",@"bmp",@"tiff",@"jpeg"]];
    [openPanel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
        if (NSModalResponseOK == result) {
            
            NSOperationQueue *opQueue = [[[NSOperationQueue alloc] init] autorelease];
            [opQueue addOperationWithBlock:^{
                NSMutableArray *paths = [NSMutableArray array];
                for (NSURL *urlPath in openPanel.URLs) {
                    [paths addObject:urlPath.path];
                }
                
                IMBPhotoEntity *albumEntity = [[IMBPhotoEntity alloc] init];
                albumEntity.albumZpk = 46;
                albumEntity.photoCounts = 1;
                albumEntity.albumKind = 1551;
                albumEntity.albumTitle = @"From iOSFiles";
                albumEntity.albumType = CreateAlbum;
                albumEntity.photoType = CommonType;
                _baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:information.ipod.uniqueKey importFiles:paths CategoryNodesEnum:_category photoAlbum:albumEntity playlistID:0 delegate:self];
                [_baseTransfer startTransfer];
                [paths release];
                paths = nil;
                [albumEntity release];
                albumEntity = nil;
            }];
        }
    }];
}

- (void)toDeviceSettingsWithInformation:(IMBInformation *)information {
    IMBDeviceConnection *conn = [IMBDeviceConnection singleton];
    IMBiPod *desIpod = nil;
    for (IMBiPod *ipod in conn.alliPods) {
        if (![ipod.uniqueKey isEqualToString:information.ipod.uniqueKey]) {
            desIpod = ipod;
            break;
        }
    }
    if (desIpod.infoLoadFinished) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableArray *selectAry = [NSMutableArray array];
            [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                IMBPhotoEntity *pe = [_folderModel.subPhotoArray objectAtIndex:idx];
                [selectAry addObject:pe];
            }];
            IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
            model.categoryNodes = _category;
            _baseTransfer = [[IMBBetweenDeviceHandler alloc] initWithSelectedArray:selectAry categoryModel:model srcIpodKey:information.ipod.uniqueKey desIpodKey:desIpod.uniqueKey withPlaylistArray:[NSArray array] albumEntity:nil Delegate:self];
            [_baseTransfer startTransfer];
        });
        
    }else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Warning!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please connect at least 2 devices"];
        [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
            
        }];
    }
}

- (void)deleteSettingsWithInformation:(IMBiPod *)iPod {
    if (!_selectedIndexes || _selectedIndexes.count == 0) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Please select photo" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please select photo"];
        [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
            
        }];
    }else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Warning" defaultButton:@"OK" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"Are U Sure To Delete?"];
        [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
            if (returnCode == 1) {
                IMBFLog(@"clicked OK button");
                NSOperationQueue *opQueue = [[[NSOperationQueue alloc] init] autorelease];
                [opQueue addOperationWithBlock:^{
                    
                    NSMutableArray *delArray = [NSMutableArray array];
                    [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                        IMBPhotoEntity *photo = [[_folderModel.subPhotoArray objectAtIndex:idx] retain];
                        IMBTrack *track = [[IMBTrack alloc] init];
                        track.photoZpk = photo.photoZpk;
                        [track setMediaType:Photo];
                        [delArray addObject:track];
                        [track release];
                        [photo release];
                    }];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStartLoadingAnimNoti object:_iPod.uniqueKey];
                    });
                    IMBDeleteTrack *deleteTrack = [[IMBDeleteTrack alloc] initWithIPod:iPod deleteArray:delArray Category:_category];
                    [deleteTrack setDelegate:self];
                    deleteTrack.delegate = self;
                    [deleteTrack startDelete];
                    [deleteTrack release];
                    
                }];
            }
            
        }];
        
    }

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
    NSString *url = [dropDestination relativePath];
    //此处调用导出方法
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:indexSet,@"indexSet",url,@"url",tableView,@"tableView", nil];
//    [self performSelector:@selector(delayTableViewdragToMac:) withObject:dic afterDelay:0.1];
    iconHide = YES;
    return namesArray;
}
#pragma mark -- NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    if (!_folderModel) return 0;
    if (_folderModel.idx == IMBDevicePageWindowFolderEnumPhotoCameraRoll || _folderModel.idx == IMBDevicePageWindowFolderEnumPhotoStream || _folderModel.idx == IMBDevicePageWindowFolderEnumPhotoLibrary) {
        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageShowToolbarNoti object:_iPod.uniqueKey];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageHideToolbarNoti object:_iPod.uniqueKey];
    }
    switch (_folderModel.idx) {
        case IMBDevicePageWindowFolderEnumPhotoCameraRoll:
        case IMBDevicePageWindowFolderEnumPhotoStream:
        case IMBDevicePageWindowFolderEnumPhotoLibrary:
            return _folderModel.subPhotoArray.count;
            break;
        case IMBDevicePageWindowFolderEnumBook://book
            return _folderModel.booksArray.count;
            break;
        case IMBDevicePageWindowFolderEnumMedia://media
        case IMBDevicePageWindowFolderEnumVideo://video
            return _folderModel.trackArray.count;
        case IMBDevicePageWindowFolderEnumOther://other
            return 0;
            break;
        case IMBDevicePageWindowFolderEnumApps://apps
            return _folderModel.appsArray.count;
            break;
            
        default:
            return 0;
            break;
    }
}




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
        {
            _selectedIndexes = [proposedSelectionIndexes retain];
        }
            break;
            
        default:
            break;
    }
    
    return proposedSelectionIndexes;
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
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
    return textField.stringValue;
}

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
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:_iPod.uniqueKey];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSAlert *alert = [NSAlert alertWithMessageText:@"Transfer Completed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"SuccessCount/TotalCount:%d/%d, please click refresh",successCount,totalCount];
//            [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
//                if (returnCode == 1) {
//                    IMBInformation *info = [[IMBInformation alloc] initWithiPod:_iPod];
//                    [self refreshWithInfo:info];
//                    [info release];
//                    info = nil;
//                }
//            }];
//        });
//    });
    
}

//传输出现错误
- (BOOL)transferOccurError:(NSString *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:_iPod.uniqueKey];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSAlert *alert = [NSAlert alertWithMessageText:@"Transfer Error" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Transfer Error"];
            [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
                
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
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:_iPod.uniqueKey];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSAlert *alert = [NSAlert alertWithMessageText:@"Delete Completed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"SuccessCount/TotalCount:%d/%d, please click refresh",success,totalCount];
//            [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
//                if (returnCode == 1) {
//                    IMBInformation *info = [[IMBInformation alloc] initWithiPod:_iPod];
//                    [self refreshWithInfo:info];
//                    [info release];
//                    info = nil;
//                }
//            }];
//        });
//        
//        
//    });
}

- (void)setCompletionWithSuccessCount:(int)successCount totalCount:(int)totalCount title:(NSString *)title {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:_iPod.uniqueKey];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSAlert *alert = [NSAlert alertWithMessageText:title defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"SuccessCount/TotalCount:%d/%d,we're going to refresh again",successCount,totalCount];
            [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
                if (returnCode == 1) {
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
