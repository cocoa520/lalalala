//
//  MonetaryLimit.m
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "MonetaryLimit.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@implementation MonetaryLimit
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

+ (MonetaryLimit *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[MonetaryLimit class]]) {
        return (MonetaryLimit *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[MonetaryLimit alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:@"unknown object in getInstance" userInfo:nil];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] != 3) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.currency = [DERPrintableString getInstance:[localEnumeration nextObject]];
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

- (instancetype)initParamString:(NSString *)paramString paramInt1:(int)paramInt1 paramInt2:(int)paramInt2
{
    if (self = [super init]) {
        DERPrintableString *printable = [[DERPrintableString alloc] initParamString:paramString paramBoolean:YES];
        ASN1Integer *amoutInteger = [[ASN1Integer alloc] initLong:paramInt1];
        ASN1Integer *exponentInteger = [[ASN1Integer alloc] initLong:paramInt2];
        self.currency = printable;
        self.amount = amoutInteger;
        self.exponent = exponentInteger;
#if !__has_feature(objc_arc)
    if (printable) [printable release]; printable = nil;
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

- (NSString *)getCurrency {
    return [self.currency getString];
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
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
