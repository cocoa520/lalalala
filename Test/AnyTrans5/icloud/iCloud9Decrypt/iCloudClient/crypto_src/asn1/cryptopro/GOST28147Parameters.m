//
//  GOST28147Parameters.m
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "GOST28147Parameters.h"
#import "DERSequence.h"

@interface GOST28147Parameters ()

@property (nonatomic, readwrite, retain) ASN1OctetString *iv;
@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *paramSet;

@end

@implementation GOST28147Parameters
@synthesize iv = _iv;
@synthesize paramSet = _paramSet;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_iv) {
        [_iv release];
        _iv = nil;
    }
    if (_paramSet) {
        [_paramSet release];
        _paramSet = nil;
    }
    [super dealloc];
#endif
}

+ (GOST28147Parameters *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [GOST28147Parameters getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (GOST28147Parameters *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[GOST28147Parameters class]]) {
        return (GOST28147Parameters *)paramObject;
    }
    if (paramObject) {
        return [[[GOST28147Parameters alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.iv = (ASN1OctetString *)[localEnumeration nextObject];
        self.paramSet = (ASN1ObjectIdentifier *)[localEnumeration nextObject];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.iv];
    [localASN1EncodableVector add:self.paramSet];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (ASN1ObjectIdentifier *)getEncryptionParamSet {
    return self.paramSet;
}

- (NSMutableData *)getIV {
    return [self.iv getOctets];
}

@end
