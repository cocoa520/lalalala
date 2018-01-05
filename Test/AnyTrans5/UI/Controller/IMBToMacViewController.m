//
//  IMBToMacViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-16.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBToMacViewController.h"
//#import "IMBColorDefine.h"
#import "HoverButton.h"
#import "IMBAnimation.h"
#import "IMBDeviceMainPageViewController.h"
#import "TempHelper.h"
#import "IMBAllFileExport.h"
#import "IMBCategoryInfoModel.h"
#import "IMBTransferToiTunes.h"
#import "IMBNotificationDefine.h"
#import "SystemHelper.h"

@interface IMBToMacViewController ()

@end

@implementation IMBToMacViewController
@synthesize bindcategoryArray = _bindcategoryArray;
@synthesize icloudManager = _icloudManager;
- (id)initWithiPod:(IMBiPod *)iPod CategoryInfoModelArrary:(NSMutableArray *)categoryArray isToMac:(BOOL)isToMac WithIsiCoudView:(BOOL)isiCloudView
{
    if (self = [super initWithNibName:@"IMBToMacViewController" bundle:nil]) {
        _bindcategoryArray = [[NSMutableArray alloc] initWithArray:categoryArray];
        _ipod = [iPod retain];
        _isToMac = isToMac;
        _isiCloudView = isiCloudView;
    }
    return self;
}

- (IBAction)selectFolder:(id)sender {
    _openPanel = [NSOpenPanel openPanel];
    _isOpen = YES;
    [_openPanel setAllowsMultipleSelection:NO];
    [_openPanel setCanChooseFiles:NO];
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result== NSFileHandlingPanelOKButton) {
            NSURL *url = [_openPanel URL];
            NSString *path = [url path];
            [_pathTextField setStringValue:path];
            [_pathTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            [_ipod.exportSetting setExportPath:path];
            [_ipod.exportSetting saveToDeviceOrLocal];
        }
        _isOpen = NO;
    }];

}

- (IBAction)clickCheckBox:(id)sender {
    NSButton *button = (NSButton *)sender;
    NSView *superView = [sender superview];
    for (NSView *selView in superView.subviews) {
        if ([selView isKindOfClass:[NSTextField class]]) {
            NSTextField *field = (NSTextField *)selView;
            for (IMBCategoryInfoModel *model in _arrayController.content) {
                if ([field.stringValue isEqualToString:model.categoryName]) {
                    model.isSelected = button.state;
                    break;
                }
            }
        }
    }
    
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[_arrayController.content count];i++) {
        IMBCategoryInfoModel *model = [_arrayController.content objectAtIndex:i];
        if (model.isSelected) {
            [set addIndex:i];
        }
    }
    [_connectionView setSelectionIndexes:set];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [((IMBBackgroundBorderView *)self.view) setIsGradientNoCornerPart4:YES];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"roseSkin"]) {
        [_bellImgView setHidden:YES];
        [_roseProgressBgImageView setHidden:NO];
        [_roseProgressBgImageView setImage:[StringHelper imageNamed:@"rose_progress_bg"]];
    }else if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
        [_bellImgView setHidden:NO];
        [_bellImgView setImage:[StringHelper imageNamed:@"christmas_bell"]];
        [_bellImgView setFrameOrigin:NSMakePoint(340, _bellImgView.frame.origin.y)];
        [_roseProgressBgImageView setHidden:YES];
        [_progressviewBar setDelegate:self];
    }else {
        [_bellImgView setHidden:YES];
        [_roseProgressBgImageView setHidden:YES];
    }
    //TODO:屏蔽语言选择-----long
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:NO]];
    NSString *str = @"close";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    _isTransferComplete = YES;
    _textView.delegate = self;
    if (_icloudManager != nil) {
        [_pathTextField setStringValue:[SystemHelper userDocumentPath]];
    }else{
        [_pathTextField setStringValue:_ipod.exportSetting.exportPath];
    }
    [_pathTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_connectionView setMaxNumberOfColumns:5];
    [_connectionView setMaxNumberOfRows:20];
    [_contentBox setWantsLayer:YES];

//    [((IMBBackgroundBorderView *)self.view) setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];

    [((IMBBackgroundBorderView *)self.view) setCanScroll:NO];
    [((IMBBackgroundBorderView *)self.view) setCanClick:NO];
    [_titleView setHasBottomBorder:YES];
    [_titleView setBottomBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    _closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil((NSHeight(_titleView.frame) - 32)/2), 32, 32)];
    [_closebutton setTarget:self];
    [_closebutton setAction:@selector(closeWindow:)];
    [_closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_titleView addSubview:_closebutton];
    
    
    [_nextbackBgView setWantsLayer:YES];
    _nextbackBgView.layer.frame = NSRectToCGRect(_nextbackBgView.frame);
    HoverButton *nextbutton = [[HoverButton alloc] initWithFrame:NSMakeRect(NSWidth(_nextbackBgView.frame) - 56 -15, ceil((NSHeight(_nextbackBgView.frame) - 56)/2), 56, 56)];
    nextbutton.tag = 120;
    [nextbutton setWantsLayer:YES];
    [nextbutton.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    nextbutton.layer.frame = NSRectToCGRect(nextbutton.frame);
    [nextbutton setAutoresizesSubviews:YES];
    [nextbutton setAutoresizingMask:NSViewMinXMargin|NSViewMinYMargin|NSViewMaxYMargin];
    [nextbutton setTarget:self];
    [nextbutton setAction:@selector(next:)];
    [nextbutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_next_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_next_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_next_down"]];
    [_nextbackBgView addSubview:nextbutton];
    [_nextbackBgView.layer addSublayer:nextbutton.layer];
    CABasicAnimation *animation = [IMBAnimation moveX:2.0 X:@(-15)];
    [nextbutton.layer addAnimation:animation forKey:@"comeback"];
    [_contentBox setContentView:_categorySelectView];
    [nextbutton release];
    [_connectionBgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_connectionBgView setBorderColor:[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)]];
    [_connectionBgView setHasStrokeRadius:YES];
    [_connectionBgView setXRadius:5.0 YRadius:5.0];
    [_connectionView selectAll:nil];
//    [_connectionView setBackgroundColors:@[[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)],[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]]];
    [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"ToPCiTunes_Step_Id_1", nil)]];
    NSString *promptStr = nil;
    if (_isToMac) {
        NSString *title = CustomLocalizedString(@"Button_Select", nil);
        NSRect rect = [TempHelper calcuTextBounds:title fontSize:14];
        int w = 60;
        if (rect.size.width + 20 > 60) {
            w = rect.size.width + 20;
        }
        [_selectPathButton setFrameSize:NSMakeSize(w, _selectPathButton.frame.size.height)];
        
        [_selectPathButton setLeftImage:[StringHelper imageNamed:@"select_path_left1"]];
        [_selectPathButton setLeftEnterImage:[StringHelper imageNamed:@"select_path_left2"]];
        [_selectPathButton setLeftDownImage:[StringHelper imageNamed:@"select_path_left3"]];
        [_selectPathButton setMiddleImage:[StringHelper imageNamed:@"select_path_mid1"]];
        [_selectPathButton setMiddleEnterImage:[StringHelper imageNamed:@"select_path_mid2"]];
        [_selectPathButton setMiddleDownImage:[StringHelper imageNamed:@"select_path_mid3"]];
        [_selectPathButton setRightImage:[StringHelper imageNamed:@"select_path_right1"]];
        [_selectPathButton setRightEnterImage:[StringHelper imageNamed:@"select_path_right2"]];
        [_selectPathButton setRightDownImage:[StringHelper imageNamed:@"select_path_right3"]];
        [_selectPathButton setTitle:title];
        [_cusShapeView setLeftImage:[StringHelper imageNamed:@"path_field_left1"] midImage:[StringHelper imageNamed:@"path_field_mid1"] rightImage:nil];

        [_exportLabel setStringValue:CustomLocalizedString(@"SettingView_id_9", nil)];
        [_exportLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [_categorySelectTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"MergeDevice_SelectDeviceItem_Title", nil),@"Mac"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"ToPCiTunes_SelectDeviceItem_Descript", nil),CustomLocalizedString(@"ToTransfer_Descript_TOPC", nil)];
    }else{
        [_pathBGView setHidden:YES];
        [_categorySelectTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"MergeDevice_SelectDeviceItem_Title", nil),@"iTunes"]];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"ToPCiTunes_SelectDeviceItem_Descript", nil),CustomLocalizedString(@"ToTransfer_Descript_TOiTunes", nil)];
    }
    [_categorySelectTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [_categorySelectsubTitleField setAttributedStringValue:promptAs];
    [mutParaStyle release];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeOpenPanel:) name:DeviceDisConnectedNotification object:nil];
    
}

#pragma mark - method
- (void)setSelectedNavStr:(NSString *)str
{
    NSString *navStr = [NSString stringWithFormat:@"%@ > %@ > %@",CustomLocalizedString(@"ToPCiTunes_Step_Id_1", nil),CustomLocalizedString(@"ToPCiTunes_Step_Id_2", nil),CustomLocalizedString(@"ToPCiTunes_Step_Id_3", nil)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:navStr];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setAlignment:NSCenterTextAlignment];
    [text addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:14.0],NSFontAttributeName,[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)],NSForegroundColorAttributeName, nil] range:NSMakeRange(0, text.length)];
    NSRange range = [text.string rangeOfString:str];
    [text addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, range.location+range.length)];
    [_navigationField setAttributedStringValue:text];
    [text release];
    
}
- (NSImage *)getipodImage:(IMBiPod *)ipod
{
    NSImage *image = [StringHelper imageNamed:@"clone_iPhone"];
    if (ipod.deviceInfo.isiPhone) {
        if (ipod.deviceInfo.family == iPhone_X) {
            image = [StringHelper imageNamed:@"clone_iPhonex"];
        }else{
            image = [StringHelper imageNamed:@"clone_iPhone"];
        }
    }else if (ipod.deviceInfo.isiPad){
        image = [StringHelper imageNamed:@"clone_iPad"];
    }else if (ipod.deviceInfo.isiPod){
        image = [StringHelper imageNamed:@"clone_iPodTouch"];
    }
    return image;
}

#pragma mark - Actions
- (void)next:(id)sender
{
    if ([[_connectionView selectionIndexes] count] == 0) {
        //需要提示 选择为空
        [self showAlertText:CustomLocalizedString(@"MSG_COM_No_Item_Selected", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    _isNextBtnDown = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:NO]];
//    [_closebutton setEnabled:NO];
    _isTransferComplete = NO;
    [self configTitle];
    [_progressviewBar setLoadAnimation];
    
    NSButton *nextbutton = [_nextbackBgView viewWithTag:120];
    [nextbutton setHidden:YES];
    [_transferView setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"push";
    transition.subtype = @"fromRight";
    [_contentBox.layer addAnimation:transition forKey:@"animation"];
    [_contentBox setContentView:_transferView];
    [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"ToPCiTunes_Step_Id_2", nil)]];
    [_completeBGImageView setImage:[StringHelper imageNamed:@"clone_complete"]];
    if (_isToMac) {
        if (_icloudManager != nil) {
            OperationLImitation *oeprtionlimit = [OperationLImitation singleton];
            [oeprtionlimit setNeedlimit:NO];
            if (![IMBSoftWareInfo singleton].isRegistered) {
//                _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
                _alertViewController.isIcloudOneOpen = YES;
            }
            NSImage *compeleteImage = [StringHelper imageNamed:@"transfer_to_macbook"];
            [_toMacAnimationView setSourceImage:[StringHelper imageNamed:@"iCloud_transfer"] targetImage:compeleteImage];
            [_toMacAnimationView resetDataLayer];
            [_completeImageView setFrame:NSMakeRect(ceilf((NSWidth(_completeView.frame) - compeleteImage.size.width)/2),_completeImageView.frame.origin.y , compeleteImage.size.width, compeleteImage.size.height)];
            [_completeImageView setImage:compeleteImage];
            [_completeImageView setFrameOrigin:NSMakePoint(NSMinX(_completeImageView.frame), NSMinY(_completeImageView.frame) - 32)];
        }else{
            NSImage *compeleteImage = [StringHelper imageNamed:@"transfer_to_macbook"];
            [_toMacAnimationView setSourceImage:[self getipodImage:_ipod] targetImage:compeleteImage];
            [_completeImageView setFrame:NSMakeRect(ceilf((NSWidth(_completeView.frame) - compeleteImage.size.width)/2),_completeImageView.frame.origin.y , compeleteImage.size.width, compeleteImage.size.height)];
            [_completeImageView setImage:compeleteImage];
        }
    }else{
        NSImage *compeleteImage = [StringHelper imageNamed:@"transfer_to_iTunes"];
        [_toMacAnimationView setFrame:NSMakeRect(ceilf((1060 - 400)/2),_toMacAnimationView.frame.origin.y, 400, NSHeight(_toMacAnimationView.frame))];
        [_toMacAnimationView setSourceImage:[self getipodImage:_ipod] targetImage:compeleteImage];
        [_completeImageView setFrame:NSMakeRect(ceilf((NSWidth(_completeView.frame) - compeleteImage.size.width)/2),_completeImageView.frame.origin.y , compeleteImage.size.width, compeleteImage.size.height)];
        [_completeImageView setImage:compeleteImage];

    }
    [_toMacAnimationView startAnimation];
    
    if (_exportArray != nil) {
        [_exportArray release];
        _exportArray = nil;
    }
    _exportArray = [[_arrayController selectedObjects] retain];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    if (_isToMac) {
        _exportFolder = [[TempHelper createExportPath:[_pathTextField stringValue]]retain];
        _baseTransfer = [[IMBAllFileExport alloc] initWithIPodkey:_ipod.uniqueKey exportTracks:_exportArray exportFolder:_exportFolder withDelegate:self];
        ((IMBAllFileExport *)_baseTransfer).icloudManager = _icloudManager;
        if (_icloudManager != nil) {
            //            NSMutableString *mutStr = [[NSMutableString alloc] init];
            for (IMBCategoryInfoModel *entity in _exportArray) {
                //                [mutStr appendString:[NSString stringWithFormat:@"%@, ", entity.categoryName]];
                [ATTracker event:iCloud_Content action:iCloud_Export actionParams:entity.categoryName label:LabelNone transferCount:0 screenView:@"iCloud Export View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }
        }else{
            [ATTracker event:Content_To_Computer action:ContentToMac actionParams:@"Content" label:Start transferCount:0 screenView:@"Content" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
    }else {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (_exportArray != nil) {
            for (IMBCategoryInfoModel *model in _exportArray) {
                [dic setObject:@"anytrans5" forKey:[NSNumber numberWithInt:model.categoryNodes]];
            }
        }
        [ATTracker event:Content_To_iTunes action:ToiTunes actionParams:@"Conent" label:Start transferCount:0 screenView:@"Conent" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        _baseTransfer = [[IMBTransferToiTunes alloc] initWithIPodkey:_ipod.uniqueKey exportDic:dic withDelegate:self];
        [_baseTransfer setIsAllExport:YES];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [self performSelector:@selector(startTransfer) withObject:nil afterDelay:0.5];
}

- (void)startTransfer {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_baseTransfer startTransfer];
    });
}

- (void)configTitle {
    [_noteImageView setImage:[StringHelper imageNamed:@"transfer_note"]];
    if (_isToMac) {
        [_transferTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"ToPCiTunes_Transfer_Title", nil),CustomLocalizedString(@"ToTransfer_Title_TOPC", nil)]];
    }else {
        [_transferTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"ToPCiTunes_Transfer_Title", nil),CustomLocalizedString(@"ToTransfer_Title_TOiTunes", nil)]];
    }
    [_transferTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_transferPromptLabel setStringValue:CustomLocalizedString(@"ImportSync_id_20", nil)];
    [_transferPromptLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_fileNameField setStringValue:@""];
    NSString *str = nil;
    if (_icloudManager) {
        str = CustomLocalizedString(@"icloud_TransferDevice_Message_Caution", nil);
    }else {
        str = CustomLocalizedString(@"TransferDevice_Message_Caution", nil);
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init] ;
    [style setAlignment:NSLeftTextAlignment];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:12],NSFontNameAttribute,style,NSParagraphStyleAttributeName, nil];
    NSSize size = [str sizeWithAttributes:dic];
    [_noteImageView setFrameOrigin:NSMakePoint((1060- (22+ size.width))/2.0 + 8, _noteImageView.frame.origin.y)];
    
    [_warningTipField setFrameOrigin:NSMakePoint((1060- (22+ size.width))/2.0 + 30, _warningTipField.frame.origin.y)];
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc] initWithString:str];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_warningColor", nil)] range:NSMakeRange(0, as2.length)];
    [as2 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as2.length)];
    
    [_warningTipField setAttributedStringValue:as2];
    [as2 release], as2 = nil;
    [style release], style = nil;
}

- (IBAction)closeWindow:(id)sender {
   
    if (_annoyTimer != nil) {
        [_annoyTimer invalidate];
        _annoyTimer = nil;
    }

    if (!_isTransferComplete) {
        if (!_isNextBtnDown) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
            _isNextBtnDown = NO;
        }
        if (_baseTransfer != nil) {
            [_baseTransfer pauseScan];
        }
        [_alertViewController setIsStopPan:YES];
        int result = [self showAlertText:CustomLocalizedString(@"Main_Window_Stop_Tips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)];
        [_alertViewController setIsStopPan:NO];
        if (result) {
            OperationLImitation *oeprtionlimit = [OperationLImitation singleton];
            [oeprtionlimit setNeedlimit:YES];
            if (_baseTransfer != nil) {
                [_closebutton setEnabled:NO];
                [_baseTransfer stopScan];
                [_baseTransfer resumeScan];
                [_transferPromptLabel setStringValue:CustomLocalizedString(@"ImportSync_id_5", nil)];
                [_transferPromptLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            }
        }else {
            if (_baseTransfer != nil) {
                [_baseTransfer resumeScan];
            }
        }
    }else {
        [[IMBTransferError singleton] removeAllError];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
        [self animationRemoveToMacView];
    }
}

- (void)animationRemoveToMacView {
    //放开语言设置按钮-----long
    NSString *str = @"open";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    
    NSMenu *menu = self.view.window.menu;
    NSMenuItem *item = [menu itemWithTag:205];
    [item setEnabled:YES];
    [_contentBox setAutoresizingMask:NSViewMinYMargin];
    [_nextbackBgView setAutoresizingMask:NSViewMinYMargin];
    [self.view setFrame: NSMakeRect(0, -20, NSWidth(self.view.frame), NSHeight(self.view.frame)+20)];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:@(0) Y:@(20) repeatCount:1];
        anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.view.layer addAnimation:anima1 forKey:@"moveY"];
    } completionHandler:^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:@(20) Y:@(-NSHeight(self.view.frame)) repeatCount:1];
            anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [self.view.layer addAnimation:anima1 forKey:@"moveY"];
            if (_delegate && [_delegate respondsToSelector:@selector(setTrackingAreaEnable:)]) {
                [_delegate setTrackingAreaEnable:YES];
            }
        } completionHandler:^{
            [self.view removeFromSuperview];
            [self release];
        }];
    }];
    //to do 需要结束正在传输的进程
    [_toMacAnimationView stopAnimation];
}

//传输准备进度开始
- (void)transferPrepareFileStart:(NSString *)file {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMenu *menu = self.view.window.menu;
        NSMenuItem *item = [menu itemWithTag:205];
        [item setEnabled:NO];
        if (![TempHelper stringIsNilOrEmpty:file]) {
            [_transferPromptLabel setStringValue:file];
            [_transferPromptLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
//            NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:file];
//            [as addAttribute:NSForegroundColorAttributeName value:IMBTextButton_Normal_Border range:NSMakeRange(0, as.length)];
//            [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
//            [_backUpProgressLable setAttributedStringValue:as];
//            [as release], as = nil;
        }
    });
}
//传输准备进度结束
- (void)transferPrepareFileEnd {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_progressviewBar removeAnimationImgView];
        [_progressviewBar startAnimation];
    });
}
//传输进度
- (void)transferProgress:(float)progress {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_progressviewBar setProgress:progress];
    });
}

//当前传输文件的名字或者路径
- (void)transferFile:(NSString *)file {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![TempHelper stringIsNilOrEmpty:file]) {
            NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:file];
            [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.length)];
            [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
            [_fileNameField setAttributedStringValue:as];
            [as release], as = nil;
        }
    });
}
//分析进度
- (void)parseProgress:(float)progress {
    
}
//当前分析文件的名字或者路径
- (void)parseFile:(NSString *)file {
    
}

//全部传输成功
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount {
    _successCount = successCount;
    _totalCount = totalCount;
    OperationLImitation *oeprtionlimit = [OperationLImitation singleton];
    [oeprtionlimit setNeedlimit:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_annoyTimer != nil) {
            [_annoyTimer invalidate];
            _annoyTimer = nil;
        }
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
        if (!_isToMac) {
            if (successCount > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LOAD_ITUNES_DATA object:nil];
            }
        }
        _isTransferComplete = YES;
        [_closebutton setEnabled:YES];
        
        [_progressviewBar stopAnimation];
        [_toMacAnimationView stopAnimation];
        CATransition *transition = [CATransition animation];
        transition.delegate = self;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"fade";
        [_contentBox.layer addAnimation:transition forKey:@"animation"];
        
        if (![IMBSoftWareInfo singleton].isRegistered && _isiCloudView && ![IMBSoftWareInfo singleton].isNOAdvertisement) {
            [self setSelectedNavStr:CustomLocalizedString(@"ToPCiTunes_Step_Id_3", nil)];
            if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
                    [self configEniCloudCompleteView];
                    [_contentBox setContentView:_resultView];
                } else {
                    [self configMuiCloudCompleteView];
                    [_contentBox setContentView:_muicloudCompleteView];
                }
            
        } else {
            [_contentBox setContentView:_completeView];
            [self setSelectedNavStr:CustomLocalizedString(@"ToPCiTunes_Step_Id_3", nil)];
            [_completetitleField setStringValue:CustomLocalizedString(@"Transfer_text_id_4", nil)];
            [_completetitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            NSString *str = nil;
            NSString *transferCountStr = nil;
            if (successCount> 1) {
                transferCountStr = [NSString stringWithFormat:@"%d/%d",successCount,totalCount];
                str = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_text_complete_tips", nil),transferCountStr];
            }else {
                transferCountStr = [NSString stringWithFormat:@"%d/%d",successCount,totalCount];
                str = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_text_complete_tip", nil),transferCountStr];
            }
            NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:str];
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:NSMakeRange(0, as.length)];
            [as addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:NSMakeRange(0, as.length)];
            [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.length)];
            [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
            [[_completeSubTitleField textStorage] setAttributedString:as];
            [as release], as = nil;
            
            
            if (_successCount < totalCount && [IMBTransferError singleton].errorArrayM.count > 0) {
                
                NSString *promptStr = @"";
                NSString *overStr1 = @"";
                NSString *overStr2 = @"";
                NSString *overStr3 = @"";
                if (!_isToMac) {
                    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_text_complete_viewfile", nil), CustomLocalizedString(@"Show_ResultWindow_linkTips", nil),CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil)];
                    overStr1 = CustomLocalizedString(@"Show_ResultWindow_linkTips", nil);
                    overStr2 = CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil);
                } else {
                    promptStr = [[[[[[[[CustomLocalizedString(@"Transfer_text_complete_viewfile_1", nil) stringByAppendingString:CustomLocalizedString(@"  ", nil)] stringByAppendingString:CustomLocalizedString(@"|", nil)] stringByAppendingString:CustomLocalizedString(@"  ", nil)] stringByAppendingString:CustomLocalizedString(@"Show_Transfer_text_complete_viewfile_2", nil)] stringByAppendingString:CustomLocalizedString(@"  ", nil)] stringByAppendingString:CustomLocalizedString(@"|", nil)] stringByAppendingString:CustomLocalizedString(@"  ", nil)] stringByAppendingString:CustomLocalizedString(@"Show_ResultWindow_linkTips", nil)];
                    overStr1 = CustomLocalizedString(@"Transfer_text_complete_viewfile_1", nil);
                    overStr2 = CustomLocalizedString(@"Show_Transfer_text_complete_viewfile_2", nil);
                    overStr3 = CustomLocalizedString(@"Show_ResultWindow_linkTips", nil);
                }
                
                NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
                [_textView setLinkTextAttributes:linkAttributes];
                
                NSMutableAttributedString *promptAs = [[NSMutableAttributedString alloc] initWithString:promptStr?:@""];
                [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, promptAs.length)];
                [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
                
                
                NSRange infoRange1 = [promptStr rangeOfString:overStr1];
                [promptAs addAttribute:NSLinkAttributeName value:overStr1 range:infoRange1];
                [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange1];
                [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange1];
                [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange1];
                
                
                NSRange infoRange2 = [promptStr rangeOfString:overStr2];
                [promptAs addAttribute:NSLinkAttributeName value:overStr2 range:infoRange2];
                [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange2];
                [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange2];
                [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange2];
                
                NSRange infoRange3 = [promptStr rangeOfString:overStr3];
                [promptAs addAttribute:NSLinkAttributeName value:overStr3 range:infoRange3];
                [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange3];
                [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange3];
                [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange3];
                
                NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
                [mutParaStyle setAlignment:NSCenterTextAlignment];
                [mutParaStyle setLineSpacing:5.0];
                [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
                [[_textView textStorage] setAttributedString:promptAs];
                [promptAs release], promptAs =nil;
                [mutParaStyle release];
                mutParaStyle = nil;
                
            } else {
                
                NSString *promptStr = @"";
                NSString *overStr1 = @"";
                NSString *overStr2 = @"";
                if (!_isToMac) {
                    promptStr = CustomLocalizedString(@"Transfer_text_complete_viewfile_3", nil);
                    overStr1 = CustomLocalizedString(@"Transfer_text_complete_viewfile_3", nil);
                }else{
                    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_text_complete_viewfile", nil), CustomLocalizedString(@"Transfer_text_complete_viewfile_1", nil),CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil)];
                    overStr1 = CustomLocalizedString(@"Transfer_text_complete_viewfile_1", nil);
                    overStr2 = CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil);
                }
                
                NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
                [_textView setLinkTextAttributes:linkAttributes];
                
                NSMutableAttributedString *promptAs = [[NSMutableAttributedString alloc] initWithString:promptStr?:@""];
                [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, promptAs.length)];
                [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
                
                
                NSRange infoRange1 = [promptStr rangeOfString:overStr1];
                [promptAs addAttribute:NSLinkAttributeName value:overStr1 range:infoRange1];
                [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange1];
                [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange1];
                [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange1];
                
                
                NSRange infoRange2 = [promptStr rangeOfString:overStr2];
                [promptAs addAttribute:NSLinkAttributeName value:overStr2 range:infoRange2];
                [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange2];
                [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange2];
                [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange2];
                
                NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
                [mutParaStyle setAlignment:NSCenterTextAlignment];
                [mutParaStyle setLineSpacing:5.0];
                [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
                [[_textView textStorage] setAttributedString:promptAs];
                [promptAs release], promptAs =nil;
                [mutParaStyle release];
                mutParaStyle = nil;
                
            }
        }
        
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        if (_isToMac) {
            if (_icloudManager != nil) {
                //                for (IMBCategoryInfoModel *entity in _exportArray) {
                //                    [ATTracker event:iCloud_Content action:iCloud_Export actionParams:entity.categoryName label:LabelNone transferCount:0 screenView:@"iCloud Export View" screenColor:[IMBSoftWareInfo singleton].curUseSkin userLanguageName:[TempHelper currentSelectionLanguage] customParameters:nil];
                //                }
            }else {
                [ATTracker event:Content_To_Computer action:ContentToMac actionParams:@"Conent" label:Finish transferCount:successCount screenView:@"Conent" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }
        }else{
            [ATTracker event:Content_To_iTunes action:ToiTunes actionParams:@"Conent" label:Finish transferCount:successCount screenView:@"Conent" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        
//        [_contentView addSubview:_resultContentView];
    });
}

#pragma mark - textView Delegete
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex {
    if (_successCount < _totalCount && [IMBTransferError singleton].errorArrayM.count > 0) {
        NSString *moreItemStr = nil;
        if (!_isToMac) {
            moreItemStr = CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil);
        } else {
            moreItemStr = CustomLocalizedString(@"Show_Transfer_text_complete_viewfile_2", nil);
        }
        if ([link isEqualToString:CustomLocalizedString(@"Transfer_text_complete_viewfile_1", nil)] ) {
            
            NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
            [workSpace selectFile:nil inFileViewerRootedAtPath:_exportFolder];
            
        } else if ([link isEqualToString:moreItemStr]) {
            
            [self closeWindow:nil];
            
        } else if ([link isEqualToString: CustomLocalizedString(@"completeActivity_LinkTip", nil)]) {
            NSString *hoStr = nil;
            if (![StringHelper stringIsNilOrEmpty:[IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.gatherUrl]) {
                hoStr = [IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.gatherUrl;
            } else {
                hoStr = CustomLocalizedString(@"iCloudComplete_Url", nil);
            }
            hoStr = [hoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:hoStr];
            NSWorkspace *ws = [NSWorkspace sharedWorkspace];
            [ws openURL:url];
        } else if ([link isEqualToString:CustomLocalizedString(@"Show_ResultWindow_linkTips", nil)]) {
            //传输失败原因弹框
            NSView *view = nil;
            for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
                if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                    view = subView;
                    break;
                }
            }
            if (view) {
                [view setHidden:NO];
                [_androidAlertViewController showATtransferFailAlertViewWithSuperView:view WithFailReasonArray:[IMBTransferError singleton].errorArrayM];
            }
        }
        
    } else {
        
        if ([link isEqualToString:CustomLocalizedString(@"Transfer_text_complete_viewfile_1", nil)] ) {
            NSLog(@"%@",CustomLocalizedString(@"Transfer_text_complete_viewfile_1", nil));
            NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
            [workSpace selectFile:nil inFileViewerRootedAtPath:_exportFolder];
        }else if ([link isEqualToString:CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil)]|| [link isEqualToString:CustomLocalizedString(@"Transfer_text_complete_viewfile_3", nil)]) {
            NSLog(@"%@",CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil));
            [self closeWindow:nil];
        }else if ([link isEqualToString: CustomLocalizedString(@"completeActivity_LinkTip", nil)]) {
            NSString *hoStr = nil;
            if (![StringHelper stringIsNilOrEmpty:[IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.gatherUrl]) {
                hoStr = [IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.gatherUrl;
            } else {
                hoStr = CustomLocalizedString(@"iCloudComplete_Url", nil);
            }
            hoStr = [hoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:hoStr];
            NSWorkspace *ws = [NSWorkspace sharedWorkspace];
            [ws openURL:url];
        }
    }
    
    return YES;
}

#pragma mark - Alert
- (int)showAlertText:(NSString *)alertText OKButton:(NSString *)OkText
{
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    return [_alertViewController showAlertText:alertText OKButton:OkText SuperView:view];
}

- (int)showAlertText:(NSString *)alertText OKButton:(NSString *)OkText CancelButton:(NSString *)cancelText
{
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    return [_alertViewController showAlertText:alertText OKButton:OkText CancelButton:cancelText SuperView:view];
}

- (void)closeOpenPanel:(NSNotification *)noti {
    if ([noti.object isEqualToString:_ipod.uniqueKey] && _openPanel != nil && _isOpen) {
        [_openPanel cancel:nil];
        _openPanel = nil;
    }
}

- (void)moveBellImageView:(int)moveX {
    if (_bellImgView != nil) {
        [_bellImgView setFrameOrigin:NSMakePoint(340 + moveX, _bellImgView.frame.origin.y)];
    }
}

#pragma mark - iCloud完成活动界面 - 英语版
- (void)configEniCloudCompleteView {
    //配置文字和图片
    NSString *overStr = nil;
    NSString *promptStr = nil;
    if (_successCount > 1) {
        overStr = [NSString stringWithFormat:@"%d/%d",_successCount,_totalCount];
        overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"complete_items", nil)];
        promptStr = [NSString stringWithFormat: CustomLocalizedString(@"icloudUSCompleteActivity_Tip", nil),overStr];
    } else if (_successCount == 1){
        overStr = [NSString stringWithFormat:@"%d/%d",_successCount,_totalCount];
        overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"complete_item", nil)];
        promptStr = [NSString stringWithFormat: CustomLocalizedString(@"icloudUSCompleteActivity_Tip", nil),overStr];
        
    } else {
        promptStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_FailTitle", nil);
    }
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:26.0] withColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    if (![IMBHelper stringIsNilOrEmpty:overStr]) {
        NSRange infoRange = [promptStr rangeOfString:overStr];
        [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
        [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:26.0] range:infoRange];
    }
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_resultTitle textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
    
    //副标题
    [_resultSubTitle setStringValue:CustomLocalizedString(@"icloudUSCompleteActivity_Title", nil)];
    [_resultSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
    
    [_imageViewOne setImage:[StringHelper imageNamed:@"icloud_icon1"]];
    [_imageViewTwo setImage:[StringHelper imageNamed:@"icloud_icon4"]];
    [_imageViewThree setImage:[StringHelper imageNamed:@"icloud_icon3"]];
    [_imageViewFour setImage:[StringHelper imageNamed:@"icloud_icon2"]];
    
    //四个子标题
    [self setSubTitle:_imageTitleOne WithTextString:CustomLocalizedString(@"icloudUSCompleteActivity_Transfer1", nil)];
    [self setSubTitle:_imageTitleTwo WithTextString:CustomLocalizedString(@"icloudUSCompleteActivity_Transfer2", nil)];
    [self setSubTitle:_imageTitleThree WithTextString:CustomLocalizedString(@"icloudUSCompleteActivity_Transfer3", nil)];
    [self setSubTitle:_imageTitleFour WithTextString:CustomLocalizedString(@"icloudUSCompleteActivity_Transfer4", nil)];
    
    
    //textview
    [self setTextViewAttribute:_imageSubTitleOne WithString:CustomLocalizedString(@"icloudUSCompleteActivity_Transfer1_description",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
    [self setTextViewAttribute:_imageSubTitleTwo WithString:CustomLocalizedString(@"icloudUSCompleteActivity_Transfer2_description",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
    [self setTextViewAttribute:_imageSubTitleThree WithString:CustomLocalizedString(@"icloudUSCompleteActivity_Transfer3_description",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
    [self setTextViewAttribute:_imageSubTitleFour WithString:CustomLocalizedString(@"icloudUSCompleteActivity_Transfer4_description",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
    [self setTextViewAttribute:_bottomTitle WithString:CustomLocalizedString(@"completeActivity_LinkTip", nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithAlignment:2 WithFontSize:14.0 WithIsClick:YES];
    [_bottomTitle setDelegate:self];
    [_bottomTitle setSelectable:YES];
    
    
    //按钮加载
    [self setLearnMoreButton:_buttonOne];
    [_buttonOne setAction:@selector(iCloudCompleteOneClick)];
    [self setLearnMoreButton:_buttonTwo];
    [_buttonTwo setAction:@selector(iCloudCompleteTwoClick)];
    [self setLearnMoreButton:_buttonThree];
    [_buttonThree setAction:@selector(iCloudCompleteThreeClick)];
    [self setLearnMoreButton:_buttonFour];
    [_buttonFour setAction:@selector(iCloudCompleteFourClick)];
    
    //分割线
    [_lineViewOne setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_lineViewTwo setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_lineViewThree setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_lineViewFour setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_lineViewFive setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
}
- (void)setSubTitle:(NSTextField *)subTitle WithTextString:(NSString *)textString {
    [subTitle setStringValue:textString];
    [subTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [subTitle setFont:[NSFont fontWithName:@"Helvetica Neue Medium" size:14.0]];
}
- (void)setLearnMoreButton:(IMBGridientButton *)button {
    [button setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"learnMoreBtn_enter_Color", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"learnMoreBtn_enter_Color", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"learnMoreBtn_down_Color", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"learnMoreBtn_down_Color", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [button setButtonBorder:YES withNormalBorderColor:[StringHelper getColorFromString:CustomColor(@"learnMoreBtn_border_normalColor", nil)] withEnterBorderColor:[StringHelper getColorFromString:CustomColor(@"learnMoreBtn_border_Color", nil)] withDownBorderColor:[StringHelper getColorFromString:CustomColor(@"learnMoreBtn_border_Color", nil)] withForbiddenBorderColor:[StringHelper getColorFromString:CustomColor(@"learnMoreBtn_border_normalColor", nil)] withBorderLineWidth:2.0];
    
    [button setButtonTitle:CustomLocalizedString(@"DownLoad_LearnMore", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] withTitleSize:12.0 WithLightAnimation:NO];
    [button setHasRightImage:YES];
    [button setRightImage:[StringHelper imageNamed:@"media_arrow"]];
    [button setTarget:self];
    [button setEnabled:YES];
}
- (void)setTextViewAttribute:(NSTextView *)textView WithString:(NSString *)promptStr WithTextColor:(NSColor *)textColor WithAlignment:(NSUInteger)alignment WithFontSize:(int)fontSize WithIsClick:(BOOL)isClick {
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:fontSize] withColor:textColor];
    if (isClick) {
        NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]};
        [textView setLinkTextAttributes:linkAttributes];
        [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
        NSRange infoRange = [promptStr rangeOfString:promptStr];
        [promptAs addAttribute:NSLinkAttributeName value:promptStr range:infoRange];
        [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
        [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    }
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:alignment];
    [mutParaStyle setLineSpacing:3.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [textView setSelectable:NO];
    [[textView textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
}

#pragma mark - iCloud完成活动界面 - 其它语言版
- (void)configMuiCloudCompleteView {
    
    //配置文字和图片
    NSString *overStr = nil;
    NSString *promptStr = nil;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
        if (_successCount > 1) {
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            promptStr = [NSString stringWithFormat: CustomLocalizedString(@"Transfer_text_complete_ActivityTitles", nil),overStr];
            overStr = [overStr stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_2", nil)];
        } else if (_successCount == 1){
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            promptStr = [NSString stringWithFormat: CustomLocalizedString(@"Transfer_text_complete_ActivityTitle", nil),overStr];
            overStr = [overStr stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_1", nil)];
        } else {
            promptStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_FailTitle", nil);
        }
    } else {
        if (_successCount > 1) {
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            promptStr = [NSString stringWithFormat: CustomLocalizedString(@"Transfer_text_complete_ActivityTitles", nil),overStr];
            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_2", nil)];
        } else if (_successCount == 1){
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            promptStr = [NSString stringWithFormat: CustomLocalizedString(@"Transfer_text_complete_ActivityTitle", nil),overStr];
            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_1", nil)];
        } else {
            promptStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_FailTitle", nil);
        }
    }
    
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:26.0] withColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    if (![IMBHelper stringIsNilOrEmpty:overStr]) {
        NSRange infoRange = [promptStr rangeOfString:overStr];
        [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
        [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:26.0] range:infoRange];
    }
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_muicloudCompleteMainTitle textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
    
    [_muicloudCompleteSubTitle setStringValue:CustomLocalizedString(@"Transfer_text_complete_ActivitySubTitle",nil)];
    [_muicloudCompleteMiddleTitle setStringValue:CustomLocalizedString(@"TransferComplete_iCloudActivity_Tips", nil)];
    
    [_muicloudCompleteLable1 setStringValue:CustomLocalizedString(@"TransferComplete_iCloudActivity_1", nil)];
    [_muicloudCompleteLable2 setStringValue:CustomLocalizedString(@"TransferComplete_iCloudActivity_2", nil)];
    [_muicloudCompleteLable3 setStringValue:CustomLocalizedString(@"TransferComplete_iCloudActivity_3", nil)];
    [_muicloudCompleteLable4 setStringValue:CustomLocalizedString(@"TransferComplete_iCloudActivity_4", nil)];
    [_muicloudCompleteLable5 setStringValue:CustomLocalizedString(@"TransferComplete_iCloudActivity_5", nil)];
    [_muicloudCompleteBtnView1 mouseDownImage:[StringHelper imageNamed:@"mu_icloud_icon1"] withMouseUpImg:[StringHelper imageNamed:@"mu_icloud_icon1"] withMouseExitedImg:[StringHelper imageNamed:@"mu_icloud_icon1"] mouseEnterImg:[StringHelper imageNamed:@"mu_icloud_icon1"]];
    [_muicloudCompleteBtnView1 setTarget:self];
    [_muicloudCompleteBtnView1 setIsEnble:YES];
    [_muicloudCompleteBtnView1 setAction:@selector(iCloudCompleteOneClick)];
    
    [_muicloudCompleteBtnView2 mouseDownImage:[StringHelper imageNamed:@"mu_icloud_icon2"] withMouseUpImg:[StringHelper imageNamed:@"mu_icloud_icon2"] withMouseExitedImg:[StringHelper imageNamed:@"mu_icloud_icon2"] mouseEnterImg:[StringHelper imageNamed:@"mu_icloud_icon2"]];
    [_muicloudCompleteBtnView2 setTarget:self];
    [_muicloudCompleteBtnView2 setIsEnble:YES];
    [_muicloudCompleteBtnView2 setAction:@selector(iCloudCompleteTwoClick)];
    
    [_muicloudCompleteBtnView3 mouseDownImage:[StringHelper imageNamed:@"mu_icloud_icon3"] withMouseUpImg:[StringHelper imageNamed:@"mu_icloud_icon3"] withMouseExitedImg:[StringHelper imageNamed:@"mu_icloud_icon3"] mouseEnterImg:[StringHelper imageNamed:@"mu_icloud_icon3"]];
    [_muicloudCompleteBtnView3 setTarget:self];
    [_muicloudCompleteBtnView3 setIsEnble:YES];
    [_muicloudCompleteBtnView3 setAction:@selector(iCloudCompleteThreeClick)];
    
    [_muicloudCompleteBtnView4 mouseDownImage:[StringHelper imageNamed:@"mu_icloud_icon4"] withMouseUpImg:[StringHelper imageNamed:@"mu_icloud_icon4"] withMouseExitedImg:[StringHelper imageNamed:@"mu_icloud_icon4"] mouseEnterImg:[StringHelper imageNamed:@"mu_icloud_icon4"]];
    [_muicloudCompleteBtnView4 setTarget:self];
    [_muicloudCompleteBtnView4 setIsEnble:YES];
    [_muicloudCompleteBtnView4 setAction:@selector(iCloudCompleteFourClick)];
    
    [_muicloudCompleteBtnView5 mouseDownImage:[StringHelper imageNamed:@"mu_icloud_icon5"] withMouseUpImg:[StringHelper imageNamed:@"mu_icloud_icon5"] withMouseExitedImg:[StringHelper imageNamed:@"mu_icloud_icon5"] mouseEnterImg:[StringHelper imageNamed:@"mu_icloud_icon5"]];
    [_muicloudCompleteBtnView5 setTarget:self];
    [_muicloudCompleteBtnView5 setIsEnble:YES];
    [_muicloudCompleteBtnView5 setAction:@selector(iCloudCompleteFiveClick)];
    
    //配置颜色
    [_muicloudCompleteSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
    [_muicloudCompleteMiddleTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_muicloudCompleteLable1 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_muicloudCompleteLable2 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_muicloudCompleteLable3 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_muicloudCompleteLable4 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_muicloudCompleteLable5 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_muicloudCompleteDetailView setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_muicloudCompleteDetailView setIsHaveCorner:NO];
    
    //配置按钮
    [_muicloudCompleteButton setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"completeButton_normal_leftColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"completeButton_normal_rightColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"completeButton_enter_leftColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"completeButton_enter_rightColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"completeButton_down_leftColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"completeButton_down_rightColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"completeButton_enter_leftColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"completeButton_enter_rightColor", nil)]];
    [_muicloudCompleteButton setButtonTitle:CustomLocalizedString(@"TransferComplete_iCloudActivity_BtnTitle", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withTitleSize:18.0 WithLightAnimation:NO];
    [_muicloudCompleteButton setHasRightImage:YES];
    [_muicloudCompleteButton setRightImage:[StringHelper imageNamed:@"media_btnarrow"]];
    [_muicloudCompleteButton setHasBorder:NO];
    [_muicloudCompleteButton setIsiCloudCompleteBtn:YES];
    [_muicloudCompleteButton setTarget:self];
    [_muicloudCompleteButton setAction:@selector(iCloudCompleteButtonClick)];
    [_muicloudCompleteButton setNeedsDisplay:YES];
    
}

#pragma mark - iCloud传输完成界面 按钮点击方法
- (void)iCloudCompleteButtonClick {
    NSString *hoStr = CustomLocalizedString(@"TransferComplete_iCloudActivity_Url", nil);
    hoStr = [hoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)iCloudCompleteOneClick {
    NSString *hoStr = nil;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
        if (![StringHelper stringIsNilOrEmpty:[IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.moveVideoUrl]) {
            hoStr = [IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.moveVideoUrl;
        } else {
            hoStr = CustomLocalizedString(@"iCloudComplete_moveVideoUrl", nil);
        }
    } else {
        hoStr = CustomLocalizedString(@"TransferComplete_iCloudActivity_Url", nil);
    }
    hoStr = [hoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)iCloudCompleteTwoClick {
    NSString *hoStr = nil;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
        if (![StringHelper stringIsNilOrEmpty:[IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.convertVideoUrl]) {
            hoStr = [IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.convertVideoUrl;
        } else {
            hoStr = CustomLocalizedString(@"iCloudComplete_convertVideoUrl", nil);
        }
    } else {
        hoStr = CustomLocalizedString(@"TransferComplete_iCloudActivity_Url", nil);
    }
    hoStr = [hoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)iCloudCompleteThreeClick {
    NSString *hoStr = nil;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
        if (![StringHelper stringIsNilOrEmpty:[IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.migrateMediaUrl]) {
            hoStr = [IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.migrateMediaUrl;
        } else {
            hoStr = CustomLocalizedString(@"iCloudComplete_migrateMediaUrl", nil);
        }
    } else {
        hoStr = CustomLocalizedString(@"TransferComplete_iCloudActivity_Url", nil);
    }
    hoStr = [hoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)iCloudCompleteFourClick {
    NSString *hoStr = nil;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
        if (![StringHelper stringIsNilOrEmpty:[IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.transferUrl]) {
            hoStr = [IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.transferUrl;
        }else {
            hoStr = CustomLocalizedString(@"iCloudComplete_transferUrl", nil);
        }
    } else {
        hoStr = CustomLocalizedString(@"TransferComplete_iCloudActivity_Url", nil);
    }
    hoStr = [hoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)iCloudCompleteFiveClick {
    NSString *hoStr = CustomLocalizedString(@"TransferComplete_iCloudActivity_Url", nil);
    hoStr = [hoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)dealloc
{
    [_closebutton release],_closebutton = nil;
//    [_ipod release],_ipod = nil;
    [_bindcategoryArray release],_bindcategoryArray = nil;
//    [_alertViewController release],_alertViewController = nil;
    [_exportFolder release],_exportFolder = nil;
    [_exportArray release],_exportArray = nil;
    [_baseTransfer release],_baseTransfer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DeviceDisConnectedNotification object:nil];
    [super dealloc];
}
@end
