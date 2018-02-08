//
//  CertificatePolicies.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertificatePolicies.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "Extension.h"
#import "CategoryExtend.h"

@interface CertificatePolicies ()

@property (nonatomic, readwrite, retain) NSMutableArray *policyInformation;

@end

@implementation CertificatePolicies
@synthesize policyInformation = _policyInformation;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_policyInformation) {
        [_policyInformation release];
        _policyInformation = nil;
    }
    [super dealloc];
#endif
}

+ (CertificatePolicies *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertificatePolicies class]]) {
        return (CertificatePolicies *)paramObject;
    }
    if (paramObject) {
        return [[[CertificatePolicies alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (CertificatePolicies *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [CertificatePolicies getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (CertificatePolicies *)fromExtensions:(Extensions *)paramExtensions {
    return [CertificatePolicies getInstance:[paramExtensions getExtensionParsedValue:[Extension certificatePolicies]]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSMutableArray *policyAry = [[NSMutableArray alloc] initWithSize:(int)[paramASN1Sequence size]];
        self.policyInformation = policyAry;
        for (int i = 0; i != [paramASN1Sequence size]; i++) {
            self.policyInformation[i] = [PolicyInformation getInstance:[paramASN1Sequence getObjectAt:i]];
        }
#if !__has_feature(objc_arc)
    if (policyAry) [policyAry release]; policyAry = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamPolicyInformation:(PolicyInformation *)paramPolicyInformation
{
    if (self = [super init]) {
        NSMutableArray *policyAry = [[NSMutableArray alloc] initWithObjects:paramPolicyInformation, nil];
        self.policyInformation = policyAry;
#if !__has_feature(objc_arc)
    if (policyAry) [policyAry release]; policyAry = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfPolicyInformation:(NSMutableArray *)paramArrayOfPolicyInformation
{
    if (self = [super init]) {
        self.policyInformation = paramArrayOfPolicyInformation;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableArray *)getPolicyInformation {
    NSMutableArray *arrayOfPolicyInformation = [[[NSMutableArray alloc] initWithSize:(int)[self.policyInformation count]] autorelease];
    [arrayOfPolicyInformation copyFromIndex:0 withSource:self.policyInformation withSourceIndex:0 withLength:(int)[self.policyInformation count]];
    return arrayOfPolicyInformation;
}

- (PolicyInformation *)getPolicyInformation:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    for (int i = 0; i != self.policyInformation.count; i++) {
        if ([paramASN1ObjectIdentifier isEqual:[self.policyInformation[i] getPolicyIdentifer]]) {
            return self.policyInformation[i];
        }
    }
    return nil;
}

- (ASN1Primitive *)toASN1Primitive {
    return [[[DERSequence alloc] initDERparamArrayOfASN1Encodable:self.policyInformation] autorelease];
}

- (NSString *)toString {
    NSMutableString *localStringBuffer = [[[NSMutableString alloc] init] autorelease];
    for (int i = 0; i < self.policyInformation.count; i++) {
        if ([localStringBuffer length]) {
            [localStringBuffer appendString:@", "];
        }
        [localStringBuffer appendString:self.policyInformation[i]];
    }
    return [NSString stringWithFormat:@"CertificatePolicies: [%@]", localStringBuffer];
}

@end
