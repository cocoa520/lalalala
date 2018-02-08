//
//  SignerAttribute.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "AttributeCertificate.h"

@interface SignerAttribute : ASN1Object {
@private
    NSMutableArray *_values;
}

+ (SignerAttribute *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfAttribute:(NSMutableArray *)paramArrayOfAttribute;
- (instancetype)initParamAttributeCertificate:(AttributeCertificate *)paramAttributeCertificate;
- (NSMutableArray *)getValues;
- (ASN1Primitive *)toASN1Primitive;

@end
