//
//  IMBOutlineCellView.m
//  AnyTransforCloud
//
//  Created by hym on 01/05/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBOutlineCellView.h"
#import "IMBOutlineTriangleView.h"
#import "IMBDriveModel.h"
#import "IMBMoveAlertViewController.h"
#import "StringHelper.h"
@implementation IMBOutlineCellView
@synthesize triangleView = _triangleView;
@synthesize name = _name;
@synthesize model = _model;
@synthesize delegate = _delegate;
@synthesize imgView = _imgView;
- (void)awakeFromNib {
    [_name setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
}

- (void)setModel:(IMBDriveModel *)model {
    if (_model) {
        [_model release];
        _model = nil;
    }
    _model = [model retain];
    [_name setStringValue: model.fileName];
    [_imgView setImage:model.iConimage];
    [_triangleView setShowType:model.showType];
    [_triangleView setTarget:self];
    [_triangleView setAction:@selector(changeTriangleState)];
    [_triangleView setNeedsDisplay:YES];
    [_model addObserver:self forKeyPath:@"showType" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"showType"] && [object isEqual:_model]) {
        showTypeEnum type = [[change objectForKey:@"new"] intValue];
        [_triangleView setShowType:type];
        [_triangleView setNeedsDisplay:YES];
    }
}

- (void)changeTriangleState {
    if (_delegate && [_delegate respondsToSelector:@selector(changeDriveState:)]) {
        [_delegate changeDriveState:_model];
    }
}

- (void)dealloc {
    [_model removeObserver:self forKeyPath:@"showType"];
    if (_model) {
        [_model release];
        _model = nil;
    }
    [super dealloc];
    
}

@end
