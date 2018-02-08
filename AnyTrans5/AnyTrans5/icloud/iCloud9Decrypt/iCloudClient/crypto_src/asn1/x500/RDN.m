//
//  RDN.m
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RDN.h"
#import "DERSet.h"
#import "DERSequence.h"

@interface RDN ()

@property (nonatomic, readwrite, retain) ASN1Set *values;

@end

@implementation RDN
@synthesize values = _values;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_values) {
        [_values release];
        _values = nil;
    }
    [super dealloc];
#endif
}

+ (RDN *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[RDN class]]) {
        return (RDN *)paramObject;
    }
    if (paramObject) {
        return nil;
    }
    return nil;
}

- (instancetype)initParamASN1Set:(ASN1Set *)paramASN1Set
{
    if (self = [super init]) {
        self.values = paramASN1Set;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        [localASN1EncodableVector add:paramASN1ObjectIdentifier];
        [localASN1EncodableVector add:paramASN1Encodable];
        ASN1Encodable *encodable = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
        ASN1Set *asn1Set = [[DERSet alloc] initDERParamASN1Encodable:encodable];
        self.values = asn1Set;
#if !__has_feature(objc_arc)
        if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
        if (encodable) [encodable release]; encodable = nil;
        if (asn1Set) [asn1Set release]; asn1Set = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAttributeTypeAndValue:(AttributeTypeAndValue *)paramAttributeTypeAndValue
{
    if (self = [super init]) {
        ASN1Set *asn1Set = [[DERSet alloc] initDERParamASN1Encodable:paramAttributeTypeAndValue];
        self.values = asn1Set;
#if !__has_feature(objc_arc)
    if (asn1Set) [asn1Set release]; asn1Set = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfAttributeTypeAndValue:(NSMutableArray *)paramArrayOfAttributeTypeAndValue
{
    if (self = [super init]) {
        ASN1Set *asn1Set = [[DERSet alloc] initDERParamArrayOfASN1Encodable:paramArrayOfAttributeTypeAndValue];
        self.values = asn1Set;
#if !__has_feature(objc_arc)
    if (asn1Set) [asn1Set release]; asn1Set = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BOOL)isMultiValued {
    return [self.values size] > 1;
}

- (int)size {
    return [self.values size];
}

- (AttributeTypeAndValue *)getFirst {
    if ([self.values size] == 0) {
        return nil;
    }
    return [AttributeTypeAndValue getInstance:[self.values getObjectAt:0]];
}

- (NSMutableArray *)getTypeAndValues {
    NSMutableArray *arrayOfAttributeTypeAndValue = [[[NSMutableArray alloc] initWithSize:(int)[self.values size]] autorelease];
    for (int i = 0; i != arrayOfAttributeTypeAndValue.count; i++) {
        arrayOfAttributeTypeAndValue[i] = [AttributeTypeAndValue getInstance:[self.values getObjectAt:i]];
    }
    return arrayOfAttributeTypeAndValue;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.values;
}

@end
