//
//  CRLReason.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Enumerated.h"

@interface CRLReason : ASN1Object {
@private
    ASN1Enumerated *_value;
}

+ (int)UNSPECIFIED;
+ (int)KEY_COMPROMISE;
+ (int)CA_COMPROMISE;
+ (int)AFFILIATION_CHANGED;
+ (int)SUPERSEDED;
+ (int)CESSATION_OF_OPERATION;
+ (int)CERTIFICATE_HOLD;
+ (int)REMOVE_FROM_CRL;
+ (int)PRIVILEGE_WITHDRAWN;
+ (int)AA_COMPROMISE;
+ (int)unspecified;
+ (int)keyCompromise;
+ (int)cACompromise;
+ (int)affiliationChanged;
+ (int)superseded;
+ (int)cessationOfOperation;
+ (int)certificateHold;
+ (int)removeFromCRL;
+ (int)privilegeWithdrawn;
+ (int)aACompromise;
+ (NSMutableArray *)reasonString;
+ (NSMutableDictionary *)table;
+ (CRLReason *)getInstance:(id)paramObject;
+ (CRLReason *)lookup:(int)paramInt;
- (BigInteger *)getValue;
- (ASN1Primitive *)toASN1Primitive;

@end
