//
//  IMBCategoryButtonView.h
//  iMobieTrans
//
//  Created by iMobie on 14-4-28.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
#import "IMBiPod.h"
#import "IMBDeviceInfo.h"
#import "IMBTransparentView.h"
#import "IMBPopupView.h"
#import "IMBFunctionButton.h"
#import "IMBAndroid.h"
typedef void (^CategorybuttonBlock)(CategoryNodesEnum category,IMBFunctionButton *button);
typedef void (^ReloadBlock)(void);
@interface IMBCategoryBarButtonView : NSView<NSAnimationDelegate>
{
    CategorybuttonBlock _catagoryBlock;
    ReloadBlock _reloadBlock;
    IMBiPod *_ipod;
    IMBTransparentView *_transparentView;  //透明的View
    IMBPopupView *_popUpView;   //弹出视图
    NSView     *containerView;
    NSMutableArray *_audioArr;
    NSMutableArray *_videosArr;
    NSMutableArray *_photosArr;
    NSMutableArray *_safraiArr;
    NSMutableArray *_toolsArr;
    NSMutableArray *_systemArr;
    NSMutableArray *_allcategoryArr;//所有的不是容器的按钮
    NSInteger  _currentContainer;  //当前选中的category容器的tag
    NSMutableArray *_categoryArr;//除开容器内的按钮剩下的所有的按钮
    NSMutableArray *_allBtnArr;//所有的按钮
    IMBFunctionButton *currentButton; //当前选中的button
    IMBFunctionButton *startPointButton;
    NSTimer *timer;
    int K;
    BOOL _threadBreak;
    dispatch_queue_t timerqueue;
    IMBFunctionButton *systemButton;
    
    IMBAndroid *_android;
    
    BOOL _isTwo;
    BOOL _isremovePopView;
    BOOL _isDownBtn;
}

@property(nonatomic,retain)IMBiPod *ipod;
@property(nonatomic,retain)IMBAndroid *android;
@property(nonatomic,copy)CategorybuttonBlock catagoryBlock;
@property(nonatomic,copy)ReloadBlock reloadBlock;
@property(nonatomic,retain)IMBTransparentView *transparentView;
@property(nonatomic,retain)IMBPopupView *popUpView;
@property(nonatomic,retain)NSMutableArray *audioArr;
@property(nonatomic,retain)NSMutableArray *videosArr;
@property(nonatomic,retain)NSMutableArray *photosArr;
@property(nonatomic,retain)NSMutableArray *safraiArr;
@property(nonatomic,retain)NSMutableArray *systemArr;
@property(nonatomic,retain)NSMutableArray *allcategoryArr;
@property(nonatomic,assign)NSInteger currentContainer;
@property(nonatomic,retain)NSMutableArray *categoryArr;
@property(nonatomic,retain)NSMutableArray *allBtnArr;
@property(readonly)IMBFunctionButton *currentButton;
@property(nonatomic,assign)NSTimer *timer;
@property(nonatomic,assign)BOOL threadBreak;
- (id)initWithiPod:(IMBiPod*)iPod withFrame:(NSRect)frame;
- (void)initializationCategoryView:(IMBiPod *)iPod withCategoryBlock:(CategorybuttonBlock)categoryBlock;
- (void)initializationCategoryBlock:(CategorybuttonBlock)categoryBlock;
- (void)initializationCategoryAndroid:(IMBAndroid *)android withCategoryBlock:(CategorybuttonBlock)categoryBlock;
- (void)setShowBadgeCount:(BOOL)showBadgeCount;
- (void)addNoContainerButtons;
- (void)addCategoryButtons:(NSMutableArray *)categoryArr;
- (void)reloadPopupViewButtons:(IMBFunctionButton *)sender;

//加载除开media video等等其他数据
- (void)loadothersData:(dispatch_queue_t)queue;
- (void)clickCategory:(IMBFunctionButton *)sender;
@end
