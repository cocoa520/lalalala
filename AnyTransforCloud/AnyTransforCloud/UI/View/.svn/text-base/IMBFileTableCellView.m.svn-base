//
//  IMBFileTable_m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/24.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBFileTableCellView.h"
#import "StringHelper.h"
#import "IMBAllCloudViewController.h"

@implementation IMBFileTableCellView
@synthesize checkButton = _checkButton;
@synthesize fileImageView = _fileImageView;
@synthesize fileName = _fileName;
@synthesize collectionBtn = _collectionBtn;
@synthesize shareBtn = _shareBtn;
@synthesize syncBtn = _syncBtn;
@synthesize moreBtn = _moreBtn;
@synthesize fileSize = _fileSize;
@synthesize fileLastTime = _fileLastTime;
@synthesize fileExtension = _fileExtension;
@synthesize cellRow = _cellRow;

- (void)awakeFromNib {
    //在弹出窗口时，屏蔽详细页面的进入状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableEnterState:) name:DISABLE_ENTER_STATE object:nil];
    
    [_lineView setIsTableViewLine:YES];
    
    [_checkButton setTarget:self];
    [_checkButton setAction:@selector(cellSelectClick:withCellRow:)];
    
    [_collectionBtn setMouseExitedImg:[NSImage imageNamed:@"list_star"] withMouseEnterImg:[NSImage imageNamed:@"list_star2"] withMouseDownImage:[NSImage imageNamed:@"list_star3"] withMouseDisableImage:[NSImage imageNamed:@"list_star4"]];
    [_collectionBtn setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_13", nil)];
    [_collectionBtn setTag:1001];

    [_shareBtn setMouseExitedImg:[NSImage imageNamed:@"list_share"] withMouseEnterImg:[NSImage imageNamed:@"list_share2"] withMouseDownImage:[NSImage imageNamed:@"list_share3"] withMouseDisableImage:[NSImage imageNamed:@"list_share4"]];
    [_shareBtn setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_12", nil)];
    [_shareBtn setTag:1002];
    
    [_syncBtn setMouseExitedImg:[NSImage imageNamed:@"list_sync"] withMouseEnterImg:[NSImage imageNamed:@"list_sync2"] withMouseDownImage:[NSImage imageNamed:@"list_sync3"] withMouseDisableImage:[NSImage imageNamed:@"list_sync4"]];
    [_syncBtn setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_11", nil)];
    [_syncBtn setTag:1003];
    
    [_moreBtn setMouseExitedImg:[NSImage imageNamed:@"list_more"] withMouseEnterImg:[NSImage imageNamed:@"list_more2"] withMouseDownImage:[NSImage imageNamed:@"list_more3"] withMouseDisableImage:[NSImage imageNamed:@"list_more4"]];
    [_moreBtn setToolTip:CustomLocalizedString(@"Menu_MoreCloud_Tips", nil)];
    [_moreBtn setTag:1004];
    
    [_collectionBtn setTarget:self];
    [_collectionBtn setAction:@selector(cellViewButtonClick:)];
    
    [_shareBtn setTarget:self];
    [_shareBtn setAction:@selector(cellViewButtonClick:)];
    
    [_syncBtn setTarget:self];
    [_syncBtn setAction:@selector(cellViewButtonClick:)];
    
    [_moreBtn setTarget:self];
    [_moreBtn setAction:@selector(cellViewButtonClick:)];
    
    [_collectionBtn setHidden:YES];
    [_shareBtn setHidden:YES];
    [_syncBtn setHidden:YES];
    [_moreBtn setHidden:YES];
    
}

- (void)setModel:(IMBDriveModel *)model {
    
    if (model.isFolder) {
        [_syncBtn setMouseExitedImg:[NSImage imageNamed:@"list_sync"] withMouseEnterImg:[NSImage imageNamed:@"list_sync2"] withMouseDownImage:[NSImage imageNamed:@"list_sync3"] withMouseDisableImage:[NSImage imageNamed:@"list_sync4"]];
        [_syncBtn setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_11", nil)];
        [_syncBtn setTag:1003];
        [_syncBtn setTarget:self];
        [_syncBtn setAction:@selector(cellViewButtonClick:)];
        
    } else {
        [_syncBtn setMouseExitedImg:[NSImage imageNamed:@"list_downlaod"] withMouseEnterImg:[NSImage imageNamed:@"list_downlaod2"] withMouseDownImage:[NSImage imageNamed:@"list_downlaod3"] withMouseDisableImage:[NSImage imageNamed:@"list_downlaod4"]];
        [_syncBtn setTag:1005];
        [_syncBtn setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_2", nil)];
        [_syncBtn setTarget:self];
        [_syncBtn setAction:@selector(cellViewButtonClick:)];
    }
    
    _model = model;
    if (model.image) {
        [_fileImageView setImage:model.image];
    }else if (model.transferImage) {
        [_fileImageView setImage:model.transferImage];
    }else {
        [_fileImageView setImage:model.iConimage];
    }
    [_fileName setStringValue:model.displayName];
    if (model.fileSize == 0) {
        [_fileSize setStringValue:@"--"];
    }else {
        [_fileSize setStringValue:[StringHelper getFileSizeString:model.fileSize reserved:2]];
    }
    [_fileLastTime setStringValue:model.lastModifiedDateString];
    [_fileExtension setStringValue:model.extension];
    [self setCheckState:model.checkState];
}

- (void)setCheckState:(CheckStateEnum)checkState {
    [_checkButton setState:checkState];
}

- (void)cellSelectClick:(id)sender withCellRow:(NSInteger)cellRow {
    [_delegate cellCheckButtonClick:sender withCellRow:_cellRow];
}

- (void)cellViewButtonClick:(id)sender {
    IMBToolBarButton *bottomBtn = (IMBToolBarButton *)sender;
    
    int buttonTag = (int)[bottomBtn tag];
    if (buttonTag == 1001) {//收藏
        [_delegate itemStar:_model];
    } else if (buttonTag == 1002) {//分享
        [_delegate itemShare:_model];
    } else if (buttonTag == 1003) {//同步
        [_delegate itemSync:_model];
    } else if (buttonTag == 1004) {//点击更多
        [_delegate cellViewMoreBtn:_model withMoreBtn:bottomBtn];
    } else if (buttonTag == 1005) {//下载
        [_delegate itemDownload:_model];
    }
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
        _trackingArea = nil;
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)drawRect:(NSRect)dirtyRect {
    
    if (_isOpenMenu) {
        [_collectionBtn setHidden:NO];
        [_shareBtn setHidden:NO];
        [_syncBtn setHidden:NO];
        [_moreBtn setHidden:NO];
    } else {
        if ((_buttonType == MouseEnter || _buttonType == MouseDown || _buttonType == MouseUp) && !_isOpenMenu) {
            [_collectionBtn setHidden:NO];
            [_shareBtn setHidden:NO];
            [_syncBtn setHidden:NO];
            [_moreBtn setHidden:NO];
        }else {
            [_collectionBtn setHidden:YES];
            [_shareBtn setHidden:YES];
            [_syncBtn setHidden:YES];
            [_moreBtn setHidden:YES];
        }
    }
    
    float sizeX = 475 *(self.frame.size.width / 972.0);
    float dateX = 640 *(self.frame.size.width / 972.0);
    float extensionX = 858 *(self.frame.size.width / 972.0);
    
    [_fileSize setFrameOrigin:NSMakePoint(sizeX, _fileSize.frame.origin.y)];
    [_fileLastTime setFrameOrigin:NSMakePoint(dateX, _fileLastTime.frame.origin.y)];
    [_fileExtension setFrameOrigin:NSMakePoint(extensionX, _fileExtension.frame.origin.y)];
}

- (void)setIsOpenMenu:(BOOL)isOpenMenu {
    _isOpenMenu = isOpenMenu;
    [self setNeedsDisplay:YES];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    if (!_isDisable && !_model.isForbiddden) {
        if (_buttonType != MouseEnter) {
            _buttonType = MouseEnter;
            [self setNeedsDisplay:YES];
        }
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    if (_buttonType != MouseOut) {
        _buttonType = MouseOut;
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (_buttonType != MouseDown) {
        _buttonType = MouseDown;
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (_buttonType != MouseUp) {
        _buttonType = MouseUp;
        [self setNeedsDisplay:YES];
    }
}

- (void)disableEnterState:(NSNotification *)notification {
    _isDisable = [notification.object boolValue];
}

- (void)dealloc {
    if(_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}

@end
