//
//  OCSPRequest.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "TBSRequest.h"
#import "Signature.h"
#import "ASN1TaggedObject.h"

@interface OCSPRequest : ASN1Object {
    TBSRequest *_tbsRequest;
    Signature *_optionalSignature;
}

@property (nonatomic, readwrite, retain) TBSRequest *tbsRequest;
@property (nonatomic, readwrite, retain) Signature *optionalSignature;

+ (OCSPRequest *)getInstance:(id)paramObject;
+ (OCSPRequest *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamTBSRequest:(TBSRequest *)paramTBSRequest paramSignature:(Signature *)paramSignature;
- (TBSRequest *)getTbsRequest;
- (Signature *)getOptionalSignature;
- (ASN1Primitive *)toASN1Primitive;

@end
