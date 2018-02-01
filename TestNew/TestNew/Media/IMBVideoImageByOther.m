//
//  IMBVideoImageByOther.m
//  iMobieTrans
//
//  Created by iMobie on 12/18/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBVideoImageByOther.h"
#import "IMBFileSystem.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVTime.h>
#import "IMBSession.h"
#import <AppKit/AppKit.h>


@implementation IMBVideoImageByOther

- (id)initWithPath:(NSString *)path withiPod:(IMBiPod *)ipod {
    self = [super init];
    if (self) {
        _ipod = ipod;
        _oriPath = path;
    }
    return self;
}

- (void)dealloc
{
    if (_videoImagePath != nil) {
        [_videoImagePath release];
        _videoImagePath = nil;
    }
    [super dealloc];
}

- (NSString *)getVideoImageInfo {
    NSString *videoPath = nil;
    videoPath = [self videoImagePathAfterReadingDeviceVideo:_oriPath];
    _videoImagePath = [[[videoPath stringByDeletingPathExtension] stringByAppendingString:@".tmp.png"] retain];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:_videoImagePath]){
        return _videoImagePath;
    }
    //取video第一帧图片
    NSURL *videoUrl = [NSURL fileURLWithPath:videoPath];
    [self getFirstVideoImage:videoUrl];
    return _videoImagePath;
}

- (NSString *)videoImagePathAfterReadingDeviceVideo:(NSString *)devicePath {
    NSString *saveFolder = [[[_ipod session] sessionFolderPath] stringByAppendingPathComponent:@"video"];
    NSString *tempPath = [saveFolder stringByAppendingPathComponent:devicePath.lastPathComponent];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:tempPath]) {
        return tempPath;
    }
    if (![fileManager fileExistsAtPath:saveFolder]) {
        [fileManager createDirectoryAtPath:saveFolder withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    NSData *data = [self readFileData:devicePath];
    [data writeToFile:tempPath atomically:YES];
    [data release];
    return tempPath;
}

- (NSData *)readFileData:(NSString *)filePath{
    if (![_ipod.fileSystem fileExistsAtPath:filePath]) {
        return nil;
    }
    else{
        long long fileLength = [_ipod.fileSystem getFileLength:filePath];
        AFCFileReference *openFile = [_ipod.fileSystem openForRead:filePath];
        const uint32_t bufsz = 10240000;
        char *buff = (char*)malloc(bufsz);
        NSMutableData *totalData = [[NSMutableData alloc] init];
        int i = 0;
        while (1) {
            uint64_t n = [openFile readN:bufsz bytes:buff];
            if (n==0) break;
            //将字节数据转化为NSdata
            NSData *b2 = [[NSData alloc]
                          initWithBytesNoCopy:buff length:n freeWhenDone:NO];
            [totalData appendData:b2];
            i ++;
        }
        if (totalData.length == fileLength) {
            //            NSLog(@"success readData");
        }
        return totalData;
    }
}

- (void)getFirstVideoImage:(NSURL *)url {
    NSDictionary *assetOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
	AVAsset *localAsset = [AVURLAsset URLAssetWithURL:url options:assetOptions];
	if (localAsset) {
		AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:localAsset];
        [localAsset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
            if ([localAsset statusOfValueForKey:@"tracks" error:NULL] != AVKeyValueStatusLoaded) {
                return;
            }
            
            NSArray *visualTracks = [localAsset tracksWithMediaCharacteristic:AVMediaCharacteristicVisual];
            NSArray *audibleTracks = [localAsset tracksWithMediaCharacteristic:AVMediaCharacteristicAudible];
            if ([visualTracks count] > 0)
            {
                // Grab the first frame from the asset and display it
                [imageGenerator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:kCMTimeZero]] completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error) {
                    if (result == AVAssetImageGeneratorSucceeded) {
                        NSImage *newImage = [self imageFromCGImageRef:image];
                        if (newImage != nil) {
                            NSData *data = [newImage TIFFRepresentation];
                            NSFileManager *fm = [NSFileManager defaultManager];
                            if ([fm fileExistsAtPath:_videoImagePath]) {
                                [fm removeItemAtPath:_videoImagePath error:nil];
                            }
                            [data writeToFile:_videoImagePath atomically:YES];
                        }
                    }else{
                    }
                }];
            }
            else if ([audibleTracks count] > 0)
            {
                
            }
            else
            {
                
            }
        }];
	}
}

- (NSImage*) imageFromCGImageRef:(CGImageRef)image

{
    
    NSRect imageRect = NSMakeRect(0.0, 0.0, 0.0, 0.0);
    
    CGContextRef imageContext = nil;
    
    NSImage* newImage = nil;
    
    
    
    // Get the image dimensions.
    
    imageRect.size.height = CGImageGetHeight(image);
    
    imageRect.size.width = CGImageGetWidth(image);
    
    
    
    // Create a new image to receive the Quartz image data.
    
    newImage = [[[NSImage alloc] initWithSize:imageRect.size] autorelease];
    
    [newImage lockFocus];
    
    // Get the Quartz context and draw.
    
    imageContext = (CGContextRef)[[NSGraphicsContext currentContext]
                                  
                                  graphicsPort];
    
    CGContextDrawImage(imageContext, *(CGRect*)&imageRect, image);
    
    [newImage unlockFocus];
    
    
    return newImage;
    
}


@end
