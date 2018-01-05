//
//  AdmissionSyntax.h
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "GeneralName.h"
#import "ASN1Sequence.h"

@interface AdmissionSyntax : ASN1Object {
@private
    GeneralName *_admissionAuthority;
    ASN1Sequence *_contentsOfAdmissions;
}

+ (AdmissionSyntax *)getInstance:(id)paramObject;
- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (ASN1Primitive *)toASN1Primitive;
- (GeneralName *)getAdmissionAuthority;
- (NSMutableArray *)getContentsOfAdmissions;

@end
