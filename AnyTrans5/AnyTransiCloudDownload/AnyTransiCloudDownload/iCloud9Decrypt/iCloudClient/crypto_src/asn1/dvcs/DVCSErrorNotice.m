//
//  DVCSErrorNotice.m
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DVCSErrorNotice.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface DVCSErrorNotice ()

@property (nonatomic, readwrite, retain) PKIStatusInfo *transactionStatus;
@property (nonatomic, readwrite, retain) GeneralName *transactionIdentifier;

@end

@implementation DVCSErrorNotice
@synthesize transactionStatus = _transactionStatus;
@synthesize transactionIdentifier = _transactionIdentifier;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_transactionStatus) {
        [_transactionStatus release];
        _transactionStatus = nil;
    }
    if (_transactionIdentifier) {
        [_transactionIdentifier release];
        _transactionIdentifier = nil;
    }
    [super dealloc];
#endif
}

+ (DVCSErrorNotice *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[DVCSErrorNotice class]]) {
        return (DVCSErrorNotice *)paramObject;
    }
    if (paramObject) {
        [[[DVCSErrorNotice alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (DVCSErrorNotice *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolea {
    return [DVCSErrorNotice getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolea]];
}

- (instancetype)initParamPKIStatusInfo:(PKIStatusInfo *)paramPKIStatusInfo
{
    if (self = [super init]) {
        [self initParamPKIStatusInfo:paramPKIStatusInfo paramGeneralName:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamPKIStatusInfo:(PKIStatusInfo *)paramPKIStatusInfo paramGeneralName:(GeneralName *)paramGeneralName
{
    if (self = [super init]) {
        self.transactionStatus = paramPKIStatusInfo;
        self.transactionIdentifier = paramGeneralName;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.transactionStatus = [PKIStatusInfo getInstance:[paramASN1Sequence getObjectAt:0]];
        if ([paramASN1Sequence size] > 1) {
            self.transactionIdentifier = [GeneralName getInstance:[paramASN1Sequence getObjectAt:1]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.transactionStatus];
    if (self.transactionIdentifier) {
        [localASN1EncodableVector add:self.transactionIdentifier];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"DVCSErrorNotice {\ntransactionStatus: %@\n%@}\n", self.transactionStatus, (self.transactionIdentifier != nil ? [NSString stringWithFormat:@"transactionIdentifier: %@\n", self.transactionIdentifier] : @"")];
}

- (PKIStatusInfo *)getTransactionStatus {
    return self.transactionStatus;
}

- (GeneralName *)getTransactionIdentifier {
    return self.transactionIdentifier;
}

@end
