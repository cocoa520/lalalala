//
//  CenterTextFieidCell.h
//  AppDemo
//
//  Created by zhang yang on 13-3-6.
//  Copyright (c) 2013年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
@interface IMBCenterTextFieldCell : NSTextFieldCell{
    
    id _nodeDetail;
    id _mouseMoveNodeDetail;
    NSColor *_titleColor;
    NSColor *_hilightTitleColor;
    float _fontSize;
    BOOL _isLoading;//是否正在加载
    BOOL _isLastCell;
    BOOL _isExist;
    BOOL _isRighVale;
    BOOL _isDeleted;
    BOOL _isExistAndDeleted;
    BOOL _isItem;
    BOOL _isExplainColor;
    CategoryNodesEnum _category;
//    IMBADAudioTrack
//    IMBADVideoTrack
    id _entity;
}
@property (nonatomic,assign) CategoryNodesEnum category;
@property (nonatomic,retain) id entity;
@property (nonatomic,assign)BOOL isRighVale;
@property (nonatomic,assign)BOOL isExist;
@property (nonatomic,assign)BOOL isLoading;
@property (nonatomic, assign) id nodeDetail;
@property (nonatomic, assign) id mouseMoveNodeDetail;//鼠标移动到某行时的节点
@property (nonatomic, retain) NSColor *titleColor;
@property (nonatomic, retain) NSColor *hilightTitleColor;
@property (nonatomic, assign) float fontSize;
@property(nonatomic, assign) BOOL isLastCell;
@property (nonatomic, assign) BOOL isDeleted;
@property (nonatomic, assign) BOOL isExistAndDeleted;
@property(nonatomic, assign) BOOL isItem;
@property(nonatomic, assign) BOOL isExplainColor;
@end
