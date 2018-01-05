//
//  Admissions.m
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Admissions.h"
#import "ProfessionInfo.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface Admissions ()

@property (nonatomic, readwrite, retain) GeneralName *admissionAuthority;
@property (nonatomic, readwrite, retain) NamingAuthority *namingAuthority;
@property (nonatomic, readwrite, retain) ASN1Sequence *professionInfos;

@end

@implementation Admissions
@synthesize admissionAuthority = _admissionAuthority;
@synthesize namingAuthority = _namingAuthority;
@synthesize professionInfos = _professionInfos;

+ (Admissions *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[Admissions class]]) {
        return (Admissions *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[Admissions alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] > 3) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        ASN1Encodable *localASN1Encodable = (ASN1Encodable *)[localEnumeration nextObject];
        if ([localASN1Encodable isKindOfClass:[ASN1TaggedObject class]]) {
            switch ([((ASN1TaggedObject *)localASN1Encodable) getTagNo]) {
                case 0:
                    self.admissionAuthority = [GeneralName getInstance:(ASN1TaggedObject *)localASN1Encodable paramBoolean:YES];
                    break;
                case 1:
                    self.namingAuthority = [NamingAuthority getInstance:(ASN1TaggedObject *)localASN1Encodable paramBoolean:YES];
                    break;
                default:
                    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad tag number: %d", [((ASN1TaggedObject *)localASN1Encodable) getTagNo]] userInfo:nil];
                    break;
            }
            localASN1Encodable = (ASN1Encodable *)[localEnumeration nextObject];
        }
        if ([localASN1Encodable isKindOfClass:[ASN1TaggedObject class]]) {
            switch ([((ASN1TaggedObject *)localASN1Encodable) getTagNo]) {
                case 1:
                    self.namingAuthority = [NamingAuthority getInstance:(ASN1TaggedObject *)localASN1Encodable paramBoolean:YES];
                    break;
                default:
                    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad tag number: %d", [((ASN1TaggedObject *)localASN1Encodable) getTagNo]] userInfo:nil];
                    break;
            }
            localASN1Encodable = (ASN1Encodable *)[localEnumeration nextObject];
        }
        self.professionInfos = [ASN1Sequence getInstance:localASN1Encodable];
        if ([localEnumeration nextObject]) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad object encountered: %s", object_getClassName(paramASN1Sequence)] userInfo:nil];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName paramNamingAuthority:(NamingAuthority *)paramNamingAuthority paramArrayOfProfessionInfo:(NSMutableArray *)paramArrayOfProfessionInfo
{
    if (self = [super init]) {
        self.admissionAuthority = paramGeneralName;
        self.namingAuthority = paramNamingAuthority;
        ASN1Sequence *sequence = [[DERSequence alloc] initDERparamArrayOfASN1Encodable:paramArrayOfProfessionInfo];
        self.professionInfos = sequence;
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

- (void)dealloc
{
    [self setAdmissionAuthority:nil];
    [self setNamingAuthority:nil];
    [self setProfessionInfos:nil];
    [super dealloc];
}

- (GeneralName *)getAdmissionAuthority {
    return self.admissionAuthority;
}

- (NamingAuthority *)getNamingAuthority {
    return self.namingAuthority;
}

- (NSMutableArray *)getProfessionInfos {
    NSMutableArray *arrayOfProfessionInfo = [[[NSMutableArray alloc] initWithSize:(int)[self.professionInfos size]] autorelease];
    int i = 0;
    NSEnumerator *localEnumeration = [self.professionInfos getObjects];
    id localObject = nil;
    while (localObject = [localEnumeration nextObject]) {
        arrayOfProfessionInfo[i++] = [ProfessionInfo getInstance:localObject];
    }
    return arrayOfProfessionInfo;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.admissionAuthority) {
        ASN1Encodable *admissionEncodable = [[DERTaggedObject alloc] initParamBoolean:TRUE paramInt:0 paramASN1Encodable:self.admissionAuthority];
        [localASN1EncodableVector add:admissionEncodable];
#if !__has_feature(objc_arc)
    if (admissionEncodable) [admissionEncodable release]; admissionEncodable = nil;
#endif
    }
    if (self.namingAuthority) {
        ASN1Encodable *namingEncodable = [[DERTaggedObject alloc] initParamBoolean:TRUE paramInt:1 paramASN1Encodable:self.namingAuthority];
        [localASN1EncodableVector add:namingEncodable];
#if !__has_feature(objc_arc)
    if (namingEncodable) [namingEncodable release]; namingEncodable = nil;
#endif
    }
    [localASN1EncodableVector add:self.professionInfos];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
