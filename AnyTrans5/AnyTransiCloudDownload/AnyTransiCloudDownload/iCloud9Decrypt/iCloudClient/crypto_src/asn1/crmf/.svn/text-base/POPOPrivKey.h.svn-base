//
//  POPOPrivKey.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1Encodable.h"
#import "ASN1TaggedObject.h"
#import "SubsequentMessage.h"

@interface POPOPrivKey : ASN1Choice {
@private
    int _tagNo;
    ASN1Encodable *_obj;
}

+ (int)thisMessage;
+ (int)subsequentMessage;
+ (int)dhMAC;
+ (int)agreeMAC;
+ (int)encryptedKey;
+ (POPOPrivKey *)getInstance:(id)paramObject;
+ (POPOPrivKey *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamSubsequentMessage:(SubsequentMessage *)paramSubsequentMessage;
- (int)getType;
- (ASN1Encodable *)getValue;
- (ASN1Primitive *)toASN1Primitive;

@end
