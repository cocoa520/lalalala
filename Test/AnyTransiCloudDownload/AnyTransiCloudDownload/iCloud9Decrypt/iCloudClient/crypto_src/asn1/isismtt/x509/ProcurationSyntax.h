//
//  ProcurationSyntax.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "DirectoryString.h"
#import "GeneralName.h"
#import "IssuerSerial.h"

@interface ProcurationSyntax : ASN1Object {
@private
    NSString *_country;
    DirectoryString *_typeOfSubstitution;
    GeneralName *_thirdPerson;
    IssuerSerial *_certRef;
}

+ (ProcurationSyntax *)getInstance:(id)paramObject;
- (instancetype)initParamString:(NSString *)paramString paramDirectoryString:(DirectoryString *)paramDirectoryString paramIssuerSerial:(IssuerSerial *)paramIssuerSerial;
- (instancetype)initParamString:(NSString *)paramString paramDirectoryString:(DirectoryString *)paramDirectoryString paramGeneralName:(GeneralName *)paramGeneralName;
- (NSString *)getCountry;
- (DirectoryString *)getTypeOfSubstitution;
- (GeneralName *)getThirdPerson;
- (IssuerSerial *)getCertRef;
- (ASN1Primitive *)toASN1Primitive;

@end
