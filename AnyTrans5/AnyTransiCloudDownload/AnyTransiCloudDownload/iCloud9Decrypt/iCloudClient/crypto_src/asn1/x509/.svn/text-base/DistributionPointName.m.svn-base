//
//  DistributionPointName.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DistributionPointName.h"
#import "DERTaggedObject.h"

@implementation DistributionPointName
@synthesize name = _name;
@synthesize type = _type;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_name) {
        [_name release];
        _name = nil;
    }
    [super dealloc];
#endif
}

+ (int)FULL_NAME {
    static int _FULL_NAME = 0;
    @synchronized(self) {
        if (!_FULL_NAME) {
            _FULL_NAME = 0;
        }
    }
    return _FULL_NAME;
}

+ (int)NAME_RELATIVE_TO_CRL_ISSUER {
    static int _NAME_RELATIVE_TO_CRL_ISSUER = 0;
    @synchronized(self) {
        if (!_NAME_RELATIVE_TO_CRL_ISSUER) {
            _NAME_RELATIVE_TO_CRL_ISSUER = 1;
        }
    }
    return _NAME_RELATIVE_TO_CRL_ISSUER;
}

+ (DistributionPointName *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DistributionPointName class]]) {
        return (DistributionPointName *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        return [[[DistributionPointName alloc] initParamASN1TaggedObject:(ASN1TaggedObject *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown object in factory: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (DistributionPointName *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [DistributionPointName getInstance:[ASN1TaggedObject getInstance:paramASN1TaggedObject paramBoolean:YES]];
}

- (instancetype)initParamInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        self.type = paramInt;
        self.name = paramASN1Encodable;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames
{
    if (self = [super init]) {
        [self initParamInt:0 paramASN1Encodable:paramGeneralNames];
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
        self.type = [paramASN1TaggedObject getTagNo];
        if (self.type == 0) {
            self.name = [GeneralNames getInstance:paramASN1TaggedObject paramBoolean:NO];
        }else {
            self.name = [ASN1Set getInstance:paramASN1TaggedObject paramBoolean:NO];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (int)getType {
    return self.type;
}

- (ASN1Encodable *)getName {
    return self.name;
}

- (ASN1Primitive *)toASN1Primitive {
    return [[[DERTaggedObject alloc] initParamBoolean:NO paramInt:self.type paramASN1Encodable:self.name] autorelease];
}

- (NSString *)toString {
    NSString *str = @"";
    NSMutableString *localStringBuffer = [[NSMutableString alloc] init];
    [localStringBuffer appendString:@"DistributionPointName: ["];
    [localStringBuffer appendString:str];
    if (self.type == 0) {
        [self appendObject:localStringBuffer paramString1:str paramString2:@"fullName" paramString3:[NSString stringWithFormat:@"%@", self.name]];
    }else {
        [self appendObject:localStringBuffer paramString1:str paramString2:@"nameRelativeToCRLIssuer" paramString3:[NSString stringWithFormat:@"%@", self.name]];
    }
    [localStringBuffer appendString:@"]"];
    [localStringBuffer appendString:str];
    NSString *tmpLocalStringBuffer = localStringBuffer.description;
    return [NSString stringWithFormat:@"%@", tmpLocalStringBuffer];
}

- (void)appendObject:(NSMutableString *)paramStringBuffer paramString1:(NSString *)paramString1 paramString2:(NSString *)paramString2 paramString3:(NSString *)paramString3 {
    NSString *str = @"    ";
    [paramStringBuffer appendString:str];
    [paramStringBuffer appendString:paramString2];
    [paramStringBuffer appendString:@":"];
    [paramStringBuffer appendString:paramString1];
    [paramStringBuffer appendString:str];
    [paramStringBuffer appendString:str];
    [paramStringBuffer appendString:paramString3];
    [paramStringBuffer appendString:paramString1];
}

@end
