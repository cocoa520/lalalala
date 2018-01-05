//
//  KEKIdentifier.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "KEKIdentifier.h"
#import "ASN1Sequence.h"
#import "DEROctetString.h"
#import "DERSequence.h"

@interface KEKIdentifier ()

@property (nonatomic, readwrite, retain) ASN1OctetString *keyIdentifier;
@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *date;
@property (nonatomic, readwrite, retain) OtherKeyAttribute *other;

@end

@implementation KEKIdentifier
@synthesize keyIdentifier = _keyIdentifier;
@synthesize date = _date;
@synthesize other = _other;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_keyIdentifier) {
        [_keyIdentifier release];
        _keyIdentifier = nil;
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

+ (KEKIdentifier *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[KEKIdentifier class]]) {
        return (KEKIdentifier *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[KEKIdentifier alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Invalid KEKIdentifier: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (KEKIdentifier *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [KEKIdentifier getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.keyIdentifier = (ASN1OctetString *)[paramASN1Sequence getObjectAt:0];
        switch ([paramASN1Sequence size]) {
            case 1:
                break;
            case 2: {
                if ([[paramASN1Sequence getObjectAt:1] isKindOfClass:[ASN1GeneralizedTime class]]) {
                    self.date = (ASN1GeneralizedTime *)[paramASN1Sequence getObjectAt:1];
                }else {
                    self.other = [OtherKeyAttribute getInstance:[paramASN1Sequence getObjectAt:1]];
                }
            }
                break;
            case 3: {
                self.date = (ASN1GeneralizedTime *)[paramASN1Sequence getObjectAt:1];
                self.other = [OtherKeyAttribute getInstance:[paramASN1Sequence getObjectAt:2]];
            }
                break;
            default:
                @throw [NSException exceptionWithName:NSGenericException reason:@"Invalid KEKIdentifier" userInfo:nil];
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

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramOtherKeyAttribute:(OtherKeyAttribute *)paramOtherKeyAttribute
{
    if (self = [super init]) {
        ASN1OctetString *octecString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        self.keyIdentifier = octecString;
#if !__has_feature(objc_arc)
    if (octecString) [octecString release]; octecString = nil;
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

- (ASN1OctetString *)getKeyIdentifier {
    return self.keyIdentifier;
}

- (ASN1GeneralizedTime *)getDate {
    return self.date;
}

- (OtherKeyAttribute *)getOther {
    return self.other;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.keyIdentifier];
    if (self.date) {
        [localASN1EncodableVector add:self.date];
    }
    if (self.other) {
        [localASN1EncodableVector add:self.other];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
    return primitive;
}

@end
