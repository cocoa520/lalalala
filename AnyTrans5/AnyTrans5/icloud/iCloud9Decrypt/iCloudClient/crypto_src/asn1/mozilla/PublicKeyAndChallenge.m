//
//  PublicKeyAndChallenge.m
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PublicKeyAndChallenge.h"

@interface PublicKeyAndChallenge ()

@property (nonatomic, readwrite, retain) ASN1Sequence *pkacSeq;
@property (nonatomic, readwrite, retain) SubjectPublicKeyInfo *spki;
@property (nonatomic, readwrite, retain) DERIA5String *challenge;

@end

@implementation PublicKeyAndChallenge
@synthesize pkacSeq = _pkacSeq;
@synthesize spki = _spki;
@synthesize challenge = _challenge;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_pkacSeq) {
        [_pkacSeq release];
        _pkacSeq = nil;
    }
    if (_spki) {
        [_spki release];
        _spki = nil;
    }
    if (_challenge) {
        [_challenge release];
        _challenge = nil;
    }
    [super dealloc];
#endif
}

+ (PublicKeyAndChallenge *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PublicKeyAndChallenge class]]) {
        return (PublicKeyAndChallenge *)paramObject;
    }
    if (paramObject) {
        return [[[PublicKeyAndChallenge alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.pkacSeq = paramASN1Sequence;
        self.spki = [SubjectPublicKeyInfo getInstance:[paramASN1Sequence getObjectAt:0]];
        self.challenge = [DERIA5String getInstance:[paramASN1Sequence getObjectAt:1]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (ASN1Primitive *)toASN1Primitive {
    return self.pkacSeq;
}

- (SubjectPublicKeyInfo *)getSubjectPublicKeyInfo {
    return self.spki;
}

- (DERIA5String *)getChallenge {
    return self.challenge;
}

@end
