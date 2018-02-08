//
//  DVCSTime.h
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1GeneralizedTime.h"
#import "ContentInfo.h"
#import "ASN1TaggedObject.h"

@interface DVCSTime : ASN1Choice {
@private
    ASN1GeneralizedTime *_genTime;
    ContentInfo *_timeStampToken;
    NSDate *_time;
}

+ (DVCSTime *)getInstance:(id)paramObject;
+ (DVCSTime *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamDate:(NSDate *)paramDate;
- (instancetype)initParamASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime;
- (instancetype)initParamContentInfo:(ContentInfo *)paramContentInfo;
- (ASN1GeneralizedTime *)getGenTime;
- (ContentInfo *)getTimeStampToken;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;

@end
