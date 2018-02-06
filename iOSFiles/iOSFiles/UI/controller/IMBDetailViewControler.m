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


static CGFloat const rowH = 40.0f;
static CGFloat const labelY = 10.0f;


@interface IMBDetailViewControler ()<NSTableViewDelegate,NSTableViewDataSource>
{
    @private
    IBOutlet NSScrollView *_scrollView;
    
    IBOutlet NSTableView *_tableView;
    
    NSArray *_headerTitleArr;
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

- (void)addNotis {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshClicked:) name:IMBDevicePageRefreshClickedNoti object:nil];
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
                    NSArray *photoArr = [information camerarollArray];
                    _folderModel.subPhotoArray = [[NSArray alloc] initWithArray:photoArr ? photoArr : [NSArray array]];
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


- (NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes {
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBDevicePageRefreshClickedNoti object:nil];
    
    [super dealloc];
}

@end
