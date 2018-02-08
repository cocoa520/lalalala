//
//  NamingAuthority.h
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "DirectoryString.h"
#import "ASN1TaggedObject.h"

@interface NamingAuthority : ASN1Object {
@private
    ASN1ObjectIdentifier *_namingAuthorityId;
    NSString *_namingAuthorityUrl;
    DirectoryString *_namingAuthorityText;
}

+ (ASN1ObjectIdentifier *)id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern;
+ (NamingAuthority *)getInstance:(id)paramObject;
+ (NamingAuthority *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString paramDirectoryString:(DirectoryString *)paramDirectoryString;
- (ASN1ObjectIdentifier *)getNamingAuthorityId;
- (DirectoryString *)getNamingAuthorityText;
- (NSString *)getNamingAuthorityUrl;
- (ASN1Primitive *)toASN1Primitive;

@end
