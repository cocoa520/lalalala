//
//  EncKeyWithID.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "EncKeyWithID.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface EncKeyWithID ()

@property (nonatomic, readwrite, retain) PrivateKeyInfo *privKeyInfo;
@property (nonatomic, readwrite, retain) ASN1Encodable *identifier;

@end

@implementation EncKeyWithID
@synthesize privKeyInfo = _privKeyInfo;
@synthesize identifier = _identifier;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_privKeyInfo) {
        [_privKeyInfo release];
        _privKeyInfo = nil;
    }
    if (_identifier) {
        [_identifier release];
        _identifier = nil;
    }
    [super dealloc];
#endif
}

+ (EncKeyWithID *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[EncKeyWithID class]]) {
        return (EncKeyWithID *)paramObject;
    }
    if (paramObject) {
        return [[[EncKeyWithID alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.privKeyInfo = [PrivateKeyInfo getInstance:[paramASN1Sequence getObjectAt:0]];
        if ([paramASN1Sequence size] > 1) {
            if (![[paramASN1Sequence getObjectAt:1] isKindOfClass:[DERUTF8String class]]) {
                self.identifier = [GeneralName getInstance:[paramASN1Sequence getObjectAt:1]];
            }else {
                self.identifier = [paramASN1Sequence getObjectAt:1];
            }
        }else {
            self.identifier = nil;
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamPrivateKeyInfo:(PrivateKeyInfo *)paramPrivateKeyInfo
{
    if (self = [super init]) {
        self.privKeyInfo = paramPrivateKeyInfo;
        self.identifier = nil;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamPrivateKeyInfo:(PrivateKeyInfo *)paramPrivateKeyInfo paramDERUTF8String:(DERUTF8String *)paramDERUTF8String
{
    if (self = [super init]) {
        self.privKeyInfo = paramPrivateKeyInfo;
        self.identifier = paramDERUTF8String;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamPrivateKeyInfo:(PrivateKeyInfo *)paramPrivateKeyInfo paramGeneralName:(GeneralName *)paramGeneralName
{
    if (self = [super init]) {
        self.privKeyInfo = paramPrivateKeyInfo;
        self.identifier = paramGeneralName;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (PrivateKeyInfo *)getPrivatekey {
    return self.privKeyInfo;
}

- (BOOL)hasIdentifier {
    return self.identifier != nil;
}

- (BOOL)isIdentifierUTF8String {
    return [self.identifier isKindOfClass:[DERUTF8String class]];
}

- (ASN1Encodable *)getIdentifier {
    return self.identifier;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.privKeyInfo];
    if (self.identifier) {
        [localASN1EncodableVector add:self.identifier];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
