//
//  IMBAndroid.m
//  
//
//  Created by ding ming on 17/3/28.
//
//

#import "IMBAndroid.h"
#import "RegexKitLite.h"
#import "IMBExportConfig.h"
@implementation IMBAndroid
@synthesize adAudio = _adAudio;
@synthesize adVideo = _adVideo;
@synthesize adDevice = _adDevice;
@synthesize adGallery = _adGallery;
@synthesize adCallHistory = _adCallHistory;
@synthesize deviceInfo = _deviceInfo;
@synthesize adCalendar = _adCalendar;
@synthesize adDoucment = _adDoucment;
@synthesize adSMS = _adSMS;
@synthesize adContact = _adContact;
@synthesize adPermisson = _adPermisson;
@synthesize rootHandle = _rootHandle;
@synthesize currentRealStop = _currentRealStop;
@synthesize exportSetting = _exportSetting;
@synthesize adRingtone = _adRingtone;
@synthesize category = _category;

- (id)initWithDeviceInfo:(DeviceInfo *)deviceInfo {
    if (self = [super init]) {
        _category = Category_Summary;
        _logManager = [IMBLogManager singleton];
        _deviceInfo = [deviceInfo retain];
        _condition = [[NSCondition alloc] init];
        _adAudio = [[IMBADAudio alloc] initWithSerialNumber:_deviceInfo.devSerialNumber];
        _adAudio.condition = _condition;
        _adVideo = [[IMBADVideo alloc] initWithSerialNumber:_deviceInfo.devSerialNumber];
        _adVideo.condition = _condition;
        _adGallery = [[IMBADGallery alloc] initWithSerialNumber:_deviceInfo.devSerialNumber];
        _adGallery.condition = _condition;
        _adCallHistory = [[IMBADCallHistory alloc] initWithSerialNumber:_deviceInfo.devSerialNumber];
        _adCallHistory.condition = _condition;
        _adDevice = [[IMBADDevice alloc] initWithSerialNumber:_deviceInfo.devSerialNumber WithDeviceInfo:_deviceInfo];
        _adCalendar = [[IMBADCalendar alloc] initWithSerialNumber:_deviceInfo.devSerialNumber];
        _adCalendar.condition = _condition;
        _adContact = [[IMBADContact alloc] initWithSerialNumber:_deviceInfo.devSerialNumber];
        _adContact.condition = _condition;
        _adDoucment = [[IMBADDoucment alloc] initWithSerialNumber:_deviceInfo.devSerialNumber];
        _adDoucment.condition = _condition;
        _adRingtone = [[IMBADRingtone alloc] initWithSerialNumber:_deviceInfo.devSerialNumber];
        _adRingtone.condition = _condition;
        _adSMS = [[IMBADMessage alloc] initWithSerialNumber:_deviceInfo.devSerialNumber];
        _adSMS.condition = _condition;
        _adPermisson = [[IMBADPermisson alloc] initWithSerialNumber:_deviceInfo.devSerialNumber];
        _exportSetting = [IMBExportConfig singleton];
    }
    return self;
}

- (void)dealloc {
    if (_rootHandle != nil) {
        [_rootHandle release];
        _rootHandle = nil;
    }
    if (_deviceInfo != nil) {
        [_deviceInfo release];
        _deviceInfo = nil;
    }
    if (_adDevice != nil) {
        [_adDevice release];
        _adDevice = nil;
    }
    if (_adAudio != nil) {
        [_adAudio release];
        _adAudio = nil;
    }
    if (_adGallery != nil) {
        [_adGallery release];
        _adGallery = nil;
    }
    if (_adCallHistory != nil) {
        [_adCallHistory release];
        _adCallHistory = nil;
    }
    if (_adCalendar != nil) {
        [_adCalendar release];
        _adCalendar = nil;
    }
    if (_adContact != nil) {
        [_adContact release];
        _adContact = nil;
    }
    if (_adDoucment != nil) {
        [_adDoucment release];
        _adDoucment = nil;
    }
    if (_adSMS != nil) {
        [_adSMS release];
        _adSMS = nil;
    }
    if (_adPermisson != nil) {
        [_adPermisson release];
        _adPermisson = nil;
    }
    if (_currentRealStop) {
        [_currentRealStop release];
        _currentRealStop = nil;
    }
    if (_adRingtone != nil) {
        [_adRingtone release];
        _adRingtone = nil;
    }
    [_condition release],_condition = nil;
    [super dealloc];
}

#pragma mark - 查询方法
- (int)queryDeviceDetailInfo {
    return [_adDevice queryDetailContent];
}

- (int)queryAudioDetailInfo {
    [_adAudio.reslutEntity reInit];
    int ret = [_adAudio queryDetailContent];
    if (_adDoucment.musicReslutEntity.reslutCount > 0) {
        for (IMBADAudioTrack *track in _adDoucment.musicReslutEntity.reslutArray) {
            BOOL isAdd = YES;
            for (IMBADAudioTrack *audioTrack in _adAudio.reslutEntity.reslutArray) {
                if ([track.url isEqualToString:audioTrack.url]) {
                    isAdd = NO;
                    break;
                }
            }
            if (isAdd) {
                _adAudio.reslutEntity.reslutCount ++;
                _adAudio.reslutEntity.selectedCount ++;
                _adAudio.reslutEntity.reslutSize += track.size;
                [_adAudio.reslutEntity.reslutArray addObject:track];
            }
        }
    }
    return ret;
}

- (int)queryVideoDetailInfo {
    [_adVideo.reslutEntity reInit];
    int ret = [_adVideo queryDetailContent];
    if (_adDoucment.moviesReslutEntity.reslutCount > 0) {
        for (IMBADVideoTrack *track in _adDoucment.moviesReslutEntity.reslutArray) {
            BOOL isAdd = YES;
            for (IMBADVideoTrack *videoTrack in _adVideo.reslutEntity.reslutArray) {
                if ([track.url isEqualToString:videoTrack.url]) {
                    isAdd = NO;
                    break;
                }
            }
            if (isAdd) {
                _adVideo.reslutEntity.reslutCount ++;
                _adVideo.reslutEntity.selectedCount ++;
                _adVideo.reslutEntity.reslutSize += track.size;
                [_adVideo.reslutEntity.reslutArray addObject:track];
            }
        }
    }
    return ret;
}

- (int)queryGalleryDetailInfo {
    [_adGallery.reslutEntity reInit];
    int ret = [_adGallery queryDetailContent];
    if (_adDoucment.photoReslutEntity.reslutCount > 0) {
        for (IMBADPhotoEntity *entity in _adDoucment.photoReslutEntity.reslutArray) {
            BOOL isAdd = YES;
            for (IMBADAlbumEntity *albumEntity in _adGallery.reslutEntity.reslutArray) {
                for (IMBADPhotoEntity *photoEntity in albumEntity.photoArray) {
                    if ([entity.url isEqualToString:photoEntity.url]) {
                        isAdd = NO;
                        break;
                    }
                }
                if (!isAdd) {
                    break;
                }
            }
            if (isAdd) {
                NSString *albumName = CustomLocalizedString(@"photoView_id_6", nil);
                NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    IMBADAlbumEntity *item = (IMBADAlbumEntity *)evaluatedObject;
                    if ([[item albumName] isEqualToString:albumName]) {
                        return YES;
                    }else {
                        return NO;
                    }
                }];
                NSArray *preArray = [_adGallery.reslutEntity.reslutArray filteredArrayUsingPredicate:pre];
                IMBADAlbumEntity *albumEntity = nil;
                BOOL isExist = NO;
                if (preArray != nil && preArray.count > 0) {
                    isExist = YES;
                    albumEntity = [preArray objectAtIndex:0];
                }else {
                    isExist = NO;
                    albumEntity = [[IMBADAlbumEntity alloc] init];
                    [albumEntity setAlbumName:albumName];
                    [albumEntity setIsAppAlbum:YES];
                }
                _adGallery.reslutEntity.reslutCount ++;
                _adGallery.reslutEntity.selectedCount ++;
                _adGallery.reslutEntity.reslutSize += entity.size;
                [albumEntity.photoArray addObject:entity];
                if (!isExist) {
                    [_adGallery.reslutEntity.reslutArray addObject:albumEntity];
                    [albumEntity release];
                    albumEntity = nil;
                }
            }
        }
    }
    return ret;
}

- (BOOL)loadThumbnaiImage:(IMBADPhotoEntity *)photoEntity {
    return [_adGallery queryThumbnailContent:photoEntity];
}

- (BOOL)loadThumbnaiImageWithApp:(IMBADPhotoEntity *)appPhotoEntity {
    return [_adDoucment queryThumbnailContentWithApp:appPhotoEntity];
}

- (int)queryCallHistoryDetailInfo {
    [_adCallHistory.reslutEntity reInit];
    return [_adCallHistory queryDetailContent];
}

- (int)queryCalendarDetailInfo {
    [_adCalendar.reslutEntity reInit];
    return [_adCalendar queryDetailContent];
}

- (int)queryContactDetailInfo {
    [_adContact.reslutEntity reInit];
    return [_adContact queryDetailContent];
}

- (int)queryDoucmentDetailInfo {
    if (_category == Category_Music) {
        [_adDoucment.musicReslutEntity reInit];
    }else if (_category == Category_Movies) {
        [_adDoucment.moviesReslutEntity reInit];
    }else if (_category == Category_iBooks) {
        [_adDoucment.ibookReslutEntity reInit];
    }else if (_category == Category_Compressed) {
        [_adDoucment.compressedReslutEntity reInit];
    }else if (_category == Category_Document) {
        [_adDoucment.reslutEntity reInit];
    }else if (_category == Category_Photo) {
        [_adDoucment.photoReslutEntity reInit];
    }else if (_category == Category_Summary) {
        [_adDoucment.musicReslutEntity reInit];
        [_adDoucment.moviesReslutEntity reInit];
        [_adDoucment.ibookReslutEntity reInit];
        [_adDoucment.compressedReslutEntity reInit];
        [_adDoucment.reslutEntity reInit];
        [_adDoucment.photoReslutEntity reInit];
    }
    [_adDoucment init];
    [_adDoucment setCategory:_category];
    return [_adDoucment queryDetailContent];
}

- (int)querySMSDetailInfo {
    [_adSMS.reslutEntity reInit];
    [_adSMS.attachReslutEntity reInit];
    return [_adSMS queryDetailContent];
}

- (int)queryRingtoneDetailInfo {
    [_adRingtone.reslutEntity reInit];
    return [_adRingtone queryDetailContent];
}

- (IMBResultEntity *)getAudioContent {
    return _adAudio.reslutEntity;
}

- (IMBResultEntity *)getVideoContent {
    return _adVideo.reslutEntity;
}

- (IMBResultEntity *)getGalleryContent {
    return _adGallery.reslutEntity;
}

- (IMBResultEntity *)getCallHistoryContent {
    return _adCallHistory.reslutEntity;
}

- (IMBResultEntity *)getCalendarContent {
    return _adCalendar.reslutEntity;
}

- (IMBResultEntity *)getContactContent {
    return _adContact.reslutEntity;
}

- (IMBResultEntity *)getAppDoucmentContent {
    return _adDoucment.reslutEntity;
}

- (IMBResultEntity *)getiBooksContent {
    return _adDoucment.ibookReslutEntity;
}

- (IMBResultEntity *)getCompressedContent {
    return _adDoucment.compressedReslutEntity;
}

- (IMBResultEntity *)getAppPhotoContent {
    return nil;//_adDoucment.appPhotoEntity;
}

- (IMBResultEntity *)getAppVideoContent {
    return nil;//_adDoucment.appVideoEntity;
}

- (IMBResultEntity *)getAppAudioContent {
    return nil;//_adDoucment.appAudioEntity;
}

- (IMBResultEntity *)getSMSContent {
    return _adSMS.reslutEntity;
}

- (IMBResultEntity *)getSMSAttachmentContent {
    return _adSMS.attachReslutEntity;
}

- (IMBResultEntity *)getRingtoneContent {
    return _adRingtone.reslutEntity;
}

#pragma mark - 导出方法
- (int)exportAudioContent:(NSString *)path ContentList:(NSArray *)exportArray {
    return [_adAudio exportContent:path ContentList:exportArray];
}

- (int)exportVideoContent:(NSString *)path ContentList:(NSArray *)exportArray {
    return [_adVideo exportContent:path ContentList:exportArray];
}

- (int)exportGalleryContent:(NSString *)path ContentList:(NSArray *)exportArray {
    return [_adGallery exportContent:path ContentList:exportArray];
}

- (int)exportCallHistoryContent:(NSString *)path ContentList:(NSArray *)exportArray {
    return [_adCallHistory exportContent:path ContentList:exportArray exportType:[_exportSetting getExportExtension:EXPORT_CALLHISTORY_CATEGORY]];
}

- (int)exportCalendarContent:(NSString *)path ContentList:(NSArray *)exportArray {
    return [_adCalendar exportContent:path ContentList:exportArray exportType:[_exportSetting getExportExtension:EXPORT_CALENDAR_CATEGORY]];
}

- (int)exportContactContent:(NSString *)path ContentList:(NSArray *)exportArray {
    return [_adContact exportContent:path ContentList:exportArray exportType:[_exportSetting getExportExtension:EXPORT_CONTACT_CATEGORY]];
}

- (int)exportDoucmentContent:(NSString *)path ContentList:(NSArray *)exportArray {
    return [_adDoucment exportContent:path ContentList:exportArray];
}

- (int)exportSMSContent:(NSString *)path ContentList:(NSArray *)exportArray {
    return [_adSMS exportContent:path ContentList:exportArray exportType:[_exportSetting getExportExtension:EXPORT_MESSAGE_CATEGORY]];
}

- (int)exportMMSAttachment:(NSString *)targetPath exportArray:(NSArray *)exportArray {
    return [_adSMS exportMessageAttachment:targetPath exportArray:exportArray];
}

- (int)exportRingtoneContent:(NSString *)path ContentList:(NSArray *)exportArray {
    return [_adRingtone exportContent:path ContentList:exportArray];
}

#pragma marl - 导入方法
- (int)importAudioContent:(NSArray *)contentArray {
    return [_adAudio importContent:contentArray];
}

- (int)importVideoContent:(NSArray *)contentArray {
    return [_adVideo importContent:contentArray];
}

- (int)importGalleryContent:(NSArray *)contentArray {
    return [_adGallery importContent:contentArray];
}

- (int)importCallHistoryContent:(NSArray *)contentArray {
    return [_adCallHistory importContent:contentArray];
}

- (int)importCalendarContent:(NSArray *)contentArray {
    return [_adCalendar importContent:contentArray];
}

- (int)importContactContent:(NSArray *)contentArray {
    return [_adContact importContent:contentArray];
}

- (int)importDoucmentContent:(NSArray *)contentArray {
    return [_adDoucment importContent:contentArray];
}

- (int)importSMSContent:(NSArray *)contentArray {
    return [_adSMS importContent:contentArray];
}

#pragma mark - 删除方法
- (int)deleteAudioContent:(NSArray *)contentArray {
    return [_adAudio deleteContent:contentArray];
}

- (int)deleteVideoContent:(NSArray *)contentArray {
    return [_adVideo deleteContent:contentArray];
}

- (int)deleteGalleryContent:(NSArray *)contentArray {
    return [_adGallery deleteContent:contentArray];
}

- (int)deleteCallHistoryContent:(NSArray *)contentArray {
    return [_adCallHistory deleteContent:contentArray];
}

- (int)deleteCalendarContent:(NSArray *)contentArray {
    return [_adCalendar deleteContent:contentArray];
}

- (int)deleteContactContent:(NSArray *)contentArray {
    return [_adContact deleteContent:contentArray];
}

- (int)deleteDoucmentContent:(NSArray *)contentArray {
    return [_adDoucment deleteContent:contentArray];
}

- (int)deleteSMSContent:(NSArray *)contentArray {
    return [_adSMS deleteContent:contentArray];
}

#pragma mark - 授予设备权限
- (BOOL)checkDevicePermisson {
    int i = 2;
    BOOL isGreanted = NO;
    while (i--) {
        isGreanted = [_adPermisson checkDevicePermisson];
        if (isGreanted) {
            break;
        }
        usleep(100);
    }
    return isGreanted;
}

- (void)sendAction:(NSString *)switchView ResultText:(int)resultCount TargetWord:(NSString *)target {
    [_adPermisson sendAction:switchView ResultText:resultCount TargetWord:target];
}

#pragma mark - 检查是否设备root
- (BOOL)checkDeviceIsRoot {
    BOOL isRoot = NO;
    _deviceInfo.isRoot = [_adPermisson checkDeviceIsRoot];
    if (_deviceInfo.isRoot) {
        if ([IMBHelper stringIsNilOrEmpty:_rootHandle]) {
            [_rootHandle release];
            self.rootHandle = @"su";
        }
        isRoot = YES;
    }else {
        IMBAdbManager *adbManager = [IMBAdbManager singleton];
        NSMutableString *pathDir = [NSMutableString string];
        if (![IMBHelper stringIsNilOrEmpty:_deviceInfo.pathDir]) {
            NSArray *array = [_deviceInfo.pathDir componentsSeparatedByString:@":"];
            if (array != nil) {
                for (NSString *path in array) {
                    [pathDir appendString:[NSString stringWithFormat:@"ls %@ -l;",path]];
                }
            }
        }
        if ([IMBHelper stringIsNilOrEmpty:pathDir]) {
            pathDir = (NSMutableString *)[NSString stringWithFormat:@"ls /system/bin/ -l; ls /system/xbin/ -l; ls /system/sbin/ -l; ls /sbin/ -l; ls /vendor/bin/ -l;"];
        }
        NSString *rootStr = [adbManager runADBCommand:[adbManager checkRootState:_deviceInfo.devSerialNumber withPathDir:pathDir]];
        if (rootStr != nil) {
            if ([rootStr rangeOfString:@"su8"].location != NSNotFound) {
                [_rootHandle release];
                _rootHandle = [@"su8" retain];
                isRoot = YES;
                _deviceInfo.isRoot = YES;
            }else {
                rootStr = [rootStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
                NSArray *array1 = [rootStr componentsSeparatedByString:@" "];
                if (array1 != nil) {
                    for (NSString *str1 in array1) {
                        if ([str1 isEqualToString:@"su"] || [str1 isEqualToString:@"bdsu"]) {
                            [_rootHandle release];
                            _rootHandle = [str1 retain];
                            isRoot = YES;
                            _deviceInfo.isRoot = YES;
                            break;
                        }
                    }
                }
            }
        }
    }
    return isRoot;
}

#pragma mark - 扫描前的分析
- (void)parseDevice:(NSArray *)array {
    _isSuccess = NO;
    if (_rootHandle != nil) {
//        if (_dbBackup != nil) {
//            [_dbBackup release];
//            _dbBackup = nil;
//        }
//        _dbBackup = [[IMBAdbDbBackup alloc] init];
//        _isSuccess = [_dbBackup accessToSuPermissions:_deviceInfo.devSerialNumber];
//        if (_isSuccess) {
//        }
//        [self filteredArrayUsingPredicate:array];
    }
}

#pragma mark - stop pause
- (void)setIsStop:(BOOL)isStop {
    _selfStop = isStop;
    _adVideo.isStop = isStop;
    _adAudio.isStop = isStop;
    _adGallery.isStop = isStop;
    _adCallHistory.isStop = isStop;
    _adCalendar.isStop = isStop;
    _adContact.isStop = isStop;
    _adDoucment.isStop = isStop;
    _adSMS.isStop = isStop;
}

- (void)setIsPause:(BOOL)isPause {
    _adVideo.isPause = isPause;
    _adAudio.isPause = isPause;
    _adGallery.isPause = isPause;
    _adCallHistory.isPause = isPause;
    _adCalendar.isPause = isPause;
    _adContact.isPause = isPause;
    _adDoucment.isPause = isPause;
    _adSMS.isPause = isPause;
    if (isPause == NO) {
        [_condition lock];
        [_condition signal];
        [_condition unlock];
    }
}

- (BOOL)checkStopSelectItem {
    BOOL res = NO;
    if (![IMBHelper stringIsNilOrEmpty:[_adContact currentRealStopName]]) {
        res = YES;
        self.currentRealStop = [_adContact currentRealStopName];
        return res;
    }
    if (![IMBHelper stringIsNilOrEmpty:[_adCallHistory currentRealStopName]]) {
        res = YES;
        self.currentRealStop = [_adCallHistory currentRealStopName];
        return res;
    }
    if (![IMBHelper stringIsNilOrEmpty:[_adSMS currentRealStopName]]) {
        res = YES;
        self.currentRealStop = [_adSMS currentRealStopName];
        return res;
    }
    if (![IMBHelper stringIsNilOrEmpty:[_adCalendar currentRealStopName]]) {
        res = YES;
        self.currentRealStop = [_adCalendar currentRealStopName];
        return res;
    }
    if (![IMBHelper stringIsNilOrEmpty:[_adGallery currentRealStopName]]) {
        res = YES;
        self.currentRealStop = [_adGallery currentRealStopName];
        return res;
    }
    if (![IMBHelper stringIsNilOrEmpty:[_adAudio currentRealStopName]]) {
        res = YES;
        self.currentRealStop = [_adAudio currentRealStopName];
        return res;
    }
    if (![IMBHelper stringIsNilOrEmpty:[_adVideo currentRealStopName]]) {
        res = YES;
        self.currentRealStop = [_adVideo currentRealStopName];
        return res;
    }
    if (![IMBHelper stringIsNilOrEmpty:[_adDoucment currentRealStopName]]) {
        res = YES;
        self.currentRealStop = [_adDoucment currentRealStopName];
        return res;
    }
    return res;
}

- (BOOL)checkIsInstallApk:(NSString *)serialNo {
    BOOL res = NO;
    IMBAdbManager *adbManager = [IMBAdbManager singleton];
    NSString *str = [adbManager runADBCommand:[adbManager isInstallerAPK:adbManager.packageName withSerialNo:serialNo]];
    if (![str isEqualToString:@""]) {
        res = YES;
    }
    return res;
}

- (BOOL)installAPK:(NSString *)serialNumber {
    BOOL ret = NO;
    NSString *apkPath = [[NSBundle mainBundle] pathForResource:@"anytransservice" ofType:@"apk"];
    IMBAdbManager *adbManager = [IMBAdbManager singleton];
    NSString *str = [adbManager runADBCommand:[adbManager installAPK:apkPath withSerialNo:serialNumber]];
    if ([IMBHelper stringIsNilOrEmpty:str] || [str rangeOfString:@"Success"].location != NSNotFound) {
        ret = YES;
    }else {
        ret = NO;
    }
    return ret;
}

@end
