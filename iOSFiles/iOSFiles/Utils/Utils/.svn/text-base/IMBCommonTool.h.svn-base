//
//  IMBCommonTool.h
//  iOSFiles
//
//  Created by iMobie on 2018/3/14.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <AppKit/AppKit.h>
@class IMBiPod;

APPKIT_EXTERN NSString * const IMBAlertViewiCloudKey;
APPKIT_EXTERN NSString * const IMBAlertViewDropBoxKey;

@interface IMBCommonTool : NSObject
/**
 *  设置view的背景颜色
 *
 *  @param view      view
 *  @param bgColor   背景颜色值
 *  @param delta     差值
 *  @param radius    弧度
 *  @param dirtyRect frame
 */
+ (void)setViewBgWithView:(NSView *)view color:(NSColor *)bgColor delta:(CGFloat)delta radius:(CGFloat)radius dirtyRect:(NSRect)dirtyRect;

/**
 *  显示单个ok按钮的下拉提示框，当界面是dropbox时，isDetailWindow参数传入 IMBAlertViewDropBoxKey  当界面是iCloud时，isDetailWindow参数传入 IMBAlertViewiCloudKey  当界面是device时，isDetailWindow参数传入 ipod.uniqueKey
 *
 *  @param isMainWindow    是否显示在mainwindow上
 *  @param btnTitle        btn的title
 *  @param msgText         显示的提示信息
 *  @param btnClickedBlock 按钮点击响应事件
 */
+ (void)showSingleBtnAlertInMainWindow:(NSString *)isDetailWindow btnTitle:(NSString *)btnTitle msgText:(NSString *)msgText btnClickedBlock:(void(^)(void))btnClickedBlock;
+ (void)showSingleBtnAlertInMainWindow:(NSString *)isDetailWindow alertTitle:(NSString *)alertTitle btnTitle:(NSString *)btnTitle msgText:(NSString *)msgText btnClickedBlock:(void(^)(void))btnClickedBlock;

/**
 *  显示单个两个按钮的下拉提示框，当界面是dropbox时，isDetailWindow参数传入 IMBAlertViewDropBoxKey  当界面是iCloud时，isDetailWindow参数传入 IMBAlertViewiCloudKey  当界面是device时，isDetailWindow参数传入 ipod.uniqueKey
 *
 *  @param isMainWindow          是否显示在mainwindow上
 *  @param firstTitle            第一个btn的title
 *  @param secondTitle           第二个btn的title
 *  @param msgText               显示的提示信息
 *  @param firstBtnClickedBlock  第一个按钮点击响应事件
 *  @param secondBtnClickedBlock 第二个按钮点击响应事件
 */
+ (void)showTwoBtnsAlertInMainWindow:(NSString *)isDetailWindow firstBtnTitle:(NSString *)firstTitle secondBtnTitle:(NSString *)secondTitle msgText:(NSString *)msgText firstBtnClickedBlock:(void(^)(void))firstBtnClickedBlock secondBtnClickedBlock:(void(^)(void))secondBtnClickedBlock;
+ (void)showTwoBtnsAlertInMainWindow:(NSString *)isDetailWindow alertTitle:(NSString *)alertTitle firstBtnTitle:(NSString *)firstTitle secondBtnTitle:(NSString *)secondTitle msgText:(NSString *)msgText firstBtnClickedBlock:(void(^)(void))firstBtnClickedBlock secondBtnClickedBlock:(void(^)(void))secondBtnClickedBlock;
/**
 *  上传文件时，对于openpanel能打开什么样的文件进行判断返回
 *
 *  @param category 传入的分类进行筛选返回
 *
 *  @return 返回能打开的文件类型数组
 */
+ (NSArray <NSString *>*)getOpenPanelSuffxiWithCategory:(CategoryNodesEnum)category;

/**
 *  加载book封面
 *
 *  @param array iBooks array
 *  @param ipod  ipod
 */
+ (void)loadbookCover:(NSArray *)array ipod:(IMBiPod *)ipod;
/**
 *  显示双重验证view
 *
 *  @param cancelClicked cancel按钮取消
 *  @param okClicked     ok按钮取消
 */
+ (void)showDoubleVerificationViewIsDetailWindow:(NSString *)isDetailWindow CancelClicked:(void (^)(void))cancelClicked okClicked:(void (^)(NSString *codeId))okClicked;


@end
