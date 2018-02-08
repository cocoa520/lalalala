//
//  IMBMyAlbumsViewController.m
//  iMobieTrans
//
//  Created by iMobie on 7/28/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBAndroidAlbumsViewController.h"
#import "IMBImageAndTextCell.h"
#import "IMBSegmentedBtn.h"
#import "IMBAlertViewController.h"
#import "IMBAnimation.h"
#import "CNGridViewItemLayout.h"
#import "IMBHelper.h"
#import "IMBImageAndTextCell.h"
#import "IMBCustomHeaderCell.h"
#import "IMBADPhotoEntity.h"
#import "IMBNotificationDefine.h"
#import "StringHelper.h"
#import "PhotoConversioniCloud.h"
#import "IMBADPhotoToiCloud.h"
#import "IMBAndroidMainPageViewController.h"

@implementation IMBAndroidAlbumsViewController
@synthesize albumTableView = _albumTableView;
@synthesize currentSelectView = _currentSelectView;
@synthesize currentAlbum = _currentAlbum;
@synthesize defaultLayout = _defaultLayout;
@synthesize hoverLayout = _hoverLayout;
@synthesize selectionLayout = _selectionLayout;

- (id)initwithAndroid:(IMBAndroid *)android withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate{
    if ([super initwithAndroid:android withCategoryNodesEnum:category withDelegate:delegate]) {
        _dataSourceArray = [android.adGallery.reslutEntity.reslutArray retain];
    }
    return self;
}


- (void)dealloc {
    if (_defaultLayout != nil) {
        [_defaultLayout release];
        _defaultLayout = nil;
    }
    if (_hoverLayout != nil) {
        [_hoverLayout release];
        _hoverLayout = nil;
    }
    if (_selectionLayout != nil) {
        [_selectionLayout release];
        _selectionLayout = nil;
    }
    if (_operation != nil) {
        [_operation release];
        _operation = nil;
    }
    if (_researchdataSourceArray != nil) {
        [_researchdataSourceArray release];
        _researchdataSourceArray = nil;
    }
    
    [super dealloc];
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        [self configNoDataView];
        NSString *addStr = CustomLocalizedString(@"Button_id_2", nil);
        NSRect rect = [StringHelper calcuTextBounds:addStr fontSize:14];
        float w = 110;
        if (rect.size.width > 80) {
            w = rect.size.width + 30;
        }
    });
}

- (void)changeSkin:(NSNotification *)notification {
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [_loadingAnimationView setNeedsDisplay:YES];
    [self configNoDataView];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_albumTableView setBackgroundColor:[NSColor clearColor]];
    [_rightTableView setBackgroundColor:[NSColor clearColor]];
    [_loadingAnimationView setNeedsDisplay:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
}

- (void)awakeFromNib {
     _isAndroid = YES;
    [super awakeFromNib];
   
    _researchdataSourceArray = [[NSMutableArray alloc] init];
    [_rightTableView setBackgroundColor:[NSColor clearColor]];
    _operation = [[NSOperationQueue alloc] init];
    [_operation setMaxConcurrentOperationCount:10];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    alerView = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
    }else {
        [_mainBox setContentView:_contentView];
        IMBADAlbumEntity *album = [_dataSourceArray objectAtIndex:0];
        _baseAry = [[NSMutableArray alloc] initWithArray:album.photoArray];
        [_boxContent setContentView:_rightColDetailView];
        _currentSelectView = 1;
    }
    [self configNoDataView];
    [_albumTableView setListener:self];
    [_albumTableView setBackgroundColor:[NSColor clearColor]];
    [_rightTableView setListener:self];
    [_scrollView setHastopBorder:NO leftBorder:NO BottomBorder:NO rightBorder:NO];
    [_albumTableView setFocusRingType:NSFocusRingTypeNone];
    [_albumTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    [_albumTableView reloadData];
    [self tableViewSelectionDidChange:nil];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    
    _defaultLayout = [[CNGridViewItemLayout alloc] init];
    _hoverLayout = [[CNGridViewItemLayout alloc] init];
    _selectionLayout = [[CNGridViewItemLayout alloc] init];
    
    _hoverLayout.backgroundColor = [[NSColor grayColor] colorWithAlphaComponent:0.42];
    _selectionLayout.backgroundColor = [NSColor colorWithCalibratedRed:0.542 green:0.699 blue:0.807 alpha:0.420];
    _gridView.itemSize = NSMakeSize(144, 144);
    _gridView.backgroundColor = [NSColor whiteColor];
    _gridView.scrollElasticity = NO;
    _gridView.allowsDragAndDrop = NO;
    [_gridView reloadData];
    _gridView.allowsMultipleSelection = YES;
    _gridView.allowsMultipleSelectionWithDrag = YES;
    [_gridView setIsPhotoView:YES];
    

    NSTableColumn *column = [_itemTableView tableColumnWithIdentifier:@"Image"];
    IMBCustomHeaderCell *columnHeaderCell = (IMBCustomHeaderCell *) column.headerCell;
    [columnHeaderCell setIsShowTriangle:NO];
    _rightTableView.menu.delegate = self;
}

#pragma mark - NSTextView
- (void)configNoDataView {
    [_textView setDelegate:self];
    [_noDataTextTwo setDelegate:self];
    [_noDataImageView setImage:[StringHelper imageNamed:@"nodata_ad_photo"]];
    NSString *promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)];
    NSString *overStr = CustomLocalizedString(@"NO_DATA_TITLE_2", nil);
    
    NSString *overStr1 = CustomLocalizedString(@"noData_subTitle1", nil);
    NSString *promptStr1 = [[[NSString stringWithFormat:CustomLocalizedString(@"noData_subTitle", nil),CustomLocalizedString(@"MenuItem_id_77", nil)] stringByAppendingString:@" "] stringByAppendingString:overStr1];

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
    
    
    [_noDataTextTwo setLinkTextAttributes:linkAttributes];
    [_noDataTextTwo setSelectable:YES];
    NSMutableAttributedString *promptAs1 = [[NSMutableAttributedString alloc] initWithString:promptStr1];
    NSRange promRange1 = NSMakeRange(0, promptAs1.length);
    [promptAs1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0,promRange1.length)];
    [promptAs1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0,promRange1.length)];
    [promptAs1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0,promRange1.length)];
    [promptAs1 addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs1.length)];
    NSRange infoRange1 = [promptStr1 rangeOfString:overStr1];
    [promptAs1 addAttribute:NSLinkAttributeName value:overStr1 range:infoRange1];
    [promptAs1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange1];
    [promptAs1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange1];
    [promptAs1 addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange1];
    
    [promptAs1 addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs1 string] length])];
    [[_noDataTextTwo textStorage] setAttributedString:promptAs1];
    [promptAs1 release], promptAs1 = nil;
    [mutParaStyle release], mutParaStyle = nil;
}

#pragma mark - textView Delegate
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex {
    NSString *overStr = CustomLocalizedString(@"noData_subTitle1", nil);
    if ([link isEqualToString:overStr]) {
        NSLog(@"控制apk将手机界面显示为权限管理的界面");
    }
    return YES;
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (tableView == _albumTableView) {
        if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
            return _dataSourceArray.count;
        }
    }else {
        if (_isSearch) {
            if (_researchdataSourceArray != nil && _researchdataSourceArray.count > 0) {
                return _researchdataSourceArray.count;
            }
        }else {
            if (_baseAry != nil && _baseAry.count > 0) {
                return _baseAry.count;
            }
        }
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == _albumTableView) {
        IMBADAlbumEntity *album = [_dataSourceArray objectAtIndex:row];
        if ([@"AlbumName" isEqualToString:tableColumn.identifier]) {
            return album.albumName;
        }else if ([@"Count" isEqualToString:tableColumn.identifier]) {
            if (album.photoArray.count == 0) {
                return @"--";
            }else {
                return [NSNumber numberWithInt:(int)album.photoArray.count];
            }
        }
        return @"";
    }else {
        IMBADPhotoEntity *photoEntity = nil;
        if (_isSearch) {
            if (row >= _researchdataSourceArray.count) {
                return @"";
            }
            photoEntity = [_researchdataSourceArray objectAtIndex:row];
        }else{
            if (row >= _baseAry.count) {
                return @"";
            }
            photoEntity = [_baseAry objectAtIndex:row];
        }
        if ([tableColumn.identifier isEqualToString:@"Name"]) {
            return photoEntity.name;
        }else if ([tableColumn.identifier isEqualToString:@"CheckCol"]){
            return [NSNumber numberWithInt:photoEntity.checkState];
        }else if ([@"Format" isEqualToString:tableColumn.identifier]){
            if (photoEntity.width==0 ||photoEntity.height==0) {
                return @"--";
            }else{
                return [NSString stringWithFormat:@"%d*%d",photoEntity.width,photoEntity.height];
            }
        }else if ([@"Time" isEqualToString:tableColumn.identifier]){
            if (photoEntity.time == 0) {
                return @"--";
            }else{
                return [DateHelper dateFrom1970ToString:photoEntity.time withMode:2];
            }
        }else if ([@"Size" isEqualToString:tableColumn.identifier]){
            return [IMBHelper getFileSizeString:photoEntity.size reserved:2];
        }else if ([@"Image" isEqualToString:tableColumn.identifier]){
            return @"";
        }
        return @"";
    }
}

#pragma mark - NSTableViewdelegate

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == _albumTableView) {
        if ([@"AlbumName" isEqualToString:tableColumn.identifier]) {
            IMBADAlbumEntity *album = [_dataSourceArray objectAtIndex:row];
            IMBImageAndTextCell *cell1 = (IMBImageAndTextCell *)cell;
            cell1.imageSize = NSMakeSize(16, 16);
            cell1.marginX = 20;
            cell1.paddingX = 0;
            if (album.isAppAlbum) {
                cell1.image = [StringHelper imageNamed:@"toios_photo_appphoto"];
                cell1.imageName = @"toios_photo_appphoto";
            }else {
                cell1.image = [StringHelper imageNamed:@"toios_photo_icon"];
                cell1.imageName = @"toios_photo_icon";
            }
        }else if ([@"Count" isEqualToString:tableColumn.identifier]) {
            IMBCenterTextFieldCell *cell2 = (IMBImageAndTextCell *)cell;
            cell2.isRighVale = YES;
        }
    }else {
        NSArray *array = nil;
        if (_isSearch) {
            array = _researchdataSourceArray;
        }else {
            array = _baseAry;
        }
        if ([tableColumn.identifier isEqualToString:@"Image"] && row < array.count) {
            IMBADPhotoEntity *dp = [array objectAtIndex:row];
            NSImage *image = nil;
            IMBImageAndTextCell *curCell = (IMBImageAndTextCell *)cell;
            [curCell setImageSize:NSMakeSize(54, 54)];
            if (dp.photoImage == nil) {
                image = [StringHelper imageNamed:@"default_photo"];
            }else{
                image = dp.photoImage;
                [curCell setIsDataImage:YES];
            }
            curCell.image = image;
            curCell.marginX = 14;
        }
    }
}

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    return NO;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView *tableView = notification.object;
    if (tableView == _albumTableView) {
        NSInteger row = [_albumTableView selectedRow];
        if (row == -1) {
//            [_delegate loadMyAlbumButton:CreateAlbum withIsViewDisplay:_currentSelectView withViewController:self];
            return;
        }
        [_searchFieldBtn setStringValue:@""];
        _isSearch = NO;
        _curIndex = (int)row;
         IMBADAlbumEntity *album = [_dataSourceArray objectAtIndex:row];
        [_baseAry removeAllObjects];
        [_baseAry addObjectsFromArray:album.photoArray];
        [_rightTableView deselectAll:nil];
        
        int count = 0;
        if (_baseAry.count > 0) {
            for (int i = 0; i < _baseAry.count; i ++) {
                IMBADPhotoEntity *entity = [_baseAry objectAtIndex:i];
                if (entity.checkState == NSOnState) {
                    count ++;
                }
            }
        }
        if (count == 0) {
            [_rightTableView changeHeaderCheckState:UnChecked];
        }else if (count == (int)_baseAry.count) {
             [_rightTableView changeHeaderCheckState:Check];
        }else {
             [_rightTableView changeHeaderCheckState:SemiChecked];
        }
        
        [_gridView reloadData];
        [_rightTableView reloadData];
    }
}

- (void)tableView:(NSTableView *)tableView rightDownrow:(NSInteger)index {
//    if (tableView == _albumTableView) {
//        IMBADAlbumEntity *album = [_dataSourceArray objectAtIndex:index];
//        [_renameMenuItem setHidden:YES];
//        [_deleteItem setHidden:YES];
//        [_albumTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
//    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    if (tableView == _rightTableView) {
        return 64;
    }else {
        return 30;
    }
}

-(void)tableView:(NSTableView *)tableView row:(NSInteger)index{
    if (tableView == _rightTableView) {
        NSMutableArray *disPalyAry = nil;
        if (_isSearch) {
            disPalyAry = _researchdataSourceArray;
        }else{
            disPalyAry = _baseAry;
        }
        if (disPalyAry.count <=0) {
            return;
        }
        IMBADPhotoEntity *entity = [disPalyAry objectAtIndex:index];
        entity.checkState = !entity.checkState;
        
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (int i=0;i<[disPalyAry count]; i++) {
            IMBADPhotoEntity *item= [disPalyAry objectAtIndex:i];
            if (item.checkState == NSOnState) {
                [set addIndex:i];
            }
        }
//        if (entity.checkState == NSOnState) {
//            [_rightTableView selectRowIndexes:set byExtendingSelection:NO];
//        }else if (entity.checkState == NSOffState)
//        {
//            [_rightTableView deselectRow:index];
//        }
        
        if (set.count == disPalyAry.count) {
            [_rightTableView changeHeaderCheckState:Check];
        }else if (set.count == 0){
            [_rightTableView changeHeaderCheckState:UnChecked];
        }else{
            [_rightTableView changeHeaderCheckState:SemiChecked];
        }
        [_rightTableView reloadData];
    }
}

//排序
- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    if (tableView == _rightTableView) {
        id cell = [tableColumn headerCell];
        NSString *identify = [tableColumn identifier];
        NSArray *array = [tableView tableColumns];
        NSMutableArray *disPalyAry = nil;
        if (_isSearch) {
            disPalyAry = _researchdataSourceArray;
        }else{
            disPalyAry = _baseAry;
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
        
        if ( [@"Name" isEqualToString:identify] || [@"Format" isEqualToString:identify] || [@"TimeDate" isEqualToString:identify] || [@"Size" isEqualToString:identify] || [@"DocumentSize" isEqualToString:identify] || [@"Format" isEqualToString:identify]|| [@"Genre" isEqualToString:identify] || [@"Rating" isEqualToString:identify]|| [@"Time" isEqualToString:identify]) {
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
                IMBADPhotoEntity *track = [disPalyAry objectAtIndex:i];
                if (track.checkState == NSOnState) {
                    [set addIndex:i];
                }
            }
//            [_rightTableView selectRowIndexes:set byExtendingSelection:NO];
        }
        [_rightTableView reloadData];
    }
}

- (void)sort:(BOOL)isAscending key:(NSString *)key dataSource:(NSMutableArray *)array {
    if ([key isEqualToString:@"Name"]) {
        key = @"name";
    } else if ([key isEqualToString:@"Format"]) {
        key = @"width";
    }else if ([key isEqualToString:@"Size"]) {
        key = @"size";
    }else if ([key isEqualToString:@"Time"]) {
        key = @"time";
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    [_itemTableView reloadData];
    
    [sortDescriptor release];
    [sortDescriptors release];
}

- (void)setAllselectState:(CheckStateEnum)checkState {
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _baseAry;
    }
    for (int i=0;i<[array count]; i++) {
        IMBADPhotoEntity *entity = [array objectAtIndex:i];
        [entity setCheckState:checkState];
        if (entity.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
    [_rightTableView reloadData];
}

//TableView加载图片
- (void)loadingThumbnilImage:(NSRange)oldVisibleRows withNewVisibleRows:(NSRange)newVisibleRows {
    NSArray *visibleItems = nil;
    if (_baseAry.count > newVisibleRows.length) {
        visibleItems = [_baseAry subarrayWithRange:newVisibleRows];
    }else {
        visibleItems = [_baseAry subarrayWithRange:NSMakeRange(0, _baseAry.count)];
    }
    if (visibleItems != nil && visibleItems.count > 0) {
        for (IMBADPhotoEntity *entity in visibleItems) {
            if (entity.isLoad == NO || entity.photoImage == nil) {
                [self loadImage:entity];
            }
        }
    }
}

- (void)loadImage:(IMBADPhotoEntity *)entity {
    @synchronized (entity) {
        [_operation addOperationWithBlock:^(void) {
            @autoreleasepool {
                if (entity.loadingImage == NO) {
                    entity.loadingImage = YES;
                    [_android loadThumbnaiImage:entity];
                    entity.loadingImage = NO;
                }
                [self performSelectorOnMainThread:@selector(reloadRowForTableView:) withObject:entity waitUntilDone:NO modes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            }
        }];
    }
}

- (void)reloadRowForTableView:(id)object {
    NSInteger row;
    if (_isSearch) {
        row = [_researchdataSourceArray indexOfObject:object];
    }else{
        row = [_baseAry indexOfObject:object];
    }
    
    if (row != NSNotFound) {
        [_rightTableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row] columnIndexes:[NSIndexSet indexSetWithIndex:1]];
    }
}

#pragma mark - CNGridView DataSource
- (NSUInteger)gridView:(CNGridView *)gridView numberOfItemsInSection:(NSInteger)section {
    if (_isSearch) {
        return _researchdataSourceArray.count;
    }else {
        return _baseAry.count;
    }
}

- (CNGridViewItem *)gridView:(CNGridView *)gridView itemAtIndex:(NSInteger)index inSection:(NSInteger)section {
    static NSString *reuseIdentifier = @"CNGridViewItem";
    
    CNGridViewItem *item = [gridView dequeueReusableItemWithIdentifier:@(index)];
    if (item == nil) {
        item = [[[CNGridViewItem alloc] initWithLayout:self.defaultLayout reuseIdentifier:reuseIdentifier] autorelease];
        item.hoverLayout = self.hoverLayout;
        item.selectionLayout = self.selectionLayout;
    }
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _baseAry;
    }
    
    IMBADPhotoEntity *photoEntity = [array objectAtIndex:index];
    item.bgImg = [StringHelper imageNamed:@"default_photo"];
    item.isPhotoView = YES;
    [_operation addOperationWithBlock:^{
        if (item.itemImage == nil) {
            if (!photoEntity.isLoad) {
                if (!photoEntity.loadingImage) {
                    photoEntity.loadingImage = YES;
                    BOOL dataResult = [_android loadThumbnaiImage:photoEntity];
                    if (photoEntity.photoImage) {
                        NSImage *image = [IMBHelper scaleCutImageForSize:photoEntity.photoImage width:122 height:122 type:nil];
                        if (image != nil) {
                            photoEntity.photoImage = image;
                            if (dataResult) {
                                if (photoEntity.photoImage != nil) {
                                    item.itemImage = photoEntity.photoImage;
                                    photoEntity.isLoad = YES;
                                }
                            }else{
                                item.itemImage = [StringHelper imageNamed:@"default_photo"];
                                photoEntity.loadingImage = NO;
                            }
                        }
                    }
                }
            } else {
                NSImage *image = [[NSImage alloc] initWithData:[IMBHelper suchAsScalingImage:photoEntity.photoImage width:122 height:122]];
                item.itemImage = image;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [item setNeedsDisplay:YES];
            });
        }
    }];
    if (item.seledImg == nil) {
        item.seledImg = [StringHelper imageNamed:@"scan_photoselete"];
    }
    item.selected = photoEntity.checkState;
    
    if (photoEntity.checkState == Check) {
        if (![gridView.selectedItems containsObject:item]) {
            [[gridView getSelectedItemsDic] setObject:item forKey:@(item.index)];
        }
    }else{
        if ([gridView.selectedItems containsObject:item]) {
            [[gridView getSelectedItemsDic] removeObjectForKey:@(item.index)];
        }
    }
    return item;
}

#pragma mark - CNGridView Delegate
- (void)gridView:(CNGridView *)gridView didSelectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section{
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _baseAry;
    }
    if (index < array.count) {
        IMBADPhotoEntity *photoEntity = [array objectAtIndex:index];
        photoEntity.checkState = Check;
        int count = 0;
        for (IMBADPhotoEntity *entity in array) {
            if (entity.checkState == Check) {
                count ++ ;
            }
        }
    }
}

- (void)gridView:(CNGridView *)gridView didDeselectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section{
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _baseAry;
    }
    
    IMBADPhotoEntity *photoEntity = [array objectAtIndex:index];
    photoEntity.checkState = UnChecked;
}

- (void)gridViewDidDeselectAllItems:(CNGridView *)gridView{
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _baseAry;
    }
    
    for (IMBADPhotoEntity *attachEntity in array) {
        attachEntity.checkState = UnChecked;
    }
    _resultEntity.selectedCount = 0;
    [_gridView reloadSelecdImage];
}

- (void)gridViewCancelAllOperations:(CNGridView *)gridView {
    if (_operation != nil) {
        [_operation cancelAllOperations];
    }
}

#pragma mark - 搜索
- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _searchFieldBtn = searchBtn;
    _isSearch = YES;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_baseAry filteredArrayUsingPredicate:predicate]];
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
        [self loadCheckBoxState];
    }
    [_rightTableView reloadData];
    [_gridView reloadData];
}

- (void)doSwitchView:(id)sender {
    IMBSegmentedBtn *segBtn = (IMBSegmentedBtn *)sender;
    if (segBtn.selectedSegment == 0) {
        [_rightTableView reloadData];
        [_boxContent setContentView:_rightListDetailView];
        
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (int i=0;i<[_baseAry count]; i++) {
            IMBADPhotoEntity *item= [_baseAry objectAtIndex:i];
            if (item.checkState == NSOnState) {
                [set addIndex:i];
            }
        }
        if (set.count == _baseAry.count) {
            [_rightTableView changeHeaderCheckState:Check];
        }else if (set.count == 0){
            [_rightTableView changeHeaderCheckState:UnChecked];
        }else{
            [_rightTableView changeHeaderCheckState:SemiChecked];
        }
        [_rightTableView reloadData];
        _currentSelectView = 0;
    }else if (segBtn.selectedSegment == 1) {
        [_gridView reloadData];
        [_boxContent setContentView:_rightColDetailView];
        _currentSelectView = 1;
    }
}

- (NSIndexSet *)selectedItems {
    NSMutableIndexSet *selectedItems = [NSMutableIndexSet indexSet];
    for (int i=0;i<[_dataSourceArray count]; i++) {
        IMBADAlbumEntity *entity = [_dataSourceArray objectAtIndex:i];
        int count = 0;
        for (IMBADPhotoEntity *photo in entity.photoArray) {
            if (photo.checkState == NSOnState) {
                count ++;
            }
        }
        if (count > 0) {
            [selectedItems addIndex:i];
        }
    }
    return selectedItems;
}

#pragma mark reload
- (void)androidReload:(id)sender {
    [self disableFunctionBtn:NO];
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    
    //检查apk是否赋予权限
    if (_delegate != nil && [_delegate respondsToSelector:@selector(checkDeviceGreantedPermission:)] ) {
        [_delegate checkDeviceGreantedPermission:ReloadFunctionType];
    }
}

- (void)reloadData {
    [_android queryGalleryDetailInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_rightTableView changeHeaderCheckState:NSOffState];
        [self disableFunctionBtn:YES];
        [self refresh];
    });
}

- (void)cancelReload {
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_mainBox setContentView:_contentView];
    }
    [self disableFunctionBtn:YES];
    [_loadingAnimationView endAnimation];
}

- (void)refresh {
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    _dataSourceArray = [_android.adGallery.reslutEntity.reslutArray retain];

    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_mainBox setContentView:_contentView];
        IMBADAlbumEntity *album = [_dataSourceArray objectAtIndex:0];
        [_albumTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        [_baseAry removeAllObjects];
        [_baseAry addObjectsFromArray: album.photoArray];
    }
    [_albumTableView reloadData];
    if (_dataSourceArray.count > 0 && _curIndex < _dataSourceArray.count ) {
        [_albumTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:_curIndex] byExtendingSelection:NO];
    }else if (_dataSourceArray.count > 0) {
        [_albumTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    }
    [_loadingAnimationView endAnimation];
    
    [_gridView reloadData];
    [self tableViewSelectionDidChange:nil];
    int allCount = 0;
    for (IMBADAlbumEntity *album in _dataSourceArray) {
        for (IMBPhotoEntity *entity in album.photoArray) {
            entity.checkState = UnChecked;
        }
        allCount += album.photoArray.count;
    }
    if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
        [_delegate refeashBadgeConut:allCount WithCategory:_category];
    }
}

- (void)reloadTableView{
    _isSearch = NO;
    [_rightTableView reloadData];
    [_gridView reloadData];
}

#pragma mark - 更新CheckBox的状态
- (void)loadCheckBoxState {
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else{
        displayArr = _baseAry;
    }
    if (displayArr.count == 0) {
        return;
    }
    int checkCount = 0;
    int unCheckCount = 0;
    for (IMBADPhotoEntity *PhotoEntity in displayArr) {
        if (PhotoEntity.checkState == Check) {
                checkCount ++;
        } else if (PhotoEntity.checkState == UnChecked) {
                unCheckCount ++;
        }
    }
        if (checkCount == displayArr.count) {
            [_rightTableView changeHeaderCheckState:Check];
        } else if (unCheckCount == displayArr.count || displayArr.count == 0) {
            [_rightTableView changeHeaderCheckState:UnChecked];
        } else {
            [_rightTableView changeHeaderCheckState:SemiChecked];
        }
    [_rightTableView reloadData];
    
}

#pragma mark - 返回按钮
- (void)doBack:(id)sender {
    [super doBack:sender];
    if (_searchFieldBtn != nil) {
        [self doSearchBtn:nil withSearchBtn:_searchFieldBtn];
    }
}

//传输准备进度开始
- (void)transferPrepareFileStart:(NSString *)file {
    NSLog(@"准备进度开始");
}

//传输准备进度结束
- (void)transferPrepareFileEnd {
    NSLog(@"准备进度结束");
}

//传输进度
- (void)transferProgress:(float)progress {
    NSLog(@"传输进度值：%f", progress);
}

//当前传输文件的名字或者路径
- (void)transferFile:(NSString *)file {
    NSLog(@"当前传输文件的名字或者路径");
}

//分析进度
- (void)parseProgress:(float)progress {
    NSLog(@"分析进度");
}

//当前分析文件的名字或者路径
- (void)parseFile:(NSString *)file {
    NSLog(@"当前分析文件的名字或者路径");
}

//全部传输成功
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount {
    NSLog(@"全部传输成功");
}

- (void)menuWillOpen:(NSMenu *)menu {
    [self initAndroidDeviceMenuItem];
    [self initAndroidiCloudMenuItem];
}


@end
