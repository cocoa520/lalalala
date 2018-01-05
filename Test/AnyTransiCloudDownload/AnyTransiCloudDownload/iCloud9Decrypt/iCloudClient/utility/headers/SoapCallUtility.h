//
//  SoapCallClass.h
//  
//
//  Created by Pallas on 10/22/15.
//
//

#import <Foundation/Foundation.h>

@interface SoapCallUtility : NSObject {
@private
    NSString *_servEndPointPath;
    NSString *_servNameSpace;
    NSString *_servRequest;
}

@property (nonatomic, readwrite, retain) NSString *servEndPointPath;
@property (nonatomic, readwrite, retain) NSString *servNameSpace;
@property (nonatomic, readwrite, retain) NSString *servRequest;

- (id)initWithUrl:(NSString*)url withNameSpace:(NSString*)ns withRequest:(NSString*)request;
- (id)getSoapWithMethodName:(NSString*)methodName withParams:(NSDictionary*)params withParamsOrder:(NSArray*)paramsOrder withErrorCode:(long*)errorCode;

@end
