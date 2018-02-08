//
//  KeyRecRepContent.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "KeyRecRepContent.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"
#import "CategoryExtend.h"

@interface KeyRecRepContent ()

@property (nonatomic, readwrite, retain) PKIStatusInfo *status;
@property (nonatomic, readwrite, retain) CMPCertificate *nSC;
@property (nonatomic, readwrite, retain) ASN1Sequence *caCerts;
@property (nonatomic, readwrite, retain) ASN1Sequence *keyPairHist;

@end

@implementation KeyRecRepContent
@synthesize status = _status;
@synthesize nSC = _nSC;
@synthesize caCerts = _caCerts;
@synthesize keyPairHist = _keyPairHist;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_status) {
        [_status release];
        _status = nil;
    }
    if (_nSC) {
        [_nSC release];
        _nSC = nil;
    }
    if (_caCerts) {
        [_caCerts release];
        _caCerts = nil;
    }
    if (_keyPairHist) {
        [_keyPairHist release];
        _keyPairHist = nil;
    }
    [super dealloc];
#endif
}

+ (KeyRecRepContent *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[KeyRecRepContent class]]) {
        return (KeyRecRepContent *)paramObject;
    }
    if (paramObject) {
        return [[[KeyRecRepContent alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.status = [PKIStatusInfo getInstance:[localEnumeration nextObject]];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            ASN1TaggedObject *localASN1TaggedObject = [ASN1TaggedObject getInstance:localObject];
            switch ([localASN1TaggedObject getTagNo]) {
                case 0:
                    self.nSC = [CMPCertificate getInstance:[localASN1TaggedObject getObject]];
                    break;
                case 1:
                    self.caCerts = [ASN1Sequence getInstance:[localASN1TaggedObject getObject]];
                    break;
                case 2:
                    self.keyPairHist = [ASN1Sequence getInstance:[localASN1TaggedObject getObject]];
                    break;
                default:
                    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown tag number: %d", [localASN1TaggedObject getTagNo]] userInfo:nil];
                    break;
            }
        }
    }
    return self;
}

- (PKIStatusInfo *)getStatus {
    return self.status;
}

- (CMPCertificate *)getNewSigCert {
    return self.nSC;
}

- (NSMutableArray *)getCaCerts {
    if (!self.caCerts) {
        return nil;
    }
    NSMutableArray *arrayOfCMPCertificate = [[[NSMutableArray alloc] initWithSize:[self.caCerts size]] autorelease];
    for (int i = 0; i != arrayOfCMPCertificate.count; i++) {
        arrayOfCMPCertificate[i] = [CMPCertificate getInstance:[self.caCerts getObjectAt:i]];
    }
    return arrayOfCMPCertificate;
}

- (NSMutableArray *)getKeyPairHist {
    if (!self.keyPairHist) {
        return nil;
    }
    NSMutableArray *arrayOfCertifiedKeyPair = [[[NSMutableArray alloc] initWithSize:[self.keyPairHist size]] autorelease];
    for (int i = 0; i != arrayOfCertifiedKeyPair.count; i++) {
        arrayOfCertifiedKeyPair[i] = [CMPCertificate getInstance:[self.keyPairHist getObjectAt:i]];
    }
    return arrayOfCertifiedKeyPair;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.status];
    [self addOptional:localASN1EncodableVector paramInt:0 paramASN1Encodable:self.nSC];
    [self addOptional:localASN1EncodableVector paramInt:1 paramASN1Encodable:self.caCerts];
    [self addOptional:localASN1EncodableVector paramInt:2 paramASN1Encodable:self.keyPairHist];
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
