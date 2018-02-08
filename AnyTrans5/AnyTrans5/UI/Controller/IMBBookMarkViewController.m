//
//  IMBBookMarkViewController.m
//  AnyTrans
//
//  Created by long on 16-7-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBookMarkViewController.h"
#import "IMBOutlineView.h"
#import "IMBBackgroundBorderView.h"
#import "IMBImageAndTextCell.h"
#import "IMBScrollView.h"
#import "IMBCustomHeaderCell.h"
#import "IMBCheckBoxCell.h"
#import "IMBBookMarkSqliteManager.h"
#import "IMBAnimation.h"
#import "IMBBrowserBookMarkViewController.h"
#import "IMBParseBookmark.h"
#import "CapacityView.h"
#import "IMBDeviceMainPageViewController.h"
#import "IMBNotificationDefine.h"
//#import "IMBBookMarkSqliteManager.h"
//#import "IMBSafariHistoryEntity.h"
//#import "IMBCenterTextFieldCell.h"
//#import "IMBHistorySqliteManager.h"


@implementation IMBBookMarkViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithProductVersion:(SimpleNode *)node withDelegate:(id)delegate WithIMBBackupDecryptAbove4:(IMBBackupDecryptAbove4 *)abve4  {
    if ([super initWithNibName:@"IMBBookMarkViewController" bundle:nil]) {
        _delegate = delegate;
        _category = Category_Bookmarks;
        _isBackUp = YES;
        _backupDecryptAbove4 = abve4;
        _node = node;
    }
    return self;
}

- (id)initiCloudWithiCloudBackUp:(IMBiCloudBackup *)icloudBackup WithDelegate:(id)delegate{
    if ([super initWithNibName:@"IMBBookMarkViewController" bundle:nil]) {
        _delegate = delegate;
        _category = Category_Bookmarks;
        _isBackUp = YES;
        _iCloudBackup= icloudBackup;
        _isiCloud = YES;
        _isiCloudView = YES;
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    self = [super initWithIpod:ipod withCategoryNodesEnum:category withDelegate:delegate];
    if (self) {
        _isBackUp = NO;
        //获取数据
        _playlistArray = (NSMutableArray *)[[_information bookmarkArray] retain];
         _dataSourceArray = [[NSMutableArray alloc]init];
        _rootBookmark = [[IMBBookmarkEntity alloc] init];
        _rootBookmark.name = CustomLocalizedString(@"MenuItem_id_21", nil);
        _rootBookmark.isFolder = YES;
        _rootBookmark.childBookmarkArray = _playlistArray;
        _ipod = [ipod retain];
        _bookmarkManager = [[IMBBookmarksManager alloc] initWithAMDevice:_ipod.deviceHandle];
        _bookmarkManager.allkeys = [_bookmarkManager getAllkeys:_playlistArray];
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        if (_dataSourceArray.count == 0) {
            [self configNoDataView];
            [_noDataTitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_59", nil)]];
            [_noDataTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
        }else {
            
        }
    });
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [_backUpNodataView setIsGradientColorNOCornerPart3:YES];
//    [_deviceLoadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
//    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_deviceLoadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [self configNoDataView];
    alerView = [[IMBAlertViewController alloc]initWithNibName:@"IMBAlertViewController" bundle:nil];
    _broBookVC = [[IMBBrowserBookMarkViewController alloc] initWithNibName:@"IMBBrowserBookMarkViewController" bundle:nil];
    [_loadingAnmationView startAnimation];
    [_rightMainBox setContentView:_containTableOutlineView];
    
    [_scrollView setHastopBorder:NO leftBorder:NO BottomBorder:NO rightBorder:NO];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];//
    [_editMenuItem setTitle:CustomLocalizedString(@"Bookmark_id_5", nil)];
    [_addFolderMenuItem setTitle:CustomLocalizedString(@"Bookmark_id_3", nil)];
    [_addBookMarkMenuItem setTitle:CustomLocalizedString(@"Bookmark_id_4", nil)];
    [_deletMenuItem setTitle:CustomLocalizedString(@"Menu_Delete", nil)];
    [_deleteTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_deleteTitle setStringValue:CustomLocalizedString(@"MSG_COM_Adding", nil)];
    if (_isBackUp) {
        [_loadingBox setContentView:_loadingView];
        [_outlineView setMenu:nil];
//        [self.view setFrame:NSMakeRect(0, 0, 800, 534)];
//        [_scrollView setFrame:NSMakeRect(0, 0, 800, 534)];
        [self.view setFrame:NSMakeRect(0, 0, 800, 536)];
        [_containTableOutlineView setFrame:NSMakeRect(0, 0, 540, 534)];
        [_rightScrollView setFrame:NSMakeRect(0, 0, 541, 536)];
        [_rightMainBox setFrame:NSMakeRect(259, 0, 541, 536)];
        [_loadingBox setFrame:NSMakeRect(0, 0, 800, 536)];
        [_lineView setFrame:NSMakeRect(259, 0, 1, 536)];
        [_scrollView setFrame:NSMakeRect(0, 0, 259, 536)];
        [_noDataView setFrame:NSMakeRect(0, 0, 540, 534)];
        [_noDataImageView setFrameOrigin:NSMakePoint((_noDataView.frame.size.width - _noDataImageView.frame.size.width)/2, _noDataImageView.frame.origin.y)];
        [_noDaScrollView setFrameOrigin:NSMakePoint((_noDataView.frame.size.width -_noDaScrollView.frame.size.width)/2, _noDaScrollView.frame.origin.y)];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            IMBBookMarkSqliteManager *bookMarkManager = nil;
            if (_isiCloud) {
                bookMarkManager = [[IMBBookMarkSqliteManager alloc] initWithiCloudBackup:_iCloudBackup withType:_iCloudBackup.iOSVersion];
            }else{
                bookMarkManager = [[IMBBookMarkSqliteManager alloc] initWithAMDevice:nil backupfilePath:_node.backupPath withDBType:_node.productVersion WithisEncrypted:_node.isEncrypt withBackUpDecrypt:_backupDecryptAbove4];
            }
            
            NSMutableArray *ary =  [bookMarkManager queryAllBookmarks] ;
            dispatch_async(dispatch_get_main_queue(), ^{
                _playlistArray = [ary retain];
                _dataSourceArray = [[NSMutableArray alloc]init];
                _rootBookmark = [[IMBBookmarkEntity alloc] init];
                _rootBookmark.name = CustomLocalizedString(@"MenuItem_id_21", nil);
                //    _rootBookmark = [_playlistArray objectAtIndex:3];
                _rootBookmark.isFolder = YES;
                _rootBookmark.childBookmarkArray = _playlistArray;
                [_loadingBox setContentView:nil];

                if (_playlistArray.count == 0) {
                    if (_isiCloud) {
                        [_loadingBox setContentView:_backUpNodataView];
                        [_loadingBox setContentView:_backUpNodataView];
                        [_noDataTitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_59", nil)]];
                        [_noDataTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
                    }else {
                        [_rightMainBox setContentView:_noDataView];
                    }
                    
                    NSString *promptStr = @"";
                    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_59", nil)];
                    NSString *overStr = @"";
                    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
                    [_textView setLinkTextAttributes:linkAttributes];
                    [_textView setSelectable:NO];
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
                    
                }else {
                    _outlineView.singleDelegate = self;
                    _outlineView.allowsEmptySelection = NO;
                    //默认选中第一个
                    [_outlineView expandItem:_rootBookmark];
                    if (_playlistArray.count == 0) {
                        [_outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                    }else {
                        [_outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
                        [_outlineView setNeedsDisplay:YES];
                        [_outlineView reloadData];
                    }
                    _outlineView.selectionHighlightColor = [StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)];
                    [_outlineView setFocusRingType:NSFocusRingTypeNone];
                    [_outlineView expandItem:_rootBookmark];
                    _outlineView.allowsEmptySelection = NO;
                    
                    [_rightMainBox setContentView:_containTableOutlineView];
                    //        [self changeSonTableViewData:0];
                    
                }
//                [_outlineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
                [_outlineView setBackgroundColor:[NSColor clearColor]];
                [_outlineView reloadData];
                [_itemTableView reloadData];

            });
        });
        
    }else{
        _outlineView.singleDelegate = self;
        _outlineView.allowsEmptySelection = NO;
        //默认选中第一个
        [_outlineView expandItem:_rootBookmark];
        if (_playlistArray.count == 0) {
            [_outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        }else {
            [_outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
            [_outlineView setNeedsDisplay:YES];
            [_outlineView reloadData];
        }
        _outlineView.selectionHighlightColor = [StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)];
        [_outlineView setFocusRingType:NSFocusRingTypeNone];
        [_outlineView expandItem:_rootBookmark];
        _outlineView.allowsEmptySelection = NO;
    }
 
//    [_outlineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_outlineView setBackgroundColor:[NSColor clearColor]];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeAddBookMarkAlert:) name:DeviceDisConnectedNotification object:nil];
 }

- (void)changeSkin:(NSNotification *)notification
{
//    [_deviceLoadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
//    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_deviceLoadingView setIsGradientColorNOCornerPart3:YES];
    [_deviceLoadingView setNeedsDisplay:YES];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];//
    [_deleteTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    _outlineView.selectionHighlightColor = [StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)];
//    [_outlineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_outlineView setBackgroundColor:[NSColor clearColor]];
    [self configNoDataView];
    [_backUpNodataView setNeedsDisplay:YES];
    [_itemTableView reloadData];
    [_outlineView reloadData];
    [_loadingAnmationView setNeedsDisplay:YES];
    [_deviceAnimationView setNeedsDisplay:YES];
    [_backUpNodataView setIsGradientColorNOCornerPart3:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
}

#pragma mark - NSTextView
- (void)configNoDataView {
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_bookMark"]];
    [_textView setDelegate:self];
    if (_isBackUp) {
        NSString *promptStr = @"";
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_59", nil)];
        NSString *overStr = @"";
        NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
        [_textView setLinkTextAttributes:linkAttributes];
        [_textView setSelectable:NO];
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
        [_textView setNeedsDisplay:YES];
        [mutParaStyle release];
        mutParaStyle = nil;
    }else{
        NSString *promptStr = @"";
         NSString *overStr = CustomLocalizedString(@"NO_DATA_TITLE_2", nil);
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_59", nil)] stringByAppendingString:overStr];
       
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
}

#pragma mark - NSOutlineViewDataSource
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if (item == nil) {
        return 1;
    }else
    {
        IMBBookmarkEntity *bookmark = (IMBBookmarkEntity *)item;
        return [[bookmark childBookmarkArray] count];
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if (item == nil) {
        return _rootBookmark;
    }else
    {
        
        IMBBookmarkEntity *bookmark = (IMBBookmarkEntity *)item;
        return [[bookmark childBookmarkArray] objectAtIndex:index];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    
    IMBBookmarkEntity *bookmark = (IMBBookmarkEntity *)item;
    return bookmark.isFolder;
    
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    
    IMBBookmarkEntity *bookmark = (IMBBookmarkEntity *)item;
    return bookmark.name;
}

#pragma mark - NSOutlineViewdelegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSMutableArray *disPlayAry = nil;
    if (_isSearch) {
        disPlayAry = _researchdataSourceArray;
    }else{
        disPlayAry = _dataSourceArray;
    }
    if (disPlayAry.count <= 0) {
        return 0;
    }
    return [disPlayAry count];
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
    return 32;
}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    
    IMBBookmarkEntity *bookmark = (IMBBookmarkEntity *)item;
    IMBImageAndTextCell *imageCell = (IMBImageAndTextCell *)cell;
    IMBBookmarkEntity *selectedNode = nil;
    NSInteger row = [_outlineView selectedRow];
    if (row != -1) {
        selectedNode = [_outlineView itemAtRow:row];
    }
    if (bookmark.isFolder) {
        [imageCell setMarginX:5];
        [imageCell setImageSize:NSMakeSize(16, 16)];
        if (selectedNode != bookmark) {
            [imageCell setImage:[StringHelper imageNamed:@"nav_folder1"]];
            [imageCell setImageName:@"nav_folder1"];
        }else {
            [imageCell setImage:[StringHelper imageNamed:@"nav_folder2"]];
            [imageCell setImageName:@"nav_folder2"];
        }
    }else
    {
        [imageCell setMarginX:5];
        [imageCell setImageSize:NSMakeSize(16, 16)];
        if (selectedNode != bookmark) {
            [imageCell setImage:[StringHelper imageNamed:@"nav_bookmark1"]];
            [imageCell setImageName:@"nav_bookmark1"];
        }else {
            [imageCell setImage:[StringHelper imageNamed:@"nav_bookmark2"]];
            [imageCell setImageName:@"nav_bookmark2"];
        }
    }
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    [_dataSourceArray removeAllObjects];
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    NSInteger row = [_outlineView selectedRow];
    IMBBookmarkEntity *bookmark = nil;
    if (row != -1 && [_playlistArray count]>0) {
        bookmark = [_outlineView itemAtRow:row];
    }

    if (bookmark.isFolder) {
        [_dataSourceArray addObjectsFromArray:bookmark.allBookmarkArray];
        if (row == 0) {
            for (IMBBookmarkEntity *entity in _playlistArray) {
                if (!entity.isFolder) {
                    [_dataSourceArray addObject:entity];
                }
            }
        }

//        if (![_outlineView isItemExpanded:bookmark]) {
//            [_outlineView expandItem:bookmark expandChildren:NO];
//        }else
//        {
//            [_outlineView collapseItem:bookmark collapseChildren:YES];
//        }
    }else if(bookmark != nil) {
        [_dataSourceArray addObject:bookmark];
    }
    
    
    if (_dataSourceArray.count == 0) {
        [_rightMainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        for (IMBBookmarkEntity *entity in _dataSourceArray) {
            entity.checkState = UnChecked;
        }
        [_itemTableView changeHeaderCheckState:UnChecked];
        [_itemTableView deselectAll:nil];
        [_rightMainBox setContentView:_containTableOutlineView];
    }

    NSIndexSet *sets = [self selectedItems];
    [_itemTableView selectRowIndexes:sets byExtendingSelection:NO];
    [_itemTableView reloadData];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    return NO;
}

#pragma - mark singleDelegate
- (void)outlineView:(NSOutlineView *)outlineView row:(NSInteger)index {
    IMBBookmarkEntity *node = nil;
    if (index != -1) {
        node = [_outlineView itemAtRow:index];
    }
    if (node.isFolder) {
        if (![_outlineView isItemExpanded:node]) {
            [_outlineView expandItem:node expandChildren:NO];
        }else
        {
            [_outlineView collapseItem:node collapseChildren:YES];
        }
        return;
    }
}

#pragma mark - NSTableViewDataSource
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <= 0) {
        return @"";
    }
    IMBBookmarkEntity *bookMark = [displayArray objectAtIndex:row];
    if ([@"Title" isEqualToString:tableColumn.identifier] ) {
        return bookMark.name;
    }else if ([@"URL" isEqualToString:tableColumn.identifier]) {
        return bookMark.url;
    }else if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
        return [NSNumber numberWithInt:bookMark.checkState];
    }
    return @"";
}

- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
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
    IMBBookmarkEntity *bookMark = [displayArray objectAtIndex:index];
    bookMark.checkState = !bookMark.checkState;
    //点击checkBox 实现选中行
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[displayArray count]; i++) {
        IMBBookmarkEntity *bookMark= [displayArray objectAtIndex:i];
        if (bookMark.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
    
    if (bookMark.checkState == NSOnState) {
//        [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    }else if (bookMark.checkState == NSOffState)
    {
        [_itemTableView deselectRow:index];
    }
    if (set.count == displayArray.count) {
        [_itemTableView changeHeaderCheckState:NSOnState];
    }else if (set.count == 0){
        [_itemTableView changeHeaderCheckState:NSOffState];
    }else{
        [_itemTableView changeHeaderCheckState:NSMixedState];
    }
    [_itemTableView reloadData];
}

#pragma mark - NSTableViewdelegate
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView *atableView = [notification object];
    if (atableView == _itemTableView) {
//        NSIndexSet *set = [_itemTableView selectedRowIndexes];
//        for (int i=0; i<[_dataSourceArray count]; i++) {
//            IMBBookmarkEntity *bookMark = [_dataSourceArray objectAtIndex:i];
//            if ([set containsIndex:i]) {
//                [bookMark setCheckState:NSOnState];
//            }else{
//                [bookMark setCheckState:NSOffState];
//            }
//        }
//        if ([set count] == [_dataSourceArray count]&&[_dataSourceArray count]>0) {
//            [_itemTableView changeHeaderCheckState:NSOnState];
//        }else if ([set count] == 0) {
//            [_itemTableView changeHeaderCheckState:NSOffState];
//        }else {
//            [_itemTableView changeHeaderCheckState:NSMixedState];
//        }
    }
    [_itemTableView reloadData];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 32;
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    id cell = [tableColumn headerCell];
    NSString *identify = [tableColumn identifier];
    NSArray *array = [tableView tableColumns];
    for (NSTableColumn  *column in array) {
        if ([column.headerCell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *columnHeadercell = (IMBCustomHeaderCell *)column.headerCell;
            if ([column.identifier isEqualToString:identify]) {
                [columnHeadercell setIsShowTriangle:YES];
            }else {
                [columnHeadercell setIsShowTriangle:NO];
            }
        }
        
    }
    NSMutableArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <= 0) {
        return ;
    }
	if ( [@"Title" isEqualToString:identify] || [@"URL" isEqualToString:identify]) {
        if ([cell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *customHeaderCell = (IMBCustomHeaderCell *)cell;
            if (customHeaderCell.ascending) {
                customHeaderCell.ascending = NO;
            }else
            {
                customHeaderCell.ascending = YES;
            }
            [self sort:customHeaderCell.ascending key:identify dataSource:displayArray];
        }
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (int i=0;i<[displayArray count]; i++) {
            IMBTrack *track = [displayArray objectAtIndex:i];
            if (track.checkState == NSOnState) {
                [set addIndex:i];
            }
        }
        
//        [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    }

    [_itemTableView reloadData];
}

- (void)sort:(BOOL)isAscending key:(NSString *)key dataSource:(NSMutableArray *)array {
    if ([key isEqualToString:@"Title"]) {
        key = @"name";
    } else if ([key isEqualToString:@"URL"]) {
        key = @"url";
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    [_itemTableView reloadData];
    
    [sortDescriptor release];
    [sortDescriptors release];
}


- (void)setAllselectState:(CheckStateEnum)checkState {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[disAry count]; i++) {
        IMBBookmarkEntity *bookMark = [disAry objectAtIndex:i];
        [bookMark setCheckState:checkState];
        if (bookMark.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
//    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    [_itemTableView reloadData];
}

- (void)menuNeedsUpdate:(NSMenu *)menu {
    
    NSInteger seletedRow = [_outlineView selectedRow];
    IMBBookmarkEntity *bookmark = nil;
    if (seletedRow != -1) {
        bookmark = [_outlineView itemAtRow:seletedRow];
    }else
    {
        return;
    }
        if ([bookmark isFolder]) {
            NSArray *itemArray = [_outlineViewMenu itemArray];
            if (bookmark == _rootBookmark) {
                for (NSMenuItem *item in itemArray) {
                    if (item.tag == 101)
                    {
                        [item setHidden:NO];
                    }if (item.tag == 102)
                    {
                        [item setHidden:NO];
                    }else if (item.tag == 100) {
                        [item setHidden:YES];
                        
                    }else if (item.tag == 103)
                    {
                        [item setHidden:YES];
                    }else if (item.tag == 104)
                    {
                        [item setHidden:YES];
                    }else if (item.tag == 105)
                    {
                        [item setHidden:NO];
                    }else if (item.tag == 106)
                    {
                        [item setHidden:YES];
                    }
                }
                
            }else {
                for (NSMenuItem *item in itemArray) {
                    
                    if (item.tag == 101) {
                        [item setHidden:NO];
                        
                    }else if (item.tag == 102)
                    {
                        [item setHidden:NO];
                    }else if (item.tag == 104)
                    {
                        [item setHidden:NO];
                    }else if (item.tag == 105)
                    {
                        [item setHidden:NO];
                    } if (item.tag == 100) {
                        [item setHidden:NO];
                        
                    }else if (item.tag == 103)
                    {
                        [item setHidden:NO];
                    }else if (item.tag == 106)
                    {
                        [item setHidden:NO];
                    }
                }
            }
        }else
        {
            NSArray *itemArray = [_outlineViewMenu itemArray];
            
            for (NSMenuItem *item in itemArray) {
                
                if (item.tag == 101) {
                    [item setHidden:YES];
                    
                }else if (item.tag == 102)
                {
                    [item setHidden:YES];
                }else if (item.tag == 104)
                {
                    [item setHidden:YES];
                }else if (item.tag == 105)
                {
                    [item setHidden:YES];
                }else if (item.tag == 106)
                {
                    [item setHidden:NO];
                }else if (item.tag == 100)
                {
                    [item setHidden:NO];
                }else if (item.tag == 103)
                {
                    [item setHidden:NO];
                }
            }
    }
}

- (void)addAnimtion {
    [_loadingBox setContentView:_deleteView];
    [self startAnimation];
}

//无动画
- (void)reloadData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            //刷新方式，重新读取
            [_information loadBookmark];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (_playlistArray != nil) {
                    [_playlistArray release];
                    _playlistArray = nil;
                }
                if (_rootBookmark != nil) {
                    [_rootBookmark release];
                    _rootBookmark = nil;
                }
                
                _playlistArray = (NSMutableArray *)[[_information bookmarkArray] retain];
                _rootBookmark = [[IMBBookmarkEntity alloc] init];
                _rootBookmark.name = CustomLocalizedString(@"MenuItem_id_21", nil);
                _rootBookmark.isFolder = YES;
                _rootBookmark.childBookmarkArray = _playlistArray;
                for (IMBBookmarkEntity *bookmark in _playlistArray) {
                    bookmark.parentNode = _rootBookmark;
                }
                
                [_outlineView reloadData];
                [_outlineView expandItem:_rootBookmark expandChildren:NO];
                if ([_playlistArray count]>0) {
                    [_outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
                }
                NSInteger row = [_outlineView selectedRow];
                IMBBookmarkEntity *bookmark = nil;
                if (row != -1) {
                    bookmark = [_outlineView itemAtRow:row];
                }
                if (_dataSourceArray != nil) {
                    [_dataSourceArray release];
                    _dataSourceArray = nil;
                }
                _dataSourceArray = [[NSMutableArray alloc]init];
                if (bookmark.isFolder) {
                    [_dataSourceArray addObjectsFromArray:bookmark.allBookmarkArray];
                }else if(bookmark != nil)
                {
                    [_dataSourceArray addObject:bookmark];
                }
                [_loadingBox setContentView:nil];
                [self stopAnimation];
                if (_dataSourceArray.count == 0) {
                    [_rightMainBox setContentView:_noDataView];
                    [self configNoDataView];
                }else {
                    [_rightMainBox setContentView:_containTableOutlineView];
                }
                [_deviceAnimationView endAnimation];
                [_itemTableView reloadData];
            });
        }
    });
}

- (IBAction)editMenuClick:(id)sender {
     NSInteger row = [_outlineView selectedRow];
    IMBBookmarkEntity *bookmark = [_outlineView itemAtRow:row];
    if (bookmark.isFolder) {
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        NSString *string = [CustomLocalizedString(@"Bookmark_id_1", nil) stringByAppendingString:@":"];
        NSInteger result = [alerView showTitleName:string InputTextFiledString:bookmark.name OkButton:CustomLocalizedString(@"Button_Ok", nil)  CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
        if (result == 1) {
            //进行操作
            [alerView.renameLoadingView setHidden:NO];
            [alerView.renameLoadingView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
            [alerView.renameLoadingView setImage:[StringHelper imageNamed:@"registedLoading"]];
            [alerView.renameLoadingView.layer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:-2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
            NSString *inputName = [[alerView reNameInputTextField] stringValue];
            if (![TempHelper stringIsNilOrEmpty:inputName]) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    IMBBookmarkEntity *moBookmark = [[IMBBookmarkEntity alloc] initBookmarkWithName:inputName url:nil];
                    moBookmark.isFolder = bookmark.isFolder;
                    moBookmark.parent = bookmark.parent;
                    moBookmark.url = bookmark.url;
                    moBookmark.position = bookmark.position;
                    moBookmark.bookMarksId = bookmark.bookMarksId;
                    
                    [_bookmarkManager openMobileSync];
                    BOOL success = [_bookmarkManager modifyBookmark:moBookmark];
                    [_bookmarkManager closeMobileSync];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [alerView unloadAlertView:alerView.reNameView];
                        [alerView.renameLoadingView setHidden:YES];
                        if (success) {
                            [_outlineView reloadItem:bookmark];
                        }
                        [self reload:nil];
                    });
                });
            }
        }
    }else {
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        NSString *firstString = [NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"Bookmark_id_1",nil),@":"];
        NSString *secondString = [NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"Bookmark_id_2", nil),@":"];
        
        NSInteger result = [alerView showfirstName:firstString  SecondName:secondString  FirstInputString:bookmark.name SecondInputString:bookmark.url OkButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
        if (result == 1) {
            //进行操作
            [alerView.renameLoadingView setHidden:NO];
            [alerView.renameLoadingView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
            [alerView.renameLoadingView setImage:[StringHelper imageNamed:@"registedLoading"]];
            [alerView.renameLoadingView.layer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:-2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
//            NSString *inputName = [[alerView reNameInputTextField] stringValue];
            NSString *str1 = [[alerView addEditBookMarkTitleInputTextFiled]stringValue];
            NSString *str2 = [[alerView addEditBookMarkURLInputTextFiled] stringValue];
            if (![TempHelper stringIsNilOrEmpty:str1] && ! [TempHelper stringIsNilOrEmpty:str2]) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    IMBBookmarkEntity *moBookmark = [[IMBBookmarkEntity alloc] initBookmarkWithName:[[alerView addEditBookMarkTitleInputTextFiled]stringValue]  url:[[alerView addEditBookMarkURLInputTextFiled] stringValue]];
                    moBookmark.isFolder = bookmark.isFolder;
                    if (bookmark.parent == nil) {
                        bookmark.parent = [[NSArray alloc]init];
                    }
                    moBookmark.parent = bookmark.parent;
                    moBookmark.position = bookmark.position;
                    moBookmark.bookMarksId = bookmark.bookMarksId;
                    [_bookmarkManager openMobileSync];
                    BOOL success = [_bookmarkManager modifyBookmark:moBookmark];
                    [_bookmarkManager closeMobileSync];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [alerView unloadAlertView:alerView.reNameView];
                        [alerView.renameLoadingView setHidden:YES];
                        if (success) {
                            [_outlineView reloadItem:bookmark];
                            [_itemTableView reloadData];
                        }
                        [self reload:nil];
                    });
                });
            }
        }
    }
}

- (IBAction)addFolderMenuClick:(id)sender {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    NSString *string = [CustomLocalizedString(@"Bookmark_id_1", nil) stringByAppendingString:@":"];
    NSInteger result = [alerView showTitleName:string InputTextFiledString:@"" OkButton:CustomLocalizedString(@"Button_Ok", nil)  CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
    if (result == 1) {
        //进行操作
        [alerView.renameLoadingView setHidden:NO];
        [alerView.renameLoadingView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [alerView.renameLoadingView setImage:[StringHelper imageNamed:@"registedLoading"]];
        [alerView.renameLoadingView.layer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:-2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
        NSString *inputName = [[alerView reNameInputTextField] stringValue];
        if (![TempHelper stringIsNilOrEmpty:inputName]) {
            NSInteger row = [_outlineView selectedRow];
            IMBBookmarkEntity *node  = nil;
            if (row != -1) {
                node = [_outlineView itemAtRow:row];
            }
            if (node != nil) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    IMBBookmarkEntity *entity = [[IMBBookmarkEntity alloc] init];
                    entity.name = inputName;
                    entity.isFolder = YES;
                    if (node.bookMarksId.length > 0) {
                        NSMutableArray *parentArray = [NSMutableArray array];
                        [parentArray addObject:node.bookMarksId];
                        entity.parent = parentArray;
                    }
                    [_bookmarkManager openMobileSync];
                    NSString *key = [_bookmarkManager insertBookmark:entity];
                    [_bookmarkManager closeMobileSync];
                    entity.bookMarksId = key;
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self showRefrshLoading:NO];
                        if (key != nil) {
                            if (node == _rootBookmark) {
                                [_playlistArray addObject:entity];
                                entity.parentNode = _rootBookmark;
                                [_outlineView reloadItem:_rootBookmark reloadChildren:YES];
                                [_outlineView expandItem:_rootBookmark expandChildren:NO];
                            }else
                            {
                                [node.childBookmarkArray addObject:entity];
                                entity.parentNode = node;
                                [_outlineView reloadItem:node reloadChildren:YES];
                                [_outlineView expandItem:node expandChildren:NO];
                                [_itemTableView reloadData];
                            }
                        }
                        [entity release];
                        [alerView unloadAlertView:alerView.reNameView];
                        [alerView.renameLoadingView setHidden:YES];
                        [self reload:nil];
                        //刷新categorybutton的badgecoun

                    });
                });
            }
        }
    }
}

- (IBAction)addBookmarkMenuClick:(id)sender {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    NSString *firstString = [NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"Bookmark_id_1",nil),@":"];
    NSString *secondString = [NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"Bookmark_id_2", nil),@":"];
     NSInteger result = [alerView showfirstName:firstString  SecondName:secondString FirstInputString:@"" SecondInputString:@"" OkButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
    if (result == 1) {
        //进行操作
        NSInteger row = [_outlineView selectedRow];
        IMBBookmarkEntity *node  = nil;
        if (row != -1) {
            node = [_outlineView itemAtRow:row];
        }
        if (node != nil) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                IMBBookmarkEntity *entity = [[IMBBookmarkEntity alloc] init];
                entity.name = [[alerView addEditBookMarkTitleInputTextFiled] stringValue];
                entity.url = [[alerView addEditBookMarkURLInputTextFiled] stringValue];
                entity.isFolder = NO;
                if (node.bookMarksId.length > 0) {
                    NSMutableArray *parentArray = [NSMutableArray array];
                    [parentArray addObject:node.bookMarksId];
                    entity.parent = parentArray;
                }
                [_bookmarkManager openMobileSync];
                NSString *key = [_bookmarkManager insertBookmark:entity];
                [_bookmarkManager closeMobileSync];
                entity.bookMarksId = key;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (key != nil) {
                        if (node == _rootBookmark) {
                            [_playlistArray addObject:entity];
                            entity.parentNode = _rootBookmark;
                            [_outlineView reloadItem:_rootBookmark reloadChildren:YES];
                            [_outlineView expandItem:_rootBookmark expandChildren:NO];
                        }else
                        {
                            [node.childBookmarkArray addObject:entity];
                            [node.allBookmarkArray addObject:entity];
                            entity.parentNode = node;
                            [_outlineView reloadItem:node reloadChildren:YES];
                            [_outlineView expandItem:node expandChildren:NO];
                            [_itemTableView reloadData];
                        }
                        
                    }
                    [entity release];
                    [self reload:nil];
                    //刷新categorybutton的badgecount
                });
                
            });
        }
    }
}

- (IBAction)deleteMenuClick:(id)sender {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    NSString *string = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete_2", nil) ;
    NSInteger result = [alerView showDeleteConfrimText:string OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
    if (result == 0) {
        return;
    }

    [_outlineView beginUpdates];
    NSInteger row = [_outlineView selectedRow];
    IMBBookmarkEntity *node  = nil;
    if (row != -1) {
        node = [_outlineView itemAtRow:row];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_bookmarkManager openMobileSync];
        BOOL issuccess = [_bookmarkManager deleteBookmarks:[NSArray arrayWithObject:node.bookMarksId]];
        [_bookmarkManager closeMobileSync];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (issuccess) {
                IMBBookmarkEntity *parentnode = [node parentNode];
                NSMutableArray *childarr = [parentnode childBookmarkArray];
                if (parentnode == _rootBookmark) {
                    childarr = _playlistArray;
                }
                NSInteger index = [childarr indexOfObject:node];
                [childarr removeObjectAtIndex:index];
                [_outlineView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parentnode withAnimation:NSTableViewAnimationEffectFade | NSTableViewAnimationSlideLeft];
                [_outlineView endUpdates];
            }
            [self reload:nil];
        });
    });
}

#pragma mark - Actions
- (void)reload:(id)sender {
    BOOL open = [self chekiCloud:@"Bookmarks" withCategoryEnum:_category];
    if (!open) {
        return;
    }
    [self disableFunctionBtn:NO];
    [_searchFieldBtn setStringValue:@""];
    _isSearch = NO;
    [_loadingBox setContentView:_deviceLoadingView];
    [_deviceAnimationView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            //刷新方式，重新读取
            [_information loadBookmark];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self disableFunctionBtn:YES];
                if (_playlistArray != nil) {
                    [_playlistArray release];
                    _playlistArray = nil;
                }
                if (_rootBookmark != nil) {
                    [_rootBookmark release];
                    _rootBookmark = nil;
                }
                
                _playlistArray = (NSMutableArray *)[[_information bookmarkArray] retain];
                _rootBookmark = [[IMBBookmarkEntity alloc] init];
                _rootBookmark.name = CustomLocalizedString(@"MenuItem_id_21", nil);
                _rootBookmark.isFolder = YES;
                _rootBookmark.childBookmarkArray = _playlistArray;
                for (IMBBookmarkEntity *bookmark in _playlistArray) {
                    bookmark.parentNode = _rootBookmark;
                }
                
                [_outlineView reloadData];
                [_outlineView expandItem:_rootBookmark expandChildren:NO];
                if ([_playlistArray count]>0) {
                    [_outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
                }
                NSInteger row = [_outlineView selectedRow];
                IMBBookmarkEntity *bookmark = nil;
                if (row != -1) {
                    bookmark = [_outlineView itemAtRow:row];
                }
                if (_dataSourceArray != nil) {
                    [_dataSourceArray release];
                    _dataSourceArray = nil;
                }
                _dataSourceArray = [[NSMutableArray alloc]init];
                if (bookmark.isFolder) {
                    [_dataSourceArray addObjectsFromArray:bookmark.allBookmarkArray];
                }else if(bookmark != nil)
                {
                    [_dataSourceArray addObject:bookmark];
                }
                [_loadingBox setContentView:nil];
                if (_dataSourceArray.count == 0) {
                    [_rightMainBox setContentView:_noDataView];
                    [self configNoDataView];
                }else {
                    [_rightMainBox setContentView:_containTableOutlineView];
                }
                int count = (int)[_rootBookmark childBookmarkArray].count;
                if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                    [_delegate refeashBadgeConut:count WithCategory:_category];
                }
                
                [_deviceAnimationView endAnimation];
                [_itemTableView reloadData];
      
            });
        }
    });
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _isSearch = YES;
    _searchFieldBtn = searchBtn;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
        if (_researchdataSourceArray.count <=0) {
        }
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
        IMBBookmarkEntity *bookMark = [disAry objectAtIndex:i];
        if (bookMark.checkState == NSOnState) {
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

- (void)addItems:(id)sender {
    if (_ipod.beingSynchronized) {
        [self showAlertText:CustomLocalizedString(@"AirsyncTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    [_broBookVC showBrowserWithAddButton:CustomLocalizedString(@"Common_id_7", nil) OkButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view ImportBookmarkBlock:^(NSInteger tag, NSMutableArray *bookmarkArray, NSInteger btag) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (btag == 0) {//creatView页面
                [self importCustom:[NSMutableArray arrayWithArray:bookmarkArray]];
            }else if (btag == 1) {//Import页面
                if (tag == 1) { //选中的是safari浏览器
                    [self importSafariBookmarks];
                }else if (tag == 2) {//选中的是google浏览器
                    [self importGoogleBookmarks];
                }else if (tag == 3) { //选中的是火狐浏览器
                    [self importFirefoxBookmarks];
                }
            }
        });
    }];
}

- (void)deleteItems:(id)sender {
    NSInteger row = [_outlineView selectedRow];
    IMBBookmarkEntity *node  = nil;
    if (row != -1) {
        node = [_outlineView itemAtRow:row];
    }else
    {
        return;
    }
    
    NSIndexSet *seletedSet = [_itemTableView selectedRowIndexes];
    if ([seletedSet count]>0) {
        NSMutableArray *selectedItems = [NSMutableArray array];
        NSMutableArray *displayArray = nil;
        if (_isSearch) {
            displayArray = _researchdataSourceArray;
        }
        else{
            displayArray = _dataSourceArray;
        }
        
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        NSString *string = nil;
        if (seletedSet.count > 1) {
            string = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete", nil) ;
        }else {
            string = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete_2", nil) ;
        }
      
        NSInteger result = [alerView showDeleteConfrimText:string OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
        if (result == 0) {
            return;
        }
  
        [seletedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            IMBBookmarkEntity *bookmark = [displayArray objectAtIndex:idx];
            [selectedItems addObject:bookmark];
        }];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [_bookmarkManager openMobileSync];
            NSMutableArray *seletedID = [NSMutableArray array];
            for (IMBBookmarkEntity *entity in selectedItems) {
                [seletedID addObject:entity.bookMarksId];
            }
            BOOL success = [_bookmarkManager deleteBookmarks:seletedID];
            if (success) {
                [displayArray removeObjectsInArray:selectedItems];
                if (node.isFolder) {
                    [node.childBookmarkArray removeObjectsInArray:selectedItems];
                }
            }
            [_bookmarkManager closeMobileSync];
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if (node.isFolder) {
                    [_outlineView reloadItem:node reloadChildren:YES];
                }else
                {   IMBBookmarkEntity *parent = node.parentNode;
                    [parent.childBookmarkArray removeObject:node];
                    [parent.allBookmarkArray removeObject:node];
                    [_outlineView reloadItem:parent reloadChildren:YES];
                    if (parent.allBookmarkArray.count > 0) {
                        [_rightMainBox setContentView:_containTableOutlineView];
                        [_itemTableView reloadData];
                    }else {
                        [_rightMainBox setContentView:_noDataView];
                        [self configNoDataView];
                    }
                }
                [self reload:nil];
            });
            });
//        }else
//        {
//            return;
//        }
        
    }else
    {
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        NSString *str = nil;
        if (_dataSourceArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_delete", nil),CustomLocalizedString(@"MenuItem_id_59", nil)];
        }else {
            str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        }
        
        [alerView showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil) SuperView:view];
    }

}

- (void)importCustom:(NSMutableArray *)arr {
//    [self addAnimtion];
    NSString *str = CustomLocalizedString(@"MSG_COM_Adding", nil);
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            [view setHidden:NO];
            break;
        }
    }
    [_alertViewController showDeleteAnimationViewAlertText:str SuperView:view];
    IMBBookmarkEntity *node  = nil;
    IMBBookmarkEntity *rootBookmark = nil;
    int row = (int)[_outlineView selectedRow];;
    node = [_outlineView itemAtRow:row];
    if (!node.isFolder) {
        rootBookmark = node.parentNode;
    }else {
        rootBookmark = node;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (IMBBookmarkEntity *entity in arr) {
            if (rootBookmark.bookMarksId.length > 0) {
                NSMutableArray *parentArray = [NSMutableArray array];
                [parentArray addObject:rootBookmark.bookMarksId];
                entity.parent = parentArray;
            }
            entity.isFolder = NO;
            [_bookmarkManager openMobileSync];
            NSString *key = [_bookmarkManager insertBookmark:entity];
            [_bookmarkManager closeMobileSync];
            entity.bookMarksId = key;
            if (key != nil) {
                if (node == _rootBookmark) {
                    [_playlistArray addObject:entity];
                    entity.parentNode = _rootBookmark;
                    [_outlineView reloadItem:_rootBookmark reloadChildren:YES];
                    [_outlineView expandItem:_rootBookmark expandChildren:NO];
                }else
                {
                    [node.childBookmarkArray addObject:entity];
                    [node.allBookmarkArray addObject:entity];
                    entity.parentNode = node;
                    [_outlineView reloadItem:node reloadChildren:YES];
                    [_outlineView expandItem:node expandChildren:NO];
                    [_itemTableView reloadData];
                }
                
            }
            [entity release];
         }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
                [_alertViewController unloadAlertView:_alertViewController.deleteAnimationView];
            });
    });
}

- (void)importSafariBookmarks {
//    [self addAnimtion];
    NSString *str = CustomLocalizedString(@"MSG_COM_Adding", nil);
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            [view setHidden:NO];
            break;
        }
    }
    [_alertViewController showDeleteAnimationViewAlertText:str SuperView:view];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            NSMutableArray *safariArray = [IMBParseBookmark parseSafariBookmarkByPlist];
            IMBBookmarkEntity *parent = [[IMBBookmarkEntity alloc] init];
            parent.parentNode = _rootBookmark;
            NSMutableArray *parentArray = [NSMutableArray array];
            if (_rootBookmark.bookMarksId != nil) {
                [parentArray addObject:_rootBookmark.bookMarksId];
            }
            parent.parent = parentArray;
            parent.isFolder = YES;
            parent.name = @"Safari";
            parent.childBookmarkArray = safariArray;
            [_bookmarkManager insertBookmarks:[NSMutableArray arrayWithObject:parent]];
            [parent release];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self showRefrshLoading:NO];
                  [_alertViewController unloadAlertView:_alertViewController.deleteAnimationView];
                //重新加载
                [self reloadData];
            });
        }
    });
}

- (void)importGoogleBookmarks {
//    [self addAnimtion];
    NSString *str = CustomLocalizedString(@"MSG_COM_Adding", nil);
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            [view setHidden:NO];
            break;
        }
    }
    [_alertViewController showDeleteAnimationViewAlertText:str SuperView:view];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            NSMutableArray *googleArray = [IMBParseBookmark parseChromeBookmarkByJSON];
            IMBBookmarkEntity *parent = [[IMBBookmarkEntity alloc] init];
            parent.isFolder = YES;
            parent.name = @"Google";
            parent.childBookmarkArray = googleArray;
            [_bookmarkManager insertBookmarks:[NSMutableArray arrayWithObject:parent]];
            [parent release];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self showRefrshLoading:NO];
                  [_alertViewController unloadAlertView:_alertViewController.deleteAnimationView];
                //重新加载
                [self reloadData];
            });
        }
    });
}

- (void)importFirefoxBookmarks{
//    [self addAnimtion];
    NSString *str = CustomLocalizedString(@"MSG_COM_Adding", nil);
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            [view setHidden:NO];
            break;
        }
    }
    [_alertViewController showDeleteAnimationViewAlertText:str SuperView:view];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            IMBParseBookmark *parseBookMark = [[IMBParseBookmark alloc]init];
            NSMutableArray *firefoxArray = [parseBookMark parseFirefoxBookmarkByDB];
            IMBBookmarkEntity *parent = [[IMBBookmarkEntity alloc] init];
            parent.isFolder = YES;
            parent.name = @"Firefox";
            parent.childBookmarkArray = firefoxArray;
            
            [_bookmarkManager insertBookmarks:[NSMutableArray arrayWithObject:parent]];
            [parent release];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self showRefrshLoading:NO];
               [_alertViewController unloadAlertView:_alertViewController.deleteAnimationView];
                //重新加载
                [self reloadData];
            });
        }
    });
}

- (void)startAnimation {
    [_animtionView setWantsLayer:YES];
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"position"];
    animation1.duration = 3; // 持续时间
    animation1.repeatCount = NSIntegerMax; // 重复次数
    animation1.autoreverses = NO;
    animation1.fromValue = [NSValue valueWithPoint:NSMakePoint(-100, 0)]; // 起始帧
    animation1.toValue = [NSValue valueWithPoint:NSMakePoint(500 , 0)];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _animtionView.layer.contents = [StringHelper imageNamed:@"transfer_light"];
    [_animtionView.layer addAnimation:animation1 forKey:@""];
}

- (void)stopAnimation {
    [_animtionView.layer removeAllAnimations];
}
#pragma mark - 断开当前设备
- (void)closeAddBookMarkAlert:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    if ([_ipod.uniqueKey isEqualToString:[dic objectForKey:@"UniqueKey"]]) {
        [_broBookVC cancelBtnClick:nil];
    }
}

- (void)dealloc {
    [_rootBookmark release],_rootBookmark = nil;
    if (_ipod != nil) {
        [_ipod release];
        _ipod = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DeviceDisConnectedNotification object:nil];
    [super dealloc];
}

@end
