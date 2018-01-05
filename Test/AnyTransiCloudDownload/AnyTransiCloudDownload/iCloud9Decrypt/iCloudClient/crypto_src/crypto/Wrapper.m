//
//  Wrapper.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "Wrapper.h"
#import "CipherParameters.h"

@implementation Wrapper

/// <summary>The name of the algorithm this cipher implements.</summary>
- (NSString*)algorithmName {
    return nil;
}

- (void)init:(BOOL)forWrapping withParameters:(CipherParameters*)parameters {
}

- (NSMutableData*)wrap:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length {
    return nil;
}

- (NSMutableData*)unwrap:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length {
    return nil;
}

@end
