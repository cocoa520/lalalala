//
//  ASN1Sequence.m
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Sequence.h"
#import "ASN1SequenceParser.h"
#import "ASN1Encodable.h"
#import "BERTaggedObject.h"
#import "BERSequence.h"
#import "DLSequence.h"
#import "DERSequence.h"

@implementation ASN1Sequence
@synthesize seq = _seq;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_seq) {
        [_seq release];
        _seq = nil;
    }
    [super dealloc];
#endif
}

+ (ASN1Sequence *)getInstance:(id)paramObject {
    if ((!paramObject) || ([paramObject isKindOfClass:[ASN1Sequence class]])) {
        return (ASN1Sequence *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1SequenceParser class]]) {
        return [ASN1Sequence getInstance:[((ASN1SequenceParser *)paramObject) toASN1Primitive]];
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return [ASN1Sequence getInstance:[self fromByteArray:(NSMutableData *)paramObject]];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"failed to construct sequence from byte[] :%@", exception.description] userInfo:nil];
        }
    }
    if ([paramObject isKindOfClass:[ASN1Encodable class]]) {
        ASN1Primitive *localASN1Primitive = [((ASN1Encodable *)paramObject) toASN1Primitive];
        if ([localASN1Primitive isKindOfClass:[ASN1Sequence class]]) {
            return (ASN1Sequence *)localASN1Primitive;
        }
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown object in getInstance %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (ASN1Sequence *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    if (paramBoolean) {
        if (![paramASN1TaggedObject isExplicitlyIncluded]) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"object implicit - explicit expected." userInfo:nil];
        }
        return [ASN1Sequence getInstance:[[paramASN1TaggedObject getObject] toASN1Primitive]];
    }
    if ([paramASN1TaggedObject isExplicitlyIncluded]) {
        if ([paramASN1TaggedObject isKindOfClass:[BERTaggedObject class]]) {
            return [[[BERSequence alloc] initParamASN1Encodable:(ASN1Encodable *)[paramASN1TaggedObject getObject]] autorelease];
        }
        return [[[DLSequence alloc] initDLParamASN1Encodable:(ASN1Encodable *)[paramASN1TaggedObject getObject]] autorelease];
    }
    if ([[paramASN1TaggedObject getObject] isKindOfClass:[ASN1Sequence class]]) {
        return (ASN1Sequence *)[paramASN1TaggedObject getObject];
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"unknown object in getInstance: %s", object_getClassName(paramASN1TaggedObject)] userInfo:nil];
}

- (instancetype)init
{
    if (self = [super init]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        [self.seq addObject:paramASN1Encodable];
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
        NSMutableArray *tmpAry = [[NSMutableArray alloc] init];
        [self setSeq:tmpAry];
        for (int i = 0; i != [paramASN1EncodableVector size]; i++) {
            [self.seq addObject:[paramASN1EncodableVector get:i]];
        }
#if !__has_feature(objc_arc)
        if (tmpAry != nil) [tmpAry release]; tmpAry = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfASN1Encodable:(NSMutableArray *)paramArrayOfASN1Encodable
{
    if (self = [super init]) {
        for (int i = 0; i != paramArrayOfASN1Encodable.count; i++) {
            [self.seq addObject:paramArrayOfASN1Encodable[i]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableArray *)toArray {
    NSMutableArray *arrayOfASN1Encodable = [[[NSMutableArray alloc] initWithSize:(int)[self size]] autorelease];
    for (int i = 0; i != [self size]; i++) {
        arrayOfASN1Encodable[i] = [self getObjectAt:i];
    }
    return arrayOfASN1Encodable;
}

- (int)size {
    return (int)self.seq.count;
}

- (ASN1Encodable *)getObjectAt:(int)paramInt {
    return (ASN1Encodable *)[self.seq objectAtIndex:paramInt];
}

- (NSEnumerator *)getObjects {
    return [self.seq objectEnumerator];
}

- (ASN1SequenceParser *)parser {
    return nil;
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[ASN1Sequence class]]) {
        return NO;
    }
    ASN1Sequence *localASN1Sequence = (ASN1Sequence *)paramASN1Primitive;
    if ([self size] != [localASN1Sequence size]) {
        return NO;
    }
    NSEnumerator *localEnumeration1 = [self getObjects];
    NSEnumerator *localEnumeration2 = [localASN1Sequence getObjects];
    id value1 = nil;
    id value2 = nil;
    while (value1 = [localEnumeration1 nextObject]) {
        ASN1Encodable *localASN1Encodable1 = [self getNext:value1];
        ASN1Encodable *localASN1Encodable2 = nil;
        if (value2 = [localEnumeration2 nextObject]) {
            localASN1Encodable2 = [self getNext:value2];
        }
        ASN1Primitive *localASN1Primitive1 = [localASN1Encodable1 toASN1Primitive];
        ASN1Primitive *localASN1Primitive2 = [localASN1Encodable2 toASN1Primitive];
        if ((localASN1Primitive1 == localASN1Primitive2) || [localASN1Primitive1 isEqual:localASN1Primitive2]) {
            continue;
        }
        return NO;
    }
    return YES;
}

- (ASN1Encodable *)getNext:(id)paramEnumeration {
    ASN1Encodable *localASN1Encodable = (ASN1Encodable *)paramEnumeration;
    return localASN1Encodable;
}

- (ASN1Primitive *)toDERObject {
    DERSequence *localDERSequence = [[[DERSequence alloc] init] autorelease];
    localDERSequence.seq = self.seq;
    return localDERSequence;
}

- (ASN1Primitive *)toDLObject {
    DLSequence *localDLSequence = [[[DLSequence alloc] init] autorelease];
    localDLSequence.seq = self.seq;
    return localDLSequence;
}

- (BOOL)isConstructed {
    return YES;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
}

- (NSUInteger)hash {
    NSEnumerator *e = [self getObjects];
    int hashCode = [self size];
    id value = nil;
    while (value = [e nextObject]) {
        id o = [self getNext:value];
        hashCode *= 17;
        hashCode ^= [o hash];
    }
    return hashCode;
}

@end
