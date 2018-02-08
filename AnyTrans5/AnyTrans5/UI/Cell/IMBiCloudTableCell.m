//
//  IMBiCloudTableCell.m
//  PhoneRescue
//
//  Created by 肖体华 on 14-9-26.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBiCloudTableCell.h"
//#import "IMBHelper.h"
#import "IMBCommonEnum.h"
//#import "IMBiCloudDataShowViewController.h"
#import "IMBiCloudDeleteButton.h"
#import "StringHelper.h"
@implementation IMBiCloudTableCell
@synthesize size = _size;
@synthesize curRowIndex = _curRowIndex;
@synthesize selectIndex = _selectIndex;
@synthesize dataArray = _dataArray;
@synthesize bindingEntity = _bindingEntity;
@synthesize isSelected = _isSelected;
@synthesize isDisable = _isDisable;
@synthesize proessStr = _proessStr;
- (BOOL)isHasSubview:(NSView *)view Subview:(NSView *)subView{
    for (NSView *sub in [view subviews]) {
        if (sub == subView) {
            return YES;
        }
    }
    return NO;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{

//    NSColor *fontColor = nil;
//    if (_isSelected) {
//        fontColor = [StringHelper getColorFromString:CustomColor(@"popover_borderColor", nil)];
////        self.bindingEntity.btniCloudCommon.isTableRowSelected = YES;
//    }else{
//        fontColor = [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)];
////        self.bindingEntity.btniCloudCommon.isTableRowSelected = NO;
//    }
    if (_isDisable) {
        return;
    }
    [self.bindingEntity.deleteButton setHidden:YES];
    [self.bindingEntity.showText setHidden:YES];
    [self.bindingEntity.closeDownBtn setHidden:YES];
    [self.bindingEntity.progressView setHidden:YES];
    if (self.bindingEntity.loadType != iCloudDataComplete) {
        [self.bindingEntity.btniCloudCommon setHidden:YES];
    }
    [self.bindingEntity.findPathBtn setHidden:YES];
    if (![self.bindingEntity.showText superview]) {
        [controlView addSubview:self.bindingEntity.showText];
    }
    if (![self.bindingEntity.closeDownBtn superview]) {
        [controlView addSubview:self.bindingEntity.closeDownBtn];
    }
    if (![self.bindingEntity.progressView superview]) {
        [controlView addSubview:self.bindingEntity.progressView];
    }
    if (![self.bindingEntity.btniCloudCommon superview]) {
        [controlView addSubview:self.bindingEntity.btniCloudCommon];
    }
    if (![self.bindingEntity.findPathBtn superview]) {
        [controlView addSubview:self.bindingEntity.findPathBtn];
    }
    if (![self.bindingEntity.deleteButton superview]) {
        [controlView addSubview:self.bindingEntity.deleteButton];
    }
    [self.bindingEntity.showText setFrame:NSMakeRect(NSMaxX(cellFrame) - 160, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.showText.frame.size.height)/2,155, 18)];
    [self.bindingEntity.deleteButton setFrame:NSMakeRect(NSMaxX(cellFrame) - 155, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.deleteButton.frame.size.height)/2 +2, 14, 14)];
    [self.bindingEntity.findPathBtn setFrame:NSMakeRect(NSMaxX(cellFrame) - 130, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.deleteButton.frame.size.height)/2 +2, 14, 14)];
     [self.bindingEntity.progressView setFrame:NSMakeRect(NSMaxX(cellFrame) - 160, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.progressView.frame.size.height)/2,self.bindingEntity.progressView.frame.size.width , 6)];
     [self.bindingEntity.closeDownBtn setFrame:NSMakeRect(NSMaxX(cellFrame) - 40, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.closeDownBtn.frame.size.height)/2, 18, 18)];
    if (_isSelected) {
        if (!self.bindingEntity.isMouseEntered) {
            if (self.bindingEntity.loadType == iCloudDataComplete) {
                
                [self.bindingEntity.btniCloudCommon setFrame:NSMakeRect(NSMaxX(cellFrame) - 155, cellFrame.origin.y  + (cellFrame.size.height - self.bindingEntity.btniCloudCommon.frame.size.height)/2,self.bindingEntity.btniCloudCommon.frame.size.width, 20)];
                
                [self.bindingEntity.btniCloudCommon WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)]];
                //线的颜色
                [self.bindingEntity.btniCloudCommon WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)]WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)]];
                [self.bindingEntity.btniCloudCommon WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)]];
                
                [self.bindingEntity.btniCloudCommon setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)]];
                //            [self.bindingEntity.btniCloudCommon setTablerowSelectRowFontColor];
                
                [controlView addSubview:self.bindingEntity.btniCloudCommon];
                [self.bindingEntity.btniCloudCommon setNeedsDisplay:YES];
//                [self.bindingEntity.showText setFrame:NSMakeRect(NSMaxX(cellFrame) - 155, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.showText.frame.size.height)/2,155, 18)];
//                [self.bindingEntity.showText setTextColor:fontColor];
//                [controlView addSubview:self.bindingEntity.showText];
            }
            if (self.bindingEntity.loadType == iCloudDataWaitingDownLoad){
                [self.bindingEntity.showText setFrame:NSMakeRect(NSMaxX(cellFrame) - 160, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.showText.frame.size.height)/2,155, 18)];
                [self.bindingEntity.showText setTextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)]];
                [self.bindingEntity.showText setHidden:NO];
//                [controlView addSubview:self.bindingEntity.showText];
            }
            if (self.bindingEntity.loadType == iCloudDataDownLoading) {
                [self.bindingEntity.progressView setFrame:NSMakeRect(NSMaxX(cellFrame) - 160, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.progressView.frame.size.height)/2,self.bindingEntity.progressView.frame.size.width , 6)];
                [self.bindingEntity.closeDownBtn setImageWithWithPrefixImageName:@"close_light"];
                [self.bindingEntity.closeDownBtn setFrame:NSMakeRect(NSMaxX(cellFrame) - 40, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.closeDownBtn.frame.size.height)/2, 18, 18)];
                //            [self.bindingEntity.progressView addSubview:self.bindingEntity.deleteButton];
                //        NSString *str= [NSString stringWithFormat:@"%d%@",(int)(progress *100),@"%"];
                NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)], NSForegroundColorAttributeName,
                                            nil];
                
                [_proessStr drawAtPoint:NSMakePoint(NSMaxX(cellFrame)  - 70, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.closeDownBtn.frame.size.height)/2) withAttributes:attributes];
//                [self.bindingEntity.closeDownBtn setNeedsDisplay:YES];
                [self.bindingEntity.closeDownBtn setHidden:NO];
                [self.bindingEntity.progressView setHidden:NO];
//                [controlView addSubview:self.bindingEntity.closeDownBtn];
//                [controlView addSubview:self.bindingEntity.progressView];
            }
            if (self.bindingEntity.loadType == iCloudDataFail) {
                [self.bindingEntity.showText setFrame:NSMakeRect(NSMaxX(cellFrame) - 160
, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.showText.frame.size.height)/2,145, 18)];
                [self.bindingEntity.showText setTextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)]];
//                [controlView addSubview:self.bindingEntity.showText];
                [self.bindingEntity.showText setHidden:NO];
            }
            return;
        }
        
        switch (self.bindingEntity.loadType) {
            case iCLoudDataContinue:{
//                NSLog(@"continnue;");
            }
            case iCloudDataDownLoad:{
                [self.bindingEntity.btniCloudCommon WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)]];
                //线的颜色
                [self.bindingEntity.btniCloudCommon WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)]];
                [self.bindingEntity.btniCloudCommon WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_enter_bgColor", nil)]];
                [self.bindingEntity.btniCloudCommon setFrame:NSMakeRect(NSMaxX(cellFrame) - 155, cellFrame.origin.y  + (cellFrame.size.height - self.bindingEntity.btniCloudCommon.frame.size.height)/2,self.bindingEntity.btniCloudCommon.frame.size.width, 20)];
                
                [self.bindingEntity.btniCloudCommon setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)]];
                //            [self.bindingEntity.btniCloudCommon setTablerowSelectRowFontColor];
                
//                [controlView addSubview:self.bindingEntity.btniCloudCommon];
                [self.bindingEntity.btniCloudCommon setHidden:NO];
                [self.bindingEntity.btniCloudCommon setNeedsDisplay:YES];
            }
                break;
            case iCloudDataWaitingDownLoad:{
                
                [self.bindingEntity.showText setTextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)]];
                [self.bindingEntity.showText setFrame:NSMakeRect(NSMaxX(cellFrame) - 160, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.showText.frame.size.height)/2, 155, 18)];
//                [controlView addSubview:self.bindingEntity.showText];
                [self.bindingEntity.showText setHidden:NO];
                break;
            }
            case iCloudDataDownLoading:{
                [self.bindingEntity.progressView setFrame:NSMakeRect(NSMaxX(cellFrame) - 160, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.progressView.frame.size.height)/2,self.bindingEntity.progressView.frame.size.width , 6)];
                [self.bindingEntity.closeDownBtn setFrame:NSMakeRect(NSMaxX(cellFrame) - 40, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.closeDownBtn.frame.size.height)/2 , 18, 18)];
                //            [self.bindingEntity.progressView addSubview:self.bindingEntity.deleteButton];
                NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)], NSForegroundColorAttributeName,
                                            nil];
                [_proessStr drawAtPoint:NSMakePoint(NSMaxX(cellFrame)  - 70, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.closeDownBtn.frame.size.height)/2) withAttributes:attributes];
                [self.bindingEntity.closeDownBtn setImageWithWithPrefixImageName:@"close_light"];
                
//                [controlView addSubview:self.bindingEntity.closeDownBtn];
//                [controlView addSubview:self.bindingEntity.progressView];
                [self.bindingEntity.closeDownBtn setHidden:NO];
                [self.bindingEntity.progressView setHidden:NO];
                [self.bindingEntity.closeDownBtn setNeedsDisplay:YES];
                break;
            }
            case iCloudDataFail:
            case iCloudDataComplete:{
                [self.bindingEntity.btniCloudCommon WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)]];
                //线的颜色
                [self.bindingEntity.btniCloudCommon WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)]];
                [self.bindingEntity.btniCloudCommon WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_enter_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_enter_bgColor", nil)]];              [self.bindingEntity.btniCloudCommon setFrame:NSMakeRect(NSMaxX(cellFrame) - 155, cellFrame.origin.y  + (cellFrame.size.height - self.bindingEntity.btniCloudCommon.frame.size.height)/2 ,self.bindingEntity.btniCloudCommon.frame.size.width, 20)];
                [self.bindingEntity.btniCloudCommon setHidden:NO];
                [self.bindingEntity.btniCloudCommon setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)]];
                //            [self.bindingEntity.btniCloudCommon setTablerowSelectRowFontColor];
                [self.bindingEntity.btniCloudCommon setNeedsDisplay:YES];
                break;
            }
            case iCloudDataDelete:{
                [self.bindingEntity.deleteButton setFrame:NSMakeRect(NSMaxX(cellFrame) - 155, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.deleteButton.frame.size.height)/2 +2, 14, 14)];
                [self.bindingEntity.findPathBtn setFrame:NSMakeRect(NSMaxX(cellFrame) - 130, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.deleteButton.frame.size.height)/2 +2, 14, 14)];
         
                //            [self.bindingEntity.btniCloudCommon setTablerowSelectRowFontColor];
                [self.bindingEntity.findPathBtn setNeedsDisplay:YES];
                [self.bindingEntity.deleteButton setNeedsDisplay:YES];
                [self.bindingEntity.findPathBtn setNeedsDisplay:YES];
                [self.bindingEntity.deleteButton setNeedsDisplay:YES];
                break;
            }
            case iCloudDataCancelDownLoad:{
                [self.bindingEntity.btniCloudCommon WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)]];
                //线的颜色
                [self.bindingEntity.btniCloudCommon WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)]];
                [self.bindingEntity.btniCloudCommon WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_enter_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_enter_bgColor", nil)]];
                [self.bindingEntity.btniCloudCommon setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)]];
                [self.bindingEntity.btniCloudCommon setFrame:NSMakeRect(NSMaxX(cellFrame) - 155, cellFrame.origin.y  + (cellFrame.size.height - self.bindingEntity.btniCloudCommon.frame.size.height)/2 ,self.bindingEntity.btniCloudCommon.frame.size.width, 20)];
                [self.bindingEntity.btniCloudCommon setHidden:NO];
                //            [self.bindingEntity.btniCloudCommon setTablerowSelectRowFontColor];
                [self.bindingEntity.btniCloudCommon setNeedsDisplay:YES];
                break;
            }
            default:
                break;
        }
    }
    else{
        if (!self.bindingEntity.isMouseEntered) {
            if (self.bindingEntity.loadType == iCloudDataComplete) {

                [self.bindingEntity.btniCloudCommon setFrame:NSMakeRect(NSMaxX(cellFrame) - 155, cellFrame.origin.y  + (cellFrame.size.height - self.bindingEntity.btniCloudCommon.frame.size.height)/2,self.bindingEntity.btniCloudCommon.frame.size.width, 20)];
                [self.bindingEntity.btniCloudCommon WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                //线的颜色
                [self.bindingEntity.btniCloudCommon WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
                [self.bindingEntity.btniCloudCommon WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
                [self.bindingEntity.btniCloudCommon setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
                //            [self.bindingEntity.btniCloudCommon setTablerowSelectRowFontColor];
                [controlView addSubview:self.bindingEntity.closeDownBtn];
                [self.bindingEntity.btniCloudCommon setNeedsDisplay:YES];
                
//                [self.bindingEntity.showText setFrame:NSMakeRect(NSMaxX(cellFrame) - 155, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.showText.frame.size.height)/2,155, 18)];
//                [self.bindingEntity.showText setTextColor:fontColor];
//                [controlView addSubview:self.bindingEntity.showText];
            }
            if (self.bindingEntity.loadType == iCloudDataWaitingDownLoad){
                [self.bindingEntity.showText setFrame:NSMakeRect(NSMaxX(cellFrame) - 160, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.showText.frame.size.height)/2,155, 18)];
                [self.bindingEntity.showText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)]];
//                [controlView addSubview:self.bindingEntity.showText];
                [self.bindingEntity.showText setHidden:NO];
            }
            if (self.bindingEntity.loadType == iCloudDataDownLoading) {
                [self.bindingEntity.progressView setFrame:NSMakeRect(NSMaxX(cellFrame) - 160, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.progressView.frame.size.height)/2,self.bindingEntity.progressView.frame.size.width , 6)];
                [self.bindingEntity.closeDownBtn setFrame:NSMakeRect(NSMaxX(cellFrame) - 40, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.closeDownBtn.frame.size.height)/2, 18, 18)];
                //            [self.bindingEntity.progressView addSubview:self.bindingEntity.deleteButton];
                //        NSString *str= [NSString stringWithFormat:@"%d%@",(int)(progress *100),@"%"];
                NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                            nil];
                [_proessStr drawAtPoint:NSMakePoint(NSMaxX(cellFrame)  - 70, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.closeDownBtn.frame.size.height)/2) withAttributes:attributes];
                [self.bindingEntity.closeDownBtn setImageWithWithPrefixImageName:@"icloudClose"];
               
                
                [self.bindingEntity.closeDownBtn setHidden:NO];
                [self.bindingEntity.progressView setHidden:NO];
                 [self.bindingEntity.closeDownBtn setNeedsDisplay:YES];
            }
            if (self.bindingEntity.loadType == iCloudDataFail) {
                [self.bindingEntity.showText setFrame:NSMakeRect(NSMaxX(cellFrame) - 160
, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.showText.frame.size.height)/2,145, 18)];
                [self.bindingEntity.showText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)]];
                [self.bindingEntity.showText setHidden:NO];
            }
            return;
        }
        
        switch (self.bindingEntity.loadType) {
            case iCLoudDataContinue:{
//                NSLog(@"continnue;");
            }
            case iCloudDataDownLoad:{
                [self.bindingEntity.btniCloudCommon WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                //线的颜色
                [self.bindingEntity.btniCloudCommon WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
                [self.bindingEntity.btniCloudCommon WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"category_enterColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"category_downColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"category_enterColor", nil)]];
                [self.bindingEntity.btniCloudCommon setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];

                [self.bindingEntity.btniCloudCommon setFrame:NSMakeRect(NSMaxX(cellFrame) - 155, cellFrame.origin.y  + (cellFrame.size.height - self.bindingEntity.btniCloudCommon.frame.size.height)/2,self.bindingEntity.btniCloudCommon.frame.size.width, 20)];
                //            [self.bindingEntity.btniCloudCommon setTablerowSelectRowFontColor];
                
                [self.bindingEntity.btniCloudCommon setHidden:NO];
                [self.bindingEntity.btniCloudCommon setNeedsDisplay:YES];
            }
                break;
            case iCloudDataWaitingDownLoad:{
                [self.bindingEntity.showText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)]];
                [self.bindingEntity.showText setFrame:NSMakeRect(NSMaxX(cellFrame) - 160, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.showText.frame.size.height)/2, 145, 18)];
                 [self.bindingEntity.showText setHidden:NO];
                break;
            }
            case iCloudDataDownLoading:{
                [self.bindingEntity.progressView setFrame:NSMakeRect(NSMaxX(cellFrame) - 160, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.progressView.frame.size.height)/2,self.bindingEntity.progressView.frame.size.width , 6)];
                [self.bindingEntity.closeDownBtn setFrame:NSMakeRect(NSMaxX(cellFrame) - 40, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.closeDownBtn.frame.size.height)/2, 18, 18)];
                //            [self.bindingEntity.progressView addSubview:self.bindingEntity.deleteButton];
                NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                            nil];
                [_proessStr drawAtPoint:NSMakePoint(NSMaxX(cellFrame)  - 70, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.closeDownBtn.frame.size.height)/2) withAttributes:attributes];
                [self.bindingEntity.closeDownBtn setImageWithWithPrefixImageName:@"icloudClose"];
                
                [self.bindingEntity.closeDownBtn setHidden:NO];
                [self.bindingEntity.progressView setHidden:NO];
                [self.bindingEntity.closeDownBtn setNeedsDisplay:YES];
                break;
            }
            case iCloudDataFail:
            case iCloudDataComplete:{
                [self.bindingEntity.btniCloudCommon setFrame:NSMakeRect(NSMaxX(cellFrame) - 155, cellFrame.origin.y  + (cellFrame.size.height - self.bindingEntity.btniCloudCommon.frame.size.height)/2,self.bindingEntity.btniCloudCommon.frame.size.width, 20)];
                
                [self.bindingEntity.btniCloudCommon WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                //线的颜色
                [self.bindingEntity.btniCloudCommon WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
                [self.bindingEntity.btniCloudCommon WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"category_enterColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"category_downColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"category_enterColor", nil)]];
                [self.bindingEntity.btniCloudCommon setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
                //            [self.bindingEntity.btniCloudCommon setTablerowSelectRowFontColor];
                
                [self.bindingEntity.btniCloudCommon setHidden:NO];
                [self.bindingEntity.btniCloudCommon setNeedsDisplay:YES];
//                [self.bindingEntity.showText setFrame:NSMakeRect(NSMaxX(cellFrame) - 155, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.showText.frame.size.height)/2,155, 18)];
//                [self.bindingEntity.showText setTextColor:fontColor];
//                [controlView addSubview:self.bindingEntity.showText];
                break;
            }
            case iCloudDataDelete:{
                [self.bindingEntity.findPathBtn setFrame:NSMakeRect(NSMaxX(cellFrame) - 130, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.deleteButton.frame.size.height)/2 +2, 14, 14)];
                [self.bindingEntity.deleteButton setFrame:NSMakeRect(NSMaxX(cellFrame) - 155, cellFrame.origin.y + (cellFrame.size.height - self.bindingEntity.deleteButton.frame.size.height)/2 +2, 14, 14)];
                [self.bindingEntity.findPathBtn setHidden:NO];
                [self.bindingEntity.deleteButton setHidden:NO];
                [self.bindingEntity.deleteButton setNeedsDisplay:YES];
                [self.bindingEntity.findPathBtn setNeedsDisplay:YES];
                break;
            }
            case iCloudDataCancelDownLoad:{
//                [self.bindingEntity.btniCloudCommon WithMouseExitedtextColor:COLOR_TEXT_ORDINARY WithMouseUptextColor:COLOR_TEXT_ORDINARY WithMouseDowntextColor:COLOR_TEXT_ORDINARY withMouseEnteredtextColor:COLOR_TEXT_ORDINARY];
//                [self.bindingEntity.btniCloudCommon WithMouseExitedLineColor:COLOR_TEXT_LINE WithMouseUpLineColor:COLOR_TEXT_LINE WithMouseDownLineColor:COLOR_TEXT_LINE withMouseEnteredLineColor:COLOR_TEXT_LINE];
//                [self.bindingEntity.btniCloudCommon WithMouseExitedfillColor:[NSColor whiteColor] WithMouseUpfillColor:[NSColor whiteColor] WithMouseDownfillColor:COLOR_TEXT_EXPLAIN withMouseEnteredfillColor:[NSColor whiteColor]];
                [self.bindingEntity.btniCloudCommon setFrame:NSMakeRect(NSMaxX(cellFrame) - 155, cellFrame.origin.y  + (cellFrame.size.height - self.bindingEntity.btniCloudCommon.frame.size.height)/2 ,self.bindingEntity.btniCloudCommon.frame.size.width, 20)];
                [self.bindingEntity.btniCloudCommon WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                //线的颜色
                [self.bindingEntity.btniCloudCommon WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
                [self.bindingEntity.btniCloudCommon WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"category_enterColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"category_downColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"category_enterColor", nil)]];
                [self.bindingEntity.btniCloudCommon setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];

                 [self.bindingEntity.btniCloudCommon setHidden:NO];
                //            [self.bindingEntity.btniCloudCommon setTablerowSelectRowFontColor];
                [self.bindingEntity.btniCloudCommon setNeedsDisplay:YES];
                break;
            }
            default:
                break;
        }
    }
 }


- (void)dealloc{
    [super dealloc];
}
@end
