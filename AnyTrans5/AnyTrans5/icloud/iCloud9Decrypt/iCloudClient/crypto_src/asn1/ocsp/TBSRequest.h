//
//  TBSRequest.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "GeneralName.h"
#import "ASN1Sequence.h"
#import "Extensions.h"
#import "ASN1TaggedObject.h"
#import "X509Extensions.h"

@interface TBSRequest : ASN1Object {
    ASN1Integer *_version;
    GeneralName *_requestorName;
    ASN1Sequence *_requestList;
    Extensions *_requestExtensions;
    BOOL _versionSet;
}

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) GeneralName *requestorName;
@property (nonatomic, readwrite, retain) ASN1Sequence *requestList;
@property (nonatomic, readwrite, retain) Extensions *requestExtensions;
@property (nonatomic, assign) BOOL versionSet;

+ (TBSRequest *)getInstance:(id)paramObject;
+ (TBSRequest *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence paramX509Extensions:(X509Extensions *)paramX509Extensions;
- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence paramExtensions:(Extensions *)paramExtensions;
- (ASN1Integer *)getVersion;
- (GeneralName *)getRequestorName;
- (ASN1Sequence *)getRequestList;
- (Extensions *)getRequestExtensions;
- (ASN1Primitive *)toASN1Primitive;

@end
