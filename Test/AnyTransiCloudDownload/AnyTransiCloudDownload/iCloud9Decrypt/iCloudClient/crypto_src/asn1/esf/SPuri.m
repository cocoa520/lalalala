//
//  SPuri.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SPuri.h"

@interface SPuri ()

@property (nonatomic, readwrite, retain) DERIA5String *uri;

@end

@implementation SPuri
@synthesize uri = _uri;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_uri) {
        [_uri release];
        _uri = nil;
    }
    [super dealloc];
#endif
}

+ (SPuri *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[SPuri class]]) {
        return (SPuri *)paramObject;
    }
    if ([paramObject isKindOfClass:[DERIA5String class]]) {
        return [[[SPuri alloc] initParamDERIA5String:[DERIA5String getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamDERIA5String:(DERIA5String *)paramDERIA5String
{
    self = [super init];
    if (self) {
        self.uri = paramDERIA5String;
    }
    return self;
}

- (DERIA5String *)getUri {
    return self.uri;
}

- (ASN1Primitive *)toASN1Primitive {
    return [self.uri toASN1Primitive];
}

@end
