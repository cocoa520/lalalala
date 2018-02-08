//
//  CrlListID.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"

@interface CrlListID : ASN1Object {
@private
    ASN1Sequence *_crls;
}

+ (CrlListID *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfCrlValidatedID:(NSMutableArray *)paramArrayOfCrlValidatedID;
- (NSMutableArray *)getCrls;
- (ASN1Primitive *)toASN1Primitive;

@end
