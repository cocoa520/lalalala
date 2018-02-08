//
//  NameOrPseudonym.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "NameOrPseudonym.h"
#import "ASN1Sequence.h"
#import "ASN1String.h"
#import "DERSequence.h"

@interface NameOrPseudonym ()

@property (nonatomic, readwrite, retain) DirectoryString *pseudonym;
@property (nonatomic, readwrite, retain) DirectoryString *surname;
@property (nonatomic, readwrite, retain) ASN1Sequence *givenName;

@end

@implementation NameOrPseudonym
@synthesize pseudonym = _pseudonym;
@synthesize surname = _surname;
@synthesize givenName = _givenName;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_pseudonym) {
        [_pseudonym release];
        _pseudonym = nil;
    }
    if (_surname) {
        [_surname release];
        _surname = nil;
    }
    if (_givenName) {
        [_givenName release];
        _givenName = nil;
    }
    [super dealloc];
#endif
}

+ (NameOrPseudonym *)getInstance:(id)paramObject {
    if (!paramObject ||[paramObject isKindOfClass:[NameOrPseudonym class]]) {
        return (NameOrPseudonym *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1String class]]) {
        return [[[NameOrPseudonym alloc] initParamDirectoryString:[DirectoryString getInstance:paramObject]] autorelease];
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[NameOrPseudonym alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] != 2) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        if (![[paramASN1Sequence getObjectAt:0] isKindOfClass:[ASN1String class]]) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad object encountered: %s", object_getClassName([paramASN1Sequence getObjectAt:0])] userInfo:nil];
        }
        self.surname = [DirectoryString getInstance:[paramASN1Sequence getObjectAt:0]];
        self.givenName = [ASN1Sequence getInstance:[paramASN1Sequence getObjectAt:1]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamDirectoryString:(DirectoryString *)paramDirectoryString
{
    if (self = [super init]) {
        self.pseudonym = paramDirectoryString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString
{
    if (self = [super init]) {
        DirectoryString *str = [[DirectoryString alloc] initParamString:paramString];
        [self initParamDirectoryString:str];
#if !__has_feature(objc_arc)
    if (str) [str release]; str = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamDirectoryString:(DirectoryString *)paramDirectoryString paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.surname = paramDirectoryString;
        self.givenName = paramASN1Sequence;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (DirectoryString *)getPseudonym {
    return self.pseudonym;
}

- (DirectoryString *)getSurname {
    return self.surname;
}

- (NSMutableArray *)getGivenName {
    NSMutableArray *arrayOfDirectoryString = [[[NSMutableArray alloc] initWithSize:(int)[self.givenName size]] autorelease];
    int i = 0;
    NSEnumerator *localEnumeration = [self.givenName getObjects];
    while ([localEnumeration nextObject]) {
        arrayOfDirectoryString[i++] = [DirectoryString getInstance:[localEnumeration nextObject]];
    }
    return arrayOfDirectoryString;
}

- (ASN1Primitive *)toASN1Primitive {
    if (self.pseudonym) {
        return [self.pseudonym toASN1Primitive];
    }
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.surname];
    [localASN1EncodableVector add:self.givenName];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
