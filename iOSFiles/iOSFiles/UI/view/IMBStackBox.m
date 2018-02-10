//
//  IMBStackBox.m
//  iOSFiles
//
//  Created by iMobie on 18/2/6.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBStackBox.h"
#import <objc/runtime.h>



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
    [_contentViewsArray addObject:view];
    [self zl_setContentView:view];
    
}

- (void)popView {
    if (_contentViewsArray && _contentViewsArray.count > 1) {
        [_contentViewsArray removeLastObject];
        NSView *view = [_contentViewsArray lastObject];
        [self zl_setContentView:view];
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

/**
 *  首次加载用runtime调换方法:setContentView:和zl_setContentView:
    因为设置contentView必须得调用setContentView:才能实现效果，直接对_contenView进行辅助不行
 */
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL needSwizzleSelectors[1] = {
            @selector(setContentView:),
        };
        
        for (int i = 0; i < 1;  i++) {
            SEL selector = needSwizzleSelectors[i];
            NSString *newSelectorStr = [NSString stringWithFormat:@"zl_%@", NSStringFromSelector(selector)];
            Method originMethod = class_getInstanceMethod(self, selector);
            Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

- (void)zl_setContentView:(__kindof NSView *)contentView {
    if (!_contentViewsArray) {
        _contentViewsArray = [[NSMutableArray alloc] init];
    }else {
        [_contentViewsArray removeAllObjects];
    }
    [_contentViewsArray addObject:contentView];
    [self zl_setContentView:contentView];
}

- (void)setContentView:(__kindof NSView *)contentView {
    [super setContentView:contentView];
    
}

- (NSView *)currentView {
    if (_contentViewsArray.count) {
        return [_contentViewsArray.lastObject retain];
    }
    return nil;
}
@end
