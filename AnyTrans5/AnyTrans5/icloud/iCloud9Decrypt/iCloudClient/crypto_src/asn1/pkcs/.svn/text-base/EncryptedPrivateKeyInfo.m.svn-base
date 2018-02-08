//
//  EncryptedPrivateKeyInfo.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "EncryptedPrivateKeyInfo.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DEROctetString.h"

@interface EncryptedPrivateKeyInfo ()

@property (nonatomic, readwrite, retain) AlgorithmIdentifier *algId;
@property (nonatomic, readwrite, retain) ASN1OctetString *data;

@end

@implementation EncryptedPrivateKeyInfo
@synthesize algId = _algId;
@synthesize data = _data;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_algId) {
        [_algId release];
        _algId = nil;
    }
    if (_data) {
        [_data release];
        _data = nil;
    }
    [super dealloc];
#endif
}

+ (EncryptedPrivateKeyInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[EncryptedPrivateKeyInfo class]]) {
        return (EncryptedPrivateKeyInfo *)paramObject;
    }
    if (paramObject) {
        return [[[EncryptedPrivateKeyInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.algId = [AlgorithmIdentifier getInstance:[localEnumeration nextObject]];
        self.data = [ASN1OctetString getInstance:[localEnumeration nextObject]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        self.algId = paramAlgorithmIdentifier;
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        self.data = octetString;
#if !__has_feature(objc_arc)
        if (octetString) [octetString release]; octetString = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (AlgorithmIdentifier *)getEncryptionAlgorithm {
    return self.algId;
}

- (NSMutableData *)getEncrypteData {
    return [self.data getOctets];
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.algId];
    [localASN1EncodableVector add:self.data];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
