//
//  IMBPhotoHeicManager.h
//  AnyTrans
//
//  Created by JGehry on 10/20/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBPhotoHeicManager : NSObject {
 @private
    NSString *_heicFilePath;
    NSString *_inputFilePath;
    NSString *_outputFilePath;
    NSString *_fileType;
}

/**
 *  heic文件路径
 */
@property (nonatomic, readwrite, retain) NSString *heicFilePath;

/**
 *  转化heic文件的临时输入路径
 */
@property (nonatomic, readwrite, retain) NSString *inputFilePath;

/**
 *  转化后的保存路径
 */
@property (nonatomic, readwrite, retain) NSString *outputFilePath;

/**
 *  需要转换的文件类型，比如JPG、PNG
 */
@property (nonatomic, readwrite, retain) NSString *fileType;

+ (IMBPhotoHeicManager *)singleton;

/**
 *  初始化方法
 *
 *  @param heicPath   heic文件路径
 *  @param inputPath  转化中存放的临时路径
 *  @param outputPath 转化后的保存路径
 *  @param fileType   需要转换的文件类型
 */
- (void)initParamsWithHeic:(NSString *)heicPath withInputPath:(NSString *)inputPath withOutputPath:(NSString *)outputPath withFileType:(NSString *)fileType;

/**
 *  开始执行转化
 */
- (void)startConvert;

@end
