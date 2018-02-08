//
//  SubjectDirectoryAttributes.m
//  crypto
//
//  Created by JGehry on 7/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SubjectDirectoryAttributes.h"
#import "AttributeX509.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface SubjectDirectoryAttributes ()

@property (nonatomic, readwrite, retain) NSMutableArray *attributes;

@end

@implementation SubjectDirectoryAttributes
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

+ (SubjectDirectoryAttributes *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[SubjectDirectoryAttributes class]]) {
        return (SubjectDirectoryAttributes *)paramObject;
    }
    if (paramObject) {
        return [[[SubjectDirectoryAttributes alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            ASN1Sequence *localASN1Sequence = [ASN1Sequence getInstance:localObject];
            [self.attributes addObject:[AttributeX509 getInstance:localASN1Sequence]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (instancetype)initParamVector:(NSMutableArray *)paramVector
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramVector objectEnumerator];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            [self.attributes addObject:localObject];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    NSEnumerator *localEnumeration = [self.attributes objectEnumerator];
    AttributeX509 *x509 = nil;
    while (x509 = [localEnumeration nextObject]) {
        [localASN1EncodableVector add:x509];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (NSMutableArray *)getAttributes {
    return self.attributes;
}

@end
