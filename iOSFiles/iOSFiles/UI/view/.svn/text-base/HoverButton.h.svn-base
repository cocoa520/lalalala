//
//  HoverButton.h
//  HoverButton
//

#import <Cocoa/Cocoa.h>
@interface HoverButton : NSButton
{
	NSTrackingArea *trackingArea;
    NSImage *_mouseExitImage;
    NSImage *_mouseEnteredImage;
    NSImage *_mouseDownImage;
    NSImage *_forBidImage;
    BOOL _isSelected;
    
    BOOL _isDrawBorder;
    int _status;
    BOOL _hasPopover;
    id _delegate;
    BOOL _isShowTips;
    BOOL _hasExite;
    BOOL _hasSpot;
    BOOL _isDrawRectLine;
}
@property (assign) int status;
@property (assign,nonatomic)BOOL isSelected;
@property (retain) NSImage *MouseExitImage;
@property (retain) NSImage *MouseEnteredImage;
@property (retain) NSImage *MouseDownImage;
@property (nonatomic,retain) NSImage *forBidImage;
@property (nonatomic, assign) BOOL hasPopover;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL isShowTips;
@property (nonatomic, assign) BOOL hasSpot;
@property (nonatomic, assign) BOOL isDrawRectLine;
//设置按钮的图片
-(void)setMouseEnteredImage:(NSImage *)image1 mouseExitImage:(NSImage *)image2 mouseDownImage:(NSImage *)image3 forBidImage:(NSImage *)forBidImage;
-(void)setMouseEnteredImage:(NSImage *)image1 mouseExitImage:(NSImage *)image2 mouseDownImage:(NSImage *)image3;

- (void)setIsDrawBorder:(BOOL)isDraw;
- (void)showPopover:(id)sender;
- (void)closePopover:(id)sender;


@end
