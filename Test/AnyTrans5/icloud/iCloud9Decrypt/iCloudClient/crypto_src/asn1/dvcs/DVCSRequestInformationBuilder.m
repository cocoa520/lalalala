//
//  DVCSRequestInformationBuilder.m
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DVCSRequestInformationBuilder.h"
#import "ASN1Integer.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"
#import "BigIntegers.h"
#import "CategoryExtend.h"

@interface DVCSRequestInformationBuilder ()

@property (nonatomic, assign) int version;
@property (nonatomic, readwrite, retain) ServiceType *service;
@property (nonatomic, readwrite, retain) DVCSRequestInformation *initialInfo;
@property (nonatomic, readwrite, retain) BigInteger *nonce;
@property (nonatomic, readwrite, retain) DVCSTime *requestTime;
@property (nonatomic, readwrite, retain) GeneralNames *requester;
@property (nonatomic, readwrite, retain) PolicyInformation *requestPolicy;
@property (nonatomic, readwrite, retain) GeneralNames *dvcs;
@property (nonatomic, readwrite, retain) GeneralNames *dataLocations;
@property (nonatomic, readwrite, retain) Extensions *extensions;

@end

@implementation DVCSRequestInformationBuilder
@synthesize version = _version;
@synthesize service = _service;
@synthesize initialInfo = _initialInfo;
@synthesize nonce = _nonce;
@synthesize requestTime = _requestTime;
@synthesize requester = _requester;
@synthesize requestPolicy = _requestPolicy;
@synthesize dvcs = _dvcs;
@synthesize dataLocations = _dataLocations;
@synthesize extensions = _extensions;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_service) {
        [_service release];
        _service = nil;
    }
    if (_initialInfo) {
        [_initialInfo release];
        _initialInfo = nil;
    }
    if (_nonce) {
        [_nonce release];
        _nonce = nil;
    }
    if (_requestTime) {
        [_requestTime release];
        _requestTime = nil;
    }
    if (_requester) {
        [_requester release];
        _requester = nil;
    }
    if (_requestPolicy) {
        [_requestPolicy release];
        _requestPolicy = nil;
    }
    if (_dvcs) {
        [_dvcs release];
        _dvcs = nil;
    }
    if (_dataLocations) {
        [_dataLocations release];
        _dataLocations = nil;
    }
    if (_extensions) {
        [_extensions release];
        _extensions = nil;
    }
    [super dealloc];
#endif
}

+ (int)DEFAULT_VERSION {
    static int _DEFAULT_VERSION = 0;
    @synchronized(self) {
        if (!_DEFAULT_VERSION) {
            _DEFAULT_VERSION = 1;
        }
    }
    return _DEFAULT_VERSION;
}

+ (int)TAG_REQUESTER {
    static int _TAG_REQUESTER = 0;
    @synchronized(self) {
        if (!_TAG_REQUESTER) {
            _TAG_REQUESTER = 0;
        }
    }
    return _TAG_REQUESTER;
}

+ (int)TAG_REQUEST_POLICY {
    static int _TAG_REQUEST_POLICY = 0;
    @synchronized(self) {
        if (!_TAG_REQUEST_POLICY) {
            _TAG_REQUEST_POLICY = 1;
        }
    }
    return _TAG_REQUEST_POLICY;
}

+ (int)TAG_DVCS {
    static int _TAG_DVCS = 0;
    @synchronized(self) {
        if (!_TAG_DVCS) {
            _TAG_DVCS = 2;
        }
    }
    return _TAG_DVCS;
}

+ (int)TAG_DATA_LOCATIONS {
    static int _TAG_DATA_LOCATIONS = 0;
    @synchronized(self) {
        if (!_TAG_DATA_LOCATIONS) {
            _TAG_DATA_LOCATIONS = 3;
        }
    }
    return _TAG_DATA_LOCATIONS;
}

+ (int)TAG_EXTENSIONS {
    static int _TAG_EXTENSIONS = 0;
    @synchronized(self) {
        if (!_TAG_EXTENSIONS) {
            _TAG_EXTENSIONS = 4;
        }
    }
    return _TAG_EXTENSIONS;
}

- (instancetype)initParamServiceType:(ServiceType *)paramServiceType
{
    if (self = [super init]) {
        self.service = paramServiceType;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamDVCSRequestInformation:(DVCSRequestInformation *)paramDVCSRequestInformation
{
    if (self = [super init]) {
        self.initialInfo = paramDVCSRequestInformation;
        self.service = [paramDVCSRequestInformation getService];
        self.version = [paramDVCSRequestInformation getVersion];
        self.nonce = [paramDVCSRequestInformation getNonce];
        self.requestTime = [paramDVCSRequestInformation getRequestTime];
        self.requestPolicy = [paramDVCSRequestInformation getRequestPolicy];
        self.dvcs = [paramDVCSRequestInformation getDVCS];
        self.dataLocations = [paramDVCSRequestInformation getDataLocations];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (DVCSRequestInformation *)build {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.version != 1) {
        ASN1Encodable *versionEncodable = [[ASN1Integer alloc] initLong:self.version];
        [localASN1EncodableVector add:versionEncodable];
#if !__has_feature(objc_arc)
    if (versionEncodable) [versionEncodable release]; versionEncodable = nil;
#endif
    }
    [localASN1EncodableVector add:self.service];
    if (self.nonce) {
        ASN1Encodable *nonceEncodable = [[ASN1Integer alloc] initBI:self.nonce];
        [localASN1EncodableVector add:nonceEncodable];
#if !__has_feature(objc_arc)
    if (nonceEncodable) [nonceEncodable release]; nonceEncodable = nil;
#endif
    }
    if (self.requestTime) {
        [localASN1EncodableVector add:self.requestTime];
    }
    NSArray *arrayOfInt = @[@0, @1, @2, @3, @4];
    NSArray *arrayOfASN1Encodable = @[self.requester, self.requestPolicy, self.dvcs, self.dataLocations, self.extensions];
    for (int i = 0; i < arrayOfInt.count; i++) {
        int j = (int)arrayOfInt[i];
        ASN1Encodable *localASN1Encodable = arrayOfASN1Encodable[i];
        if (localASN1Encodable) {
            ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:false paramInt:j paramASN1Encodable:localASN1Encodable];
            [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
        }
    }
    DERSequence *derSequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
    DVCSRequestInformation *info = [DVCSRequestInformation getInstance:derSequence];
#if !__has_feature(objc_arc)
    if (derSequence) [derSequence release]; derSequence = nil;
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return info;
}

- (void)setVersion:(int)version {
    if (self.initialInfo) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"cannot change version in existing DVCSRequestInformation" userInfo:nil];
    }
    self.version = version;
}

- (void)setNonce:(BigInteger *)nonce {
    if (self.initialInfo) {
        if (![self.initialInfo getNonce]) {
            self.nonce = nonce;
        }else {
            NSMutableData *arrayOfByte1 = [[[self initialInfo] getNonce] toByteArray];
            NSMutableData *arrayOfByte2 = [BigIntegers asUnsignedByteArray:nonce];
            NSMutableData *arrayOfByte3 = [[NSMutableData alloc] initWithSize:(int)(arrayOfByte1.length + arrayOfByte2.length)];
            [arrayOfByte3 copyFromIndex:0 withSource:arrayOfByte1 withSourceIndex:0 withLength:(int)[arrayOfByte1 length]];
            [arrayOfByte3 copyFromIndex:(int)[arrayOfByte1 length] withSource:arrayOfByte2 withSourceIndex:0 withLength:(int)[arrayOfByte2 length]];
            BigInteger *big = [[BigInteger alloc] initWithData:arrayOfByte3];
            self.nonce = big;
#if !__has_feature(objc_arc)
    if (big) [big release]; big = nil;
    if (arrayOfByte3) [arrayOfByte3 release]; arrayOfByte3 = nil;
#endif
        }
    }
    self.nonce = nonce;
}

- (void)setRequestTime:(DVCSTime *)requestTime {
    if (self.initialInfo) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"cannot change request time in existing DVCSRequestInformation" userInfo:nil];
    }
    self.requestTime = requestTime;
}

- (void)setRequesterGeneralName:(GeneralName *)requester {
    GeneralNames *names = [[GeneralNames alloc] initParamGeneralName:requester];
    [self setRequester:names];
#if !__has_feature(objc_arc)
    if (names) [names release]; names = nil;
#endif
}

- (void)setRequester:(GeneralNames *)requesters {
    self.requester = requesters;
}

- (void)setRequestPolicy:(PolicyInformation *)requestPolicy {
    if (self.initialInfo) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"cannot change request policy in existing DVCSRequestInformation" userInfo:nil];
    }
    self.requestPolicy = requestPolicy;
}

- (void)setDvcsGeneralName:(GeneralName *)dvcs {
    GeneralNames *names = [[GeneralNames alloc] initParamGeneralName:dvcs];
    [self setDvcs:names];
#if !__has_feature(objc_arc)
    if (names) [names release]; names = nil;
#endif
}

- (void)setDvcs:(GeneralNames *)dvcs {
    self.dvcs = dvcs;
}

- (void)setDataLocationsGeneralName:(GeneralName *)dataLocations {
    GeneralNames *names = [[GeneralNames alloc] initParamGeneralName:dataLocations];
    [self setDataLocations:names];
#if !__has_feature(objc_arc)
    if (names) [names release]; names = nil;
#endif
}

- (void)setDataLocations:(GeneralNames *)dataLocations {
    self.dataLocations = dataLocations;
}

- (void)setExtensions:(Extensions *)extensions {
    if (self.initialInfo) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"cannot change extensions in existing DVCSRequestInformation" userInfo:nil];
    }
    self.extensions = extensions;
}

@end
