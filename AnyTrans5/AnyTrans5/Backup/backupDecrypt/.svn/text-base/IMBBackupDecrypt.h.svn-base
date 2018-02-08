//
//  IMBBackupDecrypt.h
//  DataRecovery
//
//  Created by iMobie on 3/14/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBBackupDecrypt : NSObject{
    NSFileManager *fm;
    NSNotificationCenter *nc;
    int _totalDecryptFiles;//需要解密文件；
    int _currentDecryptFile;//当前解密文件；
    BOOL _isProgressBreaked;//是否中断解密进程；
    NSString *_outputPath;   //解密到的文件路径；
    NSString *_backupFilePath;  //备份文件路径；
    NSString *_password;  //验证正确的密码值；
    NSMutableArray *_fileRecordArray; // IMBMBFileRecord
    
    NSString *_iosVersion;
}
@property (nonatomic, readwrite, retain) NSString *iosVersion;
@property (nonatomic, readwrite, assign) int totalDecryptFiles;
@property (nonatomic, readwrite, assign) int currentDecryptFile;
@property (nonatomic, readwrite, assign) BOOL isProgressBreaked;
@property (nonatomic, readwrite, retain) NSString *outputPath;
@property (nonatomic, readwrite, retain) NSString *backupFilePath;
@property (nonatomic, readwrite, retain) NSString *password;
@property (nonatomic, readwrite, retain) NSMutableArray *fileRecordArray;

-(id)initWithPath:(NSString *)backupPath withOutputPath:(NSString *)outputPath withIOSProductVersion:(NSString *)iosProductVersion;
-(BOOL)verifyPassword:(NSString *)password withPath:(NSString *)manidestPath;//判断密码是否匹配；
-(void)decryptAllFile;//解密所有文件；
-(NSString *)decryptSingleFile:(NSString *)domain  withFilePath:(NSString *)filePath;//解密单个文件；
-(void)decryptDomainFile:(NSString *)domain;//解密domain文件；

@end
