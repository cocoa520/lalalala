//
//  EncryptedKey.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "EncryptedKey.h"
#import "DERTaggedObject.h"

@interface EncryptedKey ()

@property (nonatomic, readwrite, retain) EnvelopedData *envelopedData;
@property (nonatomic, readwrite, retain) EncryptedValue *encryptedValue;

@end

@implementation EncryptedKey
@synthesize envelopedData = _envelopedData;
@synthesize encryptedValue = _encryptedValue;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_envelopedData) {
        [_envelopedData release];
        _envelopedData = nil;
    }
    if (_encryptedValue) {
        [_encryptedValue release];
        _encryptedValue = nil;
    }
   [super dealloc];
#endif
}

+ (EncryptedKey *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[EncryptedKey class]]) {
        return (EncryptedKey *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        return [[[EncryptedKey alloc] initParamEnvelopedData:[EnvelopedData getInstance:(ASN1TaggedObject *)paramObject paramBoolean:false]] autorelease];
    }
    if ([paramObject isKindOfClass:[EncryptedValue class]]) {
        return [[[EncryptedKey alloc] initParamEncryptedValue:(EncryptedValue *)paramObject] autorelease];
    }
    return [[[EncryptedKey alloc] initParamEncryptedValue:[EncryptedValue getInstance:paramObject]] autorelease];
}

- (instancetype)initParamEnvelopedData:(EnvelopedData *)paramEnvelopedData
{
    if (self = [super init]) {
        self.envelopedData = paramEnvelopedData;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamEncryptedValue:(EncryptedValue *)paramEncryptedValue
{
    if (self = [super init]) {
        self.encryptedValue = paramEncryptedValue;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (BOOL)isEncryptedValue {
    return self.encryptedValue != nil;
}

- (ASN1Encodable *)getValue {
    if (self.encryptedValue) {
        return self.encryptedValue;
    }
    return self.envelopedData;
}

- (ASN1Primitive *)toASN1Primitive {
    if (self.encryptedValue) {
        return [self.encryptedValue toASN1Primitive];
    }
    return [[[DERTaggedObject alloc] initParamBoolean:false paramInt:0 paramASN1Encodable:self.envelopedData] autorelease];
}

@end
