//
//  CertStatus.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertStatus.h"
#import "DERNull.h"
#import "DERTaggedObject.h"

@interface CertStatus ()

@property (nonatomic, assign) int tagNo;
@property (nonatomic, readwrite, retain) ASN1Encodable *value;

@end

@implementation CertStatus
@synthesize tagNo = _tagNo;
@synthesize value = _value;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_value) {
        [_value release];
        _value = nil;
    }
    [super dealloc];
#endif
}

+ (CertStatus *)getInstance:(id)paramObject {
    if (paramObject || [paramObject isKindOfClass:[CertStatus class]]) {
        return (CertStatus *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        return [[[CertStatus alloc] initParamASN1TaggedObject:(ASN1TaggedObject *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"unknown object in factory: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (CertStatus *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [CertStatus getInstance:[paramASN1TaggedObject getObject]];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.tagNo = 0;
        self.value = [DERNull INSTANCE];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamRevokedInfo:(RevokedInfo *)paramRevokedInfo
{
    if (self = [super init]) {
        self.tagNo = 1;
        self.value = paramRevokedInfo;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        self.tagNo = paramInt;
        self.value = paramASN1Encodable;
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
        self.tagNo = [paramASN1TaggedObject getTagNo];
        switch ([paramASN1TaggedObject getTagNo]) {
            case 0:
                self.value = [DERNull INSTANCE];
                break;
            case 1:
                self.value = [RevokedInfo getInstance:paramASN1TaggedObject paramBoolean:false];
                break;
            case 2:
                self.value = [DERNull INSTANCE];
                break;
            default:
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

- (int)getTagNo {
    return self.tagNo;
}

- (ASN1Encodable *)getStatus {
    return self.value;
}

- (ASN1Primitive *)toASN1Primitive {
    return [[[DERTaggedObject alloc] initParamBoolean:false paramInt:self.tagNo paramASN1Encodable:self.value] autorelease];
}

@end
