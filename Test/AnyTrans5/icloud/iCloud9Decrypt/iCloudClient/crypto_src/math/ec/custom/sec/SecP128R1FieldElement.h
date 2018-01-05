//
//  SecP128R1FieldElement.h
//  
//
//  Created by Pallas on 5/31/16.
//
//

#import "ECFieldElement.h"

@interface SecP128R1FieldElement : ECFieldElement {
@protected
    NSMutableArray *                    _x; // uint[]
}

// return == uint[]
- (NSMutableArray*)x;

+ (BigInteger*)Q;

- (id)initWithBigInteger:(BigInteger*)x;
- (id)initWithUintArray:(NSMutableArray*)x;

- (BOOL)equalsWithSecP128R1FieldElement:(SecP128R1FieldElement*)other;

@end
