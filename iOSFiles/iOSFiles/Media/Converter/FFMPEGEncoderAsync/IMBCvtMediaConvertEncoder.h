//
//  IMBCvtMediaConvertEncoder.h
//  iMobieTrans
//
//  Created by zhang yang on 13-5-9.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCvtEncodedMedia.h"
#import "IMBCvtMediaFileEntity.h"
#import "IMBTrack.h"


#define FFMPEG_CONVERT_THREAD_COUNT 4
@interface IMBCvtMediaConvertEncoder : NSObject {
    IMBCvtEncodedMedia* _tempEncodedMedia;
    IMBCvtMediaFileEntity* _tempMediaFile;
    int iProgressErrorCount;
    int PROGRESS_ERROR_LIMIT;
    NSMutableString *_ffmpegOutputStr;
    NSNotificationCenter *nc;
}


/*TODO 需要做如下处理，在notification中有两个方法。
 #region "Delegate"
 一个进度事件以及一个完成事件
 public delegate void EncodeProgressEventHandler(object sender, EncodeProgressEventArgs e);
 
 public delegate void EncodeFinishedEventHandler(object sender, EncodeFinishedEventArgs e);
 
*/

//开始转换时，最重要的函数。
- (void) encodeMediaAsyncWithMediaFile:(IMBCvtMediaFileEntity*)input EncodeParas:(NSArray*)encodeParas OutputFileName:(NSString*)outputFile ThumbnailSize:(NSString*) thumbnailSize;


//1.设置转换时的参数。
//2.如果是video的话截取一张图片。
//3.创建执行参数。
//4.异步调用ffmpeg函数。

-(void) getMediaInfo:(IMBCvtMediaFileEntity*) input;
-(NSString*) getVideoArtworkData:(NSString*) mediaFilePath;
-(IMBNewTrack*) createNewtrackWithffmpeg:(NSString*) mediaFilePath;



@end
