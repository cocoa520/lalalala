//
//  IMBGeneralButton.h
//  PhoneClean
//
//  Created by iMobie on 6/17/15.
//  Copyright (c) 2015 imobie.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
#import "IMBGeneralBtnCell.h"
@interface IMBGeneralButton : NSButton {
    NSTrackingArea *_trackingArea;
    NSString *_leftImageName;
    NSString *_middleImageName;
    NSString *_rightImageName;
    NSString *_buttonName;
    IMBGeneralBtnCell *_btnCell;
    
    MouseStatusEnum _buttonType;
    float _size;
    NSImage *_defaultImage;
    NSImage *_disableImage;
    BOOL _isChange;
    BOOL _isCompleteView;
    BOOL _isBigBtn;
    BOOL _isBackupSettingView;
    BOOL _isRegisteredView;
    BOOL _isReslutVeiw;
    
    NSImage *_bgImage;
    NSInteger _evNum;
    NSMutableDictionary *_dic;
    NSColor *_disableColor;
}
@property (nonatomic, assign) BOOL isRegisteredView;
@property (nonatomic, assign) BOOL isBackupSettingView;
@property (nonatomic, assign) BOOL isBigBtn;
@property (nonatomic, assign) BOOL isCompleteView;
@property (nonatomic, readwrite, retain) NSString *buttonName;
@property (nonatomic, readwrite) BOOL isChange;
@property (nonatomic, readwrite) BOOL isReslutVeiw;
@property (nonatomic, readwrite, retain) IMBGeneralBtnCell *btnCell;
@property (nonatomic, readwrite, retain) NSImage *bgImage;
@property (nonatomic, retain) NSMutableDictionary *dic;
@property (nonatomic, retain) NSColor *disableColor;

- (void)setButtonName:(NSString *)buttonName;
- (id)initWithFrame:(NSRect)frame WithPrefixImageName:(NSString *)prefixImageName WithButtonName:(NSString *)buttonName;
- (void)setButtonImageName:(NSString *)prefixImageName;
- (void)setIconImageName:(NSString *)iconName;
- (void)reSetInit:(NSString *)btnName WithPrefixImageName:(NSString *)prefixImageName;
- (void)setFontSize:(float)size;
-(NSMutableAttributedString *)attributedTitle:(BOOL)isEntered;

@end
