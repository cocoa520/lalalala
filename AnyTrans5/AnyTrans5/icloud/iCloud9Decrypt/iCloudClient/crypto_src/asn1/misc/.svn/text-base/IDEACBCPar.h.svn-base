//
//  IDEACBCPar.h
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1OctetString.h"
#import "ASN1Sequence.h"

@interface IDEACBCPar : ASN1Object {
    ASN1OctetString *_iv;
}

@property (nonatomic, readwrite, retain) ASN1OctetString *iv;

+ (IDEACBCPar *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (NSMutableData *)getIV;
- (ASN1Primitive *)toASN1Primitive;

@end
