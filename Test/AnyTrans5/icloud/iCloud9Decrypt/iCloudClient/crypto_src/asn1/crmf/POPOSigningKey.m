//
//  POPOSigningKey.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "POPOSigningKey.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"

@interface POPOSigningKey ()

@property (nonatomic, readwrite, retain) POPOSigningKeyInput *poposkInput;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *algorithmIdentifier;
@property (nonatomic, readwrite, retain) DERBitString *signature;

@end

@implementation POPOSigningKey
@synthesize poposkInput = _poposkInput;
@synthesize algorithmIdentifier = _algorithmIdentifier;
@synthesize signature = _signature;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_poposkInput) {
        [_poposkInput release];
        _poposkInput = nil;
    }
    if (_algorithmIdentifier) {
        [_algorithmIdentifier release];
        _algorithmIdentifier = nil;
    }
    if (_signature) {
        [_signature release];
        _signature = nil;
    }
  [super dealloc];
#endif
}

+ (POPOSigningKey *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[POPOSigningKey class]]) {
        return (POPOSigningKey *)paramObject;
    }
    if (paramObject) {
        return [[[POPOSigningKey alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (POPOSigningKey *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [POPOSigningKey getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        int i = 0;
        if ([[paramASN1Sequence getObjectAt:i] isKindOfClass:[ASN1TaggedObject class]]) {
            ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)[paramASN1Sequence getObjectAt:i++];
            if ([localASN1TaggedObject getTagNo]) {
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Unknown POPOSigningKeyInput tag: %d", [localASN1TaggedObject getTagNo]] userInfo:nil];
            }
            self.poposkInput = [POPOSigningKeyInput getInstance:[localASN1TaggedObject getObject]];
        }
        self.algorithmIdentifier = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:i++]];
        self.signature = [DERBitString getInstance:[paramASN1Sequence getObjectAt:i]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamPOPOSigningKeyInput:(POPOSigningKeyInput *)paramPOPOSigningKeyInput paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramDERBitString:(DERBitString *)paramDERBitString
{
    if (self = [super init]) {
        self.poposkInput = paramPOPOSigningKeyInput;
        self.algorithmIdentifier = paramAlgorithmIdentifier;
        self.signature = paramDERBitString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (POPOSigningKeyInput *)getPoposkInput {
    return self.poposkInput;
}

- (AlgorithmIdentifier *)getAlgorithmIdentifier {
    return self.algorithmIdentifier;
}

- (DERBitString *)getSignature {
    return self.signature;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.poposkInput) {
        ASN1Encodable *popoEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:0 paramASN1Encodable:self.poposkInput];
        [localASN1EncodableVector add:popoEncodable];
#if !__has_feature(objc_arc)
        if (popoEncodable) [popoEncodable release]; popoEncodable = nil;
#endif
    }
    [localASN1EncodableVector add:self.algorithmIdentifier];
    [localASN1EncodableVector add:self.signature];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
