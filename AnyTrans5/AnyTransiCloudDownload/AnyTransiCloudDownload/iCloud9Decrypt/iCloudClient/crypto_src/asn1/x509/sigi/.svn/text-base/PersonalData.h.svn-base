//
//  PersonalData.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "NameOrPseudonym.h"
#import "BigInteger.h"
#import "ASN1GeneralizedTime.h"
#import "DirectoryString.h"

@interface PersonalData : ASN1Object {
@private
    NameOrPseudonym *_nameOrPseudonym;
    BigInteger *_nameDistinguisher;
    ASN1GeneralizedTime *_dateOfBirth;
    DirectoryString *_placeOfBirth;
    NSString *_gender;
    DirectoryString *_postalAddress;
}

+ (PersonalData *)getInstance:(id)paramObject;
- (instancetype)initParamNameOrPseudonym:(NameOrPseudonym *)paramNameOrPseudonym paramBigInteger:(BigInteger *)paramBigInteger paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramDirectoryString1:(DirectoryString *)paramDirectoryString1 paramString:(NSString *)paramString paramDirectoryString2:(DirectoryString *)paramDirectoryString2;
- (NameOrPseudonym *)getNameOrPseudonym;
- (BigInteger *)getNameDistinguisher;
- (ASN1GeneralizedTime *)getDateOfBirth;
- (DirectoryString *)getPlaceOfBirth;
- (NSString *)getGender;
- (DirectoryString *)getPostalAddress;
- (ASN1Primitive *)toASN1Primitive;

@end
