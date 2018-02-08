//
//  PKIMessages.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKIMessage.h"
#import "CMPCertificate.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"
#import "CategoryExtend.h"

@interface PKIMessage ()

@property (nonatomic, readwrite, retain) PKIHeader *header;
@property (nonatomic, readwrite, retain) PKIBody *body;
@property (nonatomic, readwrite, retain) DERBitString *protection;
@property (nonatomic, readwrite, retain) ASN1Sequence *extraCerts;

@end

@implementation PKIMessage
@synthesize header = _header;
@synthesize body = _body;
@synthesize protection = _protection;
@synthesize extraCerts = _extraCerts;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_header) {
        [_header release];
        _header = nil;
    }
    if (_body) {
        [_body release];
        _body = nil;
    }
    if (_protection) {
        [_protection release];
        _protection = nil;
    }
    if (_extraCerts) {
        [_extraCerts release];
        _extraCerts = nil;
    }
    [super dealloc];
#endif
}

+ (PKIMessage *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PKIMessage class]]) {
        return (PKIMessage *)paramObject;
    }
    if (paramObject) {
        return [[[PKIMessage alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.header = [PKIHeader getInstance:[localEnumeration nextObject]];
        self.body = [PKIBody getInstance:[localEnumeration nextObject]];
        ASN1TaggedObject *localASN1TaggedObject = nil;
        while (localASN1TaggedObject = [localEnumeration nextObject]) {
            if ([localASN1TaggedObject getTagNo] == 0) {
                self.protection = [DERBitString getInstance:localASN1TaggedObject paramBoolean:TRUE];
            }else {
                self.extraCerts = [ASN1Sequence getInstance:localASN1TaggedObject paramBoolean:TRUE];
            }
        }
    }
    return self;
}

- (instancetype)initParamPKIHeader:(PKIHeader *)paramPKIHeader paramPKIBody:(PKIBody *)paramPKIBody paramDERBitString:(DERBitString *)paramDERBitString paramArrayOfCMPCertificate:(NSMutableArray *)paramArrayOfCMPCertificate
{
    self = [super init];
    if (self) {
        self.header = paramPKIHeader;
        self.body = paramPKIBody;
        self.protection = paramDERBitString;
        if (paramArrayOfCMPCertificate) {
            ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
            for (int i = 0; i < paramArrayOfCMPCertificate.count; i++) {
                [localASN1EncodableVector add:paramArrayOfCMPCertificate[i]];
            }
            ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
            self.extraCerts = sequence;
#if !__has_feature(objc_arc)
            if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
            if (sequence) [sequence release]; sequence = nil;
#endif
        }
    }
    return self;
}

- (instancetype)initParamPKIHeader:(PKIHeader *)paramPKIHeader paramPKIBody:(PKIBody *)paramPKIBody paramDERBitString:(DERBitString *)paramDERBitString
{
    self = [super init];
    if (self) {
        [self initParamPKIHeader:paramPKIHeader paramPKIBody:paramPKIBody paramDERBitString:paramDERBitString paramArrayOfCMPCertificate:nil];
    }
    return self;
}

- (instancetype)initParamPKIHeader:(PKIHeader *)paramPKIHeader paramPKIBody:(PKIBody *)paramPKIBody
{
    self = [super init];
    if (self) {
        [self initParamPKIHeader:paramPKIHeader paramPKIBody:paramPKIBody paramDERBitString:nil paramArrayOfCMPCertificate:nil];
    }
    return self;
}

- (PKIHeader *)getHeader {
    return self.header;
}

- (PKIBody *)getBody {
    return self.body;
}

- (DERBitString *)getProtection {
    return self.protection;
}

- (NSMutableArray *)getExtraCerts {
    if (!self.extraCerts) {
        return nil;
    }
    NSMutableArray *arrayOfCMPCertificate = [[[NSMutableArray alloc] initWithSize:[self.extraCerts size]] autorelease];
    for (int i = 0; i < arrayOfCMPCertificate.count; i++) {
        arrayOfCMPCertificate[i] = [CMPCertificate getInstance:[self.extraCerts getObjectAt:i]];
    }
    return arrayOfCMPCertificate;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.header];
    [localASN1EncodableVector add:self.body];
    [self addOptional:localASN1EncodableVector paramInt:0 paramASN1Encodable:self.protection];
    [self addOptional:localASN1EncodableVector paramInt:1 paramASN1Encodable:self.extraCerts];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (void)addOptional:(ASN1EncodableVector *)paramASN1EncodableVector paramInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable {
    if (paramASN1Encodable) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:TRUE paramInt:paramInt paramASN1Encodable:paramASN1Encodable];
        [paramASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
}

@end
