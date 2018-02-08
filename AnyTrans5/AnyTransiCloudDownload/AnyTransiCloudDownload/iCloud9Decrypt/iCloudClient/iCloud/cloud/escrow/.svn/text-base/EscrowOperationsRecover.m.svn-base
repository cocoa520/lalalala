//
//  EscrowOperationsRecover.m
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import "EscrowOperationsRecover.h"
#import "Arrays.h"
#import "AESCBC.h"
#import "Blob.h"
#import "CategoryExtend.h"
#import "EscrowProxyRequest.h"
#import "HttpClient.h"
#import "Hex.h"
#import "PBKDF2.h"
#import "SRPClient.h"
#import "SRPFactory.h"
#import "SecureRandom.h"
#import "Sha256Digest.h"

@implementation EscrowOperationsRecover

+ (NSMutableDictionary*)recover:(EscrowProxyRequest*)requests {
    SecureRandom *random = [[SecureRandom alloc] init];
    SRPClient *srpClient = [SRPFactory rfc5054:random];
    
    NSMutableDictionary *srpInitResponse = [EscrowOperationsRecover srpInit:requests withSrpClient:srpClient];
    NSMutableDictionary *recover = [EscrowOperationsRecover recover:requests withSrpClient:srpClient withSrpInitResponse:srpInitResponse];
    NSMutableDictionary *decrypt = [EscrowOperationsRecover decrypt:srpClient withRecoverResponse:recover];
    
#if !__has_feature(objc_arc)
    if (random != nil) [random release]; random = nil;
#endif
    
    return decrypt;
}

+ (NSMutableDictionary*)recover:(EscrowProxyRequest*)requests withSrpClient:(SRPClient*)srpClient withSrpInitResponse:(NSDictionary*)srpInitResponse {
    [EscrowOperationsRecover validateSrpInitResponse:srpInitResponse];
    
    NSString *dsid = nil;
    NSString *respBlob = nil;
    if ([srpInitResponse.allKeys containsObject:@"dsid"]) {
        id obj = [srpInitResponse objectForKey:@"dsid"];
        if (obj != nil && [obj isKindOfClass:[NSString class]]) {
            dsid = (NSString*)obj;
        }
    }
    if ([srpInitResponse.allKeys containsObject:@"respBlob"]) {
        id obj = [srpInitResponse objectForKey:@"respBlob"];
        if (obj != nil && [obj isKindOfClass:[NSString class]]) {
            respBlob = (NSString*)obj;
        }
    }
    
    NSMutableData *m1 = nil;
    NSMutableData *uid = nil;
    NSMutableData *tag = nil;
    @try {
        BlobA4 *blob = [EscrowOperationsRecover blobA4:respBlob];
        m1 = [EscrowOperationsRecover calculateM1:srpClient withBlob:blob withDsid:dsid];
        uid = [blob getUid];
        tag = [blob getTag];
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:@"ErrorFormat" reason:[exception reason] userInfo:srpInitResponse];
    }
    
    return [EscrowOperationsRecover recover:requests withUid:uid withTag:tag withM1:m1];
}

+ (NSMutableDictionary*)recover:(EscrowProxyRequest*)requests withUid:(NSMutableData*)uid withTag:(NSMutableData*)tag withM1:(NSMutableData*)m1 {
    /*
     SRP-6a RECOVER
     
     Failures will deplete attempts (we have 10 attempts max).
     Server will abort on an invalid M1 or present us with, amongst other things, M2 which we can verify (or not).
     */
    NSMutableURLRequest *recoverRequest = [requests recover:m1 withUUID:uid withTag:tag];
    NSData *responsedData = [HttpClient execute:recoverRequest];
    NSMutableDictionary *response = nil;
    if (responsedData != nil) {
        response = [responsedData dataToMutableDictionary];
    }
    return response;
}

+ (NSMutableDictionary*)srpInit:(EscrowProxyRequest*)requests withSrpClient:(SRPClient*)srpClient {
    /*
     SRP-6a SRP_INIT
     
     Randomly generated ephemeral key A presented to escrow server along with id (mmeAuthToken header).
     Server returns amongst other things a salt and an ephemeral key B.
     */
    NSMutableData *ephemeralKeyA = [srpClient generateClientCredentials];
    
    NSMutableURLRequest *srpInitRequest = [requests srpInit:ephemeralKeyA];
    NSData *responsedData = [HttpClient execute:srpInitRequest];
    NSMutableDictionary *dictionary = nil;
    if (responsedData != nil) {
        dictionary = [responsedData dataToMutableDictionary];
    }
    return dictionary;
}

+ (void)validateSrpInitResponse:(NSDictionary*)srpInitResponseBlob {
    int version = 0;
    if ([srpInitResponseBlob.allKeys containsObject:@"version"]) {
        id obj = [srpInitResponseBlob objectForKey:@"version"];
        if (obj != nil) {
            version = [obj intValue];
        }
    }
    if (version != 1) {
        @throw [NSException exceptionWithName:@"UnsupportedOperation" reason:[NSString stringWithFormat:@"unknown SRP_INIT version: %d", version] userInfo:nil];
    }
}

+ (NSMutableData*)calculateM1:(SRPClient*)srpClient withBlob:(BlobA4*)blob withDsid:(NSString*)dsid {
    NSMutableData *dsidBytes = [[dsid dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    NSMutableData *salt = [blob getSalt];
    NSMutableData *ephemeralKey = [blob getEphemeralKey];
    
    NSMutableData *retData = [EscrowOperationsRecover calculateM1:srpClient withSalt:salt withDsid:dsidBytes withEphemeralKeyB:ephemeralKey];
#if !__has_feature(objc_arc)
    if (dsidBytes) [dsidBytes release]; dsidBytes = nil;
#endif
    return retData;
}

+ (NSMutableData*)calculateM1:(SRPClient*)srpClient withSalt:(NSMutableData*)salt withDsid:(NSMutableData*)dsid withEphemeralKeyB:(NSMutableData*)ephemeralKeyB {
    NSMutableData *retData = [srpClient calculateClientEvidenceMessage:salt withIdentity:dsid withPassword:dsid withServerB:ephemeralKeyB];
    if (retData == nil) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"bad ephemeral key received from server" userInfo:nil];
    }
    return retData;
}

+ (NSMutableDictionary*)decrypt:(SRPClient*)srpClient withRecoverResponse:(NSDictionary*)recoverResponse {
    NSString *respBlob = nil;
    if ([recoverResponse.allKeys containsObject:@"respBlob"]) {
        id obj = [recoverResponse objectForKey:@"respBlob"];
        if (obj != nil && [obj isKindOfClass:[NSString class]]) {
            respBlob = (NSString*)obj;
        }
    }
    
    BlobA6 *blob = [EscrowOperationsRecover blobA6:respBlob];
    
    NSMutableData *key = [EscrowOperationsRecover sessionKey:srpClient withBlob:blob];
    
    return [EscrowOperationsRecover decrypt:blob withKey:key];
}

+ (NSMutableDictionary*)decrypt:(BlobA6*)blob withKey:(NSMutableData*)key {
    NSMutableData *pcsData = [AESCBC decryptAESCBC:key withIv:[blob iv] withData:[blob data]];
    //NSLog(@"-- decrypt() - pcs data: 0x%@", [Hex toHexString:pcsData]);
    
    BlobA0 *pcsBlob = [[BlobA0 alloc] init:[DataStream wrapWithData:pcsData]];
    
    Sha256Digest *sha256 = [[Sha256Digest alloc] init];
    NSMutableData *derivedKey = [PBKDF2 generate:sha256 withPassword:[pcsBlob dsid] withSalt:[pcsBlob salt] withIterations:[pcsBlob iterations] withLengthBits:(16 * 8)];
    //NSLog(@"-- decrypt() - derived key: 0x%@", [Hex toHexString:derivedKey]);
    
    NSMutableData *saltIV = [Arrays copyOfWithData:[pcsBlob salt] withNewLength:0x10];
    //NSLog(@"-- decrypt() - salt/ iv: 0x%@", [Hex toHexString:saltIV]);
    
    NSMutableData *dictionaryData = [AESCBC decryptAESCBC:derivedKey withIv:saltIV withData:[pcsBlob data]];
    //NSLog(@"-- decrypt() - dictionary data: 0x%@", [Hex toHexString:dictionaryData]);
#if !__has_feature(objc_arc)
    if (saltIV) [saltIV release]; saltIV = nil;
#endif
    
    NSMutableDictionary *dictionary = [dictionaryData dataToMutableDictionary];
    //NSLog(@"-- decrypt() - dictionary: %@", [dictionary description]);
#if !__has_feature(objc_arc)
    if (sha256) [sha256 release]; sha256 = nil;
    if (pcsBlob) [pcsBlob release]; pcsBlob = nil;
#endif
    return dictionary;
}

+ (NSMutableData*)sessionKey:(SRPClient*)srp withBlob:(BlobA6*)blob {
    NSMutableData *key = [srp verifyServerEvidenceMessage:[blob m2]];
    if (key == nil) {
        @throw [NSException exceptionWithName:@"IllegalState" reason:@"failed to verify SRP m2" userInfo:nil];
    }
    //NSLog(@"-- sessionKey() - session key: 0x%@", [Hex toHexString:key]);
    return key;
}

+ (BlobA4*)blobA4:(NSString*)respBlob {
    NSMutableData *tmpData = nil;
    @autoreleasepool {
        NSData *data = [Base64Codec dataFromBase64String:respBlob];
        tmpData = [data mutableCopy];
    }
    DataStream *buffer = [DataStream wrapWithData:tmpData];
#if !__has_feature(objc_arc)
    if (tmpData) [tmpData release]; tmpData = nil;
#endif
    return [[[BlobA4 alloc] init:buffer] autorelease];
}

+ (BlobA6*)blobA6:(NSString*)respBlob {
    NSMutableData *tmpData = nil;
    @autoreleasepool {
        NSData *data = [Base64Codec dataFromBase64String:respBlob];
        tmpData = [data mutableCopy];
    }
    DataStream *buffer = [DataStream wrapWithData:tmpData];
#if !__has_feature(objc_arc)
    if (tmpData) [tmpData release]; tmpData = nil;
#endif
    return [[[BlobA6 alloc] init:buffer] autorelease];
}

@end
