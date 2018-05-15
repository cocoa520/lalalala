//
//  IMBMainNavigationView.m
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/12.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBMainNavigationView.h"
#import "StringHelper.h"
#import "IMBSVGButton.h"
#import "IMBAnimation.h"
#import "IMBNotificationDefine.h"
@implementation IMBMainNavigationView
@synthesize delegate = _delegate;
@synthesize addBtn = _addBtn;
@synthesize historyBtn = _historyBtn;
@synthesize allBtnArray = _allBtnArray;
@synthesize showBtnArray = _showBtnArray;
@synthesize popBtnArray = _popBtnArray;
@synthesize fixedBtnView = _fixedBtnView;
@synthesize moreBtn = _moreBtn;

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnToolTipMouseMove:) name:GLOBAL_MOUSE_MOVE object:nil];
    _showBtnArray = [[NSMutableArray alloc] init];
    _allBtnArray = [[NSMutableArray alloc]init];
    _popBtnArray = [[NSMutableArray alloc]init];
    _lineView = [[IMBWhiteView alloc] initWithFrame:NSMakeRect(0, 0, 48, 1)];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    _fixedBtnView = [[IMBWhiteView alloc] initWithFrame:NSMakeRect(0, 0, 70, 328)];
    
    _addBtn = [[IMBSVGButton alloc] initWithFrame:NSMakeRect(0, 0, ButtonSizeWidth, ButtonSizeHeight)];
    [_addBtn setBordered:NO];
    [_addBtn setDelegate:self];
    [_addBtn setImagePosition:NSImageOnly];
    [_addBtn setSvgFileName:@"icloud_add"];
    [_addBtn setToolTipStr:CustomLocalizedString(@"Menu_AddCloud_Tips", nil)];
    [_addBtn setAllowsExpansionToolTips:NO];
    [_addBtn setTag:101];
    [_addBtn setTarget:self];
    [_addBtn setAction:@selector(switchView:)];
    
    IMBCloudEntity *addCloudEntity = [[IMBCloudEntity alloc]init];
    addCloudEntity.categoryCloudEnum = AddBtnEnum;
    [addCloudEntity setName:CustomLocalizedString(@"AddCloud_Button_Content", nil)];
    addCloudEntity.image = [NSImage imageNamed:@"icloud_add2"];
    _addBtn.cloudEntity = addCloudEntity;
    [addCloudEntity release];
    
    _moreBtn = [[IMBSVGButton alloc] initWithFrame:NSMakeRect(0, 0, ButtonSizeWidth, ButtonSizeHeight)];
    [_moreBtn setToolTipStr:CustomLocalizedString(@"Menu_MoreCloud_Tips", nil)];
    [_moreBtn setTag:102];
    [_moreBtn setDelegate:self];
    [_moreBtn setAllowsExpansionToolTips:NO];
    [_moreBtn setBordered:NO];
    [_moreBtn setImagePosition:NSImageOnly];
    [_moreBtn setSvgFileName:@"icloud_more"];
    [_moreBtn setTarget:self];
    [_moreBtn setAction:@selector(switchView:)];
    IMBCloudEntity *moreCloudEntity = [[IMBCloudEntity alloc]init];
    moreCloudEntity.categoryCloudEnum = MoreBtnEnum;
    _moreBtn.cloudEntity = moreCloudEntity;
    [moreCloudEntity release];
    
    _historyBtn = [[IMBSVGButton alloc] initWithFrame:NSMakeRect(0, 0, ButtonSizeWidth, ButtonSizeHeight)];
    [_historyBtn setDelegate:self];
    [_historyBtn setBordered:NO];
    [_historyBtn setImagePosition:NSImageOnly];
    [_historyBtn setSvgFileName:@"menu_history"];
    [_historyBtn setToolTipStr:CustomLocalizedString(@"Menu_HistoryCloud_Tips", nil)];
    [_historyBtn setAllowsExpansionToolTips:NO];
    [_historyBtn setTag:103];
    [_historyBtn setTarget:self];
    [_historyBtn setAction:@selector(switchView:)];
    IMBCloudEntity *historyCloudEntity = [[IMBCloudEntity alloc]init];
    historyCloudEntity.categoryCloudEnum = HistoryBtnEnum;
    _historyBtn.cloudEntity = historyCloudEntity;
    [historyCloudEntity release];
    
    _shareBtn = [[IMBSVGButton alloc] initWithFrame:NSMakeRect(0, 0, ButtonSizeWidth, ButtonSizeHeight)];
    [_shareBtn setDelegate:self];
    [_shareBtn setBordered:NO];
    [_shareBtn setImagePosition:NSImageOnly];
    [_shareBtn setSvgFileName:@"menu_share"];
    [_shareBtn setToolTipStr:CustomLocalizedString(@"Menu_ShareCloud_Tips", nil)];
    [_shareBtn setTag:104];
    [_shareBtn setAllowsExpansionToolTips:NO];
    [_shareBtn setTarget:self];
    [_shareBtn setAction:@selector(switchView:)];
    IMBCloudEntity *shareCloudEntity = [[IMBCloudEntity alloc]init];
    shareCloudEntity.categoryCloudEnum = ShareBtnEnum;
    _shareBtn.cloudEntity = shareCloudEntity;
    [shareCloudEntity release];
    
    _starBtn = [[IMBSVGButton alloc] initWithFrame:NSMakeRect(0, 0, ButtonSizeWidth, ButtonSizeHeight)];
    [_starBtn setDelegate:self];
    [_starBtn setToolTipStr:CustomLocalizedString(@"Menu_FavoriteCloud_Tips", nil)];
    [_starBtn setSvgFileName:@"menu_star"];
    [_starBtn setBordered:NO];
    [_starBtn setImagePosition:NSImageOnly];
    [_starBtn setTag:105];
    [_starBtn setAllowsExpansionToolTips:NO];
    [_starBtn setTarget:self];
    [_starBtn setAction:@selector(switchView:)];
    IMBCloudEntity *starCloudEntity = [[IMBCloudEntity alloc]init];
    starCloudEntity.categoryCloudEnum = StarBtnEnum;
    _starBtn.cloudEntity = starCloudEntity;
    [starCloudEntity release];
    
    _trashBtn = [[IMBSVGButton alloc] initWithFrame:NSMakeRect(0, 0, ButtonSizeWidth, ButtonSizeHeight)];
    [_trashBtn setBordered:NO];
    [_trashBtn setDelegate:self];
    [_trashBtn setToolTipStr:CustomLocalizedString(@"Menu_TrashCloud_Tips", nil)];
    [_trashBtn setImagePosition:NSImageOnly];
    [_trashBtn setSvgFileName:@"menu_trash"];
    [_trashBtn setTag:106];
    [_trashBtn setAllowsExpansionToolTips:NO];
    [_trashBtn setTarget:self];
    [_trashBtn setAction:@selector(switchView:)];
    IMBCloudEntity *trashCloudEntity = [[IMBCloudEntity alloc]init];
    trashCloudEntity.categoryCloudEnum = TrashBtnEnum;
    _trashBtn.cloudEntity = trashCloudEntity;
    [trashCloudEntity release];
    
    [_fixedBtnView setFrameOrigin:NSMakePoint(0, 154)];
    [self addSubview:_fixedBtnView];
    
    [_addBtn setFrameOrigin:NSMakePoint((_fixedBtnView.frame.size.width - _addBtn.frame.size.width)/2, _fixedBtnView.frame.size.height - _addBtn.frame.size.height - 6)];
    [_fixedBtnView addSubview:_addBtn];
    
    [_lineView setFrameOrigin:NSMakePoint((_fixedBtnView.frame.size.width - _lineView.frame.size.width)/2, _addBtn.frame.origin.y - _lineView.frame.size.height - LineSpace + 6)];
    [_fixedBtnView addSubview:_lineView];
    
    [_shareBtn setFrameOrigin:NSMakePoint((_fixedBtnView.frame.size.width - _shareBtn.frame.size.width)/2, _lineView.frame.origin.y - _shareBtn.frame.size.height - LineSpace)];
    [_fixedBtnView addSubview:_shareBtn];
    
    [_starBtn setFrameOrigin:NSMakePoint((_fixedBtnView.frame.size.width - _starBtn.frame.size.width)/2, _shareBtn.frame.origin.y - _starBtn.frame.size.height - ButtonSpace)];
    [_fixedBtnView addSubview:_starBtn];
    
    [_historyBtn setFrameOrigin:NSMakePoint((_fixedBtnView.frame.size.width - _historyBtn.frame.size.width)/2, _starBtn.frame.origin.y - _historyBtn.frame.size.height - ButtonSpace)];
    [_fixedBtnView addSubview:_historyBtn];
    
    [_trashBtn setFrameOrigin:NSMakePoint((_fixedBtnView.frame.size.width - _trashBtn.frame.size.width)/2, _historyBtn.frame.origin.y - _trashBtn.frame.size.height - ButtonSpace)];
    [_fixedBtnView addSubview:_trashBtn];
}

#pragma mark - 增加或者移除关联Cloud的按钮
- (void)addRelationCloudButton:(IMBCloudEntity *)cloudEntity animate:(BOOL)animateFlag {
    IMBDrawOneImageBtn *drawOneImageBtn = [[IMBDrawOneImageBtn alloc]initWithFrame:NSMakeRect(0, 0, ButtonSizeWidth, ButtonSizeHeight)];
    [drawOneImageBtn setEnabled:YES];
    [drawOneImageBtn setBordered:NO];
    [drawOneImageBtn setDelegate:self];
    [drawOneImageBtn setToolTipStr:cloudEntity.name];
    [drawOneImageBtn setCloudEntity:cloudEntity];
    [drawOneImageBtn setTitle:@""];
    [drawOneImageBtn setStringValue:@""];

    [drawOneImageBtn mouseDownImage:cloudEntity.image withMouseUpImg:cloudEntity.image withMouseExitedImg:cloudEntity.image mouseEnterImg:cloudEntity.image];
    [drawOneImageBtn setTarget:self];
    [drawOneImageBtn setAction:@selector(switchView:)];
    
    if (animateFlag) {
        NSPoint point;
        if (_allBtnArray.count > 0) {
            IMBDrawOneImageBtn *btn = [_allBtnArray lastObject];
            point = NSMakePoint((self.frame.size.width - drawOneImageBtn.frame.size.width)/2, btn.frame.origin.y);
        }else {
            point = NSMakePoint((self.frame.size.width - drawOneImageBtn.frame.size.width)/2, _fixedBtnView.frame.origin.y + _fixedBtnView.frame.size.height - drawOneImageBtn.frame.size.height - ButtonSpace);
        }
        [drawOneImageBtn setFrameOrigin:point];
        
        [self btnAnimationScale:drawOneImageBtn];
        if (_allBtnArray.count < 3) {
            int moveY = _fixedBtnView.frame.origin.y - (drawOneImageBtn.frame.size.height + ButtonSpace);
            [self fixedBtnViewAnimationMoveX:moveY];
            for (IMBDrawOneImageBtn *imageBtn in _allBtnArray) {
                int y = imageBtn.frame.origin.y - imageBtn.frame.size.height - ButtonSpace;
                [self btnAnimationMove:imageBtn MoveY:y];
            }
            [_showBtnArray insertObject:drawOneImageBtn atIndex:0];
        }else {
            IMBDrawOneImageBtn *imageBtn = [_allBtnArray objectAtIndex:_allBtnArray.count - 2];
            int y = imageBtn.frame.origin.y - imageBtn.frame.size.height - ButtonSpace;
            [self btnAnimationMove:imageBtn MoveY:y];
            IMBDrawOneImageBtn *imageBtn1 = [_allBtnArray lastObject];
            y = imageBtn1.frame.origin.y - imageBtn1.frame.size.height - ButtonSpace;
            [self btnAnimationMove:imageBtn1 MoveY:y];
            
            if (_allBtnArray.count == 3) {
                [_moreBtn setFrameOrigin:NSMakePoint(_addBtn.frame.origin.x, _addBtn.frame.origin.y)];
                [_addBtn removeFromSuperview];
                [_fixedBtnView addSubview:_moreBtn];
                [_popBtnArray addObject:_addBtn];
            }
            [_showBtnArray insertObject:drawOneImageBtn atIndex:0];
            IMBDrawOneImageBtn *lastBtn = [_showBtnArray lastObject];
            [_popBtnArray insertObject:lastBtn atIndex:0];
            [lastBtn removeFromSuperview];
            [_showBtnArray removeObject:lastBtn];
        }
        [_allBtnArray addObject:drawOneImageBtn];
    }else {
        [drawOneImageBtn setFrameOrigin:NSMakePoint((self.frame.size.width - drawOneImageBtn.frame.size.width)/2, _fixedBtnView.frame.origin.y + _fixedBtnView.frame.size.height - drawOneImageBtn.frame.size.height - ButtonSpace)];
        int moveY = _fixedBtnView.frame.origin.y - (drawOneImageBtn.frame.size.height + ButtonSpace);
        
        if (_allBtnArray.count < 3) {
            [self addSubview:drawOneImageBtn];
            [_fixedBtnView setFrameOrigin:NSMakePoint(_fixedBtnView.frame.origin.x,  moveY)];
            [_showBtnArray addObject:drawOneImageBtn];
        }else {
            if (_allBtnArray.count == 3) {
                [_moreBtn setFrameOrigin:NSMakePoint(_addBtn.frame.origin.x, _addBtn.frame.origin.y)];
                [_addBtn removeFromSuperview];
                [_fixedBtnView addSubview:_moreBtn];
                [_popBtnArray addObject:_addBtn];
            }
            [_popBtnArray insertObject:drawOneImageBtn atIndex:0];
        }
        [_allBtnArray insertObject:drawOneImageBtn atIndex:0];
    }
    if (animateFlag) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIEY_CHOOSE_CLOUD_BTN object:drawOneImageBtn];
    }
    [drawOneImageBtn release];
}

- (void)changeCloudButton:(IMBCloudEntity *)cloudEntity {
    IMBDrawOneImageBtn *changeBtn = nil;
    for (IMBDrawOneImageBtn *btn in _allBtnArray) {
        if ([btn.cloudEntity.driveID isEqualToString:cloudEntity.driveID]) {
            changeBtn = btn;
            break;
        }
    }
    if (changeBtn) {
        IMBDrawOneImageBtn *removeBtn = [_showBtnArray lastObject];
        IMBDrawOneImageBtn *firstBtn = [_showBtnArray firstObject];
        [changeBtn setFrameOrigin:NSMakePoint(firstBtn.frame.origin.x, firstBtn.frame.origin.y)];
        [removeBtn removeFromSuperview];
        [_popBtnArray insertObject:removeBtn atIndex:0];
        [_showBtnArray removeObject:removeBtn];
        for (IMBDrawOneImageBtn *btn in _showBtnArray) {
//            [btn setFrameOrigin:NSMakePoint(btn.frame.origin.x, btn.frame.origin.y - btn.frame.size.height - ButtonSpace)];
            [self btnAnimationMove:btn MoveY:btn.frame.origin.y - btn.frame.size.height - ButtonSpace];
        }
        [self btnAnimationScale:changeBtn];
        [_showBtnArray insertObject:changeBtn atIndex:0];
        [_popBtnArray removeObject:changeBtn];
        [changeBtn setNeedsDisplay:YES];
    }
}

- (void)removeRelationCloudButton:(NSString *)identifier {
    IMBDrawOneImageBtn *curBtn = nil;
    for (IMBDrawOneImageBtn *popBtn in _popBtnArray) {
        if ([popBtn.cloudEntity.driveID isEqualToString:identifier]) {
            curBtn = popBtn;
            break;
        }
    }
    if (curBtn) {
        [_popBtnArray removeObject:curBtn];
        [_allBtnArray removeObject:curBtn];
        if (_popBtnArray.count == 1) {
            [_addBtn setFrameOrigin:NSMakePoint(_moreBtn.frame.origin.x, _moreBtn.frame.origin.y)];
            [_moreBtn removeFromSuperview];
            [_popBtnArray removeObject:_addBtn];
            [_fixedBtnView addSubview:_addBtn];
        }
    }else {
        for (IMBDrawOneImageBtn *btn in _showBtnArray) {
            if ([btn.cloudEntity.driveID isEqualToString:identifier]) {
                curBtn = btn;
                break;
            }
        }
        if (curBtn) {
            NSUInteger index = [_showBtnArray indexOfObject:curBtn];
            IMBDrawOneImageBtn *newShowBtn = nil;
            if (_popBtnArray.count > 0) {
                newShowBtn = [_popBtnArray firstObject];
                if (index == 2) {
                    [newShowBtn setFrameOrigin:NSMakePoint(curBtn.frame.origin.x, curBtn.frame.origin.y)];
                    [self btnAnimationScale:newShowBtn];
                }else if (index == 1) {
                    IMBDrawOneImageBtn *showLastBtn = [_showBtnArray lastObject];
                    NSRect showLastRect = showLastBtn.frame;
                    [self btnAnimationMove:showLastBtn MoveY:curBtn.frame.origin.y];
//                    [self btnAnimationMoveY:showLastBtn srcRect:showLastBtn.frame desRect:NSMakeRect(curBtn.frame.origin.x, curBtn.frame.origin.y, showLastBtn.frame.size.width, showLastBtn.frame.size.height)];
//                    [showLastBtn setFrameOrigin:NSMakePoint(curBtn.frame.origin.x, curBtn.frame.origin.y)];
                    
                    [newShowBtn setFrameOrigin:NSMakePoint(showLastRect.origin.x, showLastRect.origin.y)];
                    [self btnAnimationScale:newShowBtn];
                }else {
                    IMBDrawOneImageBtn *twoBtn = [_showBtnArray objectAtIndex:1];
                    NSRect twoRect = twoBtn.frame;
                    [self btnAnimationMove:twoBtn MoveY:curBtn.frame.origin.y];
//                    [self btnAnimationMoveY:twoBtn srcRect:twoBtn.frame desRect:NSMakeRect(curBtn.frame.origin.x, curBtn.frame.origin.y, twoBtn.frame.size.width, twoBtn.frame.size.height)];
//                    [twoBtn setFrameOrigin:NSMakePoint(curBtn.frame.origin.x, curBtn.frame.origin.y)];
                    
                    IMBDrawOneImageBtn *showLastBtn = [_showBtnArray lastObject];
                    NSRect showLastRect = showLastBtn.frame;
                    [self btnAnimationMove:showLastBtn MoveY:twoRect.origin.y];
//                    [self btnAnimationMoveY:showLastBtn srcRect:showLastBtn.frame desRect:NSMakeRect(twoRect.origin.x, twoRect.origin.y, showLastBtn.frame.size.width, showLastBtn.frame.size.height)];
//                    [showLastBtn setFrameOrigin:NSMakePoint(twoRect.origin.x, twoRect.origin.y)];
                    
                    [newShowBtn setFrameOrigin:NSMakePoint(showLastRect.origin.x, showLastRect.origin.y)];
                    [self btnAnimationScale:newShowBtn];
                }
                [_showBtnArray addObject:newShowBtn];
                [_popBtnArray removeObject:newShowBtn];
                [curBtn removeFromSuperview];
                [_showBtnArray removeObject:curBtn];
                [_allBtnArray removeObject:curBtn];
                if (_popBtnArray.count == 1) {
                    [_addBtn setFrameOrigin:NSMakePoint(_moreBtn.frame.origin.x, _moreBtn.frame.origin.y)];
                    [_moreBtn removeFromSuperview];
                    [_popBtnArray removeObject:_addBtn];
                    [_fixedBtnView addSubview:_addBtn]; 
                }
            }else {
                int moveY = _fixedBtnView.frame.origin.y + (curBtn.frame.size.height + ButtonSpace);
                [self fixedBtnViewAnimationMoveX:moveY];
                if (index != 2) {
                    if (index == 1) {
                        if (_showBtnArray.count > 2) {
                            IMBDrawOneImageBtn *showLastBtn = [_showBtnArray lastObject];
                            [self btnAnimationMove:showLastBtn MoveY:curBtn.frame.origin.y];
                        }
                    }else {
                        if (_showBtnArray.count > 2) {
                            IMBDrawOneImageBtn *twoBtn = [_showBtnArray objectAtIndex:1];
                            NSRect twoRect = twoBtn.frame;
                            [self btnAnimationMove:twoBtn MoveY:curBtn.frame.origin.y];
                            
                            IMBDrawOneImageBtn *showLastBtn = [_showBtnArray lastObject];
                            [self btnAnimationMove:showLastBtn MoveY:twoRect.origin.y];
                        }else if (_showBtnArray.count == 2) {
                            IMBDrawOneImageBtn *showLastBtn = [_showBtnArray lastObject];
                            [self btnAnimationMove:showLastBtn MoveY:curBtn.frame.origin.y];
                        }
                    }
                }
                
                [curBtn removeFromSuperview];
                [_showBtnArray removeObject:curBtn];
                [_allBtnArray removeObject:curBtn];
            }
        }
    }
}

- (void)fixedBtnViewAnimationMoveX:(int)moveY {
    NSViewAnimation *animation = nil;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        //属性字典
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //设置目标对象
        [dict setObject:_fixedBtnView forKey:NSViewAnimationTargetKey];
        //设置其实大小
        [dict setObject:[NSValue valueWithRect:NSMakeRect(_fixedBtnView.frame.origin.x,  _fixedBtnView.frame.origin.y, _fixedBtnView.frame.size.width, _fixedBtnView.frame.size.height)] forKey:NSViewAnimationStartFrameKey];
        //设置最终大小
        [dict setObject:[NSValue valueWithRect:NSMakeRect(_fixedBtnView.frame.origin.x,  moveY, _fixedBtnView.frame.size.width, _fixedBtnView.frame.size.height)] forKey:NSViewAnimationEndFrameKey];
        
        //设置动画
        NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:dict,nil]];
        animation.delegate = self;
        [animation setDuration:0.2];
        //启动动画
        [animation startAnimation];
    } completionHandler:^{
        if (animation) {
            [animation stopAnimation];
            [animation release];
        }
    }];
}

- (void)btnAnimationScale:(IMBDrawOneImageBtn *)btn {
//    NSViewAnimation *animation = nil;
//    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//        //属性字典
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        //设置目标对象
//        [dict setObject:btn forKey:NSViewAnimationTargetKey];
//        //设置其实大小
//        [dict setObject:[NSValue valueWithRect:NSMakeRect(btn.frame.origin.x + btn.frame.size.width/2,  btn.frame.origin.y + btn.frame.size.height/2, 0, 0)] forKey:NSViewAnimationStartFrameKey];
//        //设置最终大小
//        [dict setObject:[NSValue valueWithRect:NSMakeRect(btn.frame.origin.x,  btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height)] forKey:NSViewAnimationEndFrameKey];
//        
//        [self addSubview:btn];
//        [btn setFrame:NSMakeRect(btn.frame.origin.x + btn.frame.size.width/2,  btn.frame.origin.y + btn.frame.size.height/2, 0, 0)];
//        
//        //设置动画
//        NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:dict,nil]];
//        animation.delegate = self;
//        [animation setDuration:0.2];
//        //启动动画
//        [animation startAnimation];
//    } completionHandler:^{
//        if (animation) {
//            [animation stopAnimation];
//            [animation release];
//        }
//    }];
    [self addSubview:btn];
    [btn setWantsLayer:YES];
    [btn.layer setAnchorPoint:NSMakePoint(0.5, 0.5)];
    CAAnimation *animation = [IMBAnimation scale:@0 orgin:@1 durTimes:0.2 Rep:0];
    animation.autoreverses = NO;
    [btn.layer addAnimation:animation forKey:@"enter"];
}

- (void)btnAnimationMove:(IMBDrawOneImageBtn *)btn MoveY:(int)moveY {
//    [btn setWantsLayer:YES];
//    [btn.layer setAnchorPoint:NSMakePoint(0.5, 0.5)];
//    CAAnimation *animation = [IMBAnimation moveY:0.2 X:[NSNumber numberWithInt:btn.frame.origin.y] Y:[NSNumber numberWithInt:btn.frame.origin.y - btn.frame.size.height - ButtonSpace] repeatCount:1 beginTime:0 isAutoreverses:NO];//[IMBAnimation moveY:0.2 X:[NSNumber numberWithInt:btn.frame.origin.y] Y:[NSNumber numberWithInt:btn.frame.origin.y - btn.frame.size.height - ButtonSpace] repeatCount:1];
////    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
////    animation.autoreverses = NO;
//    [btn.layer addAnimation:animation forKey:@"move"];
//    [btn setFrameOrigin:NSMakePoint(btn.frame.origin.x, btn.frame.origin.y - btn.frame.size.height - ButtonSpace)];
    
    int y = moveY;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        [[btn animator] setFrameOrigin:NSMakePoint(btn.frame.origin.x, y)];
        context.duration = 0.2;
    } completionHandler:^{
        [btn setFrameOrigin:NSMakePoint(btn.frame.origin.x, y)];
    }];
//    NSViewAnimation *animation = nil;
//    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//        //属性字典
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        //设置目标对象
//        [dict setObject:btn forKey:NSViewAnimationTargetKey];
//        //设置其实大小
//        [dict setObject:[NSValue valueWithRect:NSMakeRect(btn.frame.origin.x, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height)] forKey:NSViewAnimationStartFrameKey];
//        //设置最终大小
//        [dict setObject:[NSValue valueWithRect:NSMakeRect(btn.frame.origin.x, btn.frame.origin.y - btn.frame.size.height - ButtonSpace, btn.frame.size.width, btn.frame.size.height)] forKey:NSViewAnimationEndFrameKey];
//        
//        //设置动画
//        NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:dict,nil]];
//        animation.delegate = self;
//        [animation setDuration:0.2];
//        //启动动画
//        [animation startAnimation];
//    } completionHandler:^{
//        if (animation) {
//            [animation stopAnimation];
//            [animation release];
//        }
//    }];
}


//- (void)btnAnimationMoveY:(IMBDrawOneImageBtn *)btn srcRect:(NSRect)srcRect desRect:(NSRect)desRect {
//    NSViewAnimation *animation = nil;
//    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//        //属性字典
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        //设置目标对象
//        [dict setObject:btn forKey:NSViewAnimationTargetKey];
//        //设置其实大小
//        [dict setObject:[NSValue valueWithRect:srcRect] forKey:NSViewAnimationStartFrameKey];
//        //设置最终大小
//        [dict setObject:[NSValue valueWithRect:desRect] forKey:NSViewAnimationEndFrameKey];
//        
//        //设置动画
//        NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:dict,nil]];
//        animation.delegate = self;
//        [animation setDuration:0.2];
//        //启动动画
//        [animation startAnimation];
//    } completionHandler:^{
//        if (animation) {
//            [animation stopAnimation];
//            [animation release];
//        }
//    }];
//}

#pragma mark - 按钮的触发事件
- (void)switchView:(id)sender {
    NSButton *btn = (NSButton *)sender;
    IMBCloudEntity *curEntity = nil;
    if (btn.tag == 102) {
        IMBSVGButton *btn1 = (IMBSVGButton *)btn;
        btn1.cloudEntity.cloudAry = [_popBtnArray retain];
        curEntity = btn1.cloudEntity;
    }else if (btn.tag != 102) {
        [_addBtn setIsDownOtherBtn:YES];
        [_moreBtn setIsDownOtherBtn:YES];
        [_historyBtn setIsDownOtherBtn:YES];
        [_shareBtn setIsDownOtherBtn:YES];
        [_starBtn setIsDownOtherBtn:YES];
        [_trashBtn setIsDownOtherBtn:YES];
        [self setBottomViewButton:NO];
        
        for (IMBDrawOneImageBtn *drawOneBtn in _showBtnArray) {
            [drawOneBtn setLongTimeDown:NO];
            [drawOneBtn.cloudEntity setIsClick:NO];
            [drawOneBtn setIsDownOtherBtn:YES];
            [drawOneBtn setNeedsDisplay:YES];
        }
        for (IMBDrawOneImageBtn *oneImageBtn in _popBtnArray) {
            if ([oneImageBtn isKindOfClass:[IMBDrawOneImageBtn class]]) {
                [oneImageBtn setLongTimeDown:NO];
                [oneImageBtn.cloudEntity setIsClick:NO];
            }else {
                [(IMBSVGButton *)oneImageBtn setIsClick:NO];
                [[(IMBSVGButton *)oneImageBtn cloudEntity] setIsClick:NO];
            }
        }
        if ([btn isKindOfClass:[IMBDrawOneImageBtn class]]) {
            IMBDrawOneImageBtn *imagebtn = (IMBDrawOneImageBtn *)btn;
            [imagebtn setLongTimeDown:YES];
            [[imagebtn cloudEntity] setIsClick:YES];
            curEntity = imagebtn.cloudEntity;
        }else if ([btn isKindOfClass:[IMBSVGButton class]]) {
            IMBSVGButton *svgBtn = (IMBSVGButton *)btn;
            [svgBtn setIsClick:YES];
            [[svgBtn cloudEntity] setIsClick:YES];
            curEntity = svgBtn.cloudEntity;
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(cloudNavigationSwitch:withAddBtn:)]) {
        [_delegate cloudNavigationSwitch:curEntity withAddBtn:btn];
    }
    [btn setNeedsDisplay:YES];

}

- (void)setBottomViewButton:(BOOL)isclick {
    [_addBtn setIsClick:isclick];
    [[_addBtn cloudEntity] setIsClick:isclick];
    [_moreBtn setIsClick:isclick];
    [[_moreBtn cloudEntity] setIsClick:isclick];
    [_historyBtn setIsClick:isclick];
    [[_historyBtn cloudEntity] setIsClick:isclick];
    [_shareBtn setIsClick:isclick];
    [[_shareBtn cloudEntity] setIsClick:isclick];
    [_starBtn setIsClick:isclick];
    [[_starBtn cloudEntity] setIsClick:isclick];
    [_trashBtn setIsClick:isclick];
    [[_trashBtn cloudEntity] setIsClick:isclick];
    [_addBtn setNeedsDisplay:YES];
    [_moreBtn setNeedsDisplay:YES];
    [_historyBtn setNeedsDisplay:YES];
    [_shareBtn setNeedsDisplay:YES];
    [_starBtn setNeedsDisplay:YES];
    [_trashBtn setNeedsDisplay:YES];
}

#pragma mark - 按钮tooltip
- (void)showToolTip:(NSButton *)sender withToolTip:(NSString *)toolTip {
    [_delegate showToolTip:sender withToolTip:toolTip];
}

- (void)toolTipViewClose {
    [_delegate toolTipViewClose];
}

- (void)dealloc {
    [_showBtnArray release], _showBtnArray = nil;
    [_allBtnArray release], _allBtnArray = nil;
    [_popBtnArray release], _popBtnArray = nil;
    [_lineView release], _lineView = nil;
    [_addBtn release], _addBtn = nil;
    [_moreBtn release], _moreBtn = nil;
    [_historyBtn release], _historyBtn = nil;
    [_shareBtn release], _shareBtn = nil;
    [_starBtn release], _starBtn = nil;
    [_trashBtn release], _trashBtn = nil;
    [_fixedBtnView release], _fixedBtnView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)btnToolTipMouseMove:(NSNotification *)notification {
    NSEvent *event = notification.object;
    if (event) {
        BOOL isClose = YES;
        NSPoint point = [self convertPoint:event.locationInWindow fromView:nil];
        for (NSButton *btn in _allBtnArray) {
            BOOL inner = NSMouseInRect(point, [btn frame], [self isFlipped]);
            if (inner) {
                isClose = NO;
                break;
            }
        }
        if (isClose) {
            NSMutableArray *closeAry = [NSMutableArray array];
            if (_popBtnArray.count > 0) {
                [closeAry addObject:_moreBtn];
            }else {
                [closeAry addObject:_addBtn];
            }
            [closeAry addObject:_historyBtn];
            [closeAry addObject:_shareBtn];
            [closeAry addObject:_starBtn];
            [closeAry addObject:_trashBtn];
            point = [_fixedBtnView convertPoint:event.locationInWindow fromView:nil];
            for (NSButton *btn in closeAry) {
                BOOL inner = NSMouseInRect(point, [btn frame], [self isFlipped]);
                if (inner) {
                    isClose = NO;
                    break;
                }
            }
        }
        if (isClose) {
            [self toolTipViewClose];
        }
    }
}

@end
