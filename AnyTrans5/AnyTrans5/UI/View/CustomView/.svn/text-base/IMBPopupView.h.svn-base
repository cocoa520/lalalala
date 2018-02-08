//
//  IMBPopupView.h
//  iMobieTrans
//
//  Created by iMobie on 14-4-30.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define CellSeparation 4
#define ArrowSize 17
#define PopUpViewHeight 147

@class IMBCategoryBarButtonView;
@interface IMBPopupView : NSView<NSAnimationDelegate>
{
    float _startPoint;
    NSView *_containerView;
    IMBCategoryBarButtonView *_categoryBarView;
    BOOL _isTwoBtn;
}
@property(nonatomic,assign)IMBCategoryBarButtonView *categoryBarView;//此处为弱引用
@property(nonatomic,assign)float startPoint;
@property(nonatomic,assign)NSView *containerView;
@property(nonatomic,assign)BOOL isTwoBtn;
- (void)animation:(BOOL)isTwo;
@end


@interface IMBPopupContentView : NSView {
    float _startPoint;
}
@property(nonatomic,assign)float startPoint;

@end