//
//  MonetaryValue.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "Iso4217CurrencyCode.h"
#import "ASN1Integer.h"

@interface MonetaryValue : ASN1Object {
@private
    Iso4217CurrencyCode *_currency;
    ASN1Integer *_amount;
    ASN1Integer *_exponent;
}

+ (MonetaryValue *)getInstance:(id)paramObject;
- (instancetype)initParamIso4217CurrencyCode:(Iso4217CurrencyCode *)paramIso4217CurrencyCode paramInt1:(int)paramInt1 paramInt2:(int)paramInt2;
- (Iso4217CurrencyCode *)getCurrency;
- (BigInteger *)getAmount;
- (BigInteger *)getExponent;
- (ASN1Primitive *)toASN1Primitive;

@end
