//
//  TSTInfo.m
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "TSTInfo.h"
#import "ASN1Sequence.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface TSTInfo ()

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *tsaPolicyId;
@property (nonatomic, readwrite, retain) MessageImprint *messageImprint;
@property (nonatomic, readwrite, retain) ASN1Integer *serialNumber;
@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *genTime;
@property (nonatomic, readwrite, retain) Accuracy *accuracy;
@property (nonatomic, readwrite, retain) ASN1Boolean *ordering;
@property (nonatomic, readwrite, retain) ASN1Integer *nonce;
@property (nonatomic, readwrite, retain) GeneralName *tsa;
@property (nonatomic, readwrite, retain) Extensions *extensions;

@end

@implementation TSTInfo
@synthesize version = _version;
@synthesize tsaPolicyId = _tsaPolicyId;
@synthesize messageImprint = _messageImprint;
@synthesize serialNumber = _serialNumber;
@synthesize genTime = _genTime;
@synthesize accuracy = _accuracy;
@synthesize ordering = _ordering;
@synthesize nonce = _nonce;
@synthesize tsa = _tsa;
@synthesize extensions = _extensions;

+ (TSTInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[TSTInfo class]]) {
        return (TSTInfo *)paramObject;
    }
    if (paramObject) {
        return [[[TSTInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.version = [ASN1Integer getInstance:[localEnumeration nextObject]];
        self.tsaPolicyId = [ASN1ObjectIdentifier getInstance:[localEnumeration nextObject]];
        self.messageImprint = [MessageImprint getInstance:[localEnumeration nextObject]];
        self.serialNumber = [ASN1Integer getInstance:[localEnumeration nextObject]];
        self.genTime = [ASN1GeneralizedTime getInstance:[localEnumeration nextObject]];
        self.ordering = [ASN1Boolean getInstanceBoolean:NO];
        ASN1Object *localASN1Object = nil;
        while (localASN1Object = [localEnumeration nextObject]) {
            if ([localASN1Object isKindOfClass:[ASN1TaggedObject class]]) {
                DERTaggedObject *localDERTaggedObject = (DERTaggedObject *)localASN1Object;
                switch ([localDERTaggedObject getTagNo]) {
                    case 0:
                        self.tsa = [GeneralName getInstance:localDERTaggedObject paramBoolean:YES];
                        break;
                    case 1:
                        self.extensions = [Extensions getInstance:localDERTaggedObject paramBoolean:NO];
                        break;
                    default:
                        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Unknown tag value %d", [localDERTaggedObject getTagNo]] userInfo:nil];
                        break;
                }
            }else if ([localASN1Object isKindOfClass:[ASN1Sequence class]] || [localASN1Object isKindOfClass:[Accuracy class]]) {
                self.accuracy = [Accuracy getInstance:localASN1Object];
            }else if ([localASN1Object isKindOfClass:[ASN1Boolean class]]) {
                self.ordering = [ASN1Boolean getInstanceObject:localASN1Object];
            }else if ([localASN1Object isKindOfClass:[ASN1Integer class]]) {
                self.nonce = [ASN1Integer getInstance:localASN1Object];
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

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramMessageImprint:(MessageImprint *)paramMessageImprint paramASN1Integer1:(ASN1Integer *)paramASN1Integer1 paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramAccuracy:(Accuracy *)paramAccuracy paramASN1Boolean:(ASN1Boolean *)paramASN1Boolean paramASN1Integer2:(ASN1Integer *)paramASN1Integer2 paramGeneralName:(GeneralName *)paramGeneralName paramExtensions:(Extensions *)paramExtensions
{
    if (self = [super init]) {
        ASN1Integer *integer = [[ASN1Integer alloc] initLong:1];
        self.version = integer;
        self.tsaPolicyId = paramASN1ObjectIdentifier;
        self.messageImprint = paramMessageImprint;
        self.serialNumber = paramASN1Integer1;
        self.genTime = paramASN1GeneralizedTime;
        self.accuracy = paramAccuracy;
        self.ordering = paramASN1Boolean;
        self.nonce = paramASN1Integer2;
        self.tsa = paramGeneralName;
        self.extensions = paramExtensions;
#if !__has_feature(objc_arc)
    if (integer) [integer release]; integer = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)dealloc
{
    [self setVersion:nil];
    [self setTsaPolicyId:nil];
    [self setMessageImprint:nil];
    [self setSerialNumber:nil];
    [self setGenTime:nil];
    [self setAccuracy:nil];
    [self setOrdering:nil];
    [self setNonce:nil];
    [self setTsa:nil];
    [self setExtensions:nil];
    [super dealloc];
}

- (ASN1Integer *)getVersion {
    return self.version;
}

- (MessageImprint *)getMessageImprint {
    return self.messageImprint;
}

- (ASN1ObjectIdentifier *)getPolicy {
    return self.tsaPolicyId;
}

- (ASN1Integer *)getSerialNumber {
    return self.serialNumber;
}

- (Accuracy *)getAccuracy {
    return self.accuracy;
}

- (ASN1GeneralizedTime *)getGenTime {
    return self.genTime;
}

- (ASN1Boolean *)getOrdering {
    return self.ordering;
}

- (ASN1Integer *)getNonce {
    return self.nonce;
}

- (GeneralName *)getTsa {
    return self.tsa;
}

- (Extensions *)getExtensions {
    return self.extensions;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.version];
    [localASN1EncodableVector add:self.tsaPolicyId];
    [localASN1EncodableVector add:self.messageImprint];
    [localASN1EncodableVector add:self.serialNumber];
    [localASN1EncodableVector add:self.genTime];
    if (self.accuracy) {
        [localASN1EncodableVector add:self.accuracy];
    }
    if (self.ordering && [self.ordering isTrue]) {
        [localASN1EncodableVector add:self.ordering];
    }
    if (self.nonce) {
        [localASN1EncodableVector add:self.nonce];
    }
    if (self.tsa) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.tsa];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    if (self.extensions) {
        [localASN1EncodableVector add:self.extensions];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
