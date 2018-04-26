//
//  LoadingViewTwo.h
//  AllFiles
//
//  Created by hym on 06/04/2018.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LoadingViewTwo : NSView
{
    CALayer *_bgLayer;
    CALayer *_layer1;
    CALayer *_layer2;
    CALayer *_layer3;
    
    float _centerX;
}
- (void)startAnimation;
- (void)endAnimation;
@end
