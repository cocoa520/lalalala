//
//  EscrowOperationsRecords.h
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class EscrowProxyRequest;

@interface EscrowOperationsRecords : NSObject

+ (NSMutableDictionary*)records:(EscrowProxyRequest*)requests;

@end