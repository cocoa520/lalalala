//
//  RecipientKeyIdentifier.m
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RecipientKeyIdentifier.h"
#import "DEROctetString.h"
#import "DERSequence.h"

@interface RecipientKeyIdentifier ()

@property (nonatomic, readwrite, retain) ASN1OctetString *subjectKeyIdentifier;
@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *date;
@property (nonatomic, readwrite, retain) OtherKeyAttribute *other;

@end

@implementation RecipientKeyIdentifier
@synthesize subjectKeyIdentifier = _subjectKeyIdentifier;
@synthesize date = _date;
@synthesize other = _other;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_subjectKeyIdentifier) {
        [_subjectKeyIdentifier release];
        _subjectKeyIdentifier = nil;
    }
    if (_date) {
        [_date release];
        _date = nil;
    }
    if (_other) {
        [_other release];
        _other = nil;
    }
    [super dealloc];
#endif
}

+ (RecipientKeyIdentifier *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[RecipientKeyIdentifier class]]) {
        return (RecipientKeyIdentifier *)paramObject;
    }
    if (paramObject) {
        return [[[RecipientKeyIdentifier alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (RecipientKeyIdentifier *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [RecipientKeyIdentifier getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.subjectKeyIdentifier = [ASN1OctetString getInstance:[paramASN1Sequence getObjectAt:0]];
        switch ([paramASN1Sequence size]) {
            case 1:
                break;
            case 2: {
                if ([[paramASN1Sequence getObjectAt:1] isKindOfClass:[ASN1GeneralizedTime class]]) {
                    self.date = [ASN1GeneralizedTime getInstance:[paramASN1Sequence getObjectAt:1]];
                }else {
                    self.other = [OtherKeyAttribute getInstance:[paramASN1Sequence getObjectAt:2]];
                }
            }
                break;
            case 3: {
                self.date = [ASN1GeneralizedTime getInstance:[paramASN1Sequence getObjectAt:1]];
                self.other = [OtherKeyAttribute getInstance:[paramASN1Sequence getObjectAt:2]];
            }
                break;
            default:
                @throw [NSException exceptionWithName:NSGenericException reason:@"Invalid RecipientKeyIdentifier" userInfo:nil];
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

- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramOtherKeyAttribute:(OtherKeyAttribute *)paramOtherKeyAttribute
{
    if (self = [super init]) {
        self.subjectKeyIdentifier = paramASN1OctetString;
        self.date = paramASN1GeneralizedTime;
        self.other = paramOtherKeyAttribute;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        [self initParamArrayOfByte:paramArrayOfByte paramASN1GeneralizedTime:nil paramOtherKeyAttribute:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramOtherKeyAttribute:(OtherKeyAttribute *)paramOtherKeyAttribute
{
    if (self = [super init]) {
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        self.subjectKeyIdentifier = octetString;
#if !__has_feature(objc_arc)
    if (octetString) [octetString release]; octetString = nil;
#endif
        self.date = paramASN1GeneralizedTime;
        self.other = paramOtherKeyAttribute;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1OctetString *)getSubjectKeyIdentifier {
    return self.subjectKeyIdentifier;
}

- (ASN1GeneralizedTime *)getDate {
    return self.date;
}

- (OtherKeyAttribute *)getOtherKeyAttribute {
    return self.other;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.subjectKeyIdentifier];
    if (self.date) {
        [localASN1EncodableVector add:self.date];
    }
    if (self.other) {
        [localASN1EncodableVector add:self.other];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
