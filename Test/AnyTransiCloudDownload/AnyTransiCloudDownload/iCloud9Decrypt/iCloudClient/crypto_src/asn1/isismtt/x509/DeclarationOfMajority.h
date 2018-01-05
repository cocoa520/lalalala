//
//  DeclarationOfMajority.h
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1TaggedObject.h"
#import "ASN1GeneralizedTime.h"
#import "ASN1Sequence.h"

@interface DeclarationOfMajority : ASN1Choice {
@private
    ASN1TaggedObject *_declaration;
}

+ (int)notYoungerThan;
+ (int)fullAgeAtCountry;
+ (int)dateOfBirth;

+ (DeclarationOfMajority *)getInstance:(id)paramObject;
- (instancetype)initParamInt:(int)paramInt;
- (instancetype)initParamBoolean:(BOOL)paramBoolean paramString:(NSString *)paramString;
- (instancetype)initParamASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime;
- (ASN1Primitive *)toASN1Primitive;
- (int)getType;
- (int)notYoungerThan;
- (ASN1Sequence *)fullAgeAtCountry;
- (ASN1GeneralizedTime *)getDateOfBirth;

@end
