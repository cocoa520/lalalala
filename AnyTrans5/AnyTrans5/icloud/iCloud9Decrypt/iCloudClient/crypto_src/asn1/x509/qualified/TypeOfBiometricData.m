//
//  TypeOfBiometricData.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "TypeOfBiometricData.h"
#import "ASN1Integer.h"

@implementation TypeOfBiometricData
@synthesize obj = _obj;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_obj) {
        [_obj release];
        _obj = nil;
    }
    [super dealloc];
#endif
}

+ (int)PICTURE {
    static int _PICTURE = 0;
    @synchronized(self) {
        if (!_PICTURE) {
            _PICTURE = 0;
        }
    }
    return _PICTURE;
}

+ (int)HANDWRITTEN_SIGNATURE {
    static int _HANDWRITTEN_SIGNATURE = 0;
    @synchronized(self) {
        if (!_HANDWRITTEN_SIGNATURE) {
            _HANDWRITTEN_SIGNATURE = 1;
        }
    }
    return _HANDWRITTEN_SIGNATURE;
}

+ (TypeOfBiometricData *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[TypeOfBiometricData class]]) {
        return (TypeOfBiometricData *)paramObject;
    }
    id localObject;
    if ([paramObject isKindOfClass:[ASN1Integer class]]) {
        localObject = [ASN1Integer getInstance:paramObject];
        int i = [[((ASN1Integer *)localObject) getValue] intValue];
        return [[[TypeOfBiometricData alloc] initParamInt:i] autorelease];
    }
    if ([paramObject isKindOfClass:[ASN1ObjectIdentifier class]]) {
        localObject = [ASN1ObjectIdentifier getInstance:paramObject];
        return [[[TypeOfBiometricData alloc] initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)localObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:@"unknown object in getInstance" userInfo:nil];
}

- (instancetype)initParamInt:(int)paramInt
{
    if (self = [super init]) {
        if ((paramInt == 0) || (paramInt == 1)) {
            ASN1Encodable *encodable = [[ASN1Integer alloc] initLong:paramInt];
            self.obj = encodable;
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
        }else {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknow PredefinedBiometricType : %d", paramInt] userInfo:nil];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier
{
    if (self = [super init]) {
        self.obj = paramASN1ObjectIdentifier;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (BOOL)isPredefined {
    return [self.obj isKindOfClass:[ASN1Integer class]];
}

- (int)getPredefinedBiometricType {
    return [[((ASN1Integer *)self.obj) getValue] intValue];
}

- (ASN1ObjectIdentifier *)getBiometricDataOid {
    return (ASN1ObjectIdentifier *)self.obj;
}

- (ASN1Primitive *)toASN1Primitive {
    return [self.obj toASN1Primitive];
}

@end
