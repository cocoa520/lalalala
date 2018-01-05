//
//  IMBiTunesTrackViewController.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBiTunesTrackViewController.h"
#import "StringHelper.h"
#import "IMBCustomHeaderCell.h"
#import "IMBAnimation.h"
#import "IMBitunesLibraryViewController.h"
#import "IMBCenterTextFieldCell.h"

#import "ATTracker.h"
#import "CommonEnum.h"
@implementation IMBiTunesTrackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithDistinguishedKindId:(int)distingushedID withCategory:(CategoryNodesEnum)category withDelegate:(id)delegate {
    self = [super initWithNibName:@"IMBiTunesTrackViewController" bundle:nil];
    if (self) {
        _delegate = delegate;
        _iTunes = [IMBiTunes singleton];
        _distinguishedKindId = distingushedID;
        _category = category;
        IMBiTLPlaylist *pl = [_iTunes getPlaylistByDistinguished:_distinguishedKindId];
        if (pl != nil) {
            _dataSourceArray = [pl.playlistItems retain];
        }

    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self configNoDataView];
    });
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_nodataBgVIew setBackgroundColor:[NSColor clearColor]];
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
//        [self configNoDataView];
    }else {
        [_mainBox setContentView:_containTableView];
    }
    [self configNoDataView];
    [_itemTableView setListener:self];
    [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:-1]byExtendingSelection:NO];
    [self.view setWantsLayer:YES];
    [self.view.layer setMasksToBounds:YES];
    [self.view.layer setCornerRadius:5];
    [self reloadList:1];
    [_textView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_itemTableView setBackgroundColor:[NSColor clearColor]];
}

- (void)changeSkin:(NSNotification *)notification
{
    [_textView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [self configNoDataView];
    [_loadingAnimationView setNeedsDisplay:YES];
//    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
}

#pragma mark - NSTextView
- (void)configNoDataView {
    [_textView setDelegate:self];
    [_textView setSelectable:NO];
    NSString *promptStr = @"";
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    if (_category == Category_iTunes_Music) {
        [ATTracker event:iTunes_Library action:ActionNone actionParams:@"iTunes Music" label:Switch transferCount:0 screenView:@"iTunes Library" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_music"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_1", nil)];
    }else if (_category == Category_iTunes_Movie) {
        [ATTracker event:iTunes_Library action:ActionNone actionParams:@"iTunes Movie" label:Switch transferCount:0 screenView:@"iTunes Movie" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_movies"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_70", nil)];
    }else if (_category == Category_iTunes_TVShow) {
        [ATTracker event:iTunes_Library action:ActionNone actionParams:@"iTunes TVShow" label:Switch transferCount:0 screenView:@"iTunes TVShow" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_TVshow"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_71", nil)];
    }else if (_category == Category_iTunes_PodCasts) {
        [ATTracker event:iTunes_Library action:ActionNone actionParams:@"iTunes PodCasts" label:Switch transferCount:0 screenView:@"iTunes PodCasts" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_podcasts"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_72", nil)];
    }else if (_category == Category_iTunes_iTunesU) {
        [ATTracker event:iTunes_Library action:ActionNone actionParams:@"iTunes iTunesU" label:Switch transferCount:0 screenView:@"iTunes iTunesU" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_U"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_16", nil)];
    }else if (_category == Category_iTunes_iBooks) {
        [ATTracker event:iTunes_Library action:ActionNone actionParams:@"iTunes iBooks" label:Switch transferCount:0 screenView:@"iTunes iBooks" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_book"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_55", nil)];
    }else if (_category == Category_iTunes_Audiobook) {
        [ATTracker event:iTunes_Library action:ActionNone actionParams:@"iTunes Audiobook" label:Switch transferCount:0 screenView:@"iTunes Audiobook" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_audiobook"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_73", nil)];
    }else if (_category == Category_iTunes_VoiceMemos) {
        [ATTracker event:iTunes_Library action:ActionNone actionParams:@"iTunes VoiceMemos" label:Switch transferCount:0 screenView:@"iTunes VoiceMemos" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_voice"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_74", nil)];
    }else if (_category == Category_iTunes_App) {
        [ATTracker event:iTunes_Library action:ActionNone actionParams:@"iTunes App" label:Switch transferCount:0 screenView:@"iTunes App" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_app"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_75", nil)];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    
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


#pragma mark - NSTableView相关方法
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView == _itemTableView) {
        NSMutableArray *disAry = nil;
        if (_isSearch) {
            disAry = _researchdataSourceArray;
        }else{
            disAry = _dataSourceArray;
        }
        if (disAry.count <=0) {
            return 0;
        }
        if (disAry.count > 0) {
            return [disAry count];
        }
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (tableView == _itemTableView) {
        NSMutableArray *disAry = nil;
        if (_isSearch) {
            disAry = _researchdataSourceArray;
        }else{
            disAry = _dataSourceArray;
        }
        if (disAry.count <=0) {
            return 0;
        }
        NSArray *displayArray = nil;
        displayArray = disAry;
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
        }else if ([@"Genre" isEqualToString:tableColumn.identifier]) {
            return track.genre;
        }else if ([@"Rating" isEqualToString:tableColumn.identifier]) {
            if (track.rating == 0) {
                return @"";
            }
            return [NSNumber numberWithInteger:track.rating];
        }
    }
    return @"";
}

- (void)tableView:(NSTableView *)tableView row:(NSInteger)index{
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    IMBiTLTrack *track = [disAry objectAtIndex:index];
    track.checkState = !track.checkState;
    

    //点击checkBox 实现选中行
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[disAry count]; i++) {
        IMBiTLTrack *track = [disAry objectAtIndex:i];
        if (track.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
    if (track.checkState == NSOnState) {
//        [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    }else if (track.checkState == NSOffState)
    {
        [_itemTableView deselectRow:index];
    }

    if (set.count == disAry.count) {
        [_itemTableView changeHeaderCheckState:NSOnState];
    }else if (set.count == 0){
        [_itemTableView changeHeaderCheckState:NSOffState];
    }else{
        [_itemTableView changeHeaderCheckState:NSMixedState];
    }
}

- (NSCell*)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == _itemTableView) {
        IMBiTLTrack *track = nil;
        NSMutableArray *disAry = nil;
        if (_isSearch) {
            disAry = _researchdataSourceArray;
        }else{
            disAry = _dataSourceArray;
        }
        if (disAry != nil && row<[disAry count]) {
            track = [disAry objectAtIndex:row];
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
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView *atableView = [notification object];
    if (atableView == _itemTableView) {
//        NSIndexSet *set = [_itemTableView selectedRowIndexes];
//        for (int i=0; i<[_dataSourceArray count]; i++) {
//            IMBiTLTrack *track = [_dataSourceArray objectAtIndex:i];
//            if ([set containsIndex:i]) {
//                [track setCheckState:NSOnState];
//            }else{
//                [track setCheckState:NSOffState];
//            }
//        }
//        [_itemTableView reloadData];
//        NSIndexSet *selectedset = [_itemTableView selectedRowIndexes];
//        if ([selectedset count] == [_dataSourceArray count]&&[_dataSourceArray count]>0) {
//            [_itemTableView changeHeaderCheckState:NSOnState];
//        }else if ([selectedset count] == 0)
//        {
//            [_itemTableView changeHeaderCheckState:NSOffState];
//        }else
//        {
//            [_itemTableView changeHeaderCheckState:NSMixedState];
//        }
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 32;
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
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
    
	if ( [@"Name" isEqualToString:identify] || [@"Time" isEqualToString:identify] || [@"Artist" isEqualToString:identify] || [@"Album" isEqualToString:identify] || [@"Size" isEqualToString:identify] || [@"Format" isEqualToString:identify]|| [@"Genre" isEqualToString:identify] || [@"Rating" isEqualToString:identify]) {
        if ([cell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *customHeaderCell = (IMBCustomHeaderCell *)cell;
            if (customHeaderCell.ascending) {
                customHeaderCell.ascending = NO;
            }else
            {
                customHeaderCell.ascending = YES;
            }
            [self sort:customHeaderCell.ascending key:identify dataSource:disAry];
        }
        //排序后高亮,随的变化
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (int i=0;i<[disAry count]; i++) {
            IMBiTLTrack *track = [disAry objectAtIndex:i];
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
    } else if ([key isEqualToString:@"Format"]) {
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
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[disAry count]; i++) {
        IMBiTLTrack *track = [disAry objectAtIndex:i];
        [track setCheckState:checkState];
        if (track.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
//    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    [_itemTableView reloadData];
}

- (void)reloadList:(int)sender{
    
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_mainBox setContentView:_containTableView];
    }
    for (IMBiTLTrack *track in _dataSourceArray) {
        track.checkState = UnChecked;
    }
    [_itemTableView changeHeaderCheckState:NSOffState];
    [self setAllselectState:UnChecked];
    [_itemTableView reloadData];
}

- (void)toMac:(id)sender {
    NSIndexSet *selectedSet = [self selectedItems];
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if ([selectedSet count] <= 0) {
        //弹出警告确认框
        NSString *str = nil;
        if (disAry.count == 0) {
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
                [ATTracker event:iTunes_Library action:ContentToMac actionParams:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] label:Start transferCount:0 screenView:@"iTunes_App" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
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

- (void)iTunestoMacDelay:(NSOpenPanel *)openPanel
{
    NSIndexSet *selectedSet = [self selectedItems];
    NSViewController *annoyVC = nil;
    long long result = [self checkNeedAnnoy:&(annoyVC)];
    if (result == 0) {
        return;
    }
    NSString * path =[[openPanel URL] path];
    NSString *filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:_category]];
    [self copyiTunesContentToMac:filePath indexSet:(NSIndexSet *)selectedSet Result:(int)result AnnoyVC:(NSViewController *)annoyVC];
}

- (void)copyiTunesContentToMac:(NSString *)filePath indexSet:(NSIndexSet *)set Result:(int)result AnnoyVC:(NSViewController *)annoyVC {
    //得出选中的track
    NSIndexSet *selectedSet = set;
    NSMutableArray *selectedTracks = [NSMutableArray array];
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
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

- (void)animationAddTransferView:(NSView *)view
{
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

@end
