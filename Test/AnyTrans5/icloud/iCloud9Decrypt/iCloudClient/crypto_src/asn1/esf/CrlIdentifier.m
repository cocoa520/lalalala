//
//  CrlIdentifier.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CrlIdentifier.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface CrlIdentifier ()

@property (nonatomic, readwrite, retain) X500Name *crlIssuer;
@property (nonatomic, readwrite, retain) ASN1UTCTime *crlIssuedTime;
@property (nonatomic, readwrite, retain) ASN1Integer *crlNumber;

@end

@implementation CrlIdentifier
@synthesize crlIssuer = _crlIssuer;
@synthesize crlIssuedTime = _crlIssuedTime;
@synthesize crlNumber = _crlNumber;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_crlIssuer) {
        [_crlIssuer release];
        _crlIssuer = nil;
    }
    if (_crlIssuedTime) {
        [_crlIssuedTime release];
        _crlIssuedTime = nil;
    }
    if (_crlNumber) {
        [_crlNumber release];
        _crlNumber = nil;
    }
    [super dealloc];
#endif
}

+ (CrlIdentifier *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CrlIdentifier class]]) {
        return (CrlIdentifier *)paramObject;
    }
    if (paramObject) {
        return [[[CrlIdentifier alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (([paramASN1Sequence size] < 2) || ([paramASN1Sequence size] > 3)) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"" userInfo:nil];
        }
        self.crlIssuer = [X500Name getInstance:[paramASN1Sequence getObjectAt:0]];
        self.crlIssuedTime = [ASN1UTCTime getInstance:[paramASN1Sequence getObjectAt:1]];
        if ([paramASN1Sequence size] > 2) {
            self.crlNumber = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:2]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamX500Name:(X500Name *)paramX500Name paramASN1UTCTime:(ASN1UTCTime *)paramASN1UTCTime
{
    if (self = [super init]) {
        [self initParamX500Name:paramX500Name paramASN1UTCTime:paramASN1UTCTime paramBigInteger:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamX500Name:(X500Name *)paramX500Name paramASN1UTCTime:(ASN1UTCTime *)paramASN1UTCTime paramBigInteger:(BigInteger *)paramBigInteger
{
    if (self = [super init]) {
        self.crlIssuer = paramX500Name;
        self.crlIssuedTime = paramASN1UTCTime;
        if (paramBigInteger) {
            ASN1Integer *integer = [[ASN1Integer alloc] initBI:paramBigInteger];
            self.crlNumber = integer;
#if !__has_feature(objc_arc)
    if (integer) [integer release]; integer = nil;
#endif
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (X500Name *)getCrlIssuer {
    return self.crlIssuer;
}

- (ASN1UTCTime *)getCrlIssuedTime {
    return self.crlIssuedTime;
}

- (BigInteger *)getCrlNumber {
    if (!self.crlNumber) {
        return nil;
    }
    return [self.crlNumber getValue];
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:[self.crlIssuer toASN1Primitive]];
    [localASN1EncodableVector add:self.crlIssuedTime];
    if (self.crlNumber) {
        [localASN1EncodableVector add:self.crlNumber];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
