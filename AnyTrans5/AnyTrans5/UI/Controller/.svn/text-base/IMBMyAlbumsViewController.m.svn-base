//
//  IMBMyAlbumsViewController.m
//  iMobieTrans
//
//  Created by iMobie on 7/28/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBMyAlbumsViewController.h"
#import "IMBImageAndTextCell.h"
#import "IMBPhotosCollectionViewController.h"
//#import "IMBAddOrRenameAlbumWindowController.h"
#import "IMBDeleteTrack.h"
//#import "IMBProcedureWindowController.h"
#import "IMBPhotosListViewController.h"
//#import "IMBPhotoFileExport.h"
#import "IMBDeviceInfo.h"
#import "IMBAirSyncImportTransfer.h"
//#import "IMBExportSetting.h"
#import "IMBDeviceMainPageViewController.h"
#import "IMBSegmentedBtn.h"
#import "IMBAlertViewController.h"
#import "IMBAnimation.h"
#import "IMBDeleteCameraRollPhotos.h"
@interface IMBMyAlbumsViewController ()

@end

@implementation IMBMyAlbumsViewController
@synthesize albumTableView = _albumTableView;
@synthesize selectedType = _selectedType;
@synthesize currentSelectView = _currentSelectView;
@synthesize currentEntity = _currentEntity;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    self = [super initWithIpod:ipod withCategoryNodesEnum:category withDelegate:delegate];
    if (self) {
        _currentSelectView = 1;
        _selectedType = CreateAlbum;
        
        if (_category == Category_MyAlbums) {
            _contentDic = [[NSMutableDictionary alloc] init];
            _playlistArray = [[_information myAlbumsArray] retain];
        }else if (_category == Category_PhotoShare) {
            _contentDic = [[NSMutableDictionary alloc] init];
            _playlistArray = [[_information photoshareArray] retain];
        }else if (_category == Category_ContinuousShooting)
        {
            _contentDic = [[NSMutableDictionary alloc] init];
            _playlistArray = [[_information continuousShootingArray] retain];
        }
    }
    return self;
}

- (void)dealloc {
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ALBUMS_CHANGE_LANGUAGE object:nil];
    if (_contentDic != nil) {
        [_contentDic release];
        _contentDic = nil;
    }
    if (_currentContorller != nil) {
        [_currentContorller release];
        _currentContorller = nil;
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
        [_addAlbumBtn setFrame:NSMakeRect((_bottomView.frame.size.width - w)/2, _addAlbumBtn.frame.origin.y, w, _addAlbumBtn.frame.size.height)];
        [_addAlbumBtn setTitleName:addStr];
        [_addAlbumBtn setNeedsDisplay:YES];
    });
}

- (void)changeSkin:(NSNotification *)notification {
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [self configNoDataView];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
//    [_albumTableView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"playlist_bgColor", nil)]];
    [_albumTableView setBackgroundColor:[NSColor clearColor]];
    if (_category != Category_ContinuousShooting && _category != Category_PhotoShare) {
//        [_bottomView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"playlist_bgColor", nil)]];
        [_bottomView setBackgroundColor:[NSColor clearColor]];
        NSString *addStr = CustomLocalizedString(@"Button_id_2", nil);
        [_addAlbumBtn mouseDownImage:[StringHelper imageNamed:@"add_item3"] withMouseUpImg:[StringHelper imageNamed:@"add_item1"]  withMouseExitedImg:[StringHelper imageNamed:@"add_item1"]  mouseEnterImg:[StringHelper imageNamed:@"add_item2"]  withButtonName:addStr];
    }
    [_loadingAnimationView setNeedsDisplay:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    alerView = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    //    [_searchFieldBtn setHidden:YES];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    if (_playlistArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        //        [self configNoDataView];
    }else {
        [_mainBox setContentView:_containTableView];
    }
    [self configNoDataView];
    [_albumTableView setListener:self];
//    [_albumTableView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"playlist_bgColor", nil)]];
    [_albumTableView setBackgroundColor:[NSColor clearColor]];
    [_renameMenuItem setTitle:CustomLocalizedString(@"Common_id_8", nil)];
    [_deleteItem setTitle:CustomLocalizedString(@"Common_id_9", nil)];
    if (_category == Category_ContinuousShooting||_category == Category_PhotoShare) {
        [_bottomView setHidden:YES];
        [_scrollView setFrame:NSMakeRect(0, 0, _scrollView.frame.size.width, _containTableView.frame.size.height)];
        [_albumTableView setFrame:NSMakeRect(0, 0, _scrollView.frame.size.width, _containTableView.frame.size.height)];
        [_renameMenuItem setHidden:YES];
        
        if (_category == Category_ContinuousShooting) {
            
            [_albumTableView setAllowsMultipleSelection:YES];
            [_albumTableView setAllowsEmptySelection:NO];
        }
        
    }else
    {
//        [_bottomView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"playlist_bgColor", nil)]];
        [_bottomView setBackgroundColor:[NSColor clearColor]];
        NSString *addStr = CustomLocalizedString(@"Button_id_2", nil);
        NSRect rect = [StringHelper calcuTextBounds:addStr fontSize:14];
        float w = 110;
        if (rect.size.width > 80) {
            w = rect.size.width + 30;
        }
        [_addAlbumBtn setFrame:NSMakeRect((_bottomView.frame.size.width - w)/2, _addAlbumBtn.frame.origin.y, w, _addAlbumBtn.frame.size.height)];
        [_addAlbumBtn mouseDownImage:[StringHelper imageNamed:@"add_item3"] withMouseUpImg:[StringHelper imageNamed:@"add_item1"]  withMouseExitedImg:[StringHelper imageNamed:@"add_item1"]  mouseEnterImg:[StringHelper imageNamed:@"add_item2"]  withButtonName:addStr];
    }
    
    [_scrollView setHastopBorder:NO leftBorder:NO BottomBorder:NO rightBorder:NO];
    [_albumTableView setFocusRingType:NSFocusRingTypeNone];
    //    [_albumTableView setSelectionHighlightColor:[NSColor colorWithDeviceRed:0.0/255 green:160.0/255 blue:233.0/255 alpha:1.0]];
    [_albumTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    [_albumTableView reloadData];
    [self tableViewSelectionDidChange:nil];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
}

#pragma mark - NSTextView
- (void)configNoDataView {
    [_textView setDelegate:self];
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_photo"]];
    NSString *promptStr = @"";
    NSString *overStr = CustomLocalizedString(@"NO_DATA_TITLE_2", nil);
    if (_category == Category_MyAlbums) {
//        promptStr = [[[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)] stringByAppendingString:@","] stringByAppendingString:overStr];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)];
    }else if (_category == Category_PhotoShare) {
//        promptStr = [[[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)] stringByAppendingString:@","] stringByAppendingString:overStr];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)];
        
    }else if (_category == Category_ContinuousShooting) {
//        promptStr = [[[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)] stringByAppendingString:@","] stringByAppendingString:overStr];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)];
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

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_playlistArray != nil && _playlistArray.count > 0) {
        return [_playlistArray count];
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    IMBPhotoEntity *entity = [_playlistArray objectAtIndex:row];
    if ([@"AlbumName" isEqualToString:tableColumn.identifier]) {
        return entity.albumTitle;
    }
    return @"";
}

#pragma mark - NSTableViewdelegate

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([@"AlbumName" isEqualToString:tableColumn.identifier]) {
        IMBPhotoEntity *entity = [_playlistArray objectAtIndex:row];
        IMBImageAndTextCell *cell1 = (IMBImageAndTextCell *)cell;
        cell1.imageSize = NSMakeSize(16, 16);
        cell1.marginX = 20;
        cell1.paddingX = 0;
        if (_category == Category_ContinuousShooting) {
            cell1.image = [StringHelper imageNamed:@"burst_icon"];
            cell1.imageName = @"burst_icon";
        }else
        {
            if (entity.albumKind == 2) {
                cell1.image = [StringHelper imageNamed:@"device_album"];
                cell1.imageName = @"device_album";
            } else if (entity.albumKind == 1505) {
                cell1.image = [StringHelper imageNamed:@"album_sync"];
                cell1.imageName = @"album_sync";
            }else if (entity.albumKind == -70) {
                cell1.image = [StringHelper imageNamed:@"livePhoto"];
                cell1.imageName = @"livePhoto";
            }else if (entity.albumKind == -80) {
                cell1.image = [StringHelper imageNamed:@"screenshot"];
                cell1.imageName = @"screenshot";
            }else if (entity.albumKind == -90) {
                cell1.image = [StringHelper imageNamed:@"selfies"];
                cell1.imageName = @"selfies";
            }else if (entity.albumKind == -100) {
                cell1.image = [StringHelper imageNamed:@"location"];
                cell1.imageName = @"location";
            }else if (entity.albumKind == -110) {
                cell1.image = [StringHelper imageNamed:@"favorite"];
                cell1.imageName = @"favorite";
            }else {
                cell1.image = [StringHelper imageNamed:@"synchronous"];
                cell1.imageName = @"synchronous";
            }// || entity.albumKind == -80 || entity.albumKind == -90 || entity.albumKind == -100 || entity.albumKind == -110
        }
        
    }
}

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    
    return NO;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = [_albumTableView selectedRow];
    if (row == -1) {
        [_delegate loadMyAlbumButton:CreateAlbum withIsViewDisplay:_currentSelectView withViewController:self];
        return;
    }
    [_searchFieldBtn setStringValue:@""];
    _isSearch = NO;
    IMBPhotoEntity *entity = nil;
    
    _curIndex = (int)row;
    entity = [_playlistArray objectAtIndex:row];
    _selectedType = entity.albumType;
    //        if (_category == Category_MyAlbums) {
    [_delegate loadMyAlbumButton:_selectedType withIsViewDisplay:_currentSelectView withViewController:self];
    //        }
    
    if (_currentSelectView == 0) {
        IMBBaseViewController *controller = [_contentDic objectForKey:[NSString stringWithFormat:@"List-%d",entity?entity.albumZpk:-5]];
        if (controller != nil) {
            [controller reloadTableView];
            [_boxContent setContentView:controller.view];
            if (_currentContorller != nil) {
                [_currentContorller release];
                _currentContorller = nil;
            }
            _currentContorller = [controller retain];
        }else {
            controller = [[IMBPhotosListViewController alloc] initWithiPod:_ipod withCategoryNodesEnum:_category withDelegate:_delegate withPhotoEntity:entity];
            [_boxContent setContentView:controller.view];
            if (_currentContorller != nil) {
                [_currentContorller release];
                _currentContorller = nil;
            }
            _currentContorller = [controller retain];
            if (entity != nil) {
                [_contentDic setObject:controller forKey:[NSString stringWithFormat:@"List-%d",entity.albumZpk]];
            }else {
                [_contentDic setObject:controller forKey:[NSString stringWithFormat:@"List-%d",-5]];
            }
            [controller release];
        }
    }else {
        IMBBaseViewController *controller = [_contentDic objectForKey:[NSString stringWithFormat:@"View-%d",entity?entity.albumZpk:-5]];
        if (controller != nil) {
            [controller reloadTableView];
            [_boxContent setContentView:controller.view];
            if (_currentContorller != nil) {
                [_currentContorller release];
                _currentContorller = nil;
            }
            _currentContorller = [controller retain];
        }else {
            controller = [[IMBPhotosCollectionViewController alloc] initWithiPod:_ipod withCategoryNodesEnum:_category withDelegate:_delegate withPhotoEntity:entity];
            
            [_boxContent setContentView:controller.view];
            if (_currentContorller != nil) {
                [_currentContorller release];
                _currentContorller = nil;
            }
            _currentContorller = [controller retain];
            if (entity != nil) {
                [_contentDic setObject:controller forKey:[NSString stringWithFormat:@"View-%d",entity.albumZpk]];
            }else {
                [_contentDic setObject:controller forKey:[NSString stringWithFormat:@"View-%d",-5]];
            }
            
            [controller release];
        }
    }
    
    _currentEntity = entity;
    
}

- (void)tableView:(NSTableView *)tableView rightDownrow:(NSInteger)index {
    if (tableView == _albumTableView) {
        IMBPhotoEntity *entity = [_playlistArray objectAtIndex:index];
        if (entity.albumType == SyncAlbum) {
            [_renameMenuItem setHidden:NO];
            [_deleteItem setHidden:NO];
        }else {
            [_renameMenuItem setHidden:YES];
            [_deleteItem setHidden:YES];
        }
        [_albumTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
    }
}

- (IBAction)addAlbumBtn:(id)sender {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    NSString *string = CustomLocalizedString(@"PhotoView_id_3", nil);
    NSInteger result = [alerView showTitleName:string InputTextFiledString:@"" OkButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
    if (result == 1) {
        //进行操作
        IMBPhotoEntity *entity = [[IMBPhotoEntity alloc] init];
        entity.albumZpk = -4;
        entity.albumKind = 1550;
        entity.albumTitle = [alerView.reNameInputTextField stringValue];
        entity.albumType = SyncAlbum;
        [_playlistArray addObject:entity];
        [entity release];
        [_albumTableView reloadData];
        [_albumTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:_playlistArray.count - 1] byExtendingSelection:NO];
        [alerView unloadAlertView:alerView.reNameView];
    }
}

-(void)deleteBackupSelectedItems:(id)sender {
    
    if (_isDeletePlaylist) {
        int row = (int)[_albumTableView selectedRow];
        if (row == -1) {
            return;
        }
        IMBPhotoEntity *entity = [[_playlistArray objectAtIndex:row] retain];
        if (entity.albumZpk == -4) {
            [_playlistArray removeObject:entity];
            [_albumTableView reloadData];
            if (_playlistArray.count > 0) {
                [_albumTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
            }
            [_contentDic removeObjectForKey:[NSString stringWithFormat:@"View-%d",entity.albumZpk]];
            [_contentDic removeObjectForKey:[NSString stringWithFormat:@"List-%d",entity.albumZpk]];
        }else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSMutableArray *delArray = [[NSMutableArray alloc] init];
                IMBTrack *track = [[IMBTrack alloc] init];
                track.albumZpk = entity.albumZpk;
                [track setMediaType:Photo];
                [delArray addObject:track];
                [track release];
                IMBDeleteTrack *procedure = [[IMBDeleteTrack alloc] initWithIPod:_ipod deleteArray:delArray Category:_category];
                [procedure setDelegate:self];
                [procedure startDelete];
                IMBInformationManager *manager = [IMBInformationManager shareInstance];
                IMBInformation *information = [manager.informationDic objectForKey:_ipod.deviceHandle.udid];
//                if (_category == Category_MyAlbums) {
//                    [information refreshMyAlbum];
//                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (_category == Category_MyAlbums) {
                        if (_playlistArray != nil) {
                            [_playlistArray release];
                            _playlistArray = nil;
                        }
                        _playlistArray = [[information myAlbumsArray] retain];
                    }
                    [_albumTableView reloadData];
                    [_contentDic removeObjectForKey:[NSString stringWithFormat:@"View-%d",entity.albumZpk]];
                    [_contentDic removeObjectForKey:[NSString stringWithFormat:@"List-%d",entity.albumZpk]];
                    if (_playlistArray.count > 0) {
                        [_albumTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                        [self tableViewSelectionDidChange:nil];
                    }
                    _isDeletePlaylist = NO;
                    [delArray release];
                    [procedure release];
//                    [self reload:nil];
                });
            });
        }
        [entity release];
    }else{
        if (_delArray != nil) {
            [_delArray release];
            _delArray = nil;
        }
        IMBBaseViewController *controller = nil;
        if (_currentSelectView == 0) {
            controller = [_contentDic objectForKey:[NSString stringWithFormat:@"List-%d", _currentEntity.albumZpk]];
        }else{
            controller = [_contentDic objectForKey:[NSString stringWithFormat:@"View-%d",_currentEntity.albumZpk]];
        }
        _delArray = [[NSMutableArray alloc]init];
        [_alertViewController._removeprogressAnimationView setProgress:0];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSIndexSet *selectedSet = [self selectedItems];
            NSMutableArray *selectedTracks = [NSMutableArray array];
            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                [selectedTracks addObject:[controller.dataSourceArray objectAtIndex:idx]];
            }];
            if ((_category == Category_MyAlbums && (_selectedType == CreateAlbum || _selectedType == PhotoSelfies || _selectedType == LivePhoto || _selectedType == Screenshot || _selectedType == Location || _selectedType == Favorite)) || _category == Category_ContinuousShooting) {
                if (camera != nil) {
                    [camera release];
                    camera = nil;
                }
                camera = [[IMBDeleteCameraRollPhotos alloc] initWithArray:selectedTracks withIpod:_ipod];

                [_alertViewController._removeprogressAnimationView setProgressWithOutAnimation:96];
                [camera startDeviceBrowser];
                sleep(1);
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [_alertViewController._removeprogressAnimationView setProgressWithOutAnimation:100];
                    [self showRemoveSuccessAlertText:CustomLocalizedString(@"MSG_COM_Delete_Complete", nil) withCount:(int)selectedTracks.count];
                    [self reload:nil];
                });
            }else {
                for (IMBPhotoEntity *entity in selectedTracks) {
                    IMBTrack *track = [[IMBTrack alloc] init];
                    track.photoZpk = entity.photoZpk;
                    [track setMediaType:Photo];
                    [_delArray addObject:track];
                    [track release];
                }
                CategoryNodesEnum category = _category;
                if (_category == Category_MyAlbums) {
                    category = Category_PhotoLibrary;
                }
                IMBDeleteTrack *deleteTrack = [[IMBDeleteTrack alloc] initWithIPod:_ipod deleteArray:_delArray Category:category];
                [deleteTrack setDelegate:self];
                [deleteTrack startDelete];
                [deleteTrack release];
            }
        });
        
    }
}

- (IBAction)deleteAlbum:(id)sender {
    _isDeletePlaylist = YES;
    [self deleteItems:sender];
}

- (void)deleteItems:(id)sender {
    NSIndexSet *selectedSet = [self selectedItems];
    if (!_isDeletePlaylist) {
        if (selectedSet.count <= 0) {
            //弹出警告确认框
            NSString *str = nil;
            int count = _currentEntity.photoCounts;
            if (count == 0) {
                str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_delete", nil),[StringHelper getCategeryStr:_category]];
            }else {
                str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
            }
            [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        }
    }

    NSString *str = nil;
    if (selectedSet.count == 1) {
        str = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete_2", nil);
    }else {
        str = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete", nil);
    }
    [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)];
}

- (IBAction)doRenameAlbum:(id)sender {
    int row = (int)[_albumTableView selectedRow];
    IMBPhotoEntity *entity = [_playlistArray objectAtIndex:row];
    
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    NSString *string = CustomLocalizedString(@"PhotoView_id_3", nil);
    NSInteger result = [alerView showTitleName:string InputTextFiledString:entity.albumTitle OkButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
    if (result == 1) {
        //进行操作
        if (entity.albumZpk == -4) {
            [entity setAlbumTitle:[alerView.reNameInputTextField stringValue]];
            [alerView unloadAlertView:alerView.reNameView];
            [_albumTableView reloadData];
        }else {
            if (entity != nil) {
                NSString *rename = [alerView.reNameInputTextField stringValue];
                IMBAirSyncImportTransfer *sirSync = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:_ipod.uniqueKey Rename:rename AlbumEntity:entity];
                [alerView.renameLoadingView setHidden:NO];
                [alerView.renameLoadingView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
                [alerView.renameLoadingView setImage:[StringHelper imageNamed:@"registedLoading"]];
                [alerView.renameLoadingView.layer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:-2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [sirSync renameAlbum];
                    if (_category == Category_MyAlbums) {
                        [_information refreshMyAlbum];
                    }
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [alerView unloadAlertView:alerView.reNameView];
                        [alerView.renameLoadingView setHidden:YES];
                        if (_category == Category_MyAlbums) {
                            if (_playlistArray != nil) {
                                [_playlistArray release];
                                _playlistArray = nil;
                            }
                            _playlistArray = [[_information myAlbumsArray] retain];
                        }
                        if (_playlistArray.count > 0) {
                            [_albumTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:_curIndex] byExtendingSelection:NO];
                        }
                        [_albumTableView reloadData];
                    });
                    [sirSync release];
                });
            }
        }
    }
}

- (void)toMac:(id)sender {
    NSIndexSet *sets = [self selectedItems];
    if (sets.count > 0) {
        if (_category == Category_MyAlbums || _category == Category_PhotoShare||_category == Category_ContinuousShooting) {

            IMBPhotoExportSettingConfig *exportSettingConfig = [IMBPhotoExportSettingConfig singleton];
            if (!exportSettingConfig.sureSaveCheckBtnState) {
                [self photoToMac];
            }else{
                NSString *str = CustomLocalizedString(@"Photo_Export_Set_id_14", nil);
                NSView *view = nil;
                for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
                    if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                        view = subView;
                        break;
                    }
                }
                if (view) {
                    [view setHidden:NO];
                    int i = [_alertViewController showDeleteConfrimText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)  CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
                    if (i == 1) {
                        int64_t delayInSeconds = 1;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            [_alertViewController showPhotoAlertSettingSuperView:view withContinue:YES];
                        });
                    }else{
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            exportSettingConfig.sureSaveCheckBtnState = NO;
                            [exportSettingConfig saveData];
                        });
                        [self photoToMac];
                    }
                }
            }
        }
    }else {
        //弹出警告确认框
        NSString *str = nil;
        if (_dataSourceArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_transfer", nil),[StringHelper getCategeryStr:_category]];
        }else {
            str = CustomLocalizedString(@"Export_View_Selected_Tips", nil);
        }
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }
}

- (void)photoToMac{
    [self performSelector:@selector(photoToMacAler) withObject:nil afterDelay:0.1];
}

- (void)photoToMacAler{
    NSIndexSet *selectedSet = [self selectedItems];
    NSViewController *annoyVC = nil;
    long long result = [self checkNeedAnnoy:&(annoyVC)];
    if (result == 0) {
        return;
    }
    IMBPhotoExportSettingConfig *photoExport = [IMBPhotoExportSettingConfig singleton];
    NSString *path = photoExport.exportPath;
    NSString *filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:_category]];
    NSString *stringName = _currentEntity.albumTitle;
    if ([TempHelper stringIsNilOrEmpty:stringName]) {
        stringName = CustomLocalizedString(@"Common_id_10", nil);
    }
    filePath = [TempHelper createCategoryPath:filePath withString:stringName];
    [self copyAlbumToMac:filePath indexSet:(NSIndexSet *)selectedSet Result:(long long)result AnnoyVC:(NSViewController *)annoyVC];
}

- (void)albumtoMacDelay:(NSOpenPanel *)openPanel {
    NSIndexSet *selectedSet = [self selectedItems];
    NSViewController *annoyVC = nil;
    long long result = [self checkNeedAnnoy:&(annoyVC)];
    if (result == 0) {
        return;
    }
    NSString *path = [[openPanel URL] path];
    NSString *filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:_category]];
    NSString *stringName = _currentEntity.albumTitle;
    if ([TempHelper stringIsNilOrEmpty:stringName]) {
        stringName = CustomLocalizedString(@"Common_id_10", nil);
    }
    filePath = [TempHelper createCategoryPath:filePath withString:stringName];
    [self copyAlbumToMac:filePath indexSet:(NSIndexSet *)selectedSet Result:(long long)result AnnoyVC:(NSViewController *)annoyVC];
}

- (void)copyAlbumToMac:(NSString *)filePath indexSet:(NSIndexSet *)set Result:(long long)result AnnoyVC:(NSViewController *)annoyVC  {
    NSIndexSet *selectedSet = set;
    NSMutableArray *selectedPhoto = [NSMutableArray array];
    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSMutableArray *disAry = nil;
        if (_isSearch) {
            disAry = [(IMBBaseViewController *)_currentContorller researchdataSourceArray];
        }else{
            disAry = [(IMBBaseViewController *)_currentContorller dataSourceArray];
        }
        IMBPhotoEntity *photo = [[(IMBBaseViewController *)_currentContorller dataSourceArray] objectAtIndex:idx];
        [selectedPhoto addObject:photo];
    }];
    
    if (_transferController != nil) {
        [_transferController release];
        _transferController = nil;
    }
    _transferController = [[IMBTransferViewController alloc] initWithIPodkey:_ipod.uniqueKey Type:_category SelectItems:selectedPhoto ExportFolder:filePath];
    [_transferController setExportType:1];
    if (result>0) {
        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
    }else {
        [self animationAddTransferView:_transferController.view];
    }
}

- (void)doSwitchView:(id)sender {
    IMBSegmentedBtn *segBtn = (IMBSegmentedBtn *)sender;
    if (segBtn.selectedSegment == 0) {
        IMBBaseViewController *controller = [_contentDic objectForKey:[NSString stringWithFormat:@"List-%d",_currentEntity.albumZpk]];
        [_searchFieldBtn setHidden:NO];
        if (controller != nil) {
            
            [_boxContent setContentView:controller.view];
            [controller setTableViewHeadOrCollectionViewCheck];
            if (_currentContorller != nil) {
                [_currentContorller release];
                _currentContorller = nil;
            }
            _currentContorller = [controller retain];
        }else {
            controller = [[IMBPhotosListViewController alloc] initWithiPod:_ipod withCategoryNodesEnum:_category withDelegate:_delegate withPhotoEntity:_currentEntity];
            [controller setSearchFieldBtn:_searchFieldBtn];
            [_boxContent setContentView:controller.view];
            if (_currentContorller != nil) {
                [_currentContorller release];
                _currentContorller = nil;
            }
            _currentContorller = [controller retain];
            [_contentDic setObject:controller forKey:[NSString stringWithFormat:@"List-%d",_currentEntity.albumZpk]];
            [controller release];
            [controller setTableViewHeadCheckBtn];
        }
        _currentSelectView = 0;
    }else if (segBtn.selectedSegment == 1) {
        IMBBaseViewController *controller = [_contentDic objectForKey:[NSString stringWithFormat:@"View-%d",_currentEntity.albumZpk]];
        if (controller != nil) {
            [_boxContent setContentView:controller.view];
            [controller setSearchFieldBtn:_searchFieldBtn];
            [controller setTableViewHeadOrCollectionViewCheck];
            if (_currentContorller != nil) {
                [_currentContorller release];
                _currentContorller = nil;
            }
            _currentContorller = [controller retain];
        }else {
            controller = [[IMBPhotosCollectionViewController alloc] initWithiPod:_ipod withCategoryNodesEnum:_category withDelegate:_delegate withPhotoEntity:_currentEntity];
            [_boxContent setContentView:controller.view];
            [controller setTableViewHeadOrCollectionViewCheck];
            if (_currentContorller != nil) {
                [_currentContorller release];
                _currentContorller = nil;
            }
            _currentContorller = [controller retain];
            [_contentDic setObject:controller forKey:[NSString stringWithFormat:@"View-%d",_currentEntity.albumZpk]];
            [controller release];
        }
        _currentSelectView = 1;
    }
}

- (NSIndexSet *)selectedItems {
    return [(IMBBaseViewController *)_currentContorller selectedItems];
}

- (void)deviceToiCloud:(id)sender{
    NSViewController *annoyVC = nil;
    long long result = [self checkNeedAnnoy:&(annoyVC)];
    if (result == 0) {
        return;
    }
    NSPredicate *cate = [NSPredicate predicateWithFormat:@"self.checkState == %d",Check];
    NSArray *selectedArray = [[(IMBBaseViewController *)_currentContorller dataSourceArray] filteredArrayUsingPredicate:cate];
    if (_transferController != nil) {
        [_transferController release];
        _transferController = nil;
    }
    _transferController = [[IMBTransferViewController alloc] initWithIPodkey:_ipod.uniqueKey Type:_category SelectItems:(NSMutableArray *)selectedArray iCloudManager:_iCloudManager];
    if (result>0) {
        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
    }else{
        [self animationAddTransferView:_transferController.view];
    }
}



- (NSMutableArray *)getSelectedItemsArray:(NSIndexSet *)sets {
    NSMutableArray *itemsArray = [NSMutableArray array];
    [sets enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
//        if (_isSearch) {
//            [itemsArray addObject:[[(IMBBaseViewController *)_currentContorller researchdataSourceArray] objectAtIndex:idx]];
//        }
//        else{
            [itemsArray addObject:[[(IMBBaseViewController *)_currentContorller dataSourceArray] objectAtIndex:idx]];
//        }
    }];
    return itemsArray;
}

#pragma mark reload
- (void)reload:(id)sender {
    //    [_seachField setStringValue:@""];
    [self disableFunctionBtn:NO];
    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (_category == Category_MyAlbums) {
            [_information refreshMyAlbum];
        }else if (_category == Category_PhotoShare) {
            [_information refreshPhotoShare];
        }else if (_category == Category_ContinuousShooting)
        {
            [_information refreshcontinuousShootings];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self disableFunctionBtn:YES];
            [self refresh];
        });
    });
}

- (void)refresh {
    if (_category == Category_MyAlbums) {
        if (_playlistArray != nil) {
            [_playlistArray release];
            _playlistArray = nil;
        }
        _playlistArray = [[_information myAlbumsArray] retain];
    }else if (_category == Category_PhotoShare) {
        if (_playlistArray != nil) {
            [_playlistArray release];
            _playlistArray = nil;
        }
        _playlistArray = [[_information photoshareArray] retain];
    }else if (_category == Category_ContinuousShooting) {
        if (_playlistArray != nil) {
            [_playlistArray release];
            _playlistArray = nil;
        }
        _playlistArray = [[_information continuousShootingArray] retain];
    }
    if (_playlistArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_mainBox setContentView:_containTableView];
    }
    [_loadingAnimationView endAnimation];
    [_contentDic removeAllObjects];
    if (_playlistArray.count > 0) {
        [_albumTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:_curIndex] byExtendingSelection:NO];
    }
    [_albumTableView reloadData];
    [self tableViewSelectionDidChange:nil];
    if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
        [_delegate refeashBadgeConut:(int)_playlistArray.count WithCategory:_category];
    }
}

- (void)changeAlbumsLanguage:(NSNotification *)notification {
    //    [_renameMenuItem setTitle:CustomLocalizedString(@"Common_id_8", nil)];
    //    [_albumTextField setStringValue:CustomLocalizedString(@"ListView_id_9", nil)];
    //    if ([_countDelegate respondsToSelector:@selector(reCaulateItemCount)]) {
    //
    //        [_countDelegate reCaulateItemCount];
    //    }
}

- (void)mutilBurstToMac {
    /*    int remainCount = [IMBHelper openRegisterWindowAndGetCountByType:IMBTransfer_Before];
     if (remainCount == 0) {
     return;
     }
     NSOpenPanel *openPanel = [IMBOpenPanel openPanel];
     [openPanel setCanChooseDirectories:YES];
     [openPanel setCanChooseFiles:NO];
     [openPanel setAllowsMultipleSelection:NO];
     [openPanel setDirectory:_ipod.exportSetting.exportPath];
     NSInteger isOK = [openPanel runModal];
     if (isOK == NSFileHandlingPanelOKButton)
     {
     NSString *path = [[openPanel URL] path];
     NSIndexSet *set = [_albumTableView selectedRowIndexes];
     NSMutableArray *selectedArray = [NSMutableArray array];
     [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
     [selectedArray addObject:[_albumArray objectAtIndex:idx]];
     }];
     NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_ipod,@"IMBIPod",path,@"filePath",selectedArray,@"MutilBurst", nil];
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BurstMutil_ToMac object:nil userInfo:dic];
     }*/
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    [(IMBBaseViewController *)_currentContorller doSearchBtn:searchStr withSearchBtn:searchBtn];
    _isSearch = YES;
}

- (void)reloadTableView{
    _isSearch = NO;
    [_albumTableView reloadData];
    if (_playlistArray.count > 0) {
        [(IMBBaseViewController *)_currentContorller reloadTableView];
    }
}


@end
