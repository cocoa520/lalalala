
#import "IMBCustomCornerView.h"
#import "IMBCustomHeaderCell.h"

@implementation IMBCustomCornerView
@synthesize backgroundColorGradient = _backgroundColorGradient;
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect {
    
    NSArray* colorArray = [NSArray arrayWithObjects:
                                                            [NSColor colorWithCalibratedWhite:1.00 alpha:1.0],
                                                              [NSColor colorWithCalibratedWhite:1.00 alpha:1.0],
                                                              [NSColor colorWithCalibratedWhite:1.00 alpha:1.0],
                                                              nil];
    self.backgroundColorGradient = [[[NSGradient alloc] initWithColors:colorArray] autorelease];
    [_backgroundColorGradient drawInRect:rect angle:90.0];
	
	NSGraphicsContext* gc = [NSGraphicsContext currentContext];
	[gc saveGraphicsState];
	[gc setShouldAntialias:NO];
	
	NSBezierPath* path = [NSBezierPath bezierPath];
	[path setLineWidth:1.0];
	NSPoint p = NSMakePoint(rect.origin.x , rect.origin.y+24);
	[path moveToPoint:p];
	
	p.x += rect.size.width;
	[path lineToPoint:p];
	p.x += rect.size.width;
	[path lineToPoint:p];
    [[NSColor colorWithCalibratedRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0] setStroke];
    [path stroke];
    
	NSBezierPath* path1 = [NSBezierPath bezierPath];
	p = NSMakePoint(rect.origin.x , rect.origin.y+1.0);
	[path1 moveToPoint:p];
	p.x += rect.size.width;
	[path1 lineToPoint:p];
	
    [[NSColor colorWithCalibratedRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0] setStroke];
    [path1 stroke];
	
    NSBezierPath* path2 = [NSBezierPath bezierPath];
	p = NSMakePoint(rect.size.width , rect.origin.y);
	[path2 moveToPoint:p];
	p.y += rect.size.height;
	[path2 lineToPoint:p];
	
    [[NSColor colorWithCalibratedRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0] setStroke];
    [path2 stroke];
    
	[gc restoreGraphicsState];
	

}

- (BOOL)isFlipped
{
	return YES;
}

-(void)dealloc
{
    [_backgroundColorGradient release],_backgroundColorGradient = nil;
    [super dealloc];
}
@end
