//
//  ISISMTTObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ISISMTTObjectIdentifiers.h"

@implementation ISISMTTObjectIdentifiers

+ (ASN1ObjectIdentifier *)id_isismtt {
    static ASN1ObjectIdentifier *_id_isismtt = nil;
    @synchronized(self) {
        if (!_id_isismtt) {
            _id_isismtt = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.36.8"];
        }
    }
    return _id_isismtt;
}

+ (ASN1ObjectIdentifier *)id_isismtt_cp {
    static ASN1ObjectIdentifier *_id_isismtt_cp = nil;
    @synchronized(self) {
        if (!_id_isismtt_cp) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt] branch:@"1"] retain];
            }
            _id_isismtt_cp = [branchObj retain];
        }
    }
    return _id_isismtt_cp;
}

+ (ASN1ObjectIdentifier *)id_isismtt_cp_accredited {
    static ASN1ObjectIdentifier *_id_isismtt_cp_accredited = nil;
    @synchronized(self) {
        if (!_id_isismtt_cp_accredited) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt_cp] branch:@"1"] retain];
            }
            _id_isismtt_cp_accredited = [branchObj retain];
        }
    }
    return _id_isismtt_cp_accredited;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at {
    static ASN1ObjectIdentifier *_id_isismtt_at = nil;
    @synchronized(self) {
        if (!_id_isismtt_at) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt] branch:@"3"] retain];
            }
            _id_isismtt_at = [branchObj retain];
        }
    }
    return _id_isismtt_at;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at_dateOfCertGen {
    static ASN1ObjectIdentifier *_id_isismtt_at_dateOfCertGen = nil;
    @synchronized(self) {
        if (!_id_isismtt_at_dateOfCertGen) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt_at] branch:@"1"] retain];
            }
            _id_isismtt_at_dateOfCertGen = [branchObj retain];
        }
    }
    return _id_isismtt_at_dateOfCertGen;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at_procuration {
    static ASN1ObjectIdentifier *_id_isismtt_at_procuration = nil;
    @synchronized(self) {
        if (!_id_isismtt_at_procuration) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt_at] branch:@"2"] retain];
            }
            _id_isismtt_at_procuration = [branchObj retain];
        }
    }
    return _id_isismtt_at_procuration;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at_admission {
    static ASN1ObjectIdentifier *_id_isismtt_at_admission = nil;
    @synchronized(self) {
        if (!_id_isismtt_at_admission) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt_at] branch:@"3"] retain];
            }
            _id_isismtt_at_admission = [branchObj retain];
        }
    }
    return _id_isismtt_at_admission;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at_monetaryLimit {
    static ASN1ObjectIdentifier *_id_isismtt_at_monetaryLimit = nil;
    @synchronized(self) {
        if (!_id_isismtt_at_monetaryLimit) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt_at] branch:@"4"] retain];
            }
            _id_isismtt_at_monetaryLimit = [branchObj retain];
        }
    }
    return _id_isismtt_at_monetaryLimit;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at_declarationOfMajority {
    static ASN1ObjectIdentifier *_id_isismtt_at_declarationOfMajority = nil;
    @synchronized(self) {
        if (!_id_isismtt_at_declarationOfMajority) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt_at] branch:@"5"] retain];
            }
            _id_isismtt_at_declarationOfMajority = [branchObj retain];
        }
    }
    return _id_isismtt_at_declarationOfMajority;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at_iCCSN {
    static ASN1ObjectIdentifier *_id_isismtt_at_iCCSN = nil;
    @synchronized(self) {
        if (!_id_isismtt_at_iCCSN) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt_at] branch:@"6"] retain];
            }
            _id_isismtt_at_iCCSN = [branchObj retain];
        }
    }
    return _id_isismtt_at_iCCSN;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at_PKReference {
    static ASN1ObjectIdentifier *_id_isismtt_at_PKReference = nil;
    @synchronized(self) {
        if (!_id_isismtt_at_PKReference) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt_at] branch:@"7"] retain];
            }
            _id_isismtt_at_PKReference = [branchObj retain];
        }
    }
    return _id_isismtt_at_PKReference;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at_restriction {
    static ASN1ObjectIdentifier *_id_isismtt_at_restriction = nil;
    @synchronized(self) {
        if (!_id_isismtt_at_restriction) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt_at] branch:@"8"] retain];
            }
            _id_isismtt_at_restriction = [branchObj retain];
        }
    }
    return _id_isismtt_at_restriction;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at_retrieveIfAllowed {
    static ASN1ObjectIdentifier *_id_isismtt_at_retrieveIfAllowed = nil;
    @synchronized(self) {
        if (!_id_isismtt_at_retrieveIfAllowed) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt_at] branch:@"9"] retain];
            }
            _id_isismtt_at_retrieveIfAllowed = [branchObj retain];
        }
    }
    return _id_isismtt_at_retrieveIfAllowed;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at_requestedCertificate {
    static ASN1ObjectIdentifier *_id_isismtt_at_requestedCertificate = nil;
    @synchronized(self) {
        if (!_id_isismtt_at_requestedCertificate) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt_at] branch:@"10"] retain];
            }
            _id_isismtt_at_requestedCertificate = [branchObj retain];
        }
    }
    return _id_isismtt_at_requestedCertificate;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at_namingAuthorities {
    static ASN1ObjectIdentifier *_id_isismtt_at_namingAuthorities = nil;
    @synchronized(self) {
        if (!_id_isismtt_at_namingAuthorities) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt_at] branch:@"11"] retain];
            }
            _id_isismtt_at_namingAuthorities = [branchObj retain];
        }
    }
    return _id_isismtt_at_namingAuthorities;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at_certInDirSince {
    static ASN1ObjectIdentifier *_id_isismtt_at_certInDirSince = nil;
    @synchronized(self) {
        if (!_id_isismtt_at_certInDirSince) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt_at] branch:@"12"] retain];
            }
            _id_isismtt_at_certInDirSince = [branchObj retain];
        }
    }
    return _id_isismtt_at_certInDirSince;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at_certHash {
    static ASN1ObjectIdentifier *_id_isismtt_at_certHash = nil;
    @synchronized(self) {
        if (!_id_isismtt_at_certHash) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt_at] branch:@"13"] retain];
            }
            _id_isismtt_at_certHash = [branchObj retain];
        }
    }
    return _id_isismtt_at_certHash;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at_nameAtBirth {
    static ASN1ObjectIdentifier *_id_isismtt_at_nameAtBirth = nil;
    @synchronized(self) {
        if (!_id_isismtt_at_nameAtBirth) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt_at] branch:@"14"] retain];
            }
            _id_isismtt_at_nameAtBirth = [branchObj retain];
        }
    }
    return _id_isismtt_at_nameAtBirth;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at_additionalInformation {
    static ASN1ObjectIdentifier *_id_isismtt_at_additionalInformation = nil;
    @synchronized(self) {
        if (!_id_isismtt_at_additionalInformation) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_isismtt_at] branch:@"15"] retain];
            }
            _id_isismtt_at_additionalInformation = [branchObj retain];
        }
    }
    return _id_isismtt_at_additionalInformation;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at_liabilityLimitationFlag {
    static ASN1ObjectIdentifier *_id_isismtt_at_liabilityLimitationFlag = nil;
    @synchronized(self) {
        if (!_id_isismtt_at_liabilityLimitationFlag) {
            _id_isismtt_at_liabilityLimitationFlag = [[ASN1ObjectIdentifier alloc] initParamString:@"0.2.262.1.10.12.0"];
        }
    }
    return _id_isismtt_at_liabilityLimitationFlag;
}


@end
