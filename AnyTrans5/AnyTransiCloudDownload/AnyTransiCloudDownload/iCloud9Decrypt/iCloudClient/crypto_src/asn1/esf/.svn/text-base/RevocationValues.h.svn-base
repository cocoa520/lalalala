//
//  RevocationValues.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "OtherRevVals.h"

@interface RevocationValues : ASN1Object {
@private
    ASN1Sequence *_crlVals;
    ASN1Sequence *_ocspVals;
    OtherRevVals *_otherRevVals;
}

+ (RevocationValues *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfCertificateList:(NSMutableArray *)paramArrayOfCertificateList paramArrayOfBasicOCSPResponse:(NSMutableArray *)paramArrayOfBasicOCSPResponse paramOtherRevVals:(OtherRevVals *)paramOtherRevVals;
- (NSMutableArray *)getCrlVals;
- (NSMutableArray *)getOcspVals;
- (OtherRevVals *)getOtherRevVals;
- (ASN1Primitive *)toASN1Primitive;

@end
