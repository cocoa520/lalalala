//
//  AttCertIssuer.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "AttCertIssuer.h"
#import "DERTaggedObject.h"

@implementation AttCertIssuer
@synthesize obj = _obj;
@synthesize choiceObj = _choiceObj;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_obj) {
        [_obj release];
        _obj = nil;
    }
    if (_choiceObj) {
        [_choiceObj release];
        _choiceObj = nil;
    }
    [super dealloc];
#endif
}

+ (AttCertIssuer *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[AttCertIssuer class]]) {
        return (AttCertIssuer *)paramObject;
    }
    if ([paramObject isKindOfClass:[V2Form class]]) {
        return [[[AttCertIssuer alloc] initParamV2Form:[V2Form getInstance:paramObject]] autorelease];
    }
    if ([paramObject isKindOfClass:[GeneralNames class]]) {
        return [[[AttCertIssuer alloc] initParamGeneralNames:(GeneralNames *)paramObject] autorelease];
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        return [[[AttCertIssuer alloc] initParamV2Form:[V2Form getInstance:(ASN1TaggedObject *)paramObject paramBoolean:false]] autorelease];
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[AttCertIssuer alloc] initParamGeneralNames:[GeneralNames getInstance:paramObject]] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown object in factory: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (AttCertIssuer *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [AttCertIssuer getInstance:[paramASN1TaggedObject getObject]];
}

- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames
{
    if (self = [super init]) {
        self.obj = paramGeneralNames;
        self.choiceObj = [self.obj toASN1Primitive];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamV2Form:(V2Form *)paramV2Form
{
    if (self = [super init]) {
        self.obj = paramV2Form;
        ASN1Primitive *choicePrimitive = [[DERTaggedObject alloc] initParamBoolean:false paramInt:0 paramASN1Encodable:self.obj];
        self.choiceObj = choicePrimitive;
#if !__has_feature(objc_arc)
        if (choicePrimitive) [choicePrimitive release]; choicePrimitive = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Encodable *)getIssuer {
    return self.obj;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.choiceObj;
}

@end
