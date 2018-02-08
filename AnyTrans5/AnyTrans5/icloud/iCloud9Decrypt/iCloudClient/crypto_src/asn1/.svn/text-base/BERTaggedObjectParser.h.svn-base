//
//  BERTaggedObjectParser.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1TaggedObjectParser.h"
#import "ASN1StreamParser.h"

@interface BERTaggedObjectParser : ASN1TaggedObjectParser {
@private
    BOOL _constructed;
    int _tagNumber;
    ASN1StreamParser *_parser;
}

- (instancetype)initParamBoolean:(BOOL)paramBoolean paramInt:(int)paramInt paramASN1StreamParser:(ASN1StreamParser *)paramASN1StreamParser;
- (BOOL)isConstructed;
- (int)getTagNo;
- (ASN1Encodable *)getObjectParser:(int)paramInt paramBoolean:(BOOL)paramBoolean;
- (ASN1Primitive *)getLoadedObject;
- (ASN1Primitive *)toASN1Primitive;

@end
