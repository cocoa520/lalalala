//
//  X962Parameters.h
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1TaggedObject.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Null.h"

@interface X962Parameters : ASN1Choice {
@private
    ASN1Primitive *_params;
}

+ (X962Parameters *)getInstance:(id)paramObject;
+ (X962Parameters *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamX9ECParameters:(X962Parameters *)paramX9ECParameters;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (instancetype)initParamASN1Null:(ASN1Null *)paramASN1Null;
- (instancetype)initParamASN1Primitive:(ASN1Primitive *)paramASN1Primitive;
- (BOOL)isNameCurve;
- (BOOL)isImplicitlyCA;
- (ASN1Primitive *)getParameters;
- (ASN1Primitive *)toASN1Primitive;
    
@end
