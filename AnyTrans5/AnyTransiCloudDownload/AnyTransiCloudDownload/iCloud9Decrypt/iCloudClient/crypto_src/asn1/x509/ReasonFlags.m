//
//  ReasonFlags.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ReasonFlags.h"

@implementation ReasonFlags

+ (int)UNUSED {
    static int _UNUSED = 0;
    @synchronized(self) {
        if (!_UNUSED) {
            _UNUSED = 128;
        }
    }
    return _UNUSED;
}

+ (int)KEY_COMPROMISE {
    static int _KEY_COMPROMISE = 0;
    @synchronized(self) {
        if (!_KEY_COMPROMISE) {
            _KEY_COMPROMISE = 64;
        }
    }
    return _KEY_COMPROMISE;
}

+ (int)CA_COMPROMISE {
    static int _CA_COMPROMISE = 0;
    @synchronized(self) {
        if (!_CA_COMPROMISE) {
            _CA_COMPROMISE = 32;
        }
    }
    return _CA_COMPROMISE;
}

+ (int)AFFILIATION_CHANGED {
    static int _AFFILIATION_CHANGED = 0;
    @synchronized(self) {
        if (!_AFFILIATION_CHANGED) {
            _AFFILIATION_CHANGED = 16;
        }
    }
    return _AFFILIATION_CHANGED;
}

+ (int)SUPERSEDED {
    static int _SUPERSEDED = 0;
    @synchronized(self) {
        if (!_SUPERSEDED) {
            _SUPERSEDED = 8;
        }
    }
    return _SUPERSEDED;
}

+ (int)CESSATION_OF_OPERATION {
    static int _CESSATION_OF_OPERATION = 0;
    @synchronized(self) {
        if (!_CESSATION_OF_OPERATION) {
            _CESSATION_OF_OPERATION = 4;
        }
    }
    return _CESSATION_OF_OPERATION;
}

+ (int)CERTIFICATE_HOLD {
    static int _CERTIFICATE_HOLD = 0;
    @synchronized(self) {
        if (!_CERTIFICATE_HOLD) {
            _CERTIFICATE_HOLD = 2;
        }
    }
    return _CERTIFICATE_HOLD;
}

+ (int)PRIVILEGE_WITHDRAWN {
    static int _PRIVILEGE_WITHDRAWN = 0;
    @synchronized(self) {
        if (!_PRIVILEGE_WITHDRAWN) {
            _PRIVILEGE_WITHDRAWN = 1;
        }
    }
    return _PRIVILEGE_WITHDRAWN;
}

+ (int)AA_COMPROMISE {
    static int _AA_COMPROMISE = 0;
    @synchronized(self) {
        if (!_AA_COMPROMISE) {
            _AA_COMPROMISE = 32768;
        }
    }
    return _AA_COMPROMISE;
}

+ (int)unused {
    static int _unused = 0;
    @synchronized(self) {
        if (!_unused) {
            _unused = 128;
        }
    }
    return _unused;
}

+ (int)keyCompromise {
    static int _keyCompromise = 0;
    @synchronized(self) {
        if (!_keyCompromise) {
            _keyCompromise = 64;
        }
    }
    return _keyCompromise;
}

+ (int)cACompromise {
    static int _cACompromise = 0;
    @synchronized(self) {
        if (!_cACompromise) {
            _cACompromise = 32;
        }
    }
    return _cACompromise;
}

+ (int)affiliationChanged {
    static int _affiliationChanged = 0;
    @synchronized(self) {
        if (!_affiliationChanged) {
            _affiliationChanged = 16;
        }
    }
    return _affiliationChanged;
}

+ (int)superseded {
    static int _superseded = 0;
    @synchronized(self) {
        if (!_superseded) {
            _superseded = 8;
        }
    }
    return _superseded;
}

+ (int)cessationOfOperation {
    static int _cessationOfOperation = 0;
    @synchronized(self) {
        if (!_cessationOfOperation) {
            _cessationOfOperation = 4;
        }
    }
    return _cessationOfOperation;
}

+ (int)certificateHold {
    static int _certificateHold = 0;
    @synchronized(self) {
        if (!_certificateHold) {
            _certificateHold = 2;
        }
    }
    return _certificateHold;
}

+ (int)privilegeWithdrawn {
    static int _privilegeWithdrawn = 0;
    @synchronized(self) {
        if (!_privilegeWithdrawn) {
            _privilegeWithdrawn = 1;
        }
    }
    return _privilegeWithdrawn;
}

+ (int)aACompromise {
    static int _aACompromise = 0;
    @synchronized(self) {
        if (!_aACompromise) {
            _aACompromise = 32768;
        }
    }
    return _aACompromise;
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

@end
