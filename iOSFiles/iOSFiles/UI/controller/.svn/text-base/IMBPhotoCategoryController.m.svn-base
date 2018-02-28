//
//  IMBPhotoCategoryController.m
//  iOSFiles
//
//  Created by iMobie on 18/2/10.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBPhotoCategoryController.h"
#import "IMBStackBox.h"
#import "IMBDevicePageFolderModel.h"
#import "IMBiPod.h"
#import "IMBInformation.h"
#import "IMBDetailViewControler.h"
#import "IMBDevicePageWindow.h"

#import <objc/runtime.h>

static CGFloat const rowH = 40.0f;
static CGFloat const labelY = 10.0f;

@interface IMBPhotoCategoryController ()<NSTabViewDelegate,NSTableViewDataSource>
{
    
    IBOutlet NSScrollView *_scrollView;
    IBOutlet NSTableView *_tableView;
    
    IMBStackBox *_rootBox;
    IMBDetailViewControler *_detailVc;
}
@end

@implementation IMBPhotoCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setupView];
}

- (void)setupView {
    _rootBox = objc_getAssociatedObject(_iPod, &kIMBDevicePageRootBoxKey);
    
//    objc_setAssociatedObject(_iPod, &kIMBPhotoCategoryControllerKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    _scrollView.hasHorizontalScroller = NO;
    
    [_tableView setTarget:self];
    [_tableView setDoubleAction:@selector(tableViewDoubleClicked:)];
    
    NSInteger count = _tableView.tableColumns.count;
    for (NSInteger i = 0; i < count; i++) {
        [_tableView removeTableColumn:_tableView.tableColumns[0]];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:DetailVCHeaderTitleSubPhotoNamesPlist ofType:nil];
    NSArray *headerTitleArr = [NSArray arrayWithContentsOfFile:path];
    
    if (headerTitleArr.count) {
        NSInteger count = headerTitleArr.count;
        CGFloat cW = _tableView.frame.size.width/count;
        for (NSInteger i = 0; i < count; i++) {
            NSTableHeaderCell *cell = [[NSTableHeaderCell alloc] initTextCell:headerTitleArr[i]];
            cell.alignment = NSCenterTextAlignment;
            NSTableColumn * column = [[NSTableColumn alloc] initWithIdentifier:headerTitleArr[i]];
            
            [column setHeaderCell:cell];
            [column setWidth:cW];
            [_tableView addTableColumn:column];
        }
        
    }
    
}

- (void)tableViewDoubleClicked:(id)sender {
    NSInteger rowNumber = [_tableView clickedRow];
    NSLog(@"Double Clicked.%ld ",rowNumber);
    // ...
    IMBDevicePageWindow *pageWindow = objc_getAssociatedObject(_iPod, &kIMBDevicePageWindowKey);
    switch (rowNumber) {
        case 0:
            [pageWindow setTitleStr:@"Camera Roll"];
            break;
        case 1:
            [pageWindow setTitleStr:@"Photo Stream"];
            break;
        case 2:
            [pageWindow setTitleStr:@"Photo Library"];
            break;
            
        default:
            break;
    }
    IMBDevicePageFolderModel *subPhotoModel = [[IMBDevicePageFolderModel alloc] init];
    subPhotoModel.idx = IMBDevicePageWindowFolderEnumPhotoCameraRoll + rowNumber;
    NSMutableArray *subArray = (NSMutableArray *)[_folderModel.photoArray objectAtIndex:rowNumber];
    subPhotoModel.subPhotoArray = subArray ? subArray : [[NSMutableArray alloc] init];
    if (_detailVc) {
        [_detailVc release];
        _detailVc = nil;
    }
    
    _detailVc = [[IMBDetailViewControler alloc] initWithNibName:@"IMBDetailViewControler" bundle:nil];
    _detailVc.folderModel = [subPhotoModel retain];
    _detailVc.iPod = [_iPod retain];
    [_rootBox pushView:_detailVc.view];
    
    [subPhotoModel release];
    subPhotoModel = nil;
}


#pragma mark -- tableviewDelegate,talbeviewDatasource


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (!_folderModel) return 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageHideToolbarNoti object:_iPod.uniqueKey];
    return _folderModel.photoArray.count;
}




- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return rowH;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    return NO;
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
    
    return aView;
}
- (NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes {
    
    return proposedSelectionIndexes;
}
#pragma mark -- 销毁
- (void)dealloc {
    [self clearMemory];
    
    [super dealloc];
}

- (void)clearMemory {
    if (_folderModel) {
        [_folderModel release];
        _folderModel = nil;
    }
    if (_detailVc) {
        [_detailVc release];
        _detailVc = nil;
    }
    if (_iPod) {
        [_iPod release];
        _iPod = nil;
    }
}

#pragma mark -- 外部方法

- (void)reloadData {
    [_tableView reloadData];
}
@end
