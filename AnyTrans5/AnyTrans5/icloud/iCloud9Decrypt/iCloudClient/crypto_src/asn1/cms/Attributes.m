//
//  Attributes.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Attributes.h"
#import "DLSet.h"
#import "Attribute.h"

@interface Attributes ()

@property (nonatomic, readwrite, retain) ASN1Set *attributes;

@end

@implementation Attributes
@synthesize attributes = _attributes;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_attributes) {
        [_attributes release];
        _attributes = nil;
    }
    [super dealloc];
#endif
}

+ (Attributes *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[Attributes class]]) {
        return (Attributes *)paramObject;
    }
    if (paramObject) {
        return [[[Attributes alloc] initParamASN1Set:[ASN1Set getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Set:(ASN1Set *)paramASN1Set
{
    if (self = [super init]) {
        self.attributes = paramASN1Set;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVector
{
    if (self = [super init]) {
        ASN1Set *attributesSet = [[DLSet alloc] initDLParamASN1EncodableVector:paramASN1EncodableVector];
        self.attributes = attributesSet;
#if !__has_feature(objc_arc)
    if (attributesSet) [attributesSet release]; attributesSet = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableArray *)getAttributes {
    NSMutableArray *arrayOfAttribute = [[[NSMutableArray alloc] initWithSize:(int)[self.attributes size]] autorelease];
    for (int i = 0; i != [arrayOfAttribute count]; i++) {
        arrayOfAttribute[i] = [Attribute getInstance:[self.attributes getObjectAt:i]];
    }
    return arrayOfAttribute;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.attributes;
}

@end
