//
//  EncryptedValue.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "EncryptedValue.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"

@interface EncryptedValue ()

@property (nonatomic, readwrite, retain) AlgorithmIdentifier *intendedAlg;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *symmAlg;
@property (nonatomic, readwrite, retain) DERBitString *encSymmKey;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *keyAlg;
@property (nonatomic, readwrite, retain) ASN1OctetString *valueHint;
@property (nonatomic, readwrite, retain) DERBitString *encValue;

@end

@implementation EncryptedValue
@synthesize intendedAlg = _intendedAlg;
@synthesize symmAlg = _symmAlg;
@synthesize encSymmKey = _encSymmKey;
@synthesize keyAlg = _keyAlg;
@synthesize valueHint = _valueHint;
@synthesize encValue = _encValue;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_intendedAlg) {
        [_intendedAlg release];
        _intendedAlg = nil;
    }
    if (_symmAlg) {
        [_symmAlg release];
        _symmAlg = nil;
    }
    if (_encSymmKey) {
        [_encSymmKey release];
        _encSymmKey = nil;
    }
    if (_keyAlg) {
        [_keyAlg release];
        _keyAlg = nil;
    }
    if (_valueHint) {
        [_valueHint release];
        _valueHint = nil;
    }
    if (_encValue) {
        [_encValue release];
        _encValue = nil;
    }
  [super dealloc];
#endif
}

+ (EncryptedValue *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[EncryptedValue class]]) {
        return (EncryptedValue *)paramObject;
    }
    if (paramObject) {
        return [[[EncryptedValue alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        int i = 0;
        for (i = 0; [[paramASN1Sequence getObjectAt:i] isKindOfClass:[ASN1TaggedObject class]]; i++) {
            ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)[paramASN1Sequence getObjectAt:i];
            switch ([localASN1TaggedObject getTagNo]) {
                case 0:
                    self.intendedAlg = [AlgorithmIdentifier getInstance:localASN1TaggedObject paramBoolean:false];
                    break;
                case 1:
                    self.symmAlg = [AlgorithmIdentifier getInstance:localASN1TaggedObject paramBoolean:false];
                    break;
                case 2:
                    self.encSymmKey = [DERBitString getInstance:localASN1TaggedObject paramBoolean:false];
                    break;
                case 3:
                    self.keyAlg = [AlgorithmIdentifier getInstance:localASN1TaggedObject paramBoolean:false];
                    break;
                case 4:
                    self.valueHint = [ASN1OctetString getInstance:localASN1TaggedObject paramBoolean:false];
                    break;
                default:
                    break;
            }
        }
        self.encValue = [DERBitString getInstance:[paramASN1Sequence getObjectAt:i]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAlgorithmIdentifier1:(AlgorithmIdentifier *)paramAlgorithmIdentifier1 paramAlgorithmIdentifier2:(AlgorithmIdentifier *)paramAlgorithmIdentifier2 paramDERBitString1:(DERBitString *)paramDERBitString1 paramAlgorithmIdentifier3:(AlgorithmIdentifier *)paramAlgorithmIdentifier3 paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString paramDERBitString2:(DERBitString *)paramDERBitString2
{
    if (self = [super init]) {
        if (!paramDERBitString2) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"'encValue' cannot be null" userInfo:nil];
        }
        self.intendedAlg = paramAlgorithmIdentifier1;
        self.symmAlg = paramAlgorithmIdentifier2;
        self.encSymmKey = paramDERBitString1;
        self.keyAlg = paramAlgorithmIdentifier3;
        self.valueHint = paramASN1OctetString;
        self.encValue = paramDERBitString2;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (AlgorithmIdentifier *)getIntendedAlg {
    return self.intendedAlg;
}

- (AlgorithmIdentifier *)getSymmAlg {
    return self.symmAlg;
}

- (DERBitString *)getEncSymmKey {
    return self.encSymmKey;
}

- (AlgorithmIdentifier *)getKeyAlg {
    return self.keyAlg;
}

- (ASN1OctetString *)getValueHint {
    return self.valueHint;
}

- (DERBitString *)getEncValue {
    return self.encValue;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [self addOptional:localASN1EncodableVector paramInt:0 paramASN1Encodable:self.intendedAlg];
    [self addOptional:localASN1EncodableVector paramInt:1 paramASN1Encodable:self.symmAlg];
    [self addOptional:localASN1EncodableVector paramInt:2 paramASN1Encodable:self.encSymmKey];
    [self addOptional:localASN1EncodableVector paramInt:3 paramASN1Encodable:self.keyAlg];
    [self addOptional:localASN1EncodableVector paramInt:4 paramASN1Encodable:self.valueHint];
    [localASN1EncodableVector add:self.encValue];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (void)addOptional:(ASN1EncodableVector *)paramASN1EncodableVector paramInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable {
    if (paramASN1Encodable) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:false paramInt:paramInt paramASN1Encodable:paramASN1Encodable];
        [paramASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
}

@end
