//
//  Twitter.h
//  DriveSync
//
//  Created by JGehry on 28/02/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "BaseDrive.h"

@interface Twitter : BaseDrive {
    NSString *_authorizeToken;
    NSString *_authorizeAccessToken;
    
    NSString *_twitterUserID;
    NSString *_screenName;
}

@property (nonatomic, readwrite, retain) NSString *authorizeToken;
@property (nonatomic, readwrite, retain) NSString *authorizeAccessToken;

@property (nonatomic, readwrite, retain) NSString *twitterUserID;
@property (nonatomic, readwrite, retain) NSString *screenName;

/**
 *  打开浏览器
 */
- (void)openBrower;

/**
 *  获取请求Token
 *
 *  @param consumerKey 应用ID
 *  @param success     成功回调
 *  @param fail        失败回调
 */
- (void)fetchRequestToken:(NSString *)consumerKey success:(Callback)success fail:(Callback)fail;

/**
 *  获取访问Token
 *
 *  @param pin     PIN码
 *  @param success 成功回调
 *  @param fail    失败回调
 */
- (void)fetchAccessTokenWithPIN:(NSString *)pin success:(Callback)success fail:(Callback)fail;

/**
 *  获取所有媒体文件
 *
 *  @param screenName 用户名称，默认传入字符串0即可
 *  @param success    成功回调
 *  @param fail       失败回调
 */
- (void)getVideo:(NSString *)screenName success:(Callback)success fail:(Callback)fail;

@end