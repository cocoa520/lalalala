//
//  ObjectDigestInfo.h
//  crypto
//
//  Created by JGehry on 7/11/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "ASN1Enumerated.h"
#import "ASN1ObjectIdentifier.h"
#import "AlgorithmIdentifier.h"
#import "DERBitString.h"

@interface ObjectDigestInfo : ASN1Object {
    ASN1Enumerated *_digestedObjectType;
    ASN1ObjectIdentifier *_otherObjectTypeID;
    AlgorithmIdentifier *_digestAlgorithm;
    DERBitString *_objectDigest;
}

@property (nonatomic, readwrite, retain) ASN1Enumerated *digestedObjectType;
@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *otherObjectTypeID;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *digestAlgorithm;
@property (nonatomic, readwrite, retain) DERBitString *objectDigest;

+ (int)publicKey;
+ (int)publickeyCert;
+ (int)otherObjectDigest;
+ (ObjectDigestInfo *)getInstance:(id)paramObject;
+ (ObjectDigestInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamInt:(int)paramInt paramASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (ASN1Enumerated *)getDigestedObjectType;
- (ASN1ObjectIdentifier *)getOtherObjectTypeID;
- (AlgorithmIdentifier *)getDigestAlgorithm;
- (DERBitString *)getObjectDigest;
- (ASN1Primitive *)toASN1Primitive;

@end
