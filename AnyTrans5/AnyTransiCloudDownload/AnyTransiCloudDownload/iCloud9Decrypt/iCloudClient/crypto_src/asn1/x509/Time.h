//
//  Time.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1TaggedObject.h"

@interface Time : ASN1Choice {
    ASN1Primitive *_time;
}

@property (nonatomic, readwrite, retain) ASN1Primitive *time;

+ (Time *)getInstance:(id)paramObject;
+ (Time *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Primitive:(ASN1Primitive *)paramASN1Primitive;
- (instancetype)initParamDate:(NSDate *)paramDate;
- (NSString *)getTime;
- (NSDate *)getDate;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;

@end
