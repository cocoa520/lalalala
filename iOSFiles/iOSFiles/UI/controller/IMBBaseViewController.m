//
//  IMBBaseViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBBlankDraggableCollectionView.h"
#import "IMBAirSyncImportTransfer.h"
#import "IMBExportSetting.h"
#import "IMBAnimation.h"
#import "IMBCustomHeaderCell.h"
#import "IMBDeleteTrack.h"
#import "IMBNotificationDefine.h"
#import "IMBFileSystem.h"
#import "IMBBookEntity.h"
#import "IMBSyncBookPlistBuilder.h"
#import "IMBDeleteApps.h"
#import "IMBCategoryInfoModel.h"
#import "SystemHelper.h"
#import "IMBMainWindowController.h"
#import "IMBPhotoExportSettingConfig.h"
#import <objc/runtime.h>
@implementation IMBBaseViewController
@synthesize researchdataSourceArray = _researchdataSourceArray;
@synthesize dataSourceArray = _dataSourceArray;
@synthesize navigationController = _navigationController;
@synthesize category = _category;
@synthesize itemTableViewcanDrag = _itemTableViewcanDrag;
@synthesize itemTableViewcanDrop = _itemTableViewcanDrop;
@synthesize collectionViewcanDrag = _collectionViewcanDrag;
@synthesize collectionViewcanDrop = _collectionViewcanDrop;
@synthesize isPause = _isPause;
@synthesize condition = _condition;
@synthesize isStop = _isStop;
@synthesize isSearch = _isSearch;
@synthesize mainTopLineView = _mainTopLineView;
@synthesize isShowLineView = _isShowLineView;
@synthesize iPod = _iPod;
@synthesize currentSelectView = _currentSelectView;
@synthesize defaultLayout = _defaultLayout;
@synthesize hoverLayout = _hoverLayout;
@synthesize selectionLayout = _selectionLayout;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    }
    return self;
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
}

- (void)setIsShowLineView:(BOOL)isShowLineView {
    _isShowLineView = isShowLineView;
//    if (_delegate && [_delegate respondsToSelector:@selector(setTopLineViewIsHidden:)]) {
//        [_delegate setTopLineViewIsHidden:!isShowLineView];
//    }
}

- (id)init
{
    if (self = [super initWithNibName:[self className] bundle:nil]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    if (self = [self init]) {
        _iPod = [ipod retain];
        _information = [[IMBInformationManager shareInstance].informationDic objectForKey:_iPod.uniqueKey];
        _category = category;
        _delegate = delegate;
        _delArray = [[NSMutableArray alloc]init];
    }
    return self;
}



-(void)loadData:(NSMutableArray *)ary{
    
}

- (void)awakeFromNib {
    _condition = [[NSCondition alloc]init];
    _endRunloop = NO;
    _itemTableViewcanDrag = YES;
    _itemTableViewcanDrop = YES;
    _isMerge = NO;
    _isClone = NO;
    _isContentToMac = NO;
    _isAddContent = NO;
    _researchdataSourceArray = [[NSMutableArray alloc] init];
    
    _defaultLayout = [[CNGridViewItemLayout alloc] init];
    _hoverLayout = [[CNGridViewItemLayout alloc] init];
    _selectionLayout = [[CNGridViewItemLayout alloc] init];
    _hoverLayout.backgroundColor = [[NSColor grayColor] colorWithAlphaComponent:0.42];
    _selectionLayout.backgroundColor = [NSColor colorWithCalibratedRed:0.542 green:0.699 blue:0.807 alpha:0.420];
    
    if (_itemTableView != nil) {
        
        _itemTableViewcanDrag = NO;
        _itemTableViewcanDrop = NO;
        _itemTableView.dataSource = self;
        _itemTableView.delegate = self;
        _itemTableView.allowsMultipleSelection = YES;
        [_itemTableView setListener:self];
        [_itemTableView setFocusRingType:NSFocusRingTypeNone];
        
    } 
    [_toolBarButtonView setHidden:NO];
    [_toolBarButtonView loadButtons:[NSArray arrayWithObjects:@(0),@(17),@(1),@(2),@(4),@(5),@(12),nil] Target:self DisplayMode:YES];
    
//    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
//    [_alertViewController setDelegate:self];

//    [_propertyMenuItem setTitle:CustomLocalizedString(@"Menu_Property", nil)];
//    [_deleteMenuItem setTitle:CustomLocalizedString(@"Menu_Delete", nil)];
//    [_toDeviceMenuItem setTitle:CustomLocalizedString(@"Menu_ToDevice", nil)];
//    [_toMacMenuItem setTitle:CustomLocalizedString(@"Menu_ToPc", nil)];
//    [_toiTunesMenuItem setTitle:CustomLocalizedString(@"Menu_ToiTunes", nil)];
//    [_addToPlaylistMenuItem setTitle:CustomLocalizedString(@"Menu_Playlist", nil)];
//    [_addToDeviceMenuItem setTitle:CustomLocalizedString(@"Menu_ToDevice", nil)];
//    [_addToDeviceMenuItem setHidden:YES];
//    [_toDeleteMenuItem setTitle:CustomLocalizedString(@"Menu_Delete", nil)];
//    [_refreshMenuItem setTitle:CustomLocalizedString(@"Common_id_1", nil)];
//    [_preViewMenuItem setTitle:CustomLocalizedString(@"ToolContextMenuButton_id_9", nil)];
//    [_addMenuItem setTitle:CustomLocalizedString(@"Common_id_7", nil)];
//    [_itemTableView setBackgroundColor:[NSColor clearColor]];
//    [_upLoadMenuItem setTitle:CustomLocalizedString(@"icloud_upLoad", nil)];
//    [_downLoadMenuItem setTitle:CustomLocalizedString(@"icloud_DownLoad", nil)];
//    [_creatFolderMenuItem setTitle:CustomLocalizedString(@"icloud_greateFile", nil)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeOpenPanel:) name:DeviceDisConnectedNotification object:nil];
}

- (void)setToolBar:(IMBToolButtonView *)toolbar{
    _toolBarButtonView = toolbar;
}
#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [_dataSourceArray count];
}

- (void)tableView:(NSTableView *)aTableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    self.dataSourceArray  = [NSMutableArray arrayWithArray:[self.dataSourceArray sortedArrayUsingDescriptors:[aTableView sortDescriptors]]];
    [aTableView reloadData];
}

#pragma mark - NSTableViewDelegate
- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return NO;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 30;
}

//NSTableView drop and drag
- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
    NSArray *fileTypeList = [NSArray arrayWithObject:@"export"];
    [pboard setPropertyList:fileTypeList
                    forType:NSFilesPromisePboardType];
    if (_category == Category_PhotoVideo ||_category == Category_Photo||_category == Category_ContinuousShooting) {
        return YES;
    }else{
        if (_itemTableViewcanDrag) {
            return YES;
        }else
        {
            return NO;
        }
    }
    
}
//_itemTableView drag destination support
- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation
{
    NSPasteboard *pastboard = [info draggingPasteboard];
    NSArray *fileTypeList = [pastboard propertyListForType:NSFilesPromisePboardType];
    if ( _category == 0 || _category == Category_iTunes_Playlist || _category  == Category_iTunes_Movie || _category  == Category_iTunes_Music || _category  == Category_iTunes_TVShow || _category  == Category_iTunes_PodCasts || _category  == Category_iTunes_iTunesU || _category  == Category_iTunes_iBooks || _category  == Category_iTunes_VoiceMemos || _category  == Category_iTunes_Audiobook || _category  == Category_iTunes_App || _category  == Category_PhotoVideo || _category  == Category_CameraRoll || _category  == Category_PhotoStream || _category == Category_PhotoShare || _category  == Category_Panoramas || _category  == Category_ContinuousShooting || _category  == Category_SafariHistory || _category  == Category_Notes || _category  == Category_Voicemail || _category  == Category_Message || _category  == Category_Calendar) {
        NSLog(@"**********can't drag to tableView");
        return NSDragOperationNone;
    }else if (fileTypeList == nil) {
        if (_itemTableViewcanDrop) {
            return NSDragOperationCopy;
        }else
        {
            return NSDragOperationNone;
        }
        
    }else
    {
        return NSDragOperationNone;
    }
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation {
    NSPasteboard *pastboard = [info draggingPasteboard];
    NSArray *boarditemsArray = [pastboard pasteboardItems];
    NSMutableArray *itemArray = [NSMutableArray array];
    for (NSPasteboardItem *item in boarditemsArray) {
        NSString *urlPath = [item stringForType:@"public.file-url"];
        NSURL *url = [NSURL URLWithString:urlPath];
        NSString *path = [url relativePath];
        if (path == nil) {
            return NO;
        }
        [itemArray addObject:path];
    }
    [self dropToTabView:tableView paths:itemArray];
    return YES;
}

- (NSArray *)tableView:(NSTableView *)tableView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination forDraggedRowsWithIndexes:(NSIndexSet *)indexSet {
    NSArray *namesArray = nil;
    //获取目的url
    BOOL iconHide = NO;
    NSString *url = [dropDestination relativePath];
    //此处调用导出方法
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:indexSet,@"indexSet",url,@"url",tableView,@"tableView", nil];
    [self performSelector:@selector(delayTableViewdragToMac:) withObject:dic afterDelay:0.1];
    iconHide = YES;
    return namesArray;
}

- (void)delayTableViewdragToMac:(NSDictionary *)param {
    NSIndexSet *indexSet = [param objectForKey:@"indexSet"];
    NSString *url = [param objectForKey:@"url"];
    NSTableView *tableView = [param objectForKey:@"tableView"];
    [self dragToMac:indexSet withDestination:url withView:tableView];
}

#pragma mark - IMBImageRefreshListListener
- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    
}

-(void)setAllselectState:(CheckStateEnum)sender{
}

#pragma mark drop and drag Actions
- (void)dragToMac:(NSIndexSet *)indexSet withDestination:(NSString *)destinationPath withView:(NSView *)view {
    NSLog(@"dragToMac：category：%d",_category);
    if (indexSet.count > 0){
        if (_category == Category_Applications) {
            //弹出路径选择框
            if ([_iPod.deviceInfo.getDeviceFloatVersionNumber isVersionMajorEqual:@"8.3"]) {
                //弹出警告确认框
                [self showAlertText:@"Your device is running iOS 8.3 or higher version, which has disabled this feature in AnyTrans." OKButton:@"OK"];
                return;
            }
        }
        NSViewController *annoyVC = nil;
        long long result =  10;
        
            result = [self checkNeedAnnoy:&(annoyVC)];
            if (result == 0) {
                return;
            }
        
        
        if (_category != Category_iCloudDriver){
            destinationPath = [TempHelper createCategoryPath:[TempHelper createExportPath:destinationPath] withString:[IMBCommonEnum categoryNodesEnumToName:_category]];
        }
    }
}

- (void)dropToTabView:(NSTableView *)tableView paths:(NSArray *)pathArray {
    [self dropToTabviewAndCollectionViewWithPaths:pathArray];
}

- (void)copyInfomationToMac:(NSString *)filePath indexSet:(NSIndexSet *)set{
    
}

- (void)dropUpLoad:(NSMutableArray *)pathArray{
    
}

- (void)copyInPhotofomationToMac:(NSString *)filePath indexSet:(NSIndexSet *)set{
    
}

- (void)dropicloudToTabView:(NSTableView *)tableView paths:(NSArray *)pathArray{
    [self dropToTabviewAndCollectionViewWithPaths:pathArray];
}

- (void)dropToCollectionView:(NSCollectionView *)collectionView paths:(NSMutableArray *)pathArray {
    [self dropToTabviewAndCollectionViewWithPaths:pathArray];
}

- (void)dropIcloudToCollectionView:(NSCollectionView *)collectionView paths:(NSMutableArray *)pathArray {
    [self dropToTabviewAndCollectionViewWithPaths:pathArray];
}

- (void)dropToTabviewAndCollectionViewWithPaths:(NSArray *)pathArray {
//    NSMutableArray *allPaths = [[NSMutableArray alloc] init];
//    NSArray *supportExtension = [[MediaHelper getSupportFileTypeArray:_category supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_ipod] componentsSeparatedByString:@";"];
//    //限制每次只能导入1000首，超过的就不导入
//    if (_category == Category_Music || _category == Category_Ringtone || _category == Category_Audiobook || _category == Category_VoiceMemos  || _category == Category_Playlist || _category == Category_Movies || _category == Category_HomeVideo || _category == Category_TVShow || _category == Category_MusicVideo || _category == Category_PhotoLibrary || _category == Category_MyAlbums) {
//        if (_ipod.beingSynchronized) {
//            [self showAlertText:CustomLocalizedString(@"AirsyncTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
//            return;
//        }
//        [self getFileNames:pathArray byFileExtensions:supportExtension toArray:allPaths];
//        
//        if (allPaths.count > 1000) {
//            NSView *view = nil;
//            for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
//                if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
//                    view = subView;
//                    [view setHidden:NO];
//                    break;
//                }
//            }
//            [_alertViewController showAlertText:CustomLocalizedString(@"MSG_AddData_Tips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) SuperView:view];
//            int i = (int)allPaths.count;
//            [allPaths removeObjectsInRange:NSMakeRange(999, i - 1000)];
//        }
//    }else {
//        [allPaths addObjectsFromArray:pathArray];
//    }
//    
//    if (_category == Category_iCloudDriver){
//        [self dropUpLoad:allPaths];
//        return;
//        //        [self copyInfomationToMac:destinationPath indexSet:indexSet];
//    }
//    long long playlistID = 0;
//
//    
//    IMBPhotoEntity *albumEntity = nil;
//    BOOL isAlloc = NO;
//    if (_category == Category_PhotoLibrary) {
//        if (_ipod.deviceInfo.isIOSDevice) {
//            if (albumEntity == nil) {
//                NSArray *albumArray = [_information myAlbumsArray];
//                for (IMBPhotoEntity *entity in albumArray) {
//                    if ([entity.albumTitle isEqualToString:CustomLocalizedString(@"MSG_AddPhotoToDefaultAlbum", nil)] && entity.albumKind == 1550) {
//                        albumEntity = entity;
//                        isAlloc = YES;
//                        break;
//                    }
//                }
//                if (!isAlloc) {
//                    isAlloc = YES;
//                    albumEntity = [[IMBPhotoEntity alloc] init];
//                    albumEntity.albumZpk = -4;
//                    albumEntity.albumKind = 1550;
//                    albumEntity.albumTitle = CustomLocalizedString(@"MSG_AddPhotoToDefaultAlbum", nil);
//                    albumEntity.albumType = SyncAlbum;
//                }else {
//                    isAlloc = NO;
//                }
//            }
//        }
//    }
//    
//    if (_category == Category_Storage || _category == Category_System) {
//        //        NSViewController *annoyVC = nil;
//        //        long long result = [self checkNeedAnnoy:&(annoyVC)];
//        //        if (result == 0) {
//        //            return;
//        //        }
//        //
//        //        [self importToDevice:[NSMutableArray arrayWithArray:allPaths] photoAlbum:albumEntity playlistID:playlistID Result:result AnnoyVC:annoyVC];
//        
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:allPaths, @"supportArray", albumEntity, @"albumEntity", playlistID, @"playlistID", nil];
//        [self performSelector:@selector(executeAction:) withObject:dic afterDelay:0.1];
//        
//        [allPaths autorelease], allPaths = nil;
//        return;
//    }
//    
//    
//    NSMutableArray *supportArray = [[NSMutableArray alloc]init];
//    NSArray *supportFiles = [[MediaHelper getSupportFileTypeArray:_category supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_ipod] componentsSeparatedByString:@";"];
//    for (NSString *path in allPaths) {
//        NSLog(@"%@",path.pathExtension);
//        if ([supportFiles containsObject:[path.pathExtension lowercaseString]]) {
//            [supportArray addObject:path];
//        }
//    }
//    
//    if (supportArray.count > 0) {
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:supportArray, @"supportArray", albumEntity, @"albumEntity", playlistID, @"playlistID", nil];
//        [self performSelector:@selector(executeAction:) withObject:dic afterDelay:0.1];
//    }
//    [supportArray autorelease], supportArray = nil;
//    [allPaths autorelease], allPaths = nil;
}

- (void)executeAction:(NSDictionary *)dic {
    NSViewController *annoyVC = nil;
    long long result = [self checkNeedAnnoy:&(annoyVC)];
    if (result == 0) {
        return;
    }
    IMBPhotoEntity *albumEntity = [dic objectForKey:@"albumEntity"];
    NSMutableArray *supportArray = [dic objectForKey:@"supportArray"];
    long long playlistID = [[dic objectForKey:@"playlistID"] longLongValue];
    [self importToDevice:supportArray photoAlbum:albumEntity playlistID:playlistID Result:result AnnoyVC:annoyVC];
    if (_category != Category_Storage && _category != Category_System) {
        [self refeash];
    }
}

#pragma mark - NSCollectionViewDelegate
- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event
{
    return YES;
}

- (BOOL)collectionView:(NSCollectionView *)cv writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard
{
    NSArray *fileTypeList = [NSArray arrayWithObject:@"export"];
    [pasteboard setPropertyList:fileTypeList
                        forType:NSFilesPromisePboardType];
    if (_collectionViewcanDrag) {
        return YES;
    }else
    {
        return NO;
    }
    
    return YES;
}

- (NSImage *)collectionView:(NSCollectionView *)collectionView draggingImageForItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event offset:(NSPointPointer)dragImageOffset
{
    NSImage *image = [_collectionView draggingImageForItemsAtIndexes:indexes withEvent:event offset:dragImageOffset];
    NSImage *scalingimage = [[NSImage alloc] initWithSize:NSMakeSize(image.size.width, image.size.height)];
    [scalingimage lockFocus];
    [[NSColor clearColor] setFill];
    NSRectFill(NSMakeRect(0, 0, image.size.width/3.0, image.size.height/3.0));
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationLow];
    [image drawInRect:NSMakeRect(0, 0, image.size.width/3.0, image.size.height/3.0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    NSArray *selectedArray = [_arrayController selectedObjects];
    int count = (int)[selectedArray count];
    NSString *countstr = [NSString stringWithFormat:@"%d",count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:countstr?:@""];
    [str addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:12] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, str.length)];
    //    NSRect drawRect = NSMakeRect(image.size.width/6.0, image.size.height/6.0, str.size.width+8, 20);
    //    NSBezierPath *path = nil;
    //    if (count <= 9) {
    //        path = [NSBezierPath bezierPathWithRoundedRect:drawRect xRadius:10 yRadius:10];
    //    }else
    //    {
    //        path = [NSBezierPath bezierPathWithRoundedRect:drawRect xRadius:8 yRadius:8];
    //    }
    
    NSRect drawRect = NSMakeRect(image.size.width/6.0, image.size.height/6.0, str.size.width + 8, str.size.width + 8);
    
    NSBezierPath *path = nil;
    path = [NSBezierPath bezierPathWithRoundedRect:drawRect xRadius:(str.size.width + 8)/2.0 yRadius:(str.size.width + 8)/2.0];
    
    [[NSColor redColor] setFill];
    [path fill];
    [[NSColor whiteColor] setStroke];
    [path stroke];
    
    //    [str drawInRect: NSMakeRect(image.size.width/6.0 + (str.size.width+8 - str.size.width)/2.0, image.size.height/6.0+(20-str.size.height)/2.0 - 3.5, str.size.width+8, 20)];
    [str drawInRect: NSMakeRect(drawRect.origin.x+4,drawRect.origin.y +(drawRect.size.height - str.size.height )/2.0 + 1, str.size.width+8, str.size.height)];
    
    NSData *tempdata = nil;
    NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect: NSMakeRect(0, 0, image.size.width/3.0, image.size.height/3.0)];
    tempdata = [bitmap representationUsingType:NSPNGFileType properties:nil];
    [bitmap release];
    [scalingimage unlockFocus];
    [scalingimage release];
    
    NSImage *dragImage = [[[NSImage alloc] initWithData:tempdata] autorelease];
    return dragImage;
}

- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id <NSDraggingInfo>)draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation
{
    NSPasteboard *pastboard = [draggingInfo draggingPasteboard];
    NSArray *fileTypeList = [pastboard propertyListForType:NSFilesPromisePboardType];
    return NSDragOperationCopy;
}

- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id <NSDraggingInfo>)draggingInfo index:(NSInteger)index dropOperation:(NSCollectionViewDropOperation)dropOperation
{
    if (collectionView == _collectionView) {
        NSPasteboard *pastboard = [draggingInfo draggingPasteboard];
        NSArray *boarditemsArray = [pastboard pasteboardItems];
        NSMutableArray *itemArray = [NSMutableArray array];
        for (NSPasteboardItem *item in boarditemsArray) {
            NSString *urlPath = [item stringForType:@"public.file-url"];
            NSURL *url = [NSURL URLWithString:urlPath];
            NSString *path = [url relativePath];
            if(![StringHelper stringIsNilOrEmpty:path]) {
                [itemArray addObject:path];
            }
        }
       
        [self dropToCollectionView:collectionView paths:itemArray];
        
    }else if (collectionView == _noDataCollectionView) {
        NSPasteboard *pastboard = [draggingInfo draggingPasteboard];
        NSArray *boarditemsArray = [pastboard pasteboardItems];
        NSMutableArray *itemArray = [NSMutableArray array];
        for (NSPasteboardItem *item in boarditemsArray) {
            NSString *urlPath = [item stringForType:@"public.file-url"];
            NSURL *url = [NSURL URLWithString:urlPath];
            NSString *path = [url relativePath];
            [itemArray addObject:path];
        }
        if (_itemTableView != nil) {
            [self dropToTabviewAndCollectionViewWithPaths:itemArray];
        }else if (_collectionView != nil) {
            [self dropToCollectionView:collectionView paths:itemArray];
        }
        return YES;
    }
    return NO;
}

- (NSArray *)collectionView:(NSCollectionView *)collectionView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropURL forDraggedItemsAtIndexes:(NSIndexSet *)indexes
{
    NSArray *namesArray = nil;
    //获取目的url
    NSString *url = [dropURL relativePath];
    //此处调用导出方法
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:indexes,@"indexSet",url,@"url",collectionView,@"collectionView", nil];
    [self performSelector:@selector(delayCollectionViewdragToMac:) withObject:dic afterDelay:0.1];
    return namesArray;
}

- (void)delayCollectionViewdragToMac:(NSDictionary *)param
{
    NSIndexSet *indexSet = [param objectForKey:@"indexSet"];
    NSString *url = [param objectForKey:@"url"];
    NSCollectionView *collectionView = [param objectForKey:@"collectionView"];
    [self dragToMac:indexSet withDestination:url withView:collectionView];
}

- (void)iClouddragDownDataToMac:(NSString *)pathUrl{
    
}

#pragma mark Operaiton Actions
- (void)reload:(id)sender {
    NSLog(@"reload");
}
- (void)addItems:(id)sender {
//    if (_ipod.beingSynchronized) {
//        [self showAlertText:CustomLocalizedString(@"AirsyncTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
//        return;
//    }
//    if (_category != Category_PhotoLibrary && _category != Category_MyAlbums) {
//        if (![self checkInternetAvailble]) {
//            return;
//        }
//    }
//    if (_category == Category_Ringtone) {
//        if (![IMBRingtoneConfig singleton].allSkip) {
//            [_alertViewController setIsStopPan:YES];
//            int ret = [self showAlertText:CustomLocalizedString(@"ringtone_setting_window_11", nil) OKButton:CustomLocalizedString(@"Button_Yes", nil) CancelButton:CustomLocalizedString(@"Button_No", nil)];
//            [_alertViewController setIsStopPan:NO];
//            if (ret == 1) {
//                [self performSelector:@selector(doSetting:) withObject:nil afterDelay:0.6];
//                return;
//            }
//        }
//    }
//    
//    [self addItemContent];
}

- (void)addItemContent {
//    long long playlistID = 0;
//
//    __block IMBPhotoEntity *albumEntity = nil;
//    BOOL isAlloc = NO;
//    if (_category == Category_PhotoLibrary) {
//        if (_ipod.deviceInfo.isIOSDevice) {
//            if (albumEntity == nil) {
//                NSArray *albumArray = [_information myAlbumsArray];
//                for (IMBPhotoEntity *entity in albumArray) {
//                    if ([entity.albumTitle isEqualToString:CustomLocalizedString(@"MSG_AddPhotoToDefaultAlbum", nil)] && entity.albumKind == 1550) {
//                        albumEntity = entity;
//                        isAlloc = YES;
//                        break;
//                    }
//                }
//                if (!isAlloc) {
//                    isAlloc = YES;
//                    albumEntity = [[IMBPhotoEntity alloc] init];
//                    albumEntity.albumZpk = -4;
//                    albumEntity.albumKind = 1550;
//                    albumEntity.albumTitle = CustomLocalizedString(@"MSG_AddPhotoToDefaultAlbum", nil);
//                    albumEntity.albumType = SyncAlbum;
//                }else {
//                    isAlloc = NO;
//                }
//            }
//        }
//    }
//    NSArray *supportFiles = [[MediaHelper getSupportFileTypeArray:_category supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_ipod] componentsSeparatedByString:@";"];
//    
//    _openPanel = [NSOpenPanel openPanel];
//    _isOpen = YES;
//    [_openPanel setCanChooseDirectories:YES];
//    [_openPanel setCanChooseFiles:YES];
//    [_openPanel setAllowsMultipleSelection:YES];
//    [_openPanel setAllowedFileTypes:supportFiles];
//    [_openPanel beginSheetModalForWindow:[(IMBDeviceMainPageViewController *)_delegate view].window completionHandler:^(NSModalResponse returnCode) {
//        if (returnCode == NSFileHandlingPanelOKButton) {
//            NSDictionary *param = nil;
//            if (albumEntity == nil) {
//                param = [NSDictionary dictionaryWithObjectsAndKeys:_openPanel,@"openPanel",[NSNull null],@"albumEntity",@(playlistID),@"playlistID",@(isAlloc),@"isAlloc",nil];
//                
//            }else{
//                param = [NSDictionary dictionaryWithObjectsAndKeys:_openPanel,@"openPanel",albumEntity,@"albumEntity",@(playlistID),@"playlistID",@(isAlloc),@"isAlloc",nil];
//                
//            }
//            [self performSelector:@selector(addItemsDelay:) withObject:param afterDelay:0.1];
//        }
//        _isOpen = NO;
//    }];
}

- (void)addItemsDelay:(NSDictionary *)param
{
//    NSViewController *annoyVC = nil;
//    long long result = [self checkNeedAnnoy:&(annoyVC)];
//    if (result == 0) {
//        return;
//    }
//    BOOL isAlloc = [[param objectForKey:@"isAlloc"] boolValue];
//    NSOpenPanel *openPanel = [param objectForKey:@"openPanel"];
//    long long playlistID = [[param objectForKey:@"playlistID"] longLongValue];
//    IMBPhotoEntity *albumEntity = [param objectForKey:@"albumEntity"];
//    if ([albumEntity isKindOfClass:[NSNull class]]) {
//        albumEntity = nil;
//    }
//    NSArray *urlArr = [openPanel URLs];
//    NSMutableArray *paths = [NSMutableArray array];
//    for (NSURL *url in urlArr) {
//        [paths addObject:url.path];
//    }
//    NSMutableArray *allPaths = [[NSMutableArray alloc] init];
//    NSArray *supportExtension = [[MediaHelper getSupportFileTypeArray:_category supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_ipod] componentsSeparatedByString:@";"];
//    //限制每次只能导入1000首，超过的就不导入
//    if (_category == Category_Music || _category == Category_Ringtone || _category == Category_Audiobook || _category == Category_VoiceMemos  || _category == Category_Playlist || _category == Category_Movies || _category == Category_HomeVideo || _category == Category_TVShow || _category == Category_MusicVideo || _category == Category_PhotoLibrary || _category == Category_MyAlbums) {
//        [self getFileNames:paths byFileExtensions:supportExtension toArray:allPaths];
//        if (allPaths.count > 1000) {
//            NSView *view = nil;
//            for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
//                if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
//                    view = subView;
//                    [view setHidden:NO];
//                    break;
//                }
//            }
//            [_alertViewController showAlertText:CustomLocalizedString(@"MSG_AddData_Tips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) SuperView:view];
//            int i = (int)allPaths.count;
//            [allPaths removeObjectsInRange:NSMakeRange(999, i - 1000)];
//        }
//    }else {
//        [allPaths addObjectsFromArray:paths];
//    }
//    NSDictionary *dimensionDict = nil;
//    @autoreleasepool {
//        dimensionDict = [[TempHelper customDimension] copy];
//    }
//    [ATTracker event:Device_Content action:Import actionParams:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] label:Start transferCount:allPaths.count screenView:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
//    if (dimensionDict) {
//        [dimensionDict release];
//        dimensionDict = nil;
//    }
//    [self importToDevice:allPaths photoAlbum:albumEntity playlistID:playlistID Result:result AnnoyVC:annoyVC];
//    if (isAlloc && albumEntity != nil) {
//        [albumEntity release];
//    }
//    [allPaths autorelease], allPaths = nil;
}

- (void)deleteItems:(id)sender
{
    if (_category != Category_PhotoLibrary && _category != Category_MyAlbums && _category != Category_CameraRoll && _category != Category_CameraRoll && _category != Category_PhotoVideo &&_category == Category_TimeLapse &&_category !=Category_Panoramas && _category == Category_SlowMove&& _category != Category_LivePhoto&& _category != Category_Screenshot&& _category != Category_PhotoSelfies&& _category != Category_Location&& _category != Category_Favorite) {
        if (![self checkInternetAvailble]) {
            return;
        }
    }
    NSLog(@"deleteItems");
    
    NSIndexSet *selectedSet = [self selectedItems];
    if (selectedSet.count > 0) {
        _isDeletePlaylist = NO;
        NSString *str = nil;
        if (selectedSet.count == 1) {
            str = @"Are you sure you want to permanently delete the selected item?";
        }else {
            str = @"Are you sure you want to permanently delete the selected items?";
        }
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Device_Content action:Delete actionParams:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] label:Start transferCount:0 screenView:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [self showAlertText:str OKButton:@"OK" CancelButton:@"Cancel"];
    }else {
        //弹出警告确认框
        NSString *str = nil;
        if (_dataSourceArray.count == 0) {
            str = [NSString stringWithFormat:@"No %@ to delete.",[StringHelper getCategeryStr:_category]];
        }else {
            str = @"Please select at least one item.";
        }
        [self showAlertText:str OKButton:@"OK"];
    }
}


- (void)photoToMac{
    [self performSelector:@selector(photoToMacAler) withObject:nil afterDelay:0.1];
}

- (void)systemtoMacDelay:(NSOpenPanel *)openPanel
{
    NSViewController *annoyVC = nil;
    long long result1 = [self checkNeedAnnoy:&(annoyVC)];
    if (result1 == 0) {
        return;
    }
    NSString *path = [[openPanel URL] path];
    NSString *filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:_category]];
    [self copyCollectionContentToMac:filePath Result:result1 AnnoyVC:annoyVC];
}
- (void)infortoMacDelay:(NSOpenPanel *)openPanel
{
    NSIndexSet *selectedSet = [self selectedItems];
    NSViewController *annoyVC = nil;
    long long result1 = 10;

    NSString *path = [[openPanel URL] path];
    NSString *filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:_category]];
    [self copyInfomationToMac:filePath indexSet:selectedSet Result:result1 AnnoyVC:annoyVC];
}

- (void)doImportContact:(id)sender{
    NSLog(@"doImportContact");
}

- (void)doToContact:(id)sender{
    NSLog(@"doToContact");
}

- (void)back:(id)sender
{
    [self.navigationController popViewController:self AnimationStyle:0];
}

- (void)setTableViewHeadCheckBtn{

}

#pragma mark - export Action
- (void)copyTableViewContentToMac:(NSString *)filePath indexSet:(NSIndexSet *)set Result:(long long)result AnnoyVC:(NSViewController *)annoyVC{
//    //得出选中的track
//    NSLog(@"===========");
//    NSIndexSet *selectedSet = set;
//    NSMutableArray *selectedTracks = [NSMutableArray array];
//    NSArray *displayArray = nil;
//    if (_isSearch) {
//        displayArray = _researchdataSourceArray;
//    }else{
//        displayArray = _dataSourceArray;
//    }
//    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
//        [selectedTracks addObject:[displayArray objectAtIndex:idx]];
//    }];
//    
////    if (_category == Category_Voicemail) {
////        [selectedTracks removeAllObjects];
////        for (IMBVoiceMailAccountEntity *entity in displayArray) {
////            for (IMBVoiceMailEntity *voiceEntity in entity.subArray) {
////                if (voiceEntity.checkState == Check) {
////                    [selectedTracks addObject:voiceEntity];
////                }
////            }
////        }
////    }
//    
//    if (_transferController != nil) {
//        [_transferController release];
//        _transferController = nil;
//    }
//    
////    int exportType = 1;
////    if (_isiCloud) {
////        exportType = 3;
////    }else {
////        if ([self isKindOfClass:[IMBBackupCollectionViewController class]]) {
////            exportType = 2;
////        }
////    }
//    _transferController = [[IMBTransferViewController alloc] initWithIPodkey:_ipod.uniqueKey Type:_category SelectItems:selectedTracks ExportFolder:filePath];
//    [_transferController setExportType:exportType];
//    if (result>0) {
//        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
//    }else{
//        [self animationAddTransferView:_transferController.view];
//    }
}

- (void)copyCollectionContentToMac:(NSString *)filePath Result:(long long)result AnnoyVC:(NSViewController *)annoyVC{
    NSArray *selectedFile = [_arrayController selectedObjects];
//    
//    if (_transferController != nil) {
//        [_transferController release];
//        _transferController = nil;
//    }
//    _transferController = [[IMBTransferViewController alloc] initWithIPodkey:_iPod.uniqueKey Type:_category SelectItems:(NSMutableArray *)selectedFile ExportFolder:filePath];
//    if (result>0) {
//        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
//    }else{
//        [self animationAddTransferView:_transferController.view];
//        
//    }
}

- (void)copyInfomationToMac:(NSString *)filePath indexSet:(NSIndexSet *)set Result:(long long)result AnnoyVC:(NSViewController *)annoyVC{
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    NSMutableArray *selectedArray = [NSMutableArray array];
//    if (_category == Category_Calendar && [self isKindOfClass:[IMBCalendarViewController class]]) {
//        [selectedArray addObjectsFromArray:[(IMBCalendarViewController *)self selectItems]];
//    }else {
//        NSIndexSet *selectedSet = set;
//        NSArray *displayArray = disAry;
//        [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
//            [selectedArray addObject:[displayArray objectAtIndex:idx]];
//        }];
//    }
    
    NSString *mode = @"";
    if (_iPod != nil) {
        if (_category == Category_Notes) {
            mode = [_iPod.exportSetting getExportExtension:_iPod.exportSetting.notesType];
        }
        //message 导出到Mac
        else if (_category == Category_Message) {
            mode = [_iPod.exportSetting getExportExtension:_iPod.exportSetting.messageType];
        }
        else if (_category == Category_Calendar){
            mode = [_iPod.exportSetting getExportExtension:_iPod.exportSetting.calenderType];
        }
        else if (_category == Category_Bookmarks) {
            mode = [_iPod.exportSetting getExportExtension:_iPod.exportSetting.safariType];
        }
        else if (_category == Category_Contacts){
            mode = [_iPod.exportSetting getExportExtension:_iPod.exportSetting.contactType];
        }
        else if (_category == Category_SafariHistory){
            mode = [_iPod.exportSetting getExportExtension:_iPod.exportSetting.safariHistoryType];
        }
        else if (_category == Category_CallHistory) {
            mode = [_iPod.exportSetting getExportExtension:_iPod.exportSetting.callHistoryType];
        }
        else if (_category == Category_Reminder) {
            mode = [_iPod.exportSetting getExportExtension:_iPod.exportSetting.reminderType];
        }
    }else {
        if (_exportSetting != nil) {
            [_exportSetting release];
            _exportSetting = nil;
        }
        _exportSetting = [[IMBExportSetting alloc] initWithIPod:nil];
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        if (_category == Category_Notes) {
            mode = [_exportSetting getExportExtension:_exportSetting.notesType];
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Notes Send to Mac" label:Finish transferCount:0 screenView:@"Notes View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
        //message 导出到Mac
        else if (_category == Category_Message) {
            mode = [_exportSetting getExportExtension:_exportSetting.messageType];
        }
        else if (_category == Category_Calendar){
            mode = [_exportSetting getExportExtension:_exportSetting.calenderType];
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Calendar Send to Mac" label:Finish transferCount:0 screenView:@"Calendar View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
        else if (_category == Category_Bookmarks) {
            mode = [_exportSetting getExportExtension:_exportSetting.safariType];
        }
        else if (_category == Category_Contacts){
            mode = [_exportSetting getExportExtension:_exportSetting.contactType];
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Contacts Send to Mac" label:Finish transferCount:0 screenView:@"Contacts View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
        else if (_category == Category_SafariHistory){
            mode = [_exportSetting getExportExtension:_exportSetting.safariHistoryType];
        }
        else if (_category == Category_CallHistory) {
            mode = [_exportSetting getExportExtension:_exportSetting.callHistoryType];
        }
        else if (_category == Category_Reminder) {
            mode = [_exportSetting getExportExtension:_exportSetting.reminderType];
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Reminder Send to Mac" label:Finish transferCount:0 screenView:@"Reminder View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    }
//    if (_transferController != nil) {
//        [_transferController release];
//        _transferController = nil;
//    }
//    
//   
//    _transferController = [[IMBTransferViewController alloc] initWithType:_category SelectItems:selectedArray ExportFolder:filePath Mode:mode];
//    
//    
//    if (result>0) {
//        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
//    }else{
//        [self animationAddTransferView:_transferController.view];
//        
//    }
}

#pragma mark - import Action
- (void)importToDevice:(NSMutableArray *)paths photoAlbum:(IMBPhotoEntity *)photoAlbum playlistID:(int64_t)playlistID Result:(long long)result AnnoyVC:(NSViewController *)annoyVC{
//    if (_transferController != nil) {
//        [_transferController release];
//        _transferController = nil;
//    }
//    _transferController = [[IMBTransferViewController alloc] initWithIPodkey:_iPod.uniqueKey Type:_category importFiles:paths photoAlbum:photoAlbum playlistID:playlistID];
//    [_transferController setDelegate:self];
//    if (result>0) {
//        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
//    }else{
//        [self animationAddTransferView:_transferController.view];
//        
//        
//    }
}

#pragma mark - delete Action
-(void)deleteBackupSelectedItems:(id)sender {
}

- (BOOL)isUnusualPersistentID:(NSString *)persistentID{
    for (int i = 0; i < persistentID.length; i ++) {
        unichar charcode = [persistentID characterAtIndex:i];
        if ((charcode > 'a' && charcode < 'z') || (charcode >= 'A' && charcode <= 'Z')) {
            return YES;
        }
    }
    return NO;
}

- (void)setDeleteProgress:(float)progress withWord:(NSString *)msgStr {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_alertViewController._removeprogressAnimationView setProgress:progress];
//        [_alertViewController showChangeRemoveProgressViewTitle:msgStr];
//    });
}

- (void)setDeleteComplete:(int)success totalCount:(int)totalCount {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_alertViewController._removeprogressAnimationView setProgressWithOutAnimation:100];
//        [self showRemoveSuccessAlertText:CustomLocalizedString(@"MSG_COM_Delete_Complete", nil) withCount:success];
//        [self reload:nil];
//    });
}

#pragma mark - toDevice Action
//检查是否有另一个设备准备好 可以clone和merge、todevice
- (BOOL)checkDeviceReady:(BOOL)todevice {
    BOOL ready = NO;
    IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
    NSArray *array = [connection getConnectedIPods];
    int totalDeviceCount = 0;
    for (IMBiPod *ipod in array) {
        if (![ipod.uniqueKey isEqualToString:_iPod.uniqueKey]/* && ipod.infoLoadFinished*/) {
            if (todevice) {
                totalDeviceCount ++;
            }else {
                if (ipod.deviceInfo.isIOSDevice) {
                    totalDeviceCount ++;
                }
            }
        }
    }
    if (totalDeviceCount == 0) {
        if (todevice) {
            [self showAlertText:@"Please connect at least two devices to continue." OKButton:@"OK"];
        }else {
            [self showAlertText:@"Please connect at least two iOS devices to continue." OKButton:@"OK"];
        }
    }else{
        ready = YES;
    }
    return ready;
}

- (void)toDeviceWithSelectArray:(NSMutableArray *)selectArry WithView:(NSView *)view{
    if (_toDevicePopover != nil) {
        [_toDevicePopover release];
        _toDevicePopover = nil;
    }
    _toDevicePopover = [[NSPopover alloc] init];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
        _toDevicePopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];
    }else {
        _toDevicePopover.appearance = NSPopoverAppearanceMinimal;
    }
    
    _toDevicePopover.animates = YES;
    _toDevicePopover.behavior = NSPopoverBehaviorTransient;
    _toDevicePopover.delegate = self;
   
//    IMBToDevicePopoverViewController *toDevicePopVC = [[IMBToDevicePopoverViewController alloc]initWithNibName:@"IMBToDevicePopoverViewController" bundle:nil WithDevice:selectArry];
//    [toDevicePopVC setTarget:self];
//    if (view.tag == 1111) {
//        [toDevicePopVC setAction:@selector(toiCloudItemClicked:)];
//    }else{
//        if (_isiCloudView) {
//            [toDevicePopVC setAction:@selector(onItemiCloudClicked:)];
//        }else if (_isAndroidView) {
//            [toDevicePopVC setAction:@selector(onItemAndroidClicked:)];
//        }else {
//            [toDevicePopVC setAction:@selector(onItemClicked:)];
//        }
//    }
    
//    if (_toDevicePopover != nil) {
//        _toDevicePopover.contentViewController = toDevicePopVC;
//    }
//    
//    [toDevicePopVC release];
    
    NSRectEdge prefEdge = NSMaxYEdge;
    NSRect rect = NSMakeRect(0, 0,  0, 0);
    [_toDevicePopover showRelativeToRect:rect ofView:view preferredEdge:prefEdge];
}

- (void)onItemClicked:(id)sender {
    IMBBaseInfo *baseInfo = (IMBBaseInfo *)sender;
    [_toDevicePopover close];
    
    NSIndexSet *selectedSet = [self selectedItems];
    NSArray *playlistsArray = nil;
    
    if ([selectedSet count] > 0 || playlistsArray.count > 0) {
        IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
        IMBiPod *tarIpod = [connection getIPodByKey:baseInfo.uniqueKey];
        if (_category == Category_Calendar) {
            BOOL open = [self chekiCloud:@"Calendars" withCategoryEnum:_category];
            if (!open) {
                return;
            }
        }
        if (tarIpod.beingSynchronized) {
            [self showAlertText:@"Syncing your device. Please wait." OKButton:@"OK"];
            return;
        }
        if (_category == Category_Applications) {
            NSMutableArray *disAry = nil;
            if (_isSearch) {
                disAry = _researchdataSourceArray;
            }else{
                disAry = _dataSourceArray;
            }
            NSMutableArray *sourceApps = [[[NSMutableArray alloc] init] autorelease];
            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                [sourceApps addObject:[disAry objectAtIndex:idx]];
            }];
            int i = [self addAppTodevice:tarIpod withSourceAppArray:sourceApps];
            if (i != 0) {
                [self contentToDevice:playlistsArray indexSet:selectedSet tarIpod:tarIpod];
            }
        }else {
            [self contentToDevice:playlistsArray indexSet:selectedSet tarIpod:tarIpod];
        }
    }else {
        //弹出警告确认框
        [self showAlertText:@"Please select at least one item to continue." OKButton:@"OK"];
    }
}

- (void)contentToDevice:(NSArray *)playlistsArray indexSet:(NSIndexSet *)selectedSet tarIpod:(IMBiPod *)tarIpod {
    NSViewController *annoyVC = nil;
    long long result = [self checkNeedAnnoy:&(annoyVC)];
    if (result == 0) {
        return;
    }
    
    BOOL isSupportCategory = FALSE;
    if (_category == Category_Music||_category == Category_Movies||_category == Category_TVShow||_category == Category_MusicVideo||_category == Category_PodCasts||_category == Category_iTunesU||_category == Category_Audiobook||_category == Category_Ringtone||_category == Category_Playlist||_category == Category_HomeVideo||_category == Category_VoiceMemos||_category == Category_Applications||_category == Category_iBooks) {
        if (![self checkInternetAvailble]) {
            return;
        }
        isSupportCategory = YES;
    }else if (_category == Category_PhotoLibrary || _category == Category_PhotoStream || _category == Category_PhotoVideo || _category == Category_CameraRoll || _category == Category_Panoramas||_category == Category_ContinuousShooting||_category == Category_MyAlbums || _category == Category_PhotoShare||_category == Category_Notes||_category == Category_Contacts||_category == Category_Bookmarks||_category == Category_System||_category == Category_Calendar || _category == Category_SlowMove || _category == Category_TimeLapse || _category == Category_LivePhoto || _category == Category_Screenshot || _category == Category_PhotoSelfies || _category == Category_Location || _category == Category_Favorite) {
        isSupportCategory = YES;
    }
    if (isSupportCategory) {
        NSMutableArray *preparedArray = [NSMutableArray array];
        IMBPhotoEntity *albumEntity = nil;
   
        [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            [preparedArray addObject:[_dataSourceArray objectAtIndex:idx]];
        }];
      
        
        if (preparedArray == nil) {
            preparedArray= [NSMutableArray array];
        }
        if (playlistsArray == nil) {
            playlistsArray = [NSMutableArray array];
        }
        
        IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
        model.categoryNodes = _category;
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:preparedArray forKey:@"selectArr"];
        [dictionary setObject:model forKey:@"category"];
        [dictionary setObject:playlistsArray forKey:@"playlists"];
        if (albumEntity != nil) {
            [dictionary setObject:albumEntity forKey:@"albumentity"];
        }
        
        if (_category == Category_Calendar) {
            IMBInformationManager *manager= [IMBInformationManager shareInstance];
            IMBInformation *information = [manager.informationDic objectForKey:tarIpod.uniqueKey];
//            if (information.calendarArray.count > 0) {
//                IMBCalendarEntity *calendarEntity = [information.calendarArray objectAtIndex:0];
//                [dictionary setObject:calendarEntity.calendarID forKey:@"calendarID"];
//            } else {
//                //弹出警告确认框,提示目标设备没有calendar 组
//                [self showAlertText:CustomLocalizedString(@"transferCalendar_toDevicePrompt", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
//                [model release];
//                return;
//            }
        }
        
//        if (_transferController != nil) {
//            [_transferController release];
//            _transferController = nil;
//        }
//        _transferController = [[IMBTransferViewController alloc] initWithIPodkey:_iPod.uniqueKey DesIpodKey:tarIpod.uniqueKey SelectDic:dictionary];
//        if (result>0) {
//            [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
//        }else {
//            [self animationAddTransferView:_transferController.view];
//        }
        [model release];
        
    }
}

//获得选中的item
- (NSIndexSet *)selectedItems {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    NSMutableIndexSet *sets = [NSMutableIndexSet indexSet];
    for (int i=0;i<[disAry count]; i++) {
        IMBBaseEntity *entity = [disAry objectAtIndex:i];
        if (entity.checkState == Check||entity.checkState == SemiChecked) {
            [sets addIndex:i];
        }
    }
    return sets;
}

#pragma mark - Android - 获得选中的item
- (NSIndexSet *)selectedAndroidItems {
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else{
        if (_category == Category_Photo) {
            displayArr = _baseAry;
        } else {
            displayArr = _dataSourceArray;
        }
        
    }
    NSMutableIndexSet *sets = [NSMutableIndexSet indexSet];
    for (int i=0;i<[displayArr count]; i++) {
        IMBBaseEntity *entity = [displayArr objectAtIndex:i];
        if (entity.checkState == Check||entity.checkState == SemiChecked) {
            [sets addIndex:i];
        }
    }
    return sets;
}

- (void)setTableViewHeadOrCollectionViewCheck{
    return;
}

- (void)animationAddTransferViewfromRight:(NSView *)view AnnoyVC:(NSViewController *)AnnoyVC;
{
//    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//        [view setFrame:NSMakeRect(0, 0, [(IMBDeviceMainPageViewController *)_delegate view].frame.size.width, [(IMBDeviceMainPageViewController *)_delegate view].frame.size.height)];
//        [[(IMBDeviceMainPageViewController *)_delegate view] addSubview:view];
//        [view setWantsLayer:YES];
//        [view.layer  addAnimation:[IMBAnimation moveX:0.5 fromX:[NSNumber numberWithInt:view.frame.size.width] toX:[NSNumber numberWithInt:0] repeatCount:1 beginTime:0] forKey:@"movex"];
//    } completionHandler:^{
//        [(AnnoyVC).view removeFromSuperview];
//        [(AnnoyVC) release];
//    }];
}

- (void)animationAddTransferView:(NSView *)view
{
    //    [[(IMBDeviceMainPageViewController *)_delegate view] setWantsLayer:YES];
    //    CATransition *transition = [self pushAnimation:kCATransitionPush withSubType:kCATransitionFromTop durTimes:0.5];
    //    [[(IMBDeviceMainPageViewController *)_delegate view].layer removeAllAnimations];
    //    [[(IMBDeviceMainPageViewController *)_delegate view].layer addAnimation:transition forKey:@"animation"];
//    
//    [view setFrame:NSMakeRect(0, 0, [(IMBDeviceMainPageViewController *)_delegate view].frame.size.width, [(IMBDeviceMainPageViewController *)_delegate view].frame.size.height)];
//    [[(IMBDeviceMainPageViewController *)_delegate view] addSubview:view];
//    [view setWantsLayer:YES];
//    [view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
    
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

#pragma mark rightKeyClick
- (IBAction)doDeleteItem:(id)sender {
    NSLog(@"doDeleteItem");
    [self deleteItems:nil];
}

- (IBAction)doToDeviceItem:(id)sender {
    NSLog(@"doToDeviceItem");
    //    [self toDevice:nil];
}

- (IBAction)doToMacItem:(id)sender {
    NSLog(@"doToMacItem");

    [self toMac:nil];
}

- (IBAction)doToiTunesItem:(id)sender {
    NSLog(@"doToiTunesItem");
    [self toiTunes:nil];
}

- (IBAction)doRefreshItem:(id)sender {

        [self reload:nil];
    
}

- (IBAction)doAddItem:(id)sender {
    [self addItems:nil];
}

- (IBAction)doToiCloudItem:(id)sender {
    //    [self iCloudSyncTransfer:nil];
}

- (IBAction)doUpLoadItem:(id)sender {
    [self upLoad:nil];
}

- (IBAction)doDownLoadItem:(id)sender {
    [self downLoad:nil];
}

- (IBAction)doCreatFolderItem:(id)sender {
    [self createAlbum:nil];
}

//NSMenu的回调函数
- (void)menuWillOpen:(NSMenu *)menu {
    if ([menu.title isEqualToString:@"Add to Playlist"]) {
        [self initPlaylistMenuItem];
    }else if ([menu.title isEqualToString:@"to Device"]) {
        [self initDeviceMenuItem];
    }else if ([menu.title isEqualToString:@"to iCloud"]) {
        [self initiCloudMenuItem];
    }else if ([menu.title isEqualToString:@"to Album"]){
        [self initiCloudPhotoAlbumMenuItem];
    }
}

//- (void)initDeviceMenuItem {
//    IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
//    NSArray *array = [connection getOtherConnectedIPod:_ipod.uniqueKey];
//    NSMutableArray *baseInfoArr = [NSMutableArray array];
//    for (IMBiPod *ipod in array) {
//        if (ipod.infoLoadFinished) {
//            IMBBaseInfo *baseInfo = [connection getDeviceByKey:ipod.uniqueKey];
//            [baseInfoArr addObject:baseInfo];
//        }
//    }
//    if (baseInfoArr.count == 0) {
//        //        [self showAlertText:CustomLocalizedString(@"Nothave_toDevices", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
//        return;
//    }
//    
//    //    [_toDeviceMenuItem setTitle:CustomLocalizedString(@"Menu_ToDevice", nil)];
//    NSMenu *toDeviceMenu = _toDeviceMenuItem.submenu;
//    [toDeviceMenu removeAllItems];
//    [toDeviceMenu setAutoenablesItems:NO];
//    
//    int i = 0;
//    for (IMBBaseInfo *baseInfo in baseInfoArr) {
//        i ++;
//        NSMenuItem *menuItem = nil;
//        NSString *deviceName = baseInfo.deviceName;
//        if (deviceName.length >= 15) {
//            deviceName = [deviceName substringToIndex:15];
//            deviceName = [deviceName stringByAppendingString:@"..."];
//        }
//        menuItem = [[NSMenuItem alloc] initWithTitle:deviceName action:@selector(toDeviceMenuAction:) keyEquivalent:@""];
//        [menuItem setTag:i];
//        [menuItem setKeyEquivalent:baseInfo.uniqueKey];
//        [menuItem setTarget:self];
//        [menuItem setEnabled:YES];
//        
//        [toDeviceMenu addItem:menuItem];
//        
//        [menuItem release];
//    }
//}

- (void)toDeviceMenuAction:(id)sender{
//    NSMenu *menu = _toDeviceMenuItem.submenu;
//    for (NSMenuItem *menuItem in menu.itemArray) {
//        if (menuItem == sender) {
//            IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
//            IMBBaseInfo *baseInfo = [connection getDeviceByKey:menuItem.keyEquivalent];
//            if (baseInfo != nil) {
//                [self onItemClicked:baseInfo];
//                break;
//            }
//        }
//    }
}

- (void)initPlaylistMenuItem {
//    NSMenu *submenu = _addToPlaylistMenuItem.submenu;
//    [submenu removeAllItems];
//    
//    if (_playlistArray != nil ) {
//        if (_playlistArray.count> 0) {
//            if (![[_playlistArray objectAtIndex:0] isKindOfClass:[IMBBookmarkEntity class]]) {
//                for (int i = 0; i < _playlistArray.count; i++) {
//                    IMBPlaylist *pl = [_playlistArray objectAtIndex:i];
//                    if ([pl isUserDefinedPlaylist]) {
//                        NSMenuItem *item = [[NSMenuItem alloc] init];
//                        item.title = pl.name;
//                        item.tag = i;
//                        [item setTarget:self];
//                        [item setAction:@selector(doAddToPlaylist:)];
//                        [submenu addItem:item];
//                        [item release];
//                    }
//                }
//            };
//        }
//    }
}

- (void)doAddToPlaylist:(id)sender {
    int row = (int)[sender tag];
    IMBPlaylist *pl = [_playlistArray objectAtIndex:row];
    if (pl != nil) {
        [self addToPlaylist:pl.iD];
    }
}

#pragma mark - 将歌曲添加到指定播放列表
- (void)addToPlaylist:(long long)playlistID{
    
}

- (void)reloadTableView{
    if (_itemTableView != nil) {
        _isSearch = NO;
        [_itemTableView reloadData];
        
    }else if (_collectionView != nil){
        _isSearch = NO;
        [self loadCollectionView:NO];
    }
}

- (void)loadCollectionView:(BOOL)isFrist{
    return;
}

- (void)ShowWindowControllerCategory {
    return;
}

// 检查备份是否被加密
- (BOOL)checkBackupEncrypt {
    BOOL isEncrypt = [[_iPod.deviceHandle deviceValueForKey:@"WillEncrypt" inDomain:@"com.apple.mobile.backup"] boolValue];
    return isEncrypt;
}
//android  检测备份加密
- (BOOL)AndroidCheckBackupEncrypt:(IMBiPod *)ipod {
    BOOL isEncrypt = [[ipod.deviceHandle deviceValueForKey:@"WillEncrypt" inDomain:@"com.apple.mobile.backup"] boolValue];
    return isEncrypt;
}

//检查网络和服务器是否正常连接
- (BOOL) checkInternetAvailble {
    //    if (![MediaHelper isInternetAvail]) {
    //        [self showAlertText:CustomLocalizedString(@"IMBTrans_NO_Internet_MSG", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    //        return false;
    //    }
    //
    //    if (![TempHelper checkInternetAvailble]) {
    //        [self showAlertText:CustomLocalizedString(@"IMBTrans_Server_Not_Avail_MSG", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    //        return false;
    //    }
    return true;
}

//屏蔽按钮
- (void)disableFunctionBtn:(BOOL)isDisable {
    if ([_delegate respondsToSelector:@selector(disableFunctionBtn:)]) {
        [_delegate disableFunctionBtn:isDisable];
    }
}

- (void)refeash {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
        [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
    }
}

//- (long long)checkNeedAnnoy:(NSViewController **)annoyVC;
//{
//    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
//    _endRunloop = NO;
//    if (!soft.isRegistered) {
//        OperationLImitation *limit = [OperationLImitation singleton];
//        long long redminderCount = (long long)limit.remainderCount;
//        //弹出骚扰窗口
//        (*annoyVC) = [[IMBAnnoyViewController alloc] initWithNibName:@"IMBAnnoyViewController" Delegate:self Result:&redminderCount];
//        ((IMBAnnoyViewController *)(*annoyVC)).category = _category;
//        ((IMBAnnoyViewController *)(*annoyVC)).isClone = _isClone;
//        ((IMBAnnoyViewController *)(*annoyVC)).isMerge = _isMerge;
//        ((IMBAnnoyViewController *)(*annoyVC)).isContentToMac = _isContentToMac;
//        ((IMBAnnoyViewController *)(*annoyVC)).isAddContent = _isAddContent;
//        [(*annoyVC).view setFrameSize:NSMakeSize(NSWidth([(IMBBaseViewController *)_delegate view].frame), NSHeight([(IMBBaseViewController *)_delegate view].frame))];
//        [(*annoyVC).view setWantsLayer:YES];
//        [[(IMBBaseViewController *)_delegate view] addSubview:(*annoyVC).view];
//        [(*annoyVC).view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-(*annoyVC).view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
//        NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
//        NSInteger result1 = NSRunContinuesResponse;
//        while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
//        {
//            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//        }
//        [NSApp endModalSession:session];
//        _endRunloop = NO;
//        return redminderCount;
//    }else{
//        return -1;
//    }
//}

-(void)getFileNames:(NSArray *)fileNames byFileExtensions:(NSArray *)fileExtensions toArray:(NSMutableArray *)array{
    @autoreleasepool {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        for (NSString *string in fileNames) {
            if ([[fileManager attributesOfItemAtPath:string error:nil] fileType] == NSFileTypeDirectory) {
                NSError *error = nil;
                NSArray *items = [fileManager subpathsOfDirectoryAtPath:string error:&error];
                if (error != nil) {
                    NSLog(@"error:%@",error);
                }
                for (NSString *path in items) {
                    path = [string stringByAppendingPathComponent:path];
                    //                    if (array.count >= 1000) {
                    //                        break;
                    //                    }
                    NSString *extension = [path pathExtension].lowercaseString;
                    if ([fileExtensions containsObject:extension]) {
                        [array addObject:path];
                    }
                }
            }
            else{
                //                if (array.count >= 1000) {
                //                    break;
                //                }
                NSString *extension = [string pathExtension].lowercaseString;
                if(extension.length > 0 && [fileExtensions containsObject:extension]){
                    [array addObject:string];
                }
            }
        }
    }
}

//- (int)addAppTodevice:(IMBiPod *)targetiPod withSourceAppArray:(NSMutableArray *)sourceApps{
//    //判断选择的分类中是否包含App
//    NSArray *sourceAppArray = [sourceApps retain];
//    NSArray *targetAppArray = targetiPod.applicationManager.appEntityArray;
//    NSMutableArray *downAppM = [[NSMutableArray alloc]init];
//    for (IMBAppEntity *app in sourceAppArray) {
//        int i = 0;
//        for (IMBAppEntity *targetApp in targetAppArray) {
//            if ([targetApp.appKey isEqualToString:app.appKey]) {
//                i = 1;
//                break;
//            }
//        }
//        if (i == 0) {
//            [downAppM addObject:app];
//        }
//    }
//    [sourceAppArray release];
//    if (downAppM.count == 0) {
//        return 1;
//    }
//    
//    BOOL version = NO;
//    if ([targetiPod.deviceInfo.getDeviceFloatVersionNumber isVersionMajorEqual:@"8.3"] || [_ipod.deviceInfo.getDeviceFloatVersionNumber isVersionMajorEqual:@"8.3"]) {
//        version = YES;
//    }
//    
//    if (downAppM.count > 0 && version) {
//        NSView *view = nil;
//        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
//            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
//                view = subView;
//                break;
//            }
//        }
//        [view setHidden:NO];
//        NSString *str = nil;
//        if (downAppM.count <= 1) {
//            str = [NSString stringWithFormat:CustomLocalizedString(@"Above9AppToDeviceTipsSin", nil),targetiPod.deviceInfo.deviceName,targetiPod.deviceInfo.deviceName];
//        }else {
//            str = [NSString stringWithFormat:CustomLocalizedString(@"Above9AppToDeviceTipsDou", nil),targetiPod.deviceInfo.deviceName,targetiPod.deviceInfo.deviceName];
//        }
//        [_mergeCloneAppVC setIsToDevice:YES];
//        [_mergeCloneAppVC setSourceApps:downAppM];
//        int i = [_mergeCloneAppVC showTitleString:str OkButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) TargetiPod:targetiPod sourceiPod:_ipod SuperView:view];
//        if (i == 0) {
//            return 0;
//        }
//    }else {
//        return 1;
//    }
//    return 0;
//}

//- (void)loadLoadingView:(NSBox *)rootBox {
//    _loadingView = [[LoadingView alloc] initWithFrame:rootBox.bounds];
//    [_loadingView startAnimation];
//}
//
//- (void)removeLoadingView {
//    [_loadingView endAnimation];
//    [_loadingView release];
//    _loadingView = nil;
//}

- (void)closeOpenPanel:(NSNotification *)noti {
    if ([noti.object isEqualToString:_iPod.uniqueKey] && _openPanel != nil && _isOpen) {
        [_openPanel cancel:nil];
        _openPanel = nil;
    }
}

- (void)reloadData {
    return;
}

- (void)cancelReload {
    return;
}

#pragma mark - 设备选择按钮事件
- (void)onItemClickedd:(NSString *)account
{
    //        if ([account isEqualToString:CustomLocalizedString(@"icloud_addAcount", nil)]) {
    ////            [self cleanTextField];
    ////            [devPopover close];
    ////            [_rootBox setContentView:_icloudLogView];
    ////            [self.view setBounds:_rootBox.bounds];
    //            return;
    //        }
    //        [_appleID release];
    //        _appleID = [account retain];
    //        [self setiCloudTitle];
    //        NSDictionary *iCloudDic = [_delegate getiCloudAccountViewCollection];
    //        _otheriCloudManager = [[iCloudDic objectForKey:account] iCloudManager];
    //        IMBiCloudMainPageViewController *icloudMainPage = [_iCloudDic objectForKey:account];
    //        //    [icloudMainPage setCookieStorage];
    //        [_rootBox setContentView:icloudMainPage.view];
    //        [icloudMainPage.view setBounds:_rootBox.bounds];
    //        [_devPopover close];
    
    //        for (NSString *str in iCloudDic.allKeys) {
    //            IMBBaseInfo *base = [[IMBBaseInfo alloc]init];
    //            base.isSelected = NO;
    //            i++;
    //            base.uniqueKey = [NSString stringWithFormat:@"%d",i];
    //            base.deviceName = str;
    //            if (![str isEqualToString:_iCloudManager.netClient.loginInfo.appleID]) {
    //                [allDevice addObject:base];
    //            }
    //            [base release];
    //        }
    //    }
}

- (NSData *)readFileData:(NSString *)filePath {
    if (![_iPod.fileSystem fileExistsAtPath:filePath]) {
        return nil;
    }
    else{
        long long fileLength = [_iPod.fileSystem getFileLength:filePath];
        AFCFileReference *openFile = [_iPod.fileSystem openForRead:filePath];
        const uint32_t bufsz = 10240;
        char *buff = (char*)malloc(bufsz);
        NSMutableData *totalData = [[[NSMutableData alloc] init] autorelease];
        while (1) {
            
            uint64_t n = [openFile readN:bufsz bytes:buff];
            if (n==0) break;
            //将字节数据转化为NSdata
            NSData *b2 = [[NSData alloc]
                          initWithBytesNoCopy:buff length:n freeWhenDone:NO];
            [totalData appendData:b2];
            [b2 release];
        }
        free(buff);
        [openFile closeFile];
        return totalData;
    }
}

- (BOOL)isFindMyiCloud:(AMDevice *)device
{
    bool isFindMyDevice = false;
    @try {
        isFindMyDevice = [[device deviceValueForKey:@"IsAssociated" inDomain:@"com.apple.fmip"] boolValue];
    }
    @catch (NSException *exception) {
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"Android Get IsAssociated exception %@", exception.reason]];
    }
    return isFindMyDevice;
}

-(void)showAlert{
//    if (_alertViewController.isIcloudOneOpen) {
//        _isPause = YES;
//        [self showiCloudAnnoyAlertTitleText:CustomLocalizedString(@"iclouddriver_annoyView_titleStr", nil) withSubStr:CustomLocalizedString(@"iclouddriver_annoyView_subtitleStr", nil) withImageName:@"iCloud_pause" buyButtonText:CustomLocalizedString(@"harassment_buyBtn", nil) CancelButton:CustomLocalizedString(@"iCloudBackup_View_Tips3", nil)];
//    }
}

- (void)cancelTimerData{
    if (_annoyTimer != nil) {
        [_annoyTimer invalidate];
        _annoyTimer = nil;
    }
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


- (void)refresh:(IMBInformation *)information {
    
}

- (void)toMac:(IMBInformation *)information {
    
}

- (void)addToDevice:(IMBInformation *)information {
    
}

- (void)deleteItem:(IMBInformation *)information {
    
}

- (void)toDevice:(IMBInformation *)information {
    
}

- (void)doEdit:(IMBInformation *)information {

}

#pragma mark - select android calendar data

-(void)dealloc {
    if (_annoyTimer != nil) {
        [_annoyTimer invalidate];
        _annoyTimer = nil;
    }
    if (_researchdataSourceArray != nil) {
        [_researchdataSourceArray release];
        _researchdataSourceArray = nil;
    }
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
    
    [_iPod release],_iPod = nil;
    [_delArray release],_delArray = nil;
    [_playlistArray release],_playlistArray = nil;
    [_dataSourceArray release],_dataSourceArray = nil;
//    [_transferController release],_transferController = nil;
    [_exportSetting release],_exportSetting = nil;
    [camera release], camera = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DeviceDisConnectedNotification object:nil];
    [super dealloc];
}
@end
