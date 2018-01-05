//
//  DSTU4145BinaryField.m
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DSTU4145BinaryField.h"
#import "ASN1Sequence.h"
#import "ASN1Integer.h"
#import "DERSequence.h"

@interface DSTU4145BinaryField ()

@property (nonatomic, assign) int m;
@property (nonatomic, assign) int k;
@property (nonatomic, assign) int j;
@property (nonatomic, assign) int l;

@end

@implementation DSTU4145BinaryField
@synthesize m = _m;
@synthesize k = _k;
@synthesize j = _j;
@synthesize l = _l;

+ (DSTU4145BinaryField *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[DSTU4145BinaryField class]]) {
        return (DSTU4145BinaryField *)paramObject;
    }
    if (paramObject) {
        return [[[DSTU4145BinaryField alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.m = [[[ASN1Integer getInstance:[paramASN1Sequence getObjectAt:0]] getPositiveValue] intValue];
        if ([[paramASN1Sequence getObjectAt:1] isKindOfClass:[ASN1Integer class]]) {
            self.k = [[((ASN1Integer *)[paramASN1Sequence getObjectAt:1]) getPositiveValue] intValue];
        }else if ([[paramASN1Sequence getObjectAt:1] isKindOfClass:[ASN1Sequence class]]) {
            ASN1Sequence *localASN1Sequence = [ASN1Sequence getInstance:[paramASN1Sequence getObjectAt:1]];
            self.k = [[[ASN1Integer getInstance:[localASN1Sequence getObjectAt:0]] getPositiveValue] intValue];
            self.j = [[[ASN1Integer getInstance:[localASN1Sequence getObjectAt:1]] getPositiveValue] intValue];
            self.l = [[[ASN1Integer getInstance:[localASN1Sequence getObjectAt:2]] getPositiveValue] intValue];
        }else {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"object parse error" userInfo:nil];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt1:(int)paramInt1 paramInt2:(int)paramInt2 paramInt3:(int)paramInt3 paramInt4:(int)paramInt4
{
    if (self = [super init]) {
        self.m = paramInt1;
        self.k = paramInt2;
        self.j = paramInt3;
        self.l = paramInt4;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt1:(int)paramInt1 paramInt2:(int)paramInt2
{
    if (self = [super init]) {
        [self initParamInt1:paramInt1 paramInt2:paramInt2 paramInt3:0 paramInt4:0];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (int)getM {
    return self.m;
}

- (int)getK1 {
    return self.k;
}

- (int)getK2 {
    return self.j;
}

- (int)getK3 {
    return self.l;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector1 = [[ASN1EncodableVector alloc] init];
    ASN1Encodable *integer = [[ASN1Integer alloc] initLong:self.m];
    [localASN1EncodableVector1 add:integer];
#if !__has_feature(objc_arc)
    if (integer) [integer release]; integer = nil;
#endif
    if (self.j == 0) {
        ASN1Encodable *jInteger = [[ASN1Integer alloc] initLong:self.k];
        [localASN1EncodableVector1 add:jInteger];
#if !__has_feature(objc_arc)
        if (jInteger) [jInteger release]; jInteger = nil;
#endif
    }else {
        ASN1EncodableVector *localASN1EncodableVector2 = [[ASN1EncodableVector alloc] init];
        ASN1Encodable *kInteger = [[ASN1Integer alloc] initLong:self.k];
        ASN1Encodable *jInteger = [[ASN1Integer alloc] initLong:self.j];
        ASN1Encodable *iInteger = [[ASN1Integer alloc] initLong:self.l];
        [localASN1EncodableVector2 add:kInteger];
        [localASN1EncodableVector2 add:jInteger];
        [localASN1EncodableVector2 add:iInteger];
        ASN1Encodable *encodable = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector2];
        [localASN1EncodableVector1 add:encodable];
#if !__has_feature(objc_arc)
        if (kInteger) [kInteger release]; kInteger = nil;
        if (jInteger) [jInteger release]; jInteger = nil;
        if (iInteger) [iInteger release]; iInteger = nil;
        if (encodable) [encodable release]; encodable = nil;
        if (localASN1EncodableVector2) [localASN1EncodableVector2 release]; localASN1EncodableVector2 = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector1] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector1) [localASN1EncodableVector1 release]; localASN1EncodableVector1 = nil;
#endif
    return primitive;
}

@end
