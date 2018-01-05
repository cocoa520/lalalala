//
//  DPAESCBCCipher.h
//  
//
//  Created by Pallas on 8/26/16.
//
//  Complete

#import "BlockCipher.h"

@class BlockCipher;
@class KeyParameter;

@interface DPAESCBCCipher : BlockCipher {
@private
    BlockCipher *                               _cipher;
    int                                         _blockLength;
    id                                          _target;
    SEL                                         _selector;
    IMP                                         _imp;
    KeyParameter *                              _key;
    BOOL                                        _forEncryption;
    int                                         _index;
    int                                         _offset;
}

- (id)initWithBlockSize:(int)blockSize;

@end
