//
//  IMBContactViewController.m
//  NewMacTestApp
//
//  Created by iMobie on 6/11/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import "IMBContactViewController.h"
#import "IMBImageAndTextCell.h"
#import "IMBCustomCornerView.h"
#import "IMBContactSqliteManager.h"
#import "IMBInformation.h"
#import "IMBExportSetting.h"
#import "IMBToolBarButton.h"
#import "IMBCustomHeaderCell.h"
#import "IMBDeviceMainPageViewController.h"
#import <AddressBook/AddressBook.h>
#import "IMBCheckBoxCell.h"
#import "IMBAlertViewController.h"
#import "IMBInformationManager.h"
#import "IMBNotificationDefine.h"
#import "ATTracker.h"
#import "IMBContactEditView.h"
#define BLOCKORIGINX 20
#define BLOCKORIGINY 0
#define BLOCKWIDTH (_flippedView.frame.size.width - 40)
#define BLOCKHEIGHT _flippedView.frame.size.height

@implementation IMBContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    if (self = [super initWithIpod:ipod withCategoryNodesEnum:category withDelegate:delegate]) {
        _dataSourceArray = [[_information contactArray] retain];
        _contactManager = [[IMBContactManager alloc] initWithAMDevice:_ipod.deviceHandle];
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        NSArray *displayArray = nil;
        if (_isSearch) {
            displayArray = _researchdataSourceArray;
        }
        else{
            displayArray = _dataSourceArray;
        }
        if (displayArray.count > _itemTableView.selectedRow) {
            if (_isiCloudView) {
                IMBiCloudContactEntity *contactEntity = [displayArray objectAtIndex:[_itemTableView selectedRow]];
                [self generateiCloudContactView:contactEntity];
            }else {
                IMBContactEntity *contactEntity = [displayArray objectAtIndex:[_itemTableView selectedRow]];
                [self generateContactView:contactEntity];
            }
            
        }
        [self configNoDataView];
        [_editButton setTitleName:CustomLocalizedString(@"Calendar_id_10", nil) WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
        [_editButton setNeedsDisplay:YES];
    });

}

- (void)changeSkin:(NSNotification *)notification {
    [_editButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [_editButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [_editButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [self configNoDataView];
    [_editButton setNeedsDisplay:YES];
    [_topWhiteView setNeedsDisplay:YES];
    
    if (!_isEditing) {
        NSArray *displayArray = nil;
        if (_isSearch) {
            displayArray =  _researchdataSourceArray;
        }
        else{
            displayArray = _dataSourceArray;
        }
        if(_selecteRow >= 0 && (int)displayArray.count > _selecteRow)
        {
            [_showFlippedView setHidden:NO];
            if(_isiCloudView) {
                IMBiCloudContactEntity *contactEntity = [displayArray objectAtIndex:_selecteRow];
                [self generateiCloudContactView:contactEntity];
            }else {
                IMBContactEntity *contactEntity = [displayArray objectAtIndex:_selecteRow];
                [self generateContactView:contactEntity];
            }
        }
        else{
            [_showFlippedView setHidden:YES];
        }
        [_loadingView setIsGradientColorNOCornerPart3:YES];
        [_loadingView setNeedsDisplay:YES];
        [_editLoadingView setIsGradientColorNOCornerPart3:YES];
        [_editLoadingView setNeedsDisplay:YES];
        [_scrollView setNeedsDisplay:YES];
        [_sortRightPopuBtn setNeedsDisplay:YES];
        [_selectSortBtn setNeedsDisplay:YES];
        [_loadingAnimationView setNeedsDisplay:YES];
        [_editLoadingAnimationView setNeedsDisplay:YES];
        [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
        [self.view setNeedsDisplay:YES];
        
        NSTextField *text = [self.view viewWithTag:601];
        [text setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    }
    [_scrollView setHastopBorder:NO leftBorder:YES BottomBorder:NO rightBorder:NO];
    [_scrollView setNeedsDisplay:YES];
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImage:) name:NOTIFY_CHANGECONTEACIMAGE_REDEVICENAME object:nil];
//    _editFlippedView = [[IMBContactEditView alloc] init];
    _isloadingPopBtn = YES;
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkFaultInterrupt) name:NOTITY_NETWORK_FAULT_INTERRUPT object:nil];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_editLoadingView setIsGradientColorNOCornerPart3:YES];
    [self configNoDataView];
    _itemTableView.allowsMultipleSelection = NO;
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
    }else {
        [_mainBox setContentView:_detailView];
    }
    _alertView = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    [self initFilippedView];
    [self initEditAndCancelButton];
//    [self initAddDesView];
    [self initTableView];
    _topWhiteView.isBommt = YES;
    [_topWhiteView setBackgroundColor:[NSColor clearColor]];
    [_scrollView setHastopBorder:NO leftBorder:YES BottomBorder:NO rightBorder:NO];
    if (_information.contactNeedReload) {
        [self reload:nil];
        _information.contactNeedReload = NO;
    }


    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    
    if (_isiCloudView) {
        _dataSourceArray = [_iCloudManager.contactArray retain];
        [_itemTableView reloadData];
        if (_dataSourceArray.count>0) {
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        }
        if (_dataSourceArray.count == 0) {
            [_mainBox setContentView:_noDataView];
        }else {
            [_mainBox setContentView:_detailView];
        }
    }
}

-(void)changeImage:(NSNotification *)obj{
    _noteImageData = obj.object;
}

- (void)initTableView {
    _itemTableView.dataSource = self;
    _itemTableView.delegate = self;
    _itemTableView.allowsMultipleSelection = NO;
//    [_itemTableView setSelectionColor:[NSColor colorWithDeviceRed:0.0/255 green:160.0/255 blue:233.0/255 alpha:1.0]];
//    [_itemTableView setGridColor:[NSColor colorWithCalibratedRed:147.0/255 green:147.0/255 blue:147.0/255 alpha:0.2]];
//    [_itemTableView setGridStyleMask:NSTableViewSolidHorizontalGridLineMask];
//    [_itemTableView setHeaderTextAlignment:NSLeftTextAlignment];
//    [_tableViewBackScroll setImageName:@"table_background"];
    
    if (_dataSourceArray.count>0) {
        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    }
    
//    [_itemTableView setHeaderTextAlignment:NSLeftTextAlignment];
//    [_itemTableView setHasTitleBorderLine:YES];
    _firstEnter = YES;
    NSInteger selectedRow = [_itemTableView selectedRow];
    if (selectedRow < 0 || selectedRow > _dataSourceArray.count) {
//        [_editButton setHidden:YES];
    }
}

- (void)retToolbar:(IMBToolBarView *)toolbar{
    _toolBar = toolbar;
}

- (void)initFilippedView{

}

- (void)initEditAndCancelButton{
    NSString *editStr = CustomLocalizedString(@"Calendar_id_10", nil);
    NSRect editRect = [StringHelper calcuTextBounds:editStr fontSize:13];
    int w = 80;
    if (editRect.size.width > 80) {
        w = editRect.size.width + 10;
    }
    _editButton = [[IMBMyDrawCommonly alloc] initWithFrame:NSMakeRect(_showFlippedView.frame.size.width - w - 20, 15, w, 20)];
    //设置按钮样式
    [_editButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [_editButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [_editButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [_editButton setTitleName:editStr WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [_editButton setTarget:self];
    [_editButton setAction:@selector(setIsEditing)];
    [_editButton setAutoresizingMask:YES];
    [_editButton setAutoresizingMask:NSViewMinXMargin|NSViewMaxYMargin];

}

#pragma mark - NSTextView
- (void)configNoDataView {
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_contact"]];
    [_textView setDelegate:self];
    NSString *promptStr = @"";
    NSString *overStr = @"";
    promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_61", nil)] stringByAppendingString:overStr];
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

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_dataSourceArray != nil) {
        //当前显示的数据源
        NSArray *displayArray = nil;
        if (_isSearch) {
            displayArray = _researchdataSourceArray;
        }
        else{
            displayArray = _dataSourceArray;
        }
        
        return [displayArray count];
    }
    return 0;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 30;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
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
    IMBContactEntity *entity = [displayArray objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:@"Name"]) {
        NSString *finalString = [NSString new];
        if (entity.firstName.length > 0) {
            if(finalString.length > 0) {
                finalString = [finalString stringByAppendingString:@" "];
            }
            finalString = [finalString stringByAppendingString:entity.firstName];
        }
        
        if (entity.middleName.length > 0) {
            if (finalString.length > 0) {
                finalString = [finalString stringByAppendingString:@" "];
            }
            finalString = [finalString stringByAppendingString:entity.middleName];
        }
        if (entity.lastName.length > 0) {
            if (finalString.length > 0) {
                finalString = [finalString stringByAppendingString:@" "];
            }
            finalString = [finalString stringByAppendingString:entity.lastName];
        }
        
        if (finalString.length == 0){
            finalString = [finalString stringByAppendingString:CustomLocalizedString(@"contact_id_48", nil)];
        }
        return finalString;
    }else if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
        return [NSNumber numberWithBool:entity.checkState];
    }
    
    return nil;
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([[tableColumn identifier] isEqualToString:@"CheckCol"]) {
        IMBCheckBoxCell *boxCell = (IMBCheckBoxCell *)cell;
        boxCell.outlineCheck = YES;
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    if (_onlySelectedRow) {
        return ;
    }
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray =  _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <= 0) {
        return;
    }
    NSInteger selectrow = [_itemTableView selectedRow];
    if (_isEditing && _dataSourceArray.count > 1) {
        [self setIsCanceling];
    }
    
    if(selectrow >= 0 && selectrow != NSNotFound) {
        [_showFlippedView setHidden:NO];
        if (_isiCloudView) {
            if (_contactiCloudEntity != nil) {
                [_contactiCloudEntity release];
                _contactiCloudEntity = nil;
            }
            _contactiCloudEntity = [[displayArray objectAtIndex:selectrow] retain];
            [self generateiCloudContactView:_contactiCloudEntity];
        }else {
            if (_contactEntity != nil) {
                [_contactEntity release];
                _contactEntity = nil;
            }
            _contactEntity = [[displayArray objectAtIndex:selectrow] retain];
            [self generateContactView:_contactEntity];
        }
    }
    else{
        [_showFlippedView setHidden:YES];
    }
    _selecteRow = (int)selectrow;
    _iCloudAdd = NO;
    [_toolBar toolBarButtonIsEnabled:YES];
}

#pragma mark - IMBImageRefreshListListener
- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray =  _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <= 0) {
        return;
    }
    IMBContactEntity *contact = [displayArray objectAtIndex:index];
    contact.checkState = !contact.checkState;
    
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[displayArray count]; i++) {
        IMBContactEntity *item= [displayArray objectAtIndex:i];
        if (item.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
//    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    if (set.count == _dataSourceArray.count) {
        [_itemTableView changeHeaderCheckState:Check];
    }else if (set.count == 0){
        [_itemTableView changeHeaderCheckState:UnChecked];
    }else{
        [_itemTableView changeHeaderCheckState:SemiChecked];
    }
    [_itemTableView reloadData];
}

- (void)setAllselectState:(CheckStateEnum)checkState {
//    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    for (int i=0;i<[disAry count]; i++) {
        IMBContactEntity *contact = [disAry objectAtIndex:i];
        [contact setCheckState:checkState];
//        if (contact.checkState == NSOnState) {
//            [set addIndex:i];
//        }
    }
//    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    [_itemTableView reloadData];
}

- (void)tableViewSelectRow:(int)selectRow {
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray =  _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }

    if (selectRow > displayArray.count || selectRow < 0) {
        return;
    }
    if (_onlySelectedRow) {
        return ;
    }
      if (displayArray.count <= 0) {
        return;
    }

    if (_isEditing && displayArray.count >= 1) {
        [self setIsCanceling];
    }
    
    if(selectRow >= 0)
    {
        [_showFlippedView setHidden:NO];
        if (_isiCloudView) {
            IMBiCloudContactEntity *contactEntity = [displayArray objectAtIndex:selectRow];
            [self generateiCloudContactView:contactEntity];
        }else {
            IMBContactEntity *contactEntity = [displayArray objectAtIndex:selectRow];
            [self generateContactView:contactEntity];
        }
    }
    else{
        [_showFlippedView setHidden:YES];
    }
    _selecteRow = selectRow;
}

- (void)sheetResultReturned:(NSNotification *)notification{
    
}

- (void)generateContactView:(IMBContactEntity *)contactEntity{
    @autoreleasepool {
        [_showFlippedView removeFromSuperview];
        if (_showFlippedView != nil) {
            [_showFlippedView release];
            _showFlippedView = nil;
        }
        _showFlippedView = [[FlippedView alloc] initWithFrame:NSMakeRect(0, 0, _scrollView.frame.size.width,  _scrollView.frame.size.height)];
        [_showFlippedView setAutoresizesSubviews:YES];
        [_showFlippedView setAutoresizingMask:NSViewWidthSizable];
        if (_isClickCancel) {
            CATransition *transition = [CATransition animation];
            transition.delegate = self;
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = @"moveIn";
            transition.subtype = kCATransitionFromBottom;
            [_scrollView.layer addAnimation:transition forKey:@""];
        }
        [_scrollView setDocumentView:_showFlippedView];
        [_showFlippedView addSubview:_editButton];
        [_editButton setFrame:NSMakeRect(_showFlippedView.frame.size.width -_editButton.frame.size.width - 20, 14, _editButton.frame.size.width, _editButton.frame.size.height)];
        [_editButton setAutoresizingMask:NSViewMinXMargin | NSViewMaxYMargin];
        //*************基本信息*******************
        //头像
        NSImageView *iconImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(60, 40, 62, 62)];
        [iconImageView setWantsLayer:YES];
        [iconImageView.layer setCornerRadius:31];
        NSImage *iconImage = nil;
        if (contactEntity.image != nil) {
            iconImage = [[[NSImage alloc] initWithData:contactEntity.image] autorelease];
        }else{
            iconImage = [StringHelper imageNamed:@"contact_show"];
        }
        [iconImageView setImage:iconImage];
        [_showFlippedView addSubview:iconImageView];
        [iconImageView setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin];
        [iconImageView release], iconImageView = nil;
        //名字
        NSTextField *nameLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(140, 56, 400, 30)];
        [[nameLabel cell] setLineBreakMode:NSLineBreakByCharWrapping];
        [[nameLabel cell] setTruncatesLastVisibleLine:YES];
        [nameLabel setBordered:NO];
        [nameLabel setEditable:NO];
        [nameLabel setDrawsBackground:NO];
        [nameLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [nameLabel setFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
        [nameLabel.cell setLineBreakMode:NSLineBreakByClipping];
        NSString *nameStr = @"";
        NSString *firstStr = @"";
        NSString *midStr = @"";
        NSString *lastStr = @"";
        if (![StringHelper stringIsNilOrEmpty:contactEntity.firstName]) {
            firstStr = contactEntity.firstName;
        }
        if (![StringHelper stringIsNilOrEmpty:contactEntity.middleName]) {
            midStr = contactEntity.middleName;
        }
        if (![StringHelper stringIsNilOrEmpty:contactEntity.lastName]) {
            lastStr = contactEntity.lastName;
        }
        nameStr = [[[[firstStr stringByAppendingString:@" "] stringByAppendingString:midStr] stringByAppendingString:@" "] stringByAppendingString:lastStr];

        if (![StringHelper stringIsNilOrEmpty:contactEntity.nickname]) {
            nameStr = [nameStr stringByAppendingString:[NSString stringWithFormat:@" (%@)",contactEntity.nickname]];
        }
        if(nameStr.length > 26) {
            nameStr = [[nameStr substringToIndex:26] stringByAppendingString:@"..."];
        }
        [nameLabel setStringValue:nameStr];
        [_showFlippedView addSubview:nameLabel];
        [nameLabel setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin];
        [nameLabel release], nameLabel = nil;
         //公司
        NSTextField *companyLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(140, 80, 200, 20)];
        [companyLabel setBordered:NO];
        [companyLabel setEditable:NO];
        [companyLabel setDrawsBackground:NO];
        [companyLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
        [companyLabel setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
        [companyLabel.cell setLineBreakMode:NSLineBreakByClipping];
        NSString *companyStr = @"";
        if (![StringHelper stringIsNilOrEmpty:contactEntity.companyName]) {
            companyStr = contactEntity.companyName;
        }
        [companyLabel setStringValue:companyStr];
        [_showFlippedView addSubview:companyLabel];
        [companyLabel setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin];
        [companyLabel release], companyLabel = nil;
        
        int height = 0;
        int count = 10;//基本信息的高度为
        
        //***********电话***********
        if (contactEntity.phoneNumberArray.count > 0) {
            for (IMBContactKeyValueEntity *entity in contactEntity.phoneNumberArray) {
                count += 1;
                [self setTitleString:entity.label?entity.label:entity.type WithValueString:entity.value withCounts:count];
                count += 1;
            }
            [self setLineWhiteViewCount:count];
            count += 2.0;
        }
        
        //***********email***********
        if (contactEntity.emailAddressArray.count > 0) {
            for (IMBContactKeyValueEntity *entity in contactEntity.emailAddressArray) {
                count += 1;
                [self setTitleString:entity.label?entity.label:entity.type WithValueString:entity.value withCounts:count];
                count += 1;
            }
            [self setLineWhiteViewCount:count];
            count += 2.0;
        }
        
        //***********relatedName*********** 如父母的名字等
        if (contactEntity.relatedNameArray.count > 0) {
            for (IMBContactKeyValueEntity *entity in contactEntity.relatedNameArray) {
                count += 1;
                [self setTitleString:entity.label?entity.label:entity.type WithValueString:entity.value withCounts:count];
                count += 1;
            }
            [self setLineWhiteViewCount:count];
            count += 2.0;
        }
        
        //***********url**************
        if (contactEntity.urlArray.count > 0) {
            for (IMBContactKeyValueEntity *entity in contactEntity.urlArray) {
                count += 1;
                [self setTitleString:entity.label?entity.label:entity.type WithValueString:entity.value withCounts:count];
                count += 1;
            }
            [self setLineWhiteViewCount:count];
            count += 2.0;
        }
        
        //***********date**************
        if (contactEntity.dateArray.count > 0) {
            for (IMBContactKeyValueEntity *entity in contactEntity.dateArray) {
                count += 1;
                NSTimeInterval timeVer = [(NSDate *)entity.value timeIntervalSince1970];
                if (timeVer < 0) {
                    NSDateFormatter*dateFormatter = [[[NSDateFormatter alloc]init] autorelease];
                    [dateFormatter setDateFormat:@"MM/dd"];
                    NSString *currentDateStr = [dateFormatter stringFromDate:entity.value];

                    [self setTitleString:entity.label?entity.label:entity.type WithValueString:currentDateStr withCounts:count];
                }else {
                    NSDateFormatter*dateFormatter = [[[NSDateFormatter alloc]init] autorelease];
                    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                    NSString *currentDateStr = [dateFormatter stringFromDate:entity.value];
                   [self setTitleString:entity.label?entity.label:entity.type WithValueString:currentDateStr withCounts:count];
                }
                count += 1;
            }
            [self setLineWhiteViewCount:count];
            count += 2.0;
        }
        
        //***********IM**************
        if (contactEntity.IMArray.count > 0) {
            for (IMBContactIMEntity *entity in contactEntity.IMArray) {
                count += 1;
                [self setTitleString:entity.label?entity.label:entity.type WithValueString:entity.user withCounts:count];
                count += 1;
            }
            [self setLineWhiteViewCount:count];
            count += 2.0;
        }
        
        //***********address**************
        if (contactEntity.addressArray.count > 0) {
            for (IMBContactAddressEntity *entity in contactEntity.addressArray) {
                count += 1;
                NSTextField *titleText = [[NSTextField alloc] init];
                [titleText setAlignment:NSRightTextAlignment];
                [titleText setBordered:NO];
                [titleText setDrawsBackground:NO];
                [titleText setAlignment:NSRightTextAlignment];
                [titleText setDrawsBackground:NO];
                [titleText setStringValue:entity.label?entity.label:entity.type];
                [titleText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
                [titleText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
                [titleText setFrame:NSMakeRect(10, (count * 12) -2, 70, 20)];
                [titleText setEditable:NO];
                [titleText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
                [_showFlippedView addSubview:titleText];
                [titleText release];
                
                NSString *addressStr = @"";
                NSString *countryStr = @"";
                NSString *cityStr = @"";
                NSString *stateStr = @"";
                NSString *streetStr = @"";
                NSString *postalCodeStr = @"";
                
                if (![StringHelper stringIsNilOrEmpty:entity.street]) {
                    streetStr = entity.street;
                    if ([streetStr contains:@"\n"]) {
                        NSArray *array = [entity.street componentsSeparatedByString:@"\n"];
                        if (array.count > 0) {
                            int y = 0;
                            for (NSString *str in array) {
                                if (y > 0) {
                                    count += 1;
                                }
                                NSTextField *addressText = [[NSTextField alloc] init];
                                [addressText setBordered:NO];
                                [addressText setDrawsBackground:NO];
                                [addressText setAlignment:NSLeftTextAlignment];
                                [addressText setDrawsBackground:NO];
                                [addressText setStringValue:str];
                                [addressText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                                [addressText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
                                [addressText setFrame:NSMakeRect(90, (count * 12) -2,_showFlippedView.frame.size.width - 120 , 20)];
                                [addressText setEditable:NO];
                                [addressText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
                                [_showFlippedView addSubview:addressText];
                                [addressText release];
                                count += 1;
                                y ++;
                            }
                        }
                    }else {
                        NSTextField *addressText = [[NSTextField alloc] init];
                        [addressText setBordered:NO];
                        [addressText setDrawsBackground:NO];
                        [addressText setAlignment:NSLeftTextAlignment];
                        [addressText setDrawsBackground:NO];
                        [addressText setStringValue:entity.street];
                        [addressText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                        [addressText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
                        [addressText setFrame:NSMakeRect(90, (count * 12) -2,_showFlippedView.frame.size.width - 120 , 20)];
                        [addressText setEditable:NO];
                        [addressText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
                        [_showFlippedView addSubview:addressText];
                        [addressText release];
                        count += 1;
                    }
                }
                
                BOOL haveValue = NO;
                if (![StringHelper stringIsNilOrEmpty:entity.city]) {
                    cityStr = [entity.city stringByAppendingString:@"   "];
                    haveValue = YES;
                }
                if (![StringHelper stringIsNilOrEmpty:entity.state]) {
                    stateStr = [entity.state stringByAppendingString:@"   "];
                    haveValue = YES;
                }
                if (![StringHelper stringIsNilOrEmpty:entity.postalCode]) {
                    postalCodeStr = entity.postalCode;
                    haveValue = YES;
                }
                addressStr = [[cityStr stringByAppendingString:stateStr] stringByAppendingString:postalCodeStr];
                if (haveValue) {
                    count += 1;
                    NSTextField *addressText = [[NSTextField alloc] init];
                    [addressText setBordered:NO];
                    [addressText setDrawsBackground:NO];
                    [addressText setAlignment:NSLeftTextAlignment];
                    [addressText setDrawsBackground:NO];
                    [addressText setStringValue:addressStr];
                    [addressText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                    [addressText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
                    [addressText setFrame:NSMakeRect(90, (count * 12) -2,_showFlippedView.frame.size.width - 120 , 20)];
                    [addressText setEditable:NO];
                    [addressText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
                    [_showFlippedView addSubview:addressText];
                    [addressText release];
                    count += 1;
                }
                
                if (![StringHelper stringIsNilOrEmpty:entity.country]) {
                    count += 1;
                    countryStr = entity.country;
                    NSTextField *addressText = [[NSTextField alloc] init];
                    [addressText setBordered:NO];
                    [addressText setDrawsBackground:NO];
                    [addressText setAlignment:NSLeftTextAlignment];
                    [addressText setDrawsBackground:NO];
                    [addressText setStringValue:countryStr];
                    [addressText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                    [addressText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
                    [addressText setFrame:NSMakeRect(90, (count * 12) -2,_showFlippedView.frame.size.width - 120 , 20)];
                    [addressText setEditable:NO];
                    [addressText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
                    [_showFlippedView addSubview:addressText];
                    [addressText release];
                    count += 1;
                }
            }
            [self setLineWhiteViewCount:count];
            count += 2.0;
        }
        
        //***********note**************
        if (contactEntity.notes.length>0) {
            count += 1;
            NSTextField *noteText = [[NSTextField alloc] init];
            [noteText setBordered:NO];
            [noteText setDrawsBackground:NO];
            [noteText setAlignment:NSRightTextAlignment];
            [noteText setDrawsBackground:NO];
            [noteText setStringValue:CustomLocalizedString(@"Calendar_id_11", nil)];
            [noteText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
            [noteText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
            [noteText setFrame:NSMakeRect(10, (count * 12) -2, 70, 20)];
            [noteText setEditable:NO];
            [noteText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
            [_showFlippedView addSubview:noteText];
            [noteText release];
            
            NSTextField *valueText = [[NSTextField alloc] init];
            [valueText setBordered:NO];
            [valueText setAlignment:NSLeftTextAlignment];
            [valueText setDrawsBackground:NO];
            NSString *noteStr = contactEntity.notes;

            NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
            [textParagraph setLineSpacing:2.0f];
            [textParagraph setAlignment:NSLeftTextAlignment];
            NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:12],NSFontAttributeName,nil];
            NSRect rect = [noteStr boundingRectWithSize:NSMakeSize(_scrollView.frame.size.width - 100, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDic];
            height = rect.size.height + 10;
           
            [valueText setStringValue:contactEntity.notes];
            
            [valueText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            [valueText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
            [valueText setFrame:NSMakeRect(90, (count * 12) -2, _scrollView.frame.size.width - 100, height)];
            [valueText setEditable:NO];
            [valueText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
            [_showFlippedView addSubview:valueText];
            [valueText release];
        }
        [_showFlippedView setFrameSize:NSMakeSize(_scrollView.frame.size.width, height + count * 12)];
    }
}

- (void)generateiCloudContactView:(IMBiCloudContactEntity *)contactEntity{
    @autoreleasepool {
        [_showFlippedView removeFromSuperview];
        if (_showFlippedView != nil) {
            [_showFlippedView release];
            _showFlippedView = nil;
        }
        _showFlippedView = [[FlippedView alloc] initWithFrame:NSMakeRect(0, 0, _scrollView.frame.size.width,  _scrollView.frame.size.height)];
        [_showFlippedView setAutoresizesSubviews:YES];
        [_showFlippedView setAutoresizingMask:NSViewWidthSizable];
        [_scrollView setWantsLayer:YES];
        if (_isClickCancel) {
            CATransition *transition = [CATransition animation];
            transition.delegate = self;
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = @"moveIn";
            transition.subtype = kCATransitionFromBottom;
            [_scrollView.layer addAnimation:transition forKey:@""];
        }
        [_scrollView setDocumentView:_showFlippedView];
        [_showFlippedView addSubview:_editButton];
        [_editButton setFrame:NSMakeRect(_showFlippedView.frame.size.width -_editButton.frame.size.width - 20, 14, _editButton.frame.size.width, _editButton.frame.size.height)];
        [_editButton setAutoresizingMask:NSViewMinXMargin | NSViewMaxYMargin];
        //*************基本信息*******************
        //头像
        NSImageView *iconImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(60, 40, 62, 62)];
        [iconImageView setWantsLayer:YES];
        [iconImageView.layer setCornerRadius:31];
        NSImage *iconImage = nil;
        if (contactEntity.image != nil) {
            iconImage = [[[NSImage alloc] initWithData:contactEntity.image] autorelease];
        }else{
            iconImage = [StringHelper imageNamed:@"contact_show"];
        }
        [iconImageView setImage:iconImage];
        [_showFlippedView addSubview:iconImageView];
        [iconImageView setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin];
        [iconImageView release], iconImageView = nil;
        //名字
        NSTextField *nameLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(140, 56, 400, 30)];
        [nameLabel setBordered:NO];
        [nameLabel setEditable:NO];
        [nameLabel setDrawsBackground:NO];
        [nameLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [nameLabel setFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
        [nameLabel.cell setLineBreakMode:NSLineBreakByClipping];
        NSString *nameStr = @"";
        NSString *firstStr = @"";
        NSString *midStr = @"";
        NSString *lastStr = @"";
        NSString *nickName = @"";
        if (![StringHelper stringIsNilOrEmpty:contactEntity.firstName]) {
            firstStr = contactEntity.firstName;
        }
        if (![StringHelper stringIsNilOrEmpty:contactEntity.middleName]) {
            midStr = contactEntity.middleName;
        }
        if (![StringHelper stringIsNilOrEmpty:contactEntity.lastName]) {
            lastStr = contactEntity.lastName;
        }
        if (![StringHelper stringIsNilOrEmpty:contactEntity.nickname]) {
            nickName = [NSString stringWithFormat:@"(%@)",contactEntity.nickname];
        }
        nameStr = [[[[[[firstStr stringByAppendingString:@" "] stringByAppendingString:midStr] stringByAppendingString:@" "] stringByAppendingString:lastStr] stringByAppendingString:@" "] stringByAppendingString:nickName];
        nameStr  = [nameStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if (nameStr.length > 50) {
            nameStr = [[nameStr substringToIndex:50] stringByAppendingString:@"..."];
        }
        [nameLabel setStringValue:nameStr];
        [_showFlippedView addSubview:nameLabel];
        [nameLabel setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin];
        [nameLabel release], nameLabel = nil;
        //公司
        NSTextField *companyLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(140, 80, 400, 20)];
        [companyLabel setBordered:NO];
        [companyLabel setEditable:NO];
        [companyLabel setDrawsBackground:NO];
        [companyLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
        [companyLabel setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
        [companyLabel.cell setLineBreakMode:NSLineBreakByClipping];
        NSString *companyStr = @"";
        if (![StringHelper stringIsNilOrEmpty:contactEntity.companyName]) {
            companyStr = contactEntity.companyName;
        }
        [companyLabel setStringValue:companyStr];
        [_showFlippedView addSubview:companyLabel];
        [companyLabel setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin];
        [companyLabel release], companyLabel = nil;
        
        int height = 0;
        int count = 10;//基本信息的高度为
        
        //***********电话***********
        if (contactEntity.phoneNumberArray.count > 0) {
            for (IMBContactKeyValueEntity *entity in contactEntity.phoneNumberArray) {
                count += 1;
                [self setTitleString:entity.label?entity.label:entity.type WithValueString:entity.value withCounts:count];
                count += 1;
            }
            [self setLineWhiteViewCount:count];
            count += 2.0;
        }
        
        //***********email***********
        if (contactEntity.emailAddressArray.count > 0) {
            for (IMBContactKeyValueEntity *entity in contactEntity.emailAddressArray) {
                count += 1;
                [self setTitleString:entity.label?entity.label:entity.type WithValueString:entity.value withCounts:count];
                count += 1;
            }
            [self setLineWhiteViewCount:count];
            count += 2.0;
        }
        
        //***********relatedName*********** 如父母的名字等
        if (contactEntity.relatedNameArray.count > 0) {
            for (IMBContactKeyValueEntity *entity in contactEntity.relatedNameArray) {
                count += 1;
                [self setTitleString:entity.label?entity.label:entity.type WithValueString:entity.value withCounts:count];
                count += 1;
            }
            [self setLineWhiteViewCount:count];
            count += 2.0;
        }
        
        //***********url**************
        if (contactEntity.urlArray.count > 0) {
            for (IMBContactKeyValueEntity *entity in contactEntity.urlArray) {
                count += 1;
                [self setTitleString:entity.label?entity.label:entity.type WithValueString:entity.value withCounts:count];
                count += 1;
            }
            [self setLineWhiteViewCount:count];
            count += 2.0;
        }
        
        //***********date**************
        if (contactEntity.dateArray.count > 0) {
            for (IMBContactKeyValueEntity *entity in contactEntity.dateArray) {
                count += 1;
                NSTimeInterval timeVer = [(NSDate *)entity.value timeIntervalSince1970];
                if (timeVer < 0) {
                    NSDateFormatter*dateFormatter = [[[NSDateFormatter alloc]init] autorelease];
                    [dateFormatter setDateFormat:@"MM/dd"];
                    NSString *currentDateStr = [dateFormatter stringFromDate:entity.value];
                    
                    [self setTitleString:entity.label?entity.label:entity.type WithValueString:currentDateStr withCounts:count];
                }else {
                    NSDateFormatter*dateFormatter = [[[NSDateFormatter alloc]init] autorelease];
                    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                    NSString *currentDateStr = [dateFormatter stringFromDate:entity.value];
                    [self setTitleString:entity.label?entity.label:entity.type WithValueString:currentDateStr withCounts:count];
                }
                count += 1;
            }
            [self setLineWhiteViewCount:count];
            count += 2.0;
        }
        
        //***********IM**************
        if (contactEntity.IMArray.count > 0) {
            for (IMBContactIMEntity *entity in contactEntity.IMArray) {
                count += 1;
                [self setTitleString:entity.label?entity.label:entity.type WithValueString:entity.user withCounts:count];
                count += 1;
            }
            [self setLineWhiteViewCount:count];
            count += 2.0;
        }
        
        //***********address**************
        if (contactEntity.addressArray.count > 0) {
            for (IMBContactAddressEntity *entity in contactEntity.addressArray) {
                count += 1;
                NSTextField *titleText = [[NSTextField alloc] init];
                [titleText setAlignment:NSRightTextAlignment];
                [titleText setBordered:NO];
                [titleText setDrawsBackground:NO];
                [titleText setAlignment:NSRightTextAlignment];
                [titleText setDrawsBackground:NO];
                NSString *str = entity.label?entity.label:entity.type;
                if ([StringHelper stringIsNilOrEmpty:str]) {
                    str = @" ";
                }
                [titleText setStringValue:str];
                [titleText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
                [titleText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
                [titleText setFrame:NSMakeRect(10, (count * 12) -2, 70, 20)];
                [titleText setEditable:NO];
                [titleText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
                [_showFlippedView addSubview:titleText];
                [titleText release];
                
                NSString *addressStr = @"";
                NSString *countryStr = @"";
                NSString *cityStr = @"";
                NSString *stateStr = @"";
                NSString *streetStr = @"";
                NSString *postalCodeStr = @"";
                
                if (![StringHelper stringIsNilOrEmpty:entity.street]) {
                    streetStr = entity.street;
                    if ([streetStr contains:@"\n"]) {
                        NSArray *array = [entity.street componentsSeparatedByString:@"\n"];
                        if (array.count > 0) {
                            int y = 0;
                            for (NSString *str in array) {
                                if (y > 0) {
                                    count += 1;
                                }
                                NSTextField *addressText = [[NSTextField alloc] init];
                                [addressText setBordered:NO];
                                [addressText setDrawsBackground:NO];
                                [addressText setAlignment:NSLeftTextAlignment];
                                [addressText setDrawsBackground:NO];
                                [addressText setStringValue:str];
                                [addressText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                                [addressText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
                                [addressText setFrame:NSMakeRect(90, (count * 12) -2,_showFlippedView.frame.size.width - 120 , 20)];
                                [addressText setEditable:NO];
                                [addressText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
                                [_showFlippedView addSubview:addressText];
                                [addressText release];
                                count += 1;
                                y ++;
                            }
                        }
                    }else {
                        NSTextField *addressText = [[NSTextField alloc] init];
                        [addressText setBordered:NO];
                        [addressText setDrawsBackground:NO];
                        [addressText setAlignment:NSLeftTextAlignment];
                        [addressText setDrawsBackground:NO];
                        [addressText setStringValue:entity.street];
                        [addressText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                        [addressText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
                        [addressText setFrame:NSMakeRect(90, (count * 12) -2,_showFlippedView.frame.size.width - 120 , 20)];
                        [addressText setEditable:NO];
                        [addressText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
                        [_showFlippedView addSubview:addressText];
                        [addressText release];
                        count += 1;
                    }
                }
                
                BOOL haveValue = NO;
                if (![StringHelper stringIsNilOrEmpty:entity.city]) {
                    cityStr = [entity.city stringByAppendingString:@"   "];
                    haveValue = YES;
                }
                if (![StringHelper stringIsNilOrEmpty:entity.state]) {
                    stateStr = [entity.state stringByAppendingString:@"   "];
                    haveValue = YES;
                }
                if (![StringHelper stringIsNilOrEmpty:entity.postalCode]) {
                    postalCodeStr = entity.postalCode;
                    haveValue = YES;
                }
                addressStr = [[cityStr stringByAppendingString:stateStr] stringByAppendingString:postalCodeStr];
                if (haveValue) {
                    count += 1;
                    NSTextField *addressText = [[NSTextField alloc] init];
                    [addressText setBordered:NO];
                    [addressText setDrawsBackground:NO];
                    [addressText setAlignment:NSLeftTextAlignment];
                    [addressText setDrawsBackground:NO];
                    [addressText setStringValue:addressStr];
                    [addressText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                    [addressText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
                    [addressText setFrame:NSMakeRect(90, (count * 12) -2,_showFlippedView.frame.size.width - 120 , 20)];
                    [addressText setEditable:NO];
                    [addressText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
                    [_showFlippedView addSubview:addressText];
                    [addressText release];
                    count += 1;
                }
                
                if (![StringHelper stringIsNilOrEmpty:entity.country]) {
                    count += 1;
                    countryStr = entity.country;
                    NSTextField *addressText = [[NSTextField alloc] init];
                    [addressText setBordered:NO];
                    [addressText setDrawsBackground:NO];
                    [addressText setAlignment:NSLeftTextAlignment];
                    [addressText setDrawsBackground:NO];
                    [addressText setStringValue:countryStr];
                    [addressText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                    [addressText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
                    [addressText setFrame:NSMakeRect(90, (count * 12) -2,_showFlippedView.frame.size.width - 120 , 20)];
                    [addressText setEditable:NO];
                    [addressText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
                    [_showFlippedView addSubview:addressText];
                    [addressText release];
                    count += 1;
                }
            }
            [self setLineWhiteViewCount:count];
            count += 2.0;
        }
        
        //***********note**************
        if (contactEntity.notes.length>0) {
            count += 1;
            NSTextField *noteText = [[NSTextField alloc] init];
            [noteText setBordered:NO];
            [noteText setDrawsBackground:NO];
            [noteText setAlignment:NSRightTextAlignment];
            [noteText setDrawsBackground:NO];
            [noteText setStringValue:CustomLocalizedString(@"Calendar_id_11", nil)];
            [noteText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
            [noteText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
            [noteText setFrame:NSMakeRect(10, (count * 12) -2, 70, 20)];
            [noteText setEditable:NO];
            [noteText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
            [_showFlippedView addSubview:noteText];
            [noteText release];
            
            NSTextField *valueText = [[NSTextField alloc] init];
            [valueText setBordered:NO];
            [valueText setAlignment:NSLeftTextAlignment];
            [valueText setDrawsBackground:NO];
            NSString *noteStr = contactEntity.notes;
            
            NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
            [textParagraph setLineSpacing:2.0f];
            [textParagraph setAlignment:NSLeftTextAlignment];
            NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:12],NSFontAttributeName,nil];
            NSRect rect = [noteStr boundingRectWithSize:NSMakeSize(_scrollView.frame.size.width - 100, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDic];
            height = rect.size.height + 10;
            
            [valueText setStringValue:contactEntity.notes];
            
            [valueText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            [valueText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
            [valueText setFrame:NSMakeRect(90, (count * 12) -2, _scrollView.frame.size.width - 100, height)];
            [valueText setEditable:NO];
            [valueText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
            [_showFlippedView addSubview:valueText];
            [valueText release];
        }
        [_showFlippedView setFrameSize:NSMakeSize(_scrollView.frame.size.width, height + count * 12)];
    }
}

- (void)editContactView:(IMBContactEntity *)contactEntity{
    
}

- (void)setLineWhiteViewCount:(int)count {
    IMBWhiteView *whiteView = [[IMBWhiteView alloc] initWithFrame:NSMakeRect(90, (count * 12)+10, _showFlippedView.frame.size.width - 140, 1)];
    [whiteView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [whiteView setAutoresizingMask: NSViewMaxXMargin|NSViewWidthSizable];
    [_showFlippedView addSubview:whiteView];
    [whiteView release];
}

- (void)setTitleString:(NSString *)textString  WithValueString:(NSString *)valueString withCounts:(int)count {
    NSTextField *homeText = [[NSTextField alloc] init];
    [homeText setBordered:NO];
    [homeText setAlignment:NSRightTextAlignment];
    [homeText setDrawsBackground:NO];
    if (textString == nil) {
        [homeText setStringValue:@" "];
    }else {
        [homeText setStringValue:textString];
    }
    [homeText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [homeText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [homeText setFrame:NSMakeRect(10, (count * 12) -2, 70, 20)];
    [homeText setEditable:NO];
    [homeText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
    [_showFlippedView addSubview:homeText];
    [homeText release];
    
    NSTextField *valueText = [[NSTextField alloc] init];
    [valueText setBordered:NO];
    [valueText setAlignment:NSLeftTextAlignment];
    [valueText setDrawsBackground:NO];
    if (valueString == nil) {
        [valueText setStringValue:@" "];
    }else {
        [valueText setStringValue:valueString];
    }
    [valueText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [valueText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [valueText setFrame:NSMakeRect(90, (count * 12) -2, _scrollView.frame.size.width - 110, 20)];
    [valueText setEditable:NO];
    [valueText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
    [_showFlippedView addSubview:valueText];
    [valueText release];
}

- (IBAction)setIsEditing{
    _isEditing = YES;
    [_toolBar toolBarButtonIsEnabled:NO];
    if (_editFlippedView != nil) {
        [_editFlippedView release];
        _editFlippedView = nil;
    }
    _editFlippedView = [[IMBContactEditView alloc] initWithSuperView:_scrollView];
    [_editFlippedView setAutoresizesSubviews:YES];
    [_editFlippedView setAutoresizingMask:NSViewWidthSizable];
    if (_isiCloudView) {
        [_editFlippedView setIsiCloudView:YES];
        [_editFlippedView setiCloudContactEntity:_contactiCloudEntity];
    }else {
        [_editFlippedView setIsiCloudView:NO];
        [_editFlippedView setContactEntity:_contactEntity];
    }
    
    
    _editFlippedView.saveBlock = ^(IMBMyDrawCommonly *button,id contactEntity){
        if (button.tag == 101) {//保存
            if (_isiCloudView) {
                if (![TempHelper checkInternetAvailble]) {
                    [self showAlertText:CustomLocalizedString(@"IMBTrans_Server_Not_Avail_MSG", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
                    return ;
                }
                [_toolBar toolBarButtonIsEnabled:NO];
                [_editBox setContentView:_editLoadingView];
                [_editLoadingAnimationView startAnimation];
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    if (!_isRefreshing) {
                        if (_iCloudAdd) {
                            [_iCloudManager importContact:@[(IMBiCloudContactEntity *)contactEntity]];
                        }else {
                            [_iCloudManager editContact:(IMBiCloudContactEntity *)contactEntity];
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_editBox setContentView:nil];
                        _isEditing = NO;
                        if (_dataSourceArray.count == 0) {
                            [_mainBox setContentView:_noDataView];
                            [self configNoDataView];
                        }else {
                            [_mainBox setContentView:_detailView];
                        }
                        [self refresh];
                        [_editLoadingAnimationView endAnimation];
                        [_toolBar toolBarButtonIsEnabled:YES];
                        _iCloudAdd = NO;
                    });
                });
            }else {
                BOOL open = [self chekiCloud:@"Contacts" withCategoryEnum:_category];
                if (!open) {
                    return;
                }
                [_toolBar toolBarButtonIsEnabled:NO];
                [_editBox setContentView:_editLoadingView];
                [_editLoadingAnimationView startAnimation];
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    if (!_isRefreshing) {
                        [_contactManager openMobileSync];
                        [_contactManager modifyContact:_contactEntity];
                        [_contactManager closeMobileSync];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _isEditing = NO;
                        [_editBox setContentView:nil];
                        if (_dataSourceArray.count == 0) {
                            [_mainBox setContentView:_noDataView];
                            [self configNoDataView];
                        }else {
                            [_mainBox setContentView:_detailView];
                        }
                        [self refresh];
                        [_editLoadingAnimationView endAnimation];
                        [_toolBar toolBarButtonIsEnabled:YES];
                        _isDeviceAdd = NO;
                    });
                });
            }
        }else if (button.tag == 102) {//取消
            [self setIsCanceling];
        }
    };
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"moveIn";
    transition.subtype = kCATransitionFromBottom;
    [_scrollView.layer addAnimation:transition forKey:@""];
    [_scrollView setDocumentView:_editFlippedView];
}

#pragma mark - cancel
- (IBAction)setIsCanceling{
    if (_isiCloudView) {
        if (_isiCloudAddEditView) {//add的编辑页面
            [_dataSourceArray removeObjectAtIndex:0];
            if (_dataSourceArray.count == 0) {
                [_mainBox setContentView:_noDataView];
                [self configNoDataView];
                _isEditing = NO;
                _iCloudAdd = NO;
                _isiCloudAddEditView = NO;
                [_toolBar toolBarButtonIsEnabled:YES];
                return;
            }else {
                [_mainBox setContentView:_detailView];
            }
            _isClickCancel = YES;
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
            IMBiCloudContactEntity *contactEntity = [_dataSourceArray objectAtIndex:0];
            [self generateiCloudContactView:contactEntity];
            _isClickCancel = NO;
        }else {//编辑页面
            int row = (int)[_itemTableView selectedRow];
            if (row < _dataSourceArray.count && row >= 0) {
                _isClickCancel = YES;
                [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
                IMBiCloudContactEntity *contactEntity = [_dataSourceArray objectAtIndex:row];
                [self generateiCloudContactView:contactEntity];
                _isClickCancel = NO;
            }
        }
        _isEditing = NO;
        _iCloudAdd = NO;
        _isiCloudAddEditView = NO;
        [_toolBar toolBarButtonIsEnabled:YES];
    }else {
        if (_isDeviceAddEditView) {
            [_dataSourceArray removeObjectAtIndex:0];
            if (_dataSourceArray.count == 0) {
                [_mainBox setContentView:_noDataView];
                [self configNoDataView];
                _isEditing = NO;
                _isDeviceAdd = NO;
                _isDeviceAddEditView = NO;
                [_toolBar toolBarButtonIsEnabled:YES];
                return;
            }else {
                [_mainBox setContentView:_detailView];
            }
            _isClickCancel = YES;
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
            IMBContactEntity *contactEntity = [_dataSourceArray objectAtIndex:0];
            [self generateContactView:contactEntity];
            _isClickCancel = NO;
        }else {
            int row = (int)[_itemTableView selectedRow];
            if (row < _dataSourceArray.count && row >= 0) {
                _isClickCancel = YES;
                [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
                IMBContactEntity *contactEntity = [_dataSourceArray objectAtIndex:row];
                [self generateContactView:contactEntity];
                _isClickCancel = NO;
            }
        }
        _isEditing = NO;
        _isDeviceAdd = NO;
        _isDeviceAddEditView = NO;
        [_toolBar toolBarButtonIsEnabled:YES];
    }
}

#pragma mark - sort、Select
- (IBAction)sortSelectedPopuBtn:(id)sender {
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray =  _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    NSMenuItem *item = [_selectSortBtn selectedItem];
    NSInteger tag = [_selectSortBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _selectSortBtn.itemArray) {
        [menuItem setState:NSOffState];
    }
    if (tag == 1) {
        for (IMBContactEntity *note in displayArray) {
            note.checkState = Check;
        }
    }else if (tag == 2){
        for (IMBContactEntity *note in displayArray) {
            note.checkState = UnChecked;
        }
    }
    [item setState:NSOnState];
    NSRect rect1 = [TempHelper calcuTextBounds:item.title fontSize:12];
    int wide = 0;
    if (rect1.size.width >170) {
        wide = 170;
    }else{
        wide = rect1.size.width;
    }
    [_selectSortBtn setFrame:NSMakeRect(-2,_selectSortBtn.frame.origin.y , wide +30, _selectSortBtn.frame.size.height)];
    [_selectSortBtn setTitle:[_selectSortBtn titleOfSelectedItem]];
    [_itemTableView reloadData];
}

- (IBAction)sortRightPopuBtn:(id)sender {
    NSMenuItem *item = [_sortRightPopuBtn selectedItem];
    NSRect rect = [TempHelper calcuTextBounds:item.title fontSize:12];
    [_sortRightPopuBtn setFrame:NSMakeRect(_topWhiteView.frame.size.width - 30 - rect.size.width-12,_sortRightPopuBtn.frame.origin.y , rect.size.width +30, _sortRightPopuBtn.frame.size.height)];
    [_sortRightPopuBtn setTitle:[_sortRightPopuBtn titleOfSelectedItem]];
    NSInteger tag = [_sortRightPopuBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
        if (menuItem.tag != 1) {
            [menuItem setState:NSOffState];
        }
    }
    
    if (item.tag == 1) {
        for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
            if (menuItem.tag != 1) {
                [menuItem setState:NSOffState];
            }
            if (menuItem.tag == 3) {
                if (_isAscending) {
                    [menuItem setState:NSOnState];
                }else{
                    [menuItem setState:NSOffState];
                }
            }else if (menuItem.tag == 4){
                if (_isAscending) {
                    [menuItem setState:NSOffState];
                }else{
                    [menuItem setState:NSOnState];
                }
            }
        }
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"allName" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_dataSourceArray sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        [_sortRightPopuBtn setTitle:[_sortRightPopuBtn titleOfSelectedItem]];
    }else if (tag == 2){
        
    }else if (item.tag == 3){
        _isAscending = YES;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"allName" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_dataSourceArray sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        //        [_topPopuBtn setTitle:[_topPopuBtn titleOfSelectedItem]];
    }else if (item.tag == 4){
        _isAscending = NO;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"allName" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_dataSourceArray sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        //        //
    }
    NSString *str1 = CustomLocalizedString(@"SortBy_Name", nil);
    [_sortRightPopuBtn setTitle:str1];
    [_sortRightPopuBtn setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSInteger row = [_itemTableView selectedRow];
    [self changeSonTableViewData:row];
}

- (void)changeSonTableViewData:(NSInteger)row {
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }
    if (row < 0 || row >= displayArray.count) {
        row = 0;
    }
    if (displayArray.count > 0) {
        [_showFlippedView setHidden:NO];
        if (_isiCloudView) {
            IMBiCloudContactEntity *contactEntity = [displayArray objectAtIndex:row];
            if (_contactiCloudEntity != nil) {
                [_contactiCloudEntity release];
                _contactiCloudEntity = nil;
            }
            _contactiCloudEntity = [contactEntity retain];
            [self generateiCloudContactView:contactEntity];
            
        }else {
            
            IMBContactEntity *contactEntity = [displayArray objectAtIndex:row];
            if (_contactEntity != nil) {
                [_contactEntity release];
                _contactEntity = nil;
            }
            _contactEntity = [contactEntity retain];
            [self generateContactView:contactEntity];
        }
    }else{
        [_showFlippedView setHidden:YES];
    }
 }

#pragma mark OperationActions

- (void)addItems:(id)sender {
    if (_isDeviceAdd) {
        return;
    }
    if (_ipod.beingSynchronized) {
        [self showAlertText:CustomLocalizedString(@"AirsyncTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    IMBContactEntity *contactEntity = [[IMBContactEntity alloc] init];
    [_dataSourceArray insertObject:contactEntity atIndex:0];
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_mainBox setContentView:_detailView];
    }
    [_itemTableView reloadData];
    
    if (_contactEntity != nil) {
        [_contactEntity release];
        _contactEntity = nil;
    }
    _contactEntity = [contactEntity retain];
    [self setIsEditing];
    [contactEntity release];
    _isDeviceAdd = YES;
    _isDeviceAddEditView = YES;
    [_toolBar toolBarButtonIsEnabled:NO];
}

- (void)deleteItems:(id)sender {
    NSMutableArray *arrayM = [[NSMutableArray alloc]init];
    for (IMBContactEntity *entity in _dataSourceArray) {
        if (entity.checkState == Check) {
            [arrayM addObject:entity];
        }
    }
    if (arrayM.count > 0) {
        NSString *str;
        if (arrayM.count > 1) {
            str = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete", nil);
        }else {
            str = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete_2", nil);
        }
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        int i = [_alertView showDeleteConfrimText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)  CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
        if (i == 0) {
            return;
        }
    }else {
        //弹出警告确认框
        NSString *str = nil;
        if (_dataSourceArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_delete", nil),CustomLocalizedString(@"MenuItem_id_61", nil)];
        }else {
            str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        }
        
        
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    
    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_contactManager openMobileSync];
        [_contactManager delContract:arrayM];
        [_contactManager closeMobileSync];
        for (IMBContactEntity *entity in arrayM) {
            [_information.contactArray removeObject:entity];
        }
//        [_information loadContact];
        dispatch_sync(dispatch_get_main_queue(), ^{

            if (_dataSourceArray != nil) {
                [_dataSourceArray release];
                _dataSourceArray = nil;
            }
            _dataSourceArray = [[_information contactArray] retain];
            NSLog(@"=====_dataSourceArray.count=%lu",(unsigned long)_dataSourceArray.count);
            [self refresh];
            [_editBox setContentView:nil];
            if (_dataSourceArray.count == 0) {
                [_mainBox setContentView:_noDataView];
                [self configNoDataView];
            }else {
                [_mainBox setContentView:_detailView];
            }
            [_loadingAnimationView endAnimation];
            [_itemTableView reloadData];
            if (_dataSourceArray.count > 0) {
                [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
            }
            
        });
    });
    [arrayM autorelease];
}

- (void)doImportContact:(id)sender{
    
    if (_ipod.beingSynchronized) {
        [self showAlertText:CustomLocalizedString(@"AirsyncTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    
    
    _openPanel = [NSOpenPanel openPanel];
    _isOpen = YES;
    [_openPanel setCanChooseDirectories:NO];
    [_openPanel setCanChooseFiles:YES];
    [_openPanel setAllowsMultipleSelection:YES];
    [_openPanel setAllowedFileTypes:[NSArray arrayWithObject:@"VCF"]];
    [_openPanel beginSheetModalForWindow:[(IMBDeviceMainPageViewController *)_delegate view].window completionHandler:^(NSInteger result) {
        if (result== NSFileHandlingPanelOKButton) {
            [self performSelector:@selector(ImportContactDelay:) withObject:_openPanel afterDelay:0.1];
            
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                [_mainBox setContentView:_animationView];
//                [self startAnimation];
//                NSArray *urlArray = [openPanel URLs];
//                [_contactManager importContactVCF:urlArray];
//                
//                [_information loadContact];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (_dataSourceArray != nil) {
//                        [_dataSourceArray release];
//                        _dataSourceArray = nil;
//                    }
//                    _dataSourceArray = [[_information contactArray] retain];
//                    [self refresh];
//                    if (_dataSourceArray.count == 0) {
//                        [_mainBox setContentView:_noDataView];
//                        [self configNoDataView];
//                    }else {
//                        [_mainBox setContentView:_detailView];
//                    }
//                    [self stopAnimation];
//                });
//            });
        }
        _isOpen = NO;
    }];
}

- (void)ImportContactDelay:(NSOpenPanel *)openPanel {
    NSViewController *annoyVC = nil;
    long long result = [self checkNeedAnnoy:&(annoyVC)];
    if (result == 0) {
        return;
    }

    NSArray *urlArr = [openPanel URLs];
    NSMutableArray *paths = [NSMutableArray array];
    for (NSURL *url in urlArr) {
        [paths addObject:url.path];
    }
    [self importContactToDevice:paths Result:result AnnoyVC:annoyVC];
}

- (void)importContactToDevice:(NSMutableArray *)paths Result:(long long)result AnnoyVC:(NSViewController *)annoyVC{
    if (_transferController != nil) {
        [_transferController release];
        _transferController = nil;
    }
    _transferController = [[IMBTransferViewController alloc] initWithContactManager:_contactManager SelectFiles:paths TransferModeType:TransferImportContacts];
    [_transferController setDelegate:self];
    if (result>0) {
        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
    }else{
        [self animationAddTransferView:_transferController.view];
    }
}

- (void)deviceToiCloud:(id)sender{
    NSViewController *annoyVC = nil;
    long long result = [self checkNeedAnnoy:&(annoyVC)];
    if (result == 0) {
        return;
    }
    OperationLImitation *imitation = [OperationLImitation singleton];
    NSMutableArray *arrayM = [NSMutableArray array];
    NSMutableArray *slectAry = [NSMutableArray array];
    int allCount = 0;
    if (_iCloudManager.contactArray.count == 0) {
        for (IMBContactEntity *entity in _dataSourceArray) {
            if (entity.checkState == Check) {
                allCount ++;
                if (imitation.remainderCount == 0) {
                    break;
                }
                IMBiCloudContactEntity *contactEntity = [[IMBiCloudContactEntity alloc]init];
                CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
                NSString *guid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
                [contactEntity setContactId:guid];
                [contactEntity setEtag:@""];
                if (entity.image != nil) {
                    NSImage *image = [[NSImage alloc]initWithData:entity.image];
                    NSData *imageData = [TempHelper createThumbnail:image withWidth:200 withHeight:200];
                    contactEntity.image = imageData;
                    [image release];
                }
                contactEntity.firstName = entity.firstName;
                contactEntity.lastName = entity.lastName;
                contactEntity.displayAsCompany = entity.displayAsCompany;
                contactEntity.jobTitle = entity.jobTitle;
                contactEntity.companyName = entity.companyName;
                contactEntity.department = entity.department;
                contactEntity.birthday = entity.birthday;
                contactEntity.nickname = entity.nickname;
                contactEntity.notes = entity.notes;
                contactEntity.middleName = entity.middleName;
                contactEntity.firstNameYomi = entity.firstNameYomi;
                contactEntity.lastNameYomi = entity.lastNameYomi;
                contactEntity.suffix = entity.suffix;
                contactEntity.title = entity.title;
                contactEntity.fullName = entity.fullName;
                contactEntity.phoneNumberArray = entity.phoneNumberArray;
                contactEntity.emailAddressArray = entity.emailAddressArray;
                contactEntity.relatedNameArray = entity.relatedNameArray;
                contactEntity.urlArray = entity.urlArray;
                contactEntity.dateArray = entity.dateArray;
                contactEntity.addressArray = entity.addressArray;
                contactEntity.IMArray = entity.IMArray;
                contactEntity.allName = entity.allName;
                [contactEntity setImageSign:@""];
                [arrayM addObject:contactEntity];
                [contactEntity release];
                [imitation reduceRedmainderCount];
            }
        }
    }else{
        for (IMBContactEntity *entity in _dataSourceArray) {
            if (entity.checkState == Check) {
                BOOL isAdd = YES;
                allCount ++;
                for (IMBiCloudContactEntity *icloudEntity in _iCloudManager.contactArray) {
                    if ([entity.lastName isEqualToString:icloudEntity.lastName] && [entity.firstName isEqualToString: icloudEntity.firstName] ) {
                        int i= 0;
                        for (IMBContactKeyValueEntity *iCloudKeyValueEntity in icloudEntity.phoneNumberArray) {
                            for (IMBContactKeyValueEntity *keyValueEntity in entity.phoneNumberArray) {
                                if ([iCloudKeyValueEntity.value isEqualToString: keyValueEntity.value] ) {
                                    i++;
                                    break;
                                }
                            }
                        }
                        if (i == icloudEntity.phoneNumberArray.count) {
                            [slectAry addObject:entity];
                            isAdd = NO;
                        }
                    }
                }
                if (isAdd) {
                    [arrayM addObject:entity];
                    [imitation reduceRedmainderCount];
                }
            }
        }
    }
   
    if (arrayM.count > 0) {
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Device_Content action:ToiCloud actionParams:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] label:Start transferCount:allCount screenView:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        if (_transferController != nil) {
            [_transferController release];
            _transferController = nil;
        }
        _icloudTransCount = allCount;
        _transferController = [[IMBTransferViewController alloc] initWithType:Category_Contacts withDelegate:self withTransfertype:TransferSync withIsicloudView:YES];
        [_transferController setDelegate:self];
        _iCloudManager.delegate = self;
        if (result>0) {
            [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
        }else{
            [self animationAddTransferView:_transferController.view];
        }
        if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_83", nil)]];
        }
        
        NSString *msgStr = CustomLocalizedString(@"ImportSync_id_1", nil);
        if ([_transferController respondsToSelector:@selector(transferFile:)]) {
            [_transferController transferFile:msgStr];
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //每次都必须请求一次数据；
//            [_iCloudManager getContactContent];
            [_iCloudManager importContact:arrayM];
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:Device_Content action:ToiCloud actionParams:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] label:Finish transferCount:0 screenView:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
        });
    }else if (slectAry.count >0 && arrayM.count == 0){
        if (_transferController != nil) {
            [_transferController release];
            _transferController = nil;
        }
        _transferController = [[IMBTransferViewController alloc] initWithType:Category_Contacts withDelegate:self withTransfertype:TransferSync withIsicloudView:YES];
        [_transferController setDelegate:self];
        _iCloudManager.delegate = self;
        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
        
        if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
            [_transferController transferComplete:0 TotalCount:allCount];
        }

    }else {
        //弹出警告确认框
        NSString *str = nil;
        str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }
}

- (void)doToContact:(id)sender{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (IMBContactEntity *entity in _dataSourceArray) {
        if (entity.checkState == Check) {
            [array addObject:entity];
        }
    }
    if (array.count == 0) {
        //弹出警告确认框
        NSString *str = nil;
        if (_dataSourceArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_transfer", nil),CustomLocalizedString(@"MenuItem_id_61", nil)];
        }else {
            str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        }
        
        
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    
    NSViewController *annoyVC = nil;
    long long result = [self checkNeedAnnoy:&(annoyVC)];
    if (result == 0) {
        return;
    }
    
    if (_transferController != nil) {
        [_transferController release];
        _transferController = nil;
    }
    _transferController = [[IMBTransferViewController alloc] initWithContactManager:nil SelectFiles:array TransferModeType:TransferToContact];
    if (result>0) {
        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
    }else {
        [self animationAddTransferView:_transferController.view];
    }

    [array release];
}

- (void)reload:(id)sender {
//    BOOL open = [self chekiCloud:@"Contacts" withCategoryEnum:_category];
//    if (!open) {
//        return;
//    }
    [self disableFunctionBtn:NO];
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    _isEditing = NO;

    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            //刷新方式，重新读取
            [_information loadContact];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self disableFunctionBtn:YES];
                if (_dataSourceArray != nil) {
                    [_dataSourceArray release];
                    _dataSourceArray = nil;
                }
                _dataSourceArray = [[_information contactArray] retain];
                [self refresh];
                [_editBox setContentView:nil];

                if (_dataSourceArray.count == 0) {
                    [_mainBox setContentView:_noDataView];
                    [self configNoDataView];
                }else {
                    [_mainBox setContentView:_detailView];
                }
                if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                    [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
                }
                [_loadingAnimationView endAnimation];
            });
        }
    });
}

- (void)refresh {
    NSInteger selecteRow = [_itemTableView selectedRow];
    if (_isEditing) {
        _isRefreshing = YES;
        _isRefreshing = NO;
    }
    if (_dataSourceArray.count > 0) {
        if (selecteRow <= 0) {
            [self changeSonTableViewData:0];
        }else {
            [self changeSonTableViewData:selecteRow];
        }
    }
    if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
        [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
    }
    [_itemTableView reloadData];
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _isSearch = YES;
    _searchFieldBtn = searchBtn ;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"allName CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
        if (_researchdataSourceArray.count > 0) {
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]byExtendingSelection:NO];
            [self changeSonTableViewData:0];
        }else{
            [self changeSonTableViewData:0];
        }
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]byExtendingSelection:NO];
        [self changeSonTableViewData:0];
    }
    
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    
    int checkCount = 0;
    for (int i=0; i<[disAry count]; i++) {
        IMBContactEntity *bookMark = [disAry objectAtIndex:i];
        if (bookMark.checkState == NSOnState) {
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

- (void)startAnimation {
    [_animtionView setWantsLayer:YES];
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"position"];
    animation1.duration = 3; // 持续时间
    animation1.repeatCount = NSIntegerMax; // 重复次数
    animation1.autoreverses = NO;
    animation1.fromValue = [NSValue valueWithPoint:NSMakePoint(-100, 0)]; // 起始帧
    animation1.toValue = [NSValue valueWithPoint:NSMakePoint(500 , 0)];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _animtionView.layer.contents = [StringHelper imageNamed:@"transfer_light"];
    [_animtionView.layer addAnimation:animation1 forKey:@""];
}

- (void)stopAnimation {
    [_animtionView.layer removeAllAnimations];
}

#pragma iCloud OperationAction 

- (void)iCloudReload:(id)sender {
    [_toolBar toolBarButtonIsEnabled:NO];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Contact Refresh" label:Start transferCount:0 screenView:@"Contact View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
        [_mainBox setContentView:_loadingView];
        [_loadingAnimationView startAnimation];
    _isiCloudAddEditView = NO;
    _isEditing = NO;
    _iCloudAdd = NO;
    [_toolBar toolBarButtonIsEnabled:NO];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_iCloudManager getContactContent];
        if (_dataSourceArray != nil) {
            [_dataSourceArray release];
            _dataSourceArray = nil;
        }
        _dataSourceArray = [_iCloudManager.contactArray retain];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_toolBar toolBarButtonIsEnabled:YES];
            [_editBox setContentView:nil];
            
            NSInteger selecteRow = [_itemTableView selectedRow];
            if (selecteRow < _dataSourceArray.count) {
                [_itemTableView deselectAll:nil];
                [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selecteRow] byExtendingSelection:YES];
            }
            [_itemTableView reloadData];
            if (_dataSourceArray.count>0) {
                [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
            }
            if (_dataSourceArray.count == 0) {
                [_mainBox setContentView:_noDataView];
            }else {
                [_mainBox setContentView:_detailView];
            }
            if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
            }
            [_loadingAnimationView endAnimation];
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Contact Refresh" label:Finish transferCount:0 screenView:@"Contact View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
        });
    });
}

- (void)addiCloudItems:(id)sender {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Contact Add" label:Start transferCount:0 screenView:@"Contact View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    _iCloudAdd = YES;
    IMBiCloudContactEntity *iCloudEntity = [[IMBiCloudContactEntity alloc] init];
    [_dataSourceArray insertObject:iCloudEntity atIndex:0];
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        [_mainBox setContentView:_detailView];
    }
    [_itemTableView reloadData];
    
    CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
    NSString *guid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
    iCloudEntity.contactId = guid;
    if (_contactiCloudEntity != nil) {
        [_contactiCloudEntity release];
        _contactiCloudEntity = nil;
    }
    _contactiCloudEntity = [iCloudEntity retain];
    [self generateiCloudContactView:_contactiCloudEntity];
    [self setIsEditing];
    _onlySelectedRow = YES;
    [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    _onlySelectedRow = NO;
    _isiCloudAddEditView = YES;
    [iCloudEntity release];
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Contact Add" label:Finish transferCount:0 screenView:@"Contact View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [_toolBar toolBarButtonIsEnabled:NO];
}

- (void)deleteiCloudItems:(id)sender {
    if (_iCloudAdd) {
        return;
    }
    NSMutableArray *arrayM = [[NSMutableArray alloc]init];
    for (IMBiCloudContactEntity *entity in _dataSourceArray) {
        if (entity.checkState == Check) {
            [arrayM addObject:entity];
        }
    }
    if (arrayM.count > 0) {
        NSString *str;
        if (arrayM.count > 1) {
            str = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete", nil);
        }else {
            str = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete_2", nil);
        }
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        int i = [_alertView showDeleteConfrimText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)  CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
        if (i == 0) {
            return;
        }
    }else {
        //弹出警告确认框
        NSString *str = nil;
        if (_dataSourceArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_delete", nil),CustomLocalizedString(@"MenuItem_id_61", nil)];
        }else {
            str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        }
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    
    [_mainBox setContentView:_loadingView];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Contact Delete" label:Start transferCount:arrayM.count screenView:@"Contact View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [_loadingAnimationView startAnimation];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [_iCloudManager deleteContact:arrayM];
        [_iCloudManager getContactContent];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (_dataSourceArray != nil) {
                [_dataSourceArray release];
                _dataSourceArray = nil;
            }
            _dataSourceArray = [_iCloudManager.contactArray retain];
            if (_dataSourceArray.count == 0) {
                [_mainBox setContentView:_noDataView];
                [self configNoDataView];
            }else {
                [_mainBox setContentView:_detailView];
            }
            if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
            }
            [_loadingAnimationView endAnimation];
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Contact Delete" label:Finish transferCount:arrayM.count screenView:@"Contact View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            [_itemTableView reloadData];
            
            if (_dataSourceArray.count > 0) {
                [_itemTableView reloadData];
                [self tableViewSelectRow:0];
            }
        });
        [arrayM autorelease];
    });

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
        if (baseInfoArr.count ==1) {
            NSMutableArray *arrayM = [[NSMutableArray alloc]init];
            for (IMBiCloudContactEntity *entity in _dataSourceArray) {
                if (entity.checkState == Check) {
                    IMBiCloudContactEntity *transEntity = [entity mutableCopy];
                    CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
                    NSString *guid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
                    [transEntity setContactId:guid];
                    [transEntity setEtag:@""];
                    [transEntity setImageSign:@""];
                    [arrayM addObject:transEntity];
                    [transEntity release];
                }
            }
            if (arrayM.count > 0) {
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Contact To iCloud" label:Start transferCount:arrayM.count screenView:@"Contact View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                _icloudTransCount = (int)arrayM.count;
                if (_transferController != nil) {
                    [_transferController release];
                    _transferController = nil;
                }
                IMBBaseInfo *baseInfo = [baseInfoArr objectAtIndex:0];
                NSDictionary *iCloudDic = [_delegate getiCloudAccountViewCollection];
                _otheriCloudManager = [[iCloudDic objectForKey:baseInfo.uniqueKey] iCloudManager];
                [_otheriCloudManager setDelegate:self];
                _transferController = [[IMBTransferViewController alloc] initWithType:Category_Contacts withDelegate:self withTransfertype:TransferSync withIsicloudView:YES];
                [_transferController setDelegate:self];
                _transferController.isicloudView = YES;
//                [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:nil];
                     [self animationAddTransferView:_transferController.view];
                if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
                    [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_20", nil)]];
                }
                NSString *msgStr = CustomLocalizedString(@"ImportSync_id_1", nil);
                if ([_transferController respondsToSelector:@selector(transferFile:)]) {
                    [_transferController transferFile:msgStr];
                }

                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    //每次都必须请求一次数据；
                    [_otheriCloudManager getContactContent];
                    [_otheriCloudManager importContact:arrayM];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSDictionary *dimensionDict = nil;
                        @autoreleasepool {
                            dimensionDict = [[TempHelper customDimension] copy];
                        }
                        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Contact To iCloud" label:Finish transferCount:arrayM.count screenView:@"Contact View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                        if (dimensionDict) {
                            [dimensionDict release];
                            dimensionDict = nil;
                        }
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

- (void)onItemiCloudClicked:(id)sender{

    [_toDevicePopover close];
    NSMutableArray *arrayM = [[NSMutableArray alloc]init];
    for (IMBiCloudContactEntity *entity in _dataSourceArray) {
        if (entity.checkState == Check) {
            IMBiCloudContactEntity *transEntity = [entity mutableCopy];
            CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
            NSString *guid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
            [transEntity setContactId:guid];
            [transEntity setEtag:@""];
            [arrayM addObject:transEntity];
            [transEntity release];
        }
    }
    if (arrayM.count > 0) {
        _icloudTransCount = (int)arrayM.count;
        if (_transferController != nil) {
            [_transferController release];
            _transferController = nil;
        }
        IMBBaseInfo *baseInfo = (IMBBaseInfo *)sender;
        NSDictionary *iCloudDic = [_delegate getiCloudAccountViewCollection];
        _otheriCloudManager = [[iCloudDic objectForKey:baseInfo.uniqueKey] iCloudManager];
        [_otheriCloudManager setDelegate:self];
        _transferController = [[IMBTransferViewController alloc] initWithType:Category_iCloudDriver withDelegate:self withTransfertype:TransferSync];
        [_transferController setDelegate:self];
        _transferController.isicloudView = YES;
//        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:nil];
             [self animationAddTransferView:_transferController.view];
        if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_20", nil)]];
        }

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //每次都必须请求一次数据；
            [_otheriCloudManager getContactContent];
            [_otheriCloudManager importContact:arrayM];
        });
    }else {
        //弹出警告确认框
        NSString *str = nil;
        str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }
}

- (void)transfranDic:(NSDictionary *)contacDic {
//    NSDictionary *dic = noti.object;
    NSArray *dataAry = nil;
    int count = 0;
    if (contacDic != nil){
       dataAry = [contacDic objectForKey:@"contacts"];
        count = (int)dataAry.count;
    }

    for (int i = 0; i <= 100; i++) {
        if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
            [_transferController transferProgress:i];
        }
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_iCloudManager getContactContent];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                [_transferController transferComplete:count TotalCount:_icloudTransCount];
            }
        });
    });
}

- (void)showEditErrorTip {
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_iCloud_Modify_Failed", nil),CustomLocalizedString(@"MenuItem_id_83", nil)];
    [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
}

- (void)showAddErrorTip {
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_iCloud_Add_Failed", nil),CustomLocalizedString(@"MenuItem_id_83", nil)];
    [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
}

- (void)showDeleteErrorTip {
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_iCloud_Delete_Failed", nil),CustomLocalizedString(@"MenuItem_id_83", nil)];
    [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
}

- (void)reloadTableView {
    _isSearch = NO;
    [_itemTableView reloadData];
    if (_dataSourceArray.count > 0) {
        if (_isEditing && _dataSourceArray.count > 1) {
            [self setIsCanceling];
        }
        NSInteger row = [_itemTableView selectedRow];
        if (row != 0) {
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        }else {
            [_showFlippedView setHidden:NO];
            if (_isiCloudView) {
                if (_contactiCloudEntity != nil) {
                    [_contactiCloudEntity release];
                    _contactiCloudEntity = nil;
                }
                _contactiCloudEntity = [[_dataSourceArray objectAtIndex:0] retain];
                [self generateiCloudContactView:_contactiCloudEntity];
            }else {
                if (_contactEntity != nil) {
                    [_contactEntity release];
                    _contactEntity = nil;
                }
                _contactEntity = [[_dataSourceArray objectAtIndex:0] retain];
                [self generateContactView:_contactEntity];
            }
            _selecteRow = 0;
            _iCloudAdd = NO;
            [_toolBar toolBarButtonIsEnabled:YES];
        }
    }
}

- (void)netWorkFaultInterrupt {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertText:CustomLocalizedString(@"iCloudLogin_View_Tips2", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OPENSHEETNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGECONTEACIMAGE_REDEVICENAME object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTITY_NETWORK_FAULT_INTERRUPT object:nil];
    
    if (_showFlippedView != nil) {
        [_showFlippedView release];
        _showFlippedView = nil;
    }
    if (_contactManager != nil) {
        [_contactManager release];
        _contactManager = nil;
    }
    [super dealloc];
}

@end
