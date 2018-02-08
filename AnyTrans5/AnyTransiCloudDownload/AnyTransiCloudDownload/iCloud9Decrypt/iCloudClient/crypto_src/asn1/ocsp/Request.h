//
//  Request.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "CertID.h"
#import "Extensions.h"
#import "ASN1TaggedObject.h"

@interface Request : ASN1Object {
    CertID *_reqCert;
    Extensions *_singleRequestExtensions;
}

@property (nonatomic, readwrite, retain) CertID *reqCert;
@property (nonatomic, readwrite, retain) Extensions *singleRequestExtensions;

+ (Request *)getInstance:(id)paramObject;
+ (Request *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamCertID:(CertID *)paramCertID paramExtensions:(Extensions *)paramExtensions;
- (CertID *)getReqCert;
- (Extensions *)getSingleRequestExtensions;
- (ASN1Primitive *)toASN1Primitive;

@end
