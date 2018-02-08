//
//  CRLReason.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CRLReason.h"

@interface CRLReason ()

@property (nonatomic, readwrite, retain) ASN1Enumerated *value;

@end

@implementation CRLReason
@synthesize value = _value;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_value) {
        [_value release];
        _value = nil;
    }
    [super dealloc];
#endif
}

+ (int)UNSPECIFIED {
    static int _UNSPECIFIED = 0;
    @synchronized(self) {
        if (!_UNSPECIFIED) {
            _UNSPECIFIED = 0;
        }
    }
    return _UNSPECIFIED;
}

+ (int)KEY_COMPROMISE {
    static int _KEY_COMPROMISE = 0;
    @synchronized(self) {
        if (!_KEY_COMPROMISE) {
            _KEY_COMPROMISE = 1;
        }
    }
    return _KEY_COMPROMISE;
}

+ (int)CA_COMPROMISE {
    static int _CA_COMPROMISE = 0;
    @synchronized(self) {
        if (!_CA_COMPROMISE) {
            _CA_COMPROMISE = 2;
        }
    }
    return _CA_COMPROMISE;
}

+ (int)AFFILIATION_CHANGED {
    static int _AFFILIATION_CHANGED = 0;
    @synchronized(self) {
        if (!_AFFILIATION_CHANGED) {
            _AFFILIATION_CHANGED = 3;
        }
    }
    return _AFFILIATION_CHANGED;
}

+ (int)SUPERSEDED {
    static int _SUPERSEDED = 0;
    @synchronized(self) {
        if (!_SUPERSEDED) {
            _SUPERSEDED = 4;
        }
    }
    return _SUPERSEDED;
}

+ (int)CESSATION_OF_OPERATION {
    static int _CESSATION_OF_OPERATION = 0;
    @synchronized(self) {
        if (!_CESSATION_OF_OPERATION) {
            _CESSATION_OF_OPERATION = 5;
        }
    }
    return _CESSATION_OF_OPERATION;
}

+ (int)CERTIFICATE_HOLD {
    static int _CERTIFICATE_HOLD = 0;
    @synchronized(self) {
        if (!_CERTIFICATE_HOLD) {
            _CERTIFICATE_HOLD = 6;
        }
    }
    return _CERTIFICATE_HOLD;
}

+ (int)REMOVE_FROM_CRL {
    static int _REMOVE_FROM_CRL = 0;
    @synchronized(self) {
        if (!_REMOVE_FROM_CRL) {
            _REMOVE_FROM_CRL = 8;
        }
    }
    return _REMOVE_FROM_CRL;
}

+ (int)PRIVILEGE_WITHDRAWN {
    static int _PRIVILEGE_WITHDRAWN = 0;
    @synchronized(self) {
        if (!_PRIVILEGE_WITHDRAWN) {
            _PRIVILEGE_WITHDRAWN = 9;
        }
    }
    return _PRIVILEGE_WITHDRAWN;
}

+ (int)AA_COMPROMISE {
    static int _AA_COMPROMISE = 0;
    @synchronized(self) {
        if (!_AA_COMPROMISE) {
            _AA_COMPROMISE = 10;
        }
    }
    return _AA_COMPROMISE;
}

+ (int)unspecified {
    static int _unspecified = 0;
    @synchronized(self) {
        if (!_unspecified) {
            _unspecified = 0;
        }
    }
    return _unspecified;
}

+ (int)keyCompromise {
    static int _keyCompromise = 0;
    @synchronized(self) {
        if (!_keyCompromise) {
            _keyCompromise = 1;
        }
    }
    return _keyCompromise;
}

+ (int)cACompromise {
    static int _cACompromise = 0;
    @synchronized(self) {
        if (!_cACompromise) {
            _cACompromise = 2;
        }
    }
    return _cACompromise;
}

+ (int)affiliationChanged {
    static int _affiliationChanged = 0;
    @synchronized(self) {
        if (!_affiliationChanged) {
            _affiliationChanged = 3;
        }
    }
    return _affiliationChanged;
}

+ (int)superseded {
    static int _superseded = 0;
    @synchronized(self) {
        if (!_superseded) {
            _superseded = 4;
        }
    }
    return _superseded;
}

+ (int)cessationOfOperation {
    static int _cessationOfOperation = 0;
    @synchronized(self) {
        if (!_cessationOfOperation) {
            _cessationOfOperation = 5;
        }
    }
    return _cessationOfOperation;
}

+ (int)certificateHold {
    static int _certificateHold = 0;
    @synchronized(self) {
        if (!_certificateHold) {
            _certificateHold = 6;
        }
    }
    return _certificateHold;
}

+ (int)removeFromCRL {
    static int _removeFromCRL = 0;
    @synchronized(self) {
        if (!_removeFromCRL) {
            _removeFromCRL = 8;
        }
    }
    return _removeFromCRL;
}

+ (int)privilegeWithdrawn {
    static int privilegeWithdrawn = 0;
    @synchronized(self) {
        if (!privilegeWithdrawn) {
            privilegeWithdrawn = 9;
        }
    }
    return privilegeWithdrawn;
}

+ (int)aACompromise {
    static int _aACompromise = 0;
    @synchronized(self) {
        if (!_aACompromise) {
            _aACompromise = 10;
        }
    }
    return _aACompromise;
}

+ (NSMutableArray *)reasonString {
    static NSMutableArray *_reasonString = nil;
    @synchronized(self) {
        if (!_reasonString) {
            _reasonString = [[NSMutableArray alloc] initWithObjects:@"unspecified", @"keyCompromise", @"cACompromise", @"affiliationChanged", @"superseded", @"cessationOfOperation", @"certificateHold", @"unknown", @"removeFromCRL", @"privilegeWithdrawn", @"aACompromise", nil];
        }
    }
    return _reasonString;
}

+ (NSMutableDictionary *)table {
    static NSMutableDictionary *_table = nil;
    @synchronized(self) {
        if (!_table) {
            _table = [[NSMutableDictionary alloc] init];
        }
    }
    return _table;
}

+ (CRLReason *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CRLReason class]]) {
        return (CRLReason *)paramObject;
    }
    return nil;
}

- (instancetype)initParamInt:(int)paramInt
{
    if (self = [super init]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

+ (CRLReason *)lookup:(int)paramInt {
    return nil;
}

- (BigInteger *)getValue {
    return [self.value getValue];
}

- (ASN1Primitive *)toASN1Primitive {
    return self.value;
}

@end
