//
//  IMBTransferTipShadowsView.h
//  AnyTransforCloud
//
//  Created by hym on 07/05/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMBCurrencySvgButton;
@interface IMBTransferTipShadowsView : NSView
{
    NSShadow *_shadow;
    NSTextField *_textFiled;
    IMBCurrencySvgButton *_closeBtn;
    NSTrackingArea *_trackingArea;
    id		_target;
    SEL		_action;
}
@property (nonatomic, assign, nullable) id target;
@property (nonatomic, assign, nullable) SEL action;
- (void)setShowString:(nonnull NSString *)str;
@end
