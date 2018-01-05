//
//  RoleSyntax.m
//  crypto
//
//  Created by JGehry on 7/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RoleSyntax.h"
#import "ASN1String.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface RoleSyntax ()

@property (nonatomic, readwrite, retain) GeneralNames *roleAuthority;
@property (nonatomic, readwrite, retain) GeneralName *roleName;

@end

@implementation RoleSyntax
@synthesize roleAuthority = _roleAuthority;
@synthesize roleName = _roleName;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_roleAuthority) {
        [_roleAuthority release];
        _roleAuthority = nil;
    }
    if (_roleName) {
        [_roleName release];
        _roleName = nil;
    }
    [super dealloc];
#endif
}

+ (RoleSyntax *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[RoleSyntax class]]) {
        return (RoleSyntax *)paramObject;
    }
    if (paramObject) {
        return [[[RoleSyntax alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (([paramASN1Sequence size] < 1) || ([paramASN1Sequence size] > 2)) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        for (int i = 0; i != [paramASN1Sequence size]; i++) {
            ASN1TaggedObject *localASN1TaggedObject = [ASN1TaggedObject getInstance:[paramASN1Sequence getObjectAt:i]];
            switch ([localASN1TaggedObject getTagNo]) {
                case 0:
                    self.roleAuthority = [GeneralNames getInstance:localASN1TaggedObject paramBoolean:NO];
                    break;
                case 1:
                    self.roleName = [GeneralName getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                default:
                    @throw [NSException exceptionWithName:NSGenericException reason:@"Unknown tag in RoleSyntax" userInfo:nil];
                    break;
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

- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames paramGeneralName:(GeneralName *)paramGeneralName
{
    if (self = [super init]) {
        if (paramGeneralName || ([paramGeneralName getTagNo] != 6) || ([[((ASN1String *)[paramGeneralName getName]) getString] isEqualToString:@""])) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"the role name MUST be non empty and MUST use the URI option of GeneralName" userInfo:nil];
        }
        self.roleAuthority = paramGeneralNames;
        self.roleName = paramGeneralName;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName
{
    if (self = [super init]) {
        [self initParamGeneralNames:nil paramGeneralName:paramGeneralName];
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
        GeneralName *name = [[GeneralName alloc] initParamInt:6 paramString:(paramString == nil ? @"" : paramString)];
        [self initParamGeneralName:name];
#if !__has_feature(objc_arc)
    if (name) [name release]; name = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (GeneralNames *)getRoleAuthority {
    return self.roleAuthority;
}

- (GeneralName *)getRoleName {
    return self.roleName;
}

- (NSString *)getRoleNameAsString {
    ASN1String *localASN1String = (ASN1String *)[self.roleName getName];
    return [localASN1String getString];
}

- (NSMutableArray *)getRoleAuthorityAsString {
    if (!self.roleAuthority) {
        return [[[NSMutableArray alloc] initWithSize:0] autorelease];
    }
    NSMutableArray *arrayOfGeneralName = [self.roleAuthority getNames];
    NSMutableArray *arrayOfString = [[[NSMutableArray alloc] initWithSize:(int)[arrayOfGeneralName count]] autorelease];
    for (int i = 0; i < [arrayOfGeneralName count]; i++) {
        ASN1Encodable *localASN1Encodable = [((GeneralName *)arrayOfGeneralName[i]) getName];
        if ([localASN1Encodable isKindOfClass:[ASN1String class]]) {
            arrayOfString[i] = [((ASN1String *)localASN1Encodable) getString];
        }else {
            arrayOfString[i] = [NSString stringWithFormat:@"%@", localASN1Encodable];
        }
    }
    return arrayOfString;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.roleAuthority) {
        ASN1Encodable *roleEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:0 paramASN1Encodable:self.roleAuthority];
        [localASN1EncodableVector add:roleEncodable];
#if !__has_feature(objc_arc)
        if (roleEncodable) [roleEncodable release]; roleEncodable = nil;
#endif
    }
    ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:self.roleName];
    [localASN1EncodableVector add:encodable];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (encodable) [encodable release]; encodable = nil;
#endif
    return primitive;
}

- (NSString *)toString {
    NSMutableString *localStringBuffer = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"Name: %@ - Auth: ", [self getRoleNameAsString]]];
    if (!self.roleAuthority || ([[self.roleAuthority getNames] count] == 0)) {
        [localStringBuffer appendString:@"N/A"];
    }else {
        NSMutableArray *arrayOfString = [self getRoleAuthorityAsString];
        [localStringBuffer appendString:@"["];
        [localStringBuffer appendString:[NSString stringWithFormat:@"%@", arrayOfString[0]]];
        for (int i = 1; i < [arrayOfString count]; i++) {
            [localStringBuffer appendString:@", "];
            [localStringBuffer appendString:[NSString stringWithFormat:@"%@", arrayOfString[i]]];
        }
        [localStringBuffer appendString:@"]"];
    }
    NSString *tmpLocalStringBuffer = localStringBuffer.description;
#if !__has_feature(objc_arc)
    if (localStringBuffer) [localStringBuffer release]; localStringBuffer = nil;
#endif
    return [NSString stringWithFormat:@"%@", tmpLocalStringBuffer];
}

@end
