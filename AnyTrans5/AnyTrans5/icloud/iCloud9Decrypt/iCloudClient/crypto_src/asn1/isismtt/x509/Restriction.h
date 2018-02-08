//
//  Restriction.h
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "DirectoryString.h"

@interface Restriction : ASN1Object {
@private
    DirectoryString *_restriction;
}

+ (Restriction *)getInstance:(id)paramObject;
- (instancetype)initParamString:(NSString *)paramString;
- (DirectoryString *)getRestriction;
- (ASN1Primitive *)toASN1Primitive;

@end
