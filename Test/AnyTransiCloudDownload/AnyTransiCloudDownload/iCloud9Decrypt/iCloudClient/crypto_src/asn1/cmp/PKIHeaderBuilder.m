//
//  PKIHeaderBuilder.m
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKIHeaderBuilder.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"

@interface PKIHeaderBuilder ()

@property (nonatomic, readwrite, retain) ASN1Integer *pvno;
@property (nonatomic, readwrite, retain) GeneralName *sender;
@property (nonatomic, readwrite, retain) GeneralName *recipient;
@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *messageTime;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *protectionAlg;
@property (nonatomic, readwrite, retain) ASN1OctetString *senderKID;
@property (nonatomic, readwrite, retain) ASN1OctetString *recipKID;
@property (nonatomic, readwrite, retain) ASN1OctetString *transactionID;
@property (nonatomic, readwrite, retain) ASN1OctetString *senderNonce;
@property (nonatomic, readwrite, retain) ASN1OctetString *recipNonce;
@property (nonatomic, readwrite, retain) PKIFreeText *freeText;
@property (nonatomic, readwrite, retain) ASN1Sequence *generalInfo;

@end

@implementation PKIHeaderBuilder
@synthesize pvno = _pvno;
@synthesize sender = _sender;
@synthesize recipient = _recipient;
@synthesize messageTime = _messageTime;
@synthesize protectionAlg = _protectionAlg;
@synthesize senderKID = _senderKID;
@synthesize recipKID = _recipKID;
@synthesize transactionID = _transactionID;
@synthesize senderNonce = _senderNonce;
@synthesize recipNonce = _recipNonce;
@synthesize freeText = _freeText;
@synthesize generalInfo = _generalInfo;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_pvno) {
        [_pvno release];
        _pvno = nil;
    }
    if (_sender) {
        [_sender release];
        _sender = nil;
    }
    if (_recipient) {
        [_recipient release];
        _recipient = nil;
    }
    if (_messageTime) {
        [_messageTime release];
        _messageTime = nil;
    }
    if (_protectionAlg) {
        [_protectionAlg release];
        _protectionAlg = nil;
    }
    if (_senderKID) {
        [_senderKID release];
        _senderKID = nil;
    }
    if (_recipKID) {
        [_recipKID release];
        _recipKID = nil;
    }
    if (_transactionID) {
        [_transactionID release];
        _transactionID = nil;
    }
    if (_senderNonce) {
        [_senderNonce release];
        _senderNonce = nil;
    }
    if (_recipNonce) {
        [_recipNonce release];
        _recipNonce = nil;
    }
    if (_freeText) {
        [_freeText release];
        _freeText = nil;
    }
    if (_generalInfo) {
        [_generalInfo release];
        _generalInfo = nil;
    }
    [super dealloc];
#endif
}

+ (ASN1Sequence *)makeGeneralInfoSeq:(InfoTypeAndValue *)paramInfoTypeAndValue {
    return [[[DERSequence alloc] initDERParamASN1Encodable:paramInfoTypeAndValue] autorelease];
}

+ (ASN1Sequence *)makeGeneralInfoSeqParamArrayOf:(NSMutableArray *)paramArrayOfInfoTypeAndValue {
    DERSequence *localDERSequence = nil;
    if (paramArrayOfInfoTypeAndValue) {
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        for (int i = 0; i < paramArrayOfInfoTypeAndValue.count; i++) {
            [localASN1EncodableVector add:paramArrayOfInfoTypeAndValue[i]];
        }
        localDERSequence = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
        if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    }
    return localDERSequence;
}

- (PKIHeader *)build {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.pvno];
    [localASN1EncodableVector add:self.sender];
    [localASN1EncodableVector add:self.recipient];
    [self addOptional:localASN1EncodableVector paramInt:0 paramASN1Encodable:self.messageTime];
    [self addOptional:localASN1EncodableVector paramInt:1 paramASN1Encodable:self.protectionAlg];
    [self addOptional:localASN1EncodableVector paramInt:2 paramASN1Encodable:self.senderKID];
    [self addOptional:localASN1EncodableVector paramInt:3 paramASN1Encodable:self.recipKID];
    [self addOptional:localASN1EncodableVector paramInt:4 paramASN1Encodable:self.transactionID];
    [self addOptional:localASN1EncodableVector paramInt:5 paramASN1Encodable:self.senderNonce];
    [self addOptional:localASN1EncodableVector paramInt:6 paramASN1Encodable:self.recipNonce];
    [self addOptional:localASN1EncodableVector paramInt:7 paramASN1Encodable:self.freeText];
    [self addOptional:localASN1EncodableVector paramInt:8 paramASN1Encodable:self.generalInfo];
    self.messageTime = nil;
    self.protectionAlg = nil;
    self.senderKID = nil;
    self.recipKID = nil;
    self.transactionID = nil;
    self.senderNonce = nil;
    self.recipNonce = nil;
    self.freeText = nil;
    self.generalInfo = nil;
    ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
    PKIHeader *header = [PKIHeader getInstance:sequence];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (sequence) [sequence release]; sequence = nil;
#endif
    return header;
}

- (instancetype)initParamInt:(int)paramInt paramGeneralName1:(GeneralName *)paramGeneralName1 paramGeneralName2:(GeneralName *)paramGeneralName2
{
    self = [super init];
    if (self) {
        ASN1Integer *integer = [[ASN1Integer alloc] initLong:paramInt];
        [self initParamASN1Integer:integer paramGeneralName1:paramGeneralName1 paramGeneralName2:paramGeneralName2];
#if !__has_feature(objc_arc)
        if (integer) [integer release]; integer = nil;
#endif
    }
    return self;
}

- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer paramGeneralName1:(GeneralName *)paramGeneralName1 paramGeneralName2:(GeneralName *)paramGeneralName2
{
    self = [super init];
    if (self) {
        self.pvno = paramASN1Integer;
        self.sender = paramGeneralName1;
        self.recipient = paramGeneralName2;
    }
    return self;
}

- (PKIHeaderBuilder *)getMessageTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime {
    self.messageTime = paramASN1GeneralizedTime;
    return self;
}

- (PKIHeaderBuilder *)getProtectionAlg:(AlgorithmIdentifier *)paramAlgorithmIdentifier {
    self.protectionAlg = paramAlgorithmIdentifier;
    return self;
}

- (PKIHeaderBuilder *)getSenderKID:(NSMutableData *)paramArrayOfByte {
    ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
    PKIHeaderBuilder *hB = [self getSenderKIDs:(paramArrayOfByte == nil ? nil : octetString)];
#if !__has_feature(objc_arc)
    if (octetString) [octetString release]; octetString = nil;
#endif
    return hB;
}

- (PKIHeaderBuilder *)getSenderKIDs:(ASN1OctetString *)paramASN1OctetString {
    self.senderKID = paramASN1OctetString;
    return self;
}

- (PKIHeaderBuilder *)getRecipKID:(NSMutableData *)paramArrayOfByte {
    DEROctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
    PKIHeaderBuilder *hB = [self getRecipKIDs:(paramArrayOfByte == nil ? nil : octetString)];
#if !__has_feature(objc_arc)
    if (octetString) [octetString release]; octetString = nil;
#endif
    return hB;
}

- (PKIHeaderBuilder *)getRecipKIDs:(DEROctetString *)paramASN1OctetString {
    self.recipKID = paramASN1OctetString;
    return self;
}

- (PKIHeaderBuilder *)getTransactionID:(NSMutableData *)paramArrayOfByte {
    ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
    PKIHeaderBuilder *hB = [self getTransactionIDs:(paramArrayOfByte == nil ? nil : octetString)];
#if !__has_feature(objc_arc)
    if (octetString) [octetString release]; octetString = nil;
#endif
    return hB;
}

- (PKIHeaderBuilder *)getTransactionIDs:(ASN1OctetString *)paramASN1OctetString {
    self.transactionID = paramASN1OctetString;
    return self;
}

- (PKIHeaderBuilder *)getSenderNonce:(NSMutableData *)paramArrayOfByte {
    ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
    PKIHeaderBuilder *hB = [self getSenderNonces:(paramArrayOfByte == nil ? nil : octetString)];
#if !__has_feature(objc_arc)
    if (octetString) [octetString release]; octetString = nil;
#endif
    return hB;
}

- (PKIHeaderBuilder *)getSenderNonces:(ASN1OctetString *)paramASN1OctetString {
    self.senderNonce = paramASN1OctetString;
    return self;
}

- (PKIHeaderBuilder *)getsetRecipNonce:(NSMutableData *)paramArrayOfByte {
    ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
    PKIHeaderBuilder *hB = [self getsetRecipNonces:(paramArrayOfByte == nil ? nil : octetString)];
#if !__has_feature(objc_arc)
    if (octetString) [octetString release]; octetString = nil;
#endif
    return hB;
}

- (PKIHeaderBuilder *)getsetRecipNonces:(ASN1OctetString *)paramASN1OctetString {
    self.recipNonce = paramASN1OctetString;
    return self;
}

- (PKIHeaderBuilder *)getFreeText:(PKIFreeText *)paramPKIFreeText {
    self.freeText = paramPKIFreeText;
    return self;
}

- (PKIHeaderBuilder *)getGeneralInfo:(InfoTypeAndValue *)paramInfoTypeAndValue {
    return [self getGeneralInfoParamASN1Sequence:[PKIHeaderBuilder makeGeneralInfoSeq:paramInfoTypeAndValue]];
}

- (PKIHeaderBuilder *)getGeneralInfoParamArrayOf:(NSMutableArray *)paramArrayOfInfoTypeAndValue {
    return [self getGeneralInfoParamASN1Sequence:[PKIHeaderBuilder makeGeneralInfoSeqParamArrayOf:paramArrayOfInfoTypeAndValue]];
}

- (PKIHeaderBuilder *)getGeneralInfoParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence {
    self.generalInfo = paramASN1Sequence;
    return self;
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
