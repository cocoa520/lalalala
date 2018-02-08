//
//  SPuri.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DERIA5String.h"
#import "ASN1Primitive.h"

@interface SPuri : NSObject {
@private
    DERIA5String *_uri;
}

+ (SPuri *)getInstance:(id)paramObject;
- (instancetype)initParamDERIA5String:(DERIA5String *)paramDERIA5String;
- (DERIA5String *)getUri;
- (ASN1Primitive *)toASN1Primitive;

@end
