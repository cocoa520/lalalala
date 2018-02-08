//
//  GeneralUtility.m
//  InstallAntivirus
//
//  Created by Pallas on 6/24/15.
//  Copyright (c) 2015 Pallas. All rights reserved.
//

#import "GeneralUtility.h"
#import "RegexKitLite.h"
#import "CategoryExtend.h"
#import <sys/sysctl.h>
#import "AuthorizationUtility.h"
#include "utility.h"
#include <sys/dir.h>
#include <sys/stat.h>

@implementation GeneralUtility

static BOOL SystemVersionCompare(SInt32 gestVersion, int32_t major, int32_t minor) {
#ifndef ELCAPITAN
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
#endif
        NSOperatingSystemVersion version = { major, minor, 0 };
        return [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:version];
#ifndef ELCAPITAN
    } else {
        SInt32 systemVersion = 0;
        OSStatus err = Gestalt(gestaltSystemVersion, &systemVersion);
        if (err == noErr) {
        }
        if (systemVersion >= gestVersion) {
            return YES;
        } else {
            return NO;
        }
    }
#endif
}

+ (NSString *)osVersion {
    NSString *versionString = [[NSProcessInfo processInfo] operatingSystemVersionString];
    NSString *regexStr = @"[V|v]ersion ((\\d+|\\.)*)";
    NSString *matchRes = [self getStringWithRegEx:versionString RegEx:regexStr];
    return matchRes;
}

+ (NSString*)getStringWithRegEx:(NSString*)srcStr RegEx:(NSString*)regexStr {
    NSString *matchedString = [srcStr stringByMatching:regexStr capture:1L];
    return matchedString;
}

+ (NSString *)platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+ (int)platformFlag {
    NSString *platform = [self platform];
    int flag = 0;
    if ([platform.lowercaseString isEqualToString:@"i386"]) {
        flag = NSBundleExecutableArchitectureI386;
    }
    else if([platform.lowercaseString isEqualToString:@"x86_64"]){
        flag = NSBundleExecutableArchitectureX86_64;
    }
    else if([platform.lowercaseString isEqualToString:@"ppc"]){
        flag = NSBundleExecutableArchitecturePPC;
    }
    else if([platform.lowercaseString isEqualToString:@"ppc64"]){
        flag = NSBundleExecutableArchitecturePPC64;
    }
    return flag;
}

+ (BOOL)OSIsJaguarOrLater {
    return SystemVersionCompare(0x1020, 10, 2);
}

+ (BOOL)OSIsPantherOrLater {
    return SystemVersionCompare(0x1030, 10, 3);
}

+ (BOOL)OSIsTigerOrLater {
    return SystemVersionCompare(0x1040, 10, 4);
}

+ (BOOL)OSIsLeopardOrLater {
    return SystemVersionCompare(0x1050, 10, 5);
}

+ (BOOL)OSIsSnowLeopardOrLater {
    return SystemVersionCompare(0x1060, 10, 6);
}

+ (BOOL)OSIsLionOrLater {
    return SystemVersionCompare(0x1070, 10, 7);
}

+ (BOOL)OSIsMountainLionOrLater {
    return SystemVersionCompare(0x1080, 10, 8);
}

+ (BOOL)OSIsMavericksOrLater {
    return SystemVersionCompare(0x1090, 10, 9);
}

+ (NSString *)deviceModalString{
    size_t len = 0;
    sysctlbyname("hw.model", NULL, &len, NULL, 0);
    if (len) {
        char *model = malloc(len*sizeof(char));
        sysctlbyname("hw.model", model, &len, NULL, 0);
        printf("%s\n", model);
        NSString *platform = [NSString stringWithUTF8String:model];
        free(model);
        return platform;
    }
    return nil;
}

+ (DeviceModel)deviceModal{
    NSString *string = [self deviceModalString];
    DeviceModel modal = MaciMac;
    if ([string.lowercaseString rangeOfString:@"macbookpro"].location != NSNotFound) {
        modal = MacBookPro;
    }
    else if([string.lowercaseString rangeOfString:@"imac"].location != NSNotFound){
        modal = MaciMac;
    }
    else if([string.lowercaseString rangeOfString:@"mini"].location != NSNotFound){
        modal = MacMini;
    }
    else if([string.lowercaseString rangeOfString:@"macbookair"].location != NSNotFound){
        modal = MacBookAir;
    }
    else if([string.lowercaseString rangeOfString:@"macbook"].location != NSNotFound) {
        modal = MacBook;
    }
    else if([string.lowercaseString rangeOfString:@"macpro"].location != NSNotFound) {
        modal = MacPro;
    }
    return modal;
}

+ (NSString*)getPlatformSerialNumber {
    io_registry_entry_t     rootEntry = IORegistryEntryFromPath( kIOMasterPortDefault, "IOService:/" );
    CFTypeRef serialAsCFString = NULL;
    
    serialAsCFString = IORegistryEntryCreateCFProperty( rootEntry,
                                                       CFSTR(kIOPlatformSerialNumberKey),
                                                       kCFAllocatorDefault,
                                                       0);
    
    IOObjectRelease( rootEntry );
    return (NULL != serialAsCFString) ? [(NSString*)serialAsCFString autorelease] : nil;
}

+ (NSDictionary*)getCpuIds {
    NSMutableDictionary*    cpuInfo = [[NSMutableDictionary alloc] init];
    CFMutableDictionaryRef  matchClasses = NULL;
    kern_return_t           kernResult = KERN_FAILURE;
    mach_port_t             machPort;
    io_iterator_t           serviceIterator;
    
    io_object_t             cpuService;
    
    kernResult = IOMasterPort( MACH_PORT_NULL, &machPort );
    if( KERN_SUCCESS != kernResult ) {
        printf( "IOMasterPort failed: %d\n", kernResult );
    }
    
    matchClasses = IOServiceNameMatching( "processor" );
    if( NULL == matchClasses ) {
        printf( "IOServiceMatching returned a NULL dictionary" );
    }
    
    kernResult = IOServiceGetMatchingServices( machPort, matchClasses, &serviceIterator );
    if( KERN_SUCCESS != kernResult ) {
        printf( "IOServiceGetMatchingServices failed: %d\n", kernResult );
    }
    
    while( (cpuService = IOIteratorNext( serviceIterator )) ) {
        CFTypeRef CPUIDAsCFNumber = NULL;
        io_name_t nameString;
        IORegistryEntryGetNameInPlane( cpuService, kIOServicePlane, nameString );
        
        CPUIDAsCFNumber = IORegistryEntrySearchCFProperty( cpuService,
                                                          kIOServicePlane,
                                                          CFSTR( "IOCPUID" ),
                                                          kCFAllocatorDefault,
                                                          kIORegistryIterateRecursively);
        
        if( NULL != CPUIDAsCFNumber ) {
            NSString* cpuName = [NSString stringWithCString:nameString encoding:NSUTF8StringEncoding];
            [cpuInfo setObject:(NSNumber*)CPUIDAsCFNumber forKey:cpuName];
        }
        
        if( NULL != CPUIDAsCFNumber ) {
            CFRelease( CPUIDAsCFNumber );
        }
    }
    
    IOObjectRelease( serviceIterator );
    
    return [cpuInfo autorelease];
}

+ (NSString*)getHardwareUUID {
    NSString *ret = nil;
    io_service_t platformExpert ;
    platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice")) ;
    
    if (platformExpert) {
        CFTypeRef serialNumberAsCFString ;
        serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, CFSTR("IOPlatformUUID"), kCFAllocatorDefault, 0) ;
        if (serialNumberAsCFString) {
            ret = [(NSString *)(CFStringRef)serialNumberAsCFString copy];
            CFRelease(serialNumberAsCFString); serialNumberAsCFString = NULL;
        }
        IOObjectRelease(platformExpert); platformExpert = 0;
    }
    
    return [ret autorelease];
}

+ (NSString*)getHardwareSerialNumber {
    NSString * ret = nil;
    io_service_t platformExpert ;
    platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice")) ;
    
    if (platformExpert) {
        CFTypeRef uuidNumberAsCFString ;
        uuidNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, CFSTR("IOPlatformSerialNumber"), kCFAllocatorDefault, 0) ;
        if (uuidNumberAsCFString)   {
            ret = [(NSString *)(CFStringRef)uuidNumberAsCFString copy];
            CFRelease(uuidNumberAsCFString); uuidNumberAsCFString = NULL;
        }
        IOObjectRelease(platformExpert); platformExpert = 0;
    }
    
    return [ret autorelease];
}

+ (uint64_t)totalDiskSpaceInBytes {
    uint64_t space = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemSize] longLongValue];
    return space;
}

+ (uint64_t)freeDiskSpaceInBytes {
    uint64_t freeSpace = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemFreeSize] longLongValue];
    return freeSpace;
}

+ (uint64_t)usedDiskSpaceInBytes {
    uint64_t usedSpace = [self totalDiskSpaceInBytes] - [self freeDiskSpaceInBytes];
    return usedSpace;
}

+ (uint64_t)physicalMemoryInBytes {
    return [[NSProcessInfo processInfo] physicalMemory];
}

//+ (char*)getSystemVersion {
//    SInt32 versMaj, versMin, versBugFix;
//    Gestalt(gestaltSystemVersionMajor, &versMaj);
//    Gestalt(gestaltSystemVersionMinor, &versMin);
//    Gestalt(gestaltSystemVersionBugFix, &versBugFix);
//    NSString *version = [NSString stringWithFormat:@"%d.%d.%d",versMaj,versMin,versBugFix];
//    return [GeneralUtility convertStringToCstring:version];
//}

+ (float)backingFactor{
    float backingFactor = [[NSScreen mainScreen] backingScaleFactor];
    return backingFactor;
}

+ (NSString*)convertCstringToString:(char*)cString {
    NSString *string = [[[NSString alloc] initWithCString:(const char*)cString encoding:NSUTF8StringEncoding] autorelease];
    return string;
}

+ (char*)convertStringToCstring:(NSString*)string {
    char* cString = (char *)[string cStringUsingEncoding:NSUTF8StringEncoding];
    return cString;
}

+ (BOOL)appIsRunningAtPath:(NSString*)path {
    BOOL appIsRunning = NO;
    @autoreleasepool {
        NSArray *arr = [[NSWorkspace sharedWorkspace] runningApplications];
        for (NSRunningApplication *app in arr) {
            if ([[[app executableURL] path] isEqualToString:path]) {
                appIsRunning = YES;
                break;
            }
        }
    }
    return appIsRunning;
}

+ (NSRunningApplication*)runningAppAtPath:(NSString*)path {
    @autoreleasepool {
        NSArray *arr = [[NSWorkspace sharedWorkspace] runningApplications];
        for (NSRunningApplication *app in arr) {
            if ([[[app executableURL] path] isEqualToString:path]) {
                return app;
                break;
            }
        }
    }
    return nil;
}

+ (BOOL)appIsRunningWithBundleIdentifier:(NSString*)bundleIdentifier {
    BOOL appIsRunning = NO;
    if (bundleIdentifier.length == 0 || bundleIdentifier == NULL) {
        return appIsRunning;
    }
    @autoreleasepool {
        NSArray *arr = [[NSWorkspace sharedWorkspace] runningApplications];
        for (NSRunningApplication *app in arr) {
            if ([[app bundleIdentifier] isEqualToString:bundleIdentifier]) {
                appIsRunning = YES;
                break;
            }
        }
    }
    return appIsRunning;
}

+ (BOOL)runningApplicationTerminateIdentifier:(NSString*)bundleIdentifier {
    BOOL retVal = NO;
    if (bundleIdentifier.length == 0 || bundleIdentifier == NULL) {
        return retVal;
    }
    @autoreleasepool {
        NSArray *arr = [[NSWorkspace sharedWorkspace] runningApplications];
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.bundleIdentifier == %@", bundleIdentifier];
        NSArray *tmpArray = [arr filteredArrayUsingPredicate:pre];
        NSRunningApplication *runningApp = nil;
        if (tmpArray != nil && tmpArray.count > 0) {
            runningApp = [tmpArray objectAtIndex:0];
        } else {
            retVal = TRUE;
        }
        if (runningApp != nil) {
            retVal = [runningApp terminate];
        }
    }
    return retVal;
}

+ (BOOL)isExsitAppWithIdentifier:(NSString*)identifier {
    return ([[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:identifier] != nil);
}

+ (NSString*)appAbsolutePathWithIdentifier:(NSString*)identifier {
    return [[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:identifier];
}

+ (NSString*)firefoxDefaultPath {
    if ([self isExsitAppWithIdentifier:@"org.mozilla.firefox"]) {
        NSString *basePath = [NSString stringWithFormat:@"%@/Firefox", [self userApplicationSupportPath]];
        NSFileManager *fm = [NSFileManager defaultManager];
        BOOL isDir = NO;
        if ([fm fileExistsAtPath:basePath isDirectory:&isDir]) {
            if (isDir) {
                NSString *iniPath = [basePath stringByAppendingPathComponent:@"profiles.ini"];
                if ([fm fileExistsAtPath:iniPath]) {
                    NSString *contents = [NSString stringWithContentsOfFile:iniPath encoding:NSUTF8StringEncoding error:nil];
                    if ([NSString isNilOrEmpty:contents]) {
                        return nil;
                    }
                    for (NSString *line in [contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
                        if ([line startWithString:@"Path"]) {
                            NSArray *tmpArray = [line componentsSeparatedByString:@"="];
                            if (tmpArray != nil && tmpArray.count > 1) {
                                NSString *defaultPath = [tmpArray[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                if (![NSString isNilOrEmpty:defaultPath]) {
                                    return [basePath stringByAppendingPathComponent:defaultPath];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return nil;
}

+ (NSString*)chromeDefaultPath {
    if ([self isExsitAppWithIdentifier:@"com.google.Chrome"]) {
        return [NSString stringWithFormat:@"%@/Google/Chrome/Default", [self userApplicationSupportPath]];
    }
    return nil;
}

+ (NSString*)operaDefaultPath {
    if ([self isExsitAppWithIdentifier:@"com.operasoftware.Opera"]) {
        return [NSString stringWithFormat:@"%@/com.operasoftware.Opera", [self userApplicationSupportPath]];
    }
    return nil;
}

+ (CGImageRef)nsimageToCGImageRef:(NSImage*)image {
    NSData * imageData = [image TIFFRepresentation];
    CGImageRef imageRef;
    if(imageData) {
        CGImageSourceRef imageSource =
        CGImageSourceCreateWithData((__bridge CFDataRef)imageData,  NULL);
        imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
        if (imageSource) {
            CFRelease(imageSource);
            imageSource = NULL;
        }
    }
    return imageRef;
}

+ (NSImage*)rotateImage:(NSImage*)sourceImage byDegrees:(float)degegrees {
    NSSize srcsize= [sourceImage size];
    float srcw = srcsize.width;
    float srch= srcsize.height;
    // 旋转弧度
    // double ratain = ((deg/180) * PI);
    NSRect r1;
    if(0 < degegrees && degegrees <= 90) {
        r1 = NSMakeRect(0.5*(srcw -srch), 0.5*(srch-srcw), srch, srcw);
    } else if (90 < degegrees && degegrees <= 180) {
        r1 = NSMakeRect(0, 0, srcw, srch);
    } else if (180 < degegrees && degegrees <= 270) {
        r1 = NSMakeRect(0.5*(srcw -srch), 0.5*(srch-srcw), srch, srcw);
    } else if (270 < degegrees && degegrees <= 360) {
        r1 = NSMakeRect(0, 0, srch, srcw);
    }
    //draw new image
    NSImage *rotated = [[NSImage alloc] initWithSize:[sourceImage size]];
    [rotated lockFocus];
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:(0.5*srcw) yBy: (0.5*srch)];  //按中心图片旋转
    [transform rotateByDegrees:degegrees];                //旋转度数，rotateByRadians：使用弧度
    [transform translateXBy:(-0.5*srcw) yBy: (-0.5*srch)];
    [transform concat];
    // [sourceImage drawInRect:r1 fromRect:NSZeroRect operation:NSCompositeDestinationOver fraction:1.0];//矩形内画图
    [sourceImage drawInRect:r1 fromRect:NSZeroRect operation:NSCompositeDestinationOver fraction:1.0 respectFlipped:NO hints:nil];
    [rotated unlockFocus];
    return [rotated autorelease];
}

+ (NSImage*)rotateImage:(NSImage*)sourceImage {
    NSSize srcsize= [sourceImage size];
    float srcw = srcsize.width;
    float srch= srcsize.height;
    //旋转弧度
    //double ratain = ((deg/180) * PI);
    NSRect r1;
    r1 = NSMakeRect(0, 0, srch, srcw);
    // draw new image
    NSImage *rotated = [[NSImage alloc] initWithSize:[sourceImage size]];
    [rotated lockFocus];
    [sourceImage drawInRect:r1 fromRect:NSZeroRect operation:NSCompositeDestinationOver fraction:1.0 respectFlipped:NO hints:nil];
    [rotated unlockFocus];
    return [rotated autorelease];
}

+ (void)rotateImage:(NSImage *)image roate:(float)roate rect:(NSRect)rect {
    CGImageRef myImage = [self nsimageToCGImageRef:image];
    [NSGraphicsContext saveGraphicsState];
    CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextTranslateCTM(myContext,NSMidX(rect),NSMidY(rect));
    CGContextRotateCTM(myContext, roate/180*M_PI);
    CGContextTranslateCTM(myContext,-rect.size.width /2,-rect.size.height / 2);
    CGContextDrawImage (myContext, CGRectMake(0, 0, rect.size.width, rect.size.height), myImage);
    [NSGraphicsContext restoreGraphicsState];
    CGImageRelease(myImage);
}

+ (NSImage*)iconForFile:(NSString *)path maxSize:(int)size {
    NSImage *nImage = nil;
    
    @autoreleasepool {
        NSImage *image = [[NSWorkspace sharedWorkspace] iconForFile:path];
        NSData *data = [image TIFFRepresentationUsingCompression:NSTIFFCompressionOldJPEG factor:0.2];
        NSArray *imageReps = [NSBitmapImageRep imageRepsWithData:data];
        if (imageReps.count > 0) {
            NSBitmapImageRep *bitRep = nil;
            for (NSBitmapImageRep *nbitRep in imageReps) {
                if (nbitRep.size.width <= size && nbitRep.size.height <= size) {
                    bitRep = nbitRep;
                    break;
                }
            }
            if (bitRep == nil && imageReps.count != 0) {
                bitRep = [imageReps objectAtIndex:0];
                [bitRep setSize:NSMakeSize(size, size)];
            }
            if (bitRep != nil) {
                NSData *tifData = [bitRep TIFFRepresentation];
                nImage = [[NSImage alloc] initWithData:tifData];
            }
        }
        
    }
    return nImage == nil ? nil : [nImage autorelease];
}

+ (NSDictionary*)allAttributesOfFile:(NSString*)path {
    // 常用属性 包含文件大小等属性
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSDictionary *usualDic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    
    // 包含flg 以及是否隐藏的属性
    MDItemRef item = MDItemCreate(kCFAllocatorSystemDefault, (__bridge CFStringRef)path);
    if(item == nil){
        return nil;
    }
    CFArrayRef names = MDItemCopyAttributeNames(item);
    NSDictionary *specialDic = (NSDictionary *)(MDItemCopyAttributes(item, names));
    if (item) {
        CFRelease(item);
        item = NULL;
    }
    
    [dic addEntriesFromDictionary:usualDic];
    [dic addEntriesFromDictionary:specialDic];
    return dic;
}

+ (NSDictionary*)commonAttributesOfFile:(NSString*)path {
    // 常用属性 包含文件大小等属性
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSDictionary *usualDic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    [dic addEntriesFromDictionary:usualDic];
    return dic;
}

+ (NSDictionary*)specialAttributesOfFile:(NSString*)path {
    // 包含flag及是否隐藏的属性
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    MDItemRef item = MDItemCreate(kCFAllocatorDefault, (__bridge CFStringRef)path);
    CFArrayRef names = MDItemCopyAttributeNames(item);
    NSDictionary *specialDic = (NSDictionary *)(MDItemCopyAttributes(item, names));
    if (item) {
        CFRelease(item);
        item = NULL;
    }
    
    [dic addEntriesFromDictionary:specialDic];
    return dic;
}

+ (NSDictionary*)dicForMDItem:(NSString *)path metadata:(NSArray *)datas{
    if (datas == nil) {
        return nil;
    }
    MDItemRef fileMetadata=MDItemCreate(NULL,(CFStringRef)path);
    NSDictionary *metadataDictionary = (NSDictionary*)MDItemCopyAttributes (fileMetadata,                                                                                           (CFArrayRef)datas);
    return metadataDictionary;
}

+ (uint64_t)sizeOfFileWithPath:(NSString *)path {
    long long totalSize = 0;
    @autoreleasepool {
        NSDictionary *dic = [self commonAttributesOfFile:path];
        if ([[dic objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory]) {
            totalSize = [self folderSizeAtPath:path];
//            totalSize = get_folder_size([GeneralUtility convertStringToCstring:path]);
        }
        else{
            NSURL *nUrl = [NSURL fileURLWithPath:path];
            NSNumber *sizeNumber;
            NSError *error;
            if ([nUrl getResourceValue:&sizeNumber forKey:NSURLFileAllocatedSizeKey error:&error])
                totalSize += [sizeNumber unsignedLongLongValue];
        }
    }
    return totalSize;
}

+ (uint64_t)folderSizeAtPath:(NSString*)folderPath {
    return [self _folderSizeAtPath:folderPath];
}

+ (uint64_t)_folderSizeAtPath:(NSString*)folderPath{
    uint64_t folderSize = 0;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *contentOfFolder = [fm contentsOfDirectoryAtPath:folderPath error:nil];
    for (NSString *aPath in contentOfFolder) {
        NSString * fullPath = [folderPath stringByAppendingPathComponent:aPath];
        BOOL isDir = NO;
        if ([fm fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (isDir == YES) {
                NSURL *nUrl = [NSURL fileURLWithPath:fullPath];
                NSNumber *sizeNumber;
                NSError *error;
                if ([nUrl getResourceValue:&sizeNumber forKey:NSURLFileAllocatedSizeKey error:&error]) {
                    folderSize += [sizeNumber unsignedLongLongValue];
                }
                NSDictionary *dic = [self commonAttributesOfFile:fullPath];
                if (![[dic objectForKey:NSFileType] isEqualToString:NSFileTypeSymbolicLink]) {
                    folderSize += [self _folderSizeAtPath:fullPath];
                }
            } else {
                NSURL *nUrl = [NSURL fileURLWithPath:fullPath];
                NSNumber *sizeNumber;
                NSError *error;
                if ([nUrl getResourceValue:&sizeNumber forKey:NSURLFileAllocatedSizeKey error:&error]) {
                    folderSize += [sizeNumber unsignedLongLongValue];
                }
            }
        }
    }
    return folderSize;
}


//DIR* dir = opendir(folderPath);
//if (dir == NULL) return 0;
//struct dirent* child;
//while ((child = readdir(dir))!=NULL) {
//    if (child->d_type == DT_DIR && (
//                                    (child->d_name[0] == '.' && child->d_name[1] == 0) || // 忽略目录 .
//                                    (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0) // 忽略目录 ..
//                                    )) continue;
//    
//    int folderPathLength = (int)strlen(folderPath);
//    char childPath[1024]; // 子文件的路径地址
//    stpcpy(childPath, folderPath);
//    if (folderPath[folderPathLength-1] != '/'){
//        childPath[folderPathLength] = '/';
//        folderPathLength++;
//    }
//    stpcpy(childPath+folderPathLength, child->d_name);
//    childPath[folderPathLength + child->d_namlen] = 0;
//    if (child->d_type == DT_DIR){ // directory
//        folderSize += [self _folderSizeAtPath:childPath]; // 递归调用子目录
//        // 把目录本身所占的空间也加上
//        NSString *webUrl = [[self convertCstringToString:childPath] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSURL *nUrl = [NSURL URLWithString:[@"file://" stringByAppendingString:webUrl]];
//        NSNumber *sizeNumber;
//        NSError *error;
//        if ([nUrl getResourceValue:&sizeNumber forKey:NSURLFileAllocatedSizeKey error:&error]) {
//            folderSize += [sizeNumber unsignedLongLongValue];
//        }
//        //            struct stat st;
//        //            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
//    }else if (child->d_type == DT_REG || child->d_type == DT_LNK){ // file or link
//        NSString *webUrl = [[self convertCstringToString:childPath] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSURL *nUrl = [NSURL URLWithString:[@"file://" stringByAppendingString:webUrl]];
//        NSNumber *sizeNumber;
//        NSError *error;
//        if ([nUrl getResourceValue:&sizeNumber forKey:NSURLFileAllocatedSizeKey error:&error]) {
//            folderSize += [sizeNumber unsignedLongLongValue];
//        }
//        //            struct stat st;
//        //            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
//    }
//}

+ (uint64_t)countOfFileWithPath:(NSString*)path {
    uint64_t totalCount = 0;
    @autoreleasepool {
        NSDictionary *dic = [self commonAttributesOfFile:path];
        if ([[dic objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory]) {
            totalCount = get_file_count([GeneralUtility convertStringToCstring:path]);
        } else {
            totalCount = 1;
        }
    }
    return totalCount;
}

+ (uint64_t)countOfItemNotContainSubItemWithPath:(NSString*)path {
    uint64_t totalCount = 0;
    @autoreleasepool {
        NSDictionary *dic = [self commonAttributesOfFile:path];
        if ([[dic objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory]) {
            totalCount = get_item_count_not_contain_sub_item([GeneralUtility convertStringToCstring:path]);
        }
    }
    return totalCount;
}

+ (NSArray*)getSizeAndUnitFor1024:(uint64_t)size withReserved:(uint)reserved {
    double mbSize = size / 1048576.f;
    double kbSize = size / 1024.f;
    if (size < 1024) {
        return [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.0f", (double)size], @"B", nil];
    } else {
        NSString *formatStr = [NSString stringWithFormat:@"%%.%df", reserved];
        if (mbSize > 1024) {
            double gbSize = size / 1073741824.f;
            return [NSArray arrayWithObjects:[NSString stringWithFormat:formatStr, gbSize], @"GB", nil];
        } else if (kbSize > 1024) {
            return [NSArray arrayWithObjects:[NSString stringWithFormat:formatStr, mbSize], @"MB", nil];
        } else {
            return [NSArray arrayWithObjects:[NSString stringWithFormat:formatStr, kbSize], @"KB", nil];
        }
    }
}

+ (NSArray*)getSizeAndUnitFor1024:(uint64_t)size {
    double mbSize = size / 1048576.f;
    double kbSize = size / 1024.f;
    if (size < 1024) {
        return [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.0f", (double)size], @"B", nil];
    } else {
        if (mbSize > 1024) {
            NSString *formatStr = [NSString stringWithFormat:@"%%.%df", 2];
            double gbSize = size / 1073741824.f;
            NSString *gbSizeStr = [NSString stringWithFormat:formatStr, gbSize];
            if ([gbSizeStr hasSuffix:@"00"] ) {
                gbSizeStr = [gbSizeStr substringWithRange:NSMakeRange(0, gbSizeStr.length - 3)];
            } else if ([gbSizeStr hasSuffix:@"0"]) {
                gbSizeStr = [gbSizeStr substringWithRange:NSMakeRange(0, gbSizeStr.length - 1)];
            }
            return [NSArray arrayWithObjects:gbSizeStr, @"GB", nil];
        } else if (kbSize > 1024) {
            NSString *formatStr = [NSString stringWithFormat:@"%%.%df", 1];
            NSString *mbSizeStr = [NSString stringWithFormat:formatStr, mbSize];
            if ([mbSizeStr hasSuffix:@"0"]) {
                mbSizeStr = [mbSizeStr substringWithRange:NSMakeRange(0, mbSizeStr.length - 2)];
            }
            return [NSArray arrayWithObjects:mbSizeStr, @"MB", nil];
        } else {
            NSString *formatStr = [NSString stringWithFormat:@"%%.%df", 0];
            NSString *kbSizeStr = [NSString stringWithFormat:formatStr, kbSize];
            return [NSArray arrayWithObjects:kbSizeStr, @"KB", nil];
        }
    }
}

+ (NSArray*)getSizeAndUnitFor1000:(uint64_t)size  withReserved:(uint)reserved {
    double mbSize = size / 1000000.f;
    double kbSize = size / 1000.f;
    if (size < 1000) {
        return [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.0f", (double)size], @"B", nil];
    } else {
        NSString *formatStr = [NSString stringWithFormat:@"%%.%df", reserved];
        if (mbSize > 1000) {
            double gbSize = size / 1000000000.f;
            return [NSArray arrayWithObjects:[NSString stringWithFormat:formatStr, gbSize], @"GB", nil];
        } else if (kbSize > 1000) {
            return [NSArray arrayWithObjects:[NSString stringWithFormat:formatStr, mbSize], @"MB", nil];
        } else {
            return [NSArray arrayWithObjects:[NSString stringWithFormat:formatStr, kbSize], @"KB", nil];
        }
    }
}

+ (NSArray*)getSizeAndUnitFor1000:(uint64_t)size {
    double mbSize = size / 1000000.f;
    double kbSize = size / 1000.f;
    if (size < 1000) {
        return [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.0f", (double)size], @"B", nil];
    } else {
        if (mbSize > 1000) {
            NSString *formatStr = [NSString stringWithFormat:@"%%.%df", 2];
            double gbSize = size / 1000000000.f;
            NSString *gbSizeStr = [NSString stringWithFormat:formatStr, gbSize];
            if ([gbSizeStr hasSuffix:@"00"] ) {
                gbSizeStr = [gbSizeStr substringWithRange:NSMakeRange(0, gbSizeStr.length - 3)];
            } else if ([gbSizeStr hasSuffix:@"0"]) {
                gbSizeStr = [gbSizeStr substringWithRange:NSMakeRange(0, gbSizeStr.length - 1)];
            }
            return [NSArray arrayWithObjects:gbSizeStr, @"GB", nil];
        } else if (kbSize > 1000) {
            NSString *formatStr = [NSString stringWithFormat:@"%%.%df", 1];
            NSString *mbSizeStr = [NSString stringWithFormat:formatStr, mbSize];
            if ([mbSizeStr hasSuffix:@"0"]) {
                mbSizeStr = [mbSizeStr substringWithRange:NSMakeRange(0, mbSizeStr.length - 2)];
            }
            return [NSArray arrayWithObjects:mbSizeStr, @"MB", nil];
        } else {
            NSString *formatStr = [NSString stringWithFormat:@"%%.%df", 0];
            NSString *kbSizeStr = [NSString stringWithFormat:formatStr, kbSize];
            return [NSArray arrayWithObjects:kbSizeStr, @"KB", nil];
        }
    }
}

+ (NSString*)itemKindForFile:(NSString*)string withAppTempPath:(NSString*)appTempPath {
    NSString *key = @"kMDItemKind";
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([string isEqualToString:@"application"]) {
        NSArray *array = [fm contentsOfDirectoryAtPath:@"/Applications" error:nil];
        NSString *pathForApp = nil;
        for (NSString *string in array) {
            if ([[string pathExtension].lowercaseString isEqualToString:@"app"]) {
                pathForApp = [@"/Applications" stringByAppendingPathComponent:string];
                break;
            }
        }
        if ([fm fileExistsAtPath:pathForApp]) {
            return [[self dicForMDItem:pathForApp metadata:@[key]] objectForKey:key];
        }
    }
    else if([string isEqualToString:@"alias"]){
        NSString *origin = nil;
        origin = [appTempPath stringByAppendingPathComponent:@".DS_Store"];
        if (![fm fileExistsAtPath:origin]) {
            [fm createFileAtPath:origin contents:nil attributes:nil];
        }
        NSString *aliasFile = [appTempPath stringByAppendingPathComponent:@".DS_Store alias"];
        if (![fm fileExistsAtPath:aliasFile]) {
            [self makeAliasToFolder:origin inFolder:appTempPath withName:@".DS_Store alias"];
        }
        return [[self dicForMDItem:aliasFile metadata:@[key]] objectForKey:key];
    }
    else if([string isEqualToString:@"folder"]){
        if ([fm fileExistsAtPath:appTempPath]) {
            return [[self dicForMDItem:appTempPath metadata:@[key]] objectForKey:key];
        }
    }
    else if([string isEqualToString:@"file"]){
        if ([fm fileExistsAtPath:appTempPath]) {
            appTempPath = [appTempPath stringByAppendingPathComponent:@".DS_Store"];
            if ([fm fileExistsAtPath:appTempPath]) {
                return [[self dicForMDItem:appTempPath metadata:@[key]] objectForKey:key];
            }
        }
    }
    return nil;
}

+ (NSMutableArray*)allFilesAtPath:(NSString*)dirPath withSearchOption:(SearchOptionEnum)searchOption {
    NSMutableArray * allFiles = [[[NSMutableArray alloc] init] autorelease];
    if (searchOption == TopDirectoryOnly) {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *contentOfFolder = [fm contentsOfDirectoryAtPath:dirPath error:nil];
        for (NSString *aPath in contentOfFolder) {
            NSString * fullPath = [dirPath stringByAppendingPathComponent:aPath];
            NSDictionary *dic = [self commonAttributesOfFile:fullPath];
            if ([[dic objectForKey:NSFileType] isEqualToString:NSFileTypeRegular]) {
                [allFiles addObject:fullPath];
            }
        }
    } else {
        [allFiles addObjectsFromArray:[self allFilesOfSubPath:dirPath]];
    }
    return allFiles;
}

+ (NSMutableArray*)allFilesOfSubPath:(NSString*)dirPath {
    NSMutableArray *allFiles = [[[NSMutableArray alloc] init] autorelease];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *contentOfFolder = [fm contentsOfDirectoryAtPath:dirPath error:nil];
    for (NSString *aPath in contentOfFolder) {
        NSString * fullPath = [dirPath stringByAppendingPathComponent:aPath];
        NSDictionary *dic = [self commonAttributesOfFile:fullPath];
        if ([[dic objectForKey:NSFileType] isEqualToString:NSFileTypeRegular]) {
            [allFiles addObject:fullPath];
        } else if ([[dic objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory]) {
            NSMutableArray *tmpArray = [self allFilesOfSubPath:fullPath];
            [allFiles addObjectsFromArray:tmpArray];
        }
    }
    return allFiles;
}

typedef OSStatus (*MDItemSetAttribute_type)(MDItemRef, CFStringRef, CFTypeRef);

+ (BOOL)setAttributeForPath:(NSString*)path withName:(CFStringRef)name withValue:(CFTypeRef)value {
    CFBundleRef metadataBundle = CFBundleGetBundleWithIdentifier(CFSTR("com.apple.Metadata"));
    if (!metadataBundle) {
        return NO;
    }
    MDItemSetAttribute_type mdItemSetAttributeFunc = (MDItemSetAttribute_type)CFBundleGetFunctionPointerForName(metadataBundle, CFSTR("MDItemSetAttribute"));
    if (!mdItemSetAttributeFunc) {
        return NO;
    }
    MDItemRef mdItem = MDItemCreate(kCFAllocatorDefault, (CFStringRef)path);
    OSStatus retval = mdItemSetAttributeFunc(mdItem, name, value);
    CFRelease(mdItem);
    return retval == 1 ? YES : NO;
}

+ (BOOL)fileHasWritePermission:(NSString *)path {
    char *pth = [self convertStringToCstring:path];
    char perms[3] = {0};
    get_file_permit(perms, pth);
    if (contains(perms, "w")) {
        return YES;
    }
    return NO;
}

+ (void)makeAliasToFolder:(NSString *)destFolder inFolder:(NSString *)parentFolder withName:(NSString *)name {
    // Create a resource file for the alias.
    FSRef parentRef;
    CFURLGetFSRef((CFURLRef)[NSURL fileURLWithPath:parentFolder], &parentRef);
    HFSUniStr255 aliasName;
    FSGetHFSUniStrFromString((CFStringRef)name, &aliasName);
    FSRef aliasRef;
    FSCreateResFile(&parentRef, aliasName.length, aliasName.unicode, 0, NULL, &aliasRef, NULL);
    
    // Construct alias data to write to resource fork.
    FSRef targetRef;
    CFURLGetFSRef((CFURLRef)[NSURL fileURLWithPath:destFolder], &targetRef);
    AliasHandle aliasHandle = NULL;
    FSNewAlias(NULL, &targetRef, &aliasHandle);
    
    // Add the alias data to the resource fork and close it.
    ResFileRefNum fileReference = FSOpenResFile(&aliasRef, fsRdWrPerm);
    UseResFile(fileReference);
    AddResource((Handle)aliasHandle, 'alis', 0, NULL);
    CloseResFile(fileReference);
    
    // Update finder info.
    FSCatalogInfo catalogInfo;
    FSGetCatalogInfo(&aliasRef, kFSCatInfoFinderInfo, &catalogInfo, NULL, NULL, NULL);
    FileInfo *theFileInfo = (FileInfo*)(&catalogInfo.finderInfo);
    theFileInfo->finderFlags |= kIsAlias; // Set the alias bit.
    theFileInfo->finderFlags &= ~kHasBeenInited; // Clear the inited bit to tell Finder to recheck the file.
    theFileInfo->fileType = kContainerFolderAliasType;
    FSSetCatalogInfo(&aliasRef, kFSCatInfoFinderInfo, &catalogInfo);
}

+ (NSMutableArray *)pathWithDomainKey:(NSSearchPathDirectory)dic inDomain:(NSSearchPathDomainMask)domain {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [manager URLsForDirectory:dic inDomains:domain];
    NSMutableArray *retArr = [NSMutableArray array];
    for (NSURL *url in array) {
        [retArr addObject:[url path]];
    }
    return retArr;
}

+ (NSString *)userHomePath{
    NSString *path = NSHomeDirectoryForUser(NSUserName()); //NSSearchPathForDirectoriesInDomains(, NSUserDomainMask, YES);
    return path;
}

+ (NSString *)tempPath {
    return NSTemporaryDirectory();
}

+ (NSString *)userDeskTopPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)applicationPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSSystemDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)userApplicationPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)applicationUtilityPath{
    NSString *format = @"%@/Utilities";
    return [NSString stringWithFormat:format,[self applicationPath]];
}

+ (NSString *)userLibrary {
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)userApplicationSupportPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *baseDir = (paths.count > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)userTrashPath{
    NSString *osVer = [self osVersion];
    NSString *baseDir = nil;
    if ([osVer isGreaterThanOrEqual:@"10.8"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSTrashDirectory, NSUserDomainMask, YES);
        baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    } else {
        baseDir = [NSString stringWithFormat:@"%@/.Trash", [self userHomePath]];
    }
    return baseDir;
}

+ (NSString *)userMoviePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSMoviesDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)userMusicPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSMusicDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)userPicturePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)userDownlodsPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)userDocumentPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)userPreferencesPath {
    NSString *baseDir = [NSString stringWithFormat:@"%@/Preferences", [self userLibrary]];
    return baseDir;
}

+ (NSString *)appDockIconPlistPath{
    NSString *format = @"%@/Library/Preferences/com.apple.dock.plist";
    return [NSString stringWithFormat:format,[self userHomePath]];
}

+ (BOOL)suPermission:(NSString*)tips {
    AuthorizationUtility *utility = [AuthorizationUtility singleton];
    if (utility.needAuthorize) {
        BOOL result = false;
        char *prompt = [self convertStringToCstring:tips];
        char *buf = combine_strings(255, "--prompt=%s",prompt);
        char *a[3] = {buf,"sudo","-i"};
        result = cocosSudo(3, a) == 0;
        if (result) {
            utility.needAuthorize = NO;
        }
        free(buf);
        return result;
    } else{
        BOOL result = false;
        char *a[2] = {"sudo","-i"};
        result = cocosSudo(2, a) == 0;
        return result;
    }
    return NO;
}

+ (BOOL)changePermissionForPath:(NSString*)path withUser:(NSString*)uPerm withGroup:(NSString*)gPerm withOther:(NSString*)oPerm {
    // 组合权限设置字符串
    char *permStr = "";
    char *freeStr = NULL;
    if ([uPerm isEqualToString:@""]) {
        join_string(&permStr, "u=");
        freeStr = permStr;
    } else {
        char *pstr = (char *)calloc(16, sizeof(char));
        sprintf(pstr, "u=%s", [self convertStringToCstring:uPerm]);
        join_string(&permStr, pstr);
        free(pstr);
        pstr = NULL;
        freeStr = permStr;
    }
    if ([gPerm isEqualToString:@""]) {
        if (strcmp(permStr, "") == 0) {
            join_string(&permStr, "g=");
            if (freeStr != NULL) {
                free(freeStr);
                freeStr = NULL;
            }
            freeStr = permStr;
        } else {
            join_string(&permStr, ",g=");
            if (freeStr != NULL) {
                free(freeStr);
                freeStr = NULL;
            }
            freeStr = permStr;
        }
    } else {
        if (strcmp(permStr, "") == 0) {
            char *pstr = (char *)calloc(16, sizeof(char));
            sprintf(pstr, "g=%s", [self convertStringToCstring:gPerm]);
            join_string(&permStr, pstr);
            free(pstr);
            pstr = NULL;
            if (freeStr != NULL) {
                free(freeStr);
                freeStr = NULL;
            }
            freeStr = permStr;
        } else {
            char *pstr = (char *)calloc(16, sizeof(char));
            sprintf(pstr, ",g=%s", [self convertStringToCstring:gPerm]);
            join_string(&permStr, pstr);
            free(pstr);
            pstr = NULL;
            if (freeStr != NULL) {
                free(freeStr);
                freeStr = NULL;
            }
            freeStr = permStr;
        }
    }
    if ([oPerm isEqualToString:@""]) {
        if (strcmp(permStr, "") == 0) {
            join_string(&permStr, "o=");
            if (freeStr != NULL) {
                free(freeStr);
                freeStr = NULL;
            }
            freeStr = permStr;
        } else {
            join_string(&permStr, ",o=");
            if (freeStr != NULL) {
                free(freeStr);
                freeStr = NULL;
            }
            freeStr = permStr;
        }
    } else {
        if (strcmp(permStr, "") == 0) {
            char *pstr = (char *)calloc(16, sizeof(char));
            sprintf(pstr, "o=%s", [self convertStringToCstring:oPerm]);
            join_string(&permStr, pstr);
            free(pstr);
            pstr = NULL;
            if (freeStr != NULL) {
                free(freeStr);
                freeStr = NULL;
            }
            freeStr = permStr;
        } else {
            char *pstr = (char *)calloc(16, sizeof(char));
            sprintf(pstr, ",o=%s", [self convertStringToCstring:oPerm]);
            join_string(&permStr, pstr);
            free(pstr);
            pstr = NULL;
            if (freeStr != NULL) {
                free(freeStr);
                freeStr = NULL;
            }
            freeStr = permStr;
        }
    }
    
    if (strcmp(permStr, "") != 0) {
        AuthorizationUtility *utility = [AuthorizationUtility singleton];
        if (utility.needAuthorize) {
            BOOL result = false;
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                free(freeStr);
                freeStr = NULL;
                permStr = NULL;
                return result;
            }
            char *cPath = [GeneralUtility convertStringToCstring:path];
            char *cPrompt = [GeneralUtility convertStringToCstring:AUTH_WORD];
            char *buf = combine_strings(255, "--prompt=%s",cPrompt);
            char *a[4] = {buf, "chmod", permStr, cPath};
            result = cocosSudo(4, a) == 0;
            if (result) {
                utility.needAuthorize = NO;
            }
            free(buf);
            free(freeStr);
            freeStr = NULL;
            permStr = NULL;
            return result;
        } else {
            BOOL result = false;
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                return result;
            }
            char *cPath = [GeneralUtility convertStringToCstring:path];
            char *a[3] = {"chmod", permStr, cPath};
            result = cocosSudo(3, a) == 0;
            free(freeStr);
            freeStr = NULL;
            permStr = NULL;
            return result;
        }
        return NO;
    } else {
        return NO;
    }
}

+ (BOOL)removeFileForcely:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        return YES;
    }
    
    BOOL result = [fm removeItemAtPath:path error:nil];
    if(!result){
        AuthorizationUtility *utility = [AuthorizationUtility singleton];
        if (utility.needAuthorize) {
            char *cPath = [self convertStringToCstring:path];
            char *prompt = [self convertStringToCstring:AUTH_WORD];
            char *buf = combine_strings(255,"--prompt=%s",prompt);
            char *a[6] = {buf,"rm","-f","-R","-v",cPath};
            result = cocosSudo(6, a) == 0;
            if (result) {
                utility.needAuthorize = NO;
            }
            free(buf);
        } else{
            char *cPath = [self convertStringToCstring:path];
            char *a[5] = {"rm","-f","-R","-v",cPath};
            result = cocosSudo(5, a) == 0;
        }
    }
    if (!result) {
        return NO;
    }
    else{
        return YES;
    }
}

+ (BOOL)moveFileForcelyFrom:(NSString *)srcPath toPath:(NSString *)toPath withTips:(NSString*)tips {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:srcPath]) {
        return NO;
    }
    BOOL result = [self renameItemWithAuth:srcPath withNewPath:toPath withTips:tips];
    if (!result) {
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)moveFileToTrashFrom:(NSString *)srcPath{
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:srcPath]) {
        return NO;
    }
    
    BOOL isScuccess = [[NSWorkspace sharedWorkspace] performFileOperation:NSWorkspaceRecycleOperation
                                                                   source:[srcPath stringByDeletingLastPathComponent]
                                                              destination:@""
                                                                    files:[NSArray arrayWithObject:[srcPath lastPathComponent]]
                                                                      tag:nil];
    if (!isScuccess) {
        isScuccess = [self renameItemWithAuth:srcPath withNewPath:[NSString stringWithFormat:@"%@/%@",[self userTrashPath], srcPath.lastPathComponent] withTips:AUTH_WORD];
    }
    return isScuccess;
}

+ (BOOL)mkdirWithAuth:(NSString*)path withTips:(NSString*)tips {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:path isDirectory:&isDir]) {
        if (!isDir) {
            [self removeItemWithAuth:path withTips:tips];
        } else  {
            return YES;
        }
    }
    BOOL result = [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    if (!result) {
        AuthorizationUtility *utility = [AuthorizationUtility singleton];
        if (utility.needAuthorize) {
            char *cPath = [GeneralUtility convertStringToCstring:path];
            char *prompt = [GeneralUtility convertStringToCstring:tips];
            char *buf = combine_strings(255,"--prompt=%s",prompt);
            char *a[4] = {buf,"mkdir","-p",cPath};
            
            BOOL result = cocosSudo(4, a) == 0;
            if (result) {
                utility.needAuthorize = NO;
            }
            free(buf);
            return result;
        } else{
            char *cPath = [GeneralUtility convertStringToCstring:path];
            char *a[3] = {"mkdir","-p",cPath};
            BOOL result = cocosSudo(3, a) == 0;
            return result;
        }
    }
    return result;
}

+ (BOOL)removeItemWithAuth:(NSString*)path withTips:(NSString*)tips {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        return YES;
    }
    BOOL result = [fm removeItemAtPath:path error:nil];
    if (!result) {
        AuthorizationUtility *utility = [AuthorizationUtility singleton];
        if (utility.needAuthorize) {
            char *cPath = [GeneralUtility convertStringToCstring:path];
            char *prompt = [GeneralUtility convertStringToCstring:tips];
            char *buf = combine_strings(255,"--prompt=%s",prompt);
            char *a[6] = {buf,"rm","-f","-R","-v",cPath};
            BOOL result = cocosSudo(6, a) == 0;
            if (result) {
                utility.needAuthorize = NO;
            }
            free(buf);
            return result;
        } else{
            char *cPath = [GeneralUtility convertStringToCstring:path];
            char *a[5] = {"rm","-f","-R","-v",cPath};
            BOOL result = cocosSudo(5, a) == 0;
            return result;
        }
        
    }
    return result;
}

+ (BOOL)renameItemWithAuth:(NSString*)path withNewPath:(NSString*)newPath withTips:(NSString*)tips {
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        if ([fm fileExistsAtPath:newPath]) {
            [self removeItemWithAuth:newPath withTips:tips];
        }
        BOOL result = [fm moveItemAtPath:path toPath:newPath error:nil];
        if (!result) {
            AuthorizationUtility *utility = [AuthorizationUtility singleton];
            if (utility.needAuthorize) {
                char *cfPath = [GeneralUtility convertStringToCstring:path];
                char *ctPath = [GeneralUtility convertStringToCstring:newPath];
                char *prompt = [GeneralUtility convertStringToCstring:tips];
                char *buf = combine_strings(255,"--prompt=%s",prompt);
                char *a[6] = {buf,"mv","-f","-v",cfPath,ctPath};
                BOOL result = cocosSudo(6, a) == 0;
                if (result) {
                    utility.needAuthorize = NO;
                }
                free(buf);
                return result;
            } else {
                char *cfPath = [GeneralUtility convertStringToCstring:path];
                char *ctPath = [GeneralUtility convertStringToCstring:newPath];
                char *a[5] = { "mv","-f","-v",cfPath,ctPath};
                BOOL result = cocosSudo(5, a) == 0;
                return result;
            }
        }
    }
    return NO;
}

+ (BOOL)unparkWithAuth:(NSString*)package withType:(NSString*)type withToFolder:(NSString*)toFolder withTips:(NSString*)tips {
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([NSString isNilOrEmpty:package] || ![fm fileExistsAtPath:package]) {
        return NO;
    }
    if ([NSString isNilOrEmpty:toFolder]) {
        toFolder = [package stringByDeletingLastPathComponent];
    }
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:toFolder isDirectory:&isDir]) {
        if (!isDir) {
            [self removeItemWithAuth:toFolder withTips:tips];
        }
    } else {
        [self mkdirWithAuth:toFolder withTips:tips];
    }
    
    AuthorizationUtility *utility = [AuthorizationUtility singleton];
    if (utility.needAuthorize) {
        char *cpPath = [GeneralUtility convertStringToCstring:package];
        char *cfPath = [GeneralUtility convertStringToCstring:toFolder];
        if ([type isEqualToString:@"zip"]) {
            char *prompt = [GeneralUtility convertStringToCstring:tips];
            char *buf = combine_strings(255,"--prompt=%s",prompt);
            char *a[5] = { buf,"unzip",cpPath,"-d",cfPath};
            BOOL result = cocosSudo(5, a) == 0;
            if (result) {
                utility.needAuthorize = NO;
            }
            free(buf);
            return result;
        } else if ([type isEqualToString:@"tar"]) {
            char *prompt = [GeneralUtility convertStringToCstring:tips];
            char *buf = combine_strings(255,"--prompt=%s",prompt);
            char *a[6] = { buf,"tar","-xvf",cpPath,"-C",cfPath };
            BOOL result = cocosSudo(6, a) == 0;
            if (result) {
                utility.needAuthorize = NO;
            }
            free(buf);
            return result;
        } else if ([type isEqualToString:@"tar.gz"]) {
            char *prompt = [GeneralUtility convertStringToCstring:tips];
            char *buf = combine_strings(255,"--prompt=%s",prompt);
            char *a[6] = { buf,"tar","-xzvf",cpPath,"-C",cfPath };
            BOOL result = cocosSudo(6, a) == 0;
            if (result) {
                utility.needAuthorize = NO;
            }
            free(buf);
            return result;
        } else if ([type isEqualToString:@"tar.bz2"]) {
            char *prompt = [GeneralUtility convertStringToCstring:tips];
            char *buf = combine_strings(255,"--prompt=%s",prompt);
            char *a[6] = { buf,"tar","-xjvf",cpPath,"-C",cfPath };
            BOOL result = cocosSudo(6, a) == 0;
            if (result) {
                utility.needAuthorize = NO;
            }
            free(buf);
            return result;
        } else if ([type isEqualToString:@"tar.Z"]) {
            char *prompt = [GeneralUtility convertStringToCstring:tips];
            char *buf = combine_strings(255,"--prompt=%s",prompt);
            char *a[6] = { buf,"tar","-xZvf",cpPath,"-C",cfPath };
            BOOL result = cocosSudo(6, a) == 0;
            if (result) {
                utility.needAuthorize = NO;
            }
            free(buf);
            return result;
        } else if ([type isEqualToString:@"tar.xz"]) {
            char *prompt = [GeneralUtility convertStringToCstring:tips];
            char *buf = combine_strings(255,"--prompt=%s",prompt);
            char *a[6] = { buf,"tar","-Jxvf",cpPath,"-C",cfPath };
            BOOL result = cocosSudo(6, a) == 0;
            if (result) {
                utility.needAuthorize = NO;
            }
            free(buf);
            return result;
        } else {
            return NO;
        }
    } else {
        char *cpPath = [GeneralUtility convertStringToCstring:package];
        char *cfPath = [GeneralUtility convertStringToCstring:toFolder];
        if ([type isEqualToString:@"zip"]) {
            char *a[4] = { "unzip",cpPath,"-d",cfPath };
            BOOL result = cocosSudo(4, a) == 0;
            return result;
        } else if ([type isEqualToString:@"tar"]) {
            char *a[5] = { "tar","-xvf",cpPath,"-C",cfPath };
            BOOL result = cocosSudo(5, a) == 0;
            return result;
        } else if ([type isEqualToString:@"tar.gz"]) {
            char *a[5] = { "tar","-xzvf",cpPath,"-C",cfPath };
            BOOL result = cocosSudo(5, a) == 0;
            return result;
        } else if ([type isEqualToString:@"tar.bz2"]) {
            char *a[5] = { "tar","-xjvf",cpPath,"-C",cfPath };
            BOOL result = cocosSudo(5, a) == 0;
            return result;
        } else if ([type isEqualToString:@"tar.Z"]) {
            char *a[5] = { "tar","-xZvf",cpPath,"-C",cfPath };
            BOOL result = cocosSudo(5, a) == 0;
            return result;
        } else if ([type isEqualToString:@"tar.xz"]) {
            char *a[5] = { "tar","-Jxvf",cpPath,"-C",cfPath };
            BOOL result = cocosSudo(5, a) == 0;
            return result;
        } else {
            return NO;
        }
    }
    return NO;
}

+ (BOOL)shutdownSystem {
    BOOL retVal = NO;
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
                                   @"\
                                   tell application \"System Events\"\n\
                                   shut down\n\
                                   end tell"];
    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
    [scriptObject release];
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

+ (BOOL)restartSystem {
    BOOL retVal = NO;
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
                                   @"\
                                   tell application \"System Events\"\n\
                                   restart\n\
                                   end tell"];
    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
    [scriptObject release];
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

+ (BOOL)startFinder {
    BOOL retVal = NO;
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
                                   @"\
                                   tell application \"Finder\"\n\
                                   activate\n\
                                   end tell"];
    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
    [scriptObject release];
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

+ (BOOL)killFinder {
    BOOL retVal = NO;
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
                                   @"\
                                   tell application \"Finder\"\n\
                                   quit\n\
                                   end tell"];
    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
    [scriptObject release];
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

+ (BOOL)clearRecentApplications {
    BOOL retVal = NO;
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
                                   @"\
                                   set prefFolder to path to preferences as string\n\
                                   tell application \"System Events\"\n\
                                   tell appearance preferences\n\
                                   set x to {recent applications limit}\n\
                                   set {recent applications limit} to {0}\n\
                                   set {recent applications limit} to x\n\
                                   end tell\n\
                                   end tell"];
    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
    [scriptObject release];
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

+ (BOOL)clearRecentDocuments {
    BOOL retVal = NO;
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
                                   @"\
                                   set prefFolder to path to preferences as string\n\
                                   tell application \"System Events\"\n\
                                   tell appearance preferences\n\
                                   set x to {recent documents limit}\n\
                                   set {recent documents limit} to {0}\n\
                                   set {recent documents limit} to x\n\
                                   end tell\n\
                                   end tell"];
    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
    [scriptObject release];
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

+ (BOOL)clearRecentServers {
    BOOL retVal = NO;
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
                                   @"\
                                   set prefFolder to path to preferences as string\n\
                                   tell application \"System Events\"\n\
                                   tell appearance preferences\n\
                                   set x to {recent servers limit}\n\
                                   set {recent servers limit} to {0}\n\
                                   set {recent servers limit} to x\n\
                                   end tell\n\
                                   end tell"];
    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
    [scriptObject release];
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

+ (BOOL)clearDNSCachesWithAuth:(NSString*)authWord {
    BOOL ret = NO;
    NSString *osVersion = [self osVersion];
    AuthorizationUtility *utility = [AuthorizationUtility singleton];
    if (utility.needAuthorize) {
        char *prompt = [GeneralUtility convertStringToCstring:authWord];
        if ([osVersion isGreaterThanOrEqual:@"10.10"]) {
            char *buf =   combine_strings(255, "--prompt=%s", prompt);
            char *a[3] = {buf,"discoveryutil","mdnsflushcache"};
            BOOL result = cocosSudo(3, a) == 0;
            if (result) {
                utility.needAuthorize = NO;
                char *b[2] = {"discoveryutil", "udnsflushcaches"};
                result = cocosSudo(2, b) == 0;
                if (result) {
                    ret = YES;
                }
            }
            free(buf);
        } else if ([osVersion isGreaterThanOrEqual:@"10.9"] && [osVersion isLessThan:@"10.10"]) {
            char *buf = combine_strings(255, "--prompt=%s", prompt);
            char *a[3] = {buf,"dscacheutil","-flushcache"};
            BOOL result = cocosSudo(3, a) == 0;
            if (result) {
                utility.needAuthorize = NO;
                char *b[3] = {"killall", "-HUP", "mDNSResponder"};
                result = cocosSudo(3, b) == 0;
                if (result) {
                    ret = YES;
                }
            }
            free(buf);
        } else if ([osVersion isGreaterThanOrEqual:@"10.7"] && [osVersion isLessThan:@"10.9"]) {
            char *buf = combine_strings(255, "--prompt=%s", prompt);
            char *a[4] = {buf,"killall","-HUP","mDNSResponder"};
            BOOL result = cocosSudo(4, a) == 0;
            if (result) {
                utility.needAuthorize = NO;
                ret = YES;
            }
            free(buf);
        } else if ([osVersion isGreaterThanOrEqual:@"10.5"] && [osVersion isLessThan:@"10.7"]) {
            char *buf = combine_strings(255, "--prompt=%s", prompt);
            char *a[3] = {buf,"dscacheutil","-flushcache"};
            BOOL result = cocosSudo(3, a) == 0;
            if (result) {
                utility.needAuthorize = NO;
                ret = YES;
            }
            free(buf);
        } else {
            char *buf = combine_strings(255, "--prompt=%s", prompt);
            char *a[3] = {buf,"lookupd","-flushcache"};
            BOOL result = cocosSudo(3, a) == 0;
            if (result) {
                utility.needAuthorize = NO;
                ret = YES;
            }
            free(buf);
        }
    } else {
        if ([osVersion isGreaterThanOrEqual:@"10.10"]) {
            char *a[2] = {"discoveryutil","mdnsflushcache"};
            BOOL result = cocosSudo(2, a) == 0;
            if (result) {
                char *b[2] = {"discoveryutil", "udnsflushcaches"};
                result = cocosSudo(2, b) == 0;
                if (result) {
                    ret = YES;
                }
            }
        } else if ([osVersion isGreaterThanOrEqual:@"10.9"] && [osVersion isLessThan:@"10.10"]) {
            char *a[2] = {"dscacheutil","-flushcache"};
            BOOL result = cocosSudo(2, a) == 0;
            if (result) {
                char *b[3] = {"killall", "-HUP", "mDNSResponder"};
                result = cocosSudo(3, b) == 0;
                if (result) {
                    ret = YES;
                }
            }
        } else if ([osVersion isGreaterThanOrEqual:@"10.7"] && [osVersion isLessThan:@"10.9"]) {
            char *a[3] = {"killall","-HUP","mDNSResponder"};
            BOOL result = cocosSudo(3, a) == 0;
            if (result) {
                ret = YES;
            }
        } else if ([osVersion isGreaterThanOrEqual:@"10.5"] && [osVersion isLessThan:@"10.7"]) {
            char *a[2] = {"dscacheutil","-flushcache"};
            BOOL result = cocosSudo(2, a) == 0;
            if (result) {
                ret = YES;
            }
        } else {
            char *a[2] = {"lookupd","-flushcache"};
            BOOL result = cocosSudo(2, a) == 0;
            if (result) {
                ret = YES;
            }
        }
    }
    return ret;
}

// 重建Spotlight索引
+ (BOOL)rebuildSpotlightIndexWithAuth:(NSString*)authWord {
    BOOL ret = NO;
    AuthorizationUtility *utility = [AuthorizationUtility singleton];
    SpotlightStatus status = is_serv_opened();
    char *prompt = [GeneralUtility convertStringToCstring:authWord];
    if (status == ServerNotOpened) {
        // 打开Spotlight服务
        if (utility.needAuthorize) {
            char *buf = combine_strings(255, "--prompt=%s", prompt);
            char *a[5] = {buf,"launchctl","load","-w","/System/Library/LaunchDaemons/com.apple.metadata.mds.plist"};
            int retVal = cocosSudo(5, a);
            if (!retVal) {
                status = is_serv_opened();
            }
            free(buf);
        } else {
            char *a[4] = {"launchctl","load","-w","/System/Library/LaunchDaemons/com.apple.metadata.mds.plist"};
            int retVal = cocosSudo(4, a);
            if (!retVal) {
                status = is_serv_opened();
            }
        }
    }
    if (status == IndexDisabled) {
        // 打开Spotligth服务索引
        if (utility.needAuthorize) {
            char *buf = combine_strings(255, "--prompt=%s", prompt);
            char *a[5] = {buf,"mdutil","-a","-i","on"};
            int retVal = cocosSudo(5, a);
            if (!retVal) {
                status = is_serv_opened();
            }
            free(buf);
        } else {
            char *a[4] = {"mdutil","-a","-i","on"};
            int retVal = cocosSudo(4, a);
            if (!retVal) {
                status = is_serv_opened();
            }
        }
    }
    if (status == IndexEnabled || status == IndexReady) {
        // 重建Spotligth服务索引
        if (utility.needAuthorize) {
            char *buf = combine_strings(255, "--prompt=%s", prompt);
            char *a[4] = {buf,"mdutil","-E","/"};
            int retVal = cocosSudo(4, a);
            if (!retVal) {
                ret = YES;
            }
            free(buf);
        } else {
            char *a[3] = {"mdutil","-E","/"};
            int retVal = cocosSudo(3, a);
            if (!retVal) {
                ret = YES;
            }
        }
    }
    return ret;
}

// 修复磁盘权限
+ (BOOL)repairDiskPermissionsWithAuth:(NSString*)authWord {
    BOOL ret = NO;
    AuthorizationUtility *utility = [AuthorizationUtility singleton];
    if (utility.needAuthorize) {
        char *prompt = [GeneralUtility convertStringToCstring:authWord];
        char *buf = combine_strings(255, "--prompt=%s", prompt);
        char *a[4] = {buf,"diskutil","repairPermissions","/"};
        int retVal = cocosSudo(4, a);
        if (!retVal) {
            ret = YES;
        }
        free(buf);
    } else {
        char *a[3] = {"diskutil","repairPermissions","/"};
        int retVal = cocosSudo(3, a);
        if (!retVal) {
            ret = YES;
        }
    }
    return ret;
}

+ (BOOL)verifyStartupDiskWithAuth:(NSString*)authWord {
    BOOL ret = NO;
    AuthorizationUtility *utility = [AuthorizationUtility singleton];
    if (utility.needAuthorize) {
        char *prompt = [GeneralUtility convertStringToCstring:authWord];
        char *buf = combine_strings(255, "--prompt=%s", prompt);
        char *a[4] = {buf,"diskutil","verifyVolume","/"};
        int retVal = cocosSudo(4, a);
        if (!retVal) {
            ret = YES;
        }
        free(buf);
    } else {
        char *a[3] = {"diskutil","verifyVolume","/"};
        int retVal = cocosSudo(3, a);
        if (!retVal) {
            ret = YES;
        }
    }
    return ret;
}

+ (BOOL)rebuildLaunchServicesDatabaseWithAuth:(NSString *)authWord {
    BOOL ret = NO;
    AuthorizationUtility *utility = [AuthorizationUtility singleton];
    if (utility.needAuthorize) {
        char *prompt = [GeneralUtility convertStringToCstring:authWord];
        char *buf = combine_strings(255, "--prompt=%s", prompt);
        char *a[8] = {buf,"/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister","-kill","-r","-domain","local","-domain","user"};
        int retVal = cocosSudo(8, a);
        if (!retVal) {
            ret = YES;
        }
        free(buf);
    } else {
        char *a[7] = {"/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister","-kill","-r","-domain","local","-domain","user"};
        int retVal = cocosSudo(7, a);
        if (!retVal) {
            ret = YES;
        }
    }
    return ret;
}

+ (BOOL)speedUpMail {
    BOOL retVal = NO;
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
                                   @"\
                                   tell application \"Mail\" to quit\n\
                                   set sizeBefore to do shell script \"ls -lah ~/Library/Mail/V2/MailData | grep -E 'Envelope Index$' | awk {'print $5'}\"\n\
                                   do shell script \"/usr/bin/sqlite3 '~/Library/Mail/V2/MailData/Envelope Index vacuum'\"\n\
                                   set sizeAfter to do shell script \"ls -lah ~/Library/Mail/V2/MailData | grep -E 'Envelope Index$' | awk {'print $5'}\"\n\
                                   "];
    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
    [scriptObject release];
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
