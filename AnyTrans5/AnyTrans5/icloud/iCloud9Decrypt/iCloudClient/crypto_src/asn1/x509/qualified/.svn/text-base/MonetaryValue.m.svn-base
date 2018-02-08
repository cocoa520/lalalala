//
//  MonetaryValue.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "MonetaryValue.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface MonetaryValue ()

@property (nonatomic, readwrite, retain) Iso4217CurrencyCode *currency;
@property (nonatomic, readwrite, retain) ASN1Integer *amount;
@property (nonatomic, readwrite, retain) ASN1Integer *exponent;

@end

@implementation MonetaryValue
@synthesize currency = _currency;
@synthesize amount = _amount;
@synthesize exponent = _exponent;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_currency) {
        [_currency release];
        _currency = nil;
    }
    if (_amount) {
        [_amount release];
        _amount = nil;
    }
    if (_exponent) {
        [_exponent release];
        _exponent = nil;
    }
    [super dealloc];
#endif
}

+ (MonetaryValue *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[MonetaryValue class]]) {
        return (MonetaryValue *)paramObject;
    }
    if (paramObject) {
        return [[[MonetaryValue alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.currency = [Iso4217CurrencyCode getInstance:[localEnumeration nextObject]];
        self.amount = [ASN1Integer getInstance:[localEnumeration nextObject]];
        self.exponent = [ASN1Integer getInstance:[localEnumeration nextObject]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamIso4217CurrencyCode:(Iso4217CurrencyCode *)paramIso4217CurrencyCode paramInt1:(int)paramInt1 paramInt2:(int)paramInt2
{
    if (self = [super init]) {
        self.currency = paramIso4217CurrencyCode;
        ASN1Integer *amoutInteger = [[ASN1Integer alloc] initLong:paramInt1];
        ASN1Integer *exponentInteger = [[ASN1Integer alloc] initLong:paramInt2];
        self.amount = amoutInteger;
        self.exponent = exponentInteger;
#if !__has_feature(objc_arc)
    if (amoutInteger) [amoutInteger release]; amoutInteger = nil;
    if (exponentInteger) [exponentInteger release]; exponentInteger = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (Iso4217CurrencyCode *)getCurrency {
    return self.currency;
}

- (BigInteger *)getAmount {
    return [self.amount getValue];
}

- (BigInteger *)getExponent {
    return [self.exponent getValue];
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.currency];
    [localASN1EncodableVector add:self.amount];
    [localASN1EncodableVector add:self.exponent];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
    return primitive;
}

@end
