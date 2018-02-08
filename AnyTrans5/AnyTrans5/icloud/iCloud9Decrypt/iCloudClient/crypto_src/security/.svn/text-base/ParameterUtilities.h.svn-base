//
//  ParameterUtilities.h
//  
//
//  Created by iMobie on 7/21/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class KeyParameter;
@class CipherParameters;
@class SecureRandom;
@class DerObjectIdentifier;
@class ASN1Object;
@class ASN1Encodable;

@interface ParameterUtilities : NSObject

+ (NSString*)getCanonicalAlgorithmName:(NSString*)algorithm;
+ (KeyParameter*)createKeyParameterWithAlgOid:(DerObjectIdentifier*)algOid withKeyBytes:(NSMutableData*)keyBytes;
+ (KeyParameter*)createKeyParameterWithAlgorithm:(NSString*)algorithm withKeyBytes:(NSMutableData *)keyBytes;
+ (KeyParameter*)createKeyParameterWithAlgOid:(DerObjectIdentifier*)algOid withKeyBytes:(NSMutableData*)keyBytes withOffset:(int)offset withLength:(int)length;
+ (KeyParameter*)createKeyParameterWithAlgorithm:(NSString*)algorithm withKeyBytes:(NSMutableData*)keyBytes withOffset:(int)offset withLength:(int)length;
+ (CipherParameters*)getCipherParametersWithAlgOid:(DerObjectIdentifier*)algOid withKey:(CipherParameters*)key withAsn1Params:(ASN1Object*)asn1Params;
+ (CipherParameters*)getCipherParametersWithAlgorithm:(NSString*)algorithm withKey:(CipherParameters*)key withAsn1Params:(ASN1Object*)asn1Paramss;
+ (ASN1Encodable*)generateParametersWithAlgID:(DerObjectIdentifier*)algID withRandom:(SecureRandom*)random;
+ (ASN1Encodable*)generateParametersWithAlgorithm:(NSString*)algorithm withRandom:(SecureRandom*)random;


@end
