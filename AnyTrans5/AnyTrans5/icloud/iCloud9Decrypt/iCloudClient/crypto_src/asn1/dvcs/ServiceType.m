//
//  ServiceType.m
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ServiceType.h"

@interface ServiceType ()

@property (nonatomic, readwrite, retain) ASN1Enumerated *value;

@end

@implementation ServiceType
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

+ (ServiceType *)CPD {
    static ServiceType *_CPD = nil;
    @synchronized(self) {
        if (!_CPD) {
            _CPD = [[ServiceType alloc] initParamInt:1];
        }
    }
    return _CPD;
}

+ (ServiceType *)VSD {
    static ServiceType *_VSD = nil;
    @synchronized(self) {
        if (!_VSD) {
            _VSD = [[ServiceType alloc] initParamInt:2];
        }
    }
    return _VSD;
}

+ (ServiceType *)VPKC {
    static ServiceType *_VPKC = nil;
    @synchronized(self) {
        if (!_VPKC) {
            _VPKC = [[ServiceType alloc] initParamInt:3];
        }
    }
    return _VPKC;
}

+ (ServiceType *)CCPD {
    static ServiceType *_CCPD = nil;
    @synchronized(self) {
        if (!_CCPD) {
            _CCPD = [[ServiceType alloc] initParamInt:4];
        }
    }
    return _CCPD;
}

+ (ServiceType *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ServiceType class]]) {
        return (ServiceType *)paramObject;
    }
    if (paramObject) {
        return [[[ServiceType alloc] initParamASN1Enumerated:[ASN1Enumerated getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (ServiceType *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [ServiceType getInstance:[ASN1Enumerated getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamInt:(int)paramInt
{
    self = [super init];
    if (self) {
        ASN1Enumerated *enumerated = [[ASN1Enumerated alloc] initParamInt:paramInt];
        self.value = enumerated;
#if !__has_feature(objc_arc)
    if (enumerated) [enumerated release]; enumerated = nil;
#endif
    }
    return self;
}

- (instancetype)initParamASN1Enumerated:(ASN1Enumerated *)paramASN1Enumerated
{
    self = [super init];
    if (self) {
        self.value = paramASN1Enumerated;
    }
    return self;
}

- (BigInteger *)getValue {
    return [self.value getValue];
}

- (ASN1Primitive *)toASN1Primitive {
    return self.value;
}

- (NSString *)toString {
    int i = [[self.value getValue] intValue];
    return [NSString stringWithFormat:@" %d%@", i, (i == [[[ServiceType CCPD] getValue] intValue] ? @"(CCPD)" : i == [[[ServiceType VPKC] getValue] intValue] ? @"(VPKC)" : i == [[[ServiceType VSD] getValue] intValue] ? @"(VSD" : i == [[[ServiceType CPD] getValue] intValue] ? @"(CPD" : @"?")];
}

@end
