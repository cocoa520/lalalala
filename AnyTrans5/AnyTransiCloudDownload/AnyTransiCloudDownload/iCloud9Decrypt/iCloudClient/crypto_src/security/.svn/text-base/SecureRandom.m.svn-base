//
//  SecureRandom.m
//  
//
//  Created by iMobie on 7/15/16.
//
//  Complete

#import "SecureRandom.h"

@implementation SecureRandom

static uint8_t *randomData = nil;

- (NSMutableData*)nextBytes:(int)bitCount {
    dispatch_block_t block = (dispatch_block_t) ^{
        int err = 0;
        
        // Don't ask for too many bytes in one go, that can lock up your system
        err = SecRandomCopyBytes(kSecRandomDefault, bitCount, randomData);
        if (err != noErr) {
            @throw [NSException exceptionWithName:@"..." reason:@"..." userInfo:nil];
        }
    };
    
    if (!randomData) {
        randomData = malloc(bitCount);
    } else {
        free(randomData);
        randomData = malloc(bitCount);
    }
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), block); //regenerate random data
    NSMutableData *retData = [[[NSMutableData alloc] initWithBytes:randomData length:bitCount] autorelease];
    if (randomData) {
        free(randomData); randomData = nil;
    }
    return retData;
}

@end
