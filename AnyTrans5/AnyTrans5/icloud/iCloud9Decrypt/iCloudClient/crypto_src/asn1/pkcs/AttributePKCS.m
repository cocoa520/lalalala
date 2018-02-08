//
//  AttributePKCS.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "AttributePKCS.h"

@interface AttributePKCS ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *attrType;
@property (nonatomic, readwrite, retain) ASN1Set *attrValues;

@end

@implementation AttributePKCS
@synthesize attrType = _attrType;
@synthesize attrValues = _attrValues;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_attrType) {
        [_attrType release];
        _attrType = nil;
    }
    if (_attrValues) {
        [_attrValues release];
        _attrValues = nil;
    }
    [super dealloc];
#endif
}

+ (AttributePKCS *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[AttributePKCS class]]) {
        return (AttributePKCS *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[AttributePKCS alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown object in factory: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.attrType = (ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:0];
        self.attrValues = (ASN1Set *)[paramASN1Sequence getObjectAt:1];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Set:(ASN1Set *)paramASN1Set
{
    if (self = [super init]) {
        self.attrType = paramASN1ObjectIdentifier;
        self.attrValues = paramASN1Set;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getAttrType {
    return self.attrType;
}

- (ASN1Set *)getAttrValues {
    return self.attrValues;
}

- (NSMutableArray *)getAttributeValues {
    return [self.attrValues toArray];
}

@end
