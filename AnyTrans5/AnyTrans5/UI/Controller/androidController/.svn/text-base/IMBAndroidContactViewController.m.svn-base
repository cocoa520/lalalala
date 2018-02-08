//
//  IMBAndroidContactViewController.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-27.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBAndroidContactViewController.h"
#import "IMBCenterTextFieldCell.h"
#import "IMBHelper.h"
#import "IMBADContactEntity.h"
#import "IMBSoftWareInfo.h"
#import "NSString+Category.h"
#import "ColorHelper.h"
#import "IMBContactTextFieldCell.h"
#import "IMBImageAndTextCell.h"
#import "IMBChineseSortHelper.h"
#include <stdio.h>
#import "StringHelper.h"
#import "ContactConversioniCloud.h"
#import "IMBADContactToiCloud.h"
#import "IMBAndroidMainPageViewController.h"

@implementation IMBAndroidContactViewController
@synthesize headImageView = _headImageView;
@synthesize nameTextField = _nameTextField;
@synthesize subTextField = _subTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initwithAndroid:(IMBAndroid *)android withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate{
    if ([super initwithAndroid:android withCategoryNodesEnum:category withDelegate:delegate]) {
        _isAndroid = YES;
        _dataSourceArray = [android.adContact.reslutEntity.reslutArray retain];
        _resultEntity = [android.adContact.reslutEntity retain];
    }
    return self;
}

-(void)registerSucceed {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_itemTableView reloadData];
        NSInteger row = [_itemTableView selectedRow];
        [self changeSonTableViewData:row];
    });
}

-(void)awakeFromNib{
    _isloadingPopBtn = YES;
    _isAndroid = YES;
    [super awakeFromNib];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_itemTableView setDelegate:self];
    [_itemTableView setDataSource:self];
    [_itemTableView setListener:self];
    _itemTableView.menu.delegate = self;
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [_rightLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_itemTableView setBackgroundColor:[NSColor clearColor]];
    if (_dataSourceArray.count == 0) {
        [self configNoDataView];
        [_mainBox setContentView:_nodataView];
    }else {
        [_mainBox setContentView:_detailView];
        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]byExtendingSelection:NO];
    }
    _itemArray = [[NSMutableArray alloc] initWithArray:_dataSourceArray];
    [_topWhiteView setIsBommt:YES];
    NSRect rect = [IMBHelper calcuTextBounds:CustomLocalizedString(@"Detail_Control_Header_SortByName", nil) fontSize:12];
    [_sortRightPopuBtn setFrame:NSMakeRect(_topWhiteView.frame.size.width- rect.size.width -14,_sortRightPopuBtn.frame.origin.y  , rect.size.width +10, _sortRightPopuBtn.frame.size.height)];
    _sortName = @"sortStr";
    _headImageLayer = [[CALayer alloc]init];
    _headImageLayer.frame = CGRectMake(30, 463, 62, 62);
     [_headImageLayer setCornerRadius:31];
    [_rootView setWantsLayer:YES];
    [_headImageLayer setMasksToBounds:YES];
    [_rootView.layer addSublayer:_headImageLayer];
    [_headImageLayer setAutoresizingMask:NSViewMaxXMargin | NSViewMinYMargin];
    
}

#pragma mark - NSTextView
- (void)configNoDataView {
    [_nodataImageView setImage:[StringHelper imageNamed:@"noData_contact"]];
    [_textView setDelegate:self];
    [_textView setSelectable:YES];
    NSString *overStr1 = CustomLocalizedString(@"noData_subTitle1", nil);
    NSString *promptStr1 = [[[NSString stringWithFormat:CustomLocalizedString(@"noData_subTitle", nil),CustomLocalizedString(@"MenuItem_id_61", nil)] stringByAppendingString:@" "] stringByAppendingString:overStr1];
    NSString *promptStr = [[[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_61", nil)] stringByAppendingString:@" "]stringByAppendingString:promptStr1];
    
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_textView setLinkTextAttributes:linkAttributes];
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = [promptStr rangeOfString:overStr1];
    [promptAs addAttribute:NSLinkAttributeName value:overStr1 range:infoRange];
    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_textView textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
}

#pragma mark - textView Delegate
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex {
    NSString *overStr = CustomLocalizedString(@"noData_subTitle1", nil);
    if ([link isEqualToString:overStr]) {
        NSLog(@"控制apk将手机界面显示为权限管理的界面");
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSView *view = nil;
            for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
                if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                    view = subView;
                    break;
                }
            }
            if (view) {
                [view setHidden:NO];
                [_androidAlertViewController setAndroid:_android];
                [_androidAlertViewController showNoDataAlertViewWithSuperView:view];
            }
            
        });
    }
    return YES;
}
#pragma mark - NSTableViewDataSource,NSTableViewDelegate相关方法
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_isSearch) {
        return _researchdataSourceArray.count;
    }else {
        return _itemArray.count;
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else{
        displayArr = _itemArray;
    }
    if (displayArr != nil && displayArr.count >row) {
        IMBADContactEntity *contactData = [displayArr objectAtIndex:row];
        if ([tableColumn.identifier isEqualToString:@"Title"]) {
            NSString *nameStr = @"";
            if ([IMBSoftWareInfo singleton].isRegistered) {
                nameStr = contactData.contactSortName;
            }else{
                if (contactData.isDeleted) {
                    nameStr = [IMBHelper isaddMosaicTextStr:contactData.contactSortName];
                }else{
                    nameStr = contactData.contactSortName;
                }
            }
           
            return nameStr;
        }else if ([tableColumn.identifier isEqualToString:@"CheckCol"]){
            return [NSNumber numberWithBool:contactData.checkState];
        }
    }
    return @"";
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([@"Title" isEqualToString:tableColumn.identifier]) {
        NSArray *displayArr = nil;
        if (_isSearch) {
            displayArr = _researchdataSourceArray;
        }else{
            displayArr = _itemArray;
        }
        if (displayArr != nil && displayArr.count >row) {
            IMBADContactEntity *contactData = [displayArr objectAtIndex:row];
            IMBContactTextFieldCell *contactTextCell = (IMBContactTextFieldCell *)cell;
            contactTextCell.isExistAndDeleted = contactData.isHaveExistAndDeleted;
            contactTextCell.isDeleted = contactData.isDeleted;
        }
    }else if ([@"Image" isEqualToString:tableColumn.identifier]) {
        IMBImageAndTextCell *imageCell = (IMBImageAndTextCell *)cell;
        imageCell.marginX = 12;
        imageCell.paddingX = 0;
        [imageCell setImageSize:NSMakeSize(30, 30)];
        NSArray *displayArr = nil;
        if (_isSearch) {
            displayArr = _researchdataSourceArray;
        }else{
            displayArr = _itemArray;
        }
        [imageCell setImageSize:NSMakeSize(30, 30)];
        imageCell.marginX = 8;
        imageCell.paddingX = 3;
        IMBADContactEntity *entity = [displayArr objectAtIndex:row];
        if (entity.imageData != nil) {
            NSImage *newImage = [[NSImage alloc]initWithData:entity.imageData];
            NSImage *cutImage = [IMBHelper cutImageWithImage:newImage border:0];
            [imageCell setIsDataImage:YES];
            [imageCell setImage:cutImage];
            [newImage release];
        }else{
            [imageCell setImage:[StringHelper imageNamed:@"def"]];
        }
    }
}

-(void)tableView:(NSTableView *)tableView row:(NSInteger)index{
    if (_isSearch) {
        IMBADContactEntity *contactData = [_researchdataSourceArray objectAtIndex:index];
        contactData.checkState = !contactData.checkState;
    }else{
        IMBADContactEntity *contactData = [_itemArray objectAtIndex:index];
        contactData.checkState = !contactData.checkState;
    }
    int count = 0;
    for (IMBADContactEntity *contactData in _itemArray) {
        if (contactData.checkState == Check) {
            count ++;
        }
    }
//    _resultEntity.selectedCount = count;
//    if (count == _itemArray.count) {
//        [(IMBScanDeviceViewController *)_delegate checkBoxState:Check WithScanTypeEnum:ScanContactFile withSelectCount:count];
//    }else if (count == 0){
//        [(IMBScanDeviceViewController *)_delegate checkBoxState:UnChecked WithScanTypeEnum:ScanContactFile withSelectCount:count];
//    }else{
//        [(IMBScanDeviceViewController *)_delegate checkBoxState:SemiChecked WithScanTypeEnum:ScanContactFile withSelectCount:count];
//    }
    [_itemTableView reloadData];
}

- (BOOL)tableView:(NSTableView *)tableView shouldShowCellExpansionForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return NO;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 56;
}

-(void)checkBoxState:(CheckStateEnum)checkState{
    for (IMBADContactEntity *contactData in _itemArray) {
        contactData.checkState = checkState;
    }
    if (checkState == Check) {
//        _resultEntity.selectedCount = _resultEntity.reslutCount;
    }else {
//        _resultEntity.selectedCount = 0;
    }
    [_itemTableView reloadData];
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
      NSTableView *atableView = [aNotification object];
      NSInteger row = [atableView selectedRow];
    if (row != -1) {
        [self changeSonTableViewData:row];
    }
}

#pragma mark - 全选
- (IBAction)tableViewLeftSelectBtnDowm:(id)sender {
    NSMenuItem *item = [_selectSortBtn selectedItem];
    NSInteger tag = [_selectSortBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _selectSortBtn.itemArray) {
        [menuItem setState:NSOffState];
    }
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else{
        displayArr = _itemArray;
    }
    if (tag == 1) {
        for (IMBADContactEntity *note in displayArr) {
            note.checkState = Check;
        }
    }else if (tag == 2){
        for (IMBADContactEntity *note in displayArr) {
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
    [_selectSortBtn setFrame:NSMakeRect(-2,_selectSortBtn.frame.origin.y , wide +10, _selectSortBtn.frame.size.height)];
    [_selectSortBtn setTitle:[_selectSortBtn titleOfSelectedItem]];
    [_itemTableView reloadData];
}

#pragma mark - 排序
- (IBAction)tableViewRightSortBtnDown:(id)sender {
    NSInteger selectedTag = [_itemTableView selectedRow];
    NSMenuItem *item = [_sortRightPopuBtn selectedItem];
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
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:_sortName ascending:_isAscending selector:@selector(compare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        if (_isSearch) {
            [_researchdataSourceArray sortUsingDescriptors:sortDescriptors];
        }else{
            [_itemArray sortUsingDescriptors:sortDescriptors];
        }
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
    }else if (item.tag == 2){
        
    }else if (item.tag == 3){
        _isAscending = YES;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:_sortName ascending:_isAscending selector:@selector(compare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        if (_isSearch) {
            [_researchdataSourceArray sortUsingDescriptors:sortDescriptors];
        }else{
            [_itemArray sortUsingDescriptors:sortDescriptors];
        }
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
    }else if (item.tag == 4){
        _isAscending = NO;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:_sortName ascending:_isAscending selector:@selector(compare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        if (_isSearch) {
            [_researchdataSourceArray sortUsingDescriptors:sortDescriptors];
        }else{
            [_itemArray sortUsingDescriptors:sortDescriptors];
        }
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
    }
    NSMutableArray *ary = nil;
    if (_isSearch) {
        ary = _researchdataSourceArray;
    }else{
        ary = _itemArray;
    }
    IMBADContactEntity *contactData = [ary objectAtIndex:selectedTag];
    [self showSingleContactContent:contactData];
}

- (void)changeSonTableViewData:(NSInteger)row {
    NSInteger count = 0;
    if (_isSearch) {
        count = _researchdataSourceArray.count;
    }else{
        count = _itemArray.count;
    }
    if (count == 0) {
        [_subTextField setHidden:YES];
        [_nameTextField setHidden:YES];
        [_headImageLayer setHidden:YES];
        NSArray *views = _contentCustomView.subviews;
        if (views != nil && views.count > 0) {
            for (long i = views.count - 1; i >= 0; i--) {
                NSView *view = [views objectAtIndex:i];
                [view removeFromSuperview];
            }
        }
    } else {
        if (_itemArray != nil && _itemArray.count > 0) {
            if (_isSearch) {
                IMBADContactEntity *entity = [_researchdataSourceArray objectAtIndex:row];
                if (_currentContactData != nil) {
                    [_currentContactData release];
                    _currentContactData = nil;
                }
                _currentContactData = [entity retain];
                [self showSingleContactContent:entity];
            }else{
                IMBADContactEntity *entity = [_itemArray objectAtIndex:row];
                if (_currentContactData != nil) {
                    [_currentContactData release];
                    _currentContactData = nil;
                }
                _currentContactData = [entity retain];
                [self showSingleContactContent:entity];
            }
        }
    }
}

- (void)showSingleContactContent:(IMBADContactEntity *)entity {
    if (entity != nil) {
        [_headImageLayer setHidden:NO];
//        [_headImageLayer setWantsLayer:YES];
        if (entity.imageData != nil) {
            NSImage *newImage = [[NSImage alloc] initWithData:entity.imageData];
//            [_headImageView setImage:newImage];
            [_headImageLayer setContents:newImage];
        }else {
//            [_headImageView setImage:[StringHelper imageNamed:@"contact_show"]];
            [_headImageLayer setContents:[StringHelper imageNamed:@"contact_show"]];
        }
        [_nameTextField setHidden:NO];
        NSString *name = entity.contactSortName;
        if (entity.contactNickName != nil && ![IMBHelper stringIsNilOrEmpty:entity.contactNickName.value]) {
            name = [name stringByAppendingString:[NSString stringWithFormat:@"(%@)",entity.contactNickName.value]];
        }
        NSString *nameStr = @"";
        if ([IMBSoftWareInfo singleton].isRegistered) {
            nameStr = name;
        }else{
            if (entity.isDeleted) {
                nameStr = [IMBHelper isaddMosaicTextStr:name];
            }else{
                nameStr = name;
            }
        }
        
       
        if (entity.isDeleted && !entity.isHaveExistAndDeleted) {
            NSMutableAttributedString *deleteStr = [self stringDeleteStyle:nameStr];
            [_nameTextField setAttributedStringValue:deleteStr];
        }else {
            if (!entity.isDeleted) {
                [_nameTextField setStringValue:nameStr?:@""];
                [_nameTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            }else {
                if (entity.contactNickName != nil && ![IMBHelper stringIsNilOrEmpty:entity.contactNickName.value] && entity.contactNickName.isDeleted) {
                    //名字（昵称）---名字为一般颜色，昵称为删除颜色；
                    NSRange nickRange = [name rangeOfString:entity.contactNickName.value];
                    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:name];
                    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
                    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)] range:nickRange];
                     [_nameTextField setAttributedStringValue:as];
                    [as release], as = nil;

                }else {
                    [_nameTextField setStringValue:entity.contactSortName?:@""];
                    [_nameTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                }
            }
        }
        
        NSString *companyNameJob = @"";
        if (entity.companyName != nil && ![IMBHelper stringIsNilOrEmpty:entity.companyName.value]) {
            companyNameJob = [companyNameJob stringByAppendingString: entity.companyName.value];
        }
        if (entity.companyJob != nil && ![IMBHelper stringIsNilOrEmpty:entity.companyJob.value]) {
            if (entity.companyName != nil && ![IMBHelper stringIsNilOrEmpty:entity.companyName.value]) {
                companyNameJob = [[companyNameJob stringByAppendingString:@" "] stringByAppendingString:entity.companyJob.value];
            }else {
                 companyNameJob = [companyNameJob stringByAppendingString:entity.companyJob.value];
            }
        }
        if ([IMBSoftWareInfo singleton].isRegistered) {
            nameStr = companyNameJob;
        }else{
            if (entity.isDeleted) {
                nameStr = [IMBHelper isaddMosaicTextStr:companyNameJob];
            }else{
                nameStr = companyNameJob;
            }

        }
        if (entity.isDeleted) {
            NSMutableAttributedString *deleteStr = [self stringDeleteStyle:nameStr];
            [_subTextField setAttributedStringValue:deleteStr];
        }else {
            NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:companyNameJob];
            [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.length)];
            if (!entity.isDeleted) {
                [_subTextField setStringValue:companyNameJob];
                [_subTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
            }else {
                if (entity.companyName != nil && ![IMBHelper stringIsNilOrEmpty:entity.companyName.value] && entity.companyName.isDeleted) {
                    NSRange companyRange = [companyNameJob rangeOfString:entity.companyName.value];
                    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)] range:companyRange];
                }
                if (entity.companyJob != nil && ![IMBHelper stringIsNilOrEmpty:entity.companyJob.value] && entity.companyJob.isDeleted) {
                    NSRange jobRange = [companyNameJob rangeOfString:entity.companyJob.value];
                    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)] range:jobRange];
                }
            }
            [_subTextField setAttributedStringValue:as];
            [as release], as = nil;
        }
        if(companyNameJob.length < 1) {
            [_nameTextField setFrameOrigin:NSMakePoint(_nameTextField.frame.origin.x, self.view.frame.size.height - 50)];
        }else {
            [_nameTextField setFrameOrigin:NSMakePoint(_nameTextField.frame.origin.x, self.view.frame.size.height - 45)];
        }
        
        [self showContentVeiw:entity];
    }else{
        NSArray *views = _contentCustomView.subviews;
        if (views != nil && views.count > 0) {
            for (long i = views.count - 1; i < views.count; i--) {
                NSView *view = [views objectAtIndex:i];
                [view removeFromSuperview];
            }
        }
        [_nameTextField setStringValue:@"  "];
        [_subTextField setStringValue:@" "];
        [_headImageLayer setHidden:YES];
    }
}

- (void)showContentVeiw:(IMBADContactEntity *)entity {
    float height = 0;
    _count = -1;
    NSArray *views = _contentCustomView.subviews;
    if (views != nil && views.count > 0) {
        for (long i = views.count - 1; i < views.count; i--) {
            NSView *view = [views objectAtIndex:i];
            [view removeFromSuperview];
        }
    }
    
    if (entity.phoneData != nil && entity.phoneData.count > 0) {
        for (IMBContactLabelValueEntity *multe in entity.phoneData) {
            _count += 1;
            [self setHomeTextString:multe.lable withCounts:_count];
            _count += 1;
            NSString *amosaicStr = @"";
            if (![IMBSoftWareInfo singleton].isRegistered) {
                NSString *endStr = @"";
                if (multe.isDeleted) {
                     endStr = [IMBHelper isaddMosaicTextStr:multe.value];
                }else{
                    endStr = multe.value;
                }
               
                if (endStr != nil) {
                    amosaicStr = endStr;
                }else{
                    amosaicStr = multe.value;
                }
            }else{
                amosaicStr = multe.value;
            }
            [self setTextViewString:amosaicStr withCounts:_count withIsDelete:multe.isDeleted];
        }
        _count += 1;
        [self setLineWhiteViewCount:_count];
    }
    
    if (entity.emailData != nil && entity.emailData.count > 0) {
        for (IMBContactLabelValueEntity *multe in entity.emailData) {
            _count += 1;
            [self setHomeTextString:multe.lable withCounts:_count];
            _count += 1;
            NSString *amosaicStr = @"";
            if (![IMBSoftWareInfo singleton].isRegistered) {
                NSString *endStr = @"";
                if (multe.isDeleted) {
                    endStr = [IMBHelper isaddMosaicTextStr:multe.value];
                }else{
                    endStr = multe.value;
                }
                if (endStr != nil) {
                    amosaicStr = endStr;
                }else{
                    amosaicStr = multe.value;
                }
            }else{
                amosaicStr = multe.value;
            }
            [self setTextViewString:amosaicStr withCounts:_count withIsDelete:multe.isDeleted];
        }
        _count += 1;
        [self setLineWhiteViewCount:_count];
    }
    
    if (entity.websiteData != nil && entity.websiteData.count > 0) {
        for (IMBContactLabelValueEntity *item in entity.websiteData) {
            _count += 1;
            [self setHomeTextString:CustomLocalizedString(@"contactLable_website", nil) withCounts:_count];
            _count += 1;
            NSString *nameStr = @"";
            if ([IMBSoftWareInfo singleton].isRegistered) {
                nameStr = item.value;
            }else{
                if (item.isDeleted) {
                    nameStr = [IMBHelper isaddMosaicTextStr:item.value];
                }else{
                    nameStr = item.value;
                }
            }
            
            [self setTextViewString:nameStr withCounts:_count withIsDelete:item.isDeleted];
        }
        _count += 1;
        [self setLineWhiteViewCount:_count];
    }
    
    if (entity.addressData != nil && entity.addressData.count > 0) {
        for (IMBContactLabelValueEntity *multe in entity.addressData) {
            _count += 1;
            [self setHomeTextString:multe.lable withCounts:_count];
            _count += 1;
            NSString *amosaicStr = @"";
            if (![IMBSoftWareInfo singleton].isRegistered) {
                NSString *endStr = @"";
                if (multe.isDeleted) {
                    endStr = [IMBHelper isaddMosaicTextStr:multe.value];
                }else{
                    endStr = multe.value;
                }
//                NSString *endStr = [IMBHelper isaddMosaicTextStr:multe.value];
                if (endStr != nil) {
                    amosaicStr = endStr;
                }else{
                    amosaicStr = multe.value;
                }
            }else{
                amosaicStr = multe.value;
            }
            [self setTextViewString:amosaicStr withCounts:_count withIsDelete:multe.isDeleted];
        }
        _count += 1;
        [self setLineWhiteViewCount:_count];
    }
    
    if (entity.eventData != nil && entity.eventData.count > 0) {
        for (IMBContactLabelValueEntity *multe in entity.eventData) {
            _count += 1;
            [self setHomeTextString:multe.lable withCounts:_count];
            _count += 1;
            if (multe.isDeleted == YES) {
                NSString *nameStr = @"";
                if ([IMBSoftWareInfo singleton].isRegistered) {
                    nameStr = multe.value;
                    //[IMBHelper longToDateString:[multe.value doubleValue] withMode:0];
                }else{
                    nameStr = [IMBHelper isaddMosaicTextStr:multe.value ];
                }
                
                NSMutableAttributedString *deleteStr = [self stringDeleteStyle:nameStr];
                [self setTextViewStringFromDeleted:deleteStr withCounts:_count];
            }else {
                [self setTextViewString:multe.value withCounts:_count withIsDelete:NO];
            }
        }
        _count += 1;
        [self setLineWhiteViewCount:_count];
    }

    if (entity.relationData != nil && entity.relationData.count > 0) {
        for (IMBContactLabelValueEntity *multe in entity.relationData) {
            _count += 1;
            [self setHomeTextString:multe.lable withCounts:_count];
            _count += 1;
            NSString *amosaicStr = @"";
            if (![IMBSoftWareInfo singleton].isRegistered) {
                NSString *endStr = @"";
                if (multe.isDeleted) {
                    endStr = [IMBHelper isaddMosaicTextStr:multe.value];
                }else{
                    endStr = multe.value;
                }
                if (endStr != nil) {
                    amosaicStr = endStr;
                }else{
                    amosaicStr = multe.value;
                }
            }else{
                amosaicStr = multe.value;
            }
            [self setTextViewString:amosaicStr withCounts:_count withIsDelete:multe.isDeleted];
        }
        _count += 1;
        [self setLineWhiteViewCount:_count];
    }

    if (entity.imData != nil && entity.imData.count > 0) {
        for (IMBContactLabelValueEntity *multe in entity.imData) {
            _count += 1;
            [self setHomeTextString:multe.lable withCounts:_count];
            _count += 1;
            NSString *amosaicStr = @"";
            if (![IMBSoftWareInfo singleton].isRegistered) {
                NSString *endStr = @"";
                if (multe.isDeleted) {
                    endStr = [IMBHelper isaddMosaicTextStr:multe.value];
                }else{
                    endStr = multe.value;
                }
                if (endStr != nil) {
                    amosaicStr = endStr;
                }else{
                    amosaicStr = multe.value;
                }
            }else{
                amosaicStr = multe.value;
            }
            [self setTextViewString:amosaicStr withCounts:_count withIsDelete:multe.isDeleted];
        }
        _count += 1;
        [self setLineWhiteViewCount:_count];
    }

    if (entity.contactNote != nil && ![IMBHelper stringIsNilOrEmpty:entity.contactNote.value]) {
        _count += 1;
        [self setHomeTextString:[CustomLocalizedString(@"contact_id_91", nil) stringByAppendingString:@":"] withCounts:_count];
        _count += 1;
        NSTextView *textView = [[NSTextView alloc] init];
        [textView setEditable:YES];
        [textView setSelectable:YES];
        [textView setDrawsBackground:NO];
        [textView setFrame:NSMakeRect(10, (_count * 20), _contentCustomView.frame.size.width - 20., 40)];
        NSString *amosaicStr = @"";
        if (![IMBSoftWareInfo singleton].isRegistered) {
            NSString *endStr = @"";
            if (entity.isDeleted) {
                endStr = [IMBHelper isaddMosaicTextStr:entity.contactNote.value];
            }else{
                endStr = entity.contactNote.value;
            }
            if (endStr != nil) {
                amosaicStr = endStr;
            }else{
                amosaicStr = entity.contactNote.value;
            }
        }else{
            amosaicStr = entity.contactNote.value;
        }
        height = [self setTextViewForString:amosaicStr withTextVeiw:textView withDelete:entity.contactNote.isDeleted];
        [textView setEditable:NO];
        [textView setSelectable:NO];
        [textView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [textView setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin|NSViewWidthSizable];
        [_contentCustomView addSubview:textView];
        [textView release];
    }else {
        height = 15;
    }
    
    [_contentCustomView setFrameSize:NSMakeSize(_contentCustomView.frame.size.width, (_count * 21) + height)];
}

- (void)setTextViewString:(NSString *)textString withCounts:(int)count withIsDelete:(BOOL)isdelete {
    if ([textString contains:@"\n"]) {
        textString = [textString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    }
    NSTextView *textView = [[NSTextView alloc] init];
    [textView setEditable:YES];
    [textView setSelectable:YES];
    [textView setAlignment:NSLeftTextAlignment];
    [textView setDrawsBackground:NO];
    [textView setString:textString];
    if (isdelete) {
        [textView setTextColor:[NSColor redColor]];
    }else{
        [textView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    }
    
    [textView setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [textView setFrame:NSMakeRect(8, (count * 20) + 4, _contentCustomView.frame.size.width - 24, 40)];
    float hight = [self getTextViewForStringHight:textString withTextVeiw:textView withDelete:isdelete];
    if (hight > 40) {
        [textView setFrame:NSMakeRect(8, (count * 20) + 4, _contentCustomView.frame.size.width - 24, hight + 10)];
        _count += ceil((hight - 40) / 20.0);
    }
    
    [textView setEditable:NO];
    [textView setSelectable:NO];
    [textView setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin|NSViewWidthSizable];
    [_contentCustomView addSubview:textView];
    [textView release];
}

- (float)getTextViewForStringHight:(NSString *)myString withTextVeiw:(NSTextView *)textView  withDelete:(BOOL)isDeleted {
    NSMutableAttributedString *drawStr = [[[NSMutableAttributedString alloc] initWithString:myString] autorelease];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:myString];
    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(textView.frame.size.width, FLT_MAX)] autorelease];
    
    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:2.0f];
    [textParagraph setAlignment:NSLeftTextAlignment];
    [textParagraph setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *fontDic = nil;
    
    if (isDeleted) {
        fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, [NSColor redColor], NSForegroundColorAttributeName, [NSFont fontWithName:@"Helvetica Neue" size:12], NSFontAttributeName, nil];
    }else {
        fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, [NSFont fontWithName:@"Helvetica Neue" size:12], NSFontAttributeName, [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,nil];
    }

    NSRect rect = [myString boundingRectWithSize:NSMakeSize(645, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDic];//textView.frame.size.width
    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
    [drawStr addAttributes:fontDic range:NSMakeRange(0, textStorage.length)];
    float changeHeight = rect.size.height;
    if (changeHeight > 36) {
        changeHeight += 20;
    }
    [textView setFrameSize:NSMakeSize(textView.frame.size.width, changeHeight)];
    [[textView textStorage] setAttributedString:drawStr];
    [textStorage release];
    
    return changeHeight;
}

- (void)setTextViewStringFromDeleted:(NSMutableAttributedString *)textString withCounts:(int)count {
    NSTextView *textView = [[NSTextView alloc] init];
    [textView setEditable:YES];
    [textView setSelectable:YES];
    [textView setAlignment:NSLeftTextAlignment];
    [textView setDrawsBackground:NO];
    [[textView textStorage] setAttributedString:textString];
    [textView setFrame:NSMakeRect(10, (count * 20) +2, 330, 40)];
    [textView setEditable:NO];
    [textView setSelectable:NO];
    [textView setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin|NSViewWidthSizable];
    [_contentCustomView addSubview:textView];
    [textView release];
}

- (void)setHomeTextString:(NSString *)textString withCounts:(int)count {
    NSTextField *homeText = [[NSTextField alloc] init];
    [homeText setBordered:NO];
    [homeText setAlignment:NSLeftTextAlignment];
    [homeText setDrawsBackground:NO];
    if (textString == nil) {
       [homeText setStringValue:@" "];
    }else {
        [homeText setStringValue:textString];
    }
    [homeText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [homeText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [homeText setFrame:NSMakeRect(10, (count * 20) -2, 80, 16)];
    [homeText sizeToFit];
    [homeText setEditable:NO];
    [homeText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
    [_contentCustomView addSubview:homeText];
    [homeText release];
}

- (void)setLineWhiteViewCount:(int)count {
    IMBWhiteView *whiteView = [[IMBWhiteView alloc] initWithFrame:NSMakeRect(4, (count * 20)+4  +6, _contentCustomView.frame.size.width - 24, 1)];
    [whiteView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [whiteView setAutoresizingMask: NSViewMaxYMargin|NSViewMinXMargin|NSViewWidthSizable];
    [_contentCustomView addSubview:whiteView];
    [whiteView release];
}

- (float)setTextViewForString:(NSString *)myString withTextVeiw:(NSTextView *)textView withDelete:(BOOL)isDeleted {
    NSMutableAttributedString *drawStr = [[[NSMutableAttributedString alloc] initWithString:myString] autorelease];
    
    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:myString] autorelease];
    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(645, FLT_MAX)] autorelease];//textView.frame.size.width
    
    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:2.0f];
    [textParagraph setAlignment:NSLeftTextAlignment];
    [textParagraph setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *fontDic = nil;
    if (isDeleted == YES) {
        fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, [NSColor redColor], NSForegroundColorAttributeName, [NSFont fontWithName:@"Helvetica Neue" size:12], NSFontAttributeName, nil];
    }else {
        fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, [NSFont fontWithName:@"Helvetica Neue" size:12], NSFontAttributeName, [NSColor colorWithDeviceRed:0.f/255 green:0.f/255 blue:0.f/255 alpha:1.0], NSForegroundColorAttributeName,nil];
    }
    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    [drawStr addAttributes:fontDic range:NSMakeRange(0, textStorage.length)];
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    float changeHeight = [layoutManager usedRectForTextContainer:textContainer].size.height;
    [textView setFrameSize:NSMakeSize(textView.frame.size.width, changeHeight)];
    [[textView textStorage] setAttributedString:drawStr];
    
    return changeHeight;
}

- (NSMutableAttributedString *)stringDeleteStyle:(NSString *)string {
    NSMutableAttributedString *deleteString = [[[NSMutableAttributedString alloc] initWithString:string] autorelease];
    
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineBreakMode:NSLineBreakByTruncatingMiddle];
     NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName, textParagraph, NSParagraphStyleAttributeName, nil];
    [deleteString addAttributes:dic range:NSMakeRange(0, deleteString.length)];
    return deleteString;
}

#pragma mark - 切换语言
- (void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [super doChangeLanguage:notification];
        [self configNoDataView];
        NSRect rect = [TempHelper calcuTextBounds:CustomLocalizedString(@"Detail_Control_Header_SortByName", nil) fontSize:12];
        int w = rect.size.width + 30;
        if ((rect.size.width + 30) < 50) {
            w = 50;
        }
        [_sortRightPopuBtn setFrame:NSMakeRect(_topWhiteView.frame.size.width - w -12, _sortRightPopuBtn.frame.origin.y, w, _sortRightPopuBtn.frame.size.height)];
        for (NSMenuItem *item in [[_sortRightPopuBtn menu] itemArray])
        {
            if (item.tag == 0) {
                [item setTitle:CustomLocalizedString(@"Detail_Control_Header_SortByName", nil)];
            }else if (item.tag == 3)
            {
                [item setTitle:CustomLocalizedString(@"Sort_Ascend", nil)];
            }else if (item.tag == 4)
            {
                [item setTitle:CustomLocalizedString(@"Sort_Descend", nil)];
            }
        }
        if (_currentContactData != nil) {
            [self showSingleContactContent:_currentContactData];
        }
        
    });
    
}

#pragma mark - 切换皮肤
- (void)changeSkin:(NSNotification *)notification{
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [_loadingAnimationView setNeedsDisplay:YES];
    [self configNoDataView];
    [_topWhiteView setNeedsDisplay:YES];
    [self configNoDataView];
    [_loadingAnimationView setNeedsDisplay:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
    [_selectSortBtn setNeedsDisplay:YES];
    [_sortRightPopuBtn setNeedsDisplay:YES];
    [_rightLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    if (_currentContactData != nil) {
        [self showSingleContactContent:_currentContactData];
    }
}

#pragma mark - 搜索
- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    [self.view setNeedsDisplay:YES];
    _searchFieldBtn = searchBtn;
    _isSearch = YES;
    if (![IMBHelper stringIsNilOrEmpty:searchBtn.stringValue]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contactSortName CONTAINS[cd] %@ ",searchBtn.stringValue];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray filteredArrayUsingPredicate:predicate]];
        if (_researchdataSourceArray.count > 0) {
            _isSearch = YES;
            IMBADContactEntity *entity = [_researchdataSourceArray objectAtIndex:0];
            [self showSingleContactContent:entity];
        }else {
            [self showSingleContactContent:nil];
        }
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
        if (_dataSourceArray.count != 0) {
            IMBADContactEntity *entity = [_dataSourceArray objectAtIndex:0];
            [self showSingleContactContent:entity];
        }
    }
    
    [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]byExtendingSelection:NO];
    [_itemTableView reloadData];
}

#pragma mark - action

- (void)androidReload:(id)sender {
    [self disableFunctionBtn:NO];
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    
    //检查apk是否赋予权限
    if (_delegate != nil && [_delegate respondsToSelector:@selector(checkDeviceGreantedPermission:)] ) {
        [_delegate checkDeviceGreantedPermission:ReloadFunctionType];
    }
}

- (void)reloadData {
    @autoreleasepool {
        //刷新方式，重新读取
        [_android queryContactDetailInfo];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self disableFunctionBtn:YES];
            if (_dataSourceArray != nil) {
                [_dataSourceArray release];
                _dataSourceArray = nil;
            }
            _dataSourceArray = [_android.getContactContent.reslutArray retain];
            [_itemArray removeAllObjects];
            [_itemArray addObjectsFromArray:_dataSourceArray];
            
            if (_dataSourceArray.count == 0) {
                [_mainBox setContentView:_nodataView];
                [self configNoDataView];
            }else {
                [_mainBox setContentView:_detailView];
                [_itemTableView reloadData];
                [self changeSonTableViewData:0];
            }
            if (_delegate != nil && [(IMBAndroidMainPageViewController *)_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                [(IMBAndroidMainPageViewController *)_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
            }
            [_loadingAnimationView endAnimation];
        });
    }
}

- (void)cancelReload {
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_nodataView];
        [self configNoDataView];
    }else {
        [_mainBox setContentView:_detailView];
    }
    [self disableFunctionBtn:YES];
    [_loadingAnimationView endAnimation];
}

- (void)reloadTableView {
    _isSearch = NO;
    [_itemTableView reloadData];
    if (_itemArray.count > 0) {
        NSInteger row = [_itemTableView selectedRow];
        if (row == 0) {
            [self changeSonTableViewData:0];
        }else {
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        }
    }
}

-(void)dealloc{
    if (_deletedAry != nil) {
        [_deletedAry release];
        _deletedAry = nil;
    }
    if (_existenceAry != nil) {
        [_existenceAry release];
        _existenceAry = nil;
    }
    if (_itemArray != nil) {
        [_itemArray release];
        _itemArray = nil;
    }
    if (_resultEntity != nil) {
        [_resultEntity release];
        _resultEntity = nil;
    }
    if (_headImageLayer != nil) {
        [_headImageLayer release];
        _headImageLayer = nil;
    }
    [super dealloc];
}

//传输准备进度开始
- (void)transferPrepareFileStart:(NSString *)file {
    NSLog(@"准备进度开始");
}

//传输准备进度结束
- (void)transferPrepareFileEnd {
    NSLog(@"准备进度结束");
}

//传输进度
- (void)transferProgress:(float)progress {
    NSLog(@"传输进度值：%f", progress);
}

//当前传输文件的名字或者路径
- (void)transferFile:(NSString *)file {
    NSLog(@"当前传输文件的名字或者路径");
}

//分析进度
- (void)parseProgress:(float)progress {
    NSLog(@"分析进度");
}

//当前分析文件的名字或者路径
- (void)parseFile:(NSString *)file {
    NSLog(@"当前分析文件的名字或者路径");
}

//全部传输成功
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount {
    NSLog(@"全部传输成功");
}

- (void)menuWillOpen:(NSMenu *)menu {
    [self initAndroidDeviceMenuItem];
    [self initAndroidiCloudMenuItem];
}

@end
