//
//  TypeOfBiometricData.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1Encodable.h"
#import "ASN1ObjectIdentifier.h"

@interface TypeOfBiometricData : ASN1Choice {
    ASN1Encodable *_obj;
}

@property (nonatomic, readwrite, retain) ASN1Encodable *obj;

+ (int)PICTURE;
+ (int)HANDWRITTEN_SIGNATURE;
+ (TypeOfBiometricData *)getInstance:(id)paramObject;
- (instancetype)initParamInt:(int)paramInt;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (BOOL)isPredefined;
- (int)getPredefinedBiometricType;
- (ASN1ObjectIdentifier *)getBiometricDataOid;
- (ASN1Primitive *)toASN1Primitive;

@end
