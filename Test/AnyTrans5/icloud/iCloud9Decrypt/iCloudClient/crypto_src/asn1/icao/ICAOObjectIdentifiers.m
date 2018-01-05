//
//  ICAOObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ICAOObjectIdentifiers.h"

@implementation ICAOObjectIdentifiers

+ (ASN1ObjectIdentifier *)id_icao {
    static ASN1ObjectIdentifier *_id_icao = nil;
    @synchronized(self) {
        if (!_id_icao) {
            _id_icao = [[ASN1ObjectIdentifier alloc] initParamString:@"2.23.136"];
        }
    }
    return _id_icao;
}

+ (ASN1ObjectIdentifier *)id_icao_mrtd {
    static ASN1ObjectIdentifier *_id_icao_mrtd = nil;
    @synchronized(self) {
        if (!_id_icao_mrtd) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_icao] branch:@"1"] retain];
            }
            _id_icao_mrtd = [branchObj retain];
        }
    }
    return _id_icao_mrtd;
}

+ (ASN1ObjectIdentifier *)id_icao_mrtd_security {
    static ASN1ObjectIdentifier *_id_icao_mrtd_security = nil;
    @synchronized(self) {
        if (!_id_icao_mrtd_security) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_icao_mrtd] branch:@"1"] retain];
            }
            _id_icao_mrtd_security = [branchObj retain];
        }
    }
    return _id_icao_mrtd_security;
}

+ (ASN1ObjectIdentifier *)id_icao_ldsSecurityObject {
    static ASN1ObjectIdentifier *_id_icao_ldsSecurityObject = nil;
    @synchronized(self) {
        if (!_id_icao_ldsSecurityObject) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_icao_mrtd_security] branch:@"1"] retain];
            }
            _id_icao_ldsSecurityObject = [branchObj retain];
        }
    }
    return _id_icao_ldsSecurityObject;
}

+ (ASN1ObjectIdentifier *)id_icao_cscaMasterList {
    static ASN1ObjectIdentifier *_id_icao_cscaMasterList = nil;
    @synchronized(self) {
        if (!_id_icao_cscaMasterList) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_icao_mrtd_security] branch:@"2"] retain];
            }
            _id_icao_cscaMasterList = [branchObj retain];
        }
    }
    return _id_icao_cscaMasterList;
}

+ (ASN1ObjectIdentifier *)id_icao_cscaMasterListSigningKey {
    static ASN1ObjectIdentifier *_id_icao_cscaMasterListSigningKey = nil;
    @synchronized(self) {
        if (!_id_icao_cscaMasterListSigningKey) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_icao_mrtd_security] branch:@"3"] retain];
            }
            _id_icao_cscaMasterListSigningKey = [branchObj retain];
        }
    }
    return _id_icao_cscaMasterListSigningKey;
}

+ (ASN1ObjectIdentifier *)id_icao_documentTypeList {
    static ASN1ObjectIdentifier *_id_icao_documentTypeList = nil;
    @synchronized(self) {
        if (!_id_icao_documentTypeList) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_icao_mrtd_security] branch:@"4"] retain];
            }
            _id_icao_documentTypeList = [branchObj retain];
        }
    }
    return _id_icao_documentTypeList;
}

+ (ASN1ObjectIdentifier *)id_icao_aaProtocolObject {
    static ASN1ObjectIdentifier *_id_icao_aaProtocolObject = nil;
    @synchronized(self) {
        if (!_id_icao_aaProtocolObject) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_icao_mrtd_security] branch:@"5"] retain];
            }
            _id_icao_aaProtocolObject = [branchObj retain];
        }
    }
    return _id_icao_aaProtocolObject;
}

+ (ASN1ObjectIdentifier *)id_icao_extensions {
    static ASN1ObjectIdentifier *_id_icao_extensions = nil;
    @synchronized(self) {
        if (!_id_icao_extensions) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_icao_mrtd_security] branch:@"6"] retain];
            }
            _id_icao_extensions = [branchObj retain];
        }
    }
    return _id_icao_extensions;
}

+ (ASN1ObjectIdentifier *)id_icao_extensions_namechangekeyrollover {
    static ASN1ObjectIdentifier *_id_icao_extensions_namechangekeyrollover = nil;
    @synchronized(self) {
        if (!_id_icao_extensions_namechangekeyrollover) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_icao_extensions] branch:@"1"] retain];
            }
            _id_icao_extensions_namechangekeyrollover = [branchObj retain];
        }
    }
    return _id_icao_extensions_namechangekeyrollover;
}

@end
