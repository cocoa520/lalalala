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
    NSInteger count = _tableView.tableColumns.count;
    for (NSInteger i = 0; i < count; i++) {
        [_tableView removeTableColumn:_tableView.tableColumns[0]];
    }
    _scrollView.hasHorizontalScroller = NO;
    
    if (!_headerTitleArr) {
        NSString *path = @"";
        switch (_folderModel.idx) {
            case 0://photo
                path = [[NSBundle mainBundle] pathForResource:DetailVCHeaderTitlePhotoNamesPlist ofType:nil];
                break;
            case 1://book
                path = [[NSBundle mainBundle] pathForResource:DetailVCHeaderTitleBookNamesPlist ofType:nil];
                break;
            case 2://media
            case 3://video
                path = [[NSBundle mainBundle] pathForResource:IMBDetailVCHeaderTitleTrackNamesPlist ofType:nil];
            case 4://other
                
                break;
            case 5://apps
                path = [[NSBundle mainBundle] pathForResource:DetailVCHeaderTitleAppNamesPlist ofType:nil];
                break;
                
            default:
                
                break;
        }
        
        _headerTitleArr = [NSArray arrayWithContentsOfFile:path];
    }
    
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

- (void)setFolderModel:(IMBDevicePageFolderModel *)folderModel {
    _folderModel = folderModel;
    
    
    [_tableView reloadData];
    
}

#pragma mark -- NSTableViewDelegate,NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
//    return 0;
    if (!_folderModel) return 0;
    switch (_folderModel.idx) {
        case 0://photo
            return _folderModel.photoArray.count;
            break;
        case 1://book
            return _folderModel.booksArray.count;
            break;
        case 2://media
        case 3://video
            return _folderModel.trackArray.count;
        case 4://other
            return 0;
            break;
        case 5://apps
            return _folderModel.appsArray.count;
            break;
            
        default:
            return 0;
            break;
    }
    return _folderModel.appsArray.count;
}

//- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
//{
//    if (!_folderModel) return nil;
//   
//    NSTableCellView *cell = [tableColumn dataCellForRow:row];
//    switch (_folderModel.idx) {
//        case 0://photo
//        {
//            IMBPhotoEntity *photo = [_folderModel.photoArray objectAtIndex:row];
//            cell.textField.stringValue = photo.photoName;
//        }
//            break;
//        case 1://book
//        {
//            IMBBookEntity *book = [_folderModel.booksArray objectAtIndex:row];
//            cell.textField.stringValue = book.bookName;
//        }
//            break;
//        case 2://media
//        case 3://video
//        {
//            IMBTrack *track = [_folderModel.trackArray objectAtIndex:row];
//            cell.textField.stringValue = track.title;
//        }
//        case 4://other
//            return nil;
//            break;
//        case 5://apps
//        {
//            IMBAppEntity *app = [_folderModel.appsArray objectAtIndex:row];
//            cell.textField.stringValue = app.appName;
//        }
//            break;
//            
//        default:
//            return nil;
//            break;
//    }
//    return cell;
//}



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
        case 0://photo
        {
            IMBPhotoEntity *photo = [_folderModel.photoArray objectAtIndex:row];
            if ([strIdt isEqualToString:@"Name"]) {
                textField.stringValue = photo.photoName;
            }else if ([strIdt isEqualToString:@"Resolution"]) {
                NSString *resolutionStr = [NSString stringWithFormat:@"%d*%d",photo.photoWidth,photo.photoHeight];
                textField.stringValue = resolutionStr ? resolutionStr : @"-";
            }else if ([strIdt isEqualToString:@"Size"]) {
                textField.stringValue = [NSString stringWithFormat:@"%.2f MB",photo.photoSize/1024.0/1024.0];
            }
            
        }
            break;
        case 1://book
        {
            IMBBookEntity *book = [_folderModel.booksArray objectAtIndex:row];
            if ([strIdt isEqualToString:@"Name"]) {
                textField.stringValue = book.bookName;
            }else if ([strIdt isEqualToString:@"Size"]) {
                textField.stringValue = [NSString stringWithFormat:@"%.2f MB",book.size/1024.0/1024.0];
            }
        }
            break;
        case 2://media
        case 3://video
        {
            IMBTrack *track = [_folderModel.trackArray objectAtIndex:row];
            if ([strIdt isEqualToString:@"Name"]) {
                textField.stringValue = track.title;
            }else if ([strIdt isEqualToString:@"Time"]) {
                textField.stringValue = [[StringHelper getTimeString:track.length] stringByAppendingString:@" "];//@"-";
            }else if ([strIdt isEqualToString:@"Size"]) {
                textField.stringValue = [NSString stringWithFormat:@"%.2f MB",track.fileSize/1024.0/1024.0];
            }
        }
        case 4://other
            break;
        case 5://apps
        {
            IMBAppEntity *app = [_folderModel.appsArray objectAtIndex:row];
            if ([strIdt isEqualToString:@"Name"]) {
                textField.stringValue = app.appName;
            }else if ([strIdt isEqualToString:@"Version"]) {
                textField.stringValue = app.version;
            }else if ([strIdt isEqualToString:@"Size"]) {
                textField.stringValue = [NSString stringWithFormat:@"%.2f MB",app.appSize/1024.0/1024.0];
            }
        }
            break;
            
        default:
            break;
    }
    return aView;
}


@end
