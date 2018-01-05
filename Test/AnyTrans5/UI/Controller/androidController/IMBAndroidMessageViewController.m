//
//  IMBMessageViewController.m
//  AnyTrans
//
//  Created by long on 17-7-17.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBAndroidMessageViewController.h"
#import "IMBSMSChatDataEntity.h"
#import "IMBCustomHeaderCell.h"
#import "IMBCheckBoxCell.h"
#import "IMBNotificationDefine.h"
#import "IMBAnimation.h"
#import "IMBMessageNameTextCell.h"
#import "IMBAndroidMainPageViewController.h"
#import "IMBImageAndTextCell.h"
#define BGIMAGEX 5
#define BGIMAGEY 4
#define ACHECKBOX 5
#define SCHECKBOX 8
@implementation IMBAndroidMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initwithAndroid:(IMBAndroid *)android withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    if ([super initwithAndroid:android withCategoryNodesEnum:category withDelegate:delegate]) {
        _dataSourceArray = [android.adSMS.reslutEntity.reslutArray retain];
    }
    return self;
}

- (void)dealloc {
    [[IMBLogManager singleton] writeInfoLog:@"message del"];
    [[IMBLogManager singleton] writeInfoLog:@"message del1"];
    if (_operationQueue != nil) {
        [_operationQueue cancelAllOperations];
        [_operationQueue release];
        _operationQueue = nil;
    }
    [nc removeObserver:self name:NSViewBoundsDidChangeNotification object:nil];
    [[IMBLogManager singleton] writeInfoLog:@"message del111"];
    [super dealloc];
}
#pragma mark - 切换语言and皮肤
- (void)doChangeLanguage:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self configNoDataView];
        [super doChangeLanguage:notification];
        
    });
}

- (void)changeSkin:(NSNotification *)notification {
    //    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [self configNoDataView];
    
    [_itemTableView setGridColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_topWhiteView setNeedsDisplay:YES];
    [_sortRightPopuBtn setNeedsDisplay:YES];
    [_selectSortBtn setNeedsDisplay:YES];
    [_loadingAnmationView setNeedsDisplay:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
}

- (void)awakeFromNib {
    _isloadingPopBtn = YES;
    _isAndroid = YES;
    [super awakeFromNib];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    nc = [NSNotificationCenter defaultCenter];
    [self configNoDataView];
    [_topWhiteView setIsBommt:YES];
    [_topWhiteView setBackgroundColor:[NSColor clearColor]];
    _itemTableView.allowsMultipleSelection = NO;
    [_itemTableView setGridColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [nc addObserver: self
           selector: @selector(boundsDidChangeNotification:)
               name: NSViewBoundsDidChangeNotification
             object: [_msgContentScrollView contentView]];
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
    }else {
        [_mainBox setContentView:_detailView];
    }
    
    //    entity = [[IMBSMSChatDataEntity alloc]init];
    _androidEntity = [[IMBThreadsEntity alloc]init];
    _operationQueue = [[NSOperationQueue alloc] init];
    [_operationQueue setMaxConcurrentOperationCount:10];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]byExtendingSelection:NO];
    _itemTableView.menu.delegate = self;
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    //    [_operationQueue addOperationWithBlock:^{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i <_dataSourceArray.count; i ++) {
            if (_isReload) {
                break;
            }
            IMBThreadsEntity *threadsentity  = [_dataSourceArray objectAtIndex:i];
            if (_isReload) {
                break;
            }
            for (int y = 0; y < threadsentity.messageList.count; y ++) {
                if (_isReload) {
                    break;
                }
                IMBADMessageEntity *messageEntity = [threadsentity.messageList objectAtIndex:y];
                if (_isReload) {
                    break;
                }
                for (int k = 0 ; k < messageEntity.partList.count; k ++) {
                    if (_isReload) {
                        break;
                    }
                    IMBSMSPartEntity *partEntity = [messageEntity.partList objectAtIndex:k];
                    NSString *ctString = partEntity.ct;
                    if ([ctString rangeOfString:@"image"].location != NSNotFound) {
                        if (partEntity.localPath == nil || ![[NSFileManager defaultManager] fileExistsAtPath:partEntity.localPath]) {
                            [_android.adSMS getAttachmentContent:partEntity withPath:nil];
                        }
                    }
                    if (_isReload) {
                        break;
                    }
                }
                if (_isReload) {
                    break;
                }
            }
            if (_isReload) {
                break;
            }
        }
        if (_isReload) {
            _isReload = NO;
        }
    });
    //    }];
    
}

- (void)boundsDidChangeNotification: (NSNotification *) notification {
    
    int contentOffset = _msgContentScrollView.documentVisibleRect.origin.y;
    NSView *doView = (NSView *)_msgContentScrollView.documentView;
    if (contentOffset != 0 && contentOffset > doView.frame.size.height - _msgContentScrollView.contentView.frame.size.height -10 && _androidEntity.messageList.count > 0) {
        [self showSingleMessageContent:_androidSmsSonData];
    }
}

#pragma mark - noData NSTextView
- (void)configNoDataView {
    [_noDataImageView setImage:[StringHelper imageNamed:@"nodata_ad_message"]];
    [_textView setDelegate:self];
    [_textView setSelectable:YES];
    NSString *overStr1 = CustomLocalizedString(@"noData_subTitle1", nil);
    NSString *promptStr1 = [[[NSString stringWithFormat:CustomLocalizedString(@"noData_subTitle", nil),CustomLocalizedString(@"MenuItem_id_76", nil)] stringByAppendingString:@" "] stringByAppendingString:overStr1];
    NSString *promptStr = [[[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_76", nil)] stringByAppendingString:@" "] stringByAppendingString:promptStr1];
    
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

#pragma mark - NSTableView delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0) {
        return 0;
    }
    return disAry.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0 || row > disAry.count -1) {
        return nil;
    }
    
    IMBThreadsEntity *smsData = [disAry objectAtIndex:row];
    if ([[tableColumn identifier] isEqualToString:@"Name"]) {
        if (smsData.snippet != nil) {
            NSString *titleStr = [smsData.snippet stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *nameStr = @"";
            NSString *subTitleStr = @"";
            if (titleStr != nil) {
                int length = (int)titleStr.length;//[self convertToInt:text];
                if (length > 18) {
                    NSString *frontText = [titleStr substringWithRange:NSMakeRange(0, 16)];
                    for (int i = 0;i <3 ; i++) {
                        frontText = [frontText stringByAppendingString:@"."];
                    }
                    subTitleStr = frontText;
                }else{
                    subTitleStr = titleStr;
                }
            }
            nameStr = smsData.threadsname;
            NSString *removeR = [subTitleStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSString *titleS = [removeR stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *remover2 = [nameStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSString *titleStr1 = [remover2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *remover3 = [smsData.lastMsgTime stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSString *titleStr2 = [remover3 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            return [NSString stringWithFormat:@"%@\n%@\n%@",titleStr1,titleStr2,titleS];
        }else {
            NSString *nameStr = @"";
            if ([IMBSoftWareInfo singleton].isRegistered) {
                nameStr = smsData.threadsname;
            }else{
                if (smsData.isDeleted) {
                    nameStr = [IMBHelper isaddMosaicTextStr:smsData.threadsname];
                }else{
                    nameStr = smsData.threadsname;
                }
            }
            NSString *remover2 = [smsData.threadsname stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSString *titleStr1 = [remover2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *remover3 = [smsData.lastMsgTime stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSString *titleStr2 = [remover3 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            return [NSString stringWithFormat:@"%@\n%@",titleStr1,titleStr2];
        }
    }else if ([[tableColumn identifier] isEqualToString:@"Time"]) {
        return smsData.lastMsgTime;
    }else if ([[tableColumn identifier] isEqualToString:@"CheckCol"]) {
        return [NSNumber numberWithInt:smsData.checkState];
    }
    return @"";
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([[tableColumn identifier] isEqualToString:@"CheckCol"]) {
        IMBCheckBoxCell *boxCell = (IMBCheckBoxCell *)cell;
        boxCell.outlineCheck = YES;
    }else if ([[tableColumn identifier] isEqualToString:@"Name"]) {
        IMBMessageNameTextCell *messageCell = (IMBMessageNameTextCell *)cell;
        [messageCell setIsMessage:YES];
    }else if ([@"Image" isEqualToString:tableColumn.identifier]){
        IMBImageAndTextCell *imageCell = (IMBImageAndTextCell *)cell;
        imageCell.marginX = 10;
        imageCell.paddingX = 0;
        NSArray *displayArr = nil;
        ////        if (_isSearch) {
        ////            displayArr = _searchAry;
        ////        }else{
        //            displayArr = _baseAry;
        ////        }
        ////        if (row%2 == 0) {
        ////            imageCell.isOneRow = YES;
        ////        }else{
        ////            imageCell.isOneRow = NO;
        ////        }
        ////        imageCell.isDrawBgImg = YES;
        //        [imageCell setImageSize:NSMakeSize(34, 34)];
        if (_isSearch) {
            displayArr = _researchdataSourceArray;
        }else{
            displayArr = _dataSourceArray;
        }
        [imageCell setImageSize:NSMakeSize(34, 34)];
        IMBThreadsEntity *smsData = [displayArr objectAtIndex:row];
        if (smsData.headerImage != nil) {
            NSImage *newImage = [[NSImage alloc]initWithData:smsData.headerImage];
            NSImage *cutImage = [IMBHelper cutImageWithImage:newImage border:0];
            [imageCell setImage:cutImage];
            [newImage release];
        }else{
            [imageCell setImage:[StringHelper imageNamed:@"message_default"]];
        }
    }
}

- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0 || index > disAry.count -1) {
        return;
    }
    IMBSMSChatDataEntity *entity2 = [disAry objectAtIndex:index];
    entity2.checkState = !entity2.checkState;
    int checkCount = 0;
    for (IMBSMSChatDataEntity *entity1 in disAry) {
        if (entity1.checkState == Check) {
            checkCount ++;
        }
    }
    if (checkCount == disAry.count) {
        [_itemTableView changeHeaderCheckState:Check];
    }else if (checkCount == 0){
        [_itemTableView changeHeaderCheckState:UnChecked];
    }else{
        [_itemTableView changeHeaderCheckState:SemiChecked];
    }
    [_itemTableView reloadData];
}

- (void)setAllselectState:(CheckStateEnum)sender {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0 ) {
        return;
    }
    for (IMBSMSChatDataEntity *entity1 in disAry) {
        entity1.checkState = sender;
    }
    [_itemTableView  reloadData];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 60;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView *tabTableView = [notification object];
    NSInteger row = [tabTableView selectedRow];
    [self changeTableView:row];
}

- (void)showSingleMessageContent:(id)mesEntity {
    //        IMBThreadsEntity *aentity = mesEntity;
    
    NSString *dateStandardString = @"";
    NSMutableArray *viewAry = [[NSMutableArray alloc]init];
    NSString *typeStr = nil;
    if (_androidEntity.messageList != nil && _androidEntity.messageList.count > 0) {
        for (IMBADMessageEntity *msgData in _androidEntity.messageList) {
            if ([IMBHelper stringIsNilOrEmpty:msgData.body] && msgData.partList.count <= 0 ) {
                continue;
            }
            if (msgData.partList.count > 0 ) {
                typeStr = @"1";
            } else {
                typeStr = @"0";
            }
            @autoreleasepool {
                NSView *doView = (NSView *)_msgContentScrollView.documentView;
                if (_scrollallHeight > doView.frame.size.height ) {
                    break;
                }
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:(long)msgData.sortDate / 1000.0];
                if (msgData.sortDate < 0) {
                    date = [NSDate date];
                }
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
                NSString *dateStr = [dateFormatter stringFromDate:date];
                if ([dateStandardString isEqualToString:@""] || ![dateStandardString isEqualToString:dateStr]) {
                    dateStandardString = dateStr;
                    [self setHomeTextString:dateStr withFolat:_scrollallHeight];
                    _scrollallHeight += 45;
                }
                //                [msgData.checkBtn setTarget:self];
                //                [msgData.checkBtn setAction:@selector(isSelected:)];
                
                NSString *amosaicStr = @"";
                if ([typeStr isEqualToString:@"0"]) {
                    if (![IMBSoftWareInfo singleton].isRegistered) {
                        NSString *endStr = @"";
                        if (msgData.isDeleted) {
                            endStr = [IMBHelper isaddMosaicTextStr:msgData.body];
                        }else{
                            endStr = msgData.body;
                        }
                        
                        if (endStr != nil) {
                            amosaicStr = endStr;
                        }else{
                            amosaicStr = msgData.body;
                        }
                    }else{
                        amosaicStr = msgData.body;
                    }
                    
                    if (![IMBHelper stringIsNilOrEmpty:amosaicStr]) {
                        _scrollheight = 0;
                        NSTextView *textView = [[NSTextView alloc] init];
                        [textView setEditable:YES];
                        [textView setSelectable:YES];
                        [textView setDrawsBackground:NO];
                        [textView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                        float x = 0;
                        float width = 0;
                        if (![IMBHelper stringIsNilOrEmpty:amosaicStr]) {
                            NSRect rect = [IMBHelper calcuTextBounds:amosaicStr fontSize:12];
                            if (msgData.type == 1) {
                                x = 45;
                                if (rect.size.width > (_customView.frame.size.width - 100) / 2) {
                                    width = (_customView.frame.size.width - 100) / 2;
                                }else {
                                    width = rect.size.width + 10;
                                }
                            }else {
                                if (rect.size.width > (_customView.frame.size.width - 100) / 2) {
                                    x = _customView.frame.size.width / 2;
                                    width = (_customView.frame.size.width - 100) / 2;
                                }else {
                                    width = rect.size.width + 10;
                                    x = _customView.frame.size.width - 50 - width;
                                }
                            }
                            [textView setFrame:NSMakeRect(x, _scrollallHeight, width, 16)];
                            
                            _scrollheight = [self setTextViewForString:amosaicStr withTextVeiw:textView withDelete:msgData.isDeleted];
                            if (msgData.type == 1) {
                                [textView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_message_receiveColor", nil)]];
                            }else {
                                [textView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_message_sendColor", nil)]];
                            }
                        }
                        
                        
                        if (_scrollheight < 17) {
                            _scrollheight = 17;
                        }
                        [textView setEditable:NO];
                        [textView setSelectable:NO];
                        
                        IMBMessageView *messageView = [[IMBMessageView alloc] initWithFrame:NSMakeRect(x, _scrollallHeight, width + 30, _scrollheight + 40)];
                        if ([typeStr isEqualToString:@"1"]) {
                            if (msgData.type == 1) {
                                [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_receive_bgColor", nil)]];
                            }else if (msgData.type == 2) {
                                [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"Message_Right_Color", nil)]];
                            }else {
                                [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"Message_Right_Color", nil)]];
                            }
                        }else if ([typeStr isEqualToString:@"0"]) {
                            if (msgData.type == 1) {
                                [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_receive_bgColor", nil)]];
                            }else if (msgData.type == 2) {
                                [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"Message_Right_Color", nil)]];
                            }else {
                                [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"Message_Right_Color", nil)]];
                            }
                        }else {
                            if (msgData.type == 1) {
                                [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_receive_bgColor", nil)]];
                            }else if (msgData.type == 2) {
                                [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"Message_Right_Color", nil)]];
                            }
                        }
                        [textView setFrameOrigin:NSMakePoint(18, 18)];
                        [messageView addSubview:textView];
                        
                        NSImageView *bgImageView = nil;
                        if (msgData.type == 1) {
                            bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(messageView.frame.origin.x - 5 - BGIMAGEX, messageView.frame.origin.y + messageView.frame.size.height - 15 + BGIMAGEY, 20, 18)];
                            [bgImageView setImage:[StringHelper imageNamed:@"mu_left"]];
                            [msgData.checkBtn setFrameOrigin:NSMakePoint(messageView.frame.origin.x-26 - ACHECKBOX,messageView.frame.origin.y + (messageView.frame.size.height - 14)/2)];
                            [msgData.checkBtn setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                            [messageView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                            [bgImageView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                            //                                [_customView addSubview:msgData.checkBtn];
                        }else {
                            [messageView setFrameOrigin:NSMakePoint(messageView.frame.origin.x-24, messageView.frame.origin.y)];
                            bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(messageView.frame.origin.x + messageView.frame.size.width - 15 + BGIMAGEX, messageView.frame.origin.y + messageView.frame.size.height - 15 + BGIMAGEY, 20, 18)];
                            
                            [bgImageView setImage:[StringHelper imageNamed:@"bulue_ad_right"]];
                            [msgData.checkBtn setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                            [messageView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                            [bgImageView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                            
                            [msgData.checkBtn setFrameOrigin:NSMakePoint(_customView.frame.size.width -24 - SCHECKBOX,messageView.frame.origin.y + (messageView.frame.size.height - 14)/2)];
                            //                                [_customView addSubview:msgData.checkBtn];
                        }
                        
                        [_customView addSubview:bgImageView];
                        [_customView addSubview:messageView];
                        
                        
                        _scrollallHeight += (_scrollheight + 30 + 10);
                        
                        if (textView != nil) {
                            [textView release];
                        }
                        if (messageView != nil) {
                            [messageView release];
                        }
                        if (bgImageView != nil) {
                            [bgImageView release];
                        }
                    }
                    
                    
                } else if ([typeStr isEqualToString:@"1"]) {
                    int i = 0;
                    int j = 0;
                    
                    IMBSMSPartEntity *tempEntity = [msgData.partList objectAtIndex:msgData.partList.count - 1];
                    NSString *tempStr = tempEntity.ct;
                    
                    for (int k= 0; k < msgData.partList.count; k ++) {
                        IMBSMSPartEntity *partEntity = [msgData.partList objectAtIndex:k];
                        NSImageView *imageView = nil;
                        IMBMessageView *imageMsgView = nil;
                        i++;
                        
                        NSString *ctString = partEntity.ct;
                        NSImage *image = nil;
                        if ([ctString rangeOfString:@"image"].location != NSNotFound) {
                            j++;
                            if (partEntity.localPath != nil && [[NSFileManager defaultManager] fileExistsAtPath:partEntity.localPath]) {
                                image = [[NSImage alloc] initWithContentsOfFile:partEntity.localPath];
                                if (image == nil) {
                                    image = [[StringHelper imageNamed:@"default_photo"] retain];
                                    [image setSize:NSMakeSize(128, 128)];
                                }
                            } else {
                                image = [[StringHelper imageNamed:@"default_photo"] retain];
                                [image setSize:NSMakeSize(128, 128)];
                            }
                            if (image != nil) {
                                float x = 0;
                                float width = 0;
                                _scrollheight = 0;
                                float oriWidth =180;
                                if (oriWidth > 380) {
                                    oriWidth = 380;
                                }
                                if (msgData.type == 1) {
                                    x = 45;
                                    if (image.size.width > oriWidth) {
                                        width = oriWidth;
                                        _scrollheight = image.size.height * (width / image.size.width);
                                    }else {
                                        width = image.size.width;
                                        _scrollheight = image.size.height;
                                    }
                                }else {
                                    if (image.size.width > oriWidth) {
                                        width = oriWidth;
                                        x = _customView.frame.size.width / 2;
                                        _scrollheight = image.size.height * (width / image.size.width);
                                    }else {
                                        width = image.size.width;
                                        _scrollheight = image.size.height;
                                        x = _customView.frame.size.width / 2;
                                    }
                                }
                                
                                
                                imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(50, 10, width, _scrollheight)];
                                [imageView setImage:image];
                                if (j == 1) {
                                    imageMsgView = [[IMBMessageView alloc] initWithFrame:NSMakeRect(x, _scrollallHeight, (_customView.frame.size.width - 100) / 2 + 22, imageView.frame.size.height + 26)];
                                }else {
                                    imageMsgView = [[IMBMessageView alloc] initWithFrame:NSMakeRect(x, _scrollallHeight - 20, (_customView.frame.size.width - 100) / 2 +22 , imageView.frame.size.height + 26)];
                                }
                                
                                if (msgData.type == 1) {
                                    [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"Message_MMS_Color", nil)]];
                                }else if (msgData.type == 2) {
                                    [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"Message_Right_Color", nil)]];
                                }
                                
                                NSImageView *bgImageView = nil;
                                if (msgData.type == 1) {
                                    
                                    if ([tempStr rangeOfString:@"image"].location != NSNotFound || [tempStr rangeOfString:@"audio"].location != NSNotFound || [tempStr rangeOfString:@"video"].location != NSNotFound || ([tempStr rangeOfString:@"text"].location != NSNotFound && ![IMBHelper stringIsNilOrEmpty:tempEntity.text])) {
                                        if (i == msgData.partList.count) {
                                            
                                            bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(imageMsgView.frame.origin.x - 4 - BGIMAGEX, imageMsgView.frame.origin.y + imageMsgView.frame.size.height - 15 + BGIMAGEY, 20, 18)];
                                            [bgImageView setImage:[StringHelper imageNamed:@"mu_left"]];
                                            [bgImageView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                                        }
                                    } else {
                                        if (i == msgData.partList.count - 1) {
                                            bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(imageMsgView.frame.origin.x - 4 - BGIMAGEX, imageMsgView.frame.origin.y + imageMsgView.frame.size.height - 15 + BGIMAGEY, 20, 18)];
                                            [bgImageView setImage:[StringHelper imageNamed:@"bulue_ad_right"]];
                                            [bgImageView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                                        }
                                    }
                                    
                                    [msgData.checkBtn setFrameOrigin:NSMakePoint(imageMsgView.frame.origin.x-26 - ACHECKBOX,imageMsgView.frame.origin.y + (imageMsgView.frame.size.height - 14)/2)];
                                    [msgData.checkBtn setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                                    [imageMsgView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                                }else {
                                    [imageMsgView setFrameOrigin:NSMakePoint(imageMsgView.frame.origin.x - 24 - 20, imageMsgView.frame.origin.y)];
                                    
                                    if ([tempStr rangeOfString:@"image"].location != NSNotFound || [tempStr rangeOfString:@"audio"].location != NSNotFound || [tempStr rangeOfString:@"video"].location != NSNotFound || ([tempStr rangeOfString:@"text"].location != NSNotFound && ![IMBHelper stringIsNilOrEmpty:tempEntity.text])) {
                                        if (i == msgData.partList.count) {
                                            bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(imageMsgView.frame.origin.x + imageMsgView.frame.size.width - 19 + BGIMAGEX, imageMsgView.frame.origin.y + imageMsgView.frame.size.height - 15 + BGIMAGEY, 20, 18)];
                                            
                                            [bgImageView setImage:[StringHelper imageNamed:@"bulue_ad_right"]];
                                            [bgImageView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                                        }
                                    } else {
                                        if (i == msgData.partList.count - 1) {
                                            bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(imageMsgView.frame.origin.x + imageMsgView.frame.size.width - 19 + BGIMAGEX, imageMsgView.frame.origin.y + imageMsgView.frame.size.height - 15 + BGIMAGEY, 20, 18)];
                                            
                                            [bgImageView setImage:[StringHelper imageNamed:@"bulue_ad_right"]];
                                            [bgImageView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                                        }
                                    }
      
                                    [msgData.checkBtn setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                                    [imageMsgView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                                    
                                    [msgData.checkBtn setFrameOrigin:NSMakePoint(_customView.frame.size.width - 24 - SCHECKBOX,imageMsgView.frame.origin.y + (imageMsgView.frame.size.height - 14)/2)];
                                }
                                if (j != 1 &&k != msgData.partList.count -1 &&msgData.partList.count>1) {
                                     [imageMsgView setIsMMS:YES];
                                }
                                if (msgData.type !=1) {
                                     [imageMsgView setFrame:NSMakeRect(imageMsgView.frame.origin.x, imageMsgView.frame.origin.y - 10, imageMsgView.frame.size.width, imageMsgView.frame.size.height +10)];
                                }
                                if (k == msgData.partList.count -1) {
                                    [imageMsgView setFrame:NSMakeRect(imageMsgView.frame.origin.x, imageMsgView.frame.origin.y - 10, imageMsgView.frame.size.width, imageMsgView.frame.size.height +10)];
                                }
                                [imageMsgView addSubview:imageView];
                                [_customView addSubview:bgImageView];
                                [_customView addSubview:imageMsgView];
                                _scrollallHeight += imageMsgView.frame.size.height;
                                
                                if (partEntity.localPath == nil || ![[NSFileManager defaultManager] fileExistsAtPath:partEntity.localPath]) {
                                    [_operationQueue addOperationWithBlock:^{
                                        BOOL success = [_android.adSMS getAttachmentContent:partEntity withPath:nil];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (success && [[NSFileManager defaultManager] fileExistsAtPath:partEntity.localPath]) {
                                                NSImage *thumbImage = [[NSImage alloc] initWithContentsOfFile:partEntity.localPath];
                                                if (thumbImage!= nil) {
                                                    if (thumbImage.size.width < 179 && thumbImage.size.height < 241) {
                                                        [imageView setFrameSize:NSMakeSize(thumbImage.size.width, thumbImage.size.height)];
                                                    }
                                                    [imageView setImage:thumbImage];
                                                }
                                                [thumbImage release];
                                            }
                                            [imageView setNeedsDisplay:YES];
                                            [imageMsgView setNeedsDisplay:YES];
                                        });
                                    }];
                                }
                                
                                if (imageMsgView != nil) {
                                    [imageMsgView release];
                                }
                                if (imageView != nil) {
                                    [imageView release];
                                }
                                if (bgImageView != nil) {
                                    [bgImageView release];
                                }
                                if (image != nil) {
                                    [image release];
                                }
                            }
                        }else if ([ctString rangeOfString:@"audio"].location != NSNotFound || [ctString rangeOfString:@"video"].location != NSNotFound) {
                            j++;
                            if ([ctString rangeOfString:@"audio"].location != NSNotFound) {
                                image = [[StringHelper imageNamed:@"default_audio"] retain];
                            }else if ([ctString rangeOfString:@"video"].location != NSNotFound) {
                                image = [[StringHelper imageNamed:@"default_video"] retain];
                            }else {
                                image = [[StringHelper imageNamed:@"default_video"] retain];
                            }
                            
                            if (image != nil) {
                                float x = 0;
                                float width = 0;
                                _scrollheight = 0;
                                float oriWidth = (_customView.frame.size.width - 100) / 2;
                                if (oriWidth > 380) {
                                    oriWidth = 380;
                                }
                                if (msgData.type == 1) {
                                    x = 45;
                                    if (image.size.width > oriWidth) {
                                        width = oriWidth;
                                        _scrollheight = image.size.height * (width / image.size.width);
                                    }else {
                                        width = image.size.width;
                                        _scrollheight = image.size.height;
                                    }
                                }else {
                                    if (image.size.width > oriWidth) {
                                        width = oriWidth;
                                        x = _customView.frame.size.width / 2;
                                        _scrollheight = image.size.height * (width / image.size.width);
                                    }else {
                                        width = image.size.width;
                                        _scrollheight = image.size.height;
                                        x = _customView.frame.size.width / 2;
                                    }
                                }
                                
                                imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(50, 8, width, _scrollheight)];
                                [imageView setImage:image];
                                if (j == 1) {
                                    imageMsgView = [[IMBMessageView alloc] initWithFrame:NSMakeRect(x, _scrollallHeight, (_customView.frame.size.width - 100) / 2 +22, imageView.frame.size.height + 26)];
                                }else {
                                    imageMsgView = [[IMBMessageView alloc] initWithFrame:NSMakeRect(x, _scrollallHeight - 20, (_customView.frame.size.width - 100) / 2 + 22, imageView.frame.size.height + 26)];
                                }
                                if (msgData.type == 1) {
                                    [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"Message_MMS_Color", nil)]];
                                }else if (msgData.type == 2) {
                                    [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"Message_Right_Color", nil)]];
                                }
                                
                                NSImageView *bgImageView = nil;
                                if (msgData.type == 1) {
                                    if ([tempStr rangeOfString:@"image"].location != NSNotFound || [tempStr rangeOfString:@"audio"].location != NSNotFound || [tempStr rangeOfString:@"video"].location != NSNotFound || ([tempStr rangeOfString:@"text"].location != NSNotFound && ![IMBHelper stringIsNilOrEmpty:tempEntity.text])) {
                                        if (i == msgData.partList.count) {
                                            bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(imageMsgView.frame.origin.x - 4 - BGIMAGEX, imageMsgView.frame.origin.y + imageMsgView.frame.size.height - 15 + BGIMAGEY, 20, 18)];
                                            
                                            [bgImageView setImage:[StringHelper imageNamed:@"mu_left"]];
                                            [bgImageView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                                        }
                                    } else {
                                        if (i == msgData.partList.count - 1) {
                                            bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(imageMsgView.frame.origin.x - 4 - BGIMAGEX, imageMsgView.frame.origin.y + imageMsgView.frame.size.height - 15 + BGIMAGEY, 20, 18)];
                                            [bgImageView setImage:[StringHelper imageNamed:@"bulue_ad_right"]];
                                            [bgImageView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                                        }
                                    }
 
                                    [msgData.checkBtn setFrameOrigin:NSMakePoint(imageMsgView.frame.origin.x-26 - ACHECKBOX,imageMsgView.frame.origin.y + (imageMsgView.frame.size.height - 14)/2)];
                                    [msgData.checkBtn setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                                    [imageMsgView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                                }else {
                                    [imageMsgView setFrameOrigin:NSMakePoint(imageMsgView.frame.origin.x - 24 - 20, imageMsgView.frame.origin.y)];
                                    
                                    if ([tempStr rangeOfString:@"image"].location != NSNotFound || [tempStr rangeOfString:@"audio"].location != NSNotFound || [tempStr rangeOfString:@"video"].location != NSNotFound || ([tempStr rangeOfString:@"text"].location != NSNotFound && ![IMBHelper stringIsNilOrEmpty:tempEntity.text])) {
                                        if (i == msgData.partList.count) {
                                            bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(imageMsgView.frame.origin.x + imageMsgView.frame.size.width - 19 + BGIMAGEX, imageMsgView.frame.origin.y + imageMsgView.frame.size.height - 15 + BGIMAGEY, 20, 18)];
                                            
                                            [bgImageView setImage:[StringHelper imageNamed:@"bulue_ad_right"]];
                                            [bgImageView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                                        }
                                    } else {
                                        
                                        if (i == msgData.partList.count - 1) {
                                            bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(imageMsgView.frame.origin.x + imageMsgView.frame.size.width - 19 + BGIMAGEX, imageMsgView.frame.origin.y + imageMsgView.frame.size.height - 15 + BGIMAGEY, 20, 18)];
                                            
                                            [bgImageView setImage:[StringHelper imageNamed:@"bulue_ad_right"]];
                                            [bgImageView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                                        }
                                    }
                                    [msgData.checkBtn setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                                    [imageMsgView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                                    
                                    [msgData.checkBtn setFrameOrigin:NSMakePoint(_customView.frame.size.width - 24 - SCHECKBOX,imageMsgView.frame.origin.y + (imageMsgView.frame.size.height - 14)/2)];
                                }
                                if (j != 1 &&k != msgData.partList.count -1&&msgData.partList.count>1) {
                                    [imageMsgView setIsMMS:YES];
                                }
                                if (k == msgData.partList.count -1) {
                                    [imageMsgView setFrame:NSMakeRect(imageMsgView.frame.origin.x, imageMsgView.frame.origin.y -10, imageMsgView.frame.size.width, imageMsgView.frame.size.height +10)];
                                }
                                [imageMsgView addSubview:imageView];
                                [_customView addSubview:bgImageView];
                                [_customView addSubview:imageMsgView];
                                _scrollallHeight += imageMsgView.frame.size.height - 4;
                                
                                if (imageMsgView != nil) {
                                    [imageMsgView release];
                                }
                                if (imageView != nil) {
                                    [imageView release];
                                }
                                if (bgImageView != nil) {
                                    [bgImageView release];
                                }
                                if (image != nil) {
                                    [image release];
                                }
                            }
                        }else if ([ctString rangeOfString:@"text"].location != NSNotFound && ![IMBHelper stringIsNilOrEmpty:partEntity.text]) {
                            j++;
                            _scrollheight = 0;
                            NSTextView *textView = [[NSTextView alloc] init];
                            [textView setEditable:YES];
                            [textView setSelectable:YES];
                            [textView setDrawsBackground:NO];
                            float x = 0;
                            float width = 0;
                            
                            NSRect rect = [IMBHelper calcuTextBounds:partEntity.text fontSize:12];
                            if (msgData.type == 1) {
                                x = 45;
                                if (rect.size.width > (_customView.frame.size.width - 100) / 2) {
                                    width = (_customView.frame.size.width - 100) / 2;
                                }else {
                                    width = (_customView.frame.size.width - 100) / 2;
                                }
                            }else {
                                if (rect.size.width > (_customView.frame.size.width - 100) / 2) {
                                    x = _customView.frame.size.width / 2;
                                    width = (_customView.frame.size.width - 100) / 2;
                                }else {
                                    width = (_customView.frame.size.width - 100) / 2;
                                    x = _customView.frame.size.width / 2;
                                }
                            }
                            [textView setFrame:NSMakeRect(x, _scrollallHeight, width, 16)];
                            _scrollheight = [self setTextViewForString:partEntity.text withTextVeiw:textView withDelete:msgData.isDeleted];
                            if (msgData.type == 1) {
                                [textView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_message_receiveColor", nil)]];
                            }else {
                                [textView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_message_sendColor", nil)]];
                            }
                            if (_scrollheight < 17) {
                                _scrollheight = 17;
                            }
                            if (msgData.isDeleted == NO) {
                                
                                [textView setTextColor:[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1]];
                            }
                            [textView setEditable:NO];
                            [textView setSelectable:NO];
                            
                            int y = _scrollallHeight;
                            if (j != 1) {
                                y = _scrollallHeight - 20;
                            }
                            
                            IMBMessageView *messageView = nil;
                            if (msgData.type == 1) {
                                messageView = [[IMBMessageView alloc] initWithFrame:NSMakeRect( x , y, width+22, _scrollheight +8)];
                                [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"Message_MMS_Color", nil)]];
                            }
                            if (msgData.type == 2) {
                                messageView = [[IMBMessageView alloc] initWithFrame:NSMakeRect(_customView.frame.size.width/2 , y, width+22, _scrollheight+8)];
                                [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"Message_Right_Color", nil)]];
                            }
                            
                            [textView setFrameOrigin:NSMakePoint(16, 3)];
                            [messageView addSubview:textView];
                            
                            NSImageView *bgImageView = nil;
                            if (msgData.type == 1) {
                                if ([tempStr rangeOfString:@"image"].location != NSNotFound || [tempStr rangeOfString:@"audio"].location != NSNotFound || [tempStr rangeOfString:@"video"].location != NSNotFound || ([tempStr rangeOfString:@"text"].location != NSNotFound && ![IMBHelper stringIsNilOrEmpty:tempEntity.text])) {
                                    if (i == msgData.partList.count) {
                                        bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(messageView.frame.origin.x - BGIMAGEX - 5, messageView.frame.origin.y + messageView.frame.size.height - 15 + BGIMAGEY, 20, 18)];
                                        
                                        [bgImageView setImage:[StringHelper imageNamed:@"mu_left"]];
                                        [bgImageView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                                    }
                                } else {
                                    if (i == msgData.partList.count - 1) {
                                        bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(messageView.frame.origin.x - BGIMAGEX - 5, messageView.frame.origin.y + messageView.frame.size.height - 15 + BGIMAGEY, 20, 18)];
                                        [bgImageView setImage:[StringHelper imageNamed:@"bulue_ad_right"]];
                                        [bgImageView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                                    }
                                }

                                [msgData.checkBtn setFrameOrigin:NSMakePoint(messageView.frame.origin.x-26 - ACHECKBOX,messageView.frame.origin.y + (messageView.frame.size.height - 14)/2)];
                                [msgData.checkBtn setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                                [messageView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                            }else {
                                [messageView setFrameOrigin:NSMakePoint(messageView.frame.origin.x-44, messageView.frame.origin.y)];
                                if ([tempStr rangeOfString:@"image"].location != NSNotFound || [tempStr rangeOfString:@"audio"].location != NSNotFound || [tempStr rangeOfString:@"video"].location != NSNotFound || ([tempStr rangeOfString:@"text"].location != NSNotFound && ![IMBHelper stringIsNilOrEmpty:tempEntity.text])) {
                                    if (i == msgData.partList.count) {
                                        bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(messageView.frame.origin.x + messageView.frame.size.width - 15 + BGIMAGEX + 1, messageView.frame.origin.y + messageView.frame.size.height - 15 + BGIMAGEY, 20, 18)];
                                        
                                        [bgImageView setImage:[StringHelper imageNamed:@"bulue_ad_right"]];
                                        [bgImageView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                                    }
                                } else {
                                    if (i == msgData.partList.count - 1) {
                                        bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(messageView.frame.origin.x + messageView.frame.size.width - 15 + BGIMAGEX + 1, messageView.frame.origin.y + messageView.frame.size.height - 15 + BGIMAGEY, 20, 18)];
                                        
                                        [bgImageView setImage:[StringHelper imageNamed:@"bulue_ad_right"]];
                                        [bgImageView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                                    }
                                }
                                
                                [msgData.checkBtn setFrameOrigin:NSMakePoint(_customView.frame.size.width -24 - SCHECKBOX,messageView.frame.origin.y + (messageView.frame.size.height - 14)/2)];
                                
                                [msgData.checkBtn setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                                [messageView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                            }
//                            if (j != 1&&k != msgData.partList.count -1&&msgData.partList.count>1) {
                                [messageView setIsMMS:YES];
//                            }else{
//                                [messageView setIsMMS:NO];
//                            }
                            if (k == msgData.partList.count -1) {
                                if (msgData.type != 1) {
                                    [messageView setFrame:NSMakeRect(messageView.frame.origin.x, messageView.frame.origin.y -20, messageView.frame.size.width, messageView.frame.size.height +20)];
                                }else{
                                    [messageView setFrame:NSMakeRect(messageView.frame.origin.x, messageView.frame.origin.y -10, messageView.frame.size.width, messageView.frame.size.height +10)];
                                }
                            }
                            [_customView addSubview:bgImageView];
                            [_customView addSubview:messageView];
                            
                            _scrollallHeight += _scrollheight +6;
                            
                            if (textView != nil) {
                                [textView release];
                            }
                            if (messageView != nil) {
                                [messageView release];
                            }
                            if (bgImageView != nil) {
                                [bgImageView release];
                            }
                        }
                    }
                }
                [viewAry addObject:msgData];
            }
        }
        [_androidEntity.messageList removeObjectsInArray:viewAry];
        if (viewAry != nil) {
            [viewAry release];
            viewAry = nil;
        }
        [_customView setFrameSize:NSMakeSize(_customView.frame.size.width, _scrollallHeight + 10)];
    }
}

- (float)setTextViewForString:(NSString *)myString withTextVeiw:(NSTextView *)textView  withDelete:(BOOL)isDeleted {
    NSMutableAttributedString *drawStr = [[[NSMutableAttributedString alloc] initWithString:myString] autorelease];
    
    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:myString] autorelease];
    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(textView.frame.size.width, FLT_MAX)] autorelease];
    
    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:2.0f];
    [textParagraph setAlignment:NSLeftTextAlignment];
    [textParagraph setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *fontDic = nil;
    if (isDeleted == YES) {
        fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, [StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)], NSForegroundColorAttributeName, [NSNumber numberWithInt:1], NSStrikethroughStyleAttributeName, [NSFont fontWithName:@"Helvetica Neue" size:12], NSFontAttributeName, nil];
    }else {
        fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:12],NSFontAttributeName,nil];
    }
    
    NSRect rect = [myString boundingRectWithSize:NSMakeSize(textView.frame.size.width, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDic];
    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
    [drawStr addAttributes:fontDic range:NSMakeRange(0, textStorage.length)];
    float changeHeight = rect.size.height;
    if (changeHeight > 40) {
        changeHeight += 20;
    }
    [textView setFrameSize:NSMakeSize(textView.frame.size.width, changeHeight)];
    [[textView textStorage] setAttributedString:drawStr];
    return changeHeight;
}

- (void)setHomeTextString:(NSString *)textString withFolat:(float)height {
    if ([StringHelper stringIsNilOrEmpty:textString]) {
        return;
    }
    NSTextField *homeText = [[NSTextField alloc] init];
    [homeText setBordered:NO];
    [homeText setAlignment:NSLeftTextAlignment];
    [homeText setDrawsBackground:NO];
    [homeText setStringValue:textString];
    [homeText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [homeText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [homeText setFrame:NSMakeRect((_msgContentCustomView.frame.size.width - 400) / 2, height, 400, 18)];
    [homeText setAlignment:NSCenterTextAlignment];
    //    [homeText sizeToFit];
    [homeText setEditable:NO];
    [homeText setAutoresizingMask: NSViewMinXMargin|NSViewMaxXMargin|NSViewWidthSizable];
    [_msgContentCustomView addSubview:homeText];
    [homeText release];
}

- (void)changeTableView:(NSInteger)row {
    NSInteger count = 0;
    if (row <0) {
        return;
    }
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0 || row > disAry.count -1) {
        return;
    }
    count = disAry.count;
    _scrollheight = 0;
    _scrollallHeight = 4;
    NSArray *views = _msgContentCustomView.subviews;
    if (views != nil && views.count > 0) {
        for (long i = views.count - 1; i < views.count; i--) {
            NSView *view = [views objectAtIndex:i];
            [view removeFromSuperview];
        }
    }
    if (count == 0) {
        NSArray *views = _msgContentCustomView.subviews;
        if (views != nil && views.count > 0) {
            for (long i = views.count - 1; i < views.count; i--) {
                NSView *view = [views objectAtIndex:i];
                [view removeFromSuperview];
            }
        }
    }else{
        if (disAry != nil && disAry.count > 0) {
            _androidSmsSonData = [disAry objectAtIndex:row];
            NSView *doView = (NSView *)_msgContentScrollView.documentView;
            [_msgContentScrollView.documentView setFrame:NSMakeRect(doView.frame.origin.x, doView.frame.origin.y, doView.frame.size.width, _msgContentScrollView.frame.size.height)];
            [_androidEntity.messageList removeAllObjects];
            [_androidEntity.messageList addObjectsFromArray:_androidSmsSonData.messageList];
            [self showSingleMessageContent:_androidSmsSonData];
        }
    }
}

#pragma mark - Action
- (IBAction)sortRightPopuBtn:(id)sender {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0) {
        return;
    }
    NSString *str1 = nil;
    NSMenuItem *item = [_sortRightPopuBtn selectedItem];
    NSInteger tag = [_sortRightPopuBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
        if (menuItem.tag != 1 || menuItem.tag != 2) {
            [menuItem setState:NSOffState];
        }
    }
    
    if (item.tag == 1 ) {
        _isSortByName = YES;
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
        NSString *str = @"";
        
        str = @"threadsname";
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:str ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [disAry sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        str1 = CustomLocalizedString(@"SortBy_Name", nil);
    }else if (tag == 2){
        _isSortByName = NO;
        for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
            if (menuItem.tag != 2) {
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
        NSString *str = @"";
        
        str = @"lastMsgTime";
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:str ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [disAry sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        str1 = CustomLocalizedString(@"SortBy_Date", nil);
    }else if (item.tag == 3){
        _isAscending = YES;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = nil;
        if (_isSortByName) {
            for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
                if (menuItem.tag == 1) {
                    [menuItem setState:NSOnState];
                }
            }
            NSString *str = @"";
            
            str = @"threadsname";
            
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:str ascending:_isAscending selector:@selector(localizedStandardCompare:)];
            str1 = CustomLocalizedString(@"SortBy_Name", nil);
        }else {
            for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
                if (menuItem.tag == 2) {
                    [menuItem setState:NSOnState];
                }
            }
            NSString *str = @"";
            
            str = @"lastMsgTime";
            
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:str ascending:_isAscending selector:@selector(localizedStandardCompare:)];
            str1 = CustomLocalizedString(@"SortBy_Date", nil);
        }
        
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [disAry sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
    }else if (item.tag == 4){
        _isAscending = NO;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = nil;
        if (_isSortByName) {
            for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
                if (menuItem.tag == 1) {
                    [menuItem setState:NSOnState];
                }
            }
            NSString *str = @"";
            
            str = @"threadsname";
            
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:str ascending:_isAscending selector:@selector(localizedStandardCompare:)];
            str1 = CustomLocalizedString(@"SortBy_Name", nil);
        }else {
            for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
                if (menuItem.tag == 2) {
                    [menuItem setState:NSOnState];
                }
            }
            NSString *str = @"";
            
            str = @"lastMsgTime";
            
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:str ascending:_isAscending selector:@selector(localizedStandardCompare:)];
            str1 = CustomLocalizedString(@"SortBy_Date", nil);
        }
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [disAry sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
    }
    
    [_sortRightPopuBtn setTitle:str1];
    [_sortRightPopuBtn setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    
    NSRect rect = [TempHelper calcuTextBounds:str1 fontSize:12];
    [_sortRightPopuBtn setFrame:NSMakeRect(_topWhiteView.frame.size.width - 30 - rect.size.width-12,_sortRightPopuBtn.frame.origin.y , rect.size.width +30, _sortRightPopuBtn.frame.size.height)];
    NSInteger row = [_itemTableView selectedRow];
    [self changeTableView:row];
}

- (IBAction)sortSelectedPopuBtn:(id)sender {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0) {
        return;
    }
    NSMenuItem *item = [_selectSortBtn selectedItem];
    NSInteger tag = [_selectSortBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _selectSortBtn.itemArray) {
        [menuItem setState:NSOffState];
    }
    
    
    if (tag == 1) {
        for (IMBSMSChatDataEntity *note in disAry) {
            note.checkState = Check;
        }
        [_itemTableView changeHeaderCheckState:Check];
        //        [_sortRightPopuBtn setTitle:CustomLocalizedString(@"showMenu_id_1", nil)];
    }else if (tag == 2){
        for (IMBSMSChatDataEntity *note in disAry) {
            note.checkState = UnChecked;
        }
        
        [_itemTableView changeHeaderCheckState:UnChecked];
        //        [_sortRightPopuBtn setTitle:CustomLocalizedString(@"showMenu_id_2", nil)];
    }else if (tag == 3){
        
        
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
#pragma mark - 刷新
- (void)androidReload:(id)sender {
    [_toolBar toolBarButtonIsEnabled:NO];
    [self disableFunctionBtn:NO];
    _isReload = YES;
    [_loadingBox setContentView:_loadingView];
    [_loadingAnmationView startAnimation];
    //检查apk是否赋予权限
    if (_delegate != nil && [_delegate respondsToSelector:@selector(checkDeviceGreantedPermission:)] ) {
        [_delegate checkDeviceGreantedPermission:ReloadFunctionType];
    }
}

- (void)reloadData {
    [_android querySMSDetailInfo];
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    _dataSourceArray = [_android.adSMS.reslutEntity.reslutArray retain];
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (int i = 0; i <_dataSourceArray.count; i ++) {
                if (_isReload) {
                    break;
                }
                IMBThreadsEntity *threadsentity  = [_dataSourceArray objectAtIndex:i];
                if (_isReload) {
                    break;
                }
                for (int y = 0; y < threadsentity.messageList.count; y ++) {
                    if (_isReload) {
                        break;
                    }
                    IMBADMessageEntity *messageEntity = [threadsentity.messageList objectAtIndex:y];
                    if (_isReload) {
                        break;
                    }
                    for (int k = 0 ; k < messageEntity.partList.count; k ++) {
                        if (_isReload) {
                            break;
                        }
                        IMBSMSPartEntity *partEntity = [messageEntity.partList objectAtIndex:k];
                        NSString *ctString = partEntity.ct;
                        if ([ctString rangeOfString:@"image"].location != NSNotFound) {
                            if (partEntity.localPath == nil || ![[NSFileManager defaultManager] fileExistsAtPath:partEntity.localPath]) {
                                [_android.adSMS getAttachmentContent:partEntity withPath:nil];
                            }
                        }
                        if (_isReload) {
                            break;
                        }
                    }
                    if (_isReload) {
                        break;
                    }
                }
                if (_isReload) {
                    break;
                }
            }
            if (_isReload) {
                _isReload = NO;
            }
        });
        [self disableFunctionBtn:YES];
        if ([_dataSourceArray count]>0) {
            [_mainBox setContentView:_detailView];
            NSInteger row = [_itemTableView selectedRow];
            if (row == 0) {
                [self tableViewSelectionDidChange:nil];
            }
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        }else {
            [_mainBox setContentView:_noDataView];
            [self configNoDataView];
        }
        [_loadingBox setContentView:nil];
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
            [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
        }
        [_loadingAnmationView endAnimation];
        [_itemTableView reloadData];
        [_toolBar toolBarButtonIsEnabled:YES];
        [_itemTableView reloadData];
    });
}

- (void)cancelReload {
    if ([_dataSourceArray count]>0) {
        [_mainBox setContentView:_detailView];
    }else {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }
    [self disableFunctionBtn:YES];
    [_loadingAnmationView endAnimation];
    [_toolBar toolBarButtonIsEnabled:YES];
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn {
    _isSearch = YES;
    _searchFieldBtn = searchBtn;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"threadsname CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
        if (_researchdataSourceArray.count > 0) {
            [self changeTableView:0];
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]byExtendingSelection:NO];
        }else{
            NSArray *views = _msgContentCustomView.subviews;
            if (views != nil && views.count > 0) {
                for (long i = views.count - 1; i < views.count; i--) {
                    NSView *view = [views objectAtIndex:i];
                    [view removeFromSuperview];
                }
            }
        }
    }else{
        _isSearch = NO;
        NSInteger row = [_itemTableView selectedRow];
        if (_dataSourceArray.count > 0 && row >= 0 && row < _dataSourceArray.count ) {
            [self changeTableView:row];
        }else if(_dataSourceArray.count > 0) {
            [self changeTableView:0];
        }
        [_researchdataSourceArray removeAllObjects];
    }
    [_itemTableView reloadData];
}

- (void)animationAddTransferView:(NSView *)view {
    [view setFrame:NSMakeRect(0, 0, [[_delegate view] frame].size.width, [[_delegate view] frame].size.height)];
    [[_delegate view] addSubview:view];
    
    [view setWantsLayer:YES];
    [view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
}

- (void)reloadTableView {
    _isSearch = NO;
    [_itemTableView reloadData];
    if (_dataSourceArray.count > 0) {
        NSInteger row = [_itemTableView selectedRow];
        if (row == 0) {
            [self changeTableView:0];
        }else {
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        }
    }
}

- (void)menuWillOpen:(NSMenu *)menu {
    [self initAndroidDeviceMenuItem];
}


@end
