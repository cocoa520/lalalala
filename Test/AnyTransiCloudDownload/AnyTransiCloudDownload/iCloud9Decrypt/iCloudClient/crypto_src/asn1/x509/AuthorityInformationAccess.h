//
//  AuthorityInformationAccess.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "Extensions.h"
#import "AccessDescription.h"

@interface AuthorityInformationAccess : ASN1Object {
@private
    NSMutableArray *_descriptions;
}

+ (AuthorityInformationAccess *)getInstance:(id)paramObject;
+ (AuthorityInformationAccess *)fromExtensions:(Extensions *)paramExtensions;
- (instancetype)initParamAccessDescription:(AccessDescription *)paramAccessDescription;
- (instancetype)initParamArrayOfAccessDescription:(NSMutableArray *)paramArrayOfAccessDescription;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramGeneralName:(GeneralName *)paramGeneralName;
- (NSMutableArray *)getAccessDescriptions;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;

@end
