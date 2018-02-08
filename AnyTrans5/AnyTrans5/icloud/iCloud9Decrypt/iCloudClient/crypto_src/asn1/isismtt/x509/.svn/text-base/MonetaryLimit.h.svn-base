//
//  MonetaryLimit.h
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "DERPrintableString.h"
#import "ASN1Integer.h"

@interface MonetaryLimit : ASN1Object {
    DERPrintableString *_currency;
    ASN1Integer *_amount;
    ASN1Integer *_exponent;
}

@property (nonatomic, readwrite, retain) DERPrintableString *currency;
@property (nonatomic, readwrite, retain) ASN1Integer *amount;
@property (nonatomic, readwrite, retain) ASN1Integer *exponent;

+ (MonetaryLimit *)getInstance:(id)paramObject;
- (instancetype)initParamString:(NSString *)paramString paramInt1:(int)paramInt1 paramInt2:(int)paramInt2;
- (NSString *)getCurrency;
- (BigInteger *)getAmount;
- (BigInteger *)getExponent;
- (ASN1Primitive *)toASN1Primitive;

@end
