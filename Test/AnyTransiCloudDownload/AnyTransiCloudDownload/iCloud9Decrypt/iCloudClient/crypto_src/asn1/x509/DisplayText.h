//
//  DisplayText.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1String.h"
#import "ASN1TaggedObject.h"

@interface DisplayText : ASN1Choice {
    int _contentType;
    ASN1String *_contents;
}

@property (nonatomic, assign) int contentType;
@property (nonatomic, readwrite, retain) ASN1String *contents;

+ (int)CONTENT_TYPE_IA5STRING;
+ (int)CONTENT_TYPE_BMPSTRING;
+ (int)CONTENT_TYPE_UTF8STRING;
+ (int)CONTENT_TYPE_VISIBLESTRING;
+ (int)DISPLAY_TEXT_MAXIMUM_SIZE;
+ (DisplayText *)getInstance:(id)paramObject;
+ (DisplayText *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamInt:(int)paramInt paramString:(NSString *)paramString;
- (instancetype)initParamString:(NSString *)paramString;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)getString;

@end
