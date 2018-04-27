//
//  CenterTextFieidCell.h
//  AppDemo
//
//  Created by zhang yang on 13-3-6.
//  Copyright (c) 2013年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LoadingView.h"
@interface IMBCenterTextFieldCell : NSTextFieldCell{
    
    id _nodeDetail;
    id _mouseMoveNodeDetail;
    NSColor *_titleColor;
    NSColor *_hilightTitleColor;
    float _fontSize;
    BOOL _isLoading;//是否正在加载
    LoadingView *_loadingView;
}

@property (nonatomic,assign)LoadingView *loadingView;
@property (nonatomic,assign)BOOL isLoading;
@property (nonatomic, assign) id nodeDetail;
@property (nonatomic, assign) id mouseMoveNodeDetail;//鼠标移动到某行时的节点
@property (nonatomic, retain) NSColor *titleColor;
@property (nonatomic, retain) NSColor *hilightTitleColor;
@property (nonatomic, assign) float fontSize;
@end
