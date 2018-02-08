//
//  ASN1Set.m
//  crypto
//
//  Created by JGehry on 5/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Set.h"
#import "BERTaggedObject.h"
#import "BERSet.h"
#import "DLSet.h"
#import "DERSet.h"
#import "ASN1Sequence.h"
#import "DERNull.h"
#import <math.h>
#import "PrivateKey.h"
#import "PublicKeyInfo.h"

@interface ASN1Set ()

@property (nonatomic, readwrite, retain) NSMutableArray *set;
@property (nonatomic, assign) BOOL isSorted;

@end

@implementation ASN1Set
@synthesize set = _set;
@synthesize isSorted = _isSorted;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_set) {
        [_set release];
        _set = nil;
    }
    [super dealloc];
#endif
}

+ (ASN1Set *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[ASN1Set class]]) {
        return  (ASN1Set *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1SetParser class]]) {
        return [ASN1Set getInstance:[((ASN1SetParser *)paramObject) toASN1Primitive]];
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return [ASN1Set getInstance:[ASN1Primitive fromByteArray:((NSMutableData *)paramObject)]];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"failed to construct set from byte[]: %@", exception.description] userInfo:nil];
        }
    }
    if ([paramObject isKindOfClass:[ASN1Encodable class]]) {
        ASN1Primitive *localASN1Primitive = [((ASN1Encodable *)paramObject) toASN1Primitive];
        if ([localASN1Primitive isKindOfClass:[ASN1Set class]]) {
            return (ASN1Set *)localASN1Primitive;
        }
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"unknown object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (ASN1Set *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    if (paramBoolean) {
        if (!paramASN1TaggedObject.explicit) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"object implicit - explicit expected." userInfo:nil];
        }
        return (ASN1Set *)[paramASN1TaggedObject getObject];
    }
    if (paramASN1TaggedObject.explicit) {
        if ([paramASN1TaggedObject isKindOfClass:[BERTaggedObject class]]) {
            return [[[BERSet alloc] initBERParamASN1Encodable:[paramASN1TaggedObject getObject]] autorelease];
        }
        return [[[DLSet alloc] initDLParamASN1Encodable:[paramASN1TaggedObject getObject]] autorelease];
    }
    if ([[paramASN1TaggedObject getObject] isKindOfClass:[ASN1Set class]]) {
        return (ASN1Set *)[paramASN1TaggedObject getObject];
    }
    if ([[paramASN1TaggedObject getObject] isKindOfClass:[ASN1Sequence class]]) {
        ASN1Sequence *localASN1Sequence = (ASN1Sequence *)[paramASN1TaggedObject getObject];
        if ([paramASN1TaggedObject isKindOfClass:[BERTaggedObject class]]) {
            return [[[BERSet alloc] initBERParamArrayOfASN1Encodable:[localASN1Sequence toArray]] autorelease];
        }
        return [[[DLSet alloc] initDLParamArrayOfASN1Encodable:[localASN1Sequence toArray]] autorelease];
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
        [[self set] addObject:paramASN1Encodable];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVector paramBoolean:(BOOL)paramBoolean
{
    if (self = [super init]) {
        NSMutableArray *tmpAry = [[NSMutableArray alloc] init];
        [self setSet:tmpAry];
        for (int i = 0; i != [paramASN1EncodableVector size]; i++) {
            [[self set] addObject:[paramASN1EncodableVector get:i]];
        }
        if (paramBoolean) {
            [self sort];
        }
#if !__has_feature(objc_arc)
        if (tmpAry) [tmpAry release]; tmpAry = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfASN1Encodable:(NSMutableArray *)paramArrayOfASN1Encodable paramBoolean:(BOOL)paramBoolean
{
    if (self = [super init]) {
        for (int i = 0; i != paramArrayOfASN1Encodable.count; i++) {
            [[self set] addObject:paramArrayOfASN1Encodable[i]];
        }
        if (paramBoolean) {
            [self sort];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Primitive *)toDERObject {
    if (self.isSorted) {
        
        ASN1Set *derSet = [[[DERSet alloc] init] autorelease];
        derSet.set = self.set;
        return derSet;
    }else {
        id localObjectMutableArray = [[NSMutableArray alloc] init];
        for (int i = 0; i != self.set.count; i++) {
            [((NSMutableArray *)localObjectMutableArray) addObject:[self.set objectAtIndex:i]];
        }
        DERSet *localDERSet = [[[DERSet alloc] init] autorelease];
        localDERSet.set = ((NSMutableArray *)localObjectMutableArray);
#if !__has_feature(objc_arc)
        if (localObjectMutableArray) [localObjectMutableArray release]; localObjectMutableArray = nil;
#endif
        [localDERSet sort];
        return localDERSet;
    }
}

- (ASN1Primitive *)toDLObject {
    DLSet *localDLSet = [[[DLSet alloc] init] autorelease];
    localDLSet.set = self.set;
    return localDLSet;
}

- (NSEnumerator *)getObjects {
    return [[self set] objectEnumerator];
}

- (ASN1Encodable *)getObjectAt:(int)paramInt {
    return (ASN1Encodable *)[[self set] objectAtIndex:paramInt];
}

- (int)size {
    return (int)[[self set] count];
}

- (NSMutableArray *)toArray {
    NSMutableArray *arrayOfASN1Encodable = [[[NSMutableArray alloc] initWithSize:(int)[self size]] autorelease];
    for (int i = 0; i != [self size]; i++) {
        arrayOfASN1Encodable[i] = [self getObjectAt:i];
    }
    return arrayOfASN1Encodable;
}

- (ASN1SetParser *)parser {
    ASN1SetParser *setParser = [[[ASN1SetParser alloc] init] autorelease];
    [setParser readObject];
    [setParser getLoadedObject];
    [setParser toASN1Primitive];
    return setParser;
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[ASN1Set class]]) {
        return NO;
    }
    ASN1Set *localASN1Set = (ASN1Set *)paramASN1Primitive;
    if ([self size] != [localASN1Set size]) {
        return NO;
    }
    id value1 = nil;
    id value2 = nil;
    NSEnumerator *localEnumeration1 = [self getObjects];
    NSEnumerator *localEnumeration2 = [localASN1Set getObjects];
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
    if (!localASN1Encodable) {
        return [DERNull INSTANCE];
    }
    return localASN1Encodable;
}

- (BOOL)lessThanOrEqualParamArrayOfByte1:(NSMutableData *)paramArrayOfByte1 paramArrayOfByte2:(NSMutableData *)paramArrayOfByte2 {
    int i = MIN(paramArrayOfByte1.length, paramArrayOfByte2.length);
    for (int j = 0; j != i; j++) {
        if (((Byte *)[paramArrayOfByte1 bytes])[j] != ((Byte *)[paramArrayOfByte2 bytes])[j]) {
            return (((Byte *)[paramArrayOfByte1 bytes])[j] & 0xFF) < (((Byte *)[paramArrayOfByte2 bytes])[j] & 0xFF);
        }
    }
    return i == paramArrayOfByte1.length;
}

- (NSMutableData *)getDEREncoded:(ASN1Encodable *)paramASN1Encodable {
    @try {
        return [[paramASN1Encodable toASN1Primitive] getEncoded:@"DER"];
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"cannot encode object added to SET" userInfo:nil];
    }
}

- (void)sort {
    if (!self.isSorted) {
        self.isSorted = YES;
        if ([self.set count] > 1) {
            BOOL swapped = YES;
            int lastSwap = [self.set count] - 1;
            while (swapped) {
                int index = 0;
                int swapIndex = 0;
                NSMutableData *a = [self getDEREncoded:(ASN1Encodable *)[self.set objectAtIndex:0]];
                swapped = NO;
                while (index != lastSwap) {
                    NSMutableData *b = [self getDEREncoded:(ASN1Encodable *)[self.set objectAtIndex:(index + 1)]];
                    if ([self lessThanOrEqualParamArrayOfByte1:a paramArrayOfByte2:b]) {
                        a = b;
                    }else {
                        id localObject2 = [self.set objectAtIndex:index];
                        [self.set replaceObjectAtIndex:index withObject:[self.set objectAtIndex:(index + 1)]];
                        [self.set replaceObjectAtIndex:index + 1 withObject:localObject2];
                        swapped = YES;
                        swapIndex = index;
                    }
                    index++;
                }
                lastSwap = swapIndex;
            }
        }
    }
}

- (BOOL)isConstructed {
    return YES;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"%@", self.set];
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
