//
//  DVCSRequest.m
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DVCSRequest.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface DVCSRequest ()

@property (nonatomic, readwrite, retain) DVCSRequestInformation *requestInformation;
@property (nonatomic, readwrite, retain) DataDVCS *data;
@property (nonatomic, readwrite, retain) GeneralName *transactionIdentifier;

@end

@implementation DVCSRequest
@synthesize requestInformation = _requestInformation;
@synthesize data = _data;
@synthesize transactionIdentifier = _transactionIdentifier;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_requestInformation) {
        [_requestInformation release];
        _requestInformation = nil;
    }
    if (_data) {
        [_data release];
        _data = nil;
    }
    if (_transactionIdentifier) {
        [_transactionIdentifier release];
        _transactionIdentifier = nil;
    }
    [super dealloc];
#endif
}

+ (DVCSRequest *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[DVCSRequest class]]) {
        return (DVCSRequest *)paramObject;
    }
    if (paramObject) {
        return [[[DVCSRequest alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (DVCSRequest *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [DVCSRequest getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initparamDVCSRequestInformation:(DVCSRequestInformation *)paramDVCSRequestInformation paramData:(DataDVCS *)paramData
{
    self = [super init];
    if (self) {
        [self initparamDVCSRequestInformation:paramDVCSRequestInformation paramData:paramData paramGeneralName:nil];
    }
    return self;
}

- (instancetype)initparamDVCSRequestInformation:(DVCSRequestInformation *)paramDVCSRequestInformation paramData:(DataDVCS *)paramData paramGeneralName:(GeneralName *)paramGeneralName
{
    self = [super init];
    if (self) {
        self.requestInformation = paramDVCSRequestInformation;
        self.data = paramData;
        self.transactionIdentifier = paramGeneralName;
    }
    return self;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        self.requestInformation = [DVCSRequestInformation getInstance:[paramASN1Sequence getObjectAt:0]];
        self.data = [DataDVCS getInstance:[paramASN1Sequence getObjectAt:1]];
        if ([paramASN1Sequence size] > 2) {
            self.transactionIdentifier = [GeneralName getInstance:[paramASN1Sequence getObjectAt:2]];
        }
    }
    return self;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.requestInformation];
    [localASN1EncodableVector add:self.data];
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
    return [NSString stringWithFormat:@"DVCSRequest {\nrequestInformation: %@\ndata: %@\n%@}\n", self.requestInformation, self.data, (self.transactionIdentifier != nil ? [NSString stringWithFormat:@"transactionIdentifier: %@\n", self.transactionIdentifier] : @"")];
}

- (DataDVCS *)getData {
    return self.data;
}

- (DVCSRequestInformation *)getRequestInformation {
    return self.requestInformation;
}

- (GeneralName *)getTransactionIdentifier {
    return self.transactionIdentifier;
}

@end
