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



static CGFloat const rowH = 40.0f;
static CGFloat const labelY = 10.0f;


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
    
}
@end

@implementation IMBDetailViewControler

@synthesize folderModel = _folderModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)awakeFromNib {
    
    [self addNotis];
    
    [self setupTableView];
    
}

- (void)setupTableView {
    _selectedIndexes = nil;
    _scrollView.hasHorizontalScroller = NO;
    
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
//            path = [[NSBundle mainBundle] pathForResource:DetailVCHeaderTitleSubPhotoNamesPlist ofType:nil];
//            break;
        case IMBDevicePageWindowFolderEnumPhotoCameraRoll:
        case IMBDevicePageWindowFolderEnumPhotoStream:
        case IMBDevicePageWindowFolderEnumPhotoLibrary:
            path = [[NSBundle mainBundle] pathForResource:DetailVCHeaderTitlePhotoNamesPlist ofType:nil];
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
    if (_folderModel.idx == IMBDevicePageWindowFolderEnumPhoto) {
        IMBDevicePageFolderModel *subPhotoModel = [[IMBDevicePageFolderModel alloc] init];
        subPhotoModel.idx = IMBDevicePageWindowFolderEnumPhotoCameraRoll + rowNumber;
        NSArray *subArray = [_folderModel.photoArray objectAtIndex:rowNumber];
        subPhotoModel.subPhotoArray = subArray ? subArray : [NSArray array];
        _folderModel = subPhotoModel;
//        [self setupTableView];
        [_tableView reloadData];
    }
    
}

#pragma mark -- 通知
- (void)addNotis {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshClicked:) name:IMBDevicePageRefreshClickedNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toMacClicked:) name:IMBDevicePageToMacClickedNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToDeviceClicked:) name:IMBDevicePageAddToDeviceClickedNoti object:nil];
}

- (void)refreshClicked:(NSNotification *)noti {
    IMBInformation *information = [noti object];
    if (!information) return;
    if (_folderModel) {
        NSOperationQueue *opQueue = [[[NSOperationQueue alloc] init] autorelease];
        switch (_folderModel.idx) {
            case IMBDevicePageWindowFolderEnumPhotoStream:
            {
                _folderModel.subPhotoArray = nil;
                [_tableView reloadData];
                [opQueue addOperationWithBlock:^{
                    
                    [information refreshPhotoStream];
                    NSArray *photoArr = [information photostreamArray];
                    _folderModel.subPhotoArray = [[NSArray alloc] initWithArray:photoArr ? photoArr : [NSArray array]];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [_tableView reloadData];
                    });
                    
                }];
            }
                break;
            case IMBDevicePageWindowFolderEnumPhotoLibrary:
            {
                _folderModel.subPhotoArray = nil;
                [_tableView reloadData];
                [opQueue addOperationWithBlock:^{
                    
                    [information refreshPhotoLibrary];
                    NSArray *photoArr = [information photolibraryArray];
                    _folderModel.subPhotoArray = [[NSArray alloc] initWithArray:photoArr ? photoArr : [NSArray array]];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [_tableView reloadData];
                    });
                }];
            }
                
                break;
            case IMBDevicePageWindowFolderEnumPhotoCameraRoll:
            {
                _folderModel.subPhotoArray = nil;
                [_tableView reloadData];
                [opQueue addOperationWithBlock:^{
                    
                    [information refreshCameraRoll];
                    [information refreshVideoAlbum];
                    NSMutableArray *cameraRoll = [[NSMutableArray alloc] init];
                    [cameraRoll addObjectsFromArray:[information camerarollArray] ? [information camerarollArray] : [NSArray array]];
                    [cameraRoll addObjectsFromArray:[information photovideoArray] ? [information photovideoArray] : [NSArray array]];
                    _folderModel.subPhotoArray = [[NSArray alloc] initWithArray:cameraRoll];
                    [cameraRoll release];
                    cameraRoll = nil;
                    dispatch_sync(dispatch_get_main_queue(), ^{
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
    if (!information) return;
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
    if (!information) return;
    
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
                }];
                
                filePath = [TempHelper createCategoryPath:filePath withString:stringName];
                _baseTransfer = [[IMBPhotoFileExport alloc] initWithIPodkey:information.ipod.uniqueKey exportTracks:photos exportFolder:filePath withDelegate:self];
                [(IMBPhotoFileExport *)_baseTransfer setExportType:1];
                [_baseTransfer startTransfer];
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
                    NSString *path = [urlPath relativeString];
                    if ([path containsString:@"file://"]) {
                        path = [path stringByReplacingOccurrencesOfString:@"file://" withString:@""];
                    }
                    [paths addObject:path];
                }
                
                IMBPhotoEntity *albumEntity = [[IMBPhotoEntity alloc] init];
                albumEntity.albumZpk = -4;
                albumEntity.albumKind = 1550;
                albumEntity.albumTitle = @"From iOSFiles";
                albumEntity.albumType = SyncAlbum;
                _baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:information.ipod.uniqueKey importFiles:paths CategoryNodesEnum:_category photoAlbum:albumEntity playlistID:0 delegate:self];
                [(IMBAirSyncImportTransfer *)_baseTransfer startTransfer];
                [paths release];
                paths = nil;
                [albumEntity release];
                albumEntity = nil;
            }];
        }
    }];
}

#pragma mark -- NSTableViewDelegate,NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    if (!_folderModel) return 0;
    switch (_folderModel.idx) {
        case IMBDevicePageWindowFolderEnumPhoto://photo
            return _folderModel.photoArray.count;
            break;
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
    _selectedIndexes = nil;
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
        case IMBDevicePageWindowFolderEnumPhoto://photo
        {
            if ([strIdt isEqualToString:@"Name"]) {
                switch (row) {
                    case 0:
                    {
                        textField.stringValue = @"Camera Roll";
                        
                    }
                        break;
                    case 1:
                    {
                        textField.stringValue = @"Photo Stream";
                    }
                        break;
                    case 2:
                    {
                        textField.stringValue = @"Photo Library";
                    }
                        break;
                        
                    default:
                        break;
                }
            }else {
                NSArray *subArray = [_folderModel.photoArray objectAtIndex:row];
                textField.stringValue = [NSString stringWithFormat:@"%lu",subArray.count];
            }
            
            
        }
            break;
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

- (void)dealloc {
    [_folderModel release];
    _folderModel = nil;
    
    if (_selectedIndexes) {
        [_selectedIndexes release];
        _selectedIndexes = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBDevicePageRefreshClickedNoti object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBDevicePageToMacClickedNoti object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBDevicePageAddToDeviceClickedNoti object:nil];
    
    [super dealloc];
}

#pragma mark -- transferDelegate
//传输准备进度开始
- (void)transferPrepareFileStart:(NSString *)file {
    
}
//传输准备进度结束
- (void)transferPrepareFileEnd {
    
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
    NSAlert *alert = [NSAlert alertWithMessageText:@"Transfer Completed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"SuccessCount/TotalCount:%d/%d",successCount,totalCount];
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
        
    }];
}

//传输出现错误
- (BOOL)transferOccurError:(NSString *)error {
    return YES;
}
- (void)cloneOrMergeComplete:(BOOL)success {
    
}
- (void)transferCurrentSize:(long long)currenSize {
    
}
@end
