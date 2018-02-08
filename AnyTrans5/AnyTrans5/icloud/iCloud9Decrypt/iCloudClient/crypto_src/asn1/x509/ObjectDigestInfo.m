//
//  ObjectDigestInfo.m
//  crypto
//
//  Created by JGehry on 7/11/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ObjectDigestInfo.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@implementation ObjectDigestInfo
@synthesize digestedObjectType = _digestedObjectType;
@synthesize otherObjectTypeID = _otherObjectTypeID;
@synthesize digestAlgorithm = _digestAlgorithm;
@synthesize objectDigest = _objectDigest;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_digestedObjectType) {
        [_digestedObjectType release];
        _digestedObjectType = nil;
    }
    if (_otherObjectTypeID) {
        [_otherObjectTypeID release];
        _otherObjectTypeID = nil;
    }
    if (_digestAlgorithm) {
        [_digestAlgorithm release];
        _digestAlgorithm = nil;
    }
    if (_objectDigest) {
        [_objectDigest release];
        _objectDigest = nil;
    }
    [super dealloc];
#endif
}

+ (int)publicKey {
    static int _publicKey = 0;
    @synchronized(self) {
        if (!_publicKey) {
            _publicKey = 0;
        }
    }
    return _publicKey;
}

+ (int)publickeyCert {
    static int _publickeyCert = 0;
    @synchronized(self) {
        if (!_publickeyCert) {
            _publickeyCert = 1;
        }
    }
    return _publickeyCert;
}

+ (int)otherObjectDigest {
    static int _otherObjectDigest = 0;
    @synchronized(self) {
        if (!_otherObjectDigest) {
            _otherObjectDigest = 2;
        }
    }
    return _otherObjectDigest;
}

+ (ObjectDigestInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ObjectDigestInfo class]]) {
        return (ObjectDigestInfo *)paramObject;
    }
    if (paramObject) {
        return [[[ObjectDigestInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (ObjectDigestInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [ObjectDigestInfo getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (([paramASN1Sequence size] > 4) || ([paramASN1Sequence size] < 3)) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.digestedObjectType = [ASN1Enumerated getInstance:[paramASN1Sequence getObjectAt:0]];
        int i = 0;
        if ([paramASN1Sequence size] == 4) {
            self.otherObjectTypeID = [ASN1ObjectIdentifier getInstance:[paramASN1Sequence getObjectAt:1]];
            i++;
        }
        self.digestAlgorithm = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:(1 + i)]];
        self.objectDigest = [DERBitString getInstance:[paramASN1Sequence getObjectAt:(2 + i)]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt:(int)paramInt paramASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        ASN1Enumerated *enumerator = [[ASN1Enumerated alloc] initParamInt:paramInt];
        self.digestedObjectType = enumerator;
        if (paramInt == 2) {
            self.otherObjectTypeID = paramASN1ObjectIdentifier;
        }
        self.digestAlgorithm = paramAlgorithmIdentifier;
        DERBitString *bitString = [[DERBitString alloc] initDERBitString:paramArrayOfByte];
        self.objectDigest = bitString;
#if !__has_feature(objc_arc)
    if (enumerator) [enumerator release]; enumerator = nil;
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

- (ASN1Enumerated *)getDigestedObjectType {
    return self.digestedObjectType;
}

- (ASN1ObjectIdentifier *)getOtherObjectTypeID {
    return self.otherObjectTypeID;
}

- (AlgorithmIdentifier *)getDigestAlgorithm {
    return self.digestAlgorithm;
}

- (DERBitString *)getObjectDigest {
    return self.objectDigest;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.digestedObjectType];
    if (self.otherObjectTypeID) {
        [localASN1EncodableVector add:self.otherObjectTypeID];
    }
    [localASN1EncodableVector add:self.digestAlgorithm];
    [localASN1EncodableVector add:self.objectDigest];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
