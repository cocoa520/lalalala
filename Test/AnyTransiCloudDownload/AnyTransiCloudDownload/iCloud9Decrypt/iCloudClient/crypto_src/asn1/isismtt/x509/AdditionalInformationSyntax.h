//
//  AdditionalInformationSyntax.h
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "DirectoryString.h"

@interface AdditionalInformationSyntax : ASN1Object {
@private
    DirectoryString *_infomation;
}

+ (AdditionalInformationSyntax *)getInstance:(id)paramObject;
- (instancetype)initParamString:(NSString *)paramString;
- (DirectoryString *)getInfomation;
- (ASN1Primitive *)toASN1Primitive;

@end
