//
//  CrlOcspRef.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "CrlListID.h"
#import "OcspListID.h"
#import "OtherRevRefs.h"

@interface CrlOcspRef : ASN1Object {
@private
    CrlListID *_crlids;
    OcspListID *_ocspids;
    OtherRevRefs *_otherRev;
}

+ (CrlOcspRef *)getInstance:(id)paramObject;
- (instancetype)initParamCrlListID:(CrlListID *)paramCrlListID paramOcspListID:(OcspListID *)paramOcspListID paramOtherRevRefs:(OtherRevRefs *)paramOtherRevRefs;
- (CrlListID *)getCrlids;
- (OcspListID *)getOcspids;
- (OtherRevRefs *)getOtherRev;
- (ASN1Primitive *)toASN1Primitive;

@end
