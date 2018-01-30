//
//  IMBInformationManager.m
//  iMobieTrans
//
//  Created by iMobie on 14-3-11.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBInformationManager.h"
//#import "RegexKitLite.h"
//#import "IMBDeviceInfo.h"
//#import "RegexKitLite.h"
//#import "IMBHelper.h"
//#import "IMBIPod.h"
//#import "IMBiCloudClient.h"
//#import "IMBInformation.h"
//#import "IMBProgressCounter.h"

static IMBInformationManager *sigleton = nil;
@implementation IMBInformationManager
@synthesize informationDic = _informationDic;
+ (IMBInformationManager *)shareInstance{
    if (sigleton == nil) {
        @synchronized(self){
            sigleton = [[IMBInformationManager alloc] init];
        }
    }
    return sigleton;
}

- (id)init {
    if (self = [super init]) {
        _informationDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

//限制当前对象创建多实例
#pragma mark - sengleton setting
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sigleton == nil) {
            sigleton = [super allocWithZone:zone];
        }
    }
    return sigleton;
}

/*
- (SimpleNode *)getBackupRootNode:(IMBIPod *)ipod
{
    //SimpleNode *rootNode = [[[SimpleNode alloc] initWithName:@"root"] autorelease];
    NSMutableArray *backupNodeArr = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isdir;
    isdir = NO;

    if ([fileManager fileExistsAtPath:[IMBHelper getBackupFolderPath] isDirectory:&isdir]) {
      if (isdir) {
            NSURL *url = [[NSURL alloc ] initFileURLWithPath:[IMBHelper getBackupFolderPath]];
            NSArray *backupFolderArr = [fileManager contentsOfDirectoryAtURL:url includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:  NSDirectoryEnumerationSkipsHiddenFiles   error:nil];
            for (int i = 0; i<[backupFolderArr count];i++) {
                NSURL *filePathURL = [backupFolderArr objectAtIndex:i];
                NSString *filePath = [filePathURL relativePath];
                BOOL isDir = NO;
                if ([fileManager fileExistsAtPath:filePath isDirectory:&isDir]) {
                    if (isDir) {
                        //得到所有的备份node
                        NSString *manifestplistPath = [filePath stringByAppendingPathComponent:@"Manifest.plist"];
                        if ([fileManager fileExistsAtPath:manifestplistPath]) {
                            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:manifestplistPath];
                            //过滤掉4代一下备份文件
                            if (![dic.allKeys containsObject:@"BackupKeyBag"]) {
                                continue;
                            }
                            
                            //分别取出udid backupdata deviceName
                            NSDate *backupDate = [dic objectForKey:@"Date"];
                            NSDictionary *lockdown = [dic objectForKey:@"Lockdown"];
                            NSString *udid = [lockdown objectForKey:@"UniqueDeviceID"];
                            NSString *deviceName = [lockdown objectForKey:@"DeviceName"];
                            NSString *productVersion = [lockdown objectForKey:@"ProductVersion"];
                            NSString *productType = [lockdown objectForKey:@"ProductType"];
                            SimpleNode *node = [[SimpleNode alloc] init];
                            node.udid = udid;
                            node.deviceName = deviceName;
                            node.backupDate = [self stringFromFomate:backupDate formate:@"yyyy-MM-dd HH:mm"];
                            node.fileName = node.backupDate;
                            node.backupPath = filePath;
                            node.container = YES;
                            node.isBackupNode = YES;
                            NSString *reg = @"iPad\\w+,\\w+";
                            NSString *reg1 = @"iPhone\\w+,\\w+";
                            NSString *reg2 = @"iPod\\w+,\\w+";
                            BOOL isiPad = [productType isMatchedByRegex:reg];
                            BOOL isiPhone = [productType isMatchedByRegex:reg1];
                            BOOL isiPodTouch = [productType isMatchedByRegex:reg2];
                            if (isiPad) {
                                
                                node.productType = iPadType;
                                
                            }else if (isiPhone)
                            {
                                node.productType = iPhoneType;
                                
                            }else if (isiPodTouch)
                            {
                                node.productType = iPodTouchType;
                            }
                            node.productVersion = productVersion;
                            node.childrenArray = [self supportedBackupItems:node];
                            [backupNodeArr addObject:node];
                            [node release];
                        }
                        
                    }
                    
                }
            }
        }
    }else
    {
        NSLog(@"备份目录不存在");
    }
    
    SimpleNode *rootNode = [self createRootNode:backupNodeArr withiPod:ipod];
    
   
    return rootNode;
}

- (SimpleNode *)getBackupRootNodeByiCloud:(IMBIPod *)ipod WithArray:(NSArray *)backupListArray {
    SimpleNode *rootNode = nil;
    if (backupListArray != nil && backupListArray.count > 0) {
        NSMutableArray *backupNodeArr = [NSMutableArray array];
        for (IMBiCloudBackup *iCloudBackup in backupListArray) {
            SimpleNode *node = [[SimpleNode alloc] init];
            node.udid = iCloudBackup.uuid;
            node.deviceName = iCloudBackup.deviceName;
            node.backupDate = [IMBHelper longToDateString1970:(long)iCloudBackup.lastModified withMode:3];
            node.fileName = node.backupDate;
            node.backupPath = nil;//待定
            node.container = YES;
            node.isBackupNode = YES;
            node.snapshotID = iCloudBackup.snapshotID;
            NSString *reg = @"iPad\\w+,\\w+";
            NSString *reg1 = @"iPhone\\w+,\\w+";
            NSString *reg2 = @"iPod\\w+,\\w+";
            BOOL isiPad = [iCloudBackup.productType isMatchedByRegex:reg];
            BOOL isiPhone = [iCloudBackup.productType isMatchedByRegex:reg1];
            BOOL isiPodTouch = [iCloudBackup.productType isMatchedByRegex:reg2];
            if (isiPad) {
                
                node.productType = iPadType;
                
            }else if (isiPhone)
            {
                node.productType = iPhoneType;
                
            }else if (isiPodTouch)
            {
                node.productType = iPodTouchType;
            }
            node.productVersion = iCloudBackup.iOSVersion;
            node.childrenArray = [self supportedBackupItems:node];
            [backupNodeArr addObject:node];
            [node release];
        }
        
        rootNode = [self createRootNode:backupNodeArr withiPod:ipod];
    }
    return rootNode;
}

- (SimpleNode *)createRootNode:(NSArray *)backupNodeArray withiPod:(IMBIPod *)ipod {
    SimpleNode *rootNode = [[[SimpleNode alloc] initWithName:@"root"] autorelease];
    NSMutableArray *devceArr = [NSMutableArray array];   //得到所有的设备node
    NSMutableArray *devceudid = [NSMutableArray array];
    for (SimpleNode *node in backupNodeArray) {
        if (![devceudid containsObject:node.udid]) {
            SimpleNode *nnode = [[SimpleNode alloc] init];
            nnode.deviceName = node.deviceName;
            nnode.udid = node.udid;
            nnode.fileName = node.deviceName;
            nnode.container = YES;
            nnode.isDeviceNode = YES;
            nnode.productType = node.productType;
            nnode.snapshotID = node.snapshotID;
            [devceArr addObject:nnode];
            [devceudid addObject:node.udid];
            [nnode release];
        }
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    for (SimpleNode *devicenode in devceArr) {
        for (SimpleNode *node in backupNodeArray){
            if ([devicenode.udid isEqualToString:node.udid]) {
                NSString *mfPlPath = [node.backupPath stringByAppendingPathComponent:@"Manifest.plist"];
                NSString *tmpMFPlPath = [[IMBHelper getAppTempPath] stringByAppendingPathComponent:@"Manifest.plist"];
                if ([fm fileExistsAtPath:mfPlPath]) {
                    if ([fm fileExistsAtPath:tmpMFPlPath]) {
                        [fm removeItemAtPath:tmpMFPlPath error:nil];
                    }
                    if ([fm copyItemAtPath:mfPlPath toPath:tmpMFPlPath error:nil]) {
                        NSDictionary *manifestDic = [NSDictionary dictionaryWithContentsOfFile:tmpMFPlPath];
                        NSArray *allKey = [manifestDic allKeys];
                        if (allKey != nil & allKey.count > 0) {
                            if ([allKey containsObject:@"IsEncrypted"]) {
                                [node setIsEncrypt:[[manifestDic objectForKey:@"IsEncrypted"] boolValue]];
                            } else {
                                [node setIsEncrypt:NO];
                            }
                            
                            if ([allKey containsObject:@"DecryptKey"]) {
                                [node setDecryptKey:[manifestDic objectForKey:@"DecryptKey"]];
                            } else {
                                [node setDecryptKey:nil];
                            }
                        }
                    } else {
                        node.isEncrypt = NO;
                        node.decryptKey = nil;
                    }
                } else {
                    node.isEncrypt = NO;
                    node.decryptKey = nil;
                }
                [devicenode.childrenArray addObject:node];
            }
        }
        [rootNode.childrenArray addObject:devicenode];
        if ([devicenode.udid isEqualToString:ipod.deviceHandle.udid]) {
            [rootNode.childrenArray exchangeObjectAtIndex:0 withObjectAtIndex:[rootNode.childrenArray indexOfObject:devicenode]];
        }
    }
    return rootNode;
}

- (NSMutableArray *)supportedBackupItems:(SimpleNode *)nnode
{
    NSMutableArray *supportedArr = [NSMutableArray array];
    //判断是否支持备份,notes,contacts,bookmarks,calendar
   
    SimpleNode *backupnode = [[SimpleNode alloc] init];
    backupnode.fileName = CustomLocalizedString(@"MenuItem_id_31",nil);
    backupnode.deviceName = nnode.deviceName;
    backupnode.udid = nnode.udid;
    backupnode.backupDate = nnode.backupDate;
    backupnode.backupPath = nnode.backupPath;
    backupnode.snapshotID = nnode.snapshotID;
    backupnode.container = NO;
    backupnode.type = @"Explorer";
    backupnode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,backupnode.fileName];
    [supportedArr addObject:backupnode];
    [backupnode release];

    SimpleNode *notesnode = [[SimpleNode alloc] init];
    notesnode.fileName = CustomLocalizedString(@"MenuItem_id_17",nil);
    notesnode.deviceName = nnode.deviceName;
    notesnode.udid = nnode.udid;
    notesnode.backupDate = nnode.backupDate;
    notesnode.backupPath = nnode.backupPath;
    notesnode.snapshotID = nnode.snapshotID;
    notesnode.container = NO;
    notesnode.type = @"Notes";
    notesnode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,notesnode.fileName];
    [supportedArr addObject:notesnode];
    [notesnode release];

    SimpleNode *contactsnode = [[SimpleNode alloc] init];
    contactsnode.fileName = CustomLocalizedString(@"MenuItem_id_20",nil);
    contactsnode.deviceName = nnode.deviceName;
    contactsnode.udid = nnode.udid;
    contactsnode.backupDate = nnode.backupDate;
    contactsnode.backupPath = nnode.backupPath;
    contactsnode.snapshotID = nnode.snapshotID;
    contactsnode.container = NO;
    contactsnode.type = @"Contact";
    contactsnode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,contactsnode.fileName];
    [supportedArr addObject:contactsnode];
    [contactsnode release];

    
    SimpleNode *bookmarksnode = [[SimpleNode alloc] init];
    bookmarksnode.fileName = CustomLocalizedString(@"MenuItem_id_21",nil);
    bookmarksnode.deviceName = nnode.deviceName;
    bookmarksnode.udid = nnode.udid;
    bookmarksnode.backupDate = nnode.backupDate;
    bookmarksnode.backupPath = nnode.backupPath;
    bookmarksnode.snapshotID = nnode.snapshotID;
    bookmarksnode.container = NO;
    bookmarksnode.type = @"Bookmarks";
    bookmarksnode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,bookmarksnode.fileName];
    [supportedArr addObject:bookmarksnode];
    [bookmarksnode release];

    SimpleNode *calendarnode = [[SimpleNode alloc] init];
    calendarnode.fileName = CustomLocalizedString(@"MenuItem_id_22",nil);
    calendarnode.deviceName = nnode.deviceName;
    calendarnode.udid = nnode.udid;
    calendarnode.backupDate = nnode.backupDate;
    calendarnode.backupPath = nnode.backupPath;
    calendarnode.snapshotID = nnode.snapshotID;
    calendarnode.type = @"Calendar";
    calendarnode.container = NO;
    calendarnode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,calendarnode.fileName];
    [supportedArr addObject:calendarnode];
    [calendarnode release];

    
    if (nnode.productType == iPhoneType) {
        
        SimpleNode *voicemailnode = [[SimpleNode alloc] init];
        voicemailnode.fileName = CustomLocalizedString(@"MenuItem_id_27",nil);
        voicemailnode.deviceName = nnode.deviceName;
        voicemailnode.udid = nnode.udid;
        voicemailnode.backupDate = nnode.backupDate;
        voicemailnode.backupPath = nnode.backupPath;
        voicemailnode.snapshotID = nnode.snapshotID;
        voicemailnode.container = NO;
        voicemailnode.type = @"Voicemail";
        voicemailnode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,voicemailnode.fileName];
        [supportedArr addObject:voicemailnode];
        [voicemailnode release];
    }
    
    NSString *version = nnode.productVersion;
    NSString *versionstr = nil;
    if (version.length>0) {
        NSRange range;
        range.length = 1;
        range.location = 0;
        versionstr = [version substringWithRange:range];
        
    }
   if ([versionstr intValue]>=4) {
       
       SimpleNode *messagenode = [[SimpleNode alloc] init];
       messagenode.fileName = CustomLocalizedString(@"MenuItem_id_19",nil);
       messagenode.deviceName = nnode.deviceName;
       messagenode.udid = nnode.udid;
       messagenode.backupDate = nnode.backupDate;
       messagenode.backupPath = nnode.backupPath;
       messagenode.snapshotID = nnode.snapshotID;
       messagenode.container = NO;
       messagenode.type = @"Message";
       messagenode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,messagenode.fileName];
       [supportedArr addObject:messagenode];
       [messagenode release];
        
    }

    if (nnode.productType == iPhoneType) {
        
        SimpleNode *callHistorynode = [[SimpleNode alloc] init];
        callHistorynode.fileName = CustomLocalizedString(@"MenuItem_id_18",nil);
        callHistorynode.deviceName = nnode.deviceName;
        callHistorynode.udid = nnode.udid;
        callHistorynode.backupDate = nnode.backupDate;
        callHistorynode.backupPath = nnode.backupPath;
        callHistorynode.snapshotID = nnode.snapshotID;
        callHistorynode.container = NO;
        callHistorynode.type = @"CallHistory";
        callHistorynode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,callHistorynode.fileName];
        [supportedArr addObject:callHistorynode];
        [callHistorynode release];
    }
    //默认支持safarihistory
   
    SimpleNode *safarinode = [[SimpleNode alloc] init];
    safarinode.fileName = CustomLocalizedString(@"MenuItem_id_37",nil);
    safarinode.deviceName = nnode.deviceName;
    safarinode.udid = nnode.udid;
    safarinode.backupDate = nnode.backupDate;
    safarinode.backupPath = nnode.backupPath;
    safarinode.snapshotID = nnode.snapshotID;
    safarinode.container = NO;
    safarinode.type = @"SafariHistory";
    safarinode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,safarinode.fileName];
    [supportedArr addObject:safarinode];
    [safarinode release];

    return supportedArr;
}

- (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate {
	
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSString *str = [formatter stringFromDate:date];
	[formatter release];
	
    return str;
}

- (void)copyiCloudFileToMac:(NSString *)despath withNode:(SimpleNode *)node withMidPath:(NSString *)midPath successNum:(int *)successNum {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (node.childrenArray.count > 0) {
        for (SimpleNode *childNode in node.childrenArray) {
            if (childNode.container) {
                NSString *dicPath = [despath stringByAppendingPathComponent:childNode.fileName];
                if (![fm fileExistsAtPath:dicPath]) {
                    [fm createDirectoryAtPath:dicPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                [self copyiCloudFileToMac:dicPath withNode:childNode withMidPath:midPath successNum:successNum];
            }else {
                NSString *path = [midPath stringByAppendingPathComponent:childNode.key];
                if ([fm fileExistsAtPath:path]) {
                    NSString *path1 = [despath stringByAppendingPathComponent:childNode.fileName];
                    if ([fm fileExistsAtPath:path1]) {
                        path1 = [IMBHelper getFilePathAlias:path1];
                    }
                    if ([fm copyItemAtPath:path toPath:path1 error:nil]) {
                        *successNum += 1;
                    }
                }
            }
        }
    }
}

- (NSString *)createDifferentfileNameinfolder:(NSString *)folder  filePath:(NSString *)filePath fileManager:(NSFileManager *)fileMan
{
    NSString *fileName = [filePath lastPathComponent];
    NSString *newfilePath = nil;
    NSArray *arr = [fileName componentsSeparatedByString:@"."];
    int i = 1;
    if (arr.count == 1) {
        
        while (1) {
            
            newfilePath = [folder stringByAppendingFormat:@"/%@(%d)",fileName,i];
            if (![fileMan fileExistsAtPath:newfilePath]) {
                
                break;
                
            }
            
            i++;
            
        }
        
        
    }else
    {
        NSString *filename = nil;
        NSString *extensionname = nil;
        if (arr.count>=2) {
            
            filename = [arr objectAtIndex:0];
            extensionname = [arr objectAtIndex:1];
            
        }
        
        while (1) {
            
            newfilePath = [folder stringByAppendingFormat:@"/%@(%d).%@",filename,i,extensionname];
            if (![fileMan fileExistsAtPath:newfilePath]) {
                
                break;
                
            }
            
            i++;
            
        }
    }
    
    return newfilePath;
}

+ (BOOL)backupfileIsencrypt:(NSString *)backupPath
{
    //从备份文件目录下读取manifest.plist文件从它的encrypt属性去判断
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *mpfilePath = [backupPath stringByAppendingPathComponent:@"Manifest.plist"];
    NSString *desfilePath = [[IMBHelper getAppTempPath] stringByAppendingPathComponent:@"Manifest.plist"];
    if ([fileManager fileExistsAtPath:desfilePath]) {
        
        [fileManager removeItemAtPath:desfilePath error:nil];
    }
    [fileManager copyItemAtPath:mpfilePath toPath:desfilePath error:nil];
    NSDictionary *mpDic = [NSDictionary dictionaryWithContentsOfFile:desfilePath];
    BOOL isEncrypted = [[mpDic objectForKey:@"IsEncrypted"] boolValue];
    return isEncrypted;
}

+ (int)getBackupFileVersion:(NSString *)backupPath
{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *mpfilePath = [backupPath stringByAppendingPathComponent:@"Manifest.plist"];
    NSString *desfilePath = [[IMBHelper getAppTempPath] stringByAppendingPathComponent:@"Manifest.plist"];
    if ([fileManager fileExistsAtPath:desfilePath]) {
        
        [fileManager removeItemAtPath:desfilePath error:nil];
    }
    [fileManager copyItemAtPath:mpfilePath toPath:desfilePath error:nil];
    NSDictionary *mpDic = [NSDictionary dictionaryWithContentsOfFile:desfilePath];
    NSDictionary *lockDic  = [mpDic objectForKey:@"Lockdown"];
    NSString *productVersion = [lockDic objectForKey:@"ProductVersion"];
    NSString *versionstrone = nil;
    if (productVersion.length>0) {
        NSRange range;
        range.length = 1;
        range.location = 0;
        versionstrone = [productVersion substringWithRange:range];
    }else
    {
        return 5;
    }
    
    return [versionstrone intValue];
}

+ (float)getBackupFileFloatVersion:(NSString *)backupPath
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *mpfilePath = [backupPath stringByAppendingPathComponent:@"Manifest.plist"];
    NSString *desfilePath = [[IMBHelper getAppTempPath] stringByAppendingPathComponent:@"Manifest.plist"];
    if ([fileManager fileExistsAtPath:desfilePath]) {
        
        [fileManager removeItemAtPath:desfilePath error:nil];
    }
    [fileManager copyItemAtPath:mpfilePath toPath:desfilePath error:nil];
    NSDictionary *mpDic = [NSDictionary dictionaryWithContentsOfFile:desfilePath];
    NSDictionary *lockDic  = [mpDic objectForKey:@"Lockdown"];
    NSString *productVersion = [lockDic objectForKey:@"ProductVersion"];
    NSString *versionstrone = nil;
    if (productVersion.length>0) {
        NSRange range;
        range.length = 3;
        range.location = 0;
        versionstrone = [productVersion substringWithRange:range];
    }else
    {
        return 5;
    }
    
    float version = roundf([versionstrone floatValue]*10)*0.1;
   
    return version;
}


+ (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;
}

- (oneway void)release {
}

- (id)autorelease {
    return self;
}

//重新计算filerecord的hash值
+ (void)reCaculateRecordHash:(IMBMBFileRecord *)mbfileRecord backupFolderPath:(NSString *)backupFolderPath {
    if (mbfileRecord != nil) {
        NSString *targetFilePath = [backupFolderPath stringByAppendingPathComponent:[mbfileRecord key]];
        // 得到文件的大小并进行赋值
        int64_t fileSize = [IMBUtilTool fileSizeAtPath:targetFilePath];
        [mbfileRecord changeFileLength:fileSize];
        // 计算hash的值并赋与DataHash
        uint8_t hash[20] = { 0x00 };
        NSData *cont = [NSData dataWithContentsOfFile:targetFilePath];
        const char *buf = [cont bytes];
        long len = cont.length;
        CC_SHA1_CTX content;
        CC_SHA1_Init(&content);
        CC_SHA1_Update(&content, buf, (int)len);
        CC_SHA1_Final(hash, &content);
        NSString *dataHashStr = [NSString stringToHex:hash length:CC_SHA1_DIGEST_LENGTH];
        [mbfileRecord setDataHash:dataHashStr];
    }
}

// 将修改号了的Manifest文件保存到备份文件中去,recordsArray修改后的记录,cacheFilePath文件写入的缓存的路径,backupFolderPath备份的文件夹下面
+ (BOOL)saveMBDB:(NSArray*)recordsArray cacheFilePath:(NSString *)cacheFilePath backupFolderPath:(NSString*)backupFolderPath {
    //[[IMBHelper getBackupCacheFolder] stringByAppendingPathComponent:@"Manifest.mbdb"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *cacheMBDBFilePath = cacheFilePath;
    NSMutableData *writer = [[NSMutableData alloc] init];
    if (recordsArray != nil && [recordsArray count] > 0) {
        NSData *sigData = [@"6D6264620500" hexToBytes];
        [writer appendData:sigData];
        for (IMBMBFileRecord *fileRecord in recordsArray) {
            [self writeStr:writer str:[fileRecord domain]];
            [self writeStr:writer str:[fileRecord path]];
            [self writeStr:writer str:[fileRecord linkTarget]];
            [self writeDataHex:writer hexStr:[fileRecord dataHash]];
            [self writeData:writer withData:[fileRecord encryptionKey]];
            
            NSData *lpdata = [[fileRecord data] hexToBytes];
            if (lpdata != nil) {
                [writer appendData:lpdata];
            }
            
            NSArray *properties = [[fileRecord properties] retain];
            
            
            if (properties != nil && [properties count] > 0) {
                for (IMBFileProperties *filePropertie in properties) {
                    [self writeStr:writer str:[filePropertie name]];
                    [self writeDataHex:writer hexStr:[filePropertie value]];
                }
            }
            [properties release];
        }
    }
    [writer writeToFile:cacheMBDBFilePath atomically:YES];
    [writer release];
    
    if ([fm fileExistsAtPath:cacheMBDBFilePath] && [IMBUtilTool fileSizeAtPath:cacheMBDBFilePath] > 0) {
        NSString *targetFilePath = [backupFolderPath stringByAppendingPathComponent:@"Manifest.mbdb"];
        if ([fm fileExistsAtPath:targetFilePath]) {
            [fm removeItemAtPath:targetFilePath error:nil];
        }
        [fm copyItemAtPath:cacheMBDBFilePath toPath:targetFilePath error:nil];
    }
    return YES;
}

+ (void)writeStr:(NSMutableData*)writer str:(NSString*)str {
    int dataLength = 0;
    Byte b0, b1;
    if (str == nil) {
        b0 = (Byte)255;
        b1 = (Byte)255;
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
    } else {
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        dataLength = (int)[data length];
        b0 = (Byte)(dataLength / 256);
        b1 = (Byte)(dataLength % 256);
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
        [writer appendData:data];
    }
}

+ (void)writeDataHex:(NSMutableData*)writer hexStr:(NSString*)hexStr {
    int dataLength = 0;
    Byte b0, b1;
    if (hexStr == nil) {
        b0 = (Byte)255;
        b1 = (Byte)255;
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
    } else {
        NSData *data = [hexStr hexToBytes];
        dataLength = (int)[data length];
        b0 = (Byte)(dataLength / 256);
        b1 = (Byte)(dataLength % 256);
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
        [writer appendData:data];
    }
}

+ (void)writeData:(NSMutableData*)writer withData:(NSData*)data {
    int dataLength = 0;
    Byte b0, b1;
    if (data == nil) {
        b0 = (Byte)255;
        b1 = (Byte)255;
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
    } else {
        dataLength = (int)[data length];
        b0 = (Byte)(dataLength / 256);
        b1 = (Byte)(dataLength % 256);
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
        [writer appendData:data];
    }
}
*/

- (void)dealloc
{
    [_informationDic release],_informationDic = nil;
    [super dealloc];
}
    
@end
