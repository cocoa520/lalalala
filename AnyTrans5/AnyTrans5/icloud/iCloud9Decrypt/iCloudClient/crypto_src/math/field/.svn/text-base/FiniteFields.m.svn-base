//
//  FiniteFields.m
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import "FiniteFields.h"
#import "IFiniteField.h"
#import "PrimeField.h"
#import "BigInteger.h"
#import "GenericPolynomialExtensionField.h"
#import "GF2Polynomial.h"

@implementation FiniteFields

+ (IFiniteField*)GF_2 {
    static PrimeField *_gf_2 = nil;
    @synchronized(self) {
        if (_gf_2 == nil) {
            _gf_2 = [[PrimeField alloc] initWithBigInteger:[BigInteger Two]];
        }
    }
    return _gf_2;
}

+ (IFiniteField*)GF_3 {
    static PrimeField *_gf_3 = nil;
    @synchronized(self) {
        if (_gf_3 == nil) {
            _gf_3 = [[PrimeField alloc] initWithBigInteger:[BigInteger Three]];
        }
    }
    return _gf_3;
}

// exponents == int[]
+ (IPolynomialExtensionField*)getBinaryExtensionField:(NSMutableArray*)exponents {
    GenericPolynomialExtensionField *retVal = nil;
    @autoreleasepool {
        if ([exponents[0] intValue] != 0) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"exponents - Irreducible polynomials in GF(2) must have constant term" userInfo:nil];
        }
        for (int i = 1; i < exponents.count; ++i) {
            if ([exponents[i] intValue] <= [exponents[i - 1] intValue]) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"exponents - Polynomial exponents must be montonically increasing" userInfo:nil];
            }
        }
        
        GF2Polynomial *gf2p = [[GF2Polynomial alloc] initWithExponents:exponents];
        retVal = [[GenericPolynomialExtensionField alloc] initWithSubfield:[FiniteFields GF_2] withPolynomial:gf2p];
#if !__has_feature(objc_arc)
        if (gf2p != nil) [gf2p release]; gf2p = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

+ (IFiniteField*)getPrimeField:(BigInteger*)characteristic {
    int bitLength = [characteristic bitLength];
    if ([characteristic signValue] <= 0 || bitLength < 2) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"characteristic must be >= 2" userInfo:nil];
    }
    
    if (bitLength < 3) {
        switch ([characteristic intValue]) {
            case 2: {
                return [FiniteFields GF_2];
            }
            case 3: {
                return [FiniteFields GF_3];
            }
        }
    }
    
    return [[[PrimeField alloc] initWithBigInteger:characteristic] autorelease];
}

@end
