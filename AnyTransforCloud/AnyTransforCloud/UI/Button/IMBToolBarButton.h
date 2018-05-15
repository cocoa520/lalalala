//
//  IMBToolBarButton.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/25.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@interface IMBToolBarButton : NSButton {
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _mouseType;
    NSPoint _curEventPoint;
    
    NSImage *_mouseExitedImage;
    NSImage *_mouseEnteredImage;
    NSImage *_mouseDownImage;
    NSImage *_mouseDisableImage;
}
@property (nonatomic, retain) NSImage *mouseExitedImage;
/**
 *  0为listView  1为collectionView
 */
@property (nonatomic, assign) int switchBtnState;
@property (nonatomic, assign) NSPoint curEventPoint;

/**
 *  设置按钮图片属性
 *
 *  @param mouseExiteImg 正常显示图片
 *  @param mouseEnterImg 进入显示图片
 *  @param mouseDownImg  点击显示图片
 *  @param mouseDisableImg 禁用显示图片
 */
- (void)setMouseExitedImg:(NSImage *)mouseExiteImg withMouseEnterImg:(NSImage *)mouseEnterImg withMouseDownImage:(NSImage*)mouseDownImg withMouseDisableImage:(NSImage*)mouseDisableImg;

@end
