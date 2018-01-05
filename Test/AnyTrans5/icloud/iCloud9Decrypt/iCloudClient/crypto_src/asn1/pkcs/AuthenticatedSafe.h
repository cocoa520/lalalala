//
//  AuthenticatedSafe.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"

@interface AuthenticatedSafe : ASN1Object {
@private
    NSMutableArray *_info;
    BOOL _isBer;
}

+ (AuthenticatedSafe *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfContentInfo:(NSMutableArray *)paramArrayOfContentInfo;
- (NSMutableArray *)getContentInfo;
- (ASN1Primitive *)toASN1Primitive;

@end
