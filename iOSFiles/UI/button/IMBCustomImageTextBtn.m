//
//  IMBCustomImageTextBtn.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/24.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBCustomImageTextBtn.h"
#import "StringHelper.h"


@interface IMBCustomImageTextBtn()
{
    NSTextField *_titleLabel;
    NSImageView *_leftIconImageView;
    NSImageView *_rightIconImageView;
}

@end

@implementation IMBCustomImageTextBtn
#pragma mark - draw
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

#pragma mark - initialization
- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupView];
}

- (void)setupView {
    [self addTrackingRect:self.bounds owner:self userData:nil assumeInside:0];
}

#pragma mark -

- (void)setTitle:(NSString *)title leftIcon:(NSString *)leftIcon rightIcon:(NSString *)rightIcon {
    [self setTitle:title titleColor:nil titleSize:0 leftIcon:leftIcon rightIcon:rightIcon];
}

- (void)setTitle:(NSString *)title titleColor:(NSColor *)titleColor titleSize:(CGFloat)titleSize leftIcon:(NSString *)leftIcon rightIcon:(NSString *)rightIcon {
    [self emptyMemory];
    _titleLabel = [[NSTextField alloc] init];
    [_titleLabel setBordered:NO];
    [_titleLabel setDrawsBackground:NO];
    _titleLabel.editable = NO;
    _titleLabel.textColor = titleColor ? titleColor : [NSColor darkGrayColor];
    _titleLabel.font = titleSize > 0 ? [NSFont systemFontOfSize:titleSize] : [NSFont systemFontOfSize:14.f];//[NSFont fontWithName:IMBCommonFont size:titleSize] : [NSFont fontWithName:IMBCommonFont size:14.f]
    
    _titleLabel.stringValue = title;
    
    NSDictionary *textAttr = @{NSForegroundColorAttributeName : _titleLabel.textColor, NSFontAttributeName : _titleLabel.font};
    NSSize textSize = [title boundingRectWithSize:NSMakeSize(MAXFLOAT, 0) options:NSStringDrawingTruncatesLastVisibleLine attributes:textAttr].size;
    textSize.width += 5.f;
    if (!rightIcon) {
        _rightIconImageView.image = [NSImage imageNamed:rightIcon];
        if (textSize.width + 5 + _rightIconImageView.frame.size.width >  NSWidth(self.frame)) {
            _titleLabel.frame = NSMakeRect(0, (NSHeight(self.frame) - textSize.height)/2.f, NSWidth(self.frame) - 20, textSize.height);
        }else {
            _titleLabel.frame = NSMakeRect(ceil((NSWidth(self.frame) -textSize.width + 5 + _rightIconImageView.frame.size.width)/2.0), (NSHeight(self.frame) - textSize.height)/2.f, NSWidth(self.frame) - 20, textSize.height);
        }
    }else {
        if (textSize.width < NSWidth(self.frame) - 45) {
            _titleLabel.frame = NSMakeRect((NSWidth(self.frame) - textSize.width)/2.f, (NSHeight(self.frame) - textSize.height)/2.f, textSize.width, textSize.height);
        }else {
            _titleLabel.frame = NSMakeRect(25, (NSHeight(self.frame) - textSize.height)/2.f, NSWidth(self.frame) - 45, textSize.height);
        }
    }

//    [_titleLabel.cell setLineBreakMode:NSLineBreakByTruncatingTail];
    [_titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];

    [self addSubview:_titleLabel];
    
    if (leftIcon) {
        _leftIconImageView = [[NSImageView alloc] init];
        _leftIconImageView.image = [NSImage imageNamed:leftIcon];
        _leftIconImageView.frame = NSMakeRect(NSMinX(_titleLabel.frame) - 5 - _leftIconImageView.image.size.width, (NSHeight(self.frame) - _leftIconImageView.image.size.height)/2.f, _leftIconImageView.image.size.width, _leftIconImageView.image.size.height);
        [self addSubview:_leftIconImageView];
    }
    
    if (rightIcon) {
        _rightIconImageView = [[NSImageView alloc] init];
        _rightIconImageView.image = [NSImage imageNamed:rightIcon];
        _rightIconImageView.frame = NSMakeRect(NSMaxX(_titleLabel.frame) + 5, (NSHeight(self.frame) - _rightIconImageView.image.size.height)/2.f, _rightIconImageView.image.size.width, _rightIconImageView.image.size.height);
        [self addSubview:_rightIconImageView];
    }

}

#pragma mark - mosueAction

- (void)mouseDown:(NSEvent *)theEvent {
    
}

- (void)mouseUp:(NSEvent *)theEvent {
    [NSApp sendAction:self.action to:self.target from:self];
}

#pragma mark - dealloc方法
- (void)dealloc {
    [self emptyMemory];
    [super dealloc];
}

- (void)emptyMemory {
    if (_titleLabel) {
        [_titleLabel removeFromSuperview];
        [_titleLabel release];
        _titleLabel = nil;
    }
    if (_leftIconImageView) {
        [_leftIconImageView removeFromSuperview];
        [_leftIconImageView release];
        _leftIconImageView = nil;
    }
    if (_rightIconImageView) {
        [_rightIconImageView removeFromSuperview];
        [_rightIconImageView release];
        _rightIconImageView = nil;
    }
}
@end
