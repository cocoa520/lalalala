//
//  ExtendedKeyUsage.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "ASN1TaggedObject.h"
#import "Extensions.h"
#import "KeyPurposeId.h"

@interface ExtendedKeyUsage : ASN1Object {
    NSMutableDictionary *_usageTable;
    ASN1Sequence *_seq;
}

@property (nonatomic, readwrite, retain) NSMutableDictionary *usageTable;
@property (nonatomic, readwrite, retain) ASN1Sequence *seq;

+ (ExtendedKeyUsage *)getInstance:(id)paramObject;
+ (ExtendedKeyUsage *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (ExtendedKeyUsage *)fromExtensions:(Extensions *)paramExtensions;
- (instancetype)initParamKeyPurposeId:(KeyPurposeId *)paramKeyPurposeId;
- (instancetype)initParamArrayOfKeyPurposeId:(NSMutableArray *)paramArrayOfKeyPurposeId;
- (instancetype)initParamVector:(NSMutableArray *)paramVector;
- (BOOL)hasKeyPurposeId:(KeyPurposeId *)paramKeyPurposeId;
- (NSMutableArray *)getUsages;
- (int)size;
- (ASN1Primitive *)toASN1Primitive;

@end
