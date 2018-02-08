//
//  EscrowedKeys.h
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class EscrowProxyRequest;
@class ServiceKeySet;
@class Account;

@interface EscrowedKeys : NSObject

+ (EscrowProxyRequest*)requestFactory:(Account*)account;
+ (ServiceKeySet*)keysWithAccount:(Account*)account;
+ (ServiceKeySet*)keysWithRequests:(EscrowProxyRequest*)requests;

@end
