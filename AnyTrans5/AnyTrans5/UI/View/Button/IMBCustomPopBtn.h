//
//  IMBCustomPopBtn.h
//  AnyTrans
//
//  Created by smz on 17/10/19.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBWhiteView.h"

@interface IMBCustomPopBtn : NSPopUpButton {
    
    BOOL _hasMinWidth;//是否有最小宽度
    float _minWidth;
    float _fontSize;
    float _titleSpaceWidth;//标题与图标之间的间隙宽度
    float _btnHeight;
    BOOL _hasBorder;
    NSColor *_titleColor;
    NSColor *_borderColor;
    BOOL _hasMaxWidth;//是否有最大宽度
    float _maxWidth;
    NSImage *_arrowImage;
    float _normalWidth;
    NSString *_displayedTitle;
    float _tempSpace;
    float _arrowSpace;
    BOOL _isAlertView;
    BOOL _isBackupTime;
    id _delegete;
}
@property (nonatomic,assign) BOOL hasMinWidth;
@property (nonatomic,assign) float minWidth;
@property (nonatomic,assign) float fontSize;
@property (nonatomic,assign) float titleSpaceWidth;
@property (nonatomic,assign) float btnHeight;
@property (nonatomic,assign) BOOL hasBorder;
@property (nonatomic,retain) NSColor *titleColor;
@property (nonatomic,retain) NSColor *borderColor;
@property (nonatomic,assign) BOOL hasMaxWidth;
@property (nonatomic,assign) float maxWidth;
@property (nonatomic,retain) NSImage *arrowImage;
@property (nonatomic,assign) float normalWidth;
@property (nonatomic,assign) float arrowSpace;
@property (nonatomic,assign) BOOL isAlertView;
@property (nonatomic,assign) BOOL isBackupTime;
@property (nonatomic,assign) id delegete;
@end
