//
//  X962Parameters.m
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X962Parameters.h"
#import "ASN1Primitive.h"

@interface X962Parameters ()

@property (nonatomic, readwrite, retain) ASN1Primitive *params;

@end

@implementation X962Parameters
@synthesize params = _params;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_params) {
        [_params release];
        _params = nil;
    }
    [super dealloc];
#endif
}

+ (X962Parameters *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[X962Parameters class]]) {
        return (X962Parameters *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Primitive class]]) {
        return [[[X962Parameters alloc] initParamASN1Primitive:(ASN1Primitive *)paramObject] autorelease];
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return [[[X962Parameters alloc] initParamASN1Primitive:[ASN1Primitive fromByteArray:(NSMutableData *)paramObject]] autorelease];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"unable to parse encoded data: %@", exception.description] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"unknown object in getInstance()" userInfo:nil];
}

+ (X962Parameters *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [X962Parameters getInstance:[paramASN1TaggedObject getObject]];
}

- (instancetype)initParamX9ECParameters:(X962Parameters *)paramX9ECParameters
{
    if (self = [super init]) {
        self.params = paramX9ECParameters.toASN1Primitive;
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
        self.params = paramASN1ObjectIdentifier;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Null:(ASN1Null *)paramASN1Null
{
    if (self = [super init]) {
        self.params = paramASN1Null;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

/**
 * @deprecated
 */
- (instancetype)initParamASN1Primitive:(ASN1Primitive *)paramASN1Primitive
{
    if (self = [super init]) {
        self.params = paramASN1Primitive;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (BOOL)isNameCurve {
    return [self.params isKindOfClass:[ASN1ObjectIdentifier class]];
}

- (BOOL)isImplicitlyCA {
    return [self.params isKindOfClass:[ASN1Null class]];
}

- (ASN1Primitive *)getParameters {
    return self.params;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.params;
}

@end
