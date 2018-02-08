//
//  SRPFactory.h
//  
//
//  Created by Pallas on 4/27/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class SRPClient;
@class SecureRandom;

@interface SRPFactory : NSObject

+ (SRPClient*)rfc5054:(SecureRandom*)random;

@end
