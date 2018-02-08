//
//  OCSPResponse.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "OCSPResponseStatus.h"
#import "ResponseBytes.h"

@interface OCSPResponse : ASN1Object {
    OCSPResponseStatus *_responseStatus;
    ResponseBytes *_responseBytes;
}

@property (nonatomic, readwrite, retain) OCSPResponseStatus *responseStatus;
@property (nonatomic, readwrite, retain) ResponseBytes *responseBytes;

+ (OCSPResponse *)getInstance:(id)paramObject;
+ (OCSPResponse *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamOCSPResponseStatus:(OCSPResponseStatus *)paramOCSPResponseStatus paramResponseBytes:(ResponseBytes *)paramResponseBytes;
- (OCSPResponseStatus *)getResponseStatus;
- (ResponseBytes *)getResponseBytes;
- (ASN1Primitive *)toASN1Primitive;

@end
