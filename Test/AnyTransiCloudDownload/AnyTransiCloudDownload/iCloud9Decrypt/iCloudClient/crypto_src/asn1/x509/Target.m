//
//  Target.m
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Target.h"
#import "ASN1TaggedObject.h"
#import "DERTaggedObject.h"

@interface Target ()

@property (nonatomic, readwrite, retain) GeneralName *targName;
@property (nonatomic, readwrite, retain) GeneralName *targGroup;

@end

@implementation Target
@synthesize targName = _targName;
@synthesize targGroup = _targGroup;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_targName) {
        [_targName release];
        _targName = nil;
    }
    if (_targGroup) {
        [_targGroup release];
        _targGroup = nil;
    }
    [super dealloc];
#endif
}

+ (int)targetName {
    static int _targetName = 0;
    @synchronized(self) {
        if (!_targetName) {
            _targetName = 0;
        }
    }
    return _targetName;
}

+ (int)targetGroup {
    static int _targetGroup = 0;
    @synchronized(self) {
        if (!_targetGroup) {
            _targetGroup = 1;
        }
    }
    return _targetGroup;
}

+ (Target *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[Target class]]) {
        return (Target *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        return [[[Target alloc] initParamASN1TaggedObject:(ASN1TaggedObject *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown object in factory: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamASN1TaggedObject:(ASN1TaggedObject *)paramASN1TaggedObject
{
    if (self = [super init]) {
        switch ([paramASN1TaggedObject getTagNo]) {
            case 0:
                self.targName = [GeneralName getInstance:paramASN1TaggedObject paramBoolean:YES];
                break;
            case 1:
                self.targGroup = [GeneralName getInstance:paramASN1TaggedObject paramBoolean:YES];
                break;
            default:
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown tag: %d", [paramASN1TaggedObject getTagNo]] userInfo:nil];
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

- (instancetype)initParamInt:(int)paramInt paramGeneralName:(GeneralName *)paramGeneralName
{
    if (self = [super init]) {
        ASN1TaggedObject *tagged = [[DERTaggedObject alloc] initParamInt:paramInt paramASN1Encodable:paramGeneralName];
        [self initParamASN1TaggedObject:tagged];
#if !__has_feature(objc_arc)
    if (tagged) [tagged release]; tagged = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (GeneralName *)getTargetGroup {
    return self.targGroup;
}

- (GeneralName *)getTargetName {
    return self.targName;
}

- (ASN1Primitive *)toASN1Primitive {
    if (self.targName) {
        return [[[DERTaggedObject alloc] initParamBoolean:TRUE paramInt:0 paramASN1Encodable:self.targName] autorelease];
    }
    return [[[DERTaggedObject alloc] initParamBoolean:TRUE paramInt:1 paramASN1Encodable:self.targGroup] autorelease];
}

@end
