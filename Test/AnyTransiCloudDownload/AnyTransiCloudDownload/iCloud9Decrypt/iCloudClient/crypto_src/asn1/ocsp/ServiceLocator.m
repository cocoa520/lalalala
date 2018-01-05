//
//  ServiceLocator.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ServiceLocator.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface ServiceLocator ()

@property (nonatomic, readwrite, retain) X500Name *issuer;
@property (nonatomic, readwrite, retain) AuthorityInformationAccess *locator;

@end

@implementation ServiceLocator
@synthesize issuer = _issuer;
@synthesize locator = _locator;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_issuer) {
        [_issuer release];
        _issuer = nil;
    }
    if (_locator) {
        [_locator release];
        _locator = nil;
    }
    [super dealloc];
#endif
}

+ (ServiceLocator *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ServiceLocator class]]) {
        return (ServiceLocator *)paramObject;
    }
    if (paramObject) {
        return [[[ServiceLocator alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.issuer = [X500Name getInstance:[paramASN1Sequence getObjectAt:0]];
        if ([paramASN1Sequence size] == 2) {
            self.locator = [AuthorityInformationAccess getInstance:[paramASN1Sequence getObjectAt:1]];
        }else {
            self.locator = nil;
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (X500Name *)getIssuer {
    return self.issuer;
}

- (AuthorityInformationAccess *)getLocator {
    return self.locator;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.issuer];
    if (self.locator) {
        [localASN1EncodableVector add:self.locator];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
