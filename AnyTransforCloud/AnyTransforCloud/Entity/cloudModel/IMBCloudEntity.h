//
//  IMBCloudEntity.h
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/16.
//  Copyright © 2018年 IMB. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"
@class IMBiCloudDriveManager;
@interface IMBCloudEntity : NSObject
{
    NSString *_name;
    NSImage *_image;
    NSString *_email;
    CategoryCloudNameEnum _categoryCloudEnum;
    NSString *_driveID;
    BOOL _isBottomItem;
    NSString *_lastVisitTime;
    long long _totalSize;
    long long _availableSize;
    int _usersNumber;///用户数
    NSMutableArray *_cloudAry;///装more btn展示的cloud
    BOOL _isClick;
    
    NSString *_category;
    NSString *_service;
    int _popular;
    
    BOOL _isHidden;
    NSString *_showSize;
    BOOL _isAddHidden;
}
@property (nonatomic,assign) CategoryCloudNameEnum categoryCloudEnum;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,assign) BOOL isHidden;
@property (nonatomic,retain) NSString *driveID;
@property (nonatomic,retain) NSImage *image;
@property (nonatomic,assign) BOOL isBottomItem;
@property (nonatomic,retain) NSString *lastVisitTime;
@property (nonatomic,assign) long long totalSize;
@property (nonatomic,assign) long long availableSize;
@property (nonatomic,assign) int usersNumber;
@property (nonatomic,retain) NSMutableArray *cloudAry;
@property (nonatomic,assign) BOOL isClick;
@property (nonatomic,retain) NSString *category;
@property (nonatomic,retain) NSString *service;
@property (nonatomic,assign) int popular;
@property (nonatomic,retain) NSString *showSize;
@property (nonatomic,assign) BOOL isAddHidden;
@end
