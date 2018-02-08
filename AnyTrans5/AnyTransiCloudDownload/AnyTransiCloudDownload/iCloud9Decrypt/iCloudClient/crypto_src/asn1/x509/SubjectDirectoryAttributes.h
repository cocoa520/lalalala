//
//  SubjectDirectoryAttributes.h
//  crypto
//
//  Created by JGehry on 7/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"

@interface SubjectDirectoryAttributes : ASN1Object {
@private
    NSMutableArray *_attributes;
}

+ (SubjectDirectoryAttributes *)getInstance:(id)paramObject;
- (instancetype)initParamVector:(NSMutableArray *)paramVector;
- (ASN1Primitive *)toASN1Primitive;
- (NSMutableArray *)getAttributes;

@end
