//
//  IMBPhotoHeicManager.m
//  AnyTrans
//
//  Created by JGehry on 10/20/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "IMBPhotoHeicManager.h"

static IMBPhotoHeicManager *_singleton = nil;

@implementation IMBPhotoHeicManager

+ (IMBPhotoHeicManager *)singleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_singleton) {
            _singleton = [[IMBPhotoHeicManager alloc] init];
        }
    });
    return _singleton;
}

- (instancetype)init
{
    if (self = [super init]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

#pragma mark -- 初始化方法
- (void)initParamsWithHeic:(NSString *)heicPath withInputPath:(NSString *)inputPath withOutputPath:(NSString *)outputPath withFileType:(NSString *)fileType {
    if (!heicPath) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"string cannot be nil" userInfo:nil];
    }
    if (!inputPath) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"string cannot be nil" userInfo:nil];
    }
    if (!outputPath) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"string cannot be nil" userInfo:nil];
    }
    if (!fileType) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"string cannot be nil" userInfo:nil];
    }
    self.heicFilePath = heicPath;
    self.inputFilePath = inputPath;
    self.outputFilePath = outputPath;
    self.fileType = fileType;
}

#pragma mark -- 开始执行转化
- (void)startConvert {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *heicConvert = [bundle pathForResource:@"heicConvert" ofType:@"py"];
    NSString *heicFilePath = self.heicFilePath;
    NSString *inputFilePath = self.inputFilePath;
    NSString *outputFilePath = self.outputFilePath;
    NSString *fileType = self.fileType;
    NSString *pythonScriptPath = [NSString stringWithFormat:@"%@ \"%@,,,%@,,,%@\" %@", heicConvert, heicFilePath, inputFilePath, outputFilePath, fileType];
    NSTask *pythonTask = [[NSTask alloc] init];
    [pythonTask setLaunchPath:@"/bin/bash"];
    NSString *pyStr = [NSString stringWithFormat:@"python %@", pythonScriptPath];
    [pythonTask setArguments:[NSArray arrayWithObjects:@"-c", pyStr, nil]];
    NSPipe *pipe = [[NSPipe alloc] init];
    [pythonTask setStandardOutput:pipe];
    [pythonTask launch];
    
    NSFileHandle *fh = [pipe fileHandleForReading];
    NSData *data = [fh readDataToEndOfFile];
    NSString *returnStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([returnStr rangeOfString:@"heicConvert Completed"].location != NSNotFound) {
        NSLog(@"True");
    }
}

@end
