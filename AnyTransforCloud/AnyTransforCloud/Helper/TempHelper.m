//
//  TempHelper.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/15.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "TempHelper.h"
#import "IMBDriveModel.h"

@implementation TempHelper

+ (NSString*)getAppSupportPath {
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

+ (NSString*)getAppTempPath {
    NSString *tmpPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"tmp"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpPath;
}

+ (NSString*)getAppDownloadDefaultPath {
    NSString *tmpPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"DownloadDefaultPath"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpPath;
}

+ (NSString*)getAppDownloadCachePath {
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

+ (NSString*)getAppIpswPath {
    NSString *tmpPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"ipsw"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpPath;
}

+ (NSString*)getAppSkinPath {
    NSString *tmpPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"Skin"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpPath;
}

+ (NSString*)getAppiMobieConfigPath {
    NSString *tmpPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"iMobieConfig"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpPath;
}

+ (NSString*)getPhotoSqliteConfigPath:(NSString *)path {
    NSString *tmpPath = [[[self getAppSupportPath] stringByAppendingPathComponent:@"iMobieConfig"] stringByAppendingPathComponent:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpPath;
}

+ (NSString*)resourcePathOfAppDir:(NSString*)resourceName ofType:type {
    NSString *appDirectory = [TempHelper getAppSupportPath];
    NSString *resourcePath = [[appDirectory stringByAppendingPathComponent:resourceName] stringByAppendingPathExtension:type];
    NSFileManager* sharedFM = [NSFileManager defaultManager];
    if (![sharedFM fileExistsAtPath:resourcePath]) {
        NSString *bundelPath = [[NSBundle mainBundle] pathForResource:resourceName ofType:type];
        [sharedFM copyItemAtPath:bundelPath toPath:resourcePath error:nil];
    }
    return resourcePath;
}

+ (NSString*)getSystemLastNumberString {
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSString *systemVersion = processInfo.operatingSystemVersionString;
    NSArray *array = [systemVersion componentsSeparatedByString:@"."];
    NSString *lastStr = @"0";
    if (array.count >= 2) {
        lastStr = [array objectAtIndex:1];
    }
    return lastStr;
}

+ (NSImage *)loadFileImage:(FileTypeEnum )type{
    NSImage *image;
    if (type == CommonFile) {
        return  [NSImage imageNamed:@"def_def"];
    }else if (type == ImageFile) {
        return  [NSImage imageNamed:@"def_image"];
    }else if (type == MusicFile) {
        return  [NSImage imageNamed:@"def_muisc"];
    }else if (type == MovieFile) {
        return  [NSImage imageNamed:@"def_video"];
    }else if (type == DocFile) {
        return  [NSImage imageNamed:@"def_word"];
    }else if (type == TxtFile) {
        return  [NSImage imageNamed:@"def_txtfiles"];
    }else if (type == BookFile) {
        return  [NSImage imageNamed:@"def_bookfiles"];
    }else if (type == ZIPFile) {
        return  [NSImage imageNamed:@"def_compress"];
    }else if (type == PPtFile) {
        return  [NSImage imageNamed:@"def_ppt"];
    }else if (type == excelFile) {
        return  [NSImage imageNamed:@"def_excel"];
    }else if (type == contactFile) {
        return  [NSImage imageNamed:@"def_contactfile"];
    }else if (type == dmgFile) {
        return  [NSImage imageNamed:@"def_dmg"];
    }else if (type == Folder) {
        return  [NSImage imageNamed:@"def_folder_mac"];
    }else if (type == AppFile) {
        return  [NSImage imageNamed:@"def_compress"];
    }else if (type == M4a) {
        return  [NSImage imageNamed:@"def_m4a"];
    }else if (type == Wav) {
        return  [NSImage imageNamed:@"def_wav"];
    }else {
        return  [NSImage imageNamed:@"def_def"];
    }
    return image;
}


+ (NSImage *)loadFileTransferImage:(FileTypeEnum )type{
    NSImage *image;
    if (type == CommonFile) {
        return  [NSImage imageNamed:@"def_def32"];
    }else if (type == ImageFile) {
        return  [NSImage imageNamed:@"def_image32"];
    }else if (type == MusicFile) {
        return  [NSImage imageNamed:@"def_muisc32"];
    }else if (type == MovieFile) {
        return  [NSImage imageNamed:@"def_video32"];
    }else if (type == DocFile) {
        return  [NSImage imageNamed:@"def_word32"];
    }else if (type == TxtFile) {
        return  [NSImage imageNamed:@"def_txtfiles32"];
    }else if (type == BookFile) {
        return  [NSImage imageNamed:@"def_bookfiles32"];
    }else if (type == ZIPFile) {
        return  [NSImage imageNamed:@"def_compress32"];
    }else if (type == PPtFile) {
        return  [NSImage imageNamed:@"def_ppt32"];
    }else if (type == excelFile) {
        return  [NSImage imageNamed:@"def_excel32"];
    }else if (type == contactFile) {
        return  [NSImage imageNamed:@"def_contactfile32"];
    }else if (type == dmgFile) {
        return  [NSImage imageNamed:@"def_dmg32"];
    }else if (type == Folder) {
        return  [NSImage imageNamed:@"def_folder_mac32"];
    }else if (type == AppFile) {
        return  [NSImage imageNamed:@"def_compress32"];
    }else if (type == M4a) {
        return  [NSImage imageNamed:@"def_m4a32"];
    }else if (type == Wav) {
        return  [NSImage imageNamed:@"def_wav32"];
    }else {
        return  [NSImage imageNamed:@"def_def32"];
    }
    return image;
}


+ (FileTypeEnum)getFileFormatWithExtension:(NSString *)extension {
    
    NSArray *imageArr = @[@"png",@"jpg",@"gif",@"bmp",@"jpeg",@"tiff"];
    if ([imageArr containsObject:extension]) {
         return ImageFile;
    }
    NSArray *musicArr = @[@"mp3",@"m4a",@"wma",@"wav",@"rm",@"mdi",@"m4r",@"m4b",@"m4p",@"flac",@"amr",@"ogg",@"ac3",@"ape",@"aac",@"mka",@"wv"];
    if ([musicArr containsObject:extension]) {
        return MusicFile;
    }
    NSArray *movieArr = @[@"mp4",@"m4v",@"mov",@"wmv",@"rmvb",@"mkv",@"avi",@"flv",@"rm",@"3gp",@"mpg",@"webm"];
    if ([movieArr containsObject:extension]) {
        return MovieFile;
    }
    if ([extension isEqualToString:@"txt"]) {
        return TxtFile;
    }else if ([extension isEqualToString:@"doc"] || [extension isEqualToString:@"docx"]) {
        return DocFile;
    }else if ([extension isEqualToString:@"zip"]) {
        return ZIPFile;
    }else if ([extension isEqualToString:@"dmg"]) {
        return dmgFile;
    }else if ([extension isEqualToString:@"epub"] || [extension isEqualToString:@"pdf"]) {
        return BookFile;
    }else if ([extension isEqualToString:@"ppt"] || [extension isEqualToString:@"pptx"]) {
        return PPtFile;
    }else if ([extension isEqualToString:@"xlsx"]) {
        return excelFile;
    }else if ([extension isEqualToString:@"vcf"]) {
        return contactFile;
    }else if ([extension isEqualToString:@"m4a"]) {
        return M4a;
    }else if ([extension isEqualToString:@"mav"]) {
        return Wav;
    }
    return CommonFile;
}

+ (void)setDriveDefultImage:(BaseDrive *)drive CloudEntity:(IMBCloudEntity *)cloudEntity {
//    NSString *str = [self getCloudName:drive.driveType DriveName:drive.displayName];
    if ([drive.driveType isEqualToString:OneDriveCSEndPointURL]) {
        cloudEntity.image = [NSImage imageNamed:@"add_onedrive"];
        cloudEntity.categoryCloudEnum = OneDriveEnum;
    }else if ([drive.driveType isEqualToString:GoogleDriveCSEndPointURL]) {
        cloudEntity.image = [NSImage imageNamed:@"add_google"];
        cloudEntity.categoryCloudEnum = GoogleEnum;
    }else if ([drive.driveType isEqualToString:DropboxCSEndPointURL]) {
        cloudEntity.image = [NSImage imageNamed:@"add_dropbox"];
        cloudEntity.categoryCloudEnum = DropBoxEnum;
    }else if ([drive.driveType isEqualToString:BoxCSEndPointURL]) {
        cloudEntity.image = [NSImage imageNamed:@"add_box"];
        cloudEntity.categoryCloudEnum = BoxEnum;
    }else if ([drive.driveType isEqualToString:PCloudCSEndPointURL]) {
        cloudEntity.image = [NSImage imageNamed:@"add_pcloud"];
        cloudEntity.categoryCloudEnum = PCloudEnum;
    }else if ([drive.driveType isEqualToString:FacebookCSEndPointURL]) {
        cloudEntity.image = [NSImage imageNamed:@"add_facebook"];
        cloudEntity.categoryCloudEnum = FaceBookEnum;
    }else if ([drive.driveType isEqualToString:TwitterCSEndPointURL]) {
        cloudEntity.image = [NSImage imageNamed:@"add_twitter"];
        cloudEntity.categoryCloudEnum = TwitterEnum;
    }else if ([drive.driveType isEqualToString:InstagramCSEndPointURL]) {
        cloudEntity.image = [NSImage imageNamed:@"add_ins"];
        cloudEntity.categoryCloudEnum = InsEnum;
    }else if ([drive.driveType isEqualToString:iCloudDriveCSEndPointURL]) {
        cloudEntity.image = [NSImage imageNamed:@"add_icloud"];
        cloudEntity.categoryCloudEnum = iCloudDriveEnum;
    }
    cloudEntity.name = drive.displayName;
    cloudEntity.totalSize = drive.totalCapacity;
    cloudEntity.availableSize = drive.usedCapacity;
    cloudEntity.driveID = drive.driveID;
}

+ (NSString *)getCloudName:(NSString *)type DriveName:(NSString *)driveName {
    NSString *name = nil;
    NSString *str = CustomLocalizedString(@"AddCloud_google", nil);
    if ([type isEqualToString:OneDriveCSEndPointURL]) {
        str = CustomLocalizedString(@"AddCloud_oneDrive", nil);
    }else if ([type isEqualToString:GoogleDriveCSEndPointURL]) {
        str = CustomLocalizedString(@"AddCloud_google", nil);
    }else if ([type isEqualToString:DropboxCSEndPointURL]) {
        str = CustomLocalizedString(@"AddCloud_dropBox", nil);
    }else if ([type isEqualToString:BoxCSEndPointURL]) {
        str = CustomLocalizedString(@"AddCloud_box", nil);
    }else if ([type isEqualToString:PCloudCSEndPointURL]) {
        str = CustomLocalizedString(@"AddCloud_pCloud", nil);
    }
    
    if (driveName && ![driveName isEqualToString:@""]) {
        name = [NSString stringWithFormat:@"%@ %@",driveName,str];
    }else {
        name = str;
    }
    return name;
}

+ (NSImage *)getCloudImage:(NSString *)type {
    NSImage *image = [NSImage imageNamed:@"add_onedrive"];
    if ([type isEqualToString:OneDriveCSEndPointURL]) {
        image = [NSImage imageNamed:@"add_onedrive"];
    }else if ([type isEqualToString:GoogleDriveCSEndPointURL]) {
        image = [NSImage imageNamed:@"add_google"];
    }else if ([type isEqualToString:DropboxCSEndPointURL]) {
        image = [NSImage imageNamed:@"add_dropbox"];
    }else if ([type isEqualToString:BoxCSEndPointURL]) {
        image = [NSImage imageNamed:@"add_box"];
    }else if ([type isEqualToString:PCloudCSEndPointURL]) {
        image = [NSImage imageNamed:@"add_pcloud"];
    }else if ([type isEqualToString:FacebookCSEndPointURL]) {
        image = [NSImage imageNamed:@"add_facebook"];
    }else if ([type isEqualToString:TwitterCSEndPointURL]) {
        image = [NSImage imageNamed:@"add_twitter"];
    }else if ([type isEqualToString:InstagramCSEndPointURL]) {
        image = [NSImage imageNamed:@"add_ins"];
    }
    return image;
}

+ (NSImage *)getAuthorizateCloudImage:(CategoryCloudNameEnum)cloudEnum {
    NSImage *image = [NSImage imageNamed:@"allow_onedrive"];
    if (cloudEnum == OneDriveEnum) {
        image = [NSImage imageNamed:@"allow_onedrive"];
    }else if (cloudEnum == GoogleEnum) {
        image = [NSImage imageNamed:@"allow_google"];
    }else if (cloudEnum == DropBoxEnum) {
        image = [NSImage imageNamed:@"allow_dropbox"];
    }else if (cloudEnum == BoxEnum) {
        image = [NSImage imageNamed:@"allow_box"];
    }else if (cloudEnum == PCloudEnum) {
        image = [NSImage imageNamed:@"allow_pcloud"];
    }else if (cloudEnum == FaceBookEnum) {
        image = [NSImage imageNamed:@"allow_facebook"];
    }else if (cloudEnum == TwitterEnum) {
        image = [NSImage imageNamed:@"allow_twitter"];
    }else if (cloudEnum == InsEnum) {
        image = [NSImage imageNamed:@"allow_instagram"];
    }else if (cloudEnum == iCloudDriveEnum) {
        image = [NSImage imageNamed:@"allow_icloud"];
    }else if (cloudEnum == GooglePhotoEnum) {
        image = [NSImage imageNamed:@"allow_googlephoto"];
    }else if (cloudEnum == SumsungEnum) {
        image = [NSImage imageNamed:@"allow_sumsung"];
    }
    return image;
}

//等比例压缩图片
+ (NSData *)suchAsScalingImage:(NSImage *)image width:(int)scalWidth height:(int)scalHeight{
    NSImage *scalingimage = [[NSImage alloc] initWithSize:NSMakeSize(scalWidth, scalHeight)];
    [scalingimage lockFocus];
    NSRectFill(NSMakeRect(0, 0, scalWidth, scalHeight));
    [[NSGraphicsContext currentContext]setImageInterpolation:NSImageInterpolationHigh];
    [image drawInRect:NSMakeRect(0, 0, scalWidth, scalHeight) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    
    NSData *tempdata = nil;
    NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect: NSMakeRect(0, 0, scalWidth, scalHeight)];
    tempdata = [bitmap representationUsingType:NSPNGFileType properties:nil];
    [bitmap release];
    [scalingimage unlockFocus];
    [scalingimage release];
    
    return tempdata;
}

+ (NSData *)scalingImage:(NSImage *)image withLenght:(int)lenght {
    NSData *compressImageData = nil;
    if (image != nil) {
        if (image.size.width >= image.size.height && image.size.height > 0) {
            //按宽=lenght压缩
            int w = image.size.width;
            int h = image.size.height;
            int W = lenght;
            int H = (int)(((double)h / w) * W);
            if (((double)h / w) * W < 1.0) {
                H = 1;
            }
            compressImageData = [self suchAsScalingImage:image width:W height:H];
        }else if (image.size.height > image.size.width && image.size.width > 0) {
            //按高=lenght压缩
            int w = image.size.width;
            int h = image.size.height;
            int H = lenght;
            int W = (int)(((double)w / h) * H);
            if (((double)w / h) * H < 1.0) {
                W = 1;
            }
            compressImageData = [self suchAsScalingImage:image width:W height:H];
        }
    }
    return compressImageData;
}

//如果file已经存在，则生成别名
+(NSString*)getFilePathAlias:(NSString*)filePath withary:(NSMutableArray *)ary WithIsFolder:(BOOL)isFolder{
    NSString *newPath = filePath;
    int i = 2;
    while ([self filePathExists:ary FileName:newPath Index:1 WithIsFolder:isFolder]) {
        newPath = [NSString stringWithFormat:@"%@ %d",filePath, i++];
    }
    return newPath;
}

+ (BOOL)filePathExists:(NSArray *)ary FileName:(NSString *)fileName Index:(int)index WithIsFolder:(BOOL)isFolder{
    BOOL ret = NO;
    for (int i=index;i < ary.count; i++) {
        IMBDriveModel *driveModel = [ary objectAtIndex:i];
        if (isFolder == driveModel.isFolder && [driveModel.fileName isEqualToString:fileName]) {
            ret = YES;
            break;
        }
    }
    return ret;
}

@end
