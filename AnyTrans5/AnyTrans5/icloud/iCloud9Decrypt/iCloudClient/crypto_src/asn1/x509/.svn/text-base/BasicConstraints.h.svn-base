//
//  BasicConstraints.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Boolean.h"
#import "ASN1Integer.h"
#import "ASN1TaggedObject.h"
#import "Extensions.h"

@interface BasicConstraints : ASN1Object {
    ASN1Boolean *_cA;
    ASN1Integer *_pathLenConstraint;
}

@property (nonatomic, readwrite, retain) ASN1Boolean *cA;
@property (nonatomic, readwrite, retain) ASN1Integer *pathLenConstraint;

+ (BasicConstraints *)getInstance:(id)paramObject;
+ (BasicConstraints *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (BasicConstraints *)fromExtensions:(Extensions *)paramExtensions;
- (instancetype)initParamBoolean:(BOOL)paramBoolean;
- (instancetype)initParamInt:(int)paramInt;
- (BOOL)isCA;
- (BigInteger *)getPathLenConstraint;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;

@end
