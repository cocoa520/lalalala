//
//  V2TBSCertListGenerator.m
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "V2TBSCertListGenerator.h"
#import "CRLReason.h"
#import "DERSequence.h"
#import "DEROctetString.h"
#import "DERTaggedObject.h"
#import "CategoryExtend.h"

@interface V2TBSCertListGenerator ()

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *signature;
@property (nonatomic, readwrite, retain) X500Name *issuer;
@property (nonatomic, readwrite, retain) Time *thisUpdate;
@property (nonatomic, readwrite, retain) Time *nextUpdate;
@property (nonatomic, readwrite, retain) Extensions *extensions;
@property (nonatomic, readwrite, retain) ASN1EncodableVector *crlentries;

@end

@implementation V2TBSCertListGenerator
@synthesize version = _version;
@synthesize signature = _signature;
@synthesize issuer = _issuer;
@synthesize thisUpdate = _thisUpdate;
@synthesize nextUpdate = _nextUpdate;
@synthesize extensions = _extensions;
@synthesize crlentries = _crlentries;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_signature) {
        [_signature release];
        _signature = nil;
    }
    if (_issuer) {
        [_issuer release];
        _issuer = nil;
    }
    if (_thisUpdate) {
        [_thisUpdate release];
        _thisUpdate = nil;
    }
    if (_nextUpdate) {
        [_nextUpdate release];
        _nextUpdate = nil;
    }
    if (_extensions) {
        [_extensions release];
        _extensions = nil;
    }
    if (_crlentries) {
        [_crlentries release];
        _crlentries = nil;
    }
    [super dealloc];
#endif
}

+ (NSMutableArray *)reasons {
    static NSMutableArray *_reasons = nil;
    @synchronized(self) {
        if (!_reasons) {
            _reasons = [[NSMutableArray alloc] initWithSize:11];
        }
    }
    return _reasons;
}

+ (ASN1Sequence *)createReasonExtension:(int)paramInt {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    CRLReason *localCRLReason = [CRLReason lookup:paramInt];
    @try {
        [localASN1EncodableVector add:[Extension reasonCode]];
        ASN1Encodable *encodable = [[DEROctetString alloc] initDEROctetString:[localCRLReason getEncoded]];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"error encoding reason: %@", exception.description] userInfo:nil];
    }
    ASN1Sequence *sequence = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return sequence;
}

+ (ASN1Sequence *)createInvalidityDateExtension:(ASN1GeneralizedTime *)paramASN1GeneralizedTime {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    @try {
        [localASN1EncodableVector add:[Extension invalidityDate]];
        ASN1Encodable *encodable = [[DEROctetString alloc] initDEROctetString:[paramASN1GeneralizedTime getEncoded]];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"error encoding reason: %@", exception.description] userInfo:nil];
    }
    ASN1Sequence *sequence = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return sequence;
}

- (TBSCertList *)generateTBSCertList {
    if (!self.signature || !self.issuer || !self.thisUpdate) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Not all mandatory fields set in V2 TBSCertList generator." userInfo:nil];
    }
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.version];
    [localASN1EncodableVector add:self.signature];
    [localASN1EncodableVector add:self.issuer];
    [localASN1EncodableVector add:self.thisUpdate];
    if (self.nextUpdate) {
        [localASN1EncodableVector add:self.nextUpdate];
    }
    if ([self.crlentries size] != 0) {
        ASN1Encodable *encodable = [[DERSequence alloc] initDERParamASN1EncodableVector:self.crlentries];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    if (self.extensions) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamInt:0 paramASN1Encodable:self.extensions];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
    TBSCertList *tbs = [[[TBSCertList alloc] initParamASN1Sequence:sequence] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (sequence) [sequence release]; sequence = nil;
#endif
    return tbs;
}

- (void)setVersion:(ASN1Integer *)version {
    if (_version != version) {
        _version = [[[ASN1Integer alloc] initLong:1] autorelease];
    }
}

- (void)setIssuerParamX509Name:(X509Name *)paramX509Name {
    self.issuer = [X500Name getInstance:[paramX509Name toASN1Primitive]];
}

- (void)setThisUpdateParamASN1UTCTime:(ASN1UTCTime *)paramASN1UTCTime {
    Time *time = [[Time alloc] initParamASN1Primitive:paramASN1UTCTime];
    self.thisUpdate = time;
#if !__has_feature(objc_arc)
    if (time) [time release]; time = nil;
#endif
}

- (void)setNextUpdateParamASN1UTCTime:(ASN1UTCTime *)paramASN1UTCTime {
    Time *time = [[Time alloc] initParamASN1Primitive:paramASN1UTCTime];
    self.nextUpdate = time;
#if !__has_feature(objc_arc)
    if (time) [time release]; time = nil;
#endif
}

- (void)setExtensionsParamX509Extensions:(X509Extensions *)paramX509Extensions {
    [self setExtensions:[Extensions getInstance:paramX509Extensions]];
}

- (void)addCRLEntry:(ASN1Sequence *)paramASN1Sequence {
    [self.crlentries add:paramASN1Sequence];
}

- (void)addCRLEntry:(ASN1Integer *)paramASN1Integer paramASN1UTCTime:(ASN1UTCTime *)paramASN1UTCTime paramInt:(int)paramInt {
    Time *time = [[Time alloc] initParamASN1Primitive:paramASN1UTCTime];
    [self addCRLEntry:paramASN1Integer paramTime:time paramInt:paramInt];
#if !__has_feature(objc_arc)
    if (time) [time release]; time = nil;
#endif
}

- (void)addCRLEntry:(ASN1Integer *)paramASN1Integer paramTime:(Time *)paramTime paramInt:(int)paramInt {
    [self addCRLEntry:paramASN1Integer paramTime:paramTime paramInt:paramInt paramASN1GeneralizedTime:nil];
}

- (void)addCRLEntry:(ASN1Integer *)paramASN1Integer paramTime:(Time *)paramTime paramInt:(int)paramInt paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime {
    ASN1EncodableVector *localASN1EncodableVector;
    if (paramInt) {
        localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        if (paramInt < [[V2TBSCertListGenerator reasons] count]) {
            if (paramInt < 0) {
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"invalid reason value: %d", paramInt] userInfo:nil];
            }
            [localASN1EncodableVector add:[V2TBSCertListGenerator reasons][paramInt]];
        }else {
            [localASN1EncodableVector add:[V2TBSCertListGenerator createReasonExtension:paramInt]];
        }
        if (paramASN1GeneralizedTime) {
            [localASN1EncodableVector add:[V2TBSCertListGenerator createInvalidityDateExtension:paramASN1GeneralizedTime]];
        }
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
        [self internalAddCRLEntry:paramASN1Integer paramTime:paramTime paramASN1Sequence:sequence];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (sequence) [sequence release]; sequence = nil;
#endif
    }else if (paramASN1GeneralizedTime) {
        localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        [localASN1EncodableVector add:[V2TBSCertListGenerator createInvalidityDateExtension:paramASN1GeneralizedTime]];
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
        [self internalAddCRLEntry:paramASN1Integer paramTime:paramTime paramASN1Sequence:sequence];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (sequence) [sequence release]; sequence = nil;
#endif
    }else {
        [self addCRLEntry:paramASN1Integer paramTime:paramTime paramExtensions:nil];
    }
}

- (void)addCRLEntry:(ASN1Integer *)paramASN1Integer paramTime:(Time *)paramTime paramExtensions:(Extensions *)paramExtensions {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:paramASN1Integer];
    [localASN1EncodableVector add:paramTime];
    if (paramExtensions) {
        [localASN1EncodableVector add:paramExtensions];
    }
    ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
    [self addCRLEntry:sequence];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (sequence) [sequence release]; sequence = nil;
#endif
}

- (void)internalAddCRLEntry:(ASN1Integer *)paramASN1Integer paramTime:(Time *)paramTime paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:paramASN1Integer];
    [localASN1EncodableVector add:paramTime];
    if (paramASN1Sequence) {
        [localASN1EncodableVector add:paramASN1Sequence];
    }
    ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
    [self addCRLEntry:sequence];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (sequence) [sequence release]; sequence = nil;
#endif
}



@end
