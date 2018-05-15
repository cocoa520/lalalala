//
//  IMBOutlineTriangleView.h
//  AnyTransforCloud
//
//  Created by hym on 01/05/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
@interface IMBOutlineTriangleView : NSView
{
    showTypeEnum _showType;
    CALayer *_loadImageLayer;
    
    id		_target;
    SEL		_action;
}
@property (nonatomic, assign) showTypeEnum showType;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@end
