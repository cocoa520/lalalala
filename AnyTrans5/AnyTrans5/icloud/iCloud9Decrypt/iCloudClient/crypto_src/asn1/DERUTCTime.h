//
//  DERUTCTime.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1UTCTime.h"

@interface DERUTCTime : ASN1UTCTime

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamDate:(NSDate *)paramDate;
- (instancetype)initParamString:(NSString *)paramString;

@end
