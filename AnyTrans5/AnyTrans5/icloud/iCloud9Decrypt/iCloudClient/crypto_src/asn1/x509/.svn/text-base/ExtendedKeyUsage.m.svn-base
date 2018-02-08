//
//  ExtendedKeyUsage.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ExtendedKeyUsage.h"
#import "Extension.h"
#import "DERSequence.h"

@implementation ExtendedKeyUsage
@synthesize usageTable = _usageTable;
@synthesize seq = _seq;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_usageTable) {
        [_usageTable release];
        _usageTable = nil;
    }
    if (_seq) {
        [_seq release];
        _seq = nil;
    }
    [super dealloc];
#endif
}

+ (ExtendedKeyUsage *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ExtendedKeyUsage class]]) {
        return (ExtendedKeyUsage *)paramObject;
    }
    if (paramObject) {
        return [[[ExtendedKeyUsage alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (ExtendedKeyUsage *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [ExtendedKeyUsage getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (ExtendedKeyUsage *)fromExtensions:(Extensions *)paramExtensions {
    return [ExtendedKeyUsage getInstance:[paramExtensions getExtensionParsedValue:[Extension extendedKeyUsage]]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.seq = paramASN1Sequence;
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        ASN1Encodable *localASN1Encodable = nil;
        while (localASN1Encodable = [localEnumeration nextObject]) {
            if (![[localASN1Encodable toASN1Primitive] isKindOfClass:[ASN1ObjectIdentifier class]]) {
                @throw [NSException exceptionWithName:NSGenericException reason:@"Only ASN1ObjectIdentifiers allowed in ExtendedKeyUsage." userInfo:nil];
            }
            [self.usageTable setObject:localASN1Encodable forKey:localASN1Encodable];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamKeyPurposeId:(KeyPurposeId *)paramKeyPurposeId
{
    if (self = [super init]) {
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1Encodable:paramKeyPurposeId];
        self.seq = sequence;
        [self.usageTable setObject:paramKeyPurposeId forKey:paramKeyPurposeId];
#if !__has_feature(objc_arc)
    if (sequence) [sequence release]; sequence = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfKeyPurposeId:(NSMutableArray *)paramArrayOfKeyPurposeId
{
    if (self = [super init]) {
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        for (int i = 0; i != [paramArrayOfKeyPurposeId count]; i++) {
            [localASN1EncodableVector add:paramArrayOfKeyPurposeId[i]];
            [self.usageTable setObject:paramArrayOfKeyPurposeId[i] forKey:[NSString stringWithFormat:@"%@", paramArrayOfKeyPurposeId[i]]];
        }
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
        self.seq = sequence;
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (sequence) [sequence release]; sequence = nil;
#endif
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
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        NSEnumerator *localEnumeration = [paramVector objectEnumerator];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            KeyPurposeId *localKeyPurposeId = [KeyPurposeId getInstance:localObject];
            [localASN1EncodableVector add:localKeyPurposeId];
            [self.usageTable setObject:localKeyPurposeId forKey:localKeyPurposeId];
        }
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
        self.seq = sequence;
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (sequence) [sequence release]; sequence = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BOOL)hasKeyPurposeId:(KeyPurposeId *)paramKeyPurposeId {
    return ([self.usageTable objectForKey:paramKeyPurposeId] != nil);
}

- (NSMutableArray *)getUsages {
    NSMutableArray *arrayOfKeyPurposeId = [[[NSMutableArray alloc] initWithSize:(int)[self.seq size]] autorelease];
    int i = 0;
    NSEnumerator *localEnumeration = [self.seq getObjects];
    id localObject = nil;
    while (localObject = [localEnumeration nextObject]) {
        arrayOfKeyPurposeId[i++] = [KeyPurposeId getInstance:localObject];
    }
    return arrayOfKeyPurposeId;
}

- (int)size {
    return (int)[self.usageTable count];
}

- (ASN1Primitive *)toASN1Primitive {
    return self.seq;
}

- (void)setUsageTable:(NSMutableDictionary *)usageTable {
    if (_usageTable != usageTable) {
        _usageTable = [[[NSMutableDictionary alloc] init] autorelease];
    }
}

@end
