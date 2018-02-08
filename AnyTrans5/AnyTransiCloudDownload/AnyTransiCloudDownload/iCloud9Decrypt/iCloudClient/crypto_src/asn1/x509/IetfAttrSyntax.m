//
//  IetfAttrSyntax.m
//  crypto
//
//  Created by JGehry on 7/11/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "IetfAttrSyntax.h"
#import "ASN1Sequence.h"
#import "DERUTF8String.h"
#import "DEROctetString.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"

@implementation IetfAttrSyntax
@synthesize policyAuthority = _policyAuthority;
@synthesize values = _values;
@synthesize valueChoice = _valueChoice;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_policyAuthority) {
        [_policyAuthority release];
        _policyAuthority = nil;
    }
    if (_values) {
        [_values release];
        _values = nil;
    }
    [super dealloc];
#endif
}

+ (int)VALUE_OCTETS {
    static int _VALUE_OCTETS = 0;
    @synchronized(self) {
        if (!_VALUE_OCTETS) {
            _VALUE_OCTETS = 1;
        }
    }
    return _VALUE_OCTETS;
}

+ (int)VALUE_OID {
    static int _VALUE_OID = 0;
    @synchronized(self) {
        if (!_VALUE_OID) {
            _VALUE_OID = 2;
        }
    }
    return _VALUE_OID;
}

+ (int)VALUE_UTF8 {
    static int _VALUE_UTF8 = 0;
    @synchronized(self) {
        if (!_VALUE_UTF8) {
            _VALUE_UTF8 = 3;
        }
    }
    return _VALUE_UTF8;
}

+ (IetfAttrSyntax *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[IetfAttrSyntax class]]) {
        return (IetfAttrSyntax *)paramObject;
    }
    if (paramObject) {
        return [[[IetfAttrSyntax alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        int i = 0;
        if ([[paramASN1Sequence getObjectAt:0] isKindOfClass:[ASN1TaggedObject class]]) {
            self.policyAuthority = [GeneralNames getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:0] paramBoolean:false];
            i++;
        }else if ([paramASN1Sequence size] == 2) {
            self.policyAuthority = [GeneralNames getInstance:[paramASN1Sequence getObjectAt:0]];
            i++;
        }
        if (![[paramASN1Sequence getObjectAt:i] isKindOfClass:[ASN1Sequence class]]) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"Non-IetfAttrSyntax encoding" userInfo:nil];
        }
        paramASN1Sequence = (ASN1Sequence *)[paramASN1Sequence getObjectAt:i];
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        ASN1Primitive *localASN1Primitive = nil;
        while (localASN1Primitive = [localEnumeration nextObject]) {
            int j;
            if ([localASN1Primitive isKindOfClass:[ASN1ObjectIdentifier class]]) {
                j = 2;
            }else if ([localASN1Primitive isKindOfClass:[DERUTF8String class]]) {
                j = 3;
            }else if ([localASN1Primitive isKindOfClass:[DEROctetString class]]) {
                j = 1;
            }else {
                @throw [NSException exceptionWithName:NSGenericException reason:@"Bad value type encoding IetfAttrSyntax" userInfo:nil];
            }
            if (self.valueChoice  < 0) {
                self.valueChoice = j;
            }
            if (j != self.valueChoice) {
                @throw [NSException exceptionWithName:NSGenericException reason:@"Mix of value types in IetfAttrSyntax" userInfo:nil];
            }
            [self.values addObject:localASN1Primitive];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (GeneralNames *)getPolicyAuthority {
    return self.policyAuthority;
}

- (int)getValueType {
    return self.valueChoice;
}

- (NSMutableArray *)getValues {
    if ([self getValueType] == 1) {
        NSMutableArray *localObject = [[[NSMutableArray alloc] initWithSize:(int)[self.values count]] autorelease];
        for (int i = 0; i != localObject.count; i++) {
            localObject[i] = (ASN1OctetString *)[self.values objectAtIndex:i];
        }
        return (NSMutableArray *)localObject;
    }
    if ([self getValueType] == 2) {
        NSMutableArray *localObject = [[[NSMutableArray alloc] initWithSize:(int)[self.values count]] autorelease];
        for (int i = 0; i != localObject.count; i++) {
            localObject[i] = (ASN1ObjectIdentifier *)[self.values objectAtIndex:i];
        }
        return (NSMutableArray *)localObject;
    }
    NSMutableArray *localObject = [[[NSMutableArray alloc] initWithSize:(int)[self.values count]] autorelease];
    for (int i = 0; i != localObject.count; i++) {
        localObject[i] = (DERUTF8String *)[self.values objectAtIndex:i];
    }
    return (NSMutableArray *)localObject;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector1 = [[ASN1EncodableVector alloc] init];
    if (self.policyAuthority) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamInt:0 paramASN1Encodable:self.policyAuthority];
        [localASN1EncodableVector1 add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    ASN1EncodableVector *localASN1EncodableVector2 = [[ASN1EncodableVector alloc] init];
    NSEnumerator *localEnumeration = [self.values objectEnumerator];
    ASN1Encodable *encodable = nil;
    while (encodable = [localEnumeration nextObject]) {
        [localASN1EncodableVector2 add:encodable];
    }
    ASN1Encodable *derEncodable = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector2];
    [localASN1EncodableVector1 add:derEncodable];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector1] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector1) [localASN1EncodableVector1 release]; localASN1EncodableVector1 = nil;
    if (localASN1EncodableVector2) [localASN1EncodableVector2 release]; localASN1EncodableVector2 = nil;
    if (derEncodable) [derEncodable release]; derEncodable = nil;
#endif
    return primitive;
}

@end
