//
//  DVCSRequestInformationBuilder.h
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceType.h"
#import "DVCSRequestInformation.h"
#import "BigInteger.h"
#import "DVCSTime.h"
#import "GeneralNames.h"
#import "PolicyInformation.h"
#import "Extensions.h"

@interface DVCSRequestInformationBuilder : NSObject {
@private
    int _version;
    ServiceType *_service;
    DVCSRequestInformation *_initialInfo;
    BigInteger *_nonce;
    DVCSTime *_requestTime;
    GeneralNames *_requester;
    PolicyInformation *_requestPolicy;
    GeneralNames *_dvcs;
    GeneralNames *_dataLocations;
    Extensions *_extensions;
}

- (instancetype)initParamServiceType:(ServiceType *)paramServiceType;
- (instancetype)initParamDVCSRequestInformation:(DVCSRequestInformation *)paramDVCSRequestInformation;
- (DVCSRequestInformation *)build;
- (void)setVersion:(int)version;
- (void)setNonce:(BigInteger *)nonce;
- (void)setRequestTime:(DVCSTime *)requestTime;
- (void)setRequesterGeneralName:(GeneralName *)requester;
- (void)setRequester:(GeneralNames *)requesters;
- (void)setRequestPolicy:(PolicyInformation *)requestPolicy;
- (void)setDvcsGeneralName:(GeneralName *)dvcs;
- (void)setDvcs:(GeneralNames *)dvcs;
- (void)setDataLocationsGeneralName:(GeneralName *)dataLocations;
- (void)setDataLocations:(GeneralNames *)dataLocations;
- (void)setExtensions:(Extensions *)extensions;

@end
