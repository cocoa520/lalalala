//
//  IMBPhotosListViewController.m
//  iMobieTrans
//
//  Created by iMobie on 7/29/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBPhotosListViewController.h"
#import "IMBImageAndTextCell.h"
#import "IMBFileSystem.h"
//#import "IMBColorDefine.h"
#import "IMBCustomHeaderCell.h"
//#import "IMBPhotosPreviewWindowController.h"

@interface IMBPhotosListViewController ()

@end

@implementation IMBPhotosListViewController
@synthesize curEntity = _curEntity;
@synthesize icloudPhotoDelegate = _icloudPhotoDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithiPod:(IMBiPod *)ipod category:(CategoryNodesEnum)category {
    if ([super initWithNibName:@"IMBPhotosListViewController" bundle:nil]) {
        _iPod = ipod;
        _category = category;
    }
    return self;
}


- (void)dealloc
{
    if (queue != nil) {
        [queue release];
        queue = nil;
    }
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    IMBInformationManager *inforManager = [IMBInformationManager shareInstance];
    _information = [inforManager.informationDic objectForKey:_iPod.uniqueKey];
    if (_category == Category_Media) {
        _dataSourceArray = [_information.mediaArray retain];
    }else if (_category == Category_Video) {
        _dataSourceArray = [_information.videoArray retain];
    }else if (_category == Category_iBooks) {
        _dataSourceArray = [_information.allBooksArray retain];
    }else if (_category == Category_Applications) {
        _dataSourceArray = [_information.appArray retain];
    }else if (_category == Category_System) {
        
    }else if (_category == Category_PhotoStream||_category == Category_PhotoLibrary||_category == Category_CameraRoll) {
        _dataSourceArray = [_information.allPhotoArray retain];
    }
    
    if (_dataSourceArray.count == 0) {
        [_noDataLable setHidden:YES];
        [_noDataView setFrame:NSMakeRect(0, 0, 1000, 534)];
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_noDataLable setHidden:YES];
        [_mainBox setContentView:_containTableView];
    }

    _tqueue = dispatch_queue_create("com.ConcurrentQueue.list", NULL);
    [_itemTableView setTarget:self];
    [_itemTableView setAction:@selector(openFullImageFormTab:)];
    queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:8];
    [_itemTableView setListener:self];
    //屏蔽排序图片
    NSTableColumn *column = [_itemTableView tableColumnWithIdentifier:@"Image"];
    IMBCustomHeaderCell *columnHeaderCell = (IMBCustomHeaderCell *) column.headerCell;
    [columnHeaderCell setIsShowTriangle:NO];
    
//    [self reloadListWithSearchString:_seachField.stringValue];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];

    
}

- (void)setTableViewHeadOrCollectionViewCheck{
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    _dataSourceArray = [_information.allPhotoArray retain];
    
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_mainBox setContentView:_containTableView];
    }

    NSIndexSet *set = [self selectedItems];
    [_itemTableView showVisibleRextPhoto];

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

- (void)setTableViewHeadCheckBtn{
    NSIndexSet *set = [self selectedItems];
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

- (void)openFullImageFormTab:(IMBCustomHeaderTableView *)tableView {
 /*   if (tableView == _itemTableView) {
        NSInteger row = [tableView clickedRow];
        if (row == -1) {
            return;
        }
        
        if (tableView.clickNum == 2) {
            IMBPhotoEntity *entity = [_itemArray objectAtIndex:row];
            if (entity.photoKind == 1) {
//                NSAlert *alert = [NSAlert alertWithMessageText:CustomLocalizedString(@"IMB_Warning", nil) defaultButton:CustomLocalizedString(@"MSG_COM_Confirm_OK", nil) alternateButton:nil otherButton: nil informativeTextWithFormat: CustomLocalizedString(@"IMB_Photo_Video_File", nil)];
//                [alert.window center];
//                [alert runModal];
                return;
            }
            NSMutableArray *preArray = [[NSMutableArray alloc]init];
            if (_itemArray != nil) {
                for (IMBPhotoEntity *pe in _itemArray) {
                    if (pe.photoKind != 1) {
                        [preArray addObject:pe];
                    }
                }
            }
            IMBPhotosPreviewWindowController *photoController = [[IMBPhotosPreviewWindowController alloc] initWithArray:preArray withIpod:_ipod WithPhotoEntity:entity];
            [NSApp runModalForWindow:[photoController window]];
            [photoController release];
            [preArray release];
        }
    }*/
}

#pragma mark - NSTextView
- (void)configNoDataView {
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_photo"]];
    [_textView setDelegate:self];
    NSString *promptStr = @"";
    NSString *overStr  = CustomLocalizedString(@"NO_DATA_TITLE_2", nil);
    if (_category == Category_CameraRoll) {
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)];
        [_textView setSelectable:NO];
    }else if (_category == Category_PhotoStream) {
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)];
        [_textView setSelectable:NO];
    }else if (_category == Category_PhotoLibrary) {
        promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)] stringByAppendingString:overStr];
        [_textView setSelectable:YES];
    }else if (_category == Category_PhotoVideo) {
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_24", nil)];
        [_textView setSelectable:NO];
    }else if (_category == Category_Panoramas) {
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)];
        [_textView setSelectable:NO];
    }else if (_category == Category_TimeLapse) {
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_29", nil)];
        [_textView setSelectable:NO];
    }else if (_category == Category_SlowMove) {
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_29", nil)];
        [_textView setSelectable:NO];
    }else if (_category == Category_MyAlbums || _category == Category_PhotoShare || _category == Category_ContinuousShooting) {
        if (_curEntity.albumType == SyncAlbum) {
            promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)] stringByAppendingString:overStr];
            [_textView setSelectable:YES];
        }else {
            promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)];
            [_textView setSelectable:NO];
        }
    }else if (_category == Category_Photo){
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"DeviceView_id_6", nil)];
        [_textView setSelectable:NO];
    }else if (_category == Category_LivePhoto || _category == Category_Screenshot|| _category == Category_PhotoSelfies|| _category == Category_Location|| _category == Category_Favorite){
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_77", nil)];
        [_textView setSelectable:NO];
    }

    [_noDataLable setStringValue:promptStr];
    [_noDataLable setTextColor:IMBGrayColor(201)];
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName:IMBGrayColor(201), (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_textView setLinkTextAttributes:linkAttributes];
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0f] withColor:IMBGrayColor(201)];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = [promptStr rangeOfString:overStr];
    [promptAs addAttribute:NSLinkAttributeName value:overStr range:infoRange];
    [promptAs addAttribute:NSForegroundColorAttributeName value:IMBGrayColor(201) range:infoRange];
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

#pragma mark - IMBImageRefreshListener
- (void)loadingThumbnilImage:(NSRange)oldVisibleRows withNewVisibleRows:(NSRange)newVisibleRows {
    [queue cancelAllOperations];
    _visibleItems = (NSMutableArray *)[[_dataSourceArray subarrayWithRange:newVisibleRows] retain];
   
    
    NSRange range;
    if (newVisibleRows.location > 10) {
        range = NSMakeRange(0, newVisibleRows.location - 1);
        NSArray *array = [_dataSourceArray subarrayWithRange:range];
        if (array != nil) {
            for (IMBPhotoEntity *entity in array) {
                @autoreleasepool {
                    if (entity.loadingImage == 0) {
                        entity.photoImage = [StringHelper imageNamed:@"photo_show"];
                    }
                }
            }
        }
    }
    if (newVisibleRows.location + newVisibleRows.length + 10 < _dataSourceArray.count && _dataSourceArray.count > 10) {
        range = NSMakeRange(newVisibleRows.location + newVisibleRows.length + 8, _dataSourceArray.count - 9 - (newVisibleRows.location + newVisibleRows.length));
        NSArray *array = [_dataSourceArray subarrayWithRange:range];
        if (array != nil) {
            for (IMBPhotoEntity *entity in array) {
                @autoreleasepool {
                    if (entity.loadingImage == 0) {
                        entity.photoImage = [StringHelper imageNamed:@"photo_show"];
                    }
                }
            }
        }
    }
    
    if (_visibleItems != nil && _visibleItems.count > 0) {
        for (id entity in _visibleItems) {
            [self loadImage:entity];
        }
    }
    [_visibleItems release];
}

/*
- (void)loadImage:(id)phEntity {
    @synchronized (phEntity) {
        [queue addOperationWithBlock:^(void) {
            @autoreleasepool {
                IMBPhotoEntity *entity = nil;
                if (phEntity && [phEntity isKindOfClass:[IMBPhotoEntity class]]) {
                    entity = (IMBPhotoEntity *)phEntity;
                }
                if (entity.loadingImage == 0) {
                    entity.loadingImage = 1;
                    NSData *data  = nil;
                  
                    data = [[self createImageToTableView:entity] retain];
                    
                    if (data) {
                        NSImage *image = [[NSImage alloc] initWithData:data];
                        if (image) {
                            entity.loadingImage = 2;
                            entity.photoImage = image;
                        }else {
                            entity.loadingImage = 0;
                        }
                        [image release];
                        image = nil;
                        //此线程写图片到本地
                        dispatch_async(_tqueue, ^{
                            @autoreleasepool {
                                if (entity.catchName == nil) {
                                    NSDate *date = [NSDate date];
                                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                    NSString *str = [formatter stringFromDate:date];
                                    NSString *name = [[NSString stringWithFormat:@"%@_%@.jpg",[entity.photoName stringByDeletingPathExtension],str] retain];
                                    entity.catchName = name;
                                    [name release];
                                    name = nil;
                                    [formatter release];
                                    formatter = nil;
                                }
                                NSString *imageCatchBasePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"imageCatch"];
                                NSString *imagefilepath = [imageCatchBasePath stringByAppendingPathComponent:entity.catchName];
                                NSFileManager *fm = [NSFileManager defaultManager];
                                if ([fm fileExistsAtPath:imagefilepath]) {
                                    imagefilepath = [TempHelper getFilePathAlias:imagefilepath];
                                    entity.catchName = [imagefilepath lastPathComponent];
                                }
                                if (![fm fileExistsAtPath:imagefilepath]) {
                                    if ([fm createDirectoryAtPath:imageCatchBasePath withIntermediateDirectories:NO attributes:nil error:nil]) {
                                        [fm createFileAtPath:imagefilepath contents:data attributes:nil];
                                    }else
                                    {
                                        [fm createFileAtPath:imagefilepath contents:data attributes:nil];
                                    }
                                }
                            
                            }
                        });
                    }else {
                        entity.loadingImage = 0;
                    }
                    [data release];
                    data = nil;
                }else if (entity.loadingImage == 2) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *imageCatchBasePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"imageCatch"];
                        NSString *imagefilepath = [imageCatchBasePath stringByAppendingPathComponent:entity.catchName];
                        NSFileManager *fm = [NSFileManager defaultManager];
                        if ([fm fileExistsAtPath:imagefilepath]) {
                            NSData *imageData = [[NSData alloc] initWithContentsOfFile:imagefilepath];
                            NSImage *image = [[NSImage alloc] initWithData:imageData];
                            if (image) {
                                entity.photoImage = image;
                            }
                            [imageData release];
                            imageData = nil;
                            [image release];
                            image = nil;
                        }else {
                            entity.loadingImage = 0;
                            entity.photoImage = [StringHelper imageNamed:@"photo_show"];
                        }
                    });
                }
                [self performSelectorOnMainThread:@selector(reloadRowForTableView:) withObject:entity waitUntilDone:NO modes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                NSLog(@"entity count: %ld", entity.retainCount);
            }
        }];
    }
}
*/

- (void)reloadRowForTableView:(id)object {
    NSInteger row;
    if (_isSearch) {
        row = [_researchdataSourceArray indexOfObject:object];
    }else{
        row = [_dataSourceArray indexOfObject:object];
    }
   
    if (row != NSNotFound) {
        [_itemTableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row] columnIndexes:[NSIndexSet indexSetWithIndex:1]];
    }
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSMutableArray *disPalyAry = nil;
    if (_isSearch) {
        disPalyAry = _researchdataSourceArray;
    }else{
        disPalyAry = _dataSourceArray;
    }
    if (disPalyAry.count <= 0) {
        return 0;
    }
    return [disPalyAry count];
}
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <=0) {
        return @"";
    }
    if (_category == Category_Media || _category == Category_Video) {
        IMBTrack *entity = [displayArray objectAtIndex:row];
        
        if ([@"Name" isEqualToString:tableColumn.identifier] ) {
            return entity.title;
        }
        
        if ([@"TimeDate" isEqualToString:tableColumn.identifier]) {
            return [[StringHelper getTimeString:entity.length] stringByAppendingString:@" "];//[DateHelper dateFrom2001ToString:entity.time withMode:2];
        }
        if ([@"Size" isEqualToString:tableColumn.identifier]) {
            return [StringHelper getFileSizeString:entity.fileSize reserved:2];
        }
        return @"";
    }else if (_category == Category_iBooks) {
        
    }else if (_category == Category_Applications) {
        
    }else if (_category == Category_PhotoStream||_category == Category_PhotoLibrary||_category == Category_CameraRoll) {
        IMBPhotoEntity *entity = [displayArray objectAtIndex:row];
        
        if ([@"Name" isEqualToString:tableColumn.identifier] ) {
            return entity.photoName;
        }
        
        if ([@"Format" isEqualToString:tableColumn.identifier]) {
            return [NSString stringWithFormat:@"%d * %d",entity.photoWidth,entity.photoHeight];
        }
        
        if ([@"TimeDate" isEqualToString:tableColumn.identifier]) {
            return [DateHelper dateFrom2001ToString:entity.photoDateData withMode:2];
        }
        if ([@"Size" isEqualToString:tableColumn.identifier]) {
            return [StringHelper getFileSizeString:entity.photoSize reserved:2];
        }
        if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
            return [NSNumber numberWithInt:entity.checkState];
        }
        return @"";
    }
    return @"";
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
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
    if ([@"Image" isEqualToString:tableColumn.identifier] ) {
    IMBPhotoEntity *entity = [displayArray objectAtIndex:row];
        IMBImageAndTextCell *curCell = (IMBImageAndTextCell*)cell;
        NSImage *image = nil;
        image = [entity.photoImage retain];
        int W = 58;
        int H = 58;
        if (image.size.width >= image.size.height && image.size.height > 0) {
            W = 58;
            H = (int)(((double)image.size.height / image.size.width) * W);
            if (H < 1.0) {
                H = 1;
            }
        }else if (image.size.height > image.size.width && image.size.width > 0) {
            H = 58;
            W = (int)(((double)image.size.width / image.size.height) * H);
            if (W < 1.0) {
                W = 1;
            }
        }
        [curCell setImageSize:NSMakeSize(W, H)];
        curCell.image = image;
        curCell.paddingX = 2;
        curCell.marginX =(58 - W) / 2 + 6;
        if (entity.cloudLocalState == 6) {
            curCell.iCloudImg = [StringHelper imageNamed:@"iCloud_list"];
            curCell.imageName = @"iCloud_list";
        }else {
            curCell.iCloudImg = nil;
        }
        [image release];
        return;
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 64;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    [_itemTableView reloadData];
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    id cell = [tableColumn headerCell];
    NSString *identify = [tableColumn identifier];
    NSArray *array = [tableView tableColumns];
    NSMutableArray *disPalyAry = nil;
    if (_isSearch) {
        disPalyAry = _researchdataSourceArray;
    }else{
        disPalyAry = _dataSourceArray;
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

	if ( [@"Name" isEqualToString:identify] || [@"Format" isEqualToString:identify] || [@"TimeDate" isEqualToString:identify] || [@"Size" isEqualToString:identify] || [@"DocumentSize" isEqualToString:identify] || [@"Format" isEqualToString:identify]|| [@"Genre" isEqualToString:identify] || [@"Rating" isEqualToString:identify]) {
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
            IMBTrack *track = [disPalyAry objectAtIndex:i];
            if (track.checkState == NSOnState) {
                [set addIndex:i];
            }
        }
    }

    [_itemTableView reloadData];
}

- (void)sort:(BOOL)isAscending key:(NSString *)key dataSource:(NSMutableArray *)array {
    if ([key isEqualToString:@"Name"]) {
        key = @"photoName";
    } else if ([key isEqualToString:@"Format"]) {
        key = @"photoWidth";
    }else if ([key isEqualToString:@"TimeDate"]) {
        key = @"photoDateData";
    } else if ([key isEqualToString:@"Size"]) {
        key = @"photoSize";
    } 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    [_itemTableView reloadData];
    
    [sortDescriptor release];
    [sortDescriptors release];
}

#pragma mark - IMBImageRefreshListListener
- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    NSMutableArray *disPalyAry = nil;
    if (_isSearch) {
        disPalyAry = _researchdataSourceArray;
    }else{
        disPalyAry = _dataSourceArray;
    }
    if (disPalyAry.count <=0) {
        return;
    }
    IMBPhotoEntity *entity = [disPalyAry objectAtIndex:index];
    [entity setIsHiddenSelectImage:entity.checkState];
    entity.checkState = !entity.checkState;
    
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[disPalyAry count]; i++) {
        IMBPhotoEntity *item= [disPalyAry objectAtIndex:i];
        if (item.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
    if (entity.checkState == NSOnState) {
        
    }else if (entity.checkState == NSOffState)
    {
        [_itemTableView deselectRow:index];
    }
    
    if (set.count == disPalyAry.count) {
        [_itemTableView changeHeaderCheckState:Check];
    }else if (set.count == 0){
        [_itemTableView changeHeaderCheckState:UnChecked];
    }else{
        [_itemTableView changeHeaderCheckState:SemiChecked];
    }
    [_itemTableView reloadData];
}

- (void)setAllselectState:(CheckStateEnum)checkState {
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }

    for (int i=0;i<[displayArray count]; i++) {
        IMBPhotoEntity *entity = [displayArray objectAtIndex:i];
        [entity setIsHiddenSelectImage:!checkState];
        [entity setCheckState:checkState];
        if (entity.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
    [_itemTableView reloadData];
}

- (NSData *)createImageToTableView:(IMBPhotoEntity *)entity {
    NSString *filePath = nil;
    if (entity.photoKind == 0) {
        if ([_iPod.deviceHandle.productVersion isVersionMajorEqual:@"7"]) {
            if ([_iPod.fileSystem fileExistsAtPath:entity.thumbPath]) {
                filePath = entity.thumbPath;
            }else {
                filePath = entity.allPath;
            }
        }else {
            if ([_iPod.fileSystem fileExistsAtPath:entity.allPath]) {
                filePath = entity.allPath;
            }
        }
    }else if (entity.photoKind == 1) {
        if ([_iPod.deviceHandle.productVersion isVersionMajorEqual:@"7"]) {
            if ([_iPod.fileSystem fileExistsAtPath:entity.thumbPath]) {
                filePath = entity.thumbPath;
            }else {
                filePath = entity.videoPath;
            }
        }else {
            if ([_iPod.fileSystem fileExistsAtPath:entity.videoPath]) {
                filePath = entity.videoPath;
            }
        }
    }
    
    NSData *data = [self readFileData:filePath];
    NSImage *sourceImage = [[NSImage alloc] initWithData:data];
    
    
    NSMutableData *imageData = nil;
    if ([_iPod.deviceHandle.productVersion isVersionMajorEqual:@"7"]) {
        imageData = [(NSMutableData *)[TempHelper scalingImage:sourceImage withLenght:140] retain];
    }else {
        imageData = [(NSMutableData *)[TempHelper createThumbnail:sourceImage withWidth:140 withHeight:140] retain];
    }
    [sourceImage release];
    
    return [imageData autorelease];
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
        if (totalData.length == fileLength) {
           // NSLog(@"success readData 1111");
        }
        free(buff);
        [openFile closeFile];
        return totalData;
    }
}

- (void)changePhotosListLanguage:(NSNotification *)notification {
//    [_itemTableView _setupHeaderCell];
//    [_itemTableView reloadData];
//    if ([_countDelegate respondsToSelector:@selector(reCaulateItemCount)]) {
//        
//        [_countDelegate reCaulateItemCount];
//    }
}

- (void)reload:(id)sender {
    [self disableFunctionBtn:NO];
    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            if (_category == Category_CameraRoll) {
                [_information refreshCameraRoll];
            }else if (_category == Category_PhotoLibrary) {
                [_information refreshPhotoLibrary];
            }else if (_category == Category_PhotoStream){
                [_information refreshPhotoStream];
            }else if (_category == Category_PhotoVideo) {
                [_information refreshVideoAlbum];
            }else if (_category == Category_Panoramas) {
                [_information refreshPanoramas];
            }else if (_category == Category_TimeLapse) {
                [_information refreshTimeLapse];
            }else if (_category == Category_SlowMove){
                [_information refreshSlowMove];
            }else if (_category == Category_LivePhoto) {
                [_information refreshLivePhoto];
            }else if (_category == Category_Screenshot) {
                [_information refreshScreenshot];
            }else if (_category == Category_PhotoSelfies) {
                [_information refreshPhotoSelfies];
            }else if (_category == Category_Location) {
                [_information refreshLocation];
            }else if (_category == Category_Favorite) {
                [_information refreshFavorite];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self disableFunctionBtn:YES];
                [self refresh];
            });
        }
    });
}

- (void)refresh {
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    _isSearch = NO;
    if (_category == Category_CameraRoll) {

        _dataSourceArray=[[_information camerarollArray]retain];
    }else if (_category == Category_PhotoLibrary)
    {
        _dataSourceArray = [[_information photolibraryArray]retain];
    }else if (_category == Category_PhotoStream)
    {
        _dataSourceArray = [[_information photostreamArray]retain];
    }else if (_category == Category_PhotoVideo) {
        _dataSourceArray = [[_information photovideoArray]retain];
    }else if (_category == Category_Panoramas) {
        _dataSourceArray = [[_information panoramasArray]retain];
    }else if (_category == Category_TimeLapse) {
        _dataSourceArray =[[_information timelapseArray]retain];
    }else if (_category == Category_SlowMove) {
        _dataSourceArray = [[_information slowMoveArray]retain];
    }else if (_category == Category_LivePhoto) {
        _dataSourceArray = [_information.livePhotoArray retain];
    }else if (_category == Category_Screenshot) {
        _dataSourceArray = [_information.screenshotArray retain];
    }else if (_category == Category_PhotoSelfies) {
        _dataSourceArray = [_information.photoSelfiesArray retain];
    }else if (_category == Category_Location) {
        _dataSourceArray = [_information.locationArray retain];
    }else if (_category == Category_Favorite) {
        _dataSourceArray = [_information.favoriteArray retain];
    }
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_mainBox setContentView:_containTableView];
        [_itemTableView changeHeaderCheckState:UnChecked];
    }
    if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
//        [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
    }
    [_loadingAnimationView endAnimation];
    [_itemTableView reloadData];
}

#pragma mark - iCloudOperationActions

- (void)dropicloudToTabView:(NSTableView *)tableView paths:(NSArray *)pathArray{
    [_icloudPhotoDelegate dropicloudToTabView:tableView paths:pathArray];


}

- (void)upLoad:(id)sender {
    [_icloudPhotoDelegate upLoad:sender];

}

- (void)icloudDriverError:(NSNotification *)notification{
    
}

- (void)copyInPhotofomationToMac:(NSString *)filePath indexSet:(NSIndexSet *)set{
    [_icloudPhotoDelegate copyInPhotofomationToMac:filePath indexSet:set];

}

- (void)downLoad:(id)sender {
    [_icloudPhotoDelegate downLoad:sender];

}

- (void)onItemiCloudClicked:(id)sender
{
    [_icloudPhotoDelegate onItemiCloudClicked:sender];

}
@end
