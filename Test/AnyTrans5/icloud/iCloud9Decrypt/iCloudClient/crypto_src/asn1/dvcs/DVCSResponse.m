//
//  DVCSResponse.m
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DVCSResponse.h"
#import "DERTaggedObject.h"

@interface DVCSResponse ()

@property (nonatomic, readwrite, retain) DVCSCertInfo *dvCertInfo;
@property (nonatomic, readwrite, retain) DVCSErrorNotice *dvErrorNote;

@end

@implementation DVCSResponse
@synthesize dvCertInfo = _dvCertInfo;
@synthesize dvErrorNote = _dvErrorNote;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_dvCertInfo) {
        [_dvCertInfo release];
        _dvCertInfo = nil;
    }
    if (_dvErrorNote) {
        [_dvErrorNote release];
        _dvErrorNote = nil;
    }
    [super dealloc];
#endif
}

+ (DVCSResponse *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DVCSResponse class]]) {
        return (DVCSResponse *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return [DVCSResponse getInstance:[ASN1Primitive fromByteArray:(NSMutableData *)paramObject]];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"failed to construct sequence from byte[]: %@", exception.description] userInfo:nil];
        }
    }
    id localObject;
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        localObject = [DVCSCertInfo getInstance:paramObject];
        return [[[DVCSResponse alloc] initParamDVCSCertInfo:(DVCSCertInfo *)paramObject] autorelease];
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        localObject = [ASN1TaggedObject getInstance:paramObject];
        DVCSErrorNotice *localDVCSErrorNotice = [DVCSErrorNotice getInstance:(ASN1TaggedObject *)localObject paramBoolean:false];
        return [[[DVCSResponse alloc] initParamDVCSErrorNotice:localDVCSErrorNotice] autorelease];
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Couldn't convert from object to DVCSResponse: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (DVCSResponse *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [DVCSResponse getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamDVCSCertInfo:(DVCSCertInfo *)paramDVCSCertInfo
{
    if (self = [super init]) {
        self.dvCertInfo = paramDVCSCertInfo;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamDVCSErrorNotice:(DVCSErrorNotice *)paramDVCSErrorNotice
{
    if (self = [super init]) {
        self.dvErrorNote = paramDVCSErrorNotice;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (DVCSCertInfo *)getCertInfo {
    return self.dvCertInfo;
}

- (DVCSErrorNotice *)getErrorNotice {
    return self.dvErrorNote;
}

- (ASN1Primitive *)toASN1Primitive {
    if (self.dvCertInfo) {
        return [self.dvCertInfo toASN1Primitive];
    }
    return [[[DERTaggedObject alloc] initParamBoolean:false paramInt:0 paramASN1Encodable:self.dvErrorNote] autorelease];
}

- (NSString *)toString {
    if (self.dvCertInfo) {
        return [NSString stringWithFormat:@"DVCSResponse {\ndvCertInfo: %@}\n", [self.dvCertInfo toString]];
    }
    return [NSString stringWithFormat:@"DVCSResponse {\ndvErrorNote: %@}\n", [self.dvErrorNote toString]];
}

@end
