//
//  Curve25519FieldElement.h
//  
//
//  Created by Pallas on 5/25/16.
//
//  Complete

#import "ECFieldElement.h"

@interface Curve25519FieldElement : ECFieldElement {
@protected
    NSMutableArray *                        _x;         // uint[]
}

+ (BigInteger*)Q;

- (NSMutableArray*)x;

- (id)initWithBigInteger:(BigInteger*)x;
- (id)initWithUintArray:(NSMutableArray*)x;

- (BOOL)equalsWithCurve25519FieldElement:(Curve25519FieldElement*)other;

@end
