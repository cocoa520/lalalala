//
//  IMBClickedImageView.h
//  AnyTrans
//
//  Created by LuoLei on 16-12-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBackgroundBorderView.h"
@interface IMBClickedImageView : NSImageView
{
    NSInteger _eventNumber;
    NSTrackingArea *_trackingArea;
    IMBBackgroundBorderView *_maskView;
}
@end
