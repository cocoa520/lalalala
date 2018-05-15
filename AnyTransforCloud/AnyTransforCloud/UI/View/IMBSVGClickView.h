//
//  IMBSVGClickView.h
//  AnyTransforCloud
//
//  Created by hym on 24/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
@interface IMBSVGClickView : NSView
{
    id		_target;
    SEL		_action;
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _mouseState;
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

/**
 *  设置要View显示的SVG图片
 *
 *  @param svgName SVG图片名称
 */
- (void)setSVGImageName:(NSString *)svgName;

@end
