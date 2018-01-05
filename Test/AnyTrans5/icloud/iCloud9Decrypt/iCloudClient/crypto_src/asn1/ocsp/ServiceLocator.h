//
//  ServiceLocator.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "X500Name.h"
#import "AuthorityInformationAccess.h"

@interface ServiceLocator : ASN1Object {
@private
    X500Name *_issuer;
    AuthorityInformationAccess *_locator;
}

+ (ServiceLocator *)getInstance:(id)paramObject;
- (X500Name *)getIssuer;
- (AuthorityInformationAccess *)getLocator;
- (ASN1Primitive *)toASN1Primitive;

@end
