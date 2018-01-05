//
//  PKIBody.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKIBody.h"
#import "ASN1TaggedObject.h"
#import "DERTaggedObject.h"
#import "CertRepMessage.h"
#import "CertificationRequest.h"
#import "POPODecKeyChallContent.h"
#import "POPODecKeyRespContent.h"
#import "CertReqMessages.h"
#import "KeyRecRepContent.h"
#import "CAKeyUpdAnnContent.h"
#import "CMPCertificate.h"
#import "RevReqContent.h"
#import "RevRepContent.h"
#import "RevAnnContent.h"
#import "CRLAnnContent.h"
#import "PKIConfirmContent.h"
#import "PKIMessages.h"
#import "GenMsgContent.h"
#import "GenRepContent.h"
#import "ErrorMsgContent.h"
#import "CertConfirmContent.h"
#import "PollReqContent.h"
#import "PollRepContent.h"

@interface PKIBody ()

@property (nonatomic, assign) int tagNo;
@property (nonatomic, readwrite, retain) ASN1Encodable *body;

@end

@implementation PKIBody
@synthesize tagNo = _tagNo;
@synthesize body = _body;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_body) {
        [_body release];
        _body = nil;
    }
    [super dealloc];
#endif
}

+ (int)TYPE_INIT_REQ {
    static int _TYPE_INIT_REQ = 0;
    @synchronized(self) {
        if (!_TYPE_INIT_REQ) {
            _TYPE_INIT_REQ = 0;
        }
    }
    return _TYPE_INIT_REQ;
}

+ (int)TYPE_INIT_REP {
    static int _TYPE_INIT_REP = 0;
    @synchronized(self) {
        if (!_TYPE_INIT_REP) {
            _TYPE_INIT_REP = 1;
        }
    }
    return _TYPE_INIT_REP;
}

+ (int)TYPE_CERT_REQ {
    static int _TYPE_CERT_REQ = 0;
    @synchronized(self) {
        if (!_TYPE_CERT_REQ) {
            _TYPE_CERT_REQ = 2;
        }
    }
    return _TYPE_CERT_REQ;
}

+ (int)TYPE_CERT_REP {
    static int _TYPE_CERT_REP = 0;
    @synchronized(self) {
        if (!_TYPE_CERT_REP) {
            _TYPE_CERT_REP = 3;
        }
    }
    return _TYPE_CERT_REP;
}

+ (int)TYPE_P10_CERT_REQ {
    static int _TYPE_P10_CERT_REQ = 0;
    @synchronized(self) {
        if (!_TYPE_P10_CERT_REQ) {
            _TYPE_P10_CERT_REQ = 4;
        }
    }
    return _TYPE_P10_CERT_REQ;
}

+ (int)TYPE_POPO_CHALL {
    static int _TYPE_POPO_CHALL = 0;
    @synchronized(self) {
        if (!_TYPE_POPO_CHALL) {
            _TYPE_POPO_CHALL = 5;
        }
    }
    return _TYPE_POPO_CHALL;
}

+ (int)TYPE_POPO_REP {
    static int _TYPE_POPO_REP = 0;
    @synchronized(self) {
        if (!_TYPE_POPO_REP) {
            _TYPE_POPO_REP = 6;
        }
    }
    return _TYPE_POPO_REP;
}

+ (int)TYPE_KEY_UPDATE_REQ {
    static int _TYPE_KEY_UPDATE_REQ = 0;
    @synchronized(self) {
        if (!_TYPE_KEY_UPDATE_REQ) {
            _TYPE_KEY_UPDATE_REQ = 7;
        }
    }
    return _TYPE_KEY_UPDATE_REQ;
}

+ (int)TYPE_KEY_UPDATE_REP {
    static int _TYPE_KEY_UPDATE_REP = 0;
    @synchronized(self) {
        if (!_TYPE_KEY_UPDATE_REP) {
            _TYPE_KEY_UPDATE_REP = 8;
        }
    }
    return _TYPE_KEY_UPDATE_REP;
}

+ (int)TYPE_KEY_RECOVERY_REQ {
    static int _TYPE_KEY_RECOVERY_REQ = 0;
    @synchronized(self) {
        if (!_TYPE_KEY_RECOVERY_REQ) {
            _TYPE_KEY_RECOVERY_REQ = 9;
        }
    }
    return _TYPE_KEY_RECOVERY_REQ;
}

+ (int)TYPE_KEY_RECOVERY_REP {
    static int _TYPE_KEY_RECOVERY_REP = 0;
    @synchronized(self) {
        if (!_TYPE_KEY_RECOVERY_REP) {
            _TYPE_KEY_RECOVERY_REP = 10;
        }
    }
    return _TYPE_KEY_RECOVERY_REP;
}

+ (int)TYPE_REVOCATION_REQ {
    static int _TYPE_REVOCATION_REQ = 0;
    @synchronized(self) {
        if (!_TYPE_REVOCATION_REQ) {
            _TYPE_REVOCATION_REQ = 11;
        }
    }
    return _TYPE_REVOCATION_REQ;
}

+ (int)TYPE_REVOCATION_REP {
    static int _TYPE_REVOCATION_REP = 0;
    @synchronized(self) {
        if (!_TYPE_REVOCATION_REP) {
            _TYPE_REVOCATION_REP = 12;
        }
    }
    return _TYPE_REVOCATION_REP;
}

+ (int)TYPE_CROSS_CERT_REQ {
    static int _TYPE_CROSS_CERT_REQ = 0;
    @synchronized(self) {
        if (!_TYPE_CROSS_CERT_REQ) {
            _TYPE_CROSS_CERT_REQ = 13;
        }
    }
    return _TYPE_CROSS_CERT_REQ;
}

+ (int)TYPE_CROSS_CERT_REP {
    static int _TYPE_CROSS_CERT_REP = 0;
    @synchronized(self) {
        if (!_TYPE_CROSS_CERT_REP) {
            _TYPE_CROSS_CERT_REP = 14;
        }
    }
    return _TYPE_CROSS_CERT_REP;
}

+ (int)TYPE_CA_KEY_UPDATE_ANN {
    static int _TYPE_CA_KEY_UPDATE_ANN = 0;
    @synchronized(self) {
        if (!_TYPE_CA_KEY_UPDATE_ANN) {
            _TYPE_CA_KEY_UPDATE_ANN = 15;
        }
    }
    return _TYPE_CA_KEY_UPDATE_ANN;
}

+ (int)TYPE_CERT_ANN {
    static int _TYPE_CERT_ANN = 0;
    @synchronized(self) {
        if (!_TYPE_CERT_ANN) {
            _TYPE_CERT_ANN = 16;
        }
    }
    return _TYPE_CERT_ANN;
}

+ (int)TYPE_REVOCATION_ANN {
    static int _TYPE_REVOCATION_ANN = 0;
    @synchronized(self) {
        if (!_TYPE_REVOCATION_ANN) {
            _TYPE_REVOCATION_ANN = 17;
        }
    }
    return _TYPE_REVOCATION_ANN;
}

+ (int)TYPE_CRL_ANN {
    static int _TYPE_CRL_ANN = 0;
    @synchronized(self) {
        if (!_TYPE_CRL_ANN) {
            _TYPE_CRL_ANN = 18;
        }
    }
    return _TYPE_CRL_ANN;
}

+ (int)TYPE_CONFIRM {
    static int _TYPE_CONFIRM = 0;
    @synchronized(self) {
        if (!_TYPE_CONFIRM) {
            _TYPE_CONFIRM = 19;
        }
    }
    return _TYPE_CONFIRM;
}

+ (int)TYPE_NESTED {
    static int _TYPE_NESTED = 0;
    @synchronized(self) {
        if (!_TYPE_NESTED) {
            _TYPE_NESTED = 20;
        }
    }
    return _TYPE_NESTED;
}

+ (int)TYPE_GEN_MSG {
    static int _TYPE_GEN_MSG = 0;
    @synchronized(self) {
        if (!_TYPE_GEN_MSG) {
            _TYPE_GEN_MSG = 21;
        }
    }
    return _TYPE_GEN_MSG;
}

+ (int)TYPE_GEN_REP {
    static int _TYPE_GEN_REP = 0;
    @synchronized(self) {
        if (!_TYPE_GEN_REP) {
            _TYPE_GEN_REP = 22;
        }
    }
    return _TYPE_GEN_REP;
}

+ (int)TYPE_ERROR {
    static int _TYPE_ERROR = 0;
    @synchronized(self) {
        if (!_TYPE_ERROR) {
            _TYPE_ERROR = 23;
        }
    }
    return _TYPE_ERROR;
}

+ (int)TYPE_CERT_CONFIRM {
    static int _TYPE_CERT_CONFIRM = 0;
    @synchronized(self) {
        if (!_TYPE_CERT_CONFIRM) {
            _TYPE_CERT_CONFIRM = 24;
        }
    }
    return _TYPE_CERT_CONFIRM;
}

+ (int)TYPE_POLL_REQ {
    static int _TYPE_POLL_REQ = 0;
    @synchronized(self) {
        if (!_TYPE_POLL_REQ) {
            _TYPE_POLL_REQ = 25;
        }
    }
    return _TYPE_POLL_REQ;
}

+ (int)TYPE_POLL_REP {
    static int _TYPE_POLL_REP = 0;
    @synchronized(self) {
        if (!_TYPE_POLL_REP) {
            _TYPE_POLL_REP = 26;
        }
    }
    return _TYPE_POLL_REP;
}

+ (PKIBody *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[PKIBody class]]) {
        return (PKIBody *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        return [[[PKIBody alloc] initParamASN1TaggedObject:(ASN1TaggedObject *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Invalid object: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamASN1TaggedObject:(ASN1TaggedObject *)paramASN1TaggedObject
{
    self = [super init];
    if (self) {
        self.tagNo = [paramASN1TaggedObject getTagNo];
        self.body = [PKIBody getBodyForType:self.tagNo paramASN1Encodable:[paramASN1TaggedObject getObject]];
    }
    return self;
}

- (instancetype)initParamInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    self = [super init];
    if (self) {
        self.tagNo = paramInt;
        self.body = [PKIBody getBodyForType:paramInt paramASN1Encodable:paramASN1Encodable];
    }
    return self;
}

+ (ASN1Encodable *)getBodyForType:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable {
    switch (paramInt) {
        case 0:
            return [CertRepMessage getInstance:paramASN1Encodable];
        case 1:
            return [CertRepMessage getInstance:paramASN1Encodable];
        case 2:
            return [CertRepMessage getInstance:paramASN1Encodable];
        case 3:
            return [CertRepMessage getInstance:paramASN1Encodable];
        case 4:
            return [CertificationRequest getInstance:paramASN1Encodable];
        case 5:
            return [POPODecKeyChallContent getInstance:paramASN1Encodable];
        case 6:
            return [POPODecKeyRespContent getInstance:paramASN1Encodable];
        case 7:
            return [CertReqMessages getInstance:paramASN1Encodable];
        case 8:
            return [CertReqMessages getInstance:paramASN1Encodable];
        case 9:
            return [CertReqMessages getInstance:paramASN1Encodable];
        case 10:
            return [KeyRecRepContent getInstance:paramASN1Encodable];
        case 11:
            return [RevReqContent getInstance:paramASN1Encodable];
        case 12:
            return [RevRepContent getInstance:paramASN1Encodable];
        case 13:
            return [CertReqMessages getInstance:paramASN1Encodable];
        case 14:
            return [CertRepMessage getInstance:paramASN1Encodable];
        case 15:
            return [CAKeyUpdAnnContent getInstance:paramASN1Encodable];
        case 16:
            return [CMPCertificate getInstance:paramASN1Encodable];
        case 17:
            return [RevAnnContent getInstance:paramASN1Encodable];
        case 18:
            return [CRLAnnContent getInstance:paramASN1Encodable];
        case 19:
            return [PKIConfirmContent getInstance:paramASN1Encodable];
        case 20:
            return [PKIMessages getInstance:paramASN1Encodable];
        case 21:
            return [GenMsgContent getInstance:paramASN1Encodable];
        case 22:
            return [GenRepContent getInstance:paramASN1Encodable];
        case 23:
            return [ErrorMsgContent getInstance:paramASN1Encodable];
        case 24:
            return [CertConfirmContent getInstance:paramASN1Encodable];
        case 25:
            return [PollReqContent getInstance:paramASN1Encodable];
        case 26:
            return [PollRepContent getInstance:paramASN1Encodable];
        default:
            break;
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown tag number: %d", paramInt] userInfo:nil];
}

- (int)getType {
    return self.tagNo;
}

- (ASN1Encodable *)getContent {
    return self.body;
}

- (ASN1Primitive *)toASN1Primitive {
    return [[[DERTaggedObject alloc] initParamBoolean:TRUE paramInt:self.tagNo paramASN1Encodable:self.body] autorelease];
}

@end
