//
//  SignerAttribute.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SignerAttribute.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"
#import "AttributeX509.h"

@interface SignerAttribute ()

@property (nonatomic, readwrite, retain) NSMutableArray *values;

@end

@implementation SignerAttribute
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

+ (SignerAttribute *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[SignerAttribute class]]) {
        return (SignerAttribute *)paramObject;
    }
    if (paramObject) {
        return [[[SignerAttribute alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        int i = 0;
        self.values = [[[NSMutableArray alloc] initWithSize:(int)[paramASN1Sequence size]] autorelease];
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            ASN1TaggedObject *localASN1TaggedObject = [ASN1TaggedObject getInstance:localObject];
            if ([localASN1TaggedObject getTagNo] == 0) {
                ASN1Sequence *localASN1Sequence = [ASN1Sequence getInstance:localASN1TaggedObject paramBoolean:TRUE];
                NSMutableArray *arrayOfAttribute = [[[NSMutableArray alloc] initWithSize:(int)[localASN1Sequence size]] autorelease];
                for (int j = 0; j != arrayOfAttribute.count; j++) {
                    arrayOfAttribute[j] = [AttributeX509 getInstance:[localASN1Sequence getObjectAt:j]];
                }
                self.values[i] = arrayOfAttribute;
            }else if ([localASN1TaggedObject getTagNo] == 1) {
                self.values[i] = [AttributeCertificate getInstance:[ASN1Sequence getInstance:localASN1TaggedObject paramBoolean:TRUE]];
            }else {
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal tag: %d", [localASN1TaggedObject getTagNo]] userInfo:nil];
            }
            i++;
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfAttribute:(NSMutableArray *)paramArrayOfAttribute
{
    self = [super init];
    if (self) {
        self.values = [[[NSMutableArray alloc] initWithSize:1] autorelease];
        self.values[0] = paramArrayOfAttribute;
    }
    return self;
}

- (instancetype)initParamAttributeCertificate:(AttributeCertificate *)paramAttributeCertificate
{
    self = [super init];
    if (self) {
        self.values = [[[NSMutableArray alloc] initWithSize:1] autorelease];
        self.values[0] = paramAttributeCertificate;
    }
    return self;
}

- (NSMutableArray *)getValues {
    return self.values;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    for (int i = 0; i != self.values.count; i++) {
        if ([self.values[i] isKindOfClass:[NSMutableArray class]]) {
            ASN1Encodable *derSequenceEncodable = [[DERSequence alloc] initDERparamArrayOfASN1Encodable:(NSMutableArray *)self.values[i]];
            ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamInt:0 paramASN1Encodable:derSequenceEncodable];
            [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
            if (derSequenceEncodable) [derSequenceEncodable release]; derSequenceEncodable = nil;
            if (encodable) [encodable release]; encodable = nil;
#endif
        }else {
            ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamInt:1 paramASN1Encodable:(AttributeCertificate *)self.values[i]];
            [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
            if (encodable) [encodable release]; encodable = nil;
#endif
        }
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
