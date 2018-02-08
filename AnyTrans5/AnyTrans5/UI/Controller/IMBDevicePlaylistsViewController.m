//
//  IMBDevicePlaylistsViewController.m
//  iMobieTrans
//
//  Created by iMobie on 14-5-26.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBDevicePlaylistsViewController.h"
#import "IMBPlaylist.h"
#import "IMBPlaylistList.h"
#import "IMBImageAndTextCell.h"
#import "IMBiTunesEnum.h"
#import "IMBCustomHeaderCell.h"
#import "IMBAlertViewController.h"
#import "IMBDeviceMainPageViewController.h"
#import "IMBAddPlaylist.h"
#import "IMBRenamePlaylist.h"
#import "IMBDeletePlaylist.h"
#import "IMBAddTrackToList.h"
#import "IMBAnimation.h"
#import "IMBNotificationDefine.h"
@interface IMBDevicePlaylistsViewController ()

@end

@implementation IMBDevicePlaylistsViewController
@synthesize playlistsTableView = _playlistsTableView;
@synthesize playlistTextfield = _playlistTextfield;
@synthesize selectedItems = _selectedItems;
@synthesize selectedPlaylists = _selectedPlaylists;
@synthesize onlyTransferPlaylist = _onlyTransferPlaylist;
@synthesize isPlaylistType = _isPlaylistType;

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
        _isPlaylistType = YES;
        if (_information.playlists != nil) {
            _playlistArray = [_information.playlists.playlistArray retain];
            IMBPlaylist *masterPl = _ipod.playlists.getMasterPlaylist;
            if (masterPl.trackCount > 0) {
                _dataSourceArray = [[NSMutableArray alloc] initWithArray:[masterPl tracks]];
            }
        }
        _logManger = [IMBLogManager singleton];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePlaylistLanguage:) name:NOTIFY_PLAYLIST_CHANGE_LANGUAGE object:nil];
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self configNoDataView];
        NSString *addStr = CustomLocalizedString(@"Button_id_1", nil);
        NSRect rect = [StringHelper calcuTextBounds:addStr fontSize:14];
        float w = 110;
        if (rect.size.width > 80) {
            w = rect.size.width + 30;
        }
        [_addPlaylistBtn setFrame:NSMakeRect((_bottomView.frame.size.width - w)/2, _addPlaylistBtn.frame.origin.y, w, _addPlaylistBtn.frame.size.height)];
        [_addPlaylistBtn setTitleName:addStr];
        [_addPlaylistBtn setNeedsDisplay:YES];
        [_renameMenuItem setTitle:CustomLocalizedString(@"Common_id_8", nil)];
    });
    
}

- (void)changeSkin:(NSNotification *)notification {
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
//    [_playlistsTableView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"playlist_bgColor", nil)]];
    [_playlistsTableView setBackgroundColor:[NSColor clearColor]];
//    [_bottomView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"playlist_bgColor", nil)]];
    [_bottomView setBackgroundColor:[NSColor clearColor]];
    [self configNoDataView];
    NSString *addStr = CustomLocalizedString(@"Button_id_1", nil);
    [_addPlaylistBtn mouseDownImage:[StringHelper imageNamed:@"add_item3"] withMouseUpImg:[StringHelper imageNamed:@"add_item1"]  withMouseExitedImg:[StringHelper imageNamed:@"add_item1"]  mouseEnterImg:[StringHelper imageNamed:@"add_item2"]  withButtonName:addStr];
    [_loadingAnimationView setNeedsDisplay:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_renameMenuItem setTitle:CustomLocalizedString(@"Common_id_8", nil)];
    alerView = [[IMBAlertViewController alloc]initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_playlistsTableView setListener:self];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
//    [_playlistsTableView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"playlist_bgColor", nil)]];
    [_playlistsTableView setBackgroundColor:[NSColor clearColor]];
    [_playlistTextfield setStringValue:CustomLocalizedString(@"ItunesLibrary_id_2", nil)];
    [_scrollView setHastopBorder:NO leftBorder:NO BottomBorder:NO rightBorder:NO];
//    [_bgColorView setBackground:[NSColor whiteColor]];
//    _bgColorView.rightBorder = NO;
//    _bgColorView.bottomBorder = YES;
//    _bgColorView.topBorder = YES;
//    _bgColorView.isBorder = YES;
    [_playlistsTableView setAllowsEmptySelection:NO];
    [_playlistsTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    if (_dataSourceArray.count == 0) {
        [_rightMianBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_rightMianBox setContentView:_containTableView];
    }
//    [self configNoDataView];
    [_itemTableView reloadData];
    [self performSelector:@selector(checkCDBcorrupted) withObject:nil afterDelay:0.01];
    
    NSArray *array = [_itemTableView tableColumns];
    for (NSTableColumn *column in array) {
        if ([column.headerCell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *cell = column.headerCell;
            [cell setHasDiviation:YES];
            [cell setDiviationY:8];
        }
    }
    
//    [_bottomView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"playlist_bgColor", nil)]];
    [_bottomView setBackgroundColor:[NSColor clearColor]];
    NSString *addStr = CustomLocalizedString(@"Button_id_1", nil);
    NSRect rect = [StringHelper calcuTextBounds:addStr fontSize:14];
    float w = 110;
    if (rect.size.width > 80) {
        w = rect.size.width + 30;
    }
    [_addPlaylistBtn setFrame:NSMakeRect((_bottomView.frame.size.width - w)/2, _addPlaylistBtn.frame.origin.y, w, _addPlaylistBtn.frame.size.height)];
    [_addPlaylistBtn mouseDownImage:[StringHelper imageNamed:@"add_item3"] withMouseUpImg:[StringHelper imageNamed:@"add_item1"]  withMouseExitedImg:[StringHelper imageNamed:@"add_item1"]  mouseEnterImg:[StringHelper imageNamed:@"add_item2"]  withButtonName:addStr];
    _nc = [NSNotificationCenter defaultCenter];
    [_nc addObserver:self selector:@selector(changeAddToPlaylistMenu) name:PLAYLIST_COUNT_CHANGE object:nil];
    [self changeAddToPlaylistMenu];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
}

- (void)changeAddToPlaylistMenu {
    IMBPlaylist *currentPlaylist = nil;
    NSIndexSet *indexset = _playlistsTableView.selectedRowIndexes;
    if (indexset.count > 0) {
        NSInteger integer = indexset.firstIndex;
        currentPlaylist = [_playlistArray objectAtIndex:integer];
    }
    NSArray *array = [_ipod.playlists getPlaylist];
    int i = 0;
    for (IMBPlaylist *playlist in array) {
        if (playlist.iD != currentPlaylist.iD && playlist.isUserDefinedPlaylist) {
            i ++;
        }
    }
    if (i < 1) {
        [_addToPlaylistMenuItem setHidden:YES];
    }else {
        [_addToPlaylistMenuItem setHidden:NO];
    }
}

#pragma mark - NSTextView
- (void)configNoDataView {
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_box"]];
    [_textView setDelegate:self];
    NSString *promptStr = @"";
    NSString *overStr= @"";
    if (_isPlaylistType) {
        overStr = CustomLocalizedString(@"NO_DATA_TITLE_2", nil);
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MSG_Item_id_1", nil)] stringByAppendingString:overStr];
    }else {
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MSG_Item_id_1", nil)] ;
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

- (NSArray *)selectedPlaylists{
    if (!_onlyTransferPlaylist) {
        NSInteger index = [_playlistsTableView selectedRow];
        if (index == -1) {
            return nil;
        }
        IMBPlaylist *playlist = nil;
        if (index != NSNotFound) {
            playlist = [_playlistArray objectAtIndex:index];
        }
        if (playlist != nil) {
            return [NSArray arrayWithObject:playlist];
        }
    }
    else{
        return _selectedPlaylists;
    }
    return nil;
}

- (NSArray *)selectedItemsByPlaylist{
    if (_onlyTransferPlaylist) {
        return nil;
    }
    NSIndexSet *indexSet = _itemTableView.selectedRowIndexes;
    if (indexSet.count == 0) {
        return nil;
    }
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    NSMutableArray *items = [NSMutableArray array];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [items addObject:[displayArray objectAtIndex:idx]];
    }];
    return items;
}

- (void)toDevice:(id)sender{
    [self toDeviceItems];
}

- (void)toDeviceItems{
    _onlyTransferPlaylist = NO;
    [super toDevice:nil];
}

- (void)toDevicePlaylists{
    _onlyTransferPlaylist = YES;
    for (IMBPlaylist *playlist in _selectedPlaylists) {
        [playlist setBetweenDeviceCopyableTrackList:playlist.tracks];
    }
    [super toDevice:nil];
}

- (void)initPlaylistMenuItem {
    
    IMBPlaylist *currentPlaylist = nil;
    [_addToPlaylistMenuItem setTitle:CustomLocalizedString(@"Menu_Playlist", nil)];
    NSMenu *addToPlaylistMenu = _addToPlaylistMenuItem.submenu;
    [addToPlaylistMenu removeAllItems];
    

    [addToPlaylistMenu setAutoenablesItems:NO];
    NSIndexSet *indexset = _playlistsTableView.selectedRowIndexes;
    if (indexset.count > 0) {
        NSInteger integer = indexset.firstIndex;
        currentPlaylist = [_playlistArray objectAtIndex:integer];
    }
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

#pragma mark - 将歌曲添加到指定播放列表
- (void)addToPlaylist:(long long)playlistID{
    NSLog(@"========");
    if (![self checkInternetAvailble]) {
        [_logManger writeInfoLog:[NSString stringWithFormat:@"Do Add Track To Playlist End (checkInternetAvailble = %d)",[self checkInternetAvailble]]];
        return;
    }
    
    NSInteger selectedRow = [_playlistsTableView selectedRow];
    if (selectedRow != NSNotFound) {
        IMBPlaylist *playlist = [_playlistArray objectAtIndex:selectedRow];
        if (playlist != nil){
            [_logManger writeInfoLog:@"Do Add Track To Playlist Strat"];
            
            if (playlist.iD != playlistID) {
                IMBPlaylist *playlist = [_ipod.playlists getPlaylistByID:playlistID];
                NSArray *selectItem = [self selectedItemsByPlaylist];
                if (playlist != nil && selectItem.count > 0) {
                    IMBAddTrackToList *procedure = [[IMBAddTrackToList alloc] initWithIPodKey:_ipod.uniqueKey tracksArray:selectItem playlistID:playlist.iD];
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
                    
                    [_alertViewController showDeleteAnimationViewAlertText:str SuperView:view];
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [procedure startAddTrackToList];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_alertViewController unloadAlertView:_alertViewController.deleteAnimationView];
                            [self reload:nil];
                        });
                        [procedure release];

                    });
                    [_playlistsTableView deselectAll:nil];
                }
            }
            else{
                [_logManger writeInfoLog:[NSString stringWithFormat:@"%@ is same playlist,cannot add",playlist.name]];
                
            }
        }
    }else {
        [self showAlertText:CustomLocalizedString(@"MSG_COM_No_Item_Selected", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }
}

#pragma mark - 重命名一个头playlist列表
- (IBAction)doRenamePlaylist:(id)sender{
    [_logManger writeInfoLog:@"Do Rename Playlist Strat"];
    if (![self checkInternetAvailble]) {
        [_logManger writeInfoLog:[NSString stringWithFormat:@"Do Rename Playlist End (checkInternetAvailble = %d)",[self checkInternetAvailble]]];
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
    NSInteger row = [_playlistsTableView selectedRow];
    IMBPlaylist *pl = [_playlistArray objectAtIndex:row];
    NSString *string = [NSString stringWithFormat:@"%@",CustomLocalizedString(@"Playlist_id_2", nil)];
    NSInteger result = [alerView showTitleName:string InputTextFiledString:pl.name OkButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
    
    [alerView.renameLoadingView setHidden:NO];
    [alerView.renameLoadingView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [alerView.renameLoadingView setImage:[StringHelper imageNamed:@"registedLoading"]];
    [alerView.renameLoadingView.layer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:-2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
    if (result == 1) {
        //进行重命名操作
        NSString *inputName = [[alerView reNameInputTextField] stringValue];
        if (![TempHelper stringIsNilOrEmpty:inputName] && ![inputName isEqualToString:pl.name]) {
            IMBRenamePlaylist *procedure = [[IMBRenamePlaylist alloc] initWithIPodKey:_ipod.uniqueKey playlistName:inputName playlistID:pl.iD];
//            [self showRefrshLoading:YES LoadingType:LoadingReName];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [procedure startRenamePlaylist];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alerView unloadAlertView:alerView.reNameView];
                    [alerView.renameLoadingView setHidden:YES];
                    [self reload:nil];
                   
                });
                [procedure release];
            });
        }
    }
}

#pragma mark - 删除单个播放列表
- (IBAction)doDeletePlaylist:(id)sender{
    [_logManger writeInfoLog:@"Do Rename Playlist Strat"];
    if (![self checkInternetAvailble]) {
        [_logManger writeInfoLog:[NSString stringWithFormat:@"Do Rename Playlist End (checkInternetAvailble = %d)",[self checkInternetAvailble]]];
        return;
    }
    
    IMBPlaylist *pl = nil;
    NSInteger index = _playlistsTableView.selectedRow;
    if (index != NSNotFound) {
        pl = [_playlistArray objectAtIndex:index];
    }
    if (pl == nil) {
        return;
    }
    _isDeletePlaylist = YES;
    [self showAlertText:[NSString stringWithFormat:CustomLocalizedString(@"Playlist_id_4", nil),pl.name] OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)];
}

-(void)deleteBackupSelectedItems:(id)sender{
    if (_isDeletePlaylist) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [_alertViewController._removeprogressAnimationView setProgress:0];
            long long playlistID = 0;
            IMBPlaylist *pl = nil;
            NSInteger index = _playlistsTableView.selectedRow;
            if (index != NSNotFound) {
                pl = [_playlistArray objectAtIndex:index];
                playlistID = pl.iD;
            }
            if (pl == nil) {
                return;
            }
            if (playlistID != 0) {
                [self removePlaylistWithID:playlistID];
                IMBDeletePlaylist *procedure = [[IMBDeletePlaylist alloc] initWithIPod:_ipod deleteArray:[NSMutableArray arrayWithObjects:pl, nil]];
                [procedure setDelegate:self];
                [procedure startDelete];
                [procedure release];
            }
            [_playlistsTableView reloadData];
        });
    }else {
        [super deleteBackupSelectedItems:sender];
    }
}

- (void)setDeleteProgress:(float)progress withWord:(NSString *)msgStr {
    if (_isDeletePlaylist) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"delete progress:%f",progress);
            [_alertViewController._removeprogressAnimationView setProgress:progress];
            [_alertViewController showChangeRemoveProgressViewTitle:msgStr];
        });
    }else {
        [super setDeleteProgress:progress withWord:msgStr];
    }
}

- (void)setDeleteComplete:(int)success totalCount:(int)totalCount {
    if (_isDeletePlaylist) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_alertViewController._removeprogressAnimationView setProgressWithOutAnimation:100];
            [self showRemoveSuccessAlertText:CustomLocalizedString(@"MSG_COM_Delete_Complete", nil) withCount:success];
            [_nc postNotificationName:PLAYLIST_COUNT_CHANGE object:nil];
            //    IMBPlaylist *pl = [_playlistArray objectAtIndex:0];
            //    [self reloadByPlaylistID:pl.iD];
        });
    }else {
        [super setDeleteComplete:success totalCount:totalCount];
    }
}

#pragma mark - 添加一个头playlist列表
- (IBAction)doAddPlaylist:(id)sender{
    if (![self checkInternetAvailble]) {
        [_logManger writeInfoLog:[NSString stringWithFormat:@"Do Add Playlist End (checkInternetAvailble = %d)",[self checkInternetAvailble]]];
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
    NSString *string = [NSString stringWithFormat:@"%@",CustomLocalizedString(@"Playlist_id_2", nil)];
    NSInteger result = [alerView showTitleName:string InputTextFiledString:@"" OkButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
    if (result == 1) {
        //进行增加操作
        [_logManger writeInfoLog:@"Do Add Playlist Strat"];
        [alerView.renameLoadingView setHidden:NO];
        [alerView.renameLoadingView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [alerView.renameLoadingView setImage:[StringHelper imageNamed:@"registedLoading"]];
        [alerView.renameLoadingView.layer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:-2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
        NSString *inputName = [[alerView reNameInputTextField] stringValue];
        if (![TempHelper stringIsNilOrEmpty:inputName]) {
            IMBAddPlaylist *addPlaylist = [[IMBAddPlaylist alloc] initWithIPodKey:_ipod.uniqueKey playlistName:inputName];
            ;
//            [self showRefrshLoading:YES LoadingType:LoadingAddPlaylist];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [addPlaylist startAddPlaylist];
                [addPlaylist release];
                //刷新当前view, TODO也可以在回调事件中从tableview中删除
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alerView unloadAlertView:alerView.reNameView];
                    [alerView.renameLoadingView setHidden:YES];
                    [self reload:nil];
                    [_nc postNotificationName:PLAYLIST_COUNT_CHANGE object:nil];
                });
            });
        }
    }
}

#pragma mark - 设备间传输playlist
- (IBAction)doBatchHandle:(id)sender{
/*    NSMenuItem *menuItem = sender;
    int tag = menuItem.tag;
    [_logManger writeInfoLog:@"Do Between Device Playlist Strat"];
    if (![self checkInternetAvailble]) {
        
        [_logManger writeInfoLog:[NSString stringWithFormat:@"Do Between Device Playlist End (checkInternetAvailble = %d)",[self checkInternetAvailble]]];
        return;
    }
    NSMutableString *msg = [[NSMutableString alloc] init];
    
    [msg release];
    IMBUserDefinedPlistWindowController *userdefineWC = nil;
    if (tag == 0) {
        userdefineWC = [[IMBUserDefinedPlistWindowController alloc] initWithIpodkey:_ipod.uniqueKey withType:BetweenDeviceEnum];
    }
    else if(tag == 1){
        userdefineWC = [[IMBUserDefinedPlistWindowController alloc] initWithIpodkey:_ipod.uniqueKey withType:DeleteEnum];

    }
    userdefineWC.contentViewController = self;
    [NSApp runModalForWindow:userdefineWC.window];
    if (userdefineWC.block != nil) {
        userdefineWC.block();
    }
    [userdefineWC release];
  */
}

- (int) runWindowModalSession:(NSWindow*)window {
    //[NSApp runModalForWindow:window];
    __block int result = NSRunContinuesResponse;
    
    NSModalSession session =  [NSApp beginModalSessionForWindow:window];
    
    while ( (result= [NSApp runModalSession:session]) == NSRunContinuesResponse)
    {
        //run the modal session
        //once the modal window finishes, it will return a different result and break out of the loop
        //result = [NSApp runModalSession:session];
        //this gives the main run loop some time so your other code processes
        //[[NSRunLoop currentRunLoop] limitDateForMode:NSDefaultRunLoopMode];
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        NSDate *date = [NSDate distantFuture];
        [runloop runMode:NSDefaultRunLoopMode beforeDate:date];
        //do some other non-intensive task if necessary
    }
    
    [NSApp endModalSession:session];
    NSLog(@"endModalSession result: %d", result);
    
    return result;
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (tableView == _itemTableView) {
        if (_dataSourceArray != nil) {
            //当前显示的数据源
            NSArray *displayArray = nil;
            if (_isSearch) {
                displayArray = _researchdataSourceArray;
            }
            else{
                displayArray = _dataSourceArray;
            }
            if (displayArray.count <= 0) {
                return 0;
            }
            return [displayArray count];
        }

    }else if (tableView == _playlistsTableView)
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
        }
        else{
            displayArray = _dataSourceArray;
        }
    
        if(row >= displayArray.count||displayArray.count <= 0){
            return nil;
        }
        IMBTrack *track = [displayArray objectAtIndex:row];
        
        if ([@"Name" isEqualToString:tableColumn.identifier] ) {
            return track.title;
        }else if ([@"Time" isEqualToString:tableColumn.identifier]) {
            return [[StringHelper getTimeString:track.length] stringByAppendingString:@" "];
        }else if ([@"Artist" isEqualToString:tableColumn.identifier]) {
            return track.artist;
        }else if ([@"Album" isEqualToString:tableColumn.identifier]) {
            return track.album;
        }else if ([@"Size" isEqualToString:tableColumn.identifier]) {
            return [StringHelper getFileSizeString:track.fileSize reserved:2];
        }else if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
            return [NSNumber numberWithInt:track.checkState];
        }else if ([@"Type" isEqualToString:tableColumn.identifier]) {
            return [IMBiTunesEnum iTunesMediaTypeEnumToString:(iTunesMediaTypeEnum)track.mediaType];
        }
        

    }else if (tableView == _playlistsTableView)
    {
        IMBPlaylist *pl = [_playlistArray objectAtIndex:row];
        if ([@"PlaylistName" isEqualToString:tableColumn.identifier] ) {
            return pl.name;
        }else if ([@"itemCount" isEqualToString:tableColumn.identifier] ) {
            int count = pl.trackCount;
            if (count == 0) {
                return @"--";
            }
            return [NSNumber numberWithInt:count];
        }
    }
    return @"";
}

#pragma mark - NSTableViewdelegate
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == _playlistsTableView)
    {
    
        if ([@"PlaylistName" isEqualToString:tableColumn.identifier] ) {
            IMBPlaylist *pl = [_playlistArray objectAtIndex:row];
            IMBImageAndTextCell *cell1 = (IMBImageAndTextCell*)cell;
            cell1.imageSize = NSMakeSize(16, 16);
            cell1.marginX = 20;
            cell1.paddingX = 0;
            if (pl.isMaster == true) {
                cell1.image = [StringHelper imageNamed:[self getListIconName:_ipod]];
                cell1.imageName = [self getListIconName:_ipod];
            } else if (pl.isUserDefinedPlaylist == false) {
                cell1.image = [StringHelper imageNamed:@"list"];
                cell1.imageName = @"list";
            } else if (pl.isUserDefinedPlaylist == true) {
                cell1.image = [StringHelper imageNamed:@"news_list"];
                cell1.imageName = @"news_list";
            }
        }else if ([@"itemCount" isEqualToString:tableColumn.identifier]) {
            IMBPlaylist *pl = [_playlistArray objectAtIndex:row];
            IMBCenterTextFieldCell *cell1 = (IMBCenterTextFieldCell*)cell;
            if (pl.playlistItems.count == 0) {
                cell1.isLastCell = YES;
            }else {
                cell1.isLastCell = NO;
            }
        }
    }
    
}

- (NSCell*)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == _itemTableView) {
        
        NSArray *displayArray = nil;
        if (_isSearch) {
            displayArray = _researchdataSourceArray;
        }
        else{
            displayArray = _dataSourceArray;
        }
        if (displayArray.count <= 0) {
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

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView *atableView = [notification object];

    if (atableView == _playlistsTableView) {
        NSInteger row = [_playlistsTableView selectedRow];
        if (row == -1) {
            return;
        }
        [_searchFieldBtn setStringValue:@""];
        _isSearch = NO;
        IMBPlaylist *pl = [_playlistArray objectAtIndex:row];
        if (pl.isMaster) {
            _isPlaylistType = YES;
        }else {
            _isPlaylistType = pl.isUserDefinedPlaylist;
        }
        [_delegate loadPlaylistButton:_isPlaylistType withViewController:self];
        if (_dataSourceArray != nil) {
            [_dataSourceArray release];
            _dataSourceArray = nil;
        }
        if (pl != nil && pl.tracks) {
             _dataSourceArray = [[NSMutableArray alloc] initWithArray:[pl tracks]];
        }
//        NSArray *array;
//        if (_isSearching) {
//            array = _searchBindingArray;
//        }
//        else{
//            array = _bindingArray;
//        }
//        
//        if (array.count > 0) {
//            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                IMBDetailBindingEntity *detailBinding = (IMBDetailBindingEntity *)obj;
//                [detailBinding.checkBox removeFromSuperview];
//            }];
//        }
//        _isSearching = NO;
//
//        [self rebuildingBindingArray:_itemArray];
//        [_itemTableView deselectAll:nil];
//        [_itemTableView uncheckAllButton];
        
        for (IMBTrack *track in _dataSourceArray) {
            track.checkState = UnChecked;
        }
        [_itemTableView changeHeaderCheckState:UnChecked];
        [self setAllselectState:UnChecked];
//        [_itemTableView reloadData];
        
        if (_dataSourceArray.count == 0) {
            [_rightMianBox setContentView:_noDataView];
            [self configNoDataView];
        }else {
            [_rightMianBox setContentView:_containTableView];
        }
        [_itemTableView reloadData];
    }else {
        NSMutableArray *disPlayAry = nil;
        if (_isSearch) {
            disPlayAry = _researchdataSourceArray;
        }else{
            disPlayAry = _dataSourceArray;
        }
//        NSIndexSet *set = [_itemTableView selectedRowIndexes];
//        for (int i=0; i<[disPlayAry count]; i++) {
//            IMBTrack *track = [disPlayAry objectAtIndex:i];
//            if ([set containsIndex:i]) {
//                [track setCheckState:NSOnState];
//            }else{
//                [track setCheckState:NSOffState];
//            }
//        }
//        if ([set count] == [disPlayAry count]&&[disPlayAry count]>0) {
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
    [self changeAddToPlaylistMenu];
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
	if ( [@"Name" isEqualToString:identify] || [@"Time" isEqualToString:identify] || [@"Artist" isEqualToString:identify] || [@"Album" isEqualToString:identify] || [@"Size" isEqualToString:identify] || [@"Type" isEqualToString:identify]) {
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
            IMBTrack *track = [_dataSourceArray objectAtIndex:i];
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
        key = @"title";
    } else if ([key isEqualToString:@"Time"]) {
        key = @"length";
    }else if ([key isEqualToString:@"Artist"]) {
        key = @"artist";
    } else if ([key isEqualToString:@"Album"]) {
        key = @"album";
    } else if ([key isEqualToString:@"Size"]) {
        key = @"fileSize";
    }else if ([key isEqualToString:@"Type"]) {
        key = @"mediaType";
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    [_itemTableView reloadData];
    
    [sortDescriptor release];
    [sortDescriptors release];
}

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    if (tableView == _playlistsTableView) {
        
        return NO;
    }else
    {
        NSArray *fileTypeList = [NSArray arrayWithObject:@"export"];
        [pboard setPropertyList:fileTypeList
                        forType:NSFilesPromisePboardType];
        return YES;
    }
        
}

#pragma mark - IMBImageRefreshListListener
- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    NSMutableArray *disPlayAry = nil;
    if (_isSearch) {
        disPlayAry = _researchdataSourceArray;
    }else{
        disPlayAry = _dataSourceArray;
    }
    IMBTrack *track = [disPlayAry objectAtIndex:index];
    track.checkState = !track.checkState;
    
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[disPlayAry count]; i++) {
        IMBTrack *item= [disPlayAry objectAtIndex:i];
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
    
    if (set.count == disPlayAry.count) {
        [_itemTableView changeHeaderCheckState:Check];
    }else if (set.count == 0){
        [_itemTableView changeHeaderCheckState:UnChecked];
    }else{
        [_itemTableView changeHeaderCheckState:SemiChecked];
    }
    [_itemTableView reloadData];
}

- (void)tableView:(NSTableView *)tableView rightDownrow:(NSInteger)index {
    if (tableView == _playlistsTableView) {
        IMBPlaylist *pl = [_playlistArray objectAtIndex:index];
        if (pl.isMaster) {
            for (NSMenuItem *item in _leftMenuItem.itemArray) {
                [item setHidden:YES];
            }
        }else if (pl.isUserDefinedPlaylist == false){
            [_renameMenuItem setHidden:YES];
            [_toDeleteMenuItem setHidden:YES];
            [_addToDeviceMenuItem setHidden:NO];
        }else {
            [_renameMenuItem setHidden:NO];
            [_toDeleteMenuItem setHidden:NO];
            [_addToDeviceMenuItem setHidden:NO];
        }
        [_playlistsTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
    }
}

- (void)setAllselectState:(CheckStateEnum)checkState {
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }

    for (int i=0;i<[displayArray count]; i++) {
        IMBTrack *track = [displayArray objectAtIndex:i];
        [track setCheckState:checkState];
        if (track.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
//    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    [_itemTableView reloadData];
}

- (void)removePlaylistWithID:(long long)plID {
    [_playlistsTableView deselectAll:nil];
    if (_playlistArray != nil) {
        [_playlistArray release];
        _playlistArray = nil;
    }
    NSMutableArray *plArray = [NSMutableArray arrayWithArray:_information.playlists.playlistArray];
    _playlistArray = [[NSMutableArray arrayWithArray:[plArray filteredArrayUsingPredicate:
                       [NSPredicate predicateWithFormat:@"iD != %lld",plID]]] retain];
    [_playlistsTableView reloadData];
}

- (void)removePlaylistWithplArr:(NSArray *)plArr {
    [_playlistsTableView deselectAll:nil];
    if (_playlistArray != nil) {
        [_playlistArray release];
        _playlistArray = nil;
    }
    NSMutableArray *plArray = [NSMutableArray arrayWithArray:_information.playlists.playlistArray];
    for (int i=0;i<[plArr count]; i++) {
        
        IMBPlaylist  *playlist = [plArr objectAtIndex:i];
        
        _playlistArray = [[NSMutableArray arrayWithArray:[plArray filteredArrayUsingPredicate:
                           [NSPredicate predicateWithFormat:@"iD != %lld",playlist.iD]]] retain];
    }
    
    [_playlistsTableView reloadData];
}

#pragma mark OperationActions
- (void)reload:(id)sender {
    [self disableFunctionBtn:NO];
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    [_loadingBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            if (_ipod != nil) {
                [_ipod startSync];
                [_information refreshMedia];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self disableFunctionBtn:YES];
                    [_loadingAnimationView endAnimation];
                    int row = (int)_playlistsTableView.selectedRow;
                    if (row < 0) {
                        [_playlistsTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                    }
                    row = (int)_playlistsTableView.selectedRow;
                    IMBPlaylist *pl = [_playlistArray objectAtIndex:row];
                    long long plID = 0;
                    if (pl != nil) {
                       plID = pl.iD;
                    }
                    [_loadingBox setContentView:nil];
                    [self reloadByPlaylistID:plID];
                    if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                        [_delegate refeashBadgeConut:_playlistArray.count WithCategory:_category];
                    }
                });
                [_ipod endSync];
            }
            
        }
    });
}

- (void)reloadByPlaylistID:(long long)plID {
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    [_playlistsTableView deselectAll:nil];
    [_itemTableView deselectAll:nil];
    if (_playlistArray != nil) {
        [_playlistArray  release];
        _playlistArray = nil;
    }
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    
    if (_ipod.playlists != nil) {
        
        _playlistArray = [_ipod.playlists.playlistArray retain];
        IMBPlaylist *pl = [_ipod.playlists getPlaylistByID:plID];
        if (pl != nil) {
            
            _dataSourceArray = [[NSMutableArray alloc] initWithArray:[pl tracks]];
        } else {
            
            _dataSourceArray = [[NSMutableArray alloc] initWithArray:[_ipod.playlists.getMasterPlaylist tracks]];
        }

        if (_dataSourceArray.count == 0) {
            [_rightMianBox setContentView:_noDataView];
            [self configNoDataView];
        }else {
            [_rightMianBox setContentView:_containTableView];
        }
        [_playlistsTableView reloadData];
        if (pl != nil) {
            int index = (int)[_playlistArray indexOfObject:pl];
            if (index != NSNotFound) {
                NSMutableIndexSet *mutableIndexSet = [[NSMutableIndexSet alloc] init];
                [mutableIndexSet addIndex:index];
                [_playlistsTableView selectRowIndexes:mutableIndexSet byExtendingSelection:NO];
                [mutableIndexSet release];
                
            } else {
                NSMutableIndexSet *mutableIndexSet = [[NSMutableIndexSet alloc] init];
                [mutableIndexSet addIndex:index];
                [_playlistsTableView selectRowIndexes:mutableIndexSet byExtendingSelection:NO];
                [mutableIndexSet release];
            }
        }
        [_itemTableView reloadData];
    }
}

- (void)reloadListWithPlaylistArr:(NSArray *)plArr {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [_playlistsTableView deselectAll:nil];
        [_itemTableView deselectAll:nil];
    });
    
    NSLog(@"deselect......");
    
    if (_playlistArray != nil) {
        [_playlistArray release];
        _playlistArray = nil;
    }
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    if (_ipod.playlists != nil) {
        _playlistArray = [_ipod.playlists.playlistArray retain];
        for (IMBPlaylist *pl in plArr) {
            
            if (pl != nil) {
                //            _tracklistArray = [[NSArray alloc]initWithArray:[pl tracks]];
                _dataSourceArray = [[NSMutableArray alloc] initWithArray:[pl tracks]];
                
            } else {
                //            _tracklistArray = [[NSArray alloc]initWithArray:[_iPod.playlists.getMasterPlaylist tracks]];
                _dataSourceArray = [[NSMutableArray alloc] initWithArray:[_ipod.playlists.getMasterPlaylist tracks]];
            }
//            [self rebuildingBindingArray:_itemArray];
            [_playlistsTableView reloadData];
            if (pl != nil) {
                if ([_playlistArray containsObject:pl]) {
                    int index = (int)[_playlistArray indexOfObject:pl];
                    if (index != NSNotFound) {
                        NSMutableIndexSet *mutableIndexSet = [[NSMutableIndexSet alloc] init];
                        [mutableIndexSet addIndex:index];
                        [_playlistsTableView selectRowIndexes:mutableIndexSet byExtendingSelection:NO];
                        [mutableIndexSet release];
                        
                    } else {
                        NSMutableIndexSet *mutableIndexSet = [[NSMutableIndexSet alloc] init];
                        [mutableIndexSet addIndex:index];
                        [_playlistsTableView selectRowIndexes:mutableIndexSet byExtendingSelection:NO];
                        [mutableIndexSet release];
                    }
                    [self reload:nil];
                }
                else{
                    if (_playlistArray.count > 0) {
                        NSMutableIndexSet *mutableIndexSet = [[NSMutableIndexSet alloc] init];
                        [mutableIndexSet addIndex:0];
                        [_playlistsTableView selectRowIndexes:mutableIndexSet byExtendingSelection:NO];
                        [mutableIndexSet release];
                    }
                }
            }
            [_itemTableView reloadData];
        }
        
    }
//    [self showRefrshLoading:NO];

}

- (void)changePlaylistLanguage:(NSNotification *)notification {
//    [_propertyMenuItem setTitle:CustomLocalizedString(@"Menu_Property", nil)];
//    [_deleteMenuItem setTitle:CustomLocalizedString(@"Menu_Delete", nil)];
//    [_toDeviceMenuItem setTitle:CustomLocalizedString(@"Menu_ToDevice", nil)];
//    [_toMacMenuItem setTitle:CustomLocalizedString(@"Menu_ToPc", nil)];
//    [_toiTunesMenuItem setTitle:CustomLocalizedString(@"Menu_ToiTunes", nil)];
//    [_addToPlaylistMenuItem setTitle:CustomLocalizedString(@"Menu_Playlist", nil)];
//    [_addToDeviceMenuItem setTitle:CustomLocalizedString(@"Menu_ToDevice", nil)];
//    [_toDeleteMenuItem setTitle:CustomLocalizedString(@"Playlist_id_11", nil)];
//    [_playlistTextfield setStringValue:CustomLocalizedString(@"Playlist_id_1", nil)];
//    [_renameMenuItem setTitle:CustomLocalizedString(@"Common_id_8", nil)];
//    [_itemTableView _setupHeaderCell];
//    [_itemTableView reloadData];
//    if ([_countDelegate respondsToSelector:@selector(reCaulateItemCount)]) {
//        
//        [_countDelegate reCaulateItemCount];
//    }
}

- (NSString*) getListIconName:(IMBiPod*)iPod {
    if (iPod.deviceInfo.isIOSDevice == TRUE) {
        if ([iPod.deviceInfo.productType containsString:@"iPad"]) {
            return @"playlist_ipad";
        } else if ([iPod.deviceInfo.productType containsString:@"iPhone"]) {
            return @"playlist_iphone";
        } else if ([iPod.deviceInfo.productType containsString:@"iPod"]) {
            return @"playlist_ipod";
        } else {
            return @"playlist_iphone";
        }
    } else {
        return @"playlist_ipod";
    }
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _isSearch = YES;
    _searchFieldBtn = searchBtn;
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

- (void)reloadTableView{
    _isSearch = NO;
    [_playlistsTableView reloadData];
    if (_playlistArray.count > 0) {
        NSInteger row = [_playlistsTableView selectedRow];
        if (row == 0) {
            NSNotification *noti = [NSNotification notificationWithName:@"" object:_playlistsTableView];
            [self tableViewSelectionDidChange:noti];
        }else {
            [_playlistsTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        }
    }
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_PLAYLIST_CHANGE_LANGUAGE object:nil];
    [_nc removeObserver:self name:PLAYLIST_COUNT_CHANGE object:nil];
    if (_selectedPlaylists) {
        [_selectedPlaylists release];
        _selectedPlaylists = nil;
    }
    
    if (_selectedItems) {
        [_selectedItems release];
        _selectedItems = nil;
    }
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    [super dealloc];
}
@end
