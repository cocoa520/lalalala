//
//  IMBiCloudButton.h
//  PhoneRescue
//
//  Created by 肖体华 on 14-9-24.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBHoverBtnCell.h"

typedef enum {
    enteredButton = 1,
    exitButton = 2,
    upButton = 3,
    downButton = 4,
} buttonType;


@interface IMBiCloudButton : NSButton{
    NSTrackingArea *_trackingArea;
    NSString *_leftImageName;
    NSString *_middleImageName;
    NSString *_rightImageName;
    
    NSString *_buttonName;
    IMBHoverBtnCell *_btnCell;
    
    buttonType _buttonType;
    BOOL _isTableRowSelected;
    BOOL _isMouseEnter;
}

@property (nonatomic, readwrite, retain) NSString *buttonName;
@property (nonatomic,assign) BOOL isTableRowSelected;
@property (nonatomic,assign) BOOL isMouseEnter;


- (id)initWithFrame:(NSRect)frame WithPrefixImageName:(NSString *)prefixImageName WithButtonName:(NSString *)buttonName;
- (void)getButtonImageName:(NSString *)prefixImageName;

-(NSMutableAttributedString *)attributedTitle:(BOOL)isEntered;
- (void)setButtonNameWithprefixImageName:(NSString *)buttonName prefixImageName:(NSString *)prefixImageName;
- (void)setTablerowSelectRowFontColor;
@end
