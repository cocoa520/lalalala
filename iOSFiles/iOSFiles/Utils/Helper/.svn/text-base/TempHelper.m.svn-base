//
//  TempHelper.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/15.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "TempHelper.h"
//#import "IMBLogManager.h"
#import <SystemConfiguration/SystemConfiguration.h>
//#import "IMBSoftWareInfo.h"
#import "IMBNotificationDefine.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>

@implementation TempHelper

+(NSString*)getAppSupportPath{
    NSString *appTempPath;
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *identifier = [bundle bundleIdentifier];
    NSString *appName = [[bundle infoDictionary] objectForKey:@"CFBundleName"];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *homeDocumentsPath = [[[manager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] objectAtIndex:0] path];
    appTempPath =[[homeDocumentsPath stringByAppendingPathComponent:identifier] stringByAppendingPathComponent:appName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:appTempPath]) {
        [fileManager createDirectoryAtPath:appTempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return appTempPath;
}

//+(NSString *)currentSelectionLanguage{
//    IMBSoftWareInfo *softInfo = [IMBSoftWareInfo singleton];
//    int chooseLgCount = softInfo.chooseLanguageType;
//    if (chooseLgCount == 0) {
//        return @"en";
//    }else if (chooseLgCount == 1){
//        return @"ja";
//    }else if (chooseLgCount == 2){
//        return @"fr";
//    }else if (chooseLgCount == 3){
//        return @"de";
//    }else if (chooseLgCount == 4){
//        return @"cl";
//    }else if (chooseLgCount == 5){
//        return @"hl";
//    }else if (chooseLgCount == 8){
//        return @"ar";
//    }else{
//        return @"es";
//    }
//}

//+ (NSMutableDictionary *)customDimension {
//    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
//    IMBSoftWareInfo *softInfo = [IMBSoftWareInfo singleton];
//    if (!softInfo.isIronsrc) {
//        [dict setObject:@"generalSource" forKey:@"cd4"];
//    }else {
//        [dict setObject:@"ironSource" forKey:@"cd4"];
//    }
//    return dict;
//}

+(NSString*)getAppTempPath {
    NSString *tmpPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"tmp"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpPath;
}

+(NSString*)getAppDownloadDefaultPath {
    NSString *tmpPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"DownloadDefaultPath"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpPath;
}

+(NSString*)getAppDownloadCachePath {
    NSString *tmpPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"DownloadCache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpPath;
}

+ (NSString *)getSoftwareBackupFolderPath:(NSString *)name withUuid:(NSString *)uuid {
    NSString *tmpFolder = [[TempHelper getAppSupportPath] stringByAppendingPathComponent:@"iTunesBackup"];
    NSString *path = [[tmpFolder stringByAppendingPathComponent:name] stringByAppendingPathComponent:uuid];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+(NSString*)getAppIpswPath {
    NSString *tmpPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"ipsw"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpPath;
}

+(NSString*)getAppSkinPath {
    NSString *tmpPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"Skin"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpPath;
}

+(NSString*)getAppiMobieConfigPath {
    NSString *tmpPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"iMobieConfig"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpPath;
}

//备份文件路径
+ (NSString *)getBackupFolderPath
{
    NSString *libraryPath = [self getLibraryPath];
    NSString *backupFolderPath = [NSString stringWithFormat:@"%@/Application Support/MobileSync/Backup",libraryPath];
    return backupFolderPath;
}

+ (NSString *)getLibraryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = nil;
    if ([paths count]>0) {
        libraryPath = [paths objectAtIndex:0];
    }
    return libraryPath;
}

+ (NSString *)getAppCachePathInPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tmpPath = path;
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *appTmpPath = [tmpPath stringByAppendingPathComponent:@"Application"];
    if (![fileManager fileExistsAtPath:appTmpPath]) {
        [fileManager createDirectoryAtPath:appTmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return tmpPath;
}

+ (NSMutableDictionary*)getPlistFileDir:(NSString*)Path {
    NSMutableDictionary *manifest = nil;
    if (Path != nil) {
        manifest = [NSMutableDictionary dictionaryWithContentsOfFile:Path];
    }
    return manifest;
}

+ (BOOL)stringIsNilOrEmpty:(NSString*)string {
    if (string == nil || [string isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

+(BOOL)isInternetAvail
{
    return [self checkSiteAvail:@"google.com"];
}
+(BOOL)checkSiteAvail:(NSString*)urlStr
{
    const char *hostName = [urlStr cStringUsingEncoding:NSASCIIStringEncoding];
    SCNetworkReachabilityRef target;
    SCNetworkConnectionFlags flags = 0;
    target = SCNetworkReachabilityCreateWithName(NULL, hostName);
    SCNetworkReachabilityGetFlags(target, &flags);
    NSLog(@"flag %d", flags);
    CFRelease(target);
    return (flags == kSCNetworkFlagsReachable) || (flags == (kSCNetworkFlagsReachable | kSCNetworkFlagsTransientConnection)) ;
}


//+ (NSData *)scalingImage:(NSImage *)image withLenght:(int)lenght {
//    NSData *compressImageData = nil;
//    if (image != nil) {
//        if (image.size.width >= image.size.height && image.size.height > 0) {
//            //按宽=lenght压缩
//            int w = image.size.width;
//            int h = image.size.height;
//            int W = lenght;
//            int H = (int)(((double)h / w) * W);
//            if (((double)h / w) * W < 1.0) {
//                H = 1;
//            }
//            @try {
//                compressImageData = [self suchAsScalingImage:image width:W height:H];
//            }
//            @catch (NSException *exception) {
////                [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"scaling image failed, reason is %@", [exception reason]]];
//            }
//        }else if (image.size.height > image.size.width && image.size.width > 0) {
//            //按高=lenght压缩
//            int w = image.size.width;
//            int h = image.size.height;
//            int H = lenght;
//            int W = (int)(((double)w / h) * H);
//            if (((double)w / h) * H < 1.0) {
//                W = 1;
//            }
//            @try {
//                compressImageData = [self suchAsScalingImage:image width:W height:H];
//            }
//            @catch (NSException *exception) {
////                [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"scaling image failed, reason is %@", [exception reason]]];
//            }
//        }
//    }
//    return compressImageData;
//}

//创建图片
//+ (NSData *)createThumbnail:(NSImage *)sourceImage withWidth:(int)scalWidth withHeight:(int)scalHeight {
//    NSImage *cropImage = nil;
//    NSData *scalingImageData = nil;
//    if (sourceImage != nil) {
//        if (sourceImage.size.width > sourceImage.size.height && sourceImage.size.height > 0) {
//            int h = sourceImage.size.height;
//            if (h > 400) {//创建缩略图的宽度不大于400；
//                h = 400;
//            }
//            //按高裁剪
//            cropImage = [self cutImageForSize:sourceImage width:h height:h type:@"H"];
//        }else if (sourceImage.size.height >= sourceImage.size.width && sourceImage.size.width > 0){
//            int w = sourceImage.size.width;
//            if (w > 400) {//创建缩略图的宽度不大于400；
//                w = 400;
//            }
//            //按宽裁剪
//            cropImage = [self cutImageForSize:sourceImage width:w height:w type:@"W"];
//        }
//    }
//    if (cropImage != nil) {
//        //等比例压缩图片
//        scalingImageData = [self suchAsScalingImage:cropImage width:scalWidth height:scalHeight];
//    }
//    
//    return scalingImageData;
//}

//+ (NSData *) suchAsScalingImage:(NSImage *)image width:(int)scalWidth height:(int)scalHeight{
//    NSImage *scalingimage = [[NSImage alloc] initWithSize:NSMakeSize(scalWidth, scalHeight)];
//    [scalingimage lockFocus];
//    NSRectFill(NSMakeRect(0, 0, scalWidth, scalHeight));
//    [[NSGraphicsContext currentContext]setImageInterpolation:NSImageInterpolationHigh];
//    [image drawInRect:NSMakeRect(0, 0, scalWidth, scalHeight) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
//    
//    NSData *tempdata = nil;
//    NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect: NSMakeRect(0, 0, scalWidth, scalHeight)];
//    tempdata = [bitmap representationUsingType:NSJPEGFileType properties:nil];
//    [bitmap release];
//    [scalingimage unlockFocus];
//    [scalingimage release];
//    
//    return tempdata;
//}

//裁剪图片(此处是先将图片缩放到剪切的最小尺寸，再裁剪)
//+ (NSData *)scaleCutImage:(NSImage *)image width:(int)cutWidth height:(int)cutHeight type:(NSString *)cutType {
//    float scalWidth = 0;
//    float scalHeight = 0;
//    if (image.size.width / cutWidth > image.size.height / cutHeight) {
//        scalWidth = image.size.width * 1.0 / (image.size.height / cutHeight);
//        scalHeight = cutHeight;
//    }else {
//        scalWidth = cutWidth;
//        scalHeight = image.size.height * 1.0 / (image.size.width / cutWidth);
//    }
//    
//    NSImage *scalingimage = nil;
//    if (scalWidth != 0 && scalHeight != 0) {
//        scalingimage = [[NSImage alloc] initWithSize:NSMakeSize(scalWidth, scalHeight)];
//        [scalingimage lockFocus];
//        NSRectFill(NSMakeRect(0, 0, scalWidth, scalHeight));
//        [[NSGraphicsContext currentContext]setImageInterpolation:NSImageInterpolationHigh];
//        [image drawInRect:NSMakeRect(0, 0, scalWidth, scalHeight) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
//        [scalingimage unlockFocus];
//    }else {
//        scalingimage = [image retain];
//    }
//    
//    int toWidth = cutWidth;
//    int toHeight = cutHeight;
//    int x,y,ow,oh = 0;
//    if ([cutType isEqualToString: @"H"]) {
//        x = (scalingimage.size.width - toHeight) / 2;
//        y = (scalingimage.size.height - toHeight) / 2;
//    }else{
//        x = (scalingimage.size.width - toWidth) / 2;
//        y = (scalingimage.size.height - toWidth) / 2;
//    }
//    ow = toWidth;
//    oh = toHeight;
//    NSImage *targetImage = [[NSImage alloc] initWithSize:NSMakeSize(ow, oh)];
//    [targetImage lockFocus];
//    NSRectFill(NSMakeRect(0, 0, ow, oh));
//    [scalingimage drawInRect:NSMakeRect(0, 0, toWidth, toHeight) fromRect:NSMakeRect(x, y, ow, oh) operation:NSCompositeSourceOver fraction:1.0];
//    
//    NSData *targetData = nil;
//    NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect: NSMakeRect(0, 0, ow, oh)];
//    targetData = [bitmap representationUsingType:NSJPEGFileType properties:nil];
//    [bitmap release];
//    [targetImage unlockFocus];
//    [targetImage release];
//    [scalingimage release];
//    
//    return targetData;
//}

+ (int)getDeviceVersionNumber:(NSString *)version {
    NSString *versionstrone = nil;
    if (version.length>0) {
        NSRange range;
        if ([version hasPrefix:@"10"]) {
            range.length = 2;
            range.location = 0;
        }else {
            range.length = 1;
            range.location = 0;
        }
        versionstrone = [version substringWithRange:range];
    }else
    {
        return 5;
    }
    return [versionstrone intValue];
}

//如果file已经存在，则生成别名
+(NSString*)getFilePathAlias:(NSString*)filePath {
    NSString *newPath = filePath;
    NSFileManager *fm = [NSFileManager defaultManager];
    int i = 1;
    NSString *filePathWithOutExt = [filePath stringByDeletingPathExtension];
    NSString *fileExtension = [filePath pathExtension];
    while ([fm fileExistsAtPath:newPath]) {
        newPath = [NSString stringWithFormat:@"%@(%d).%@",filePathWithOutExt,i++,fileExtension];
    }
    return newPath;
}

+ (NSString*)getRandomFileName:(int)length {
    char charArr[length + 1];
    srandom((unsigned int)time((time_t *)NULL));
    for (int i = 0; i < length; i++) {
        long num = random();
        charArr[i] = (int)num % 52;
        if (charArr[i] < 26) {
            charArr[i] += (91 - 26);
        } else {
            charArr[i] += (123 - 52);
        }
    }
    charArr[length] ='\0';
    return [NSString stringWithCString:charArr encoding:NSUTF8StringEncoding];
}

//创建头像图片
//+ (NSData *)createHeadThumbnail:(NSImage *)sourceImage withWidth:(int)scalWidth withHeight:(int)scalHeight {
//    NSImage *cropImage = nil;
//    NSData *scalingImageData = nil;
//    if (sourceImage != nil) {
//        if (sourceImage.size.width > sourceImage.size.height && sourceImage.size.height > 0) {
//            int h = sourceImage.size.height;
//            if (h > 800) {//创建缩略图的宽度不大于800；
//                h = 800;
//            }
//            //按高裁剪
//            cropImage = [self cutImageForSize:sourceImage width:h height:h type:@"H"];
//        }else if (sourceImage.size.height >= sourceImage.size.width && sourceImage.size.width > 0){
//            int w = sourceImage.size.width;
//            if (w > 800) {//创建缩略图的宽度不大于800；
//                w = 800;
//            }
//            //按宽裁剪
//            cropImage = [self cutImageForSize:sourceImage width:w height:w type:@"W"];
//        }
//    }
//    if (cropImage != nil) {
//        //等比例压缩图片
//        scalingImageData = [self suchAsScalingImage:cropImage width:scalWidth height:scalHeight];
//    }
//    
//    return scalingImageData;
//}

//裁剪图片
//+ (NSImage *) cutImageForSize:(NSImage *)image width:(int)cutWidth height:(int)cutHeight type:(NSString *)cutType{
//    int toWidth = cutWidth;
//    int toHeight = cutHeight;
//    int x,y,ow,oh = 0;
//    if ([cutType isEqualToString: @"H"]) {
//        x = (image.size.width - toHeight) / 2;
//        y = (image.size.height - toHeight) / 2;
//        //        ow = image.size.height;
//        //        oh = image.size.height * toHeight / toWidth;
//        ow = toWidth;
//        oh = toHeight;
//    }else{
//        x = (image.size.width - toWidth) / 2;
//        y = (image.size.height - toWidth) / 2;
//        //        ow = image.size.width;
//        //        oh = image.size.width * toHeight / toWidth;
//        ow = toWidth;
//        oh = toHeight;
//        
//    }
//    NSImage *targetImage = [[[NSImage alloc] initWithSize:NSMakeSize(ow, oh)] autorelease];
//    [targetImage lockFocus];
//    NSRectFill(NSMakeRect(0, 0, ow, oh));
//    [image drawInRect:NSMakeRect(0, 0, toWidth, toHeight) fromRect:NSMakeRect(x, y, ow, oh) operation:NSCompositeSourceOver fraction:1.0];
//    [targetImage unlockFocus];
//    
//    return targetImage;
//}
//
////裁剪图片
//+ (NSImage *) cutImageForSize:(NSImage *)image width:(int)cutWidth height:(int)cutHeight x:(int)x y:(int)y {
//    NSImage *targetImage = [[[NSImage alloc] initWithSize:NSMakeSize(cutWidth, cutHeight)] autorelease];
//    [targetImage lockFocus];
//    NSRectFill(NSMakeRect(0, 0, cutWidth, cutHeight));
//    [image drawInRect:NSMakeRect(0, 0, cutWidth, cutHeight) fromRect:NSMakeRect(x, y, cutWidth, cutHeight) operation:NSCompositeSourceOver fraction:1.0];
//    [targetImage unlockFocus];
//    
//    return targetImage;
//}
//
////裁剪成圆形图片
//+ (NSImage *)cutImageWithImage:(NSImage *)image border:(int)border{
//    
//    NSImage *targetImage = [[[NSImage alloc] initWithSize:NSMakeSize(image.size.width, image.size.height)] autorelease];
//    [targetImage lockFocus];
//    
////    NSSize size = image.size;
//    
//    //创建图片上下文
////    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
//    
//    //绘制边框的圆
////    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
////    CGContextAddEllipseInRect(context, CGRectMake(0, 0, size.width, size.height));
////    
////    //剪切可视范围
////    CGContextClip(context);
//    
//    //绘制边框图片
////    [borderImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    
//    
//    //设置头像frame
//    CGFloat iconX = 0;//border / 2;
//    CGFloat iconY = 0;//border / 2;
//    CGFloat iconW = image.size.width;
//    CGFloat iconH = image.size.height;
//    
//    //绘制圆形头像范围
//    CGContextAddEllipseInRect(context, CGRectMake(iconX, iconY, iconW, iconH));
//    
//    //剪切可视范围
//    CGContextClip(context);
//    
//    [image drawInRect:NSMakeRect(iconX, iconY, iconW, iconH) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
//    
//    //绘制头像
////    [image drawInRect:NSMakeRect(iconX, iconY, iconW, iconH)];
//    
//    //取出整个图片上下文的图片
////    NSImage *iconImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    [targetImage unlockFocus];
//    
//    return targetImage;
//    
////    return iconImage;
//}

//计算text的size
//+ (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize {
//    NSRect textBounds = NSMakeRect(0, 0, 0, 0);
//    if (text) {
//        NSAttributedString *as = [[NSAttributedString alloc] initWithString:text];
//        NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
//        [paragraphStyle setAlignment:NSCenterTextAlignment];
//        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [NSFont fontWithName:@"Helvetica Neue" size:fontSize], NSFontAttributeName,
//                                    paragraphStyle, NSParagraphStyleAttributeName,
//                                    nil];
//        NSSize textSize = [as.string sizeWithAttributes:attributes];
//        textBounds = NSMakeRect(0, 0, textSize.width, textSize.height);
//        [as release];
//    }
//    return textBounds;
//}

+ (BOOL)unTarFile:(NSString*)filePath unTarPath:(NSString*)unTarPath toDestFolder:toDestFolder {
    NSMutableArray * args = [NSMutableArray
                             arrayWithObjects:@"xvf",filePath, nil];
    if (unTarPath != nil && ![unTarPath isEqualToString:@""]) {
        [args addObject:unTarPath];
    }
    NSTask *tarTask = [[NSTask alloc] init];
    [tarTask setLaunchPath:@"/usr/bin/tar"];
    [tarTask setArguments:args];
    [tarTask setCurrentDirectoryPath:toDestFolder];
    [tarTask waitUntilExit];
    [tarTask launch];
    [tarTask release];
    return YES;
}

+ (BOOL)checkInternetAvailble {
    BOOL isFromServer = NO;
    [self getDateTimeFromService:&isFromServer];
    return isFromServer;
}

//+ (void)exoprtPdfWithPath:(NSString *)path withcontrol:(id)control withmakeSizew:(int )width withhigh:(int )high{
//    NSString *pdfFilePath = path;
//    //    if ([fileManager fileExistsAtPath:pdfFilePath]) {
//    //        pdfFilePath = [StringHelper createDifferentfileName:pdfFilePath];
//    //    }
//    
//    NSPrintInfo *sharedInfo = nil;
//    NSMutableDictionary *sharedDict = nil;
//    NSPrintInfo *printInfo = nil;
//    NSMutableDictionary *printInfoDict = nil;
//    sharedInfo = [NSPrintInfo sharedPrintInfo];
//    sharedDict = [sharedInfo dictionary];
//    printInfoDict = [NSMutableDictionary dictionaryWithDictionary:
//                     sharedDict];
//    [printInfoDict setObject:NSPrintSaveJob
//                      forKey:NSPrintJobDisposition];
//    [printInfoDict setObject:[NSDate date] forKey:NSPrintTime];
//    [printInfoDict setObject:pdfFilePath forKey:NSPrintSavePath];
//    printInfo = [[NSPrintInfo alloc] initWithDictionary: printInfoDict];
//    [printInfo setHorizontalPagination: NSFitPagination];
//    [printInfo setVerticalPagination: NSAutoPagination];
//    [printInfo setVerticallyCentered:NO];
//    
//    [printInfo setPaperSize:NSMakeSize(width, high)];
//    [printInfo setLeftMargin:0];
//    [printInfo setRightMargin:0];
//    [printInfo setTopMargin:0];
//    [printInfo setBottomMargin:0];
//    NSPrintOperation *printOp = nil;
//    if ([control isKindOfClass:[NSView class]]) {
//        printOp = [NSPrintOperation printOperationWithView:(NSView*)control
//                                                                   printInfo:printInfo];
//    }else{
//        printOp = [NSPrintOperation printOperationWithView:control
//                                                 printInfo:printInfo];
//    }
//
//    [printOp setShowsPrintPanel:NO];
//    [printOp setShowsProgressPanel:NO];
//    [printOp runOperation];
//
//}

//+ (NSString *)checkiCloudInternetAvailble {
//    BOOL isFromServer = NO;
//    NSString *retvalue = [TempHelper pingiCloudDomain:@"http://143.95.78.61/"];
//    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
//    if (retvalue) {
//        soft.domainNetwork = @"http://143.95.78.61/";
//    }else{
//        retvalue = [TempHelper pingiCloudDomain:@"http://cal.imobie.us/"];
//        if (retvalue) {
//            soft.domainNetwork = @"http://cal.imobie.us/";
//        }else{
//            retvalue = [TempHelper pingiCloudDomain:@"http://imobie-001-site1.mywindowshosting.com/"];
//            if (retvalue) {
//                soft.domainNetwork = @"http://imobie-001-site1.mywindowshosting.com/";
//            }else{
//                retvalue = [TempHelper pingiCloudDomain:@"http://imobie.us.179.gppnetwork.com/"];
//                if (retvalue) {
//                    soft.domainNetwork = @"http://imobie.us.179.gppnetwork.com/";
//                }else{
//                    retvalue = [TempHelper pingiCloudDomain:@"https://imobie.us/"];
//                    if (retvalue) {
//                        soft.domainNetwork = @"https://imobie.us/";
//                    }else{
//                        retvalue = [TempHelper pingiCloudDomain:@"http://call.imobie.us//"];
//                        if (retvalue) {
//                            soft.domainNetwork = @"http://call.imobie.us//";
//                        }
//                    }
//                }
//            }
//        }
//    }
//    NSDate *localDatetime = nil;
//    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"retvalue:%@", retvalue]];
//    if (retvalue != nil && ![retvalue isEqualToString:@""]) {
//        isFromServer = YES;
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
//        NSDate *greenwishTime = [dateFormatter dateFromString:retvalue];
//        [dateFormatter release];
//        dateFormatter = nil;
//        localDatetime = [self greenwishTime2LocalTime:greenwishTime];
//    } else {
//        isFromServer = NO;
//    }
//    if (isFromServer == YES) {
//        return soft.domainNetwork;
//    }else{
//        return @"";
//    }
//}

+(BOOL)connectedToNetwork{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

//+ (NSDate*)getDateTimeFromService:(BOOL*)isFromServer {
//    NSString *retvalue = [TempHelper pingDomain:@"http://143.95.78.61/"];
//    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
//    if (retvalue) {
//        soft.domainNetwork = @"http://143.95.78.61/";
//    }else{
//        retvalue = [TempHelper pingDomain:@"http://imobie-001-site1.mywindowshosting.com/"];
//        if (retvalue) {
//            soft.domainNetwork = @"http://imobie-001-site1.mywindowshosting.com/";
//        }else
//        {
//            retvalue = [TempHelper pingDomain:@"http://cal.imobie.us/"];
//            if (retvalue) {
//                soft.domainNetwork = @"http://cal.imobie.us/";
//            }else{
//                retvalue = [TempHelper pingDomain:@"http://imobie.us/"];
//                if (retvalue) {
//                    soft.domainNetwork = @"http://imobie.us/";
//                }else{
//                    retvalue = [TempHelper pingDomain:@"http://imobie.us.179.gppnetwork.com/"];
//                    if (retvalue) {
//                        soft.domainNetwork = @"http://imobie.us.179.gppnetwork.com/";
//                    }
//                }
//            }
//        }
//    }
//    NSDate *localDatetime = nil;
//    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"retvalue:%@", retvalue]];
//    if (retvalue != nil && ![retvalue isEqualToString:@""]) {
//        *isFromServer = YES;
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
//        NSDate *greenwishTime = [dateFormatter dateFromString:retvalue];
//        [dateFormatter release];
//        dateFormatter = nil;
//        localDatetime = [self greenwishTime2LocalTime:greenwishTime];
//    } else {
//        *isFromServer = NO;
//    }
//    return localDatetime;
//}


//+ (NSString *)pingiCloudDomain:(NSString *)networkDomain
//{
//    NSString *netPath = [networkDomain stringByAppendingString:@"USERREGWEBS.asmx"];
//    NSURL *url = [NSURL URLWithString:netPath];
//    NSString *nameSpace = @"http://tempuri.org/";
//    WSMethodInvocationRef mySoapRef = WSMethodInvocationCreate((CFURLRef)url, (CFStringRef)@"GetServerDateTime", kWSSOAP2001Protocol);
//    
//    NSDictionary *reqHeaders = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@%@", nameSpace, @"GetServerDateTime"] forKey:@"SOAPAction"];
//    WSMethodInvocationSetProperty(mySoapRef, kWSSOAPMethodNamespaceURI,
//                                  (CFStringRef)nameSpace);
//    WSMethodInvocationSetProperty(mySoapRef, kWSHTTPExtraHeaders,
//                                  (CFDictionaryRef)reqHeaders);
//    WSMethodInvocationSetProperty(mySoapRef, kWSHTTPFollowsRedirects,
//                                  kCFBooleanTrue);
//    // set debug props
//    WSMethodInvocationSetProperty(mySoapRef, kWSDebugIncomingBody,
//                                  kCFBooleanTrue);
//    WSMethodInvocationSetProperty(mySoapRef, kWSDebugIncomingHeaders,
//                                  kCFBooleanTrue);
//    WSMethodInvocationSetProperty(mySoapRef, kWSDebugOutgoingBody,
//                                  kCFBooleanTrue);
//    WSMethodInvocationSetProperty(mySoapRef, kWSDebugOutgoingHeaders,
//                                  kCFBooleanTrue);
//    
//    NSDictionary *result = (NSDictionary *)WSMethodInvocationInvoke(mySoapRef);
////    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"resultDir:%@", [result description]]];
//    
//    // get HTTP response from SOAP request so we can see the status code
//    //    [result objectForKey:(id)kWSHTTPResponseMessage];
//    NSDictionary *resultDir = [result objectForKey:@"/Result"];
//    NSArray *keyArr = resultDir.allKeys;
//    NSString *retvalue = nil;
//    for (NSString *key in keyArr) {
//        retvalue = [resultDir valueForKey:key];
//    }
//    return retvalue;
//    
//}


+ (NSDate*)greenwishTime2LocalTime:(NSDate*)greenwishTime {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [greenwishTime dateByAddingTimeInterval:interval];
    return localeDate;
}

+ (NSString *)getCurrentTimeStamp {
    NSDate *newDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *newDateOne = [dateFormat stringFromDate:newDate];
    [dateFormat setFormatterBehavior:NSDateFormatterFullStyle];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    return newDateOne;
}

//+ (NSString *)pingDomain:(NSString *)networkDomain
//{
//    NSString *netPath = [networkDomain stringByAppendingString:@"USERREGWEBS.asmx"];
//    NSURL *url = [NSURL URLWithString:netPath];
//    NSString *nameSpace = @"http://tempuri.org/";
//    WSMethodInvocationRef mySoapRef = WSMethodInvocationCreate((CFURLRef)url, (CFStringRef)@"GetServerDateTime", kWSSOAP2001Protocol);
//    
//    NSDictionary *reqHeaders = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@%@", nameSpace, @"GetServerDateTime"] forKey:@"SOAPAction"];
//    WSMethodInvocationSetProperty(mySoapRef, kWSSOAPMethodNamespaceURI,
//                                  (CFStringRef)nameSpace);
//    WSMethodInvocationSetProperty(mySoapRef, kWSHTTPExtraHeaders,
//                                  (CFDictionaryRef)reqHeaders);
//    WSMethodInvocationSetProperty(mySoapRef, kWSHTTPFollowsRedirects,
//                                  kCFBooleanTrue);
//    // set debug props
//    WSMethodInvocationSetProperty(mySoapRef, kWSDebugIncomingBody,
//                                  kCFBooleanTrue);
//    WSMethodInvocationSetProperty(mySoapRef, kWSDebugIncomingHeaders,
//                                  kCFBooleanTrue);
//    WSMethodInvocationSetProperty(mySoapRef, kWSDebugOutgoingBody,
//                                  kCFBooleanTrue);
//    WSMethodInvocationSetProperty(mySoapRef, kWSDebugOutgoingHeaders,
//                                  kCFBooleanTrue);
//    
//    NSDictionary *result = (NSDictionary *)WSMethodInvocationInvoke(mySoapRef);
//    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"resultDir:%@", [result description]]];
//    
//    // get HTTP response from SOAP request so we can see the status code
//    //    [result objectForKey:(id)kWSHTTPResponseMessage];
//    NSDictionary *resultDir = [result objectForKey:@"/Result"];
//    NSArray *keyArr = resultDir.allKeys;
//    NSString *retvalue = nil;
//    for (NSString *key in keyArr) {
//        retvalue = [resultDir valueForKey:key];
//    }
//    return retvalue;
//    
//}

+ (NSString*)getiCloudLocalPath {
    NSString *icloudLocalPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"iCloud"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:icloudLocalPath]) {
        [fileManager createDirectoryAtPath:icloudLocalPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return icloudLocalPath;
}

//获取当前任务所占用的内存(单位:MB)
+ (double)usedMemory {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    if(kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

+ (NSString*) resourcePathOfAppDir:(NSString*)resourceName ofType:type {
    NSString *appDirectory = [TempHelper getAppSupportPath];
    NSString *resourcePath = [[appDirectory stringByAppendingPathComponent:resourceName] stringByAppendingPathExtension:type];
    NSFileManager* sharedFM = [NSFileManager defaultManager];
    if (![sharedFM fileExistsAtPath:resourcePath]) {
        NSString *bundelPath = [[NSBundle mainBundle] pathForResource:resourceName ofType:type];
        [sharedFM copyItemAtPath:bundelPath toPath:resourcePath error:nil];
    }
    return resourcePath;
}

+ (NSString*)replaceSpecialChar:(NSString*)validateString {
    if ([self stringIsNilOrEmpty:validateString] == NO) {
        validateString = [validateString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"/" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@":" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"*" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"?" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"<" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@">" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"|" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"%" withString:@""];
    }
    return validateString;
}

+ (NSURL *)getHashWebserviceUrl {
    //NSURL *url = [NSURL URLWithString:@"http://dl.imobie.com/verifyonline/webservice/wsdlsoap/service.php?wsdl"];
    //NSURL *url = [NSURL URLWithString:@"http://192.168.0.122:8080/webservice/wsdlsoap/service.php?wsdl"];
    //    NSURL *url = [NSURL URLWithString:@"http://192.168.0.109:8080/verifyonline/webservice/wsdlsoap/service.php?wsdl"];
    //NSURL *url = [NSURL URLWithString:@"http://dl.imobie.com:80/verifyonline/php/validationservice.php"];
    NSURL *url = [NSURL URLWithString:@"http://67.225.249.166:80/verifyonline/php/validationservice.php"];
    
    return url;
}

+ (NSString *)getHashWebserviceNameSpace {
    NSString *nameSpace = @"urn:imobie_validation";
    return nameSpace;
}


+ (id)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err != nil) {
        NSLog(@"json解析失败：%@",err);
//        [nc postNotificationName:NOTIFY_ICLOUD_DOWNLOAD_ERROR object:[NSNumber numberWithInt:DownloadNetworkError] userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_iCloudData_NETWORK_FAIL object:dic];
        return nil;
    }
    return dic;
}
+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSString *jsonStr = nil;
    if (dic != nil) {
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
            jsonStr = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
            NSLog(@"jsonStr:%@",jsonStr);
        }
    }
    return jsonStr;
}
//创建导出路径
+ (NSString *)createCategoryPath:(NSString *)path withString:(NSString *)category {
    NSString *exportPath = @"";
    NSFileManager *fm = [NSFileManager defaultManager];
    exportPath = [path stringByAppendingPathComponent:category];
    if ([fm fileExistsAtPath:exportPath]) {
        exportPath = [self getFolderPathAlias:exportPath];
    }
    @try {
        BOOL isDir = NO;
        if ([fm fileExistsAtPath:exportPath isDirectory:&isDir]) {
            if (!isDir) {
                [fm removeItemAtPath:exportPath error:nil];
                [fm createDirectoryAtPath:exportPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }else {
            [fm createDirectoryAtPath:exportPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"create dir failed, reason is %@", exception.reason);
    }
    
    return exportPath;
}



+ (NSString *)createExportPath:(NSString *)path {
    NSString *exPath = @"";
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    exPath = [formatter stringFromDate:date];
    [formatter release];
    exPath = [path stringByAppendingPathComponent:[@"AnyTrans-Export-" stringByAppendingString:exPath]];
    if ([fm fileExistsAtPath:exPath]) {
        exPath = [self getFolderPathAlias:exPath];
    }
    [fm createDirectoryAtPath:exPath withIntermediateDirectories:YES attributes:nil error:nil];
    return exPath;
}

//文件夹存在，生成别名
+ (NSString *)getFolderPathAlias:(NSString *)folderPath {
    NSString *newPath = folderPath;
    NSFileManager *fm = [NSFileManager defaultManager];
    int i = 1;
    while ([fm fileExistsAtPath:newPath]) {
        newPath = [NSString stringWithFormat:@"%@-%d",folderPath,i++];
    }
    return newPath;
}

+ (BOOL)runApp:(NSString*)appName {
    BOOL retVal = NO;
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
                                   [NSString stringWithFormat:@"\
                                    tell application \"%@\"\n\
                                    activate\n\
                                    end tell", appName]
                                   ];
    returnDescriptor = [scriptObject executeAndReturnError:&errorDict];
#if !__has_feature(objc_arc)
    if (scriptObject) [scriptObject release]; scriptObject = nil;
#endif
    if (returnDescriptor != NULL) {
        // successful execution
        if (kAENullEvent != [returnDescriptor descriptorType]) {
            // script returned an AppleScript result
            if (cAEList == [returnDescriptor descriptorType]) {
                // result is a list of other descriptors
            } else {
                // coerce the result to the appropriate ObjC type
            }
        }
        retVal = YES;
    } else {
        // no script result, handle error here
        retVal = NO;
    }
    return retVal;
}

@end
