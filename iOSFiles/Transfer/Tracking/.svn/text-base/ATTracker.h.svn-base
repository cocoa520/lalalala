//
//  ATTracker.h
//  AnytransTracking
//
//  Created by JGehry on 10/13/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonEnum.h"

@interface ATTracker : NSObject {
@private
    NSString *_cid;
    NSString *_appName;
    NSString *_appVersion;
    NSString *_MPVersion;
    NSString *_ua;
    NSString *_tid;
}

/**
 *   建立Google Analytics连接
 *
 *  @param tid = Google Analytics property id
 */
+ (void)setupWithTrackingID:(NSString *)tid;

/**
 *  构建事件跟踪
 *
 *  @param category             事件类别
 *  @param action               事件操作
 *  @param label                事件标签
 *  @param labelParameters      事件标签描述
 *  @param transferCount        传输个数
 *  @param screenName           屏幕名称
 *  @param parameters           默认为nil
 */
+ (void)event:(EventCategory)category action:(EventAction)action label:(EventLabel)label labelParameters:(NSString *)labelParameters transferCount:(long)transferCount screenView:(NSString *)screenName userLanguageName:(NSString *)userLanguageName customParameters:(NSDictionary *)parameters;

/**
 *  构建屏幕跟踪
 *
 *  @param screenName       屏幕名称
 *  @param parameters       默认为nil
 */
+ (void)screenView:(NSString *)screenName customParameters:(NSDictionary *)parameters;

/**
 *  构建事件异常跟踪
 *
 *  @param description 异常描述
 *  @param isFatal     if = YES，发送事件跟踪异常
 *  @param parameters  默认为nil
 */
+ (void)excpetionWithDescription:(NSString *)description isFatal:(BOOL)isFatal customParameters:(NSDictionary *)parameters;

@end
