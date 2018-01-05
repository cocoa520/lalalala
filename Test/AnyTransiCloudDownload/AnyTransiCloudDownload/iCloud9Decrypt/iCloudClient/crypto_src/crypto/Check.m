//
//  Check.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "Check.h"

@implementation Check

+ (void)dataLength:(BOOL)condition withMsg:(NSString*)msg {
    if (condition) {
        @throw [NSException exceptionWithName:@"DataLength" reason:msg userInfo:nil];
    }
}

+ (void)dataLength:(NSMutableData*)buf withOff:(int)off withLen:(int)len withMsg:(NSString*)msg {
    if (off + len > buf.length) {
        @throw [NSException exceptionWithName:@"DataLength" reason:msg userInfo:nil];
    }
}

+ (void)outputLength:(NSMutableData*)buf withOff:(int)off withLen:(int)len withMsg:(NSString*)msg {
    if (off + len > buf.length) {
        @throw [NSException exceptionWithName:@"OutputLength" reason:msg userInfo:nil];
    }
}

@end
