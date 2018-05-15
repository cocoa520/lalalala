//
//  IMBToolBarView.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/25.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBToolBarView.h"
#import "StringHelper.h"
#import "IMBBaseViewController.h"

#define OperationButtonWidth  36
#define OperationButtonHeight 24
#define OperationButtonSeparationWidth 0

@implementation IMBToolBarView

- (void)toolBarButtonIsEnabled:(BOOL)isEnabled {
    [_reload setEnabled:isEnabled];
    [_sync setEnabled:isEnabled];
    [_share setEnabled:isEnabled];
    [_star setEnabled:isEnabled];
    [_rename setEnabled:isEnabled];
    [_copy setEnabled:isEnabled];
    [_move setEnabled:isEnabled];
    [_download setEnabled:isEnabled];
    [_info setEnabled:isEnabled];
    [_switch setEnabled:isEnabled];
    [_upload setEnabled:isEnabled];
    [_createFolder setEnabled:isEnabled];
    [_delete setEnabled:isEnabled];
    
    [_reload setNeedsDisplay:YES];
    [_sync setNeedsDisplay:YES];
    [_share setNeedsDisplay:YES];
    [_star setNeedsDisplay:YES];
    [_rename setNeedsDisplay:YES];
    [_copy setNeedsDisplay:YES];
    [_move setNeedsDisplay:YES];
    [_download setNeedsDisplay:YES];
    [_info setNeedsDisplay:YES];
    [_switch setNeedsDisplay:YES];
    [_upload setNeedsDisplay:YES];
    [_createFolder setNeedsDisplay:YES];
    [_delete setNeedsDisplay:YES];
}

- (void)loadButtons:(NSArray *)FunctionTypeArray Target:(id)Target DisplayMode:(BOOL)displayMode {
    NSArray *array = [NSArray arrayWithArray:self.subviews];
    if (array != nil) {
        for (NSView *view in array) {
            if ([view isKindOfClass:[IMBToolBarButton class]]) {
                [view removeFromSuperview];
            }
        }
    }
    NSMutableArray *buttonsArray = [NSMutableArray array];
    for (NSNumber *number in FunctionTypeArray) {
        switch (number.intValue) {
            case refreshAction:
            {
                if (_reload) {
                    [_reload setTarget:Target];
                    [buttonsArray addObject:_reload];
                }else{
                    _reload =[[IMBToolBarButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_reload setAutoresizesSubviews:YES];
                    [_reload setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_reload setMouseExitedImg:[NSImage imageNamed:@"toolbar_refresh"] withMouseEnterImg:[NSImage imageNamed:@"toolbar_refresh2"] withMouseDownImage:[NSImage imageNamed:@"toolbar_refresh3"] withMouseDisableImage:[NSImage imageNamed:@"toolbar_refresh4"]];
                    [_reload setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_6", nil)];
                    [_reload setTarget:Target];
                    [_reload setAction:@selector(reload:)];
                    [buttonsArray addObject:_reload];
                }
            }
                break;
            case syncAction:
            {
                if (_sync) {
                    [_sync setTarget:Target];
                    [buttonsArray addObject:_sync];
                }else{
                    _sync =[[IMBToolBarButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_sync setAutoresizesSubviews:YES];
                    [_sync setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_sync setMouseExitedImg:[NSImage imageNamed:@"toolbar_sync"] withMouseEnterImg:[NSImage imageNamed:@"toolbar_sync2"] withMouseDownImage:[NSImage imageNamed:@"toolbar_sync3"] withMouseDisableImage:[NSImage imageNamed:@"toolbar_sync4"]];
                    [_sync setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_11", nil)];
                    [_sync setTarget:Target];
                    [_sync setAction:@selector(sync:)];
                    [buttonsArray addObject:_sync];
                }
            }
                break;
            case shareAction:
            {
                if (_share) {
                    [_share setTarget:Target];
                    [buttonsArray addObject:_share];
                }else{
                    _share =[[IMBToolBarButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_share setAutoresizesSubviews:YES];
                    [_share setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_share setMouseExitedImg:[NSImage imageNamed:@"toolbar_share"] withMouseEnterImg:[NSImage imageNamed:@"toolbar_share2"] withMouseDownImage:[NSImage imageNamed:@"toolbar_share3"] withMouseDisableImage:[NSImage imageNamed:@"toolbar_share4"]];
                    [_share setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_12", nil)];
                    [_share setTarget:Target];
                    [_share setAction:@selector(share:)];
                    [buttonsArray addObject:_share];
                }
            }
                break;
            case starAction:
            {
                if (_star) {
                    [_star setTarget:Target];
                    [buttonsArray addObject:_star];
                }else{
                    _star =[[IMBToolBarButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_star setAutoresizesSubviews:YES];
                    [_star setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_star setMouseExitedImg:[NSImage imageNamed:@"toolbar_star"] withMouseEnterImg:[NSImage imageNamed:@"toolbar_star2"] withMouseDownImage:[NSImage imageNamed:@"toolbar_star3"] withMouseDisableImage:[NSImage imageNamed:@"toolbar_star4"]];
                    [_star setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_13", nil)];
                    [_star setTarget:Target];
                    [_star setAction:@selector(star:)];
                    [buttonsArray addObject:_star];
                }
            }
                break;
            case renameAction:
            {
                if (_rename) {
                    [_rename setTarget:Target];
                    [buttonsArray addObject:_rename];
                }else{
                    _rename =[[IMBToolBarButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_rename setAutoresizesSubviews:YES];
                    [_rename setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_rename setMouseExitedImg:[NSImage imageNamed:@"toolbar_rename"] withMouseEnterImg:[NSImage imageNamed:@"toolbar_rename2"] withMouseDownImage:[NSImage imageNamed:@"toolbar_rename3"] withMouseDisableImage:[NSImage imageNamed:@"toolbar_rename4"]];
                    [_rename setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_5", nil)];
                    [_rename setTarget:Target];
                    [_rename setAction:@selector(rename:)];
                    [buttonsArray addObject:_rename];
                }
            }
                break;
            case copyAction:
            {
                if (_copy) {
                    [_copy setTarget:Target];
                    [buttonsArray addObject:_copy];
                }else{
                    _copy =[[IMBToolBarButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_copy setAutoresizesSubviews:YES];
                    [_copy setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_copy setMouseExitedImg:[NSImage imageNamed:@"toolbar_copy"] withMouseEnterImg:[NSImage imageNamed:@"toolbar_copy2"] withMouseDownImage:[NSImage imageNamed:@"toolbar_copy3"] withMouseDisableImage:[NSImage imageNamed:@"toolbar_copy4"]];
                    [_copy setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_9", nil)];
                    [_copy setTarget:Target];
                    [_copy setAction:@selector(copy:)];
                    [buttonsArray addObject:_copy];
                }
            }
                break;
            case moveAction:
            {
                if (_move) {
                    [_move setTarget:Target];
                    [buttonsArray addObject:_move];
                }else{
                    _move =[[IMBToolBarButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_move setAutoresizesSubviews:YES];
                    [_move setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_move setMouseExitedImg:[NSImage imageNamed:@"toolbar_move"] withMouseEnterImg:[NSImage imageNamed:@"toolbar_move2"] withMouseDownImage:[NSImage imageNamed:@"toolbar_move3"] withMouseDisableImage:[NSImage imageNamed:@"toolbar_move4"]];
                    [_move setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_14", nil)];
                    [_move setTarget:Target];
                    [_move setAction:@selector(move:)];
                    [buttonsArray addObject:_move];
                }
            }
                break;
            case downloadAction:
            {
                if (_download) {
                    [_download setTarget:Target];
                    [buttonsArray addObject:_download];
                }else{
                    _download =[[IMBToolBarButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_download setAutoresizesSubviews:YES];
                    [_download setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_download setMouseExitedImg:[NSImage imageNamed:@"toolbar_download"] withMouseEnterImg:[NSImage imageNamed:@"toolbar_download2"] withMouseDownImage:[NSImage imageNamed:@"toolbar_download3"] withMouseDisableImage:[NSImage imageNamed:@"toolbar_download4"]];
                    [_download setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_2", nil)];
                    [_download setTarget:Target];
                    [_download setAction:@selector(download:)];
                    [buttonsArray addObject:_download];
                }
            }
                break;
            case infoAction:
            {
                if (_info) {
                    [_info setTarget:Target];
                    [buttonsArray addObject:_info];
                }else{
                    _info =[[IMBToolBarButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_info setAutoresizesSubviews:YES];
                    [_info setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_info setMouseExitedImg:[NSImage imageNamed:@"toolbar_info"] withMouseEnterImg:[NSImage imageNamed:@"toolbar_info2"] withMouseDownImage:[NSImage imageNamed:@"toolbar_info3"] withMouseDisableImage:[NSImage imageNamed:@"toolbar_info4"]];
                    [_info setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_15", nil)];
                    [_info setTarget:Target];
                    [_info setAction:@selector(showDetailView:)];
                    [buttonsArray addObject:_info];
                }
            }
                break;
            case deleteAction:
            {
                if (_delete) {
                    [_delete setTarget:Target];
                    [buttonsArray addObject:_delete];
                }else{
                    _delete =[[IMBToolBarButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_delete setAutoresizesSubviews:YES];
                    [_delete setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_delete setMouseExitedImg:[NSImage imageNamed:@"toolbar_delete"] withMouseEnterImg:[NSImage imageNamed:@"toolbar_delete2"] withMouseDownImage:[NSImage imageNamed:@"toolbar_delete3"] withMouseDisableImage:[NSImage imageNamed:@"toolbar_delete4"]];
                    [_delete setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_4", nil)];
                    [_delete setTarget:Target];
                    [_delete setAction:@selector(deleteFile:)];
                    [buttonsArray addObject:_delete];
                }
            }
                break;
            case switchAction:
            {
                if (_switch) {
                    if (!displayMode) {
                        [_switch setMouseExitedImg:[NSImage imageNamed:@"toolbar_sort"] withMouseEnterImg:[NSImage imageNamed:@"toolbar_sort2"] withMouseDownImage:[NSImage imageNamed:@"toolbar_sort3"] withMouseDisableImage:[NSImage imageNamed:@"toolbar_sort4"]];
                    } else {
                        [_switch setMouseExitedImg:[NSImage imageNamed:@"toolbar_img"] withMouseEnterImg:[NSImage imageNamed:@"toolbar_img2"] withMouseDownImage:[NSImage imageNamed:@"toolbar_img3"] withMouseDisableImage:[NSImage imageNamed:@"toolbar_img4"]];
                    }
                    [_switch setTarget:Target];
                    [buttonsArray addObject:_switch];
                }else{
                    _switch =[[IMBToolBarButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_switch setAutoresizesSubviews:YES];
                    [_switch setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    if (!displayMode) {
                        [_switch setMouseExitedImg:[NSImage imageNamed:@"toolbar_sort"] withMouseEnterImg:[NSImage imageNamed:@"toolbar_sort2"] withMouseDownImage:[NSImage imageNamed:@"toolbar_sort3"] withMouseDisableImage:[NSImage imageNamed:@"toolbar_sort4"]];
                    } else {
                        [_switch setMouseExitedImg:[NSImage imageNamed:@"toolbar_img"] withMouseEnterImg:[NSImage imageNamed:@"toolbar_img2"] withMouseDownImage:[NSImage imageNamed:@"toolbar_img3"] withMouseDisableImage:[NSImage imageNamed:@"toolbar_img4"]];
                    }
                    [_switch setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_16", nil)];
                    [_switch setTarget:Target];
                    [_switch setAction:@selector(doSwitchView:)];
                    [buttonsArray addObject:_switch];
                }
            }
                break;
            case uploadAction:
            {
                if (_upload) {
                    [_upload setTarget:Target];
                    [buttonsArray addObject:_upload];
                }else{
                    _upload =[[IMBToolBarButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_upload setAutoresizesSubviews:YES];
                    [_upload setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_upload setMouseExitedImg:[NSImage imageNamed:@"toolbar_add"] withMouseEnterImg:[NSImage imageNamed:@"toolbar_add2"] withMouseDownImage:[NSImage imageNamed:@"toolbar_add3"] withMouseDisableImage:[NSImage imageNamed:@"toolbar_add4"]];
                    [_upload setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_3", nil)];
                    [_upload setTarget:Target];
                    [_upload setAction:@selector(upload:)];
                    [buttonsArray addObject:_upload];
                }
            }
                break;
            case createFolder:
            {
                if (_createFolder) {
                    [_createFolder setTarget:Target];
                    [buttonsArray addObject:_createFolder];
                }else{
                    _createFolder =[[IMBToolBarButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_createFolder setAutoresizesSubviews:YES];
                    [_createFolder setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_createFolder setMouseExitedImg:[NSImage imageNamed:@"toolbar_newfolder"] withMouseEnterImg:[NSImage imageNamed:@"toolbar_newfolder2"] withMouseDownImage:[NSImage imageNamed:@"toolbar_newfolder3"] withMouseDisableImage:[NSImage imageNamed:@"toolbar_newfolder4"]];
                    [_createFolder setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_7", nil)];
                    [_createFolder setTarget:Target];
                    [_createFolder setAction:@selector(createFolder:)];
                    [buttonsArray addObject:_createFolder];
                }
            }
                break;
            case preViewAction:
            {
                if (_preView) {
                    [_preView setTarget:Target];
                    [buttonsArray addObject:_preView];
                }else{
                    _preView =[[IMBToolBarButton alloc]initWithFrame:NSMakeRect(0, 0, OperationButtonWidth, OperationButtonHeight)];
                    [_preView setAutoresizesSubviews:YES];
                    [_preView setAutoresizingMask:NSViewMaxYMargin|NSViewMinXMargin];
                    [_preView setMouseExitedImg:[NSImage imageNamed:@"toolbar_icon_preview"] withMouseEnterImg:[NSImage imageNamed:@"toolbar_icon_preview"] withMouseDownImage:[NSImage imageNamed:@"toolbar_icon_preview"] withMouseDisableImage:[NSImage imageNamed:@"toolbar_icon_preview"]];
                    [_preView setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_22", nil)];
                    [_preView setTarget:Target];
                    [_preView setAction:@selector(preViewFile:)];
                    [buttonsArray addObject:_preView];
                }
            }
                break;
        }
    }
    for (int i=0;i<[buttonsArray count];i++) {
        IMBToolBarButton *button = [buttonsArray objectAtIndex:i];
        float ox = NSWidth(self.frame) - ([buttonsArray count] - i)*OperationButtonWidth - ([buttonsArray count] - (i+1))*OperationButtonSeparationWidth;
        ox = ox - 14;
        [button setFrameOrigin:NSMakePoint(ox, (NSHeight(self.frame) - OperationButtonHeight)/2)];
        [self addSubview:button];
    }
}

@end
