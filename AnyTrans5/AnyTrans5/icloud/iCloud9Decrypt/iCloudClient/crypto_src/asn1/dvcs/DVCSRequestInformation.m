//
//  DVCSRequestInformation.m
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DVCSRequestInformation.h"
#import "ASN1Sequence.h"
#import "ASN1Integer.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface DVCSRequestInformation ()

@property (nonatomic, assign) int version;
@property (nonatomic, readwrite, retain) ServiceType *service;
@property (nonatomic, readwrite, retain) BigInteger *nonce;
@property (nonatomic, readwrite, retain) DVCSTime *requestTime;
@property (nonatomic, readwrite, retain) GeneralNames *requester;
@property (nonatomic, readwrite, retain) PolicyInformation *requestPolicy;
@property (nonatomic, readwrite, retain) GeneralNames *dvcs;
@property (nonatomic, readwrite, retain) GeneralNames *dataLocations;
@property (nonatomic, readwrite, retain) Extensions *extensions;

@end

@implementation DVCSRequestInformation
@synthesize version = _version;
@synthesize service = _service;
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

+ (DVCSRequestInformation *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[DVCSRequestInformation class]]) {
        return (DVCSRequestInformation *)paramObject;
    }
    if (paramObject) {
        return [[[DVCSRequestInformation alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (DVCSRequestInformation *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [DVCSRequestInformation getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        int i = 0;
        id localObject;
        if ([[paramASN1Sequence getObjectAt:0] isKindOfClass:[ASN1Integer class]]) {
            localObject = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:i++]];
            self.version = [[((ASN1Integer *)localObject) getValue] intValue];
        }else {
            self.version = 1;
        }
        self.service = [ServiceType getInstance:[paramASN1Sequence getObjectAt:i++]];
        while (i < [paramASN1Sequence size]) {
            localObject = [paramASN1Sequence getObjectAt:i];
            if ([localObject isKindOfClass:[ASN1Integer class]]) {
                self.nonce = [[ASN1Integer getInstance:localObject] getValue];
            }else if ([localObject isKindOfClass:[ASN1GeneralizedTime class]]) {
                self.requestTime = [DVCSTime getInstance:localObject];
            }else if ([localObject isKindOfClass:[ASN1TaggedObject class]]) {
                ASN1TaggedObject *localASN1TaggedObject = [ASN1TaggedObject getInstance:localObject];
                int j = [localASN1TaggedObject getTagNo];
                switch (j) {
                    case 0:
                        self.requester = [GeneralNames getInstance:localASN1TaggedObject paramBoolean:false];
                        break;
                    case 1:
                        self.requestPolicy = [PolicyInformation getInstance:[ASN1Sequence getInstance:localASN1TaggedObject paramBoolean:false]];
                        break;
                    case 2:
                        self.dvcs = [GeneralNames getInstance:localASN1TaggedObject paramBoolean:false];
                        break;
                    case 3:
                        self.dataLocations = [GeneralNames getInstance:localASN1TaggedObject paramBoolean:false];
                        break;
                    case 4:
                        self.extensions = [Extensions getInstance:localASN1TaggedObject paramBoolean:false];
                    default:
                        break;
                }
            }else {
                self.requestTime = [DVCSTime getInstance:localObject];
            }
            i++;
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
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (NSString *)toString {
    NSMutableString *localStringBuffer = [[[NSMutableString alloc] init] autorelease];
    [localStringBuffer appendString:@"DVCSRequestInformation {\n"];
    if (self.version != 1) {
        [localStringBuffer appendString:[NSString stringWithFormat:@"version: %d\n", self.version]];
    }
    [localStringBuffer appendString:[NSString stringWithFormat:@"service: %@\n", self.service]];
    if (self.nonce) {
        [localStringBuffer appendString:[NSString stringWithFormat:@"nonce: %@\n", self.nonce]];
    }
    if (self.requestTime) {
        [localStringBuffer appendString:[NSString stringWithFormat:@"requestTime %@\n", self.requestTime]];
    }
    if (self.requester) {
        [localStringBuffer appendString:[NSString stringWithFormat:@"requester: %@\n", self.requester]];
    }
    if (self.requestPolicy) {
        [localStringBuffer appendString:[NSString stringWithFormat:@"requestPolicy: %@\n", self.requestPolicy]];
    }
    if (self.dvcs) {
        [localStringBuffer appendString:[NSString stringWithFormat:@"dvcs: %@\n", self.dvcs]];
    }
    if (self.dataLocations) {
        [localStringBuffer appendString:[NSString stringWithFormat:@"dataLocations: %@\n", self.dataLocations]];
    }
    if (self.extensions) {
        [localStringBuffer appendString:[NSString stringWithFormat:@"extensions: %@\n", self.extensions]];
    }
    [localStringBuffer appendString:@"}\n"];
    return [NSString stringWithFormat:@"%@", localStringBuffer.description];
}

- (int)getVersion {
    return self.version;
}

- (ServiceType *)getService {
    return self.service;
}

- (BigInteger *)getNonce {
    return self.nonce;
}

- (DVCSTime *)getRequestTime {
    return self.requestTime;
}

- (GeneralNames *)getRequester {
    return self.requester;
}

- (PolicyInformation *)getRequestPolicy {
    return self.requestPolicy;
}

- (GeneralNames *)getDVCS {
    return self.dvcs;
}

- (GeneralNames *)getDataLocations {
    return self.dataLocations;
}

- (Extensions *)getExtensions {
    return self.extensions;
}

@end
