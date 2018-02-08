//
//  Check.h
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface Check : NSObject

+ (void)dataLength:(BOOL)condition withMsg:(NSString*)msg;
+ (void)dataLength:(NSMutableData*)buf withOff:(int)off withLen:(int)len withMsg:(NSString*)msg;
+ (void)outputLength:(NSMutableData*)buf withOff:(int)off withLen:(int)len withMsg:(NSString*)msg;

@end
