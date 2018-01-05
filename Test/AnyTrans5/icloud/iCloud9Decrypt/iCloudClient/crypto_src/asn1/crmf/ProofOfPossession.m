//
//  ProofOfPossession.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ProofOfPossession.h"
#import "ASN1TaggedObject.h"
#import "DERTaggedObject.h"
#import "DERNull.h"

@interface ProofOfPossession ()

@property (nonatomic, assign) int tagNo;
@property (nonatomic, retain) ASN1Encodable *obj;

@end

@implementation ProofOfPossession
@synthesize tagNo = _tagNo;
@synthesize obj = _obj;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_obj) {
        [_obj release];
        _obj = nil;
    }
    [super dealloc];
#endif
}

+ (int)TYPE_RA_VERIFIED {
    static int _TYPE_RA_VERIFIED = 0;
    @synchronized(self) {
        if (!_TYPE_RA_VERIFIED) {
            _TYPE_RA_VERIFIED = 0;
        }
    }
    return _TYPE_RA_VERIFIED;
}

+ (int)TYPE_SIGNING_KEY {
    static int _TYPE_SIGNING_KEY = 0;
    @synchronized(self) {
        if (!_TYPE_SIGNING_KEY) {
            _TYPE_SIGNING_KEY = 1;
        }
    }
    return _TYPE_SIGNING_KEY;
}

+ (int)TYPE_KEY_ENCIPHERMENT {
    static int _TYPE_KEY_ENCIPHERMENT = 0;
    @synchronized(self) {
        if (!_TYPE_KEY_ENCIPHERMENT) {
            _TYPE_KEY_ENCIPHERMENT = 2;
        }
    }
    return _TYPE_KEY_ENCIPHERMENT;
}

+ (int)TYPE_KEY_AGREEMENT {
    static int _TYPE_KEY_AGREEMENT = 0;
    @synchronized(self) {
        if (!_TYPE_KEY_AGREEMENT) {
            _TYPE_KEY_AGREEMENT = 3;
        }
    }
    return _TYPE_KEY_AGREEMENT;
}

+ (ProofOfPossession *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[ProofOfPossession class]]) {
        return (ProofOfPossession *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        return [[[ProofOfPossession alloc] initParamASN1TaggedObject:(ASN1TaggedObject *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Invalid object: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamASN1TaggedObject:(ASN1TaggedObject *)paramASN1TaggedObject
{
    self = [super init];
    if (self) {
        self.tagNo = [paramASN1TaggedObject getTagNo];
        switch (self.tagNo) {
            case 0:
                self.obj = [DERNull INSTANCE];
                break;
            case 1:
                self.obj = [POPOSigningKey getInstance:paramASN1TaggedObject paramBoolean:false];
                break;
            case 2:
            case 3:
                self.obj = [POPOPrivKey getInstance:paramASN1TaggedObject paramBoolean:TRUE];
                break;
            default:
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown tag: %d", self.tagNo] userInfo:nil];
                break;
        }
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tagNo = 0;
        self.obj = [DERNull INSTANCE];
    }
    return self;
}

- (instancetype)initParamPOPOSigningKey:(POPOSigningKey *)paramPOPOSigningKey
{
    self = [super init];
    if (self) {
        self.tagNo = 1;
        self.obj = paramPOPOSigningKey;
    }
    return self;
}

- (instancetype)initParamInt:(int)paramInt paramPOPOPrivKey:(POPOPrivKey *)paramPOPOPrivKey
{
    self = [super init];
    if (self) {
        self.tagNo = paramInt;
        self.obj = paramPOPOPrivKey;
    }
    return self;
}

- (int)getType {
    return self.tagNo;
}

- (ASN1Encodable *)getObject {
    return self.obj;
}

- (ASN1Primitive *)toASN1Primitive {
    return [[[DERTaggedObject alloc] initParamBoolean:false paramInt:self.tagNo paramASN1Encodable:self.obj] autorelease];
}

@end
