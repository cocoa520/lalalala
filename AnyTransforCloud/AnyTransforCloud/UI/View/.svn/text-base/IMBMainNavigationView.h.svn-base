//
//  IMBMainNavigationView.h
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/12.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBWhiteView.h"
#import "IMBDrawOneImageBtn.h"
#import "IMBSVGButton.h"

#define LineSpace 9
#define ButtonSpace 4
#define ButtonSizeWidth 70
#define ButtonSizeHeight 46

@class IMBCloudEntity;
@protocol CloudNavigationDelegate <NSObject>

@optional

- (void)cloudNavigationSwitch:(IMBCloudEntity *)cloudEnity withAddBtn:(NSButton *)btn;

@end

@interface IMBMainNavigationView : NSView<NSAnimationDelegate> {
    id _delegate;
    IMBWhiteView *_lineView;
    IMBWhiteView *_fixedBtnView;
    IMBSVGButton *_addBtn;
    IMBSVGButton *_moreBtn;
    IMBSVGButton *_historyBtn;
    IMBSVGButton *_shareBtn;
    IMBSVGButton *_starBtn;
    IMBSVGButton *_trashBtn;
    NSMutableArray *_showBtnArray;      ///左边显示的按钮数组
    NSMutableArray *_allBtnArray;       ///所有加载按钮数组
    NSMutableArray *_popBtnArray;       ///more按钮中显示的按钮数组
}
@property (nonatomic, retain) IMBWhiteView *fixedBtnView;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) IMBSVGButton *addBtn;
@property (nonatomic, retain) IMBSVGButton *moreBtn;
@property (nonatomic, retain) IMBSVGButton *historyBtn;
@property (nonatomic, retain) NSMutableArray *allBtnArray;
@property (nonatomic, retain) NSMutableArray *showBtnArray;
@property (nonatomic, retain) NSMutableArray *popBtnArray;

/**
 *  增加关联云按钮
 *
 *  @param IMBCloudEntity  对应的实体
 *  @param animateFlag  增加时是否执行动画
 */
- (void)addRelationCloudButton:(IMBCloudEntity *)cloudEntity animate:(BOOL)animateFlag;

/**
 *  移除关联云按钮
 *
 *  @param identifier 按钮的唯一标示
 */
- (void)removeRelationCloudButton:(NSString *)identifier;

/**
 *  把选中的cloud置顶
 *
 *  @param cloudEntity 要改变的对象
 */
- (void)changeCloudButton:(IMBCloudEntity *)cloudEntity;

/**
 *  改变SVG按钮的选中状态
 *
 *  @param isclick YES是选中
 */
- (void)setBottomViewButton:(BOOL)isclick;

/**
 *  按钮的tooltip
 *  @param sender 当前按钮
 *  @param toolTip 显示文字
 */
- (void)showToolTip:(NSButton *)sender withToolTip:(NSString *)toolTip;

/**
 *  按钮的tooltip退出
 */
- (void)toolTipViewClose;

/**
 *  切换页面
 *
 *  @param sender 对应按钮
 */
- (void)switchView:(id)sender;
@end
