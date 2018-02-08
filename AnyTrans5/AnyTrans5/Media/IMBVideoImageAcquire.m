//
//  IMBVideoImageAquire.m
//  iMobieTrans
//
//  Created by iMobie on 6/18/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBVideoImageAcquire.h"
#import "IMBCommonEnum.h"
#import "IMBFileSystem.h"
#import "NSString+Category.h"
#import "TempHelper.h"
#import "IMBMediaInfo.h"
@implementation IMBVideoImageAcquire
@synthesize ffmpegApp = _ffmpegApp;
@synthesize hour = _hour;
@synthesize minutes = _minutes;
@synthesize seconds = _seconds;
@synthesize width = _width;
@synthesize height = _height;
@synthesize filePath = _filePath;
@synthesize isMovies = _isMovies;
- (id)init{
    if(self = [super init]){
        
    }
    return self;
}
- (id)initwithLocalPath:(NSString *)localpath
{
    if (self = [super init]) {
        
        _localPath = [localpath retain];
    }
    return self;
}

- (void)dealloc
{
    [_localPath release]; _localPath = nil;
    [super dealloc];

}
- (id)initWithPath:(NSString *)path withIpod:(IMBiPod *)ipod{
    if (self = [super init]) {
        _ipod = ipod;
        NSString *extension = [path pathExtension].length > 0 ? [@"*." stringByAppendingString:[path pathExtension]]:@"";
        NSArray *supportArr = [@"*.mp4;*.m4v;*.mov" componentsSeparatedByString:@";"];
        if ([supportArr containsObject:extension.lowercaseString]) {
            isSupportToGet = true;
        }
        _filePath = path;
    }
    return self;
}

- (id)initwithDevicePath:(NSString *)path withIpod:(IMBiPod *)ipod{
    if (self = [super init]) {
        _ipod = ipod;
        NSString *extention = [path pathExtension].length > 0 ? [@"*." stringByAppendingString:[path pathExtension]]:@"";
        NSArray *supportArr = [@"*.mp4;*.m4v;*.mov" componentsSeparatedByString:@";"];
        if ([supportArr containsObject:extention.lowercaseString]) {
            isSupportToGet = true;
        }
        _filePath = path;
    }
    return self;
}

- (NSString *)imagePathAfterReadingDeviceVideo:(NSString *)devicePath{
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
    _filePath = tempPath;
    return tempPath;
}

- (NSString *)imageLocalPathReadingDeviceVideo:(NSString *)localPath
{
    NSString *saveFolder = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"video"];
    NSString *tempPath = [saveFolder stringByAppendingPathComponent:localPath.lastPathComponent];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:tempPath]) {
        return tempPath;
    }
    if (![fileManager fileExistsAtPath:saveFolder]) {
        [fileManager createDirectoryAtPath:saveFolder withIntermediateDirectories:YES attributes:nil error:NULL];
    }
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
            
            uint32_t n = [openFile readN:bufsz bytes:buff];
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


- (NSString *)getInfo{
    if (!isSupportToGet) {
        return nil;
    }
    NSString *tmpFile = [[_filePath stringByDeletingPathExtension] stringByAppendingString:@".tmp.png"];
    
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-y", @"-i",[NSString stringWithFormat:@"%@",_filePath], @"-vframes", @"1", @"-ss", @"0:0:0", @"-an", @"-vcodec", @"png",@"-f",@"rawvideo",@"-s",@"640*480",[NSString stringWithFormat:@"%@",tmpFile], nil];
    [self runFFMpeg:params];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:_filePath]) {
        [fileManager removeItemAtPath:_filePath error:NULL];
    }
    return tmpFile;
}

- (NSString *)getVideoArtWork
{
    NSString *tmpFile = [[[self imageLocalPathReadingDeviceVideo:_localPath] stringByDeletingPathExtension] stringByAppendingString:@".tmp.png"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:tmpFile]){
        [fileManager removeItemAtPath:tmpFile error:nil];
    }
    IMBMediaInfo *mediaInfo = [IMBMediaInfo singleton];
    if (mediaInfo.videowidth.intValue == 0) {
        mediaInfo.videowidth = [NSNumber numberWithInt:640];
    }
    if (mediaInfo.videoheight.intValue == 0) {
        mediaInfo.videoheight = [NSNumber numberWithInt:480];
    }
    NSString *widthandheight = nil;
    if (_isMovies) {
        widthandheight = [NSString stringWithFormat:@"%@*%@",mediaInfo.videowidth,mediaInfo.videoheight];
    }else{
        widthandheight = [NSString stringWithFormat:@"%@*%@",@"640",@"480"];
    }
    
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-y", @"-i",[NSString stringWithFormat:@"%@",_localPath], @"-vframes", @"1", @"-ss", @"0:0:1", @"-an", @"-vcodec", @"png",@"-f",@"rawvideo",@"-s",widthandheight,[NSString stringWithFormat:@"%@",tmpFile], nil];
    [self runFFMpeg:params];
    
    if ([fileManager fileExistsAtPath:tmpFile]) {
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:tmpFile];
        NSData *imageData = [self scalingImage:image];
        [fileManager removeItemAtPath:tmpFile error:nil];
        [imageData writeToFile:tmpFile atomically:YES];
        [image release];
    }
    
    usleep(200);
    return tmpFile;
}

- (NSString *)getDeviceInfo{
    if (!isSupportToGet) {
        return nil;
    }
    NSString *tmpFile = [[[self imagePathAfterReadingDeviceVideo:_filePath] stringByDeletingPathExtension] stringByAppendingString:@".tmp.png"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:tmpFile]){
        return tmpFile;
    }
    
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-y", @"-i",[NSString stringWithFormat:@"%@",_filePath], @"-vframes", @"1", @"-ss", @"0:0:0", @"-an", @"-vcodec", @"png",@"-f",@"rawvideo",@"-s",@"640*480",[NSString stringWithFormat:@"%@",tmpFile], nil];
    [self runFFMpeg:params];
    usleep(200);
    if ([fileManager fileExistsAtPath:_filePath]) {
        [fileManager removeItemAtPath:_filePath error:NULL];
    }
    return tmpFile;
}

- (NSString*) runFFMpeg:(NSArray*)params {
    //需要用中文
    NSString* ffmpegPath = [[NSBundle mainBundle] pathForResource:@"ffmpeg" ofType:@""];
    
    if (params != nil) {
        if (_ffmpegOutputStr != nil) {
            [_ffmpegOutputStr release];
        }
        _ffmpegOutputStr = [[NSMutableString alloc] init];
        NSLog(@"params:%@",params);
        NSTask *task = [[NSTask alloc] init];
        //Todo这里需要异步操作!!
        [task setLaunchPath: ffmpegPath];
        [task setArguments: params];
        NSPipe *errorPipe = [NSPipe pipe];
        [task setStandardError:errorPipe];
        NSFileHandle *errFile = [errorPipe fileHandleForReading];
        [errFile waitForDataInBackgroundAndNotify];
        [task launch];
        [task waitUntilExit];
        sleep(1);
        int status = [task terminationStatus];
        
        if (status == 0)
            NSLog(@"Task succeeded.");
        else
            NSLog(@"Task failed.");
        //NSLog(@"terminationStatus %i", [task terminationStatus]);
        NSLog(@"DONE:%@",_ffmpegOutputStr);
        //[params release];
        return _ffmpegOutputStr;
    }
    return nil;
}

- (NSData *)scalingImage:(NSImage *)image {
    NSData *compressImageData = nil;
    if (image != nil) {
        if (image.size.width >= image.size.height && image.size.height > 0) {
            //按宽=lenght压缩
            int w = image.size.width;
            int h = image.size.height;
            int W = 600;
            int H = (int)(((double)h / w) * W);
            if (((double)h / w) * W < 1.0) {
                H = 1;
            }
            @try {
                compressImageData = [self suchAsScalingImage:image width:W height:H];
            }
            @catch (NSException *exception) {
                //                [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"scaling image failed, reason is %@", [exception reason]]];
            }
        }else if (image.size.height > image.size.width && image.size.width > 0) {
            //按高=lenght压缩
            int w = image.size.width;
            int h = image.size.height;
            int H = 1024;
            int W = (int)(((double)w / h) * H);
            if (((double)w / h) * H < 1.0) {
                W = 1;
            }
            @try {
                compressImageData = [self suchAsScalingImage:image width:W height:H];
            }
            @catch (NSException *exception) {
                //                [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"scaling image failed, reason is %@", [exception reason]]];
            }
        }
    }
    return compressImageData;
}

- (NSData *) suchAsScalingImage:(NSImage *)image width:(int)scalWidth height:(int)scalHeight{
    NSImage *scalingimage = [[NSImage alloc] initWithSize:NSMakeSize(600, 1024)];
    [scalingimage lockFocus];
    NSRectFill(NSMakeRect(0, 0, 600, 1024));
    [[NSGraphicsContext currentContext]setImageInterpolation:NSImageInterpolationHigh];
    [image drawInRect:NSMakeRect((600 - scalWidth)/2, (1024 - scalHeight)/2, scalWidth, scalHeight) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    
    NSData *tempdata = nil;
    NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect: NSMakeRect(0, 0, 600, 1024)];
    tempdata = [bitmap representationUsingType:NSPNGFileType properties:nil];
    [bitmap release];
    [scalingimage unlockFocus];
    [scalingimage release];
    
    return tempdata;
}
@end
