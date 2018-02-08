//
//  OriginatorPublicKey.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OriginatorPublicKey.h"
#import "DERSequence.h"

@interface OriginatorPublicKey ()

@property (nonatomic, readwrite, retain) AlgorithmIdentifier *algorithm;
@property (nonatomic, readwrite, retain) DERBitString *publicKey;

@end

@implementation OriginatorPublicKey
@synthesize algorithm = _algorithm;
@synthesize publicKey = _publicKey;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_algorithm) {
        [_algorithm release];
        _algorithm = nil;
    }
    if (_publicKey) {
        [_publicKey release];
        _publicKey = nil;
    }
    [super dealloc];
#endif
}

+ (OriginatorPublicKey *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OriginatorPublicKey class]]) {
        return (OriginatorPublicKey *)paramObject;
    }
    if (paramObject) {
        return [[[OriginatorPublicKey alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (OriginatorPublicKey *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [OriginatorPublicKey getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.algorithm = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        self.publicKey = (DERBitString *)[paramASN1Sequence getObjectAt:1];
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
        self.algorithm = paramAlgorithmIdentifier;
        DERBitString *bitString = [[DERBitString alloc] initDERBitString:paramArrayOfByte];
        self.publicKey = bitString;
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
    return self.algorithm;
}

- (DERBitString *)getPublicKey {
    return self.publicKey;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.algorithm];
    [localASN1EncodableVector add:self.publicKey];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
