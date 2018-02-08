//
//  ASN1EncodableVector.m
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1EncodableVector.h"

@implementation ASN1EncodableVector
@synthesize vector = _vector;

- (instancetype)init
{
    if (self = [super init]) {
        NSMutableArray *tmpVector = [[NSMutableArray alloc] init];
        [self setVector:tmpVector];
#if !__has_feature(objc_arc)
        if (tmpVector) [tmpVector release]; tmpVector = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [self setVector:nil];
    [super dealloc];
#endif
}

- (void)add:(ASN1Encodable *)paramASN1Encodable {
    [self.vector addObject:paramASN1Encodable];
}

- (void)addAll:(ASN1EncodableVector *)paramASN1EncodableVector {
    NSEnumerator *localEnumeration = paramASN1EncodableVector.vector.objectEnumerator;
    id localObject = nil;
    while (localObject = [localEnumeration nextObject]) {
        [self.vector addObject:localObject];
    }
}

- (ASN1Encodable *)get:(int)paramInt {
    return (ASN1Encodable *)[self.vector objectAtIndex:paramInt];
}

- (NSUInteger)size {
    return [self.vector count];
}

@end
