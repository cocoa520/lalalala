//
//  IetfAttrSyntax.h
//  crypto
//
//  Created by JGehry on 7/11/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "GeneralNames.h"

@interface IetfAttrSyntax : ASN1Object {
    GeneralNames *_policyAuthority;
    NSMutableArray *_values;
    int _valueChoice;
}

@property (nonatomic, readwrite, retain) GeneralNames *policyAuthority;
@property (nonatomic, readwrite, retain) NSMutableArray *values;
@property (nonatomic, assign) int valueChoice;

+ (int)VALUE_OCTETS;
+ (int)VALUE_OID;
+ (int)VALUE_UTF8;
+ (IetfAttrSyntax *)getInstance:(id)paramObject;
- (GeneralNames *)getPolicyAuthority;
- (int)getValueType;
- (NSMutableArray *)getValues;
- (ASN1Primitive *)toASN1Primitive;

@end
