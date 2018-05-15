//
//  IMBSearchView.m
//  AnyTransforCloud
//
//  Created by hym on 26/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBSearchView.h"
#import "IMBDrawImageBtn.h"
#import "IMBWhiteView.h"
#import "StringHelper.h"
#import "IMBMainPageViewController.h"
#import "IMBCloudEntity.h"
#import "IMBAnimation.h"

@implementation IMBSearchView
@synthesize searchType = _searchType;
@synthesize delegate = _delegate;
@synthesize selectedCloudEntity = _selectedCloudEntity;

- (void)awakeFromNib {
    [self setWantsLayer:YES];
    [_pullDownBtn mouseDownImage:[NSImage imageNamed:@"search_arrow3"] withMouseUpImg:[NSImage imageNamed:@"search_arrow2"] withMouseExitedImg:[NSImage imageNamed:@"search_arrow1"] mouseEnterImg:[NSImage imageNamed:@"search_arrow2"]];
    [_pullDownBtn setTarget:self];
    [_pullDownBtn setAction:@selector(pullDown:)];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_lineColor", nil)]];
    [_searchBtn mouseDownImage:[NSImage imageNamed:@"search_ser3"] withMouseUpImg:[NSImage imageNamed:@"search_ser2"] withMouseExitedImg:[NSImage imageNamed:@"search_ser1"] mouseEnterImg:[NSImage imageNamed:@"search_ser2"]];
    [_searchBtn setTarget:self];
    [_searchBtn setAction:@selector(search:)];
    
    [_clearSearchBtn mouseDownImage:[NSImage imageNamed:@"search_close3"] withMouseUpImg:[NSImage imageNamed:@"search_close2"] withMouseExitedImg:[NSImage imageNamed:@"search_close1"] mouseEnterImg:[NSImage imageNamed:@"search_close2"]];
    [_clearSearchBtn setTarget:self];
    [_clearSearchBtn setAction:@selector(clearSearchContent:)];
    
    [_eyeBtn mouseDownImage:[NSImage imageNamed:@"search_openeye3"] withMouseUpImg:[NSImage imageNamed:@"search_openeye2"] withMouseExitedImg:[NSImage imageNamed:@"search_openeye1"] mouseEnterImg:[NSImage imageNamed:@"search_openeye2"]];
    _eyeType = openEye;
    [_eyeBtn setHidden:YES];
    [_eyeBtn setTarget:self];
    [_eyeBtn setAction:@selector(openOrCloseEye:)];
    
    [_searchTextFiled setPlaceholderString:CustomLocalizedString(@"SearchControl_Tips", nil)];
    [_searchTextFiled setDrawsBackground:NO];
    [_searchTextFiled setBordered:NO];
    [_searchTextFiled setFocusRingType:NSFocusRingTypeNone];
    [_firstLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_secondLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_thirdLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_fourthLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_nameTextFiled setEditable:NO];
    [_nameTextFiled setDrawsBackground:NO];
    [_nameTextFiled setStringValue:CustomLocalizedString(@"SearchControl_CloudName", nil)];
     [_nameTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_typeTextFiled setEditable:NO];
    [_typeTextFiled setDrawsBackground:NO];
    [_typeTextFiled setStringValue:CustomLocalizedString(@"SearchControl_Type", nil)];
    [_typeTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_TimeTextFiled setEditable:NO];
    [_TimeTextFiled setDrawsBackground:NO];
    [_TimeTextFiled setStringValue:CustomLocalizedString(@"SearchControl_Time", nil)];
    [_TimeTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_namePullDownBtn mouseDownImage:[NSImage imageNamed:@"search_arrow3"] withMouseUpImg:[NSImage imageNamed:@"search_arrow2"] withMouseExitedImg:[NSImage imageNamed:@"search_arrow1"] mouseEnterImg:[NSImage imageNamed:@"search_arrow2"]];
    [_namePullDownBtn setTarget:self];
    [_namePullDownBtn setAction:@selector(chooseParameter:)];
    
    [_typePullDownBtn mouseDownImage:[NSImage imageNamed:@"search_arrow3"] withMouseUpImg:[NSImage imageNamed:@"search_arrow2"] withMouseExitedImg:[NSImage imageNamed:@"search_arrow1"] mouseEnterImg:[NSImage imageNamed:@"search_arrow2"]];
    [_typePullDownBtn setTarget:self];
    [_typePullDownBtn setAction:@selector(chooseParameter:)];
    
    [_timePullDownBtn mouseDownImage:[NSImage imageNamed:@"search_arrow3"] withMouseUpImg:[NSImage imageNamed:@"search_arrow2"] withMouseExitedImg:[NSImage imageNamed:@"search_arrow1"] mouseEnterImg:[NSImage imageNamed:@"search_arrow2"]];
    [_timePullDownBtn setTarget:self];
    [_timePullDownBtn setAction:@selector(chooseParameter:)];
    
    [_selectedNameTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_selectedTypeTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_selectedTimeTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    _searchBgView = [[IMBWhiteView alloc] initWithFrame:NSMakeRect(10, 2, self.frame.size.width - 20, 2)];
    [_searchBgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
    _lightLayer = [[CALayer alloc] init];
}

- (void)setSearchType:(searchTypeEnum)searchType {
    _searchType = searchType;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
        NSRect newRect = NSMakeRect(dirtyRect.origin.x+5, dirtyRect.origin.y+3, self.frame.size.width-10, self.frame.size.height -5);
    if (_searchType == unUseType) {
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:5 yRadius:5];
        [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
        [path fill];
        [path closePath];
        [[StringHelper getColorFromString:CustomColor(@"text_lineColor", nil)] setStroke];
        path.lineWidth = 0.5;
        [path stroke];
        [path addClip];
    }else if(_searchType == useType) {
        if (_shadow) {
            [_shadow release];
            _shadow = nil;
        }
        _shadow = [[NSShadow alloc] init];
        [_shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"shadow_Color", nil)]];
        [_shadow setShadowOffset:NSMakeSize(0.0, -2.0)];
        [_shadow setShadowBlurRadius:4.0];
        [_shadow set];
        
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:5 yRadius:5];
        [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
        [path fill];
        [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setStroke];
        path.lineWidth = 0.3;
        [path stroke];
        [path closePath];
    }else {
        if (_shadow) {
            [_shadow release];
            _shadow = nil;
        }
        _shadow = [[NSShadow alloc] init];
        [_shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"shadow_Color", nil)]];
        [_shadow setShadowOffset:NSMakeSize(0.0, -2.0)];
        [_shadow setShadowBlurRadius:4.0];
        [_shadow set];
        
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:5 yRadius:5];
        [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
        [path fill];
        [[StringHelper getColorFromString:CustomColor(@"search_borderColor", nil)] setStroke];
        path.lineWidth = 0.3;
        [path stroke];
        [path closePath];
    }
}

#pragma mark - action
- (void)pullDown:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(pullDownSearchView)]) {
        [_delegate pullDownSearchView];
    }
}

- (void)chooseParameter:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(pullDownSearchParameter:)]) {
        [_delegate pullDownSearchParameter:sender];
    }
}

- (void)clearSearchContent:(id)sender {
    [_searchBtn setHidden:NO];
    [_eyeBtn setHidden:YES];
    [_searchTextFiled setStringValue:@""];
    [_lightLayer removeAllAnimations];
    [_searchBgView removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(clearSearch:)]) {
        [_delegate clearSearch:sender];
    }
}

- (void)openOrCloseEye:(id)sender {
    if (_eyeType == openEye) {
        _eyeType = closeEye;
        [_eyeBtn mouseDownImage:[NSImage imageNamed:@"search_eye3"] withMouseUpImg:[NSImage imageNamed:@"search_eye2"] withMouseExitedImg:[NSImage imageNamed:@"search_eye1"] mouseEnterImg:[NSImage imageNamed:@"search_eye2"]];
    }else {
        _eyeType = openEye;
         [_eyeBtn mouseDownImage:[NSImage imageNamed:@"search_openeye3"] withMouseUpImg:[NSImage imageNamed:@"search_openeye2"] withMouseExitedImg:[NSImage imageNamed:@"search_openeye1"] mouseEnterImg:[NSImage imageNamed:@"search_openeye2"]];
    }
    [_eyeBtn setNeedsDisplay:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(showOrCloseSearchResult:)]) {
        [_delegate showOrCloseSearchResult:sender];
    }
}

- (void)search:(id)sender {
    if ([StringHelper stringIsNilOrEmpty:_searchTextFiled.stringValue]) {
        return;
    }
    [self addSubview:_searchBgView];
    
    NSImage *image = [NSImage imageNamed:@"search_light"];
    _lightLayer.contents = image;
    _lightLayer.frame = NSMakeRect(0, 0, image.size.width, image.size.height);
    [_searchBgView setWantsLayer:YES];
    [_searchBgView.layer addSublayer:_lightLayer];
    CAAnimation *animation = [IMBAnimation moveX:2.0 fromX:0 toX:[NSNumber numberWithFloat:_searchBgView.frame.size.width] repeatCount:NSIntegerMax beginTime:0.0];
    [_lightLayer addAnimation:animation forKey:@"11"];
    
    [_searchBtn setHidden:YES];
    [_eyeBtn setHidden:NO];
    if (_delegate && [_delegate respondsToSelector:@selector(startSearch:)]) {
        [_delegate startSearch:sender];
    }
}

- (BOOL)mouseDownCanMoveWindow {
    return NO;
}

- (void)mouseDown:(NSEvent *)theEvent {
    
}

- (void)mouseUp:(NSEvent *)theEvent {
    
}



- (void)dealloc {
    if (_shadow) {
        [_shadow release];
        _shadow = nil;
    }
    [super dealloc];
}

@end
