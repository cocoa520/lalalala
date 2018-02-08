//
//  ReasonFlags.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERBitString.h"

@interface ReasonFlags : DERBitString

+ (int)UNUSED;
+ (int)KEY_COMPROMISE;
+ (int)CA_COMPROMISE;
+ (int)AFFILIATION_CHANGED;
+ (int)SUPERSEDED;
+ (int)CESSATION_OF_OPERATION;
+ (int)CERTIFICATE_HOLD;
+ (int)PRIVILEGE_WITHDRAWN;
+ (int)AA_COMPROMISE;
+ (int)unused;
+ (int)keyCompromise;
+ (int)cACompromise;
+ (int)affiliationChanged;
+ (int)superseded;
+ (int)cessationOfOperation;
+ (int)certificateHold;
+ (int)privilegeWithdrawn;
+ (int)aACompromise;
- (instancetype)initParamInt:(int)paramInt;
- (instancetype)initParamDERBitString:(DERBitString *)paramDERBitString;

@end
