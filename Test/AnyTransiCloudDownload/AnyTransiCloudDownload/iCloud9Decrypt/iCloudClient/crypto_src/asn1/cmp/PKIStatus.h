//
//  PKIStatus.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "BigInteger.h"

@interface PKIStatus : ASN1Object {
@private
    ASN1Integer *_value;
}

+ (int)GRANTED;
+ (int)GRANTED_WITH_MODS;
+ (int)REJECTION;
+ (int)WAITING;
+ (int)REVOCATION_WARNING;
+ (int)REVOCATION_NOTIFICATION;
+ (int)KEY_UPDATE_WARNING;
+ (PKIStatus *)granted;
+ (PKIStatus *)grantedWithMods;
+ (PKIStatus *)rejection;
+ (PKIStatus *)waiting;
+ (PKIStatus *)revocationWarning;
+ (PKIStatus *)revocationNotification;
+ (PKIStatus *)keyUpdateWaiting;

+ (PKIStatus *)getInstance:(id)paramObject;
- (BigInteger *)getValue;
- (ASN1Primitive *)toASN1Primitive;

@end
