//
//  IMBRfc2898DeriveBytes.h
//  BackupTool_Mac
//
//  Created by Pallas on 1/17/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBRfc2898DeriveBytes : NSObject {
    
}

+ (void)deriveBytes:(NSMutableData *)deriveBytes fromPassword:(NSString *)password withSalt:(NSData *)salt withIterations:(int)iterations;

+ (void)deriveBytes256:(NSMutableData *)deriveBytes fromPassword:(NSString *)password withSalt:(NSData *)salt withIterations:(int)iterations;

+ (void)deriveBytes:(NSMutableData *)deriveBytes fromPasscodeData:(NSData *)passcodeData withSalt:(NSData *)salt withIterations:(int)iterations;

+ (void)deriveKey:(NSMutableData *)key andIV:(NSMutableData *)iv fromPassword:(NSString *)password withSalt:(NSData *)salt withIterations:(int)iterations;

@end
