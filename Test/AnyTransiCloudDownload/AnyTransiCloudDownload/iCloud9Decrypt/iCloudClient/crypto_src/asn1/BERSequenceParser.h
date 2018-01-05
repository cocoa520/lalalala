//
//  BERSequenceParser.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1SequenceParser.h"
#import "ASN1StreamParser.h"

@interface BERSequenceParser : ASN1SequenceParser {
@private
    ASN1StreamParser *_parser;
}

- (instancetype)initParamASN1StreamParser:(ASN1StreamParser *)paramASN1StreamParser;
- (ASN1Encodable *)readObject;
- (ASN1Primitive *)getLoadedObject;
- (ASN1Primitive *)toASN1Primitive;

@end
