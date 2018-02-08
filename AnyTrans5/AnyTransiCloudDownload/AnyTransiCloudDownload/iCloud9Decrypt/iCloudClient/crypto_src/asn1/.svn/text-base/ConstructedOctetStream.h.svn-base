//
//  ConstructedOctetStream.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1StreamParser.h"
#import "CategoryExtend.h"

@interface ConstructedOctetStream : Stream {
@private
    ASN1StreamParser *_parser;
    BOOL _first;
    Stream *_currentStream;
}

- (instancetype)initParamASN1StreamParser:(ASN1StreamParser *)paramASN1StreamParser;
- (int)readParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt1:(int)paramInt1 paramInt2:(int)paramInt2;
- (int)read;

@end
