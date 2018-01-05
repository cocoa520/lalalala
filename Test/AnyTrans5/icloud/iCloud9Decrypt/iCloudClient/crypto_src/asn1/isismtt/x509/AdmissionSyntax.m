//
//  AdmissionSyntax.m
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "AdmissionSyntax.h"
#import "Admissions.h"
#import "DERSequence.h"

@interface AdmissionSyntax ()

@property (nonatomic, readwrite, retain) GeneralName *admissionAuthority;
@property (nonatomic, readwrite, retain) ASN1Sequence *contentsOfAdmissions;

@end

@implementation AdmissionSyntax
@synthesize admissionAuthority = _admissionAuthority;
@synthesize contentsOfAdmissions = _contentsOfAdmissions;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_admissionAuthority) {
        [_admissionAuthority release];
        _admissionAuthority = nil;
    }
    if (_contentsOfAdmissions) {
        [_contentsOfAdmissions release];
        _contentsOfAdmissions = nil;
    }
    [super dealloc];
#endif
}

+ (AdmissionSyntax *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[AdmissionSyntax class]]) {
        return (AdmissionSyntax *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[AdmissionSyntax alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        switch ([paramASN1Sequence size]) {
            case 1:
                self.contentsOfAdmissions = [DERSequence getInstance:[paramASN1Sequence getObjectAt:0]];
                break;
            case 2:
                self.admissionAuthority = [GeneralName getInstance:[paramASN1Sequence getObjectAt:0]];
                self.contentsOfAdmissions = [DERSequence getInstance:[paramASN1Sequence getObjectAt:1]];
                break;
            default:
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
                break;
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.admissionAuthority = paramGeneralName;
        self.contentsOfAdmissions = paramASN1Sequence;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.admissionAuthority) {
        [localASN1EncodableVector add:self.admissionAuthority];
    }
    [localASN1EncodableVector add:self.contentsOfAdmissions];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (GeneralName *)getAdmissionAuthority {
    return self.admissionAuthority;
}

- (NSMutableArray *)getContentsOfAdmissions {
    NSMutableArray *arrayOfAdmissions = [[[NSMutableArray alloc] initWithSize:(int)[self.contentsOfAdmissions size]] autorelease];
    int i = 0;
    NSEnumerator *localEnumeration = [self.contentsOfAdmissions getObjects];
    id localObject = nil;
    while (localObject = [localEnumeration nextObject]) {
        arrayOfAdmissions[i++] = [Admissions getInstance:localObject];
    }
    return arrayOfAdmissions;
}

@end
