//
//  CertificateHolderAuthorization.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "DERApplicationSpecific.h"
#import "BidirectionalMap.h"

@interface CertificateHolderAuthorization : ASN1Object {
    ASN1ObjectIdentifier *_oid;
    DERApplicationSpecific *_accessRights;
}

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *oid;
@property (nonatomic, readwrite, retain) DERApplicationSpecific *accessRights;

+ (ASN1ObjectIdentifier *)id_role_EAC;
+ (int)CVCA;
+ (int)DV_DOMESTIC;
+ (int)DV_FOREIGN;
+ (int)IS;
+ (int)RADG4;
+ (int)RADG3;
+ (NSMutableDictionary *)RightsDecodeMap;
+ (BidirectionalMap *)AuthorizationRole;
+ (NSMutableDictionary *)ReverseMap;
+ (NSString *)getRoleDescription:(int)paramInt;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramInt:(int)paramInt;
- (instancetype)initParamDERApplicationSpecific:(DERApplicationSpecific *)paramDERApplicationSpecific;
- (int)getAccessRights;
- (ASN1ObjectIdentifier *)getOid;
- (ASN1Primitive *)toASN1Primitive;

@end
