//
//  PKIHeader.m
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKIHeader.h"
#import "InfoTypeAndValue.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"
#import "X500Name.h"

@interface PKIHeader ()

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

@implementation PKIHeader
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

+ (GeneralName *)NULL_NAME {
    static GeneralName *_NULL_NAME = nil;
    @synchronized(self) {
        if (!_NULL_NAME) {
            DERSequence *sequence = [[DERSequence alloc] init];
            _NULL_NAME = [[GeneralName alloc] initParamX500Name:[X500Name getInstance:sequence]];
#if !__has_feature(objc_arc)
    if (sequence) [sequence release]; sequence = nil;
#endif
        }
    }
    return _NULL_NAME;
}

+ (int)CMP_1999 {
    static int _CMP_1999 = 0;
    @synchronized(self) {
        if (!_CMP_1999) {
            _CMP_1999 = 1;
        }
    }
    return _CMP_1999;
}

+ (int)CMP_2000 {
    static int _CMP_2000 = 0;
    @synchronized(self) {
        if (!_CMP_2000) {
            _CMP_2000 = 2;
        }
    }
    return _CMP_2000;
}

+ (PKIHeader *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PKIHeader class]]) {
        return (PKIHeader *)paramObject;
    }
    if (paramObject) {
        return [[[PKIHeader alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.pvno = [ASN1Integer getInstance:[localEnumeration nextObject]];
        self.sender = [GeneralName getInstance:[localEnumeration nextObject]];
        self.recipient = [GeneralName getInstance:[localEnumeration nextObject]];
        ASN1TaggedObject *localASN1TaggedObject = nil;
        while (localASN1TaggedObject = [localEnumeration nextObject]) {
            switch ([localASN1TaggedObject getTagNo]) {
                case 0:
                    self.messageTime = [ASN1GeneralizedTime getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                case 1:
                    self.protectionAlg = [AlgorithmIdentifier getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                case 2:
                    self.senderKID = [ASN1OctetString getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                case 3:
                    self.recipKID = [ASN1OctetString getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                case 4:
                    self.transactionID = [ASN1OctetString getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                case 5:
                    self.senderNonce = [ASN1OctetString getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                case 6:
                    self.recipNonce = [ASN1OctetString getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                case 7:
                    self.freeText = [PKIFreeText getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                case 8:
                    self.generalInfo = [ASN1Sequence getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                default:
                    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown tag number: %d", [localASN1TaggedObject getTagNo]] userInfo:nil];
                    break;
            }
        }
    }
    return self;
}

- (instancetype)initParamInt:(int)paramInt paramGeneralName1:(GeneralName *)paramGeneralName1 paramGeneralName2:(GeneralName *)paramGeneralName2
{
    if (self = [super init]) {
        ASN1Integer *integer = [[ASN1Integer alloc] initLong:paramInt];
        [self initParamASN1Integer:integer paramGeneralName1:paramGeneralName1 paramGeneralName2:paramGeneralName2];
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

- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer paramGeneralName1:(GeneralName *)paramGeneralName1 paramGeneralName2:(GeneralName *)paramGeneralName2
{
    if (self = [super init]) {
        self.pvno = paramASN1Integer;
        self.sender = paramGeneralName1;
        self.recipient = paramGeneralName2;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Integer *)getPvno {
    return self.pvno;
}

- (GeneralName *)getSender {
    return self.sender;
}

- (GeneralName *)getRecipient {
    return self.recipient;
}

- (ASN1GeneralizedTime *)getMessageTime {
    return self.messageTime;
}

- (AlgorithmIdentifier *)getProtectionAlg {
    return self.protectionAlg;
}

- (ASN1OctetString *)getSenderKID {
    return self.senderKID;
}

- (ASN1OctetString *)getRecipKID {
    return self.recipKID;
}

- (ASN1OctetString *)getTransactionID {
    return self.transactionID;
}

- (ASN1OctetString *)getSenderNonce {
    return self.senderNonce;
}

- (ASN1OctetString *)getRecipNonce {
    return self.recipNonce;
}

- (PKIFreeText *)gerFreeText {
    return self.freeText;
}

- (NSMutableArray *)getGeneralInfo {
    if (!self.generalInfo) {
        return nil;
    }
    NSMutableArray *arrayOfInfoTypeAndValue = [[[NSMutableArray alloc] initWithSize:(int)[self.generalInfo size]] autorelease];
    for (int i = 0; i < arrayOfInfoTypeAndValue.count; i++) {
        arrayOfInfoTypeAndValue[i] = [InfoTypeAndValue getInstance:[self.generalInfo getObjectAt:i]];
    }
    return arrayOfInfoTypeAndValue;
}

- (ASN1Primitive *)toASN1Primitive {
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
