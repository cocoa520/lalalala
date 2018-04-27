//
//  IMBCreateSyncImage.m
//  iMobieTrans
//
//  Created by iMobie on 7/11/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBCreateSyncImage.h"
#import "IMBArtworkHelper.h"
#import "IMBDeviceInfo.h"
#import "IMBFileSystem.h"
#import "NSString+Category.h"
#import "NSData+Category.h"
#import "MediaHelper.h"
#import "SystemHelper.h"
@implementation IMBCreateSyncImage
@synthesize fileTatolSize = _fileTatolSize;

-(id)initWithImage:(IMBiPod *)ipod{
    self = [super init];
    if (self) {
        _fileTatolSize = 0;
        _logHandle = [IMBLogManager singleton];
        _ipod = ipod;
    }
    return self;
}

-(NSMutableArray *)getThumbnilArray:(NSMutableArray *)uuidArray{
    NSMutableArray *thumbArray = [[[NSMutableArray alloc]init]autorelease];
    for (int i=0; i<uuidArray.count; i++) {
//        IMBTrack *photoInfo = [uuidArray objectAtIndex:i];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CURRENT_MESSAGE object:[NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Sync_PrepareImageData",nil),i+1,uuidArray.count,[[photoInfo.filepath pathComponents]lastObject]] userInfo:nil];
//        IMBSyncPhotoData *info = [[IMBSyncPhotoData alloc]init];
////        if (_ipod.deviceInfo == iPod_Touch_3 && ([_ipod.deviceHandle.productVersion rangeOfString:@"5"].length > 0 || [_ipod.deviceHandle.productVersion rangeOfString:@"6"].length > 0 || [_ipod.deviceHandle.productVersion rangeOfString:@"7"].length > 0 || [_ipod.deviceHandle.productVersion rangeOfString:@"8"].length > 0)) {
////                    info.thumbPath = [self writeiPod3Image:photoInfo];
////        }else {
////                    info.thumbPath = [self writeImage:photoInfo];
////        }
//        info.thumbName = photoInfo.photoName;
//        [thumbArray addObject:info];
//        [info release];
    }
    return thumbArray;
}

- (NSData *)createImageDataByTract:(IMBTrack *)tract withType:(BOOL)isBetweenDevice {
    NSData *newData = nil;
    _isBetweenDevice = isBetweenDevice;
    if (isBetweenDevice) {
        newData = [self createImageDataDToD:tract];
    }else {
        newData = [self createImageData:tract];
    }
    return newData;
}

//device to device
- (NSData *)createImageDataDToD:(IMBTrack *)tract {
    NSData *newData = nil;
    NSData *oldData = [self readFileDataDtoD:tract.photoFilePath];
    newData = [self writeImage:tract withOldData:oldData];
    return newData;
}

//mac to device
-(NSData *)createImageData:(IMBTrack *)tract{
    NSData *newData = nil;
    NSData *oldData = [self readFileDataMtoD:tract.photoFilePath];
    
    if (_ipod.deviceInfo.family == iPod_Touch_3 && ([_ipod.deviceHandle.productVersion isVersionMajorEqual:@"5"])) {
        newData = [self writeiPod3Image:tract withOldData:oldData];
    }else {
        newData = [self writeImage:tract withOldData:oldData];
    }
    return newData;
}

-(NSData *)writeImage:(IMBTrack *)tract withOldData:(NSData *)oldData {
    long int originalImageSize = tract.fileSize;
    NSData *originalImageSizeData = [NSData intToBytes:originalImageSize];
    //得到缩略图data
    NSData *bit78 = nil;
    NSData *bit158 = nil;
    NSData *bit167 = nil;
    NSData *bit120 = nil;
    NSData *bit32 = nil;
    
    @autoreleasepool {
        if ([_ipod.deviceHandle.productVersion isVersionMajorEqual:@"8.3"]) {
//            [_logHandle writeInfoLog:@"version major equal 8.3"];
            bit167 = [[self createThumb167_167Image:oldData] retain];
        }else {
            bit167 = [[self createThumb167_167Image:oldData] retain];
            bit158 = [[self createThumb158_158Image:oldData] retain];
            bit120 = [[self createThumb120_120Image:oldData] retain];
            bit78 = [[self createThumb78_78Image:oldData] retain];
            bit32 = [[self createThumb32_32Image:oldData] retain];
        }
    }
    
    //78*78缩略图
    long int thumbImageSize78 = bit78.length;
    long int offest78 = originalImageSize + thumbImageSize78;
    long int resolution78 = 0x00000c45;
    NSData *thumbImageSizeData78 = [NSData intToBytes:thumbImageSize78];
    NSData *reslutOffest78 = [NSData intToBytes:offest78];
    NSData *resolutionData78 = [NSData intToBytes:resolution78];
    
    //158*158缩略图
    long int thumbImageSize158 = bit158.length;
    long int offest158 = offest78 + thumbImageSize158;
    long int resolution158 = 0x00000fc8;
    NSData *thumbImageSizeData158 = [NSData intToBytes:thumbImageSize158];
    NSData *reslutOffest158 = [NSData intToBytes:offest158];
    NSData *resolutionData158 = [NSData intToBytes:resolution158];
    
    //167*167缩略图
    long int thumbImageSize167 = bit167.length;
    long int offest167 = offest158 + thumbImageSize167;
    long int resolution167 = 0x00000fbf;
    NSData *thumbImageSizeData167 = [NSData intToBytes:thumbImageSize167];
    NSData *reslutOffest167 = [NSData intToBytes:offest167];
    NSData *resolutionData167 = [NSData intToBytes:resolution167];
    
    //120*120缩略图
    long int thumbImageSize120 = bit120.length;
    long int offest120  = offest167 + thumbImageSize120;
    long int resolution120 = 0x00000fc0;
    NSData *thumbImageSizeData120 = [NSData intToBytes:thumbImageSize120];
    NSData *reslutOffest120 = [NSData intToBytes:offest120];
    NSData *resolutionData120 = [NSData intToBytes:resolution120];
    
    //32*32缩略图
    long int thumbImageSize32 = bit32.length;
    //    long int offest32 = offest120 + thumbImageSize32;
    //    NSData *reslutOffest32 = [MyHelper intToBytes:(int)offest32];
    
    long int totleFileSize = originalImageSize + thumbImageSize78 + thumbImageSize158 + thumbImageSize167 +thumbImageSize120 +thumbImageSize32;
    NSData *totleFileSizeData = [NSData intToBytes:totleFileSize];
    NSMutableData *writeData = [NSMutableData dataWithCapacity:totleFileSize + 124];
    
    [writeData appendData:oldData];
    [writeData appendData:bit78];
    [writeData appendData:bit158];
    [writeData appendData:bit167];
    [writeData appendData:bit120];
    [writeData appendData:bit32];
    
    //写入head数据段
    NSData *value1 = [NSData intToBytes:4035];//0x00000fc3
    NSData *value2 = [NSData intToBytes:0x00000000];
    NSData *value3 = [NSData intToBytes:3041];//0x00000be1
    
    NSMutableData *headData = [NSMutableData dataWithCapacity:124];
    [headData appendData:value1];//0x00000fc3
    [headData appendData:value2];//0x00000000
    [headData appendData:originalImageSizeData];//图片原尺寸
    //写入32*32格式数据段
    [headData appendData:value3];//0x00000be1
    [headData appendData:originalImageSizeData];//图片原尺寸（偏移量）
    //写入3141格式数据段（78*78）
    [headData appendData:thumbImageSizeData78];
    [headData appendData:resolutionData78];//0x00000c45
    [headData appendData:reslutOffest78];
    //写入4040格式数据段（158*158）
    [headData appendData:thumbImageSizeData158];
    [headData appendData:resolutionData158];//0x00000fc8
    [headData appendData:reslutOffest158];
    //写入4031格式数据段（167*167）
    [headData appendData:thumbImageSizeData167];
    [headData appendData:resolutionData167];//0x00000fbf
    [headData appendData:reslutOffest167];
    //写入4032格式数据段（120*120）
    [headData appendData:thumbImageSizeData120];
    [headData appendData:resolutionData120];//0x00000fc0
    [headData appendData:reslutOffest120];
    
    //写入未知固定值 00000800  00000000  00000020  00000000  00000006 0000000C
    NSData *value4 = [NSData intToBytes:0x00000800];
    NSData *value5 = [NSData intToBytes:0x00000020];
    NSData *value6 = [NSData intToBytes:0x00000006];
    NSData *value7 = [NSData intToBytes:0x0000000c];
    [headData appendData:value4];//0x00000800
    [headData appendData:value2];//0x00000000
    [headData appendData:value5];//0x00000020
    [headData appendData:value2];//0x00000000
    [headData appendData:value6];//0x00000006
    [headData appendData:value7];//0x0000000c
    //写入图片数据段长度（去除头的长度==124）
    [headData appendData:totleFileSizeData];
    //写入uuid
    NSMutableString *uuid = [[NSMutableString alloc]initWithCapacity:40];
    [uuid setString:tract.uuid];
    if (uuid != NULL) {
        [uuid replaceCharactersInRange:NSMakeRange(8, 1) withString:@""];
        [uuid replaceCharactersInRange:NSMakeRange(12, 1) withString:@""];
        [uuid replaceCharactersInRange:NSMakeRange(16, 1) withString:@""];
        [uuid replaceCharactersInRange:NSMakeRange(20, 1) withString:@""];
    }
    NSData *uuidData = [MediaHelper My16NSStringToNSData:uuid];
    [headData appendData:uuidData];
    [uuid release];
    //写入总文件大小
    NSData *fileSizeData = [NSData intToBytes:(int)totleFileSize + 124];
    [headData appendData:fileSizeData];
    //写入固定值00000002
    NSData *value8 = [NSData intToBytes:0x00000002];
    [headData appendData:value8];
    //写入head标示
    NSData *markData = [NSData intToBytes:0x696d7468];
    [headData appendData:markData];
    //    int indentifferLeaght = 4;
    //    char *indentiffer = (char *) malloc(indentifferLeaght + 1);
    //    memset(indentiffer, 0, malloc_size(indentiffer));
    //    memcpy(indentiffer, "imth", malloc_size(indentiffer));
    //    [headData appendBytes:indentiffer length:indentifferLeaght];
    //    free(indentiffer);
    
    //总图片数据
    [writeData appendData:headData];
    _fileTatolSize += (totleFileSize + 124);
    
//    [self saveImage:writeData stringPath:@"quan"];
    
    if (bit78 != nil) {
        [bit78 release];
        bit78 = nil;
    }
    if (bit158 != nil) {
        [bit158 release];
        bit158 = nil;
    }
    if (bit167 != nil) {
        [bit167 release];
        bit167 = nil;
    }
    if (bit120 != nil) {
        [bit120 release];
        bit120 = nil;
    }
    if (bit32 != nil) {
        [bit32 release];
        bit32 = nil;
    }
    //    return tempPhotoName;
    return writeData;
}

-(NSData *)writeiPod3Image:(IMBTrack *)track withOldData:(NSData *)oldData {
//    //原图片
//    NSFileHandle *file1;
//    file1 = [NSFileHandle fileHandleForReadingAtPath:track.photoFilePath];
//    if (file1 == nil) {
//        [_logHandle writeInfoLog:@"create thumbnail open file error"];
//        exit(1);
//    }
//    int chunckSize = 10240;
    long int originalImageSize = (int)[SystemHelper folderOrfileSize:track.photoFilePath];
//    
//    NSMutableData *bitDatas = [NSMutableData dataWithCapacity:originalImageSize];
//    
//    @autoreleasepool {
//        NSData *fd = [file1 readDataOfLength:chunckSize];
//        while ([fd length] > 0) {
//            [bitDatas appendData:fd];
//            fd = [file1 readDataOfLength:chunckSize];
//        }
//    }
//    [file1 closeFile];
    NSData *originalImageSizeData = [NSData intToBytes:originalImageSize];
    
    //得到缩略图data
    NSData *bit78 = nil;
    NSData *bit120 = nil;
    @autoreleasepool {
        bit78 = [[self createiPod3Thumb78_78Image:oldData] retain];
        bit120 = [[self createThumb120_120Image:oldData] retain];
    }
    //78*78缩略图
    long int thumbImageSize78 = bit78.length;
    NSData *thumbImageSizeData78 = [NSData intToBytes:thumbImageSize78];
    //120*120缩略图
    long int thumbImageSize120 = bit120.length;
    long int offest120  = originalImageSize + thumbImageSize78;
    long int resolution120 = 0x00000fbf;
    NSData *reslutOffest120 = [NSData intToBytes:offest120];
    NSData *resolutionData120 = [NSData intToBytes:resolution120];
    
    long int totleFileSize = originalImageSize + thumbImageSize78 +thumbImageSize120;
    NSData *totleFileSizeData = [NSData intToBytes:totleFileSize];
    NSMutableData *writeData = [NSMutableData dataWithCapacity:totleFileSize + 88];
    
    [writeData appendData:oldData];
    [writeData appendData:bit78];
    [writeData appendData:bit120];
    
    //写入head数据段
    NSData *value1 = [NSData intToBytes:4036];//0x00000fc4
    NSData *value2 = [NSData intToBytes:0x00000000];
    NSData *value3 = [NSData intToBytes:3041];//0x00000be1
    
    NSMutableData *headData = [NSMutableData dataWithCapacity:88];
    [headData appendData:value1];//0x00000fc4
    [headData appendData:value2];//0x00000000
    [headData appendData:originalImageSizeData];//图片原尺寸
    //写入3041格式数据段（78*78）
    [headData appendData:value3];//0x00000be1
    [headData appendData:originalImageSizeData];//图片原尺寸（偏移量）
    //写入4031格式数据段（120*120）
    [headData appendData:thumbImageSizeData78];
    [headData appendData:resolutionData120];////0x00000fbf
    [headData appendData:reslutOffest120];
    
    //写入未知固定值 00007080 00000000 00000020 00000000 00000003 0000000C
    NSData *value4 = [NSData intToBytes:0x00007080];
    NSData *value5 = [NSData intToBytes:0x00000020];
    NSData *value6 = [NSData intToBytes:0x00000003];
    NSData *value7 = [NSData intToBytes:0x0000000c];
    [headData appendData:value4];//0x00007080
    [headData appendData:value2];//0x00000000
    [headData appendData:value5];//0x00000020
    [headData appendData:value2];//0x00000000
    [headData appendData:value6];//0x00000003
    [headData appendData:value7];//0x0000000c
    //写入图片数据段长度（去除头的长度==124）
    [headData appendData:totleFileSizeData];
    //写入uuid
    NSMutableString *uuid = [[NSMutableString alloc]initWithCapacity:40];
    [uuid setString:track.uuid];
    if (uuid != NULL) {
        [uuid replaceCharactersInRange:NSMakeRange(8, 1) withString:@""];
        [uuid replaceCharactersInRange:NSMakeRange(12, 1) withString:@""];
        [uuid replaceCharactersInRange:NSMakeRange(16, 1) withString:@""];
        [uuid replaceCharactersInRange:NSMakeRange(20, 1) withString:@""];
    }
    NSData *uuidData = [MediaHelper My16NSStringToNSData:uuid];
    [headData appendData:uuidData];
    [uuid release];
    //写入总文件大小
    NSData *fileSizeData = [NSData intToBytes:(int)totleFileSize + 88];
    [headData appendData:fileSizeData];
    //写入固定值00000002
    NSData *value8 = [NSData intToBytes:0x00000002];
    [headData appendData:value8];
    //写入head标示
    NSData *markData = [NSData intToBytes:0x696d7468];
    [headData appendData:markData];
    //总图片数据
    [writeData appendData:headData];
    _fileTatolSize += (totleFileSize + 88);
    if (bit78 != nil) {
        [bit78 release];
        bit78 = nil;
    }
    if (bit120 != nil) {
        [bit120 release];
        bit120 = nil;
    }
    return writeData;
}

//创建78*78的缩略图iPod3
-(NSData *)createiPod3Thumb78_78Image:(NSData *)imgData{
    NSData *imageData = nil;
    int f_Width = 80;
    int f_Heigth = 78;
    NSImage *originalIamge = [[NSImage alloc] initWithData:imgData];
    if (originalIamge != nil) {
        if (originalIamge.size.height > f_Heigth || originalIamge.size.width > f_Width) {
            NSImage *cutImage = [self cutOriginalImage:originalIamge addLine:false];
            if (cutImage != nil) {
                imageData = [self suchAsScalingImage:cutImage width:f_Width height:f_Heigth fillRectangle:false];
            }
        }else{
            imageData = [self createSmallImage:originalIamge wigth:f_Width heigth:f_Heigth fill:false];
        }
    }else {
        [_logHandle writeInfoLog:@"Original image is nil"];
    }
    [originalIamge release];
    return imageData;
}

//创建78*78的缩略图
-(NSData *)createThumb78_78Image:(NSData *)imgData {
    NSData *imageData = nil;
    int f_Width = 79;
    int f_Heigth = 78;
    NSImage *originalIamge = [[NSImage alloc] initWithData:imgData];
    if (originalIamge != nil) {
        if (originalIamge.size.height > f_Heigth || originalIamge.size.width > f_Width) {
            NSImage *cutImage = [self cutOriginalImage:originalIamge addLine:false];
            if (cutImage != nil) {
                imageData = [self suchAsScalingImage:cutImage width:f_Width height:f_Heigth fillRectangle:false];
            }
        }else{
            imageData = [self createSmallImage:originalIamge wigth:f_Width heigth:f_Heigth fill:false];
        }
    }else {
        [_logHandle writeInfoLog:@"Original image is nil"];
    }
    [originalIamge release];
    return imageData;
}
-(NSData *)createThumb78_78ImageByIpad:(NSData *)imgData {
    NSData *imageData = nil;
    int f_Width = 79;
    int f_Heigth = 78;
    NSImage *originalIamge = [[NSImage alloc] initWithData:imgData];
    if (originalIamge != nil) {
        if (originalIamge.size.height > f_Heigth || originalIamge.size.width > f_Width) {
            int scalW = f_Width;
            int scalH = f_Heigth;
            if (originalIamge.size.height < originalIamge.size.width) {
                scalW = f_Width;
                scalH = f_Width * originalIamge.size.height / originalIamge.size.width;
            }else if (originalIamge.size.height > originalIamge.size.width) {
                scalW = f_Heigth * originalIamge.size.width / originalIamge.size.height;
                scalH = f_Heigth;
            }else {
                scalW = f_Width;
                scalH = f_Heigth;
            }
            imageData = [self suchAsScalingImage:originalIamge width:scalW height:scalH fillRectangle:false];
        }else{
            imageData = [self createSmallImage:originalIamge wigth:f_Width heigth:f_Heigth fill:false];
        }
    }else {
        [_logHandle writeInfoLog:@"Original image is nil"];
    }
    [originalIamge release];
    return imageData;
}

//创建158*158的缩略图
-(NSData *)createThumb158_158Image:(NSData *)imgData {
    NSData *imageData = nil;
    int f_Width = 160;
//    int f_Width = 158;
    int f_Heigth = 158;
    NSImage *originalIamge = [[NSImage alloc] initWithData:imgData];
    if (originalIamge != nil) {
        if (originalIamge.size.height > f_Heigth || originalIamge.size.width > f_Width) {
            NSImage *cutImage = [self cutOriginalImage:originalIamge addLine:true];
            if (cutImage != nil) {
                imageData = [self suchAsScalingImage:cutImage width:f_Width height:f_Heigth fillRectangle:true];
            }
        }else{
            imageData = [self createSmallImage:originalIamge wigth:f_Width heigth:f_Heigth fill:true];
        }
    }else {
        [_logHandle writeInfoLog:@"Original image is nil"];
    }
    [originalIamge release];
    return imageData;
}
-(NSData *)createThumb158_158ImageByIpad:(NSData *)imgData {
    NSData *imageData = nil;
    int f_Width = 160;
    int f_Heigth = 158;
    NSImage *originalIamge = [[NSImage alloc] initWithData:imgData];
    if (originalIamge != nil) {
        if (originalIamge.size.height > f_Heigth || originalIamge.size.width > f_Width) {
            int scalW = f_Width;
            int scalH = f_Heigth;
            if (originalIamge.size.height < originalIamge.size.width) {
                scalW = f_Width;
                scalH = f_Width * originalIamge.size.height / originalIamge.size.width;
            }else if (originalIamge.size.height > originalIamge.size.width) {
                scalW = f_Heigth * originalIamge.size.width / originalIamge.size.height;
                scalH = f_Heigth;
            }else {
                scalW = f_Width;
                scalH = f_Heigth;
            }
            imageData = [self suchAsScalingImage:originalIamge width:scalW height:scalH fillRectangle:false];
        }else{
            imageData = [self createSmallImage:originalIamge wigth:f_Width heigth:f_Heigth fill:false];
        }
    }else {
        [_logHandle writeInfoLog:@"Original image is nil"];
    }
    [originalIamge release];
    return imageData;
}

//创建167*167的缩略图
-(NSData *)createThumb167_167Image:(NSData *)imgData {
    NSData *imageData = nil;
//    int f_Width = 169;//ipod size
    int f_Width = 168;
    int f_Heigth = 168;
    NSImage *originalIamge = [[NSImage alloc] initWithData:imgData];
    if (originalIamge != nil) {
        if (originalIamge.size.height > f_Heigth || originalIamge.size.width > f_Width) {
            NSImage *cutImage = [self cutOriginalImage:originalIamge addLine:false];
            if (cutImage != nil) {
                imageData = [self suchAsScalingImage:cutImage width:f_Width height:f_Heigth fillRectangle:true];
            }
        }else{
            imageData = [self createSmallImage:originalIamge wigth:f_Width heigth:f_Heigth fill:true];
        }
    }else {
        [_logHandle writeInfoLog:@"Original image is nil"];
    }
    [originalIamge release];
    return imageData;
}
-(NSData *)createThumb167_167ImageByIpad:(NSData *)imgData {
    NSData *imageData = nil;
    int f_Width = 169;
    int f_Heigth = 168;
    NSImage *originalIamge = [[NSImage alloc] initWithData:imgData];
    if (originalIamge != nil) {
        if (originalIamge.size.height > f_Heigth || originalIamge.size.width > f_Width) {
            int scalW = f_Width;
            int scalH = f_Heigth;
            if (originalIamge.size.height < originalIamge.size.width) {
                scalW = f_Width;
                scalH = f_Width * originalIamge.size.height / originalIamge.size.width;
            }else if (originalIamge.size.height > originalIamge.size.width) {
                scalW = f_Heigth * originalIamge.size.width / originalIamge.size.height;
                scalH = f_Heigth;
            }else {
                scalW = f_Width;
                scalH = f_Heigth;
            }
            imageData = [self suchAsScalingImage:originalIamge width:scalW height:scalH fillRectangle:false];
        }else{
            imageData = [self createSmallImage:originalIamge wigth:f_Width heigth:f_Heigth fill:false];
        }
    }else {
        [_logHandle writeInfoLog:@"Original image is nil"];
    }
    [originalIamge release];
    
//    [self saveImage:imageData stringPath:@"168*168"];
    
    return imageData;
}

//创建120*120的缩略图
-(NSData *)createThumb120_120Image:(NSData *)imgData {
    NSData *imageData = nil;
    int f_Width = 120;
    int f_Heigth = 120;
    NSImage *originalIamge = [[NSImage alloc] initWithData:imgData];
    if (originalIamge != nil) {
        if (originalIamge.size.height > f_Heigth || originalIamge.size.width > f_Width) {
            NSImage *cutImage = [self cutOriginalImage:originalIamge addLine:false];
            if (cutImage != nil) {
                imageData = [self suchAsScalingImage:cutImage width:f_Width height:f_Heigth fillRectangle:false];
            }
        }else{
            imageData = [self createSmallImage:originalIamge wigth:f_Width heigth:f_Heigth fill:false];
        }
    }else {
        [_logHandle writeInfoLog:@"Original image is nil"];
    }
    [originalIamge release];
    return imageData;
}
-(NSData *)createThumb120_120ImageByIpad:(NSData *)imgData {
    NSData *imageData = nil;
    int f_Width = 120;
    int f_Heigth = 120;
    NSImage *originalIamge = [[NSImage alloc] initWithData:imgData];
    if (originalIamge != nil) {
        if (originalIamge.size.height > f_Heigth || originalIamge.size.width > f_Width) {
            int scalW = f_Width;
            int scalH = f_Heigth;
            if (originalIamge.size.height < originalIamge.size.width) {
                scalW = f_Width;
                scalH = f_Width * originalIamge.size.height / originalIamge.size.width;
            }else if (originalIamge.size.height > originalIamge.size.width) {
                scalW = f_Heigth * originalIamge.size.width / originalIamge.size.height;
                scalH = f_Heigth;
            }else {
                scalW = f_Width;
                scalH = f_Heigth;
            }
            imageData = [self suchAsScalingImage:originalIamge width:scalW height:scalH fillRectangle:false];
        }else{
            imageData = [self createSmallImage:originalIamge wigth:f_Width heigth:f_Heigth fill:false];
        }
    }else {
        [_logHandle writeInfoLog:@"Original image is nil"];
    }
    [originalIamge release];
    
//    [self saveImage:imageData stringPath:@"120*120"];
    
    return imageData;
}

//创建32*32的缩略图
-(NSData *)createThumb32_32Image:(NSData *)imgData {
    NSData *imageData = nil;
    int f_Width = 32;
    int f_Heigth = 32;
    NSImage *originalIamge = [[NSImage alloc] initWithData:imgData];
    if (originalIamge != nil) {
        if (originalIamge.size.height > f_Heigth || originalIamge.size.width > f_Width) {
            NSImage *cutImage = [self cutOriginalImage:originalIamge addLine:false];
            if (cutImage != nil) {
                imageData = [self suchAsScalingImage:cutImage width:f_Width height:f_Heigth fillRectangle:false];
            }
        }else{
            imageData = [self createSmallImage:originalIamge wigth:f_Width heigth:f_Heigth fill:false];
        }
    }else {
        [_logHandle writeInfoLog:@"Original image is nil"];
    }
    [originalIamge release];
    return imageData;
}
-(NSData *)createThumb32_32ImageByIpad:(NSData *)imgData {
    NSData *imageData = nil;
    int f_Width = 32;
    int f_Heigth = 32;
    NSImage *originalIamge = [[NSImage alloc] initWithData:imgData];
    if (originalIamge != nil) {
        if (originalIamge.size.height > f_Heigth || originalIamge.size.width > f_Width) {
            int scalW = f_Width;
            int scalH = f_Heigth;
            if (originalIamge.size.height < originalIamge.size.width) {
                scalW = f_Width;
                scalH = f_Width * originalIamge.size.height / originalIamge.size.width;
            }else if (originalIamge.size.height > originalIamge.size.width) {
                scalW = f_Heigth * originalIamge.size.width / originalIamge.size.height;
                scalH = f_Heigth;
            }else {
                scalW = f_Width;
                scalH = f_Heigth;
            }
            imageData = [self suchAsScalingImage:originalIamge width:scalW height:scalH fillRectangle:false];
        }else{
            imageData = [self createSmallImage:originalIamge wigth:f_Width heigth:f_Heigth fill:false];
        }
    }else {
        [_logHandle writeInfoLog:@"Original image is nil"];
    }
    [originalIamge release];
    
//    [self saveImage:imageData stringPath:@"32*32"];
    
    return imageData;
}

//裁剪原始图片
-(NSImage *) cutOriginalImage:(NSImage *)originalImage addLine:(BOOL)isAddLine{
    NSImage *formatImage = nil;
    if (originalImage.size.width > originalImage.size.height) {
        //按高裁剪
        formatImage = [self cutImageForSize:originalImage width:originalImage.size.height height:originalImage.size.height type:@"H" addLine:isAddLine];
    }else{
        //按宽裁剪
        formatImage = [self cutImageForSize:originalImage width:originalImage.size.width height:originalImage.size.width type:@"W" addLine:isAddLine];
    }
    
    return formatImage;
}

//裁剪图片方式
-(NSImage *) cutImageForSize:(NSImage *)image width:(int)cutWidth height:(int)cutHeight type:(NSString *)cutType addLine:(BOOL)isAddLine{
    int toWidth = cutWidth;
    int toHeight = cutHeight;
    int x,y,ow,oh = 0;
    if ([cutType isEqualToString:@"H"]) {
        x = (image.size.width - toHeight) / 2;
        y = 0;
        ow = image.size.height;
        oh = image.size.height * toHeight / toWidth;
    }else{
        x = 0;
        y = (image.size.height - toWidth) / 2;
        ow = image.size.width;
        oh = image.size.width * toHeight / toWidth;
    }
    NSImage *targetImage = [[[NSImage alloc]initWithSize:NSMakeSize(ow, oh)]autorelease];
    NSRect rect;
    if (isAddLine) {
        rect = NSMakeRect(1, 3, toWidth - 3, toHeight - 1);
    }else{
        rect = NSMakeRect(0, 0, toWidth, toHeight);
    }
    [targetImage lockFocus];
    NSRectFill(NSMakeRect(0, 0, ow, oh));
    @try {
        [image drawInRect:rect fromRect:NSMakeRect(x, y, ow, oh) operation:NSCompositeSourceOver fraction:1.0];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:exception.reason];
        [_logHandle writeInfoLog:@"Cut image error"];
    }
    [targetImage unlockFocus];
    
    return targetImage;
}

//等比例压缩图片
-(NSData *) suchAsScalingImage:(NSImage *)image width:(int)scalWidth height:(int)scalHeight fillRectangle:(BOOL)isFillRectangle{
    NSImage *scalingimage = [[[NSImage alloc] initWithSize:NSMakeSize(scalWidth, scalHeight)]autorelease];
    NSRect rect;
    if (isFillRectangle) {
        rect = NSMakeRect(0, 8, scalWidth - 9, scalHeight);
    }else{
        rect = NSMakeRect(0, 0, scalWidth, scalHeight);
    }
    [scalingimage lockFocus];
    NSColor *color = [NSColor whiteColor];
    NSRect rect1 = NSMakeRect(0, 0, scalWidth, scalHeight);
    [color drawSwatchInRect:rect1];
    [[NSGraphicsContext currentContext]setImageInterpolation:NSImageInterpolationHigh];
    @try {
        [image drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:exception.reason];
        [_logHandle writeInfoLog:@"Scaling image error"];
    }
    [scalingimage unlockFocus];
    
    NSData *imageData;
    imageData = [IMBArtworkHelper convertToArtworkData:scalingimage Format:Format16bppRgb555];
    
    return imageData;
}

-(NSImage *) suchAsScalingSmallImage:(NSImage *)image width:(int)scalWidth height:(int)scalHeight{
    NSImage *scalingimage = [[[NSImage alloc] initWithSize:NSMakeSize(scalWidth, scalHeight)]autorelease];
    NSRect rect = NSMakeRect(0, 0, scalWidth, scalHeight);
    [scalingimage lockFocus];
    NSRectFill(NSMakeRect(0, 0, scalWidth, scalHeight));
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [image drawInRect:rect fromRect:NSMakeRect(0, 0, image.size.width, image.size.height) operation:NSCompositeSourceIn fraction:1.0];
    [scalingimage unlockFocus];
    return scalingimage;
}

//创建samll image
-(NSData *) createSmallImage:(NSImage *)originagImage wigth:(int)f_Width heigth:(int)f_Heigth fill:(BOOL)isFill{
    NSData *createImageData;
    NSImage *smallImage = [self suchAsScalingSmallImage:originagImage width:f_Width height:f_Heigth];
    createImageData = [self suchAsScalingImage:smallImage width:f_Width height:f_Heigth fillRectangle:isFill];
    return createImageData;
}

- (NSData *)readFileDataDtoD:(NSString *)filePath {
    if (![_ipod.fileSystem fileExistsAtPath:filePath]) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"file not exist(photo import):%@",filePath]];
        return nil;
    }
    else{
        long long fileLength = [_ipod.fileSystem getFileLength:filePath];
        AFCFileReference *openFile = [_ipod.fileSystem openForRead:filePath];
        const uint32_t bufsz = 10240;
        char *buff = (char*)malloc(bufsz);
        NSMutableData *totalData = [[[NSMutableData alloc] init] autorelease];
        while (1) {
            
            uint32_t n = [openFile readN:bufsz bytes:buff];
            if (n==0) break;
            //将字节数据转化为NSdata
            NSData *b2 = [[NSData alloc]
                          initWithBytesNoCopy:buff length:n freeWhenDone:NO];
            [totalData appendData:b2];
            [b2 release];
        }
        if (totalData.length == fileLength) {
            // NSLog(@"success readData 1111");
        }
        free(buff);
        [openFile closeFile];
        return totalData;
    }
}

- (NSData *)readFileDataMtoD:(NSString *)filePath {
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return nil;
    }else {
        //原图片
        NSFileHandle *file1;
        file1 = [NSFileHandle fileHandleForReadingAtPath:filePath];
        if (file1 == nil) {
            [_logHandle writeInfoLog:@"create thumbnail open file error"];
            return nil;
        }
        int chunckSize = 102400;
        long int originalImageSize = (int)[SystemHelper folderOrfileSize:filePath];
        
        NSMutableData *bitDatas = [NSMutableData dataWithCapacity:originalImageSize];
        
        @autoreleasepool {
            NSData *fd = [file1 readDataOfLength:chunckSize];
            while ([fd length] > 0) {
                [bitDatas appendData:fd];
                fd = [file1 readDataOfLength:chunckSize];
            }
        }
        [file1 closeFile];
        return bitDatas;
    }
}

//保存图片
-(void) saveImage:(NSData *)imageData stringPath:(NSString *)stringName {
    //保存图片
    NSImage *image = [[NSImage alloc] initWithData:imageData];
    NSData *tempdata;
    NSBitmapImageRep *srcImageRep;
    [image lockFocus];
    srcImageRep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
    tempdata = [srcImageRep representationUsingType:NSJPEGFileType properties:nil];
    NSString *savePath = [@"/Users/imobie/Documents/dingming/aa/dingming" stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",stringName]];
    [tempdata writeToFile:savePath atomically:YES];
    [image unlockFocus];
    [image release];
}

@end
