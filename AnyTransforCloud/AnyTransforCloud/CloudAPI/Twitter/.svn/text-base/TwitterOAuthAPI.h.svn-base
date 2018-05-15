//
//  TwitterOAuthAPI.h
//  DriveSync
//
//  Created by JGehry on 21/03/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "BaseDriveAPI.h"

@interface TwitterOAuthAPI : BaseDriveAPI {
    NSString *_oauthRequestToken;
    NSString *_oauthAccessToken;
    
    NSString *_accountName;
}

@property (nonatomic, readwrite, retain) NSString *oauthRequestToken;
@property (nonatomic, readwrite, retain) NSString *oauthAccessToken;

@property (nonatomic, readwrite, retain) NSString *accountName;

/**
 *  初始化方法
 *
 *  @param resource       请求资源
 *  @param httpMethod     请求方式
 *  @param baseURLString  Host
 *  @param consumerKey    应用ID
 *  @param consumerSecret 应用密码
 *  @param tokenKey       授权ID
 *  @param tokenSecret    授权密码
 *  @param PIN            获取授权需要的PIN码
 *
 *  @return 实例对象
 */
- (instancetype)initWithFetchResource:(NSString *)resource
                           httpMethod:(NSString *)httpMethod
                        baseURLString:(NSString *)baseURLString
                          consumerKey:(NSString *)consumerKey
                   withConsumerSecret:(NSString *)consumerSecret
                         withTokenKey:(NSString *)tokenKey
                      withTokenSecret:(NSString *)tokenSecret
                              withPIN:(NSString *)PIN
                    isHasRequestToken:(BOOL)hasRequestToken
                     isHasAccessToken:(BOOL)hasAccessToken;

- (NSString *)oauthTimestamp;
- (NSString *)signatureBaseStringWithHTTPMethod:(NSString *)httpMethod url:(NSURL *)url allParametersUnsorted:(NSArray *)parameters;
- (NSString *)oauthHeaderValueWithParameters:(NSArray *)parametersDictionaries;

@end

@interface NSString (TwitterRequestTokenAPI)
+ (NSString *)st_random32Characters;
- (NSString *)st_signHmacSHA1WithKey:(NSString *)key;
- (NSDictionary *)st_parametersDictionary;
- (NSString *)st_urlEncodedString;
@end

@interface NSURL (TwitterRequestTokenAPI)
- (NSString *)st_normalizedForOauthSignatureString;
- (NSArray *)st_rawGetParametersDictionaries;
@end

@interface NSData (TwitterRequestTokenAPI)

- (NSString *)base64Encoding; // private API

@end