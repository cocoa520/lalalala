//
//  IMBSkinButton.h
//  AnyTrans
//
//  Created by iMobie on 10/20/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
#import "IMBGeneralBtnCell.h"

@interface IMBSkinButton : NSButton {
    NSTrackingArea *_trackingArea;
    NSString *_leftImageName;
    NSString *_middleImageName;
    NSString *_rightImageName;
    NSString *_buttonName;
    IMBGeneralBtnCell *_btnCell;
    
    MouseStatusEnum _buttonType;
    BOOL _isChange;
    
    NSImage *_applyImage;
    NSImage *_downloadImage;
    NSImage *_downloadEnterImage;
    NSImage *_disableImage;
    NSString *_skinName;
}

@property (nonatomic, readwrite, retain) NSString *buttonName;
@property (nonatomic, readwrite) BOOL isChange;
@property (nonatomic, readwrite, retain) IMBGeneralBtnCell *btnCell;
@property (nonatomic, readwrite, retain) NSString *skinName;

- (void)setButtonName:(NSString *)buttonName;
- (id)initWithFrame:(NSRect)frame WithPrefixImageName:(NSString *)prefixImageName WithButtonName:(NSString *)buttonName;
- (void)setButtonImageName:(NSString *)prefixImageName;
- (void)reSetInit:(NSString *)btnName WithPrefixImageName:(NSString *)prefixImageName;
-(NSMutableAttributedString *)attributedTitle:(BOOL)isEntered;

@end
