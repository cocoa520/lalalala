//
//  GeneralDigest.h
//  
//
//  Created by Pallas on 7/20/16.
//
//  Complete

#import "Digest.h"

@interface GeneralDigest : Digest {
@private
    NSMutableData *                 _xBuf;
    int                             _xBufOff;
    
    int64_t                         _byteCount;
}

- (id)initWithGeneralDigest:(GeneralDigest*)t;

- (void)copyIn:(GeneralDigest*)t;
- (void)finish;

- (void)processWord:(NSMutableData*)input withInOff:(int)inOff;
- (void)processLength:(int64_t)bitLength;
- (void)processBlock;

@end
