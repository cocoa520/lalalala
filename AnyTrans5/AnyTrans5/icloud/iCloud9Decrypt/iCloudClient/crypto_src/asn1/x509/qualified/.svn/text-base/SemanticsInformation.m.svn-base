//
//  SemanticsInformation.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SemanticsInformation.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "GeneralName.h"

@interface SemanticsInformation ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *semanticsIdentifier;
@property (nonatomic, readwrite, retain) NSMutableArray *nameRegistrationAuthorities;

@end

@implementation SemanticsInformation
@synthesize semanticsIdentifier = _semanticsIdentifier;
@synthesize nameRegistrationAuthorities = _nameRegistrationAuthorities;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_semanticsIdentifier) {
        [_semanticsIdentifier release];
        _semanticsIdentifier = nil;
    }
    if (_nameRegistrationAuthorities) {
        [_nameRegistrationAuthorities release];
        _nameRegistrationAuthorities = nil;
    }
    [super dealloc];
#endif
}

+ (SemanticsInformation *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[SemanticsInformation class]]) {
        return (SemanticsInformation *)paramObject;
    }
    if (paramObject) {
        return [[[SemanticsInformation alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        if ([paramASN1Sequence size] < 1) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"no objects in SemanticsInformation" userInfo:nil];
        }
        id localObject =[localEnumeration nextObject];
        if ([localObject isKindOfClass:[ASN1ObjectIdentifier class]]) {
            self.semanticsIdentifier = [ASN1ObjectIdentifier getInstance:localObject];
            if (localObject = [localEnumeration nextObject]) {
            }else {
                localObject = nil;
            }
        }
        if (localObject) {
            ASN1Sequence *localASN1Sequence = [ASN1Sequence getInstance:localObject];
            self.nameRegistrationAuthorities = [[[NSMutableArray alloc] initWithSize:(int)[localASN1Sequence size]] autorelease];
            for (int i = 0; i < [localASN1Sequence size]; i++) {
                self.nameRegistrationAuthorities[i] = [GeneralName getInstance:[localASN1Sequence getObjectAt:i]];
            }
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier
{
    if (self = [super init]) {
        self.semanticsIdentifier = paramASN1ObjectIdentifier;
        self.nameRegistrationAuthorities = nil;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramArrayOfGeneralName:(NSMutableArray *)paramArrayOfGeneralName
{
    if (self = [super init]) {
        self.semanticsIdentifier = paramASN1ObjectIdentifier;
        self.nameRegistrationAuthorities = paramArrayOfGeneralName;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfGeneralName:(NSMutableArray *)paramArrayOfGeneralName
{
    if (self = [super init]) {
        self.semanticsIdentifier = nil;
        self.nameRegistrationAuthorities = paramArrayOfGeneralName;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getSemanticsIdentifier {
    return self.semanticsIdentifier;
}

- (NSMutableArray *)getNameRegistrationAuthorities {
    return self.nameRegistrationAuthorities;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector1 = [[ASN1EncodableVector alloc] init];
    if (self.semanticsIdentifier) {
        [localASN1EncodableVector1 add:self.semanticsIdentifier];
    }
    if (self.nameRegistrationAuthorities) {
        ASN1EncodableVector *localASN1EncodableVector2 = [[ASN1EncodableVector alloc] init];
        for (int i = 0; i < self.nameRegistrationAuthorities.count; i++) {
            [localASN1EncodableVector2 add:self.nameRegistrationAuthorities[i]];
        }
        ASN1Encodable *encodable = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector2];
        [localASN1EncodableVector1 add:encodable];
#if !__has_feature(objc_arc)
        if (localASN1EncodableVector2) [localASN1EncodableVector2 release]; localASN1EncodableVector2 = nil;
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector1] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector1) [localASN1EncodableVector1 release]; localASN1EncodableVector1 = nil;
#endif
    return primitive;
}

@end
