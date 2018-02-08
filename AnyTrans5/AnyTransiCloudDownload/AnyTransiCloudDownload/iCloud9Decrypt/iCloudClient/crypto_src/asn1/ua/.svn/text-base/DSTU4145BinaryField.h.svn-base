//
//  DSTU4145BinaryField.h
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"

@interface DSTU4145BinaryField : ASN1Object {
@private
    int _m;
    int _k;
    int _j;
    int _l;
}

+ (DSTU4145BinaryField *)getInstance:(id)paramObject;
- (instancetype)initParamInt1:(int)paramInt1 paramInt2:(int)paramInt2 paramInt3:(int)paramInt3 paramInt4:(int)paramInt4;
- (instancetype)initParamInt1:(int)paramInt1 paramInt2:(int)paramInt2;
- (int)getM;
- (int)getK1;
- (int)getK2;
- (int)getK3;
- (ASN1Primitive *)toASN1Primitive;

@end
