//
//  Iso4217CurrencyCode.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1Encodable.h"

@interface Iso4217CurrencyCode : ASN1Choice {
    ASN1Encodable *_obj;
    int _numeric;
}

@property (nonatomic, readwrite, retain) ASN1Encodable *obj;
@property (nonatomic, assign) int numeric;

+ (Iso4217CurrencyCode *)getInstance:(id)paramObject;
- (instancetype)initParamInt:(int)paramInt;
- (instancetype)initParamString:(NSString *)paramString;
- (BOOL)isAlphabetic;
- (NSString *)getAlphabetic;
- (int)getNumeric;
- (ASN1Primitive *)toASN1Primitive;

@end
