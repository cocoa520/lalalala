//
//  IMBStackBox.m
//  iOSFiles
//
//  Created by iMobie on 18/2/6.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBStackBox.h"

@implementation IMBStackBox

@synthesize contentViewsArray = _contentViewsArray;


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {
    [self setupView];
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _contentViewsArray = [[NSMutableArray alloc] init];
}

- (void)dealloc {
    if (_contentViewsArray) {
        [_contentViewsArray release];
        _contentViewsArray = nil;
    }
    [super dealloc];
}

- (void)pushView:(NSView *)view {
    if (!_contentViewsArray) {
        _contentViewsArray = [[NSMutableArray alloc] init];
    }
    
//    [self setContentView:view];
    _contentView = view;
    
}

- (void)popView {
    if (_contentViewsArray && _contentViewsArray.count > 1) {
        [_contentViewsArray removeLastObject];
        NSView *view = [_contentViewsArray lastObject];
        _contentView = view;
    }
}

- (void)popToView:(NSView *)view {
    if ([self containsView:view]) {
        NSInteger count = _contentViewsArray.count;
        for (NSInteger i = count - 1; i >= 0; i--) {
            NSView *v = [_contentViewsArray lastObject];
            if (v == view) {
                _contentView = view;
            }else {
                [_contentViewsArray removeLastObject];
            }
        }
    }
}
- (void)setContentView:(__kindof NSView *)contentView {
    [super setContentView:contentView];
    
    if (!_contentViewsArray) {
        _contentViewsArray = [[NSMutableArray alloc] init];
    }else {
        [_contentViewsArray removeAllObjects];
    }
    [_contentViewsArray addObject:contentView];
}

- (BOOL)containsView:(NSView *)cView {
    if (_contentViewsArray.count) {
        for (NSView *view in _contentViewsArray) {
            if (view == cView) {
                return YES;
            }
        }
    }
    return NO;
}
@end
