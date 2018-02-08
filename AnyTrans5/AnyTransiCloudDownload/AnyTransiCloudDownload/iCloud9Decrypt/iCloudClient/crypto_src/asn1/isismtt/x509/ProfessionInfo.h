//
//  ProfessionInfo.h
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "NamingAuthority.h"
#import "ASN1Sequence.h"
#import "ASN1OctetString.h"
#import "ASN1ObjectIdentifier.h"

@interface ProfessionInfo : ASN1Object {
@private
    NamingAuthority *_namingAuthority;
    ASN1Sequence *_professionItems;
    ASN1Sequence *_professionOIDs;
    NSString *_registrationNumber;
    ASN1OctetString *_addProfessionInfo;
}

+ (ASN1ObjectIdentifier *)Rechtsanwltin;
+ (ASN1ObjectIdentifier *)Rechtsanwalt;
+ (ASN1ObjectIdentifier *)Rechtsbeistand;
+ (ASN1ObjectIdentifier *)Steuerberaterin;
+ (ASN1ObjectIdentifier *)Steuerberater;
+ (ASN1ObjectIdentifier *)Steuerbevollmchtigte;
+ (ASN1ObjectIdentifier *)Steuerbevollmchtigter;
+ (ASN1ObjectIdentifier *)Notarin;
+ (ASN1ObjectIdentifier *)Notar;
+ (ASN1ObjectIdentifier *)Notarvertreterin;
+ (ASN1ObjectIdentifier *)Notarvertreter;
+ (ASN1ObjectIdentifier *)Notariatsverwalterin;
+ (ASN1ObjectIdentifier *)Notariatsverwalter;
+ (ASN1ObjectIdentifier *)Wirtschaftsprferin;
+ (ASN1ObjectIdentifier *)Wirtschaftsprfer;
+ (ASN1ObjectIdentifier *)VereidigteBuchprferin;
+ (ASN1ObjectIdentifier *)VereidigterBuchprfer;
+ (ASN1ObjectIdentifier *)Patentanwltin;
+ (ASN1ObjectIdentifier *)Patentanwalt;

+ (ProfessionInfo *)getInstance:(id)paramObject;
- (instancetype)initParamNamingAuthority:(NamingAuthority *)paramNamingAuthority paramArrayOfDirectoryString:(NSMutableArray *)paramArrayOfDirectoryString paramArrayOfASN1ObjectIdentifier:(NSMutableArray *)paramArrayOfASN1ObjectIdentifier paramString:(NSString *)paramString paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (ASN1Primitive *)toASN1Primitive;
- (ASN1OctetString *)getAddProfessionInfo;
- (NamingAuthority *)getNamingAuthority;
- (NSMutableArray *)getProfessionItems;
- (NSMutableArray *)getProfessionOIDs;
- (NSString *)getRegistrationNumber;

@end
