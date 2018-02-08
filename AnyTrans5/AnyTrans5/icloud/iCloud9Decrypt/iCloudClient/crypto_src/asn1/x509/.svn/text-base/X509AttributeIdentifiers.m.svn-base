//
//  X509AttributeIdentifiers.m
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X509AttributeIdentifiers.h"
#import "X509ObjectIdentifiers.h"

@implementation X509AttributeIdentifiers

+ (ASN1ObjectIdentifier *)RoleSyntax {
    static ASN1ObjectIdentifier *_RoleSyntax = nil;
    @synchronized(self) {
        if (!_RoleSyntax) {
            _RoleSyntax = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.72"];
        }
    }
    return _RoleSyntax;
}

+ (ASN1ObjectIdentifier *)id_pe_ac_auditIdentity {
    static ASN1ObjectIdentifier *_id_pe_ac_auditIdentity = nil;
    @synchronized(self) {
        if (!_id_pe_ac_auditIdentity) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[X509ObjectIdentifiers id_pe] branch:@"4"] retain];
            }
            _id_pe_ac_auditIdentity = [branchObj retain];
        }
    }
    return _id_pe_ac_auditIdentity;
}

+ (ASN1ObjectIdentifier *)id_pe_aaControls {
    static ASN1ObjectIdentifier *_id_pe_aaControls = nil;
    @synchronized(self) {
        if (!_id_pe_aaControls) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[X509ObjectIdentifiers id_pe] branch:@"6"] retain];
            }
            _id_pe_aaControls = [branchObj retain];
        }
    }
    return _id_pe_aaControls;
}

+ (ASN1ObjectIdentifier *)id_pe_ac_proxying {
    static ASN1ObjectIdentifier *_id_pe_ac_proxying = nil;
    @synchronized(self) {
        if (!_id_pe_ac_proxying) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[X509ObjectIdentifiers id_pe] branch:@"10"] retain];
            }
            _id_pe_ac_proxying = [branchObj retain];
        }
    }
    return _id_pe_ac_proxying;
}

+ (ASN1ObjectIdentifier *)id_ce_targetInformation {
    static ASN1ObjectIdentifier *_id_ce_targetInformation = nil;
    @synchronized(self) {
        if (!_id_ce_targetInformation) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[X509ObjectIdentifiers id_ce] branch:@"55"] retain];
            }
            _id_ce_targetInformation = [branchObj retain];
        }
    }
    return _id_ce_targetInformation;
}

+ (ASN1ObjectIdentifier *)id_aca {
    static ASN1ObjectIdentifier *_id_aca = nil;
    @synchronized(self) {
        if (!_id_aca) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[X509ObjectIdentifiers id_pkix] branch:@"10"] retain];
            }
            _id_aca = [branchObj retain];
        }
    }
    return _id_aca;
}

+ (ASN1ObjectIdentifier *)id_aca_authenticationInfo {
    static ASN1ObjectIdentifier *_id_aca_authenticationInfo = nil;
    @synchronized(self) {
        if (!_id_aca_authenticationInfo) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aca] branch:@"1"] retain];
            }
            _id_aca_authenticationInfo = [branchObj retain];
        }
    }
    return _id_aca_authenticationInfo;
}

+ (ASN1ObjectIdentifier *)id_aca_accessIdentity {
    static ASN1ObjectIdentifier *_id_aca_accessIdentity = nil;
    @synchronized(self) {
        if (!_id_aca_accessIdentity) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aca] branch:@"2"] retain];
            }
            _id_aca_accessIdentity = [branchObj retain];
        }
    }
    return _id_aca_accessIdentity;
}

+ (ASN1ObjectIdentifier *)id_aca_chargingIdentity {
    static ASN1ObjectIdentifier *_id_aca_chargingIdentity = nil;
    @synchronized(self) {
        if (!_id_aca_chargingIdentity) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aca] branch:@"3"] retain];
            }
            _id_aca_chargingIdentity = [branchObj retain];
        }
    }
    return _id_aca_chargingIdentity;
}

+ (ASN1ObjectIdentifier *)id_aca_group {
    static ASN1ObjectIdentifier *_id_aca_group = nil;
    @synchronized(self) {
        if (!_id_aca_group) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aca] branch:@"4"] retain];
            }
            _id_aca_group = [branchObj retain];
        }
    }
    return _id_aca_group;
}

+ (ASN1ObjectIdentifier *)id_aca_encAttrs {
    static ASN1ObjectIdentifier *_id_aca_encAttrs = nil;
    @synchronized(self) {
        if (!_id_aca_encAttrs) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aca] branch:@"6"] retain];
            }
            _id_aca_encAttrs = [branchObj retain];
        }
    }
    return _id_aca_encAttrs;
}

+ (ASN1ObjectIdentifier *)id_at_role {
    static ASN1ObjectIdentifier *_id_at_role = nil;
    @synchronized(self) {
        if (!_id_at_role) {
            _id_at_role = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.4.72"];
        }
    }
    return _id_at_role;
}

+ (ASN1ObjectIdentifier *)id_at_clearance {
    static ASN1ObjectIdentifier *_id_at_clearance = nil;
    @synchronized(self) {
        if (!_id_at_clearance) {
            _id_at_clearance = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.1.5.55"];
        }
    }
    return _id_at_clearance;
}

@end
