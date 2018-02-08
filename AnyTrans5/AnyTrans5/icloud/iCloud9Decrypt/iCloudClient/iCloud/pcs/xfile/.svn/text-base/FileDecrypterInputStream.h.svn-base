//
//  FileDecrypterInputStream.h
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import "CategoryExtend.h"

@class BlockDecrypter;

@interface FileDecrypterInputStream : Stream {
@private
    Stream *                                    _input;
    BlockDecrypter *                            _decrypter;
    NSMutableData *                             _iN;
    NSMutableData *                             _oUT;
    int                                         _pos;
    int                                         _limit;
    int                                         _block;
}

- (id)initWithInput:(Stream*)input withBlockDecrypter:(BlockDecrypter*)blockDecrypter withBlockLength:(int)blockLength;
- (id)initWithInput:(Stream*)input withBlockDecrypter:(BlockDecrypter*)blockDecrypter;

- (void)fill;

@end
