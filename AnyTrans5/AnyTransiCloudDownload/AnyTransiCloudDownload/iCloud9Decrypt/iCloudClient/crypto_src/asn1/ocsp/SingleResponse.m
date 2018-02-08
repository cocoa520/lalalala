//  SingleResponse.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SingleResponse.h"
#import "ASN1Sequence.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface SingleResponse ()

@property (nonatomic, readwrite, retain) CertID *certID;
@property (nonatomic, readwrite, retain) CertStatus *certStatus;
@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *thisUpdate;
@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *nextUpdate;
@property (nonatomic, readwrite, retain) Extensions *singleExtensions;

@end

@implementation SingleResponse
@synthesize certID = _certID;
@synthesize certStatus = _certStatus;
@synthesize thisUpdate = _thisUpdate;
@synthesize nextUpdate = _nextUpdate;
@synthesize singleExtensions = _singleExtensions;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_certID) {
        [_certID release];
        _certID = nil;
    }
    if (_certStatus) {
        [_certStatus release];
        _certStatus = nil;
    }
    if (_thisUpdate) {
        [_thisUpdate release];
        _thisUpdate = nil;
    }
    if (_nextUpdate) {
        [_nextUpdate release];
        _nextUpdate = nil;
    }
    if (_singleExtensions) {
        [_singleExtensions release];
        _singleExtensions = nil;
    }
    [super dealloc];
#endif
}

+ (SingleResponse *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[SingleResponse class]]) {
        return (SingleResponse *)paramObject;
    }
    if (paramObject) {
        return [[[SingleResponse alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (SingleResponse *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [SingleResponse getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.certID = [CertID getInstance:[paramASN1Sequence getObjectAt:0]];
        self.certStatus = [CertStatus getInstance:[paramASN1Sequence getObjectAt:1]];
        self.thisUpdate = [ASN1GeneralizedTime getInstance:[paramASN1Sequence getObjectAt:2]];
        if ([paramASN1Sequence size] > 4) {
            self.nextUpdate = [ASN1GeneralizedTime getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:3] paramBoolean:YES];
            self.singleExtensions = [Extensions getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:4] paramBoolean:YES];
        }else if ([paramASN1Sequence size] > 3) {
            ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)[paramASN1Sequence getObjectAt:3];
            if ([localASN1TaggedObject getTagNo] == 0) {
                self.nextUpdate = [ASN1GeneralizedTime getInstance:localASN1TaggedObject paramBoolean:YES];
            }else {
                self.singleExtensions = [Extensions getInstance:localASN1TaggedObject paramBoolean:YES];
            }
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamCertID:(CertID *)paramCertID paramCertStatus:(CertStatus *)paramCertStatus paramASN1GeneralizedTime1:(ASN1GeneralizedTime *)paramASN1GeneralizedTime1 paramASN1GeneralizedTime2:(ASN1GeneralizedTime *)paramASN1GeneralizedTime2 paramX509Extensions:(X509Extensions *)paramX509Extensions
{
    if (self = [super init]) {
        [self initParamCertID:paramCertID paramCertStatus:paramCertStatus paramASN1GeneralizedTime1:paramASN1GeneralizedTime1 paramASN1GeneralizedTime2:paramASN1GeneralizedTime2 paramExtensions:[Extensions getInstance:paramX509Extensions]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamCertID:(CertID *)paramCertID paramCertStatus:(CertStatus *)paramCertStatus paramASN1GeneralizedTime1:(ASN1GeneralizedTime *)paramASN1GeneralizedTime1 paramASN1GeneralizedTime2:(ASN1GeneralizedTime *)paramASN1GeneralizedTime2 paramExtensions:(Extensions *)paramExtensions
{
    if (self = [super init]) {
        self.certID = paramCertID;
        self.certStatus = paramCertStatus;
        self.thisUpdate = paramASN1GeneralizedTime1;
        self.nextUpdate = paramASN1GeneralizedTime2;
        self.singleExtensions = paramExtensions;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (CertID *)getCertID {
    return self.certID;
}

- (CertStatus *)getCertStatus {
    return self.certStatus;
}

- (ASN1GeneralizedTime *)getThisUpdate {
    return self.thisUpdate;
}

- (ASN1GeneralizedTime *)getNextUpdate {
    return self.nextUpdate;
}

- (Extensions *)getSingleExtensions {
    return self.singleExtensions;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.certID];
    [localASN1EncodableVector add:self.certStatus];
    [localASN1EncodableVector add:self.thisUpdate];
    if (self.nextUpdate) {
        ASN1Encodable *updateEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.nextUpdate];
        [localASN1EncodableVector add:updateEncodable];
#if !__has_feature(objc_arc)
        if (updateEncodable) [updateEncodable release]; updateEncodable = nil;
#endif
    }
    if (self.singleExtensions) {
        ASN1Encodable *extensions = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:self.singleExtensions];
        [localASN1EncodableVector add:extensions];
#if !__has_feature(objc_arc)
        if (extensions) [extensions release]; extensions = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
