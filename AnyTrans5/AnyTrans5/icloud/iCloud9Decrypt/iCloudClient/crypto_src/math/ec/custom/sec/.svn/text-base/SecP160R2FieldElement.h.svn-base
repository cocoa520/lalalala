//
//  SecP160R2FieldElement.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "ECFieldElement.h"

@interface SecP160R2FieldElement : ECFieldElement {
@protected
    NSMutableArray *                    _x; // uint[]
}

// return == uint[]
- (NSMutableArray*)x;

+ (BigInteger*)Q;

- (id)initWithBigInteger:(BigInteger*)x;
- (id)initWithUintArray:(NSMutableArray*)x;

- (BOOL)equalsWithSecP160R2FieldElement:(SecP160R2FieldElement*)other;

@end
