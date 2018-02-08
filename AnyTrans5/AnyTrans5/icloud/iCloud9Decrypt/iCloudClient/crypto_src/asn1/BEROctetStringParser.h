//
//  BEROctetStringParser.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1OctetStringParser.h"
#import "ASN1StreamParser.h"

@interface BEROctetStringParser : ASN1OctetStringParser {
@private
    ASN1StreamParser *_parser;
}

- (instancetype)initParamASN1StreamParser:(ASN1StreamParser *)paramASN1StreamParser;
- (Stream *)getOctetStream;
- (ASN1Primitive *)getLoadedObject;
- (ASN1Primitive *)toASN1Primitive;

@end
