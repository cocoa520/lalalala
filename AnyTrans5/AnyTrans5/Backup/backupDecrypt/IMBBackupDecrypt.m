//
//  IMBBackupDecrypt.m
//  DataRecovery
//
//  Created by iMobie on 3/14/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBackupDecrypt.h"

@implementation IMBBackupDecrypt
@synthesize totalDecryptFiles = _totalDecryptFiles;
@synthesize currentDecryptFile = _currentDecryptFile;
@synthesize isProgressBreaked = _isProgressBreaked;
@synthesize outputPath = _outputPath;
@synthesize password = _password;
@synthesize backupFilePath = _backupFilePath;
@synthesize fileRecordArray = _fileRecordArray;
@synthesize iosVersion = _iosVersion;

-(id)initWithPath:(NSString *)backupPath withOutputPath:(NSString *)outputPath withIOSProductVersion:(NSString *)iosProductVersion{
    self = [super init];
    if (self) {
        nc = [NSNotificationCenter defaultCenter];
        fm = [NSFileManager defaultManager];
        _backupFilePath = [backupPath retain];
        _outputPath = [outputPath retain];
        _totalDecryptFiles = 0;
        _currentDecryptFile = 0;
        _isProgressBreaked = NO;
    }
    return self;
}

- (void)dealloc
{
    [_backupFilePath release];
    [_outputPath release];
    [super dealloc];
}

-(BOOL)verifyPassword:(NSString *)password withPath:(NSString *)manidestPath{//判断密码是否匹配；
    return NO;
}

-(void)decryptAllFile{//解密所有文件；
    return;
}

-(NSString *)decryptSingleFile:(NSString *)domain  withFilePath:(NSString *)filePath{//解密单个文件；
    return nil;
}

-(void)decryptDomainFile:(NSString *)domain{//解密domain文件；
    return;
}



@end
