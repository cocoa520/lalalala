//
//  ResponderID.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1Encodable.h"
#import "ASN1TaggedObject.h"
#import "ASN1OctetString.h"
#import "X500Name.h"

@interface ResponderID : ASN1Choice {
@private
    ASN1Encodable *_value;
}

+ (ResponderID *)getInstance:(id)paramObject;
+ (ResponderID *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (instancetype)initParamX500Name:(X500Name *)paramX500Name;
- (NSMutableData *)getKeyHash;
- (X500Name *)getName;
- (ASN1Primitive *)toASN1Primitive;

@end
