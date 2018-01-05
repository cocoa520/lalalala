//
//  SubjectPublicKeyInfo.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SubjectPublicKeyInfo.h"
#import "ASN1InputStream.h"
#import "DERSequence.h"

@interface SubjectPublicKeyInfo ()

@property (nonatomic, readwrite, retain) AlgorithmIdentifier *algId;
@property (nonatomic, readwrite, retain) DERBitString *keyData;

@end

@implementation SubjectPublicKeyInfo
@synthesize algId = _algId;
@synthesize keyData = _keyData;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_algId) {
        [_algId release];
        _algId = nil;
    }
    if (_keyData) {
        [_keyData release];
        _keyData = nil;
    }
    [super dealloc];
#endif
}

+ (SubjectPublicKeyInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[SubjectPublicKeyInfo class]]) {
        return (SubjectPublicKeyInfo *)paramObject;
    }
    if (paramObject) {
        return [[[SubjectPublicKeyInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (SubjectPublicKeyInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [SubjectPublicKeyInfo getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] != 2) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.algId = [AlgorithmIdentifier getInstance:[localEnumeration nextObject]];
        self.keyData = [DERBitString getInstance:[localEnumeration nextObject]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        DERBitString *bitString = [[DERBitString alloc] initParamASN1Encodable:paramASN1Encodable];
        self.keyData = bitString;
        self.algId = paramAlgorithmIdentifier;
#if !__has_feature(objc_arc)
    if (bitString) [bitString release]; bitString = nil;
#endif
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
        DERBitString *bitString = [[DERBitString alloc] initDERBitString:paramArrayOfByte];
        self.keyData = bitString;
        self.algId = paramAlgorithmIdentifier;
#if !__has_feature(objc_arc)
    if (bitString) [bitString release]; bitString = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (AlgorithmIdentifier *)getAlgorithm {
    return self.algId;
}

- (AlgorithmIdentifier *)getAlgorithmId {
    return self.algId;
}

- (ASN1Primitive *)parsePublicKey {
    ASN1InputStream *localASN1InputStream = [[ASN1InputStream alloc] initParamArrayOfByte:[self.keyData getOctets]];
    ASN1Primitive *primitive = [localASN1InputStream readObject];
#if !__has_feature(objc_arc)
    if (localASN1InputStream) [localASN1InputStream release]; localASN1InputStream = nil;
#endif
    return primitive;
}

- (ASN1Primitive *)getPublicKey {
    ASN1InputStream *localASN1InputStream = [[ASN1InputStream alloc] initParamArrayOfByte:[self.keyData getOctets]];
    ASN1Primitive *primitive = [localASN1InputStream readObject];
#if !__has_feature(objc_arc)
    if (localASN1InputStream) [localASN1InputStream release]; localASN1InputStream = nil;
#endif
    return primitive;
}

- (DERBitString *)getPublicKeyData {
    return self.keyData;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.algId];
    [localASN1EncodableVector add:self.keyData];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
