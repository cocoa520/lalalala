//
//  ResponderID.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ResponderID.h"
#import "DERTaggedObject.h"
#import "DEROctetString.h"

@interface ResponderID ()

@property (nonatomic, readwrite, retain) ASN1Encodable *value;

@end

@implementation ResponderID
@synthesize value = _value;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_value) {
        [_value release];
        _value = nil;
    }
    [super dealloc];
#endif
}

+ (ResponderID *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ResponderID class]]) {
        return (ResponderID *)paramObject;
    }
    if ([paramObject isKindOfClass:[DEROctetString class]]) {
        return [[[ResponderID alloc] initParamASN1OctetString:(DEROctetString *)paramObject] autorelease];
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)paramObject;
        if ([localASN1TaggedObject getTagNo] == 1) {
            return [[[ResponderID alloc] initParamX500Name:[X500Name getInstance:localASN1TaggedObject paramBoolean:YES]] autorelease];
        }
        return [[[ResponderID alloc] initParamASN1OctetString:[ASN1OctetString getInstance:localASN1TaggedObject paramBoolean:YES]] autorelease];
    }
    return [[[ResponderID alloc] initParamX500Name:[X500Name getInstance:paramObject]] autorelease];
}

+ (ResponderID *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [ResponderID getInstance:[paramASN1TaggedObject getObject]];
}

- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        self.value = paramASN1OctetString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamX500Name:(X500Name *)paramX500Name
{
    if (self = [super init]) {
        self.value = paramX500Name;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableData *)getKeyHash {
    if ([self.value isKindOfClass:[ASN1OctetString class]]) {
        ASN1OctetString *localASN1octetString = (ASN1OctetString *)self.value;
        return [localASN1octetString getOctets];
    }
    return nil;
}

- (X500Name *)getName {
    if ([self.value isKindOfClass:[ASN1OctetString class]]) {
        return nil;
    }
    return [X500Name getInstance:self.value];
}

- (ASN1Primitive *)toASN1Primitive {
    if ([self.value isKindOfClass:[ASN1OctetString class]]) {
        return [[[DERTaggedObject alloc] initParamBoolean:YES paramInt:2 paramASN1Encodable:self.value] autorelease];
    }
    return [[[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:self.value] autorelease];
}

@end
