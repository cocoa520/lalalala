//
//  IMBMessageViewController.m
//  AnyTrans
//
//  Created by long on 16-7-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBMessageViewController.h"
#import "IMBSMSChatDataEntity.h"
#import "IMBMessageSqliteManager.h"
#import "IMBCustomHeaderCell.h"
#import "IMBCheckBoxCell.h"
#import "IMBNotificationDefine.h"
#import "IMBAnimation.h"
#import "IMBDeviceMainPageViewController.h"
#import "IMBMessageNameTextCell.h"
#import "StringHelper.h"
#define BGIMAGEX 5
#define BGIMAGEY 4
#define ACHECKBOX 5
#define SCHECKBOX 8
@implementation IMBMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    if (self = [super initWithIpod:ipod withCategoryNodesEnum:category withDelegate:delegate]) {
        _isBackup = NO;
        _dataSourceArray = [_information.messageArray retain];
    }
    return self;
}

- (id)initWithProductVersion:(SimpleNode *)node withDelegate:(id)delegate WithIMBBackupDecryptAbove4:(IMBBackupDecryptAbove4 *)abve4 {
    if ([super initWithNibName:@"IMBMessageViewController" bundle:nil]) {
        _delegate = delegate;
        _category = Category_Message;
        _isBackup = YES;
        _node = node;
        _decryptAbove4 = abve4;
    }
    return self;
}

- (id)initiCloudWithiCloudBackUp:(IMBiCloudBackup *)icloudBackup WithDelegate:(id)delegate {
    if ([super initWithNibName:@"IMBMessageViewController" bundle:nil]) {
        _delegate = delegate;
        _category = Category_Message;
        _isiCloud = YES;
        _isBackup = YES;
        _iCloudBackup = icloudBackup;
        _isiCloudView = YES;
    }
    return self;
}

-(void)dealloc {
    [[IMBLogManager singleton] writeInfoLog:@"message del"];
    [[IMBLogManager singleton] writeInfoLog:@"message del1"];
    if (_backupAnimationVC) {
        [_backupAnimationVC release];
        _backupAnimationVC = nil;
    }
    [nc removeObserver:self name:NOTITY_HIDE_REFRESHVIEW object:nil];
    [nc removeObserver:self name:NOTIFY_BACKUP_COMPELTE object:nil];
    [nc removeObserver:self name:NSViewBoundsDidChangeNotification object:nil];
    [nc removeObserver:self name:NOTIFY_BACKUP_ERROE object:nil];
    [[IMBLogManager singleton] writeInfoLog:@"message del111"];
    [super dealloc];
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        if (_isBackup) {
            NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_76", nil)];
            NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
            [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
            [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
            [_backupNoDataTextStr setAttributedStringValue:as];
            [_backupNoDataTextStr setSelectable:NO];
        }else{
            [self configNoDataView];
            [self configRefreshView];
        }
    });
}

-(void)awakeFromNib {
    _isloadingPopBtn = YES;
    [super awakeFromNib];
    //    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(backupCompleteReload:) name:NOTIFY_BACKUP_COMPELTE object:nil];
    [nc addObserver:self selector:@selector(backupErrorReload:) name:NOTIFY_BACKUP_ERROE object:nil];
    [nc addObserver:self selector:@selector(hideRefreshView) name:NOTITY_HIDE_REFRESHVIEW object:nil];
    
    [self configNoDataView];
    [_topWhiteView setIsBommt:YES];
    [_topWhiteView setBackgroundColor:[NSColor clearColor]];
    _itemTableView.allowsMultipleSelection = NO;
    [_itemTableView setGridColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    [nc addObserver: self
           selector: @selector(boundsDidChangeNotification:)
               name: NSViewBoundsDidChangeNotification
             object: [_msgContentScrollView contentView]];
    if (_isBackup) {
        [_loadingAnmationView startAnimation];
        [_mainBox setContentView:_loadingView];
//        [self.view setFrame:NSMakeRect(0, 0, 800, 504)];
//        [_scrollView setFrame:NSMakeRect(0, 0, 382, 504)];
//        [_noDataView setFrameSize:NSMakeSize(800, 504)];
        [_noDataScrollView setFrameOrigin:NSMakePoint(_noDataScrollView.frame.origin.x - 100, _noDataScrollView.frame.origin.y)];
        [_noDataImageView setFrameOrigin:NSMakePoint(_noDataImageView.frame.origin.x - 100, _noDataImageView.frame.origin.y)];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            IMBMessageSqliteManager *bookMarkManager = nil;
            if (_isiCloud) {
                bookMarkManager = [[IMBMessageSqliteManager alloc] initWithiCloudBackup:_iCloudBackup withType:_iCloudBackup.iOSVersion];
            }else{
                bookMarkManager = [[IMBMessageSqliteManager alloc] initWithAMDevice:nil backupfilePath:_node.backupPath withDBType:_node.productVersion WithisEncrypted:_node.isEncrypt withBackUpDecrypt:_decryptAbove4];
            }
            [bookMarkManager querySqliteDBContent] ;
            dispatch_async(dispatch_get_main_queue(), ^{
                _dataSourceArray = [bookMarkManager.dataAry retain];
                [bookMarkManager release];
                if (_dataSourceArray.count > 0) {
                    [_mainBox setContentView:_detailView];
                }else{
                    [_backupnodataImageView setImage:[StringHelper imageNamed:@"noData_message"]];
                    [_mainBox setContentView:_backupNoDataView];
                    
                    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_76", nil)];
                    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
                    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
                    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
                    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
                    [_backupNoDataTextStr setAttributedStringValue:as];
                    [_backupNoDataTextStr setSelectable:NO];
                }
                [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                [_itemTableView reloadData];
            });
        });
    }else {
        if (_dataSourceArray.count == 0) {
            [_mainBox setContentView:_noDataView];
        }else {
            [_mainBox setContentView:_detailView];
        }
        [self configRefreshView];
    }
    entity = [[IMBSMSChatDataEntity alloc]init];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]byExtendingSelection:NO];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
}

- (void)boundsDidChangeNotification: (NSNotification *) notification {
    
    int contentOffset = _msgContentScrollView.documentVisibleRect.origin.y;
    NSView *doView = (NSView *)_msgContentScrollView.documentView;
    if (contentOffset != 0 && contentOffset > doView.frame.size.height - _msgContentScrollView.contentView.frame.size.height - 10 && entity.msgModelList.count > 0) {
        [self showSingleMessageContent:_smsSonData];
    }
}

- (void)changeSkin:(NSNotification *)notification
{
    //    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    if (_isBackup) {
        NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_76", nil)];
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [_backupNoDataTextStr setAttributedStringValue:as];
        [_backupNoDataTextStr setSelectable:NO];
        [_backupnodataImageView setImage:[StringHelper imageNamed:@"noData_message"]];
    }else{
        [self configNoDataView];
        [self configRefreshView];
    }
    [_itemTableView setGridColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_topWhiteView setNeedsDisplay:YES];
    [_sortRightPopuBtn setNeedsDisplay:YES];
    [_selectSortBtn setNeedsDisplay:YES];
    [_loadingAnmationView setNeedsDisplay:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
}

#pragma mark - NSTextView
- (void)configNoDataView {
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_message"]];
    [_textView setDelegate:self];
    NSString *promptStr = @"";
    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_76", nil)];
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_textView textStorage] setAttributedString:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
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
    IMBSMSChatDataEntity *entity1 = [disAry objectAtIndex:row];
    if ([[tableColumn identifier] isEqualToString:@"Name"]) {
      
        if (entity1.lastMsgText.length>0) {
            NSString *removeR = [entity1.lastMsgText stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSString *titleStr = [removeR stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSString *remover2 = [entity1.contactName stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSString *titleStr1 = [remover2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *subTitleStr = @"";
            if (titleStr1 != nil) {
                int length = (int)titleStr1.length;//[self convertToInt:text];
                if (length > 22) {
                    NSString *frontText = [titleStr1 substringWithRange:NSMakeRange(0, 20)];
                    for (int i = 0;i <3 ; i++) {
                        frontText = [frontText stringByAppendingString:@"."];
                    }
                    subTitleStr = frontText;
                }else{
                    subTitleStr = titleStr1;
                }
            }

            NSString *remover3 = [entity1.lastMsgTime stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSString *titleStr2 = [remover3 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            return [NSString stringWithFormat:@"%@\n%@\n%@",subTitleStr,titleStr2,titleStr];
        }else
        {
            NSString *remover2 = [entity1.contactName stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSString *titleStr1 = [remover2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *subTitleStr = @"";
            if (titleStr1 != nil) {
                int length = (int)titleStr1.length;//[self convertToInt:text];
                if (length > 22) {
                    NSString *frontText = [titleStr1 substringWithRange:NSMakeRange(0, 20)];
                    for (int i = 0;i <3 ; i++) {
                        frontText = [frontText stringByAppendingString:@"."];
                    }
                    subTitleStr = frontText;
                }else{
                    subTitleStr = titleStr1;
                }
            }
            NSString *remover3 = [entity1.lastMsgTime stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSString *titleStr2 = [remover3 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            return [NSString stringWithFormat:@"%@\n%@",subTitleStr,titleStr2];
        }
    }else if ([[tableColumn identifier] isEqualToString:@"Time"]) {
        return entity1.lastMsgTime;
    }else if ([[tableColumn identifier] isEqualToString:@"CheckCol"]) {
        return [NSNumber numberWithInt:entity1.checkState];
    }
    
    return @"";
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([[tableColumn identifier] isEqualToString:@"CheckCol"]) {
        IMBCheckBoxCell *boxCell = (IMBCheckBoxCell *)cell;
        boxCell.outlineCheck = YES;
    }else if ([[tableColumn identifier] isEqualToString:@"Name"]) {
        IMBMessageNameTextCell *messageCell = (IMBMessageNameTextCell *)cell;
        [messageCell setIsMessage:YES];
    }
}

- (void)tableView:(NSTableView *)tableView row:(NSInteger)index{
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

-(void)setAllselectState:(CheckStateEnum)sender{
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

#pragma mark - NSTableView delegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 60;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView *tabTableView = [notification object];
    NSInteger row = [tabTableView selectedRow];
    [self changeTableView:row];
}

- (void)showSingleMessageContent:(id)mesEntity {
    IMBSMSChatDataEntity *aentity = mesEntity;
    NSString *dateStandardString = @"";
    NSMutableArray *viewAry = [[NSMutableArray alloc]init];
    if (_scrollallHeight == 4) {
        if (![StringHelper stringIsNilOrEmpty:aentity.handleService]) {
            [self setHomeTextString:[NSString stringWithFormat:@"<%@>",aentity.handleService] withFolat:_scrollallHeight];
            _scrollallHeight += 36;
        }
    }
    if (entity.msgModelList != nil && entity.msgModelList.count > 0) {
        for (IMBMessageDataEntity *msgData in entity.msgModelList) {
            @autoreleasepool {
                NSView *doView = (NSView *)_msgContentScrollView.documentView;
                if (_scrollallHeight > doView.frame.size.height + 1000) {
                    break;
                }
                if ([dateStandardString isEqualToString:@""] || ![dateStandardString isEqualToString:msgData.msgDateText]) {
                    dateStandardString = msgData.msgDateText;
                    [self setHomeTextString:msgData.msgDateText withFolat:_scrollallHeight];
                    _scrollallHeight += 36;
                }
                //显示时间
                if (aentity.sessionType == 43) {
                    NSString *currentTime = [IMBHelper longToDateString:msgData.msgDate withMode:8];
                    if (!msgData.isSent) {
                        currentTime = msgData.contactName;
                    }
                    if (![IMBHelper stringIsNilOrEmpty:currentTime]) {
                        NSRect timeRect = [IMBHelper calcuTextBounds:currentTime fontSize:12];
                        float ox = 0.0;
                        float oy = 0.0;
                        oy = _scrollallHeight;
                        if (_isBackup) {
                            if (msgData.isSent) {
                                [self setHomeiMessageTextString:currentTime withFolat:_scrollallHeight];
                            } else {
                                ox = 45;
                                [self setHomeiMessageTextString:currentTime withFolat:_scrollallHeight];
                            }

                        }else{
                            if (msgData.isSent) {
                                [self setDeviceHomeiMessageTextString:currentTime withFolat:_scrollallHeight];
                            } else {
                                ox = 45;
                                [self setDeviceHomeiMessageTextString:currentTime withFolat:_scrollallHeight];
                            }
                        }
                    
                        _scrollallHeight +=timeRect.size.height;
                    }
                }
                
                if ([msgData.msgText contains:@"￼"]||[StringHelper stringIsNilOrEmpty:msgData.msgText]) {
                    if ([StringHelper stringIsNilOrEmpty:msgData.msgText]) {
                        if (msgData.isAttachments && msgData.attachmentList != nil && msgData.attachmentList.count > 0) {
                            NSImage *image = nil;
                            for (IMBSMSAttachmentEntity *attachEntity in msgData.attachmentList) {
                                int i = 0;
                                NSString *txtString = nil;
                                for (IMBAttachDetailEntity *detailEntity in attachEntity.attachDetailList) {
                                    if (detailEntity.isPerviewImage == YES) {
                                        image = [detailEntity.thumbImage retain];
                                        break;
                                    }
                                    i++;
                                    if (i == attachEntity.attachDetailList.count) {
                                        image = [detailEntity.thumbImage retain];
                                        if (image == nil) {
                                            image = [[[NSWorkspace sharedWorkspace] iconForFile:detailEntity.backUpFilePath] retain];
                                            txtString = detailEntity.fileName;
                                        }
                                    }
                                }
                                
                                if (image != nil) {
                                    float x = 0;
                                    float width = 0;
                                    float oriWidth = (_msgContentCustomView.frame.size.width - 100) / 2;
                                    if (oriWidth > 380) {
                                        oriWidth = 380;
                                    }
                                    if (msgData.isSent == NO) {
                                        x = 50;
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
                                            x = _msgContentCustomView.frame.size.width - 35 - width;
                                            _scrollheight = image.size.height * (width / image.size.width);
                                        }else {
                                            width = image.size.width;
                                            _scrollheight = image.size.height;
                                            x = _msgContentCustomView.frame.size.width - 35 - width;
                                        }
                                    }
                                    
                                    NSImageView *imageView = nil;
                                    IMBMessageView *imageMsgView = nil;
                                    
                                    if (i == attachEntity.attachDetailList.count) {
                                        if ([StringHelper stringIsNilOrEmpty:txtString]) {
                                            imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(8, 8, width, _scrollheight)];
                                            [imageView setImage:image];
                                            imageMsgView = [[IMBMessageView alloc] initWithFrame:NSMakeRect(x, _scrollallHeight, imageView.frame.size.width + 16, imageView.frame.size.height + 16)];
                                        }else {
                                            imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(8, 24, width, _scrollheight)];
                                            [imageView setImage:image];
                                            
                                            NSTextView *textView = [[NSTextView alloc] init];
                                            [textView setEditable:YES];
                                            [textView setSelectable:YES];
                                            [textView setDrawsBackground:NO];
                                            float x = 0;
                                            float width_txt = 0;
                                            NSRect rect = [StringHelper calcuTextBounds:txtString fontSize:12];
                                            if (msgData.isSent == NO) {
                                                x = 50;
                                                if (rect.size.width > (_msgContentCustomView.frame.size.width - 100) / 2) {
                                                    width_txt = (_msgContentCustomView.frame.size.width - 100) / 2;
                                                }else {
                                                    width_txt = rect.size.width + 10;
                                                }
                                            }else {
                                                if (rect.size.width > (_msgContentCustomView.frame.size.width - 100) / 2) {
                                                    x = _msgContentCustomView.frame.size.width / 2;
                                                    width_txt = (_msgContentCustomView.frame.size.width - 100) / 2;
                                                }else {
                                                    width_txt = rect.size.width + 10;
                                                    x = _msgContentCustomView.frame.size.width - 50 - width_txt;
                                                }
                                                
                                            }
                                            [textView setFrame:NSMakeRect(x, _scrollallHeight, width_txt, 16)];
                                            _scrollheight = [self setTextViewForString:txtString withTextVeiw:textView withDelete:msgData.isDeleted];
                                            if (_scrollheight < 17) {
                                                _scrollheight = 17;
                                            }
                                            if (msgData.isDeleted == NO) {
                                                [textView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                                            }
                                            
                                            [textView setEditable:NO];
                                            [textView setSelectable:NO];
                                            [textView setFrameOrigin:NSMakePoint(8, 4)];
                                            
                                            float txtWid = 0;
                                            if (imageView.frame.size.width > width_txt) {
                                                txtWid = imageView.frame.size.width;
                                            }else {
                                                txtWid = width_txt;
                                            }
                                            imageMsgView = [[IMBMessageView alloc] initWithFrame:NSMakeRect(x, _scrollallHeight, txtWid + 16, imageView.frame.size.height + _scrollheight + 16)];
                                            [imageMsgView addSubview:textView];
                                            
                                            if (textView != nil) {
                                                [textView release];
                                                textView = nil;
                                            }
                                        }
                                        
                                        if ([aentity.handleService isEqualToString:@"iMessage"]) {
                                            if (msgData.isSent == NO) {
                                                [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_receive_bgColor", nil)]];
                                            }
                                            if (msgData.isSent == YES) {
                                                [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_send_Message_bgColor", nil)]];
                                            }
                                        }else if ([aentity.handleService isEqualToString:@"Message"] || [aentity.handleService isEqualToString:@"SMS"]) {
                                            if (msgData.isSent == NO) {
                                                [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_receive_bgColor", nil)]];
                                            }
                                            if (msgData.isSent == YES) {
                                                [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_send_iMessage_bgColor", nil)]];
                                            }
                                        }else {
                                            if (msgData.isSent == NO) {
                                                [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_receive_bgColor", nil)]];
                                            }
                                            if (msgData.isSent == YES) {
                                                [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_send_Message_bgColor", nil)]];
                                            }
                                        }
                                    }else if (i < attachEntity.attachDetailList.count) {
                                        imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, width, _scrollheight)];
                                        [imageView setImage:image];
                                        imageMsgView = [[IMBMessageView alloc] initWithFrame:NSMakeRect(x, _scrollallHeight, imageView.frame.size.width, imageView.frame.size.height)];
                                        [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_receive_bgColor", nil)]];
                                    }
                                    
                                    NSImageView *bgImageView = nil;
                                    if (msgData.isSent == NO) {
                                        bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(imageMsgView.frame.origin.x - 11 , imageMsgView.frame.origin.y + imageMsgView.frame.size.height - 15, 20, 18)];
                                        [bgImageView setImage:[StringHelper imageNamed:@"mu_left"]];
                                        [imageMsgView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                                        [bgImageView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                                        
                                    }else {
                                        [imageMsgView setFrameOrigin:NSMakePoint(imageMsgView.frame.origin.x-24, imageMsgView.frame.origin.y)];
                                        bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(imageMsgView.frame.origin.x + imageMsgView.frame.size.width - 10, imageMsgView.frame.origin.y + imageMsgView.frame.size.height - 15, 20, 18)];
                                        if ([aentity.handleService isEqualToString:@"iMessage"]) {
                                            [bgImageView setImage:[StringHelper imageNamed:@"mi_right"]];
                                        }else if ([aentity.handleService isEqualToString:@"Message"] || [aentity.handleService isEqualToString:@"SMS"]) {
                                            [bgImageView setImage:[StringHelper imageNamed:@"bulue_right"]];
                                        }else {
                                            [bgImageView setImage:[StringHelper imageNamed:@"bulue_right"]];
                                        }
                                        [imageMsgView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                                        [bgImageView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                                        
                                    }
                                    [imageMsgView addSubview:imageView];
                                    if (i == attachEntity.attachDetailList.count ) {
                                        [_msgContentCustomView addSubview:bgImageView];
                                    }
                                    [_msgContentCustomView addSubview:imageMsgView];
                                    
                                    _scrollallHeight += imageMsgView.frame.size.height + 30;
                                    
                                    if (imageMsgView != nil) {
                                        [imageMsgView release];
                                    }
                                    if (imageView != nil) {
                                        [imageView release];
                                    }
                                    if (bgImageView != nil) {
                                        [bgImageView release];
                                    }
                                }
                            }
                        }
                    }else {
                        int idx = 0;
                        NSString *textStr = [msgData.msgText stringByReplacingOccurrencesOfString:@"￼" withString:@"☼☆☼"];
                        NSArray *stringArray = [textStr componentsSeparatedByString:@"☼"];
                        for (NSString *string in stringArray) {
                            if ([string isEqualToString:@"☆"]) {
                                if (msgData.isAttachments && msgData.attachmentList!= nil && msgData.attachmentList.count > 0) {
                                    NSImage *image = nil;
                                    if (idx < msgData.attachmentList.count) {
                                        IMBSMSAttachmentEntity *attachEntity = [msgData.attachmentList objectAtIndex:idx];
                                        idx += 1;
                                        int i = 0;
                                        NSString *txtString = nil;
                                        for (IMBAttachDetailEntity *detailEntity in attachEntity.attachDetailList) {
                                            if (detailEntity.isPerviewImage == YES) {
                                                image = [detailEntity.thumbImage retain];
                                                break;
                                            }
                                            i++;
                                            if (i == attachEntity.attachDetailList.count) {
                                                image = [detailEntity.thumbImage retain];
                                                if (image == nil) {
                                                    image = [[[NSWorkspace sharedWorkspace] iconForFile:detailEntity.backUpFilePath] retain];
                                                    txtString = detailEntity.fileName;
                                                }
                                            }
                                        }
                                        
                                        if (image != nil) {
                                            float x = 0;
                                            float width = 0;
                                            float oriWidth = (_msgContentScrollView.frame.size.width - 100) / 2;
                                            if (oriWidth > 380) {
                                                oriWidth = 380;
                                            }
                                            if (msgData.isSent == NO) {
                                                x = 50;
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
                                                    x = _msgContentScrollView.frame.size.width - 35 - width;
                                                    _scrollheight = image.size.height * (width / image.size.width);
                                                }else {
                                                    width = image.size.width;
                                                    _scrollheight = image.size.height;
                                                    x = _msgContentScrollView.frame.size.width - 35 - width;
                                                }
                                            }
                                            
                                            NSImageView *imageView = nil;
                                            IMBMessageView *imageMsgView = nil;
                                            
                                            if (i == attachEntity.attachDetailList.count) {
                                                if ([StringHelper stringIsNilOrEmpty:txtString]) {
                                                    imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(8, 8, width, _scrollheight)];
                                                    [imageView setImage:image];
                                                    imageMsgView = [[IMBMessageView alloc] initWithFrame:NSMakeRect(x, _scrollallHeight, imageView.frame.size.width + 16, imageView.frame.size.height + 16)];
                                                }else {
                                                    imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(8, 24, width, _scrollheight)];
                                                    [imageView setImage:image];
                                                    
                                                    NSTextView *textView = [[NSTextView alloc] init];
                                                    [textView setEditable:YES];
                                                    [textView setSelectable:YES];
                                                    [textView setDrawsBackground:NO];
                                                    float x = 0;
                                                    float width_txt = 0;
                                                    NSRect rect = [StringHelper calcuTextBounds:txtString fontSize:12];
                                                    if (msgData.isSent == NO) {
                                                        x = 50;
                                                        if (rect.size.width > (_msgContentScrollView.frame.size.width - 100) / 2) {
                                                            width_txt = (_msgContentScrollView.frame.size.width - 100) / 2;
                                                        }else {
                                                            width_txt = rect.size.width + 10;
                                                        }
                                                    }else {
                                                        if (rect.size.width > (_msgContentScrollView.frame.size.width - 100) / 2) {
                                                            x = _msgContentScrollView.frame.size.width / 2;
                                                            width_txt = (_msgContentScrollView.frame.size.width - 100) / 2;
                                                        }else {
                                                            width_txt = rect.size.width + 10;
                                                            x = _msgContentScrollView.frame.size.width - 50 - width_txt;
                                                        }
                                                    }
                                                    [textView setFrame:NSMakeRect(x, _scrollallHeight, width_txt, 16)];
                                                    _scrollheight = [self setTextViewForString:txtString withTextVeiw:textView withDelete:msgData.isDeleted];
                                                    if (_scrollheight < 17) {
                                                        _scrollheight = 17;
                                                    }
                                                    if (msgData.isDeleted == NO) {
                                                        //                                                    if (msgData.isSent == NO) {
                                                        //                                                        [textView setTextColor:[NSColor colorWithDeviceRed:0.f/255 green:0.f/255 blue:0.f/255 alpha:1.0]];
                                                        //                                                    }else {
                                                        [textView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                                                        //                                                    }
                                                    }
                                                    
                                                    [textView setEditable:NO];
                                                    [textView setSelectable:NO];
                                                    [textView setFrameOrigin:NSMakePoint(8, 4)];
                                                    
                                                    float txtWid = 0;
                                                    if (imageView.frame.size.width > width_txt) {
                                                        txtWid = imageView.frame.size.width;
                                                    }else {
                                                        txtWid = width_txt;
                                                    }
                                                    imageMsgView = [[IMBMessageView alloc] initWithFrame:NSMakeRect(x, _scrollallHeight, txtWid + 16, imageView.frame.size.height + _scrollheight + 16)];
                                                    [imageMsgView addSubview:textView];
                                                    
                                                    if (textView != nil) {
                                                        [textView release];
                                                        textView = nil;
                                                    }
                                                }
                                                
                                                
                                                if ([aentity.handleService isEqualToString:@"iMessage"]) {
                                                    if (msgData.isSent == NO) {
                                                        [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_receive_bgColor", nil)]];
                                                    }
                                                    if (msgData.isSent == YES) {
                                                        [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_send_Message_bgColor", nil)]];
                                                    }
                                                }else if ([aentity.handleService isEqualToString:@"Message"] || [aentity.handleService isEqualToString:@"SMS"]) {
                                                    if (msgData.isSent == NO) {
                                                        [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_receive_bgColor", nil)]];
                                                    }
                                                    if (msgData.isSent == YES) {
                                                        [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_send_iMessage_bgColor", nil)]];
                                                    }
                                                }else {
                                                    if (msgData.isSent == NO) {
                                                        [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_receive_bgColor", nil)]];
                                                    }
                                                    if (msgData.isSent == YES) {
                                                        [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_send_Message_bgColor", nil)]];
                                                    }
                                                }
                                            }else if (i < attachEntity.attachDetailList.count) {
                                                imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, width, _scrollheight)];
                                                [imageView setImage:image];
                                                imageMsgView = [[IMBMessageView alloc] initWithFrame:NSMakeRect(x, _scrollallHeight, imageView.frame.size.width , imageView.frame.size.height)];
                                                [imageMsgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_receive_bgColor", nil)]];
                                            }
                                            
                                            NSImageView *bgImageView = nil;
                                            if (msgData.isSent == NO) {
                                                bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(imageMsgView.frame.origin.x - 11 , imageMsgView.frame.origin.y + imageMsgView.frame.size.height - 15, 20, 18)];
                                                [bgImageView setImage:[StringHelper imageNamed:@"mu_left"]];
                                                
                                                [imageMsgView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                                                
                                                [bgImageView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                                            }else {
                                                [imageMsgView setFrameOrigin:NSMakePoint(imageMsgView.frame.origin.x-24, imageMsgView.frame.origin.y)];
                                                bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(imageMsgView.frame.origin.x + imageMsgView.frame.size.width - 10, imageMsgView.frame.origin.y + imageMsgView.frame.size.height - 15, 20, 18)];
                                                if ([aentity.handleService isEqualToString:@"iMessage"]) {
                                                    [bgImageView setImage:[StringHelper imageNamed:@"mi_right"]];
                                                }else if ([aentity.handleService isEqualToString:@"Message"] || [aentity.handleService isEqualToString:@"SMS"]) {
                                                    [bgImageView setImage:[StringHelper imageNamed:@"bulue_right"]];
                                                }else {
                                                    [bgImageView setImage:[StringHelper imageNamed:@"bulue_right"]];
                                                }
                                                [imageMsgView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                                                [bgImageView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                                            }
                                            
                                            [imageMsgView addSubview:imageView];
                                            if (i == attachEntity.attachDetailList.count ) {
                                                [_msgContentCustomView addSubview:bgImageView];
                                            }
                                            
                                            [_msgContentCustomView addSubview:imageMsgView];
                                            _scrollallHeight += imageMsgView.frame.size.height + 1;
                                            
                                            if (imageMsgView != nil) {
                                                [imageMsgView release];
                                            }
                                            if (imageView != nil) {
                                                [imageView release];
                                            }
                                            if (image != nil) {
                                                [image release];
                                            }
                                            if (bgImageView != nil) {
                                                [bgImageView release];
                                            }
                                        }
                                        
                                    }
                                }
                            }else {
                                if (![StringHelper stringIsNilOrEmpty:string]) {
                                    _scrollheight = 0;
                                    NSTextView *textView = [[NSTextView alloc] init];
                                    [textView setEditable:YES];
                                    [textView setSelectable:YES];
                                    [textView setDrawsBackground:NO];
                                    float x = 0;
                                    float width = 0;
                                    
                                    NSRect rect = [StringHelper calcuTextBounds:string fontSize:12];
                                    if (msgData.isSent == NO) {
                                        x = 50;
                                        if (rect.size.width > (_msgContentCustomView.frame.size.width - 100) / 2) {
                                            width = (_msgContentCustomView.frame.size.width - 100) / 2;
                                        }else {
                                            width = rect.size.width + 10;
                                        }
                                    }else {
                                        if (rect.size.width > (_msgContentCustomView.frame.size.width - 100) / 2) {
                                            x = _msgContentCustomView.frame.size.width / 2;
                                            width = (_msgContentCustomView.frame.size.width - 100) / 2;
                                        }else {
                                            width = rect.size.width + 10;
                                            x = _msgContentCustomView.frame.size.width - 50 - width;
                                        }
                                    }
                                    [textView setFrame:NSMakeRect(x, _scrollallHeight, width, 16)];
                                    _scrollheight = [self setTextViewForString:string withTextVeiw:textView withDelete:msgData.isDeleted];
                                    if (_scrollheight < 17) {
                                        _scrollheight = 17;
                                    }
                                    if (msgData.isDeleted == NO) {
                                        //                                    if (msgData.isSent == NO) {
                                        //                                        [textView setTextColor:[NSColor colorWithDeviceRed:0.f/255 green:0.f/255 blue:0.f/255 alpha:1.0]];
                                        //                                    }else {
//                                        [textView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_message_receiveColor", nil)]];
                                        //                                    }
                                        
                                        if (msgData.isSent == NO) {
                                            [textView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_message_receiveColor", nil)]];
                                        }else {
                                            [textView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_message_sendColor", nil)]];
                                        }
                                    }
                                    [textView setEditable:NO];
                                    [textView setSelectable:NO];
                                    
                                    IMBMessageView *messageView = [[IMBMessageView alloc] initWithFrame:NSMakeRect(x, _scrollallHeight, width + 30, _scrollheight + 30)];
                                    if ([aentity.handleService isEqualToString:@"iMessage"]) {
                                        if (msgData.isSent == NO) {
                                            [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_receive_bgColor", nil)]];
                                        }
                                        if (msgData.isSent == YES) {
                                            [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_send_Message_bgColor", nil)]];
                                        }
                                    }else if ([aentity.handleService isEqualToString:@"Message"] || [aentity.handleService isEqualToString:@"SMS"]) {
                                        if (msgData.isSent == NO) {
                                            [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_receive_bgColor", nil)]];
                                        }
                                        if (msgData.isSent == YES) {
                                            [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_send_iMessage_bgColor", nil)]];
                                        }
                                    }else {
                                        if (msgData.isSent == NO) {
                                            [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_receive_bgColor", nil)]];
                                        }
                                        if (msgData.isSent == YES) {
                                            [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_send_Message_bgColor", nil)]];
                                        }
                                    }
                                    [textView setFrameOrigin:NSMakePoint(18, 18)];
                                    [messageView addSubview:textView];
                                    
                                    NSImageView *bgImageView = nil;
                                    if (msgData.isSent == NO) {
                                        bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(messageView.frame.origin.x - 11, messageView.frame.origin.y + messageView.frame.size.height - 15, 20, 18)];
                                        [bgImageView setImage:[StringHelper imageNamed:@"mu_left"]];
                                        [messageView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                                        [bgImageView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                                        
                                        
                                    }else {
                                        [messageView setFrameOrigin:NSMakePoint(messageView.frame.origin.x-24, messageView.frame.origin.y)];
                                        bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(messageView.frame.origin.x + messageView.frame.size.width - 10, messageView.frame.origin.y + messageView.frame.size.height - 15, 20, 18)];
                                        if ([aentity.handleService isEqualToString:@"iMessage"]) {
                                            [bgImageView setImage:[StringHelper imageNamed:@"mi_right"]];
                                        }else if ([aentity.handleService isEqualToString:@"Message"] || [aentity.handleService isEqualToString:@"SMS"]) {
                                            [bgImageView setImage:[StringHelper imageNamed:@"bulue_right"]];
                                        }else {
                                            [bgImageView setImage:[StringHelper imageNamed:@"bulue_right"]];
                                        }
                                        
                                        
                                        [bgImageView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                                        
                                        [messageView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                                        
                                        
                                    }
                                    
                                    [_msgContentCustomView addSubview:bgImageView];
                                    [_msgContentCustomView addSubview:messageView];
                                    
                                    _scrollallHeight += (_scrollheight + 30 + 1);
                                    
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
                    }
                }else {
                    if (![StringHelper stringIsNilOrEmpty:msgData.msgText]) {
                        _scrollheight = 0;
                        NSTextView *textView = [[NSTextView alloc] init];
                        [textView setEditable:YES];
                        [textView setSelectable:YES];
                        [textView setDrawsBackground:NO];
                        float x = 0;
                        float width = 0;
                        
                        NSRect rect = [StringHelper calcuTextBounds:msgData.msgText fontSize:12];
                        if (msgData.isSent == NO) {
                            x = 50;
                            if (rect.size.width > (_msgContentCustomView.frame.size.width - 100) / 2) {
                                width = (618 - 100) / 2;
                            }else {
                                width = rect.size.width + 10;
                            }
                        }else {
                            if (rect.size.width > (_msgContentCustomView.frame.size.width - 100) / 2) {
                                x = _msgContentCustomView.frame.size.width / 2;
                                width = (_msgContentCustomView.frame.size.width - 100) / 2;
                            }else {
                                width = rect.size.width + 10;
                                x = _msgContentCustomView.frame.size.width - 50 - width;
                            }
                        }
                        [textView setFrame:NSMakeRect(x, _scrollallHeight, width, 16)];
                        _scrollheight = [self setTextViewForString:msgData.msgText withTextVeiw:textView withDelete:msgData.isDeleted];
                        if (_scrollheight < 17) {
                            _scrollheight = 17;
                        }
                        if (msgData.isDeleted == NO) {
                            if (msgData.isSent == NO) {
                                [textView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_message_receiveColor", nil)]];
                            }else {
                                [textView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_message_sendColor", nil)]];
                            }
                        }
                        [textView setEditable:NO];
                        [textView setSelectable:NO];
                        
                        IMBMessageView *messageView = [[IMBMessageView alloc] initWithFrame:NSMakeRect(x, _scrollallHeight, width + 30, _scrollheight + 30)];
                        if ([aentity.handleService isEqualToString:@"iMessage"]) {
                            if (msgData.isSent == NO) {
                                [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_receive_bgColor", nil)]];
                            }
                            if (msgData.isSent == YES) {
                                [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_send_Message_bgColor", nil)]];
                            }
                        }else if ([aentity.handleService isEqualToString:@"Message"] || [aentity.handleService isEqualToString:@"SMS"]) {
                            if (msgData.isSent == NO) {
                                [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_receive_bgColor", nil)]];
                            }
                            if (msgData.isSent == YES) {
                                [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_send_iMessage_bgColor", nil)]];
                            }
                        }else {
                            if (msgData.isSent == NO) {
                                [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_receive_bgColor", nil)]];
                            }
                            if (msgData.isSent == YES) {
                                [messageView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"message_send_iMessage_bgColor", nil)]];
                            }
                        }
                        [textView setFrameOrigin:NSMakePoint(18, 18)];
                        
                        [messageView addSubview:textView];
                        
                        NSImageView *bgImageView = nil;
                        if (msgData.isSent == NO) {
                            bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(messageView.frame.origin.x - 11 , messageView.frame.origin.y + messageView.frame.size.height - 15, 20, 18)];
                            [bgImageView setImage:[StringHelper imageNamed:@"mu_left"]];
                            [messageView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                            [bgImageView setAutoresizingMask: NSViewMaxXMargin|NSViewMaxYMargin];
                            
                        }else {
                            [messageView setFrameOrigin:NSMakePoint(messageView.frame.origin.x-24, messageView.frame.origin.y)];
                            bgImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(messageView.frame.origin.x + messageView.frame.size.width - 10, messageView.frame.origin.y + messageView.frame.size.height - 15, 20, 18)];
                            if ([aentity.handleService isEqualToString:@"iMessage"]) {
                                [bgImageView setImage:[StringHelper imageNamed:@"mi_right"]];
                            }else if ([aentity.handleService isEqualToString:@"Message"] || [aentity.handleService isEqualToString:@"SMS"]) {
                                [bgImageView setImage:[StringHelper imageNamed:@"bulue_right"]];
                            }else {
                                [bgImageView setImage:[StringHelper imageNamed:@"bulue_right"]];
                            }
                            
                            [messageView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                            [bgImageView setAutoresizingMask: NSViewMinXMargin|NSViewMaxYMargin];
                            
                        }
                        
                        [_msgContentCustomView addSubview:bgImageView];
                        [_msgContentCustomView addSubview:messageView];
                        
                        
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
                }
                [viewAry addObject:msgData];
            }
        }
        [entity.msgModelList removeObjectsInArray:viewAry];
        if (viewAry != nil) {
            [viewAry release];
            viewAry = nil;
        }
        if (_scrollallHeight +10< _scrollView.frame.size.height) {
            _scrollallHeight = _scrollView.frame.size.height - 10;
        }
        [_msgContentCustomView setFrameSize:NSMakeSize(_msgContentCustomView.frame.size.width, _scrollallHeight + 10)];
    }
}

-(void)isSelected:(id)sender{
    NSInteger rightCount = 0;
    int leftCount = 0;
    int allCount = 0;
    IMBThreadsEntity *smsData = [_dataSourceArray objectAtIndex:_itemTableView.selectedRow];
    for (IMBADMessageEntity *msgData in smsData.messageList) {
        if ([(IMBCheckBtn*)sender isEqualTo:msgData.checkBtn]) {
            msgData.checkState = !msgData.checkState;
        }
        if (msgData.checkState == Check) {
            rightCount ++;
        }
    }
    if (rightCount == smsData.messageList.count) {
        smsData.checkState = Check;
    }else if (rightCount == 0){
        smsData.checkState = UnChecked;
    }else{
        smsData.checkState = SemiChecked;
    }
    
    for (IMBThreadsEntity *smsData in _dataSourceArray) {
        if (smsData.checkState == Check) {
            leftCount ++;
            allCount += smsData.messageCount;
        }else if (smsData.checkState == SemiChecked) {
            for (IMBADMessageEntity *msgData in smsData.messageList) {
                if (msgData.checkState == Check) {
                    allCount ++;
                }
            }
        }
    }
    
    //    if (leftCount == _dataSourceArray.count) {
    //        [(IMBScanDeviceViewController *)_delegate checkBoxState:Check WithScanTypeEnum:ScanMessageFile withSelectCount:(int)allCount];
    //    }else if (leftCount == 0 && allCount == 0){
    //        [(IMBScanDeviceViewController *)_delegate checkBoxState:UnChecked WithScanTypeEnum:ScanMessageFile withSelectCount:(int)allCount];
    //    }else{
    //        [(IMBScanDeviceViewController *)_delegate checkBoxState:SemiChecked WithScanTypeEnum:ScanMessageFile withSelectCount:(int)allCount];
    //    }
    [_itemTableView reloadData];
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:allCount] forKey:[NSNumber numberWithInt:_resultEntity.scanType]];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:SCAN_COUNT_TAG object:dic userInfo:nil];
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
    
    //[NSColor colorWithDeviceRed:87.f/255 green:87.f/255 blue:87.f/255 alpha:1.0],NSForegroundColorAttributeName,
    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
    //    [textContainer setLineFragmentPadding:0.0]; 10/23
    [drawStr addAttributes:fontDic range:NSMakeRange(0, textStorage.length)];
    //    (void) [layoutManager glyphRangeForTextContainer:textContainer]; 10/23
    //    float changeHeight = [layoutManager usedRectForTextContainer:textContainer].size.height;  10/23
    
    //[textView setFrameOrigin:NSMakePoint(textView.frame.origin.x, textView.frame.origin.y - changeHeight + 14)];
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

- (void)setDeviceHomeiMessageTextString:(NSString *)textString withFolat:(float)height {
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
 
    [homeText setFrame:NSMakeRect((_msgContentCustomView.frame.size.width - 510) / 2, height, 400, 18)];
    [homeText setAlignment:NSLeftTextAlignment];
    //    [homeText sizeToFit];
    [homeText setEditable:NO];
    [homeText setAutoresizingMask: NSViewMinXMargin|NSViewMaxXMargin|NSViewWidthSizable];
    [_msgContentCustomView addSubview:homeText];
    [homeText release];
}

- (void)setHomeiMessageTextString:(NSString *)textString withFolat:(float)height {
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
    [homeText setAlignment:NSLeftTextAlignment];
    //    [homeText sizeToFit];
    [homeText setEditable:NO];
    [homeText setAutoresizingMask: NSViewMinXMargin|NSViewMaxXMargin|NSViewWidthSizable];
    [_msgContentCustomView addSubview:homeText];
    [homeText release];
}

-(void)changeTableView:(NSInteger)row{
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
            _smsSonData = [disAry objectAtIndex:row];
            NSView *doView = (NSView *)_msgContentScrollView.documentView;
            [_msgContentScrollView.documentView setFrame:NSMakeRect(doView.frame.origin.x, doView.frame.origin.y, doView.frame.size.width, _msgContentScrollView.frame.size.height)];
            [entity.msgModelList removeAllObjects];
            [entity.msgModelList addObjectsFromArray:_smsSonData.msgModelList];
            [self showSingleMessageContent:_smsSonData];
        }
    }
}

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
        str = @"contactName";
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
        str = @"lastMsgTimeWithSecond";
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
            str = @"contactName";
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:str ascending:_isAscending selector:@selector(localizedStandardCompare:)];
            str1 = CustomLocalizedString(@"SortBy_Name", nil);
        }else {
            for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
                if (menuItem.tag == 2) {
                    [menuItem setState:NSOnState];
                }
            }
            NSString *str = @"";
            str = @"lastMsgTimeWithSecond";
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
            str = @"contactName";
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:str ascending:_isAscending selector:@selector(localizedStandardCompare:)];
            str1 = CustomLocalizedString(@"SortBy_Name", nil);
        }else {
            for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
                if (menuItem.tag == 2) {
                    [menuItem setState:NSOnState];
                }
            }
            NSString *str = @"";
            str = @"lastMsgTimeWithSecond";
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

- (void)reload:(id)sender {
    [self refreshBackup:NO];
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _isSearch = YES;
    _searchFieldBtn = searchBtn;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contactName CONTAINS[cd] %@ ",searchStr];
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
        //        [entity.msgModelList addObjectsFromArray:_smsSonData.msgModelList];
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
        NSInteger row = [_itemTableView selectedRow];
        if (_dataSourceArray.count > 0 && row >= 0 && row < _dataSourceArray.count ) {
            [self changeTableView:row];
        }else if(_dataSourceArray.count > 0) {
            [self changeTableView:0];
        }
    }
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    
    int checkCount = 0;
    for (int i=0; i<[disAry count]; i++) {
        IMBSMSChatDataEntity *noteMode = [disAry objectAtIndex:i];
        if (noteMode.checkState == NSOnState) {
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

- (void)configRefreshView {
    //检测是否备份
    
    NSString *textString = nil;
    NSString *btnString = nil;
    if (_dataSourceArray.count > 0 || _information.safariManager.lastBackupScoend != 0) {
        textString =  [NSString stringWithFormat:CustomLocalizedString(@"NoticeBackup_id_1", nil),[DateHelper dateFrom1970ToString:_information.safariManager.lastBackupScoend withMode:2]];
        btnString = CustomLocalizedString(@"Common_id_1", nil);
    }else
    {
        textString = CustomLocalizedString(@"Backup_id_2", nil);
        btnString = CustomLocalizedString(@"Backup_id_3", nil);
    }
    
    NSRect btnRect = [StringHelper calcuTextBounds:btnString fontSize:14];
    NSRect textRect = [StringHelper calcuTextBounds:textString fontSize:14];
    
    [_refreshView initWithLuCorner:YES LbCorner:NO RuCorner:YES RbConer:NO CornerRadius:5];
    [(IMBLackCornerView *)_refreshView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"refreshView_bgColor", nil)]];
    _refreshTitle = [[NSTextField alloc] init];
    [_refreshTitle setSelectable:NO];
    [_refreshTitle setFrame:NSMakeRect(30, 2, textRect.size.width + 20, 24)];
    [_refreshTitle setFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_refreshTitle setBordered:NO];
    [_refreshTitle setFocusRingType:NSFocusRingTypeNone];
    [_refreshTitle setDrawsBackground:NO];
    [_refreshTitle setAlignment:NSCenterTextAlignment];
    [_refreshTitle setStringValue:textString];
    [_refreshTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"refreshView_titleColor", nil)]];
    if (_dataSourceArray.count == 0) {
        [_refreshView setFrame:NSMakeRect(((self.view.bounds.size.width) - (textRect.size.width + btnRect.size.width + 100))/2, 0, (textRect.size.width + btnRect.size.width + 100), 30)];
    }else {
        [_refreshView setFrame:NSMakeRect(((_msgContentScrollView.bounds.size.width) - (textRect.size.width + btnRect.size.width + 100))/2 + _msgContentScrollView.frame.origin.x, 0, (textRect.size.width + btnRect.size.width + 100), 30)];
    }
    
    [_refreshView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewNotSizable];
    for (NSView *view in _refreshView.subviews) {
        if ([view isKindOfClass:[NSTextField class]]) {
            [view removeFromSuperview];
            break;
        }
    }
    [_refreshView addSubview:_refreshTitle];
    [_refreshTitle release];
    [self.view addSubview:_refreshView];
    for (NSView *view in _refreshView.subviews) {
        if ([view isKindOfClass:[IMBRefreshButton class]]) {
            [view removeFromSuperview];
            break;
        }
    }
    if (_refreshBtn != nil) {
        [_refreshBtn release];
        _refreshBtn = nil;
    }
    _refreshBtn = [[IMBRefreshButton alloc] initWithFrame:NSMakeRect(_refreshTitle.frame.size.width + 40, _refreshTitle.frame.origin.y + 4 , btnRect.size.width + 6, btnRect.size.height) withName:btnString];
    [_refreshBtn setTarget:self];
    [_refreshBtn setAction:@selector(doRefreshView:)];
    [_refreshView addSubview:_refreshBtn];
    [_refreshView setNeedsDisplay:YES];
    
}

- (void)doRefreshView:(id)sender {
    if ([self checkBackupEncrypt]) {//设备备份在iTunes上设置的是加密的
        [self showAlertText:CustomLocalizedString(@"backup_id_text_10", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    if (_backupAnimationVC) {
        [_backupAnimationVC release];
        _backupAnimationVC = nil;
    }
    _backupAnimationVC = [[IMBBackupAnimationViewController alloc]initWithNibName:@"IMBBackupAnimationViewController" bundle:nil Withipod:_ipod withViewTag:2];
    [_loadingBox setContentView:nil];
    [_loadingBox setContentView:_backupAnimationVC.view];
    [self animationAddTransferView:_backupAnimationVC.view];
    [_backupAnimationVC startBackupDevice];
}

- (void)refreshBackup:(BOOL)refresh {
    if ([self checkBackupEncrypt]) {
        [self showAlertText:CustomLocalizedString(@"backup_id_text_10", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    [self disableFunctionBtn:NO];
    [_backupAnimationVC.view removeFromSuperview];
    [_loadingBox setContentView:_loadingView];
    [_loadingAnmationView startAnimation];
    
    //开启线程加载数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            [_information.messageManager setIsRefresh:refresh];
            [_information loadMessage:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self disableFunctionBtn:YES];
                if (_dataSourceArray != nil) {
                    [_dataSourceArray release];
                    _dataSourceArray = nil;
                }
                _dataSourceArray = [_information.messageArray retain];
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
                    int count = 0;
                    for (IMBSMSChatDataEntity *countEntity in _dataSourceArray) {
                        count += countEntity.msgModelList.count;
                    }
                    [_delegate refeashBadgeConut:count WithCategory:_category];
                }
                [_loadingAnmationView endAnimation];
                [_itemTableView reloadData];
            });
        }
    });
}

- (void)hideRefreshView {
    [_refreshView setHidden:YES];
}

- (void)animationAddTransferView:(NSView *)view {
    //    [view setFrame:NSMakeRect(0, 0, [self view].frame.size.width, [self view].frame.size.height)];
    //    [[self view] addSubview:view];
    [view setFrame:NSMakeRect(0, 0, [(IMBDeviceMainPageViewController *)_delegate view].frame.size.width, [(IMBDeviceMainPageViewController *)_delegate view].frame.size.height)];
    [[(IMBDeviceMainPageViewController *)_delegate view] addSubview:view];
    
    [view setWantsLayer:YES];
    [view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
}

- (void)backupCompleteReload:(NSNotification *)notification {
    int i  =  [notification.object intValue];
    if (i == 2) {
        [self reload:nil];
    }
    [_refreshView setHidden:YES];
    [nc postNotificationName:NOTITY_HIDE_REFRESHVIEW object:nil];
}

- (void)backupErrorReload:(NSNotification *)notification {
    int i  =  [notification.object intValue];
    if (i == 2) {
        [_loadingBox setContentView:nil];
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
    }
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

@end
