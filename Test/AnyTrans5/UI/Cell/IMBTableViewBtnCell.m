//
//  IMBTableViewBtnCell.m
//  PhoneRescue
//
//  Created by iMobie on 4/26/16.
//  Copyright (c) 2016 iMobie Inc. All rights reserved.
//

#import "IMBTableViewBtnCell.h"
//#import "IMBColorDefine.h"
#import "StringHelper.h"
@implementation IMBTableViewBtnCell
@synthesize deleteBtn = _deleteBtn;
@synthesize findBtn = _findBtn;
@synthesize isSelected = _isSelected;
//@synthesize exportBtn = _exportBtn;

@synthesize tipText = _tipText;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}



- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    [super drawWithFrame:cellFrame inView:controlView];
        // 当是卸状态的时候需要将卸载按钮弄到界面上
//        int centerSpace = 50;
        int centerX = cellFrame.origin.x+40;

    if ((self.isHighlighted&&controlView == [[controlView window] firstResponder])||_isSelected) {
        [self.findBtn WithMouseExitedtextColor:[NSColor whiteColor] WithMouseUptextColor:[NSColor whiteColor] WithMouseDowntextColor:[NSColor whiteColor] withMouseEnteredtextColor:[NSColor whiteColor]];
        //线的颜色
        [self.findBtn WithMouseExitedLineColor:[NSColor whiteColor] WithMouseUpLineColor:[NSColor whiteColor] WithMouseDownLineColor:[NSColor whiteColor] withMouseEnteredLineColor:[NSColor whiteColor]];
        [self.findBtn WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_enter_bgColor", nil)]];
        
        
//        [self.findBtn  WithMouseExitedtextColor:[NSColor whiteColor] WithMouseUptextColor:[NSColor whiteColor] WithMouseDowntextColor:[NSColor whiteColor] withMouseEnteredtextColor:[NSColor whiteColor]];
//        //线的颜色
//        [self.findBtn  WithMouseExitedLineColor:[NSColor whiteColor] WithMouseUpLineColor:[NSColor whiteColor] WithMouseDownLineColor:[NSColor whiteColor] withMouseEnteredLineColor:[NSColor whiteColor]];
//        [self.findBtn WithMouseExitedfillColor:TableView_Cell_highLight WithMouseUpfillColor:TableView_Cell_highLight WithMouseDownfillColor:TableView_Cell_highLight withMouseEnteredfillColor:TableView_Cell_highLight];
        [self.findBtn setTitleName:CustomLocalizedString(@"backup_id_text_7", nil) WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
        [self.findBtn setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)]];
    }else if (controlView != [[controlView window] firstResponder] &&self.isHighlighted){
        [self.findBtn  WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        //线的颜色
        [self.findBtn  WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [self.findBtn WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_LoseFocusColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_LoseFocusColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_LoseFocusColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_LoseFocusColor", nil)]];
        [self.findBtn setTitleName:CustomLocalizedString(@"backup_id_text_7", nil)  WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
        [self.findBtn setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_LoseFocusColor", nil)]];
    }else{
        [self.findBtn WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        //线的颜色
        [self.findBtn WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
        //填充的颜色
        [self.findBtn WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
        [self.findBtn setTitleName:CustomLocalizedString(@"backup_id_text_7", nil)  WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
        [self.findBtn setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    }
        if (![self.deleteBtn superview]) {
            [self.deleteBtn removeFromSuperview];
            int oringeRight = centerX ;
            [self.deleteBtn setFrameOrigin:NSMakePoint(oringeRight, cellFrame.origin.y + (cellFrame.size.height - self.deleteBtn.frame.size.height) / 2)];
            [controlView addSubview:self.deleteBtn];
        }
        [self.findBtn setNeedsDisplay:YES];
    
        if (![self.findBtn superview]) {
            [self.findBtn removeFromSuperview];
            int oringeCenter = centerX  ;
            [self.findBtn setFrameOrigin:NSMakePoint(oringeCenter, cellFrame.origin.y + (cellFrame.size.height - self.findBtn.frame.size.height) / 2)];
            [controlView addSubview:self.findBtn];
        }
}


@end
