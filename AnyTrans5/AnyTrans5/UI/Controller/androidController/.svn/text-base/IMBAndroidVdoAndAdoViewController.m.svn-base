//
//  IMBAndroidVdoAndAdoViewController.m
//  AnyTrans
//
//  Created by smz on 17/7/18.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBAndroidVdoAndAdoViewController.h"
#import "IMBCustomHeaderCell.h"
#import "IMBADAudioTrack.h"
#import "IMBADVideoTrack.h"
#import "IMBHelper.h"
#import "IMBNotificationDefine.h"
#import "IMBAndroidMainPageViewController.h"
#import "IMBCenterTextFieldCell.h"
@implementation IMBAndroidVdoAndAdoViewController

- (id)initwithAndroid:(IMBAndroid *)android withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    if (self == [super initwithAndroid:android withCategoryNodesEnum:category withDelegate:delegate]) {
        if (category == Category_Movies) {
            
          _dataSourceArray = [[android getVideoContent].reslutArray retain];
        } else if (category == Category_Music) {
            
            _dataSourceArray = [[android getAudioContent].reslutArray retain];
        } else if (category == Category_Ringtone) {
            
            _dataSourceArray = [[android getRingtoneContent].reslutArray retain];
        }
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)doChangeLanguage:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setNoDataViewImageAndText];
        [super doChangeLanguage:notification];
        
    });
    
}

- (void)changeSkin:(NSNotification *)notification {
    [self setNoDataViewImageAndText];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view  setNeedsDisplay:YES];
    [_loadingView setNeedsDisplay:YES];
    [_loadingAnimationView setNeedsDisplay:YES];
}

-(void)awakeFromNib{
     _isAndroid = YES;
    [super awakeFromNib];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [_videoItemTableView setDelegate:self];
    [_videoItemTableView setDataSource:self];
    [_videoItemTableView setListener:self];
    [_videoItemTableView.menu setDelegate:self];
    [_audioItemTableView setDelegate:self];
    [_audioItemTableView setDataSource:self];
    [_audioItemTableView setListener:self];
    [_audioItemTableView.menu setDelegate:self];

    [_videoItemTableView setBackgroundColor:[NSColor clearColor]];
    [_audioItemTableView setBackgroundColor:[NSColor clearColor]];
    if (_category == Category_Music || _category == Category_Ringtone) {
        if (_dataSourceArray.count <= 0) {
            
            [self setNoDataViewImageAndText];
            [_mainBox setContentView:_noDataView];
        } else {
            [_mainBox setContentView:_audioView];
        }
        
        
    }else if (_category == Category_Movies) {
        
        if (_dataSourceArray.count <= 0) {
            
            [self setNoDataViewImageAndText];
            [_mainBox setContentView:_noDataView];
        } else {
            [_mainBox setContentView:_videoView];
        }
    }
    [_audioItemTableView.checkBoxCell.checkButton setHidden:NO];
    [_videoItemTableView.checkBoxCell.checkButton setHidden:NO];
}

- (void)setNoDataViewImageAndText {
    NSString *promptStr = @"";
    NSString *promptStr1 = @"";
    NSString *overStr1 = CustomLocalizedString(@"noData_subTitle1", nil);
    if (_category == Category_Movies) {
        [_noDataImage setImage:[NSImage imageNamed:@"nodata_ad_movies"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_82", nil)];
        promptStr1 = [[[NSString stringWithFormat:CustomLocalizedString(@"noData_subTitle", nil),CustomLocalizedString(@"MenuItem_id_82", nil)] stringByAppendingString:@" "] stringByAppendingString:overStr1];
        
    } else if (_category == Category_Music) {
        [_noDataImage setImage:[NSImage imageNamed:@"noData_audio"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_28", nil)];
        promptStr1 = [[[NSString stringWithFormat:CustomLocalizedString(@"noData_subTitle", nil),CustomLocalizedString(@"MenuItem_id_28", nil)] stringByAppendingString:@" "] stringByAppendingString:overStr1];
    } else if (_category == Category_Ringtone) {
        [_noDataImage setImage:[NSImage imageNamed:@"noData_audio"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_79", nil)];
        promptStr1 = [[[NSString stringWithFormat:CustomLocalizedString(@"noData_subTitle", nil),CustomLocalizedString(@"MenuItem_id_79", nil)] stringByAppendingString:@" "] stringByAppendingString:overStr1];
    }
    [_noDataText setDelegate:self];
    [_noDataTextTwo setDelegate:self];
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_noDataText setLinkTextAttributes:linkAttributes];
    [_noDataText setSelectable:NO];
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_noDataText textStorage] setAttributedString:promptAs];
    
    
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

#pragma mark - tableViewDataSource

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_isSearch) {
        if (_researchdataSourceArray.count != 0) {
            return _researchdataSourceArray.count;
        }else{
            return 0;
        }
    }else if (_dataSourceArray.count != 0) {
        return _dataSourceArray.count;
    }else{
        return 0;
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (_category == Category_Music || _category == Category_Ringtone) {
        IMBADAudioTrack *audioTrack = nil;
        if (_isSearch) {
            audioTrack = [_researchdataSourceArray objectAtIndex:row];
        }else{
            audioTrack = [_dataSourceArray objectAtIndex:row];
        }
        if ([tableColumn.identifier isEqualToString:@"Name"]) {
            return audioTrack.title;
        }else if ([tableColumn.identifier isEqualToString:@"CheckCol"]){
            return [NSNumber numberWithInt:audioTrack.checkState];
        }else if ([tableColumn.identifier isEqualToString:@"Size"]){
            return [IMBHelper getFileSizeString:audioTrack.size reserved:2];
        }else if ([tableColumn.identifier isEqualToString:@"Time"]){
            return [IMBHelper getTimeAutoShowHourString:audioTrack.time];
        }else if ([tableColumn.identifier isEqualToString:@"Artist"]){
            return audioTrack.singer;
        }else if ([tableColumn.identifier isEqualToString:@"Album"]){
            return audioTrack.album;
        }
    } else {
        IMBADVideoTrack *videoTrack = nil;
        if (_isSearch) {
            videoTrack = [_researchdataSourceArray objectAtIndex:row];
        }else{
            videoTrack = [_dataSourceArray objectAtIndex:row];
        }
        if ([tableColumn.identifier isEqualToString:@"Name"]) {
            return videoTrack.title;
        }else if ([tableColumn.identifier isEqualToString:@"CheckCol"]){
            return [NSNumber numberWithInt:videoTrack.checkState];
        }else if ([tableColumn.identifier isEqualToString:@"Size"]){
            return [IMBHelper getFileSizeString:videoTrack.size reserved:2];
        }else if ([tableColumn.identifier isEqualToString:@"Time"]){
            return [IMBHelper getTimeAutoShowHourString:videoTrack.time];
        }else if ([tableColumn.identifier isEqualToString:@"Artist"]){
            return videoTrack.singer;
        }else if ([tableColumn.identifier isEqualToString:@"Album"]){
            return videoTrack.album;
        }
    }
    return @"";
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if (_category == Category_Music) {
        if ([[tableColumn identifier] isEqualToString:@"Name"]) {
            IMBCenterTextFieldCell *boxCell = (IMBCenterTextFieldCell *)cell;
            IMBADAudioTrack *audioTrack = nil;
            NSArray *displayArr = nil;
            if (_isSearch) {
                displayArr = _researchdataSourceArray;
            }else{
                displayArr = _dataSourceArray;
            }
            audioTrack = [_dataSourceArray objectAtIndex:row];
            boxCell.entity = audioTrack;
            boxCell.category = _category;
        }
    }else if (_category == Category_Movies) {
        if ([[tableColumn identifier] isEqualToString:@"Name"]) {
            IMBCenterTextFieldCell *boxCell = (IMBCenterTextFieldCell *)cell;
            NSArray *displayArr = nil;
            if (_isSearch) {
                displayArr = _researchdataSourceArray;
            }else{
                displayArr = _dataSourceArray;
            }
            IMBADVideoTrack *videoTrack = nil;
            videoTrack = [_dataSourceArray objectAtIndex:row];
            boxCell.entity = videoTrack;
            boxCell.category = _category;
        }
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 40;
}

-(void)tableView:(NSTableView *)tableView row:(NSInteger)index{
    
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else{
        displayArr = _dataSourceArray;
    }
    int checkCount = 0;
    int unCheckCount = 0;
    if (_category == Category_Music || _category == Category_Ringtone) {
        IMBADAudioTrack *appEntity = [displayArr objectAtIndex:index];
        appEntity.checkState = !appEntity.checkState;
        for (IMBADAudioTrack *trackData in displayArr) {
            if (trackData.checkState == Check) {
                checkCount ++;
            } else if (trackData.checkState == UnChecked) {
                unCheckCount ++;
            }
        }
        if (checkCount == displayArr.count) {
            [_audioItemTableView changeHeaderCheckState:Check];
        } else if (unCheckCount == displayArr.count) {
            [_audioItemTableView changeHeaderCheckState:UnChecked];
        } else {
            [_audioItemTableView changeHeaderCheckState:SemiChecked];
        }
    } else {
        IMBADVideoTrack *appEntity = [displayArr objectAtIndex:index];
        if (appEntity.checkState == SemiChecked) {
            appEntity.checkState = Check;
        }else{
            appEntity.checkState = !appEntity.checkState;
        }
        for (IMBADVideoTrack *trackData in displayArr) {
            if (trackData.checkState == Check) {
                checkCount ++;
            } else if (trackData.checkState == UnChecked) {
                unCheckCount ++;
            }
        }
        if (checkCount == displayArr.count) {
            [_videoItemTableView changeHeaderCheckState:Check];
        } else if (unCheckCount == displayArr.count) {
            [_videoItemTableView changeHeaderCheckState:UnChecked];
        } else {
            [_videoItemTableView changeHeaderCheckState:SemiChecked];
        }
    }
    
    if (_category == Category_Music || _category == Category_Ringtone) {
        [_audioItemTableView reloadData];
    } else {
        [_videoItemTableView reloadData];
    }
}
- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn{
    
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
    
    if ( [@"Name" isEqualToString:identify] ||[@"Time" isEqualToString:identify]||[@"Size" isEqualToString:identify]||[@"Artist" isEqualToString:identify]||[@"Album" isEqualToString:identify]) {
        if ([cell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *customHeaderCell = (IMBCustomHeaderCell *)cell;
            if (customHeaderCell.ascending) {
                customHeaderCell.ascending = NO;
            } else {
            
                customHeaderCell.ascending = YES;
            }
            _isAscending = customHeaderCell.ascending;
            [self sort:customHeaderCell.ascending key:identify dataSource:_dataSourceArray];
            
        }
        
    }else{
        return;
    }
}
#pragma mark - 排序
- (void)sort:(BOOL)isAscending key:(NSString *)key dataSource:(NSMutableArray *)array{
    
    NSSortDescriptor *sortDescriptor = nil;
    if ([key isEqualToString:@"Name"]) {
        key = @"title";
        sortDescriptor = [IMBChineseSortHelper creatChineseSortDescriptorWithkey:key WithAscending:_isAscending];
    } else if ([key isEqualToString:@"Time"]){
        key = @"time";
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:_isAscending];
    } else if ([key isEqualToString:@"Size"]){
        key = @"size";
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:_isAscending];
    } else if ([key isEqualToString:@"Artist"]){
        key = @"singer";
        sortDescriptor = [IMBChineseSortHelper creatChineseSortDescriptorWithkey:key WithAscending:_isAscending];
    } else if ([key isEqualToString:@"Album"]){
        key = @"album";
        sortDescriptor = [IMBChineseSortHelper creatChineseSortDescriptorWithkey:key WithAscending:_isAscending];
    }
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    if (_category == Category_Music || _category == Category_Ringtone) {
        [_audioItemTableView reloadData];
    } else {
        [_videoItemTableView reloadData];
    }
    [sortDescriptor release];
    [sortDescriptors release];
}

#pragma mark - 全选
- (void)setselectState:(CheckStateEnum)state WithTableView:(NSTableView *)tableView {
    
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else{
        displayArr = _dataSourceArray;
    }
    if (displayArr.count <= 0) {
        return;
    }
    if (tableView.tag == 0) {
        for (int i=0;i<[displayArr count]; i++) {
            IMBADAudioTrack *entity = [displayArr objectAtIndex:i];
            [entity setCheckState:state];
            
        }
        [_audioItemTableView reloadData];
    } else if(tableView.tag == 1) {
        
        for (int i=0;i<[displayArr count]; i++) {
            IMBADVideoTrack *entity = [displayArr objectAtIndex:i];
            [entity setCheckState:state];
            
        }
        [_videoItemTableView reloadData];
    }
}

#pragma mark - search
- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn {
    
    _searchFieldBtn = searchBtn;
    if (![IMBHelper stringIsNilOrEmpty:searchStr]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray filteredArrayUsingPredicate:predicate]];
        _isSearch = YES;
        [self loadCheckBoxState];
    }else {
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
        [self loadCheckBoxState];
    }
    
    if (_category == Category_Music || _category == Category_Ringtone) {
        [_audioItemTableView reloadData];
    } else {
        [_videoItemTableView reloadData];
    }
}

#pragma mark - refresh
- (void)androidReload:(id)sender {
    
    [self disableFunctionBtn:NO];
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    [_searchFieldBtn.searchField setEnabled:NO];
    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    
    //检查apk是否赋予权限
    if (_delegate != nil && [_delegate respondsToSelector:@selector(checkDeviceGreantedPermission:)] ) {
        [_delegate checkDeviceGreantedPermission:ReloadFunctionType];
    }
}

- (void)reloadData {
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    
    if (_category == Category_Music) {
        [_android setCategory:Category_Music];
        [_android queryDoucmentDetailInfo];
        [_android queryAudioDetailInfo];
        
        _dataSourceArray = [[_android getAudioContent].reslutArray retain];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self disableFunctionBtn:YES];
            [_searchFieldBtn.searchField setEnabled:YES];
            if (_dataSourceArray.count <= 0) {
                [self setNoDataViewImageAndText];
                [_mainBox setContentView:_noDataView];
            } else {
                [_mainBox setContentView:_audioView];
                [_audioItemTableView changeHeaderCheckState:UnChecked];
                [_audioItemTableView reloadData];
            }
            [_loadingAnimationView endAnimation];
            if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
            }
            
        });
    } else if (_category == Category_Movies) {
        
        [_android setCategory:Category_Movies];
        [_android queryDoucmentDetailInfo];
        [_android queryVideoDetailInfo];
        
        _dataSourceArray = [[_android getVideoContent].reslutArray retain];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self disableFunctionBtn:YES];
            [_searchFieldBtn.searchField setEnabled:YES];
            if (_dataSourceArray.count <= 0) {
                [self setNoDataViewImageAndText];
                [_mainBox setContentView:_noDataView];
            } else {
                [_mainBox setContentView:_videoView];
                [_videoItemTableView changeHeaderCheckState:UnChecked];
                [_videoItemTableView reloadData];
                
            }
            [_loadingAnimationView endAnimation];
            if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
            }
        });
        
    } else if (_category == Category_Ringtone) {
        
        [_android queryRingtoneDetailInfo];
        
        _dataSourceArray = [[_android getRingtoneContent].reslutArray retain];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self disableFunctionBtn:YES];
            [_searchFieldBtn.searchField setEnabled:YES];
            if (_dataSourceArray.count <= 0) {
                [self setNoDataViewImageAndText];
                [_mainBox setContentView:_noDataView];
            } else {
                [_mainBox setContentView:_audioView];
                [_audioItemTableView changeHeaderCheckState:UnChecked];
                [_audioItemTableView reloadData];
            }
            [_loadingAnimationView endAnimation];
            if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
            }
        });
    }
}

- (void)cancelReload {
    if (_dataSourceArray.count <= 0) {
        [self setNoDataViewImageAndText];
        [_mainBox setContentView:_noDataView];
    } else {
        [_mainBox setContentView:_audioView];
    }
    [self disableFunctionBtn:YES];
    [_searchFieldBtn.searchField setEnabled:YES];
    [_loadingAnimationView endAnimation];
}

#pragma mark - 更新CheckBox的状态
- (void)loadCheckBoxState {
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else{
        displayArr = _dataSourceArray;
    }
    if (displayArr.count == 0) {
        return;
    }
    int checkCount = 0;
    int unCheckCount = 0;
    if (_category == Category_Music || _category == Category_Ringtone) {
        for (IMBADAudioTrack *trackData in displayArr) {
            if (trackData.checkState == Check) {
                checkCount ++;
            } else if (trackData.checkState == UnChecked) {
                unCheckCount ++;
            }
        }
        if (checkCount == displayArr.count) {
            [_audioItemTableView changeHeaderCheckState:Check];
        } else if (unCheckCount == displayArr.count || displayArr.count == 0) {
            [_audioItemTableView changeHeaderCheckState:UnChecked];
        } else {
            [_audioItemTableView changeHeaderCheckState:SemiChecked];
        }
    } else {
        for (IMBADVideoTrack *trackData in displayArr) {
            if (trackData.checkState == Check) {
                checkCount ++;
            } else if (trackData.checkState == UnChecked) {
                unCheckCount ++;
            }
        }
        if (checkCount == displayArr.count) {
            [_videoItemTableView changeHeaderCheckState:Check];
        } else if (unCheckCount == displayArr.count || displayArr.count == 0) {
            [_videoItemTableView changeHeaderCheckState:UnChecked];
        } else {
            [_videoItemTableView changeHeaderCheckState:SemiChecked];
        }
    }
}

#pragma mark - 返回按钮
- (void)doBack:(id)sender {
    [super doBack:sender];
    if (_searchFieldBtn != nil) {
        [self doSearchBtn:nil withSearchBtn:_searchFieldBtn];
    }
}

- (void)menuWillOpen:(NSMenu *)menu {
    [self initAndroidDeviceMenuItem];
}


@end
