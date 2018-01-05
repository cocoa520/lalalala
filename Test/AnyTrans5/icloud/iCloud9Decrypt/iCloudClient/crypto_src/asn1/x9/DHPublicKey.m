//
//  DHPublicKey.m
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DHPublicKey.h"

@interface DHPublicKey ()

@property (nonatomic, readwrite, retain) ASN1Integer *y;

@end

@implementation DHPublicKey
@synthesize y = _y;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_y) {
        [_y release];
        _y = nil;
    }
    [super dealloc];
#endif
}

+ (DHPublicKey *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [DHPublicKey getInstance:[ASN1Integer getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (DHPublicKey *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DHPublicKey class]]) {
        return (DHPublicKey *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Integer class]]) {
        return [[[DHPublicKey alloc] initParamASN1Integer:(ASN1Integer *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Invalid DHPublicKey: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer
{
    if (self = [super init]) {
        if (!paramASN1Integer) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'y' cannot be null" userInfo:nil];
        }
        self.y = paramASN1Integer;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBigInteger:(BigInteger *)paramBigInteger
{
    if (self = [super init]) {
        if (!paramBigInteger) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'y' cannot be null" userInfo:nil];
        }
        ASN1Integer *yInteger = [[ASN1Integer alloc] initBI:paramBigInteger];
        self.y = yInteger;
#if !__has_feature(objc_arc)
    if (yInteger) [yInteger release]; yInteger = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BigInteger *)getY {
    return self.y.getPositiveValue;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.y;
}

@end
