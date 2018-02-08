//
//  CommitmentTypeIdentifier.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CommitmentTypeIdentifier.h"
#import "PKCSObjectIdentifiers.h"

@implementation CommitmentTypeIdentifier

+ (ASN1ObjectIdentifier *)proofOfOrigin {
    static ASN1ObjectIdentifier *_proofOfOrigin = nil;
    @synchronized(self) {
        if (!_proofOfOrigin) {
            _proofOfOrigin = [[PKCSObjectIdentifiers id_cti_ets_proofOfOrigin] retain];
        }
    }
    return _proofOfOrigin;
}

+ (ASN1ObjectIdentifier *)proofOfReceipt {
    static ASN1ObjectIdentifier *_proofOfReceipt = nil;
    @synchronized(self) {
        if (!_proofOfReceipt) {
            _proofOfReceipt = [[PKCSObjectIdentifiers id_cti_ets_proofOfReceipt] retain];
        }
    }
    return _proofOfReceipt;
}

+ (ASN1ObjectIdentifier *)proofOfDelivery {
    static ASN1ObjectIdentifier *_proofOfDelivery = nil;
    @synchronized(self) {
        if (!_proofOfDelivery) {
            _proofOfDelivery = [[PKCSObjectIdentifiers id_cti_ets_proofOfDelivery] retain];
        }
    }
    return _proofOfDelivery;
}

+ (ASN1ObjectIdentifier *)proofOfSender {
    static ASN1ObjectIdentifier *_proofOfSender = nil;
    @synchronized(self) {
        if (!_proofOfSender) {
            _proofOfSender = [[PKCSObjectIdentifiers id_cti_ets_proofOfSender] retain];
        }
    }
    return _proofOfSender;
}

+ (ASN1ObjectIdentifier *)proofOfApproval {
    static ASN1ObjectIdentifier *_proofOfApproval = nil;
    @synchronized(self) {
        if (!_proofOfApproval) {
            _proofOfApproval = [[PKCSObjectIdentifiers id_cti_ets_proofOfApproval] retain];
        }
    }
    return _proofOfApproval;
}

+ (ASN1ObjectIdentifier *)proofOfCreation {
    static ASN1ObjectIdentifier *_proofOfCreation = nil;
    @synchronized(self) {
        if (!_proofOfCreation) {
            _proofOfCreation = [[PKCSObjectIdentifiers id_cti_ets_proofOfCreation] retain];
        }
    }
    return _proofOfCreation;
}


@end
