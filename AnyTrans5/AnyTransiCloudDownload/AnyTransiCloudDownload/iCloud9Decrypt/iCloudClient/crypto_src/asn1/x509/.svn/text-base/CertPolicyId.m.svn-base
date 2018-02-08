//
//  CertPolicyId.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertPolicyId.h"

@interface CertPolicyId()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *id;

@end

@implementation CertPolicyId
@synthesize id = _id;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_id) {
        [_id release];
        _id = nil;
    }
    [super dealloc];
#endif
}

+ (CertPolicyId *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertPolicyId class]]) {
        return (CertPolicyId *)paramObject;
    }
    if (paramObject) {
        return [[[CertPolicyId alloc] initParamASN1ObjectIdentifier:[ASN1ObjectIdentifier getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier
{
    if (self = [super init]) {
        self.id = paramASN1ObjectIdentifier;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSString *)getId {
    return [self.id getId];
}

- (ASN1Primitive *)toASN1Primitive {
    return self.id;
}

@end
