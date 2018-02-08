//
//  IMBGuideButton.h
//  AnyTrans
//
//  Created by iMobie on 10/20/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
@interface IMBGuideButton : NSButton {
    NSTrackingArea *_trackingArea;
    NSString *_buttonName;
    BOOL _isChange;
    
//    NSImage *_bgImage;
    NSImage *_arrowImage;
    NSImage *_mouseDownImg;
    NSImage *_mouseEnterImg;
    NSImage *_mouseExiteImg;
    MouseStatusEnum _buttonType;
}

@property (nonatomic, readwrite, retain) NSString *buttonName;
@property (nonatomic, readwrite) BOOL isChange;

- (void)setButtonName:(NSString *)buttonName;
- (id)initWithFrame:(NSRect)frame WithButtonName:(NSString *)buttonName;
- (void)setButtonImage;
- (void)mouseDownImg:(NSImage *)mouseDownImg mouseEnterImg:(NSImage *)mouseEnterImg mouseExiteImg:(NSImage *)mouseExiteImg;
- (void)reSetInit:(NSString *)btnName isChange:(BOOL)isChange;
-(NSMutableAttributedString *)attributedTitle:(BOOL)isEntered;

@end
