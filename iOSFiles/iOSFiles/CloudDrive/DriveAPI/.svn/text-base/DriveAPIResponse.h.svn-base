//
//  DriveAPIResult.h
//  DriveSync
//
//  Created by 罗磊 on 2017/11/29.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>

/**响应码*/
typedef enum ResponseCode {
    ResponseSuccess,           ///<成功响应
    ResponseTimeOut,           ///<响应超时
    ResponseInvalid,           ///<响应无效 一般参数错误
    ResponseNoNetwork,         ///<无网络
    ResponseTokenInvalid,      ///<token失效
    
    ResponseSessionExpired, ///sesion失效过期，主要是icloud drive如果长时间不操作 会存在此情况
    ResponseUserNameOrPasswordError,    ///<用户名或者密码错误
    ResonseSecurityCodeError,           ///<沿验证码错误
    
    ResponseUnknown            ///<记录未知的错误信息
}ResponseCode;

@interface DriveAPIResponse : NSObject
{
    ResponseCode _responseCode;
    NSData *_responseData;
    id _content;
}
@property (nonatomic,readonly)ResponseCode responseCode;
@property (nonatomic,readonly) NSData *responseData;
@property (nonatomic,readonly) id content;

- (instancetype)initWithResponseData:(NSData *)responseData  status:(ResponseCode)responsecode;
@end
