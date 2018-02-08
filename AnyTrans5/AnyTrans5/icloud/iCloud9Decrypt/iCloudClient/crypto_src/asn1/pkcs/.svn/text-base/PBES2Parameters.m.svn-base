//
//  PBES2Parameters.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PBES2Parameters.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "PBKDF2Params.h"

@interface PBES2Parameters ()

@property (nonatomic, readwrite, retain) KeyDerivationFunc *func;
@property (nonatomic, readwrite, retain) EncryptionScheme *scheme;

@end

@implementation PBES2Parameters
@synthesize func = _func;
@synthesize scheme = _scheme;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_func) {
        [_func release];
        _func = nil;
    }
    if (_scheme) {
        [_scheme release];
        _scheme = nil;
    }
    [super dealloc];
#endif
}

+ (PBES2Parameters *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PBES2Parameters class]]) {
        return (PBES2Parameters *)paramObject;
    }
    if (paramObject) {
        return [[[PBES2Parameters alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        ASN1Sequence *localASN1Sequence = [ASN1Sequence getInstance:[(ASN1Encodable *)[localEnumeration nextObject] toASN1Primitive]];
        if ([[localASN1Sequence getObjectAt:0] isEqual:[PKCSObjectIdentifiers id_PBKDF2]]) {
            KeyDerivationFunc *keyFunc = [[KeyDerivationFunc alloc] initParamASN1ObjectIdentifier:[PKCSObjectIdentifiers id_PBKDF2] paramASN1Encodable:[PBKDF2Params getInstance:[localASN1Sequence getObjectAt:1]]];
            self.func = keyFunc;
        }else {
            self.func = [KeyDerivationFunc getInstance:localASN1Sequence];
        }
        self.scheme = [EncryptionScheme getInstance:[localEnumeration nextObject]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (instancetype)initParamKeyDerivationFunc:(KeyDerivationFunc *)paramKeyDerivationFunc paramEncryptionScheme:(EncryptionScheme *)paramEncryptionScheme
{
    if (self = [super init]) {
        self.func = paramKeyDerivationFunc;
        self.scheme = paramEncryptionScheme;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (KeyDerivationFunc *)getKeyDerivationFunc {
    return self.func;
}

- (EncryptionScheme *)getEncryptionScheme {
    return self.scheme;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.func];
    [localASN1EncodableVector add:self.scheme];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
