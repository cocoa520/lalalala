//
//  IMBArtworkStringMHOD.h
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBStringMHOD.h"

typedef enum StringEncodingType {
    Ascii = 0,
    UTF8 = 1,
    Unicode = 2
} StringEncodingTypeEnum;

@interface IMBArtworkStringMHOD : IMBStringMHOD {
@private
    uint16 _unk1x;
    int _padding;
    StringEncodingTypeEnum _stringType;
    int _unk3;
    int _actualPadding;
}

@property (nonatomic, readonly) NSStringEncoding stringEncoding;

- (NSStringEncoding)stringEncoding;

- (void)setData:(NSString *)data;
- (NSString*)data;

- (void)create:(NSString*)data;

@end
