//
//  IMBMusicListViewController.m
//  iMobieTrans
//
//  Created by iMobie on 14-5-9.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBTracksListViewController.h"
#import "IMBCustomHeaderCell.h"
#import "IMBCenterTextFieldCell.h"
#import "IMBAddTrackToList.h"
#import "IMBNotificationDefine.h"
#import "IMBDeviceMainPageViewController.h"
@implementation IMBTracksListViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    self = [super initWithIpod:ipod withCategoryNodesEnum:category withDelegate:delegate];
    if (self) {
        //默认是track数据
        if (_category == Category_CloudMusic) {
            _dataSourceArray = [[NSMutableArray alloc] initWithArray:[_information cloudTrackArray]];
        }else {
            if (_information.tracks != nil) {
                _dataSourceArray = [[NSMutableArray alloc] initWithArray:[_information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:_category]]];
            }
        }
        _delegate = delegate;
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        [self configNoDataView];
    });
}

- (void)changeSkin:(NSNotification *)notification {
    [self configNoDataView];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [_loadingAnimationView setNeedsDisplay:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
}

- (void)awakeFromNib {
    _nc = [NSNotificationCenter defaultCenter];
    [super awakeFromNib];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    _logManger = [IMBLogManager singleton];
    [_propertyMenuItem setTitle:CustomLocalizedString(@"Menu_Property", nil)];
    [_deleteMenuItem setTitle:CustomLocalizedString(@"Menu_Delete", nil)];
    [_toDeviceMenuItem setTitle:CustomLocalizedString(@"Menu_ToDevice", nil)];
    [_toMacMenuItem setTitle:CustomLocalizedString(@"Menu_ToPc", nil)];
    [_toiTunesMenuItem setTitle:CustomLocalizedString(@"Menu_ToiTunes", nil)];
    [_addToPlaylistMenuItem setTitle:CustomLocalizedString(@"Menu_Playlist", nil)];
    [self performSelector:@selector(checkCDBcorrupted) withObject:nil afterDelay:0.01];
    
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_mainBox setContentView:_contentView];
    }

    NSArray *array = [_itemTableView tableColumns];
    for (NSTableColumn *column in array) {
        if ([column.headerCell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *cell = column.headerCell;
            [cell setHasDiviation:YES];
            [cell setDiviationY:8];
        }
    }

    if (_category == Category_Movies || _category == Category_TVShow || _category == Category_MusicVideo || _category == Category_HomeVideo ) {
        [_addToPlaylistMenuItem setHidden:YES];
    }else if (_category == Category_CloudMusic) {
        [_deleteMenuItem setHidden:YES];
        [_toDeviceMenuItem setHidden:YES];
        [_toiTunesMenuItem setHidden:YES];
        [_addToPlaylistMenuItem setHidden:YES];
        [_addToDeviceMenuItem setHidden:YES];
        [_addMenuItem setHidden:YES];
    }else {
        [_addToPlaylistMenuItem setHidden:NO];
    }
    [self changeAddToPlaylistMenu];
    [_nc addObserver:self selector:@selector(changeAddToPlaylistMenu) name:PLAYLIST_COUNT_CHANGE object:nil];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
}

- (void)changeAddToPlaylistMenu {
    NSArray *array = [_ipod.playlists getPlaylist];
    int i = 0;
    for (IMBPlaylist *playlist in array) {
        if (playlist.isUserDefinedPlaylist) {
            i ++;
        }
    }
    if (i < 1 || _category == Category_Movies || _category == Category_TVShow || _category == Category_MusicVideo || _category == Category_HomeVideo) {
        [_addToPlaylistMenuItem setHidden:YES];
    }else if (_category == Category_CloudMusic) {
        [_deleteMenuItem setHidden:YES];
        [_toDeviceMenuItem setHidden:YES];
        [_toiTunesMenuItem setHidden:YES];
        [_addToPlaylistMenuItem setHidden:YES];
        [_addToDeviceMenuItem setHidden:YES];
        [_addMenuItem setHidden:YES];
    }else {
        [_addToPlaylistMenuItem setHidden:NO];
    }
}

- (void)setTableViewHeadOrCollectionViewCheck {
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    if (_category == Category_CloudMusic) {
        _dataSourceArray = [[NSMutableArray alloc] initWithArray:[_information cloudTrackArray]];
    }else {
        _dataSourceArray = [[NSMutableArray alloc] initWithArray:[_information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:_category]]];
    }
    [self doSearchBtn:_searchFieldBtn.stringValue withSearchBtn:_searchFieldBtn];
    NSIndexSet *set = [self selectedItems];
//    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    [_itemTableView showVisibleRextPhoto];
    
    if (_dataSourceArray.count > 0) {
        [_mainBox setContentView:_contentView];
    }else{
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }

    if ([set count] == [_dataSourceArray count]&&[_dataSourceArray count]>0) {
        [_itemTableView changeHeaderCheckState:NSOnState];
    }else if ([set count] == 0)
    {
        [_itemTableView changeHeaderCheckState:NSOffState];
    }else
    {
        [_itemTableView changeHeaderCheckState:NSMixedState];
    }
    [_itemTableView reloadData];
}

#pragma mark - NSTextView
- (void)configNoDataView {
    [_textView setDelegate:self];
    NSString *promptStr = @"";
    NSString *overStr = CustomLocalizedString(@"NO_DATA_TITLE_2", nil);
    if (_category == Category_Music) {
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_audio"]];
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_1", nil)] stringByAppendingString:overStr];
    }else if (_category == Category_CloudMusic) {
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_audio"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_91", nil)];
    }else if (_category == Category_Movies) {
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_movies"]];
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_70", nil)] stringByAppendingString:overStr];
    }else if (_category == Category_TVShow) {
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_TVshow"]];
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_71", nil)] stringByAppendingString:overStr];
    }else if (_category == Category_MusicVideo) {
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_video"]];
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_78", nil)] stringByAppendingString:overStr];
    }else if (_category == Category_PodCasts) {
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_podcasts"]];
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_72", nil)] stringByAppendingString:overStr];
    }else if (_category == Category_iTunesU) {
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_U"]];
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_16", nil)] stringByAppendingString:overStr];
    }else if (_category == Category_Audiobook) {
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_audiobook"]];
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_73", nil)] stringByAppendingString:overStr];
    }else if (_category == Category_Ringtone) {
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_ringtones"]];
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_79", nil)] stringByAppendingString:overStr];
    }else if (_category == Category_HomeVideo) {
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_video"]];
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_50", nil)] stringByAppendingString:overStr];
    }
    
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

#pragma mark - NSTableViewDataSource
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <=0) {
        return nil;
    }
    IMBTrack *track = [displayArray objectAtIndex:row];
   
    if ([@"Name" isEqualToString:tableColumn.identifier] ) {
        return track.title;
    }
    
    if ([@"Time" isEqualToString:tableColumn.identifier]) {
        return [[StringHelper getTimeString:track.length] stringByAppendingString:@" "];
    }
    if ([@"Artist" isEqualToString:tableColumn.identifier]) {
        return track.artist;
    }
    if ([@"Album" isEqualToString:tableColumn.identifier]) {
        return track.album;
    }
    if ([@"Genre" isEqualToString:tableColumn.identifier]) {
        return track.genre;
    }
    if ([@"Rating" isEqualToString:tableColumn.identifier]) {
        return @"";
    }
    if ([@"Plays" isEqualToString:tableColumn.identifier]) {
        return [NSString stringWithFormat:@"%d", track.playCount];
    }
    if ([@"Size" isEqualToString:tableColumn.identifier]) {
        return [StringHelper getFileSizeString:track.fileSize reserved:2];
    }
    if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
        return [NSNumber numberWithInt:track.checkState];
    }
    return @"";
    
}

#pragma mark - Deleagete
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <=0) {
        return 0;
    }
    return [displayArray count];
}

- (NSString *)tableView:(NSTableView *)tableView toolTipForCell:(NSCell *)cell rect:(NSRectPointer)rect tableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row mouseLocation:(NSPoint)mouseLocation {
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <=0) {
        return @"";
    }
    IMBTrack *track = [displayArray objectAtIndex:row];
    if ([[tableColumn identifier] isEqualToString:@"Name"]) {
        return track.filePath;
    }else
    {
        return @"";
    }
    
}

- (NSCell*)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == _itemTableView) {
        NSArray *displayArray = nil;
        if (_isSearch) {
            displayArray = _researchdataSourceArray;
        }else{
            displayArray = _dataSourceArray;
        }
        if (displayArray.count <=0) {
            return nil;
        }
        IMBTrack *track = nil;
        if (displayArray != nil&&row<[displayArray count]) {
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

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    
//    NSArray *displayArray = nil;
//    if (_isSearch) {
//        displayArray = _researchdataSourceArray;
//    }else{
//        displayArray = _dataSourceArray;
//    }
//    if (displayArray.count <=0) {
//        return ;
//    }
//    NSIndexSet *set = [_itemTableView selectedRowIndexes];
//    for (int i=0; i<[displayArray count]; i++) {
//        IMBTrack *track = [displayArray objectAtIndex:i];
//        if ([set containsIndex:i]) {
//            [track setCheckState:NSOnState];
//            track.isHiddenSelectImage = NO;
//        }else{
//            [track setCheckState:NSOffState];
//            track.isHiddenSelectImage = YES;
//        }
//    }
//    if ([set count] == [_dataSourceArray count]&&[_dataSourceArray count]>0) {
//        [_itemTableView changeHeaderCheckState:NSOnState];
//    }else if ([set count] == 0)
//    {
//        [_itemTableView changeHeaderCheckState:NSOffState];
//    }else
//    {
//        [_itemTableView changeHeaderCheckState:NSMixedState];
//    }
    [_itemTableView reloadData];
}

#pragma mark - IMBImageRefreshListListener
- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <=0) {
        return;
    }
    IMBTrack *track = [displayArray objectAtIndex:index];
    track.isHiddenSelectImage = track.checkState;
    track.checkState = !track.checkState;
    
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[displayArray count]; i++) {
        IMBTrack *item= [displayArray objectAtIndex:i];
        if (item.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
    
    if (track.checkState == NSOnState) {
//        [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    }else if (track.checkState == NSOffState)
    {
        [_itemTableView deselectRow:index];
    }
    
    if (set.count == displayArray.count) {
        [_itemTableView changeHeaderCheckState:Check];
    }else if (set.count == 0){
        [_itemTableView changeHeaderCheckState:UnChecked];
    }else{
        [_itemTableView changeHeaderCheckState:SemiChecked];
    }
    [_itemTableView reloadData];
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    id cell = [tableColumn headerCell];
    NSMutableArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }

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
    NSString *newKey = @"";
    if ([key isEqualToString:@"Name"]) {
        newKey = @"title";
    } else if ([key isEqualToString:@"Time"]) {
        newKey = @"length";
    }else if ([key isEqualToString:@"Artist"]) {
        newKey = @"artist";
    } else if ([key isEqualToString:@"Album"]) {
        newKey = @"album";
    } else if ([key isEqualToString:@"Size"]) {
        newKey = @"fileSize";
    } else if ([key isEqualToString:@"Format"]) {
        newKey = @"iTunesMediaType";
    }else if ([key isEqualToString:@"Genre"]) {
        newKey = @"genre";
    }else if ([key isEqualToString:@"Rating"]) {
        newKey = @"rating";
    }
    IMBTrack *track = [array objectAtIndex:0];
    NSLog(@"%@  %@   %@",track.title,track.artist,track.album);
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:newKey ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    [_itemTableView reloadData];
    
    [sortDescriptor release];
    [sortDescriptors release];
}

- (void)setAllselectState:(CheckStateEnum)checkState {
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[displayArray count]; i++) {
        IMBTrack *track = [displayArray objectAtIndex:i];
        track.isHiddenSelectImage = !checkState;
        [track setCheckState:checkState];
        if (track.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
//    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    [_itemTableView reloadData];
}

- (void)changeTracksListLanguage:(NSNotification *)notification {
 /*   [_propertyMenuItem setTitle:CustomLocalizedString(@"Menu_Property", nil)];
    [_deleteMenuItem setTitle:CustomLocalizedString(@"Menu_Delete", nil)];
    [_toDeviceMenuItem setTitle:CustomLocalizedString(@"Menu_ToDevice", nil)];
    [_toMacMenuItem setTitle:CustomLocalizedString(@"Menu_ToPc", nil)];
    [_toiTunesMenuItem setTitle:CustomLocalizedString(@"Menu_ToiTunes", nil)];
    [_addToPlaylistMenuItem setTitle:CustomLocalizedString(@"Menu_Playlist", nil)];
    [_itemTableView _setupHeaderCell];
    [_itemTableView reloadData];
    if ([_countDelegate respondsToSelector:@selector(reCaulateItemCount)]) {
        
        [_countDelegate reCaulateItemCount];
    }*/
}

- (void)initPlaylistMenuItem {
    IMBPlaylist *currentPlaylist = nil;
    [_addToPlaylistMenuItem setTitle:CustomLocalizedString(@"Menu_Playlist", nil)];
    NSMenu *addToPlaylistMenu = _addToPlaylistMenuItem.submenu;
    [addToPlaylistMenu removeAllItems];
    
    [addToPlaylistMenu setAutoenablesItems:NO];
//    NSIndexSet *indexset = _playlistsTableView.selectedRowIndexes;
//    if (indexset.count > 0) {
//        NSInteger integer = indexset.firstIndex;
//        currentPlaylist = [_playlistArray objectAtIndex:integer];
//    }
    NSArray *array = [_ipod.playlists getPlaylist];
    int i = 0;
    for (IMBPlaylist *playlist in array) {
        i ++;
        if (playlist.iD != currentPlaylist.iD && playlist.isUserDefinedPlaylist) {
            NSMenuItem *menuItem = nil;
            menuItem = [[NSMenuItem alloc] initWithTitle:playlist.name action:@selector(addToPlaylistMenuAction:) keyEquivalent:@""];
            [menuItem setTag:i];
            [menuItem setTarget:self];
            [menuItem setEnabled:YES];
            
            [addToPlaylistMenu addItem:menuItem];
            
            [menuItem release];
        }
    }
}

- (void)addToPlaylistMenuAction:(id)sender{
    NSMenu *menu = _addToPlaylistMenuItem.submenu;
    for (NSMenuItem *menuItem in menu.itemArray) {
        if (menuItem == sender) {
            IMBPlaylist *playlist = [_ipod.playlists getPlaylistByName:menuItem.title];
            [self addToPlaylist:playlist.iD];
            break;
        }
    }
}

- (void)addToPlaylist:(long long)playlistID{
    NSLog(@"========");
    if (![self checkInternetAvailble]) {
        [_logManger writeInfoLog:[NSString stringWithFormat:@"Do Add Track To Playlist End (checkInternetAvailble = %d)",[self checkInternetAvailble]]];
        return;
    }
    
    IMBPlaylist *playlist = [_ipod.playlists getPlaylistByID:playlistID];
    NSArray *selectItem = [self selectedItemsByPlaylist];
    if (playlist != nil && selectItem.count > 0) {
        IMBAddTrackToList *procedure = [[IMBAddTrackToList alloc] initWithIPodKey:_ipod.uniqueKey tracksArray:selectItem playlistID:playlist.iD];
        //                    [self showRefrshLoading:YES LoadingType:LoadingAddPlaylist];
        
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                [view setHidden:NO];
                break;
            }
        }
        NSString *str = nil;
        if (selectItem.count > 1) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"Playlist_id_17", nil),CustomLocalizedString(@"MSG_Item_id_2", nil)];
        }else {
            str = [NSString stringWithFormat:CustomLocalizedString(@"Playlist_id_17", nil),CustomLocalizedString(@"MSG_Item_id_1", nil)];
        }
        
        [_alertViewController showDeleteAnimationViewAlertText:str SuperView: view];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [procedure startAddTrackToList];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_alertViewController unloadAlertView:_alertViewController.deleteAnimationView];
                [self reload:nil];
            });
            [procedure release];
        });
    }
}

- (NSArray *)selectedItemsByPlaylist{
    NSIndexSet *indexSet = _itemTableView.selectedRowIndexes;
    if (indexSet.count == 0) {
        [self showAlertText:CustomLocalizedString(@"MSG_COM_No_Item_Selected", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return nil;
    }
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }
    NSMutableArray *items = [NSMutableArray array];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [items addObject:[displayArray objectAtIndex:idx]];
    }];
    return items;
}

#pragma mark about reloadActions
- (void)reload:(id)sender {
    [self disableFunctionBtn:NO];
    [_loadingBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            if (_ipod != nil && _itemTableView != nil&&_collectionView == nil) {
                
                [_ipod startSync];
                if (_category == Category_CloudMusic) {
                    [_information refreshCloudMusic];
                }else {
                    [_information refreshMedia];
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self disableFunctionBtn:YES];
                    [self refresh];
                });
                [_ipod endSync];
            }
        }
    });
    
}

- (void)refresh {
    [_searchFieldBtn setStringValue:@""];
    _isSearch = NO;
    if (_information.tracks != nil) {
        //更新内存数据
        if (_dataSourceArray != nil) {
            [_dataSourceArray release];
            _dataSourceArray = nil;
        }
        if (_category == Category_CloudMusic) {
            _dataSourceArray = [[NSMutableArray alloc] initWithArray:[_information cloudTrackArray]];
        }else {
            _dataSourceArray = [[NSMutableArray alloc] initWithArray:[_information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:_category]]];
        }
        [_loadingBox setContentView:nil];
        if (_dataSourceArray.count > 0) {
            [_mainBox setContentView:_contentView];
        }else{
            [_mainBox setContentView:_noDataView];
            [self configNoDataView];
        }
    }else{
        [_mainBox setContentView:_noDataView];
    }
    [_itemTableView changeHeaderCheckState:NSOffState];
    if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
        [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
    }
    [_loadingAnimationView endAnimation];
}

-(void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _isSearch = YES;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
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
        IMBTrack *track = [disAry objectAtIndex:i];
        if (track.checkState == NSOnState) {
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

- (void)dealloc {
    [_nc removeObserver:self name:PLAYLIST_COUNT_CHANGE object:nil];
    [super dealloc];
}

@end
