//
//  PackedDate.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackedDate : NSObject {
@private
    NSMutableData *_time;
}

- (instancetype)initParamString:(NSString *)paramString;
- (instancetype)initParamDate:(NSDate *)paramDate;
- (instancetype)initParamDate:(NSDate *)paramDate paramLocale:(NSLocale *)paramLocale;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (NSDate *)getDate;
- (NSString *)toString;
- (NSMutableData *)getEncoding;

@end
