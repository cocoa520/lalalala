//
//  LongDigest.h
//  
//
//  Created by Pallas on 7/22/16.
//
//  Complete

#import "Digest.h"

@interface LongDigest : Digest {
@private
    int                                     _myByteLength; // 128
    NSMutableData *                         _xBuf;
    int                                     _xBufOff;
    int64_t                                 _byteCount1;
    int64_t                                 _byteCount2;
    uint64_t                                _h1;
    uint64_t                                _h2;
    uint64_t                                _h3;
    uint64_t                                _h4;
    uint64_t                                _h5;
    uint64_t                                _h6;
    uint64_t                                _h7;
    uint64_t                                _h8;
    NSMutableArray *                        _w; //uint64_t[80]
    int                                     _wOff;
}

@property (nonatomic, readwrite, assign) uint64_t h1;
@property (nonatomic, readwrite, assign) uint64_t h2;
@property (nonatomic, readwrite, assign) uint64_t h3;
@property (nonatomic, readwrite, assign) uint64_t h4;
@property (nonatomic, readwrite, assign) uint64_t h5;
@property (nonatomic, readwrite, assign) uint64_t h6;
@property (nonatomic, readwrite, assign) uint64_t h7;
@property (nonatomic, readwrite, assign) uint64_t h8;

/* SHA-384 and SHA-512 Constants
 * (represent the first 64 bits of the fractional parts of the
 * cube roots of the first sixty-four prime numbers)
 */
// return == uint64_t[]
+ (NSMutableArray*)K;

/**
 * Copy constructor.  We are using copy constructors in place
 * of the object.Clone() interface as this interface is not
 * supported by J2ME.
 */
- (id)initWithLongDigest:(LongDigest*)t;

- (void)copyIn:(LongDigest*)t;
- (void)finish;

- (void)processWord:(NSMutableData*)input withInOff:(int)inOff;
- (void)processLength:(int64_t)lowW withHiw:(int64_t)hiW;
- (void)processBlock;

@end
