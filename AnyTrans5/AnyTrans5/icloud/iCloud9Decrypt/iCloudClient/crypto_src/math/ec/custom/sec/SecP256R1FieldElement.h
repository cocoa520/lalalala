//
//  SecP256R1FieldElement.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "ECFieldElement.h"

@class BigInteger;

@interface SecP256R1FieldElement : ECFieldElement {
@protected
    NSMutableArray *                    _x; // uint[]
}

// return == uint[]
- (NSMutableArray*)x;

+ (BigInteger*)Q;

- (id)initWithBigInteger:(BigInteger*)x;
- (id)initWithUintArray:(NSMutableArray*)x;

- (BOOL)equalsWithSecP256R1FieldElement:(SecP256R1FieldElement*)other;

@end
