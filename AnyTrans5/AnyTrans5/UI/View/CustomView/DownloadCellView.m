//
//  DownloadCellView.m
//  AnyTrans
//
//  Created by LuoLei on 16-12-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "DownloadCellView.h"
#import "StringHelper.h"
#import "TempHelper.h"
#import "IMBNotificationDefine.h"
@implementation DownloadCellView
@synthesize sizeTextField = _sizeTextField;
@synthesize resolutionTextField = _resolutionTextField;
@synthesize DurationTextField = _DurationTextField;
@synthesize TypeTextField = _TypeTextField;
@synthesize icon = _icon;
@synthesize finderButton = _finderButton;
@synthesize toDeviceButton = _toDeviceButton;
@synthesize deleteButton = _deleteButton;
@synthesize progessField = _progessField;
@synthesize progessView = _progessView;
@synthesize downloadButton = _downloadButton;
@synthesize titleField = _titleField;
@synthesize propertityViewArray = _propertityViewArray;
@synthesize closeButton = _closeButton;
@synthesize transferProgressView = _transferProgressView;
@synthesize closeTransferButton = _closeTransferButton;
@synthesize transferResultField = _transferResultField;
@synthesize transferResultImageView = _transferResultImageView;
@synthesize reDownLoad = _reDownLoad;
@synthesize downloadFaildField = _downloadFaildField;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [_TypeTextField setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_TypeTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    [_sizeTextField setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_sizeTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    [_resolutionTextField setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_resolutionTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    [_DurationTextField setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_DurationTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    [_titleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_progessField setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    [_finderButton setMouseEnteredImage:[StringHelper imageNamed:@"download_finder2"] mouseExitImage:[StringHelper imageNamed:@"download_finder1"] mouseDownImage:[StringHelper imageNamed:@"download_finder3"]];
    [_toDeviceButton setMouseEnteredImage:[StringHelper imageNamed:@"download_toDevice2"] mouseExitImage:[StringHelper imageNamed:@"download_toDevice1"] mouseDownImage:[StringHelper imageNamed:@"download_toDevice3"]];
    [_deleteButton setMouseEnteredImage:[StringHelper imageNamed:@"download_delete2"] mouseExitImage:[StringHelper imageNamed:@"download_delete1"] mouseDownImage:[StringHelper imageNamed:@"download_delete3"]];
    [_reDownLoad setMouseEnteredImage:[StringHelper imageNamed:@"download_again2"] mouseExitImage:[StringHelper imageNamed:@"download_again1"] mouseDownImage:[StringHelper imageNamed:@"download_again3"]];
    [_progessView setLeftFillColor:[StringHelper getColorFromString:CustomColor(@"download_progres_leftFillColor", nil)]];
    [_progessView setRightFillColor:[StringHelper getColorFromString:CustomColor(@"download_progres_rightFillColor", nil)]];
    [_transferProgressView setLeftFillColor:[StringHelper getColorFromString:CustomColor(@"progress_animation_Color", nil)]];
    [_transferProgressView setRightFillColor:[StringHelper getColorFromString:CustomColor(@"progress_animation_Color", nil)]];
    [_transferProgressView setFillimage:[StringHelper imageNamed:@"download_process_bg"]];
    
    NSString *cancelStr = CustomLocalizedString(@"downloadpagebtntooltip_id", nil);
    [_downloadButton reSetInit:cancelStr WithPrefixImageName:@"cancal"];
    [_downloadButton setFontSize:12];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:cancelStr]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_downloadButton setAttributedTitle:attributedTitles];
    [_downloadButton setIsReslutVeiw:YES];
    [_downloadButton setTarget:self];
    NSRect rect1 = [TempHelper calcuTextBounds:cancelStr fontSize:14];
    [_downloadButton setFrameSize:NSMakeSize((int)rect1.size.width + 20, _downloadButton.frame.size.height)];
    [_closeButton setMouseEnteredImage:[StringHelper imageNamed:@"icloudClose2"] mouseExitImage:[StringHelper imageNamed:@"icloudClose1"] mouseDownImage:[StringHelper imageNamed:@"icloudClose3"]];
    [_closeTransferButton setMouseEnteredImage:[StringHelper imageNamed:@"icloudClose2"] mouseExitImage:[StringHelper imageNamed:@"icloudClose1"] mouseDownImage:[StringHelper imageNamed:@"icloudClose3"]];
    _propertityViewArray = [[NSMutableArray alloc] init];
    [_TypeTextField setHidden:YES];
    [_sizeTextField setHidden:YES];
    [_resolutionTextField setHidden:YES];
    [_DurationTextField setHidden:YES];
    [_downloadFaildField setTextColor:[StringHelper getColorFromString:CustomColor(@"download_transferFail_tipColor", nil)]];
}

- (void)adjustSpaceX:(float)x Y:(float)y
{
    [_TypeTextField setHidden:YES];
    [_sizeTextField setHidden:YES];
    [_resolutionTextField setHidden:YES];
    [_DurationTextField setHidden:YES];
    NSView *preView = nil;
    for (int i=0;i<[_propertityViewArray count]; i++) {
        NSView *view = [_propertityViewArray objectAtIndex:i];
        [view setHidden:NO];
        if (i==0) {
            [view setFrameOrigin:NSMakePoint(x, y)];
        }else {
            [view setFrameOrigin:NSMakePoint(preView.frame.origin.x+NSWidth(preView.frame) + 12, y)];
        }
        preView = view;
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
    NSBezierPath *topBorderPath = [NSBezierPath bezierPath];
    [topBorderPath setLineWidth:1.0];
    [topBorderPath moveToPoint:NSMakePoint(0, 0)];
    [topBorderPath lineToPoint:NSMakePoint(dirtyRect.size.width, 0)];
    [[NSColor clearColor] setStroke];
    [topBorderPath stroke];
    [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setStroke];
    [topBorderPath stroke];
}

- (void)changeSkin:(NSNotification *)noti {
    [_TypeTextField setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_TypeTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    [_TypeTextField setNeedsDisplay:YES];
    [_sizeTextField setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_sizeTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    [_sizeTextField setNeedsDisplay:YES];
    [_resolutionTextField setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_resolutionTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    [_resolutionTextField setNeedsDisplay:YES];
    [_DurationTextField setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_DurationTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    [_DurationTextField setNeedsDisplay:YES];
    [_titleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_progessField setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    [_finderButton setMouseEnteredImage:[StringHelper imageNamed:@"download_finder2"] mouseExitImage:[StringHelper imageNamed:@"download_finder1"] mouseDownImage:[StringHelper imageNamed:@"download_finder3"]];
    [_finderButton setNeedsDisplay:YES];
    [_toDeviceButton setMouseEnteredImage:[StringHelper imageNamed:@"download_toDevice2"] mouseExitImage:[StringHelper imageNamed:@"download_toDevice1"] mouseDownImage:[StringHelper imageNamed:@"download_toDevice3"]];
    [_toDeviceButton setNeedsDisplay:YES];
    [_deleteButton setMouseEnteredImage:[StringHelper imageNamed:@"download_delete2"] mouseExitImage:[StringHelper imageNamed:@"download_delete1"] mouseDownImage:[StringHelper imageNamed:@"download_delete3"]];
    [_deleteButton setNeedsDisplay:YES];
    [_reDownLoad setMouseEnteredImage:[StringHelper imageNamed:@"download_again2"] mouseExitImage:[StringHelper imageNamed:@"download_again1"] mouseDownImage:[StringHelper imageNamed:@"download_again3"]];
    [_reDownLoad setNeedsDisplay:YES];
    [_progessView setLeftFillColor:[StringHelper getColorFromString:CustomColor(@"download_progres_leftFillColor", nil)]];
    [_progessView setRightFillColor:[StringHelper getColorFromString:CustomColor(@"download_progres_rightFillColor", nil)]];
    [_progessView setNeedsDisplay:YES];
    [_transferProgressView setLeftFillColor:[StringHelper getColorFromString:CustomColor(@"progress_animation_Color", nil)]];
    [_transferProgressView setRightFillColor:[StringHelper getColorFromString:CustomColor(@"progress_animation_Color", nil)]];
    [_transferProgressView setFillimage:[StringHelper imageNamed:@"download_process_bg"]];
    [_transferProgressView setNeedsDisplay:YES];
    [_downloadButton setButtonImageName:@"cancal"];
    NSString *cancelStr = CustomLocalizedString(@"downloadpagebtntooltip_id", nil);
    [_downloadButton reSetInit:cancelStr WithPrefixImageName:@"cancal"];
    [_downloadButton setFontSize:12];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:cancelStr]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_downloadButton setAttributedTitle:attributedTitles];
     NSRect rect1 = [TempHelper calcuTextBounds:cancelStr fontSize:14];
    [_downloadButton setFrameSize:NSMakeSize((int)rect1.size.width + 20, _downloadButton.frame.size.height)];
    [_downloadButton setNeedsDisplay:YES];
    [_closeButton setMouseEnteredImage:[StringHelper imageNamed:@"icloudClose2"] mouseExitImage:[StringHelper imageNamed:@"icloudClose1"] mouseDownImage:[StringHelper imageNamed:@"icloudClose3"]];
    [_closeTransferButton setMouseEnteredImage:[StringHelper imageNamed:@"icloudClose2"] mouseExitImage:[StringHelper imageNamed:@"icloudClose1"] mouseDownImage:[StringHelper imageNamed:@"icloudClose3"]];
    [_downloadFaildField setTextColor:[StringHelper getColorFromString:CustomColor(@"download_transferFail_tipColor", nil)]];
    [self setNeedsDisplay:YES];
}

- (void)doChangeLanguage:(NSNotification *)noti {
    [_downloadButton setTitle:CustomLocalizedString(@"downloadpagebtntooltip_id", nil)];
    [_downloadButton setButtonName:CustomLocalizedString(@"downloadpagebtntooltip_id", nil)];
    
    NSString *cancelStr = CustomLocalizedString(@"downloadpagebtntooltip_id", nil);
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:cancelStr]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_downloadButton setAttributedTitle:attributedTitles];
    NSRect rect1 = [TempHelper calcuTextBounds:cancelStr fontSize:14];
    [_downloadButton setFrameSize:NSMakeSize((int)rect1.size.width + 20, _downloadButton.frame.size.height)];
    [_downloadButton setNeedsDisplay:YES];
}

- (void)dealloc
{
    [_propertityViewArray release],_propertityViewArray = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [super dealloc];
}

@end
