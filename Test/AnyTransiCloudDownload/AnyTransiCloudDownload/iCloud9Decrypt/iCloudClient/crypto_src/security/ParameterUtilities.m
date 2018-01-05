//
//  ParameterUtilities.m
//  
//
//  Created by iMobie on 7/21/16.
//
//  Complete

#import "ParameterUtilities.h"
#import "CategoryExtend.h"
#import "KeyParameter.h"
#import "ParametersWithIV.h"
#import "SecureRandom.h"

#import "NISTObjectIdentifiers.h"
#import "NTTObjectIdentifiers.h"
#import "PKCSObjectIdentifiers.h"
#import "OIWObjectIdentifier.h"
#import "CryptoProObjectIdentifiers.h"
#import "KISAObjectIdentifiers.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Encodable.h"
#import "ASN1OctetString.h"
#import "CAST5CBCParameters.h"
#import "IDEACBCPar.h"
#import "RC2CBCParameter.h"
#import "DEROctetString.h"

@implementation ParameterUtilities

- (id)init {
    if (self = [super init]) {
        return self;
    } else {
        return nil;
    }
}

+ (NSMutableDictionary*)algorithms {
    static NSMutableDictionary *_algorithms = nil;
    @synchronized(self) {
        if (_algorithms == nil) {
            _algorithms = [[NSMutableDictionary alloc] init];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"AES" withAliases:@"AESWRAP", nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"AES128" withAliases:@"2.16.840.1.101.3.4.2", [NISTObjectIdentifiers id_aes128_CBC], [NISTObjectIdentifiers id_aes128_CFB], [NISTObjectIdentifiers id_aes128_ECB], [NISTObjectIdentifiers id_aes128_OFB], [NISTObjectIdentifiers id_aes128_wrap], nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"AES192" withAliases:@"2.16.840.1.101.3.4.22", [NISTObjectIdentifiers id_aes192_CBC], [NISTObjectIdentifiers id_aes192_CFB], [NISTObjectIdentifiers id_aes192_ECB], [NISTObjectIdentifiers id_aes192_OFB], [NISTObjectIdentifiers id_aes192_wrap], nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"AES256" withAliases:@"2.16.840.1.101.3.4.42", [NISTObjectIdentifiers id_aes256_CBC], [NISTObjectIdentifiers id_aes256_CFB], [NISTObjectIdentifiers id_aes256_ECB], [NISTObjectIdentifiers id_aes256_OFB], [NISTObjectIdentifiers id_aes256_wrap], nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"BLOWFISH" withAliases:@"1.3.6.1.4.1.3029.1.2", nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"CAMELLIA" withAliases:@"CAMELLIAWRAP", nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"CAMELLIA128" withAliases:[NTTObjectIdentifiers id_camellia128_cbc], [NTTObjectIdentifiers id_camellia128_wrap], nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"CAMELLIA192" withAliases:[NTTObjectIdentifiers id_camellia192_cbc], [NTTObjectIdentifiers id_camellia192_wrap], nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"CAMELLIA256" withAliases:[NTTObjectIdentifiers id_camellia256_cbc], [NTTObjectIdentifiers id_camellia256_wrap], nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"CAST5" withAliases:@"1.2.840.113533.7.66.10", nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"CAST6" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"DES" withAliases:[OIWObjectIdentifier desCBC], [OIWObjectIdentifier desCFB], [OIWObjectIdentifier desECB], [OIWObjectIdentifier desOFB], nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"DESEDE" withAliases:@"DESEDEWRAP", @"TDEA", [OIWObjectIdentifier desEDE], [PKCSObjectIdentifiers id_alg_CMS3DESwrap], nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"DESEDE3" withAliases:[PKCSObjectIdentifiers des_EDE3_CBC], nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"GOST28147" withAliases:@"GOST", @"GOST-28147", [CryptoProObjectIdentifiers gostR28147_Cbc], nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"HC128" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"HC256" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"IDEA" withAliases:@"1.3.6.1.4.1.188.7.1.1.2", nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"NOEKEON" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"RC2" withAliases:[PKCSObjectIdentifiers RC2_CBC], [PKCSObjectIdentifiers id_alg_CMSRC2wrap], nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"RC4" withAliases:@"ARC4", @"1.2.840.113549.3.4", nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"RC5" withAliases:@"RC5-32", nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"RC5-64" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"RC6" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"RIJNDAEL" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"SALSA20" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"SEED" withAliases:[KISAObjectIdentifiers id_npki_app_cmsSeed_wrap], [KISAObjectIdentifiers id_seedCBC], nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"SERPENT" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"SKIPJACK" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"TEA" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"THREEFISH-256" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"THREEFISH-512" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"THREEFISH-1024" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"TNEPRES" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"TWOFISH" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"VMPC" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"VMPC-KSA3" withAliases:nil];
            [ParameterUtilities addAlgorithm:_algorithms withCanonicalName:@"XTEA" withAliases:nil];
        }
    }
    return _algorithms;
}

+ (NSMutableDictionary*)basicIVSizes {
    static NSMutableDictionary *_basicIVSizes = nil;
    @synchronized(self) {
        if (_basicIVSizes == nil) {
            _basicIVSizes = [[NSMutableDictionary alloc] init];
            [ParameterUtilities addBasicIVSizeEntries:_basicIVSizes withSize:8 withAlgorithms:@"BLOWFISH", @"DES", @"DESEDE", @"DESEDE3"];
            [ParameterUtilities addBasicIVSizeEntries:_basicIVSizes withSize:16 withAlgorithms:@"AES", @"AES128", @"AES192", @"AES256", @"CAMELLIA", @"CAMELLIA128", @"CAMELLIA192", @"CAMELLIA256", @"NOEKEON", @"SEED"];
        }
    }
    return _basicIVSizes;
}

+ (void)addAlgorithm:(NSMutableDictionary*)algorithmsDict withCanonicalName:(NSString*)canonicalName withAliases:(id)aliases,... {
    algorithmsDict[canonicalName] = canonicalName;
    
    va_list argList;
    id arg;
    if (aliases != nil) {
        va_start(argList, aliases);
        if (aliases != nil && [aliases isMemberOfClass:[ASN1ObjectIdentifier class]]) {
            algorithmsDict[[((ASN1ObjectIdentifier*)aliases) toString]] = canonicalName;
        } else {
            algorithmsDict[(NSString*)aliases] = canonicalName;
        }
        while((arg = va_arg(argList, id))) {
            if (arg != nil && [arg isMemberOfClass:[ASN1ObjectIdentifier class]]) {
                algorithmsDict[[((ASN1ObjectIdentifier*)arg) toString]] = canonicalName;
            } else {
                algorithmsDict[(NSString*)arg] = canonicalName;
            }
        }
        va_end(argList);
    }
}

+ (void)addBasicIVSizeEntries:(NSMutableDictionary*)ivSizesDict withSize:(int)size withAlgorithms:(NSString*)algorithms,... {
    va_list argList;
    NSString *arg;
    if (algorithms != nil) {
        va_start(argList, algorithms);
        ivSizesDict[algorithms] = @(size);
        while((arg = va_arg(argList, NSString*))) {
            ivSizesDict[arg] = @(size);
        }
        va_end(argList);
    }
}

+ (NSString*)getCanonicalAlgorithmName:(NSString*)algorithm {
    return (NSString*)([ParameterUtilities algorithms][[algorithm uppercaseString]]);
}

+ (KeyParameter*)createKeyParameterWithAlgOid:(DerObjectIdentifier*)algOid withKeyBytes:(NSMutableData*)keyBytes {
    // return [ParameterUtilities createKeyParameterWithAlgorithm:[algOid Id] withKeyBytes:keyBytes withOffset:0 withLength:(int)(keyBytes.length)];
    return nil;
}

+ (KeyParameter*)createKeyParameterWithAlgorithm:(NSString*)algorithm withKeyBytes:(NSMutableData *)keyBytes {
    return [ParameterUtilities createKeyParameterWithAlgorithm:algorithm withKeyBytes:keyBytes withOffset:0 withLength:(int)(keyBytes.length)];
}

+ (KeyParameter*)createKeyParameterWithAlgOid:(DerObjectIdentifier*)algOid withKeyBytes:(NSMutableData*)keyBytes withOffset:(int)offset withLength:(int)length {
    // return [ParameterUtilities createKeyParameterWithAlgorithm:[algOid Id] withKeyBytes:keyBytes withOffset:offset withLength:length];
    return nil;
}

+ (KeyParameter*)createKeyParameterWithAlgorithm:(NSString*)algorithm withKeyBytes:(NSMutableData*)keyBytes withOffset:(int)offset withLength:(int)length {
    if (algorithm == nil) {
        @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"algorithm" userInfo:nil];
    }
    
    NSString *canonical = [ParameterUtilities getCanonicalAlgorithmName:algorithm];
    
    if (canonical == nil) {
        @throw [NSException exceptionWithName:@"SecurityUtility" reason:[NSString stringWithFormat:@"Algorithm %@ not recognised.", algorithm] userInfo:nil];
    }
    
    if ([canonical isEqualToString:@"DES"]) {
        // return new DesParameters(keyBytes, offset, length);
        return nil;
    }
    
    if ([canonical isEqualToString:@"DESEDE"] || [canonical isEqualToString:@"DESEDE3"]) {
        // return new DesEdeParameters(keyBytes, offset, length);
        return nil;
    }
    
    if ([canonical isEqualToString:@"RC2"]) {
        // return new RC2Parameters(keyBytes, offset, length);
        return nil;
    }
    
    return [[[KeyParameter alloc] initWithKey:keyBytes withKeyOff:offset withKeyLen:length] autorelease];
}

+ (CipherParameters*)getCipherParametersWithAlgOid:(DerObjectIdentifier*)algOid withKey:(CipherParameters*)key withAsn1Params:(ASN1Object*)asn1Params {
    // return [ParameterUtilities getCipherParametersWithAlgorithm:[algOid Id] withKey:key withAsn1Params:asn1Params];
    return nil;
}

+ (CipherParameters*)getCipherParametersWithAlgorithm:(NSString*)algorithm withKey:(CipherParameters*)key withAsn1Params:(ASN1Object*)asn1Params {
    if (algorithm == nil) {
        @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"algorithm" userInfo:nil];
    }
    
    NSString *canonical = [ParameterUtilities getCanonicalAlgorithmName:algorithm];
    
    if (canonical == nil) {
        @throw [NSException exceptionWithName:@"SecurityUtility" reason:[NSString stringWithFormat:@"Algorithm %@ not recognised.", algorithm] userInfo:nil];
    }
    
    NSMutableData *iv = nil;
    
    @try {
        // TODO These algorithms support an IV
        // but JCE doesn't seem to provide an AlgorithmParametersGenerator for them
        // "RIJNDAEL", "SKIPJACK", "TWOFISH"
        
        int basicIVKeySize = [ParameterUtilities findBasicIVSize:canonical];
        if (basicIVKeySize != -1 || [canonical isEqualToString:@"RIJNDAEL"] || [canonical isEqualToString:@"SKIPJACK"] || [canonical isEqualToString:@"TWOFISH"]) {
            iv = [((ASN1OctetString*)asn1Params) getOctets];
        } else if ([canonical isEqualToString:@"CAST5"]) {
            iv = [[CAST5CBCParameters getInstance:asn1Params] getIV];
        } else if ([canonical isEqualToString:@"IDEA"]) {
            iv = [[IDEACBCPar getInstance:asn1Params] getIV];
        } else if ([canonical isEqualToString:@"RC2"]) {
            iv = [[RC2CBCParameter getInstance:asn1Params] getIV];
        }
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"Could not process ASN.1 parameters" userInfo:nil];
    }
    
    if (iv != nil) {
        return [[[ParametersWithIV alloc] initWithParameters:key withIv:iv] autorelease];
    }
    
    @throw [NSException exceptionWithName:@"SecurityUtility" reason:[NSString stringWithFormat:@"Algorithm %@ not recognised.", algorithm] userInfo:nil];
}

+ (ASN1Encodable*)generateParametersWithAlgID:(DerObjectIdentifier*)algID withRandom:(SecureRandom*)random {
    // return [ParameterUtilities generateParametersWithAlgorithm:[algID Id] withRandom:random];
    return nil;
}

+ (ASN1Encodable*)generateParametersWithAlgorithm:(NSString*)algorithm withRandom:(SecureRandom*)random {
    if (algorithm == nil) {
        @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"algorithm" userInfo:nil];
    }
    
    NSString *canonical = [ParameterUtilities getCanonicalAlgorithmName:algorithm];
    
    if (canonical == nil) {
         @throw [NSException exceptionWithName:@"SecurityUtility" reason:[NSString stringWithFormat:@"Algorithm %@ not recognised.", algorithm] userInfo:nil];
    }
    
    // TODO These algorithms support an IV
    // but JCE doesn't seem to provide an AlgorithmParametersGenerator for them
    // "RIJNDAEL", "SKIPJACK", "TWOFISH"
    
    int basicIVKeySize = [ParameterUtilities findBasicIVSize:canonical];
    if (basicIVKeySize != -1)
        return [ParameterUtilities createIVOctetString:random withIvLength:basicIVKeySize];
    
    if ([canonical isEqualToString:@"CAST5"]) {
        return [[[CAST5CBCParameters alloc] initParamArrayOfByte:[ParameterUtilities createIV:random withIvLength:8] paramInt:128] autorelease];
    }
    
    if ([canonical isEqualToString:@"IDEA"]) {
        return [[[IDEACBCPar alloc] initParamArrayOfByte:[ParameterUtilities createIV:random withIvLength:8]] autorelease];
    }
    
    if ([canonical isEqualToString:@"RC2"]) {
        return [[[RC2CBCParameter alloc] initParamArrayOfByte:[ParameterUtilities createIV:random withIvLength:8]] autorelease];
    }
    
    @throw [NSException exceptionWithName:@"SecurityUtility" reason:[NSString stringWithFormat:@"Algorithm %@ not recognised.", algorithm] userInfo:nil];
}

+ (ASN1OctetString*)createIVOctetString:(SecureRandom*)random withIvLength:(int)ivLength {
    return [[[DEROctetString alloc] initDEROctetString:[ParameterUtilities createIV:random withIvLength:ivLength]] autorelease];
}

+ (NSMutableData*)createIV:(SecureRandom*)random withIvLength:(int)ivLength {
    return [random nextBytes:ivLength];
}

+ (int)findBasicIVSize:(NSString*)canonicalName {
    if (![[ParameterUtilities basicIVSizes].allKeys containsObject:canonicalName]) {
        return -1;
    }
    
    return [[ParameterUtilities basicIVSizes][canonicalName] intValue];
}

@end
