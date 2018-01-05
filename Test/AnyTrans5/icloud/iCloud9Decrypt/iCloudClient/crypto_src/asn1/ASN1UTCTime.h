//
//  ASN1UTCTime.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Primitive.h"
#import "ASN1TaggedObject.h"
#import "ASN1OutputStream.h"

@interface ASN1UTCTime : ASN1Primitive {
@private
    NSMutableData *_time;
}

+ (ASN1UTCTime *)getInstance:(id)paramObject;
+ (ASN1UTCTime *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamString:(NSString *)paramString;
- (instancetype)initParamDate:(NSDate *)paramDate;
- (instancetype)initParamDate:(NSDate *)paramDate paramLocale:(NSLocale *)paramLocale;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (NSDate *)getAdjustedDate;
- (NSString *)getTime;
- (NSString *)getAdjustedTime;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;
- (NSString *)toString;

@end
