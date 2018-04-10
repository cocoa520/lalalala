//
//  IMBAlertViewController.m
//  iOSFiles
//
//  Created by smz on 18/3/28.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBAlertViewController.h"
#import "IMBCommonDefine.h"
#import "IMBAnimation.h"
#import "IMBDriveEntity.h"
#import "IMBImageAndTextFieldCell.h"
#import "IMBiCloudDriverViewController.h"

@implementation IMBAlertViewController
@synthesize delegete = _delegete;

#pragma mark - 窗口下拉和收回
//窗口下拉
- (void)loadAlertView:(NSView *)view alertView:(IMBBorderRectAndColorView *)alertView {
    [alertView setBackground:[NSColor whiteColor]];
    NSRect rect = [alertView frame];
    [alertView setWantsLayer:YES];
    [alertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - NSWidth(rect)) / 2), NSMaxY(self.view.bounds), NSWidth(rect), NSHeight(rect))];
    
    if (![self.view.subviews containsObject:alertView]) {
        [self.view addSubview:alertView];
    }
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [alertView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-alertView.bounds.size.height + 10]  repeatCount:0] forKey:@"moveY"];
    } completionHandler:^{
        [alertView.layer removeAnimationForKey:@"moveY"];
        [alertView setFrame:NSMakeRect(ceil((NSMaxX(view.bounds) - NSWidth(alertView.frame)) / 2), NSMaxY(view.bounds) - NSHeight(alertView.frame) + 10, NSWidth(alertView.frame), NSHeight(alertView.frame))];
    }];
    
}

//窗口收回
- (void)unloadAlertView:(IMBBorderRectAndColorView *)alertView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [alertView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:alertView.frame.size.height] repeatCount:1] forKey:@"moveY"];
        } completionHandler:^{
            [alertView.layer removeAnimationForKey:@"moveY"];
            [alertView setFrame:NSMakeRect(ceil((NSMaxX(_mainView.bounds) - alertView.frame.size.width) / 2), NSMaxY(_mainView.bounds), alertView.frame.size.width, alertView.frame.size.height)];
            [alertView removeFromSuperview];
            [self.view removeFromSuperview];
            [_mainView setHidden:YES];
        }];
    });
}

#pragma mark - 传输失败的详情-弹框
- (void)showSelectFolderAlertViewWithSuperView:(NSView *)superView WithFolderArray:(NSMutableArray *)folderArray {
    if (_folderArray != nil) {
        [_folderArray release];
        _folderArray = nil;
    }
    _folderArray = [[NSMutableArray alloc] initWithArray:folderArray];
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    
    [self loadAlertView:superView alertView:_selectFolderAlertView];
    
    [_selectFolderAlertDetailView setBackgroundColor:[NSColor clearColor]];
    [_selectFolderAlertDetailView setFocusRingType:NSFocusRingTypeNone];
    [_selectFolderAlertDetailView reloadData];
    
    [_selectFolderAlertView setBackground:[NSColor whiteColor]];
    [_backgroundBorderView setBackgroundColor:[NSColor clearColor]];
    [_backgroundBorderView setIsDrawFrame:YES];
    [_selectFolderAlertView setNeedsDisplay:YES];
    
    [_selectFolderAlertTitle setStringValue:CustomLocalizedString(@"MoveFileWindowTitle", nil)];
    [_selectFolderAlertTitle setTextColor:COLOR_TEXT_ORDINARY];
    
    //按钮样式
    [_selectFolderAlertOKBtn setIsNoGridient:YES];
    [_selectFolderAlertOKBtn setNormalFillColor:COLOR_OKBTN_NORMAL WithEnterFillColor:COLOR_OKBTN_ENTER WithDownFillColor:COLOR_OKBTN_DOWN];
    [_selectFolderAlertOKBtn setButtonTitle:CustomLocalizedString(@"Button_Ok", nil) withNormalTitleColor:COLOR_View_NORMAL withEnterTitleColor:COLOR_View_NORMAL withDownTitleColor:COLOR_View_NORMAL withForbiddenTitleColor:COLOR_View_NORMAL withTitleSize:14.0 WithLightAnimation:NO];
    [_selectFolderAlertOKBtn setTarget:self];
    [_selectFolderAlertOKBtn setAction:@selector(clickOKSelectFolderAlertView:)];
    
    [_selectFolderAlertCancelBtn setIsNoGridient:YES];
    [_selectFolderAlertCancelBtn setNormalFillColor:COLOR_CANCELBTN_NORMAL WithEnterFillColor:COLOR_CANCELBTN_ENTER WithDownFillColor:COLOR_CANCELBTN_DOWN];
    [_selectFolderAlertCancelBtn setButtonTitle:CustomLocalizedString(@"Button_Cancel", nil) withNormalTitleColor:COLOR_TEXT_ORDINARY withEnterTitleColor:COLOR_TEXT_ORDINARY withDownTitleColor:COLOR_TEXT_ORDINARY withForbiddenTitleColor:COLOR_TEXT_ORDINARY withTitleSize:14.0 WithLightAnimation:NO];
    [_selectFolderAlertCancelBtn setButtonBorder:YES withNormalBorderColor:COLOR_BTNBORDER_NORMAL withEnterBorderColor:COLOR_BTNBORDER_ENTER withDownBorderColor:COLOR_BTNBORDER_DOWN withForbiddenBorderColor:COLOR_BTNBORDER_NORMAL withBorderLineWidth:1];
    [_selectFolderAlertCancelBtn setTarget:self];
    [_selectFolderAlertCancelBtn setAction:@selector(cancelSelectFolderAlertView:)];
    
}

#pragma mark - 点击OK进行传输
- (void)clickOKSelectFolderAlertView:(id)sender {
    if (_curEntity) {
        [_delegete startMoveTransferWith:_curEntity];
        
        [self unloadAlertView:_selectFolderAlertView];
    }
}

#pragma mark - 关闭 selectFolderAlertView
- (void)cancelSelectFolderAlertView:(id)sender {
    [self unloadAlertView:_selectFolderAlertView];
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_folderArray.count > 0) {
        return _folderArray.count;
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return @"";
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([[tableColumn identifier] isEqualToString:@"ImageText"]) {
        IMBImageAndTextFieldCell *curCell = (IMBImageAndTextFieldCell *)cell;
        id item = [_folderArray objectAtIndex:row];
        if ([item isKindOfClass:[IMBDriveEntity class]]) {
            IMBDriveEntity *fileEntity = (IMBDriveEntity *)item;
            [curCell setImageSize:NSMakeSize(24, 18)];
            curCell.image = fileEntity.image;
            curCell.imageText = fileEntity.fileName;
            [curCell setIsDataImage:YES];
            curCell.marginX = 12;
        }else {
            SimpleNode *node = (SimpleNode *)item;
            [curCell setImageSize:NSMakeSize(24, 18)];
            curCell.image = node.image;
            curCell.imageText = node.fileName;
            [curCell setIsDataImage:YES];
            curCell.marginX = 12;
        }
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 40;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = [notification.object selectedRow];
    if (_folderArray.count <= 0 || _folderArray == nil) {
        return ;
    }
    if (row < 0 || row >= _folderArray.count) {
        row = 0;
    }
    _curEntity = [_folderArray objectAtIndex:row];
}

#pragma mark - 单个按钮的警告框
- (void)showAlertText:(NSString *)alertText WithButtonTitle:(NSString *)buttonTitle WithSuperView:(NSView *)superView {
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadAlertView:superView alertView:_warningAlertView];
    
    [_warnAlertImage setImage:[StringHelper imageNamed:@"alert_icon"]];

    //文本样式
    [_warningTextField setStringValue:alertText];
    [_warningTextField setTextColor:COLOR_TEXT_ORDINARY];
    
    //按钮样式
    [_okBtn setIsNoGridient:YES];
    [_okBtn setNormalFillColor:COLOR_OKBTN_NORMAL WithEnterFillColor:COLOR_OKBTN_ENTER WithDownFillColor:COLOR_OKBTN_DOWN];
    [_okBtn setButtonTitle:buttonTitle withNormalTitleColor:COLOR_View_NORMAL withEnterTitleColor:COLOR_View_NORMAL withDownTitleColor:COLOR_View_NORMAL withForbiddenTitleColor:COLOR_View_NORMAL withTitleSize:14.0 WithLightAnimation:NO];
    
    [_okBtn setTarget:self];
    [_okBtn setAction:@selector(okBtnOperation:)];
}
- (void)okBtnOperation:(id)sender {
    [self unloadAlertView:_warningAlertView];
}

@end
