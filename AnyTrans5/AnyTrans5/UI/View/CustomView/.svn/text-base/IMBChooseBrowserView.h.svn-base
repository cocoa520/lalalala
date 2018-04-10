//
//  IMBChooseBrowserView.h
//  AnyTrans
//
//  Created by hym on 25/03/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@interface IMBChooseBrowserView : NSView
{
    NSImage *_image;
    NSString *_title;
    NSTrackingArea *_trackingArea;
    BOOL _isSelected;
    MouseStatusEnum _mouseStatus;
    id _target;
    SEL _action;
    int _tag;
    BOOL _isExist;
}
@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;
@property (nonatomic, assign) int tag;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign)  BOOL isExist;
- (void)setImage:(NSImage *)image withTitle:(NSString *)title;

@end
