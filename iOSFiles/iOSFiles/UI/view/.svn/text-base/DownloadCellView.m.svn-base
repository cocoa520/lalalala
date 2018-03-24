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
#import "IMBCommonDefine.h"
#import "ObjectTableRowView.h"
@implementation DownloadCellView
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
@synthesize downLoadDriveItem = _downLoadDriveItem;
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
    [_TypeTextField setBorderColor:COLOR_LINE_WINDOW];
    [_TypeTextField setTextColor:COLOR_TEXT_DISABLE];
    [_DurationTextField setBorderColor:COLOR_LINE_WINDOW];
    [_DurationTextField setTextColor:COLOR_TEXT_DISABLE];
    [_titleField setTextColor:COLOR_TEXT_ORDINARY];
    [_progessField setTextColor:COLOR_BUTTON_SEGDOWN];
    [_finderButton setMouseEnteredImage:[StringHelper imageNamed:@"download_finder2"] mouseExitImage:[StringHelper imageNamed:@"download_finder1"] mouseDownImage:[StringHelper imageNamed:@"download_finder3"]];
    [_deleteButton setMouseEnteredImage:[StringHelper imageNamed:@"download_delete2"] mouseExitImage:[StringHelper imageNamed:@"download_delete1"] mouseDownImage:[StringHelper imageNamed:@"download_delete3"]];
    [_reDownLoad setMouseEnteredImage:[StringHelper imageNamed:@"download_again2"] mouseExitImage:[StringHelper imageNamed:@"download_again1"] mouseDownImage:[StringHelper imageNamed:@"download_again3"]];
    [_progessView setLeftFillColor:COLOR_BUTTON_SEGDOWN];
    [_progessView setRightFillColor:COLOR_DOENLOAD_PROGRESS_RIGHTFILLCOLOR];
    [_transferProgressView setLeftFillColor:PROGRESS_ANIMATION_COLOR];
    [_transferProgressView setRightFillColor:PROGRESS_ANIMATION_COLOR];
    [_transferProgressView setFillimage:[NSImage imageNamed:@"download_process_bg"]];
    
    NSString *cancelStr = CustomLocalizedString(@"downloadpagebtntooltip_id", nil);
    [_downloadButton reSetInit:cancelStr WithPrefixImageName:@"cancal"];
    [_downloadButton setFontSize:12];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:cancelStr]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_ORDINARY range:NSMakeRange(0, cancelStr.length)];
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
    [_DurationTextField setHidden:YES];
    [_downloadFaildField setTextColor:COLOR_DOENLOAD_TRANSFERFAIL_TIPCOLOR];
}

- (void)setDownLoadDriveItem:(DriveItem *)downLoadDriveItem
{
    if (_downLoadDriveItem != downLoadDriveItem) {
        [_downLoadDriveItem release];
        _downLoadDriveItem = [downLoadDriveItem retain];
        [_downLoadDriveItem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    id <DownloadAndUploadDelegate> item = object;
    if (item.state == DownloadStateComplete) {
        [_progessView setHidden:YES];
    }else if (item.state == DownloadStateError){
//        []
    }
}

- (void)adjustSpaceX:(float)x Y:(float)y
{
    [_TypeTextField setHidden:YES];
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
    [COLOR_LINE_WINDOW setStroke];
    [topBorderPath stroke];
}

- (void)dealloc
{
    [_downLoadDriveItem release],_downLoadDriveItem = nil;
    [_propertityViewArray release],_propertityViewArray = nil;
    [_downLoadDriveItem removeObserver:self forKeyPath:@"state"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [super dealloc];
}

@end
