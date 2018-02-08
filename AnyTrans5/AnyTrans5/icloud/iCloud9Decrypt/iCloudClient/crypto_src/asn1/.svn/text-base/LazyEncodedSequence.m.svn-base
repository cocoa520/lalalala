//
//  LazyEncodedSequence.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "LazyEncodedSequence.h"
#import "LazyConstructionEnumeration.h"
#import "StreamUtil.h"

@interface LazyEncodedSequence ()

@property (nonatomic, readwrite, retain) NSMutableData *encoded;

@end

@implementation LazyEncodedSequence
@synthesize encoded = _encoded;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_encoded) {
        [_encoded release];
        _encoded = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        self.encoded = paramArrayOfByte;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)parse {
    LazyConstructionEnumeration *localLazyConstructionEnumeration = [[LazyConstructionEnumeration alloc] initParamArrayOfByte:self.encoded];
    id localObject = nil;
    while (localObject = [localLazyConstructionEnumeration nextObject]) {
        [self.seq addObject:localObject];
    }
    self.encoded = nil;
#if !__has_feature(objc_arc)
    if (localLazyConstructionEnumeration) [localLazyConstructionEnumeration release]; localLazyConstructionEnumeration = nil;
#endif
}

- (ASN1Encodable *)getObjectAt:(int)paramInt {
    if (self.encoded) {
        [self parse];
    }
    return [super getObjectAt:paramInt];
}

- (NSEnumerator *)getObjects {
    if (!self.encoded) {
        return [super getObjects];
    }
    return [[[LazyConstructionEnumeration alloc] initParamArrayOfByte:self.encoded] autorelease];
}

- (int)size {
    if (self.encoded) {
        [self parse];
    }
    return [super size];
}

- (ASN1Primitive *)toDERObject {
    if (self.encoded) {
        [self parse];
    }
    return [super toDERObject];
}

- (ASN1Primitive *)toDLObject {
    if (self.encoded) {
        [self parse];
    }
    return [super toDLObject];
}

- (int)encodedLength {
    if (self.encoded) {
        return 1 + [StreamUtil calculateBodyLength:(int)[self.encoded length]] + (int)[self.encoded length];
    }
    return [[super toDLObject] encodedLength];
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    if (self.encoded) {
        [paramASN1OutputStream writeEncoded:48 paramArrayOfByte:self.encoded];
    }else {
        [[super toDLObject] encode:paramASN1OutputStream];
    }
}

@end
