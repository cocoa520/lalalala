//
//  BigInteger.m
//  
//
//  Created by Pallas on 4/30/16.
//
//

#import "BigInteger.h"
#import "CategoryExtend.h"

int64_t const IMASK = 0xFFFFFFFFLL;
uint64_t const UIMASK = 0xFFFFFFFFULL;
int const chunk2 = 1;
int const chunk8 = 1;
int const chunk10 = 19;
int const chunk16 = 16;

int const BitsPerByte = 8;
int const BitsPerInt = 32;
int const BytesPerInt = 4;

@interface BigInteger ()

@property (nonatomic, readwrite, retain) NSMutableArray *magnitude;
@property (nonatomic, readwrite, assign) int sign;
@property (nonatomic, readwrite, assign) int nBits;
@property (nonatomic, readwrite, assign) int nBitLength;
@property (nonatomic, readwrite, assign) int mQuote;

@end

@implementation BigInteger
@synthesize magnitude = _magnitude;
@synthesize sign = _sign;
@synthesize nBits = _nBits;
@synthesize nBitLength = _nBitLength;
@synthesize mQuote = _mQuote;

// int[][]
+ (NSArray*)primeLists {
    static NSArray *_primeLists = nil;
    @synchronized(self) {
        if (_primeLists == nil) {
            @autoreleasepool {
                _primeLists = [[NSArray alloc] initWithObjects:
                               [NSArray arrayWithObjects:@((int)3), @((int)5), @((int)7), @((int)11), @((int)13), @((int)17), @((int)19), @((int)23), nil],
                               [NSArray arrayWithObjects:@((int)29), @((int)31), @((int)37), @((int)41), @((int)43), nil],
                               [NSArray arrayWithObjects:@((int)47), @((int)53), @((int)59), @((int)61), @((int)67), nil],
                               [NSArray arrayWithObjects:@((int)71), @((int)73), @((int)79), @((int)83), nil],
                               [NSArray arrayWithObjects:@((int)89), @((int)97), @((int)101), @((int)103), nil],
                               
                               [NSArray arrayWithObjects:@((int)107), @((int)109), @((int)113), @((int)127), nil],
                               [NSArray arrayWithObjects:@((int)131), @((int)137), @((int)139), @((int)149), nil],
                               [NSArray arrayWithObjects:@((int)151), @((int)157), @((int)163), @((int)167), nil],
                               [NSArray arrayWithObjects:@((int)173), @((int)179), @((int)181), @((int)191), nil],
                               [NSArray arrayWithObjects:@((int)193), @((int)197), @((int)199), @((int)211), nil],
                               
                               [NSArray arrayWithObjects:@((int)223), @((int)227), @((int)229), nil],
                               [NSArray arrayWithObjects:@((int)233), @((int)239), @((int)241), nil],
                               [NSArray arrayWithObjects:@((int)251), @((int)257), @((int)263), nil],
                               [NSArray arrayWithObjects:@((int)269), @((int)271), @((int)277), nil],
                               [NSArray arrayWithObjects:@((int)281), @((int)283), @((int)293), nil],
                               
                               [NSArray arrayWithObjects:@((int)307), @((int)311), @((int)313), nil],
                               [NSArray arrayWithObjects:@((int)317), @((int)331), @((int)337), nil],
                               [NSArray arrayWithObjects:@((int)347), @((int)349), @((int)353), nil],
                               [NSArray arrayWithObjects:@((int)359), @((int)367), @((int)373), nil],
                               [NSArray arrayWithObjects:@((int)379), @((int)383), @((int)389), nil],
                               
                               [NSArray arrayWithObjects:@((int)397), @((int)401), @((int)409), nil],
                               [NSArray arrayWithObjects:@((int)419), @((int)421), @((int)431), nil],
                               [NSArray arrayWithObjects:@((int)433), @((int)439), @((int)443), nil],
                               [NSArray arrayWithObjects:@((int)449), @((int)457), @((int)461), nil],
                               [NSArray arrayWithObjects:@((int)463), @((int)467), @((int)479), nil],
                               
                               [NSArray arrayWithObjects:@((int)487), @((int)491), @((int)499), nil],
                               [NSArray arrayWithObjects:@((int)503), @((int)509), @((int)521), nil],
                               [NSArray arrayWithObjects:@((int)523), @((int)541), @((int)547), nil],
                               [NSArray arrayWithObjects:@((int)557), @((int)563), @((int)569), nil],
                               [NSArray arrayWithObjects:@((int)571), @((int)577), @((int)587), nil],
                               
                               [NSArray arrayWithObjects:@((int)593), @((int)599), @((int)601), nil],
                               [NSArray arrayWithObjects:@((int)607), @((int)613), @((int)617), nil],
                               [NSArray arrayWithObjects:@((int)619), @((int)631), @((int)641), nil],
                               [NSArray arrayWithObjects:@((int)643), @((int)647), @((int)653), nil],
                               [NSArray arrayWithObjects:@((int)659), @((int)661), @((int)673), nil],
                               
                               [NSArray arrayWithObjects:@((int)677), @((int)683), @((int)691), nil],
                               [NSArray arrayWithObjects:@((int)701), @((int)709), @((int)719), nil],
                               [NSArray arrayWithObjects:@((int)727), @((int)733), @((int)739), nil],
                               [NSArray arrayWithObjects:@((int)743), @((int)751), @((int)757), nil],
                               [NSArray arrayWithObjects:@((int)761), @((int)769), @((int)773), nil],
                               
                               [NSArray arrayWithObjects:@((int)787), @((int)797), @((int)809), nil],
                               [NSArray arrayWithObjects:@((int)811), @((int)821), @((int)823), nil],
                               [NSArray arrayWithObjects:@((int)827), @((int)829), @((int)839), nil],
                               [NSArray arrayWithObjects:@((int)853), @((int)857), @((int)859), nil],
                               [NSArray arrayWithObjects:@((int)863), @((int)877), @((int)881), nil],
                               
                               [NSArray arrayWithObjects:@((int)883), @((int)887), @((int)907), nil],
                               [NSArray arrayWithObjects:@((int)911), @((int)919), @((int)929), nil],
                               [NSArray arrayWithObjects:@((int)937), @((int)941), @((int)947), nil],
                               [NSArray arrayWithObjects:@((int)953), @((int)967), @((int)971), nil],
                               [NSArray arrayWithObjects:@((int)977), @((int)983), @((int)991), nil],
                               
                               [NSArray arrayWithObjects:@((int)997), @((int)1009), @((int)1013), nil],
                               [NSArray arrayWithObjects:@((int)1019), @((int)1021), @((int)1031), nil],
                               [NSArray arrayWithObjects:@((int)1033), @((int)1039), @((int)1049), nil],
                               [NSArray arrayWithObjects:@((int)1051), @((int)1061), @((int)1063), nil],
                               [NSArray arrayWithObjects:@((int)1069), @((int)1087), @((int)1091), nil],
                               
                               [NSArray arrayWithObjects:@((int)1093), @((int)1097), @((int)1103), nil],
                               [NSArray arrayWithObjects:@((int)1109), @((int)1117), @((int)1123), nil],
                               [NSArray arrayWithObjects:@((int)1129), @((int)1151), @((int)1153), nil],
                               [NSArray arrayWithObjects:@((int)1163), @((int)1171), @((int)1181), nil],
                               [NSArray arrayWithObjects:@((int)1187), @((int)1193), @((int)1201), nil],
                               
                               [NSArray arrayWithObjects:@((int)1213), @((int)1217), @((int)1223), nil],
                               [NSArray arrayWithObjects:@((int)1229), @((int)1231), @((int)1237), nil],
                               [NSArray arrayWithObjects:@((int)1249), @((int)1259), @((int)1277), nil],
                               [NSArray arrayWithObjects:@((int)1279), @((int)1283), @((int)1289), nil],
                               
                               nil];
            }
        }
    }
    return _primeLists;
}

// int[]
+ (NSMutableArray*)primeProducts {
    static NSMutableArray *_primeProducts = nil;
    @synchronized(self) {
        if (_primeProducts == nil) {
            _primeProducts = [[NSMutableArray alloc] init];
            @autoreleasepool {
                for (int i = 0; i < [[BigInteger primeLists] count]; ++i) {
                    NSArray *primeList = [BigInteger primeLists][i];
                    int product = [primeList[0] intValue];
                    for (int j = 1; j < primeList.count; ++j) {
                        product *= [primeList[j] intValue];
                    }
                    _primeProducts[i] = @(product);
                }
            }
        }
    }
    return _primeProducts;
}

// int[]
+ (NSMutableArray*)ZeroMagnitude {
    static NSMutableArray *_zeroMagnitude = nil;
    @synchronized(self) {
        if (_zeroMagnitude == nil) {
            _zeroMagnitude = [[NSMutableArray alloc] init];
        }
    }
    return _zeroMagnitude;
}

+ (NSMutableData*)ZeroEncoding {
    static NSMutableData *_zeroEncoding = nil;
    @synchronized(self) {
        if (_zeroEncoding == nil) {
            _zeroEncoding = [[NSMutableData alloc] init];
        }
    }
    return _zeroEncoding;
}

// BigInteger
+ (NSMutableArray*)SMALL_CONSTANTS {
    static NSMutableArray *_small_constants = nil;
    @synchronized(self) {
        if (_small_constants == nil) {
            int length = 17;
            @autoreleasepool {
                _small_constants = [[NSMutableArray alloc] initWithSize:length];
                _small_constants[0] = [BigInteger Zero];
                for (uint i = 1; i < 17; i++) {
                    _small_constants[i] = [BigInteger createUValueOf:i];
                }
            }
        }
    }
    return _small_constants;
}

+ (BigInteger*)Zero {
    static BigInteger *_zero = nil;
    @synchronized(self) {
        if (_zero == nil) {
            _zero = [[BigInteger alloc] initWithSignum:0 withMag:[BigInteger ZeroMagnitude] withCheckMag:NO];
            [_zero setNBits:-1];
            [_zero setNBitLength:-1];
        }
    }
    return _zero;
}

+ (BigInteger*)One {
    return (BigInteger*)([BigInteger SMALL_CONSTANTS][1]);
}

+ (BigInteger*)Two {
    return (BigInteger*)([BigInteger SMALL_CONSTANTS][2]);
}

+ (BigInteger*)Three {
    return (BigInteger*)([BigInteger SMALL_CONSTANTS][3]);
}

+ (BigInteger*)Four {
    return (BigInteger*)([BigInteger SMALL_CONSTANTS][4]);
}

+ (BigInteger*)Five {
    return (BigInteger*)([BigInteger SMALL_CONSTANTS][5]);
}

+ (BigInteger*)Six {
    return (BigInteger*)([BigInteger SMALL_CONSTANTS][6]);
}

+ (BigInteger*)Seven {
    return (BigInteger*)([BigInteger SMALL_CONSTANTS][7]);
}

+ (BigInteger*)Eight {
    return (BigInteger*)([BigInteger SMALL_CONSTANTS][8]);
}

+ (BigInteger*)Ten {
    return (BigInteger*)([BigInteger SMALL_CONSTANTS][10]);
}

+ (NSData*)BitLengthTable {
    static NSMutableData *_bitLengthTable = nil;
    @synchronized(self) {
        if (_bitLengthTable == nil) {
            _bitLengthTable = [[NSMutableData alloc] initWithSize:256];
            ((Byte*)(_bitLengthTable.bytes))[0] = 0;
            ((Byte*)(_bitLengthTable.bytes))[1] = 1;
            for (int i = 2; i < 4; i++) {
                ((Byte*)(_bitLengthTable.bytes))[i] = 2;
            }
            for (int i = 4; i < 8; i++) {
                ((Byte*)(_bitLengthTable.bytes))[i] = 3;
            }
            for (int i = 8; i < 16; i++) {
                ((Byte*)(_bitLengthTable.bytes))[i] = 4;
            }
            for (int i = 16; i < 32; i++) {
                ((Byte*)(_bitLengthTable.bytes))[i] = 5;
            }
            for (int i = 32; i < 64; i++) {
                ((Byte*)(_bitLengthTable.bytes))[i] = 6;
            }
            for (int i = 64; i < 128; i++) {
                ((Byte*)(_bitLengthTable.bytes))[i] = 7;
            }
            for (int i = 128; i < 256; i++) {
                ((Byte*)(_bitLengthTable.bytes))[i] = 8;
            }
        }
    }
    return _bitLengthTable;
}

+ (BigInteger*)radix2 {
    return [BigInteger valueOf:2];
}

+ (BigInteger*)radix2E {
    return [[BigInteger radix2] powWithExp:chunk2];
}

+ (BigInteger*)radix8 {
    return [BigInteger valueOf:8];
}

+ (BigInteger*)radix8E {
    return [[BigInteger radix8] powWithExp:chunk8];
}

+ (BigInteger*)radix10 {
    return [BigInteger valueOf:10];
}

+ (BigInteger*)radix10E {
    return [[BigInteger radix10] powWithExp:chunk10];
}

+ (BigInteger*)radix16 {
    return [BigInteger valueOf:16];
}

+ (BigInteger*)radix16E {
    return [[BigInteger radix16] powWithExp:chunk16];
}

+ (NSArray*)ExpWindowThresholds {
    static NSArray *_expWindowThresholds = nil;
    @synchronized(self) {
        if (_expWindowThresholds == nil) {
            _expWindowThresholds = [[NSArray alloc] initWithObjects:@((int)7), @((int)25), @((int)81), @((int)241), @((int)673), @((int)1793), @((int)4609), @((int)INT_MAX), nil];
        }
    }
    return _expWindowThresholds;
}

+ (int)getByteLength:(int)nBits {
    return (nBits + BitsPerByte - 1) / BitsPerByte;
}

+ (BigInteger*)arbitrary:(int)sizeInBits {
    return [[[BigInteger alloc] initWithSizeInBits:sizeInBits] autorelease];
}

- (id)initWithSignum:(int)signum withMag:(NSMutableArray*)mag withCheckMag:(BOOL)checkMag {
    if (self = [super init]) {
        @autoreleasepool {
            self.nBits = -1;
            self.nBitLength = -1;
            if (checkMag) {
                int i = 0;
                while (i < mag.count && [mag[i] intValue] == 0) {
                    ++i;
                }
                
                if (i == mag.count) {
                    self.sign = 0;
                    NSMutableArray *tmpArray = [[BigInteger ZeroMagnitude] clone];
                    [self setMagnitude:tmpArray];
#if !__has_feature(objc_arc)
                    if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
                } else {
                    self.sign = signum;
                    if (i == 0) {
                        NSMutableArray *tmpArray = [mag clone];
                        [self setMagnitude:tmpArray];
#if !__has_feature(objc_arc)
                        if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
                    } else {
                        // strip leading 0 words
                        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithSize:((int)mag.count - i)];
                        [self setMagnitude:tmpArray];
#if !__has_feature(objc_arc)
                        if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
                        [self.magnitude copyFromIndex:0 withSource:mag withSourceIndex:i withLength:self.magnitude.fixedSize];
                    }
                }
            } else {
                self.sign = signum;
                 NSMutableArray *tmpArray = [mag clone];
                [self setMagnitude:tmpArray];
#if !__has_feature(objc_arc)
                if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
            }
        }
        return self;
    } else {
        return nil;
    }
}

- (id)initWithValue:(NSString*)value {
    if (self = [self initWithValue:value withRadix:10]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithValue:(NSString*)value withRadix:(int)radix {
    if (self = [super init]) {
        @autoreleasepool {
            if (value.length == 0) {
                @throw [NSException exceptionWithName:@"Format" reason:@"Zero length BigInteger" userInfo:nil];
            }
            
            self.nBits = -1;
            self.nBitLength = -1;
            
            int style;
            int chunk;
            BigInteger *r;
            BigInteger *rE;
            
            switch (radix) {
                case 2: {
                    style = 7; // 数字类型
                    chunk = chunk2;
                    r = [BigInteger radix2];
                    rE = [BigInteger radix2E];
                    break;
                }
                case 8: {
                    style = 7; // 数字类型
                    chunk = chunk8;
                    r = [BigInteger radix8];
                    rE = [BigInteger radix8E];
                    break;
                }
                case 10: {
                    style = 7; // 数字类型
                    chunk = chunk10;
                    r = [BigInteger radix10];
                    rE = [BigInteger radix10E];
                    break;
                }
                case 16: {
                    style = 512; // 16进制类型
                    chunk = chunk16;
                    r = [BigInteger radix16];
                    rE = [BigInteger radix16E];
                    break;
                }
                default: {
                    @throw [NSException exceptionWithName:@"Format" reason:@"Only bases 2, 8, 10, or 16 allowed" userInfo:nil];
                    break;
                }
            }
            
            int index = 0;
            self.sign = 1;
            
            if ([[value substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"-"]) {
                if (value.length == 1) {
                    @throw [NSException exceptionWithName:@"Format" reason:@"Zero length BigInteger" userInfo:nil];
                }
                self.sign = -1;
                index = 1;
            }
            
            // strip leading zeros from the string str
            while (index < value.length && [self intParse:[value substringWithRange:NSMakeRange(index, 1)] withStyle:style] == 0) {
                index++;
            }
            
            if (index >= value.length) {
                // zero value - we're done
                self.sign = 0;
                NSMutableArray *tmpArray = [BigInteger ZeroMagnitude];
                [self setMagnitude:tmpArray];
#if !__has_feature(objc_arc)
                if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
                return self;
            }
            
            //////
            // could we work out the max number of ints required to store
            // str.Length digits in the given base, then allocate that
            // storage in one hit?, then Generate the magnitude in one hit too?
            //////
            BigInteger *b = [BigInteger Zero];
            
            int next = index + chunk;
            if (next <= value.length) {
                do {
                    NSString *s = [value substringWithRange:NSMakeRange(index, chunk)];
                    uint64_t i = 0;
                    int64_t ti = 0;
                    NSScanner* scanner = [NSScanner scannerWithString:s];
                    if (style == 512) {
                        [scanner scanHexLongLong:&i];
                    } else {
                        [scanner scanLongLong:&ti];
                        i = ti;
                    }
                    BigInteger *bi = [BigInteger createUValueOf:i];
                    
                    switch (radix) {
                        case 2: {
                            // TODO Need this because we are parsing in radix 10 above
                            if (i >= 2) {
                                @throw [NSException exceptionWithName:@"Format" reason:[NSString stringWithFormat:@"Bad character in radix 2 string: %@", s] userInfo:nil];
                            }
                            
                            // TODO Parse 64 bits at a time
                            b = [b shiftLeftWithN:1];
                            break;
                        }
                        case 8: {
                            // TODO Need this because we are parsing in radix 10 above
                            if (i >= 8) {
                                @throw [NSException exceptionWithName:@"Format" reason:[NSString stringWithFormat:@"Bad character in radix 8 string: %@", s] userInfo:nil];
                            }
                            
                            // TODO Parse 63 bits at a time
                            b = [b shiftLeftWithN:3];
                            break;
                        }
                        case 16: {
                            b = [b shiftLeftWithN:64];
                            break;
                        }
                        default: {
                            b = [b multiplyWithVal:rE];
                            break;
                        }
                    }
                    
                    b = [b addWithValue:bi];
                    
                    index = next;
                    next += chunk;
                }
                while (next <= value.length);
            }
            
            if (index < value.length) {
                NSString *s = [value substringFromIndex:index];
                uint64_t i = 0;
                int64_t ti = 0;
                NSScanner* scanner = [NSScanner scannerWithString:s];
                if (style == 512) {
                    [scanner scanHexLongLong:&i];
                } else {
                    [scanner scanLongLong:&ti];
                    i = ti;
                }
                BigInteger *bi = [BigInteger createUValueOf:i];
                if (b.sign > 0) {
                    if (radix == 2) {
                        // NB: Can't reach here since we are parsing one char at a time
                        
                        // TODO Parse all bits at once
                        // b = [b shiftLeftWithN:(int)(s.length)];
                    } else if (radix == 8) {
                        // NB: Can't reach here since we are parsing one char at a time
                        
                        // TODO Parse all bits at once
                        // b = [b shiftLeftWithN:((int)(s.length) * 3)];
                    } else if (radix == 16) {
                        b = [b shiftLeftWithN:((int)(s.length) << 2)];
                    } else {
                        b = [b multiplyWithVal:[r powWithExp:(int)(s.length)]];
                    }
                    
                    b = [b addWithValue:bi];
                } else {
                    b = bi;
                }
            }
            NSMutableArray *tmpArray = [b.magnitude clone];
            [self setMagnitude:tmpArray];
#if !__has_feature(objc_arc)
            if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
        }
        return self;
    } else {
        return nil;
    }
}

- (int)intParse:(NSString*)value withStyle:(int)style {
    int retval = 0;
    if (style == 512) {
        unsigned int outVal;
        NSScanner* scanner = [NSScanner scannerWithString:value];
        [scanner scanHexInt:&outVal];
        retval = outVal;
    } else {
        retval = [value intValue];
    }
    return retval;
}

- (id)initWithData:(NSData*)bytes {
    if (self = [self initWithData:bytes withOffset:0 withLength:(int)bytes.length]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithData:(NSData*)bytes withOffset:(int)offset withLength:(int)length {
    if (self = [super init]) {
        @autoreleasepool {
            if (length == 0) {
                @throw [NSException exceptionWithName:@"Format" reason:@"Zero length BigInteger" userInfo:nil];
            }
            
            self.nBits = -1;
            self.nBitLength = -1;
            
            // TODO Move this processing into MakeMagnitude (provide sign argument)
            if ((int8_t)(((Byte*)(bytes.bytes))[offset]) < 0) {
                self.sign = -1;
                int end = offset + length;
                
                int iBval;
                // strip leading sign bytes
                for (iBval = offset; iBval < end && ((int8_t)(((Byte*)(bytes.bytes))[iBval]) == -1); iBval++) {
                }
                
                if (iBval >= end) {
                    NSMutableArray *tmpArray = [[BigInteger One].magnitude clone];
                    [self setMagnitude:tmpArray];
#if !__has_feature(objc_arc)
                    if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
                } else {
                    int numBytes = end - iBval;
                    NSMutableData *inverse = [[NSMutableData alloc] initWithSize:numBytes];
                    
                    int index = 0;
                    while (index < numBytes) {
                        ((Byte*)(inverse.bytes))[index++] = (Byte)~(((Byte*)(bytes.bytes))[iBval++]);
                    }
                    
                    while (((Byte*)(inverse.bytes))[--index] == 255) {
                        ((Byte*)(inverse.bytes))[index] = 0;
                    }
                    
                    ((Byte*)(inverse.bytes))[index]++;
                    
                    NSMutableArray *tmpArray = [[BigInteger makeMagnitudeWithBytes:inverse withOffset:0 withLength:(int)(inverse.length)] clone];
                    [self setMagnitude:tmpArray];
#if !__has_feature(objc_arc)
                    if (inverse) [inverse release]; inverse = nil;
                    if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
                }
            } else {
                // strip leading zero bytes and return magnitude bytes
                NSMutableArray *tmpArray = [[BigInteger makeMagnitudeWithBytes:bytes withOffset:offset withLength:length] clone];
                [self setMagnitude:tmpArray];
#if !__has_feature(objc_arc)
                if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
                self.sign = self.magnitude.count > 0 ? 1 : 0;
            }
        }
        return self;
    } else {
        return nil;
    }
}

+ (NSMutableArray*)makeMagnitudeWithBytes:(NSData*)bytes withOffset:(int)offset withLength:(int)length {
    int end = offset + length;
    
    // strip leading zeros
    int firstSignificant;
    for (firstSignificant = offset; firstSignificant < end && ((Byte*)(bytes.bytes))[firstSignificant] == 0; firstSignificant++) {
    }
    
    if (firstSignificant >= end) {
        return [BigInteger ZeroMagnitude];
    }
    
    int nInts = (end - firstSignificant + 3) / BytesPerInt;
    int bCount = (end - firstSignificant) % BytesPerInt;
    if (bCount == 0) {
        bCount = BytesPerInt;
    }
    
    if (nInts < 1) {
        return [BigInteger ZeroMagnitude];
    }
    
    NSMutableArray *mag = [[[NSMutableArray alloc] initWithSize:nInts] autorelease];
    @autoreleasepool {
        int v = 0;
        int magnitudeIndex = 0;
        for (int i = firstSignificant; i < end; ++i) {
            v <<= 8;
            v |= ((Byte*)(bytes.bytes))[i] & 0xff;
            bCount--;
            if (bCount <= 0) {
                mag[magnitudeIndex] = @(v);
                magnitudeIndex++;
                bCount = BytesPerInt;
                v = 0;
            }
        }
        
        if (magnitudeIndex < mag.count) {
            mag[magnitudeIndex] = @(v);
        }
    }
    return mag;
}

- (id)initWithSign:(int)sign withBytes:(NSData*)bytes {
    if (self = [self initWithSign:sign withBytes:bytes withOffset:0 withLength:(int)(bytes.length)]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithSign:(int)sign withBytes:(NSData*)bytes withOffset:(int)offset withLength:(int)length {
    if (self = [super init]) {
        @autoreleasepool {
            self.nBits = -1;
            self.nBitLength = -1;
            if (sign < -1 || sign > 1) {
                @throw [NSException exceptionWithName:@"Format" reason:@"Invalid sign value" userInfo:nil];
            }
            if (sign == 0) {
                self.sign = 0;
                NSMutableArray *tmpArray = [[BigInteger ZeroMagnitude] clone];
                [self setMagnitude:tmpArray];
#if !__has_feature(objc_arc)
                if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
            } else {
                NSMutableArray *tmpArray = [[BigInteger makeMagnitudeWithBytes:bytes withOffset:offset withLength:length] clone];
                [self setMagnitude:tmpArray];
#if !__has_feature(objc_arc)
                if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
                self.sign = self.magnitude.count < 1 ? 0 : sign;
            }
        }
        return self;
    } else {
        return nil;
    }
}

- (id)initWithSizeInBits:(int)sizeInBits {
    if (self = [super init]) {
        @autoreleasepool {
            if (sizeInBits < 0) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"sizeInBits must be non-negative" userInfo:nil];
            }
            self.nBits = -1;
            self.nBitLength = -1;
            if (sizeInBits == 0) {
                self.sign = 0;
                NSMutableArray *tmpArray = [[BigInteger ZeroMagnitude] clone];
                [self setMagnitude:tmpArray];
#if !__has_feature(objc_arc)
                if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
                return self;
            }
            
            int nBytes = [BigInteger getByteLength:sizeInBits];
            NSMutableData *b =  [NSMutableData nextBytes:nBytes];
            
            // strip off any excess bits in the MSB
            int xBits = BitsPerByte * nBytes - sizeInBits;
            ((Byte*)(b.bytes))[0] &= (Byte)(255U >> xBits);
            
            NSMutableArray *tmpArray = [[BigInteger makeMagnitudeWithBytes:b withOffset:0 withLength:(int)b.length] clone];
            [self setMagnitude:tmpArray];
#if !__has_feature(objc_arc)
            if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
            
            self.sign = self.magnitude.count < 1 ? 0 : 1;
        }
        return self;
    } else {
        return nil;
    }
}

- (id)initWithBitLength:(int)bitLength withCertainty:(int)certainty {
    if (self = [super init]) {
        @autoreleasepool {
            if (bitLength < 2) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"sizeInBits must be non-negative" userInfo:nil];
            }
            self.sign = 1;
            self.nBitLength = bitLength;
            
            if (bitLength == 2) {
                NSMutableArray *tmpArray = [((arc4random() % 2) == 0 ? [BigInteger Two].magnitude : [BigInteger Three].magnitude) clone];
                [self setMagnitude:tmpArray];
#if !__has_feature(objc_arc)
                if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
                return self;
            }
            int nBytes = [BigInteger getByteLength:bitLength];
            NSMutableData *b = nil;
            
            int xBits = BitsPerByte * nBytes - bitLength;
            Byte mask = (Byte)(255U >> xBits);
            Byte lead = (Byte)(1 << (7-xBits));
            
            for (;;) {
                b = [NSMutableData nextBytes:nBytes];
                
                // strip off any excess bits in the MSB
                ((Byte*)(b.bytes))[0] &= mask;
                
                // ensure the leading bit is 1 (to meet the strength requirement)
                ((Byte*)(b.bytes))[0] |= lead;
                
                // ensure the trailing bit is 1 (i.e. must be odd)
                ((Byte*)(b.bytes))[nBytes - 1] |= 1;
                
                NSMutableArray *tmpArray = [[BigInteger makeMagnitudeWithBytes:b withOffset:0 withLength:(int)(b.length)] clone];
                [self setMagnitude:tmpArray];
#if !__has_feature(objc_arc)
                if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
                
                self.nBits = -1;
                self.mQuote = 0;
                
                if (certainty < 1) {
                    break;
                }
                
                if ([self checkProbablePrimeWithCertainty:certainty withRandomlySelected:YES]) {
                    break;
                }
                
                for (int j = 1; j < (self.magnitude.count - 1); ++j) {
                    self.magnitude[j] = @((int)([self.magnitude[j] intValue] ^ arc4random()));
                    if ([self checkProbablePrimeWithCertainty:certainty withRandomlySelected:YES]) {
                        return self;
                    }
                }
            }
        }
        return self;
    } else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone*)zone {
    return [self retain];
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setMagnitude:nil];
    [super dealloc];
#endif
}

- (BigInteger*)abs {
    return self.sign >= 0 ? self : [self negate];
}

/**
 * return a = a + b - b preserved.
 */
+ (NSMutableArray*)addMagnitudesWithA:(NSMutableArray*)a withB:(NSMutableArray*)b {
    @autoreleasepool {
        int tI = (int)(a.count) - 1;
        int vI = (int)(b.count) - 1;
        int64_t m = 0;
        
        while (vI >= 0) {
            m += ((int64_t)[a[tI] unsignedIntValue] + (int64_t)[b[vI--] unsignedIntValue]);
            NSNumber *num = [[NSNumber alloc] initWithInt:(int)m];
            a[tI--] = num;
#if !__has_feature(objc_arc)
            if (num) [num release]; num = nil;
#endif
            m = (int64_t)((uint64_t)m >> 32);
        }
        
        if (m != 0) {
            while (tI >= 0) {
                a[tI] = @([a[tI] intValue] + 1);
                if ([a[tI] intValue] == 0) {
                    tI--;
                } else {
                    tI--;
                    break;
                }
            }
        }
    }
    return a;
}

- (BigInteger*)addWithValue:(BigInteger*)value {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        if (self.sign == 0) {
            bigInt = value;
        } else {
            if (self.sign != value.sign) {
                if (value.sign == 0) {
                    bigInt = self;
                } else {
                    if (value.sign < 0) {
                        bigInt = [self subtractWithN:[value negate]];
                    } else {
                        bigInt = [value subtractWithN:[self negate]];
                    }
                }
            } else {
                bigInt = [self addToMagnitudeWithMagToAdd:[value magnitude]];
            }
        }
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BigInteger*)addToMagnitudeWithMagToAdd:(NSMutableArray*)magToAdd {
    BigInteger *retVal = nil;
    @autoreleasepool {
        NSMutableArray *big = nil;
        NSMutableArray *small = nil;
        
        if (self.magnitude.count < magToAdd.count) {
            big = magToAdd;
            small = self.magnitude;
        } else {
            big = self.magnitude;
            small = magToAdd;
        }
        
        // Conservatively avoid over-allocation when no overflow possible
        uint limit =  UINT_MAX;
        if (big.count == small.count) {
            limit -= [small[0] unsignedIntValue];
        }
        
        BOOL possibleOverflow = [big[0] unsignedIntValue] >= limit;
        
        NSMutableArray *bigCopy = nil;
        if (possibleOverflow) {
            bigCopy = [[NSMutableArray alloc] initWithSize:((int)(big.count) + 1)];
            [bigCopy copyFromIndex:1 withSource:big withSourceIndex:0 withLength:(int)(big.count)];
        } else {
            bigCopy =  [big clone];
        }
        
        NSMutableArray *tmpBigCopy= [BigInteger addMagnitudesWithA:bigCopy withB:small];
        retVal = [[BigInteger alloc] initWithSignum:self.sign withMag:tmpBigCopy withCheckMag:possibleOverflow];
#if !__has_feature(objc_arc)
        if (bigCopy != nil) [bigCopy release]; bigCopy = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (BigInteger*)andWithValue:(BigInteger*)value {
    if (self.sign == 0 || value.sign == 0) {
        return [BigInteger Zero];
    }
    
    BigInteger *result = nil;
    @autoreleasepool {
        NSMutableArray *aMag = self.sign > 0 ? self.magnitude : [self addWithValue:[BigInteger One]].magnitude;
        NSMutableArray *bMag = value.sign > 0 ? value.magnitude : [value addWithValue:[BigInteger One]].magnitude;
        
        BOOL resultNeg = self.sign < 0 && value.sign < 0;
        int resultLength = MAX((int)(aMag.count), (int)(bMag.count));
        NSMutableArray *resultMag = [[NSMutableArray alloc] initWithSize:resultLength];
        
        int aStart = resultMag.fixedSize - (int)(aMag.count);
        int bStart = resultMag.fixedSize - (int)(bMag.count);
        
        for (int i = 0; i < resultMag.fixedSize; ++i) {
            int aWord = i >= aStart ? [aMag[i - aStart] intValue] : 0;
            int bWord = i >= bStart ? [bMag[i - bStart] intValue] : 0;
            
            if (self.sign < 0) {
                aWord = ~aWord;
            }
            
            if (value.sign < 0) {
                bWord = ~bWord;
            }
            
            resultMag[i] = @((int)(aWord & bWord));
            
            if (resultNeg) {
                resultMag[i] = @((int)~[resultMag[i] intValue]);
            }
        }
        
        result = [[[BigInteger alloc] initWithSignum:1 withMag:resultMag withCheckMag:YES] autorelease];
        
#if !__has_feature(objc_arc)
        if (resultMag != nil) [resultMag release]; resultMag = nil;
#endif
        
        // TODO Optimise this case
        if (resultNeg) {
            result = [result Not];
        }
        [result retain];
    }
    return (result ? [result autorelease] : nil);
}

- (BigInteger*)andNotWithVal:(BigInteger*)val {
    return [self andNotWithVal:[val Not]];
}

- (int)bitCount {
    @autoreleasepool {
        if (self.nBits == -1) {
            if (self.sign < 0) {
                // TODO Optimise this case
                self.nBits = [self Not].bitCount;
            } else {
                int sum = 0;
                int count = self.magnitude.count;
                for (int i = 0; i < count; ++i) {
                    sum += [BigInteger bitCntWithI:[self.magnitude[i] intValue]];
                }
                self.nBits = sum;
            }
        }
    }
    return self.nBits;
}

+ (int)bitCntWithI:(int)i {
    uint u = (uint)i;
    @autoreleasepool {
        u = u - ((u >> 1) & 0x55555555);
        u = (u & 0x33333333) + ((u >> 2) & 0x33333333);
        u = (u + (u >> 4)) & 0x0f0f0f0f;
        u += (u >> 8);
        u += (u >> 16);
        u &= 0x3f;
    }
    return (int)u;
}

+ (int)calcBitLengthWithSign:(int)sign withIndx:(int)indx withMag:(NSMutableArray*)mag {
    int bitLength = 0;
    @autoreleasepool {
        for (;;) {
            if (indx >= mag.count) {
                return 0;
            }
            if ([mag[indx] intValue] != 0) {
                break;
            }
            ++indx;
        }
        
        // bit length for everything after the first int
        bitLength = 32 * (((int)(mag.count) - indx) - 1);
        
        // and determine bitlength of first int
        int firstMag = [mag[indx] intValue];
        bitLength += [BigInteger bitLenWithW:firstMag];
        
        // Check for negative powers of two
        if (sign < 0 && ((firstMag & -firstMag) == firstMag)) {
            do {
                if (++indx >= mag.count) {
                    --bitLength;
                    break;
                }
            }
            while ([mag[indx] intValue] == 0);
        }
    }
    return bitLength;
}

- (int)bitLength {
    if (self.nBitLength == -1) {
        self.nBitLength = self.sign == 0 ? 0 : [BigInteger calcBitLengthWithSign:self.sign withIndx:0 withMag:self.magnitude];
    }
    return self.nBitLength;
}

//
// BitLen(value) is the number of bits in value.
//
+ (int)bitLenWithW:(int)w {
    uint v = (uint)w;
    uint t = v >> 24;
    if (t != 0) {
        return 24 + ((Byte*)([BigInteger BitLengthTable].bytes))[t];
    }
    t = v >> 16;
    if (t != 0) {
        return 16 + ((Byte*)([BigInteger BitLengthTable].bytes))[t];
    }
    t = v >> 8;
    if (t != 0) {
        return 8 + ((Byte*)([BigInteger BitLengthTable].bytes))[t];
    }
    return ((Byte*)([BigInteger BitLengthTable].bytes))[v];
}

- (BOOL)quickPow2Check {
    return self.sign > 0 && self.nBits == 1;
}

- (int)compareTo:(id)obj {
    if (obj != nil && [obj isKindOfClass:[BigInteger class]]) {
        return [self compareToWithValue:(BigInteger*)obj];
    } else {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"obj is not BigInteger" userInfo:nil];
    }
}

/**
 * unsigned comparison on two arrays - note the arrays may
 * start with leading zeros.
 */

+ (int)compareToWithXindx:(int)xIndx withX:(NSMutableArray*)x withYindx:(int)yIndx withY:(NSMutableArray*)y {
    while (xIndx != x.count && [x[xIndx] intValue] == 0) {
        xIndx++;
    }
    
    while (yIndx != y.count && [y[yIndx] intValue] == 0) {
        yIndx++;
    }
    
    return [BigInteger compareNoLeadingZeroesWithXindx:xIndx withX:x withYindx:yIndx withY:y];
}

+ (int)compareNoLeadingZeroesWithXindx:(int)xIndx withX:(NSMutableArray*)x withYindx:(int)yIndx withY:(NSMutableArray*)y {
    int retVal = 0;
    @autoreleasepool {
        int diff = ((int)(x.count) - (int)(y.count)) - (xIndx - yIndx);
        
        if (diff != 0) {
            retVal = diff < 0 ? -1 : 1;
        } else {
            // lengths of magnitudes the same, test the magnitude values
            while (xIndx < x.count) {
                uint v1 = [x[xIndx++] unsignedIntValue];
                uint v2 = [y[yIndx++] unsignedIntValue];
                
                if (v1 != v2) {
                    retVal = v1 < v2 ? -1 : 1;
                    break;
                }
            }
        }
    }
    return retVal;
}

- (int)compareToWithValue:(BigInteger*)value {
    return self.sign < value.sign ? -1
            : self.sign > value.sign ? 1
            : self.sign == 0 ? 0
            : self.sign * [BigInteger compareNoLeadingZeroesWithXindx:0 withX:self.magnitude withYindx:0 withY:value.magnitude];
}

/**
 * return z = x / y - done in place (z value preserved, x contains the
 * remainder)
 * x: int[], y: int[]
 * return: int[]
 */
- (NSMutableArray*)divideWithX:(NSMutableArray*)x withY:(NSMutableArray*)y {
    NSMutableArray *count = nil;
    @autoreleasepool {
        int xStart = 0;
        while (xStart < x.count && [x[xStart] intValue] == 0) {
            ++xStart;
        }
        
        int yStart = 0;
        while (yStart < y.count && [y[yStart] intValue] == 0) {
            ++yStart;
        }
        
        if (yStart >= y.count) {
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"yStart greater than or equal to count of y.count" userInfo:nil];
        }
        
        int xyCmp = [BigInteger compareNoLeadingZeroesWithXindx:xStart withX:x withYindx:yStart withY:y];
        
        if (xyCmp > 0) {
            int yBitLength = [BigInteger calcBitLengthWithSign:1 withIndx:yStart withMag:y];
            int xBitLength = [BigInteger calcBitLengthWithSign:1 withIndx:xStart withMag:x];
            int shift = xBitLength - yBitLength;
            
            NSMutableArray *iCount = nil;
            int iCountStart = 0;
            
            NSMutableArray *c = nil;
            int cStart = 0;
            int cBitLength = yBitLength;
            if (shift > 0) {
                iCount = [[NSMutableArray alloc] initWithSize:((shift >> 5) + 1)];
                iCount[0] = @((int)(1 << (shift % 32)));
                
                c = [[BigInteger shiftLeftWithMag:y withN:shift] retain];
                cBitLength += shift;
            } else {
                iCount = [[NSMutableArray alloc] initWithSize:1];
                iCount[0] = @((int)1);
                
                int len = (int)(y.count) - yStart;
                c = [[NSMutableArray alloc] initWithSize:len];
                [c copyFromIndex:0 withSource:y withSourceIndex:yStart withLength:len];
            }
            
            count = [[NSMutableArray alloc] initWithSize:(int)(iCount.fixedSize)];
            
            for (;;) {
                if (cBitLength < xBitLength || [BigInteger compareNoLeadingZeroesWithXindx:xStart withX:x withYindx:cStart withY:c] >= 0) {
                    [BigInteger subtractWithXstart:xStart withX:x withYstart:cStart withY:c];
                    [BigInteger addMagnitudesWithA:count withB:iCount];
                    
                    while ([x[xStart] intValue] == 0) {
                        if (++xStart == x.count) {
#if !__has_feature(objc_arc)
                            if (iCount != nil) [iCount release]; iCount = nil;
                            if (c != nil) [c release]; c = nil;
#endif
                            goto jumpTo;
                        }
                    }
                    
                    //xBitLength = CalcBitLength(xStart, x);
                    xBitLength = 32 * ((int)(x.count) - xStart - 1) + [BigInteger bitLenWithW:[x[xStart] intValue]];
                    
                    if (xBitLength <= yBitLength) {
                        if (xBitLength < yBitLength) {
#if !__has_feature(objc_arc)
                            if (iCount != nil) [iCount release]; iCount = nil;
                            if (c != nil) [c release]; c = nil;
#endif
                            goto jumpTo;
                        }
                        
                        xyCmp = [BigInteger compareNoLeadingZeroesWithXindx:xStart withX:x withYindx:yStart withY:y];
                        
                        if (xyCmp <= 0) {
                            break;
                        }
                    }
                }
                
                shift = cBitLength - xBitLength;
                
                // NB: The case where c[cStart] is 1-bit is harmless
                if (shift == 1) {
                    uint firstC = [c[cStart] unsignedIntValue] >> 1;
                    uint firstX = [x[xStart] unsignedIntValue];
                    if (firstC > firstX) {
                        ++shift;
                    }
                }
                
                if (shift < 2) {
                    [BigInteger shiftRightOneInPlaceWithStart:cStart withMag:c];
                    --cBitLength;
                    [BigInteger shiftRightOneInPlaceWithStart:iCountStart withMag:iCount];
                } else {
                    [BigInteger shiftRightInPlaceWithStart:cStart withMag:c withN:shift];
                    cBitLength -= shift;
                    [BigInteger shiftRightInPlaceWithStart:iCountStart withMag:iCount withN:shift];
                }
                
                //cStart = c.Length - ((cBitLength + 31) / 32);
                while ([c[cStart] intValue] == 0) {
                    ++cStart;
                }
                
                while ([iCount[iCountStart] intValue] == 0) {
                    ++iCountStart;
                }
            }
            
#if !__has_feature(objc_arc)
            if (iCount != nil) [iCount release]; iCount = nil;
            if (c != nil) [c release]; c = nil;
#endif
        } else {
            count = [[NSMutableArray alloc] initWithSize:1];
            count[0] = @((int)1);
        }
        
        if (xyCmp == 0) {
            [BigInteger addMagnitudesWithA:count withB:[BigInteger One].magnitude];
            [x clearFromIndex:xStart withLength:((int)(x.count) - xStart)];
        }
    }
jumpTo:;
    return (count ? [count autorelease] : nil);
}

- (BigInteger*)divideWithVal:(BigInteger*)val {
    if (val.sign == 0) {
        @throw [NSException exceptionWithName:@"Arithmetic" reason:@"Division by zero error" userInfo:nil];
    }
    
    if (self.sign == 0) {
        return [BigInteger Zero];
    }
    
    BigInteger *bigInt = nil;
    @autoreleasepool {
        if ([val quickPow2Check]) { // val is power of two
            BigInteger *result = [[self abs] shiftRightWithN:([[val abs] bitLength] - 1)];
            bigInt = (val.sign == self.sign ? result : [result negate]);
        } else {
            NSMutableArray *mag = [self.magnitude clone];
            bigInt = [[[BigInteger alloc] initWithSignum:self.sign * val.sign withMag:[self divideWithX:mag withY:val.magnitude] withCheckMag:YES] autorelease];
#if !__has_feature(objc_arc)
            if (mag) [mag release]; mag = nil;
#endif
        }
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (NSMutableArray*)divideAndRemainderWithVal:(BigInteger*)val {
    if (val.sign == 0) {
        @throw [NSException exceptionWithName:@"Arithmetic" reason:@"Division by zero error" userInfo:nil];
    }
    
    // BigInteger[]
    NSMutableArray *biggies = [[[NSMutableArray alloc] initWithSize:2] autorelease];
    @autoreleasepool {
        if (self.sign == 0) {
            biggies[0] = [BigInteger Zero];
            biggies[1] = [BigInteger Zero];
        } else if ([val quickPow2Check]) { // val is power of two
            int e = [[val abs] bitLength] - 1;
            BigInteger *quotient = [[self abs] shiftRightWithN:e];
            NSMutableArray *remainder = [self lastNBitsWithN:e];
            
            biggies[0] = val.sign == self.sign ? quotient : [quotient negate];
            BigInteger *tmpBigInt = [[BigInteger alloc] initWithSignum:self.sign withMag:remainder withCheckMag:YES];
            biggies[1] = tmpBigInt;
#if !__has_feature(objc_arc)
            if (tmpBigInt) [tmpBigInt release]; tmpBigInt = nil;
#endif
        } else {
            NSMutableArray *remainder = [self.magnitude clone];
            NSMutableArray *quotient = [self divideWithX:remainder withY:val.magnitude];
            
            BigInteger *tmpBigInt = [[BigInteger alloc] initWithSignum:(self.sign * val.sign) withMag:quotient withCheckMag:YES];
            BigInteger *tmpBigInt1 = [[BigInteger alloc] initWithSignum:self.sign withMag:remainder withCheckMag:YES];
            biggies[0] = tmpBigInt;
            biggies[1] = tmpBigInt1;
#if !__has_feature(objc_arc)
            if (remainder) [remainder release]; remainder = nil;
            if (tmpBigInt) [tmpBigInt release]; tmpBigInt = nil;
            if (tmpBigInt1) [tmpBigInt1 release]; tmpBigInt1 = nil;
#endif
        }
    }
    return biggies;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
  
    if (!(object && [object isKindOfClass:[BigInteger class]])) {
        return NO;
    }
    BigInteger *biggie = (BigInteger*)object;
    return self.sign == biggie.sign && [self isEqualMagnitudeWithX:biggie];
}

- (BOOL)isEqualMagnitudeWithX:(BigInteger*)x {
    BOOL retVal = YES;
    @autoreleasepool {
        // NSMutableArray *xMag = [x magnitude];
        if (self.magnitude.count != x.magnitude.count) {
            retVal = NO;
        } else {
            for (int i = 0; i < self.magnitude.count; i++) {
                if ([self.magnitude[i] intValue] != [x.magnitude[i] intValue]) {
                    retVal = NO;
                    break;
                }
            }
        }
    }
    return retVal;
}

- (BigInteger*)gcdWithValue:(BigInteger*)value {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        if (value.sign == 0) {
            bigInt = [self abs];
        } else {
            if (self.sign == 0) {
                bigInt = [value abs];
            } else {
                BigInteger *r;
                BigInteger *u = self;
                BigInteger *v = value;
                
                while (v.sign != 0) {
                    r = [u modWithM:v];
                    u = v;
                    v = r;
                }
                bigInt = u;
            }
        }
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (NSUInteger)hash {
    int hc = (int)(self.magnitude.count);
    if (self.magnitude.count > 0) {
        hc ^= [self.magnitude[0] intValue];
        if (self.magnitude.count > 1) {
            hc ^= [self.magnitude[self.magnitude.count - 1] intValue];
        }
    }
    
    return self.sign < 0 ? ~hc : hc;
}

// TODO Make public?
- (BigInteger*)inc {
    if (self.sign == 0) {
        return [BigInteger One];
    }
    
    if (self.sign < 0) {
        return [[[BigInteger alloc] initWithSignum:-1 withMag:[BigInteger doSubBigLilWithBigMag:self.magnitude withLilMag:[[BigInteger One] magnitude]] withCheckMag:YES] autorelease];
    }
    
    return [self addToMagnitudeWithMagToAdd:[[BigInteger One] magnitude]];
}

- (int)intValue {
    if (self.sign == 0) {
        return 0;
    }
    
    int n = (int)(self.magnitude.count);
    int v = [self.magnitude[n - 1] intValue];
    
    return self.sign < 0 ? -v : v;
}

/**
 * return whether or not a BigInteger is probably prime with a
 * probability of 1 - (1/2)**certainty.
 * <p>From Knuth Vol 2, pg 395.</p>
 */
- (BOOL)isProbablePrimeWithCertainty:(int)certainty {
    return [self isProbablePrimeWithCertainty:certainty withRandomlySelected:NO];
}

- (BOOL)isProbablePrimeWithCertainty:(int)certainty withRandomlySelected:(BOOL)randomlySelected {
    if (certainty <= 0) {
        return true;
    }
    
    BigInteger *n = [self abs];
    
    if (![n testBitWithN:0]) {
        return [n isEqual:[BigInteger Two]];
    }
    
    if ([n isEqual:[BigInteger One]]) {
        return NO;
    }
    
    return [n checkProbablePrimeWithCertainty:certainty withRandomlySelected:randomlySelected];
}

- (BOOL)checkProbablePrimeWithCertainty:(int)certainty withRandomlySelected:(BOOL)randomlySelected {
    BOOL retVal = NO;
    @autoreleasepool {
        // Try to reduce the penalty for really small numbers
        int numLists = MIN(self.bitLength - 1, (int)[[BigInteger primeLists] count]);
        
        for (int i = 0; i < numLists; ++i) {
            int test = [self remainderWithM:[[BigInteger primeProducts][i] intValue]];
            
            NSArray *primeList = [BigInteger primeLists][i];
            for (int j = 0; j < primeList.count; ++j) {
                int prime = [primeList[j] intValue];
                int qRem = test % prime;
                if (qRem == 0) {
                    // We may find small numbers in the list
                    retVal = (self.bitLength < 16 && [self intValue] == prime);
                    goto jumpTo;
                }
            }
        }
        
        // TODO Is it worth trying to create a hybrid of these two?
        retVal = [self rabinMillerTestWithCertainty:certainty withRandomlySelected:randomlySelected];
    }
jumpTo:;
    return retVal;
}

- (BOOL)rabinMillerTestWithCertainty:(int)certainty {
    return [self rabinMillerTestWithCertainty:certainty withRandomlySelected:NO];
}

- (BOOL)rabinMillerTestWithCertainty:(int)certainty withRandomlySelected:(BOOL)randomlySelected {
    BOOL retVal = YES;
    @autoreleasepool {
        int bits = self.bitLength;
        
        int iterations = ((certainty - 1) / 2) + 1;
        if (randomlySelected) {
            int itersFor100Cert = bits >= 1024 ?  4 : bits >= 512  ?  8 : bits >= 256  ? 16 : 50;
            if (certainty < 100) {
                iterations = MIN(itersFor100Cert, iterations);
            } else {
                iterations -= 50;
                iterations += itersFor100Cert;
            }
        }
        
        // let n = 1 + d . 2^s
        BigInteger *n = self;
        int s = [n getLowestSetBitMaskFirstWithFirstWordMask:(int)(-1 << 1)];
        BigInteger *r = [n shiftRightWithN:s];
        
        // NOTE: Avoid conversion to/from Montgomery form and check for R/-R as result instead
        BigInteger *montRadix = [[[BigInteger One] shiftLeftWithN:(int)(32 * [[n magnitude] count])] remainderWithN:n];
        BigInteger *minusMontRadix = [n subtractWithN:montRadix];
        
        do {
            BigInteger *a = nil;
            do {
#if !__has_feature(objc_arc)
                if (a) [a release]; a = nil;
#endif
                a = [[BigInteger alloc] initWithSizeInBits:[n bitLength]];
            }
            while (a.sign == 0 || [a compareToWithValue:n] >= 0 || [a isEqualMagnitudeWithX:montRadix] || [a isEqualMagnitudeWithX:minusMontRadix]);
            
            BigInteger *y = [BigInteger modPowMontyWithB:a withE:r withM:n withConvert:NO];
#if !__has_feature(objc_arc)
            if (a) [a release]; a = nil;
#endif
            
            if (![y isEqual:montRadix]) {
                int j = 0;
                while (![y isEqual:minusMontRadix]) {
                    if (++j == s) {
                        retVal = NO;
                        goto jumpTo;
                    }
                    
                    y = [BigInteger modPowMontyWithB:y withE:[BigInteger Two] withM:n withConvert:NO];
                    
                    if ([y isEqual:montRadix]) {
                        retVal = NO;
                        goto jumpTo;
                    }
                }
            }
        }
        while (--iterations > 0);
    }
jumpTo:;
    return retVal;
}

- (int64_t)longValue {
    if (self.sign == 0) {
        return 0;
    }
    
    int n = (int)[self.magnitude count];
    
    int64_t v = [self.magnitude[n - 1] intValue] & IMASK;
    if (n > 1) {
        v |= ([self.magnitude[n - 2] intValue] & IMASK) << 32;
    }
    return self.sign < 0 ? -v : v;
}


- (BigInteger*)maxWithValue:(BigInteger*)value {
    return [self compareTo:value] > 0 ? self : value;
}

- (BigInteger*)minWithValue:(BigInteger*)value {
    return [self compareTo:value] < 0 ? self : value;
}

- (BigInteger*)modWithM:(BigInteger*)m {
    if (m.sign < 1) {
        @throw [NSException exceptionWithName:@"Arithmetic" reason:@"Modulus must be positive" userInfo:nil];
    }
    
    BigInteger *biggie = [self remainderWithN:m];
    return (biggie.sign >= 0 ? biggie : [biggie addWithValue:m]);
}

- (BigInteger*)modInverseWithM:(BigInteger*)m {
    if (m.sign < 1) {
        @throw [NSException exceptionWithName:@"Arithmetic" reason:@"Modulus must be positive" userInfo:nil];
    }
    
    BigInteger *bigInt = nil;
    @autoreleasepool {
        if ([m quickPow2Check]) {
            bigInt = [self modInversePow2WithM:m];
        } else {
            BigInteger *d = [self remainderWithN:m];
            BigInteger *x;
            BigInteger *gcd = [BigInteger extEuclidWithA:d withB:m withU1Out:&x];
            
            if (![gcd isEqual:[BigInteger One]]) {
                @throw [NSException exceptionWithName:@"Arithmetic" reason:@"Numbers not relatively prime." userInfo:nil];
            }
            
            if (x.sign < 0) {
                x = [x addWithValue:m];
            }
            bigInt = x;
        }
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BigInteger*)modInversePow2WithM:(BigInteger*)m {
    if (![self testBitWithN:0]) {
        @throw [NSException exceptionWithName:@"Arithmetic" reason:@"Numbers not relatively prime." userInfo:nil];
    }
    
    int pow = [m bitLength] - 1;
    
    int64_t inv64 = [BigInteger modInverse64WithD:[self longValue]];
    if (pow < 64) {
        inv64 &= ((1L << pow) - 1);
    }
    
    BigInteger *x = nil;
    @autoreleasepool {
         x = [BigInteger valueOf:inv64];
        
        if (pow > 64) {
            BigInteger *d = [self remainderWithN:m];
            int bitsCorrect = 64;
            
            do {
                BigInteger *t = [[x multiplyWithVal:d] remainderWithN:m];
                x = [[x multiplyWithVal:[[BigInteger Two] subtractWithN:t]] remainderWithN:m];
                
                bitsCorrect <<= 1;
            }
            while (bitsCorrect < pow);
        }
        
        if (x.sign < 0) {
            x = [x addWithValue:m];
        }
        [x retain];
    }
    return (x ? [x autorelease] : nil);
}

+ (int)modInverse32WithD:(int)d {
    // Newton's method with initial estimate "correct to 4 bits"
    int x = d + (((d + 1) & 4) << 1);   // d.x == 1 mod 2**4
    x *= 2 - d * x;                     // d.x == 1 mod 2**8
    x *= 2 - d * x;                     // d.x == 1 mod 2**16
    x *= 2 - d * x;                     // d.x == 1 mod 2**32
    return x;
}

+ (int64_t)modInverse64WithD:(int64_t)d {
    // Newton's method with initial estimate "correct to 4 bits"
    int64_t x = d + (((d + 1LL) & 4LL) << 1);    // d.x == 1 mod 2**4
    x *= 2 - d * x;                         // d.x == 1 mod 2**8
    x *= 2 - d * x;                         // d.x == 1 mod 2**16
    x *= 2 - d * x;                         // d.x == 1 mod 2**32
    x *= 2 - d * x;                         // d.x == 1 mod 2**64
    return x;
}

/**
 * Calculate the numbers u1, u2, and u3 such that:
 *
 * u1 * a + u2 * b = u3
 *
 * where u3 is the greatest common divider of a and b.
 * a and b using the extended Euclid algorithm (refer p. 323
 * of The Art of Computer Programming vol 2, 2nd ed).
 * This also seems to have the side effect of calculating
 * some form of multiplicative inverse.
 *
 * @param a    First number to calculate gcd for
 * @param b    Second number to calculate gcd for
 * @param u1Out      the return object for the u1 value
 * @return     The greatest common divisor of a and b
 */
+ (BigInteger*)extEuclidWithA:(BigInteger*)a withB:(BigInteger*)b withU1Out:(BigInteger**)u1Out {
    BigInteger *u3 = nil;
    @autoreleasepool {
        BigInteger *u1 = [BigInteger One], *v1 = [BigInteger Zero];
        u3 = a;
        BigInteger *v3 = b;
        
        if (v3.sign > 0) {
            for (;;) {
                NSMutableArray *q = [u3 divideAndRemainderWithVal:v3];
                u3 = v3;
                v3 = q[1];
                
                BigInteger *oldU1 = u1;
                u1 = v1;
                
                if (v3.sign <= 0) {
                    break;
                }
                
                v1 = [oldU1 subtractWithN:[v1 multiplyWithVal:q[0]]];
            }
        }
        
        u1Out = &u1;
        [u3 retain];
        [*u1Out retain];
    }
    *u1Out ? [*u1Out autorelease] : nil;
    
    return (u3 ? [u3 autorelease] : nil);
}

+ (void)zeroOutWithX:(NSMutableArray*)x {
    [x clearFromIndex:0 withLength:(int)(x.count)];
}

- (BigInteger*)modPowWithE:(BigInteger*)e withM:(BigInteger*)m {
    if (m.sign < 1) {
        @throw [NSException exceptionWithName:@"Arithmetic" reason:@"Numbers not relatively prime." userInfo:nil];
    }
    
    if ([m isEqual:[BigInteger One]]) {
        return [BigInteger Zero];
    }
    
    if (e.sign == 0) {
        return [BigInteger One];
    }
    
    if (self.sign == 0) {
        return [BigInteger Zero];
    }
    
    BOOL negExp = e.sign < 0;
    if (negExp) {
        e = [e negate];
    }
    
    BigInteger *result = nil;
    @autoreleasepool {
        result = [self modWithM:m];
        if (![e isEqual:[BigInteger One]]) {
            if (([m.magnitude[m.magnitude.count - 1] intValue] & 1) == 0) {
                result = [BigInteger modPowBarrettWithB:result withE:e withM:m];
            } else {
                result = [BigInteger modPowMontyWithB:result withE:e withM:m withConvert:YES];
            }
        }
        
        if (negExp) {
            result = [result modInverseWithM:m];
        }
        [result retain];
    }
    return (result ? [result autorelease] : nil);
}

+ (BigInteger*)modPowBarrettWithB:(BigInteger*)b withE:(BigInteger*)e withM:(BigInteger*)m {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        int k = (int)(m.magnitude.count);
        BigInteger *mr = [[BigInteger One] shiftLeftWithN:(int)((k + 1) << 5)];
        BigInteger *yu = [[[BigInteger One] shiftLeftWithN:(int)(k << 6)] divideWithVal:m];
        
        // Sliding window from MSW to LSW
        int extraBits = 0, expLength = [e bitLength];
        while (expLength > [[BigInteger ExpWindowThresholds][extraBits] intValue]) {
            ++extraBits;
        }
        
        int numPowers = 1 << extraBits;
        NSMutableArray *oddPowers = [[NSMutableArray alloc] initWithSize:numPowers];
        oddPowers[0] = b;
        
        BigInteger *b2 = [BigInteger reduceBarrettWithX:[b square] withM:m withMr:mr withYu:yu];
        
        for (int i = 1; i < numPowers; ++i) {
            oddPowers[i] = [BigInteger reduceBarrettWithX:[oddPowers[i - 1] multiplyWithVal:b2] withM:m withMr:mr withYu:yu];
        }
        
        NSMutableArray *windowList = [BigInteger getWindowListWithMag:e.magnitude withExtraBits:extraBits];
        
        int window = [windowList[0] intValue];
        int mult = window & 0xFF, lastZeroes = window >> 8;
        
        BigInteger *y;
        if (mult == 1) {
            y = b2;
            --lastZeroes;
        } else {
            y = oddPowers[mult >> 1];
        }
        
        int windowPos = 1;
        while ((window = [windowList[windowPos++] intValue]) != -1) {
            mult = window & 0xFF;
            
            int bits = lastZeroes + (int)(((Byte*)([BigInteger BitLengthTable].bytes))[mult]);
            for (int j = 0; j < bits; ++j) {
                y = [BigInteger reduceBarrettWithX:[y square] withM:m withMr:mr withYu:yu];
            }
            
            y = [BigInteger reduceBarrettWithX:[y multiplyWithVal:oddPowers[mult >> 1]] withM:m withMr:mr withYu:yu];
            
            lastZeroes = window >> 8;
        }
#if !__has_feature(objc_arc)
        if (oddPowers != nil) [oddPowers release]; oddPowers = nil;
#endif
        for (int i = 0; i < lastZeroes; ++i) {
            y = [BigInteger reduceBarrettWithX:[y square] withM:m withMr:mr withYu:yu];
        }
        bigInt = y;
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

+ (BigInteger*)reduceBarrettWithX:(BigInteger*)x withM:(BigInteger*)m withMr:(BigInteger*)mr withYu:(BigInteger*)yu {
    int xLen = [x bitLength], mLen = [m bitLength];
    if (xLen < mLen) {
        return x;
    }
    
    @autoreleasepool {
        if (xLen - mLen > 1) {
            int k = (int)(m.magnitude.count);
            
            BigInteger *q1 = [x divideWordsWithW:(k -1)];
            BigInteger *q2 = [q1 multiplyWithVal:yu]; // TODO Only need partial multiplication here
            BigInteger *q3 = [q2 divideWordsWithW:(k + 1)];
            
            BigInteger *r1 = [x remainderWordsWithW:(k + 1)];
            BigInteger *r2 = [q3 multiplyWithVal:m]; // TODO Only need partial multiplication here
            BigInteger *r3 = [r2 remainderWordsWithW:(k + 1)];
            
            x = [r1 subtractWithN:r3];
            if (x.sign < 0) {
                x = [x addWithValue:mr];
            }
        }
        
        while ([x compareToWithValue:m] >= 0) {
            x = [x subtractWithN:m];
        }
        [x retain];
    }
    
    return (x ? [x autorelease] : nil);
}

+ (BigInteger*)modPowMontyWithB:(BigInteger*)b withE:(BigInteger*)e withM:(BigInteger*)m withConvert:(BOOL)convert {
    BigInteger *retVal = nil;
    @autoreleasepool {
        int n = (int)(m.magnitude.count);
        int powR = 32 * n;
        BOOL smallMontyModulus = [m bitLength] + 2 <= powR;
        uint mDash = (uint)[m getMQuote];
        
        // tmp = this * R mod m
        if (convert) {
            b = [[b shiftLeftWithN:powR] remainderWithN:m];
        }
        
        NSMutableArray *yAccum = [[NSMutableArray alloc] initWithSize:(n + 1)];
        NSMutableArray *zVal = [b.magnitude retain];
        if (zVal.count < n) {
            NSMutableArray *tmp = [[NSMutableArray alloc] initWithSize:n];
            [tmp copyFromIndex:(n - (int)(zVal.count)) withSource:zVal withSourceIndex:0 withLength:(int)(zVal.count)];
#if !__has_feature(objc_arc)
            if (zVal != nil) [zVal release]; zVal = nil;
#endif
            zVal = tmp;
        }
        
        // Sliding window from MSW to LSW
        int extraBits = 0;
        
        // Filter the common case of small RSA exponents with few bits set
        if (e.magnitude.count > 1 || [e bitCount] > 2) {
            int expLength = [e bitLength];
            while (expLength > [[BigInteger ExpWindowThresholds][extraBits] intValue]) {
                ++extraBits;
            }
        }
        
        int numPowers = 1 << extraBits;
        NSMutableArray *oddPowers = [[NSMutableArray alloc] initWithSize:numPowers];    // int[][]
        oddPowers[0] = zVal;
        
        NSMutableArray *zSquared = [zVal clone];
        [BigInteger squareMontyWithA:yAccum withX:zSquared withM:m.magnitude withMdash:mDash withSmallMontyModulus:smallMontyModulus];
        
        for (int i = 1; i < numPowers; ++i) {
            NSMutableArray *tmpArray = [oddPowers[i - 1] clone];
            oddPowers[i] = tmpArray;
#if !__has_feature(objc_arc)
            if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
            [BigInteger multiplyMontyWithA:yAccum withX:oddPowers[i] withY:zSquared withM:m.magnitude withMdash:mDash withSmallMontyModulus:smallMontyModulus];
        }
        
        NSMutableArray *windowList = [BigInteger getWindowListWithMag:e.magnitude withExtraBits:extraBits];
        
        int window = [windowList[0] intValue];
        int mult = window & 0xFF, lastZeroes = window >> 8;
        
        NSMutableArray *yVal;
        BOOL isNewClone = NO;
        if (mult == 1) {
            yVal = zSquared;
            --lastZeroes;
        } else {
            yVal = [oddPowers[mult >> 1] clone];
            isNewClone = YES;
        }
        
        int windowPos = 1;
        while ((window = [windowList[windowPos++] intValue]) != -1) {
            mult = window & 0xFF;
            int bits = lastZeroes + (int)(((Byte*)([BigInteger BitLengthTable].bytes))[mult]);
            for (int j = 0; j < bits; ++j) {
                [BigInteger squareMontyWithA:yAccum withX:yVal withM:m.magnitude withMdash:mDash withSmallMontyModulus:smallMontyModulus];
            }
            [BigInteger multiplyMontyWithA:yAccum withX:yVal withY:oddPowers[mult >> 1] withM:m.magnitude withMdash:mDash withSmallMontyModulus:smallMontyModulus];
            lastZeroes = window >> 8;
        }
        
        for (int i = 0; i < lastZeroes; ++i) {
            [BigInteger squareMontyWithA:yAccum withX:yVal withM:m.magnitude withMdash:mDash withSmallMontyModulus:smallMontyModulus];
        }
        
        if (convert) {
            // Return y * R^(-1) mod m
            [BigInteger montgomeryReduceWithX:yVal withM:m.magnitude withMdash:mDash];
        } else if (smallMontyModulus && [self compareToWithXindx:0 withX:yVal withYindx:0 withY:m.magnitude] >= 0) {
            [BigInteger subtractWithXstart:0 withX:yVal withYstart:0 withY:m.magnitude];
        }
        
        retVal = [[BigInteger alloc] initWithSignum:1 withMag:yVal withCheckMag:YES];
#if !__has_feature(objc_arc)
        if (zSquared) [zSquared release]; zSquared = nil;
        if (isNewClone) {
            if (yVal) [yVal release]; yVal = nil;
        }
        if (yAccum) [yAccum release]; yAccum = nil;
        if (zVal) [zVal release]; zVal = nil;
        if (oddPowers) [oddPowers release]; oddPowers = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

+ (NSMutableArray*)getWindowListWithMag:(NSMutableArray*)mag withExtraBits:(int)extraBits {
    int v = [mag[0] intValue];
    
    int leadingBits = [BigInteger bitLenWithW:v];
    
    int resultSize = ((((int)(mag.count) - 1) << 5) + leadingBits) / (1 + extraBits) + 2;
    NSMutableArray *result = [[[NSMutableArray alloc] initWithSize:resultSize] autorelease];              // int[]
    @autoreleasepool {
        int resultPos = 0;
        
        int bitPos = 33 - leadingBits;
        v <<= bitPos;
        
        int mult = 1, multLimit = 1 << extraBits;
        int zeroes = 0;
        
        int i = 0;
        for (;;) {
            for (; bitPos < 32; ++bitPos) {
                if (mult < multLimit) {
                    mult = (mult << 1) | (int)((uint)v >> 31);
                } else if (v < 0) {
                    result[resultPos++] = @([BigInteger createWindowEntryWithMult:mult withZeroes:zeroes]);
                    mult = 1;
                    zeroes = 0;
                } else {
                    ++zeroes;
                }
                v <<= 1;
            }
            if (++i == mag.count) {
                result[resultPos++] = @([BigInteger createWindowEntryWithMult:mult withZeroes:zeroes]);
                break;
            }
            
            v = [mag[i] intValue];
            bitPos = 0;
        }
        
        result[resultPos] = @(-1);
    }
    return result;
}

+ (int)createWindowEntryWithMult:(int)mult withZeroes:(int)zeroes {
    while ((mult & 1) == 0) {
        mult >>= 1;
        ++zeroes;
    }
    
    return mult | (zeroes << 8);
}

/**
 * return w with w = x * x - w is assumed to have enough space.
 */
+ (NSMutableArray*)squareWithW:(NSMutableArray*)w withX:(NSMutableArray*)x {
    uint64_t c;
    
    @autoreleasepool {
        int wBase = (int)(w.count) - 1;
        
        for (int i = (int)(x.count) - 1; i > 0; --i) {
            uint64_t v = [x[i] unsignedIntValue];
            
            c = v * v + [w[wBase] unsignedIntValue];
            w[wBase] = @((int)c);
            c >>= 32;
            
            for (int j = i - 1; j >= 0; --j) {
                uint64_t prod = v * [x[j] unsignedIntValue];
                c += ([w[--wBase] unsignedIntValue] & UIMASK) + ((uint)prod << 1);
                w[wBase] = @((int)c);
                c = (c >> 32) + (prod >> 31);
            }
            
            c += [w[--wBase] unsignedIntValue];
            w[wBase] = @((int)c);
            
            if (--wBase >= 0) {
                w[wBase] = @((int)(c >> 32));
            } else {
            }
            
            wBase += i;
        }
        
        c = [x[0] unsignedIntValue];
        
        c = c * c + [w[wBase] unsignedIntValue];
        w[wBase] = @((int)c);
        
        if (--wBase >= 0) {
            w[wBase] = @((int)([w[wBase] intValue] + (int)(c >> 32)));
        } else {
        }
    }
    
    return w;
}

/**
 * return x with x = y * z - x is assumed to have enough space.
 */
+ (NSMutableArray*)multiplyWithX:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    int i = (int)(z.count);
    
    if (i < 1) {
        return x;
    }
    
    @autoreleasepool {
        int xBase = (int)(x.count) - (int)(y.count);
        
        do {
            int64_t a = [z[--i] intValue] & IMASK;
            int64_t val = 0;
            
            if (a != 0) {
                for (int j = (int)(y.count) - 1; j >= 0; j--) {
                    val += a * ([y[j] intValue] & IMASK) + ([x[xBase + j] intValue] & IMASK);
                    x[xBase + j] = @((int)val);
                    val = (int64_t)((uint64_t)val >> 32);
                }
            }
            --xBase;
            if (xBase >= 0) {
                x[xBase] = @((int)val);
            } else {
            }
        }
        while (i > 0);
    }
    
    return x;
}

/**
 * Calculate mQuote = -m^(-1) mod b with b = 2^32 (32 = word size)
 */
- (int)getMQuote {
    int retVal = 0;
    @autoreleasepool {
        if (self.mQuote != 0) {
            return self.mQuote; // already calculated
        }
        int d = -[self.magnitude[self.magnitude.count - 1] intValue];
        retVal = (self.mQuote = [BigInteger modInverse32WithD:d]);
    }
    return retVal;
}

+ (void)montgomeryReduceWithX:(NSMutableArray*)x withM:(NSMutableArray*)m withMdash:(uint)mDash { // mDash = -m^(-1) mod b
    // NOTE: Not a general purpose reduction (which would allow x up to twice the bitlength of m)
    @autoreleasepool {
        int n = (int)(m.count);
    
        for (int i = n - 1; i >= 0; --i) {
            uint x0 = [x[n - 1] unsignedIntValue];
            uint64_t t = x0 * mDash;
            
            uint64_t carry = t * [m[n - 1] unsignedIntValue] + x0;
            carry >>= 32;
            
            for (int j = n - 2; j >= 0; --j) {
                carry += t * [m[j] unsignedIntValue] + [x[j] unsignedIntValue];
                x[j + 1] = @((int)carry);
                carry >>= 32;
            }
            
            x[0] = @((int)carry);
        }
        
        if ([BigInteger compareToWithXindx:0 withX:x withYindx:0 withY:m] >= 0) {
            [BigInteger subtractWithXstart:0 withX:x withYstart:0 withY:m];
        }
    }
}

/**
 * Montgomery multiplication: a = x * y * R^(-1) mod m
 * <br/>
 * Based algorithm 14.36 of Handbook of Applied Cryptography.
 * <br/>
 * <li> m, x, y should have length n </li>
 * <li> a should have length (n + 1) </li>
 * <li> b = 2^32, R = b^n </li>
 * <br/>
 * The result is put in x
 * <br/>
 * NOTE: the indices of x, y, m, a different in HAC and in Java
 */
+ (void)multiplyMontyWithA:(NSMutableArray*)a withX:(NSMutableArray*)x withY:(NSMutableArray*)y withM:(NSMutableArray*)m withMdash:(uint)mDash withSmallMontyModulus:(BOOL)smallMontyModulus { // mDash = -m^(-1) mod b
    int n = (int)(m.count);
    
    @autoreleasepool {
        if (n == 1) {
            x[0] = @((int)[BigInteger multiplyMontyNIsOneWithX:[x[0] unsignedIntValue] withY:[y[0] unsignedIntValue] WithM:[m[0] unsignedIntValue] withMdash:mDash]);
            return;
        }
        
        uint y0 = [y[n - 1] unsignedIntValue];
        int aMax;
        
        {
            uint64_t xi = [x[n - 1] unsignedIntValue];
            
            uint64_t carry = xi * y0;
            uint64_t t = (uint)carry * mDash;
            
            uint64_t prod2 = t * [m[n - 1] unsignedIntValue];
            carry += (uint)prod2;
            carry = (carry >> 32) + (prod2 >> 32);
            
            for (int j = n - 2; j >= 0; --j) {
                uint64_t prod1 = xi * [y[j] unsignedIntValue];
                prod2 = t * [m[j] unsignedIntValue];
                
                carry += (prod1 & UIMASK) + (uint)prod2;
                a[j + 2] = @((int)carry);
                carry = (carry >> 32) + (prod1 >> 32) + (prod2 >> 32);
            }
            
            a[1] = @((int)carry);
            aMax = (int)(carry >> 32);
        }
        
        for (int i = n - 2; i >= 0; --i) {
            uint a0 = [a[n] unsignedIntValue];
            uint64_t xi = [x[i] unsignedIntValue];
            
            uint64_t prod1 = xi * y0;
            uint64_t carry = (prod1 & UIMASK) + a0;
            uint64_t t = (uint)carry * mDash;
            
            uint64_t prod2 = t * [m[n - 1] unsignedIntValue];
            carry += (uint)prod2;
            carry = (carry >> 32) + (prod1 >> 32) + (prod2 >> 32);
            
            for (int j = n - 2; j >= 0; --j) {
                prod1 = xi * [y[j] unsignedIntValue];
                prod2 = t * [m[j] unsignedIntValue];
                
                carry += (prod1 & UIMASK) + (uint)prod2 + [a[j + 1] unsignedIntValue];
                a[j + 2] = @((int)carry);
                carry = (carry >> 32) + (prod1 >> 32) + (prod2 >> 32);
            }
            
            carry += (uint)aMax;
            a[1] = @((int)carry);
            aMax = (int)(carry >> 32);
        }
        
        a[0] = @(aMax);
        
        if (!smallMontyModulus && [BigInteger compareToWithXindx:0 withX:a withYindx:0 withY:m] >= 0) {
            [BigInteger subtractWithXstart:0 withX:a withYstart:0 withY:m];
        }
        
        [x copyFromIndex:0 withSource:a withSourceIndex:1 withLength:n];
    }
}

+ (void)squareMontyWithA:(NSMutableArray*)a withX:(NSMutableArray*)x withM:(NSMutableArray*)m withMdash:(uint)mDash withSmallMontyModulus:(BOOL)smallMontyModulus { // mDash = -m^(-1) mod b
    int n = (int)(m.count);
    
    @autoreleasepool {
        if (n == 1) {
            uint xVal = [x[0] unsignedIntValue];
            x[0] = @((int)[BigInteger multiplyMontyNIsOneWithX:xVal withY:xVal WithM:[m[0] unsignedIntValue] withMdash:mDash]);
            return;
        }
        
        uint64_t x0 = [x[n - 1] unsignedIntValue];
        int aMax;
        
        {
            uint64_t carry = x0 * x0;
            uint64_t t = (uint)carry * mDash;
            
            uint64_t prod2 = t * [m[n - 1] unsignedIntValue];
            carry += (uint)prod2;
            carry = (carry >> 32) + (prod2 >> 32);
            
            for (int j = n - 2; j >= 0; --j) {
                uint64_t prod1 = x0 * [x[j] unsignedIntValue];
                prod2 = t * [m[j] unsignedIntValue];
                
                carry += (prod2 & UIMASK) + ((uint)prod1 << 1);
                a[j + 2] = @((int)carry);
                carry = (carry >> 32) + (prod1 >> 31) + (prod2 >> 32);
            }
            
            a[1] = @((int)carry);
            aMax = (int)(carry >> 32);
        }
        
        for (int i = n - 2; i >= 0; --i) {
            uint a0 = [a[n] unsignedIntValue];
            uint64_t t = a0 * mDash;
            
            uint64_t carry = t * [m[n - 1] unsignedIntValue] + a0;
            carry >>= 32;
            
            for (int j = n - 2; j > i; --j) {
                carry += t * [m[j] unsignedIntValue] + [a[j + 1] unsignedIntValue];
                a[j + 2] = @((int)carry);
                carry >>= 32;
            }
            
            uint64_t xi = [x[i] unsignedIntValue];
            
            {
                uint64_t prod1 = xi * xi;
                uint64_t prod2 = t * [m[i] unsignedIntValue];
                
                carry += (prod1 & UIMASK) + (uint)prod2 + [a[i + 1] unsignedIntValue];
                a[i + 2] = @((int)carry);
                carry = (carry >> 32) + (prod1 >> 32) + (prod2 >> 32);
            }
            
            for (int j = i - 1; j >= 0; --j) {
                uint64_t prod1 = xi * [x[j] unsignedIntValue];
                uint64_t prod2 = t * [m[j] unsignedIntValue];
                
                carry += (prod2 & UIMASK) + ((uint)prod1 << 1) + [a[j + 1] unsignedIntValue];
                a[j + 2] = @((int)carry);
                carry = (carry >> 32) + (prod1 >> 31) + (prod2 >> 32);
            }
            
            carry += (uint)aMax;
            a[1] = @((int)carry);
            aMax = (int)(carry >> 32);
        }
        
        a[0] = @(aMax);
        
        if (!smallMontyModulus && [BigInteger compareToWithXindx:0 withX:a withYindx:0 withY:m] >= 0) {
            [BigInteger subtractWithXstart:0 withX:a withYstart:0 withY:m];
        }
        
        [x copyFromIndex:0 withSource:a withSourceIndex:1 withLength:n];
    }
}

+ (uint)multiplyMontyNIsOneWithX:(uint)x withY:(uint)y WithM:(uint)m withMdash:(uint)mDash {
    uint64_t carry = (uint64_t)x * y;
    uint t = (uint)carry * mDash;
    uint64_t um = m;
    uint64_t prod2 = um * t;
    carry += (uint)prod2;
    carry = (carry >> 32) + (prod2 >> 32);
    if (carry > um) {
        carry -= um;
    }
    return (uint)carry;
}

- (BigInteger*)multiplyWithVal:(BigInteger*)val {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        if (val == self) {
            bigInt = [self square];
            goto jumpTo;
        }
        
        if ((self.sign & val.sign) == 0) {
            bigInt = [BigInteger Zero];
            goto jumpTo;
        }
        
        if ([val quickPow2Check]) { // val is power of two
            BigInteger *result = [self shiftLeftWithN:([[val abs] bitLength] - 1)];
            bigInt = (val.sign > 0 ? result : [result negate]);
            goto jumpTo;
        }
        
        if ([self quickPow2Check]) // this is power of two
        {
            BigInteger *result = [val shiftLeftWithN:([[self abs] bitLength] - 1)];
            bigInt = (self.sign > 0 ? result : [result negate]);
            goto jumpTo;
        }
        
        int resLength = (int)(self.magnitude.count) + (int)(val.magnitude.count);
        NSMutableArray *res = [[NSMutableArray alloc] initWithSize:resLength];              // int[]
        
        [BigInteger multiplyWithX:res withY:self.magnitude withZ:val.magnitude];
        
        int resSign = self.sign ^ val.sign ^ 1;
        bigInt = [[[BigInteger alloc] initWithSignum:resSign withMag:res withCheckMag:YES] autorelease];
#if !__has_feature(objc_arc)
        if (res != nil) [res release]; res = nil;
#endif
    jumpTo:;
        
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BigInteger*)square {
    if (self.sign == 0) {
        return [BigInteger Zero];
    }
    
    BigInteger *retVal = nil;
    @autoreleasepool {
        if ([self quickPow2Check]) {
            retVal = [self shiftLeftWithN:([[self abs] bitLength] - 1)];
        } else {
            int resLength = (int)(self.magnitude.count) << 1;
            if ([self.magnitude[0] unsignedIntValue] >> 16 == 0) {
                --resLength;
            }
            NSMutableArray *res = [[NSMutableArray alloc] initWithSize:resLength];
            [BigInteger squareWithW:res withX:self.magnitude];
            retVal = [[[BigInteger alloc] initWithSignum:1 withMag:res withCheckMag:NO] autorelease];
#if !__has_feature(objc_arc)
            if (res != nil) [res release]; res = nil;
#endif
        }
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (BigInteger*)negate {
    if (self.sign == 0) {
        return self;
    }
    BigInteger *retVal = [[[BigInteger alloc] initWithSignum:-(self.sign) withMag:self.magnitude withCheckMag:NO] autorelease];
    return retVal;
}

- (BigInteger*)nextProbablePrime {
    if (self.sign < 0) {
        @throw [NSException exceptionWithName:@"Arithmetic" reason:@"Cannot be called on value < 0" userInfo:nil];
    }
    
    if ([self compareToWithValue:[BigInteger Two]] < 0) {
        return [BigInteger Two];
    }
    
    BigInteger *bigInt = nil;
    @autoreleasepool {
        BigInteger *n = [[self inc] setBitWithN:0];
        
        while (![n checkProbablePrimeWithCertainty:100 withRandomlySelected:NO]) {
            n = [n addWithValue:[BigInteger Two]];
        }
        bigInt = n;
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BigInteger*)Not {
    return [[self inc] negate];
}

- (BigInteger*)powWithExp:(int)exp {
    if (exp <= 0) {
        if (exp < 0) {
            @throw [NSException exceptionWithName:@"Arithmetic" reason:@"Negative exponent" userInfo:nil];
        }
        return [BigInteger One];
    }
    
    if (self.sign == 0) {
        return self;
    }
    
    BigInteger *bigInt = nil;
    @autoreleasepool {
        if ([self quickPow2Check]) {
            int64_t powOf2 = (int64_t)exp * ([self bitLength] - 1);
            if (powOf2 > INT32_MAX) {
                @throw [NSException exceptionWithName:@"Arithmetic" reason:@"Result too large" userInfo:nil];
            }
            bigInt = [[BigInteger One] shiftLeftWithN:(int)powOf2];
        } else {
            BigInteger *y = [BigInteger One];
            BigInteger *z = self;
            
            for (;;) {
                if ((exp & 0x1) == 1) {
                    y = [y multiplyWithVal:z];
                }
                exp >>= 1;
                if (exp == 0) break;
                z = [z multiplyWithVal:z];
            }
            bigInt = y;
        }
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}


+ (BigInteger*)probablePrime:(int)bitLength {
    return [[[BigInteger alloc] initWithBitLength:bitLength withCertainty:100] autorelease];
}

- (int)remainderWithM:(int)m {
    int64_t acc = 0;
    @autoreleasepool {
        for (int pos = 0; pos < self.magnitude.count; ++pos) {
            int64_t posVal = [self.magnitude[pos] unsignedIntValue];
            acc = (acc << 32 | posVal) % m;
        }
    }
    return (int) acc;
}

+ (NSMutableArray*)remainderWithX:(NSMutableArray*)x withY:(NSMutableArray*)y {
    @autoreleasepool {
        int xStart = 0;
        while (xStart < x.count && [x[xStart] intValue] == 0) {
            ++xStart;
        }
        
        int yStart = 0;
        while (yStart < y.count && [y[yStart] intValue] == 0) {
            ++yStart;
        }
        
        int xyCmp = [BigInteger compareNoLeadingZeroesWithXindx:xStart withX:x withYindx:yStart withY:y];
        
        if (xyCmp > 0) {
            int yBitLength = [BigInteger calcBitLengthWithSign:1 withIndx:yStart withMag:y];
            int xBitLength = [BigInteger calcBitLengthWithSign:1 withIndx:xStart withMag:x];
            int shift = xBitLength - yBitLength;
            
            NSMutableArray *c = nil;
            int cStart = 0;
            int cBitLength = yBitLength;
            if (shift > 0) {
                c = [[self shiftLeftWithMag:y withN:shift] retain];
                cBitLength += shift;
            } else {
                int len = (int)(y.count) - yStart;
                c = [[NSMutableArray alloc] initWithSize:len];
                [c copyFromIndex:0 withSource:y withSourceIndex:yStart withLength:len];
            }
            
            for (;;) {
                if (cBitLength < xBitLength || [BigInteger compareNoLeadingZeroesWithXindx:xStart withX:x withYindx:cStart withY:c] >= 0) {
                    [BigInteger subtractWithXstart:xStart withX:x withYstart:cStart withY:c];
                    while ([x[xStart] intValue] == 0) {
                        if (++xStart == x.count) {
#if !__has_feature(objc_arc)
                            if (c != nil) [c release]; c = nil;
#endif
                            return x;
                        }
                    }
                    
                    //xBitLength = CalcBitLength(xStart, x);
                    xBitLength = 32 * ((int)(x.count) - xStart - 1) + [BigInteger bitLenWithW:[x[xStart] intValue]];
                    
                    if (xBitLength <= yBitLength) {
                        if (xBitLength < yBitLength) {
#if !__has_feature(objc_arc)
                            if (c != nil) [c release]; c = nil;
#endif
                            return x;
                        }
                        
                        xyCmp = [BigInteger compareNoLeadingZeroesWithXindx:xStart withX:x withYindx:yStart withY:y];
                        
                        if (xyCmp <= 0) {
                            break;
                        }
                    }
                }
                
                shift = cBitLength - xBitLength;
                
                // NB: The case where c[cStart] is 1-bit is harmless
                if (shift == 1) {
                    uint firstC = [c[cStart] unsignedIntValue] >> 1;
                    uint firstX = [x[xStart] unsignedIntValue];
                    if (firstC > firstX) {
                        ++shift;
                    }
                }
                
                if (shift < 2) {
                    [BigInteger shiftRightOneInPlaceWithStart:cStart withMag:c];
                    --cBitLength;
                } else {
                    [BigInteger shiftRightInPlaceWithStart:cStart withMag:c withN:shift];
                    cBitLength -= shift;
                }
                
                //cStart = c.Length - ((cBitLength + 31) / 32);
                while ([c[cStart] intValue] == 0) {
                    ++cStart;
                }
            }
            
#if !__has_feature(objc_arc)
            if (c != nil) [c release]; c = nil;
#endif
        }
        
        if (xyCmp == 0) {
            [x clearFromIndex:xStart withLength:(int)(x.count - xStart)];
        }
        return x;
    }
}

- (BigInteger*)remainderWithN:(BigInteger*)n {
    if (n.sign == 0) {
        @throw [NSException exceptionWithName:@"Arithmetic" reason:@"Division by zero error" userInfo:nil];
    }
    
    BigInteger *bigInt = nil;
    @autoreleasepool {
        if (self.sign == 0) {
            bigInt = [BigInteger Zero];
        } else {
            // For small values, use fast remainder method
            if (n.magnitude.count == 1) {
                int val = [n.magnitude[0] intValue];
                
                if (val > 0) {
                    if (val == 1) {
                        bigInt = [BigInteger Zero];
                        goto jumpTo;
                    }
                    
                    // TODO Make this func work on uint, and handle val == 1?
                    int rem = [self remainderWithM:val];
                    
                    bigInt = (rem == 0 ? [BigInteger Zero] : [[[BigInteger alloc] initWithSignum:self.sign withMag:[NSMutableArray arrayWithObjects:@(rem), nil] withCheckMag:NO] autorelease]);
                    goto jumpTo;
                }
            }
            
            if ([BigInteger compareNoLeadingZeroesWithXindx:0 withX:self.magnitude withYindx:0 withY:n.magnitude] < 0) {
                bigInt = self;
                goto jumpTo;
            }
            
            NSMutableArray *result = nil;                   // int[]
            if ([n quickPow2Check]) {  // n is power of two
                // TODO Move before small values branch above?
                result = [self lastNBitsWithN:([[n abs] bitLength] - 1)];
                bigInt = [[[BigInteger alloc] initWithSignum:self.sign withMag:result withCheckMag:YES] autorelease];
            } else {
                NSMutableArray *tmpArray = [self.magnitude clone];
                result = [BigInteger remainderWithX:tmpArray withY:n.magnitude];
                bigInt = [[[BigInteger alloc] initWithSignum:self.sign withMag:result withCheckMag:YES] autorelease];
#if !__has_feature(objc_arc)
                if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
            }
        }
        
    jumpTo:;
        [bigInt retain];
        
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (NSMutableArray*)lastNBitsWithN:(int)n {
    if (n < 1) {
        return [BigInteger ZeroMagnitude];
    }
    
    NSMutableArray *result = nil;
    @autoreleasepool {
        int numWords = (n + BitsPerInt - 1) / BitsPerInt;
        numWords = MIN(numWords, (int)(self.magnitude.count));
        result = [[NSMutableArray alloc] initWithSize:numWords];
        
        [result copyFromIndex:0 withSource:self.magnitude withSourceIndex:(int)(self.magnitude.count - numWords) withLength:numWords];
        
        int excessBits = (numWords << 5) - n;
        if (excessBits > 0) {
            result[0] = @([result[0] intValue] & ((int)(UINT32_MAX >> excessBits)));
        }
    }
    return (result ? [result autorelease] : nil);
}

- (BigInteger*)divideWordsWithW:(int)w {
    int n = (int)(self.magnitude.count);
    if (w >= n) {
        return [BigInteger Zero];
    }
    
    BigInteger *retVal = nil;
    @autoreleasepool {
        NSMutableArray *mag = [[NSMutableArray alloc] initWithSize:(n - w)];
        [mag copyFromIndex:0 withSource:self.magnitude withSourceIndex:0 withLength:(n - w)];
        retVal = [[BigInteger alloc] initWithSignum:self.sign withMag:mag withCheckMag:NO];
#if !__has_feature(objc_arc)
        if (mag != nil) [mag release]; mag = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (BigInteger*)remainderWordsWithW:(int)w {
    int n = (int)(self.magnitude.count);
    if (w >= n) {
        return self;
    }
    
    BigInteger *retVal = nil;
    @autoreleasepool {
        NSMutableArray *mag = [[NSMutableArray alloc] initWithSize:w];
        [mag copyFromIndex:0 withSource:self.magnitude withSourceIndex:(n - w) withLength:w];
        retVal = [[BigInteger alloc] initWithSignum:self.sign withMag:mag withCheckMag:NO];
#if !__has_feature(objc_arc)
        if (mag != nil) [mag release]; mag = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

+ (NSMutableArray*)shiftLeftWithMag:(NSMutableArray*)mag withN:(int)n {
    int nInts = (int)((uint)n >> 5);
    int nBits = n & 0x1f;
    int magLen = (int)(mag.count);
    
    NSMutableArray *newMag = nil;
    @autoreleasepool {
        if (nBits == 0) {
            newMag =[[NSMutableArray alloc] initWithSize:(magLen + nInts)];
            [newMag copyFromIndex:0 withSource:mag withSourceIndex:0 withLength:(int)(mag.count)];
        } else {
            int i = 0;
            int nBits2 = 32 - nBits;
            int highBits = (int)([mag[0] unsignedIntValue] >> nBits2);
            
            if (highBits != 0) {
                newMag = [[NSMutableArray alloc] initWithSize:(magLen + nInts + 1)];
                newMag[i++] = @(highBits);
            } else {
                newMag = [[NSMutableArray alloc] initWithSize:(magLen + nInts)];
            }
            
            int m = [mag[0] intValue];
            for (int j = 0; j < magLen - 1; j++) {
                int next = [mag[j + 1] intValue];
                
                newMag[i++] = @((int)((m << nBits) | (int)((uint)next >> nBits2)));
                m = next;
            }
            
            newMag[i] = @((int)([mag[magLen - 1] intValue] << nBits));
        }
    }
    
    return (newMag ? [newMag autorelease] : nil);
}

+ (int)shiftLeftOneInPlaceWithX:(NSMutableArray*)x withCarry:(int)carry {
    @autoreleasepool {
        int pos = (int)(x.count);
        while (--pos >= 0) {
            uint val = [x[pos] unsignedIntValue];
            x[pos] = @((int)((int)(val << 1) | carry));
            carry = (int)(val >> 31);
        }
    }
    return carry;
}

- (BigInteger*)shiftLeftWithN:(int)n {
    if (self.sign == 0 || self.magnitude.count == 0) {
        return [BigInteger Zero];
    }
    
    if (n == 0) {
        return self;
    }
    
    BigInteger *bigInt = nil;
    @autoreleasepool {
        if (n < 0) {
            bigInt = [self shiftRightWithN:-n];
        } else {
            BigInteger *result = [[[BigInteger alloc] initWithSignum:self.sign withMag:[BigInteger shiftLeftWithMag:self.magnitude withN:n] withCheckMag:YES] autorelease];
            if (self.nBits != -1) {
                result.nBits = self.sign > 0 ? self.nBits : (self.nBits + n);
            }
            
            if ([self nBitLength] != -1) {
                result.nBitLength = [self nBitLength] + n;
            }
            bigInt = result;
        }
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

+ (void)shiftRightInPlaceWithStart:(int)start withMag:(NSMutableArray*)mag withN:(int)n {
    @autoreleasepool {
        int nInts = (int)((uint)n >> 5) + start;
        int nBits = n & 0x1f;
        int magEnd = (int)(mag.count) - 1;
        
        if (nInts != start) {
            int delta = (nInts - start);
            
            for (int i = magEnd; i >= nInts; i--) {
                mag[i] = mag[i - delta];
            }
            for (int i = nInts - 1; i >= start; i--) {
                mag[i] = @(0);
            }
        }
        
        if (nBits != 0) {
            int nBits2 = 32 - nBits;
            int m = [mag[magEnd] intValue];
            
            for (int i = magEnd; i > nInts; --i) {
                int next = [mag[i - 1] intValue];
                
                mag[i] = @((int)((int)((uint)m >> nBits) | (next << nBits2)));
                m = next;
            }
            
            mag[nInts] = @((int)([mag[nInts] unsignedIntValue] >> nBits));
        }
    }
}

+ (void)shiftRightOneInPlaceWithStart:(int)start withMag:(NSMutableArray*)mag {
    @autoreleasepool {
        int i = (int)(mag.count);
        int m = [mag[i - 1] intValue];
        
        while (--i > start) {
            int next = [mag[i - 1] intValue];
            mag[i] = @((int)(((int)((uint)m >> 1)) | (next << 31)));
            m = next;
        }
        
        mag[start] = @((int)([mag[start] unsignedIntValue] >> 1));
    }
}

- (BigInteger*)shiftRightWithN:(int)n {
    if (n == 0) {
        return self;
    }
    
    BigInteger *retVal = nil;
    @autoreleasepool {
        if (n < 0) {
            retVal = [self shiftLeftWithN:-n];
        } else {
            if (n >= [self bitLength]) {
                retVal = (self.sign < 0 ? [[BigInteger One] negate] : [BigInteger Zero]);
            } else {
                int resultLength = ([self bitLength] - n + 31) >> 5;
                NSMutableArray *res = [[NSMutableArray alloc] initWithSize:resultLength];           // int[]
                
                int numInts = n >> 5;
                int numBits = n & 31;
                
                if (numBits == 0) {
                    [res copyFromIndex:0 withSource:self.magnitude withSourceIndex:0 withLength:res.fixedSize];
                } else {
                    int numBits2 = 32 - numBits;
                    
                    int magPos = (int)(self.magnitude.count) - 1 - numInts;
                    for (int i = resultLength - 1; i >= 0; --i) {
                        res[i] = @((int)([self.magnitude[magPos--] unsignedIntValue] >> numBits));
                        if (magPos >= 0) {
                            res[i] = @((int)([res[i] intValue] | ([self.magnitude[magPos] intValue] << numBits2)));
                        }
                    }
                }
                
                retVal = [[[BigInteger alloc] initWithSignum:self.sign withMag:res withCheckMag:NO] autorelease];
#if !__has_feature(objc_arc)
                if (res != nil) [res release]; res = nil;
#endif
            }
        }
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (int)signValue {
    return self.sign;
}

/**
 * returns x = x - y - we assume x is >= y
 */
+ (NSMutableArray*)subtractWithXstart:(int)xStart withX:(NSMutableArray*)x withYstart:(int)yStart withY:(NSMutableArray*)y {
    @autoreleasepool {
        int iT = (int)(x.count);
        int iV = (int)(y.count);
        int64_t m;
        int borrow = 0;
        
        do {
            m = ([x[--iT] intValue] & IMASK) - ([y[--iV] intValue] & IMASK) + borrow;
            x[iT] = @((int)m);
            
            borrow = (int)(m >> 63);
        }
        while (iV > yStart);
        
        if (borrow != 0) {
            int pos = --iT;
            x[pos] = @([x[pos] intValue] - 1);
            while ([x[pos] intValue] == -1) {
                pos = --iT;
                x[pos] = @([x[pos] intValue] - 1);
            }
        }
    }
    return x;
}

- (BigInteger*)subtractWithN:(BigInteger*)n {
    if (n.sign == 0) {
        return self;
    }
    
    BigInteger *bigInt = nil;
    @autoreleasepool {
        if (self.sign == 0) {
            bigInt = [n negate];
        } else {
            if (self.sign != n.sign) {
                bigInt = [self addWithValue:[n negate]];
            } else {
                int compare = [BigInteger compareNoLeadingZeroesWithXindx:0 withX:self.magnitude withYindx:0 withY:n.magnitude];
                if (compare == 0) {
                    bigInt = [BigInteger Zero];
                } else {
                    BigInteger *bigun, *lilun;
                    if (compare < 0) {
                        bigun = n;
                        lilun = self;
                    } else {
                        bigun = self;
                        lilun = n;
                    }
                    bigInt = [[[BigInteger alloc] initWithSignum:(self.sign * compare) withMag:[BigInteger doSubBigLilWithBigMag:bigun.magnitude withLilMag:lilun.magnitude] withCheckMag:YES] autorelease];
                }
            }
        }
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

+ (NSMutableArray*)doSubBigLilWithBigMag:(NSMutableArray*)bigMag withLilMag:(NSMutableArray*)lilMag {
    NSMutableArray *retArray = nil;
    @autoreleasepool {
        NSMutableArray *res = [bigMag clone];
        retArray = [BigInteger subtractWithXstart:0 withX:res withYstart:0 withY:lilMag];
        [retArray retain];
#if !__has_feature(objc_arc)
        if (res) [res release]; res = nil;
#endif
    }
    return (retArray ? [retArray autorelease] : nil);
}

- (NSMutableData*)toByteArray {
    return [self toByteArrayWithUnsignedStyle:NO];
}

- (NSMutableData*)toByteArrayUnsigned {
    return [self toByteArrayWithUnsignedStyle:YES];
}

- (NSMutableData*)toByteArrayWithUnsignedStyle:(BOOL)unsignedStyle {
    if (self.sign == 0) {
        return unsignedStyle ? [BigInteger ZeroEncoding] : [[[NSMutableData alloc] initWithSize:1] autorelease];
    }
    
    int nBits = (unsignedStyle && self.sign > 0) ? [self bitLength] : ([self bitLength] + 1);
    
    int nBytes = [BigInteger getByteLength:nBits];
    NSMutableData *bytes = [[NSMutableData alloc] initWithSize:nBytes];
    @autoreleasepool {
        int magIndex = (int)(self.magnitude.count);
        int bytesIndex = bytes.fixedSize;
        
        if (self.sign > 0) {
            while (magIndex > 1) {
                uint mag = [self.magnitude[--magIndex] unsignedIntValue];
                ((Byte*)(bytes.bytes))[--bytesIndex] = (Byte)mag;
                ((Byte*)(bytes.bytes))[--bytesIndex] = (Byte)(mag >> 8);
                ((Byte*)(bytes.bytes))[--bytesIndex] = (Byte)(mag >> 16);
                ((Byte*)(bytes.bytes))[--bytesIndex] = (Byte)(mag >> 24);
            }
            
            uint lastMag = [self.magnitude[0] unsignedIntValue];
            while (lastMag > 225) {
                ((Byte*)(bytes.bytes))[--bytesIndex] = (Byte)lastMag;
                lastMag >>= 8;
            }
            ((Byte*)(bytes.bytes))[--bytesIndex] = (Byte)lastMag;
        } else { // sign < 0
            BOOL carry = YES;
            while (magIndex > 1) {
                uint mag = ~([self.magnitude[--magIndex] unsignedIntValue]);
                if (carry) {
                    carry = (++mag == UINT_MAX);
                }
                ((Byte*)(bytes.bytes))[--bytesIndex] = (Byte) mag;
                ((Byte*)(bytes.bytes))[--bytesIndex] = (Byte)(mag >> 8);
                ((Byte*)(bytes.bytes))[--bytesIndex] = (Byte)(mag >> 16);
                ((Byte*)(bytes.bytes))[--bytesIndex] = (Byte)(mag >> 24);
            }
            uint lastMag = [self.magnitude[0] unsignedIntValue];
            if (carry) {
                // Never wraps because magnitude[0] != 0
                --lastMag;
            }
            
            while (lastMag > 255) {
                ((Byte*)(bytes.bytes))[--bytesIndex] = (Byte)~lastMag;
                lastMag >>= 8;
            }
            
            ((Byte*)(bytes.bytes))[--bytesIndex] = (Byte)~lastMag;
            
            if (bytesIndex > 0) {
                ((Byte*)(bytes.bytes))[--bytesIndex] = 255;
            }
        }
    }
    return (bytes ? [bytes autorelease] : nil);
}

- (NSString*)toString {
    return [self toStringWithRadix:10];
}

- (NSString*)toStringWithRadix:(int)radix {
    // TODO Make this method work for other radices (ideally 2 <= radix <= 36 as in Java)
    switch (radix) {
        case 2:
        case 8:
        case 10:
        case 16: {
            break;
        }
        default: {
            @throw [NSException exceptionWithName:@"Format" reason:@"Only bases 2, 8, 10, 16 are allowed" userInfo:nil];
        }
    }
    
    // NB: Can only happen to internally managed instances
    if (self.magnitude == nil) {
        return @"nil";
    }
    
    if (self.sign == 0) {
        return @"0";
    }
    
    // NOTE: This *should* be unnecessary, since the magnitude *should* never have leading zero digits
    int firstNonZero = 0;
    @autoreleasepool {
        while (firstNonZero < self.magnitude.count) {
            if ([self.magnitude[firstNonZero] intValue] != 0) {
                break;
            }
            ++firstNonZero;
        }
    }
    
    if (firstNonZero == self.magnitude.count) {
        return @"0";
    }
    
    NSMutableString *mts = [[[NSMutableString alloc] init] autorelease];
    @autoreleasepool {
        if (self.sign == -1) {
            [mts appendString:@"-"];
        }
        
        switch (radix) {
            case 2: {
                int pos = firstNonZero;
                [mts appendString:[self.magnitude[pos] binaryString]];
                while (++pos < self.magnitude.count) {
                    [BigInteger appendZeroExtendedStringWithMutStr:mts withS:[self.magnitude[pos] binaryString] withMinLength:32];
                }
                break;
            }
            case 8: {
                int mask = (1 << 30) - 1;
                BigInteger *u = [self abs];
                int bits = [u bitLength];
                NSMutableArray *s = [[NSMutableArray alloc] init];
                while (bits > 30) {
                    [s addObject:[NSString stringWithFormat:@"%o", ([u intValue] & mask)]];
                    u = [u shiftRightWithN:30];
                    bits -= 30;
                }
                [mts appendString:[NSString stringWithFormat:@"%o", [u intValue]]];
                for (int i = (int)(s.count) - 1; i >= 0; --i) {
                    [BigInteger appendZeroExtendedStringWithMutStr:mts withS:s[i] withMinLength:10];
                }
#if !__has_feature(objc_arc)
                if (s != nil) [s release]; s = nil;
#endif
                break;
            }
            case 16: {
                int pos = firstNonZero;
                [mts appendString:[NSString stringWithFormat:@"%x", [self.magnitude[pos] intValue]]];
                while (++pos < self.magnitude.count) {
                    [BigInteger appendZeroExtendedStringWithMutStr:mts withS:[NSString stringWithFormat:@"%x", [self.magnitude[pos] intValue]] withMinLength:8];
                }
                break;
            }
            case 10: {
                BigInteger *q = [self abs];
                if ([q bitLength] < 64) {
                    [mts appendString:[NSString stringWithFormat:@"%lld", [q longValue]]];
                    break;
                }
                
                // Based on algorithm 1a from chapter 4.4 in Seminumerical Algorithms (Knuth)
                
                // Work out the largest power of 'rdx' that is a positive 64-bit integer
                // TODO possibly cache power/exponent against radix?
                int64_t limit = INT64_MAX / radix;
                int64_t power = radix;
                int exponent = 1;
                while (power <= limit) {
                    power *= radix;
                    ++exponent;
                }
                
                BigInteger *bigPower = [BigInteger valueOf:power];
                
                NSMutableArray *s = [[NSMutableArray alloc] init];
                while ([q compareToWithValue:bigPower] >= 0) {
                    NSMutableArray *qr = [q divideAndRemainderWithVal:bigPower];
                    [s addObject:[NSString stringWithFormat:@"%lld", [(BigInteger*)qr[1] longValue]]];
                    q = qr[0];
                }
                [mts appendString:[NSString stringWithFormat:@"%lld", [q longValue]]];
                for (int i = (int)(s.count) - 1; i >= 0; --i) {
                    [BigInteger appendZeroExtendedStringWithMutStr:mts withS:(NSString*)s[i] withMinLength:exponent];
                }
#if !__has_feature(objc_arc)
                if (s != nil) [s release]; s = nil;
#endif
                break;
            }
        }
    }
    
    return mts;
}

+ (void)appendZeroExtendedStringWithMutStr:(NSMutableString*)mutStr withS:(NSString*)s withMinLength:(int)minLength {
    @autoreleasepool {
        for (int len = (int)(s.length); len < minLength; ++len) {
            [mutStr appendString:@"0"];
        }
    }
    [mutStr appendString:s];
}

+ (BigInteger*)createUValueOf:(uint64_t)value {
    int msw = (int)(value >> 32);
    int lsw = (int)value;
    
    BigInteger *bigInt = nil;
    @autoreleasepool {
        if (msw != 0) {
            bigInt = [[[BigInteger alloc] initWithSignum:1 withMag:[NSMutableArray arrayWithObjects:@(msw), @(lsw), nil] withCheckMag:NO] autorelease];
        } else {
            if (lsw != 0) {
                BigInteger *n = [[[BigInteger alloc] initWithSignum:1 withMag:[NSMutableArray arrayWithObjects:@(lsw), nil] withCheckMag:NO] autorelease];
                // Check for a power of two
                if ((lsw & -lsw) == lsw) {
                    n.nBits = 1;
                }
                bigInt = n;
            } else {
                bigInt = [BigInteger Zero];
            }
        }
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

+ (BigInteger*)createValueOf:(int64_t)value {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        if (value < 0) {
            if (value == LONG_MIN) {
                bigInt = [[BigInteger createValueOf:(~value)] Not];
            } else {
                bigInt = [[BigInteger createValueOf:(-value)] negate];
            }
        } else {
            bigInt = [BigInteger createUValueOf:(uint64_t)value];
        }
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

+ (BigInteger*)valueOf:(int64_t)value {
    if (value >= 0 && value < [[BigInteger SMALL_CONSTANTS] count]) {
        return (BigInteger*)([BigInteger SMALL_CONSTANTS][(int)value]);
    }
    return [BigInteger createValueOf:value];
}

- (int)getLowestSetBit {
    if (self.sign == 0) {
        return -1;
    }
    return [self getLowestSetBitMaskFirstWithFirstWordMask:-1];
}

- (int)getLowestSetBitMaskFirstWithFirstWordMask:(int)firstWordMask {
    int w = (int)(self.magnitude.count), offset = 0;
    @autoreleasepool {
        uint word = (uint)([self.magnitude[--w] intValue] & firstWordMask);
        
        while (word == 0) {
            word = [self.magnitude[--w] unsignedIntValue];
            offset += 32;
        }
        
        while ((word & 0xFF) == 0) {
            word >>= 8;
            offset += 8;
        }
        
        while ((word & 1) == 0) {
            word >>= 1;
            ++offset;
        }
    }
    return offset;
}

- (BOOL)testBitWithN:(int)n {
    if (n < 0) {
        @throw [NSException exceptionWithName:@"Arithmetic" reason:@"Bit position must not be negative" userInfo:nil];
    }
    
    BOOL retVal = NO;
    @autoreleasepool {
        if (self.sign < 0) {
            retVal = ![[self Not] testBitWithN:n];
        } else {
            int wordNum = n / 32;
            if (wordNum >= self.magnitude.count) {
                retVal = NO;
            } else {
                int word = [self.magnitude[self.magnitude.count - 1 - wordNum] intValue];
                retVal = ((word >> (n % 32)) & 1) > 0;
            }
        }
    }
    return retVal;
}

- (BigInteger*)orWithValue:(BigInteger*)value {
    if (self.sign == 0) {
        return value;
    }
    
    if (value.sign == 0) {
        return self;
    }
    
    BigInteger *bigInt = nil;
    @autoreleasepool {
        NSMutableArray *aMag = self.sign > 0 ? self.magnitude : [[self addWithValue:[BigInteger One]] magnitude];
        NSMutableArray *bMag = value.sign > 0 ? value.magnitude : [[value addWithValue:[BigInteger One]] magnitude];
        
        BOOL resultNeg = self.sign < 0 || value.sign < 0;
        int resultLength =  MAX((int)(aMag.count), (int)(bMag.count));
        NSMutableArray *resultMag = [[NSMutableArray alloc] initWithSize:resultLength];
        
        int aStart = (int)(resultMag.fixedSize) - (int)(aMag.count);
        int bStart = (int)(resultMag.fixedSize) - (int)(bMag.count);
        
        for (int i = 0; i < resultMag.count; ++i) {
            int aWord = i >= aStart ? [aMag[i - aStart] intValue] : 0;
            int bWord = i >= bStart ? [bMag[i - bStart] intValue] : 0;
            
            if (self.sign < 0) {
                aWord = ~aWord;
            }
            
            if (value.sign < 0) {
                bWord = ~bWord;
            }
            
            resultMag[i] = @((int)(aWord | bWord));
            
            if (resultNeg) {
                resultMag[i] = @((int)(~[resultMag[i] intValue]));
            }
        }
        
        BigInteger *result = [[[BigInteger alloc] initWithSignum:1 withMag:resultMag withCheckMag:YES] autorelease];
#if !__has_feature(objc_arc)
        if (resultMag != nil) [resultMag release]; resultMag = nil;
#endif
        // TODO Optimise this case
        if (resultNeg) {
            result = [result Not];
        }
        bigInt = result;
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BigInteger*)xorWithValue:(BigInteger*)value {
    if (self.sign == 0) {
        return value;
    }
    
    if (value.sign == 0) {
        return self;
    }
    
    BigInteger *bigInt = nil;
    @autoreleasepool {
        NSMutableArray *aMag = self.sign > 0 ? self.magnitude : [[self addWithValue:[BigInteger One]] magnitude];
        NSMutableArray *bMag = value.sign > 0 ? value.magnitude : [[value addWithValue:[BigInteger One]] magnitude];
        
        // TODO Can just replace with sign != value.sign?
        BOOL resultNeg = (self.sign < 0 && value.sign >= 0) || (self.sign >= 0 && value.sign < 0);
        int resultLength = MAX((int)(aMag.count), (int)(bMag.count));
        NSMutableArray *resultMag = [[NSMutableArray alloc] initWithSize:resultLength];
        
        int aStart = (int)(resultMag.fixedSize) - (int)(aMag.count);
        int bStart = (int)(resultMag.fixedSize) - (int)(bMag.count);
        
        for (int i = 0; i < resultMag.count; ++i) {
            int aWord = i >= aStart ? [aMag[i - aStart] intValue] : 0;
            int bWord = i >= bStart ? [bMag[i - bStart] intValue] : 0;
            
            if (self.sign < 0) {
                aWord = ~aWord;
            }
            
            if (value.sign < 0) {
                bWord = ~bWord;
            }
            
            resultMag[i] = @((int)(aWord | bWord));
            
            if (resultNeg) {
                resultMag[i] = @((int)(~[resultMag[i] intValue]));
            }
        }
        
        BigInteger *result = [[[BigInteger alloc] initWithSignum:1 withMag:resultMag withCheckMag:YES] autorelease];
#if !__has_feature(objc_arc)
        if (resultMag != nil) [resultMag release]; resultMag = nil;
#endif
        
        // TODO Optimise this case
        if (resultNeg) {
            result = [result Not];
        }
        bigInt = result;
        [bigInt retain];
    }
    
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BigInteger*)setBitWithN:(int)n {
    if (n < 0) {
        @throw [NSException exceptionWithName:@"Arithmetic" reason:@"Bit address less than zero" userInfo:nil];
    }
    
    if ([self testBitWithN:n]) {
        return self;
    }
    
    BigInteger *bigInt = nil;
    @autoreleasepool {
        // TODO Handle negative values and zero
        if (self.sign > 0 && n < ([self bitLength] - 1)) {
            bigInt = [self flipExistingBitWithN:n];
        } else {
            bigInt = [self orWithValue:[[BigInteger One] shiftLeftWithN:n]];
        }
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BigInteger*)clearBitWithN:(int)n {
    if (n < 0) {
        @throw [NSException exceptionWithName:@"Arithmetic" reason:@"Bit address less than zero" userInfo:nil];
    }
    
    if (![self testBitWithN:n]) {
        return self;
    }
    
    BigInteger *bigInt = nil;
    @autoreleasepool {
        // TODO Handle negative values
        if (self.sign > 0 && n < ([self bitLength] - 1)) {
            bigInt = [self flipExistingBitWithN:n];
        } else {
            bigInt = [self andNotWithVal:[[BigInteger One] shiftLeftWithN:n]];
        }
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BigInteger*)flipBitWithN:(int)n {
    if (n < 0) {
         @throw [NSException exceptionWithName:@"Arithmetic" reason:@"Bit address less than zero" userInfo:nil];
    }
    
    BigInteger *bigInt = nil;
    @autoreleasepool {
        // TODO Handle negative values and zero
        if (self.sign > 0 && n < ([self bitLength] - 1)) {
            bigInt = [self flipExistingBitWithN:n];
        } else {
            bigInt = [self xorWithValue:[[BigInteger One] shiftLeftWithN:n]];
        }
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BigInteger*)flipExistingBitWithN:(int)n {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        NSMutableArray *mag = [[self magnitude] clone];
        mag[mag.count - 1 - (n >> 5)] = @((int)([mag[mag.count - 1 - (n >> 5)] intValue] ^ (1 << (n & 31)))); // Flip bit
        //mag[mag.count - 1 - (n / 32)] ^= (1 << (n % 32));
        bigInt = [[BigInteger alloc] initWithSignum:self.sign withMag:mag withCheckMag:NO];
#if !__has_feature(objc_arc)
        if (mag) [mag release]; mag = nil;
#endif
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

@end
