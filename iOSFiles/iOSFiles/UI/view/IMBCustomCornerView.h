#import <Cocoa/Cocoa.h>


@interface IMBCustomCornerView : NSView {

    NSGradient *_backgroundColorGradient;
}

@property(nonatomic,retain)NSGradient *backgroundColorGradient;
@end
