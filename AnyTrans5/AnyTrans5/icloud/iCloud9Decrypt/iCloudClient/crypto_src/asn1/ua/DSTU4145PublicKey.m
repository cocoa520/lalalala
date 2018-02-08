//
//  DSTU4145PublicKey.m
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DSTU4145PublicKey.h"
#import "DEROctetString.h"
#import "DSTU4145PointEncoder.h"

@interface DSTU4145PublicKey ()

@property (nonatomic, readwrite, retain) ASN1OctetString *pubKey;

@end

@implementation DSTU4145PublicKey
@synthesize pubKey = _pubKey;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_pubKey) {
        [_pubKey release];
        _pubKey = nil;
    }
    [super dealloc];
#endif
}

+ (DSTU4145PublicKey *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[DSTU4145PublicKey class]]) {
        return (DSTU4145PublicKey *)paramObject;
    }
    if (paramObject) {
        return [[[DSTU4145PublicKey alloc] initParamASN1OctetString:[ASN1OctetString getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamECPoint:(ECPoint *)paramECPoint {
    if (self = [super init]) {
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:[DSTU4145PointEncoder encodePoint:paramECPoint]];
        self.pubKey = octetString;
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

- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString {
    self = [super init];
    if (self) {
        self.pubKey = paramASN1OctetString;
    }
    return self;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.pubKey;
}

@end
