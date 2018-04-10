//
//  IMBiCloudPhotoVideoViewController.m
//  AnyTrans
//
//  Created by long on 2/28/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBiCloudPhotoVideoViewController.h"
#import "IMBImageAndTextCell.h"
#import "IMBSegmentedBtn.h"
#import "IMBPhotosListViewController.h"
#import "IMBPhotosCollectionViewController.h"
#import "IMBAnimation.h"
@interface IMBiCloudPhotoVideoViewController ()

@end

@implementation IMBiCloudPhotoVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkFaultInterrupt) name:NOTITY_NETWORK_FAULT_INTERRUPT object:nil];
    _contentDic = [[NSMutableDictionary alloc] init];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    if (_category == Category_PhotoVideo) {
        [_noDataImage setImage:[StringHelper imageNamed:@"noData_video"]];
        _dataSourceArray = [_iCloudManager.photoVideoAlbumArray retain];
        [_nodataLable setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_24", nil)]];
    }else if (_category  == Category_Photo){
        [_noDataImage setImage:[StringHelper imageNamed:@"noData_photo"]];
        _dataSourceArray = [_iCloudManager.albumArray retain];
        [_nodataLable setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"DeviceView_id_6", nil)]];
    }else if (_category == Category_MyAlbums){
        _dataSourceArray = [_iCloudManager.albumArray retain];
    }
    if (_dataSourceArray.count == 0) {
        [_rootBox setContentView:_noDataView];
        [_nodataLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    }else {
        [_rootBox setContentView:_dataView];
    }
    _currentSelectView = 1;
    [_leftTableView setDelegate:self];
    [_leftTableView setDataSource:self];
    [_leftTableView setListener:self];
    [_scrollView setHastopBorder:NO leftBorder:NO BottomBorder:NO rightBorder:NO];
    
    if (_category == Category_Photo) {
        NSString *addStr = CustomLocalizedString(@"Button_id_2", nil);
        NSRect rect = [StringHelper calcuTextBounds:addStr fontSize:14];
        float w = 110;
        if (rect.size.width > 80) {
            w = rect.size.width + 30;
        }
        [_addAlbumBtn setFrame:NSMakeRect((_leftRootView.frame.size.width - w)/2, _addAlbumBtn.frame.origin.y, w, _addAlbumBtn.frame.size.height)];
        
        [_addAlbumBtn mouseDownImage:[StringHelper imageNamed:@"add_item3"] withMouseUpImg:[StringHelper imageNamed:@"add_item1"]  withMouseExitedImg:[StringHelper imageNamed:@"add_item1"]  mouseEnterImg:[StringHelper imageNamed:@"add_item2"]  withButtonName:addStr];
    }else{
        [_deleteMenuItem setHidden:YES];
        [_refreshMenuItem setHidden:YES];
        [_addAlbumBtn setHidden:YES];
    }
}

- (void)repToolBarView:(IMBToolBarView *)toolBar{
    _toolBar = toolBar;
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
        return [_dataSourceArray count];
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (_dataSourceArray.count <= row) {
        return @"";
    }
    IMBToiCloudPhotoEntity *entity = [_dataSourceArray objectAtIndex:row];
    if ([@"AlbumName" isEqualToString:tableColumn.identifier]) {
        return entity.albumTitle;
    }else if ([@"count" isEqualToString:tableColumn.identifier]) {
        if (entity.photoCounts == 0) {
            return @"--";
        }else {
            return [NSString stringWithFormat:@"%d",entity.photoCounts];
        }
        
    }
    return @"";
}
#pragma mark - NSTableViewdelegate

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([@"AlbumName" isEqualToString:tableColumn.identifier]) {
        IMBToiCloudPhotoEntity *entity = [_dataSourceArray objectAtIndex:row];
        IMBImageAndTextCell *cell1 = (IMBImageAndTextCell *)cell;
        cell1.imageSize = NSMakeSize(16, 16);
        cell1.marginX = 20;
        cell1.paddingX = 0;
        if (_category == Category_PhotoVideo) {
            if ([entity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Video"]) {
                cell1.image = [StringHelper imageNamed:@"photoviedo_allvideo"];
                cell1.imageName = @"photoviedo_allvideo";
            }else if ([entity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Timelapse"]){
                cell1.image = [StringHelper imageNamed:@"photoviedo_timelampes"];
                cell1.imageName = @"photoviedo_timelampes";
            }else if ([entity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Slomo"]){
                cell1.image = [StringHelper imageNamed:@"photoviedo_slomo"];
                cell1.imageName = @"photoviedo_slomo";
            }
        }else if (_category == Category_Photo){
            if ([entity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Favorite"]) {
                cell1.image = [StringHelper imageNamed:@"favorite"];
                cell1.imageName = @"favorite";
            }else if ([entity.clientId isEqualToString:@"CPLAssetByAddedDate"]){
                cell1.image = [StringHelper imageNamed:@"photos_allphoto"];
                cell1.imageName = @"photos_allphoto";
            }else if ([entity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Panorama"]){
                cell1.image = [StringHelper imageNamed:@"photoviedo_slomo"];
                cell1.imageName = @"photoviedo_slomo";
            }else if ([entity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Screenshot"]){
                cell1.image = [StringHelper imageNamed:@"screenshot"];
                cell1.imageName = @"screenshot";
            }else{
                cell1.image = [StringHelper imageNamed:@"device_album"];
                cell1.imageName = @"device_album";
            }
        }
        //连拍图标 bursts1
    }else if ([@"count" isEqualToString:tableColumn.identifier]){
        IMBCenterTextFieldCell *cell1 = (IMBCenterTextFieldCell *)cell;
//        cell1.isLastCell = YES;
        cell1.isRighVale = YES;
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = [_leftTableView selectedRow];
    if (row == -1) {
        return;
    }
    [_searchFieldBtn setStringValue:@""];
    _isSearch = NO;
    IMBToiCloudPhotoEntity *entity = nil;

    entity = [_dataSourceArray objectAtIndex:row];
    if (_currentEntity != nil) {
        [_currentEntity release];
        _currentEntity = nil;
    }
    _currentEntity = [entity retain];
    if (_category == Category_Photo) {
        if ([entity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Favorite"]) {
            [_toolBar loadiCloudButtons:[NSArray arrayWithObjects:@(0),@(7),@(2),@(18),@(22),@(12),@(13), nil] Target:self DisplayMode:_currentSelectView];
        }else if ([entity.clientId isEqualToString:@"CPLAssetByAddedDate"]){
            [_toolBar loadiCloudButtons:[NSArray arrayWithObjects:@(0),@(7),@(17),@(2),@(18),@(22),@(12),@(13), nil] Target:self DisplayMode:_currentSelectView];
        }else if ([entity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Panorama"]){
            [_toolBar loadiCloudButtons:[NSArray arrayWithObjects:@(0),@(7),@(2),@(18),@(22),@(12),@(13), nil] Target:self DisplayMode:_currentSelectView];
        }else if ([entity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Screenshot"]){
            [_toolBar loadiCloudButtons:[NSArray arrayWithObjects:@(0),@(7),@(2),@(18),@(22),@(12),@(13), nil] Target:self DisplayMode:_currentSelectView];
        }else{
            [_toolBar loadiCloudButtons:[NSArray arrayWithObjects:@(0),@(7),@(17),@(2),@(18),@(22),@(12),@(13), nil] Target:self DisplayMode:_currentSelectView];
        }

    }
    
    IMBBaseViewController *listController = [_contentDic objectForKey:[NSString stringWithFormat:@"List-%@",entity.clientId]];
    IMBBaseViewController *viewController = [_contentDic objectForKey:[NSString stringWithFormat:@"View-%@",entity.clientId]];
    if (entity.isloading) {
        [_toolBar toolBarButtonIsEnabled:NO];
    }
    if (listController == nil && viewController == nil) {
        if (!entity.isloading) {
            [_loadingAnimationView endAnimation];
            [_rightBox setContentView:_loadingView];
            [_loadingAnimationView startAnimation];
            [_toolBar toolBarButtonIsEnabled:NO];
            [_toolBar icloudPhotoEnabledReload:NO];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                entity.isloading = YES;
                [_iCloudManager getPhotoDetail:entity];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [_loadingAnimationView endAnimation];
                     IMBBaseViewController *controller = nil;
                    if (_currentSelectView == 0) {
                        controller = [[IMBPhotosListViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:_delegate withiCloudView:YES withCategory:_category withiCloudPhotoEntity:entity];
                        [(IMBPhotosListViewController*)controller setIcloudPhotoDelegate:self];
                        if (entity.clientId == _currentEntity.clientId) {
                            [_toolBar toolBarButtonIsEnabled:YES];
                            [_rightBox setContentView:controller.view];
                        }
                        //                    [_rightBox setContentView:controller.view];
                        if (_currentContorller != nil) {
                            [_currentContorller release];
                            _currentContorller = nil;
                        }
                        _currentContorller = [controller retain];
                        [_contentDic setObject:controller forKey:[NSString stringWithFormat:@"List-%@",entity.clientId]];
                        
                        [controller release];

                    }else{
                        controller = [[IMBPhotosCollectionViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:_delegate withiCloudView:YES withCategory:_category withiCloudPhotoEntity:entity];
                        [(IMBPhotosCollectionViewController*)controller setIcloudPhotoDelegate:self];
                        if (entity.clientId == _currentEntity.clientId) {
                            [_toolBar toolBarButtonIsEnabled:YES];
                            [_rightBox setContentView:controller.view];
                        }
                        if (_currentContorller != nil) {
                            [_currentContorller release];
                            _currentContorller = nil;
                        }
                        _currentContorller = [controller retain];
                        if (entity != nil) {
                            [_contentDic setObject:controller forKey:[NSString stringWithFormat:@"View-%@",entity.clientId]];
                        }
                        [controller release];
                    }
                    entity.isloading = NO;
                    int i = 0;
                    for (IMBToiCloudPhotoEntity *entity in _dataSourceArray) {
                        if (entity.isloading) {
                            i++;
                        }
                    }
                    if (i == 0) {
                        [_toolBar icloudPhotoEnabledReload:YES];
                    }else{
                        [_toolBar icloudPhotoEnabledReload:NO];
                    }
                });
            });
        } else {
            if (!entity.isloading) {
                [_loadingAnimationView endAnimation];
                [_toolBar toolBarButtonIsEnabled:YES];
                int i = 0;
                for (IMBToiCloudPhotoEntity *entity in _dataSourceArray) {
                    if (entity.isloading) {
                        i++;
                    }
                }
                if (i == 0) {
                    [_toolBar icloudPhotoEnabledReload:YES];
                }else{
                    [_toolBar icloudPhotoEnabledReload:NO];
                }
                if (_currentSelectView == 0) {
                    [_rightBox setContentView:listController.view];
                    if (_currentContorller != nil) {
                        [_currentContorller release];
                        _currentContorller = nil;
                    }
                    _currentContorller = [listController retain];
                }else if (_currentSelectView == 1){
                    [_rightBox setContentView:viewController.view];
                    if (_currentContorller != nil) {
                        [_currentContorller release];
                        _currentContorller = nil;
                    }
                    _currentContorller = [viewController retain];
                }
            }else{
                [_toolBar toolBarButtonIsEnabled:NO];
                int i = 0;
                for (IMBToiCloudPhotoEntity *entity in _dataSourceArray) {
                    if (entity.isloading) {
                        i++;
                    }
                }
                if (i == 0) {
                    [_toolBar icloudPhotoEnabledReload:YES];
                }else{
                    [_toolBar icloudPhotoEnabledReload:NO];
                }
                [_rightBox setContentView:_loadingView];
                [_loadingAnimationView startAnimation];
            }
        }
    }else {
        [_toolBar toolBarButtonIsEnabled:YES];
        int i = 0;
        for (IMBToiCloudPhotoEntity *entity in _dataSourceArray) {
            if (entity.isloading) {
                i++;
            }
        }
        if (i == 0) {
            [_toolBar icloudPhotoEnabledReload:YES];
        }else{
            [_toolBar icloudPhotoEnabledReload:NO];
        }
        IMBBaseViewController *controller = nil;
        if (_currentSelectView == 0) {
        
            if (listController == nil&&viewController != nil) {
                
                controller = [[IMBPhotosListViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:_delegate withiCloudView:YES withCategory:_category withiCloudPhotoEntity:entity];
                [(IMBPhotosListViewController*)controller setIcloudPhotoDelegate:self];
                if (entity.clientId == _currentEntity.clientId) {
                    [_rightBox setContentView:controller.view];
                }
                //                    [_rightBox setContentView:controller.view];
                if (_currentContorller != nil) {
                    [_currentContorller release];
                    _currentContorller = nil;
                }
                _currentContorller = [controller retain];
                [_contentDic setObject:controller forKey:[NSString stringWithFormat:@"List-%@",entity.clientId]];
                [controller release];

            }else{
                [_rightBox setContentView:listController.view];
                [listController setTableViewHeadOrCollectionViewCheck];
                if (_currentContorller != nil) {
                    [_currentContorller release];
                    _currentContorller = nil;
                }
                _currentContorller = [listController retain];
            }
        }else{
            if (listController != nil && viewController == nil) {
                controller = [[IMBPhotosCollectionViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:_delegate withiCloudView:YES withCategory:_category withiCloudPhotoEntity:entity];
                [(IMBPhotosCollectionViewController*)controller setIcloudPhotoDelegate:self];
                if (entity.clientId == _currentEntity.clientId) {
                    [_rightBox setContentView:controller.view];
                }
                if (_currentContorller != nil) {
                    [_currentContorller release];
                    _currentContorller = nil;
                }
                _currentContorller = [controller retain];
                if (entity != nil) {
                    [_contentDic setObject:controller forKey:[NSString stringWithFormat:@"View-%@",entity.clientId]];
                }
                [controller release];
            }else{
                [_rightBox setContentView:viewController.view];
//                [viewController setTableViewHeadOrCollectionViewCheck];
                if (_currentContorller != nil) {
                    [_currentContorller release];
                    _currentContorller = nil;
                }
                _currentContorller = [viewController retain];

            }
        }
    }
    
    
    
//    if (_currentSelectView == 0) {
//        IMBBaseViewController *controller = [_contentDic objectForKey:[NSString stringWithFormat:@"List-%@",entity.clientId]];
//        if (controller != nil) {
//            [_rightBox setContentView:controller.view];
//            if (_currentContorller != nil) {
//                [_currentContorller release];
//                _currentContorller = nil;
//            }
//            _currentContorller = [controller retain];
//        }else {
//            [_rightBox setContentView:_loadingView];
//            [_loadingAnimationView startAnimation];
//            [_toolBar toolBarButtonIsEnabled:NO];
//
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                [_iCloudManager getPhotoDetail:entity];
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    [_toolBar toolBarButtonIsEnabled:YES];
//                    [_loadingAnimationView endAnimation];
//                    IMBBaseViewController *controller = nil;
//                    controller = [[IMBPhotosListViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:_delegate withiCloudView:YES withCategory:_category withiCloudPhotoEntity:entity];
//                    [(IMBPhotosListViewController*)controller setIcloudPhotoDelegate:self];
//                    if (entity.clientId == _currentEntity.clientId) {
//                        [_rightBox setContentView:controller.view];
//                    }
////                    [_rightBox setContentView:controller.view];
//                    if (_currentContorller != nil) {
//                        [_currentContorller release];
//                        _currentContorller = nil;
//                    }
//                    _currentContorller = [controller retain];
//                    [_contentDic setObject:controller forKey:[NSString stringWithFormat:@"List-%@",entity.clientId]];
//                    
//                    [controller release];
//                });
//            });
//        }
//    }else {
//        IMBBaseViewController *controller = [_contentDic objectForKey:[NSString stringWithFormat:@"View-%@",entity.clientId]];
//        if (controller != nil) {
//            [_rightBox setContentView:controller.view];
//            if (_currentContorller != nil) {
//                [_currentContorller release];
//                _currentContorller = nil;
//            }
//            _currentContorller = [controller retain];
//        }else {
//            [_rightBox setContentView:_loadingView];
//            [_loadingAnimationView startAnimation];
//            [_toolBar toolBarButtonIsEnabled:NO];
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                [_iCloudManager getPhotoDetail:entity];
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    IMBBaseViewController *controller = nil;
//                    [_toolBar toolBarButtonIsEnabled:YES];
//                    controller = [[IMBPhotosCollectionViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:_delegate withiCloudView:YES withCategory:_category withiCloudPhotoEntity:entity];
//                     [(IMBPhotosCollectionViewController*)controller setIcloudPhotoDelegate:self];
//                    if (entity.clientId == _currentEntity.clientId) {
//                        [_rightBox setContentView:controller.view];
//                    }
//                    if (_currentContorller != nil) {
//                        [_currentContorller release];
//                        _currentContorller = nil;
//                    }
//                    _currentContorller = [controller retain];
//                    if (entity != nil) {
//                        [_contentDic setObject:controller forKey:[NSString stringWithFormat:@"View-%@",entity.clientId]];
//                    }
//                    [controller release];
//                });
//            });
//        }
//    }
//    if (_currentEntity != nil) {
//        [_currentEntity release];
//        _currentEntity = nil;
//    }
//    _currentEntity = [entity retain];

}

- (void)doSwitchView:(id)sender {
    IMBSegmentedBtn *segBtn = (IMBSegmentedBtn *)sender;
    if (segBtn.selectedSegment == 0) {
        IMBBaseViewController *controller = [_contentDic objectForKey:[NSString stringWithFormat:@"List-%@",_currentEntity.clientId]];
        [_searchFieldBtn setHidden:NO];
        if (controller != nil) {
            [_rightBox setContentView:controller.view];
            [controller setTableViewHeadOrCollectionViewCheck];
            if (_currentContorller != nil) {
                [_currentContorller release];
                _currentContorller = nil;
            }
            _currentContorller = [controller retain];
        }else {
            controller = [[IMBPhotosListViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:_delegate withiCloudView:YES withCategory:_category withiCloudPhotoEntity:_currentEntity];
            [(IMBPhotosListViewController*)controller setIcloudPhotoDelegate:self];
            [controller setSearchFieldBtn:_searchFieldBtn];
            [_rightBox setContentView:controller.view];
            if (_currentContorller != nil) {
                [_currentContorller release];
                _currentContorller = nil;
            }
            _currentContorller = [controller retain];
            [_contentDic setObject:controller forKey:[NSString stringWithFormat:@"List-%@",_currentEntity.clientId]];
            [controller release];
        }
        _currentSelectView = 0;
    }else if (segBtn.selectedSegment == 1) {
        IMBBaseViewController *controller = [_contentDic objectForKey:[NSString stringWithFormat:@"View-%@",_currentEntity.clientId]];
        if (controller != nil) {
            [_rightBox setContentView:controller.view];
            [controller setTableViewHeadOrCollectionViewCheck];
            if (_currentContorller != nil) {
                [_currentContorller release];
                _currentContorller = nil;
            }
            _currentContorller = [controller retain];
        }else {
             controller = [[IMBPhotosCollectionViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:_delegate withiCloudView:YES withCategory:_category withiCloudPhotoEntity:_currentEntity];
            [(IMBPhotosCollectionViewController*)controller setIcloudPhotoDelegate:self];
            [_rightBox setContentView:controller.view];
            [controller setTableViewHeadOrCollectionViewCheck];
            if (_currentContorller != nil) {
                [_currentContorller release];
                _currentContorller = nil;
            }
            _currentContorller = [controller retain];
            [_contentDic setObject:controller forKey:[NSString stringWithFormat:@"View-%@",_currentEntity.clientId]];
            [controller release];
        }
        _currentSelectView = 1;
    }
}

#pragma mark - iCloudOperationActions
- (void)iCloudReload:(id)sender {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Refresh" label:Start transferCount:0 screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_rootBox setContentView:_loadingView];
        [_loadingAnimationView startAnimation];
        [_toolBar toolBarButtonIsEnabled:NO];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_iCloudManager getPhotosContent];
        if (_dataSourceArray != nil) {
            [_dataSourceArray release];
            _dataSourceArray = nil;
        }
        if (_category == Category_PhotoVideo) {
            _dataSourceArray = [_iCloudManager.photoVideoAlbumArray retain];
        }else if (_category == Category_Photo){
             _dataSourceArray = [_iCloudManager.albumArray retain];
        }else if (_category == Category_ContinuousShooting){
            _dataSourceArray = [_iCloudManager.albumArray retain];
        }
        if (_currentEntity != nil) {
            BOOL isCur = NO;
            for (IMBToiCloudPhotoEntity *entity in _dataSourceArray) {
                if ([entity.clientId isEqualToString:_currentEntity.clientId]) {
                    isCur = YES;
                    [_currentEntity release];
                    _currentEntity = [entity retain];
                    [_iCloudManager getPhotoDetail:_currentEntity];
                    break;
                }
            }
            if (!isCur) {
                [_currentEntity release];
                _currentEntity = nil;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_toolBar toolBarButtonIsEnabled:YES];
            [_loadingAnimationView endAnimation];
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Refresh" label:Finish transferCount:0 screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            if (_dataSourceArray.count == 0) {
                [_rootBox setContentView:_noDataView];
//                [self configNoDataView];
            }else {
                [_rootBox setContentView:_dataView];
                IMBBaseViewController *controller = nil;
                if (_currentSelectView == 0) {
                    if (_currentEntity != nil) {
                        controller = [_contentDic objectForKey:[NSString stringWithFormat:@"List-%@",_currentEntity.clientId]];
                    }
                }else if (_currentSelectView == 1){
                    if (_currentEntity != nil) {
                        controller = [_contentDic objectForKey:[NSString stringWithFormat:@"View-%@",_currentEntity.clientId]];
                    }
                }
                if (controller != nil) {
                    [_rightBox setContentView:controller.view];
                }
            }
            if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                if (_category == Category_Photo) {
                    [_delegate refeashBadgeConut:_iCloudManager.photoCount WithCategory:_category];
                }else if (_category == Category_PhotoVideo) {
                    [_delegate refeashBadgeConut:_iCloudManager.photoVideoCount WithCategory:_category];
                }else if (_category == Category_ContinuousShooting) {
                    
                }
            }
//            [_arrayController addObjects:_dataSourceArray];
//            [self loadCollectionView:NO];
            [_leftTableView reloadData];
            if (_contentDic != nil) {
                [_contentDic release];
                _contentDic = nil;
            }
            _contentDic = [[NSMutableDictionary alloc]init];
            [self tableViewSelectionDidChange:nil];
        });
    });
}

- (void)iCloudAllViewReload:(id)sender {
    [_contentDic removeObjectForKey: [NSString stringWithFormat:@"View-%@",_photoEntity.clientId]];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        _photoEntity.isloading = YES;
//        [_iCloudManager getPhotoDetail:_photoEntity];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _photoEntity.isloading = NO;
//            _photoEntity.photoCounts = _photoEntity.subArray.count;
//            [_leftTableView reloadData];
////            [self tableViewSelectionDidChange:nil];
//        });
//    });
}

- (void)dropIcloudToCollectionView:(NSCollectionView *)collectionView paths:(NSMutableArray *)pathArray {
   

    if (_transferController != nil) {
        [_transferController release];
        _transferController = nil;
    }
    _transferController = [[IMBTransferViewController alloc] initWithType:_category withDelegate:self withTransfertype:TransferUpLoading];
    [_transferController setDelegate:self];
    _transferController.isicloudView = YES;
    [self animationAddTransferView:_transferController.view];
    if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
        NSString *string = @"";
        if (_category == Category_Photo) {
            string = CustomLocalizedString(@"MenuItem_id_9", nil);
        }else if (_category == Category_PhotoVideo){
            string = CustomLocalizedString(@"MenuItem_id_24", nil);
        }else if (_category == Category_ContinuousShooting){
            string = CustomLocalizedString(@"MenuItem_id_47", nil);
        }
        [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),string]];
    }
    
    NSString *msgStr = CustomLocalizedString(@"ImportSync_id_1", nil);
    if ([_transferController respondsToSelector:@selector(transferFile:)]) {
        [_transferController transferFile:msgStr];
    }
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Upload" label:Start transferCount:pathArray.count screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    _alertViewController.isIcloudOneOpen = YES;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        float updataCot = 0;
        float curCount = 0;
        for (NSString *url in pathArray) {
            curCount ++;
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                [_iCloudManager cancel];
                [[IMBTransferError singleton] addAnErrorWithErrorName:url.lastPathComponent WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                if (curCount == pathArray.count) {
                    _isStop = NO;
                }
                continue;
            }
            
            NSString *containerId = nil;
            if (_currentEntity != nil && ![_currentEntity.clientId isEqualToString:@"CPLAssetByAddedDate"]) {
                containerId = _currentEntity.recordName;
            }
            BOOL issucc =  [_iCloudManager uploadPhoto:url withContainerId:containerId];
            if (issucc) {
                updataCot ++;
            }
            NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),[url lastPathComponent]];
            if ([_transferController respondsToSelector:@selector(transferFile:)]) {
                [_transferController transferFile:msgStr];
            }
            [_transferController transferPrepareFileEnd];
            float progress = curCount / pathArray.count *100;
            if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
                [_transferController transferProgress:progress];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_transferController startTransAnimation];
            if (_annoyTimer != nil) {
                [_annoyTimer invalidate];
                _annoyTimer = nil;
            }
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Upload" label:Finish transferCount:updataCot screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                [_transferController transferComplete:updataCot TotalCount:(int)pathArray.count];
            }
        });
    });
    
}

- (void)upLoad:(id)sender {
    _isOpen = YES;
    _openPanel = [NSOpenPanel openPanel];
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel setCanChooseFiles:YES];
    [_openPanel setAllowsMultipleSelection:YES];
    [_openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"jpg",@"jpeg", nil]];
    _isStop = NO;
    //    _updateCount = 0;
    [_openPanel beginSheetModalForWindow:[(IMBiCloudMainPageViewController *)_delegate view].window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSFileHandlingPanelOKButton) {
            if (_transferController != nil) {
                [_transferController release];
                _transferController = nil;
            }
            _transferController = [[IMBTransferViewController alloc] initWithType:_category withDelegate:self withTransfertype:TransferUpLoading];
            [_transferController setDelegate:self];
            _transferController.isicloudView = YES;
            [self animationAddTransferView:_transferController.view];
            if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
                NSString *string = @"";
                if (_category == Category_Photo) {
                    string = CustomLocalizedString(@"MenuItem_id_9", nil);
                }else if (_category == Category_PhotoVideo){
                    string = CustomLocalizedString(@"MenuItem_id_24", nil);
                }else if (_category == Category_ContinuousShooting){
                    string = CustomLocalizedString(@"MenuItem_id_47", nil);
                }
                [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),string]];
            }
            _alertViewController.isIcloudOneOpen = YES;
            NSArray *pathAry = [_openPanel URLs];
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Upload" label:Start transferCount:pathAry.count screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }

            NSString *msgStr = CustomLocalizedString(@"ImportSync_id_1", nil);
            if ([_transferController respondsToSelector:@selector(transferFile:)]) {
                [_transferController transferFile:msgStr];
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                float upDataCot = 0;
                float curCount = 0;
                for (NSURL *url in pathAry) {
                    curCount ++;
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        [_iCloudManager cancel];
                        [[IMBTransferError singleton] addAnErrorWithErrorName:url.lastPathComponent WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                        if (curCount == pathAry.count) {
                            _isStop = NO;
                        }
                        continue;
                    }
                    NSString *containerId = nil;
                    if (_currentEntity != nil && ![_currentEntity.clientId isEqualToString:@"CPLAssetByAddedDate"]) {
                        containerId = _currentEntity.recordName;
                    }
                    BOOL issucc =  [_iCloudManager uploadPhoto:url.path withContainerId:containerId];
                    if (issucc) {
                        upDataCot ++;
                    }
                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),[url lastPathComponent]];
                    if ([_transferController respondsToSelector:@selector(transferFile:)]) {
                        [_transferController transferFile:msgStr];
                    }
                    [_transferController transferPrepareFileEnd];
                    
                    float progress = curCount / pathAry.count *100;
                    if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
                        [_transferController transferProgress:progress];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_transferController startTransAnimation];
                    if (_annoyTimer != nil) {
                        [_annoyTimer invalidate];
                        _annoyTimer = nil;
                    }
                    if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                        NSDictionary *dimensionDict = nil;
                        @autoreleasepool {
                            dimensionDict = [[TempHelper customDimension] copy];
                        }
                        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Upload" label:Finish transferCount:upDataCot screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                        if (dimensionDict) {
                            [dimensionDict release];
                            dimensionDict = nil;
                        }
                        [_transferController transferComplete:upDataCot TotalCount:(int)pathAry.count];
                    }
                });
            });
        }
    }];
}

- (void)continueloadData{
    [_condition lock];
    if(_isPause)
    {
        _isPause = NO;
        [_condition signal];
    }
    [_condition unlock];
}

- (void)iClouddragDownDataToMac:(NSString *)pathUrl{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_transferController != nil) {
                [_transferController release];
                _transferController = nil;
            }
            _transferController = [[IMBTransferViewController alloc] initWithType:_category withDelegate:self withTransfertype:TransferDownLoad];
            [_transferController setDelegate:self];
            [_transferController setExprtPath:pathUrl];
            _alertViewController.isIcloudOneOpen = YES;
            _transferController.isicloudView = YES;
            if (![IMBSoftWareInfo singleton].isRegistered) {
                //                _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
            }
            [self animationAddTransferView:_transferController.view ];
            if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
                NSString *string = @"";
                if (_category == Category_Photo) {
                    string = CustomLocalizedString(@"MenuItem_id_9", nil);
                }else if (_category == Category_PhotoVideo){
                    string = CustomLocalizedString(@"MenuItem_id_24", nil);
                }else if (_category == Category_ContinuousShooting){
                    string = CustomLocalizedString(@"MenuItem_id_47", nil);
                }
                [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),string]];
            }
        });
        NSString *msgStr = CustomLocalizedString(@"ImportSync_id_20", nil);
        if ([_transferController respondsToSelector:@selector(transferFile:)]) {
            [_transferController transferFile:msgStr];
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            float i =0;
            float count = 0;
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Download" label:Start transferCount:i screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            NSArray *selectedAry = [self selectedPhotoItems];
            for (IMBToiCloudPhotoEntity *entity in selectedAry) {
                count ++;
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    [_iCloudManager cancel];
                    [[IMBTransferError singleton] addAnErrorWithErrorName:entity.photoName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                    if (count == selectedAry.count) {
                        _isStop = NO;
                    }
                    continue;
                }
                if ([_transferController respondsToSelector:@selector(transferFile:)]) {
                    [_transferController transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),entity.photoName]];
                }
                BOOL success = [_iCloudManager downloadPhoto:entity withDownloadPath:pathUrl];
                if (success ) {
                    i ++;
                }
                [_transferController transferPrepareFileEnd];
                
                float progressCount = count/selectedAry.count*100;
                if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
                    [_transferController transferProgress:progressCount];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_annoyTimer != nil) {
                    [_annoyTimer invalidate];
                    _annoyTimer = nil;
                }
                [_transferController startTransAnimation];
                if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                    NSDictionary *dimensionDict = nil;
                    @autoreleasepool {
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Download" label:Finish transferCount:i screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    if (dimensionDict) {
                        [dimensionDict release];
                        dimensionDict = nil;
                    }
                    [_transferController transferComplete:i TotalCount:(int)selectedAry.count];
                }
            });
            
        });
    });
}

- (NSArray *)selectedPhotoItems {
    NSMutableArray *seleAry = [NSMutableArray array];
    int tableViewRow = (int)[_leftTableView  selectedRow];
    if ([_dataSourceArray count] > 0) {
        IMBToiCloudPhotoEntity *entity1 = [_dataSourceArray objectAtIndex:tableViewRow];
        for (int i=0;i<[entity1.subArray count]; i++) {
            IMBToiCloudPhotoEntity *entity = [entity1.subArray objectAtIndex:i];
            if (entity.checkState == Check||entity.checkState == SemiChecked) {
                [seleAry addObject:entity];
            }
        }
    }
    return seleAry;
}

- (void)downLoad:(id)sender {
    NSArray *selectedAry = [self selectedPhotoItems];
    if ([selectedAry count] <= 0) {
        //弹出警告确认框
        NSString *str = nil;
        if (_dataSourceArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_transfer", nil),[StringHelper getCategeryStr:_category]];
        }else {
            str = CustomLocalizedString(@"Export_View_Selected_Tips", nil);
        }
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }else {
        //弹出路径选择框
        _openPanel = [NSOpenPanel openPanel];
        _isOpen = YES;
        [_openPanel setAllowsMultipleSelection:NO];
        [_openPanel setCanChooseFiles:NO];
        [_openPanel setCanChooseDirectories:YES];
        if(_category == Category_PhotoVideo||_category == Category_Photo||_category == Category_ContinuousShooting) {
            [_openPanel beginSheetModalForWindow:[(IMBiCloudMainPageViewController *)_delegate view].window completionHandler:^(NSInteger result) {
                if (result== NSFileHandlingPanelOKButton) {
                    NSString *path = [[_openPanel URL] path];
                    path = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:_category]];
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (_transferController != nil) {
                                [_transferController release];
                                _transferController = nil;
                            }
                       
                            _transferController = [[IMBTransferViewController alloc] initWithType:_category withDelegate:self withTransfertype:TransferDownLoad];
                            [_transferController setDelegate:self];
                            [_transferController setExprtPath:path];
                            _transferController.isicloudView = YES;
                            _alertViewController.isIcloudOneOpen = YES;
                            if (![IMBSoftWareInfo singleton].isRegistered) {
                                //                                _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
                            }
                            [self animationAddTransferView:_transferController.view];
                            if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
                                NSString *string = @"";
                                if (_category == Category_Photo) {
                                    string = CustomLocalizedString(@"MenuItem_id_9", nil);
                                }else if (_category == Category_PhotoVideo){
                                    string = CustomLocalizedString(@"MenuItem_id_24", nil);
                                }else if (_category == Category_ContinuousShooting){
                                    string = CustomLocalizedString(@"MenuItem_id_47", nil);
                                }
                                [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),string]];
                            }
                        });
                        NSString *msgStr = CustomLocalizedString(@"ImportSync_id_20", nil);
                        if ([_transferController respondsToSelector:@selector(transferFile:)]) {
                            [_transferController transferFile:msgStr];
                        }
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            int i =0;
                            float count = 0;
                            NSDictionary *dimensionDict = nil;
                            @autoreleasepool {
                                dimensionDict = [[TempHelper customDimension] copy];
                            }
                            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Download" label:Start transferCount:i screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                            if (dimensionDict) {
                                [dimensionDict release];
                                dimensionDict = nil;
                            }
//                            NSArray *dataAry = [_dataSourceArray objectsAtIndexes:[self selectedItems]];
                            int repeatCount = 0;
                            for (IMBToiCloudPhotoEntity *entity in selectedAry) {
                                //luolei 修改 优化icloud photo大数据下载
                                
                                @autoreleasepool {
                                    repeatCount ++;
                                    [_condition lock];
                                    if (_isPause) {
                                        [_condition wait];
                                    }
                                    [_condition unlock];
                                    if (_isStop) {
                                        [_iCloudManager cancel];
                                        [[IMBTransferError singleton] addAnErrorWithErrorName:entity.photoName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                                        if (repeatCount == selectedAry.count) {
                                            _isStop = NO;
                                        }
                                        continue;
                                    }
                                    if ([_transferController respondsToSelector:@selector(transferFile:)]) {
                                        [_transferController transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),entity.photoName]];
                                    }
                                    BOOL success = [_iCloudManager downloadPhoto:entity withDownloadPath:path];
                                    if (success ) {
                                        i ++;
                                        if ([IMBSoftWareInfo singleton].isKeepPhotoDate) {
                                            IMBPhotoEntity *photoEntity = (IMBPhotoEntity*)entity;
                                            NSString *lacolPath = [path stringByAppendingPathComponent:[photoEntity photoName]];
                                            NSTask *task;
                                            task = [[NSTask alloc] init];
                                            [task setLaunchPath: @"/usr/bin/touch"];
                                            NSArray *arguments;
                                            if (photoEntity.photoDateData != 0&&![IMBHelper stringIsNilOrEmpty:photoEntity.photoName]){
                                                NSString *str = [IMBHelper longToDateStringFrom1970:photoEntity.photoDateData withMode:8];
                                                
                                                NSString *strData = [self replaceSpecialChar:str];
                                                strData = [strData stringByReplacingOccurrencesOfString:@" " withString:@""];
                                                strData = [strData stringByReplacingOccurrencesOfString:@"-" withString:@""];
                                                arguments = [NSArray arrayWithObjects: @"-mt", strData, lacolPath, nil];
                                                [task setArguments: arguments];
                                                NSPipe *pipe;
                                                pipe = [NSPipe pipe];
                                                [task setStandardOutput: pipe];
                                                NSFileHandle *file;
                                                file = [pipe fileHandleForReading];
                                                [task launch];
                                            }
                                        }
                                    }
                                    count ++;
                                    float progressCount =count/selectedAry.count*100;
                                    [_transferController transferPrepareFileEnd];
                                    if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
                                        [_transferController transferProgress:progressCount];
                                    }
                                }
                            }
                            [_transferController startTransAnimation];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (_annoyTimer != nil) {
                                    [_annoyTimer invalidate];
                                    _annoyTimer = nil;
                                }
                                if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                                    NSDictionary *dimensionDict = nil;
                                    @autoreleasepool {
                                        dimensionDict = [[TempHelper customDimension] copy];
                                    }
                                    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Download" label:Finish transferCount:i screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                                    if (dimensionDict) {
                                        [dimensionDict release];
                                        dimensionDict = nil;
                                    }
                                    [_transferController transferComplete:i TotalCount:(int)selectedAry.count];
                                }
                            });
                            
                        });
                    });
                }else{
                    NSLog(@"other other other");
                }
            }];
        }
    }
}

- (NSString*)replaceSpecialChar:(NSString*)validateString {
    if ([StringHelper stringIsNilOrEmpty:validateString] == NO) {
        validateString = [validateString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"/" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@":" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"*" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"?" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"<" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@">" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"|" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"%" withString:@""];
    }
    return validateString;
}

- (IBAction)addAblumBtn:(id)sender {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    NSString *string = CustomLocalizedString(@"PhotoView_id_3", nil);
    NSInteger result = [_alertViewController showTitleName:string InputTextFiledString:@"" OkButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
    if (result == 1) {
        //进行操作
        NSString *albumName = [_alertViewController.reNameInputTextField stringValue];
        [_alertViewController.renameLoadingView setHidden:NO];
        [_alertViewController.renameLoadingView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [_alertViewController.renameLoadingView setImage:[StringHelper imageNamed:@"registedLoading"]];
        [_alertViewController.renameLoadingView.layer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:-2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [_iCloudManager addPhotoAlbum:albumName];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_alertViewController.renameLoadingView setHidden:YES];
                [_leftTableView reloadData];
                [_alertViewController unloadAlertView:_alertViewController.reNameView];
            });
        });
    }
}

- (void)deleteiCloudItems:(id)sender {
    NSArray *selectedAry = [self selectedPhotoItems];
    if (selectedAry.count > 0) {
        _alertViewController.isStopPan = NO;
        _alertViewController.isIcloudRemove = YES;
        NSString *str = nil;
        if (selectedAry.count == 1) {
            str = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete_2", nil);
        }else {
            str = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete", nil);
        }
        if ([self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)] == 1) {
            [_alertViewController._removeprogressAnimationView setProgressWithOutAnimation:0];
            [_alertViewController._removeprogressAnimationView setProgress:90];
//            NSMutableArray *selectedTracks = [NSMutableArray array];
//            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
//                [selectedTracks addObject:[_dataSourceArray objectAtIndex:idx]];
//            }];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Delete" label:Start transferCount:selectedAry.count screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                BOOL isSuccly = [_iCloudManager deletePhotos:selectedAry];
                if (isSuccly) {
                    //                    _currentEntity.photoCounts = _currentEntity.photoCounts-selectedAry.count;
                }
                [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Delete" label:Finish transferCount:selectedAry.count screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_alertViewController._removeprogressAnimationView setProgress:100];
                });
                double delayInSeconds = 2;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [_alertViewController showRemoveSuccessViewAlertText:CustomLocalizedString(@"MSG_COM_Delete_Complete", nil) withCount:(int)selectedAry.count];
                    [self iCloudReload:nil];
                });
            });
        }
    }else {
        //弹出警告确认框
        NSString *str = nil;
        if (_dataSourceArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_delete", nil),[StringHelper getCategeryStr:_category]];
        }else {
            str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        }
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }
}

- (void)iCloudSyncTransfer:(id)sender {
    IMBiCloudManager *otheriCloudManager = [self getOtheriCloudAccountManager];
    if (otheriCloudManager != nil) {
        NSDictionary *iCloudDic = [_delegate getiCloudAccountViewCollection];
        
        NSMutableArray *baseInfoArr = [NSMutableArray array];
        for (NSString *key in iCloudDic.allKeys) {
            if (![key isEqualToString:_iCloudManager.netClient.loginInfo.appleID]) {
                IMBBaseInfo *baseInfo = [[IMBBaseInfo alloc]init];
                IMBiCloudManager *otheriCloudManager = [[iCloudDic objectForKey:key] iCloudManager];
                baseInfo.deviceName = otheriCloudManager.netClient.loginInfo.loginInfoEntity.fullName;
                baseInfo.isicloudView = YES;
                baseInfo.uniqueKey = key;
                [baseInfoArr addObject:baseInfo];
                [baseInfo release];
            }
        }
        if (baseInfoArr.count == 1) {
            NSArray *arrayM = [[self selectedPhotoItems] retain];
//            NSArray *arrayM = [[_dataSourceArray objectsAtIndexes:indexSet] retain];

            if (arrayM.count > 0) {
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photo To iCloud" label:Start transferCount:arrayM.count screenView:@"Photo View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                if (_transferController != nil) {
                    [_transferController release];
                    _transferController = nil;
                }
                
                IMBBaseInfo *baseInfo = [baseInfoArr objectAtIndex:0];
                NSDictionary *iCloudDic = [_delegate getiCloudAccountViewCollection];
                _otheriCloudManager = [[iCloudDic objectForKey:baseInfo.uniqueKey] iCloudManager];
                [_otheriCloudManager setDelegate:self];
                _transferController = [[IMBTransferViewController alloc] initWithType:_category withDelegate:self withTransfertype:TransferSync withIsicloudView:YES];
                [_transferController setDelegate:self];
                _transferController.isicloudView = YES;
                if (![IMBSoftWareInfo singleton].isRegistered) {
                    //                    _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
                }
                //                [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:nil];
                [self animationAddTransferView:_transferController.view];
                if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
                    NSString *string = @"";
                    if (_category == Category_Photo) {
                        string = CustomLocalizedString(@"MenuItem_id_9", nil);
                    }else if (_category == Category_PhotoVideo){
                        string = CustomLocalizedString(@"MenuItem_id_24", nil);
                    }else if (_category == Category_ContinuousShooting){
                        string = CustomLocalizedString(@"MenuItem_id_47", nil);
                    }
                    [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),string]];
                }
                NSString *msgStr = CustomLocalizedString(@"ImportSync_id_1", nil);
                if ([_transferController respondsToSelector:@selector(transferFile:)]) {
                    [_transferController transferFile:msgStr];
                }
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    int i = 0;
                    float count = 0;
                    for (IMBToiCloudPhotoEntity *entity in arrayM) {
                        entity.photoImageData = [_iCloudManager getPhotoThumbnilDetail:entity.oriDownloadUrl];
                        NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),entity.photoName];
                        if ([_transferController respondsToSelector:@selector(transferFile:)]) {
                            [_transferController transferFile:msgStr];
                        }
                        
                        BOOL issuccdly =  [_otheriCloudManager syncTransferPhoto:entity];
                        if (issuccdly) {
                            i ++;
                        }
                        count ++;
                        
                        float progress = count / arrayM.count *100;
                        if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
                            [_transferController transferProgress:progress];
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (_annoyTimer != nil) {
                            [_annoyTimer invalidate];
                            _annoyTimer = nil;
                        }
                        if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                            [_transferController transferComplete:i TotalCount:(int)arrayM.count];
                        }
                        NSDictionary *dimensionDict = nil;
                        @autoreleasepool {
                            dimensionDict = [[TempHelper customDimension] copy];
                        }
                        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photo To iCloud" label:Finish transferCount:arrayM.count screenView:@"Photo View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                        if (dimensionDict) {
                            [dimensionDict release];
                            dimensionDict = nil;
                        }
                        [arrayM release];
                    });
                });
            }else {
                //弹出警告确认框
                NSString *str = nil;
                str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
                [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            }
            
            
        }else{
            [self toDeviceWithSelectArray:baseInfoArr WithView:sender];
        }
    }else {
        //提示用户，没有其他iCloud账号登录
        NSString *str = nil;
        str = CustomLocalizedString(@"NoAcount_Tips", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }
    
}

- (void)onItemiCloudClicked:(id)sender {
    [_toDevicePopover close];
    NSArray *arrayM = [[self selectedPhotoItems] retain];
//    NSArray *arrayM = [[_dataSourceArray objectsAtIndexes:indexSet] retain];
    
//    _transtotalCount = arrayM.count;
    if (arrayM.count > 0) {
        if (_transferController != nil) {
            [_transferController release];
            _transferController = nil;
        }
        
        IMBBaseInfo *baseInfo = (IMBBaseInfo *)sender;
        NSDictionary *iCloudDic = [_delegate getiCloudAccountViewCollection];
        _otheriCloudManager = [[iCloudDic objectForKey:baseInfo.uniqueKey] iCloudManager];
        [_otheriCloudManager setDelegate:self];
        _transferController = [[IMBTransferViewController alloc] initWithType:_category withDelegate:self withTransfertype:TransferSync];
        [_transferController setDelegate:self];
        _transferController.isicloudView = YES;
        if (![IMBSoftWareInfo singleton].isRegistered) {
            //            _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
        }
        //        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:nil];
        [self animationAddTransferView:_transferController.view];
        if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
            NSString *string = @"";
            if (_category == Category_Photo) {
                string = CustomLocalizedString(@"MenuItem_id_9", nil);
            }else if (_category == Category_PhotoVideo){
                string = CustomLocalizedString(@"MenuItem_id_24", nil);
            }else if (_category == Category_ContinuousShooting){
                string = CustomLocalizedString(@"MenuItem_id_47", nil);
            }
            [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),string]];
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            float count = 0;
            for (IMBToiCloudPhotoEntity *entity in arrayM) {
                entity.photoImageData = [_iCloudManager getPhotoThumbnilDetail:entity.oriDownloadUrl];
                [_otheriCloudManager syncTransferPhoto:entity];
                count ++;
                float progress = count / arrayM.count *100;
                if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
                    [_transferController transferProgress:progress];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_annoyTimer != nil) {
                    [_annoyTimer invalidate];
                    _annoyTimer = nil;
                }
                if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                    [_transferController transferComplete:(int)arrayM.count TotalCount:(int)arrayM.count];
                }
            });
        });
    }else {
        //弹出警告确认框
        NSString *str = nil;
        str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }
    [arrayM release];
}

- (void)tableView:(NSTableView *)tableView rightDownrow:(NSInteger)index {
    _moveRow = (int)index;
}

- (void)dropToTabviewAndCollectionViewWithPaths:(NSArray *)pathArray {
    if (_transferController != nil) {
        [_transferController release];
        _transferController = nil;
    }
    _transferController = [[IMBTransferViewController alloc] initWithType:_category withDelegate:self withTransfertype:TransferUpLoading];
    [_transferController setDelegate:self];
    _transferController.isicloudView = YES;
    [self animationAddTransferView:_transferController.view];
    if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
        NSString *string = @"";
        if (_category == Category_Photo) {
            string = CustomLocalizedString(@"MenuItem_id_9", nil);
        }else if (_category == Category_PhotoVideo){
            string = CustomLocalizedString(@"MenuItem_id_24", nil);
        }else if (_category == Category_ContinuousShooting){
            string = CustomLocalizedString(@"MenuItem_id_47", nil);
        }
        [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),string]];
    }
    
    NSString *msgStr = CustomLocalizedString(@"ImportSync_id_1", nil);
    if ([_transferController respondsToSelector:@selector(transferFile:)]) {
        [_transferController transferFile:msgStr];
    }
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Upload" label:Start transferCount:pathArray.count screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    _alertViewController.isIcloudOneOpen = YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        float updataCot = 0;
        float curCount = 0;
        for (NSString *url in pathArray) {
            curCount ++;
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                [_iCloudManager cancel];
                [[IMBTransferError singleton] addAnErrorWithErrorName:url.lastPathComponent WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                if (curCount == pathArray.count) {
                    _isStop = NO;
                }
                continue;
            }
            
            NSString *containerId = nil;
            if (_currentEntity != nil && ![_currentEntity.clientId isEqualToString:@"CPLAssetByAddedDate"]) {
                containerId = _currentEntity.recordName;
            }
            BOOL issucc =  [_iCloudManager uploadPhoto:url withContainerId:containerId];
            if (issucc) {
                updataCot ++;
            }
            NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),[url lastPathComponent]];
            if ([_transferController respondsToSelector:@selector(transferFile:)]) {
                [_transferController transferFile:msgStr];
            }
            [_transferController transferPrepareFileEnd];
            float progress = curCount / pathArray.count *100;
            if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
                [_transferController transferProgress:progress];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_transferController startTransAnimation];
            if (_annoyTimer != nil) {
                [_annoyTimer invalidate];
                _annoyTimer = nil;
            }
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Upload" label:Finish transferCount:updataCot screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                [_transferController transferComplete:updataCot TotalCount:(int)pathArray.count];
            }
        });
    });

}

- (void)copyInPhotofomationToMac:(NSString *)filePath indexSet:(NSIndexSet *)set{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_transferController != nil) {
                [_transferController release];
                _transferController = nil;
            }
            _transferController = [[IMBTransferViewController alloc] initWithType:_category withDelegate:self withTransfertype:TransferDownLoad];
            [_transferController setDelegate:self];
            [_transferController setExprtPath:filePath];
            _alertViewController.isIcloudOneOpen = YES;
            _transferController.isicloudView = YES;
            if (![IMBSoftWareInfo singleton].isRegistered) {
                //                _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
            }
            [self animationAddTransferView:_transferController.view ];
            if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
                NSString *string = @"";
                if (_category == Category_Photo) {
                    string = CustomLocalizedString(@"MenuItem_id_9", nil);
                }else if (_category == Category_PhotoVideo){
                    string = CustomLocalizedString(@"MenuItem_id_24", nil);
                }else if (_category == Category_ContinuousShooting){
                    string = CustomLocalizedString(@"MenuItem_id_47", nil);
                }
                [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),string]];
            }
        });
        NSString *msgStr = CustomLocalizedString(@"ImportSync_id_20", nil);
        if ([_transferController respondsToSelector:@selector(transferFile:)]) {
            [_transferController transferFile:msgStr];
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            float i =0;
            float count = 0;
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Download" label:Start transferCount:i screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            NSIndexSet *selectedSet = set;
            NSMutableArray *selectedArray = [NSMutableArray array];
                    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                    [selectedArray addObject:[[[_dataSourceArray objectAtIndex:_leftTableView.selectedRow] subArray] objectAtIndex:idx]];
              }];
//            NSArray *selectedAry = [self selectedPhotoItems];
            for (IMBToiCloudPhotoEntity *entity in selectedArray) {
                count ++;
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    [_iCloudManager cancel];
                    [[IMBTransferError singleton] addAnErrorWithErrorName:entity.photoName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                    if (count == selectedArray.count) {
                        _isStop = NO;
                    }
                    continue;
                }
                if ([_transferController respondsToSelector:@selector(transferFile:)]) {
                    [_transferController transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),entity.photoName]];
                }
                BOOL success = [_iCloudManager downloadPhoto:entity withDownloadPath:filePath];
                if (success ) {
                    i ++;
                }
                [_transferController transferPrepareFileEnd];
                
                float progressCount = count/selectedArray.count*100;
                if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
                    [_transferController transferProgress:progressCount];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_annoyTimer != nil) {
                    [_annoyTimer invalidate];
                    _annoyTimer = nil;
                }
                [_transferController startTransAnimation];
                if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                    NSDictionary *dimensionDict = nil;
                    @autoreleasepool {
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Download" label:Finish transferCount:i screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    if (dimensionDict) {
                        [dimensionDict release];
                        dimensionDict = nil;
                    }
                    [_transferController transferComplete:i TotalCount:(int)selectedArray.count];
                }
            });
            
        });
    });

}

- (IBAction)deleteMenuItem:(id)sender {
    
    _alertViewController.isStopPan = NO;
    _alertViewController.isIcloudRemove = YES;
    NSString *str = nil;
    str = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete", nil);
    if ([self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)] == 1) {
        [_alertViewController._removeprogressAnimationView setProgressWithOutAnimation:0];
        [_alertViewController._removeprogressAnimationView setProgress:90];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Delete" label:Start transferCount:1 screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            IMBToiCloudPhotoEntity *icloudEntity = [_dataSourceArray objectAtIndex:_moveRow];
            int count = 0;
            BOOL issuccly = [_iCloudManager deletePhotoAlbum:icloudEntity];
            if (issuccly) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_leftTableView reloadData];
                });
                count = 1;
            }
            
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photos Delete" label:Finish transferCount:count screenView:@"Photos View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_alertViewController._removeprogressAnimationView setProgressWithOutAnimation:100];
            });
            double delayInSeconds = 2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [_alertViewController showRemoveSuccessViewAlertText:CustomLocalizedString(@"MSG_COM_Delete_Complete", nil) withCount:count];
                [_leftTableView reloadData];
//                [self iCloudReload:nil];

            });
        });
    }
}

- (IBAction)reloadMenuItem:(id)sender {
    
}

- (void)settoAlbumMenuItem:(NSMenuItem *)item{
    _toAlbumMenuItem = item;
}

- (void)initiCloudPhotoAlbumMenuItem{
    
    NSMutableArray *baseInfoArr = [NSMutableArray array];
    if (_iCloudManager.albumArray.count >1) {
        for (IMBToiCloudPhotoEntity *entity in _iCloudManager.albumArray) {
            IMBToiCloudPhotoEntity *photoEntity = [_iCloudManager.albumArray objectAtIndex:_leftTableView.selectedRow];
            if (![entity.clientId isEqualToString:photoEntity.clientId]) {
                IMBBaseInfo *baseInfo = [[IMBBaseInfo alloc]init];
                baseInfo.deviceName = entity.albumTitle;
                baseInfo.isicloudView = YES;
                baseInfo.uniqueKey = entity.clientId;
                [baseInfoArr addObject:baseInfo];
                [baseInfo release];
            }
        }
        NSMenu *toAlbumMenu = _toAlbumMenuItem.submenu;
        [toAlbumMenu removeAllItems];
        [toAlbumMenu setAutoenablesItems:NO];
        
        int i = 0;
        for (IMBBaseInfo *baseInfo in baseInfoArr) {
            i ++;
            NSMenuItem *menuItem = nil;
            menuItem = [[NSMenuItem alloc] initWithTitle:baseInfo.deviceName action:@selector(toiCloudPhotoMenuAction:) keyEquivalent:@""];
            [menuItem setTag:i];
            [menuItem setKeyEquivalent:baseInfo.uniqueKey];
            [menuItem setTarget:self];
            [menuItem setEnabled:YES];
            [toAlbumMenu addItem:menuItem];
            [menuItem release];
        }
        
    }
    
}

- (void)toiCloudPhotoMenuAction:(id)sender{
    NSArray *selectedAry = [self selectedPhotoItems];
    if (selectedAry.count >0) {
      
            NSMenu *menu = _toAlbumMenuItem.submenu;
            NSMenuItem *selectedMenuItem = nil;
            for (NSMenuItem *menuItem in menu.itemArray) {
                if (menuItem == sender) {
                    selectedMenuItem = menuItem;
                    NSLog(@"qwsaqwsaqwsa");
                    //          - (BOOL)addPhotoToAlbum:(NSArray *)array withContainerId:(NSString *)containerId;
                    break;
                }
            }
            IMBToiCloudPhotoEntity *entity = nil;
            for (IMBToiCloudPhotoEntity *enity1 in _iCloudManager.albumArray) {
                if ([enity1.clientId isEqualToString:selectedMenuItem.keyEquivalent]) {
                    entity = enity1;
                    _photoEntity = enity1;
                }
            }
        NSString *string = [NSString stringWithFormat:CustomLocalizedString(@"iCloud_photomove", nil),entity.albumTitle];
        NSView *view = nil;
        for (NSView *subView in ((NSView *)[NSApplication sharedApplication].mainWindow.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        [_alertViewController showNoDataLoadingAlertText:string SuperView:view];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
               BOOL isSuccly = [_iCloudManager addPhotoToAlbum:selectedAry withContainerId:entity.recordName];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_alertViewController._removeprogressAnimationView setProgress:100];
                    if (isSuccly) {
                         _photoEntity.photoCounts = _photoEntity.photoCounts + (int)selectedAry.count;
                    }
//                    _photoEntity.photoCounts = _photoEntity.photoCounts + selectedAry.count;
                    [_contentDic removeObjectForKey: [NSString stringWithFormat:@"View-%@",_photoEntity.clientId]];
                    [_contentDic removeObjectForKey: [NSString stringWithFormat:@"List-%@",_photoEntity.clientId]];
                    [_leftTableView reloadData];
                });
                
                dispatch_async(dispatch_get_main_queue(), ^{
                       [_alertViewController cancleNoDataLoadingViewOperation:nil];
                });

            });
        
//        [_alertViewController unloadAlertView:_warningAlertView];
    }else{
        NSString *str = nil;
        str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }
}

- (void)changeSkin:(NSNotification *)notification {
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_lineView setNeedsDisplay:YES];
    [_loadingView setNeedsDisplay:YES];
    [_loadingAnimationView setNeedsDisplay:YES];
    if (_category == Category_PhotoVideo) {
        [_noDataImage setImage:[StringHelper imageNamed:@"noData_video"]];
    }else if (_category  == Category_Photo){
        [_noDataImage setImage:[StringHelper imageNamed:@"noData_photo"]];
        [_addAlbumBtn mouseDownImage:[StringHelper imageNamed:@"add_item3"] withMouseUpImg:[StringHelper imageNamed:@"add_item1"]  withMouseExitedImg:[StringHelper imageNamed:@"add_item1"]  mouseEnterImg:[StringHelper imageNamed:@"add_item2"]  withButtonName:CustomLocalizedString(@"Button_id_2", nil)];
        [_addAlbumBtn setNeedsDisplay:YES];
    }
    [_nodataLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
}

- (void)netWorkFaultInterrupt {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertText:CustomLocalizedString(@"iCloudLogin_View_Tips2", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    });
}

-(void)dealloc{
    if (_currentEntity != nil) {
        [_currentEntity release];
        _currentEntity = nil;
    }
    if (_contentDic != nil) {
        [_contentDic release];
        _contentDic = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTITY_NETWORK_FAULT_INTERRUPT object:nil];
    [super dealloc];
}
@end
