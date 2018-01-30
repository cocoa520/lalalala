//
//  IMBHoverButton.h
//  DataRecovery
//
//  Created by iMobie on 5/5/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBHoverBtnCell.h"

typedef enum {
    EnteredButton = 1,
    ExitButton = 2,
    UpButton = 3,
    DownButton = 4,
} ButtonType;

@interface IMBHoverButton : NSButton {
    NSTrackingArea *_trackingArea;
    NSString *_leftImageName;
    NSString *_middleImageName;
    NSString *_rightImageName;

    NSString *_buttonName;
    IMBHoverBtnCell *_btnCell;
    
    ButtonType _buttonType;
}

@property (nonatomic, readwrite, retain) NSString *buttonName;

- (id)initWithFrame:(NSRect)frame WithPrefixImageName:(NSString *)prefixImageName WithButtonName:(NSString *)buttonName;
- (void)getButtonImageName:(NSString *)prefixImageName;

-(NSMutableAttributedString *)attributedTitle:(BOOL)isEntered;

@end
