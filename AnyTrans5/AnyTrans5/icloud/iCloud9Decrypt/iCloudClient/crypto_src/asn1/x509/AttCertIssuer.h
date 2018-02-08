//
//  AttCertIssuer.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1Encodable.h"
#import "ASN1Primitive.h"
#import "ASN1TaggedObject.h"
#import "GeneralNames.h"
#import "V2Form.h"

@interface AttCertIssuer : ASN1Choice {
    ASN1Encodable *_obj;
    ASN1Primitive *_choiceObj;
}

@property (nonatomic, readwrite, retain) ASN1Encodable *obj;
@property (nonatomic, readwrite, retain) ASN1Primitive *choiceObj;

+ (AttCertIssuer *)getInstance:(id)paramObject;
+ (AttCertIssuer *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames;
- (instancetype)initParamV2Form:(V2Form *)paramV2Form;
- (ASN1Encodable *)getIssuer;
- (ASN1Primitive *)toASN1Primitive;

@end
