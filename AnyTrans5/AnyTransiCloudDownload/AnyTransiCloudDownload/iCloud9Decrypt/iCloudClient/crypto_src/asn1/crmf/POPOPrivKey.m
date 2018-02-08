//
//  POPOPrivKey.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "POPOPrivKey.h"
#import "DERTaggedObject.h"
#import "DERBitString.h"
#import "PKMACValue.h"
#import "EnvelopedData.h"

@interface POPOPrivKey ()

@property (nonatomic, assign) int tagNo;
@property (nonatomic, readwrite, retain) ASN1Encodable *obj;

@end

@implementation POPOPrivKey
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

+ (int)thisMessage {
    static int _thisMessage = 0;
    @synchronized(self) {
        if (!_thisMessage) {
            _thisMessage = 0;
        }
    }
    return _thisMessage;
}

+ (int)subsequentMessage {
    static int _subsequentMessage = 0;
    @synchronized(self) {
        if (!_subsequentMessage) {
            _subsequentMessage = 1;
        }
    }
    return _subsequentMessage;
}

+ (int)dhMAC {
    static int _dhMAC = 0;
    @synchronized(self) {
        if (!_dhMAC) {
            _dhMAC = 2;
        }
    }
    return _dhMAC;
}

+ (int)agreeMAC {
    static int _agreeMAC = 0;
    @synchronized(self) {
        if (!_agreeMAC) {
            _agreeMAC = 3;
        }
    }
    return _agreeMAC;
}

+ (int)encryptedKey {
    static int _encryptedKey = 0;
    @synchronized(self) {
        if (!_encryptedKey) {
            _encryptedKey = 4;
        }
    }
    return _encryptedKey;
}

+ (POPOPrivKey *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[POPOPrivKey class]]) {
        return (POPOPrivKey *)paramObject;
    }
    if (paramObject) {
        return [[[POPOPrivKey alloc] initParamASN1TaggedObject:[ASN1TaggedObject getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (POPOPrivKey *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [POPOPrivKey getInstance:[ASN1TaggedObject getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1TaggedObject:(ASN1TaggedObject *)paramASN1TaggedObject
{
    self = [super init];
    if (self) {
        self.tagNo = [paramASN1TaggedObject getTagNo];
        switch (self.tagNo) {
            case 0:
                self.obj = [DERBitString getInstance:paramASN1TaggedObject paramBoolean:false];
                break;
            case 1:
                self.obj = [SubsequentMessage valueOf:[[[ASN1Integer getInstance:paramASN1TaggedObject paramBoolean:false] getValue] intValue]];
                break;
            case 2:
                self.obj = [DERBitString getInstance:paramASN1TaggedObject paramBoolean:false];
                break;
            case 3:
                self.obj = [PKMACValue getInstance:paramASN1TaggedObject paramBoolean:false];
                break;
            case 4:
                self.obj = [EnvelopedData getInstance:paramASN1TaggedObject paramBoolean:false];
                break;

            default:
                @throw [NSException exceptionWithName:NSGenericException reason:@"unknown tag in POPOPrivKey" userInfo:nil];
                break;
        }
    }
    return self;
}

- (instancetype)initParamSubsequentMessage:(SubsequentMessage *)paramSubsequentMessage
{
    self = [super init];
    if (self) {
        self.tagNo = 1;
        self.obj = paramSubsequentMessage;
    }
    return self;
}

- (int)getType {
    return self.tagNo;
}

- (ASN1Encodable *)getValue {
    return self.obj;
}

- (ASN1Primitive *)toASN1Primitive {
    return [[[DERTaggedObject alloc] initParamBoolean:false paramInt:self.tagNo paramASN1Encodable:self.obj] autorelease];
}

@end
