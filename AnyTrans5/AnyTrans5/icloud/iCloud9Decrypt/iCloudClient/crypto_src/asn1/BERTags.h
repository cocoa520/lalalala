//
//  BERTags.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BERTags : NSObject

+ (int)BOOLEAN;
+ (int)INTEGER;
+ (int)BIT_STRING;
+ (int)OCTET_STRING;
+ (int)NULLS;
+ (int)OBJECT_IDENTIFIER;
+ (int)EXTERNAL;
+ (int)ENUMERATED;
+ (int)SEQUENCE;
+ (int)SEQUENCE_OF;
+ (int)SET;
+ (int)SET_OF;
+ (int)NUMERIC_STRING;
+ (int)PRINTABLE_STRING;
+ (int)T61_STRING;
+ (int)VIDEOTEX_STRING;
+ (int)IA5_STRING;
+ (int)UTC_TIME;
+ (int)GENERALIZED_TIME;
+ (int)GRAPHIC_STRING;
+ (int)VISIBLE_STRING;
+ (int)GENERAL_STRING;
+ (int)UNIVERSAL_STRING;
+ (int)BMP_STRING;
+ (int)UTF8_STRING;
+ (int)CONSTRUCTED;
+ (int)APPLICATION;
+ (int)TAGGED;

@end
