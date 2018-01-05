//
//  BufferedBlockCipher.h
//  
//
//  Created by Pallas on 7/14/16.
//
// Complete

#import "BufferedCipherBase.h"

@class BlockCipher;

@interface BufferedBlockCipher : BufferedCipherBase {
@protected
    NSMutableData *                     _buf;
    int                                 _bufOff;
    BOOL                                _forEncryption;
    BlockCipher *                       _cipher;
}

@property (nonatomic, readwrite, retain) NSMutableData *buf;
@property (nonatomic, readwrite, assign) int bufOff;
@property (nonatomic, readwrite, assign) BOOL forEncryption;
@property (nonatomic, readwrite, retain) BlockCipher *cipher;

- (id)initWithCipher:(BlockCipher*)cipher;

@end
