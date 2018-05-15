//
//  IMBTransferProgressView.m
//  AnyTransforCloud
//
//  Created by hym on 06/05/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBTransferProgressView.h"
#import "StringHelper.h"
@implementation IMBTransferProgressView
@synthesize isDownLoad = _isDownLoad;
-(void)awakeFromNib {
    [self setFocusRingType:NSFocusRingTypeNone];
    [self setWantsLayer:YES];
    _arcLayer = [[CAShapeLayer alloc] init];
    
    _arcLayer.fillColor = [[NSColor clearColor] CGColor];
    _arcLayer.strokeColor = [StringHelper getColorFromString:CustomColor(@"transfer_progress_fillColor", nil)].CGColor;
    _arcLayer.lineWidth = 2.0;
    _arcLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:_arcLayer];
    _progress = 0.0;

}

- (void)setProgress:(double)progress {
    if (progress > 100) {
        progress = 100;
    }
    if (progress > _progress) {
       _progress = progress;
    }
    double pro = _progress;
    if (pro > 1) {
        pro = pro / 100.0;
    }
    double angle = 0;
    if (pro == 1) {
        angle = 0.501 * M_PI;
    }else {
        angle = (1 - pro + 0.25) * M_PI * 2;
    };
    [self setFillPathAngle:angle];
}

- (void)reInitProgress {
    _progress = 0;
    [self setProgress:0];
}

- (void)drawLineAnimation:(CALayer*)layer {
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=1.0;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1.0];
    [layer addAnimation:bas forKey:@"key"];
}

- (void)setFillPathAngle:(double)angle {
     CGMutablePathRef fillPath = CGPathCreateMutable();
    CGPathAddArc(fillPath, NULL, self.bounds.size.width/2, self.bounds.size.height/2, 10, 0.5 * M_PI, angle, YES);
    _arcLayer.path= fillPath;
//    [self drawLineAnimation:_arcLayer];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRect:dirtyRect];
    [clipPath setWindingRule:NSEvenOddWindingRule];
    [clipPath addClip];
    [[NSColor clearColor] set];
    [clipPath fill];
    [clipPath closePath];

    NSPoint radiusPoint = NSMakePoint(12, 12);
    NSPoint beginPoint = NSMakePoint(12, 22);
    NSPoint endPoint = NSMakePoint(12, 22);
    
    float radiusValue = 10;//自定义;
    float beginAngle = 90;//自定义;
    float endAngle = 89;
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setLineWidth:1.0];
    [path moveToPoint:endPoint];
    [path lineToPoint:beginPoint];
    [path appendBezierPathWithArcWithCenter:radiusPoint radius:radiusValue startAngle:beginAngle endAngle:endAngle clockwise:NO];
    [path closePath];
    
    [[StringHelper getColorFromString:CustomColor(@"progress_bgColor", nil)] set];
    [path stroke];
    
    NSImage *image = [NSImage imageNamed:@"transfer_upload"];
    if (_isDownLoad) {
        image = [NSImage imageNamed:@"transfer_download"];
    }
    [image drawInRect:NSMakeRect(ceil((self.bounds.size.width - image.size.width)/2.0), ceil((self.bounds.size.height - image.size.height)/2.0), image.size.width, image.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}
- (void)dealloc {
    if (_arcLayer) {
        [_arcLayer release];
        _arcLayer = nil;
    }
    [super dealloc];
}

@end
