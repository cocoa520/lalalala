//
//  PKIStatus.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKIStatus.h"

@interface PKIStatus ()

@property (nonatomic, readwrite, retain) ASN1Integer *value;

@end

@implementation PKIStatus
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

+ (int)GRANTED {
    static int _GRANTED = 0;
    @synchronized(self) {
        if (!_GRANTED) {
            _GRANTED = 0;
        }
    }
    return _GRANTED;
}

+ (int)GRANTED_WITH_MODS {
    static int _GRANTED_WITH_MODS = 0;
    @synchronized(self) {
        if (!_GRANTED_WITH_MODS) {
            _GRANTED_WITH_MODS = 1;
        }
    }
    return _GRANTED_WITH_MODS;
}

+ (int)REJECTION {
    static int _REJECTION = 0;
    @synchronized(self) {
        if (!_REJECTION) {
            _REJECTION = 2;
        }
    }
    return _REJECTION;
}

+ (int)WAITING {
    static int _WAITING = 0;
    @synchronized(self) {
        if (!_WAITING) {
            _WAITING = 3;
        }
    }
    return _WAITING;
}

+ (int)REVOCATION_WARNING {
    static int _REVOCATION_WARNING = 0;
    @synchronized(self) {
        if (!_REVOCATION_WARNING) {
            _REVOCATION_WARNING = 4;
        }
    }
    return _REVOCATION_WARNING;
}

+ (int)REVOCATION_NOTIFICATION {
    static int _REVOCATION_NOTIFICATION = 0;
    @synchronized(self) {
        if (!_REVOCATION_NOTIFICATION) {
            _REVOCATION_NOTIFICATION = 5;
        }
    }
    return _REVOCATION_NOTIFICATION;
}

+ (int)KEY_UPDATE_WARNING {
    static int _KEY_UPDATE_WARNING = 0;
    @synchronized(self) {
        if (!_KEY_UPDATE_WARNING) {
            _KEY_UPDATE_WARNING = 6;
        }
    }
    return _KEY_UPDATE_WARNING;
}

+ (PKIStatus *)granted {
    static PKIStatus *_granted = nil;
    @synchronized(self) {
        if (!_granted) {
            _granted = [[PKIStatus alloc] initParamInt:0];
        }
    }
    return _granted;
}

+ (PKIStatus *)grantedWithMods {
    static PKIStatus *_grantedWithMods = nil;
    @synchronized(self) {
        if (!_grantedWithMods) {
            _grantedWithMods = [[PKIStatus alloc] initParamInt:1];
        }
    }
    return _grantedWithMods;
}

+ (PKIStatus *)rejection {
    static PKIStatus *_rejection = nil;
    @synchronized(self) {
        if (!_rejection) {
            _rejection = [[PKIStatus alloc] initParamInt:2];
        }
    }
    return _rejection;
}

+ (PKIStatus *)waiting {
    static PKIStatus *_waiting = nil;
    @synchronized(self) {
        if (!_waiting) {
            _waiting = [[PKIStatus alloc] initParamInt:3];
        }
    }
    return _waiting;
}

+ (PKIStatus *)revocationWarning {
    static PKIStatus *_revocationWarning = nil;
    @synchronized(self) {
        if (!_revocationWarning) {
            _revocationWarning = [[PKIStatus alloc] initParamInt:4];
        }
    }
    return _revocationWarning;
}

+ (PKIStatus *)revocationNotification {
    static PKIStatus *_revocationNotification = nil;
    @synchronized(self) {
        if (!_revocationNotification) {
            _revocationNotification = [[PKIStatus alloc] initParamInt:5];
        }
    }
    return _revocationNotification;
}

+ (PKIStatus *)keyUpdateWaiting {
    static PKIStatus *_keyUpdateWaiting = nil;
    @synchronized(self) {
        if (!_keyUpdateWaiting) {
            _keyUpdateWaiting = [[PKIStatus alloc] initParamInt:6];
        }
    }
    return _keyUpdateWaiting;
}

+ (PKIStatus *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PKIStatus class]]) {
        return (PKIStatus *)paramObject;
    }
    if (paramObject) {
        return [[[PKIStatus alloc] initParamASN1Integer:[ASN1Integer getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamInt:(int)paramInt
{
    if (self = [super init]) {
        ASN1Integer *integer = [[ASN1Integer alloc] initLong:paramInt];
        [self initParamASN1Integer:integer];
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

- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer
{
    if (self = [super init]) {
        self.value = paramASN1Integer;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (BigInteger *)getValue {
    return [self.value getValue];
}

- (ASN1Primitive *)toASN1Primitive {
    return self.value;
}

@end
