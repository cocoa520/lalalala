//
//  IMBCloudCategoryView.m
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/10.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBCloudCategoryView.h"
#import "StringHelper.h"
#import "IMBAnimation.h"
#import "IMBCloudManager.h"

@implementation IMBCloudCategoryView
@synthesize delegate = _delegate;
@synthesize titleBtnDic = _titleBtnDic;

- (void)awakeFromNib {
    _titleBtnDic = [[NSMutableDictionary alloc] init];
//    int firstX = ceilf((self.frame.size.width - _titleOneBtn.frame.size.width - _titleTwoBtn.frame.size.width - _titleThreeBtn.frame.size.width - _titleFourBtn.frame.size.width - 3*50)/2);
    IMBCloudManager *manager = [IMBCloudManager singleton];
    int firstX = self.frame.size.width - (manager.categroyAryM.count-1)*50;
    int oneBtnW = 0;
    int twoBtnW = 0;
    int threeBtnW = 0;
    int fourBtnW = 0;
    int fiveBtnW = 0;
//    int sixBtnW = 0;
    int tag = 0;
    for (NSString *key in manager.categroyAryM) {
        NSRect rect;
        NSString *titleStr = @"";
        NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:14];
        if ([key isEqualToString:@"popular"]) {
            titleStr = CustomLocalizedString(@"AddCloud_Classify_Popular", nil);
            rect = [StringHelper calcuTextBounds:titleStr font:font];
            oneBtnW = rect.size.width;
            tag = 101;
        }else if ([key isEqualToString:@"personal"]) {
            titleStr = CustomLocalizedString(@"AddCloud_Classify_Personal", nil);
            rect = [StringHelper calcuTextBounds:titleStr font:font];
            twoBtnW = rect.size.width;
            tag = 102;
        }else if ([key isEqualToString:@"application"]) {
            titleStr = CustomLocalizedString(@"AddCloud_Classify_App", nil);
            rect = [StringHelper calcuTextBounds:titleStr font:font];
            threeBtnW = rect.size.width;
            tag = 103;
        }else if ([key isEqualToString:@"business"]) {
            titleStr = CustomLocalizedString(@"AddCloud_Classify_Business", nil);
            rect = [StringHelper calcuTextBounds:titleStr font:font];
            fourBtnW = rect.size.width;
            tag = 104;
        }else if ([key isEqualToString:@"other"]) {
            titleStr = CustomLocalizedString(@"AddCloud_Classify_Other", nil);
            rect = [StringHelper calcuTextBounds:titleStr font:font];
            fiveBtnW = rect.size.width;
            tag = 105;
        }else if ([key isEqualToString:@"mycloud"]) {
            titleStr = CustomLocalizedString(@"AddCloud_Classify_My", nil);
            rect = [StringHelper calcuTextBounds:titleStr font:font];
//            sixBtnW = rect.size.width;
            tag = 106;
        }
        IMBSelectedButton *titleOBtn = [[IMBSelectedButton alloc] initWithFrame:NSMakeRect(0, 0, rect.size.width, 20)];
        [titleOBtn setEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] downColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] ExitColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] SelectColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] titleFont:font buttonTitle:titleStr];
        [titleOBtn setIsSelect:NO];
        [titleOBtn setTag:tag];
        [titleOBtn setTarget:self];
        [titleOBtn setAction:@selector(buttonMouseDown:)];
        [titleOBtn setNeedsDisplay:YES];
        [_titleBtnDic setObject:titleOBtn forKey:key];
        firstX -= titleOBtn.frame.size.width;
        [titleOBtn release];
    }
    /*
    NSString *titleStr = CustomLocalizedString(@"AddCloud_Classify_Popular", nil);
    NSRect rect = [StringHelper calcuTextBounds:titleStr font:font];
    _titleOneBtn = [[IMBSelectedButton alloc] initWithFrame:NSMakeRect(0, 0, rect.size.width, 20)];
    [_titleOneBtn setEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] downColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] ExitColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] SelectColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] titleFont:font buttonTitle:titleStr];
    [_titleOneBtn setIsSelect:YES];
    [_titleOneBtn setTag:101];
    [_titleOneBtn setTarget:self];
    [_titleOneBtn setAction:@selector(buttonMouseDown:)];
    [_titleOneBtn setNeedsDisplay:YES];
    [self addSubview:_titleOneBtn];
    
    titleStr = CustomLocalizedString(@"AddCloud_Classify_Social", nil);
    rect = [StringHelper calcuTextBounds:titleStr font:font];
    _titleTwoBtn = [[IMBSelectedButton alloc] initWithFrame:NSMakeRect(200, 0, rect.size.width, 20)];
    [_titleTwoBtn setEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] downColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] ExitColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] SelectColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] titleFont:[NSFont fontWithName:@"Helvetica Neue" size:14] buttonTitle:titleStr];
    [_titleTwoBtn setTag:102];
    [_titleTwoBtn setTarget:self];
    [_titleTwoBtn setAction:@selector(buttonMouseDown:)];
    [_titleTwoBtn setNeedsDisplay:YES];
    [self addSubview:_titleTwoBtn];
    
    titleStr = CustomLocalizedString(@"AddCloud_Classify_Free", nil);
    rect = [StringHelper calcuTextBounds:titleStr font:font];
    _titleThreeBtn = [[IMBSelectedButton alloc] initWithFrame:NSMakeRect(300, 0, rect.size.width, 20)];
    [_titleThreeBtn setEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] downColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] ExitColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] SelectColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] titleFont:[NSFont fontWithName:@"Helvetica Neue" size:14] buttonTitle:titleStr];
    [_titleThreeBtn setTag:103];
    [_titleThreeBtn setTarget:self];
    [_titleThreeBtn setAction:@selector(buttonMouseDown:)];
    [_titleThreeBtn setNeedsDisplay:YES];
    [self addSubview:_titleThreeBtn];
    
    titleStr = CustomLocalizedString(@"AddCloud_Classify_Personal", nil);
    rect = [StringHelper calcuTextBounds:titleStr font:font];
    _titleFourBtn = [[IMBSelectedButton alloc] initWithFrame:NSMakeRect(400, 0, rect.size.width, 20)];
    [_titleFourBtn setEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] downColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] ExitColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] SelectColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] titleFont:[NSFont fontWithName:@"Helvetica Neue" size:14] buttonTitle:titleStr];
    [_titleFourBtn setTag:104];
    [_titleFourBtn setTarget:self];
    [_titleFourBtn setAction:@selector(buttonMouseDown:)];
    [_titleFourBtn setNeedsDisplay:YES];
    [self addSubview:_titleFourBtn];
     */
    
    firstX = firstX / 2;
    _lineOneX = 0;
    _lineTwoX = 0;
    _lineThreeX = 0;
    _lineFourX = 0;
    _lineFiveX = 0;
    _lineSixX = 0;
    _selectLineView = [[IMBWhiteView alloc] initWithFrame:NSMakeRect(_lineOneX, 0, 62, 3)];
    [_selectLineView setCornerRadius:0];
    [_selectLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
    for (NSString *key in _titleBtnDic.allKeys) {
        IMBSelectedButton *btn = [_titleBtnDic objectForKey:key];
        if ([key isEqualToString:@"popular"]) {
            [btn setFrameOrigin:NSMakePoint(firstX, 16)];
            _lineOneX = btn.frame.origin.x + (btn.frame.size.width - _selectLineView.frame.size.width)/2;
        }else if ([key isEqualToString:@"personal"]) {
            int addX = 0;
            if (oneBtnW > 0) {
                addX = 50;
            }
            [btn setFrameOrigin:NSMakePoint(firstX + oneBtnW + addX, 16)];
            _lineTwoX = btn.frame.origin.x + (btn.frame.size.width - _selectLineView.frame.size.width)/2;
        }else if ([key isEqualToString:@"application"]) {
            int addX = 0;
            if (oneBtnW > 0) {
                addX += 50;
            }
            if (twoBtnW > 0) {
                addX += 50;
            }
            [btn setFrameOrigin:NSMakePoint(firstX + oneBtnW + twoBtnW + addX, 16)];
            _lineThreeX = btn.frame.origin.x + (btn.frame.size.width - _selectLineView.frame.size.width)/2;
        }else if ([key isEqualToString:@"business"]) {
            int addX = 0;
            if (oneBtnW > 0) {
                addX += 50;
            }
            if (twoBtnW > 0) {
                addX += 50;
            }
            if (threeBtnW > 0) {
                addX += 50;
            }
            [btn setFrameOrigin:NSMakePoint(firstX + oneBtnW + twoBtnW + threeBtnW + addX, 16)];
            _lineFourX = btn.frame.origin.x + (btn.frame.size.width - _selectLineView.frame.size.width)/2;
        }else if ([key isEqualToString:@"other"]) {
            int addX = 0;
            if (oneBtnW > 0) {
                addX += 50;
            }
            if (twoBtnW > 0) {
                addX += 50;
            }
            if (threeBtnW > 0) {
                addX += 50;
            }
            if (fourBtnW > 0) {
                addX += 50;
            }
            [btn setFrameOrigin:NSMakePoint(firstX + oneBtnW + twoBtnW + threeBtnW + fourBtnW + addX, 16)];
            _lineFiveX = btn.frame.origin.x + (btn.frame.size.width - _selectLineView.frame.size.width)/2;
        }else if ([key isEqualToString:@"mycloud"]) {
            int addX = 0;
            if (oneBtnW > 0) {
                addX += 50;
            }
            if (twoBtnW > 0) {
                addX += 50;
            }
            if (threeBtnW > 0) {
                addX += 50;
            }
            if (fourBtnW > 0) {
                addX += 50;
            }
            if (fiveBtnW > 0) {
                addX += 50;
            }
            [btn setFrameOrigin:NSMakePoint(firstX + oneBtnW + twoBtnW + threeBtnW + fourBtnW + fiveBtnW + addX, 16)];
            _lineSixX = btn.frame.origin.x + (btn.frame.size.width - _selectLineView.frame.size.width)/2;
        }
        [self addSubview:btn];
    }
    if (_lineOneX > 0) {
        [_selectLineView setFrameOrigin:NSMakePoint(_lineOneX, _selectLineView.frame.origin.y)];
        IMBSelectedButton *btn = [_titleBtnDic objectForKey:@"popular"];
        [btn setIsSelect:YES];
    }else if (_lineTwoX > 0) {
        [_selectLineView setFrameOrigin:NSMakePoint(_lineTwoX, _selectLineView.frame.origin.y)];
        IMBSelectedButton *btn = [_titleBtnDic objectForKey:@"personal"];
        [btn setIsSelect:YES];
    }else if (_lineTwoX > 0) {
        [_selectLineView setFrameOrigin:NSMakePoint(_lineThreeX, _selectLineView.frame.origin.y)];
        IMBSelectedButton *btn = [_titleBtnDic objectForKey:@"application"];
        [btn setIsSelect:YES];
    }else if (_lineTwoX > 0) {
        [_selectLineView setFrameOrigin:NSMakePoint(_lineFourX, _selectLineView.frame.origin.y)];
        IMBSelectedButton *btn = [_titleBtnDic objectForKey:@"business"];
        [btn setIsSelect:YES];
    }else if (_lineTwoX > 0) {
        [_selectLineView setFrameOrigin:NSMakePoint(_lineFiveX, _selectLineView.frame.origin.y)];
        IMBSelectedButton *btn = [_titleBtnDic objectForKey:@"other"];
        [btn setIsSelect:YES];
    }else if (_lineTwoX > 0) {
        [_selectLineView setFrameOrigin:NSMakePoint(_lineSixX, _selectLineView.frame.origin.y)];
        IMBSelectedButton *btn = [_titleBtnDic objectForKey:@"mycloud"];
        [btn setIsSelect:YES];
    }
    
    [self addSubview:_selectLineView];
}

-(void)buttonMouseDown:(id)sender {
    IMBSelectedButton *btn = (IMBSelectedButton *)sender;
    NSEvent *event = nil;
    if (btn.tag == 101) {
        for (NSString *key in _titleBtnDic.allKeys) {
            IMBSelectedButton *selectBtn = [_titleBtnDic objectForKey:key];
            if (selectBtn.tag == 101) {
                [selectBtn setIsSelect:YES];
                [selectBtn mouseEntered:event];
            }else if (selectBtn.tag == 102) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 103) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 104) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 105) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 106) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }
        }
        [self lineAnimationMoveX:_lineOneX];
    }else if (btn.tag == 102) {
        for (NSString *key in _titleBtnDic.allKeys) {
            IMBSelectedButton *selectBtn = [_titleBtnDic objectForKey:key];
            if (selectBtn.tag == 101) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 102) {
                [selectBtn setIsSelect:YES];
                [selectBtn mouseEntered:event];
            }else if (selectBtn.tag == 103) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 104) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 105) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 106) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }
        }
        [self lineAnimationMoveX:_lineTwoX];
    }else if (btn.tag == 103) {
        for (NSString *key in _titleBtnDic.allKeys) {
            IMBSelectedButton *selectBtn = [_titleBtnDic objectForKey:key];
            if (selectBtn.tag == 101) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 102) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 103) {
                [selectBtn setIsSelect:YES];
                [selectBtn mouseEntered:event];
            }else if (selectBtn.tag == 104) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 105) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 106) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }
        }
        [self lineAnimationMoveX:_lineThreeX];
    }else if (btn.tag == 104) {
        for (NSString *key in _titleBtnDic.allKeys) {
            IMBSelectedButton *selectBtn = [_titleBtnDic objectForKey:key];
            if (selectBtn.tag == 101) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 102) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 103) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 104) {
                [selectBtn setIsSelect:YES];
                [selectBtn mouseEntered:event];
            }else if (selectBtn.tag == 105) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 106) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }
        }
        [self lineAnimationMoveX:_lineFourX];
    }else if (btn.tag == 105) {
        for (NSString *key in _titleBtnDic.allKeys) {
            IMBSelectedButton *selectBtn = [_titleBtnDic objectForKey:key];
            if (selectBtn.tag == 101) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 102) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 103) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 104) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 105) {
                [selectBtn setIsSelect:YES];
                [selectBtn mouseEntered:event];
            }else if (selectBtn.tag == 106) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }
        }
        [self lineAnimationMoveX:_lineFiveX];
    }else if (btn.tag == 106) {
        for (NSString *key in _titleBtnDic.allKeys) {
            IMBSelectedButton *selectBtn = [_titleBtnDic objectForKey:key];
            if (selectBtn.tag == 101) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 102) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 103) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 104) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 105) {
                [selectBtn setIsSelect:NO];
                [selectBtn mouseExited:event];
            }else if (selectBtn.tag == 106) {
                [selectBtn setIsSelect:YES];
                [selectBtn mouseEntered:event];
            }
        }
        [self lineAnimationMoveX:_lineSixX];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(cloudCategory:)]) {
        [_delegate cloudCategory:btn];
    }
}
    
- (void)lineAnimationMoveX:(int)moveX {
    NSViewAnimation *animation = nil;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        //属性字典
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //设置目标对象
        [dict setObject:_selectLineView forKey:NSViewAnimationTargetKey];
        //设置其实大小
        [dict setObject:[NSValue valueWithRect:NSMakeRect(_selectLineView.frame.origin.x,  _selectLineView.frame.origin.y, _selectLineView.frame.size.width, _selectLineView.frame.size.height)] forKey:NSViewAnimationStartFrameKey];
        //设置最终大小
        [dict setObject:[NSValue valueWithRect:NSMakeRect(moveX,  _selectLineView.frame.origin.y , _selectLineView.frame.size.width, _selectLineView.frame.size.height)] forKey:NSViewAnimationEndFrameKey];
        
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

- (void)setSelectBtn:(IMBSelectedButton *)btn {
    [self buttonMouseDown:btn];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)dealloc {
    [_titleBtnDic release], _titleBtnDic = nil;
//    [_titleTwoBtn release], _titleTwoBtn = nil;
//    [_titleThreeBtn release], _titleThreeBtn = nil;
//    [_titleFourBtn release], _titleFourBtn = nil;
    [_selectLineView release], _selectLineView = nil;
    [super dealloc];
}

@end
