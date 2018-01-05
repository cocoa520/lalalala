//
//  Data.m
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DataDVCS.h"
#import "DERTaggedObject.h"
#import "DEROctetString.h"
#import "DERSequence.h"
#import "CategoryExtend.h"

@interface DataDVCS ()

@property (nonatomic, readwrite, retain) ASN1OctetString *message;
@property (nonatomic, readwrite, retain) DigestInfo *messageImprint;
@property (nonatomic, readwrite, retain) ASN1Sequence *certs;

@end

@implementation DataDVCS
@synthesize message = _message;
@synthesize messageImprint = _messageImprint;
@synthesize certs = _certs;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_message) {
        [_message release];
        _message = nil;
    }
    if (_messageImprint) {
        [_messageImprint release];
        _messageImprint = nil;
    }
    if (_certs) {
        [_certs release];
        _certs = nil;
    }
    [super dealloc];
#endif
}

+ (DataDVCS *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[DataDVCS class]]) {
        return (DataDVCS *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1OctetString class]]) {
        return [[[DataDVCS alloc] initParamASN1OctetString:(ASN1OctetString *)paramObject] autorelease];
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[DataDVCS alloc] initParamDigestInfo:[DigestInfo getInstance:paramObject]] autorelease];
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        return [[[DataDVCS alloc] initParamASn1Sequence:[ASN1Sequence getInstance:(ASN1TaggedObject *)paramObject paramBoolean:false]] autorelease];
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Unknown object submitted to getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (DataDVCS *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [DataDVCS getInstance:[paramASN1TaggedObject getObject]];
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        self.message = octetString;
#if !__has_feature(objc_arc)
    if (octetString) [octetString release]; octetString = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        self.message = paramASN1OctetString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamDigestInfo:(DigestInfo *)paramDigestInfo
{
    if (self = [super init]) {
        self.messageImprint = paramDigestInfo;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamTargetEtcChain:(TargetEtcChain *)paramTargetEtcChain
{
    if (self = [super init]) {
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1Encodable:paramTargetEtcChain];
        self.certs = sequence;
#if !__has_feature(objc_arc)
    if (sequence) [sequence release]; sequence = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfTargetEtcChain:(NSMutableArray *)paramArrayOfTargetEtcChain
{
    if (self = [super init]) {
        ASN1Sequence *sequence = [[DERSequence alloc] initDERparamArrayOfASN1Encodable:paramArrayOfTargetEtcChain];
        self.certs = sequence;
#if !__has_feature(objc_arc)
    if (sequence) [sequence release]; sequence = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASn1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.certs = paramASN1Sequence;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Primitive *)toASN1Primitive {
    if (self.message) {
        return [self.message toASN1Primitive];
    }
    if (self.messageImprint) {
        return [self.messageImprint toASN1Primitive];
    }
    return [[[ASN1TaggedObject alloc] initParamBoolean:false paramInt:0 paramASN1Encodable:self.certs] autorelease];
}

- (NSString *)toString {
    if (self.message) {
        return [NSString stringWithFormat:@"Data {\n%@}\n", self.message];
    }
    if (self.messageImprint) {
        return [NSString stringWithFormat:@"Data {\n%@}\n", self.messageImprint];
    }
    return [NSString stringWithFormat:@"Data {\n%@}\n", self.certs];
}

- (ASN1OctetString *)getMessage {
    return self.message;
}

- (DigestInfo *)getMessageImprint {
    return self.messageImprint;
}

- (NSMutableArray *)getCerts {
    if (!self.certs) {
        return nil;
    }
    NSMutableArray *arrayOfTargetEtcChain = [[[NSMutableArray alloc] initWithSize:[self.certs size]] autorelease];
    for (int i = 0; i != arrayOfTargetEtcChain.count; i++) {
        arrayOfTargetEtcChain[i] = [TargetEtcChain getInstance:[self.certs getObjectAt:i]];
    }
    return arrayOfTargetEtcChain;
}

@end
