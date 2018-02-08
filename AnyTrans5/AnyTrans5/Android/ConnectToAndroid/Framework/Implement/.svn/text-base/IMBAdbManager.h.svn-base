//
//  IMBAdbManager.h
//  
//
//  Created by JGehry on 12/12/16.
//
//

#import <Foundation/Foundation.h>

@interface IMBAdbManager : NSObject {
    NSString *_serialNum;
    NSString *_packageName;
    
    BOOL _isSelectSD;
    BOOL _isRetain;
    NSTask *_adbTask;

}

/**
 *  serialNum                  设备序列号
 *  packageName                包名
 *  isSelectSD                 是否选择安装至SD卡，默认安装到系统内置存储中
 *  isRetain                   卸载应用是否保留数据与缓存，默认全部删除
 */
@property (nonatomic, readwrite, retain) NSString *serialNum;
@property (nonatomic, readwrite, retain) NSString *packageName;
@property (nonatomic, assign) BOOL isSelectSD;
@property (nonatomic, assign) BOOL isRetain;

+ (IMBAdbManager *)singleton;
+ (NSString *)findSerial:(int)vendorID withProductID:(int)productID;
+ (NSString *)findVendor:(int)vendorID withProductID:(int)productID;
+ (NSString *)findProduct:(int)vendorID withProductID:(int)productID;
+ (NSString *)findManufacturer:(int)vendorID withProductID:(int)productID;

- (NSString *)runADBCommand:(NSArray *)cmd;//执行adb命令
- (NSString *)runLsofCommand:(NSArray *)cmd;//执行lsof命令
- (NSString *)runGrepCommand:(NSArray *)cmd;//执行grep命令
- (NSString *)runADBAppointCommand:(NSString *)cmd1 withCmd2:(NSString *)cmd2 withCmd3:(NSString *)cmd3;//执行ADB指定命令
- (NSString *)runAAPTCommand:(NSArray *)cmd;//执行aapt命令

//执行aapt命令获取apk版本信息
- (NSArray *)localAPKVersion:(NSString *)path;

- (NSArray *)adbSerialNum;
- (NSArray *)waitForDevice;//等待连接设备
- (NSArray *)connectDevices;//连接设备
- (NSArray *)startServer;//启动服务
- (NSArray *)killServer;//关闭服务
- (NSArray *)rebootDevice;//重启手机

- (NSArray *)cpFromDataDb:(NSString *)dataDb withSdcard:(NSString *)sdcard;
- (NSArray *)ddFromDataDbWithSerialNo:(NSString *)serialNo withDataDb:(NSString *)dataDb withSdcard:(NSString *)sdcard withPermission:(NSString *)permission;//从设备的高权限到低权限
- (NSArray *)pullFromDeviceWithSerialNo:(NSString *)serialNo withSource:(NSString *)source withDestination:(NSString *)dest;//从设备中拷贝文件至Mac
- (NSArray *)pushToDeviceWithSerialNo:(NSString *)serialNo withSource:(NSString *)source withDestination:(NSString *)dest;//从Mac中拷贝文件至设备
- (NSArray *)pushToDeviceWithSerialNo:(NSString *)serialNo withRootSource:(NSString *)source withRootPath:(NSString *)rootPath;//从Mac中拷贝Root文件至设备
- (NSArray *)startIntent:(NSString *)serialNo;//启动某个Intent
- (NSArray *)adbForwardTCP:(NSString *)serialNo withTcpLocal:(int)local withTcpRemote:(int)remote;//重定向TCP
- (NSArray *)adbForwardRemoveTcp:(NSString *)serialNo withTcpLocal:(int)local;//取消重定向TCP
- (NSArray *)forceStopIntentWithSerialNo:(NSString *)serialNo;//停止某个Intent
- (NSArray *)pmClearIntentWithSerialNo:(NSString *)serialNo;//清除缓存
- (NSArray *)killIntentWithSerialNo:(NSString *)serialNo;////杀死与应用程序相关联的所有进程
- (NSArray *)killAllIntentWithSerialNo:(NSString *)serialNo;//杀死与应用程序相关联的所有进程

- (NSArray *)getAPKVersion:(NSString *)serialNo withPackageName:(NSString *)packageName;//获取apk版本号
- (NSArray *)installAPK:(NSString *)apkPath withSerialNo:(NSString *)serialNo;//安装APK
- (NSArray *)unInstallAPK:(NSString *)apkPath withSerialNo:(NSString *)serialNo;//卸载APK
- (NSArray *)isInstallerAPK:(NSString *)packageName withSerialNo:(NSString *)serialNo;//检查是否已安装APK，查看包存在的位置
- (NSArray *)isInstallerAPKPath:(NSString *)packageName withSerialNo:(NSString *)serialNo;//检查是否已安装APK，查看apk存在的位置

- (NSArray *)checkApkIsRunning:(NSString *)serialNo;//检查当前Apk是否运行
- (NSArray *)checkPortOccupy;//检查adb端口是否被进程占用

- (NSArray *)clearServiceLogcat:(NSString *)serialNo;//清除当前服务日志
- (NSArray *)checkServiceIsRunning:(NSString *)serialNo;//检查当前服务是否运行

- (NSArray *)createRootDirectory:(NSString *)serialNo withRootPath:(NSString *)rootPath;//创建Root隐藏文件夹
- (NSArray *)moveRootDirectory:(NSString *)serialNo withRootPath:(NSString *)rootPath withRootPathNumberOrName:(NSString *)desNumberOrName withRootPathName:(NSString *)name;//移动Root隐藏文件
- (NSArray *)removeRootDirectory:(NSString *)serialNo withRootPath:(NSString *)rootPath withRootPathNumberOrName:(NSString *)desNumberOrName;//删除Root隐藏文件夹
- (NSArray *)removeRootDirectoryAtFile:(NSString *)serialNo withRootPath:(NSString *)rootPath;//删除Root隐藏文件夹下的文件

- (NSArray *)checkRootReource:(NSString *)serialNo withRootPath:(NSString *)rootPath;//检查Root所需相关资源文件
- (NSMutableArray *)excutePermission:(NSString *)serialNo withRootPath:(NSString *)rootPath;//获取文件可执行权限

- (NSArray *)startRootFire:(NSString *)serialNo withRootPath:(NSString *)rootPath;//开始Root
- (NSArray *)checkRootState:(NSString *)serialNo withPathDir:(NSString *)pathDir;//检查Root结果状态

- (NSArray *)createDbBackupDirectory:(NSString *)serialNo withPathName:(NSString *)pathName;//创建Backup临时文件夹

- (NSArray *)checkScreenOnState:(NSString *)serialNo;//检测屏幕状态
- (NSArray *)backHomeScreen:(NSString *)serialNo;//回到Home页面屏幕
- (NSArray *)wakeUpScreen:(NSString *)serialNo;//唤醒屏幕

- (NSArray *)checkRecoveryHasPasswordWithSerailNo:(NSString *)serialNo;//检测设备在Recovery模式下是否存在锁屏所需要的key文件
- (NSArray *)grantFilePermission:(NSString *)serialNo withPermission:(NSString *)permission;
- (NSArray *)removeRecoveryGesture:(NSString *)serialNo withCommod:(NSString *)commod;//删除Recovery模式下的锁屏密码Gesture.key
- (NSArray *)removeRecoveryLocksettings:(NSString *)serialNo withCommod:(NSString *)commod;//删除Recovery模式下的锁屏密码locksettings.db
- (NSArray *)removeRecoveryPassword:(NSString *)serialNo withCommod:(NSString *)commod;//删除Recovery模式下的锁屏密码Password.key

- (NSArray *)checkShellStatus:(NSString *)serialNo withCommod:(NSString *)commod;//检测Shell状态

@end


