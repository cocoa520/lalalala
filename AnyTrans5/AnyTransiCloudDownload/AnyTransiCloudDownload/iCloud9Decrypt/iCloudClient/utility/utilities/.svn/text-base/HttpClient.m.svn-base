//
//  HttpClient.m
//  
//
//  Created by Pallas on 1/11/16.
//
//

#import "HttpClient.h"
#import "CommonDefine.h"

@implementation HttpClient

+ (NSMutableData*)execute:(NSMutableURLRequest*)request {
    if (!request || request.HTTPMethod == nil) {
        return nil;
    }
    NSMutableData *retData = nil;
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = nil;
    @try {
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
    if (responseData != nil && [responseData length] > 0 && error == nil){
        retData = [NSMutableData dataWithData:responseData];
    }
    if (error && [error code] == -1009) {
        // 网络错误
        @throw [NSException exceptionWithName:NOTITY_NETWORK_FAULT_INTERRUPT reason:@"Network fault interrupt" userInfo:nil];
    }
    return retData;
}

+ (NSMutableData*)executeGet:(NSMutableURLRequest*)request {
    if (!request || request.HTTPMethod == nil) {
        return nil;
    }
    [request setHTTPMethod:@"GET"];
    NSMutableData *retData = nil;
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = nil;
    @try {
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
    if (responseData != nil && [responseData length] > 0 && error == nil){
        retData = [NSMutableData dataWithData:responseData];
    }
    if (error && [error code] == -1009) {
        // 网络错误
        @throw [NSException exceptionWithName:NOTITY_NETWORK_FAULT_INTERRUPT reason:@"Network fault interrupt" userInfo:nil];
    }
    return retData;
}

+ (NSMutableData*)executePost:(NSMutableURLRequest*)request {
    if (!request || request.HTTPMethod == nil) {
        return nil;
    }
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSMutableData *retData = nil;
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = nil;
    @try {
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
    if (responseData != nil && [responseData length] > 0 && error == nil){
        retData = [NSMutableData dataWithData:responseData];
    }
    if (error && [error code] == -1009) {
        // 网络错误
        @throw [NSException exceptionWithName:NOTITY_NETWORK_FAULT_INTERRUPT reason:@"Network fault interrupt" userInfo:nil];
    }
    return retData;
}

@end
