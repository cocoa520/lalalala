//
//  Admissions.h
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "GeneralName.h"
#import "NamingAuthority.h"
#import "ASN1Sequence.h"

@interface Admissions : ASN1Object {
@private
    GeneralName *_admissionAuthority;
    NamingAuthority *_namingAuthority;
    ASN1Sequence *_professionInfos;
}

+ (Admissions *)getInstance:(id)paramObject;
- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName paramNamingAuthority:(NamingAuthority *)paramNamingAuthority paramArrayOfProfessionInfo:(NSMutableArray *)paramArrayOfProfessionInfo;
- (GeneralName *)getAdmissionAuthority;
- (NamingAuthority *)getNamingAuthority;
- (NSMutableArray *)getProfessionInfos;
- (ASN1Primitive *)toASN1Primitive;

@end
