  //
//  IMBMoveAlertViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-15.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBMoveAlertViewController.h"
#import "IMBAnimation.h"
#import "IMBDriveModel.h"
#import "IMBBorderRectAndColorView.h"
#import "StringHelper.h"
#import "IMBBaseManager.h"
#import "TempHelper.h"
#import "IMBOutlineCellView.h"
#import "IMBOutlineView.h"
#import "IMBGridientButton.h"
#import "IMBWhiteView.h"
#import "IMBCanClickText.h"
#import "IMBTableRowView.h"
#import "IMBScrollView.h"
@implementation IMBMoveAlertViewController


- (void)awakeFromNib {
    _isLoading = NO;
}

- (void)dealloc{
    [super dealloc];

}

- (void)showMoveDestinationWith:(IMBBaseManager *)baseManager SuperView:(NSView *)superView withSeletedAyM:(NSMutableArray *)seletedArM isMove:(BOOL)isMove MoveBlock:(MoveBlock)block {
    _selectedAryM = [[NSMutableArray alloc] init];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [superView setWantsLayer:YES];
    _mainView = superView;
    [self loadAlertView:superView alertView:_moveAlertView];
    [_moveAlertView setIsAlertView:YES];
    [_moveAlertView setNeedsDisplay:YES];
    [_outLineView setFocusRingType:NSFocusRingTypeNone];
    [_outLineView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleRegular];
    _baseManager = [baseManager retain];
    _rootItem = [[IMBDriveModel alloc] init];
    _rootItem.itemIDOrPath = @"0";
    _rootItem.fileName = baseManager.baseDrive.driveName;
    IMBCloudEntity *entity = [[IMBCloudEntity alloc] init];
    [TempHelper setDriveDefultImage:_baseManager.baseDrive CloudEntity:entity];
    _rootItem.iConimage = entity.image;
    [entity release], entity = nil;
    
    [_scrollView setListener:_outLineView];
    
    [_okBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_leftColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_rightColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_leftColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_rightColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_leftColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_rightColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_leftColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_rightColor", nil)]];
    [_okBtn setButtonTitle:CustomLocalizedString(@"Button_Ok", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withTitleSize:12.0 WithLightAnimation:NO];
    [_outLineView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];

    [_cancelBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_normal_FillColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_normal_FillColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_enter_leftColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_enter_rightColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_down_leftColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_down_rightColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_forbiden_FillColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_forbiden_FillColor", nil)]];
    [_cancelBtn setButtonBorder:YES withNormalBorderColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_normal_borderColor", nil)] withEnterBorderColor:[NSColor clearColor] withDownBorderColor:[NSColor clearColor] withForbiddenBorderColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_forbiden_borderColor", nil)] withBorderLineWidth:1.0];
    [_cancelBtn setButtonTitle:CustomLocalizedString(@"Button_Cancel", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withTitleSize:12.0 WithLightAnimation:NO];
    
    [_mainTitle setStringValue:CustomLocalizedString(@"MoveFileWindowTitle", nil)];
    [_mainTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_borderView setHasCorner:YES];
    [_borderView setCornerRadius:3];
    [_borderView setBorderColor:[StringHelper getColorFromString:CustomColor(@"tableView_enter_color", nil)]];
    
    [_textView setNormalString:CustomLocalizedString(@"SyncFilesControl_Help", nil) WithLinkString1:CustomLocalizedString(@"SyncFilesControl_Help", nil)  WithLinkString2:CustomLocalizedString(@"SyncFilesControl_Help", nil)  WithNormalColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [_textView setEditable:NO];
    [_outLineView reloadData];
    [self changeDriveState:_rootItem];
    _isMove = isMove;
    [_selectedAryM addObjectsFromArray:seletedArM];
    _block = [block copy];
}

- (void)changeDriveState:(IMBDriveModel *)model {
    if (!_isLoading) {
        if (model.showType == loadingType) {
            _currentModel = model;
            [_baseManager setDelegate:self];
            _isLoading = YES;
            [_baseManager recursiveDirectoryContentsDics:model.itemIDOrPath];
        }else if (model.showType == expandType) {
            [_outLineView collapseItem:model collapseChildren:NO];
            model.showType = collapseType;
        }else if (model.showType == collapseType) {
            if (!model.hasLoadchid) {
                _currentModel = model;
                model.showType = loadingType;
                [_baseManager setDelegate:self];
                _isLoading = YES;
                [_baseManager recursiveDirectoryContentsDics:model.itemIDOrPath];
            }else {
                [_outLineView expandItem:model expandChildren:NO];
                model.showType = expandType;
            }
        }
    }
}

- (void)loadDriveDataFail:(ActionTypeEnum)typeEnum {
    _currentModel.hasLoadchid = NO;
    _currentModel.showType = expandType;
    _isLoading = NO;
}
    //获取数据成功
- (void)loadDriveComplete:(NSMutableArray *_Nonnull)ary WithEvent:(ActionTypeEnum)typeEnum {
    for (IMBDriveModel *model in ary) {
        if (model.fileTypeEnum == Folder) {
            if (_isMove) {
                BOOL flag = NO;
                for (IMBDriveModel *item in _selectedAryM) {
                    NSString *modelStr = [NSString stringWithFormat:@"%@",model.itemIDOrPath];
                    NSString *itemStr = [NSString stringWithFormat:@"%@",item.itemIDOrPath];
                    if ([modelStr isEqualToString:itemStr]) {
                        flag = YES;
                    }
                }
                if (!flag) {
                    [_currentModel.children  addObject:model];
                }
            }else {
                [_currentModel.children  addObject:model];
            }
        }
    }
    _currentModel.hasLoadchid = YES;
    if (ary.count > 0) {
        _currentModel.showType = expandType;
    } else {
        _currentModel.showType = nodataType;
    }
    
    [_outLineView expandItem:_currentModel expandChildren:NO];
    _isLoading = NO;
}

#pragma mark - outlineview delegate、datasource方法
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(nullable id)item {
     return (item == nil) ? 1 : [item numberOfChildren];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(nullable id)item {
      return (item == nil) ? _rootItem : [(IMBDriveModel *)item childAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return (item == nil) ? YES : ([item numberOfChildren] != -1);
}

- (nullable NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(nullable NSTableColumn *)tableColumn item:(id)item {
    IMBOutlineCellView *cellView = [outlineView makeViewWithIdentifier:@"OutlineCell" owner:self];
    IMBDriveModel *entity = (IMBDriveModel *)item;
    [cellView setModel:entity];
    [cellView setDelegate:self];
     return cellView;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    [_okBtn setEnabled:YES];
}

- (nullable NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(id)item {
    IMBTableRowView *tableRowView = [outlineView makeViewWithIdentifier:@"rowView" owner:self];
    if (tableRowView == nil) {
        tableRowView = [[[IMBTableRowView alloc] init] autorelease];
        tableRowView.identifier = @"rowView";
        [tableRowView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleRegular];
    }
    return tableRowView;
}

#pragma mark - cancle、ok点击事件
- (IBAction)clickCancel:(id)sender {
    IMBGridientButton *btn = (IMBGridientButton *)sender;
    NSEvent *event = nil;
    [btn mouseExited:event];
    [self unloaddoubleVerificaAlertView];
}

- (IBAction)clickOk:(id)sender {
    IMBDriveModel *model = [_outLineView itemAtRow:[_outLineView selectedRow]];
    _block(model);
    Block_release(_block);
    _block = nil;
    [_selectedAryM release], _selectedAryM = nil;
    IMBGridientButton *btn = (IMBGridientButton *)sender;
    NSEvent *event = nil;
    [btn mouseExited:event];
    [self unloaddoubleVerificaAlertView];
}

- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex {
    return YES;
    
}

#pragma mark - 弹出框动画
- (void)loadAlertView:(NSView *)view alertView:(IMBBorderRectAndColorView *)alertView {
    [self setupAlertRect:alertView];
    if (![self.view.subviews containsObject:alertView]) {
        [self.view addSubview:alertView];
    }
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CABasicAnimation *animation = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:- (_moveAlertView.frame.size.height - 10)] repeatCount:1];
        animation.beginTime = CACurrentMediaTime();
        [alertView.layer addAnimation:animation forKey:@"moveY"];
    } completionHandler:^{
        [alertView.layer removeAnimationForKey:@"moveY"];
        [alertView setFrame:NSMakeRect(ceil((NSMaxX(view.bounds) - NSWidth(alertView.frame)) / 2), NSMaxY(view.bounds) - NSHeight(alertView.frame) + 10 , NSWidth(alertView.frame), NSHeight(alertView.frame))];
    }];
}

- (void)setupAlertRect:(IMBBorderRectAndColorView *)alertView {
    [alertView setBackground:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    NSRect rect = [alertView frame];
    [alertView setWantsLayer:YES];
    [alertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - NSWidth(rect)) / 2), NSMaxY(self.view.bounds), NSWidth(rect), NSHeight(rect))];
}

- (void)unloaddoubleVerificaAlertView {
//    NSString *str = @"open";
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [_moveAlertView.layer addAnimation:[IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:_moveAlertView.frame.size.height] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [_moveAlertView.layer removeAnimationForKey:@"moveY"];
        [_moveAlertView removeFromSuperview];
        [_moveAlertView setFrame:NSMakeRect(ceil((NSMaxX(_mainView.bounds) - _moveAlertView.frame.size.width) / 2), NSMaxY(_mainView.bounds), _moveAlertView.frame.size.width, _moveAlertView.frame.size.height)];
        [self.view removeFromSuperview];
    }];
}

@end
