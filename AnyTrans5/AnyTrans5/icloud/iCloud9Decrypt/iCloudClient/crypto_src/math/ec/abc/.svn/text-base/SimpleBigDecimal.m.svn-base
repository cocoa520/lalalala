//
//  SimpleBigDecimal.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "SimpleBigDecimal.h"
#import "BigInteger.h"

@interface SimpleBigDecimal ()

@property (nonatomic, readwrite, retain) BigInteger *bigInt;
@property (nonatomic, readwrite, assign) int scale;

@end

@implementation SimpleBigDecimal
@synthesize bigInt = _bigInt;
@synthesize scale = _scale;

/**
 * Returns a <code>SimpleBigDecimal</code> representing the same numerical
 * value as <code>value</code>.
 * @param value The value of the <code>SimpleBigDecimal</code> to be
 * created.
 * @param scale The scale of the <code>SimpleBigDecimal</code> to be
 * created.
 * @return The such created <code>SimpleBigDecimal</code>.
 */
+ (SimpleBigDecimal*)getInstance:(BigInteger*)val withScale:(int)scale {
    return [[[SimpleBigDecimal alloc] initWithBigInt:val withScale:scale] autorelease];
}

/**
 * Constructor for <code>SimpleBigDecimal</code>. The value of the
 * constructed <code>SimpleBigDecimal</code> Equals <code>bigInt /
 * 2<sup>scale</sup></code>.
 * @param bigInt The <code>bigInt</code> value parameter.
 * @param scale The scale of the constructed <code>SimpleBigDecimal</code>.
 */
- (id)initWithBigInt:(BigInteger*)bigInt withScale:(int)scale {
    if (self = [super init]) {
        if (scale < 0) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"scale may not be negative" userInfo:nil];
        }
        [self setBigInt:bigInt];
        [self setScale:scale];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithLimBigDec:(SimpleBigDecimal*)limBigDec {
    if (self = [super init]) {
        [self setBigInt:limBigDec.bigInt];
        [self setScale:limBigDec.scale];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setBigInt:nil];
    [super dealloc];
#endif
}

- (void)checkScale:(SimpleBigDecimal*)b {
    if (self.scale != b.scale) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"Only SimpleBigDecimal of same scale allowed in arithmetic operations" userInfo:nil];
    }
}

- (SimpleBigDecimal*)adjustScale:(int)newScale {
    if (newScale < 0) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"scale may not be negative" userInfo:nil];
    }
    
    if (newScale == self.scale) {
        return self;
    }
    
    SimpleBigDecimal *retVal = nil;
    @autoreleasepool {
        retVal = [[SimpleBigDecimal alloc] initWithBigInt:[self.bigInt shiftLeftWithN:(newScale - self.scale)] withScale:newScale];
    }
    return (retVal ? [retVal autorelease] :nil);
}

- (SimpleBigDecimal*)addWithSimpleBigDecimal:(SimpleBigDecimal*)b {
    SimpleBigDecimal *retVal = nil;
    @autoreleasepool {
        [self checkScale:b];
        retVal = [[SimpleBigDecimal alloc] initWithBigInt:[self.bigInt addWithValue:b.bigInt] withScale:self.scale];
    }
    return (retVal ? [retVal autorelease] :nil);
}

- (SimpleBigDecimal*)addWithBigInteger:(BigInteger*)b {
    SimpleBigDecimal *retVal = nil;
    @autoreleasepool {
        retVal = [[SimpleBigDecimal alloc] initWithBigInt:[self.bigInt addWithValue:[b shiftLeftWithN:self.scale]] withScale:self.scale];
    }
    return (retVal ? [retVal autorelease] :nil);
}

- (SimpleBigDecimal*)negate {
    SimpleBigDecimal *retVal = nil;
    @autoreleasepool {
        retVal = [[SimpleBigDecimal alloc] initWithBigInt:[self.bigInt negate] withScale:self.scale];
    }
    return (retVal ? [retVal autorelease] :nil);
}

- (SimpleBigDecimal*)subtractWithSimpleBigDecimal:(SimpleBigDecimal*)b {
    SimpleBigDecimal *retVal = nil;
    @autoreleasepool {
        retVal = [self addWithSimpleBigDecimal:[b negate]];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] :nil);
}

- (SimpleBigDecimal*)subtractWithBigInteger:(BigInteger*)b {
    SimpleBigDecimal *retVal = nil;
    @autoreleasepool {
        retVal = [[SimpleBigDecimal alloc] initWithBigInt:[self.bigInt subtractWithN:[b shiftLeftWithN:self.scale]] withScale:self.scale];
    }
    return (retVal ? [retVal autorelease] :nil);
}

- (SimpleBigDecimal*)multiplyWithSimpleBigDecimal:(SimpleBigDecimal*)b {
    SimpleBigDecimal *retVal = nil;
    @autoreleasepool {
        [self checkScale:b];
        retVal = [[SimpleBigDecimal alloc] initWithBigInt:[self.bigInt multiplyWithVal:b.bigInt] withScale:(self.scale + self.scale)];
    }
    return (retVal ? [retVal autorelease] :nil);
}

- (SimpleBigDecimal*)multiplyWithBigInteger:(BigInteger*)b {
    SimpleBigDecimal *retVal = nil;
    @autoreleasepool {
        retVal = [[SimpleBigDecimal alloc] initWithBigInt:[self.bigInt multiplyWithVal:b] withScale:self.scale];
    }
    return (retVal ? [retVal autorelease] :nil);
}

- (SimpleBigDecimal*)divideWithSimpleBigDecimal:(SimpleBigDecimal*)b {
    SimpleBigDecimal *retVal = nil;
    @autoreleasepool {
        [self checkScale:b];
        BigInteger *dividend = [self.bigInt shiftLeftWithN:self.scale];
        retVal = [[SimpleBigDecimal alloc] initWithBigInt:[dividend divideWithVal:b.bigInt] withScale:self.scale];
    }
    return (retVal ? [retVal autorelease] :nil);
}

- (SimpleBigDecimal*)divideWithBigInteger:(BigInteger*)b {
    SimpleBigDecimal *retVal = nil;
    @autoreleasepool {
        retVal = [[SimpleBigDecimal alloc] initWithBigInt:[self.bigInt divideWithVal:b] withScale:self.scale];
    }
    return (retVal ? [retVal autorelease] :nil);
}

- (SimpleBigDecimal*)shiftLeft:(int)n {
    SimpleBigDecimal *retVal = nil;
    @autoreleasepool {
        retVal = [[SimpleBigDecimal alloc] initWithBigInt:[self.bigInt shiftLeftWithN:n] withScale:self.scale];
    }
    return (retVal ? [retVal autorelease] :nil);
}

- (int)compareToWithSimpleBigDecimal:(SimpleBigDecimal*)val {
    [self checkScale:val];
    return [self.bigInt compareToWithValue:val.bigInt];
}

- (int)compareToWithBigInteger:(BigInteger*)val {
    return [self.bigInt compareToWithValue:[val shiftLeftWithN:self.scale]];
}

- (BigInteger*)floor {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        bigInt = [self.bigInt shiftRightWithN:self.scale];
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BigInteger*)round {
    BigInteger *retVal = nil;
    @autoreleasepool {
        SimpleBigDecimal *oneHalf = [[SimpleBigDecimal alloc] initWithBigInt:[BigInteger One] withScale:1];
        retVal = [[self addWithSimpleBigDecimal:[oneHalf adjustScale:self.scale]] floor];
#if !__has_feature(objc_arc)
        if (oneHalf != nil) [oneHalf release]; oneHalf = nil;
#endif
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (int)intValue {
    return [[self floor] intValue];
}

- (int64_t)longValue {
    return [[self floor] longValue];
}

- (int)scale {
    return _scale;
}

- (NSString*)toString {
    NSString *returnStr = nil;
    @autoreleasepool {
        if (self.scale == 0) {
            [self.bigInt toString];
        }
        
        BigInteger *floorBigInt = [self floor];
        
        BigInteger *fract = [self.bigInt subtractWithN:[floorBigInt shiftLeftWithN:self.scale]];
        if ([self.bigInt signValue] < 0) {
            fract = [[[BigInteger One] shiftLeftWithN:self.scale] subtractWithN:fract];
        }
        
        if (([floorBigInt signValue] == -1) && (![fract isEqual:[BigInteger Zero]])) {
            floorBigInt = [floorBigInt addWithValue:[BigInteger One]];
        }
        NSString *leftOfPoint = [floorBigInt toString];
        
        NSMutableString *mStr = [[NSMutableString alloc] init];
        NSString *fractStr = [fract toStringWithRadix:2];
        int fractLen = (int)(fractStr.length);
        int zeroes = self.scale - fractLen;
        for (int i = 0; i < zeroes; i++) {
            [mStr appendString:@"0"];
        }
        [mStr appendString:fractStr];
        returnStr = [NSString stringWithFormat:@"%@.%@", leftOfPoint, mStr];
#if !__has_feature(objc_arc)
        if (mStr) [mStr release]; mStr = nil;
#endif
        [returnStr retain];
    }
    return (returnStr ? [returnStr autorelease] : nil);
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (object != nil && [object isKindOfClass:[SimpleBigDecimal class]]) {
        SimpleBigDecimal *other = (SimpleBigDecimal*)object;
        return [self.bigInt isEqual:other.bigInt] && self.scale == other.scale;
    } else {
        return NO;
    }
}

- (NSUInteger)hash {
    return [self.bigInt hash] ^ self.scale;
}

@end
