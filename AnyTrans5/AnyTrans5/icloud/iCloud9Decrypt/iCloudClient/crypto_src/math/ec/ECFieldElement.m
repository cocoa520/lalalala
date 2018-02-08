//
//  ECFieldElement.m
//  
//
//  Created by Pallas on 5/5/16.
//
//  Complete

#import "ECFieldElement.h"
#import "BigInteger.h"
#import "ECFieldElement.h"
#import "BigIntegers.h"
#import "Nat.h"
#import "Mod.h"
#import "LongArray.h"
#import "Arrays.h"

@implementation ECFieldElement

- (BigInteger*)toBigInteger {
    return nil;
}

- (NSString*)fieldName {
    return nil;
}

- (int)fieldSize {
    return 0;
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    return nil;
}

- (ECFieldElement*)addOne {
    return nil;
}

- (ECFieldElement*)subtract:(ECFieldElement*)b {
    return nil;
}

- (ECFieldElement*)multiply:(ECFieldElement*)b {
    return nil;
}

- (ECFieldElement*)divide:(ECFieldElement*)b {
    return nil;
}

- (ECFieldElement*)negate {
    return nil;
}

- (ECFieldElement*)square {
    return nil;
}

- (ECFieldElement*)invert {
    return nil;
}

- (ECFieldElement*)sqrt {
    return nil;
}

- (int)bitLength {
    return [[self toBigInteger] bitLength];
}

- (BOOL)isOne {
    return [self bitLength] == 1;
}

- (BOOL)isZero {
    return 0 == [[self toBigInteger] signValue];
}

- (ECFieldElement*)multiplyMinusProduct:(ECFieldElement*)b withX:(ECFieldElement*)x withY:(ECFieldElement*)y {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        retVal = [[self multiply:b] subtract:[x multiply:y]];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)multiplyPlusProduct:(ECFieldElement*)b withX:(ECFieldElement*)x withY:(ECFieldElement*)y {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        retVal = [[self multiply:b] add:[x multiply:y]];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)squareMinusProduct:(ECFieldElement*)x withY:(ECFieldElement*)y {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        retVal = [[self square] subtract:[x multiply:y]];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)squarePlusProduct:(ECFieldElement*)x withY:(ECFieldElement*)y {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        retVal = [[self square] add:[x multiply:y]];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)squarePow:(int)pow {
    ECFieldElement *r = nil;
    @autoreleasepool {
        r = self;
        for (int i = 0; i < pow; ++i) {
            r = [r square];
        }
        [r retain];
    }
    return (r ? [r autorelease] : nil);
}

- (BOOL)testBitZero {
    return [[self toBigInteger] testBitWithN:0];
}

- (BOOL)isEqual:(id)object {
    if (object && [object isKindOfClass:[ECFieldElement class]] ) {
        return [self equalsWithOther:(ECFieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [[self toBigInteger] isEqual:[other toBigInteger]];
}

- (NSUInteger)hash {
    return [[self toBigInteger] hash];
}

- (NSString*)toString {
    return [[self toBigInteger] toStringWithRadix:16];
}

- (NSMutableData*)getEncoded {
    NSMutableData *retData = nil;
    @autoreleasepool {
        retData = [BigIntegers asUnsignedByteArray:(int)(([self fieldSize] + 7) / 8) withN:[self toBigInteger]];
        [retData retain];
    }
    return [retData autorelease];
}

@end

@interface FpFieldElement ()

@property (nonatomic, readwrite, retain) BigInteger *q;
@property (nonatomic, readwrite, retain) BigInteger *r;
@property (nonatomic, readwrite, retain) BigInteger *x;

@end

@implementation FpFieldElement
@synthesize q = _q;
@synthesize r = _r;
@synthesize x = _x;

+ (BigInteger*)calculateResidue:(BigInteger*)p {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        int bitLength = [p bitLength];
        if (bitLength >= 96) {
            BigInteger *firstWord = [p shiftRightWithN:(bitLength - 64)];
            if ([firstWord longValue] == -1L) {
                bigInt = [[[BigInteger One] shiftLeftWithN:bitLength] subtractWithN:p];
            } else if ((bitLength & 7) == 0) {
                bigInt = [[[[BigInteger One] shiftLeftWithN:(int)(bitLength << 1)] divideWithVal:p] negate];
            }
        }
        bigInt ? [bigInt retain] : nil;
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (id)initWithQ:(BigInteger*)q withX:(BigInteger*)x {
    if (self = [self initWithQ:q withR:[FpFieldElement calculateResidue:q] withX:x]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithQ:(BigInteger*)q withR:(BigInteger*)r withX:(BigInteger*)x {
    if (self = [super init]) {
        if (x == nil || [x signValue] < 0 || [x compareToWithValue:q] >= 0) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"value invalid in Fp field element" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setQ:q];
        [self setR:r];
        [self setX:x];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setQ:nil];
    [self setR:nil];
    [self setX:nil];
    [super dealloc];
#endif
}

- (BigInteger*)toBigInteger {
    return self.x;
}

/**
 * return the field name for this field.
 *
 * @return the string "Fp".
 */
- (NSString*)fieldName {
    return @"Fp";
}

- (int)fieldSize {
    return [self.q bitLength];
}

- (BigInteger*)Q {
    return self.q;
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    FpFieldElement *fpFE = nil;
    @autoreleasepool {
        fpFE = [[FpFieldElement alloc] initWithQ:self.q withR:self.r withX:[self modAdd:self.x withX2:[b toBigInteger]]];
    }
    return [fpFE autorelease];
}

- (ECFieldElement*)addOne {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        BigInteger *x2 = [self.x addWithValue:[BigInteger One]];
        if ([x2 compareToWithValue:self.q] == 0) {
            x2 = [BigInteger Zero];
        }
        retVal = [[FpFieldElement alloc] initWithQ:self.q withR:self.r withX:x2];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)subtract:(ECFieldElement*)b {
    FpFieldElement *fpFE = nil;
    @autoreleasepool {
        fpFE = [[FpFieldElement alloc] initWithQ:self.q withR:self.r withX:[self modSubtract:self.x withX2:[b toBigInteger]]];
    }
    return [fpFE autorelease];
}

- (ECFieldElement*)multiply:(ECFieldElement*)b {
    FpFieldElement *fpFE = nil;
    @autoreleasepool {
        fpFE = [[FpFieldElement alloc] initWithQ:self.q withR:self.r withX:[self modMult:self.x withX2:[b toBigInteger]]];
    }
    return [fpFE autorelease];
}

- (ECFieldElement *)multiplyMinusProduct:(ECFieldElement*)b withX:(ECFieldElement*)x withY:(ECFieldElement*)y {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        BigInteger *ax = self.x, *bx = [b toBigInteger], *xx = [x toBigInteger], *yx = [y toBigInteger];
        
        BigInteger *ab = [ax multiplyWithVal:bx];
        BigInteger *xy = [xx multiplyWithVal:yx];
        retVal = [[FpFieldElement alloc] initWithQ:self.q withR:self.r withX:[self modReduce:[ab subtractWithN:xy]]];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)multiplyPlusProduct:(ECFieldElement*)b withX:(ECFieldElement*)x withY:(ECFieldElement*)y {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        BigInteger *ax = self.x, *bx = [b toBigInteger], *xx = [x toBigInteger], *yx = [y toBigInteger];
        BigInteger *ab = [ax multiplyWithVal:bx];
        BigInteger *xy = [xx multiplyWithVal:yx];
        BigInteger *sum = [ab addWithValue:xy];
        if (self.r != nil && [self.r signValue] < 0 && [sum bitLength] > ([self.q bitLength] << 1)) {
            sum = [sum subtractWithN:[self.q shiftLeftWithN:[self.q bitLength]]];
        }
        retVal = [[FpFieldElement alloc] initWithQ:self.q withR:self.r withX:[self modReduce:sum]];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)divide:(ECFieldElement*)b {
    FpFieldElement *fpFE = nil;
    @autoreleasepool {
        fpFE = [[FpFieldElement alloc] initWithQ:self.q withR:self.r withX:[self modInverse:[b toBigInteger]]];
    }
    return [fpFE autorelease];
}

- (ECFieldElement*)negate {
    FpFieldElement *fpFE = nil;
    @autoreleasepool {
        fpFE = [[FpFieldElement alloc] initWithQ:self.q withR:self.r withX:[self.q subtractWithN:self.x]];
    }
    return [self.x signValue] == 0 ? self : [fpFE autorelease];
}

- (ECFieldElement *)square {
    FpFieldElement *fpFE = nil;
    @autoreleasepool {
        fpFE = [[FpFieldElement alloc] initWithQ:self.q withR:self.r withX:[self modMult:self.x withX2:self.x]];
    }
    return [fpFE autorelease];
}

- (ECFieldElement*)squareMinusProduct:(ECFieldElement*)x withY:(ECFieldElement*)y {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        BigInteger *ax = self.x, *xx = [x toBigInteger], *yx = [y toBigInteger];;
        BigInteger *aa = [ax multiplyWithVal:ax];
        BigInteger *xy = [xx multiplyWithVal:yx];
        retVal = [[FpFieldElement alloc] initWithQ:self.q withR:self.r withX:[self modReduce:[aa subtractWithN:xy]]];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)squarePlusProduct:(ECFieldElement*)x withY:(ECFieldElement*)y {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        BigInteger *ax = self.x, *xx = [x toBigInteger], *yx = [y toBigInteger];
        BigInteger *aa = [ax multiplyWithVal:ax];
        BigInteger *xy = [xx multiplyWithVal:yx];
        BigInteger *sum = [aa addWithValue:xy];
        if (self.r != nil && [self.r signValue] < 0 && [sum bitLength] > ([self.q bitLength] << 1)) {
            sum = [sum subtractWithN:[self.q shiftLeftWithN:[self.q bitLength]]];
        }
        retVal = [[FpFieldElement alloc] initWithQ:self.q withR:self.r withX:[self modReduce:sum]];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    // TODO Modular inversion can be faster for a (Generalized) Mersenne Prime.
    FpFieldElement *fpFE = nil;
    @autoreleasepool {
        fpFE = [[FpFieldElement alloc] initWithQ:self.q withR:self.r withX:[self modInverse:self.x]];
    }
    return [fpFE autorelease];
}

/**
 * return a sqrt root - the routine verifies that the calculation
 * returns the right value - if none exists it returns null.
 */

- (ECFieldElement *)sqrt {
    if ([self isZero] || [self isOne]) {
        return self;
    }
    
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        if (![self.q testBitWithN:0]) {
            @throw [NSException exceptionWithName:@"NotImplemented" reason:@"even value of q" userInfo:nil];
        }
        
        if ([self.q testBitWithN:1]) { // q == 4m + 3
            BigInteger *e = [[self.q shiftRightWithN:2] addWithValue:[BigInteger One]];
            FpFieldElement *fe = [[FpFieldElement alloc] initWithQ:self.q withR:self.r withX:[self.x modPowWithE:e withM:self.q]];
            retVal = [self checkSqrt:fe];
#if !__has_feature(objc_arc)
            if (fe) [fe release]; fe = nil;
#endif
        } else {
            if ([self.q testBitWithN:2]) { // q == 8m + 5
                BigInteger *t1 = [self.x modPowWithE:[self.q shiftRightWithN:3] withM:self.q];
                BigInteger *t2 = [self modMult:t1 withX2:self.x];
                BigInteger *t3 = [self modMult:t2 withX2:t1];
                
                if ([t3 isEqual:[BigInteger One]]) {
                    FpFieldElement *fe = [[FpFieldElement alloc] initWithQ:self.q withR:self.r withX:t2];
                    retVal = [self checkSqrt:fe];
#if !__has_feature(objc_arc)
                    if (fe) [fe release]; fe = nil;
#endif
                } else {
                    // TODO This is constant and could be precomputed
                    BigInteger *t4 = [[BigInteger Two] modPowWithE:[self.q shiftRightWithN:2] withM:self.q];
                    
                    BigInteger *y = [self modMult:t2 withX2:t4];
                    
                    FpFieldElement *fe = [[FpFieldElement alloc] initWithQ:self.q withR:self.r withX:y];
                    retVal = [self checkSqrt:fe];
#if !__has_feature(objc_arc)
                    if (fe) [fe release]; fe = nil;
#endif
                }
            } else {
                // q == 8m + 1
                BigInteger *legendreExponent = [self.q shiftRightWithN:1];
                if ([[self.x modPowWithE:legendreExponent withM:self.q] isEqual:[BigInteger One]]) {
                    BigInteger *X = self.x;
                    BigInteger *fourX = [self modDouble:[self modDouble:X]];
                    
                    BigInteger *k = [legendreExponent addWithValue:[BigInteger One]], *qMinusOne = [self.q subtractWithN:[BigInteger One]];
                    
                    BigInteger *U = nil, *V = nil;
                    do {
                        BigInteger *P = nil;
                        do {
                            P = [BigInteger arbitrary:[self.q bitLength]];
                        }
                        while ([P compareToWithValue:self.q] >= 0 || ![[[self modReduce:[[P multiplyWithVal:P] subtractWithN:fourX]] modPowWithE:legendreExponent withM:self.q] isEqual:qMinusOne]);
                        
                        NSMutableArray *result = [self lucasSequence:P withQ:X withK:k];
                        U = (BigInteger*)(result[0]);
                        V = (BigInteger*)(result[1]);
                        
                        if ([[self modMult:V withX2:V] isEqual:fourX]) {
                            retVal = [[[FpFieldElement alloc] initWithQ:self.q withR:self.r withX:[self modHalfAbs:V]] autorelease];
                        }
                    } while ([U isEqual:[BigInteger One]] || [U isEqual:qMinusOne]);
                }
            }
        }
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)checkSqrt:(ECFieldElement*)z {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        retVal = ([[z square] isEqual:self] ? z : nil);
        retVal ? [retVal retain] : nil;
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (NSMutableArray*)lucasSequence:(BigInteger*)P withQ:(BigInteger*)Q withK:(BigInteger*)k {
    // TODO Research and apply "common-multiplicand multiplication here"
    int n = [k bitLength];
    int s = [k getLowestSetBit];
    
    BigInteger *Uh = [BigInteger One];
    BigInteger *Vl = [BigInteger Two];
    
    @autoreleasepool {
        BigInteger *Vh = P;
        BigInteger *Ql = [BigInteger One];
        BigInteger *Qh = [BigInteger One];
        
        for (int j = n - 1; j >= s + 1; --j) {
            Ql = [self modMult:Ql withX2:Qh];
            
            if ([k testBitWithN:j]) {
                Qh = [self modMult:Ql withX2:Q];
                Uh = [self modMult:Uh withX2:Vh];
                Vl = [self modReduce:[[Vh multiplyWithVal:Vl] subtractWithN:[P multiplyWithVal:Ql]]];
                Vh = [self modReduce:[[Vh multiplyWithVal:Vh] subtractWithN:[Qh shiftLeftWithN:1]]];
            } else {
                Qh = Ql;
                Uh = [self modReduce:[[Uh multiplyWithVal:Vl] subtractWithN:Ql]];
                Vh = [self modReduce:[[Vh multiplyWithVal:Vl] subtractWithN:[P multiplyWithVal:Ql]]];
                Vl = [self modReduce:[[Vl multiplyWithVal:Vl] subtractWithN:[Ql shiftLeftWithN:1]]];
            }
        }
        
        Ql = [self modMult:Ql withX2:Qh];
        Qh = [self modMult:Ql withX2:Q];
        Uh = [self modReduce:[[Uh multiplyWithVal:Vl] subtractWithN:Ql]];
        Vl = [self modReduce:[[Vh multiplyWithVal:Vl] subtractWithN:[P multiplyWithVal:Ql]]];
        Ql = [self modMult:Ql withX2:Qh];
        
        for (int j = 1; j <= s; ++j) {
            Uh = [self modMult:Uh withX2:Vl];
            Vl = [self modReduce:[[Vl multiplyWithVal:Vl] subtractWithN:[Ql shiftLeftWithN:1]]];
            Ql = [self modMult:Ql withX2:Ql];
        }
        
        [Uh retain];
        [Vl retain];
    }
    
    NSMutableArray *retArray = [[[NSMutableArray alloc] initWithObjects:Uh, Vl, nil] autorelease];
#if !__has_feature(objc_arc)
    if (Uh) [Uh release]; Uh = nil;
    if (Vl) [Vl release]; Vl = nil;
#endif
    return retArray;
}

- (BigInteger*)modAdd:(BigInteger*)x1 withX2:(BigInteger*)x2 {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        BigInteger *x3 = [x1 addWithValue:x2];
        if ([x3 compareTo:self.q] >= 0) {
            x3 = [x3 subtractWithN:self.q];
        }
        bigInt = x3;
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BigInteger*)modDouble:(BigInteger*)x {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        BigInteger *_2x = [x shiftLeftWithN:1];
        if ([_2x compareTo:self.q] >= 0) {
            _2x = [_2x subtractWithN:self.q];
        }
        bigInt = _2x;
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BigInteger*)modHalf:(BigInteger*)x {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        if ([x testBitWithN:0]) {
            x = [self.q addWithValue:x];
        }
        bigInt = [x shiftRightWithN:1];
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BigInteger*)modHalfAbs:(BigInteger*)x {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        if ([x testBitWithN:0]) {
            x = [self.q subtractWithN:x];
        }
        bigInt = [x shiftRightWithN:1];
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BigInteger*)modInverse:(BigInteger*)x {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        int bits = [self fieldSize];
        int len = (bits + 31) >> 5;
        // NSMutableArray == uint[]
        NSMutableArray *p = [Nat fromBigInteger:bits withX:self.q];
        NSMutableArray *n = [Nat fromBigInteger:bits withX:x];
        NSMutableArray *z = [Nat create:len];
        
        [Mod invert:p withX:n withZ:z];
        bigInt = [Nat toBigInteger:len withX:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BigInteger*)modMult:(BigInteger*)x1 withX2:(BigInteger*)x2 {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        bigInt = [self modReduce:[x1 multiplyWithVal:x2]];
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BigInteger*)modReduce:(BigInteger*)x {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        if (self.r == nil) {
            x = [x modWithM:self.q];
        } else {
            BOOL negative = [x signValue] < 0;
            if (negative) {
                x = [x abs];
            }
            int qLen = [self.q bitLength];
            if ([self.r signValue] > 0) {
                BigInteger *qMod = [[BigInteger One] shiftLeftWithN:qLen];
                BOOL rIsOne = [self.r isEqual:[BigInteger One]];
                while ([x bitLength] > (qLen + 1)) {
                    BigInteger *u = [x shiftRightWithN:qLen];
                    BigInteger *v = [x remainderWithN:qMod];
                    if (!rIsOne) {
                        u = [u multiplyWithVal:self.r];
                    }
                    x = [u addWithValue:v];
                }
            } else {
                int d = ((qLen - 1) & 31) + 1;
                BigInteger *mu = [self.r negate];
                BigInteger *u = [mu multiplyWithVal:[x shiftRightWithN:(qLen - d)]];
                BigInteger *quot = [u shiftRightWithN:(qLen + d)];
                BigInteger *v = [quot multiplyWithVal:self.q];
                BigInteger *bk1 = [[BigInteger One] shiftLeftWithN:(qLen + d)];
                v = [v remainderWithN:bk1];
                x = [x remainderWithN:bk1];
                x = [x subtractWithN:v];
                if ([x signValue] < 0) {
                    x = [x addWithValue:bk1];
                }
            }
            while ([x compareToWithValue:self.q] >= 0) {
                x = [x subtractWithN:self.q];
            }
            if (negative && [x signValue] != 0) {
                x = [self.q subtractWithN:x];
            }
        }
        bigInt = x;
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BigInteger*)modSubtract:(BigInteger*)x1 withX2:(BigInteger*)x2 {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        BigInteger *x3 = [x1 subtractWithN:x2];
        if ([x3 signValue] < 0) {
            x3 = [x3 addWithValue:self.q];
        }
        bigInt = x3;
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if (object && [object isKindOfClass:[FpFieldElement class]]) {
        FpFieldElement *other = (FpFieldElement*)object;
        return [self equalsWithFpOther:other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithFpOther:(FpFieldElement*)other {
    return [self.q isEqual:[other q]] && [super equalsWithOther:other];
}

- (NSUInteger)hash {
    return [self.q hash] ^ [super hash];
}

@end

@interface F2mFieldElement ()

@property (nonatomic, readwrite, assign) int representation;
@property (nonatomic, readwrite, assign) int m;
@property (nonatomic, readwrite, retain) NSMutableArray *ks;
@property (nonatomic, readwrite, retain) LongArray *x;

@end

@implementation F2mFieldElement
@synthesize representation = _representation;
@synthesize m = _m;
@synthesize ks = _ks;
@synthesize x = _x;

/**
 * Constructor for Ppb.
 * @param m  The exponent m of F2m.
 * * @param k1 The integer <code>k1</code> where <code>x<sup>m</sup> +
 * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
 * represents the reduction polynomial <code>f(z)</code>.
 * @param k2 The integer <code>k2</code> where <code>x<sup>m</sup> +
 * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
 * represents the reduction polynomial <code>f(z)</code>.
 * @param k3 The integer <code>k3</code> where <code>x<sup>m</sup> +
 * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
 * represents the reduction polynomial <code>f(z)</code>.
 * @param x The BigInteger representing the value of the field element.
 */
- (id)initWithM:(int)m withK1:(int)k1 withK2:(int)k2 withK3:(int)k3 withX:(BigInteger*)x {
    if (self = [super init]) {
        if (x == nil || [x signValue] < 0 || [x bitLength] > m) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid in F2m field element" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        
        @autoreleasepool {
            NSMutableArray *tmpArray = nil;
            if ((k2 == 0) && (k3 == 0)) {
                [self setRepresentation:Tpb];
                tmpArray = [[NSMutableArray alloc] initWithObjects:@(k1), nil];
                [self setKs:tmpArray];
#if !__has_feature(objc_arc)
                if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
            } else {
                if (k2 >= k3) {
                    @throw [NSException exceptionWithName:@"Argument" reason:@"k2 must be smaller than k3" userInfo:nil];
                }
                if (k2 <= 0) {
                    @throw [NSException exceptionWithName:@"Argument" reason:@"k2 must be larger than 0" userInfo:nil];
                }
                [self setRepresentation:Ppb];
                tmpArray = [[NSMutableArray alloc] initWithObjects:@(k1), @(k2), @(k3), nil];
                [self setKs:tmpArray];
#if !__has_feature(objc_arc)
                if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
            }
            [self setM:m];
            LongArray *tmpLongArray = [[LongArray alloc] initWithBigInt:x];
            [self setX:tmpLongArray];
#if !__has_feature(objc_arc)
            if (tmpLongArray != nil) [tmpLongArray release]; tmpLongArray = nil;
#endif
        }
        return self;
    } else {
        return nil;
    }
}

/**
 * Constructor for Tpb.
 * @param m  The exponent m of F2m.
 * @param k The integer <code>k</code> where <code>x<sup>m</sup> +
 * x<sup>k</sup> + 1</code> represents the reduction
 * polynomial <code>f(z)</code>.
 * @param x The BigInteger representing the value of the field element.
 */
- (id)initWithM:(int)m withK:(int)k withX:(BigInteger*)x {
    if (self = [self initWithM:m withK1:k withK2:0 withK3:0 withX:x]) {
        return self;
    } else {
        return nil;
    }
}

// ks == int[]
- (id)initWithM:(int)m withKs:(NSMutableArray*)ks withX:(LongArray*)x {
    if (self = [super init]) {
        [self setM:m];
        [self setRepresentation:(ks.count == 1 ? Tpb : Ppb)];
        [self setKs:ks];
        [self setX:x];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setKs:nil];
    [self setX:nil];
    [super dealloc];
#endif
}

- (int)bitLength {
    return [self.x degree];
}

- (BOOL)isOne {
    return [self.x isOne];
}

- (BOOL)isZero {
    return [self.x isZero];
}

- (BOOL)testBitZero {
    return [self.x testBitZero];
}

- (BigInteger*)toBigInteger {
    return [self.x toBigInteger];
}

- (NSString*)fieldName {
    return @"F2m";
}

- (int)fieldSize {
    return self.m;
}

/**
 * Checks, if the ECFieldElements <code>a</code> and <code>b</code>
 * are elements of the same field <code>F<sub>2<sup>m</sup></sub></code>
 * (having the same representation).
 * @param a field element.
 * @param b field element to be compared.
 * @throws ArgumentException if <code>a</code> and <code>b</code>
 * are not elements of the same field
 * <code>F<sub>2<sup>m</sup></sub></code> (having the same
 * representation).
 */
+ (void)checkFieldElements:(ECFieldElement*)a withB:(ECFieldElement*)b {
    if (![a isKindOfClass:[F2mFieldElement class]] || ![b isKindOfClass:[F2mFieldElement class]]) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"Field elements are not both instances of F2mFieldElement" userInfo:nil];
    }
    
    F2mFieldElement *aF2m = (F2mFieldElement*)a;
    F2mFieldElement *bF2m = (F2mFieldElement*)b;
    
    if (aF2m.representation != bF2m.representation) {
        // Should never occur
        @throw [NSException exceptionWithName:@"Argument" reason:@"One of the F2m field elements has incorrect representation" userInfo:nil];
    }
    
    if ((aF2m.m != bF2m.m) || ![aF2m.ks isEqualToArray:bF2m.ks]) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"Field elements are not elements of the same field F2m" userInfo:nil];
    }

}

- (ECFieldElement*)add:(ECFieldElement*)b {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        // No check performed here for performance reasons. Instead the
        // elements involved are checked in ECPoint.F2m
        // checkFieldElements(this, b);
        LongArray *iarrClone = [self.x copy];
        F2mFieldElement *bF2m = (F2mFieldElement*)b;
        [iarrClone addShiftedByWords:bF2m.x withWords:0];
        retVal = [[F2mFieldElement alloc] initWithM:self.m withKs:self.ks withX:iarrClone];
#if !__has_feature(objc_arc)
        if (iarrClone) [iarrClone release]; iarrClone = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    F2mFieldElement *f2mFE = nil;
    @autoreleasepool {
        f2mFE = [[F2mFieldElement alloc] initWithM:self.m withKs:self.ks withX:[self.x addOne]];
    }
    return [f2mFE autorelease];
}

- (ECFieldElement*)subtract:(ECFieldElement*)b {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        // Addition and subtraction are the same in F2m
        retVal = [self add:b];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)multiply:(ECFieldElement*)b {
    // Right-to-left comb multiplication in the LongArray
    // Input: Binary polynomials a(z) and b(z) of degree at most m-1
    // Output: c(z) = a(z) * b(z) mod f(z)
    
    // No check performed here for performance reasons. Instead the
    // elements involved are checked in ECPoint.F2m
    // checkFieldElements(this, b);
    F2mFieldElement *f2mFE = nil;
    @autoreleasepool {
        f2mFE = [[F2mFieldElement alloc] initWithM:self.m withKs:self.ks withX:[self.x modMultiply:((F2mFieldElement*)b).x withM:self.m withKs:self.ks]];
    }
    return [f2mFE autorelease];
}

- (ECFieldElement*)multiplyMinusProduct:(ECFieldElement*)b withX:(ECFieldElement*)x withY:(ECFieldElement*)y {
    return [self multiplyPlusProduct:b withX:x withY:y];
}

- (ECFieldElement*)multiplyPlusProduct:(ECFieldElement*)b withX:(ECFieldElement*)x withY:(ECFieldElement*)y {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        LongArray *ax = self.x, *bx = ((F2mFieldElement*)b).x, *xx = ((F2mFieldElement*)x).x, *yx = ((F2mFieldElement*)y).x;
        
        LongArray *ab = [ax multiply:bx withM:self.m withKs:self.ks];
        LongArray *xy = [xx multiply:yx withM:self.m withKs:self.ks];
        
        BOOL isCopy = NO;
        if (ab == ax || ab == bx) {
            ab = (LongArray*)[ab copy];
            isCopy = YES;
        }
        
        [ab addShiftedByWords:xy withWords:0];
        [ab reduce:self.m withKs:self.ks];
        retVal = [[F2mFieldElement alloc] initWithM:self.m withKs:self.ks withX:ab];
#if !__has_feature(objc_arc)
        if (isCopy && ab) [ab release]; ab = nil;
#endif
    }
    
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)divide:(ECFieldElement*)b {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        // There may be more efficient implementations
        ECFieldElement *bInv = [b invert];
        retVal = [self multiply:bInv];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)negate {
    // -x == x holds for all x in F2m
    return self;
}

- (ECFieldElement*)square {
    F2mFieldElement *f2mFE = nil;
    @autoreleasepool {
        f2mFE = [[F2mFieldElement alloc] initWithM:self.m withKs:self.ks withX:[self.x modSquare:self.m withKs:self.ks]];
    }
    return [f2mFE autorelease];
}

- (ECFieldElement *)squareMinusProduct:(ECFieldElement*)x withY:(ECFieldElement*)y {
    return [self squarePlusProduct:x withY:y];
}

- (ECFieldElement *)squarePlusProduct:(ECFieldElement*)x withY:(ECFieldElement*)y {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        LongArray *ax = self.x, *xx = ((F2mFieldElement*)x).x, *yx = ((F2mFieldElement*)y).x;
        
        LongArray *aa = [ax square:self.m withKs:self.ks];
        LongArray *xy = [xx multiply:yx withM:self.m withKs:self.ks];
        
        BOOL isCopy = NO;
        if (aa == ax) {
            aa = (LongArray*)[aa copy];
            isCopy = YES;
        }
        
        [aa addShiftedByWords:xy withWords:0];
        [aa reduce:self.m withKs:self.ks];
        
        retVal = [[F2mFieldElement alloc] initWithM:self.m withKs:self.ks withX:aa];
#if !__has_feature(objc_arc)
        if (isCopy && aa) [aa release]; aa = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)squarePow:(int)pow {
    F2mFieldElement *f2mFE = nil;
    @autoreleasepool {
        f2mFE = [[F2mFieldElement alloc] initWithM:self.m withKs:self.ks withX:[self.x modSquareN:pow withM:self.m withKs:self.ks]];
    }
    return pow < 1 ? self : [f2mFE autorelease];
}

- (ECFieldElement*)invert {
    F2mFieldElement *f2mFE = nil;
    @autoreleasepool {
        f2mFE = [[F2mFieldElement alloc] initWithM:self.m withKs:self.ks withX:[self.x modInverse:self.m withKs:self.ks]];
    }
    return [f2mFE autorelease];
}

- (ECFieldElement*)sqrt {
    if ([self.x isZero] || [self.x isOne]) {
        return self;
    }else {
        ECFieldElement *ecFE = nil;
        @autoreleasepool {
            ecFE = [self squarePow:(self.m - 1)];
            [ecFE retain];
        }
        return [ecFE autorelease];
    }
}


/**
 * @return Tpb: The integer <code>k</code> where <code>x<sup>m</sup> +
 * x<sup>k</sup> + 1</code> represents the reduction polynomial
 * <code>f(z)</code>.<br/>
 * Ppb: The integer <code>k1</code> where <code>x<sup>m</sup> +
 * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
 * represents the reduction polynomial <code>f(z)</code>.<br/>
 */
- (int)k1 {
    return [self.ks[0] intValue];
}

/**
 * @return Tpb: Always returns <code>0</code><br/>
 * Ppb: The integer <code>k2</code> where <code>x<sup>m</sup> +
 * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
 * represents the reduction polynomial <code>f(z)</code>.<br/>
 */
- (int)k2 {
    return self.ks.count >= 2 ? [self.ks[1] intValue] : 0;
}

/**
 * @return Tpb: Always set to <code>0</code><br/>
 * Ppb: The integer <code>k3</code> where <code>x<sup>m</sup> +
 * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
 * represents the reduction polynomial <code>f(z)</code>.<br/>
 */
- (int)k3 {
    return self.ks.count >= 3 ? [self.ks[2] intValue] : 0;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if (object && [object isKindOfClass:[F2mFieldElement class]]) {
        F2mFieldElement *other = (F2mFieldElement*)object;
        return [self equalsWithF2mOther:other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithF2mOther:(F2mFieldElement*)other {
    return ((self.m == other.m) && (self.representation == other.representation) && [self.ks isEqualToArray:other.ks] && [self.x equalsWithOther:other.x]);
}

- (NSUInteger)hash {
    return [self.x hash] ^ self.m ^ [Arrays getHashCodeWithIntArray:self.ks];
}

@end
