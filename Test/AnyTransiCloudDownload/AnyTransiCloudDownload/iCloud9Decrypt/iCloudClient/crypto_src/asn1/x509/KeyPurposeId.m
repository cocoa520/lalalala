//
//  KeyPurposeId.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "KeyPurposeId.h"
#import "Extension.h"

@interface KeyPurposeId ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *id;

@end

@implementation KeyPurposeId
@synthesize id = _id;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_id) {
        [_id release];
        _id = nil;
    }
    [super dealloc];
#endif
}

+ (ASN1ObjectIdentifier *)id_kp {
    static ASN1ObjectIdentifier *_id_kp = nil;
    @synchronized(self) {
        if (!_id_kp) {
            _id_kp = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.3"];
        }
    }
    return _id_kp;
}

+ (KeyPurposeId *)anyExtendedKeyUsage {
    static KeyPurposeId *_anyExtendedKeyUsage = nil;
    @synchronized(self) {
        if (!_anyExtendedKeyUsage) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[Extension extendedKeyUsage] branch:@"0"] retain];
            }
            _anyExtendedKeyUsage = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _anyExtendedKeyUsage;
}

+ (KeyPurposeId *)id_kp_serverAuth {
    static KeyPurposeId *_id_kp_serverAuth = nil;
    @synchronized(self) {
        if (!_id_kp_serverAuth) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"1"] retain];
            }
            _id_kp_serverAuth = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_serverAuth;
}

+ (KeyPurposeId *)id_kp_clientAuth {
    static KeyPurposeId *_id_kp_clientAuth = nil;
    @synchronized(self) {
        if (!_id_kp_clientAuth) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"2"] retain];
            }
            _id_kp_clientAuth = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_clientAuth;
}

+ (KeyPurposeId *)id_kp_codeSigning {
    static KeyPurposeId *_id_kp_codeSigning = nil;
    @synchronized(self) {
        if (!_id_kp_codeSigning) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"3"] retain];
            }
            _id_kp_codeSigning = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_codeSigning;
}

+ (KeyPurposeId *)id_kp_emailProtection {
    static KeyPurposeId *_id_kp_emailProtection = nil;
    @synchronized(self) {
        if (!_id_kp_emailProtection) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"4"] retain];
            }
            _id_kp_emailProtection = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_emailProtection;
}

+ (KeyPurposeId *)id_kp_ipsecEndSystem {
    static KeyPurposeId *_id_kp_ipsecEndSystem = nil;
    @synchronized(self) {
        if (!_id_kp_ipsecEndSystem) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"5"] retain];
            }
            _id_kp_ipsecEndSystem = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_ipsecEndSystem;
}

+ (KeyPurposeId *)id_kp_ipsecTunnel {
    static KeyPurposeId *_id_kp_ipsecTunnel = nil;
    @synchronized(self) {
        if (!_id_kp_ipsecTunnel) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"6"] retain];
            }
            _id_kp_ipsecTunnel = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_ipsecTunnel;
}

+ (KeyPurposeId *)id_kp_ipsecUser {
    static KeyPurposeId *_id_kp_ipsecUser = nil;
    @synchronized(self) {
        if (!_id_kp_ipsecUser) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"7"] retain];
            }
            _id_kp_ipsecUser = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_ipsecUser;
}

+ (KeyPurposeId *)id_kp_timeStamping {
    static KeyPurposeId *_id_kp_timeStamping = nil;
    @synchronized(self) {
        if (!_id_kp_timeStamping) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"8"] retain];
            }
            _id_kp_timeStamping = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_timeStamping;
}

+ (KeyPurposeId *)id_kp_OCSPSigning {
    static KeyPurposeId *_id_kp_OCSPSigning = nil;
    @synchronized(self) {
        if (!_id_kp_OCSPSigning) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"9"] retain];
            }
            _id_kp_OCSPSigning = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_OCSPSigning;
}

+ (KeyPurposeId *)id_kp_dvcs {
    static KeyPurposeId *_id_kp_dvcs = nil;
    @synchronized(self) {
        if (!_id_kp_dvcs) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"10"] retain];
            }
            _id_kp_dvcs = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_dvcs;
}

+ (KeyPurposeId *)id_kp_sbgpCertAAServerAuth {
    static KeyPurposeId *_id_kp_sbgpCertAAServerAuth = nil;
    @synchronized(self) {
        if (!_id_kp_sbgpCertAAServerAuth) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"11"] retain];
            }
            _id_kp_sbgpCertAAServerAuth = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_sbgpCertAAServerAuth;
}

+ (KeyPurposeId *)id_kp_scvp_responder {
    static KeyPurposeId *_id_kp_scvp_responder = nil;
    @synchronized(self) {
        if (!_id_kp_scvp_responder) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"12"] retain];
            }
            _id_kp_scvp_responder = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_scvp_responder;
}

+ (KeyPurposeId *)id_kp_eapOverPPP {
    static KeyPurposeId *_id_kp_eapOverPPP = nil;
    @synchronized(self) {
        if (!_id_kp_eapOverPPP) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"13"] retain];
            }
            _id_kp_eapOverPPP = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_eapOverPPP;
}

+ (KeyPurposeId *)id_kp_eapOverLAN {
    static KeyPurposeId *_id_kp_eapOverLAN = nil;
    @synchronized(self) {
        if (!_id_kp_eapOverLAN) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"14"] retain];
            }
            _id_kp_eapOverLAN = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_eapOverLAN;
}

+ (KeyPurposeId *)id_kp_scvpServer {
    static KeyPurposeId *_id_kp_scvpServer = nil;
    @synchronized(self) {
        if (!_id_kp_scvpServer) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"15"] retain];
            }
            _id_kp_scvpServer = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_scvpServer;
}

+ (KeyPurposeId *)id_kp_scvpClient {
    static KeyPurposeId *_id_kp_scvpClient = nil;
    @synchronized(self) {
        if (!_id_kp_scvpClient) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"16"] retain];
            }
            _id_kp_scvpClient = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_scvpClient;
}

+ (KeyPurposeId *)id_kp_ipsecIKE {
    static KeyPurposeId *_id_kp_ipsecIKE = nil;
    @synchronized(self) {
        if (!_id_kp_ipsecIKE) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"17"] retain];
            }
            _id_kp_ipsecIKE = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_ipsecIKE;
}

+ (KeyPurposeId *)id_kp_capwapAC {
    static KeyPurposeId *_id_kp_capwapAC = nil;
    @synchronized(self) {
        if (!_id_kp_capwapAC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"18"] retain];
            }
            _id_kp_capwapAC = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_capwapAC;
}

+ (KeyPurposeId *)id_kp_capwapWTP {
    static KeyPurposeId *_id_kp_capwapWTP = nil;
    @synchronized(self) {
        if (!_id_kp_capwapWTP) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[KeyPurposeId id_kp] branch:@"19"] retain];
            }
            _id_kp_capwapWTP = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:branchObj];
        }
    }
    return _id_kp_capwapWTP;
}

+ (KeyPurposeId *)id_kp_smartcardlogon {
    static KeyPurposeId *_id_kp_smartcardlogon = nil;
    @synchronized(self) {
        if (!_id_kp_smartcardlogon) {
            ASN1ObjectIdentifier *object = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.311.20.2.2"];
            _id_kp_smartcardlogon = [[KeyPurposeId alloc] initParamASN1ObjectIdentifier:object];
#if !__has_feature(objc_arc)
    if (object) [object release]; object = nil;
#endif
        }
    }
    return _id_kp_smartcardlogon;
}

+ (KeyPurposeId *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[KeyPurposeId class]]) {
        return (KeyPurposeId *)paramObject;
    }
    if (paramObject) {
        return [[[KeyPurposeId alloc] initParamASN1ObjectIdentifier:[ASN1ObjectIdentifier getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier
{
    if (self = [super init]) {
        self.id = paramASN1ObjectIdentifier;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString
{
    if (self = [super init]) {
        ASN1ObjectIdentifier *object = [[ASN1ObjectIdentifier alloc] initParamString:paramString];
        [self initParamASN1ObjectIdentifier:object];
#if !__has_feature(objc_arc)
    if (object) [object release]; object = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)toOID {
    return self.id;
}

- (NSString *)getId {
    return [self.id getId];
}

- (NSString *)toString {
    return [self.id toString];
}

- (ASN1Primitive *)toASN1Primitive {
    return self.id;
}

@end
