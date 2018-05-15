//
//  IMBCloudEntity.h
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/16.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"
@interface IMBCloudEntity : NSObject
{
    NSString *_name;
    NSImage *_image;
    NSImage *_popoverImage;
    NSImage *_rightNavigationImage;
    NSImage *_collectViewImage;
    NSImage *_popoverHoverImage;
    CategoryCloudNameEnum _categoryCloudEnum;
    NSString *_driveID;
    BOOL _isBottomItem;
    NSString *_lastVisitTime;
    long long _totalSize;
    long long _availableSize;
    int _usersNumber;///用户数
    NSMutableArray *_cloudAry;///装more展示的cloud
    BOOL _isClick;
}
@property (nonatomic,assign) CategoryCloudNameEnum categoryCloudEnum;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *driveID;
@property (nonatomic,retain) NSImage *image;
@property (nonatomic,retain) NSImage *popoverImage;
@property (nonatomic,retain) NSImage *popoverHoverImage;
@property (nonatomic,retain) NSImage *rightNavigationImage;
@property (nonatomic,retain) NSImage *collectViewImage;
@property (nonatomic,assign) BOOL isBottomItem;
@property (nonatomic,retain) NSString *lastVisitTime;
@property (nonatomic,assign) long long totalSize;
@property (nonatomic,assign) long long availableSize;
@property (nonatomic,assign) int usersNumber;
@property (nonatomic,retain) NSMutableArray *cloudAry;
@property (nonatomic,assign) BOOL isClick;
@end
