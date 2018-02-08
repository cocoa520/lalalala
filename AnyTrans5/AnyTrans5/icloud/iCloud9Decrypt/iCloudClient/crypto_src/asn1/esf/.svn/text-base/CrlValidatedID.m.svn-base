//
//  CrlValidatedID.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CrlValidatedID.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface CrlValidatedID ()

@property (nonatomic, readwrite, retain) OtherHash *crlHash;
@property (nonatomic, readwrite, retain) CrlIdentifier *crlIdentifier;

@end

@implementation CrlValidatedID
@synthesize crlHash = _crlHash;
@synthesize crlIdentifier = _crlIdentifier;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_crlHash) {
        [_crlHash release];
        _crlHash = nil;
    }
    if (_crlIdentifier) {
        [_crlIdentifier release];
        _crlIdentifier = nil;
    }
    [super dealloc];
#endif
}

+ (CrlValidatedID *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CrlValidatedID class]]) {
        return (CrlValidatedID *)paramObject;
    }
    if (paramObject) {
        return [[[CrlValidatedID alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (([paramASN1Sequence size] < 1) || ([paramASN1Sequence size] > 2)) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.crlHash = [OtherHash getInstance:[paramASN1Sequence getObjectAt:0]];
        if ([paramASN1Sequence size] > 1) {
            self.crlIdentifier = [CrlIdentifier getInstance:[paramASN1Sequence getObjectAt:1]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamOtherHash:(OtherHash *)paramOtherHash
{
    if (self = [super init]) {
        [self initParamOtherHash:paramOtherHash paramCrlIdentifier:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamOtherHash:(OtherHash *)paramOtherHash paramCrlIdentifier:(CrlIdentifier *)paramCrlIdentifier
{
    self = [super init];
    if (self) {
        self.crlHash = paramOtherHash;
        self.crlIdentifier = paramCrlIdentifier;
    }
    return self;
}

- (OtherHash *)getCrlHash {
    return self.crlHash;
}

- (CrlIdentifier *)getCrlIdentifier {
    return self.crlIdentifier;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:[self.crlHash toASN1Primitive]];
    if (self.crlIdentifier) {
        [localASN1EncodableVector add:[self.crlIdentifier toASN1Primitive]];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
