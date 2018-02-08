//
//  AuthorityInformationAccess.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "AuthorityInformationAccess.h"
#import "Extension.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "CategoryExtend.h"

@interface AuthorityInformationAccess ()

@property (nonatomic, readwrite, retain) NSMutableArray *descriptions;

@end

@implementation AuthorityInformationAccess
@synthesize descriptions = _descriptions;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_descriptions) {
        [_descriptions release];
        _descriptions = nil;
    }
    [super dealloc];
#endif
}

+ (AuthorityInformationAccess *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[AuthorityInformationAccess class]]) {
        return (AuthorityInformationAccess *)paramObject;
    }
    if (paramObject) {
        return [[[AuthorityInformationAccess alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (AuthorityInformationAccess *)fromExtensions:(Extensions *)paramExtensions {
    return [AuthorityInformationAccess getInstance:[paramExtensions getExtensionParsedValue:[Extension authorityInfoAccess]]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] < 1) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"sequence may not be empty" userInfo:nil];
        }
        NSMutableArray *descriptionsAry = [[NSMutableArray alloc] initWithSize:(int)[paramASN1Sequence size]];
        self.descriptions = descriptionsAry;
#if !__has_feature(objc_arc)
    if (descriptionsAry) [descriptionsAry release]; descriptionsAry = nil;
#endif
        for (int i = 0; i != [paramASN1Sequence size]; i++) {
            self.descriptions[i] = [AccessDescription getInstance:[paramASN1Sequence getObjectAt:i]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAccessDescription:(AccessDescription *)paramAccessDescription
{
    if (self = [super init]) {
        NSMutableArray *ary = [[NSMutableArray alloc] initWithObjects:paramAccessDescription, nil];
        [self initParamArrayOfAccessDescription:ary];
#if !__has_feature(objc_arc)
    if (ary) [ary release]; ary = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfAccessDescription:(NSMutableArray *)paramArrayOfAccessDescription
{
    if (self = [super init]) {
        NSMutableArray *descriptionsAry = [[NSMutableArray alloc] initWithSize:(int)[paramArrayOfAccessDescription count]];
        self.descriptions = descriptionsAry;
#if !__has_feature(objc_arc)
    if (descriptionsAry) [descriptionsAry release]; descriptionsAry = nil;
#endif
        [self.descriptions copyFromIndex:0 withSource:paramArrayOfAccessDescription withSourceIndex:0 withLength:(int)[paramArrayOfAccessDescription count]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramGeneralName:(GeneralName *)paramGeneralName
{
    if (self = [super init]) {
        AccessDescription *access = [[AccessDescription alloc] initParamASN1ObjectIdentifier:paramASN1ObjectIdentifier paramGeneralName:paramGeneralName];
        [self initParamAccessDescription:access];
#if !__has_feature(objc_arc)
    if (access) [access release]; access = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableArray *)getAccessDescriptions {
    return self.descriptions;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    for (int i = 0; i != [self.descriptions count]; i++) {
        [localASN1EncodableVector add:self.descriptions[i]];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"AuthorityInformationAccess: Oid(%@)", [[self.descriptions[0] getAccessMethod] getId]];
}

@end
