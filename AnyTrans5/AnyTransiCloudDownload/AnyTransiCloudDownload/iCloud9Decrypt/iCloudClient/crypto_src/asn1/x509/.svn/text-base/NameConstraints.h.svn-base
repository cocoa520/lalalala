//
//  NameConstraints.h
//  crypto
//
//  Created by JGehry on 7/11/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"

@interface NameConstraints : ASN1Object {
@private
    NSMutableArray *_permitted;
    NSMutableArray *_excluded;
}

+ (NameConstraints *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfGeneralSubtree1:(NSMutableArray *)paramArrayOfGeneralSubtree1 paramArrayOfGeneralSubtree2:(NSMutableArray *)paramArrayOfGeneralSubtree2;
- (NSMutableArray *)getPermittedSubtrees;
- (NSMutableArray *)getExcludedSubtrees;
- (ASN1Primitive *)toASN1Primitive;

@end
