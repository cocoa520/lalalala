//
//  OCSPResponseStatus.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OCSPResponseStatus.h"

@interface OCSPResponseStatus ()

@property (nonatomic, readwrite, retain) ASN1Enumerated *value;

@end

@implementation OCSPResponseStatus
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

+ (int)SUCCESSFUL {
    static int _SUCCESSFUL = 0;
    @synchronized(self) {
        if (!_SUCCESSFUL) {
            _SUCCESSFUL = 0;
        }
    }
    return _SUCCESSFUL;
}

+ (int)MALFORMED_REQUEST {
    static int _MALFORMED_REQUEST = 0;
    @synchronized(self) {
        if (!_MALFORMED_REQUEST) {
            _MALFORMED_REQUEST = 1;
        }
    }
    return _MALFORMED_REQUEST;
}

+ (int)INTERNAL_ERROR {
    static int _INTERNAL_ERROR = 0;
    @synchronized(self) {
        if (!_INTERNAL_ERROR) {
            _INTERNAL_ERROR = 2;
        }
    }
    return _INTERNAL_ERROR;
}

+ (int)TRY_LATER {
    static int _TRY_LATER = 0;
    @synchronized(self) {
        if (!_TRY_LATER) {
            _TRY_LATER = 3;
        }
    }
    return _TRY_LATER;
}

+ (int)SIG_REQUIRED {
    static int _SIG_REQUIRED = 0;
    @synchronized(self) {
        if (!_SIG_REQUIRED) {
            _SIG_REQUIRED = 5;
        }
    }
    return _SIG_REQUIRED;
}

+ (int)UNAUTHORIZED {
    static int _UNAUTHORIZED = 0;
    @synchronized(self) {
        if (!_UNAUTHORIZED) {
            _UNAUTHORIZED = 6;
        }
    }
    return _UNAUTHORIZED;
}

+ (OCSPResponseStatus *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OCSPResponseStatus class]]) {
        return (OCSPResponseStatus *)paramObject;
    }
    if (paramObject) {
        return [[[OCSPResponseStatus alloc] initParamASN1Enumerated:[ASN1Enumerated getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamInt:(int)paramInt
{
    if (self = [super init]) {
        ASN1Enumerated *enumerated = [[ASN1Enumerated alloc] initParamInt:paramInt];
        [self initParamASN1Enumerated:enumerated];
#if !__has_feature(objc_arc)
    if (enumerated) [enumerated release]; enumerated = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Enumerated:(ASN1Enumerated *)paramASN1Enumerated
{
    if (self = [super init]) {
        self.value = paramASN1Enumerated;
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
