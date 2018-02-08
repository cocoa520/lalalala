//
//  IMBAdbManager.m
//  
//
//  Created by JGehry on 12/12/16.
//
//

#import "IMBAdbManager.h"
#import <IOKit/usb/IOUSBLib.h>
#import <IOKit/hid/IOHIDKeys.h>

static IMBAdbManager *_adbManager = nil;

@implementation IMBAdbManager
@synthesize serialNum = _serialNum;
@synthesize packageName = _packageName;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [self setSerialNum:nil];
    [self setPackageName:nil];
    [super dealloc];
#endif
}

+ (IMBAdbManager *)singleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_adbManager) {
            _adbManager = [[IMBAdbManager alloc] init];
        }
    });
    return _adbManager;
}

+ (NSString *)findSerial:(int)vendorID withProductID:(int)productID {
    CFStringRef obj;
    obj = find_serial(vendorID, productID); // serial mode
    if (!obj) {
        obj = find_serial(vendorID, productID); // keyboard mode
    }
    
    if (obj) {
        char serial[256];
        if (CFStringGetCString(obj, serial, 256, CFStringGetSystemEncoding())) {
            return [NSString stringWithUTF8String:serial];
        }
    } else {
        return nil;
    }
    return nil;
}

+ (NSString *)findVendor:(int)vendorID withProductID:(int)productID {
    CFStringRef obj;
    obj = find_vendor(vendorID, productID); // vendor mode
    if (!obj) {
        obj = find_vendor(vendorID, productID); // vendor mode
    }
    
    if (obj) {
        char serial[256];
        if (CFStringGetCString(obj, serial, 256, CFStringGetSystemEncoding())) {
            return [NSString stringWithUTF8String:serial];
        }
    } else {
        return nil;
    }
    return nil;
}

+ (NSString *)findProduct:(int)vendorID withProductID:(int)productID {
    CFStringRef obj;
    obj = find_product(vendorID, productID); // product mode
    if (!obj) {
        obj = find_product(vendorID, productID); // product mode
    }
    
    if (obj) {
        char serial[256];
        if (CFStringGetCString(obj, serial, 256, CFStringGetSystemEncoding())) {
            return [NSString stringWithUTF8String:serial];
        }
    } else {
        return nil;
    }
    return nil;
}

+ (NSString *)findManufacturer:(int)vendorID withProductID:(int)productID {
    CFStringRef obj;
    obj = find_Manufacturer(vendorID, productID); // product mode
    if (!obj) {
        obj = find_Manufacturer(vendorID, productID); // product mode
    }
    
    if (obj) {
        char serial[256];
        if (CFStringGetCString(obj, serial, 256, CFStringGetSystemEncoding())) {
            return [NSString stringWithUTF8String:serial];
        }
    } else {
        return nil;
    }
    return nil;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_adbManager) {
            _adbManager = [super allocWithZone:zone];
        }
    });
    return _adbManager;
}

- (id)copy {
    return self;
}

- (id)mutableCopy {
    return self;
}

- (id)init {
    if (self = [super init]) {
        self.packageName = @"android.imobie.com.anytransservice";
        self.isSelectSD = NO;
        return self;
    }else {
        return nil;
    }
}

- (NSTask *)adbTask:(NSArray *)arguments {
    NSTask *task = [[NSTask alloc] init];
    [task setArguments:arguments];
    [task setLaunchPath:[[NSBundle mainBundle] pathForResource:@"adb" ofType:@""]];
    return task;
}

#pragma mark -- 执行adb命令
- (NSString *)runADBCommand:(NSArray *)cmd {
    NSTask *task = [self adbTask:cmd];
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];

    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    [task waitUntilExit];
    NSData *data = [file readDataToEndOfFile];
    NSString *adbCmdOutput = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [task terminate];
    [task release];
    return adbCmdOutput;
}

- (NSTask *)lsofTask:(NSArray *)arguments {
    NSTask *task = [[NSTask alloc] init];
    [task  setArguments:arguments];
    [task setLaunchPath:[[NSBundle mainBundle] pathForResource:@"lsof" ofType:@""]];
    return task;
}

#pragma mark -- 执行lsof命令
- (NSString *)runLsofCommand:(NSArray *)cmd {
    NSTask *task = [self lsofTask:cmd];
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    [task waitUntilExit];
    NSData *data = [file readDataToEndOfFile];
    NSString *outputStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *returnStr = [[[[[[outputStr componentsSeparatedByString:@"\t"] objectAtIndex:0] componentsSeparatedByString:@"\n"] objectAtIndex:1] componentsSeparatedByString:@" "] objectAtIndex:5];
    [task terminate];
    [task release];
    return returnStr;
}

#pragma mark -- 执行grep命令
- (NSString *)runGrepCommand:(NSArray *)cmd {
    _adbTask = [[NSTask alloc] init];
    [_adbTask setLaunchPath:[[NSBundle mainBundle] pathForResource:@"adb" ofType:@""]];
    [_adbTask setArguments:cmd];

    NSPipe *outpipe = [NSPipe pipe];
    NSFileHandle *readHandle = [outpipe fileHandleForReading];
    [_adbTask setStandardOutput:outpipe];
    [readHandle waitForDataInBackgroundAndNotify];
    [[NSNotificationCenter defaultCenter] addObserver:self
           selector:@selector(taskOutData:)
               name:NSFileHandleDataAvailableNotification
             object:readHandle];
    
    [_adbTask launch];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(timerAction:) userInfo:nil repeats:NO];
    [_adbTask waitUntilExit];
    if (timer.isValid) {
        [timer invalidate];
        timer = nil;
    }
    
    NSData *data = [readHandle readDataToEndOfFile];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSFileHandleDataAvailableNotification object:nil];
    [_adbTask terminate];
    [_adbTask release];
    _adbTask = nil;
    return str;
}

- (void)timerAction:(NSTimer *)timer {
    if (_adbTask != nil) {
        [_adbTask terminate];
    }
}

- (void)taskOutData:(NSNotification *)notification {
    NSFileHandle *fh = [notification object];
    NSData *data = [fh availableData];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"data str:%@",str);
    if ([str rangeOfString:@"iMobieAndroid_Socket_Listenning"].location != NSNotFound) {
        [_adbTask terminate];
    }else {
        [fh waitForDataInBackgroundAndNotify];
    }
}

#pragma mark -- 执行ADB指定命令
- (NSString *)runADBAppointCommand:(NSString *)cmd1 withCmd2:(NSString *)cmd2 withCmd3:(NSString *)cmd3 {
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/Applications/Utilities/Terminal"];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    NSPipe *inPipe = [NSPipe pipe];
    [task setStandardInput:inPipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    NSFileHandle *inFile = [inPipe fileHandleForWriting];
    [task launch];
    
    [inFile writeData:[cmd1 dataUsingEncoding:NSUTF8StringEncoding]];
    [inFile writeData:[cmd2 dataUsingEncoding:NSUTF8StringEncoding]];
    [inFile writeData:[cmd3 dataUsingEncoding:NSUTF8StringEncoding]];
    [task waitUntilExit];
    NSData *data = [file readDataToEndOfFile];
    NSString *adbCmdOutput = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [task terminate];
    [task release];
    return adbCmdOutput;
}

#pragma mark -- 执行AAPT命令
- (NSString *)runAAPTCommand:(NSArray *)cmd {
    NSString *retStr = nil;
    NSTask *task = [[NSTask alloc] init];
    [task  setArguments:cmd];
    [task setLaunchPath:[[NSBundle mainBundle] pathForResource:@"aapt" ofType:@""]];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    [task waitUntilExit];
    NSData *data = [file readDataToEndOfFile];
    retStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [task terminate];
    
    [task release];
    return retStr;
}

//执行aapt命令获取apk版本信息
- (NSArray *)localAPKVersion:(NSString *)path {
    return @[@"dump", @"badging", path];
}

//获取序列号
- (NSArray *)adbSerialNum {
    return @[@"get-serialno"];
}

//等待连接设备
- (NSArray *)waitForDevice {
    return @[@"wait-for-device"];
}

//连接设备
- (NSArray *)connectDevices {
    return @[@"devices"];
}

//启动服务
- (NSArray *)startServer {
    return @[@"start-server"];
}

//关闭服务
- (NSArray *)killServer {
    return @[@"kill-server"];
}

//重启手机
- (NSArray *)rebootDevice {
    return @[@"reboot"];
}

//从设备的高权限到低权限
- (NSArray *)ddFromDataDbWithSerialNo:(NSString *)serialNo withDataDb:(NSString *)dataDb withSdcard:(NSString *)sdcard withPermission:(NSString *)permission {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"%@ -c \'dd if=%@ of=%@\'", permission, dataDb, sdcard]];
    }else {
        return @[@"shell", [NSString stringWithFormat:@"%@ -c \'dd if=%@ of=%@\'", permission, dataDb, sdcard]];
    }
}

//从设备拷出
- (NSArray *)pullFromDeviceWithSerialNo:(NSString *)serialNo withSource:(NSString *)source withDestination:(NSString *)dest {
//    NSString *pullPath = [[[[[NSFileManager defaultManager] URLsForDirectory:NSDesktopDirectory inDomains:NSUserDomainMask] objectAtIndex:0] path] stringByAppendingPathComponent:@"AnytransForAndroidData"];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:pullPath]) {
//        [[NSFileManager defaultManager] createDirectoryAtPath:pullPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
    if (serialNo) {
        return @[@"-s", serialNo, @"pull", [NSString stringWithFormat:@"%@", source], [NSString stringWithFormat:@"%@", dest]];
    }else {
        return @[@"pull", [NSString stringWithFormat:@"%@", source], [NSString stringWithFormat:@"%@", dest]];
    }
}

//从Mac中拷贝文件至设备
- (NSArray *)pushToDeviceWithSerialNo:(NSString *)serialNo withSource:(NSString *)source withDestination:(NSString *)dest {
    if (serialNo) {
        return @[@"-s", serialNo, @"push", [NSString stringWithFormat:@"%@", source], [NSString stringWithFormat:@"%@", dest]];
    }else {
        return @[@"push", [NSString stringWithFormat:@"%@", source], [NSString stringWithFormat:@"%@", dest]];
    }
}

//从Mac中拷贝Root文件至设备
- (NSArray *)pushToDeviceWithSerialNo:(NSString *)serialNo withRootSource:(NSString *)source withRootPath:(NSString *)rootPath {
    if (serialNo) {
        return @[@"-s", serialNo, @"push", [NSString stringWithFormat:@"%@/", source], [NSString stringWithFormat:@"%@/.%@/", rootPath, serialNo]];
    }else {
        return @[@"push", [NSString stringWithFormat:@"%@", source], [NSString stringWithFormat:@"%@/.%@/", rootPath, serialNo]];
    }
}


//启动后台服务进程
- (NSArray *)startIntent:(NSString *)serialNo {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", @"am", @"start", @"-n", [NSString stringWithFormat:@"%@/%@.LaunchActivity", self.packageName, self.packageName]];
    }else {
        return @[@"shell", @"am", @"start", @"-n", [NSString stringWithFormat:@"%@/%@.LaunchActivity", self.packageName, self.packageName]];
    }
}

//重定向TCP
- (NSArray *)adbForwardTCP:(NSString *)serialNo withTcpLocal:(int)local withTcpRemote:(int)remote {
    if (serialNo) {
        return @[@"-s", serialNo, @"forward", [NSString stringWithFormat:@"tcp:%d", local], [NSString stringWithFormat:@"tcp:%d", remote]];
    }else {
        return @[@"forward", [NSString stringWithFormat:@"tcp:%d", local], [NSString stringWithFormat:@"tcp:%d", remote]];
    }
}

//取消重定向TCP
- (NSArray *)adbForwardRemoveTcp:(NSString *)serialNo withTcpLocal:(int)local {
    if (serialNo) {
        return @[@"-s", serialNo, @"forward", @"--remove", [NSString stringWithFormat:@"tcp:%d", local]];
    }else {
        return @[@"forward", @"--remove", [NSString stringWithFormat:@"tcp:%d", local]];
    }
}

//停止后台服务进程
- (NSArray *)forceStopIntentWithSerialNo:(NSString *)serialNo {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", @"am", @"force-stop", self.packageName];
    }else {
        return @[@"shell", @"am", @"force-stop", self.packageName];
    }
}

//清除缓存
- (NSArray *)pmClearIntentWithSerialNo:(NSString *)serialNo {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", @"pm", @"clear", self.packageName];
    }else {
        return @[@"shell", @"pm", @"clear", self.packageName];
    }
}

//杀死与应用程序相关联的所有进程
- (NSArray *)killIntentWithSerialNo:(NSString *)serialNo {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", @"am", @"kill", self.packageName];
    }else {
        return @[@"shell", @"am", @"kill", self.packageName];
    }
}

//杀死与应用程序相关联的所有进程
- (NSArray *)killAllIntentWithSerialNo:(NSString *)serialNo {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", @"am", @"kill-all"];
    }else {
        return @[@"shell", @"am", @"kill-all"];
    }
}

//获取apk版本号
- (NSArray *)getAPKVersion:(NSString *)serialNo withPackageName:(NSString *)packageName {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", @"dumpsys", @"package", packageName];
    }else {
        return @[@"shell", @"dumpsys", @"package", packageName];
    }
}

//安装APK
- (NSArray *)installAPK:(NSString *)apkPath withSerialNo:(NSString *)serialNo {
    if (self.isSelectSD) {
        if (serialNo) {
            return @[@"-s", serialNo, @"install", @"-r", @"-s", apkPath];
        }else {
            return @[@"install", @"-r", @"-s", apkPath];
        }
    }else {
        if (serialNo) {
            return @[@"-s", serialNo, @"install", @"-r", apkPath];
        }else {
            return @[@"install", @"-r", apkPath];
        }
    }
}

//卸载APK
- (NSArray *)unInstallAPK:(NSString *)apkPath withSerialNo:(NSString *)serialNo {
    if (self.isRetain) {
        if (serialNo) {
            return @[@"-s", serialNo, @"uninstall", @"-k", apkPath];
        }else {
            return @[@"uninstall", @"-k", apkPath];
        }
    }else {
        if (serialNo) {
            return @[@"-s", serialNo, @"uninstall", apkPath];
        }else {
            return @[@"uninstall", apkPath];
        }
    }
}

//检查是否已安装APK，查看包存在的位置
- (NSArray *)isInstallerAPK:(NSString *)packageName withSerialNo:(NSString *)serialNo {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", @"pm", @"list", @"package", @"-i", packageName];
    }else {
        return @[@"shell", @"pm", @"list", @"package", @"-i", packageName];
    }
}

//检查是否已安装APK，查看apk存在的位置
- (NSArray *)isInstallerAPKPath:(NSString *)packageName withSerialNo:(NSString *)serialNo {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", @"pm", @"path", packageName];
    }else {
        return @[@"shell", @"pm", @"path", packageName];
    }
}

//检查当前Apk是否运行
- (NSArray *)checkApkIsRunning:(NSString *)serialNo {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", @"ps"];
    }else {
        return @[@"shell", @"ps"];
    }
}

//检查adb端口是否被进程占用
- (NSArray *)checkPortOccupy {
    return @[@"-i", @"TCP:5037", @"-s", @"TCP:LISTEN"];
}

//清除当前服务日志
- (NSArray *)clearServiceLogcat:(NSString *)serialNo {
    if (serialNo) {
        return @[@"-s", serialNo, @"logcat", @"-c", @"-s", @"iMobieAndroidTAG"];
    }else {
        return @[@"logcat", @"-c", @"-s", @"iMobieAndroidTAG"];
    }
}

//检查当前服务是否运行
- (NSArray *)checkServiceIsRunning:(NSString *)serialNo {
    if (serialNo) {
        return @[@"-s", serialNo, @"logcat", @"-s", @"iMobieAndroidTAG"];
    }else {
        return @[@"logcat", @"-s", @"iMobieAndroidTAG"];
    }
}

//创建Root隐藏文件夹
- (NSArray *)createRootDirectory:(NSString *)serialNo withRootPath:(NSString *)rootPath {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"cd /%@/; mkdir %@/.%@/", rootPath, rootPath, serialNo]];
    }else {
        return @[@"shell", [NSString stringWithFormat:@"cd /%@/; mkdir %@/.tmp/", rootPath, rootPath]];
    }
}

//移动Root隐藏文件
- (NSArray *)moveRootDirectory:(NSString *)serialNo withRootPath:(NSString *)rootPath withRootPathNumberOrName:(NSString *)desNumberOrName withRootPathName:(NSString *)name {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"cd /%@/.%@/; mv ./%@/%@ .", rootPath, serialNo, desNumberOrName, name]];
    }else {
        return @[@"shell", [NSString stringWithFormat:@"cd /%@/.%@/; mv ./%@/%@ .", rootPath, serialNo, desNumberOrName, name]];
    }
}

//删除Root隐藏文件夹
- (NSArray *)removeRootDirectory:(NSString *)serialNo withRootPath:(NSString *)rootPath withRootPathNumberOrName:(NSString *)desNumberOrName {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"cd %@/.%@/; rmdir %@", rootPath, serialNo, desNumberOrName]];
    }else {
        return @[@"shell", [NSString stringWithFormat:@"cd %@/.tmp/; rmdir %@", rootPath, desNumberOrName]];
    }
}

//删除Root隐藏文件夹下的文件
- (NSArray *)removeRootDirectoryAtFile:(NSString *)serialNo withRootPath:(NSString *)rootPath {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"cd %@/.%@/; rm *", rootPath, serialNo]];
    }else {
        return @[@"shell", [NSString stringWithFormat:@"cd %@/.tmp/; rm *", rootPath]];
    }
}

//检查Root所需相关资源文件
- (NSArray *)checkRootReource:(NSString *)serialNo withRootPath:(NSString *)rootPath {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"ls %@/.%@/ -a", rootPath, serialNo]];
    }else {
        return @[@"shell", [NSString stringWithFormat:@"ls %@/.%@/ -a", rootPath, serialNo]];
    }
}

//获取文件可执行权限
- (NSMutableArray *)excutePermission:(NSString *)serialNo withRootPath:(NSString *)rootPath {
    if (serialNo) {
        NSMutableArray *mutArray = [[[NSMutableArray alloc] init] autorelease];
        NSArray *Matrix = @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"chmod 777 %@/.%@/Matrix", rootPath, serialNo]];
        NSArray *toolbox = @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"chmod 777 %@/.%@/toolbox", rootPath, serialNo]];
        NSArray *pidof = @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"chmod 777 %@/.%@/pidof", rootPath, serialNo]];
        NSArray *supolicy = @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"chmod 777 %@/.%@/supolicy", rootPath, serialNo]];
        NSArray *su = @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"chmod 777 %@/.%@/su", rootPath, serialNo]];
        NSArray *busybox = @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"chmod 777 %@/.%@/busybox", rootPath, serialNo]];
        NSArray *wsroot = @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"chmod 777 %@/.%@/wsroot.sh", rootPath, serialNo]];
        NSArray *install_recovery = @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"chmod 777 %@/.%@/install-recovery.sh", rootPath, serialNo]];
        [mutArray addObject:Matrix];
        [mutArray addObject:toolbox];
        [mutArray addObject:pidof];
        [mutArray addObject:supolicy];
        [mutArray addObject:su];
        [mutArray addObject:busybox];
        [mutArray addObject:wsroot];
        [mutArray addObject:install_recovery];
        return mutArray;
    }else {
        NSMutableArray *mutArray = [[[NSMutableArray alloc] init] autorelease];
        NSArray *Matrix = @[@"shell", [NSString stringWithFormat:@"chmod 777 %@/.%@/Matrix", rootPath, serialNo]];
        NSArray *toolbox = @[@"shell", [NSString stringWithFormat:@"chmod 777 %@/.%@/toolbox", rootPath, serialNo]];
        NSArray *pidof = @[@"shell", [NSString stringWithFormat:@"chmod 777 %@/.%@/pidof", rootPath, serialNo]];
        NSArray *supolicy = @[@"shell", [NSString stringWithFormat:@"chmod 777 %@/.%@/supolicy", rootPath, serialNo]];
        NSArray *su = @[@"shell", [NSString stringWithFormat:@"chmod 777 %@/.%@/su", rootPath, serialNo]];
        NSArray *busybox = @[@"shell", [NSString stringWithFormat:@"chmod 777 %@/.%@/busybox", rootPath, serialNo]];
        NSArray *wsroot = @[@"shell", [NSString stringWithFormat:@"chmod 777 %@/.%@/wsroot.sh", rootPath, serialNo]];
        NSArray *install_recovery = @[@"shell", [NSString stringWithFormat:@"chmod 777 %@/.%@/install-recovery.sh", rootPath, serialNo]];
        [mutArray addObjectsFromArray:Matrix];
        [mutArray addObjectsFromArray:toolbox];
        [mutArray addObjectsFromArray:pidof];
        [mutArray addObjectsFromArray:supolicy];
        [mutArray addObjectsFromArray:su];
        [mutArray addObjectsFromArray:busybox];
        [mutArray addObjectsFromArray:wsroot];
        [mutArray addObjectsFromArray:install_recovery];
        return mutArray;
    }
}

//开始Root
- (NSArray *)startRootFire:(NSString *)serialNo withRootPath:(NSString *)rootPath {
    if (serialNo) {
        /**
         *  root mode
         *  RM_TEMP=0 # 临时(暂不支持)
         *  RM_PERM_NO_SUPERUSER=1 # 永久，不安装 Superuser，提权文件为 su8 （wondershare默认程序传的1）
         *  RM_PERM_WITH_SUPERUSER=2 # 永久，安装 Superuser，提权文件为 su
         */
        return @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"cd %@/.%@/; %@/.%@/Matrix %@/.%@/ 2", rootPath, serialNo, rootPath, serialNo, rootPath, serialNo]];
    }else {
        return @[@"shell", [NSString stringWithFormat:@"cd %@/.%@/; %@/.%@/ Matrix %@/.%@/ 2", rootPath, serialNo, rootPath, serialNo, rootPath, serialNo]];
    }
}

//检查Root结果状态,pathDir--->[NSString stringWithFormat:@"ls /system/bin/ -l; ls /system/xbin/ -l; ls /system/sbin/ -l; ls /sbin/ -l; ls /vendor/bin/ -l;"]
- (NSArray *)checkRootState:(NSString *)serialNo withPathDir:(NSString *)pathDir {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", pathDir];
    }else {
        return @[@"shell", pathDir];
    }
}

//创建Backup临时文件夹
- (NSArray *)createDbBackupDirectory:(NSString *)serialNo withPathName:(NSString *)pathName {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"cd /sdcard/; mkdir %@", pathName]];
    }else {
        return @[@"shell", [NSString stringWithFormat:@"cd /sdcard/; mkdir %@", pathName]];
    }
}

//检测屏幕状态
- (NSArray *)checkScreenOnState:(NSString *)serialNo {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", @"dumpsys", @"power"];
    }else {
        return @[@"shell", @"input", @"keyevent"];
    }
}

//回到Home页面屏幕
- (NSArray *)backHomeScreen:(NSString *)serialNo {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", @"input", @"keyevent", @"3"];
    }else {
        return @[@"shell", @"input", @"keyevent", @"3"];
    }
}

//唤醒屏幕
- (NSArray *)wakeUpScreen:(NSString *)serialNo {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", @"input", @"keyevent", @"26"];
    }else {
        return @[@"shell", @"input", @"keyevent", @"26"];
    }
}

//检测设备在Recovery模式下是否存在锁屏所需要的key文件
- (NSArray *)checkRecoveryHasPasswordWithSerailNo:(NSString *)serialNo {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"find /data/system -name '*.key'"]];
    }else {
        return @[@"shell", [NSString stringWithFormat:@"find /data/system -name '*.key'"]];
    }
}

- (NSArray *)grantFilePermission:(NSString *)serialNo withPermission:(NSString *)permission {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"chmod 777 /data/system/%@", permission]];
    }else {
        return @[@"shell", [NSString stringWithFormat:@"chmod 777 /data/system/%@", permission]];
    }
}

//删除Recovery模式下的锁屏密码Gesture.key
- (NSArray *)removeRecoveryGesture:(NSString *)serialNo withCommod:(NSString *)commod {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"%@ -c 'cd /data/system/; rm gesture.key'", commod]];
    }else {
        return @[@"shell", [NSString stringWithFormat:@"%@ -c 'cd /data/system/; rm gesture.key'", commod]];
    }
}

//删除Recovery模式下的锁屏密码locksettings.db
- (NSArray *)removeRecoveryLocksettings:(NSString *)serialNo withCommod:(NSString *)commod {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"%@ -c 'cd /data/system/; rm locksettings.db'", commod]];
    }else {
        return @[@"shell", [NSString stringWithFormat:@"%@ -c 'cd /data/system/; rm locksettings.db'", commod]];
    }
}

//删除Recovery模式下的锁屏密码Password.key
- (NSArray *)removeRecoveryPassword:(NSString *)serialNo withCommod:(NSString *)commod {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"%@ -c 'cd /data/system/; rm password.key'", commod]];
    }else {
        return @[@"shell", [NSString stringWithFormat:@"%@ -c 'cd /data/system/; rm password.key'", commod]];
    }
}

//检测Shell状态
- (NSArray *)checkShellStatus:(NSString *)serialNo withCommod:(NSString *)commod {
    if (serialNo) {
        return @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"%@ \'ls data\'", commod]];
    }else {
        return @[@"shell", [NSString stringWithFormat:@"%@ -c \'ls data\'", commod]];
    }

//    if (serialNo) {
//        return @[@"-s", serialNo, @"shell", [NSString stringWithFormat:@"%@ -c \'Open SuperSU\'", commod]];
//    }else {
//        return @[@"shell", [NSString stringWithFormat:@"%@ -c \'Open SuperSU\'", commod]];
//    }
}

/**
 *  查找序列号
 *
 *  @param idVendor  VendorID
 *  @param idProduct ProductID
 *
 *  @return 返回设备序列号
 */
CFStringRef find_serial(int idVendor, int idProduct) {
    CFMutableDictionaryRef matchingDictionary = IOServiceMatching(kIOUSBDeviceClassName);
    
    CFNumberRef numberRef;
    numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &idVendor);
    CFDictionaryAddValue(matchingDictionary, CFSTR(kUSBVendorID), numberRef);
    CFRelease(numberRef);
    numberRef = 0;
    
    numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &idProduct);
    CFDictionaryAddValue(matchingDictionary, CFSTR(kUSBProductID), numberRef);
    CFRelease(numberRef);
    numberRef = 0;
    
    io_iterator_t iter = NULL;
    if (IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDictionary, &iter) == KERN_SUCCESS) {
        io_service_t usbDeviceRef;
        if ((usbDeviceRef = IOIteratorNext(iter))) {
            CFMutableDictionaryRef dict = NULL;
            if (IORegistryEntryCreateCFProperties(usbDeviceRef, &dict, kCFAllocatorDefault, kNilOptions) == KERN_SUCCESS) {
                CFTypeRef obj = CFDictionaryGetValue(dict, CFSTR(kIOHIDSerialNumberKey));
                if (!obj) {
                    obj = CFDictionaryGetValue(dict, CFSTR(kUSBSerialNumberString));
                }
                if (obj) {
                    return CFStringCreateCopy(kCFAllocatorDefault, (CFStringRef)obj);
                }
            }
        }
    }
    return NULL;
}

/**
 *  查找提供商名称
 *
 *  @param idVendor  VendorID
 *  @param idProduct ProductID
 *
 *  @return 返回提供商名称
 */
CFStringRef find_vendor(int idVendor, int idProduct) {
    CFMutableDictionaryRef matchingDictionary = IOServiceMatching(kIOUSBDeviceClassName);
    
    CFNumberRef numberRef;
    numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &idVendor);
    CFDictionaryAddValue(matchingDictionary, CFSTR(kUSBVendorID), numberRef);
    CFRelease(numberRef);
    numberRef = 0;
    
    numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &idProduct);
    CFDictionaryAddValue(matchingDictionary, CFSTR(kUSBProductID), numberRef);
    CFRelease(numberRef);
    numberRef = 0;
    
    io_iterator_t iter = NULL;
    if (IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDictionary, &iter) == KERN_SUCCESS) {
        io_service_t usbDeviceRef;
        if ((usbDeviceRef = IOIteratorNext(iter))) {
            CFMutableDictionaryRef dict = NULL;
            if (IORegistryEntryCreateCFProperties(usbDeviceRef, &dict, kCFAllocatorDefault, kNilOptions) == KERN_SUCCESS) {
                CFTypeRef obj = CFDictionaryGetValue(dict, CFSTR(kIOHIDSerialNumberKey));
                if (!obj) {
                    obj = CFDictionaryGetValue(dict, CFSTR(kUSBVendorString));
                }
                if (obj) {
                    return CFStringCreateCopy(kCFAllocatorDefault, (CFStringRef)obj);
                }
            }
        }
    }
    return NULL;
}

/**
 *  查找设备型号
 *
 *  @param idVendor  VendorID
 *  @param idProduct ProductID
 *
 *  @return 返回设备型号
 */
CFStringRef find_product(int idVendor, int idProduct) {
    CFMutableDictionaryRef matchingDictionary = IOServiceMatching(kIOUSBDeviceClassName);
    
    CFNumberRef numberRef;
    numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &idVendor);
    CFDictionaryAddValue(matchingDictionary, CFSTR(kUSBVendorID), numberRef);
    CFRelease(numberRef);
    numberRef = 0;
    
    numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &idProduct);
    CFDictionaryAddValue(matchingDictionary, CFSTR(kUSBProductID), numberRef);
    CFRelease(numberRef);
    numberRef = 0;
    
    io_iterator_t iter = NULL;
    if (IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDictionary, &iter) == KERN_SUCCESS) {
        io_service_t usbDeviceRef;
        if ((usbDeviceRef = IOIteratorNext(iter))) {
            CFMutableDictionaryRef dict = NULL;
            if (IORegistryEntryCreateCFProperties(usbDeviceRef, &dict, kCFAllocatorDefault, kNilOptions) == KERN_SUCCESS) {
                CFTypeRef obj = CFDictionaryGetValue(dict, CFSTR(kIOHIDSerialNumberKey));
                if (!obj) {
                    obj = CFDictionaryGetValue(dict, CFSTR(kUSBProductString));
                }
                if (obj) {
                    return CFStringCreateCopy(kCFAllocatorDefault, (CFStringRef)obj);
                }
            }
        }
    }
    return NULL;
}

/**
 *  查找厂商型号
 *
 *  @param idVendor  VendorID
 *  @param idProduct ProductID
 *
 *  @return 返回厂商型号
 */
CFStringRef find_Manufacturer(int idVendor, int idProduct) {
    CFMutableDictionaryRef matchingDictionary = IOServiceMatching(kIOUSBDeviceClassName);
    
    CFNumberRef numberRef;
    numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &idVendor);
    CFDictionaryAddValue(matchingDictionary, CFSTR(kUSBVendorID), numberRef);
    CFRelease(numberRef);
    numberRef = 0;
    
    numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &idProduct);
    CFDictionaryAddValue(matchingDictionary, CFSTR(kUSBProductID), numberRef);
    CFRelease(numberRef);
    numberRef = 0;
    
    io_iterator_t iter = NULL;
    if (IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDictionary, &iter) == KERN_SUCCESS) {
        io_service_t usbDeviceRef;
        if ((usbDeviceRef = IOIteratorNext(iter))) {
            CFMutableDictionaryRef dict = NULL;
            if (IORegistryEntryCreateCFProperties(usbDeviceRef, &dict, kCFAllocatorDefault, kNilOptions) == KERN_SUCCESS) {
                CFTypeRef obj = CFDictionaryGetValue(dict, CFSTR(kIOHIDSerialNumberKey));
                if (!obj) {
                    obj = CFDictionaryGetValue(dict, CFSTR(kUSBManufacturerStringIndex));
                }
                if (obj) {
                    return CFStringCreateCopy(kCFAllocatorDefault, (CFStringRef)obj);
                }
            }
        }
    }
    return NULL;
}

@end
