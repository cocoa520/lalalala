//
//  PKIArchiveOptions.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKIArchiveOptions.h"
#import "ASN1TaggedObject.h"
#import "DERTaggedObject.h"
#import "ASN1Boolean.h"

@interface PKIArchiveOptions ()

@property (nonatomic, readwrite, retain) ASN1Encodable *value;

@end

@implementation PKIArchiveOptions
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

+ (int)encryptedPrivKey {
    static int _encryptedPrivKey = 0;
    @synchronized(self) {
        if (!_encryptedPrivKey) {
            _encryptedPrivKey = 0;
        }
    }
    return _encryptedPrivKey;
}

+ (int)keyGenParameters {
    static int _keyGenParameters = 0;
    @synchronized(self) {
        if (!_keyGenParameters) {
            _keyGenParameters = 1;
        }
    }
    return _keyGenParameters;
}

+ (int)archiveRemGenPrivKey {
    static int _archiveRemGenPrivKey = 0;
    @synchronized(self) {
        if (!_archiveRemGenPrivKey) {
            _archiveRemGenPrivKey = 2;
        }
    }
    return _archiveRemGenPrivKey;
}

+ (PKIArchiveOptions *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[PKIArchiveOptions class]]) {
        return (PKIArchiveOptions *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        return [[[PKIArchiveOptions alloc] initParamASN1TaggedObject:(ASN1TaggedObject *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown object: %@", paramObject] userInfo:nil];
}

- (instancetype)initParamASN1TaggedObject:(ASN1TaggedObject *)paramASN1TaggedObject
{
    self = [super init];
    if (self) {
        switch ([paramASN1TaggedObject getTagNo]) {
            case 0:
                self.value = [EncryptedKey getInstance:[paramASN1TaggedObject getObject]];
                break;
            case 1:
                self.value = [ASN1OctetString getInstance:paramASN1TaggedObject paramBoolean:NO];
                break;
            case 2:
                self.value = [ASN1Boolean getInstance:paramASN1TaggedObject paramBoolean:NO];
                break;
            default:
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown tag number: %d", [paramASN1TaggedObject getTagNo]] userInfo:nil];
                break;
        }
    }
    return self;
}

- (instancetype)initParamEncryptedKey:(EncryptedKey *)paramEncryptedKey
{
    self = [super init];
    if (self) {
        self.value = paramEncryptedKey;
    }
    return self;
}

- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    self = [super init];
    if (self) {
        self.value = paramASN1OctetString;
    }
    return self;
}

- (instancetype)initParamBoolean:(BOOL)paramBoolean
{
    self = [super init];
    if (self) {
        self.value = [ASN1Boolean getInstanceBoolean:paramBoolean];
    }
    return self;
}

- (int)getType {
    if ([self.value isKindOfClass:[EncryptedKey class]]) {
        return 0;
    }
    if ([self.value isKindOfClass:[ASN1OctetString class]]) {
        return 1;
    }
    return 2;
}

- (ASN1Encodable *)getValue {
    return self.value;
}

- (ASN1Primitive *)toASN1Primitive {
    if ([self.value isKindOfClass:[EncryptedKey class]]) {
        return [[[DERTaggedObject alloc] initParamBoolean:TRUE paramInt:0 paramASN1Encodable:self.value] autorelease];
    }
    if ([self.value isKindOfClass:[ASN1OctetString class]]) {
        return [[[DERTaggedObject alloc] initParamBoolean:false paramInt:1 paramASN1Encodable:self.value] autorelease];
    }
    return [[[DERTaggedObject alloc] initParamBoolean:false paramInt:2 paramASN1Encodable:self.value] autorelease];
}

@end
