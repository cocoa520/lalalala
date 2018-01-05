//
//  IMBDownloadListViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-12-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBDownloadListViewController.h"
#import "HoverButton.h"
#import "StringHelper.h"
#define TableViewRowWidth 1000
#define TableViewRowHight 100
#import "ObjectTableRowView.h"
#import "DownloadCellView.h"
#import "IMBAnimation.h"
#import "IMBNotificationDefine.h"
#import "VideoBaseInfoEntity.h"
#define OringinalPropertityX 209
#define OringinalPropertityY 22
#import "IMBAirSyncImportTransfer.h"
#import "IMBCustomPopupButton.h"
#import "IMBToDevicePopoverViewController.h"
#import "SystemHelper.h"
#import "VDLManager.h"
#import "OperationLImitation.h"
#import "IMBDownloadButton.h"
#import "TempHelper.h"
#import "IMBNotAirSyncImportTransfer.h"
#import "IMBVideoDownloadViewController.h"

@interface IMBDownloadListViewController ()

@end

@implementation IMBDownloadListViewController
@synthesize downloadDataSource = _downloadDataSource;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearData:) name:NSApplicationWillTerminateNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib {
}

- (void)loadView
{
    [super loadView];
    successCount = 0;
    _cleanList.font = [NSFont fontWithName:@"Helvetica Neue" size:12.0];
    _cleanList.fontColor = [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)];
    _cleanList.fontEnterColor = [StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)];
    _cleanList.fontDownColor = [StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)];
    [_cleanList setTarget:self];
    [_cleanList setAction:@selector(cleanlist:)];
    [_cleanList setTitle:CustomLocalizedString(@"DownLoadCleanTips", nil)];
    _operationQueue = [[NSOperationQueue alloc] init];
    [_operationQueue setMaxConcurrentOperationCount:1];
    HoverButton *closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil((NSHeight(_titleView.frame) - 32)/2), 32, 32)];
    [closebutton setTarget:self];
    [closebutton setAction:@selector(closeWindow:)];
    [closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [closebutton setTag:10];
    [_titleView addSubview:closebutton];
    [_titleView setHasBottomBorder:YES];
    [_titleView setBottomBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _downloadDataSource = [[NSMutableArray alloc] init];
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_nodataImageView setImage:[StringHelper imageNamed:@"download_nodata"]];
    [_noTipTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [_titleTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_noTipTextField setStringValue:CustomLocalizedString(@"downloadpageNoDataTips", nil)];

    HoverButton *closebutton1 = [[HoverButton alloc] initWithFrame:NSMakeRect(32, ceil(NSHeight(self.view.frame)) - 32 -22, 32, 32)];
    [closebutton1 setAutoresizesSubviews:YES];
    [closebutton1 setAutoresizingMask: NSViewMaxXMargin|NSViewMinYMargin];
    [closebutton1 setTarget:self];
    [closebutton1 setAction:@selector(closeWindow:)];
    closebutton1.tag = 200;
    [closebutton1 setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_resultView addSubview:closebutton1];
    
    HoverButton *closebutton2 = [[HoverButton alloc] initWithFrame:NSMakeRect(32, ceil(NSHeight(self.view.frame)) - 32 -22, 32, 32)];
    [closebutton2 setAutoresizesSubviews:YES];
    [closebutton2 setAutoresizingMask: NSViewMaxXMargin|NSViewMinYMargin];
    [closebutton2 setTarget:self];
    [closebutton2 setAction:@selector(closeWindow:)];
    closebutton2.tag = 201;
    [closebutton2 setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_muresultView addSubview:closebutton2];
    
    [self.view setWantsLayer:YES];
    [self.view.layer setMasksToBounds:YES];
    [self.view.layer setCornerRadius:5];
    [_tableView setBackgroundColor:[NSColor clearColor]];
    [mainBgView setIsGradientColorNOCornerPart4:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [_resultView setIsGradientColorNOCornerPart4:YES];
    [_muresultView setIsGradientColorNOCornerPart4:YES];
    
    [_reslutSuperView setWantsLayer:YES];
}

- (void)clearData:(NSNotification *)notification {
    for (VideoBaseInfoEntity *entity in _downloadDataSource) {
        if (entity.downloadState == Downloading) {
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:entity.vDownloadPath]) {
                [fm removeItemAtPath:entity.vDownloadPath error:nil];
            }
            [self writeDownloadPlist:entity];
        }
    }
}

- (void)addDataSource:(NSMutableArray *)addDataSource
{
    for (id entity in addDataSource) {
        [_downloadDataSource insertObject:entity atIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData:YES];
        });
    }
}

#pragma mark - 加载视频下载完成活动界面  英语版
- (void)addResultView {
    if (![_resultView superview]) {
        //配置文字和图片
        _tempCount = successCount;
        NSString *overStr = nil;
        NSString *promptStr = nil;
        if (successCount > 1) {
            overStr = [NSString stringWithFormat:@"%d",successCount];
            promptStr = [NSString stringWithFormat:CustomLocalizedString(@"VideosDownLoadCompleteActivity_Tips", nil),overStr];
            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"complete_items", nil)];
        } else if (successCount == 1){
            overStr = [NSString stringWithFormat:@"%d",successCount];
            promptStr = [NSString stringWithFormat:CustomLocalizedString(@"VideosDownLoadCompleteActivity_Tip", nil),overStr];
            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"complete_item", nil)];
            
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
        
        [_resultSubTitle setStringValue:CustomLocalizedString(@"VideosDownLoadCompleteActivity_Title", nil)];
        [_resultSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
        
        [_imageViewOne setImage:[StringHelper imageNamed:@"media_icon1"]];
        [_imageViewTwo setImage:[StringHelper imageNamed:@"media_icon2"]];
        [_imageViewThree setImage:[StringHelper imageNamed:@"media_icon3"]];
        [_imageViewFour setImage:[StringHelper imageNamed:@"media_icon4"]];
        
        [self setSubTitle:_imageTitleOne WithTextString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_Transfer", nil)];
        [self setSubTitle:_imageTitleTwo WithTextString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_AutoConvert", nil)];
        [self setSubTitle:_imageTitleThree WithTextString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_MoveVideo", nil)];
        [self setSubTitle:_imageTitleFour WithTextString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_MigrateMedia", nil)];
        
        //textview
        [self setTextViewAttribute:_imageSubTitleOne WithString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_Transfer1",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
        [self setTextViewAttribute:_imageSubTitleTwo WithString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_AutoConvert1",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
        [self setTextViewAttribute:_imageSubTitleThree WithString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_MoveVideo1",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
        [self setTextViewAttribute:_imageSubTitleFour WithString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_MigrateMedia1",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
        [self setTextViewAttribute:_bottomTitle WithString:CustomLocalizedString(@"downloadComplete_BottomTitle", nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithAlignment:2 WithFontSize:14.0 WithIsClick:YES];
        [_bottomTitle setDelegate:self];
        [_bottomTitle setSelectable:YES];
        
        
        //按钮加载
        [self setLearnMoreButton:_buttonOne];
        [_buttonOne setAction:@selector(downloadCompleteButtonClickOne)];
        [self setLearnMoreButton:_buttonTwo];
        [_buttonTwo setAction:@selector(downloadCompleteButtonClickTwo)];
        [self setLearnMoreButton:_buttonThree];
        [_buttonThree setAction:@selector(downloadCompleteButtonClickThree)];
        [self setLearnMoreButton:_buttonFour];
        [_buttonFour setAction:@selector(downloadCompleteButtonClickFour)];
        
        //分割线
        [_lineViewOne setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_lineViewTwo setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_lineViewThree setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_lineViewFour setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_lineViewFive setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        
        [_resultView setFrameSize:NSMakeSize(NSWidth(self.view.frame), NSHeight(self.view.frame))];
        [_scrollView removeFromSuperview];
        [_titleView setHidden:YES];
        [_reslutSuperView addSubview:_resultView];
        successCount = 0;
    }
}
#pragma mark - 加载视频下载完成活动界面  其它语言版
- (void)addMuResultView {
    if (![_muresultView superview]) {
        //配置文字和图片
        _tempCount = successCount;
        NSString *overStr = nil;
        NSString *promptStr = nil;
        if (successCount > 1) {
            overStr = [NSString stringWithFormat:@"%d",successCount];
            promptStr = [NSString stringWithFormat:CustomLocalizedString(@"VideosDownLoadCompleteActivity_Titles", nil),overStr];
            if ([IMBSoftWareInfo singleton].chooseLanguageType != JapaneseLanguage && [IMBSoftWareInfo singleton].chooseLanguageType != ArabLanguage) {
                overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"VideoDownloadColorTitles", nil)];
            }
        } else if (successCount == 1) {
            overStr = [NSString stringWithFormat:@"%d",successCount];
            promptStr = [NSString stringWithFormat:CustomLocalizedString(@"VideosDownLoadCompleteActivity_Title", nil),overStr];
            if ([IMBSoftWareInfo singleton].chooseLanguageType != JapaneseLanguage && [IMBSoftWareInfo singleton].chooseLanguageType != ArabLanguage) {
                overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"VideoDownloadColorTitle", nil)];
            }
            
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
        [[_muresultTitle textStorage] setAttributedString:promptAs];
        [mutParaStyle release], mutParaStyle = nil;
        
        [_muresultSubTitle setStringValue:CustomLocalizedString(@"VideosDownLoadCompleteActivity_SubTitle", nil)];
        [_muresultSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
    
        [_muimageViewOne setImage:[StringHelper imageNamed:@"mu_media_icon1"]];
        [_muimageViewTwo setImage:[StringHelper imageNamed:@"mu_media_icon2"]];
        [_muimageViewThree setImage:[StringHelper imageNamed:@"mu_media_icon3"]];
        [_muimageViewFour setImage:[StringHelper imageNamed:@"mu_media_icon4"]];
        
        //四个子标题
        [self setSubTitle:_muimageTitleOne WithTextString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_EnjoyStr", nil)];
        [self setSubTitle:_muimageTitleTwo WithTextString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_AutoStr", nil)];
        [self setSubTitle:_muimageTitleThree WithTextString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_MoveStr", nil)];
        [self setSubTitle:_muimageTitleFour WithTextString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_MigrateStr", nil)];
        
        
        //textview
        [self setTextViewAttribute:_muimageSubTitleOne WithString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_EnjoyStr1",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
        [self setTextViewAttribute:_muimageSubTitleTwo WithString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_AutoStr1",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
        [self setTextViewAttribute:_muimageSubTitleThree WithString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_MoveStr1",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
        [self setTextViewAttribute:_muimageSubTitleFour WithString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_MigrateStr1",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
        
        //按钮加载
        [_muDownloadBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"download_org_normal_rightColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"download_org_normal_leftColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"download_org_enter_rightColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"download_org_enter_leftColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"download_org_down_rightColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"download_org_down_leftColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"download_org_normal_rightColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"download_org_normal_leftColor", nil)]];
        [_muDownloadBtn setButtonTitle:CustomLocalizedString(@"VideosDownLoadCompleteActivity_BuyBtnTitle", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withTitleSize:18.0 WithLightAnimation:NO];
        [_muDownloadBtn setHasRightImage:YES];
        [_muDownloadBtn setRightImage:[StringHelper imageNamed:@"media_btnarrow"]];
        [_muDownloadBtn setHasBorder:NO];
        [_muDownloadBtn setIsiCloudCompleteBtn:NO];
        [_muDownloadBtn setTarget:self];
        [_muDownloadBtn setAction:@selector(downloadCompleteButtonClickOne)];
        [_muDownloadBtn setNeedsDisplay:YES];
        
        //分割线
        [_mulineViewOne setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_mulineViewTwo setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        
        [_muresultView setFrameSize:NSMakeSize(NSWidth(self.view.frame), NSHeight(self.view.frame))];
        [_scrollView removeFromSuperview];
        [_titleView setHidden:YES];
        [_reslutSuperView addSubview:_muresultView];
        successCount = 0;
    }
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

#pragma mark - textView Delegate
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex {
    NSString *overStr = CustomLocalizedString(@"downloadComplete_BottomTitle", nil);
    if ([link isEqualToString:overStr]) {
        NSString *hoStr = nil;
        hoStr = [IMBSoftWareInfo singleton].activityInfo.downloadUrlInfo.gatherUrl;
        if ([IMBHelper stringIsNilOrEmpty:hoStr]) {
            hoStr = CustomLocalizedString(@"Donwload_List5_URL", nil);
        }
        NSURL *url = [NSURL URLWithString:hoStr];
        NSWorkspace *ws = [NSWorkspace sharedWorkspace];
        [ws openURL:url];
    }
    return YES;
}

#pragma mark - 完成界面 按钮点击方法
- (void)downloadCompleteButtonClickOne {
    NSString *hoStr = nil;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
        hoStr = [IMBSoftWareInfo singleton].activityInfo.downloadUrlInfo.moveVideoUrl;
        if ([IMBHelper stringIsNilOrEmpty:hoStr]) {
            hoStr = CustomLocalizedString(@"Donwload_List1_URL", nil);
        }
    } else {
        hoStr = CustomLocalizedString(@"VideosDownLoadCompleteActivity_Url", nil);
    }
    hoStr = [hoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}
- (void)downloadCompleteButtonClickTwo {
    NSString *hoStr = nil;
    hoStr = [IMBSoftWareInfo singleton].activityInfo.downloadUrlInfo.convertVideoUrl;
    if ([IMBHelper stringIsNilOrEmpty:hoStr]) {
        hoStr = CustomLocalizedString(@"Donwload_List2_URL", nil);
    }
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}
- (void)downloadCompleteButtonClickThree {
    NSString *hoStr = nil;
    hoStr = [IMBSoftWareInfo singleton].activityInfo.downloadUrlInfo.migrateMediaUrl;
    if ([IMBHelper stringIsNilOrEmpty:hoStr]) {
        hoStr = CustomLocalizedString(@"Donwload_List3_URL", nil);
    }
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}
- (void)downloadCompleteButtonClickFour {
    NSString *hoStr = nil;
    hoStr = [IMBSoftWareInfo singleton].activityInfo.downloadUrlInfo.transferUrl;
    if ([IMBHelper stringIsNilOrEmpty:hoStr]) {
        hoStr = CustomLocalizedString(@"Donwload_List4_URL", nil);
    }
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)adSuccessCount
{
    successCount++;
}

- (void)reloadData:(BOOL)isAdd
{
    [_cleanList setTitle:CustomLocalizedString(@"DownLoadCleanTips", nil)];
    [_cleanList setFrameOrigin:NSMakePoint(NSWidth(_cleanList.superview.frame) - NSWidth(_cleanList.frame), NSMinY(_cleanList.frame))];
    if ([_downloadDataSource count] <= 1) {
        [_titleTextField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"DownloadListPageBtnCountTip", nil),[_downloadDataSource count]]];
    }else{
        [_titleTextField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"DownloadListPageBtnCountTips", nil),[_downloadDataSource count]]];
    }
    if (isAdd) {
        [_titleView setHidden:NO];
        if ([_downloadDataSource count]>0) {
            [_tableView reloadData];
            [_scrollView setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
            [_contentBox setContentView:_scrollView];
        }else{
            [_nodataView setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
            [_contentBox setContentView:_nodataView];
        }
    }
}

#pragma mark - NSTableView Datasource and Delegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 100;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_downloadDataSource count];
}

- (void)tableView:(NSTableView *)tableView didRemoveRowView:(ObjectTableRowView *)rowView forRow:(NSInteger)row {
    if ([rowView.subviews count]>0) {
        DownloadCellView *cellView = (DownloadCellView *)[[rowView subviews] objectAtIndex:0];
        if ([cellView isKindOfClass:[DownloadCellView class]]) {
            [cellView.progessField unbind:@"value"];
            [cellView.progessView unbind:@"doubleValue"];
            [cellView.transferProgressView unbind:@"doubleValue"];
        }
    }
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    ObjectTableRowView *result = [[ObjectTableRowView alloc] initWithFrame:NSMakeRect(0, 0, TableViewRowWidth, TableViewRowHight)];
    result.objectValue = [_downloadDataSource objectAtIndex:row];
    return [result autorelease];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
   
    DownloadCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
    VideoBaseInfoEntity *entity = [_downloadDataSource objectAtIndex:row];
    [cellView.propertityViewArray removeAllObjects];
    if (entity.vSize.length>0) {
        [cellView.sizeTextField setStringValue:[StringHelper getFileSizeString:entity.vSize.longLongValue reserved:2]];
        [cellView.propertityViewArray addObject:cellView.sizeTextField];
        [cellView.sizeTextField setHidden:NO];
    }
    if (entity.vResolutionMode.length>0) {
        [cellView.resolutionTextField setStringValue:entity.vResolutionMode];
        [cellView.propertityViewArray addObject:cellView.resolutionTextField];
        [cellView.resolutionTextField setHidden:NO];
    }
    if (entity.vType.length>0) {
        [cellView.TypeTextField setStringValue:[entity.vType uppercaseString]];
        [cellView.propertityViewArray addObject:cellView.TypeTextField];
        [cellView.TypeTextField setHidden:NO];
    }
    if (entity.vDuration.length>0) {
        [cellView.DurationTextField setStringValue:entity.vDuration];
        [cellView.propertityViewArray addObject:cellView.DurationTextField];
        [cellView.DurationTextField setHidden:NO];
    }
    [cellView.closeButton setTarget:self];
    [cellView.closeButton setAction:@selector(closeTask:)];
    if (entity.vName.length>0) {
        [cellView.titleField setStringValue:entity.vName];
    }
    if (entity.vThumbnail == nil) {
        [cellView.icon setImage:[StringHelper imageNamed:@"download_def"]];

    }else{
        [cellView.icon setImage:entity.vThumbnail];
    }
    [cellView.progessField bind:@"value" toObject:entity withKeyPath:@"progressText" options:nil];
    for (NSView *subView in cellView.subviews) {
        [subView setHidden:YES];
    }
    [cellView adjustSpaceX:OringinalPropertityX Y:OringinalPropertityY];
    [cellView.icon setHidden:NO];
    [cellView.titleField setHidden:NO];
    [cellView.transferProgressView bind:@"doubleValue" toObject:entity withKeyPath:@"tranferprogressValue" options:nil];
    if (entity.downloadState == Downloading) {
        [cellView.progessView bind:@"doubleValue" toObject:entity withKeyPath:@"progressDoubleValue" options:nil];
        [cellView.closeButton setHidden:NO];
        [cellView.progessView setHidden:NO];
        [cellView.progessField setHidden:NO];
    }else if (entity.downloadState == DownloadFaild){
        [cellView.sizeTextField setHidden:YES];
        [cellView.resolutionTextField setHidden:YES];
        [cellView.DurationTextField setHidden:YES];
        [cellView.TypeTextField setHidden:YES];
        [cellView.downloadFaildField setHidden:NO];
        [cellView.downloadFaildField setTextColor:[StringHelper getColorFromString:CustomColor(@"download_transferFail_tipColor", nil)]];
        [cellView.downloadFaildField setStringValue:CustomLocalizedString(@"downloadFailTips", nil)];
        [cellView.reDownLoad setHidden:NO];
        [cellView.reDownLoad setTarget:self];
        [cellView.reDownLoad setAction:@selector(reDownLoad:)];
        [cellView.deleteButton setHidden:NO];
        [cellView.deleteButton setTarget:self];
        [cellView.deleteButton setAction:@selector(deleteFile:)];
    }else if (entity.downloadState == DownloadFinish){
        if (!entity.isFileExist) {
            [cellView.downloadFaildField setHidden:NO];
            [cellView.downloadFaildField setTextColor:[StringHelper getColorFromString:CustomColor(@"download_transferFail_tipColor", nil)]];
            [cellView.downloadFaildField setStringValue:CustomLocalizedString(@"downloadVideoFileNotExist", nil)];
            [cellView.sizeTextField setHidden:YES];
            [cellView.resolutionTextField setHidden:YES];
            [cellView.DurationTextField setHidden:YES];
            [cellView.TypeTextField setHidden:YES];
            [cellView.reDownLoad setHidden:NO];
            [cellView.reDownLoad setTarget:self];
            [cellView.reDownLoad setAction:@selector(reDownLoad:)];
        }else {
            [cellView.finderButton setHidden:NO];
            [cellView.finderButton setTarget:self];
            [cellView.finderButton setAction:@selector(finderFile:)];
            [cellView.toDeviceButton setHidden:NO];
            [cellView.toDeviceButton setTarget:self];
            [cellView.toDeviceButton setAction:@selector(toDevice:)];
        }
        [cellView.deleteButton setHidden:NO];
        [cellView.deleteButton setTarget:self];
        [cellView.deleteButton setAction:@selector(deleteFile:)];
    }else if (entity.downloadState == TransferWait||entity.downloadState == TransferPrePare){
        [cellView.progessField setHidden:NO];
        [cellView.transferProgressView setHidden:NO];
        [cellView.closeTransferButton setHidden:NO];
        [cellView.closeTransferButton setTarget:self];
        [cellView.closeTransferButton setAction:@selector(closeTransfer:)];
        [cellView.transferProgressView startWati];
    }else if (entity.downloadState == Transfering || entity.downloadState == TransferWillFnish){
        if (entity.downloadState == Transfering) {
            [cellView.transferProgressView endWait];
        }
        if (entity.downloadState == TransferWillFnish) {
            [cellView.transferProgressView startFinishWait];
        }
        [cellView.progessField setHidden:NO];
        [cellView.transferProgressView setHidden:NO];
        [cellView.closeTransferButton setHidden:NO];
        [cellView.closeTransferButton setTarget:self];
        [cellView.closeTransferButton setAction:@selector(closeTransfer:)];
    }else if (entity.downloadState == TransferFinishFail){
        [cellView.transferProgressView endFinishWait];
        [cellView.transferResultField setHidden:NO];
        [cellView.transferResultImageView setHidden:NO];
        NSRect rect = [StringHelper calcuTextBounds:CustomLocalizedString(@"downloadpageTransferFailedTips", nil) fontSize:12.0];
        //传输失败
        [cellView.transferResultImageView setHidden:NO];
        [cellView.transferResultField setHidden:NO];
        [cellView.transferResultImageView setImage:[StringHelper imageNamed:@"download_transferfalse"]];
        [cellView.transferResultField setTextColor:[StringHelper getColorFromString:CustomColor(@"download_transferFail_tipColor", nil)]];
        [cellView.transferResultField setStringValue:CustomLocalizedString(@"downloadpageTransferFailedTips", nil)];
        [cellView.transferResultImageView setFrameOrigin:NSMakePoint(NSMaxX(cellView.transferResultField.frame) - ceil(NSWidth(rect)) - 8 - NSWidth(cellView.transferResultImageView.frame), cellView.transferResultImageView.frame.origin.y)];
        
    }else if (entity.downloadState == TransferFinishSuccess){
        [cellView.transferProgressView endFinishWait];
        [cellView.transferResultField setHidden:NO];
        [cellView.transferResultImageView setHidden:NO];
        NSRect rect = [StringHelper calcuTextBounds:CustomLocalizedString(@"downloadpageTransferCompleteTips", nil) fontSize:12.0];
        //传输成功
        [cellView.transferResultImageView setImage:[StringHelper imageNamed:@"download_transfercomplete"]];
        [cellView.transferResultField setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
        [cellView.transferResultField setStringValue:CustomLocalizedString(@"downloadpageTransferCompleteTips", nil)];
        [cellView.transferResultImageView setHidden:NO];
        [cellView.transferResultField setHidden:NO];
        
        [cellView.transferResultImageView setFrameOrigin:NSMakePoint(NSMaxX(cellView.transferResultField.frame) - ceil(NSWidth(rect)) - 8 - NSWidth(cellView.transferResultImageView.frame), cellView.transferResultImageView.frame.origin.y)];
        
    }
    return cellView;
}

- (void)closeWindow:(id)sender
{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Video_Download action:ActionNone actionParams:@"Analyze View" label:Switch transferCount:1 screenView:@"Analyze View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
    NSString *str = @"open";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
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
            if (_delegate && [_delegate respondsToSelector:@selector(setIsShowLineView:)]) {
                [_delegate setIsShowLineView:NO];
            }
        } completionHandler:^{
            [_rightUpDownbgView setEnable:YES];
            [self.view removeFromSuperview];
            if (![IMBSoftWareInfo singleton].isRegistered && _delegate != nil) {
                [_delegate showReslutView];
            }
            NSButton *button = (NSButton *)sender;
            if (button.tag == 200) {
                [_resultView removeFromSuperview];
                successCount = 0;
            } else if (button.tag == 201) {
                [_muresultView removeFromSuperview];
                successCount = 0;
            }
        }];
    }];
}

#pragma makr Actions
- (void)finderFile:(id)sender
{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Video_Download action:Find actionParams:@"Find Video" label:LabelNone transferCount:1 screenView:@"Download View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    ObjectTableRowView *rowView = (ObjectTableRowView *)[[sender superview] superview];
    VideoBaseInfoEntity *entity = (VideoBaseInfoEntity *)rowView.objectValue;
    NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
    [workSpace selectFile:entity.vDownloadPath inFileViewerRootedAtPath:nil];
}

- (void)deleteFile:(id)sender
{
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    if (view) {
        [view setHidden:NO];
        if ([_alertViewController showDeleteConfrimText:CustomLocalizedString(@"iCloudBackup_View_Delete_Tips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view] == 1) {
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:Video_Download action:Remove actionParams:@"Remove Video" label:LabelNone transferCount:1 screenView:@"Download View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            ObjectTableRowView *rowView = (ObjectTableRowView *)[[sender superview] superview];
            VideoBaseInfoEntity *entity = (VideoBaseInfoEntity *)rowView.objectValue;
            if ([[NSFileManager defaultManager] fileExistsAtPath:entity.vDownloadPath]) {
                [[NSFileManager defaultManager] removeItemAtPath:entity.vDownloadPath error:nil];
            }
            [_downloadDataSource removeObject:entity];
            [_titleView setHidden:NO];
            if ([_downloadDataSource count]>0) {
                [_tableView reloadData];
                [_contentBox setContentView:_scrollView];
            }else{
                [_contentBox setContentView:_nodataView];
            }
            [self cleanplist:[NSArray arrayWithObject:entity]];
        }
    }
    if ([_downloadDataSource count] <= 1) {
        [_titleTextField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"DownloadListPageBtnCountTip", nil),[_downloadDataSource count]]];
    }else{
        [_titleTextField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"DownloadListPageBtnCountTips", nil),[_downloadDataSource count]]];
    }

}

- (void)cleanplist:(NSArray *)entityArray
{
    NSString *plistPath = [[TempHelper getAppDownloadDefaultPath] stringByAppendingPathComponent:@"videodownload.plist"];
    NSMutableDictionary *allDic = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:plistPath]) {
        allDic = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
        for (VideoBaseInfoEntity *entity in entityArray) {
            if ([allDic.allKeys containsObject:[NSString stringWithFormat:@"%@-%@",entity.vID,entity.vVideoID]]) {
                [allDic removeObjectForKey:[NSString stringWithFormat:@"%@-%@",entity.vID,entity.vVideoID]];
                if ([fileManager fileExistsAtPath:entity.vCachePKLBeforePath]) {
                    [fileManager removeItemAtPath:entity.vCachePKLBeforePath error:nil];
                }
            }
        }
        [allDic writeToFile:plistPath atomically:YES];
    }
}

- (void)toDevice:(id)sender
{
    ObjectTableRowView *rowView = (ObjectTableRowView *)[[sender superview] superview];
    VideoBaseInfoEntity *entity = (VideoBaseInfoEntity *)rowView.objectValue;
    if (![[NSFileManager defaultManager] fileExistsAtPath:entity.vDownloadPath]) {
        [self showAlertText:CustomLocalizedString(@"downloadVideoFileNotExist", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
    NSMutableArray *baseInfoArr = [NSMutableArray array];
    NSArray *array = [connection getConnectedIPods];
    for (IMBiPod *ipod in array) {
        if (ipod.infoLoadFinished) {
            IMBBaseInfo *baseInfo = [connection getDeviceByKey:ipod.uniqueKey];
            [baseInfoArr addObject:baseInfo];
        }
    }
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    if ([baseInfoArr count]==1) {
        [ATTracker event:Video_Download action:Automatic_Import actionParams:@"Import" label:LabelNone transferCount:1 screenView:@"Download View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        DownloadCellView *cellView = [rowView viewAtColumn:0];
        IMBBaseInfo *baseInfo = [baseInfoArr objectAtIndex:0];
        IMBiPod *tarIpod = [connection getIPodByKey:baseInfo.uniqueKey];
        [cellView.progessField setStringValue:CustomLocalizedString(@"VideoDownload_Transfer_Waitting", nil)];
        [cellView.transferProgressView startWati];
        entity.downloadState = TransferWait;
        [entity setProgressText:CustomLocalizedString(@"VideoDownload_Transfer_Waitting", nil)];
        entity.tranferprogressValue = 100.0;
        [self startVideoTransfer:entity iPod:tarIpod];
    }else if ([baseInfoArr count]>=2) {
        [ATTracker event:Video_Download action:Manual_Import actionParams:@"Import" label:LabelNone transferCount:1 screenView:@"Download View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [self toDeviceWithSelectArray:baseInfoArr WithView:sender];
    }else{
        [self showAlertText:CustomLocalizedString(@"iTunes_Nothave_toDevices", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
}

- (void)reDownLoad:(id)sender
{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Video_Download action:ReDownload actionParams:@"ReDownload Video" label:LabelNone transferCount:1 screenView:@"Download View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    ObjectTableRowView *rowView = (ObjectTableRowView *)[[sender superview] superview];
    VideoBaseInfoEntity *entity = (VideoBaseInfoEntity *)rowView.objectValue;
    entity.downloadState = Downloading;
//    entity.progressDoubleValue = 0.0;
    [_tableView reloadData];
    [_rightUpDownbgView setBadgeCount:_rightUpDownbgView.badgeCount+1];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            NSMenuItem *item = [_popUpButton selectedItem];
            [self writeDownloadPlist:entity];
            if ([item.representedObject isKindOfClass:[IMBiPod class]]) {
                entity.isToMac = NO;
                [_vdlManager redownloadVideoLocation:[TempHelper getAppDownloadDefaultPath] withVideoEntity:entity];
            }else
            {
                entity.isToMac = YES;
                [_vdlManager redownloadVideoLocation:item.representedObject withVideoEntity:entity ];
            }
        }
    });
}

- (void)cleanlist:(id)sender
{
    if ([_downloadDataSource count] == 0) {
        return;
    }
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    if ([_alertViewController showDeleteConfrimText:CustomLocalizedString(@"VideoDownload_CleanList_Tip", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view] == 1) {
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Video_Download action:CleanList actionParams:@"Clean List History" label:LabelNone transferCount:1 screenView:@"Download View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        NSPredicate *cate = [NSPredicate predicateWithFormat:@"self.downloadState != %d and self.downloadState != %d and self.downloadState != %d and self.downloadState != %d",Downloading,TransferWait,Transfering,TransferPrePare];
        NSArray *array = [_downloadDataSource filteredArrayUsingPredicate:cate];
        [self cleanplist:array];
        [_downloadDataSource removeObjectsInArray:array];
        [self reloadData:YES];
    }
}

//下载完成 直接传输
- (void)transferDownload:(IMBiPod *)iPod Video:(VideoBaseInfoEntity *)video
{
    NSInteger row = [_downloadDataSource indexOfObject:video];
    if (row>=0&&row<[_downloadDataSource count]) {
        ObjectTableRowView *rowView = [_tableView rowViewAtRow:row makeIfNecessary:NO];
        DownloadCellView *cellView = [rowView viewAtColumn:0];
        [cellView.progessField setStringValue:CustomLocalizedString(@"VideoDownload_Transfer_Waitting", nil)];
        [cellView.transferProgressView startWati];
        [video setProgressText:CustomLocalizedString(@"VideoDownload_Transfer_Waitting", nil)];
        video.downloadState = TransferWait;
        video.tranferprogressValue = 100.0;
        [self startVideoTransfer:video iPod:iPod];
    }
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
    IMBToDevicePopoverViewController *toDevicePopVC = [[IMBToDevicePopoverViewController alloc]initWithNibName:@"IMBToDevicePopoverViewController" bundle:nil WithDevice:selectArry];
    toDevicePopVC.needIcon = NO;
    [toDevicePopVC setTarget:self];
    [toDevicePopVC setAction:@selector(onItemClicked:)];
    toDevicePopVC.sender = view;
    if (_toDevicePopover != nil) {
        _toDevicePopover.contentViewController = toDevicePopVC;
    }
    [toDevicePopVC release];
    NSRectEdge prefEdge = NSMinYEdge;
    NSRect rect = NSMakeRect(0, 0,  0, 0);
    [_toDevicePopover showRelativeToRect:rect ofView:view preferredEdge:prefEdge];
}

- (void)onItemClicked:(id)sender {
    IMBBaseInfo *baseInfo = (IMBBaseInfo *)sender;
    [_toDevicePopover close];
    IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
    ObjectTableRowView *rowView = (ObjectTableRowView *)[[((IMBToDevicePopoverViewController *)_toDevicePopover.contentViewController).sender superview] superview];
    VideoBaseInfoEntity *entity = (VideoBaseInfoEntity *)rowView.objectValue;
    DownloadCellView *cellView = [rowView viewAtColumn:0];
    IMBiPod *tarIpod = [connection getIPodByKey:baseInfo.uniqueKey];
    [cellView.progessField setStringValue:CustomLocalizedString(@"VideoDownload_Transfer_Waitting", nil)];
    [cellView.transferProgressView startWati];
    entity.downloadState = TransferWait;
    [entity setProgressText:CustomLocalizedString(@"VideoDownload_Transfer_Waitting", nil)];
    entity.tranferprogressValue = 100.0;
    [self startVideoTransfer:entity iPod:tarIpod];
}

- (void)startVideoTransfer:(VideoBaseInfoEntity *)entity iPod:(IMBiPod *)iPod
{
   [_tableView reloadData];
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        @autoreleasepool {
            entity.downloadState = TransferPrePare;
            OperationLImitation *limit = [OperationLImitation singleton];
            [limit setNeedlimit:NO];
            NSString *musicstr = [MediaHelper getSupportFileTypeArray:Category_Music supportVideo:NO supportConvert:YES withiPod:_ipod];
            NSString *extension = [[entity.vDownloadPath pathExtension] lowercaseString];
            if (iPod.deviceInfo.isIOSDevice) {
                if ([musicstr contains:extension]) {
                    IMBAirSyncImportTransfer *transfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:iPod.uniqueKey importFiles:[NSArray arrayWithObject:entity.vDownloadPath] CategoryNodesEnum:Category_Music photoAlbum:nil playlistID:0 delegate:entity];
                    entity.transferDelegate = self;
                    entity.transfer = transfer;
                    [entity.transfer startTransfer];
                    [transfer release];
                }else{
                    IMBAirSyncImportTransfer *transfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:iPod.uniqueKey importFiles:[NSArray arrayWithObject:entity.vDownloadPath] CategoryNodesEnum:Category_Movies photoAlbum:nil playlistID:0 delegate:entity];
                    entity.transferDelegate = self;
                    entity.transfer = transfer;
                    [entity.transfer startTransfer];
                    [transfer release];
                }
            }else{
                if ([musicstr contains:extension]) {
                    IMBNotAirSyncImportTransfer *transfer  = [[IMBNotAirSyncImportTransfer alloc] initWithIPodkey:iPod.uniqueKey importFiles:[NSArray arrayWithObject:entity.vDownloadPath] CategoryNodesEnum:Category_Music photoAlbum:nil playlistID:0 delegate:entity];
                    entity.transferDelegate = self;
                    entity.transfer = transfer;
                    [entity.transfer startTransfer];
                    [transfer release];
                }else{
                    IMBNotAirSyncImportTransfer *transfer  = [[IMBNotAirSyncImportTransfer alloc] initWithIPodkey:iPod.uniqueKey importFiles:[NSArray arrayWithObject:entity.vDownloadPath] CategoryNodesEnum:Category_Movies photoAlbum:nil playlistID:0 delegate:entity];
                    entity.transferDelegate = self;
                    entity.transfer = transfer;
                    [entity.transfer startTransfer];
                    [transfer release];
                }
            }
            [limit setNeedlimit:YES];
        }
    }];
    entity.operaiton = operation;
    [_operationQueue addOperation:operation];
}

- (void)closeTask:(id)sender
{
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    if ([_alertViewController showDeleteConfrimText:CustomLocalizedString(@"VideoDownload_Stop_Tip", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view]) {
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Video_Download action:Stop_Download actionParams:@"Stop" label:LabelNone transferCount:1 screenView:@"Download View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        ObjectTableRowView *rowView = (ObjectTableRowView *)[[sender superview] superview];
        VideoBaseInfoEntity *entity = (VideoBaseInfoEntity *)rowView.objectValue;
        if (entity.downloadState == Downloading) {
            [entity stopMonitorEntity];
            //TODO:取消下载界面的处理
            entity.downloadState = DownloadFaild;
            [_tableView reloadData];
            //写入下载plist文件
            [self writeDownloadPlist:entity];
            [_rightUpDownbgView setBadgeCount:[_rightUpDownbgView setBadgeCountDecrease]];
//            if (_rightUpDownbgView.badgeCount == 0) {
//                [self addResultView];
//            }
        }
    }
}

- (void)writeDownloadPlist:(VideoBaseInfoEntity *)entity {
    NSString *plistPath = [[TempHelper getAppDownloadDefaultPath] stringByAppendingPathComponent:@"videodownload.plist"];
    NSMutableDictionary *allDic = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        allDic = [[NSMutableDictionary dictionaryWithContentsOfFile:plistPath] retain];
    }else {
        allDic = [[NSMutableDictionary alloc] init];
    }
    NSMutableDictionary *dic = nil;
    if ([allDic.allKeys containsObject:[NSString stringWithFormat:@"%@-%@",entity.vID,entity.vVideoID]]) {
        dic = [[allDic objectForKey:[NSString stringWithFormat:@"%@-%@",entity.vID,entity.vVideoID]] retain];
        if (entity.vThumbnailPath != nil) {
            [dic setObject:entity.vThumbnailPath forKey:@"vThumbnailPath"];
        }else {
            [dic setObject:@"" forKey:@"vThumbnailPath"];
        }
        if (entity.vCachePKLPath != nil) {
            [dic setObject:entity.vCachePKLPath forKey:@"vCachePKLPath"];
        }else {
            [dic setObject:@"" forKey:@"vCachePKLPath"];
        }
        if (entity.vCachePKLBeforePath != nil) {
            [dic setObject:entity.vCachePKLBeforePath forKey:@"vCachePKLBeforePath"];
        }else {
            [dic setObject:@"" forKey:@"vCachePKLBeforePath"];
        }
        if (entity.vDownloadPath != nil) {
            [dic setObject:entity.vDownloadPath forKey:@"vDownloadPath"];
        }else {
            [dic setObject:@"" forKey:@"vDownloadPath"];
        }
        if (entity.downloadState == Downloading) {
            [dic setObject:[NSNumber numberWithInt:DownloadFaild] forKey:@"downloadState"];
        }else {
            [dic setObject:[NSNumber numberWithInt:entity.downloadState] forKey:@"downloadState"];
        }
    }else {
        dic = [[NSMutableDictionary alloc] init];
        if (entity.vID != nil) {
            [dic setObject:entity.vID forKey:@"vID"];
        }else {
            [dic setObject:@"" forKey:@"vID"];
        }
        if (entity.vFormatID != nil) {
            [dic setObject:entity.vFormatID forKey:@"vFormatID"];
        }else {
            [dic setObject:@"" forKey:@"vFormatID"];
        }
        if (entity.vVideoID != nil) {
            [dic setObject:entity.vVideoID forKey:@"vVideoID"];
        }else {
            [dic setObject:@"" forKey:@"vVideoID"];
        }
        if (entity.vName != nil) {
            [dic setObject:entity.vName forKey:@"vName"];
        }else {
            [dic setObject:@"" forKey:@"vName"];
        }
        if (entity.vType != nil) {
            [dic setObject:entity.vType forKey:@"vType"];
        }else {
            [dic setObject:@"" forKey:@"vType"];
        }
        if (entity.vSize != nil) {
            [dic setObject:entity.vSize forKey:@"vSize"];
        }else {
            [dic setObject:@"" forKey:@"vSize"];
        }
        if (entity.vDuration != nil) {
            [dic setObject:entity.vDuration forKey:@"vDuration"];
        }else {
            [dic setObject:@"" forKey:@"vDuration"];
        }
        if (entity.vResolution != nil) {
            [dic setObject:entity.vResolution forKey:@"vResolution"];
        }else {
            [dic setObject:@"" forKey:@"vResolution"];
        }
        if (entity.vResolutionMode != nil) {
            [dic setObject:entity.vResolutionMode forKey:@"vResolutionMode"];
        }else {
            [dic setObject:@"" forKey:@"vResolutionMode"];
        }
        if (entity.vThumbnailPath != nil) {
            [dic setObject:entity.vThumbnailPath forKey:@"vThumbnailPath"];
        }else {
            [dic setObject:@"" forKey:@"vThumbnailPath"];
        }
        if (entity.vCachePKLPath != nil) {
            [dic setObject:entity.vCachePKLPath forKey:@"vCachePKLPath"];
        }else {
            [dic setObject:@"" forKey:@"vCachePKLPath"];
        }
        if (entity.vDownloadPath != nil) {
            [dic setObject:entity.vDownloadPath forKey:@"vDownloadPath"];
        }else {
            [dic setObject:@"" forKey:@"vDownloadPath"];
        }
        if (entity.vCachePKLBeforePath != nil) {
            [dic setObject:entity.vCachePKLBeforePath forKey:@"vCachePKLBeforePath"];
        }else {
            [dic setObject:@"" forKey:@"vCachePKLBeforePath"];
        }
        if (entity.parseURL != nil) {
            [dic setObject:entity.parseURL forKey:@"parseURL"];
        }else {
            [dic setObject:@"" forKey:@"parseURL"];
        }
        [dic setObject:[NSNumber numberWithInt:entity.isMuitlVideo] forKey:@"isMuitlVideo"];
        if (entity.downloadState == Downloading) {
            [dic setObject:[NSNumber numberWithInt:DownloadFaild] forKey:@"downloadState"];
        }else {
            [dic setObject:[NSNumber numberWithInt:entity.downloadState] forKey:@"downloadState"];
        }
        [allDic setObject:dic forKey:[NSString stringWithFormat:@"%@-%@",entity.vID,entity.vVideoID]];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:plistPath error:nil];
    }
    [allDic writeToFile:plistPath atomically:YES];
    [allDic release];
    [dic release];
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    [_toDevicePopover close];
}
#pragma mark - ResultView
- (void)closeResultView:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"fade";
    transition.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:transition forKey:@"an"];
    [_resultView removeFromSuperview];
    [_muresultView removeFromSuperview];
    successCount = 0;
}

- (void)learnMore:(id)sender
{
    //跳转到anytrans主页；
    NSURL *url = nil;
    url = [NSURL URLWithString:CustomLocalizedString(@"Product_Url", nil)];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Video_Download action:ActionNone actionParams:[TempHelper currentSelectionLanguage] label:Click transferCount:0 screenView:@"Download View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
}

#pragma mark - Transfer
- (void)transferPrepareFileStart:(NSString *)file Video:(VideoBaseInfoEntity *)entity
{
    
}

- (void)transferPrepareFileEnd:(VideoBaseInfoEntity *)entity
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger row = [_downloadDataSource indexOfObject:entity];
        ObjectTableRowView *rowView = [_tableView rowViewAtRow:row makeIfNecessary:NO];
        DownloadCellView *cellView = [rowView viewAtColumn:0];
        [cellView.transferProgressView endWait];
        entity.downloadState = Transfering;
        entity.tranferprogressValue = 0.0;
    });
}

- (void)transferTo100:(VideoBaseInfoEntity *)entity
{
    NSInteger row = [_downloadDataSource indexOfObject:entity];
    entity.downloadState = TransferWillFnish;
    ObjectTableRowView *rowView = [_tableView rowViewAtRow:row makeIfNecessary:NO];
    DownloadCellView *cellView = [rowView viewAtColumn:0];
    [cellView.transferProgressView startFinishWait];
}

- (void)transferComplete:(int)successcount TotalCount:(int)totalCount Video:(VideoBaseInfoEntity *)entity
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(successcount),@"successCount",@(totalCount),@"totalCount",entity, @"entity",nil];
    [self performSelectorOnMainThread:@selector(transferComplete:) withObject:dic waitUntilDone:YES];
}
- (void)transferComplete:(NSDictionary *)dic
{
    NSInteger successcount = [[dic objectForKey:@"successCount"] integerValue];
    VideoBaseInfoEntity *entity = [dic objectForKey:@"entity"];
//    NSInteger totalCount = [[dic objectForKey:@"totalCount"] integerValue];
    NSInteger row = [_downloadDataSource indexOfObject:entity];
    ObjectTableRowView *rowView = [_tableView rowViewAtRow:row makeIfNecessary:NO];
    DownloadCellView *cellView = [rowView viewAtColumn:0];
    [cellView.transferProgressView setHidden:YES];
    [cellView.progessField setHidden:YES];
    [cellView.closeTransferButton  setHidden:YES];
    [cellView.transferProgressView endFinishWait];

    if (successcount >= 1) {
        entity.downloadState = TransferFinishSuccess;
    }else{
        entity.downloadState = TransferFinishFail;
    }
    [_tableView reloadData];
}
- (void)closeTransfer:(id)sender
{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Video_Download action:Stop_Transfer actionParams:@"Stop" label:LabelNone transferCount:1 screenView:@"Download View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    ObjectTableRowView *rowView = (ObjectTableRowView *)[[sender superview] superview];
    VideoBaseInfoEntity *entity = (VideoBaseInfoEntity *)rowView.objectValue;
    if (entity.downloadState == TransferWait) {
        [entity.operaiton cancel];
        [self transferComplete:0 TotalCount:1 Video:entity];
    }else if (entity.downloadState == Transfering||entity.downloadState == TransferPrePare)
    {
        [((IMBBaseTransfer *)entity.transfer) setIsStop:YES];
    }
    //传输没有取消
}

- (void)changeSkin:(NSNotification *)notification {
    [(IMBWhiteView *)self.view setNeedsDisplay:YES];
    [_titleView setHasBottomBorder:YES];
    [_titleView setBottomBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_titleView setNeedsDisplay:YES];
    HoverButton *closebutton = [_titleView viewWithTag:10];
    [closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [closebutton setNeedsDisplay:YES];
    
    HoverButton *closebutton1 = [_resultView viewWithTag:200];
    [closebutton1 setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [closebutton1 setNeedsDisplay:YES];
    
    HoverButton *closebutton2 = [_muresultView viewWithTag:201];
    [closebutton2 setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [closebutton2 setNeedsDisplay:YES];
    
    [_titleTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_tableView reloadData];
    _cleanList.font = [NSFont fontWithName:@"Helvetica Neue" size:12.0];
    _cleanList.fontColor = [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)];
    _cleanList.fontEnterColor = [StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)];
    _cleanList.fontDownColor = [StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)];
    [_cleanList setTitle:CustomLocalizedString(@"DownLoadCleanTips", nil)];
    [_noTipTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    
    //英语活动界面
    if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
        //配置文字和图片
        NSString *overStr = nil;
        NSString *promptStr = nil;
        if (_tempCount > 1) {
            overStr = [NSString stringWithFormat:@"%d",_tempCount];
            promptStr = [NSString stringWithFormat:CustomLocalizedString(@"VideosDownLoadCompleteActivity_Tips", nil),overStr];
            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"complete_items", nil)];
        } else if (_tempCount == 1){
            overStr = [NSString stringWithFormat:@"%d",_tempCount];
            promptStr = [NSString stringWithFormat:CustomLocalizedString(@"VideosDownLoadCompleteActivity_Tip", nil),overStr];
            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"complete_item", nil)];
            
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
        
        [_resultSubTitle setStringValue:CustomLocalizedString(@"VideosDownLoadCompleteActivity_Title", nil)];
        [_resultSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
        
        [_imageViewOne setImage:[StringHelper imageNamed:@"media_icon1"]];
        [_imageViewTwo setImage:[StringHelper imageNamed:@"media_icon2"]];
        [_imageViewThree setImage:[StringHelper imageNamed:@"media_icon3"]];
        [_imageViewFour setImage:[StringHelper imageNamed:@"media_icon4"]];
        
        [self setSubTitle:_imageTitleOne WithTextString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_Transfer", nil)];
        [self setSubTitle:_imageTitleTwo WithTextString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_AutoConvert", nil)];
        [self setSubTitle:_imageTitleThree WithTextString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_MoveVideo", nil)];
        [self setSubTitle:_imageTitleFour WithTextString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_MigrateMedia", nil)];
        
        //textview
        [self setTextViewAttribute:_imageSubTitleOne WithString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_Transfer1",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
        [self setTextViewAttribute:_imageSubTitleTwo WithString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_AutoConvert1",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
        [self setTextViewAttribute:_imageSubTitleThree WithString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_MoveVideo1",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
        [self setTextViewAttribute:_imageSubTitleFour WithString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_MigrateMedia1",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
        [self setTextViewAttribute:_bottomTitle WithString:CustomLocalizedString(@"downloadComplete_BottomTitle", nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithAlignment:2 WithFontSize:14.0 WithIsClick:YES];
        [_bottomTitle setDelegate:self];
        [_bottomTitle setSelectable:YES];
        
        
        //按钮加载
        [self setLearnMoreButton:_buttonOne];
        [_buttonOne setAction:@selector(downloadCompleteButtonClickOne)];
        [self setLearnMoreButton:_buttonTwo];
        [_buttonTwo setAction:@selector(downloadCompleteButtonClickTwo)];
        [self setLearnMoreButton:_buttonThree];
        [_buttonThree setAction:@selector(downloadCompleteButtonClickThree)];
        [self setLearnMoreButton:_buttonFour];
        [_buttonFour setAction:@selector(downloadCompleteButtonClickFour)];
        
        //分割线
        [_lineViewOne setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_lineViewTwo setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_lineViewThree setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_lineViewFour setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_lineViewFive setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    } else {
        //配置文字和图片
        NSString *overStr = nil;
        NSString *promptStr = nil;
        if (_tempCount > 1) {
            overStr = [NSString stringWithFormat:@"%d",_tempCount];
            promptStr = [NSString stringWithFormat:CustomLocalizedString(@"VideosDownLoadCompleteActivity_Titles", nil),overStr];
            if ([IMBSoftWareInfo singleton].chooseLanguageType != JapaneseLanguage && [IMBSoftWareInfo singleton].chooseLanguageType != ArabLanguage) {
                overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"VideoDownloadColorTitles", nil)];
            }
        } else if (_tempCount == 1) {
            overStr = [NSString stringWithFormat:@"%d",_tempCount];
            promptStr = [NSString stringWithFormat:CustomLocalizedString(@"VideosDownLoadCompleteActivity_Title", nil),overStr];
            if ([IMBSoftWareInfo singleton].chooseLanguageType != JapaneseLanguage && [IMBSoftWareInfo singleton].chooseLanguageType != ArabLanguage) {
                overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"VideoDownloadColorTitle", nil)];
            }
            
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
        [[_muresultTitle textStorage] setAttributedString:promptAs];
        [mutParaStyle release], mutParaStyle = nil;
        
        [_muresultSubTitle setStringValue:CustomLocalizedString(@"VideosDownLoadCompleteActivity_SubTitle", nil)];
        [_muresultSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
        
        [_muimageViewOne setImage:[StringHelper imageNamed:@"mu_media_icon1"]];
        [_muimageViewTwo setImage:[StringHelper imageNamed:@"mu_media_icon2"]];
        [_muimageViewThree setImage:[StringHelper imageNamed:@"mu_media_icon3"]];
        [_muimageViewFour setImage:[StringHelper imageNamed:@"mu_media_icon4"]];
        
        //四个子标题
        [self setSubTitle:_muimageTitleOne WithTextString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_EnjoyStr", nil)];
        [self setSubTitle:_muimageTitleTwo WithTextString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_AutoStr", nil)];
        [self setSubTitle:_muimageTitleThree WithTextString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_MoveStr", nil)];
        [self setSubTitle:_muimageTitleFour WithTextString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_MigrateStr", nil)];
        
        
        //textview
        [self setTextViewAttribute:_muimageSubTitleOne WithString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_EnjoyStr1",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
        [self setTextViewAttribute:_muimageSubTitleTwo WithString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_AutoStr1",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
        [self setTextViewAttribute:_muimageSubTitleThree WithString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_MoveStr1",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
        [self setTextViewAttribute:_muimageSubTitleFour WithString:CustomLocalizedString(@"VideosDownLoadCompleteActivity_MigrateStr1",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
        
        //按钮加载
        [_muDownloadBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"download_org_normal_rightColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"download_org_normal_leftColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"download_org_enter_rightColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"download_org_enter_leftColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"download_org_down_rightColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"download_org_down_leftColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"download_org_normal_rightColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"download_org_normal_leftColor", nil)]];
        [_muDownloadBtn setButtonTitle:CustomLocalizedString(@"VideosDownLoadCompleteActivity_BuyBtnTitle", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withTitleSize:18.0 WithLightAnimation:NO];
        [_muDownloadBtn setHasRightImage:YES];
        [_muDownloadBtn setRightImage:[StringHelper imageNamed:@"media_btnarrow"]];
        [_muDownloadBtn setHasBorder:NO];
        [_muDownloadBtn setIsiCloudCompleteBtn:NO];
        [_muDownloadBtn setTarget:self];
        [_muDownloadBtn setAction:@selector(downloadCompleteButtonClickOne)];
        [_muDownloadBtn setNeedsDisplay:YES];
        
        //分割线
        [_mulineViewOne setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_mulineViewTwo setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        
        [_muresultView setFrameSize:NSMakeSize(NSWidth(self.view.frame), NSHeight(self.view.frame))];
    }
    
    [_resultView setIsGradientColorNOCornerPart4:YES];
    [_resultView setNeedsDisplay:YES];
    [_muresultView setIsGradientColorNOCornerPart4:YES];
    [_muresultView setNeedsDisplay:YES];
}

- (void)doChangeLanguage:(NSNotification *)notification{
    [_cleanList setTitle:CustomLocalizedString(@"DownLoadCleanTips", nil)];
    [_cleanList setFrameOrigin:NSMakePoint(NSWidth(_cleanList.superview.frame) - NSWidth(_cleanList.frame), NSMinY(_cleanList.frame))];
    [_noTipTextField setStringValue:CustomLocalizedString(@"downloadpageNoDataTips", nil)];
    if ([_dataSourceArray count] <= 1) {
        [_titleTextField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"DownloadListPageBtnCountTip", nil),[_downloadDataSource count]]];
    }else{
        [_titleTextField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"DownloadListPageBtnCountTips", nil),[_downloadDataSource count]]];
    }
    [_tableView reloadData];
}

- (void)reloadBgview {
    [mainBgView setIsGradientColorNOCornerPart4:YES];
    [self.view setNeedsDisplay:YES];
}

- (void)dealloc
{
    [_downloadDataSource release],_downloadDataSource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [super dealloc];
}
@end
