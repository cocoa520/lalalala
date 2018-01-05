//
//  Accuracy.h
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "ASN1Sequence.h"

@interface Accuracy : ASN1Object {
    ASN1Integer *_seconds;
    ASN1Integer *_millis;
    ASN1Integer *_micros;
}

@property (nonatomic, readwrite, retain) ASN1Integer *seconds;
@property (nonatomic, readwrite, retain) ASN1Integer *millis;
@property (nonatomic, readwrite, retain) ASN1Integer *micros;

+ (int)MIN_MILLIS;
+ (int)MAX_MILLIS;
+ (int)MIN_MICROS;
+ (int)MAX_MICROS;
+ (Accuracy *)getInstance:(id)paramObject;
- (instancetype)init;
- (instancetype)initParamASN1Integer1:(ASN1Integer *)paramASN1Integer1 paramASN1Integer2:(ASN1Integer *)paramASN1Integer2 paramASN1Integer3:(ASN1Integer *)paramASN1Integer3;
- (ASN1Integer *)getSeconds;
- (ASN1Integer *)getMillis;
- (ASN1Integer *)getMicros;
- (ASN1Primitive *)toASN1Primitive;

@end
