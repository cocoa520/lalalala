//
//  CMPObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CMPObjectIdentifiers.h"

@implementation CMPObjectIdentifiers

+ (ASN1ObjectIdentifier *)passwordBasedMac {
    static ASN1ObjectIdentifier *_passwordBasedMac = nil;
    @synchronized(self) {
        if (!_passwordBasedMac) {
            _passwordBasedMac = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113533.7.66.13"];
        }
    }
    return _passwordBasedMac;
}

+ (ASN1ObjectIdentifier *)dhBasedMac {
    static ASN1ObjectIdentifier *_dhBasedMac = nil;
    @synchronized(self) {
        if (!_dhBasedMac) {
            _dhBasedMac = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113533.7.66.30"];
        }
    }
    return _dhBasedMac;
}

+ (ASN1ObjectIdentifier *)it_caProtEncCert {
    static ASN1ObjectIdentifier *_it_caProtEncCert = nil;
    @synchronized(self) {
        if (!_it_caProtEncCert) {
            _it_caProtEncCert = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.4.1"];
        }
    }
    return _it_caProtEncCert;
}

+ (ASN1ObjectIdentifier *)it_signKeyPairTypes {
    static ASN1ObjectIdentifier *_it_signKeyPairTypes = nil;
    @synchronized(self) {
        if (!_it_signKeyPairTypes) {
            _it_signKeyPairTypes = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.4.2"];
        }
    }
    return _it_signKeyPairTypes;
}

+ (ASN1ObjectIdentifier *)it_encKeyPairTypes {
    static ASN1ObjectIdentifier *_it_encKeyPairTypes = nil;
    @synchronized(self) {
        if (!_it_encKeyPairTypes) {
            _it_encKeyPairTypes = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.4.3"];
        }
    }
    return _it_encKeyPairTypes;
}

+ (ASN1ObjectIdentifier *)it_preferredSymAlg {
    static ASN1ObjectIdentifier *_it_preferredSymAlg = nil;
    @synchronized(self) {
        if (!_it_preferredSymAlg) {
            _it_preferredSymAlg = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.4.4"];
        }
    }
    return _it_preferredSymAlg;
}

+ (ASN1ObjectIdentifier *)it_caKeyUpdateInfo {
    static ASN1ObjectIdentifier *_it_caKeyUpdateInfo = nil;
    @synchronized(self) {
        if (!_it_caKeyUpdateInfo) {
            _it_caKeyUpdateInfo = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.4.5"];
        }
    }
    return _it_caKeyUpdateInfo;
}

+ (ASN1ObjectIdentifier *)it_currentCRL {
    static ASN1ObjectIdentifier *_it_currentCRL = nil;
    @synchronized(self) {
        if (!_it_currentCRL) {
            _it_currentCRL = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.4.6"];
        }
    }
    return _it_currentCRL;
}

+ (ASN1ObjectIdentifier *)it_unsupportedOIDs {
    static ASN1ObjectIdentifier *_it_unsupportedOIDs = nil;
    @synchronized(self) {
        if (!_it_unsupportedOIDs) {
            _it_unsupportedOIDs = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.4.7"];
        }
    }
    return _it_unsupportedOIDs;
}

+ (ASN1ObjectIdentifier *)it_keyPairParamReq {
    static ASN1ObjectIdentifier *_it_keyPairParamReq = nil;
    @synchronized(self) {
        if (!_it_keyPairParamReq) {
            _it_keyPairParamReq = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.4.10"];
        }
    }
    return _it_keyPairParamReq;
}

+ (ASN1ObjectIdentifier *)it_keyPairParamRep {
    static ASN1ObjectIdentifier *_it_keyPairParamRep = nil;
    @synchronized(self) {
        if (!_it_keyPairParamRep) {
            _it_keyPairParamRep = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.4.11"];
        }
    }
    return _it_keyPairParamRep;
}

+ (ASN1ObjectIdentifier *)it_revPassphrase {
    static ASN1ObjectIdentifier *_it_revPassphrase = nil;
    @synchronized(self) {
        if (!_it_revPassphrase) {
            _it_revPassphrase = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.4.12"];
        }
    }
    return _it_revPassphrase;
}

+ (ASN1ObjectIdentifier *)it_implicitConfirm {
    static ASN1ObjectIdentifier *_it_implicitConfirm = nil;
    @synchronized(self) {
        if (!_it_implicitConfirm) {
            _it_implicitConfirm = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.4.13"];
        }
    }
    return _it_implicitConfirm;
}

+ (ASN1ObjectIdentifier *)it_confirmWaitTime {
    static ASN1ObjectIdentifier *_it_confirmWaitTime = nil;
    @synchronized(self) {
        if (!_it_confirmWaitTime) {
            _it_confirmWaitTime = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.4.14"];
        }
    }
    return _it_confirmWaitTime;
}

+ (ASN1ObjectIdentifier *)it_origPKIMessage {
    static ASN1ObjectIdentifier *_it_origPKIMessage = nil;
    @synchronized(self) {
        if (!_it_origPKIMessage) {
            _it_origPKIMessage = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.4.15"];
        }
    }
    return _it_origPKIMessage;
}

+ (ASN1ObjectIdentifier *)it_suppLangTags {
    static ASN1ObjectIdentifier *_it_suppLangTags = nil;
    @synchronized(self) {
        if (!_it_suppLangTags) {
            _it_suppLangTags = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.4.16"];
        }
    }
    return _it_suppLangTags;
}

+ (ASN1ObjectIdentifier *)id_pkip {
    static ASN1ObjectIdentifier *_id_pkip = nil;
    @synchronized(self) {
        if (!_id_pkip) {
            _id_pkip = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.5"];
        }
    }
    return _id_pkip;
}

+ (ASN1ObjectIdentifier *)id_regCtrl {
    static ASN1ObjectIdentifier *_id_regCtrl = nil;
    @synchronized(self) {
        if (!_id_regCtrl) {
            _id_regCtrl = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.5.1"];
        }
    }
    return _id_regCtrl;
}

+ (ASN1ObjectIdentifier *)id_regInfo {
    static ASN1ObjectIdentifier *_id_regInfo = nil;
    @synchronized(self) {
        if (!_id_regInfo) {
            _id_regInfo = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.5.2"];
        }
    }
    return _id_regInfo;
}

+ (ASN1ObjectIdentifier *)regCtrl_regToken {
    static ASN1ObjectIdentifier *_regCtrl_regToken = nil;
    @synchronized(self) {
        if (!_regCtrl_regToken) {
            _regCtrl_regToken = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.5.1.1"];
        }
    }
    return _regCtrl_regToken;
}

+ (ASN1ObjectIdentifier *)regCtrl_authenticator {
    static ASN1ObjectIdentifier *_regCtrl_authenticator = nil;
    @synchronized(self) {
        if (!_regCtrl_authenticator) {
            _regCtrl_authenticator = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.5.1.2"];
        }
    }
    return _regCtrl_authenticator;
}

+ (ASN1ObjectIdentifier *)regCtrl_pkiPublicationInfo {
    static ASN1ObjectIdentifier *_regCtrl_pkiPublicationInfo = nil;
    @synchronized(self) {
        if (!_regCtrl_pkiPublicationInfo) {
            _regCtrl_pkiPublicationInfo = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.5.1.3"];
        }
    }
    return _regCtrl_pkiPublicationInfo;
}

+ (ASN1ObjectIdentifier *)regCtrl_pkiArchiveOptions {
    static ASN1ObjectIdentifier *_regCtrl_pkiArchiveOptions = nil;
    @synchronized(self) {
        if (!_regCtrl_pkiArchiveOptions) {
            _regCtrl_pkiArchiveOptions = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.5.1.4"];
        }
    }
    return _regCtrl_pkiArchiveOptions;
}

+ (ASN1ObjectIdentifier *)regCtrl_oldCertID {
    static ASN1ObjectIdentifier *_regCtrl_oldCertID = nil;
    @synchronized(self) {
        if (!_regCtrl_oldCertID) {
            _regCtrl_oldCertID = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.5.1.5"];
        }
    }
    return _regCtrl_oldCertID;
}

+ (ASN1ObjectIdentifier *)regCtrl_protocolEncrKey {
    static ASN1ObjectIdentifier *_regCtrl_protocolEncrKey = nil;
    @synchronized(self) {
        if (!_regCtrl_protocolEncrKey) {
            _regCtrl_protocolEncrKey = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.5.1.6"];
        }
    }
    return _regCtrl_protocolEncrKey;
}

+ (ASN1ObjectIdentifier *)regCtrl_altCertTemplate {
    static ASN1ObjectIdentifier *_regCtrl_altCertTemplate = nil;
    @synchronized(self) {
        if (!_regCtrl_altCertTemplate) {
            _regCtrl_altCertTemplate = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.5.1.7"];
        }
    }
    return _regCtrl_altCertTemplate;
}

+ (ASN1ObjectIdentifier *)regInfo_utf8Pairs {
    static ASN1ObjectIdentifier *_regInfo_utf8Pairs = nil;
    @synchronized(self) {
        if (!_regInfo_utf8Pairs) {
            _regInfo_utf8Pairs = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.5.2.1"];
        }
    }
    return _regInfo_utf8Pairs;
}

+ (ASN1ObjectIdentifier *)regInfo_certReq {
    static ASN1ObjectIdentifier *_regInfo_certReq = nil;
    @synchronized(self) {
        if (!_regInfo_certReq) {
            _regInfo_certReq = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.5.2.2"];
        }
    }
    return _regInfo_certReq;
}

+ (ASN1ObjectIdentifier *)ct_encKeyWithID {
    static ASN1ObjectIdentifier *_ct_encKeyWithID = nil;
    @synchronized(self) {
        if (!_ct_encKeyWithID) {
            _ct_encKeyWithID = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.9.16.1.21"];
        }
    }
    return _ct_encKeyWithID;
}

@end
