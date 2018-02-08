//
//  GcmBlockCipher.h
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "AeadBlockCipher.h"

@class GcmMultiplier;
@class GcmExponentiator;
@class BlockCipher;

@interface GcmBlockCipher : AeadBlockCipher {
@private
    BlockCipher *                       _cipher;
    GcmMultiplier *                     _multiplier;
    GcmExponentiator *                  _exp;
    
    // These fields are set by Init and not modified by processing
    BOOL                                _forEncryption;
    int                                 _macSize;
    NSMutableData *                     _nonce;
    NSMutableData *                     _initialAssociatedText;
    NSMutableData *                     _h;
    NSMutableData *                     _j0;
    
    // These fields are modified during processing
    NSMutableData *                     _bufBlock;
    NSMutableData *                     _macBlock;
    NSMutableData *                     _s;
    NSMutableData *                     _s_at;
    NSMutableData *                     _s_atPre;
    NSMutableData *                     _counter;
    int                                 _bufOff;
    uint64_t                            _totalLength;
    NSMutableData *                     _atBlock;
    int                                 _atBlockPos;
    uint64_t                            _atLength;
    uint64_t                            _atLengthPre;
}

- (id)initWithCipher:(BlockCipher*)c;
- (id)initWithCipher:(BlockCipher*)c withMultiplier:(GcmMultiplier*)m;

@end
