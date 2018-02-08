//
//  IMBAndroidDcAndCpAndBkViewController.m
//  AnyTrans
//
//  Created by smz on 17/7/18.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBAndroidDcAndCpAndBkViewController.h"
#import "IMBAndroidMainPageViewController.h"
#import "IMBCenterTextFieldCell.h"
@interface IMBAndroidDcAndCpAndBkViewController ()

@end

@implementation IMBAndroidDcAndCpAndBkViewController

- (id)initwithAndroid:(IMBAndroid *)android withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    if (self == [super initwithAndroid:android withCategoryNodesEnum:category withDelegate:delegate]) {
        if (category == Category_Document) {
            _dataSourceArray = [[android getAppDoucmentContent].reslutArray retain];
        } else if (category == Category_Compressed) {
            _dataSourceArray = [[android getCompressedContent].reslutArray retain];
        } else if (category == Category_iBooks) {
            _dataSourceArray = [[android getiBooksContent].reslutArray retain];
        }
        
        
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark - 多语言切换
- (void)doChangeLanguage:(NSNotification *)notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setNoDataViewImageAndText];
        [super doChangeLanguage:notification];
    });
    
}

#pragma mark - 皮肤切换
- (void)changeSkin:(NSNotification *)notification {
    [self setNoDataViewImageAndText];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [_loadingAniamtionView setNeedsDisplay:YES];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    if (_dataSourceArray.count <= 0) {
        
        [self setNoDataViewImageAndText];
        [_mainBox setContentView:_noDataView];
    } else {
        [_mainBox setContentView:_detailView];
    }
    [_listTableView setDelegate:self];
    [_listTableView setDataSource:self];
    [_listTableView setListener:self];
    _itemTableViewcanDrag = NO;
    _itemTableViewcanDrop = NO;
    [_listTableView setBackgroundColor:[NSColor clearColor]];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [_listTableView.checkBoxCell.checkButton setHidden:NO];
    _listTableView.menu.delegate = self;
    
}

#pragma mark - noData界面加载
- (void)setNoDataViewImageAndText {
    NSString *promptStr = @"";
    NSString *promptStr1 = @"";
    NSString *overStr1 = CustomLocalizedString(@"noData_subTitle1", nil);
    if (_category == Category_Document) {
        [_noDataImage setImage:[NSImage imageNamed:@"nodata_ad_document"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_88", nil)];
        promptStr1 = [[[NSString stringWithFormat:CustomLocalizedString(@"noData_subTitle", nil),CustomLocalizedString(@"MenuItem_id_88", nil)] stringByAppendingString:@" "] stringByAppendingString:overStr1];
    } else if (_category == Category_iBooks) {
        [_noDataImage setImage:[NSImage imageNamed:@"noData_iTunes_book"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_55", nil)];
        promptStr1 = [[[NSString stringWithFormat:CustomLocalizedString(@"noData_subTitle", nil),CustomLocalizedString(@"MenuItem_id_55", nil)] stringByAppendingString:@" "] stringByAppendingString:overStr1];
    } else if (_category == Category_Compressed) {
        [_noDataImage setImage:[NSImage imageNamed:@"nodata_ad_compress"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_87", nil)];
        promptStr1 = [[[NSString stringWithFormat:CustomLocalizedString(@"noData_subTitle", nil),CustomLocalizedString(@"MenuItem_id_87", nil)] stringByAppendingString:@" "] stringByAppendingString:overStr1];
    }
    [_noDataText setDelegate:self];
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
    
        IMBADFileEntity *fileTrack = nil;
        if (_isSearch) {
            fileTrack = [_researchdataSourceArray objectAtIndex:row];
        }else{
            fileTrack = [_dataSourceArray objectAtIndex:row];
        }
        if ([tableColumn.identifier isEqualToString:@"Name"]) {
            return fileTrack.title;
        }else if ([tableColumn.identifier isEqualToString:@"CheckCol"]){
            return [NSNumber numberWithInt:fileTrack.checkState];
        }else if ([tableColumn.identifier isEqualToString:@"Size"]){
            return [IMBHelper getFileSizeString:fileTrack.fileSize reserved:2];
        }else if ([tableColumn.identifier isEqualToString:@"Type"]){
            return fileTrack.fileExtension;
        }else if ([tableColumn.identifier isEqualToString:@"Date"]){
            return [IMBHelper longToDateStringFrom1970:fileTrack.createTime withMode:4];
        }
    
    return @"";
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([[tableColumn identifier] isEqualToString:@"Name"]) {
        IMBCenterTextFieldCell *boxCell = (IMBCenterTextFieldCell *)cell;
        IMBADFileEntity *audioTrack = nil;
        NSArray *displayArr = nil;
        if (_isSearch) {
            displayArr = _researchdataSourceArray;
        }else{
            displayArr = _dataSourceArray;
        }
        audioTrack = [_dataSourceArray objectAtIndex:row];
//        boxCell.entity = audioTrack;
        boxCell.category = _category;
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
    float checkCount = 0;
    float unCheckCount = 0;
        IMBADFileEntity *fileEntity = [displayArr objectAtIndex:index];
        fileEntity.checkState = !fileEntity.checkState;
        for (IMBADFileEntity *fileEntity in displayArr) {
            if (fileEntity.checkState == Check) {
                checkCount ++;
            }else if (fileEntity.checkState == UnChecked) {
                unCheckCount ++;
            }
        }
    if (checkCount == displayArr.count) {
        [_listTableView changeHeaderCheckState:Check];
    }else if (unCheckCount == displayArr.count) {
        [_listTableView changeHeaderCheckState:UnChecked];
    }else {
        [_listTableView changeHeaderCheckState:SemiChecked];
    }
    [_listTableView reloadData];
    
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
    
    if ( [@"Name" isEqualToString:identify]||[@"Size" isEqualToString:identify]||[@"Type" isEqualToString:identify]||[@"Date" isEqualToString:identify]) {
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
    } else if ([key isEqualToString:@"Size"]){
        key = @"fileSize";
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:_isAscending];
    } else if ([key isEqualToString:@"Type"]) {
        key = @"fileExtension";
        sortDescriptor = [IMBChineseSortHelper creatChineseSortDescriptorWithkey:key WithAscending:_isAscending];
    } else if ([key isEqualToString:@"Date"]){
        key = @"createTime";
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:_isAscending];
    }
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];

    [_listTableView reloadData];
    
    [sortDescriptor release];
    [sortDescriptors release];
}

#pragma mark - 全选
- (void)setAllselectState:(CheckStateEnum)checkState {
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else{
        displayArr = _dataSourceArray;
    }
    if (displayArr.count <= 0) {
        return;
    }
    for (int i=0;i<[displayArr count]; i++) {
        IMBADFileEntity *entity = [displayArr objectAtIndex:i];
        [entity setCheckState:checkState];
        
    }
    [_listTableView reloadData];
}

#pragma mark - search
- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn {
    
    _searchFieldBtn = searchBtn;
    if (![IMBHelper stringIsNilOrEmpty:searchStr]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray filteredArrayUsingPredicate:predicate]];
        _isSearch = YES;
    }else {
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
        [self loadCheckBoxState];
    }
    [_listTableView reloadData];
}

#pragma mark - 点击刷新
- (void)androidReload:(id)sender {
    
    [self disableFunctionBtn:NO];
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    [_searchFieldBtn.searchField setEnabled:NO];
    [_mainBox setContentView:_loadingView];
    [_loadingAniamtionView startAnimation];
    
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
    
    if (_category == Category_Document) {
        [_android setCategory:Category_Document];
        [_android queryDoucmentDetailInfo];
        _dataSourceArray = [[_android getAppDoucmentContent].reslutArray retain];
        
    } else if (_category == Category_iBooks) {
        [_android setCategory:Category_iBooks];
        [_android queryDoucmentDetailInfo];
        _dataSourceArray = [[_android getiBooksContent].reslutArray retain];
        
    } else if (_category == Category_Compressed) {
        [_android setCategory:Category_Compressed];
        [_android queryDoucmentDetailInfo];
        _dataSourceArray = [[_android getCompressedContent].reslutArray retain];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self disableFunctionBtn:YES];
        [_searchFieldBtn.searchField setEnabled:YES];
        if (_dataSourceArray.count <= 0) {
            [self setNoDataViewImageAndText];
            [_mainBox setContentView:_noDataView];
        } else {
            [_mainBox setContentView:_detailView];
            [_listTableView changeHeaderCheckState:UnChecked];
            [_listTableView reloadData];
        }
        
        [_loadingAniamtionView endAnimation];
        if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
            [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
        }
        
    });
}

- (void)cancelReload {
    if (_dataSourceArray.count <= 0) {
        [self setNoDataViewImageAndText];
        [_mainBox setContentView:_noDataView];
    } else {
        [_mainBox setContentView:_detailView];
    }
    [self disableFunctionBtn:YES];
    [_searchFieldBtn.searchField setEnabled:YES];
    [_loadingAniamtionView endAnimation];
}

#pragma mark - 更新CheckBox的状态
- (void)loadCheckBoxState {
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else{
        displayArr = _dataSourceArray;
    }
    float checkCount = 0;
    float unCheckCount = 0;
    for (IMBADFileEntity *fileEntity in displayArr) {
        if (fileEntity.checkState == Check) {
            checkCount ++;
        }else if (fileEntity.checkState == UnChecked) {
            unCheckCount ++;
        }
    }
    if (checkCount == displayArr.count) {
        [_listTableView changeHeaderCheckState:Check];
    }else if (unCheckCount == displayArr.count) {
        [_listTableView changeHeaderCheckState:UnChecked];
    }else {
        [_listTableView changeHeaderCheckState:SemiChecked];
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
