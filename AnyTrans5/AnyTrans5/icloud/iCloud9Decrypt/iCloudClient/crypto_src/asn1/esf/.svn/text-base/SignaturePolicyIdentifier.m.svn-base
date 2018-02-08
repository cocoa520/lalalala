//
//  SignaturePolicyIdentifier.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SignaturePolicyIdentifier.h"
#import "DERNull.h"

@interface SignaturePolicyIdentifier ()

@property (nonatomic, readwrite, retain) SignaturePolicyId *signaturePolicyId;
@property (nonatomic, assign) BOOL isSignaturePolicyImplied;

@end

@implementation SignaturePolicyIdentifier
@synthesize signaturePolicyId = _signaturePolicyId;
@synthesize isSignaturePolicyImplied = _isSignaturePolicyImplied;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_signaturePolicyId) {
        [_signaturePolicyId release];
        _signaturePolicyId = nil;
    }
    [super dealloc];
#endif
}

+ (SignaturePolicyIdentifier *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[SignaturePolicyIdentifier class]]) {
        return (SignaturePolicyIdentifier *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Null class]] || [self hasEncodedTagValue:paramObject paramInt:5]) {
        return [[[SignaturePolicyIdentifier alloc] init] autorelease];
    }
    if (paramObject) {
        return [[[SignaturePolicyIdentifier alloc] initParamSignaturePolicyId:[SignaturePolicyId getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isSignaturePolicyImplied = TRUE;
    }
    return self;
}

- (instancetype)initParamSignaturePolicyId:(SignaturePolicyId *)paramSignaturePolicyId
{
    self = [super init];
    if (self) {
        self.signaturePolicyId = paramSignaturePolicyId;
        self.isSignaturePolicyImplied = false;
    }
    return self;
}

- (SignaturePolicyId *)getSignaturePolicyId {
    return self.signaturePolicyId;
}

- (BOOL)isSignaturePolicyImplied {
    return self.isSignaturePolicyImplied;
}

- (ASN1Primitive *)toASN1Primitive {
    if (self.isSignaturePolicyImplied) {
        return [DERNull INSTANCE];
    }
    return [self.signaturePolicyId toASN1Primitive];
}

@end
