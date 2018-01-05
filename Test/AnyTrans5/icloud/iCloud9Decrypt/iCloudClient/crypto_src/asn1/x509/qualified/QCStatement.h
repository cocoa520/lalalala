//
//  QCStatement.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Encodable.h"

@interface QCStatement : ASN1Object {
    ASN1ObjectIdentifier *_qcStatementId;
    ASN1Encodable *_qcStatementInfo;
}

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *qcStatementId;
@property (nonatomic, readwrite, retain) ASN1Encodable *qcStatementInfo;

+ (QCStatement *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (ASN1ObjectIdentifier *)getStatementId;
- (ASN1Encodable *)getStatementInfo;
- (ASN1Primitive *)toASN1Primitive;

@end
