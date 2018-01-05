//
//  IMBPlaylistViewController.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBPlaylistViewController.h"
#import "IMBiTunes.h"
#import "StringHelper.h"
#import "IMBImageAndTextCell.h"
#import "IMBBGColoerView.h"
#import "IMBCustomHeaderCell.h"
#import "IMBAnimation.h"
#import "IMBitunesLibraryViewController.h"
#import "ATTracker.h"
#import "CommonEnum.h"
@interface IMBPlaylistViewController ()

@end

@implementation IMBPlaylistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithCategory:(CategoryNodesEnum)category  withDelegate:(id)delegate {
    self = [super initWithNibName:@"IMBPlaylistViewController" bundle:nil];
    if (self) {
        _delegate = delegate;
        _iTunes = [IMBiTunes singleton];
        _category = category;
        if (_iTunes != nil) {
            _playlistArray = [[NSMutableArray alloc]init];
            NSArray *array = [_iTunes getNotCategoryiTLPlaylists];
            NSMutableArray *array1 = [[NSMutableArray alloc]init];
            NSMutableArray *array2 = [[NSMutableArray alloc]init];
            for (IMBiTLPlaylist *list in array) {
                if (list.isUserDefined == true) {
                    [array1 addObject:list];
                }else {
                    [array2 addObject:list];
                }
            }
            [_playlistArray addObjectsFromArray:array2];
            [_playlistArray addObjectsFromArray:array1];
            [array1 release], array1 = nil;
            [array2 release], array2 = nil;
            _dataSourceArray = (NSMutableArray *)[[_iTunes getiTLTracks] retain];
        }
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_playlistTableView setFocusRingType:NSFocusRingTypeNone];
    [_itemTableView setFocusRingType:NSFocusRingTypeNone];
    [_itemTableView setListener:self];
    [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:-1]byExtendingSelection:NO];
    [_playlistTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    [_bottomLevelLineView setBackgroundColor:[NSColor colorWithDeviceRed:218.0/255 green:218.0/255 blue:218.0/255 alpha:1.0]];
    [_verticalLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_topLevelLineView setBackgroundColor:[NSColor colorWithDeviceRed:218.0/255 green:218.0/255 blue:218.0/255 alpha:1.0]];
//    [_playlistTableView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"playlist_bgColor", nil)]];
    [_playlistTableView setBackgroundColor:[NSColor clearColor]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:CustomLocalizedString(@"ItunesLibrary_id_2", nil)];
    [attributedString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13.0] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithDeviceRed:53.0/255 green:53.0/255 blue:53.0/255 alpha:1.0] range:NSMakeRange(0, attributedString.length)];
    [attributedString release], attributedString = nil;
    [_playlistTableView setWantsLayer:YES];
    [self.view setWantsLayer:YES];
    [self.view.layer setCornerRadius:5];
    [self reloadList:1];
//    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
}

- (void)changeSkin:(NSNotification *)notification
{
    [_verticalLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
//    [_playlistTableView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"playlist_bgColor", nil)]];
    [_playlistTableView setBackgroundColor:[NSColor clearColor]];
    [self configNoDataView];
//    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
}

#pragma mark - NSTextView
- (void)configNoDataView {
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_box"]];
    [_textView setDelegate:self];
    [_textView setSelectable:NO];
    NSString *promptStr = @"";
    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MSG_Item_id_1", nil)];
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_textView setLinkTextAttributes:linkAttributes];
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_textView textStorage] setAttributedString:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (tableView == _itemTableView) {
        NSMutableArray *disPlayAry = nil;
        if (_isSearch) {
            disPlayAry = _researchdataSourceArray;
        }else{
            disPlayAry = _dataSourceArray;
        }
        if (disPlayAry != nil) {
            //当前显示的数据源
            return [disPlayAry count];
        }
    }else if (tableView == _playlistTableView)
    {
        return [_playlistArray count];
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == _itemTableView) {
        NSArray *displayArray = nil;
        if (_isSearch) {
            displayArray = _researchdataSourceArray;
        }else{
            displayArray = _dataSourceArray;
        }
        if (displayArray.count <=0) {
            return @"";
        }
        IMBiTLTrack *track = [displayArray objectAtIndex:row];
        if ([@"Name" isEqualToString:tableColumn.identifier] ) {
            return track.name;
        }else if ([@"Time" isEqualToString:tableColumn.identifier]) {
            return [[StringHelper getTimeString:track.duration * 1000] stringByAppendingString:@" "];
        }else if ([@"Artist" isEqualToString:tableColumn.identifier]) {
            return track.artist;
        }else if ([@"Album" isEqualToString:tableColumn.identifier]) {
            return track.album;
        }else if ([@"Size" isEqualToString:tableColumn.identifier]) {
            return [StringHelper getFileSizeString:track.size reserved:2];
        }else if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
            return [NSNumber numberWithInt:track.checkState];
        }else if ([@"Type" isEqualToString:tableColumn.identifier]) {
            return [IMBiTunesEnum iTunesMediaTypeEnumToString:track.iTunesMediaType];
        }
        
    }else if (tableView == _playlistTableView)
    {
        IMBiTLPlaylist *pl = [_playlistArray objectAtIndex:row];
        if ([@"PlaylistName" isEqualToString:tableColumn.identifier] ) {
            return pl.name;
        }
        if ([@"itemCount" isEqualToString:tableColumn.identifier] ) {
            int count = (int)pl.playlistItems.count;
            if (count == 0) {
                return @"--";
            }
            return [NSNumber numberWithInt:count];//pl.playlistItems.count;
        }
    }
    return @"";
}

- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    if (tableView == _itemTableView) {
        NSArray *displayArray = nil;
        if (_isSearch) {
            displayArray = _researchdataSourceArray;
        }else{
            displayArray = _dataSourceArray;
        }
        if (displayArray.count <=0) {
            return ;
        }
        IMBiTLTrack *track = [displayArray objectAtIndex:index];
        track.checkState = !track.checkState;
        //点击checkBox 实现选中行
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (int i=0;i<[displayArray count]; i++) {
            IMBiTLTrack *track = [displayArray objectAtIndex:i];
            if (track.checkState == NSOnState) {
                [set addIndex:i];
            }
        }
        if (track.checkState == NSOnState) {
//            [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
        }else if (track.checkState == NSOffState)
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
    }
}

- (NSCell*)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == _itemTableView) {
        IMBiTLTrack *track = nil;
        NSArray *displayArray = nil;
        if (_isSearch) {
            displayArray = _researchdataSourceArray;
        }else{
            displayArray = _dataSourceArray;
        }
        if (displayArray != nil && row<[displayArray count]) {
            track = [displayArray objectAtIndex:row];
        }
        if (![tableColumn.identifier isEqualToString:@"CheckCol"]) {
            if (tableColumn != nil) {
                IMBCenterTextFieldCell *cell = (IMBCenterTextFieldCell *)[tableColumn dataCell];
                cell.isExist = track.fileIsExist;
            }
        }
    }
    return [tableColumn dataCell];
}

#pragma mark - NSTableViewdelegate
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == _playlistTableView){
        if ([@"PlaylistName" isEqualToString:tableColumn.identifier] ) {
            IMBiTLPlaylist *pl = [_playlistArray objectAtIndex:row];
            IMBImageAndTextCell *cell1 = (IMBImageAndTextCell*)cell;
            cell1.imageSize = NSMakeSize(16, 16);
            cell1.marginX = 20;
            cell1.paddingX = 0;
            if (pl.isMaster == true ) {
                
            } else if (pl.isUserDefined == false) {
                cell1.image = [StringHelper imageNamed:@"list"];
                cell1.imageName = @"list";
            } else if (pl.isUserDefined == true) {
                cell1.image = [StringHelper imageNamed:@"news_list"];
                cell1.imageName = @"news_list";
            }

        }else if ([@"itemCount" isEqualToString:tableColumn.identifier]) {
            IMBiTLPlaylist *pl = [_playlistArray objectAtIndex:row];
            IMBCenterTextFieldCell *cell1 = (IMBCenterTextFieldCell*)cell;
            if (pl.playlistItems.count == 0) {
                cell1.isLastCell = YES;
            }else {
                cell1.isLastCell = NO;
            }
            
        }
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView *atableView = [notification object];
    if (atableView == _playlistTableView) {
        [_searchFieldBtn setStringValue:@""];
        _isSearch = NO;
        NSInteger row = [_playlistTableView selectedRow];
        if (row == -1) {
            return;
        }
        IMBiTLPlaylist *pl = [_playlistArray objectAtIndex:row];
        if (_dataSourceArray != nil) {
            [_dataSourceArray release];
            _dataSourceArray = nil;
        }
        if (pl != nil && pl.playlistItems) {
            _dataSourceArray = [pl.playlistItems retain];
        }
        for (IMBiTLTrack *track in _dataSourceArray) {
            track.checkState = UnChecked;
        }
        [_itemTableView changeHeaderCheckState:UnChecked];
        [self setAllselectState:UnChecked];
        [_itemTableView reloadData];
        
        if (_dataSourceArray.count == 0) {
            [_rightMainBox setContentView:_noDataView];
            [self configNoDataView];
        }else {
            [_rightMainBox setContentView:_containTableView];
        }
    }
    else if (atableView == _itemTableView) {
//        NSIndexSet *set = [_itemTableView selectedRowIndexes];

//        for (int i=0; i<[_dataSourceArray count]; i++) {
//            IMBiTLTrack *track = [_dataSourceArray objectAtIndex:i];
//            if ([set containsIndex:i]) {
//                [track setCheckState:NSOnState];
//            }else
//            {
//                [track setCheckState:NSOffState];
//            }
//        }
        
//        if ([set count] == [displayArray count]&&[displayArray count]>0) {
//            [_itemTableView changeHeaderCheckState:NSOnState];
//        }else if ([set count] == 0)
//        {
//            [_itemTableView changeHeaderCheckState:NSOffState];
//        }else
//        {
//            [_itemTableView changeHeaderCheckState:NSMixedState];
//        }
        [_itemTableView reloadData];
    }
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

	if ( [@"Name" isEqualToString:identify] || [@"Time" isEqualToString:identify] || [@"Artist" isEqualToString:identify] || [@"Album" isEqualToString:identify] || [@"Size" isEqualToString:identify] || [@"Type" isEqualToString:identify]|| [@"Genre" isEqualToString:identify] || [@"Rating" isEqualToString:identify]) {
        if ([cell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *customHeaderCell = (IMBCustomHeaderCell *)cell;
            if (customHeaderCell.ascending) {
                customHeaderCell.ascending = NO;
            }else
            {
                customHeaderCell.ascending = YES;
            }
            [self sort:customHeaderCell.ascending key:identify dataSource:_dataSourceArray];
        }
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (int i=0;i<[_dataSourceArray count]; i++) {
            IMBiTLTrack *track = [_dataSourceArray objectAtIndex:i];
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
        key = @"name";
    } else if ([key isEqualToString:@"Time"]) {
        key = @"duration";
    }else if ([key isEqualToString:@"Artist"]) {
        key = @"artist";
    } else if ([key isEqualToString:@"Album"]) {
        key = @"album";
    } else if ([key isEqualToString:@"Size"]) {
        key = @"size";
    } else if ([key isEqualToString:@"Type"]) {
        key = @"iTunesMediaType";
    }else if ([key isEqualToString:@"Genre"]) {
        key = @"genre";
    }else if ([key isEqualToString:@"Rating"]) {
        key = @"rating";
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    [_itemTableView reloadData];
    
    [sortDescriptor release];
    [sortDescriptors release];
}

- (void)setAllselectState:(CheckStateEnum)checkState{
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[displayArray count]; i++) {
        IMBiTLTrack *track = [displayArray objectAtIndex:i];
        [track setCheckState:checkState];
        if (track.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
//    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    [_itemTableView reloadData];
}

- (void)reloadList:(int)sender {
    _isSearch = NO;
    if (_dataSourceArray.count == 0) {
        [_rightMainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_rightMainBox setContentView:_containTableView];
    }
    [_playlistTableView reloadData];
    [_itemTableView reloadData];
    [_playlistTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    [self unselectItems];
}

- (void)unselectItems {
    for (IMBiTLPlaylist *list in _playlistArray) {
        for (IMBiTLTrack *track in list.playlistItems) {
            track.checkState = UnChecked;
        }
    }
    [self setAllselectState:UnChecked];
}

- (void)toMac:(id)sender {
    NSIndexSet *selectedSet = [self selectedItems];
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }
    if ([selectedSet count] <= 0) {
        //弹出警告确认框
        NSString *str = nil;
        if (displayArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_transfer", nil),[StringHelper getCategeryStr:_category]];
        }else {
            str = CustomLocalizedString(@"Export_View_Selected_Tips", nil);
        }
        
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }else {
        //弹出路径选择框
        NSOpenPanel *openPanel = [IMBOpenPanel openPanel];
        [openPanel setAllowsMultipleSelection:NO];
        [openPanel setCanChooseFiles:NO];
        [openPanel setCanChooseDirectories:YES];
        [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
            if (result== NSFileHandlingPanelOKButton) {
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:iTunes_Library action:ContentToMac actionParams:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] label:Click transferCount:0 screenView:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
//                [self copyiTunesContentToMac:filePath indexSet:selectedSet];
                [self performSelector:@selector(iTunestoMacDelay:) withObject:openPanel afterDelay:0.1];
            }else{
                NSLog(@"other other other");
            }
        }];
    }
}

- (void)iTunestoMacDelay:(NSOpenPanel *)openPanel {
    NSIndexSet *selectedSet = [self selectedItems];
    NSViewController *annoyVC = nil;
    long long result = [self checkNeedAnnoy:&(annoyVC)];
    if (result == 0) {
        return;
    }
    NSString * path =[[openPanel URL] path];
    NSString *filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:_category]];
    [self copyiTunesContentToMac:filePath indexSet:(NSIndexSet *)selectedSet Result:(long long)result AnnoyVC:(NSViewController *)annoyVC];
}

- (void)copyiTunesContentToMac:(NSString *)filePath indexSet:(NSIndexSet *)set Result:(long long)result AnnoyVC:(NSViewController *)annoyVC {
    //得出选中的track
    NSIndexSet *selectedSet = set;
    NSMutableArray *selectedTracks = [NSMutableArray array];
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <=0) {
        return;
    }
    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [selectedTracks addObject:[displayArray objectAtIndex:idx]];
    }];
    
    if (_transferController != nil) {
        [_transferController release];
        _transferController = nil;
    }
    _transferController = [[IMBTransferViewController alloc] initWithIPodkey:_ipod.uniqueKey Type:_category SelectItems:selectedTracks ExportFolder:filePath];
    if (result>0) {
        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
    }else {
        [self animationAddTransferView:_transferController.view];
    }
}

- (void)animationAddTransferView:(NSView *)view {
    [view setFrame:NSMakeRect(0, 0, [(IMBitunesLibraryViewController *)_delegate view].frame.size.width, [(IMBitunesLibraryViewController *)_delegate view].frame.size.height)];
    [view setWantsLayer:YES];
    [view.layer setCornerRadius:5];
    [[(IMBitunesLibraryViewController *)_delegate view] addSubview:view];

    [view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
//    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//        CABasicAnimation *anima1 = [IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1];
//        [view.layer addAnimation:anima1 forKey:@"deviceImageView"];
//    } completionHandler:^{
//        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//            CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-40] repeatCount:1];
//            [view.layer addAnimation:anima1 forKey:@"deviceImageView"];
//        } completionHandler:^{
//            CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:-40] Y:[NSNumber numberWithInt:0] repeatCount:1];
//            [view.layer addAnimation:anima1 forKey:@"deviceImageView"];
//        }];
//    }];
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _isSearch = YES;
    _searchFieldBtn = searchBtn;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
    }
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }
    int checkCount = 0;
    for (int i=0; i<[displayArray count]; i++) {
        IMBiTLTrack *track = [displayArray objectAtIndex:i];
        if (track.checkState == NSOnState) {
            checkCount ++;
        }
    }
    if (checkCount == [displayArray count]&&[displayArray count]>0) {
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

- (void)dealloc {
    [super dealloc];
}
@end
