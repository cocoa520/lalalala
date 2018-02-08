//
//  CommitmentTypeIdentifier.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface CommitmentTypeIdentifier : NSObject

+ (ASN1ObjectIdentifier *)proofOfOrigin;
+ (ASN1ObjectIdentifier *)proofOfReceipt;
+ (ASN1ObjectIdentifier *)proofOfDelivery;
+ (ASN1ObjectIdentifier *)proofOfSender;
+ (ASN1ObjectIdentifier *)proofOfApproval;
+ (ASN1ObjectIdentifier *)proofOfCreation;

@end
