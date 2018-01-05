//
//  EscrowOperationsRecover.h
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class EscrowProxyRequest;

@interface EscrowOperationsRecover : NSObject

+ (NSDictionary*)recover:(EscrowProxyRequest*)requests;

@end
