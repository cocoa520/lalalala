//
//  TBSCertList.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "TBSCertList.h"
#import "ASN1UTCTime.h"
#import "ASN1GeneralizedTime.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@implementation TBSCertList
@synthesize version = _version;
@synthesize signature = _signature;
@synthesize issuer = _issuer;
@synthesize thisUpdate = _thisUpdate;
@synthesize nextUpdate = _nextUpdate;
@synthesize revokedCertificates = _revokedCertificates;
@synthesize crlExtensions = _crlExtensions;

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
    if (_revokedCertificates) {
        [_revokedCertificates release];
        _revokedCertificates = nil;
    }
    if (_crlExtensions) {
        [_crlExtensions release];
        _crlExtensions = nil;
    }
    [super dealloc];
#endif
}

+ (TBSCertList *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[TBSCertList class]]) {
        return (TBSCertList *)paramObject;
    }
    if (paramObject) {
        return [[[TBSCertList alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (TBSCertList *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean{
    return [TBSCertList getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (([paramASN1Sequence size] < 3) || ([paramASN1Sequence size] > 7)) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        int i = 0;
        if ([[paramASN1Sequence getObjectAt:i] isKindOfClass:[ASN1Integer class]]) {
            self.version = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:i++]];
        }else {
            self.version = nil;
        }
        self.signature = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:i++]];
        self.issuer = [X500Name getInstance:[paramASN1Sequence getObjectAt:i++]];
        self.thisUpdate = [Time getInstance:[paramASN1Sequence getObjectAt:i++]];
        if ((i < [paramASN1Sequence size]) && (([[paramASN1Sequence getObjectAt:i] isKindOfClass:[ASN1UTCTime class]]) || ([[paramASN1Sequence getObjectAt:i] isKindOfClass:[ASN1GeneralizedTime class]]) || ([[paramASN1Sequence getObjectAt:i] isKindOfClass:[Time class]]))) {
            self.nextUpdate = [Time getInstance:[paramASN1Sequence getObjectAt:i++]];
        }
        if ((i < [paramASN1Sequence size]) && (![[paramASN1Sequence getObjectAt:i] isKindOfClass:[DERTaggedObject class]])) {
            self.revokedCertificates = [ASN1Sequence getInstance:[paramASN1Sequence getObjectAt:i++]];
        }
        if ((i < [paramASN1Sequence size]) && (![[paramASN1Sequence getObjectAt:i] isKindOfClass:[DERTaggedObject class]])) {
            self.crlExtensions = [Extensions getInstance:[ASN1Sequence getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:i] paramBoolean:YES]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (int)getVersionNumber {
    if (!self.version) {
        return 1;
    }
    return [[self.version getValue] intValue] + 1;
}

- (ASN1Integer *)getVersion {
    return self.version;
}

- (AlgorithmIdentifier *)getSignature {
    return self.signature;
}

- (X500Name *)getIssuer {
    return self.issuer;
}

- (Time *)getThisUpdate {
    return self.thisUpdate;
}

- (Time *)getNextUpdate {
    return self.nextUpdate;
}

- (NSMutableArray *)getRevokedCertificates {
    if (!self.revokedCertificates) {
        return [[[NSMutableArray alloc] initWithSize:0] autorelease];
    }
    NSMutableArray *arrayOfCRLEntry = [[[NSMutableArray alloc] initWithSize:(int)[self.revokedCertificates size]] autorelease];
    for (int i = 0; i < [arrayOfCRLEntry count]; i++) {
        arrayOfCRLEntry[i] = [CRLEntry getInstance:[self.revokedCertificates getObjectAt:i]];
    }
    return arrayOfCRLEntry;
}

- (NSEnumerator *)getRevokedCertificateEnumeration {
    if (!self.revokedCertificates) {
        return [[[EmptyEnumeration alloc] init] autorelease];
    }
    return nil;
}

- (Extensions *)getExtensions {
    return self.crlExtensions;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.version) {
        [localASN1EncodableVector add:self.version];
    }
    [localASN1EncodableVector add:self.signature];
    [localASN1EncodableVector add:self.issuer];
    [localASN1EncodableVector add:self.thisUpdate];
    if (self.nextUpdate) {
        [localASN1EncodableVector add:self.nextUpdate];
    }
    if (self.revokedCertificates) {
        [localASN1EncodableVector add:self.revokedCertificates];
    }
    if (self.crlExtensions) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamInt:0 paramASN1Encodable:self.crlExtensions];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end

@implementation CRLEntry
@synthesize seq = _seq;
@synthesize crlEntryExtensions = _crlEntryExtensions;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_seq) {
        [_seq release];
        _seq = nil;
    }
    if (_crlEntryExtensions) {
        [_crlEntryExtensions release];
        _crlEntryExtensions = nil;
    }
    [super dealloc];
#endif
}

+ (CRLEntry *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CRLEntry class]]) {
        return (CRLEntry *)paramObject;
    }
    if (paramObject) {
        return [[[CRLEntry alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (([paramASN1Sequence size] < 2) || ([paramASN1Sequence size] > 3)) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.seq = paramASN1Sequence;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (ASN1Integer *)getUserCertificate {
    return [ASN1Integer getInstance:[self.seq getObjectAt:0]];
}

- (Time *)getRevocationDate {
    return [Time getInstance:[self.seq getObjectAt:1]];
}

- (Extensions *)getExtensions {
    if (self.crlEntryExtensions && ([self.seq size] == 3)) {
        self.crlEntryExtensions = [Extensions getInstance:[self.seq getObjectAt:2]];
    }
    return self.crlEntryExtensions;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.seq;
}

- (BOOL)hasExtensions {
    return ([self.seq size] == 3);
}

@end

@implementation EmptyEnumeration

- (instancetype)init
{
    if (self = [super init]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BOOL)hasMoreElements {
    return NO;
}

- (id)nextElement {
    @throw [NSException exceptionWithName:NSGenericException reason:@"Empty Enumeration" userInfo:nil];
}

@end

@interface RevokedCertificatesEnumeration ()

@property (nonatomic, readwrite, retain) NSEnumerator *en;

@end

@implementation RevokedCertificatesEnumeration
@synthesize en = _en;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_en) {
        [_en release];
        _en = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initParamEnumeration:(NSEnumerator *)paramEnumeration
{
    if (self = [super init]) {
        self.en = paramEnumeration;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BOOL)hasMoreElements {
    return (BOOL)[self.en nextObject];
}

- (id)nextElement {
    return [CRLEntry getInstance:[self.en nextObject]];
}

@end
