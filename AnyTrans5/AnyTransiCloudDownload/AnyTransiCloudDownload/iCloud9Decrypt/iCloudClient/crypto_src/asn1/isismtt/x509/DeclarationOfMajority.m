//
//  DeclarationOfMajority.m
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DeclarationOfMajority.h"
#import "ASN1TaggedObject.h"
#import "ASN1Boolean.h"
#import "ASN1Integer.h"
#import "DERTaggedObject.h"
#import "DERPrintableString.h"
#import "DERSequence.h"

@interface DeclarationOfMajority ()

@property (nonatomic, readwrite, retain) ASN1TaggedObject *declaration;

@end

@implementation DeclarationOfMajority
@synthesize declaration = _declaration;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_declaration) {
        [_declaration release];
        _declaration = nil;
    }
    [super dealloc];
#endif
}

+ (int)notYoungerThan {
    static int _notYoungerThan = 0;
    @synchronized(self) {
        if (!_notYoungerThan) {
            _notYoungerThan = 0;
        }
    }
    return _notYoungerThan;
}

+ (int)fullAgeAtCountry {
    static int _fullAgeAtCountry = 0;
    @synchronized(self) {
        if (!_fullAgeAtCountry) {
            _fullAgeAtCountry = 1;
        }
    }
    return _fullAgeAtCountry;
}

+ (int)dateOfBirth {
    static int _dateOfBirth = 0;
    @synchronized(self) {
        if (!_dateOfBirth) {
            _dateOfBirth = 2;
        }
    }
    return _dateOfBirth;
}

+ (DeclarationOfMajority *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DeclarationOfMajority class]]) {
        return (DeclarationOfMajority *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        return [[[DeclarationOfMajority alloc] initParamASN1TaggedObject:(ASN1TaggedObject *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamInt:(int)paramInt
{
    if (self = [super init]) {
        ASN1Integer *integer = [[ASN1Integer alloc] initLong:paramInt];
        ASN1TaggedObject *tagged = [[DERTaggedObject alloc] initParamBoolean:false paramInt:0 paramASN1Encodable:integer];
        self.declaration = tagged;
#if !__has_feature(objc_arc)
    if (tagged) [tagged release]; tagged = nil;
    if (integer) [integer release]; integer = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBoolean:(BOOL)paramBoolean paramString:(NSString *)paramString
{
    if (self = [super init]) {
        if ([paramString length] > 2) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"country can only be 2 characters" userInfo:nil];
        }
        if (paramBoolean) {
            ASN1Encodable *encodable = [[DERPrintableString alloc] initParamString:paramString paramBoolean:YES];
            ASN1Encodable *sequenceEncodable = [[DERSequence alloc] initDERParamASN1Encodable:encodable];
            ASN1TaggedObject *tagged = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:1 paramASN1Encodable:sequenceEncodable];
            self.declaration = tagged;
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
    if (sequenceEncodable) [sequenceEncodable release]; sequenceEncodable = nil;
    if (tagged) [tagged release]; tagged = nil;
#endif
        }else {
            ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
            [localASN1EncodableVector add:[ASN1Boolean FALSEALLOC]];
            ASN1Encodable *encodable = [[DERPrintableString alloc] initParamString:paramString paramBoolean:YES];
            [localASN1EncodableVector add:encodable];
            ASN1Encodable *sequenceEncodable = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
            ASN1TaggedObject *tagged = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:1 paramASN1Encodable:sequenceEncodable];
            self.declaration = tagged;
#if !__has_feature(objc_arc)
            if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
            if (encodable) [encodable release]; encodable = nil;
            if (sequenceEncodable) [sequenceEncodable release]; sequenceEncodable = nil;
            if (tagged) [tagged release]; tagged = nil;
#endif
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime
{
    if (self = [super init]) {
        self.declaration = [[[DERTaggedObject alloc] initParamBoolean:false paramInt:2 paramASN1Encodable:paramASN1GeneralizedTime] autorelease];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1TaggedObject:(ASN1TaggedObject *)paramASN1TaggedObject
{
    if (self = [super init]) {
        if ([paramASN1TaggedObject getTagNo] > 2) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad tag number: %d", [paramASN1TaggedObject getTagNo]] userInfo:nil];
        }
        self.declaration = paramASN1TaggedObject;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Primitive *)toASN1Primitive {
    return self.declaration;
}

- (int)getType {
    return [self.declaration getTagNo];
}

- (int)notYoungerThan {
    if ([self.declaration getTagNo] != 0) {
        return -1;
    }
    return [[[ASN1Integer getInstance:self.declaration paramBoolean:false] getValue] intValue];
}

- (ASN1Sequence *)fullAgeAtCountry {
    if ([self.declaration getTagNo] != 1) {
        return nil;
    }
    return [ASN1Sequence getInstance:self.declaration paramBoolean:false];
}

- (ASN1GeneralizedTime *)getDateOfBirth {
    if ([self.declaration getTagNo] != 2) {
        return nil;
    }
    return [ASN1GeneralizedTime getInstance:self.declaration paramBoolean:false];
}

@end
