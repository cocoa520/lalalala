//
//  DVCSRequestInformation.h
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "ServiceType.h"
#import "BigInteger.h"
#import "DVCSTime.h"
#import "GeneralNames.h"
#import "PolicyInformation.h"
#import "Extensions.h"

@interface DVCSRequestInformation : ASN1Object {
@private
    int _version;
    ServiceType *_service;
    BigInteger *_nonce;
    DVCSTime *_requestTime;
    GeneralNames *_requester;
    PolicyInformation *_requestPolicy;
    GeneralNames *_dvcs;
    GeneralNames *_dataLocations;
    Extensions *_extensions;
}

+ (DVCSRequestInformation *)getInstance:(id)paramObject;
+ (DVCSRequestInformation *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;
- (int)getVersion;
- (ServiceType *)getService;
- (BigInteger *)getNonce;
- (DVCSTime *)getRequestTime;
- (GeneralNames *)getRequester;
- (PolicyInformation *)getRequestPolicy;
- (GeneralNames *)getDVCS;
- (GeneralNames *)getDataLocations;
- (Extensions *)getExtensions;

@end
