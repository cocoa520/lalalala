//
//  PKIFailureInfo.m
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKIFailureInfo.h"

@implementation PKIFailureInfo

+ (int)badAlg {
    static int _badAlg = 0;
    @synchronized(self) {
        if (!_badAlg) {
            _badAlg = 128;
        }
    }
    return _badAlg;
}

+ (int)badMessageCheck {
    static int _badMessageCheck = 0;
    @synchronized(self) {
        if (!_badMessageCheck) {
            _badMessageCheck = 64;
        }
    }
    return _badMessageCheck;
}

+ (int)badRequest {
    static int _badRequest = 0;
    @synchronized(self) {
        if (!_badRequest) {
            _badRequest = 32;
        }
    }
    return _badRequest;
}

+ (int)badTime {
    static int _badTime = 0;
    @synchronized(self) {
        if (!_badTime) {
            _badTime = 16;
        }
    }
    return _badTime;
}

+ (int)badCertId {
    static int _badCertId = 0;
    @synchronized(self) {
        if (!_badCertId) {
            _badCertId = 8;
        }
    }
    return _badCertId;
}

+ (int)badDataFormat {
    static int _badDataFormat = 0;
    @synchronized(self) {
        if (!_badDataFormat) {
            _badDataFormat = 4;
        }
    }
    return _badDataFormat;
}

+ (int)wrongAuthority {
    static int _wrongAuthority = 0;
    @synchronized(self) {
        if (!_wrongAuthority) {
            _wrongAuthority = 2;
        }
    }
    return _wrongAuthority;
}

+ (int)incorrectData {
    static int _incorrectData = 0;
    @synchronized(self) {
        if (!_incorrectData) {
            _incorrectData = 1;
        }
    }
    return _incorrectData;
}

+ (int)missingTimeStamp {
    static int _missingTimeStamp = 0;
    @synchronized(self) {
        if (!_missingTimeStamp) {
            _missingTimeStamp = 32768;
        }
    }
    return _missingTimeStamp;
}

+ (int)badPOP {
    static int _badPOP = 0;
    @synchronized(self) {
        if (!_badPOP) {
            _badPOP = 16384;
        }
    }
    return _badPOP;
}

+ (int)certRevoked {
    static int _certRevoked = 0;
    @synchronized(self) {
        if (!_certRevoked) {
            _certRevoked = 8192;
        }
    }
    return _certRevoked;
}

+ (int)certConfirmed {
    static int _certConfirmed = 0;
    @synchronized(self) {
        if (!_certConfirmed) {
            _certConfirmed = 4096;
        }
    }
    return _certConfirmed;
}

+ (int)wrongIntegrity {
    static int _wrongIntegrity = 0;
    @synchronized(self) {
        if (!_wrongIntegrity) {
            _wrongIntegrity = 2048;
        }
    }
    return _wrongIntegrity;
}

+ (int)badRecipientNonce {
    static int _badRecipientNonce = 0;
    @synchronized(self) {
        if (!_badRecipientNonce) {
            _badRecipientNonce = 1024;
        }
    }
    return _badRecipientNonce;
}

+ (int)timeNotAvailable {
    static int _timeNotAvailable = 0;
    @synchronized(self) {
        if (!_timeNotAvailable) {
            _timeNotAvailable = 512;
        }
    }
    return _timeNotAvailable;
}

+ (int)unacceptedPolicy {
    static int _unacceptedPolicy = 0;
    @synchronized(self) {
        if (!_unacceptedPolicy) {
            _unacceptedPolicy = 256;
        }
    }
    return _unacceptedPolicy;
}

+ (int)unacceptedExtension {
    static int _unacceptedExtension = 0;
    @synchronized(self) {
        if (!_unacceptedExtension) {
            _unacceptedExtension = 8388608;
        }
    }
    return _unacceptedExtension;
}

+ (int)addInfoNotAvailable {
    static int _addInfoNotAvailable = 0;
    @synchronized(self) {
        if (!_addInfoNotAvailable) {
            _addInfoNotAvailable = 4194304;
        }
    }
    return _addInfoNotAvailable;
}

+ (int)badSenderNonce {
    static int _badSenderNonce = 0;
    @synchronized(self) {
        if (!_badSenderNonce) {
            _badSenderNonce = 2097152;
        }
    }
    return _badSenderNonce;
}

+ (int)badCertTemplate {
    static int _badCertTemplate = 0;
    @synchronized(self) {
        if (!_badCertTemplate) {
            _badCertTemplate = 1048576;
        }
    }
    return _badCertTemplate;
}

+ (int)signerNotTrusted {
    static int _signerNotTrusted = 0;
    @synchronized(self) {
        if (!_signerNotTrusted) {
            _signerNotTrusted = 524288;
        }
    }
    return _signerNotTrusted;
}

+ (int)transactionIdInUse {
    static int _transactionIdInUse = 0;
    @synchronized(self) {
        if (!_transactionIdInUse) {
            _transactionIdInUse = 262144;
        }
    }
    return _transactionIdInUse;
}

+ (int)unsupportedVersion {
    static int _unsupportedVersion = 0;
    @synchronized(self) {
        if (!_unsupportedVersion) {
            _unsupportedVersion = 131072;
        }
    }
    return _unsupportedVersion;
}

+ (int)notAuthorized {
    static int _notAuthorized = 0;
    @synchronized(self) {
        if (!_notAuthorized) {
            _notAuthorized = 65536;
        }
    }
    return _notAuthorized;
}

+ (int)systemUnavail {
    static int _systemUnavail = 0;
    @synchronized(self) {
        if (!_systemUnavail) {
            _systemUnavail = 0;
        }
    }
    return _systemUnavail;
}

+ (int)systemFailure {
    static int _systemFailure = 0;
    @synchronized(self) {
        if (!_systemFailure) {
            _systemFailure = 1073741824;
        }
    }
    return _systemFailure;
}

+ (int)duplicateCertReq {
    static int _duplicateCertReq = 0;
    @synchronized(self) {
        if (!_duplicateCertReq) {
            _duplicateCertReq = 536870912;
        }
    }
    return _duplicateCertReq;
}

+ (int)BAD_ALG {
    static int _BAD_ALG = 0;
    @synchronized(self) {
        if (!_BAD_ALG) {
            _BAD_ALG = 128;
        }
    }
    return _BAD_ALG;
}

+ (int)BAD_MESSAGE_CHECK {
    static int _BAD_MESSAGE_CHECK = 0;
    @synchronized(self) {
        if (!_BAD_MESSAGE_CHECK) {
            _BAD_MESSAGE_CHECK = 64;
        }
    }
    return _BAD_MESSAGE_CHECK;
}

+ (int)BAD_REQUEST {
    static int _BAD_REQUEST = 0;
    @synchronized(self) {
        if (!_BAD_REQUEST) {
            _BAD_REQUEST = 32;
        }
    }
    return _BAD_REQUEST;
}

+ (int)BAD_TIME {
    static int _BAD_TIME = 0;
    @synchronized(self) {
        if (!_BAD_TIME) {
            _BAD_TIME = 16;
        }
    }
    return _BAD_TIME;
}

+ (int)BAD_CERT_ID {
    static int _BAD_CERT_ID = 0;
    @synchronized(self) {
        if (!_BAD_CERT_ID) {
            _BAD_CERT_ID = 8;
        }
    }
    return _BAD_CERT_ID;
}

+ (int)BAD_DATA_FORMAT {
    static int _BAD_DATA_FORMAT = 0;
    @synchronized(self) {
        if (!_BAD_DATA_FORMAT) {
            _BAD_DATA_FORMAT = 4;
        }
    }
    return _BAD_DATA_FORMAT;
}

+ (int)WRONG_AUTHORITY {
    static int _WRONG_AUTHORITY = 0;
    @synchronized(self) {
        if (!_WRONG_AUTHORITY) {
            _WRONG_AUTHORITY = 2;
        }
    }
    return _WRONG_AUTHORITY;
}

+ (int)INCORRECT_DATA {
    static int _INCORRECT_DATA = 0;
    @synchronized(self) {
        if (!_INCORRECT_DATA) {
            _INCORRECT_DATA = 1;
        }
    }
    return _INCORRECT_DATA;
}

+ (int)MISSING_TIME_STAMP {
    static int _MISSING_TIME_STAMP = 0;
    @synchronized(self) {
        if (!_MISSING_TIME_STAMP) {
            _MISSING_TIME_STAMP = 32768;
        }
    }
    return _MISSING_TIME_STAMP;
}

+ (int)BAD_POP {
    static int _BAD_POP = 0;
    @synchronized(self) {
        if (!_BAD_POP) {
            _BAD_POP = 16384;
        }
    }
    return _BAD_POP;
}

+ (int)TIME_NOT_AVAILABLE {
    static int _TIME_NOT_AVAILABLE = 0;
    @synchronized(self) {
        if (!_TIME_NOT_AVAILABLE) {
            _TIME_NOT_AVAILABLE = 512;
        }
    }
    return _TIME_NOT_AVAILABLE;
}

+ (int)UNACCEPTED_POLICY {
    static int _UNACCEPTED_POLICY = 0;
    @synchronized(self) {
        if (!_UNACCEPTED_POLICY) {
            _UNACCEPTED_POLICY = 256;
        }
    }
    return _UNACCEPTED_POLICY;
}

+ (int)UNACCEPTED_EXTENSION {
    static int _UNACCEPTED_EXTENSION = 0;
    @synchronized(self) {
        if (!_UNACCEPTED_EXTENSION) {
            _UNACCEPTED_EXTENSION = 8388608;
        }
    }
    return _UNACCEPTED_EXTENSION;
}

+ (int)ADD_INFO_NOT_AVAILABLE {
    static int _ADD_INFO_NOT_AVAILABLE = 0;
    @synchronized(self) {
        if (!_ADD_INFO_NOT_AVAILABLE) {
            _ADD_INFO_NOT_AVAILABLE = 4194304;
        }
    }
    return _ADD_INFO_NOT_AVAILABLE;
}

+ (int)SYSTEM_FAILURE {
    static int _SYSTEM_FAILURE = 0;
    @synchronized(self) {
        if (!_SYSTEM_FAILURE) {
            _SYSTEM_FAILURE = 1073741824;
        }
    }
    return _SYSTEM_FAILURE;
}

- (instancetype)initParamInt:(int)paramInt
{
    self = [super initParamArrayOfByte:[ASN1BitString getBytes:paramInt] paramInt:[ASN1BitString getPadBits:paramInt]];
    if (self) {
    }
    return self;
}

- (instancetype)initParamDERBitString:(DERBitString *)paramDERBitString
{
    self = [super initParamArrayOfByte:[paramDERBitString getBytes] paramInt:[paramDERBitString getPadBits]];
    if (self) {
    }
    return self;
}

- (NSString *)toString {
    return @"PKIFailureInfo: 0x";
}

@end
