//
//  CipherInputStream.h
//  
//
//  Created by Pallas on 8/30/16.
//
//  Complete

#import "CategoryExtend.h"

@class BufferedBlockCipher;
@class Stream;

@interface CipherInputStream : Stream {
@private
    Stream *                                        _iN;
    BufferedBlockCipher *                           _bufferedBlockCipher;
    NSMutableData *                                 _inBuf;
    NSMutableData *                                 _buf;
    int                                             _bufOff;
    int                                             _maxBuf;
    BOOL                                            _finalized;
}

- (id)initWithIs:(Stream*)is withCipher:(BufferedBlockCipher*)cipher;
- (id)initWithIs:(Stream*)is withCipher:(BufferedBlockCipher*)cipher withBufSize:(int)bufSize;

@end
