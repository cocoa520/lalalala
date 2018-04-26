//
//  IMBDatabaseHasher.m
//  iMobieTrans
//
//  Created by Pallas on 1/15/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBDatabaseHasher.h"
#import "IMBHash58.h"
#import "IMBHash72.h"
#import "IMBMusicDatabase.h"
#import <openssl/sha.h>
#import "NSString+Category.h"
#import "IMBDeviceInfo.h"

@implementation IMBDatabaseHasher

+ (void)hash:(NSString*)filePath ipod:(IMBiPod*)ipod {
    if ([[ipod deviceInfo] firewireID] == nil || [[[ipod deviceInfo] firewireID] length] != 16) {
        return;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == YES) {
        FILE *file;
        if ((file = fopen([filePath UTF8String], "rb+")) != NULL) {
            fseek(file, 0, SEEK_END);
            int len = (int)ftell(file);
            uint8_t *buf = new uint8_t[len];
            int tmp;
            tmp = fseek(file, 0, SEEK_SET);
            tmp = (int)fread(buf, 1, len, file);
            
            //进行Hash58进行计算
            uint8_t nul[20] = {0x00};
            memcpy(&buf[0x18], nul, 8);
            memcpy(&buf[0x32], nul, 20);
            memcpy(&buf[0x58], nul, 20);
            uint8_t signature[20] = { 0x00 };
            Hash58File(buf, len, signature, [[[ipod deviceInfo] firewireID] UTF8String]);
            fseek(file, 0x58, SEEK_SET);
            fwrite(signature, 1, 20, file);
            fflush(file);
            
            //进行Hash72进行计算
            NSURL *uri = [MediaHelper getHashWebserviceUri];
            NSString *nameSpace = [MediaHelper getHashWebserviceNameSpace];
            if ([[ipod mediaDatabase] hashingScheme] >= 2) {
                uint8_t nul[46] = { 0x00 };
                memcpy(&buf[0x72], nul, 46);
                uint8_t hash[20] = { 0x00 };
                SHA_CTX content;
                SHA1_Init(&content);
                SHA1_Update(&content, buf, len);
                SHA1_Final(hash, &content);
                NSString *sha1Str = [NSString stringToHex:hash length:20];
                NSString *uuidStr = [[ipod deviceInfo] serialNumberForHashing];
                NSLog(@"uuidStr %@", uuidStr);
                
                BOOL isSuccess = NO;
                uint8_t signature[46] = { 0x00 };
                [MediaHelper getHashByWebservice:uri nameSpace:nameSpace methodName:@"C0DD217E838A662" sha1:sha1Str uuid:uuidStr signature:signature isSuccess:&isSuccess];
                if (!isSuccess) {
//                    [NSException exceptionWithName:HASH_ERROR_EXCEPTION reason:@"Error calculation Hash72." userInfo:nil];
                }
                
                fseek(file, 0x72, SEEK_SET);
                fwrite(signature, 1, 46, file);
                fflush(file);
            }
            
            //进行HashAB进行计算
            //这里的HASHAB可能是8位的。
            if ([[ipod deviceInfo] needHashABChkSum]) {
                uint8_t nul[57] = { 0x00 };
                memcpy(&buf[0xAB], nul, 57);
                uint8_t hash[20] = { 0x00 };
                SHA_CTX content;
                SHA1_Init(&content);
                SHA1_Update(&content, buf, len);
                SHA1_Final(hash, &content);
                uint8_t signature[57] = { 0x00 };
                NSString *sha1Str = [NSString stringToHex:hash length:20];
                NSString *uuidStr = [[ipod deviceInfo] serialNumberForHashing];
                NSLog(@"uuidStr %@", uuidStr);
                
                BOOL isSuccess = NO;
                [MediaHelper getHashByWebservice:uri nameSpace:nameSpace methodName:@"C4EC501AF7D003B" sha1:sha1Str uuid:uuidStr signature:signature isSuccess:&isSuccess];
                if (!isSuccess) {
//                    [NSException exceptionWithName:HASH_ERROR_EXCEPTION reason:@"Error calculation HashAB." userInfo:nil];
                }
                fseek(file, 0xAB, SEEK_SET);
                fwrite(signature, 1, 57, file);
                fflush(file);
            }
            delete buf;
            fclose(file);
        }
    }
}

@end
