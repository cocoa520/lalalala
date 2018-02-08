//
//  DHPublicKey.h
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"

@interface DHPublicKey : ASN1Object {
@private
    ASN1Integer *_y;
}

+ (DHPublicKey *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (DHPublicKey *)getInstance:(id)paramObject;
- (instancetype)initParamBigInteger:(BigInteger *)paramBigInteger;
- (BigInteger *)getY;
- (ASN1Primitive *)toASN1Primitive;

@end
