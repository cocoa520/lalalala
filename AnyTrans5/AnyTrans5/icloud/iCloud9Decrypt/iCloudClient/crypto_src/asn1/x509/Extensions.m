//
//  Extensions.m
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Extensions.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface Extensions ()

@property (nonatomic, readwrite, retain) NSMutableDictionary *extensions;
@property (nonatomic, readwrite, retain) NSMutableArray *ordering;

@end

@implementation Extensions
@synthesize extensions = _extensions;
@synthesize ordering = _ordering;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_extensions) {
        [_extensions release];
        _extensions = nil;
    }
    if (_ordering) {
        [_ordering release];
        _ordering = nil;
    }
    [super dealloc];
#endif
}

+ (Extensions *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[Extensions class]]) {
        return (Extensions *)paramObject;
    }
    if (paramObject) {
        return [[[Extensions alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (Extensions *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [Extensions getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            Extension *localExtension = [Extension getInstance:localObject];
            [self.extensions setObject:localExtension forKey:[localExtension getExtnId]];
            [self.ordering addObject:[localExtension getExtnId]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamExtension:(Extension *)paramExtension
{
    if (self = [super init]) {
        [self.ordering addObject:[paramExtension getExtnId]];
        [self.extensions setObject:paramExtension forKey:[paramExtension getExtnId]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfExtension:(NSMutableArray *)paramArrayOfExtension
{
    if (self = [super init]) {
        for (int i = 0; i != [paramArrayOfExtension count]; i++) {
            Extension *localExtension = paramArrayOfExtension[i];
            [self.ordering addObject:[localExtension getExtnId]];
            [self.extensions setObject:localExtension forKey:[localExtension getExtnId]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSEnumerator *)oids {
    return [self.ordering objectEnumerator];
}

- (Extension *)getExtension:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    return (Extension *)[self.extensions objectForKey:paramASN1ObjectIdentifier];
}

- (ASN1Encodable *)getExtensionParsedValue:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    Extension *localExtension = [self getExtension:paramASN1ObjectIdentifier];
    if (localExtension) {
        return [localExtension getParsedValue];
    }
    return nil;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    NSEnumerator *localEnumeration = [self.ordering objectEnumerator];
    while ([localEnumeration nextObject]) {
        ASN1ObjectIdentifier *localASN1ObjectIdentifier = (ASN1ObjectIdentifier *)[localEnumeration nextObject];
        Extension *localExtension = (Extension *)[self.extensions objectForKey:localASN1ObjectIdentifier];
        [localASN1EncodableVector add:localExtension];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (BOOL)equivalent:(Extensions *)paramExtensions {
    if ([self.extensions count] != [paramExtensions.extensions count]) {
        return NO;
    }
    NSEnumerator *localEnumeration = [self.extensions keyEnumerator];
    while ([localEnumeration nextObject]) {
        id localObject = [localEnumeration nextObject];
        if (![[self.extensions objectForKey:localObject] isEqual:[paramExtensions.extensions objectForKey:localObject]]) {
            return NO;
        }
    }
    return YES;
}

- (NSMutableArray *)getExtensionOIDs {
    return [self toOidArray:self.ordering];
}

- (NSMutableArray *)getNonCriticalExtensionOIDs {
    return [self getExtensionOIDs:false];
}

- (NSMutableArray *)getCriticalExtensionOIDs {
    return [self getExtensionOIDs:TRUE];
}

- (NSMutableArray *)getExtensionOIDs:(BOOL)paramBoolean {
    NSMutableArray *localVector = [[NSMutableArray alloc] init];
    for (int i = 0; i != [self.ordering count]; i++) {
        id localObject = [self.ordering objectAtIndex:i];
        if ([((Extension *)[self.extensions objectForKey:localObject]) isCritical] == paramBoolean) {
            [localVector addObject:localObject];
        }
    }
    NSMutableArray *returnAry = [self toOidArray:localVector];
#if !__has_feature(objc_arc)
    if (localVector) [localVector release]; localVector = nil;
#endif
    return returnAry;
}

- (NSMutableArray *)toOidArray:(NSMutableArray *)paramVector {
    NSMutableArray *arrayOfASN1ObjectIdentifier = [[[NSMutableArray alloc] initWithSize:(int)[paramVector count]] autorelease];
    for (int i = 0; i != [arrayOfASN1ObjectIdentifier count]; i++) {
        arrayOfASN1ObjectIdentifier[i] = (ASN1ObjectIdentifier *)[paramVector objectAtIndex:i];
    }
    return arrayOfASN1ObjectIdentifier;
}

- (void)setExtensions:(NSMutableDictionary *)extensions {
    if (_extensions != extensions) {
        _extensions = [[[NSMutableDictionary alloc] init] autorelease];
    }
}

- (void)setOrdering:(NSMutableArray *)ordering {
    if (_ordering != ordering) {
        _ordering = [[[NSMutableArray alloc] init] autorelease];
    }
}

@end
