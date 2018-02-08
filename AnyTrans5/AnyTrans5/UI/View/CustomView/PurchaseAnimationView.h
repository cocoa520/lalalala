//
//  PurchaseAnimationView.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/28.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CALayer+Animation.h"
@interface PurchaseAnimationView : NSView
{
    CALayer *_bgLayer;
    CALayer *_bgimageLayer1; //背景图层
    CALayer *_bgimageLayer2; //背景图层
    CALayer *_carLayer;
    CALayer *_backwheelLayer;
    CALayer *_frontwheelLayer;
    CALayer *_groundLayer;
    CALayer *_lineLayer1;
    CALayer *_lineLayer2;
    CALayer *_maskLayer;
    CALayer *_envelopeBackground;
    CALayer *_envelopeLayer1;
    CALayer *_envelopeLayer2;
    CALayer *_categoryLayer;
    int _state;
}

- (void)setAnimationState:(int)state;
@end
