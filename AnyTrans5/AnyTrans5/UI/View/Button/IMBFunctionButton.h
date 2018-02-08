//
//  IMBFunctionButton.h
//  iMobieTrans
//
//  Created by iMobie on 3/20/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBButtonLoadingView.h"
@class IMBBackgroundBorderView;
@interface IMBFunctionButton : NSButton{
    NSTrackingArea *trackingArea;
    NSImage *_mouseExitImage;
    NSImage *_mouseEnteredImage;
    NSString *_buttonName;
    NSInteger _evNum;
    NSInteger _badgeCount;
    IMBButtonLoadingView *loadingView;
    NSImageView *_iconiCloudImageView;
//    IMBBackgroundBorderView *_maskView;
    
    int _buttonState;
    
    //新添加 罗磊
    NSImage *_navagationIcon;//导航图标；
    NSImage *_selectIcon;//todevice和clonemerge 选择类别用到
    BOOL _isAndroid;
@private
    BOOL _isEntered;
    BOOL _isCliked;
    BOOL _isContainer;    //此按钮是否是容器
    BOOL _isWhite;        //按钮标题的颜色是否是白色
    BOOL _showbadgeCount;
    BOOL _openiCloud;//是否开启iCloud
    BOOL _containerOpened;//容器展开模式 透明度降50%
}
@property (nonatomic,assign) BOOL isAndroid;
@property (nonatomic,assign) BOOL containerOpened;
@property (nonatomic, retain) NSImage *mouseExitImage;
@property (nonatomic, retain) NSImage *navagationIcon;
@property (nonatomic, retain) NSImage *selectIcon;
@property (nonatomic, retain) NSImage *mouseEnteredImage;
@property (nonatomic, setter = setIsEntered:, getter = isEntered, readwrite) BOOL isEntered;
@property (nonatomic, setter = setIsCliked:, getter = isCliked, readwrite) BOOL isCliked;
@property (nonatomic,assign) BOOL isContainer;
@property (nonatomic,assign) BOOL isWhite;
@property (nonatomic,assign) NSInteger badgeCount;
@property (nonatomic,assign) BOOL showbadgeCount;
@property (nonatomic,retain)NSString *buttonName;
@property (nonatomic,assign)BOOL openiCloud;
-(BOOL)isEntered;
-(void)setIsEntered:(BOOL)isEntered;
- (void)addAndroidLoadingView;
-(BOOL)isCliked;
-(void)setIsCliked:(BOOL)isCliked;
-(void)setImageWithImageName:(NSString *)imageName withButtonName:(NSString *)buttonName;
- (void)addLoadingView;
- (void)showloading:(BOOL)loading;
-(NSMutableAttributedString *)attributedTitle:(BOOL)isEntered;
- (void)changeBtnName;
@end
