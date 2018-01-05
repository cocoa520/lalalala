//
//  IMBPreferencesButton.h
//  AnyTrans
//
//  Created by long on 16-8-18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBGeneralBtnCell.h"
#import "IMBMyDrawCommonly.h"
@interface IMBPreferencesButton : NSButton
{
    IMBGeneralBtnCell *_btnCell;
    NSString *_buttonName;
    MouseStatusEnum _buttonType;
    NSTrackingArea *_trackingArea;
    NSString *_leftImageName;
    NSString *_middleImageName;
    NSString *_rightImageName;
    BOOL _isDown;
}
- (void)reSetInit:(NSString *)btnName WithPrefixImageName:(NSString *)prefixImageName;
@property (nonatomic, readwrite, retain) NSString *buttonName;
@property (nonatomic, assign) MouseStatusEnum buttonType;
@property (nonatomic, assign) BOOL isDown;
@end
