//
//  ContentIdentifier.m
//  crypto
//
//  Created by JGehry on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ContentIdentifier.h"
#import "DEROctetString.h"

@implementation ContentIdentifier
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

+ (ContentIdentifier *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ContentIdentifier class]]) {
        return (ContentIdentifier *)paramObject;
    }
    if (paramObject) {
        return [[[ContentIdentifier alloc] initParamASN1OctetString:[ASN1OctetString getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        self.value = paramASN1OctetString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        [self initParamASN1OctetString:octetString];
#if !__has_feature(objc_arc)
    if (octetString) [octetString release]; octetString = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1OctetString *)getValue {
    return self.value;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.value;
}

@end
