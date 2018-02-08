//
//  IMBBackupManager.m
//  AnyTrans
//
//  Created by long on 16-7-18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBackupManager.h"
#import "TempHelper.h"
#import "RegexKitLite.h"
#import "DateHelper.h"
#import "IMBMBDBParse.h"
#import "StringHelper.h"
#import "IMBUtilTool.h"
#import "IMBNoteDataEntity.h"
#import "IMBSMSChatDataEntity.h"
#import "NSString+Category.h"
#import "IMBDeviceInfo.h"
static IMBBackupManager *sigleton = nil;
@implementation IMBBackupManager
@synthesize recordDic = _recordDic;
@synthesize backupNodeArr;
@synthesize backUpPath = _backUpPath;
@synthesize iosVersion = _iosVersion;
@synthesize backFileArray = _backFileArray;
-(id)init{
    if ([super init]) {
        backupNodeArr = [[NSMutableArray alloc]init];
        fm = [NSFileManager defaultManager];
    }
    return self;
}

+ (IMBBackupManager *)shareInstance{
    if (sigleton == nil) {
        @synchronized(self){
            sigleton = [[IMBBackupManager alloc] init];
        }
    }
    return sigleton;
}

-(void)dealloc{
    [backupNodeArr release];
    [_tembackupPath release],_tembackupPath = nil;
    [super dealloc];
}

- (void)parseManifest:(NSString *)backupFilePath
{
    @synchronized(self){
        _backUpPath = backupFilePath;
        NSMutableArray *recordArray = [_recordDic objectForKey:backupFilePath];
        if (recordArray == nil) {
            IMBMBDBParse *parse = [[IMBMBDBParse alloc] initWithPath:backupFilePath withIosVersion:_iosVersion];
            [parse parseManifest];
      
            if (_recordDic == nil) {
                self.recordDic = [NSMutableDictionary dictionary];
            }
            if ([parse recordArray]) {
                [_recordDic setObject:[parse recordArray] forKey:backupFilePath];
                
            }
            mdDictionary = [[NSMutableDictionary alloc]init];
            _backFileArray = [[parse recordArray] retain];
            [parse release];
        }
    }
}

- (NSMutableArray *)getBackupRootNode:(IMBiPod *)ipod withPath:(NSString *)tagPath
{
    //SimpleNode *rootNode = [[[SimpleNode alloc] initWithName:@"root"] autorelease];
    if (backupNodeArr != nil) {
        [backupNodeArr release];
        backupNodeArr = nil;
    }
    backupNodeArr = [[NSMutableArray alloc]init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isdir;
    int count = 0;
    isdir = NO;
    if ([fileManager fileExistsAtPath:tagPath isDirectory:&isdir]) {
        if (isdir) {
            NSURL *url = [[NSURL alloc ] initFileURLWithPath:tagPath];
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

                            NSString *infoFilePath = [filePath stringByAppendingPathComponent:@"Info.plist"];
                            NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:infoFilePath];
                            if (infoDic.count != 0) {
                                [node setSerialNumber:[infoDic objectForKey:@"Serial Number"]];
                            }
                            NSString *infoFilePath1 = [filePath stringByAppendingPathComponent:@"Manifest.plist"];
                            NSDictionary *infoDic1 = [NSDictionary dictionaryWithContentsOfFile:infoFilePath1];
                            if (infoDic1.count != 0&&node.serialNumber == nil) {
                                NSDictionary *lockdownDic = [infoDic1 objectForKey:@"Lockdown"];
                                [node setSerialNumber:[lockdownDic objectForKey:@"SerialNumber"]];
                            }
                            if (infoDic1.count != 0) {
//                                NSArray *allKey = infoDic1.allKeys;
//                                if ([allKey containsObject:@"IsEncrypted"]) {
//                                    [node setIsEncrypt:[[infoDic1 objectForKey:@"IsEncrypted"] boolValue]];
//                                } else {
//                                    [node setIsEncrypt:NO];
//                                }
                                [node setIsEncrypt:[[infoDic1 objectForKey:@"IsEncrypted"] boolValue]];
                            }
                            
                            node.backupDate = [DateHelper stringFromFomate:backupDate formate:@"yyyy-MM-dd HH:mm"];
                            node.fileName = node.backupDate;
                            node.backupPath = filePath;
                            node.container = NO;
                            node.isDeviceNode = NO;
                            node.isBackupNode = YES;
                            NSString *reg = @"iPad";
                            NSString *reg1 = @"iPhone";
                            NSString *reg2 = @"iPod";
                            NSRange foundObj=[productType rangeOfString:reg options:NSCaseInsensitiveSearch];
                            NSRange foundObj1=[productType rangeOfString:reg1 options:NSCaseInsensitiveSearch];
                            NSRange foundObj2=[productType rangeOfString:reg2 options:NSCaseInsensitiveSearch];
                            
                            if (foundObj.length >0) {
                                
                                node.productType = iPadType;
                                
                            }else if (foundObj1.length >0)
                            {
                                node.productType = iPhoneType;
                                
                            }else if (foundObj2.length >0)
                            {
                                node.productType = iPodTouchType;
                            }
                            node.itemSize = [self getFolderSize:node.backupPath];
                            node.productVersion = productVersion;
                            node.childrenArray = [self supportedBackupItems:node];
                            node.uniqueID = [NSString stringWithFormat:@"%@%@",node.udid,node.backupDate];
                            [backupNodeArr addObject:node];
                            if (ipod != nil && ipod.deviceInfo.isIOSDevice) {
                                if ([node.udid isEqualToString:ipod.deviceHandle.udid]) {
                                    node.isDeviceNode = YES;
                                    [backupNodeArr exchangeObjectAtIndex:count withObjectAtIndex:[backupNodeArr indexOfObject:node]];
                                    count ++;
                                }
                            }
                
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
    
//    SimpleNode *rootNode = [self createRootNode:backupNodeArr withiPod:nil];//ipod];
    
    
    return backupNodeArr;
}

- (SimpleNode *)getSingleBackupRootNode:(NSString *)filePath {
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:filePath isDirectory:&isDir]) {
        if (isDir) {
            //得到所有的备份node
            NSString *manifestplistPath = [filePath stringByAppendingPathComponent:@"Manifest.plist"];
            if ([fm fileExistsAtPath:manifestplistPath]) {
                NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:manifestplistPath];
                //过滤掉4代一下备份文件
                if (![dic.allKeys containsObject:@"BackupKeyBag"]) {
                    return nil;
                }
                //分别取出udid backupdata deviceName
                NSDate *backupDate = [dic objectForKey:@"Date"];
                NSDictionary *lockdown = [dic objectForKey:@"Lockdown"];
                NSString *udid = [lockdown objectForKey:@"UniqueDeviceID"];
                NSString *deviceName = [lockdown objectForKey:@"DeviceName"];
                NSString *productVersion = [lockdown objectForKey:@"ProductVersion"];
                NSString *productType = [lockdown objectForKey:@"ProductType"];
                SimpleNode *node = [[[SimpleNode alloc] init] autorelease];
                node.udid = udid;
                node.deviceName = deviceName;
                
                NSString *infoFilePath = [filePath stringByAppendingPathComponent:@"Info.plist"];
                NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:infoFilePath];
                if (infoDic.count != 0) {
                    [node setSerialNumber:[infoDic objectForKey:@"Serial Number"]];
                }
                NSString *infoFilePath1 = [filePath stringByAppendingPathComponent:@"Manifest.plist"];
                NSDictionary *infoDic1 = [NSDictionary dictionaryWithContentsOfFile:infoFilePath1];
                if (infoDic1.count != 0&&node.serialNumber == nil) {
                    NSDictionary *lockdownDic = [infoDic1 objectForKey:@"Lockdown"];
                    [node setSerialNumber:[lockdownDic objectForKey:@"SerialNumber"]];
                }
                if (infoDic1.count != 0) {
                    [node setIsEncrypt:[[infoDic1 objectForKey:@"IsEncrypted"] boolValue]];
                }
                
                node.backupDate = [DateHelper stringFromFomate:backupDate formate:@"yyyy-MM-dd HH:mm"];
                node.fileName = node.backupDate;
                node.backupPath = filePath;
                node.container = NO;
                node.isDeviceNode = NO;
                node.isBackupNode = YES;
                NSString *reg = @"iPad";
                NSString *reg1 = @"iPhone";
                NSString *reg2 = @"iPod";
                NSRange foundObj=[productType rangeOfString:reg options:NSCaseInsensitiveSearch];
                NSRange foundObj1=[productType rangeOfString:reg1 options:NSCaseInsensitiveSearch];
                NSRange foundObj2=[productType rangeOfString:reg2 options:NSCaseInsensitiveSearch];
                
                if (foundObj.length >0) {
                    
                    node.productType = iPadType;
                    
                }else if (foundObj1.length >0)
                {
                    node.productType = iPhoneType;
                    
                }else if (foundObj2.length >0)
                {
                    node.productType = iPodTouchType;
                }
                node.itemSize = [self getFolderSize:node.backupPath];
                node.productVersion = productVersion;
                node.childrenArray = [self supportedBackupItems:node];
                node.uniqueID = [NSString stringWithFormat:@"%@%@",node.udid,node.backupDate];
                node.isDeviceNode = YES;
                [backupNodeArr addObject:node];
                return node;
            }
        }
    }
    return nil;
}

- (int64_t)getFolderSize:(NSString *)backupFolderPath {
    int64_t folderSize = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:backupFolderPath]) {
        [self recursionFolder:backupFolderPath folderSize:&folderSize];
    }
    return folderSize;
}

- (void)recursionFolder:(NSString *)folderPath folderSize:(int64_t *)folderSize {
    NSArray *tempArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    for (NSString *fileName in tempArray) {
        BOOL flag = YES;
        NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                *folderSize += [self fileSizeAtPath:fullPath];
            }
            else {
                [self recursionFolder:fullPath folderSize:folderSize];
            }
        }
    }
}

- (long long)fileSizeAtPath:(NSString*)filePath {
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
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
    backupnode.productVersion = nnode.productVersion;
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
    notesnode.productVersion = nnode.productVersion;
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
    contactsnode.productVersion = nnode.productVersion;
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
    bookmarksnode.productVersion = nnode.productVersion;
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
    calendarnode.productVersion = nnode.productVersion;
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
        voicemailnode.productVersion = nnode.productVersion;
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
        messagenode.productVersion = nnode.productVersion;
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
        callHistorynode.productVersion = nnode.productVersion;
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
    safarinode.productVersion = nnode.productVersion;
    safarinode.container = NO;
    safarinode.type = @"SafariHistory";
    safarinode.uniqueID = [NSString stringWithFormat:@"%@%@%@",nnode.udid,nnode.backupDate,safarinode.fileName];
    [supportedArr addObject:safarinode];
    [safarinode release];
    
    return supportedArr;
}

- (NSMutableArray *)getRootArray:(NSString *)backupfilePath
{
    NSMutableArray *rootArray = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [_recordDic removeAllObjects];
    NSMutableArray *recordArray = nil;//[_recordDic objectForKey:backupfilePath];
    if (recordArray == nil) {
        [self parseManifest:backupfilePath];
        recordArray = [_recordDic objectForKey:backupfilePath];
    }
    //得到所有的域的记录
    NSMutableArray *domainArr = [NSMutableArray array];
    for (IMBMBFileRecord *fileRecord in recordArray) {
        
        if ([fileRecord.path isEqualToString:@""]) {
            [domainArr addObject:fileRecord];
            
        }
    }
    for (IMBMBFileRecord *domainRecord in domainArr) {
        
        //得到域下所有的记录
        NSMutableArray *arr = [NSMutableArray array];
        for (IMBMBFileRecord *record in recordArray) {
            if (![record.path isEqualToString:@""] && [record.domain isEqualToString:domainRecord.domain]) {
                
                [arr addObject:record];
            }
        }
        //通过正则表达式得到域下的第一级目录
        NSMutableArray *subArr = [NSMutableArray array];
        for (IMBMBFileRecord *filerecord in arr) {
            
            NSRange range = [filerecord.path rangeOfString:@"/"];
            if (range.length == 0) {
                NSString *name = nil;
                if ([filerecord.path isEqualToString:@""]) {
                    name = filerecord.domain;
                }else
                {
                    
                    name = [filerecord.path lastPathComponent];
                }
                [subArr addObject:filerecord];
            }
        }
        SimpleNode *node   = [self getchildrenNodeWithsubRecordArray:subArr allSubRecordArray:arr fileRecord:domainRecord backupFilePath:backupfilePath fileManager:fileManager];
        
        [rootArray addObject:node];
    }
    
    return rootArray;
}

- (SimpleNode *)getchildrenNodeWithsubRecordArray:(NSMutableArray *)recordArray allSubRecordArray:(NSMutableArray *)allSubRecordArray fileRecord:(IMBMBFileRecord *)fileRecord backupFilePath:(NSString *)backupfilePath fileManager:(NSFileManager *)fileManager
{
    
    NSString *name = nil;
    if ([fileRecord.path isEqualToString:@""]) {
        name = fileRecord.domain;
    }else
    {
        name = [fileRecord.path lastPathComponent];
    }
    SimpleNode *parentNode = [SimpleNode nodeDataWithName:name];
    parentNode.domain = fileRecord.domain;
    parentNode.key = fileRecord.key;
    parentNode.path = [fileRecord.domain stringByAppendingPathComponent:fileRecord.path];
    parentNode.container = YES;
   NSImage *appleImage = [[NSWorkspace sharedWorkspace] iconForFile:[TempHelper getAppSupportPath]];
    [appleImage setSize:NSMakeSize(64, 64)];
    parentNode.image = appleImage;
    for ( IMBMBFileRecord *record in  recordArray) {
        
        SimpleNode *childNode = nil;
        
        NSString *backupPath = [backupfilePath stringByAppendingPathComponent:record.key];
        if ([_iosVersion isVersionMajorEqual:@"10"]) {
            NSString *fd = @"";
            if (record.key.length > 2) {
                fd = [record.key substringWithRange:NSMakeRange(0, 2)];
            }
            backupPath = [[backupfilePath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:record.key];
        }
        //类型是文件
        if (!(record.filetype == DirectoryType_Backup)) {
            childNode = [SimpleNode nodeDataWithName:record.path];
            childNode.container = NO;
            childNode.key = record.key;
            childNode.path = [record.domain stringByAppendingPathComponent:record.path];
            childNode.fileName = [record.path lastPathComponent];
            childNode.backupPath = backupPath;
            childNode.domain = record.domain;
            NSString *extension = [childNode.path pathExtension];
            NSWorkspace *workSpace = [[NSWorkspace alloc] init];
            NSImage *icon = [workSpace iconForFileType:extension];
            [icon setSize:NSMakeSize(56, 52)];
            childNode.image = icon;
            [workSpace release];
            
        }else  //类型是文件夹
        {
            NSMutableArray *allArr = [NSMutableArray array];
            NSMutableArray *subArr = [NSMutableArray array];
            NSString *reg = [NSString stringWithFormat:@"%@\\/",record.path];
            NSString *reg1 = [NSString stringWithFormat:@"%@/(\\.|\\w)+.*\\w+",record.path];
            NSString *reg2 = [NSString stringWithFormat:@"%@/(\\.|\\w)+.*\\w+/",record.path];
            
            
            for (IMBMBFileRecord *filerecord in allSubRecordArray)
            {
                
                if ([filerecord.path isMatchedByRegex:reg]) {
                    //得到此目录下的所有文件和文件夹
                    [allArr addObject:filerecord];
                }
                
                if ([filerecord.path isMatchedByRegex:reg1] && ![filerecord.path isMatchedByRegex:reg2]) {
                    //得到此目录下的第一级文件和文件夹
                    [subArr addObject:filerecord];
                }
            }
            
            //使用递归实现
            childNode = [self getchildrenNodeWithsubRecordArray:subArr allSubRecordArray:allArr fileRecord:record backupFilePath:backupfilePath fileManager:fileManager];
            //            NSImage *image = [StringHelper imageNamed:@"folder_new"];
            //            [image setSize:NSMakeSize(66, 52)];
            NSImage *appleImage = [[NSWorkspace sharedWorkspace] iconForFile:[TempHelper getAppSupportPath]];
            [appleImage setSize:NSMakeSize(64, 64)];
            childNode.domain = record.domain;
            childNode.image = appleImage;
            childNode.container = YES;
        }
        
        [[parentNode childrenArray] addObject:childNode];
    }
    
    return parentNode;
}

- (NSString *)copyImageToApptempWithsqliteName:(NSString *)sqliteName backupfilePath:(NSString *)backupfilePath withBackupstr:(NSString *)backupPath{
    NSMutableArray *recordArray = [_recordDic objectForKey:backupfilePath];
    NSString *desfilePath = nil;
    if (recordArray == nil) {
        [self parseManifest:backupPath];
        recordArray = [_recordDic objectForKey:backupfilePath];
    }
    if (_backFileArray != nil && [_backFileArray count] > 0) {
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            IMBMBFileRecord *item = (IMBMBFileRecord *)evaluatedObject;
            if ([[item domain] isEqualToString:sqliteName] && [[item path] rangeOfString:backupfilePath].length > 0 && ![item.path isEqualToString:@"Media/PhotoData/Photos.sqlite.aside"]) {
                return YES;
            } else {
                return NO;
            }
        }];
        IMBMBFileRecord *  SMSDBFileItem = nil;
        NSArray *preArray = [_backFileArray filteredArrayUsingPredicate:pre];
        if (preArray != nil && [preArray count] > 0) {
            SMSDBFileItem = [preArray objectAtIndex:0];
        }
        
        if ([_iosVersion isVersionMajorEqual:@"10"]) {
            NSString *fd = @"";
            if (SMSDBFileItem.key.length > 2) {
                fd = [SMSDBFileItem.key substringWithRange:NSMakeRange(0, 2)];
            }
            desfilePath = [[_backUpPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:SMSDBFileItem.key];
            //                                    currentPath = [_manifestManager.deviceBackupFolderPath stringByAppendingPathComponent:fr.key];
        }else{
            desfilePath = [_backUpPath stringByAppendingPathComponent:SMSDBFileItem.key];
        }
        
        
        NSFileManager *filemanager = [NSFileManager defaultManager];
        NSString *appPath = nil;
//        if ([filemanager fileExistsAtPath:desfilePath]) {
        
            appPath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:SMSDBFileItem.key];
            //假如该文件已经存在,则先删除
            if ([filemanager fileExistsAtPath:appPath]) {
                [filemanager removeItemAtPath:appPath error:nil];
            }
            
            BOOL success = [filemanager copyItemAtPath:desfilePath toPath:appPath  error:nil];
            if (!success){
                NSLog(@"数据库文件拷贝失败");
                return nil;
            }
            
//        }else
//        {
//            NSLog(@"该备份数据库文件已被删除");
//            return nil;
//        }

    }
    return desfilePath;
}

- (NSString *)copysqliteToApptempWithsqliteName:(NSString *)sqliteName backupfilePath:(NSString *)backupfilePath
{
    
    NSMutableArray *recordArray = [_recordDic objectForKey:backupfilePath];
    
    if (recordArray == nil) {
        
        [self parseManifest:backupfilePath];
        recordArray = [_recordDic objectForKey:backupfilePath];
        
    }
    NSString *desfilePath = nil;
    
    if (recordArray.count > 0) {
        
        NSFileManager *filemanager = [NSFileManager defaultManager];
        
        for (IMBMBFileRecord *record in recordArray) {
            NSString *filename = [record.path lastPathComponent];
            if ([filename isEqualToString:sqliteName]) {
                NSString *sourcefilePath = nil;
                if ([_iosVersion isVersionMajorEqual:@"10"]) {
                    NSString *fd = @"";
                    if (record.key.length > 2) {
                        fd = [record.key substringWithRange:NSMakeRange(0, 2)];
                    }
                    sourcefilePath = [[backupfilePath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:record.key];
                }else {
                    sourcefilePath = [backupfilePath stringByAppendingPathComponent:record.key];
                }
                if ([filemanager fileExistsAtPath:sourcefilePath]) {
                    
                    desfilePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:record.key];
                    //假如该文件已经存在,则先删除
                    if ([filemanager fileExistsAtPath:desfilePath]) {
                        [filemanager removeItemAtPath:desfilePath error:nil];
                    }
                    
                    BOOL success = [filemanager copyItemAtPath:sourcefilePath toPath:desfilePath error:nil];
                    if (!success) {
                        
                        NSLog(@"数据库文件拷贝失败");
                        return nil;
                    }
                    //找到即跳出循环
                    break;
                    
                }else
                {
                    NSLog(@"该备份数据库文件已被删除");
                    return nil;
                }
            }
        }
    }
    return desfilePath;
}


- (NSString *)copysqliteImageToApptempWithsqliteName:(NSString *)sqliteName backupfilePath:(NSString *)backupfilePath
{
    NSMutableArray *recordArray = [_recordDic objectForKey:backupfilePath];
    if (recordArray == nil) {
        [self parseManifest:backupfilePath];
        recordArray = [_recordDic objectForKey:backupfilePath];
    }
    NSString *desfilePath = nil;
    if (_backFileArray.count > 0) {
        
        NSFileManager *filemanager = [NSFileManager defaultManager];
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            IMBMBFileRecord *item = (IMBMBFileRecord *)evaluatedObject;
            if ([[item domain] isEqualToString:@"CameraRollDomain"] && [[item path] rangeOfString:@"Media/PhotoData/Photos.sqlite"].length > 0 && ![item.path isEqualToString:@"Media/PhotoData/Photos.sqlite.aside"]) {
                return YES;
            } else {
                return NO;
            }
        }];
        NSArray *preArray = [_backFileArray filteredArrayUsingPredicate:pre];
        if (preArray != nil && [preArray count] > 0) {
            IMBMBFileRecord *record  = [preArray objectAtIndex:0];
                NSString *sourcefilePath = nil;
                if ([_iosVersion isVersionMajorEqual:@"10"]) {
                    NSString *fd = @"";
                    if (record.key.length > 2) {
                        fd = [record.key substringWithRange:NSMakeRange(0, 2)];
                    }
                    sourcefilePath = [[_backUpPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:record.key];
                }else {
                    sourcefilePath = [_backUpPath stringByAppendingPathComponent:record.key];
                }
            if ([filemanager fileExistsAtPath:sourcefilePath]) {

                    desfilePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:record.key];
                    //假如该文件已经存在,则先删除
                    if ([filemanager fileExistsAtPath:desfilePath]) {
                        [filemanager removeItemAtPath:desfilePath error:nil];
                    }

                    BOOL success = [filemanager copyItemAtPath:sourcefilePath toPath:desfilePath error:nil];
                    if (!success) {

                        NSLog(@"数据库文件拷贝失败");
                        return nil;
                    }
//                    //找到即跳出循环
//                    break;
                
                }else
                {
                    NSLog(@"该备份数据库文件已被删除");
                    return nil;
                }

        }
//        for (IMBMBFileRecord *record in recordArray) {
//            
//            NSString *filename = [record.path lastPathComponent];
//            
//            if ([filename isEqualToString:sqliteName]) {
//

//             //            }
//        }
    }
    return desfilePath;
}


- (void)matchAttachmentArray:(NSMutableArray *)attachmentArray withReslutAry:(NSMutableArray *)ary  {

    mdInfoDic = [self getManifestDB];
    
    NSMutableArray *notesDomainArray = [self getNotesDomainContent];
    [self matchAndReadFileContentToNotes:notesDomainArray attachmentArray:attachmentArray withAttachData:ary];
}

- (void)matchAttachmentManifestDBattachmentList:(NSMutableArray *)attachmentList withAttachData:(NSMutableArray *)attachData {
    mdInfoDic = [self getManifestDB];
    NSMutableArray *mediaDomainArray = [self getMediaDomainContent];
    [self matchAndReadFileContent:mediaDomainArray attachmentArray:attachmentList withAttachData:attachData];
}

// 匹配并读取Manifest文件的记录内容
- (void)matchAndReadFileContent:(NSMutableArray *)mediaDomainArray attachmentArray:(NSMutableArray *)attachmentArray withAttachData:(NSMutableArray *)attachData {
    if (mediaDomainArray == nil || (attachmentArray == nil && [attachmentArray count] == 0)) {
        return;
    }
    
    NSArray *existFileArray = nil;
    NSPredicate *pre = nil;
    existFileArray = mediaDomainArray;
    if (existFileArray != nil && [existFileArray count] > 0) {
        for (IMBSMSAttachmentEntity *item in attachmentArray) {
            @autoreleasepool {
                NSArray *manifestDataArray = nil;
                NSString *attGUID = [item attGUID];
                if ([StringHelper stringIsNilOrEmpty:attGUID]) {
                    continue;
                }
                pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    IMBManifestDataModel *mdmitem = (IMBManifestDataModel*)evaluatedObject;
                    if ([[mdmitem filePath] rangeOfString:attGUID].length > 0) {
                        return YES;
                    }else {
                        return NO;
                    }
                }];
                
                manifestDataArray = [existFileArray filteredArrayUsingPredicate:pre];
                if (manifestDataArray != nil && [manifestDataArray count] > 0) {
                    NSMutableArray *attachDetailArray = [[NSMutableArray alloc] init];
                    for (IMBManifestDataModel *mfItem in manifestDataArray) {
                        @autoreleasepool {
                            if (!mfItem.isFileExist) {
                                continue;
                            }
                            IMBAttachDetailEntity *attachDetailItem = [[IMBAttachDetailEntity alloc] init];
                            [attachDetailItem setCheckState:Check];
                            [attachDetailItem setRowID:item.rowID];
                            [attachDetailItem setFileName:[[mfItem filePath] lastPathComponent]];
                            [attachDetailItem setFileSize:[mfItem fileSize]];
                            [attachDetailItem setMimeType:item.mimeType];
                            [attachDetailItem setBackUpFilePath:[mfItem fileBackUpPath]];
                            [attachDetailItem setBackFileName:[mfItem fileKey]];
                            [attachDetailItem setMbFileRecord:[mfItem mbFileRecord]];
                            NSString *filePath = [mfItem filePath];
                            if (![StringHelper stringIsNilOrEmpty:filePath] && [filePath rangeOfString:@"preview"].length > 0) {
                                [attachDetailItem setIsPerviewImage:YES];
                            } else {
                                [attachDetailItem setIsPerviewImage:NO];
                            }
                            [attachDetailArray addObject:attachDetailItem];
                            [attachData addObject:attachDetailItem];
                            [attachDetailItem release];
                            attachDetailItem = nil;
                        }
                    }
                    [item setAttachDetailList:attachDetailArray];
                    [attachDetailArray release];
                    attachDetailArray = nil;
                }
            }
        }
    }
}

- (NSMutableArray *)getMediaDomainContent {
    NSMutableArray *mediaDomainList = nil;
    if (mdInfoDic != nil && [[mdInfoDic allKeys] count] > 0) {
        if ([[mdInfoDic allKeys] containsObject:@"MediaDomain"]) {
            mediaDomainList = [mdInfoDic objectForKey:@"MediaDomain"];
        }
    }
    return mediaDomainList;
}

- (NSMutableDictionary *)getManifestDB {
    @synchronized(mdDictionary) {
        if (![_tembackupPath isEqualToString:_backUpPath]) {
            if (mdDictionary != nil && mdDictionary.allKeys.count > 0) {
                [mdDictionary removeAllObjects];
            } else {
                if (mdDictionary == nil) {
                    mdDictionary = [[NSMutableDictionary alloc] init];
                }
            }
            [_tembackupPath release];
            _tembackupPath = nil;
            _tembackupPath = [_backUpPath retain];
        }
        if ([mdDictionary.allKeys count] == 0) {
            if (_backFileArray != nil && [_backFileArray count] > 0) {
                IMBManifestDataModel *mdModel = nil;
                for (IMBMBFileRecord *frItem in _backFileArray) {
                    @autoreleasepool {
                        mdModel = [[IMBManifestDataModel alloc] init];
                        [mdModel setFileKey:[frItem key]];
                        [mdModel setFilePath:[frItem path]];
                        [mdModel setFileDomain:[frItem domain]];
                        [mdModel setMbFileRecord:frItem];
                        [self getBackUpFileInfo:_backUpPath item:frItem manifestDataItem:mdModel];
                        if (![[mdDictionary allKeys] containsObject:[frItem domain]]) {
                            NSMutableArray *manifestArray = [[NSMutableArray alloc] init];
                            [manifestArray addObject:mdModel];
                            NSString *str = [frItem domain];
                            if (str != nil) {
                                [mdDictionary setObject:manifestArray forKey:[frItem domain]];
                            }
                            [manifestArray release];
                            manifestArray = nil;
                        } else {
                            NSMutableArray *manifestArray = [mdDictionary objectForKey:[frItem domain]];
                            [manifestArray addObject:mdModel];
                        }
                        [mdModel release];
                        mdModel = nil;
                    }
                }
            }

        }
    }
    return mdDictionary;
}
- (void)getBackUpFileInfo:(NSString *)deviceBackupFolder item:(IMBMBFileRecord *)item manifestDataItem:(IMBManifestDataModel *)manifestDataItem {
    NSString *filePath = [deviceBackupFolder stringByAppendingPathComponent:[item key]];
    if ([_iosVersion isVersionMajorEqual:@"10"]) {
        NSString *fd = @"";
        if (item.key.length > 2) {
            fd = [item.key substringWithRange:NSMakeRange(0, 2)];
        }
        filePath = [[deviceBackupFolder stringByAppendingPathComponent:fd] stringByAppendingPathComponent:item.key];
    }
    if ([fm fileExistsAtPath:filePath]) {
        [manifestDataItem setFileBackUpPath:filePath];
        NSString *fileName = [[item path] lastPathComponent];
        if (fileName == nil) {
            fileName = @"";
        }
        [manifestDataItem setFileName:fileName];
        [manifestDataItem setFileSize:[IMBUtilTool fileSizeAtPath:filePath]];
        [manifestDataItem setIsFileExist:YES];
    } else {
        [manifestDataItem setFileSize:item.fileLength];
        [manifestDataItem setIsFileExist:NO];
    }
}

//获取note 附件文件记录
- (NSMutableArray *)getNotesDomainContent {
    NSMutableArray *mediaDomainList = nil;
    if (mdInfoDic != nil && [[mdInfoDic allKeys] count] > 0) {
        if ([[mdInfoDic allKeys] containsObject:@"AppDomainGroup-group.com.apple.notes"]) {
            mediaDomainList = [mdInfoDic objectForKey:@"AppDomainGroup-group.com.apple.notes"];
        }
    }
    return mediaDomainList;
}

// 匹配并读取Manifest文件的记录内容
- (void)matchAndReadFileContentToNotes:(NSMutableArray *)notesDomainArray attachmentArray:(NSMutableArray *)attachmentArray withAttachData:(NSMutableArray *)attachData {
    if (notesDomainArray == nil || (attachmentArray == nil && [attachmentArray count] == 0)) {
        return;
    }
    
    NSArray *existFileArray = nil;
    NSPredicate *pre = nil;
    existFileArray = notesDomainArray;
    if (existFileArray != nil && [existFileArray count] > 0) {
        for (IMBNoteAttachmentEntity *item in attachmentArray) {
            if (item.allAttachId.count > 0) {
                @autoreleasepool {
                    for (NSString *attGUID in item.allAttachId) {
                        NSArray *manifestDataArray = nil;
                        if ([StringHelper stringIsNilOrEmpty:attGUID]) {
                            continue;
                        }
                        pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                            IMBManifestDataModel *mdmitem = (IMBManifestDataModel*)evaluatedObject;
                            if ([[mdmitem filePath] rangeOfString:attGUID].length > 0) {
                                return YES;
                            }else {
                                return NO;
                            }
                        }];
                        
                        manifestDataArray = [existFileArray filteredArrayUsingPredicate:pre];
                        if (manifestDataArray != nil && [manifestDataArray count] > 0) {
                            //                            NSMutableArray *attachDetailArray = [[NSMutableArray alloc] init];
                            for (IMBManifestDataModel *mfItem in manifestDataArray) {
                                if (!mfItem.isFileExist) {
                                    continue;
                                }
                                IMBAttachDetailEntity *attachDetailItem = [[IMBAttachDetailEntity alloc] init];
                                //                                [attachDetailItem setCheckState:UnChecked];
                                [attachDetailItem setRowID:item.attachmentId];
                                [attachDetailItem setFileName:[[mfItem filePath] lastPathComponent]];
                                [attachDetailItem setFileSize:[mfItem fileSize]];
                                [attachDetailItem setBackUpFilePath:[mfItem fileBackUpPath]];
                                [attachDetailItem setBackFileName:[mfItem fileKey]];
                                [attachDetailItem setMbFileRecord:[mfItem mbFileRecord]];
                                NSString *filePath = [mfItem filePath];
                                if (![StringHelper stringIsNilOrEmpty:filePath] && [filePath rangeOfString:@"preview"].length > 0) {
                                    [attachDetailItem setIsPerviewImage:YES];
                                } else {
                                    [attachDetailItem setIsPerviewImage:NO];
                                }
                                //                                [attachDetailArray addObject:attachDetailItem];
                                [item.attachDetailList addObject:attachDetailItem];
                                
        
                                [attachData addObject:attachDetailItem];
                                
                                
                                [attachDetailItem release];
                                attachDetailItem = nil;
                            }
                            //                            [item setAttachDetailList:attachDetailArray];
                            //                            [attachDetailArray release];
                            //                            attachDetailArray = nil;
                        }
                    }
                    
                }
            }
        }
    }
}

// 得到备份文件中的文件记录
- (IMBMBFileRecord *)getDBFileRecord:(NSString *)domainName path:(NSString *)path {
    IMBMBFileRecord *SMSDBFileItem = nil;
    if (path == nil) {
        path = @"";
    }
    if (_backFileArray == nil) {
        IMBMBDBParse * mbdbParse = [[IMBMBDBParse alloc]init];
        [mbdbParse readMBDB:_backUpPath];
        _backFileArray = [[mbdbParse recordArray] retain];
        [mbdbParse release];
    }
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        IMBMBFileRecord *item = (IMBMBFileRecord *)evaluatedObject;
        if ([[item domain] isEqualToString:domainName] && [[item path] rangeOfString:path].length > 0 && ![item.path isEqualToString:@"Media/PhotoData/Photos.sqlite.aside"]) {
            return YES;
        } else {
            return NO;
        }
    }];
    
    NSArray *preArray = [_backFileArray filteredArrayUsingPredicate:pre];
    if (preArray != nil && [preArray count] > 0) {
        SMSDBFileItem = [preArray objectAtIndex:0];
    }
    return SMSDBFileItem;
}

@end

@implementation IMBManifestDataModel
@synthesize fileKey = _fileKey;
@synthesize fileName = _fileName;
@synthesize filePath = _filePath;
@synthesize fileBackUpPath = _fileBackUpPath;
@synthesize isFileExist = _isFileExist;
@synthesize fileSize = _fileSize;
@synthesize fileDomain = _fileDomain;
@synthesize mbFileRecord = _mbFileRecord;

- (id)init {
    self = [super init];
    if (self) {
        _fileKey = @"";
        _fileName = @"";
        _filePath = @"";
        _fileBackUpPath = @"";
        _isFileExist = NO;
        _fileSize = 0;
        _fileDomain = @"";
        _mbFileRecord = nil;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
