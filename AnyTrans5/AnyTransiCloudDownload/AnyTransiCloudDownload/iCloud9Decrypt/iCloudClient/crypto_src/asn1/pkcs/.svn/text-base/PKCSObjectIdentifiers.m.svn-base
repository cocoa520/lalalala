//
//  PKCSObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKCSObjectIdentifiers.h"

@implementation PKCSObjectIdentifiers

+ (ASN1ObjectIdentifier *)pkcs_1 {
    static ASN1ObjectIdentifier *_id_pkix = nil;
    @synchronized(self) {
        if (!_id_pkix) {
            _id_pkix = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7"];
        }
    }
    return _id_pkix;
}

+ (ASN1ObjectIdentifier *)rsaEncryption {
    static ASN1ObjectIdentifier *_rsaEncryption = nil;
    @synchronized(self) {
        if (!_rsaEncryption) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_1] branch:@"1"] retain];
            }
            _rsaEncryption = [branchObj retain];
        }
    }
    return _rsaEncryption;
}

+ (ASN1ObjectIdentifier *)md2WithRSAEncryption {
    static ASN1ObjectIdentifier *_md2WithRSAEncryption = nil;
    @synchronized(self) {
        if (!_md2WithRSAEncryption) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_1] branch:@"2"] retain];
            }
            _md2WithRSAEncryption = [branchObj retain];
        }
    }
    return _md2WithRSAEncryption;
}

+ (ASN1ObjectIdentifier *)md4WithRSAEncryption {
    static ASN1ObjectIdentifier *_md4WithRSAEncryption = nil;
    @synchronized(self) {
        if (!_md4WithRSAEncryption) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_1] branch:@"3"] retain];
            }
            _md4WithRSAEncryption = [branchObj retain];
        }
    }
    return _md4WithRSAEncryption;
}

+ (ASN1ObjectIdentifier *)md5WithRSAEncryption {
    static ASN1ObjectIdentifier *_md5WithRSAEncryption = nil;
    @synchronized(self) {
        if (!_md5WithRSAEncryption) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_1] branch:@"4"] retain];
            }
            _md5WithRSAEncryption = [branchObj retain];
        }
    }
    return _md5WithRSAEncryption;
}

+ (ASN1ObjectIdentifier *)sha1WithRSAEncryption {
    static ASN1ObjectIdentifier *_sha1WithRSAEncryption = nil;
    @synchronized(self) {
        if (!_sha1WithRSAEncryption) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_1] branch:@"5"] retain];
            }
            _sha1WithRSAEncryption = [branchObj retain];
        }
    }
    return _sha1WithRSAEncryption;
}

+ (ASN1ObjectIdentifier *)srsaOAEPEncryptionSET {
    static ASN1ObjectIdentifier *_srsaOAEPEncryptionSET = nil;
    @synchronized(self) {
        if (!_srsaOAEPEncryptionSET) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_1] branch:@"6"] retain];
            }
            _srsaOAEPEncryptionSET = [branchObj retain];
        }
    }
    return _srsaOAEPEncryptionSET;
}

+ (ASN1ObjectIdentifier *)id_RSAES_OAEP {
    static ASN1ObjectIdentifier *_id_RSAES_OAEP = nil;
    @synchronized(self) {
        if (!_id_RSAES_OAEP) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_1] branch:@"7"] retain];
            }
            _id_RSAES_OAEP = [branchObj retain];
        }
    }
    return _id_RSAES_OAEP;
}

+ (ASN1ObjectIdentifier *)id_mgf1 {
    static ASN1ObjectIdentifier *_id_mgf1 = nil;
    @synchronized(self) {
        if (!_id_mgf1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_1] branch:@"8"] retain];
            }
            _id_mgf1 = [branchObj retain];
        }
    }
    return _id_mgf1;
}

+ (ASN1ObjectIdentifier *)id_pSpecified {
    static ASN1ObjectIdentifier *_id_pSpecified = nil;
    @synchronized(self) {
        if (!_id_pSpecified) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_1] branch:@"9"] retain];
            }
            _id_pSpecified = [branchObj retain];
        }
    }
    return _id_pSpecified;
}

+ (ASN1ObjectIdentifier *)id_RSASSA_PSS {
    static ASN1ObjectIdentifier *_id_RSASSA_PSS = nil;
    @synchronized(self) {
        if (!_id_RSASSA_PSS) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_1] branch:@"10"] retain];
            }
            _id_RSASSA_PSS = [branchObj retain];
        }
    }
    return _id_RSASSA_PSS;
}

+ (ASN1ObjectIdentifier *)sha256WithRSAEncryption {
    static ASN1ObjectIdentifier *_sha256WithRSAEncryption = nil;
    @synchronized(self) {
        if (!_sha256WithRSAEncryption) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_1] branch:@"11"] retain];
            }
            _sha256WithRSAEncryption = [branchObj retain];
        }
    }
    return _sha256WithRSAEncryption;
}

+ (ASN1ObjectIdentifier *)sha384WithRSAEncryption {
    static ASN1ObjectIdentifier *_sha384WithRSAEncryption = nil;
    @synchronized(self) {
        if (!_sha384WithRSAEncryption) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_1] branch:@"12"] retain];
            }
            _sha384WithRSAEncryption = [branchObj retain];
        }
    }
    return _sha384WithRSAEncryption;
}

+ (ASN1ObjectIdentifier *)sha512WithRSAEncryption {
    static ASN1ObjectIdentifier *_sha512WithRSAEncryption = nil;
    @synchronized(self) {
        if (!_sha512WithRSAEncryption) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_1] branch:@"13"] retain];
            }
            _sha512WithRSAEncryption = [branchObj retain];
        }
    }
    return _sha512WithRSAEncryption;
}

+ (ASN1ObjectIdentifier *)sha224WithRSAEncryption {
    static ASN1ObjectIdentifier *_sha224WithRSAEncryption = nil;
    @synchronized(self) {
        if (!_sha224WithRSAEncryption) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_1] branch:@"14"] retain];
            }
            _sha224WithRSAEncryption = [branchObj retain];
        }
    }
    return _sha224WithRSAEncryption;
}

+ (ASN1ObjectIdentifier *)pkcs_3 {
    static ASN1ObjectIdentifier *_pkcs_3 = nil;
    @synchronized(self) {
        if (!_pkcs_3) {
            _pkcs_3 = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.3"];
        }
    }
    return _pkcs_3;
}

+ (ASN1ObjectIdentifier *)dhKeyAgreement {
    static ASN1ObjectIdentifier *_dhKeyAgreement = nil;
    @synchronized(self) {
        if (!_dhKeyAgreement) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_3] branch:@"1"] retain];
            }
            _dhKeyAgreement = [branchObj retain];
        }
    }
    return _dhKeyAgreement;
}

+ (ASN1ObjectIdentifier *)pkcs_5 {
    static ASN1ObjectIdentifier *_pkcs_5 = nil;
    @synchronized(self) {
        if (!_pkcs_5) {
            _pkcs_5 = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.5"];
        }
    }
    return _pkcs_5;
}

+ (ASN1ObjectIdentifier *)pbeWithMD2AndDES_CBC {
    static ASN1ObjectIdentifier *_pbeWithMD2AndDES_CBC = nil;
    @synchronized(self) {
        if (!_pbeWithMD2AndDES_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_5] branch:@"1"] retain];
            }
            _pbeWithMD2AndDES_CBC = [branchObj retain];
        }
    }
    return _pbeWithMD2AndDES_CBC;
}

+ (ASN1ObjectIdentifier *)pbeWithMD2AndRC2_CBC {
    static ASN1ObjectIdentifier *_pbeWithMD2AndRC2_CBC = nil;
    @synchronized(self) {
        if (!_pbeWithMD2AndRC2_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_5] branch:@"4"] retain];
            }
            _pbeWithMD2AndRC2_CBC = [branchObj retain];
        }
    }
    return _pbeWithMD2AndRC2_CBC;
}

+ (ASN1ObjectIdentifier *)pbeWithMD5AndDES_CBC {
    static ASN1ObjectIdentifier *_pbeWithMD5AndDES_CBC = nil;
    @synchronized(self) {
        if (!_pbeWithMD5AndDES_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_5] branch:@"3"] retain];
            }
            _pbeWithMD5AndDES_CBC = [branchObj retain];
        }
    }
    return _pbeWithMD5AndDES_CBC;
}

+ (ASN1ObjectIdentifier *)pbeWithMD5AndRC2_CBC {
    static ASN1ObjectIdentifier *_pbeWithMD5AndRC2_CBC = nil;
    @synchronized(self) {
        if (!_pbeWithMD5AndRC2_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_5] branch:@"6"] retain];
            }
            _pbeWithMD5AndRC2_CBC = [branchObj retain];
        }
    }
    return _pbeWithMD5AndRC2_CBC;
}

+ (ASN1ObjectIdentifier *)pbeWithSHA1AndDES_CBC {
    static ASN1ObjectIdentifier *_pbeWithSHA1AndDES_CBC = nil;
    @synchronized(self) {
        if (!_pbeWithSHA1AndDES_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_5] branch:@"10"] retain];
            }
            _pbeWithSHA1AndDES_CBC = [branchObj retain];
        }
    }
    return _pbeWithSHA1AndDES_CBC;
}

+ (ASN1ObjectIdentifier *)pbeWithSHA1AndRC2_CBC {
    static ASN1ObjectIdentifier *_pbeWithSHA1AndRC2_CBC = nil;
    @synchronized(self) {
        if (!_pbeWithSHA1AndRC2_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_5] branch:@"11"] retain];
            }
            _pbeWithSHA1AndRC2_CBC = [branchObj retain];
        }
    }
    return _pbeWithSHA1AndRC2_CBC;
}

+ (ASN1ObjectIdentifier *)id_PBES2 {
    static ASN1ObjectIdentifier *_id_PBES2 = nil;
    @synchronized(self) {
        if (!_id_PBES2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_5] branch:@"13"] retain];
            }
            _id_PBES2 = [branchObj retain];
        }
    }
    return _id_PBES2;
}

+ (ASN1ObjectIdentifier *)id_PBKDF2 {
    static ASN1ObjectIdentifier *_id_PBKDF2 = nil;
    @synchronized(self) {
        if (!_id_PBKDF2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_5] branch:@"12"] retain];
            }
            _id_PBKDF2 = [branchObj retain];
        }
    }
    return _id_PBKDF2;
}

+ (ASN1ObjectIdentifier *)encryptionAlgorithm {
    static ASN1ObjectIdentifier *_encryptionAlgorithm = nil;
    @synchronized(self) {
        if (!_encryptionAlgorithm) {
            _encryptionAlgorithm = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.3"];
        }
    }
    return _encryptionAlgorithm;
}

+ (ASN1ObjectIdentifier *)des_EDE3_CBC {
    static ASN1ObjectIdentifier *_des_EDE3_CBC = nil;
    @synchronized(self) {
        if (!_des_EDE3_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self encryptionAlgorithm] branch:@"7"] retain];
            }
            _des_EDE3_CBC = [branchObj retain];
        }
    }
    return _des_EDE3_CBC;
}

+ (ASN1ObjectIdentifier *)RC2_CBC {
    static ASN1ObjectIdentifier *_RC2_CBC = nil;
    @synchronized(self) {
        if (!_RC2_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self encryptionAlgorithm] branch:@"2"] retain];
            }
            _RC2_CBC = [branchObj retain];
        }
    }
    return _RC2_CBC;
}

+ (ASN1ObjectIdentifier *)rc4 {
    static ASN1ObjectIdentifier *_rc4 = nil;
    @synchronized(self) {
        if (!_rc4) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self encryptionAlgorithm] branch:@"4"] retain];
            }
            _rc4 = [branchObj retain];
        }
    }
    return _rc4;
}

+ (ASN1ObjectIdentifier *)digestAlgorithm {
    static ASN1ObjectIdentifier *_digestAlgorithm = nil;
    @synchronized(self) {
        if (!_digestAlgorithm) {
            _digestAlgorithm = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.2"];
        }
    }
    return _digestAlgorithm;
}

+ (ASN1ObjectIdentifier *)md2 {
    static ASN1ObjectIdentifier *_md2 = nil;
    @synchronized(self) {
        if (!_md2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self digestAlgorithm] branch:@"2"] retain];
            }
            _md2 = [branchObj retain];
        }
    }
    return _md2;
}

+ (ASN1ObjectIdentifier *)md4 {
    static ASN1ObjectIdentifier *_md4 = nil;
    @synchronized(self) {
        if (!_md4) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self digestAlgorithm] branch:@"4"] retain];
            }
            _md4 = [branchObj retain];
        }
    }
    return _md4;
}

+ (ASN1ObjectIdentifier *)md5 {
    static ASN1ObjectIdentifier *_md5 = nil;
    @synchronized(self) {
        if (!_md5) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self digestAlgorithm] branch:@"5"] retain];
            }
            _md5 = [branchObj retain];
        }
    }
    return _md5;
}

+ (ASN1ObjectIdentifier *)id_hmacWithSHA1 {
    static ASN1ObjectIdentifier *_id_hmacWithSHA1 = nil;
    @synchronized(self) {
        if (!_id_hmacWithSHA1) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self digestAlgorithm] branch:@"2"] retain];
            }
            _id_hmacWithSHA1 = [[branchObj intern] retain];
        }
    }
    return _id_hmacWithSHA1;
}

+ (ASN1ObjectIdentifier *)id_hmacWithSHA224 {
    static ASN1ObjectIdentifier *_id_hmacWithSHA224 = nil;
    @synchronized(self) {
        if (!_id_hmacWithSHA224) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self digestAlgorithm] branch:@"8"] retain];
            }
            _id_hmacWithSHA224 = [[branchObj intern] retain];
        }
    }
    return _id_hmacWithSHA224;
}

+ (ASN1ObjectIdentifier *)id_hmacWithSHA256 {
    static ASN1ObjectIdentifier *_id_hmacWithSHA256 = nil;
    @synchronized(self) {
        if (!_id_hmacWithSHA256) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self digestAlgorithm] branch:@"9"] retain];
            }
            _id_hmacWithSHA256 = [[branchObj intern] retain];
        }
    }
    return _id_hmacWithSHA256;
}

+ (ASN1ObjectIdentifier *)id_hmacWithSHA384 {
    static ASN1ObjectIdentifier *_id_hmacWithSHA384 = nil;
    @synchronized(self) {
        if (!_id_hmacWithSHA384) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self digestAlgorithm] branch:@"10"] retain];
            }
            _id_hmacWithSHA384 = [[branchObj intern] retain];
        }
    }
    return _id_hmacWithSHA384;
}

+ (ASN1ObjectIdentifier *)id_hmacWithSHA512 {
    static ASN1ObjectIdentifier *_id_hmacWithSHA512 = nil;
    @synchronized(self) {
        if (!_id_hmacWithSHA512) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self digestAlgorithm] branch:@"11"] retain];
            }
            _id_hmacWithSHA512 = [[branchObj intern] retain];
        }
    }
    return _id_hmacWithSHA512;
}

+ (ASN1ObjectIdentifier *)pkcs_7 {
    static ASN1ObjectIdentifier *_pkcs_7 = nil;
    @synchronized(self) {
        if (!_pkcs_7) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.7"];
            _pkcs_7 = [[obj intern] retain];
#if !__has_feature(objc_arc)
    if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _pkcs_7;
}

+ (ASN1ObjectIdentifier *)data {
    static ASN1ObjectIdentifier *_data = nil;
    @synchronized(self) {
        if (!_data) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.7.1"];
            _data = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _data;
}

+ (ASN1ObjectIdentifier *)signedData {
    static ASN1ObjectIdentifier *_signedData = nil;
    @synchronized(self) {
        if (!_signedData) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.7.2"];
            _signedData = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _signedData;
}

+ (ASN1ObjectIdentifier *)envelopedData {
    static ASN1ObjectIdentifier *_envelopedData = nil;
    @synchronized(self) {
        if (!_envelopedData) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.7.3"];
            _envelopedData = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _envelopedData;
}

+ (ASN1ObjectIdentifier *)signedAndEnvelopedData {
    static ASN1ObjectIdentifier *_signedAndEnvelopedData = nil;
    @synchronized(self) {
        if (!_signedAndEnvelopedData) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.7.4"];
            _signedAndEnvelopedData = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _signedAndEnvelopedData;
}

+ (ASN1ObjectIdentifier *)digestedData {
    static ASN1ObjectIdentifier *_digestedData = nil;
    @synchronized(self) {
        if (!_digestedData) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.7.5"];
            _digestedData = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _digestedData;
}

+ (ASN1ObjectIdentifier *)encryptedData {
    static ASN1ObjectIdentifier *_encryptedData = nil;
    @synchronized(self) {
        if (!_encryptedData) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.7.6"];
            _encryptedData = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _encryptedData;
}

+ (ASN1ObjectIdentifier *)pkcs_9 {
    static ASN1ObjectIdentifier *_pkcs_9 = nil;
    @synchronized(self) {
        if (!_pkcs_9) {
            _pkcs_9 = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.9"];
        }
    }
    return _pkcs_9;
}

+ (ASN1ObjectIdentifier *)pkcs_9_at_emailAddress {
    static ASN1ObjectIdentifier *_pkcs_9_at_emailAddress = nil;
    @synchronized(self) {
        if (!_pkcs_9_at_emailAddress) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"1"] retain];
            }
            _pkcs_9_at_emailAddress = [[branchObj intern] retain];
        }
    }
    return _pkcs_9_at_emailAddress;
}

+ (ASN1ObjectIdentifier *)pkcs_9_at_unstructuredName {
    static ASN1ObjectIdentifier *_pkcs_9_at_unstructuredName = nil;
    @synchronized(self) {
        if (!_pkcs_9_at_unstructuredName) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"2"] retain];
            }
            _pkcs_9_at_unstructuredName = [[branchObj intern] retain];
        }
    }
    return _pkcs_9_at_unstructuredName;
}

+ (ASN1ObjectIdentifier *)pkcs_9_at_contentType {
    static ASN1ObjectIdentifier *_pkcs_9_at_contentType = nil;
    @synchronized(self) {
        if (!_pkcs_9_at_contentType) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"3"] retain];
            }
            _pkcs_9_at_contentType = [[branchObj intern] retain];
        }
    }
    return _pkcs_9_at_contentType;
}

+ (ASN1ObjectIdentifier *)pkcs_9_at_messageDigest {
    static ASN1ObjectIdentifier *_pkcs_9_at_messageDigest = nil;
    @synchronized(self) {
        if (!_pkcs_9_at_messageDigest) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"4"] retain];
            }
            _pkcs_9_at_messageDigest = [[branchObj intern] retain];
        }
    }
    return _pkcs_9_at_messageDigest;
}

+ (ASN1ObjectIdentifier *)pkcs_9_at_signingTime {
    static ASN1ObjectIdentifier *_pkcs_9_at_signingTime = nil;
    @synchronized(self) {
        if (!_pkcs_9_at_signingTime) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"5"] retain];
            }
            _pkcs_9_at_signingTime = [[branchObj intern] retain];
        }
    }
    return _pkcs_9_at_signingTime;
}

+ (ASN1ObjectIdentifier *)pkcs_9_at_counterSignature {
    static ASN1ObjectIdentifier *_pkcs_9_at_counterSignature = nil;
    @synchronized(self) {
        if (!_pkcs_9_at_counterSignature) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"6"] retain];
            }
            _pkcs_9_at_counterSignature = [[branchObj intern] retain];
        }
    }
    return _pkcs_9_at_counterSignature;
}

+ (ASN1ObjectIdentifier *)pkcs_9_at_challengePassword {
    static ASN1ObjectIdentifier *_pkcs_9_at_challengePassword = nil;
    @synchronized(self) {
        if (!_pkcs_9_at_challengePassword) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"7"] retain];
            }
            _pkcs_9_at_challengePassword = [[branchObj intern] retain];
        }
    }
    return _pkcs_9_at_challengePassword;
}

+ (ASN1ObjectIdentifier *)pkcs_9_at_unstructuredAddress {
    static ASN1ObjectIdentifier *_pkcs_9_at_unstructuredAddress = nil;
    @synchronized(self) {
        if (!_pkcs_9_at_unstructuredAddress) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"8"] retain];
            }
            _pkcs_9_at_unstructuredAddress = [[branchObj intern] retain];
        }
    }
    return _pkcs_9_at_unstructuredAddress;
}

+ (ASN1ObjectIdentifier *)pkcs_9_at_extendedCertificateAttributes {
    static ASN1ObjectIdentifier *_pkcs_9_at_extendedCertificateAttributes = nil;
    @synchronized(self) {
        if (!_pkcs_9_at_extendedCertificateAttributes) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"9"] retain];
            }
            _pkcs_9_at_extendedCertificateAttributes = [[branchObj intern] retain];
        }
    }
    return _pkcs_9_at_extendedCertificateAttributes;
}

+ (ASN1ObjectIdentifier *)pkcs_9_at_signingDescription {
    static ASN1ObjectIdentifier *_pkcs_9_at_signingDescription = nil;
    @synchronized(self) {
        if (!_pkcs_9_at_signingDescription) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"13"] retain];
            }
            _pkcs_9_at_signingDescription = [[branchObj intern] retain];
        }
    }
    return _pkcs_9_at_signingDescription;
}

+ (ASN1ObjectIdentifier *)pkcs_9_at_extensionRequest {
    static ASN1ObjectIdentifier *_pkcs_9_at_extensionRequest = nil;
    @synchronized(self) {
        if (!_pkcs_9_at_extensionRequest) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"14"] retain];
            }
            _pkcs_9_at_extensionRequest = [[branchObj intern] retain];
        }
    }
    return _pkcs_9_at_extensionRequest;
}

+ (ASN1ObjectIdentifier *)pkcs_9_at_smimeCapabilities {
    static ASN1ObjectIdentifier *_pkcs_9_at_smimeCapabilities = nil;
    @synchronized(self) {
        if (!_pkcs_9_at_smimeCapabilities) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"15"] retain];
            }
            _pkcs_9_at_smimeCapabilities = [[branchObj intern] retain];
        }
    }
    return _pkcs_9_at_smimeCapabilities;
}

+ (ASN1ObjectIdentifier *)id_smime {
    static ASN1ObjectIdentifier *_id_smime = nil;
    @synchronized(self) {
        if (!_id_smime) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"16"] retain];
            }
            _id_smime = [[branchObj intern] retain];
        }
    }
    return _id_smime;
}

+ (ASN1ObjectIdentifier *)pkcs_9_at_friendlyName {
    static ASN1ObjectIdentifier *_pkcs_9_at_friendlyName = nil;
    @synchronized(self) {
        if (!_pkcs_9_at_friendlyName) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"20"] retain];
            }
            _pkcs_9_at_friendlyName = [[branchObj intern] retain];
        }
    }
    return _pkcs_9_at_friendlyName;
}

+ (ASN1ObjectIdentifier *)pkcs_9_at_localKeyId {
    static ASN1ObjectIdentifier *_pkcs_9_at_localKeyId = nil;
    @synchronized(self) {
        if (!_pkcs_9_at_localKeyId) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"21"] retain];
            }
            _pkcs_9_at_localKeyId = [[branchObj intern] retain];
        }
    }
    return _pkcs_9_at_localKeyId;
}


+ (ASN1ObjectIdentifier *)x509certType {
    static ASN1ObjectIdentifier *_x509certType = nil;
    @synchronized(self) {
        if (!_x509certType) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"22.1"] retain];
            }
            _x509certType = [branchObj retain];
        }
    }
    return _x509certType;
}

+ (ASN1ObjectIdentifier *)certTypes {
    static ASN1ObjectIdentifier *_certTypes = nil;
    @synchronized(self) {
        if (!_certTypes) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"22"] retain];
            }
            _certTypes = [branchObj retain];
        }
    }
    return _certTypes;
}

+ (ASN1ObjectIdentifier *)x509Certificate {
    static ASN1ObjectIdentifier *_x509Certificate = nil;
    @synchronized(self) {
        if (!_x509Certificate) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self certTypes] branch:@"1"] retain];
            }
            _x509Certificate = [[branchObj intern] retain];
        }
    }
    return _x509Certificate;
}

+ (ASN1ObjectIdentifier *)sdsiCertificate {
    static ASN1ObjectIdentifier *_sdsiCertificate = nil;
    @synchronized(self) {
        if (!_sdsiCertificate) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self certTypes] branch:@"2"] retain];
            }
            _sdsiCertificate = [[branchObj intern] retain];
        }
    }
    return _sdsiCertificate;
}

+ (ASN1ObjectIdentifier *)crlTypes {
    static ASN1ObjectIdentifier *_crlTypes = nil;
    @synchronized(self) {
        if (!_crlTypes) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"23"] retain];
            }
            _crlTypes = [branchObj retain];
        }
    }
    return _crlTypes;
}

+ (ASN1ObjectIdentifier *)x509Crl {
    static ASN1ObjectIdentifier *_x509Crl = nil;
    @synchronized(self) {
        if (!_x509Crl) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self crlTypes] branch:@"1"] retain];
            }
            _x509Crl = [[branchObj intern] retain];
        }
    }
    return _x509Crl;
}

+ (ASN1ObjectIdentifier *)id_aa_cmsAlgorithmProtect {
    static ASN1ObjectIdentifier *_id_aa_cmsAlgorithmProtect = nil;
    @synchronized(self) {
        if (!_id_aa_cmsAlgorithmProtect) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"52"] retain];
            }
            _id_aa_cmsAlgorithmProtect = [[branchObj intern] retain];
        }
    }
    return _id_aa_cmsAlgorithmProtect;
}

+ (ASN1ObjectIdentifier *)preferSignedData {
    static ASN1ObjectIdentifier *_preferSignedData = nil;
    @synchronized(self) {
        if (!_preferSignedData) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"15.1"] retain];
            }
            _preferSignedData = [branchObj retain];
        }
    }
    return _preferSignedData;
}

+ (ASN1ObjectIdentifier *)canNotDecryptAny {
    static ASN1ObjectIdentifier *_canNotDecryptAny = nil;
    @synchronized(self) {
        if (!_canNotDecryptAny) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"15.2"] retain];
            }
            _canNotDecryptAny = [branchObj retain];
        }
    }
    return _canNotDecryptAny;
}

+ (ASN1ObjectIdentifier *)sMIMECapabilitiesVersions {
    static ASN1ObjectIdentifier *_sMIMECapabilitiesVersions = nil;
    @synchronized(self) {
        if (!_sMIMECapabilitiesVersions) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_9] branch:@"15.3"] retain];
            }
            _sMIMECapabilitiesVersions = [branchObj retain];
        }
    }
    return _sMIMECapabilitiesVersions;
}

+ (ASN1ObjectIdentifier *)id_ct {
    static ASN1ObjectIdentifier *_id_ct = nil;
    @synchronized(self) {
        if (!_id_ct) {
            _id_ct = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.9.16.1"];
        }
    }
    return _id_ct;
}

+ (ASN1ObjectIdentifier *)id_ct_authData {
    static ASN1ObjectIdentifier *_id_ct_authData = nil;
    @synchronized(self) {
        if (!_id_ct_authData) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_ct] branch:@"2"] retain];
            }
            _id_ct_authData = [branchObj retain];
        }
    }
    return _id_ct_authData;
}

+ (ASN1ObjectIdentifier *)id_ct_TSTInfo {
    static ASN1ObjectIdentifier *_id_ct_TSTInfo = nil;
    @synchronized(self) {
        if (!_id_ct_TSTInfo) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_ct] branch:@"4"] retain];
            }
            _id_ct_TSTInfo = [branchObj retain];
        }
    }
    return _id_ct_TSTInfo;
}

+ (ASN1ObjectIdentifier *)id_ct_compressedData {
    static ASN1ObjectIdentifier *_id_ct_compressedData = nil;
    @synchronized(self) {
        if (!_id_ct_compressedData) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_ct] branch:@"9"] retain];
            }
            _id_ct_compressedData = [branchObj retain];
        }
    }
    return _id_ct_compressedData;
}

+ (ASN1ObjectIdentifier *)id_ct_authEnvelopedData {
    static ASN1ObjectIdentifier *_id_ct_authEnvelopedData = nil;
    @synchronized(self) {
        if (!_id_ct_authEnvelopedData) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_ct] branch:@"23"] retain];
            }
            _id_ct_authEnvelopedData = [branchObj retain];
        }
    }
    return _id_ct_authEnvelopedData;
}

+ (ASN1ObjectIdentifier *)id_ct_timestampedData {
    static ASN1ObjectIdentifier *_id_ct_timestampedData = nil;
    @synchronized(self) {
        if (!_id_ct_timestampedData) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_ct] branch:@"31"] retain];
            }
            _id_ct_timestampedData = [branchObj retain];
        }
    }
    return _id_ct_timestampedData;
}

+ (ASN1ObjectIdentifier *)id_alg {
    static ASN1ObjectIdentifier *_id_alg = nil;
    @synchronized(self) {
        if (!_id_alg) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_smime] branch:@"3"] retain];
            }
            _id_alg = [branchObj retain];
        }
    }
    return _id_alg;
}

+ (ASN1ObjectIdentifier *)id_alg_PWRI_KEK {
    static ASN1ObjectIdentifier *_id_alg_PWRI_KEK = nil;
    @synchronized(self) {
        if (!_id_alg_PWRI_KEK) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_alg] branch:@"9"] retain];
            }
            _id_alg_PWRI_KEK = [branchObj retain];
        }
    }
    return _id_alg_PWRI_KEK;
}

+ (ASN1ObjectIdentifier *)id_rsa_KEM {
    static ASN1ObjectIdentifier *_id_rsa_KEM = nil;
    @synchronized(self) {
        if (!_id_rsa_KEM) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_alg] branch:@"14"] retain];
            }
            _id_rsa_KEM = [branchObj retain];
        }
    }
    return _id_rsa_KEM;
}

+ (ASN1ObjectIdentifier *)id_cti {
    static ASN1ObjectIdentifier *_id_cti = nil;
    @synchronized(self) {
        if (!_id_cti) {
            _id_cti = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.9.16.6"];
        }
    }
    return _id_cti;
}

+ (ASN1ObjectIdentifier *)id_cti_ets_proofOfOrigin {
    static ASN1ObjectIdentifier *_id_cti_ets_proofOfOrigin = nil;
    @synchronized(self) {
        if (!_id_cti_ets_proofOfOrigin) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_cti] branch:@"1"] retain];
            }
            _id_cti_ets_proofOfOrigin = [branchObj retain];
        }
    }
    return _id_cti_ets_proofOfOrigin;
}

+ (ASN1ObjectIdentifier *)id_cti_ets_proofOfReceipt {
    static ASN1ObjectIdentifier *_id_cti_ets_proofOfReceipt = nil;
    @synchronized(self) {
        if (!_id_cti_ets_proofOfReceipt) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_cti] branch:@"2"] retain];
            }
            _id_cti_ets_proofOfReceipt = [branchObj retain];
        }
    }
    return _id_cti_ets_proofOfReceipt;
}

+ (ASN1ObjectIdentifier *)id_cti_ets_proofOfDelivery {
    static ASN1ObjectIdentifier *_id_cti_ets_proofOfDelivery = nil;
    @synchronized(self) {
        if (!_id_cti_ets_proofOfDelivery) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_cti] branch:@"3"] retain];
            }
            _id_cti_ets_proofOfDelivery = [branchObj retain];
        }
    }
    return _id_cti_ets_proofOfDelivery;
}

+ (ASN1ObjectIdentifier *)id_cti_ets_proofOfSender {
    static ASN1ObjectIdentifier *_id_cti_ets_proofOfSender = nil;
    @synchronized(self) {
        if (!_id_cti_ets_proofOfSender) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_cti] branch:@"4"] retain];
            }
            _id_cti_ets_proofOfSender = [branchObj retain];
        }
    }
    return _id_cti_ets_proofOfSender;
}

+ (ASN1ObjectIdentifier *)id_cti_ets_proofOfApproval {
    static ASN1ObjectIdentifier *_id_cti_ets_proofOfApproval = nil;
    @synchronized(self) {
        if (!_id_cti_ets_proofOfApproval) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_cti] branch:@"5"] retain];
            }
            _id_cti_ets_proofOfApproval = [branchObj retain];
        }
    }
    return _id_cti_ets_proofOfApproval;
}

+ (ASN1ObjectIdentifier *)id_cti_ets_proofOfCreation {
    static ASN1ObjectIdentifier *_id_cti_ets_proofOfCreation = nil;
    @synchronized(self) {
        if (!_id_cti_ets_proofOfCreation) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_cti] branch:@"6"] retain];
            }
            _id_cti_ets_proofOfCreation = [branchObj retain];
        }
    }
    return _id_cti_ets_proofOfCreation;
}

+ (ASN1ObjectIdentifier *)id_aa {
    static ASN1ObjectIdentifier *_id_aa = nil;
    @synchronized(self) {
        if (!_id_aa) {
            _id_aa = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.9.16.2"];
        }
    }
    return _id_aa;
}

+ (ASN1ObjectIdentifier *)id_aa_receiptRequest {
    static ASN1ObjectIdentifier *_id_aa_receiptRequest = nil;
    @synchronized(self) {
        if (!_id_aa_receiptRequest) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"1"] retain];
            }
            _id_aa_receiptRequest = [branchObj retain];
        }
    }
    return _id_aa_receiptRequest;
}

+ (ASN1ObjectIdentifier *)id_aa_contentHint {
    static ASN1ObjectIdentifier *_id_aa_contentHint = nil;
    @synchronized(self) {
        if (!_id_aa_contentHint) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"4"] retain];
            }
            _id_aa_contentHint = [branchObj retain];
        }
    }
    return _id_aa_contentHint;
}

+ (ASN1ObjectIdentifier *)id_aa_msgSigDigest {
    static ASN1ObjectIdentifier *_id_aa_msgSigDigest = nil;
    @synchronized(self) {
        if (!_id_aa_msgSigDigest) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"5"] retain];
            }
            _id_aa_msgSigDigest = [branchObj retain];
        }
    }
    return _id_aa_msgSigDigest;
}

+ (ASN1ObjectIdentifier *)id_aa_contentReference {
    static ASN1ObjectIdentifier *_id_aa_contentReference = nil;
    @synchronized(self) {
        if (!_id_aa_contentReference) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"10"] retain];
            }
            _id_aa_contentReference = [branchObj retain];
        }
    }
    return _id_aa_contentReference;
}

+ (ASN1ObjectIdentifier *)id_aa_encrypKeyPref {
    static ASN1ObjectIdentifier *_id_aa_encrypKeyPref = nil;
    @synchronized(self) {
        if (!_id_aa_encrypKeyPref) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"11"] retain];
            }
            _id_aa_encrypKeyPref = [branchObj retain];
        }
    }
    return _id_aa_encrypKeyPref;
}

+ (ASN1ObjectIdentifier *)id_aa_signingCertificate {
    static ASN1ObjectIdentifier *_id_aa_signingCertificate = nil;
    @synchronized(self) {
        if (!_id_aa_signingCertificate) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"12"] retain];
            }
            _id_aa_signingCertificate = [branchObj retain];
        }
    }
    return _id_aa_signingCertificate;
}

+ (ASN1ObjectIdentifier *)id_aa_signingCertificateV2 {
    static ASN1ObjectIdentifier *_id_aa_signingCertificateV2 = nil;
    @synchronized(self) {
        if (!_id_aa_signingCertificateV2) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"47"] retain];
            }
            _id_aa_signingCertificateV2 = [branchObj retain];
        }
    }
    return _id_aa_signingCertificateV2;
}

+ (ASN1ObjectIdentifier *)id_aa_contentIdentifier {
    static ASN1ObjectIdentifier *_id_aa_contentIdentifier = nil;
    @synchronized(self) {
        if (!_id_aa_contentIdentifier) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"7"] retain];
            }
            _id_aa_contentIdentifier = [branchObj retain];
        }
    }
    return _id_aa_contentIdentifier;
}

+ (ASN1ObjectIdentifier *)id_aa_signatureTimeStampToken {
    static ASN1ObjectIdentifier *_id_aa_signatureTimeStampToken = nil;
    @synchronized(self) {
        if (!_id_aa_signatureTimeStampToken) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"14"] retain];
            }
            _id_aa_signatureTimeStampToken = [branchObj retain];
        }
    }
    return _id_aa_signatureTimeStampToken;
}

+ (ASN1ObjectIdentifier *)id_aa_ets_sigPolicyId {
    static ASN1ObjectIdentifier *_id_aa_ets_sigPolicyId = nil;
    @synchronized(self) {
        if (!_id_aa_ets_sigPolicyId) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"15"] retain];
            }
            _id_aa_ets_sigPolicyId = [branchObj retain];
        }
    }
    return _id_aa_ets_sigPolicyId;
}

+ (ASN1ObjectIdentifier *)id_aa_ets_commitmentType {
    static ASN1ObjectIdentifier *_id_aa_ets_commitmentType = nil;
    @synchronized(self) {
        if (!_id_aa_ets_commitmentType) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"16"] retain];
            }
            _id_aa_ets_commitmentType = [branchObj retain];
        }
    }
    return _id_aa_ets_commitmentType;
}

+ (ASN1ObjectIdentifier *)id_aa_ets_signerLocation {
    static ASN1ObjectIdentifier *_id_aa_ets_signerLocation = nil;
    @synchronized(self) {
        if (!_id_aa_ets_signerLocation) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"17"] retain];
            }
            _id_aa_ets_signerLocation = [branchObj retain];
        }
    }
    return _id_aa_ets_signerLocation;
}

+ (ASN1ObjectIdentifier *)id_aa_ets_signerAttr {
    static ASN1ObjectIdentifier *_id_aa_ets_signerAttr = nil;
    @synchronized(self) {
        if (!_id_aa_ets_signerAttr) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"18"] retain];
            }
            _id_aa_ets_signerAttr = [branchObj retain];
        }
    }
    return _id_aa_ets_signerAttr;
}

+ (ASN1ObjectIdentifier *)id_aa_ets_otherSigCert {
    static ASN1ObjectIdentifier *_id_aa_ets_otherSigCert = nil;
    @synchronized(self) {
        if (!_id_aa_ets_otherSigCert) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"19"] retain];
            }
            _id_aa_ets_otherSigCert = [branchObj retain];
        }
    }
    return _id_aa_ets_otherSigCert;
}

+ (ASN1ObjectIdentifier *)id_aa_ets_contentTimestamp {
    static ASN1ObjectIdentifier *_id_aa_ets_contentTimestamp = nil;
    @synchronized(self) {
        if (!_id_aa_ets_contentTimestamp) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"20"] retain];
            }
            _id_aa_ets_contentTimestamp = [branchObj retain];
        }
    }
    return _id_aa_ets_contentTimestamp;
}

+ (ASN1ObjectIdentifier *)id_aa_ets_certificateRefs {
    static ASN1ObjectIdentifier *_id_aa_ets_certificateRefs = nil;
    @synchronized(self) {
        if (!_id_aa_ets_certificateRefs) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"21"] retain];
            }
            _id_aa_ets_certificateRefs = [branchObj retain];
        }
    }
    return _id_aa_ets_certificateRefs;
}

+ (ASN1ObjectIdentifier *)id_aa_ets_revocationRefs {
    static ASN1ObjectIdentifier *_id_aa_ets_revocationRefs = nil;
    @synchronized(self) {
        if (!_id_aa_ets_revocationRefs) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"22"] retain];
            }
            _id_aa_ets_revocationRefs = [branchObj retain];
        }
    }
    return _id_aa_ets_revocationRefs;
}

+ (ASN1ObjectIdentifier *)id_aa_ets_certValues {
    static ASN1ObjectIdentifier *_id_aa_ets_certValues = nil;
    @synchronized(self) {
        if (!_id_aa_ets_certValues) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"23"] retain];
            }
            _id_aa_ets_certValues = [branchObj retain];
        }
    }
    return _id_aa_ets_certValues;
}

+ (ASN1ObjectIdentifier *)id_aa_ets_revocationValues {
    static ASN1ObjectIdentifier *_id_aa_ets_revocationValues = nil;
    @synchronized(self) {
        if (!_id_aa_ets_revocationValues) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"24"] retain];
            }
            _id_aa_ets_revocationValues = [branchObj retain];
        }
    }
    return _id_aa_ets_revocationValues;
}

+ (ASN1ObjectIdentifier *)id_aa_ets_escTimeStamp {
    static ASN1ObjectIdentifier *_id_aa_ets_escTimeStamp = nil;
    @synchronized(self) {
        if (!_id_aa_ets_escTimeStamp) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"25"] retain];
            }
            _id_aa_ets_escTimeStamp = [branchObj retain];
        }
    }
    return _id_aa_ets_escTimeStamp;
}

+ (ASN1ObjectIdentifier *)id_aa_ets_certCRLTimestamp {
    static ASN1ObjectIdentifier *_id_aa_ets_certCRLTimestamp = nil;
    @synchronized(self) {
        if (!_id_aa_ets_certCRLTimestamp) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"26"] retain];
            }
            _id_aa_ets_certCRLTimestamp = [branchObj retain];
        }
    }
    return _id_aa_ets_certCRLTimestamp;
}

+ (ASN1ObjectIdentifier *)id_aa_ets_archiveTimestamp {
    static ASN1ObjectIdentifier *_id_aa_ets_archiveTimestamp = nil;
    @synchronized(self) {
        if (!_id_aa_ets_archiveTimestamp) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self id_aa] branch:@"27"] retain];
            }
            _id_aa_ets_archiveTimestamp = [branchObj retain];
        }
    }
    return _id_aa_ets_archiveTimestamp;
}


+ (ASN1ObjectIdentifier *)id_aa_sigPolicyId {
    static ASN1ObjectIdentifier *_id_cti_ets_proofOfCreation = nil;
    @synchronized(self) {
        if (!_id_cti_ets_proofOfCreation) {
            _id_cti_ets_proofOfCreation = [[self id_aa_ets_sigPolicyId] retain];
        }
    }
    return _id_cti_ets_proofOfCreation;
}

+ (ASN1ObjectIdentifier *)id_aa_commitmentType {
    static ASN1ObjectIdentifier *_id_cti_ets_proofOfCreation = nil;
    @synchronized(self) {
        if (!_id_cti_ets_proofOfCreation) {
            _id_cti_ets_proofOfCreation = [[self id_aa_ets_commitmentType] retain];
        }
    }
    return _id_cti_ets_proofOfCreation;
}

+ (ASN1ObjectIdentifier *)id_aa_signerLocation {
    static ASN1ObjectIdentifier *_id_cti_ets_proofOfCreation = nil;
    @synchronized(self) {
        if (!_id_cti_ets_proofOfCreation) {
            _id_cti_ets_proofOfCreation = [[self id_aa_ets_signerLocation] retain];
        }
    }
    return _id_cti_ets_proofOfCreation;
}


+ (ASN1ObjectIdentifier *)id_aa_otherSigCert {
    static ASN1ObjectIdentifier *_id_cti_ets_proofOfCreation = nil;
    @synchronized(self) {
        if (!_id_cti_ets_proofOfCreation) {
            _id_cti_ets_proofOfCreation = [[self id_aa_ets_otherSigCert] retain];
        }
    }
    return _id_cti_ets_proofOfCreation;
}

+ (NSString *)id_spq {
    static NSString *_id_spq = nil;
    @synchronized(self) {
        if (!_id_spq) {
            _id_spq = [[NSString alloc] initWithString:@"1.2.840.113549.1.9.16.5"];
        }
    }
    return _id_spq;
}

+ (ASN1ObjectIdentifier *)id_spq_ets_uri {
    static ASN1ObjectIdentifier *_id_spq_ets_uri = nil;
    @synchronized(self) {
        if (!_id_spq_ets_uri) {
            _id_spq_ets_uri = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.9.16.5.1"];
        }
    }
    return _id_spq_ets_uri;
}

+ (ASN1ObjectIdentifier *)id_spq_ets_unotice {
    static ASN1ObjectIdentifier *_id_spq_ets_unotice = nil;
    @synchronized(self) {
        if (!_id_spq_ets_unotice) {
            _id_spq_ets_unotice = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.9.16.5.2"];
        }
    }
    return _id_spq_ets_unotice;
}

+ (ASN1ObjectIdentifier *)pkcs_12 {
    static ASN1ObjectIdentifier *_pkcs_12 = nil;
    @synchronized(self) {
        if (!_pkcs_12) {
            _pkcs_12 = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.12"];
        }
    }
    return _pkcs_12;
}

+ (ASN1ObjectIdentifier *)bagtypes {
    static ASN1ObjectIdentifier *_bagtypes = nil;
    @synchronized(self) {
        if (!_bagtypes) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_12] branch:@"10.1"] retain];
            }
            _bagtypes = [branchObj retain];
        }
    }
    return _bagtypes;
}

+ (ASN1ObjectIdentifier *)keyBag {
    static ASN1ObjectIdentifier *_keyBag = nil;
    @synchronized(self) {
        if (!_keyBag) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bagtypes] branch:@"1"] retain];
            }
            _keyBag = [branchObj retain];
        }
    }
    return _keyBag;
}

+ (ASN1ObjectIdentifier *)pkcs8ShroudedKeyBag {
    static ASN1ObjectIdentifier *_pkcs8ShroudedKeyBag = nil;
    @synchronized(self) {
        if (!_pkcs8ShroudedKeyBag) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bagtypes] branch:@"2"] retain];
            }
            _pkcs8ShroudedKeyBag = [branchObj retain];
        }
    }
    return _pkcs8ShroudedKeyBag;
}

+ (ASN1ObjectIdentifier *)certBag {
    static ASN1ObjectIdentifier *_certBag = nil;
    @synchronized(self) {
        if (!_certBag) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bagtypes] branch:@"3"] retain];
            }
            _certBag = [branchObj retain];
        }
    }
    return _certBag;
}

+ (ASN1ObjectIdentifier *)crlBag {
    static ASN1ObjectIdentifier *_crlBag = nil;
    @synchronized(self) {
        if (!_crlBag) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bagtypes] branch:@"4"] retain];
            }
            _crlBag = [branchObj retain];
        }
    }
    return _crlBag;
}

+ (ASN1ObjectIdentifier *)secretBag {
    static ASN1ObjectIdentifier *_secretBag = nil;
    @synchronized(self) {
        if (!_secretBag) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bagtypes] branch:@"5"] retain];
            }
            _secretBag = [branchObj retain];
        }
    }
    return _secretBag;
}

+ (ASN1ObjectIdentifier *)safeContentsBag {
    static ASN1ObjectIdentifier *_safeContentsBag = nil;
    @synchronized(self) {
        if (!_safeContentsBag) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self bagtypes] branch:@"6"] retain];
            }
            _safeContentsBag = [branchObj retain];
        }
    }
    return _safeContentsBag;
}

+ (ASN1ObjectIdentifier *)pkcs_12PbeIds {
    static ASN1ObjectIdentifier *_pkcs_12PbeIds = nil;
    @synchronized(self) {
        if (!_pkcs_12PbeIds) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_12] branch:@"1"] retain];
            }
            _pkcs_12PbeIds = [branchObj retain];
        }
    }
    return _pkcs_12PbeIds;
}

+ (ASN1ObjectIdentifier *)pbeWithSHAAnd128BitRC4 {
    static ASN1ObjectIdentifier *_pbeWithSHAAnd128BitRC4 = nil;
    @synchronized(self) {
        if (!_pbeWithSHAAnd128BitRC4) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_12PbeIds] branch:@"1"] retain];
            }
            _pbeWithSHAAnd128BitRC4 = [branchObj retain];
        }
    }
    return _pbeWithSHAAnd128BitRC4;
}

+ (ASN1ObjectIdentifier *)pbeWithSHAAnd40BitRC4 {
    static ASN1ObjectIdentifier *_pbeWithSHAAnd40BitRC4 = nil;
    @synchronized(self) {
        if (!_pbeWithSHAAnd40BitRC4) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_12PbeIds] branch:@"2"] retain];
            }
            _pbeWithSHAAnd40BitRC4 = [branchObj retain];
        }
    }
    return _pbeWithSHAAnd40BitRC4;
}

+ (ASN1ObjectIdentifier *)pbeWithSHAAnd3_KeyTripleDES_CBC {
    static ASN1ObjectIdentifier *_pbeWithSHAAnd3_KeyTripleDES_CBC = nil;
    @synchronized(self) {
        if (!_pbeWithSHAAnd3_KeyTripleDES_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_12PbeIds] branch:@"3"] retain];
            }
            _pbeWithSHAAnd3_KeyTripleDES_CBC = [branchObj retain];
        }
    }
    return _pbeWithSHAAnd3_KeyTripleDES_CBC;
}

+ (ASN1ObjectIdentifier *)pbeWithSHAAnd2_KeyTripleDES_CBC {
    static ASN1ObjectIdentifier *_pbeWithSHAAnd2_KeyTripleDES_CBC = nil;
    @synchronized(self) {
        if (!_pbeWithSHAAnd2_KeyTripleDES_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_12PbeIds] branch:@"4"] retain];
            }
            _pbeWithSHAAnd2_KeyTripleDES_CBC = [branchObj retain];
        }
    }
    return _pbeWithSHAAnd2_KeyTripleDES_CBC;
}

+ (ASN1ObjectIdentifier *)pbeWithSHAAnd128BitRC2_CBC {
    static ASN1ObjectIdentifier *_pbeWithSHAAnd128BitRC2_CBC = nil;
    @synchronized(self) {
        if (!_pbeWithSHAAnd128BitRC2_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_12PbeIds] branch:@"5"] retain];
            }
            _pbeWithSHAAnd128BitRC2_CBC = [branchObj retain];
        }
    }
    return _pbeWithSHAAnd128BitRC2_CBC;
}

+ (ASN1ObjectIdentifier *)pbeWithSHAAnd40BitRC2_CBC {
    static ASN1ObjectIdentifier *_pbeWithSHAAnd40BitRC2_CBC = nil;
    @synchronized(self) {
        if (!_pbeWithSHAAnd40BitRC2_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_12PbeIds] branch:@"6"] retain];
            }
            _pbeWithSHAAnd40BitRC2_CBC = [branchObj retain];
        }
    }
    return _pbeWithSHAAnd40BitRC2_CBC;
}


+ (ASN1ObjectIdentifier *)pbewithSHAAnd40BitRC2_CBC {
    static ASN1ObjectIdentifier *_pbewithSHAAnd40BitRC2_CBC = nil;
    @synchronized(self) {
        if (!_pbewithSHAAnd40BitRC2_CBC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[self pkcs_12PbeIds] branch:@"6"] retain];
            }
            _pbewithSHAAnd40BitRC2_CBC = [branchObj retain];
        }
    }
    return _pbewithSHAAnd40BitRC2_CBC;
}

+ (ASN1ObjectIdentifier *)id_alg_CMS3DESwrap {
    static ASN1ObjectIdentifier *_id_alg_CMS3DESwrap = nil;
    @synchronized(self) {
        if (!_id_alg_CMS3DESwrap) {
            _id_alg_CMS3DESwrap = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.9.16.3.6"];
        }
    }
    return _id_alg_CMS3DESwrap;
}

+ (ASN1ObjectIdentifier *)id_alg_CMSRC2wrap {
    static ASN1ObjectIdentifier *_id_alg_CMSRC2wrap = nil;
    @synchronized(self) {
        if (!_id_alg_CMSRC2wrap) {
            _id_alg_CMSRC2wrap = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.9.16.3.7"];
        }
    }
    return _id_alg_CMSRC2wrap;
}

+ (ASN1ObjectIdentifier *)id_alg_ESDH {
    static ASN1ObjectIdentifier *_id_alg_ESDH = nil;
    @synchronized(self) {
        if (!_id_alg_ESDH) {
            _id_alg_ESDH = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.9.16.3.5"];
        }
    }
    return _id_alg_ESDH;
}

+ (ASN1ObjectIdentifier *)id_alg_SSDH {
    static ASN1ObjectIdentifier *_id_alg_SSDH = nil;
    @synchronized(self) {
        if (!_id_alg_SSDH) {
            _id_alg_SSDH = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.840.113549.1.9.16.3.10"];
        }
    }
    return _id_alg_SSDH;
}

@end
