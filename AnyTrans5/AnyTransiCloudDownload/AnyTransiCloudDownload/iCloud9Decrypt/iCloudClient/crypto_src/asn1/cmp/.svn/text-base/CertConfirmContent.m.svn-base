//
//  CertConfirmContent.m
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertConfirmContent.h"
#import "CertStatusCMP.h"
#import "CategoryExtend.h"

@interface CertConfirmContent ()

@property (nonatomic, readwrite, retain) ASN1Sequence *content;

@end

@implementation CertConfirmContent
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

+ (CertConfirmContent *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertConfirmContent class]]) {
        return (CertConfirmContent *)paramObject;
    }
    if (paramObject) {
        return [[[CertConfirmContent alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
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

- (NSMutableArray *)toCertStatusArray {
    NSMutableArray *arrayOfCertStatus = [[[NSMutableArray alloc] initWithSize:[self.content size]] autorelease];
    for (int i = 0; i != arrayOfCertStatus.count; i++) {
        arrayOfCertStatus[i] = [CertStatusCMP getInstance:[self.content getObjectAt:i]];
    }
    return arrayOfCertStatus;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.content;
}

@end
