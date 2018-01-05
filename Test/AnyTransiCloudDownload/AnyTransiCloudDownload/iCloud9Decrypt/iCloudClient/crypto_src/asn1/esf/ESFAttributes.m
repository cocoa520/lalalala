//
//  ESFAttributes.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ESFAttributes.h"
#import "PKCSObjectIdentifiers.h"

@implementation ESFAttributes

+ (ASN1ObjectIdentifier *)sigPolicyId {
    static ASN1ObjectIdentifier *_sigPolicyId = nil;
    @synchronized(self) {
        if (!_sigPolicyId) {
            _sigPolicyId = [[PKCSObjectIdentifiers id_aa_ets_sigPolicyId] retain];
        }
    }
    return _sigPolicyId;
}

+ (ASN1ObjectIdentifier *)commitmentType {
    static ASN1ObjectIdentifier *_commitmentType = nil;
    @synchronized(self) {
        if (!_commitmentType) {
            _commitmentType = [[PKCSObjectIdentifiers id_aa_ets_commitmentType] retain];
        }
    }
    return _commitmentType;
}

+ (ASN1ObjectIdentifier *)signerLocation {
    static ASN1ObjectIdentifier *_signerLocation = nil;
    @synchronized(self) {
        if (!_signerLocation) {
            _signerLocation = [[PKCSObjectIdentifiers id_aa_ets_signerLocation] retain];
        }
    }
    return _signerLocation;
}

+ (ASN1ObjectIdentifier *)signerAttr {
    static ASN1ObjectIdentifier *_signerAttr = nil;
    @synchronized(self) {
        if (!_signerAttr) {
            _signerAttr = [[PKCSObjectIdentifiers id_aa_ets_signerAttr] retain];
        }
    }
    return _signerAttr;
}

+ (ASN1ObjectIdentifier *)otherSigCert {
    static ASN1ObjectIdentifier *_otherSigCert = nil;
    @synchronized(self) {
        if (!_otherSigCert) {
            _otherSigCert = [[PKCSObjectIdentifiers id_aa_ets_otherSigCert] retain];
        }
    }
    return _otherSigCert;
}

+ (ASN1ObjectIdentifier *)contentTimestamp {
    static ASN1ObjectIdentifier *_contentTimestamp = nil;
    @synchronized(self) {
        if (!_contentTimestamp) {
            _contentTimestamp = [[PKCSObjectIdentifiers id_aa_ets_contentTimestamp] retain];
        }
    }
    return _contentTimestamp;
}

+ (ASN1ObjectIdentifier *)certificateRefs {
    static ASN1ObjectIdentifier *_certificateRefs = nil;
    @synchronized(self) {
        if (!_certificateRefs) {
            _certificateRefs = [[PKCSObjectIdentifiers id_aa_ets_certificateRefs] retain];
        }
    }
    return _certificateRefs;
}

+ (ASN1ObjectIdentifier *)revocationRefs {
    static ASN1ObjectIdentifier *_revocationRefs = nil;
    @synchronized(self) {
        if (!_revocationRefs) {
            _revocationRefs = [[PKCSObjectIdentifiers id_aa_ets_revocationRefs] retain];
        }
    }
    return _revocationRefs;
}

+ (ASN1ObjectIdentifier *)certValues {
    static ASN1ObjectIdentifier *_proofOfOrigin = nil;
    @synchronized(self) {
        if (!_proofOfOrigin) {
            _proofOfOrigin = [[PKCSObjectIdentifiers id_aa_ets_certValues] retain];
        }
    }
    return _proofOfOrigin;
}

+ (ASN1ObjectIdentifier *)revocationValues {
    static ASN1ObjectIdentifier *_revocationValues = nil;
    @synchronized(self) {
        if (!_revocationValues) {
            _revocationValues = [[PKCSObjectIdentifiers id_aa_ets_revocationValues] retain];
        }
    }
    return _revocationValues;
}

+ (ASN1ObjectIdentifier *)escTimeStamp {
    static ASN1ObjectIdentifier *_escTimeStamp = nil;
    @synchronized(self) {
        if (!_escTimeStamp) {
            _escTimeStamp = [[PKCSObjectIdentifiers id_aa_ets_escTimeStamp] retain];
        }
    }
    return _escTimeStamp;
}

+ (ASN1ObjectIdentifier *)certCRLTimestamp {
    static ASN1ObjectIdentifier *_certCRLTimestamp = nil;
    @synchronized(self) {
        if (!_certCRLTimestamp) {
            _certCRLTimestamp = [[PKCSObjectIdentifiers id_aa_ets_certCRLTimestamp] retain];
        }
    }
    return _certCRLTimestamp;
}

+ (ASN1ObjectIdentifier *)archiveTimestamp {
    static ASN1ObjectIdentifier *_archiveTimestamp = nil;
    @synchronized(self) {
        if (!_archiveTimestamp) {
            _archiveTimestamp = [[PKCSObjectIdentifiers id_aa_ets_archiveTimestamp] retain];
        }
    }
    return _archiveTimestamp;
}

+ (ASN1ObjectIdentifier *)archiveTimestampV2 {
    static ASN1ObjectIdentifier *_archiveTimestampV2 = nil;
    @synchronized(self) {
        if (!_archiveTimestampV2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[PKCSObjectIdentifiers id_aa] branch:@"48"] retain];
            }
            _archiveTimestampV2 = [branchObj retain];
        }
    }
    return _archiveTimestampV2;
}

@end
