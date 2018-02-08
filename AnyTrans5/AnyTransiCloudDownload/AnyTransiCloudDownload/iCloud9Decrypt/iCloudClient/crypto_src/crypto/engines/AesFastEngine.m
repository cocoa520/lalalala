//
//  AesFastEngine.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

/**
 * an implementation of the AES (Rijndael)), from FIPS-197.
 * <p>
 * For further details see: <a href="http://csrc.nist.gov/encryption/aes/">http://csrc.nist.gov/encryption/aes/</a>.
 *
 * This implementation is based on optimizations from Dr. Brian Gladman's paper and C code at
 * <a href="http://fp.gladman.plus.com/cryptography_technology/rijndael/">http://fp.gladman.plus.com/cryptography_technology/rijndael/</a>
 *
 * There are three levels of tradeoff of speed vs memory
 * Because java has no preprocessor), they are written as three separate classes from which to choose
 *
 * The fastest uses 8Kbytes of static tables to precompute round calculations), 4 256 word tables for encryption
 * and 4 for decryption.
 *
 * The middle performance version uses only one 256 word table for each), for a total of 2Kbytes),
 * adding 12 rotate operations per round to compute the values contained in the other tables from
 * the contents of the first
 *
 * The slowest version uses no static tables at all and computes the values in each round
 * </p>
 * <p>
 * This file contains the fast version with 8Kbytes of static tables for round precomputation
 * </p>
 */

#import "AesFastEngine.h"
#import "CategoryExtend.h"
#import "Pack.h"
#import "CipherParameters.h"
#import "KeyParameter.h"
#import "Check.h"

@interface AesFastEngine ()

@property (nonatomic, readwrite, assign) int rounds;
@property (nonatomic, readwrite, retain) NSMutableArray *workingKey;
@property (nonatomic, readwrite, assign) uint c0;
@property (nonatomic, readwrite, assign) uint c1;
@property (nonatomic, readwrite, assign) uint c2;
@property (nonatomic, readwrite, assign) uint c3;
@property (nonatomic, readwrite, assign) BOOL forEncryption;

@end

@implementation AesFastEngine
@synthesize rounds = _rounds;
@synthesize workingKey = _workingKey;
@synthesize c0 = _c0;
@synthesize c1 = _c1;
@synthesize c2 = _c2;
@synthesize c3 = _c3;
@synthesize forEncryption = _forEncryption;

// The S box
+ (NSMutableData*)S {
    static NSMutableData *_s = nil;
    @synchronized(self) {
        if (_s == nil) {
            Byte byte[] = { 99, 124, 119, 123, 242, 107, 111, 197,
                            48, 1, 103, 43, 254, 215, 171, 118,
                            202, 130, 201, 125, 250, 89, 71, 240,
                            173, 212, 162, 175, 156, 164, 114, 192,
                            183, 253, 147, 38, 54, 63, 247, 204,
                            52, 165, 229, 241, 113, 216, 49, 21,
                            4, 199, 35, 195, 24, 150, 5, 154,
                            7, 18, 128, 226, 235,  39, 178, 117,
                            9, 131, 44, 26, 27, 110, 90, 160,
                            82, 59, 214, 179, 41, 227, 47, 132,
                            83, 209, 0, 237, 32, 252, 177, 91,
                            106, 203, 190, 57, 74, 76, 88, 207,
                            208, 239, 170, 251, 67, 77, 51, 133,
                            69, 249, 2, 127, 80, 60, 159, 168,
                            81, 163, 64, 143, 146, 157, 56, 245,
                            188, 182, 218, 33, 16, 255, 243, 210,
                            205, 12, 19, 236, 95, 151, 68, 23,
                            196, 167, 126, 61, 100, 93, 25, 115,
                            96, 129, 79, 220, 34, 42, 144, 136,
                            70, 238, 184, 20, 222, 94, 11, 219,
                            224, 50, 58, 10, 73, 6, 36, 92,
                            194, 211, 172, 98, 145, 149, 228, 121,
                            231, 200, 55, 109, 141, 213, 78, 169,
                            108, 86, 244, 234, 101, 122, 174, 8,
                            186, 120, 37, 46, 28, 166, 180, 198,
                            232, 221, 116, 31, 75, 189, 139, 138,
                            112, 62, 181, 102, 72, 3, 246, 14,
                            97, 53, 87, 185, 134, 193, 29, 158,
                            225, 248, 152, 17, 105, 217, 142, 148,
                            155, 30, 135, 233, 206, 85, 40, 223,
                            140, 161, 137, 13, 191, 230, 66, 104,
                            65, 153, 45, 15, 176, 84, 187, 22 };
            _s = [[NSMutableData alloc] initWithBytes:byte length:256];
            [_s setFixedSize:(int)(_s.length)];
        }
    }
    return _s;
}

// The inverse S-box
+ (NSMutableData*)Si {
    static NSMutableData *_si = nil;
    @synchronized(self) {
        if (_si == nil) {
            Byte byte[] = { 82, 9, 106, 213, 48, 54, 165, 56,
                            191, 64, 163, 158, 129, 243, 215, 251,
                            124, 227, 57, 130, 155, 47, 255, 135,
                            52, 142, 67, 68, 196, 222, 233, 203,
                            84, 123, 148, 50, 166, 194, 35, 61,
                            238, 76, 149, 11, 66, 250, 195, 78,
                            8, 46, 161, 102, 40, 217, 36, 178,
                            118, 91, 162, 73, 109, 139, 209, 37,
                            114, 248, 246, 100, 134, 104, 152, 22,
                            212, 164, 92, 204, 93, 101, 182, 146,
                            108, 112, 72, 80, 253, 237, 185, 218,
                            94, 21, 70, 87, 167, 141, 157, 132,
                            144, 216, 171, 0, 140, 188, 211, 10,
                            247, 228, 88, 5, 184, 179, 69, 6,
                            208, 44, 30, 143, 202, 63, 15, 2,
                            193, 175, 189, 3, 1, 19, 138, 107,
                            58, 145, 17, 65, 79, 103, 220, 234,
                            151, 242, 207, 206, 240, 180, 230, 115,
                            150, 172, 116, 34, 231, 173, 53, 133,
                            226, 249, 55, 232, 28, 117, 223, 110,
                            71, 241, 26, 113, 29, 41, 197, 137,
                            111, 183, 98, 14, 170, 24, 190, 27,
                            252, 86, 62, 75, 198, 210, 121, 32,
                            154, 219, 192, 254, 120, 205, 90, 244,
                            31, 221, 168, 51, 136, 7, 199, 49,
                            177, 18, 16, 89, 39, 128, 236, 95,
                            96, 81, 127, 169, 25, 181, 74, 13,
                            45, 229, 122, 159, 147, 201, 156, 239,
                            160, 224, 59, 77, 174, 42, 245, 176,
                            200, 235, 187, 60, 131, 83, 153, 97,
                            23, 43, 4, 126, 186, 119, 214, 38,
                            225, 105, 20, 99, 85, 33, 12, 125 };
            _si = [[NSMutableData alloc] initWithBytes:byte length:256];
            [_si setFixedSize:(int)(_si.length)];
        }
    }
    return _si;
}

// vector used in calculating key schedule (powers of x in GF(256))
+ (NSMutableData*)rcon {
    static NSMutableData *_rcon = nil;
    @synchronized(self) {
        if (_rcon == nil) {
            Byte byte[] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a,
                            0x2f, 0x5e, 0xbc, 0x63, 0xc6, 0x97, 0x35, 0x6a, 0xd4, 0xb3, 0x7d, 0xfa, 0xef, 0xc5, 0x91};
            _rcon = [[NSMutableData alloc] initWithBytes:byte length:30];
            [_rcon setFixedSize:(int)(_rcon.length)];
        }
    }
    return _rcon;
}

// precomputation tables of calculations for rounds
+ (NSMutableArray*)T0 {
    static NSMutableArray *_t0 = nil;
    @synchronized(self) {
        if (_t0 == nil) {
            @autoreleasepool {
                _t0 = [@[@((uint)0xa56363c6), @((uint)0x847c7cf8), @((uint)0x997777ee), @((uint)0x8d7b7bf6), @((uint)0x0df2f2ff),
                         @((uint)0xbd6b6bd6), @((uint)0xb16f6fde), @((uint)0x54c5c591), @((uint)0x50303060), @((uint)0x03010102),
                         @((uint)0xa96767ce), @((uint)0x7d2b2b56), @((uint)0x19fefee7), @((uint)0x62d7d7b5), @((uint)0xe6abab4d),
                         @((uint)0x9a7676ec), @((uint)0x45caca8f), @((uint)0x9d82821f), @((uint)0x40c9c989), @((uint)0x877d7dfa),
                         @((uint)0x15fafaef), @((uint)0xeb5959b2), @((uint)0xc947478e), @((uint)0x0bf0f0fb), @((uint)0xecadad41),
                         @((uint)0x67d4d4b3), @((uint)0xfda2a25f), @((uint)0xeaafaf45), @((uint)0xbf9c9c23), @((uint)0xf7a4a453),
                         @((uint)0x967272e4), @((uint)0x5bc0c09b), @((uint)0xc2b7b775), @((uint)0x1cfdfde1), @((uint)0xae93933d),
                         @((uint)0x6a26264c), @((uint)0x5a36366c), @((uint)0x413f3f7e), @((uint)0x02f7f7f5), @((uint)0x4fcccc83),
                         @((uint)0x5c343468), @((uint)0xf4a5a551), @((uint)0x34e5e5d1), @((uint)0x08f1f1f9), @((uint)0x937171e2),
                         @((uint)0x73d8d8ab), @((uint)0x53313162), @((uint)0x3f15152a), @((uint)0x0c040408), @((uint)0x52c7c795),
                         @((uint)0x65232346), @((uint)0x5ec3c39d), @((uint)0x28181830), @((uint)0xa1969637), @((uint)0x0f05050a),
                         @((uint)0xb59a9a2f), @((uint)0x0907070e), @((uint)0x36121224), @((uint)0x9b80801b), @((uint)0x3de2e2df),
                         @((uint)0x26ebebcd), @((uint)0x6927274e), @((uint)0xcdb2b27f), @((uint)0x9f7575ea), @((uint)0x1b090912),
                         @((uint)0x9e83831d), @((uint)0x742c2c58), @((uint)0x2e1a1a34), @((uint)0x2d1b1b36), @((uint)0xb26e6edc),
                         @((uint)0xee5a5ab4), @((uint)0xfba0a05b), @((uint)0xf65252a4), @((uint)0x4d3b3b76), @((uint)0x61d6d6b7),
                         @((uint)0xceb3b37d), @((uint)0x7b292952), @((uint)0x3ee3e3dd), @((uint)0x712f2f5e), @((uint)0x97848413),
                         @((uint)0xf55353a6), @((uint)0x68d1d1b9), @((uint)0x00000000), @((uint)0x2cededc1), @((uint)0x60202040),
                         @((uint)0x1ffcfce3), @((uint)0xc8b1b179), @((uint)0xed5b5bb6), @((uint)0xbe6a6ad4), @((uint)0x46cbcb8d),
                         @((uint)0xd9bebe67), @((uint)0x4b393972), @((uint)0xde4a4a94), @((uint)0xd44c4c98), @((uint)0xe85858b0),
                         @((uint)0x4acfcf85), @((uint)0x6bd0d0bb), @((uint)0x2aefefc5), @((uint)0xe5aaaa4f), @((uint)0x16fbfbed),
                         @((uint)0xc5434386), @((uint)0xd74d4d9a), @((uint)0x55333366), @((uint)0x94858511), @((uint)0xcf45458a),
                         @((uint)0x10f9f9e9), @((uint)0x06020204), @((uint)0x817f7ffe), @((uint)0xf05050a0), @((uint)0x443c3c78),
                         @((uint)0xba9f9f25), @((uint)0xe3a8a84b), @((uint)0xf35151a2), @((uint)0xfea3a35d), @((uint)0xc0404080),
                         @((uint)0x8a8f8f05), @((uint)0xad92923f), @((uint)0xbc9d9d21), @((uint)0x48383870), @((uint)0x04f5f5f1),
                         @((uint)0xdfbcbc63), @((uint)0xc1b6b677), @((uint)0x75dadaaf), @((uint)0x63212142), @((uint)0x30101020),
                         @((uint)0x1affffe5), @((uint)0x0ef3f3fd), @((uint)0x6dd2d2bf), @((uint)0x4ccdcd81), @((uint)0x140c0c18),
                         @((uint)0x35131326), @((uint)0x2fececc3), @((uint)0xe15f5fbe), @((uint)0xa2979735), @((uint)0xcc444488),
                         @((uint)0x3917172e), @((uint)0x57c4c493), @((uint)0xf2a7a755), @((uint)0x827e7efc), @((uint)0x473d3d7a),
                         @((uint)0xac6464c8), @((uint)0xe75d5dba), @((uint)0x2b191932), @((uint)0x957373e6), @((uint)0xa06060c0),
                         @((uint)0x98818119), @((uint)0xd14f4f9e), @((uint)0x7fdcdca3), @((uint)0x66222244), @((uint)0x7e2a2a54),
                         @((uint)0xab90903b), @((uint)0x8388880b), @((uint)0xca46468c), @((uint)0x29eeeec7), @((uint)0xd3b8b86b),
                         @((uint)0x3c141428), @((uint)0x79dedea7), @((uint)0xe25e5ebc), @((uint)0x1d0b0b16), @((uint)0x76dbdbad),
                         @((uint)0x3be0e0db), @((uint)0x56323264), @((uint)0x4e3a3a74), @((uint)0x1e0a0a14), @((uint)0xdb494992),
                         @((uint)0x0a06060c), @((uint)0x6c242448), @((uint)0xe45c5cb8), @((uint)0x5dc2c29f), @((uint)0x6ed3d3bd),
                         @((uint)0xefacac43), @((uint)0xa66262c4), @((uint)0xa8919139), @((uint)0xa4959531), @((uint)0x37e4e4d3),
                         @((uint)0x8b7979f2), @((uint)0x32e7e7d5), @((uint)0x43c8c88b), @((uint)0x5937376e), @((uint)0xb76d6dda),
                         @((uint)0x8c8d8d01), @((uint)0x64d5d5b1), @((uint)0xd24e4e9c), @((uint)0xe0a9a949), @((uint)0xb46c6cd8),
                         @((uint)0xfa5656ac), @((uint)0x07f4f4f3), @((uint)0x25eaeacf), @((uint)0xaf6565ca), @((uint)0x8e7a7af4),
                         @((uint)0xe9aeae47), @((uint)0x18080810), @((uint)0xd5baba6f), @((uint)0x887878f0), @((uint)0x6f25254a),
                         @((uint)0x722e2e5c), @((uint)0x241c1c38), @((uint)0xf1a6a657), @((uint)0xc7b4b473), @((uint)0x51c6c697),
                         @((uint)0x23e8e8cb), @((uint)0x7cdddda1), @((uint)0x9c7474e8), @((uint)0x211f1f3e), @((uint)0xdd4b4b96),
                         @((uint)0xdcbdbd61), @((uint)0x868b8b0d), @((uint)0x858a8a0f), @((uint)0x907070e0), @((uint)0x423e3e7c),
                         @((uint)0xc4b5b571), @((uint)0xaa6666cc), @((uint)0xd8484890), @((uint)0x05030306), @((uint)0x01f6f6f7),
                         @((uint)0x120e0e1c), @((uint)0xa36161c2), @((uint)0x5f35356a), @((uint)0xf95757ae), @((uint)0xd0b9b969),
                         @((uint)0x91868617), @((uint)0x58c1c199), @((uint)0x271d1d3a), @((uint)0xb99e9e27), @((uint)0x38e1e1d9),
                         @((uint)0x13f8f8eb), @((uint)0xb398982b), @((uint)0x33111122), @((uint)0xbb6969d2), @((uint)0x70d9d9a9),
                         @((uint)0x898e8e07), @((uint)0xa7949433), @((uint)0xb69b9b2d), @((uint)0x221e1e3c), @((uint)0x92878715),
                         @((uint)0x20e9e9c9), @((uint)0x49cece87), @((uint)0xff5555aa), @((uint)0x78282850), @((uint)0x7adfdfa5),
                         @((uint)0x8f8c8c03), @((uint)0xf8a1a159), @((uint)0x80898909), @((uint)0x170d0d1a), @((uint)0xdabfbf65),
                         @((uint)0x31e6e6d7), @((uint)0xc6424284), @((uint)0xb86868d0), @((uint)0xc3414182), @((uint)0xb0999929),
                         @((uint)0x772d2d5a), @((uint)0x110f0f1e), @((uint)0xcbb0b07b), @((uint)0xfc5454a8), @((uint)0xd6bbbb6d),
                         @((uint)0x3a16162c)] mutableCopy];
                [_t0 setFixedSize:(int)(_t0.count)];
            }
        }
    }
    return _t0;
}

+ (NSMutableArray*)T1 {
    static NSMutableArray *_t1 = nil;
    @synchronized(self) {
        if (_t1 == nil) {
            @autoreleasepool {
                _t1 = [@[@((uint)0x6363c6a5), @((uint)0x7c7cf884), @((uint)0x7777ee99), @((uint)0x7b7bf68d), @((uint)0xf2f2ff0d),
                         @((uint)0x6b6bd6bd), @((uint)0x6f6fdeb1), @((uint)0xc5c59154), @((uint)0x30306050), @((uint)0x01010203),
                         @((uint)0x6767cea9), @((uint)0x2b2b567d), @((uint)0xfefee719), @((uint)0xd7d7b562), @((uint)0xabab4de6),
                         @((uint)0x7676ec9a), @((uint)0xcaca8f45), @((uint)0x82821f9d), @((uint)0xc9c98940), @((uint)0x7d7dfa87),
                         @((uint)0xfafaef15), @((uint)0x5959b2eb), @((uint)0x47478ec9), @((uint)0xf0f0fb0b), @((uint)0xadad41ec),
                         @((uint)0xd4d4b367), @((uint)0xa2a25ffd), @((uint)0xafaf45ea), @((uint)0x9c9c23bf), @((uint)0xa4a453f7),
                         @((uint)0x7272e496), @((uint)0xc0c09b5b), @((uint)0xb7b775c2), @((uint)0xfdfde11c), @((uint)0x93933dae),
                         @((uint)0x26264c6a), @((uint)0x36366c5a), @((uint)0x3f3f7e41), @((uint)0xf7f7f502), @((uint)0xcccc834f),
                         @((uint)0x3434685c), @((uint)0xa5a551f4), @((uint)0xe5e5d134), @((uint)0xf1f1f908), @((uint)0x7171e293),
                         @((uint)0xd8d8ab73), @((uint)0x31316253), @((uint)0x15152a3f), @((uint)0x0404080c), @((uint)0xc7c79552),
                         @((uint)0x23234665), @((uint)0xc3c39d5e), @((uint)0x18183028), @((uint)0x969637a1), @((uint)0x05050a0f),
                         @((uint)0x9a9a2fb5), @((uint)0x07070e09), @((uint)0x12122436), @((uint)0x80801b9b), @((uint)0xe2e2df3d),
                         @((uint)0xebebcd26), @((uint)0x27274e69), @((uint)0xb2b27fcd), @((uint)0x7575ea9f), @((uint)0x0909121b),
                         @((uint)0x83831d9e), @((uint)0x2c2c5874), @((uint)0x1a1a342e), @((uint)0x1b1b362d), @((uint)0x6e6edcb2),
                         @((uint)0x5a5ab4ee), @((uint)0xa0a05bfb), @((uint)0x5252a4f6), @((uint)0x3b3b764d), @((uint)0xd6d6b761),
                         @((uint)0xb3b37dce), @((uint)0x2929527b), @((uint)0xe3e3dd3e), @((uint)0x2f2f5e71), @((uint)0x84841397),
                         @((uint)0x5353a6f5), @((uint)0xd1d1b968), @((uint)0x00000000), @((uint)0xededc12c), @((uint)0x20204060),
                         @((uint)0xfcfce31f), @((uint)0xb1b179c8), @((uint)0x5b5bb6ed), @((uint)0x6a6ad4be), @((uint)0xcbcb8d46),
                         @((uint)0xbebe67d9), @((uint)0x3939724b), @((uint)0x4a4a94de), @((uint)0x4c4c98d4), @((uint)0x5858b0e8),
                         @((uint)0xcfcf854a), @((uint)0xd0d0bb6b), @((uint)0xefefc52a), @((uint)0xaaaa4fe5), @((uint)0xfbfbed16),
                         @((uint)0x434386c5), @((uint)0x4d4d9ad7), @((uint)0x33336655), @((uint)0x85851194), @((uint)0x45458acf),
                         @((uint)0xf9f9e910), @((uint)0x02020406), @((uint)0x7f7ffe81), @((uint)0x5050a0f0), @((uint)0x3c3c7844),
                         @((uint)0x9f9f25ba), @((uint)0xa8a84be3), @((uint)0x5151a2f3), @((uint)0xa3a35dfe), @((uint)0x404080c0),
                         @((uint)0x8f8f058a), @((uint)0x92923fad), @((uint)0x9d9d21bc), @((uint)0x38387048), @((uint)0xf5f5f104),
                         @((uint)0xbcbc63df), @((uint)0xb6b677c1), @((uint)0xdadaaf75), @((uint)0x21214263), @((uint)0x10102030),
                         @((uint)0xffffe51a), @((uint)0xf3f3fd0e), @((uint)0xd2d2bf6d), @((uint)0xcdcd814c), @((uint)0x0c0c1814),
                         @((uint)0x13132635), @((uint)0xececc32f), @((uint)0x5f5fbee1), @((uint)0x979735a2), @((uint)0x444488cc),
                         @((uint)0x17172e39), @((uint)0xc4c49357), @((uint)0xa7a755f2), @((uint)0x7e7efc82), @((uint)0x3d3d7a47),
                         @((uint)0x6464c8ac), @((uint)0x5d5dbae7), @((uint)0x1919322b), @((uint)0x7373e695), @((uint)0x6060c0a0),
                         @((uint)0x81811998), @((uint)0x4f4f9ed1), @((uint)0xdcdca37f), @((uint)0x22224466), @((uint)0x2a2a547e),
                         @((uint)0x90903bab), @((uint)0x88880b83), @((uint)0x46468cca), @((uint)0xeeeec729), @((uint)0xb8b86bd3),
                         @((uint)0x1414283c), @((uint)0xdedea779), @((uint)0x5e5ebce2), @((uint)0x0b0b161d), @((uint)0xdbdbad76),
                         @((uint)0xe0e0db3b), @((uint)0x32326456), @((uint)0x3a3a744e), @((uint)0x0a0a141e), @((uint)0x494992db),
                         @((uint)0x06060c0a), @((uint)0x2424486c), @((uint)0x5c5cb8e4), @((uint)0xc2c29f5d), @((uint)0xd3d3bd6e),
                         @((uint)0xacac43ef), @((uint)0x6262c4a6), @((uint)0x919139a8), @((uint)0x959531a4), @((uint)0xe4e4d337),
                         @((uint)0x7979f28b), @((uint)0xe7e7d532), @((uint)0xc8c88b43), @((uint)0x37376e59), @((uint)0x6d6ddab7),
                         @((uint)0x8d8d018c), @((uint)0xd5d5b164), @((uint)0x4e4e9cd2), @((uint)0xa9a949e0), @((uint)0x6c6cd8b4),
                         @((uint)0x5656acfa), @((uint)0xf4f4f307), @((uint)0xeaeacf25), @((uint)0x6565caaf), @((uint)0x7a7af48e),
                         @((uint)0xaeae47e9), @((uint)0x08081018), @((uint)0xbaba6fd5), @((uint)0x7878f088), @((uint)0x25254a6f),
                         @((uint)0x2e2e5c72), @((uint)0x1c1c3824), @((uint)0xa6a657f1), @((uint)0xb4b473c7), @((uint)0xc6c69751),
                         @((uint)0xe8e8cb23), @((uint)0xdddda17c), @((uint)0x7474e89c), @((uint)0x1f1f3e21), @((uint)0x4b4b96dd),
                         @((uint)0xbdbd61dc), @((uint)0x8b8b0d86), @((uint)0x8a8a0f85), @((uint)0x7070e090), @((uint)0x3e3e7c42),
                         @((uint)0xb5b571c4), @((uint)0x6666ccaa), @((uint)0x484890d8), @((uint)0x03030605), @((uint)0xf6f6f701),
                         @((uint)0x0e0e1c12), @((uint)0x6161c2a3), @((uint)0x35356a5f), @((uint)0x5757aef9), @((uint)0xb9b969d0),
                         @((uint)0x86861791), @((uint)0xc1c19958), @((uint)0x1d1d3a27), @((uint)0x9e9e27b9), @((uint)0xe1e1d938),
                         @((uint)0xf8f8eb13), @((uint)0x98982bb3), @((uint)0x11112233), @((uint)0x6969d2bb), @((uint)0xd9d9a970),
                         @((uint)0x8e8e0789), @((uint)0x949433a7), @((uint)0x9b9b2db6), @((uint)0x1e1e3c22), @((uint)0x87871592),
                         @((uint)0xe9e9c920), @((uint)0xcece8749), @((uint)0x5555aaff), @((uint)0x28285078), @((uint)0xdfdfa57a),
                         @((uint)0x8c8c038f), @((uint)0xa1a159f8), @((uint)0x89890980), @((uint)0x0d0d1a17), @((uint)0xbfbf65da),
                         @((uint)0xe6e6d731), @((uint)0x424284c6), @((uint)0x6868d0b8), @((uint)0x414182c3), @((uint)0x999929b0),
                         @((uint)0x2d2d5a77), @((uint)0x0f0f1e11), @((uint)0xb0b07bcb), @((uint)0x5454a8fc), @((uint)0xbbbb6dd6),
                         @((uint)0x16162c3a)] mutableCopy];
                [_t1 setFixedSize:(int)(_t1.count)];
            }
        }
    }
    return _t1;
}

+ (NSMutableArray*)T2 {
    static NSMutableArray *_t2 = nil;
    @synchronized(self) {
        if (_t2 == nil) {
            @autoreleasepool {
                _t2 = [@[@((uint)0x63c6a563), @((uint)0x7cf8847c), @((uint)0x77ee9977), @((uint)0x7bf68d7b), @((uint)0xf2ff0df2),
                         @((uint)0x6bd6bd6b), @((uint)0x6fdeb16f), @((uint)0xc59154c5), @((uint)0x30605030), @((uint)0x01020301),
                         @((uint)0x67cea967), @((uint)0x2b567d2b), @((uint)0xfee719fe), @((uint)0xd7b562d7), @((uint)0xab4de6ab),
                         @((uint)0x76ec9a76), @((uint)0xca8f45ca), @((uint)0x821f9d82), @((uint)0xc98940c9), @((uint)0x7dfa877d),
                         @((uint)0xfaef15fa), @((uint)0x59b2eb59), @((uint)0x478ec947), @((uint)0xf0fb0bf0), @((uint)0xad41ecad),
                         @((uint)0xd4b367d4), @((uint)0xa25ffda2), @((uint)0xaf45eaaf), @((uint)0x9c23bf9c), @((uint)0xa453f7a4),
                         @((uint)0x72e49672), @((uint)0xc09b5bc0), @((uint)0xb775c2b7), @((uint)0xfde11cfd), @((uint)0x933dae93),
                         @((uint)0x264c6a26), @((uint)0x366c5a36), @((uint)0x3f7e413f), @((uint)0xf7f502f7), @((uint)0xcc834fcc),
                         @((uint)0x34685c34), @((uint)0xa551f4a5), @((uint)0xe5d134e5), @((uint)0xf1f908f1), @((uint)0x71e29371),
                         @((uint)0xd8ab73d8), @((uint)0x31625331), @((uint)0x152a3f15), @((uint)0x04080c04), @((uint)0xc79552c7),
                         @((uint)0x23466523), @((uint)0xc39d5ec3), @((uint)0x18302818), @((uint)0x9637a196), @((uint)0x050a0f05),
                         @((uint)0x9a2fb59a), @((uint)0x070e0907), @((uint)0x12243612), @((uint)0x801b9b80), @((uint)0xe2df3de2),
                         @((uint)0xebcd26eb), @((uint)0x274e6927), @((uint)0xb27fcdb2), @((uint)0x75ea9f75), @((uint)0x09121b09),
                         @((uint)0x831d9e83), @((uint)0x2c58742c), @((uint)0x1a342e1a), @((uint)0x1b362d1b), @((uint)0x6edcb26e),
                         @((uint)0x5ab4ee5a), @((uint)0xa05bfba0), @((uint)0x52a4f652), @((uint)0x3b764d3b), @((uint)0xd6b761d6),
                         @((uint)0xb37dceb3), @((uint)0x29527b29), @((uint)0xe3dd3ee3), @((uint)0x2f5e712f), @((uint)0x84139784),
                         @((uint)0x53a6f553), @((uint)0xd1b968d1), @((uint)0x00000000), @((uint)0xedc12ced), @((uint)0x20406020),
                         @((uint)0xfce31ffc), @((uint)0xb179c8b1), @((uint)0x5bb6ed5b), @((uint)0x6ad4be6a), @((uint)0xcb8d46cb),
                         @((uint)0xbe67d9be), @((uint)0x39724b39), @((uint)0x4a94de4a), @((uint)0x4c98d44c), @((uint)0x58b0e858),
                         @((uint)0xcf854acf), @((uint)0xd0bb6bd0), @((uint)0xefc52aef), @((uint)0xaa4fe5aa), @((uint)0xfbed16fb),
                         @((uint)0x4386c543), @((uint)0x4d9ad74d), @((uint)0x33665533), @((uint)0x85119485), @((uint)0x458acf45),
                         @((uint)0xf9e910f9), @((uint)0x02040602), @((uint)0x7ffe817f), @((uint)0x50a0f050), @((uint)0x3c78443c),
                         @((uint)0x9f25ba9f), @((uint)0xa84be3a8), @((uint)0x51a2f351), @((uint)0xa35dfea3), @((uint)0x4080c040),
                         @((uint)0x8f058a8f), @((uint)0x923fad92), @((uint)0x9d21bc9d), @((uint)0x38704838), @((uint)0xf5f104f5),
                         @((uint)0xbc63dfbc), @((uint)0xb677c1b6), @((uint)0xdaaf75da), @((uint)0x21426321), @((uint)0x10203010),
                         @((uint)0xffe51aff), @((uint)0xf3fd0ef3), @((uint)0xd2bf6dd2), @((uint)0xcd814ccd), @((uint)0x0c18140c),
                         @((uint)0x13263513), @((uint)0xecc32fec), @((uint)0x5fbee15f), @((uint)0x9735a297), @((uint)0x4488cc44),
                         @((uint)0x172e3917), @((uint)0xc49357c4), @((uint)0xa755f2a7), @((uint)0x7efc827e), @((uint)0x3d7a473d),
                         @((uint)0x64c8ac64), @((uint)0x5dbae75d), @((uint)0x19322b19), @((uint)0x73e69573), @((uint)0x60c0a060),
                         @((uint)0x81199881), @((uint)0x4f9ed14f), @((uint)0xdca37fdc), @((uint)0x22446622), @((uint)0x2a547e2a),
                         @((uint)0x903bab90), @((uint)0x880b8388), @((uint)0x468cca46), @((uint)0xeec729ee), @((uint)0xb86bd3b8),
                         @((uint)0x14283c14), @((uint)0xdea779de), @((uint)0x5ebce25e), @((uint)0x0b161d0b), @((uint)0xdbad76db),
                         @((uint)0xe0db3be0), @((uint)0x32645632), @((uint)0x3a744e3a), @((uint)0x0a141e0a), @((uint)0x4992db49),
                         @((uint)0x060c0a06), @((uint)0x24486c24), @((uint)0x5cb8e45c), @((uint)0xc29f5dc2), @((uint)0xd3bd6ed3),
                         @((uint)0xac43efac), @((uint)0x62c4a662), @((uint)0x9139a891), @((uint)0x9531a495), @((uint)0xe4d337e4),
                         @((uint)0x79f28b79), @((uint)0xe7d532e7), @((uint)0xc88b43c8), @((uint)0x376e5937), @((uint)0x6ddab76d),
                         @((uint)0x8d018c8d), @((uint)0xd5b164d5), @((uint)0x4e9cd24e), @((uint)0xa949e0a9), @((uint)0x6cd8b46c),
                         @((uint)0x56acfa56), @((uint)0xf4f307f4), @((uint)0xeacf25ea), @((uint)0x65caaf65), @((uint)0x7af48e7a),
                         @((uint)0xae47e9ae), @((uint)0x08101808), @((uint)0xba6fd5ba), @((uint)0x78f08878), @((uint)0x254a6f25),
                         @((uint)0x2e5c722e), @((uint)0x1c38241c), @((uint)0xa657f1a6), @((uint)0xb473c7b4), @((uint)0xc69751c6),
                         @((uint)0xe8cb23e8), @((uint)0xdda17cdd), @((uint)0x74e89c74), @((uint)0x1f3e211f), @((uint)0x4b96dd4b),
                         @((uint)0xbd61dcbd), @((uint)0x8b0d868b), @((uint)0x8a0f858a), @((uint)0x70e09070), @((uint)0x3e7c423e),
                         @((uint)0xb571c4b5), @((uint)0x66ccaa66), @((uint)0x4890d848), @((uint)0x03060503), @((uint)0xf6f701f6),
                         @((uint)0x0e1c120e), @((uint)0x61c2a361), @((uint)0x356a5f35), @((uint)0x57aef957), @((uint)0xb969d0b9),
                         @((uint)0x86179186), @((uint)0xc19958c1), @((uint)0x1d3a271d), @((uint)0x9e27b99e), @((uint)0xe1d938e1),
                         @((uint)0xf8eb13f8), @((uint)0x982bb398), @((uint)0x11223311), @((uint)0x69d2bb69), @((uint)0xd9a970d9),
                         @((uint)0x8e07898e), @((uint)0x9433a794), @((uint)0x9b2db69b), @((uint)0x1e3c221e), @((uint)0x87159287),
                         @((uint)0xe9c920e9), @((uint)0xce8749ce), @((uint)0x55aaff55), @((uint)0x28507828), @((uint)0xdfa57adf),
                         @((uint)0x8c038f8c), @((uint)0xa159f8a1), @((uint)0x89098089), @((uint)0x0d1a170d), @((uint)0xbf65dabf),
                         @((uint)0xe6d731e6), @((uint)0x4284c642), @((uint)0x68d0b868), @((uint)0x4182c341), @((uint)0x9929b099),
                         @((uint)0x2d5a772d), @((uint)0x0f1e110f), @((uint)0xb07bcbb0), @((uint)0x54a8fc54), @((uint)0xbb6dd6bb),
                         @((uint)0x162c3a16)] mutableCopy];
                [_t2 setFixedSize:(int)(_t2.count)];
            }
        }
    }
    return _t2;
}

+ (NSMutableArray*)T3 {
    static NSMutableArray *_t3 = nil;
    @synchronized(self) {
        if (_t3 == nil) {
            @autoreleasepool {
                _t3 = [@[@((uint)0xc6a56363), @((uint)0xf8847c7c), @((uint)0xee997777), @((uint)0xf68d7b7b), @((uint)0xff0df2f2),
                         @((uint)0xd6bd6b6b), @((uint)0xdeb16f6f), @((uint)0x9154c5c5), @((uint)0x60503030), @((uint)0x02030101),
                         @((uint)0xcea96767), @((uint)0x567d2b2b), @((uint)0xe719fefe), @((uint)0xb562d7d7), @((uint)0x4de6abab),
                         @((uint)0xec9a7676), @((uint)0x8f45caca), @((uint)0x1f9d8282), @((uint)0x8940c9c9), @((uint)0xfa877d7d),
                         @((uint)0xef15fafa), @((uint)0xb2eb5959), @((uint)0x8ec94747), @((uint)0xfb0bf0f0), @((uint)0x41ecadad),
                         @((uint)0xb367d4d4), @((uint)0x5ffda2a2), @((uint)0x45eaafaf), @((uint)0x23bf9c9c), @((uint)0x53f7a4a4),
                         @((uint)0xe4967272), @((uint)0x9b5bc0c0), @((uint)0x75c2b7b7), @((uint)0xe11cfdfd), @((uint)0x3dae9393),
                         @((uint)0x4c6a2626), @((uint)0x6c5a3636), @((uint)0x7e413f3f), @((uint)0xf502f7f7), @((uint)0x834fcccc),
                         @((uint)0x685c3434), @((uint)0x51f4a5a5), @((uint)0xd134e5e5), @((uint)0xf908f1f1), @((uint)0xe2937171),
                         @((uint)0xab73d8d8), @((uint)0x62533131), @((uint)0x2a3f1515), @((uint)0x080c0404), @((uint)0x9552c7c7),
                         @((uint)0x46652323), @((uint)0x9d5ec3c3), @((uint)0x30281818), @((uint)0x37a19696), @((uint)0x0a0f0505),
                         @((uint)0x2fb59a9a), @((uint)0x0e090707), @((uint)0x24361212), @((uint)0x1b9b8080), @((uint)0xdf3de2e2),
                         @((uint)0xcd26ebeb), @((uint)0x4e692727), @((uint)0x7fcdb2b2), @((uint)0xea9f7575), @((uint)0x121b0909),
                         @((uint)0x1d9e8383), @((uint)0x58742c2c), @((uint)0x342e1a1a), @((uint)0x362d1b1b), @((uint)0xdcb26e6e),
                         @((uint)0xb4ee5a5a), @((uint)0x5bfba0a0), @((uint)0xa4f65252), @((uint)0x764d3b3b), @((uint)0xb761d6d6),
                         @((uint)0x7dceb3b3), @((uint)0x527b2929), @((uint)0xdd3ee3e3), @((uint)0x5e712f2f), @((uint)0x13978484),
                         @((uint)0xa6f55353), @((uint)0xb968d1d1), @((uint)0x00000000), @((uint)0xc12ceded), @((uint)0x40602020),
                         @((uint)0xe31ffcfc), @((uint)0x79c8b1b1), @((uint)0xb6ed5b5b), @((uint)0xd4be6a6a), @((uint)0x8d46cbcb),
                         @((uint)0x67d9bebe), @((uint)0x724b3939), @((uint)0x94de4a4a), @((uint)0x98d44c4c), @((uint)0xb0e85858),
                         @((uint)0x854acfcf), @((uint)0xbb6bd0d0), @((uint)0xc52aefef), @((uint)0x4fe5aaaa), @((uint)0xed16fbfb),
                         @((uint)0x86c54343), @((uint)0x9ad74d4d), @((uint)0x66553333), @((uint)0x11948585), @((uint)0x8acf4545),
                         @((uint)0xe910f9f9), @((uint)0x04060202), @((uint)0xfe817f7f), @((uint)0xa0f05050), @((uint)0x78443c3c),
                         @((uint)0x25ba9f9f), @((uint)0x4be3a8a8), @((uint)0xa2f35151), @((uint)0x5dfea3a3), @((uint)0x80c04040),
                         @((uint)0x058a8f8f), @((uint)0x3fad9292), @((uint)0x21bc9d9d), @((uint)0x70483838), @((uint)0xf104f5f5),
                         @((uint)0x63dfbcbc), @((uint)0x77c1b6b6), @((uint)0xaf75dada), @((uint)0x42632121), @((uint)0x20301010),
                         @((uint)0xe51affff), @((uint)0xfd0ef3f3), @((uint)0xbf6dd2d2), @((uint)0x814ccdcd), @((uint)0x18140c0c),
                         @((uint)0x26351313), @((uint)0xc32fecec), @((uint)0xbee15f5f), @((uint)0x35a29797), @((uint)0x88cc4444),
                         @((uint)0x2e391717), @((uint)0x9357c4c4), @((uint)0x55f2a7a7), @((uint)0xfc827e7e), @((uint)0x7a473d3d),
                         @((uint)0xc8ac6464), @((uint)0xbae75d5d), @((uint)0x322b1919), @((uint)0xe6957373), @((uint)0xc0a06060),
                         @((uint)0x19988181), @((uint)0x9ed14f4f), @((uint)0xa37fdcdc), @((uint)0x44662222), @((uint)0x547e2a2a),
                         @((uint)0x3bab9090), @((uint)0x0b838888), @((uint)0x8cca4646), @((uint)0xc729eeee), @((uint)0x6bd3b8b8),
                         @((uint)0x283c1414), @((uint)0xa779dede), @((uint)0xbce25e5e), @((uint)0x161d0b0b), @((uint)0xad76dbdb),
                         @((uint)0xdb3be0e0), @((uint)0x64563232), @((uint)0x744e3a3a), @((uint)0x141e0a0a), @((uint)0x92db4949),
                         @((uint)0x0c0a0606), @((uint)0x486c2424), @((uint)0xb8e45c5c), @((uint)0x9f5dc2c2), @((uint)0xbd6ed3d3),
                         @((uint)0x43efacac), @((uint)0xc4a66262), @((uint)0x39a89191), @((uint)0x31a49595), @((uint)0xd337e4e4),
                         @((uint)0xf28b7979), @((uint)0xd532e7e7), @((uint)0x8b43c8c8), @((uint)0x6e593737), @((uint)0xdab76d6d),
                         @((uint)0x018c8d8d), @((uint)0xb164d5d5), @((uint)0x9cd24e4e), @((uint)0x49e0a9a9), @((uint)0xd8b46c6c),
                         @((uint)0xacfa5656), @((uint)0xf307f4f4), @((uint)0xcf25eaea), @((uint)0xcaaf6565), @((uint)0xf48e7a7a),
                         @((uint)0x47e9aeae), @((uint)0x10180808), @((uint)0x6fd5baba), @((uint)0xf0887878), @((uint)0x4a6f2525),
                         @((uint)0x5c722e2e), @((uint)0x38241c1c), @((uint)0x57f1a6a6), @((uint)0x73c7b4b4), @((uint)0x9751c6c6),
                         @((uint)0xcb23e8e8), @((uint)0xa17cdddd), @((uint)0xe89c7474), @((uint)0x3e211f1f), @((uint)0x96dd4b4b),
                         @((uint)0x61dcbdbd), @((uint)0x0d868b8b), @((uint)0x0f858a8a), @((uint)0xe0907070), @((uint)0x7c423e3e),
                         @((uint)0x71c4b5b5), @((uint)0xccaa6666), @((uint)0x90d84848), @((uint)0x06050303), @((uint)0xf701f6f6),
                         @((uint)0x1c120e0e), @((uint)0xc2a36161), @((uint)0x6a5f3535), @((uint)0xaef95757), @((uint)0x69d0b9b9),
                         @((uint)0x17918686), @((uint)0x9958c1c1), @((uint)0x3a271d1d), @((uint)0x27b99e9e), @((uint)0xd938e1e1),
                         @((uint)0xeb13f8f8), @((uint)0x2bb39898), @((uint)0x22331111), @((uint)0xd2bb6969), @((uint)0xa970d9d9),
                         @((uint)0x07898e8e), @((uint)0x33a79494), @((uint)0x2db69b9b), @((uint)0x3c221e1e), @((uint)0x15928787),
                         @((uint)0xc920e9e9), @((uint)0x8749cece), @((uint)0xaaff5555), @((uint)0x50782828), @((uint)0xa57adfdf),
                         @((uint)0x038f8c8c), @((uint)0x59f8a1a1), @((uint)0x09808989), @((uint)0x1a170d0d), @((uint)0x65dabfbf),
                         @((uint)0xd731e6e6), @((uint)0x84c64242), @((uint)0xd0b86868), @((uint)0x82c34141), @((uint)0x29b09999),
                         @((uint)0x5a772d2d), @((uint)0x1e110f0f), @((uint)0x7bcbb0b0), @((uint)0xa8fc5454), @((uint)0x6dd6bbbb),
                         @((uint)0x2c3a1616)] mutableCopy];
                [_t3 setFixedSize:(int)(_t3.count)];
            }
        }
    }
    return _t3;
}

+ (NSMutableArray*)Tinv0 {
    static NSMutableArray *_tinv0 = nil;
    @synchronized(self) {
        if (_tinv0 == nil) {
            @autoreleasepool {
                _tinv0 = [@[@((uint)0x50a7f451), @((uint)0x5365417e), @((uint)0xc3a4171a), @((uint)0x965e273a), @((uint)0xcb6bab3b),
                            @((uint)0xf1459d1f), @((uint)0xab58faac), @((uint)0x9303e34b), @((uint)0x55fa3020), @((uint)0xf66d76ad),
                            @((uint)0x9176cc88), @((uint)0x254c02f5), @((uint)0xfcd7e54f), @((uint)0xd7cb2ac5), @((uint)0x80443526),
                            @((uint)0x8fa362b5), @((uint)0x495ab1de), @((uint)0x671bba25), @((uint)0x980eea45), @((uint)0xe1c0fe5d),
                            @((uint)0x02752fc3), @((uint)0x12f04c81), @((uint)0xa397468d), @((uint)0xc6f9d36b), @((uint)0xe75f8f03),
                            @((uint)0x959c9215), @((uint)0xeb7a6dbf), @((uint)0xda595295), @((uint)0x2d83bed4), @((uint)0xd3217458),
                            @((uint)0x2969e049), @((uint)0x44c8c98e), @((uint)0x6a89c275), @((uint)0x78798ef4), @((uint)0x6b3e5899),
                            @((uint)0xdd71b927), @((uint)0xb64fe1be), @((uint)0x17ad88f0), @((uint)0x66ac20c9), @((uint)0xb43ace7d),
                            @((uint)0x184adf63), @((uint)0x82311ae5), @((uint)0x60335197), @((uint)0x457f5362), @((uint)0xe07764b1),
                            @((uint)0x84ae6bbb), @((uint)0x1ca081fe), @((uint)0x942b08f9), @((uint)0x58684870), @((uint)0x19fd458f),
                            @((uint)0x876cde94), @((uint)0xb7f87b52), @((uint)0x23d373ab), @((uint)0xe2024b72), @((uint)0x578f1fe3),
                            @((uint)0x2aab5566), @((uint)0x0728ebb2), @((uint)0x03c2b52f), @((uint)0x9a7bc586), @((uint)0xa50837d3),
                            @((uint)0xf2872830), @((uint)0xb2a5bf23), @((uint)0xba6a0302), @((uint)0x5c8216ed), @((uint)0x2b1ccf8a),
                            @((uint)0x92b479a7), @((uint)0xf0f207f3), @((uint)0xa1e2694e), @((uint)0xcdf4da65), @((uint)0xd5be0506),
                            @((uint)0x1f6234d1), @((uint)0x8afea6c4), @((uint)0x9d532e34), @((uint)0xa055f3a2), @((uint)0x32e18a05),
                            @((uint)0x75ebf6a4), @((uint)0x39ec830b), @((uint)0xaaef6040), @((uint)0x069f715e), @((uint)0x51106ebd),
                            @((uint)0xf98a213e), @((uint)0x3d06dd96), @((uint)0xae053edd), @((uint)0x46bde64d), @((uint)0xb58d5491),
                            @((uint)0x055dc471), @((uint)0x6fd40604), @((uint)0xff155060), @((uint)0x24fb9819), @((uint)0x97e9bdd6),
                            @((uint)0xcc434089), @((uint)0x779ed967), @((uint)0xbd42e8b0), @((uint)0x888b8907), @((uint)0x385b19e7),
                            @((uint)0xdbeec879), @((uint)0x470a7ca1), @((uint)0xe90f427c), @((uint)0xc91e84f8), @((uint)0x00000000),
                            @((uint)0x83868009), @((uint)0x48ed2b32), @((uint)0xac70111e), @((uint)0x4e725a6c), @((uint)0xfbff0efd),
                            @((uint)0x5638850f), @((uint)0x1ed5ae3d), @((uint)0x27392d36), @((uint)0x64d90f0a), @((uint)0x21a65c68),
                            @((uint)0xd1545b9b), @((uint)0x3a2e3624), @((uint)0xb1670a0c), @((uint)0x0fe75793), @((uint)0xd296eeb4),
                            @((uint)0x9e919b1b), @((uint)0x4fc5c080), @((uint)0xa220dc61), @((uint)0x694b775a), @((uint)0x161a121c),
                            @((uint)0x0aba93e2), @((uint)0xe52aa0c0), @((uint)0x43e0223c), @((uint)0x1d171b12), @((uint)0x0b0d090e),
                            @((uint)0xadc78bf2), @((uint)0xb9a8b62d), @((uint)0xc8a91e14), @((uint)0x8519f157), @((uint)0x4c0775af),
                            @((uint)0xbbdd99ee), @((uint)0xfd607fa3), @((uint)0x9f2601f7), @((uint)0xbcf5725c), @((uint)0xc53b6644),
                            @((uint)0x347efb5b), @((uint)0x7629438b), @((uint)0xdcc623cb), @((uint)0x68fcedb6), @((uint)0x63f1e4b8),
                            @((uint)0xcadc31d7), @((uint)0x10856342), @((uint)0x40229713), @((uint)0x2011c684), @((uint)0x7d244a85),
                            @((uint)0xf83dbbd2), @((uint)0x1132f9ae), @((uint)0x6da129c7), @((uint)0x4b2f9e1d), @((uint)0xf330b2dc),
                            @((uint)0xec52860d), @((uint)0xd0e3c177), @((uint)0x6c16b32b), @((uint)0x99b970a9), @((uint)0xfa489411),
                            @((uint)0x2264e947), @((uint)0xc48cfca8), @((uint)0x1a3ff0a0), @((uint)0xd82c7d56), @((uint)0xef903322),
                            @((uint)0xc74e4987), @((uint)0xc1d138d9), @((uint)0xfea2ca8c), @((uint)0x360bd498), @((uint)0xcf81f5a6),
                            @((uint)0x28de7aa5), @((uint)0x268eb7da), @((uint)0xa4bfad3f), @((uint)0xe49d3a2c), @((uint)0x0d927850),
                            @((uint)0x9bcc5f6a), @((uint)0x62467e54), @((uint)0xc2138df6), @((uint)0xe8b8d890), @((uint)0x5ef7392e),
                            @((uint)0xf5afc382), @((uint)0xbe805d9f), @((uint)0x7c93d069), @((uint)0xa92dd56f), @((uint)0xb31225cf),
                            @((uint)0x3b99acc8), @((uint)0xa77d1810), @((uint)0x6e639ce8), @((uint)0x7bbb3bdb), @((uint)0x097826cd),
                            @((uint)0xf418596e), @((uint)0x01b79aec), @((uint)0xa89a4f83), @((uint)0x656e95e6), @((uint)0x7ee6ffaa),
                            @((uint)0x08cfbc21), @((uint)0xe6e815ef), @((uint)0xd99be7ba), @((uint)0xce366f4a), @((uint)0xd4099fea),
                            @((uint)0xd67cb029), @((uint)0xafb2a431), @((uint)0x31233f2a), @((uint)0x3094a5c6), @((uint)0xc066a235),
                            @((uint)0x37bc4e74), @((uint)0xa6ca82fc), @((uint)0xb0d090e0), @((uint)0x15d8a733), @((uint)0x4a9804f1),
                            @((uint)0xf7daec41), @((uint)0x0e50cd7f), @((uint)0x2ff69117), @((uint)0x8dd64d76), @((uint)0x4db0ef43),
                            @((uint)0x544daacc), @((uint)0xdf0496e4), @((uint)0xe3b5d19e), @((uint)0x1b886a4c), @((uint)0xb81f2cc1),
                            @((uint)0x7f516546), @((uint)0x04ea5e9d), @((uint)0x5d358c01), @((uint)0x737487fa), @((uint)0x2e410bfb),
                            @((uint)0x5a1d67b3), @((uint)0x52d2db92), @((uint)0x335610e9), @((uint)0x1347d66d), @((uint)0x8c61d79a),
                            @((uint)0x7a0ca137), @((uint)0x8e14f859), @((uint)0x893c13eb), @((uint)0xee27a9ce), @((uint)0x35c961b7),
                            @((uint)0xede51ce1), @((uint)0x3cb1477a), @((uint)0x59dfd29c), @((uint)0x3f73f255), @((uint)0x79ce1418),
                            @((uint)0xbf37c773), @((uint)0xeacdf753), @((uint)0x5baafd5f), @((uint)0x146f3ddf), @((uint)0x86db4478),
                            @((uint)0x81f3afca), @((uint)0x3ec468b9), @((uint)0x2c342438), @((uint)0x5f40a3c2), @((uint)0x72c31d16),
                            @((uint)0x0c25e2bc), @((uint)0x8b493c28), @((uint)0x41950dff), @((uint)0x7101a839), @((uint)0xdeb30c08),
                            @((uint)0x9ce4b4d8), @((uint)0x90c15664), @((uint)0x6184cb7b), @((uint)0x70b632d5), @((uint)0x745c6c48),
                            @((uint)0x4257b8d0)] mutableCopy];
                [_tinv0 setFixedSize:(int)(_tinv0.count)];
            }
        }
    }
    return _tinv0;
}

+ (NSMutableArray*)Tinv1 {
    static NSMutableArray *_tinv1 = nil;
    @synchronized(self) {
        if (_tinv1 == nil) {
            @autoreleasepool {
                _tinv1 = [@[@((uint)0xa7f45150), @((uint)0x65417e53), @((uint)0xa4171ac3), @((uint)0x5e273a96), @((uint)0x6bab3bcb),
                            @((uint)0x459d1ff1), @((uint)0x58faacab), @((uint)0x03e34b93), @((uint)0xfa302055), @((uint)0x6d76adf6),
                            @((uint)0x76cc8891), @((uint)0x4c02f525), @((uint)0xd7e54ffc), @((uint)0xcb2ac5d7), @((uint)0x44352680),
                            @((uint)0xa362b58f), @((uint)0x5ab1de49), @((uint)0x1bba2567), @((uint)0x0eea4598), @((uint)0xc0fe5de1),
                            @((uint)0x752fc302), @((uint)0xf04c8112), @((uint)0x97468da3), @((uint)0xf9d36bc6), @((uint)0x5f8f03e7),
                            @((uint)0x9c921595), @((uint)0x7a6dbfeb), @((uint)0x595295da), @((uint)0x83bed42d), @((uint)0x217458d3),
                            @((uint)0x69e04929), @((uint)0xc8c98e44), @((uint)0x89c2756a), @((uint)0x798ef478), @((uint)0x3e58996b),
                            @((uint)0x71b927dd), @((uint)0x4fe1beb6), @((uint)0xad88f017), @((uint)0xac20c966), @((uint)0x3ace7db4),
                            @((uint)0x4adf6318), @((uint)0x311ae582), @((uint)0x33519760), @((uint)0x7f536245), @((uint)0x7764b1e0),
                            @((uint)0xae6bbb84), @((uint)0xa081fe1c), @((uint)0x2b08f994), @((uint)0x68487058), @((uint)0xfd458f19),
                            @((uint)0x6cde9487), @((uint)0xf87b52b7), @((uint)0xd373ab23), @((uint)0x024b72e2), @((uint)0x8f1fe357),
                            @((uint)0xab55662a), @((uint)0x28ebb207), @((uint)0xc2b52f03), @((uint)0x7bc5869a), @((uint)0x0837d3a5),
                            @((uint)0x872830f2), @((uint)0xa5bf23b2), @((uint)0x6a0302ba), @((uint)0x8216ed5c), @((uint)0x1ccf8a2b),
                            @((uint)0xb479a792), @((uint)0xf207f3f0), @((uint)0xe2694ea1), @((uint)0xf4da65cd), @((uint)0xbe0506d5),
                            @((uint)0x6234d11f), @((uint)0xfea6c48a), @((uint)0x532e349d), @((uint)0x55f3a2a0), @((uint)0xe18a0532),
                            @((uint)0xebf6a475), @((uint)0xec830b39), @((uint)0xef6040aa), @((uint)0x9f715e06), @((uint)0x106ebd51),
                            @((uint)0x8a213ef9), @((uint)0x06dd963d), @((uint)0x053eddae), @((uint)0xbde64d46), @((uint)0x8d5491b5),
                            @((uint)0x5dc47105), @((uint)0xd406046f), @((uint)0x155060ff), @((uint)0xfb981924), @((uint)0xe9bdd697),
                            @((uint)0x434089cc), @((uint)0x9ed96777), @((uint)0x42e8b0bd), @((uint)0x8b890788), @((uint)0x5b19e738),
                            @((uint)0xeec879db), @((uint)0x0a7ca147), @((uint)0x0f427ce9), @((uint)0x1e84f8c9), @((uint)0x00000000),
                            @((uint)0x86800983), @((uint)0xed2b3248), @((uint)0x70111eac), @((uint)0x725a6c4e), @((uint)0xff0efdfb),
                            @((uint)0x38850f56), @((uint)0xd5ae3d1e), @((uint)0x392d3627), @((uint)0xd90f0a64), @((uint)0xa65c6821),
                            @((uint)0x545b9bd1), @((uint)0x2e36243a), @((uint)0x670a0cb1), @((uint)0xe757930f), @((uint)0x96eeb4d2),
                            @((uint)0x919b1b9e), @((uint)0xc5c0804f), @((uint)0x20dc61a2), @((uint)0x4b775a69), @((uint)0x1a121c16),
                            @((uint)0xba93e20a), @((uint)0x2aa0c0e5), @((uint)0xe0223c43), @((uint)0x171b121d), @((uint)0x0d090e0b),
                            @((uint)0xc78bf2ad), @((uint)0xa8b62db9), @((uint)0xa91e14c8), @((uint)0x19f15785), @((uint)0x0775af4c),
                            @((uint)0xdd99eebb), @((uint)0x607fa3fd), @((uint)0x2601f79f), @((uint)0xf5725cbc), @((uint)0x3b6644c5),
                            @((uint)0x7efb5b34), @((uint)0x29438b76), @((uint)0xc623cbdc), @((uint)0xfcedb668), @((uint)0xf1e4b863),
                            @((uint)0xdc31d7ca), @((uint)0x85634210), @((uint)0x22971340), @((uint)0x11c68420), @((uint)0x244a857d),
                            @((uint)0x3dbbd2f8), @((uint)0x32f9ae11), @((uint)0xa129c76d), @((uint)0x2f9e1d4b), @((uint)0x30b2dcf3),
                            @((uint)0x52860dec), @((uint)0xe3c177d0), @((uint)0x16b32b6c), @((uint)0xb970a999), @((uint)0x489411fa),
                            @((uint)0x64e94722), @((uint)0x8cfca8c4), @((uint)0x3ff0a01a), @((uint)0x2c7d56d8), @((uint)0x903322ef),
                            @((uint)0x4e4987c7), @((uint)0xd138d9c1), @((uint)0xa2ca8cfe), @((uint)0x0bd49836), @((uint)0x81f5a6cf),
                            @((uint)0xde7aa528), @((uint)0x8eb7da26), @((uint)0xbfad3fa4), @((uint)0x9d3a2ce4), @((uint)0x9278500d),
                            @((uint)0xcc5f6a9b), @((uint)0x467e5462), @((uint)0x138df6c2), @((uint)0xb8d890e8), @((uint)0xf7392e5e),
                            @((uint)0xafc382f5), @((uint)0x805d9fbe), @((uint)0x93d0697c), @((uint)0x2dd56fa9), @((uint)0x1225cfb3),
                            @((uint)0x99acc83b), @((uint)0x7d1810a7), @((uint)0x639ce86e), @((uint)0xbb3bdb7b), @((uint)0x7826cd09),
                            @((uint)0x18596ef4), @((uint)0xb79aec01), @((uint)0x9a4f83a8), @((uint)0x6e95e665), @((uint)0xe6ffaa7e),
                            @((uint)0xcfbc2108), @((uint)0xe815efe6), @((uint)0x9be7bad9), @((uint)0x366f4ace), @((uint)0x099fead4),
                            @((uint)0x7cb029d6), @((uint)0xb2a431af), @((uint)0x233f2a31), @((uint)0x94a5c630), @((uint)0x66a235c0),
                            @((uint)0xbc4e7437), @((uint)0xca82fca6), @((uint)0xd090e0b0), @((uint)0xd8a73315), @((uint)0x9804f14a),
                            @((uint)0xdaec41f7), @((uint)0x50cd7f0e), @((uint)0xf691172f), @((uint)0xd64d768d), @((uint)0xb0ef434d),
                            @((uint)0x4daacc54), @((uint)0x0496e4df), @((uint)0xb5d19ee3), @((uint)0x886a4c1b), @((uint)0x1f2cc1b8),
                            @((uint)0x5165467f), @((uint)0xea5e9d04), @((uint)0x358c015d), @((uint)0x7487fa73), @((uint)0x410bfb2e),
                            @((uint)0x1d67b35a), @((uint)0xd2db9252), @((uint)0x5610e933), @((uint)0x47d66d13), @((uint)0x61d79a8c),
                            @((uint)0x0ca1377a), @((uint)0x14f8598e), @((uint)0x3c13eb89), @((uint)0x27a9ceee), @((uint)0xc961b735),
                            @((uint)0xe51ce1ed), @((uint)0xb1477a3c), @((uint)0xdfd29c59), @((uint)0x73f2553f), @((uint)0xce141879),
                            @((uint)0x37c773bf), @((uint)0xcdf753ea), @((uint)0xaafd5f5b), @((uint)0x6f3ddf14), @((uint)0xdb447886),
                            @((uint)0xf3afca81), @((uint)0xc468b93e), @((uint)0x3424382c), @((uint)0x40a3c25f), @((uint)0xc31d1672),
                            @((uint)0x25e2bc0c), @((uint)0x493c288b), @((uint)0x950dff41), @((uint)0x01a83971), @((uint)0xb30c08de),
                            @((uint)0xe4b4d89c), @((uint)0xc1566490), @((uint)0x84cb7b61), @((uint)0xb632d570), @((uint)0x5c6c4874),
                            @((uint)0x57b8d042)] mutableCopy];
                [_tinv1 setFixedSize:(int)(_tinv1.count)];
            }
        }
    }
    return _tinv1;
}

+ (NSMutableArray*)Tinv2 {
    static NSMutableArray *_tinv2 = nil;
    @synchronized(self) {
        if (_tinv2 == nil) {
            @autoreleasepool {
                _tinv2 = [@[@((uint)0xf45150a7), @((uint)0x417e5365), @((uint)0x171ac3a4), @((uint)0x273a965e), @((uint)0xab3bcb6b),
                            @((uint)0x9d1ff145), @((uint)0xfaacab58), @((uint)0xe34b9303), @((uint)0x302055fa), @((uint)0x76adf66d),
                            @((uint)0xcc889176), @((uint)0x02f5254c), @((uint)0xe54ffcd7), @((uint)0x2ac5d7cb), @((uint)0x35268044),
                            @((uint)0x62b58fa3), @((uint)0xb1de495a), @((uint)0xba25671b), @((uint)0xea45980e), @((uint)0xfe5de1c0),
                            @((uint)0x2fc30275), @((uint)0x4c8112f0), @((uint)0x468da397), @((uint)0xd36bc6f9), @((uint)0x8f03e75f),
                            @((uint)0x9215959c), @((uint)0x6dbfeb7a), @((uint)0x5295da59), @((uint)0xbed42d83), @((uint)0x7458d321),
                            @((uint)0xe0492969), @((uint)0xc98e44c8), @((uint)0xc2756a89), @((uint)0x8ef47879), @((uint)0x58996b3e),
                            @((uint)0xb927dd71), @((uint)0xe1beb64f), @((uint)0x88f017ad), @((uint)0x20c966ac), @((uint)0xce7db43a),
                            @((uint)0xdf63184a), @((uint)0x1ae58231), @((uint)0x51976033), @((uint)0x5362457f), @((uint)0x64b1e077),
                            @((uint)0x6bbb84ae), @((uint)0x81fe1ca0), @((uint)0x08f9942b), @((uint)0x48705868), @((uint)0x458f19fd),
                            @((uint)0xde94876c), @((uint)0x7b52b7f8), @((uint)0x73ab23d3), @((uint)0x4b72e202), @((uint)0x1fe3578f),
                            @((uint)0x55662aab), @((uint)0xebb20728), @((uint)0xb52f03c2), @((uint)0xc5869a7b), @((uint)0x37d3a508),
                            @((uint)0x2830f287), @((uint)0xbf23b2a5), @((uint)0x0302ba6a), @((uint)0x16ed5c82), @((uint)0xcf8a2b1c),
                            @((uint)0x79a792b4), @((uint)0x07f3f0f2), @((uint)0x694ea1e2), @((uint)0xda65cdf4), @((uint)0x0506d5be),
                            @((uint)0x34d11f62), @((uint)0xa6c48afe), @((uint)0x2e349d53), @((uint)0xf3a2a055), @((uint)0x8a0532e1),
                            @((uint)0xf6a475eb), @((uint)0x830b39ec), @((uint)0x6040aaef), @((uint)0x715e069f), @((uint)0x6ebd5110),
                            @((uint)0x213ef98a), @((uint)0xdd963d06), @((uint)0x3eddae05), @((uint)0xe64d46bd), @((uint)0x5491b58d),
                            @((uint)0xc471055d), @((uint)0x06046fd4), @((uint)0x5060ff15), @((uint)0x981924fb), @((uint)0xbdd697e9),
                            @((uint)0x4089cc43), @((uint)0xd967779e), @((uint)0xe8b0bd42), @((uint)0x8907888b), @((uint)0x19e7385b),
                            @((uint)0xc879dbee), @((uint)0x7ca1470a), @((uint)0x427ce90f), @((uint)0x84f8c91e), @((uint)0x00000000),
                            @((uint)0x80098386), @((uint)0x2b3248ed), @((uint)0x111eac70), @((uint)0x5a6c4e72), @((uint)0x0efdfbff),
                            @((uint)0x850f5638), @((uint)0xae3d1ed5), @((uint)0x2d362739), @((uint)0x0f0a64d9), @((uint)0x5c6821a6),
                            @((uint)0x5b9bd154), @((uint)0x36243a2e), @((uint)0x0a0cb167), @((uint)0x57930fe7), @((uint)0xeeb4d296),
                            @((uint)0x9b1b9e91), @((uint)0xc0804fc5), @((uint)0xdc61a220), @((uint)0x775a694b), @((uint)0x121c161a),
                            @((uint)0x93e20aba), @((uint)0xa0c0e52a), @((uint)0x223c43e0), @((uint)0x1b121d17), @((uint)0x090e0b0d),
                            @((uint)0x8bf2adc7), @((uint)0xb62db9a8), @((uint)0x1e14c8a9), @((uint)0xf1578519), @((uint)0x75af4c07),
                            @((uint)0x99eebbdd), @((uint)0x7fa3fd60), @((uint)0x01f79f26), @((uint)0x725cbcf5), @((uint)0x6644c53b),
                            @((uint)0xfb5b347e), @((uint)0x438b7629), @((uint)0x23cbdcc6), @((uint)0xedb668fc), @((uint)0xe4b863f1),
                            @((uint)0x31d7cadc), @((uint)0x63421085), @((uint)0x97134022), @((uint)0xc6842011), @((uint)0x4a857d24),
                            @((uint)0xbbd2f83d), @((uint)0xf9ae1132), @((uint)0x29c76da1), @((uint)0x9e1d4b2f), @((uint)0xb2dcf330),
                            @((uint)0x860dec52), @((uint)0xc177d0e3), @((uint)0xb32b6c16), @((uint)0x70a999b9), @((uint)0x9411fa48),
                            @((uint)0xe9472264), @((uint)0xfca8c48c), @((uint)0xf0a01a3f), @((uint)0x7d56d82c), @((uint)0x3322ef90),
                            @((uint)0x4987c74e), @((uint)0x38d9c1d1), @((uint)0xca8cfea2), @((uint)0xd498360b), @((uint)0xf5a6cf81),
                            @((uint)0x7aa528de), @((uint)0xb7da268e), @((uint)0xad3fa4bf), @((uint)0x3a2ce49d), @((uint)0x78500d92),
                            @((uint)0x5f6a9bcc), @((uint)0x7e546246), @((uint)0x8df6c213), @((uint)0xd890e8b8), @((uint)0x392e5ef7),
                            @((uint)0xc382f5af), @((uint)0x5d9fbe80), @((uint)0xd0697c93), @((uint)0xd56fa92d), @((uint)0x25cfb312),
                            @((uint)0xacc83b99), @((uint)0x1810a77d), @((uint)0x9ce86e63), @((uint)0x3bdb7bbb), @((uint)0x26cd0978),
                            @((uint)0x596ef418), @((uint)0x9aec01b7), @((uint)0x4f83a89a), @((uint)0x95e6656e), @((uint)0xffaa7ee6),
                            @((uint)0xbc2108cf), @((uint)0x15efe6e8), @((uint)0xe7bad99b), @((uint)0x6f4ace36), @((uint)0x9fead409),
                            @((uint)0xb029d67c), @((uint)0xa431afb2), @((uint)0x3f2a3123), @((uint)0xa5c63094), @((uint)0xa235c066),
                            @((uint)0x4e7437bc), @((uint)0x82fca6ca), @((uint)0x90e0b0d0), @((uint)0xa73315d8), @((uint)0x04f14a98),
                            @((uint)0xec41f7da), @((uint)0xcd7f0e50), @((uint)0x91172ff6), @((uint)0x4d768dd6), @((uint)0xef434db0),
                            @((uint)0xaacc544d), @((uint)0x96e4df04), @((uint)0xd19ee3b5), @((uint)0x6a4c1b88), @((uint)0x2cc1b81f),
                            @((uint)0x65467f51), @((uint)0x5e9d04ea), @((uint)0x8c015d35), @((uint)0x87fa7374), @((uint)0x0bfb2e41),
                            @((uint)0x67b35a1d), @((uint)0xdb9252d2), @((uint)0x10e93356), @((uint)0xd66d1347), @((uint)0xd79a8c61),
                            @((uint)0xa1377a0c), @((uint)0xf8598e14), @((uint)0x13eb893c), @((uint)0xa9ceee27), @((uint)0x61b735c9),
                            @((uint)0x1ce1ede5), @((uint)0x477a3cb1), @((uint)0xd29c59df), @((uint)0xf2553f73), @((uint)0x141879ce),
                            @((uint)0xc773bf37), @((uint)0xf753eacd), @((uint)0xfd5f5baa), @((uint)0x3ddf146f), @((uint)0x447886db),
                            @((uint)0xafca81f3), @((uint)0x68b93ec4), @((uint)0x24382c34), @((uint)0xa3c25f40), @((uint)0x1d1672c3),
                            @((uint)0xe2bc0c25), @((uint)0x3c288b49), @((uint)0x0dff4195), @((uint)0xa8397101), @((uint)0x0c08deb3),
                            @((uint)0xb4d89ce4), @((uint)0x566490c1), @((uint)0xcb7b6184), @((uint)0x32d570b6), @((uint)0x6c48745c),
                            @((uint)0xb8d04257)] mutableCopy];
                [_tinv2 setFixedSize:(int)(_tinv2.count)];
            }
        }
    }
    return _tinv2;
}

+ (NSMutableArray*)Tinv3 {
    static NSMutableArray *_tinv3 = nil;
    @synchronized(self) {
        if (_tinv3 == nil) {
            @autoreleasepool {
                _tinv3 = [@[@((uint)0x5150a7f4), @((uint)0x7e536541), @((uint)0x1ac3a417), @((uint)0x3a965e27), @((uint)0x3bcb6bab),
                            @((uint)0x1ff1459d), @((uint)0xacab58fa), @((uint)0x4b9303e3), @((uint)0x2055fa30), @((uint)0xadf66d76),
                            @((uint)0x889176cc), @((uint)0xf5254c02), @((uint)0x4ffcd7e5), @((uint)0xc5d7cb2a), @((uint)0x26804435),
                            @((uint)0xb58fa362), @((uint)0xde495ab1), @((uint)0x25671bba), @((uint)0x45980eea), @((uint)0x5de1c0fe),
                            @((uint)0xc302752f), @((uint)0x8112f04c), @((uint)0x8da39746), @((uint)0x6bc6f9d3), @((uint)0x03e75f8f),
                            @((uint)0x15959c92), @((uint)0xbfeb7a6d), @((uint)0x95da5952), @((uint)0xd42d83be), @((uint)0x58d32174),
                            @((uint)0x492969e0), @((uint)0x8e44c8c9), @((uint)0x756a89c2), @((uint)0xf478798e), @((uint)0x996b3e58),
                            @((uint)0x27dd71b9), @((uint)0xbeb64fe1), @((uint)0xf017ad88), @((uint)0xc966ac20), @((uint)0x7db43ace),
                            @((uint)0x63184adf), @((uint)0xe582311a), @((uint)0x97603351), @((uint)0x62457f53), @((uint)0xb1e07764),
                            @((uint)0xbb84ae6b), @((uint)0xfe1ca081), @((uint)0xf9942b08), @((uint)0x70586848), @((uint)0x8f19fd45),
                            @((uint)0x94876cde), @((uint)0x52b7f87b), @((uint)0xab23d373), @((uint)0x72e2024b), @((uint)0xe3578f1f),
                            @((uint)0x662aab55), @((uint)0xb20728eb), @((uint)0x2f03c2b5), @((uint)0x869a7bc5), @((uint)0xd3a50837),
                            @((uint)0x30f28728), @((uint)0x23b2a5bf), @((uint)0x02ba6a03), @((uint)0xed5c8216), @((uint)0x8a2b1ccf),
                            @((uint)0xa792b479), @((uint)0xf3f0f207), @((uint)0x4ea1e269), @((uint)0x65cdf4da), @((uint)0x06d5be05),
                            @((uint)0xd11f6234), @((uint)0xc48afea6), @((uint)0x349d532e), @((uint)0xa2a055f3), @((uint)0x0532e18a),
                            @((uint)0xa475ebf6), @((uint)0x0b39ec83), @((uint)0x40aaef60), @((uint)0x5e069f71), @((uint)0xbd51106e),
                            @((uint)0x3ef98a21), @((uint)0x963d06dd), @((uint)0xddae053e), @((uint)0x4d46bde6), @((uint)0x91b58d54),
                            @((uint)0x71055dc4), @((uint)0x046fd406), @((uint)0x60ff1550), @((uint)0x1924fb98), @((uint)0xd697e9bd),
                            @((uint)0x89cc4340), @((uint)0x67779ed9), @((uint)0xb0bd42e8), @((uint)0x07888b89), @((uint)0xe7385b19),
                            @((uint)0x79dbeec8), @((uint)0xa1470a7c), @((uint)0x7ce90f42), @((uint)0xf8c91e84), @((uint)0x00000000),
                            @((uint)0x09838680), @((uint)0x3248ed2b), @((uint)0x1eac7011), @((uint)0x6c4e725a), @((uint)0xfdfbff0e),
                            @((uint)0x0f563885), @((uint)0x3d1ed5ae), @((uint)0x3627392d), @((uint)0x0a64d90f), @((uint)0x6821a65c),
                            @((uint)0x9bd1545b), @((uint)0x243a2e36), @((uint)0x0cb1670a), @((uint)0x930fe757), @((uint)0xb4d296ee),
                            @((uint)0x1b9e919b), @((uint)0x804fc5c0), @((uint)0x61a220dc), @((uint)0x5a694b77), @((uint)0x1c161a12),
                            @((uint)0xe20aba93), @((uint)0xc0e52aa0), @((uint)0x3c43e022), @((uint)0x121d171b), @((uint)0x0e0b0d09),
                            @((uint)0xf2adc78b), @((uint)0x2db9a8b6), @((uint)0x14c8a91e), @((uint)0x578519f1), @((uint)0xaf4c0775),
                            @((uint)0xeebbdd99), @((uint)0xa3fd607f), @((uint)0xf79f2601), @((uint)0x5cbcf572), @((uint)0x44c53b66),
                            @((uint)0x5b347efb), @((uint)0x8b762943), @((uint)0xcbdcc623), @((uint)0xb668fced), @((uint)0xb863f1e4),
                            @((uint)0xd7cadc31), @((uint)0x42108563), @((uint)0x13402297), @((uint)0x842011c6), @((uint)0x857d244a),
                            @((uint)0xd2f83dbb), @((uint)0xae1132f9), @((uint)0xc76da129), @((uint)0x1d4b2f9e), @((uint)0xdcf330b2),
                            @((uint)0x0dec5286), @((uint)0x77d0e3c1), @((uint)0x2b6c16b3), @((uint)0xa999b970), @((uint)0x11fa4894),
                            @((uint)0x472264e9), @((uint)0xa8c48cfc), @((uint)0xa01a3ff0), @((uint)0x56d82c7d), @((uint)0x22ef9033),
                            @((uint)0x87c74e49), @((uint)0xd9c1d138), @((uint)0x8cfea2ca), @((uint)0x98360bd4), @((uint)0xa6cf81f5),
                            @((uint)0xa528de7a), @((uint)0xda268eb7), @((uint)0x3fa4bfad), @((uint)0x2ce49d3a), @((uint)0x500d9278),
                            @((uint)0x6a9bcc5f), @((uint)0x5462467e), @((uint)0xf6c2138d), @((uint)0x90e8b8d8), @((uint)0x2e5ef739),
                            @((uint)0x82f5afc3), @((uint)0x9fbe805d), @((uint)0x697c93d0), @((uint)0x6fa92dd5), @((uint)0xcfb31225),
                            @((uint)0xc83b99ac), @((uint)0x10a77d18), @((uint)0xe86e639c), @((uint)0xdb7bbb3b), @((uint)0xcd097826),
                            @((uint)0x6ef41859), @((uint)0xec01b79a), @((uint)0x83a89a4f), @((uint)0xe6656e95), @((uint)0xaa7ee6ff),
                            @((uint)0x2108cfbc), @((uint)0xefe6e815), @((uint)0xbad99be7), @((uint)0x4ace366f), @((uint)0xead4099f),
                            @((uint)0x29d67cb0), @((uint)0x31afb2a4), @((uint)0x2a31233f), @((uint)0xc63094a5), @((uint)0x35c066a2),
                            @((uint)0x7437bc4e), @((uint)0xfca6ca82), @((uint)0xe0b0d090), @((uint)0x3315d8a7), @((uint)0xf14a9804),
                            @((uint)0x41f7daec), @((uint)0x7f0e50cd), @((uint)0x172ff691), @((uint)0x768dd64d), @((uint)0x434db0ef),
                            @((uint)0xcc544daa), @((uint)0xe4df0496), @((uint)0x9ee3b5d1), @((uint)0x4c1b886a), @((uint)0xc1b81f2c),
                            @((uint)0x467f5165), @((uint)0x9d04ea5e), @((uint)0x015d358c), @((uint)0xfa737487), @((uint)0xfb2e410b),
                            @((uint)0xb35a1d67), @((uint)0x9252d2db), @((uint)0xe9335610), @((uint)0x6d1347d6), @((uint)0x9a8c61d7),
                            @((uint)0x377a0ca1), @((uint)0x598e14f8), @((uint)0xeb893c13), @((uint)0xceee27a9), @((uint)0xb735c961),
                            @((uint)0xe1ede51c), @((uint)0x7a3cb147), @((uint)0x9c59dfd2), @((uint)0x553f73f2), @((uint)0x1879ce14),
                            @((uint)0x73bf37c7), @((uint)0x53eacdf7), @((uint)0x5f5baafd), @((uint)0xdf146f3d), @((uint)0x7886db44),
                            @((uint)0xca81f3af), @((uint)0xb93ec468), @((uint)0x382c3424), @((uint)0xc25f40a3), @((uint)0x1672c31d),
                            @((uint)0xbc0c25e2), @((uint)0x288b493c), @((uint)0xff41950d), @((uint)0x397101a8), @((uint)0x08deb30c),
                            @((uint)0xd89ce4b4), @((uint)0x6490c156), @((uint)0x7b6184cb), @((uint)0xd570b632), @((uint)0x48745c6c),
                            @((uint)0xd04257b8)] mutableCopy];
                [_tinv3 setFixedSize:(int)(_tinv3.count)];
            }
        }
    }
    return _tinv3;
}

+ (uint)shift:(uint)r withShift:(int)shift {
    return (r >> shift) | (r << (32 - shift));
}

/* multiply four bytes in GF(2^8) by 'x' {02} in parallel */

static const uint m1 = 0x80808080;
static const uint m2 = 0x7f7f7f7f;
static const uint m3 = 0x0000001b;
static const uint m4 = 0xC0C0C0C0;
static const uint m5 = 0x3f3f3f3f;

+ (uint)ffmulX:(uint)x {
    return ((x & m2) << 1) ^ (((x & m1) >> 7) * m3);
}

+ (uint)ffmulX2:(uint)x {
    uint t0  = (x & m5) << 2;
    uint t1  = (x & m4);
    t1 ^= (t1 >> 1);
    return t0 ^ (t1 >> 2) ^ (t1 >> 5);
}

/*
 The following defines provide alternative definitions of FFmulX that might
 give improved performance if a fast 32-bit multiply is not available.
 
 private int FFmulX(int x) { int u = x & m1; u |= (u >> 1); return ((x & m2) << 1) ^ ((u >>> 3) | (u >>> 6)); }
 private static final int  m4 = 0x1b1b1b1b;
 private int FFmulX(int x) { int u = x & m1; return ((x & m2) << 1) ^ ((u - (u >>> 7)) & m4); }
 
 */

+ (uint)inv_Mcol:(uint)x {
    uint t0, t1;
    t0  = x;
    t1  = t0 ^ [AesFastEngine shift:t0 withShift:8];
    t0 ^= [AesFastEngine ffmulX:t1];
    t1 ^= [AesFastEngine ffmulX2:t0];
    t0 ^= t1 ^ [AesFastEngine shift:t1 withShift:16];
    return t0;
}

+ (uint)subWord:(uint)x {
    return (uint)(((Byte*)([AesFastEngine S].bytes))[x & 255]) | (((uint)(((Byte*)([AesFastEngine S].bytes))[(x >> 8) & 255])) << 8) | (((uint)(((Byte*)([AesFastEngine S].bytes))[(x >> 16) & 255])) << 16) | (((uint)(((Byte*)([AesFastEngine S].bytes))[(x >> 24) & 255])) << 24);
}

/**
 * Calculate the necessary round keys
 * The number of calculations depends on key size and block size
 * AES specified a fixed block size of 128 bits and key sizes 128/192/256 bits
 * This code is written assuming those are the only possible values
 */
- (NSMutableArray*)generateWorkingKey:(NSMutableData*)key withForEncryption:(BOOL)forEncryption {
    int keyLen = (int)(key.length);
    if (keyLen < 16 || keyLen > 32 || (keyLen & 7) != 0) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"Key length not 128/192/256 bits." userInfo:nil];
    }
    
    int KC = (uint)keyLen >> 2;
    [self setRounds:(KC + 6)];  // This is not always true for the generalized Rijndael that allows larger block sizes
    
    NSMutableArray *W = nil;
    @autoreleasepool {
        W = [[NSMutableArray alloc] initWithSize:(self.rounds + 1)]; // 4 words in a block
        for (int i = 0; i <= self.rounds; ++i) {
            NSMutableArray *tmp = [[NSMutableArray alloc] initWithSize:4];
            W[i] = tmp;
#if !__has_feature(objc_arc)
            if (tmp != nil) [tmp release]; tmp = nil;
#endif
        }
    
        switch (KC) {
            case 4: {
                uint t0 = [Pack LE_To_UInt32:key withOff:0]; ((NSMutableArray*)(W[0]))[0] = @(t0);
                uint t1 = [Pack LE_To_UInt32:key withOff:4]; ((NSMutableArray*)(W[0]))[1] = @(t1);
                uint t2 = [Pack LE_To_UInt32:key withOff:8]; ((NSMutableArray*)(W[0]))[2] = @(t2);
                uint t3 = [Pack LE_To_UInt32:key withOff:12]; ((NSMutableArray*)(W[0]))[3] = @(t3);
                
                for (int i = 1; i <= 10; ++i) {
                    uint u = [AesFastEngine subWord:[AesFastEngine shift:t3 withShift:8]] ^ ((Byte*)([AesFastEngine rcon].bytes))[i - 1];
                    t0 ^= u; ((NSMutableArray*)(W[i]))[0] = @(t0);
                    t1 ^= t0; ((NSMutableArray*)(W[i]))[1] = @(t1);
                    t2 ^= t1; ((NSMutableArray*)(W[i]))[2] = @(t2);
                    t3 ^= t2; ((NSMutableArray*)(W[i]))[3] = @(t3);
                }
                
                break;
            }
            case 6: {
                uint t0 = [Pack LE_To_UInt32:key withOff:0]; ((NSMutableArray*)(W[0]))[0] = @(t0);
                uint t1 = [Pack LE_To_UInt32:key withOff:4]; ((NSMutableArray*)(W[0]))[1] = @(t1);
                uint t2 = [Pack LE_To_UInt32:key withOff:8]; ((NSMutableArray*)(W[0]))[2] = @(t2);
                uint t3 = [Pack LE_To_UInt32:key withOff:12]; ((NSMutableArray*)(W[0]))[3] = @(t3);
                uint t4 = [Pack LE_To_UInt32:key withOff:16]; ((NSMutableArray*)(W[1]))[0] = @(t4);
                uint t5 = [Pack LE_To_UInt32:key withOff:20]; ((NSMutableArray*)(W[1]))[1] = @(t5);
                
                uint rcon = 1;
                uint u = [AesFastEngine subWord:[AesFastEngine shift:t5 withShift:8]] ^ rcon; rcon <<= 1;
                t0 ^= u; ((NSMutableArray*)(W[1]))[2] = @(t0);
                t1 ^= t0; ((NSMutableArray*)(W[1]))[3] = @(t1);
                t2 ^= t1; ((NSMutableArray*)(W[2]))[0] = @(t2);
                t3 ^= t2; ((NSMutableArray*)(W[2]))[1] = @(t3);
                t4 ^= t3; ((NSMutableArray*)(W[2]))[2] = @(t4);
                t5 ^= t4; ((NSMutableArray*)(W[2]))[3] = @(t5);
                
                for (int i = 3; i < 12; i += 3) {
                    u = [AesFastEngine subWord:[AesFastEngine shift:t5 withShift:8]] ^ rcon; rcon <<= 1;
                    t0 ^= u; ((NSMutableArray*)(W[i]))[0] = @(t0);
                    t1 ^= t0; ((NSMutableArray*)(W[i]))[1] = @(t1);
                    t2 ^= t1; ((NSMutableArray*)(W[i]))[2] = @(t2);
                    t3 ^= t2; ((NSMutableArray*)(W[i]))[3] = @(t3);
                    t4 ^= t3; ((NSMutableArray*)(W[i + 1]))[0] = @(t4);
                    t5 ^= t4; ((NSMutableArray*)(W[i + 1]))[1] = @(t5);
                    u = [AesFastEngine subWord:[AesFastEngine shift:t5 withShift:8]] ^ rcon; rcon <<= 1;
                    t0 ^= u; ((NSMutableArray*)(W[i + 1]))[2] = @(t0);
                    t1 ^= t0; ((NSMutableArray*)(W[i + 1]))[3] = @(t1);
                    t2 ^= t1; ((NSMutableArray*)(W[i + 2]))[0] = @(t2);
                    t3 ^= t2; ((NSMutableArray*)(W[i + 2]))[1] = @(t3);
                    t4 ^= t3; ((NSMutableArray*)(W[i + 2]))[2] = @(t4);
                    t5 ^= t4; ((NSMutableArray*)(W[i + 2]))[3] = @(t5);
                }
                
                u = [AesFastEngine subWord:[AesFastEngine shift:t5 withShift:8]] ^ rcon;
                t0 ^= u; ((NSMutableArray*)(W[12]))[0] = @(t0);
                t1 ^= t0; ((NSMutableArray*)(W[12]))[1] = @(t1);
                t2 ^= t1; ((NSMutableArray*)(W[12]))[2] = @(t2);
                t3 ^= t2; ((NSMutableArray*)(W[12]))[3] = @(t3);
                
                break;
            }
            case 8: {
                uint t0 = [Pack LE_To_UInt32:key withOff:0]; ((NSMutableArray*)(W[0]))[0] = @(t0);
                uint t1 = [Pack LE_To_UInt32:key withOff:4]; ((NSMutableArray*)(W[0]))[1] = @(t1);
                uint t2 = [Pack LE_To_UInt32:key withOff:8]; ((NSMutableArray*)(W[0]))[2] = @(t2);
                uint t3 = [Pack LE_To_UInt32:key withOff:12]; ((NSMutableArray*)(W[0]))[3] = @(t3);
                uint t4 = [Pack LE_To_UInt32:key withOff:16]; ((NSMutableArray*)(W[1]))[0] = @(t4);
                uint t5 = [Pack LE_To_UInt32:key withOff:20]; ((NSMutableArray*)(W[1]))[1] = @(t5);
                uint t6 = [Pack LE_To_UInt32:key withOff:24]; ((NSMutableArray*)(W[1]))[2] = @(t6);
                uint t7 = [Pack LE_To_UInt32:key withOff:28]; ((NSMutableArray*)(W[1]))[3] = @(t7);
                
                uint u, rcon = 1;
                
                for (int i = 2; i < 14; i += 2) {
                    u = [AesFastEngine subWord:[AesFastEngine shift:t7 withShift:8]] ^ rcon; rcon <<= 1;
                    t0 ^= u; ((NSMutableArray*)(W[i]))[0] = @(t0);
                    t1 ^= t0; ((NSMutableArray*)(W[i]))[1] = @(t1);
                    t2 ^= t1; ((NSMutableArray*)(W[i]))[2] = @(t2);
                    t3 ^= t2; ((NSMutableArray*)(W[i]))[3] = @(t3);
                    u = [AesFastEngine subWord:t3];
                    t4 ^= u; ((NSMutableArray*)(W[i + 1]))[0] = @(t4);
                    t5 ^= t4; ((NSMutableArray*)(W[i + 1]))[1] = @(t5);
                    t6 ^= t5; ((NSMutableArray*)(W[i + 1]))[2] = @(t6);
                    t7 ^= t6; ((NSMutableArray*)(W[i + 1]))[3] = @(t7);
                }
                
                u = [AesFastEngine subWord:[AesFastEngine shift:t7 withShift:8]] ^ rcon;
                t0 ^= u; ((NSMutableArray*)(W[14]))[0] = @(t0);
                t1 ^= t0; ((NSMutableArray*)(W[14]))[1] = @(t1);
                t2 ^= t1; ((NSMutableArray*)(W[14]))[2] = @(t2);
                t3 ^= t2; ((NSMutableArray*)(W[14]))[3] = @(t3);
                
                break;
            }
            default: {
                @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"Should never get here" userInfo:nil];
            }
        }
        if (!forEncryption) {
            for (int j = 1; j < self.rounds; j++) {
                NSMutableArray *w = (NSMutableArray*)(W[j]);
                for (int i = 0; i < 4; i++) {
                    w[i] = @([AesFastEngine inv_Mcol:[w[i] unsignedIntValue]]);
                }
            }
        }
    }
    return (W ? [W autorelease] : nil);
}

static const int BLOCK_SIZE = 16;

/**
 * default constructor - 128 bit block size.
 */
- (id)init {
    if (self = [super init]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setWorkingKey:nil];
    [super dealloc];
#endif
}

/**
 * initialise an AES cipher.
 *
 * @param forEncryption whether or not we are for encryption.
 * @param parameters the parameters required to set up the cipher.
 * @exception ArgumentException if the parameters argument is
 * inappropriate.
 */
- (void)init:(BOOL)forEncryption withParameters:(CipherParameters*)parameters {
    KeyParameter *keyParameter = nil;
    if (parameters != nil && [parameters isKindOfClass:[KeyParameter class]]) {
        keyParameter = (KeyParameter*)parameters;
    }
    
    if (keyParameter == nil) {
        @throw [NSException exceptionWithName:@"Argument" reason:[NSString stringWithFormat:@"invalid parameter passed to AES init - %@", (parameters != nil ? [parameters className] : @"nil")] userInfo:nil];
    }
    
    [self setWorkingKey:[self generateWorkingKey:[keyParameter getKey] withForEncryption:forEncryption]];
    
    [self setForEncryption:forEncryption];
}

- (NSString*)algorithmName {
    return @"AES";
}

- (BOOL)isPartialBlockOkay {
    return NO;
}

- (int)getBlockSize {
    return BLOCK_SIZE;
}

- (int)processBlock:(NSMutableData*)inBuf withInOff:(int)inOff withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff {
    if ([self workingKey] == nil) {
        @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"AES engine not initialised" userInfo:nil];
    }
    
    [Check dataLength:inBuf withOff:inOff withLen:16 withMsg:@"input buffer too short"];
    [Check outputLength:outBuf withOff:outOff withLen:16 withMsg:@"output buffer too short"];
    
    [self unPackBlock:inBuf withOff:inOff];
    
    if (self.forEncryption) {
        [self encryptBlock:[self workingKey]];
    } else {
        [self decryptBlock:[self workingKey]];
    }
    
    [self packBlock:outBuf withOff:outOff];
    
    return BLOCK_SIZE;
}

- (void)reset {
}

- (void)unPackBlock:(NSMutableData*)bytes withOff:(int)off {
    [self setC0:[Pack LE_To_UInt32:bytes withOff:off]];
    [self setC1:[Pack LE_To_UInt32:bytes withOff:(off + 4)]];
    [self setC2:[Pack LE_To_UInt32:bytes withOff:(off + 8)]];
    [self setC3:[Pack LE_To_UInt32:bytes withOff:(off + 12)]];
}

- (void)packBlock:(NSMutableData*)bytes withOff:(int)off {
    [Pack UInt32_To_LE:self.c0 withBs:bytes withOff:off];
    [Pack UInt32_To_LE:self.c1 withBs:bytes withOff:(off + 4)];
    [Pack UInt32_To_LE:self.c2 withBs:bytes withOff:(off + 8)];
    [Pack UInt32_To_LE:self.c3 withBs:bytes withOff:(off + 12)];
}

- (void)encryptBlock:(NSMutableArray*)KW {
    @autoreleasepool {
        NSMutableArray *kw = (NSMutableArray*)(KW[0]);
        uint t0 = self.c0 ^ [kw[0] unsignedIntValue];
        uint t1 = self.c1 ^ [kw[1] unsignedIntValue];
        uint t2 = self.c2 ^ [kw[2] unsignedIntValue];
        
        uint r0, r1, r2, r3 = self.c3 ^ [kw[3] unsignedIntValue];
        int r = 1;
        
        while (r < self.rounds - 1) {
            kw = (NSMutableArray*)(KW[r++]);
            r0 = [([AesFastEngine T0][t0 & 255]) unsignedIntValue] ^ [([AesFastEngine T1][(t1 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine T2][(t2 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine T3][r3 >> 24]) unsignedIntValue] ^ [kw[0] unsignedIntValue];
            r1 = [([AesFastEngine T0][t1 & 255]) unsignedIntValue] ^ [([AesFastEngine T1][(t2 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine T2][(r3 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine T3][t0 >> 24]) unsignedIntValue] ^ [kw[1] unsignedIntValue];
            r2 = [([AesFastEngine T0][t2 & 255]) unsignedIntValue] ^ [([AesFastEngine T1][(r3 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine T2][(t0 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine T3][t1 >> 24]) unsignedIntValue] ^ [kw[2] unsignedIntValue];
            r3 = [([AesFastEngine T0][r3 & 255]) unsignedIntValue] ^ [([AesFastEngine T1][(t0 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine T2][(t1 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine T3][t2 >> 24]) unsignedIntValue] ^ [kw[3] unsignedIntValue];
            kw = (NSMutableArray*)(KW[r++]);
            t0 = [([AesFastEngine T0][r0 & 255]) unsignedIntValue] ^ [([AesFastEngine T1][(r1 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine T2][(r2 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine T3][r3 >> 24]) unsignedIntValue] ^ [kw[0] unsignedIntValue];
            t1 = [([AesFastEngine T0][r1 & 255]) unsignedIntValue] ^ [([AesFastEngine T1][(r2 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine T2][(r3 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine T3][r0 >> 24]) unsignedIntValue] ^ [kw[1] unsignedIntValue];
            t2 = [([AesFastEngine T0][r2 & 255]) unsignedIntValue] ^ [([AesFastEngine T1][(r3 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine T2][(r0 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine T3][r1 >> 24]) unsignedIntValue] ^ [kw[2] unsignedIntValue];
            r3 = [([AesFastEngine T0][r3 & 255]) unsignedIntValue] ^ [([AesFastEngine T1][(r0 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine T2][(r1 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine T3][r2 >> 24]) unsignedIntValue] ^ [kw[3] unsignedIntValue];
        }
        
        kw = (NSMutableArray*)(KW[r++]);
        r0 = [([AesFastEngine T0][t0 & 255]) unsignedIntValue] ^ [([AesFastEngine T1][(t1 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine T2][(t2 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine T3][r3 >> 24]) unsignedIntValue] ^ [kw[0] unsignedIntValue];
        r1 = [([AesFastEngine T0][t1 & 255]) unsignedIntValue] ^ [([AesFastEngine T1][(t2 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine T2][(r3 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine T3][t0 >> 24]) unsignedIntValue] ^ [kw[1] unsignedIntValue];
        r2 = [([AesFastEngine T0][t2 & 255]) unsignedIntValue] ^ [([AesFastEngine T1][(r3 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine T2][(t0 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine T3][t1 >> 24]) unsignedIntValue] ^ [kw[2] unsignedIntValue];
        r3 = [([AesFastEngine T0][r3 & 255]) unsignedIntValue] ^ [([AesFastEngine T1][(t0 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine T2][(t1 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine T3][t2 >> 24]) unsignedIntValue] ^ [kw[3] unsignedIntValue];
        
        // the final round's table is a simple function of S so we don't use a whole other four tables for it
        
        kw = (NSMutableArray*)(KW[r]);
        
        [self setC0:((uint)(((Byte*)([AesFastEngine S].bytes))[r0 & 255]) ^ (((uint)(((Byte*)([AesFastEngine S].bytes))[(r1 >> 8) & 255])) << 8) ^ (((uint)(((Byte*)([AesFastEngine S].bytes))[(r2 >> 16) & 255])) << 16) ^ (((uint)(((Byte*)([AesFastEngine S].bytes))[r3 >> 24])) << 24) ^ [kw[0] unsignedIntValue])];
        [self setC1:((uint)(((Byte*)([AesFastEngine S].bytes))[r1 & 255]) ^ (((uint)(((Byte*)([AesFastEngine S].bytes))[(r2 >> 8) & 255])) << 8) ^ (((uint)(((Byte*)([AesFastEngine S].bytes))[(r3 >> 16) & 255])) << 16) ^ (((uint)(((Byte*)([AesFastEngine S].bytes))[r0 >> 24])) << 24) ^ [kw[1] unsignedIntValue])];
        [self setC2:((uint)(((Byte*)([AesFastEngine S].bytes))[r2 & 255]) ^ (((uint)(((Byte*)([AesFastEngine S].bytes))[(r3 >> 8) & 255])) << 8) ^ (((uint)(((Byte*)([AesFastEngine S].bytes))[(r0 >> 16) & 255])) << 16) ^ (((uint)(((Byte*)([AesFastEngine S].bytes))[r1 >> 24])) << 24) ^ [kw[2] unsignedIntValue])];
        [self setC3:((uint)(((Byte*)([AesFastEngine S].bytes))[r3 & 255]) ^ (((uint)(((Byte*)([AesFastEngine S].bytes))[(r0 >> 8) & 255])) << 8) ^ (((uint)(((Byte*)([AesFastEngine S].bytes))[(r1 >> 16) & 255])) << 16) ^ (((uint)(((Byte*)([AesFastEngine S].bytes))[r2 >> 24])) << 24) ^ [kw[3] unsignedIntValue])];
    }
}

- (void)decryptBlock:(NSMutableArray*)KW {
    @autoreleasepool {
        NSMutableArray *kw = (NSMutableArray*)(KW[self.rounds]);
        uint t0 = self.c0 ^ [kw[0] unsignedIntValue];
        uint t1 = self.c1 ^ [kw[1] unsignedIntValue];
        uint t2 = self.c2 ^ [kw[2] unsignedIntValue];
        
        uint r0, r1, r2, r3 = self.c3 ^ [kw[3] unsignedIntValue];
        int r = self.rounds - 1;
        
        while (r > 1) {
            kw = (NSMutableArray*)(KW[r--]);
            r0 = [([AesFastEngine Tinv0][t0 & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv1][(r3 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv2][(t2 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv3][t1 >> 24]) unsignedIntValue] ^ [kw[0] unsignedIntValue];
            r1 = [([AesFastEngine Tinv0][t1 & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv1][(t0 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv2][(r3 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv3][t2 >> 24]) unsignedIntValue] ^ [kw[1] unsignedIntValue];
            r2 = [([AesFastEngine Tinv0][t2 & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv1][(t1 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv2][(t0 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv3][r3 >> 24]) unsignedIntValue] ^ [kw[2] unsignedIntValue];
            r3 = [([AesFastEngine Tinv0][r3 & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv1][(t2 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv2][(t1 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv3][t0 >> 24]) unsignedIntValue] ^ [kw[3] unsignedIntValue];
            kw = (NSMutableArray*)(KW[r--]);
            t0 = [([AesFastEngine Tinv0][r0 & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv1][(r3 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv2][(r2 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv3][r1 >> 24]) unsignedIntValue] ^ [kw[0] unsignedIntValue];
            t1 = [([AesFastEngine Tinv0][r1 & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv1][(r0 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv2][(r3 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv3][r2 >> 24]) unsignedIntValue] ^ [kw[1] unsignedIntValue];
            t2 = [([AesFastEngine Tinv0][r2 & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv1][(r1 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv2][(r0 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv3][r3 >> 24]) unsignedIntValue] ^ [kw[2] unsignedIntValue];
            r3 = [([AesFastEngine Tinv0][r3 & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv1][(r2 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv2][(r1 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv3][r0 >> 24]) unsignedIntValue] ^ [kw[3] unsignedIntValue];
        }
        
        kw = (NSMutableArray*)(KW[1]);
        r0 = [([AesFastEngine Tinv0][t0 & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv1][(r3 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv2][(t2 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv3][t1 >> 24]) unsignedIntValue] ^ [kw[0] unsignedIntValue];
        r1 = [([AesFastEngine Tinv0][t1 & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv1][(t0 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv2][(r3 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv3][t2 >> 24]) unsignedIntValue] ^ [kw[1] unsignedIntValue];
        r2 = [([AesFastEngine Tinv0][t2 & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv1][(t1 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv2][(t0 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv3][r3 >> 24]) unsignedIntValue] ^ [kw[2] unsignedIntValue];
        r3 = [([AesFastEngine Tinv0][r3 & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv1][(t2 >> 8) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv2][(t1 >> 16) & 255]) unsignedIntValue] ^ [([AesFastEngine Tinv3][t0 >> 24]) unsignedIntValue] ^ [kw[3] unsignedIntValue];
        
        // the final round's table is a simple function of Si so we don't use a whole other four tables for it
        
        kw = (NSMutableArray*)(KW[0]);
        [self setC0:((uint)(((Byte*)([AesFastEngine Si].bytes))[r0 & 255]) ^ (((uint)(((Byte*)([AesFastEngine Si].bytes))[(r3 >> 8) & 255])) << 8) ^ (((uint)(((Byte*)([AesFastEngine Si].bytes))[(r2 >> 16) & 255])) << 16) ^ (((uint)(((Byte*)([AesFastEngine Si].bytes))[r1 >> 24])) << 24) ^ [kw[0] unsignedIntValue])];
        [self setC1:((uint)(((Byte*)([AesFastEngine Si].bytes))[r1 & 255]) ^ (((uint)(((Byte*)([AesFastEngine Si].bytes))[(r0 >> 8) & 255])) << 8) ^ (((uint)(((Byte*)([AesFastEngine Si].bytes))[(r3 >> 16) & 255])) << 16) ^ (((uint)(((Byte*)([AesFastEngine Si].bytes))[r2 >> 24])) << 24) ^ [kw[1] unsignedIntValue])];
        [self setC2:((uint)(((Byte*)([AesFastEngine Si].bytes))[r2 & 255]) ^ (((uint)(((Byte*)([AesFastEngine Si].bytes))[(r1 >> 8) & 255])) << 8) ^ (((uint)(((Byte*)([AesFastEngine Si].bytes))[(r0 >> 16) & 255])) << 16) ^ (((uint)(((Byte*)([AesFastEngine Si].bytes))[r3 >> 24])) << 24) ^ [kw[2] unsignedIntValue])];
        [self setC3:((uint)(((Byte*)([AesFastEngine Si].bytes))[r3 & 255]) ^ (((uint)(((Byte*)([AesFastEngine Si].bytes))[(r2 >> 8) & 255])) << 8) ^ (((uint)(((Byte*)([AesFastEngine Si].bytes))[(r1 >> 16) & 255])) << 16) ^ (((uint)(((Byte*)([AesFastEngine Si].bytes))[r0 >> 24])) << 24) ^ [kw[3] unsignedIntValue])];
    }
    
}

@end
