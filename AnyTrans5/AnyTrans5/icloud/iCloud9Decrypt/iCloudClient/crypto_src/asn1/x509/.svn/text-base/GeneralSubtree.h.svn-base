//
//  GeneralSubtree.h
//  crypto
//
//  Created by JGehry on 7/11/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "GeneralName.h"
#import "ASN1Integer.h"
#import "ASN1TaggedObject.h"

@interface GeneralSubtree : ASN1Object {
@private
    GeneralName *_base;
    ASN1Integer *_minimum;
    ASN1Integer *_maximum;
}

+ (GeneralSubtree *)getInstance:(id)paramObject;
+ (GeneralSubtree *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName;
- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName paramBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2;
- (GeneralName *)getBase;
- (BigInteger *)getMinimum;
- (BigInteger *)getMaximum;
- (ASN1Primitive *)toASN1Primitive;

@end
