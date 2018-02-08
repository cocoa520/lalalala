//
//  CRLAnnContent.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CRLAnnContent.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "CategoryExtend.h"

@interface CRLAnnContent ()

@property (nonatomic, readwrite, retain) ASN1Sequence *content;

@end

@implementation CRLAnnContent
@synthesize content = _content;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_content) {
        [_content release];
        _content = nil;
    }
    [super dealloc];
#endif
}

+ (CRLAnnContent *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CRLAnnContent class]]) {
        return (CRLAnnContent *)paramObject;
    }
    if (paramObject) {
        return [[[CRLAnnContent alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.content = paramASN1Sequence;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamCertificateList:(CertificateList *)paramCertificateList
{
    if (self = [super init]) {
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1Encodable:paramCertificateList];
        self.content = sequence;
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

- (NSMutableArray *)getCertificateLists {
    NSMutableArray *arrayOfCertificateList = [[[NSMutableArray alloc] initWithSize:self.content.size] autorelease];
    for (int i = 0; i != arrayOfCertificateList.count; i++) {
        arrayOfCertificateList[i] = [CertificateList getInstance:[self.content getObjectAt:i]];
    }
    return arrayOfCertificateList;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.content;
}

@end
