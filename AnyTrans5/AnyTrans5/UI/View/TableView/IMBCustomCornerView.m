
#import "IMBCustomCornerView.h"
#import "IMBCustomHeaderCell.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
@implementation IMBCustomCornerView
@synthesize backgroundColorGradient = _backgroundColorGradient;
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
        NSArray* colorArray = [NSArray arrayWithObjects:
                               [StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)],
                               [StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)],
                               [StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)],
                               nil];
        _backgroundColorGradient = [[[NSGradient alloc] initWithColors:colorArray] retain];
    }
    return self;
}

- (void)changeSkin:(NSNotification *)notification
{

    if (_backgroundColorGradient != nil) {
        [_backgroundColorGradient release];
        _backgroundColorGradient = nil;
    }
    NSArray* colorArray = [NSArray arrayWithObjects:
                           [StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)],
                           [StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)],
                           [StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)],
                           nil];
    _backgroundColorGradient = [[[NSGradient alloc] initWithColors:colorArray] retain];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect {
    [_backgroundColorGradient drawInRect:rect angle:90.0];
	
	NSGraphicsContext* gc = [NSGraphicsContext currentContext];
	[gc saveGraphicsState];
	[gc setShouldAntialias:NO];
	
	NSBezierPath* path = [NSBezierPath bezierPath];
	[path setLineWidth:1.0];
	NSPoint p = NSMakePoint(rect.origin.x , rect.origin.y+2.0);
	[path moveToPoint:p];
	
	p.y += rect.size.height-2.0;
	[path moveToPoint:p];
	p.x += rect.size.width;
	[path lineToPoint:p];
    [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setStroke];
    [path stroke];
	NSBezierPath* path1 = [NSBezierPath bezierPath];
	p = NSMakePoint(rect.origin.x , rect.origin.y+1.0);
	[path1 moveToPoint:p];
	p.x += rect.size.width;
	[path1 lineToPoint:p];
	
	 [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setStroke];
    [path1 stroke];
	
	[gc restoreGraphicsState];
	

}

- (void)setBackgroundColorGradient:(NSGradient *)backgroundColorGradient {
    if (_backgroundColorGradient != backgroundColorGradient) {
        _backgroundColorGradient = [backgroundColorGradient retain];
    }
}

- (BOOL)isFlipped
{
	return YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [_backgroundColorGradient release],_backgroundColorGradient = nil;
    [super dealloc];
}
@end
