//
//  IMBCheckBtn.h
//  iMobieTrans
//
//  Created by iMobie on 3/20/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "IMBCommonEnum.h"

@interface IMBCheckButton :NSButton {
    CAShapeLayer *_checkLayer;      ///打勾动画使用
    CAShapeLayer *_semiLayer;
}

@end
