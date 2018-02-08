//
//  RoleSyntax.h
//  crypto
//
//  Created by JGehry on 7/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "GeneralName.h"
#import "GeneralNames.h"

@interface RoleSyntax : ASN1Object {
@private
    GeneralNames *_roleAuthority;
    GeneralName *_roleName;
}

+ (RoleSyntax *)getInstance:(id)paramObject;
- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames paramGeneralName:(GeneralName *)paramGeneralName;
- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName;
- (instancetype)initParamString:(NSString *)paramString;
- (GeneralNames *)getRoleAuthority;
- (GeneralName *)getRoleName;
- (NSString *)getRoleNameAsString;
- (NSMutableArray *)getRoleAuthorityAsString;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;

@end
