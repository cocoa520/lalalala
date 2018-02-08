//
//  IMBPopupButton.h
//  NewMacTestApp
//
//  Created by iMobie on 5/29/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBWhiteView.h"
#define OPENSHEETNOTIFICATION @"open_sheet_notification"
#define SHEETRESULTRETURNEDNOTIFICATION @"sheet_result_returned_notification"

@protocol InternalLayoutChange <NSObject>

@optional
//弹出按钮框架发生变化
- (void)popupButtonFrameChanged:(id)sender;
//文本框框架发生变化
- (void)textFieldFrameChanged:(id)sender;
//块视图中子视图框架发生变化
- (void)subviewsInBlockFrameChanged:(id)sender;
//总内容视图中块视图框架发生变化
- (void)blocksInContentFrameChanged:(id)sender;
//
- (void)removedFromSuperView:(id)sender;

- (void)emptyItemInBlockViewHasEdit:(id)sender;

- (void)emptyFieldInItemViewHasEdit:(id)sender;

@end


@interface IMBPopupButton : NSPopUpButton{
    NSArray *_titlesArr;
    float _alignmentRightOriginx;
    float _maxTitleWidth;
    id _delegate;
    id _bindingEntity;
    NSString *_bindingEntityKeyPath;
    NSArray *_defaultlabelArr;
    BOOL firstSet;
    
    IMBWhiteView *_arrBgView;
    NSImageView *_arrImageView;
    BOOL _hasBorderLine;
    BOOL _noMaxWidth;
    @public
    NSString *_lastDisplayedTitle;
    BOOL _isEditView;
    BOOL _isAirBackup;
}
@property (nonatomic,assign) BOOL isAirBackup;
@property (nonatomic,assign) BOOL isEditView;
@property(nonatomic,setter = setTitlesArr:,retain) NSArray *titlesArr;
@property(nonatomic,setter = setAlignmentRightOriginx:) float alignmentRightOriginx;
@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) float maxTitleWidth;
@property (nonatomic,retain) id bindingEntity;
@property (nonatomic,retain) NSString *bindingEntityKeyPath;
@property (nonatomic, assign) BOOL hasBorderLine;
@property (nonatomic, assign) BOOL noMaxWidth;
- (void)setAlignmentRightOriginx:(float)alignmentRightOriginx;
- (void)setTitlesArr:(NSArray *)titlesArr;
- (void)resizeRect;
+ (CGFloat)calcuateTextWidth:(NSString *)text;
@end
