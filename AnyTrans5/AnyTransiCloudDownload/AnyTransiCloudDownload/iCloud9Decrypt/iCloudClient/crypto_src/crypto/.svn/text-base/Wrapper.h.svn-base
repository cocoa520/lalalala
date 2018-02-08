//
//  Wrapper.h
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class CipherParameters;

@interface Wrapper : NSObject

- (NSString*)algorithmName;
- (void)init:(BOOL)forWrapping withParameters:(CipherParameters*)parameters;
- (NSMutableData*)wrap:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length;
- (NSMutableData*)unwrap:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length;

@end
