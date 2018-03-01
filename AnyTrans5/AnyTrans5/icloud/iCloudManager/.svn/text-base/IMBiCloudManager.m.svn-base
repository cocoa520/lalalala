//
//  IMBiCloudManager.m
//  
//
//  Created by ding ming on 17/2/1.
//
//

#import "IMBiCloudManager.h"
#import "DateHelper.h"
#import "StringHelper.h"
#import "TempHelper.h"
#import "DateHelper.h"
#import "IMBHttpWebResponseUtility.h"
#import "RegexKitLite.h"
#import "IMBSMSChatDataEntity.h"
#import "NSString+Category.h"
#import "IMBNotificationDefine.h"
#import "IMBZipHelper.h"
#import "IMBNoteListViewController.h"
#import "CommonDefine.h"
#import "IMBiCloudViewController.h"
@implementation IMBiCloudManager
@synthesize photoArray = _photoArray;
@synthesize calendarArray = _calendarArray;
@synthesize reminderArray = _reminderArray;
@synthesize noteArray = _noteArray;
@synthesize contactArray = _contactArray;
@synthesize driveFolderEntity = _driveFolderEntity;
@synthesize netClient = _netClient;
@synthesize calendarCollectionArray = _calendarCollectionArray;
@synthesize reminderCollectionArray = _reminderCollectionArray;
@synthesize photoSyncToken = _photoSyncToken;
@synthesize contactPrefToken = _contactPrefToken;
@synthesize contactSyncToken = _contactSyncToken;
@synthesize notesSyncToken = _notesSyncToken;
@synthesize editReminderNewEtag = _editReminderNewEtag;
@synthesize albumArray = _albumArray;
@synthesize delegate = _delegate;
@synthesize photoVideoAlbumArray = _photoVideoAlbumArray;
@synthesize photoVideoCount = _photoVideoCount;
@synthesize photoCount = _photoCount;

- (id)init {
    if (self = [super init]) {
        _netClient = [[IMBiCloudNetClient alloc] init];
        _logHandle = [IMBLogManager singleton];
    }
    return self;
}

- (void)dealloc
{
    if (_editReminderNewEtag != nil) {
        [_editReminderNewEtag release];
        _editReminderNewEtag = nil;
    }
    if (_netClient != nil) {
        [_netClient release];
        _netClient = nil;
    }
    if (_photoSyncToken != nil) {
        [_photoSyncToken release];
        _photoSyncToken = nil;
    }
    if (_contactPrefToken != nil) {
        [_contactPrefToken release];
        _contactPrefToken = nil;
    }
    if (_contactSyncToken != nil) {
        [_contactSyncToken release];
        _contactSyncToken = nil;
    }
    if (_photoArray != nil) {
        [_photoArray release];
        _photoArray = nil;
    }
    if (_contactArray != nil) {
        [_contactArray release];
        _contactArray = nil;
    }
    if (_driveFolderEntity != nil) {
        [_driveFolderEntity release];
        _driveFolderEntity = nil;
    }
    if (_notesSyncToken != nil) {
        [_notesSyncToken release];
        _notesSyncToken = nil;
    }
    if (_calendarCollectionArray != nil) {
        [_calendarCollectionArray release];
        _calendarCollectionArray = nil;
    }
    if (_reminderCollectionArray != nil) {
        [_reminderCollectionArray release];
        _reminderCollectionArray = nil;
    }
    if (_albumArray != nil) {
        [_albumArray release];
        _albumArray = nil;
    }
    if (_photoVideoAlbumArray != nil) {
        [_photoVideoAlbumArray release];
        _photoVideoAlbumArray = nil;
    }
    [super dealloc];
}

- (BOOL)loginiCloudAppleID:(NSString *)appleID WithPassword:(NSString *)password {
    BOOL hasTwoStepAuthentication = NO;//账号是否加了双重验证
    long statusCode = 0;
    BOOL trustEligible = NO;
    NSString *sessiontoken = nil;
    if (_firstDic != nil) {
        [_firstDic release];
        _firstDic = nil;
    }
    _firstDic = [[_netClient verifiAccountHasTwoStepAuthenticationWithAppleID:appleID withPassword:password] retain];
    if ([_firstDic.allKeys containsObject:@"statusCode"]) {
        statusCode = [[_firstDic objectForKey:@"statusCode"] longValue];
    }
    if ([_firstDic.allKeys containsObject:@"headerdic"]) {
        NSDictionary *headerDic = [_firstDic objectForKey:@"headerdic"];
        if ([headerDic.allKeys containsObject:@"X-Apple-Session-Token"]) {
            sessiontoken = [headerDic objectForKey:@"X-Apple-Session-Token"];
        }
        if ([headerDic.allKeys containsObject:@"X-Apple-TwoSV-Trust-Eligible"]) {
            trustEligible = [[headerDic objectForKey:@"X-Apple-TwoSV-Trust-Eligible"] boolValue];
        }
    }
    if (statusCode == 409 && trustEligible) {//加了双重验证
        hasTwoStepAuthentication = YES;
        [_delegate setHasTwoStepAuth:YES];
        [_delegate showTwoStepAuthenticationAlertView];
        return NO;
    }else if(statusCode == 200) {//表示成功 并且没有开启双重验证
        BOOL ret = NO;
        @try {
            ret = [_netClient iCloudLoginWithAppleID:appleID withPassword:password WithSessiontoken:sessiontoken];
        }
        @catch (NSException *exception) {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"Login Fail:%@",exception.reason]];
        }
        if (ret) {
            [_netClient startKeepAliveThread];
        }
        return ret;
    }else if (statusCode == 401) {//401 表示认证错误
        return NO;
    }else if (statusCode == 400) {//400 表示请求参数构建错误
        return NO;
    }else {
        return NO;
    }
}

- (NSDictionary *)verifiTwoStepAuthentication:(NSString *)password{
    return [_netClient verifiTwoStepAuthentication:password withFirstDic:_firstDic];
}

#pragma mark - Photos
- (void)getPhotosContent {
    if (_photoSyncToken != nil) {
        [_photoSyncToken release];
        _photoSyncToken = nil;
    }
    if (_albumArray != nil) {
        [_albumArray release];
        _albumArray = nil;
    }
    _photoCount = 0;
    _albumArray = [[NSMutableArray alloc] init];
    if (_photoVideoAlbumArray != nil) {
        [_photoVideoAlbumArray release];
        _photoVideoAlbumArray = nil;
    }
    _photoVideoCount = 0;
    _photoVideoAlbumArray = [[NSMutableArray alloc] init];
    [self getPhotoAlbumDetail];
    [self getCreatePhotoAlbumDetail];
//    if (_photoSyncToken != nil) {
//        //获得图片信息；
//        if (_photoArray != nil) {
//            [_photoArray release];
//            _photoArray = nil;
//        }
//        _photoArray = [[NSMutableArray alloc] init];
//        [self getPhotoDetail:totalCount];
//    }else {
//        NSLog(@"photo synctoken is null!");
//    }
}

- (void)getPhotoAlbumDetail {
    NSString *pathStr = @"/database/1/com.apple.photos.cloud/production/private/internal/records/query/batch?remapEnums=true&getCurrentSyncToken=true&clientBuildNumber=17AHotfix3&clientMasteringNumber=17AHotfix3&dsid=%@";
    NSString *postStr = @"{\"batch\":[{\"query\":{\"recordType\":\"HyperionIndexCountLookup\",\"filterBy\":{\"fieldName\":\"indexCountID\",\"comparator\":\"IN\",\"fieldValue\":{\"value\":[\"CPLAssetByAssetDateWithoutHiddenOrDeleted\",\"CPLAssetByAddedDate\",\"CPLAssetInSmartAlbumByAssetDate:Favorite\",\"CPLAssetInSmartAlbumByAssetDate:Video\",\"CPLAssetInSmartAlbumByAssetDate:Panorama\",\"CPLAssetInSmartAlbumByAssetDate:Timelapse\",\"CPLAssetInSmartAlbumByAssetDate:Slomo\",\"CPLAssetBurstStackAssetByAssetDate\",\"CPLAssetInSmartAlbumByAssetDate:Screenshot\",\"CPLAssetHiddenByAssetDate\",\"CPLAssetDeletedByExpungedDate\"],\"type\":\"STRING_LIST\"}}},\"zoneID\":{\"zoneName\":\"PrimarySync\"},\"zoneWide\":true,\"resultsLimit\":11}]}";
    @try {
        NSDictionary *albumDic = [_netClient postInformationContent:@"ckdatabasews" withPath:pathStr withPostStr:postStr];
        if (albumDic != nil) {
            if ([albumDic.allKeys containsObject:@"batch"]) {
                NSArray *albumArr = [albumDic objectForKey:@"batch"];
                for (NSDictionary *detailDic in albumArr) {
                    if ([detailDic.allKeys containsObject:@"records"]) {
                        NSArray *detailArr = [detailDic objectForKey:@"records"];
                        for (NSDictionary *conDic in detailArr) {
                            NSString *recName = @"";
                            if ([conDic.allKeys containsObject:@"recordName"]) {
                                recName = [conDic objectForKey:@"recordName"];
                            }
                            if ([StringHelper stringIsNilOrEmpty:recName] || [recName isEqualToString:@"CPLAssetByAssetDateWithoutHiddenOrDeleted"] || [recName isEqualToString:@"CPLAssetBurstStackAssetByAssetDate"] || [recName isEqualToString:@"CPLAssetHiddenByAssetDate"] || [recName isEqualToString:@"CPLAssetDeletedByExpungedDate"]) {
                                continue;
                            }
                            IMBToiCloudPhotoEntity *albumEntity = [[IMBToiCloudPhotoEntity alloc] init];
                            if ([conDic.allKeys containsObject:@"created"]) {
                                NSDictionary *createDic = [conDic objectForKey:@"created"];
                                if ([createDic.allKeys containsObject:@"timestamp"]) {
                                    long long timestamp = [[createDic objectForKey:@"timestamp"] longLongValue];
                                    albumEntity.photoDateData = timestamp / 1000;
                                }
                            }
                            if ([conDic.allKeys containsObject:@"fields"]) {
                                NSDictionary *fieldDic = [conDic objectForKey:@"fields"];
                                if ([fieldDic.allKeys containsObject:@"itemCount"]) {
                                    NSDictionary *itemDic = [fieldDic objectForKey:@"itemCount"];
                                    if ([itemDic.allKeys containsObject:@"value"]) {
                                        albumEntity.photoCounts = [[itemDic objectForKey:@"value"] intValue];
                                    }
                                    if (albumEntity.photoCounts == 0) {
                                        [albumEntity release];
                                        continue;
                                    }
                                }
                            }
                            if ([conDic.allKeys containsObject:@"modified"]) {
                                
                            }
                            if ([conDic.allKeys containsObject:@"recordName"]) {
                                albumEntity.clientId = [conDic objectForKey:@"recordName"];
                                NSArray *array = [albumEntity.clientId componentsSeparatedByString:@":"];
                                if (array.count > 1) {
//                                    albumEntity.iCloudAlbumType = [array objectAtIndex:0];
                                    albumEntity.recordName = [array objectAtIndex:1];
                                }
                            }
                            if ([conDic.allKeys containsObject:@"recordType"]) {
                                albumEntity.type = [conDic objectForKey:@"recordType"];
                            }
                            if ([conDic.allKeys containsObject:@"recordChangeTag"]) {
                                albumEntity.recordChangeTag = [conDic objectForKey:@"recordChangeTag"];
                            }
                            if ([conDic.allKeys containsObject:@"zoneID"]) {
                                NSDictionary *zoneIDDic = [conDic objectForKey:@"zoneID"];
                                if ([zoneIDDic.allKeys containsObject:@"ownerRecordName"]) {
                                    albumEntity.ownerRecordName = [zoneIDDic objectForKey:@"ownerRecordName"];
                                }
                                if ([zoneIDDic.allKeys containsObject:@"zoneName"]) {
                                    albumEntity.zoneName = [zoneIDDic objectForKey:@"zoneName"];
                                }
                            }
//                            if ([albumEntity.clientId isEqualToString:@"CPLAssetByAddedDate"]) {
//                                totalCount = albumEntity.photoCounts;
//                            }
                            if ([albumEntity.clientId isEqualToString:@"CPLAssetByAddedDate"]
                                ) {
                                albumEntity.iCloudAlbumType = @"CPLAssetAndMasterByAddedDate";
                                albumEntity.albumTitle = CustomLocalizedString(@"MenuItem_id_9", nil);
                            }else if ([albumEntity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Video"]
                                      ) {
                                albumEntity.iCloudAlbumType = @"CPLAssetAndMasterInSmartAlbumByAssetDate";
                                albumEntity.albumTitle = CustomLocalizedString(@"MenuItem_id_24", nil);
                            }else if ([albumEntity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Timelapse"]
                                      ) {
                                albumEntity.iCloudAlbumType = @"CPLAssetAndMasterInSmartAlbumByAssetDate";
                                albumEntity.albumTitle = CustomLocalizedString(@"MenuItem_id_48", nil);
                            }else if ([albumEntity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Slomo"]
                                      ) {
                                albumEntity.iCloudAlbumType = @"CPLAssetAndMasterInSmartAlbumByAssetDate";
                                albumEntity.albumTitle = CustomLocalizedString(@"MenuItem_id_51", nil);
                            }else if ([albumEntity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Favorite"]
                                      ) {
                                albumEntity.iCloudAlbumType = @"CPLAssetAndMasterInSmartAlbumByAssetDate";
                                albumEntity.albumTitle = CustomLocalizedString(@"MenuItem_id_67", nil);
                            }else if ([albumEntity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Panorama"]
                                      ) {
                                albumEntity.iCloudAlbumType = @"CPLAssetAndMasterInSmartAlbumByAssetDate";
                                albumEntity.albumTitle = CustomLocalizedString(@"MenuItem_id_49", nil);
                            }else if ([albumEntity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Screenshot"]
                                      ) {
                                albumEntity.iCloudAlbumType = @"CPLAssetAndMasterInSmartAlbumByAssetDate";
                                albumEntity.albumTitle = CustomLocalizedString(@"MenuItem_id_64", nil);
                            }
                        
                            if ([albumEntity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Video"] || [albumEntity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Timelapse"] || [albumEntity.clientId isEqualToString:@"CPLAssetInSmartAlbumByAssetDate:Slomo"]) {
                                [_photoVideoAlbumArray addObject:albumEntity];
                                _photoVideoCount += albumEntity.photoCounts;
                            }else {
                                _photoCount += albumEntity.photoCounts;
                                [_albumArray addObject:albumEntity];
                            }
                            [albumEntity release];
                        }
                    }
                    if ([detailDic.allKeys containsObject:@"syncToken"]) {
                        if (_photoSyncToken != nil) {
                            [_photoSyncToken release];
                            _photoSyncToken = nil;
                        }
                        _photoSyncToken = [[detailDic objectForKey:@"syncToken"] retain];
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"photo album exception :%@",exception.reason]];
    }
}

- (void)getCreatePhotoAlbumDetail {
    NSString *pathStr = @"/database/1/com.apple.photos.cloud/production/private/records/query?remapEnums=true&ckjsBuildVersion=17AProjectDev84&ckjsVersion=2.0.3&getCurrentSyncToken=true&clientBuildNumber=17AHotfix3&clientMasteringNumber=17AHotfix3&dsid=%@";
    NSString *postStr = @"{\"query\":{\"recordType\":\"CPLAlbumByPositionLive\"},\"zoneID\":{\"zoneName\":\"PrimarySync\"}}";
    
    @try {
        NSDictionary *albumDic = [_netClient postInformationContent:@"ckdatabasews" withPath:pathStr withPostStr:postStr];
        if (albumDic != nil) {
            if ([albumDic.allKeys containsObject:@"records"]) {
                NSArray *detailArr = [albumDic objectForKey:@"records"];
                for (NSDictionary *conDic in detailArr) {
                    NSString *recordName = @"";
                    if ([conDic.allKeys containsObject:@"recordName"]) {
                        recordName = [conDic objectForKey:@"recordName"];
                    }
                    if ([StringHelper stringIsNilOrEmpty:recordName] || [recordName isEqualToString:@"----Root-Folder----"]) {
                        continue;
                    }
                    IMBToiCloudPhotoEntity *albumEntity = [[IMBToiCloudPhotoEntity alloc] init];
                    if ([conDic.allKeys containsObject:@"created"]) {
                        NSDictionary *createDic = [conDic objectForKey:@"created"];
                        if ([createDic.allKeys containsObject:@"timestamp"]) {
                            long long timestamp = [[createDic objectForKey:@"timestamp"] longLongValue];
                            albumEntity.photoDateData = timestamp / 1000;
                        }
                    }
                    if ([conDic.allKeys containsObject:@"fields"]) {
                        NSDictionary *fieldDic = [conDic objectForKey:@"fields"];
                        if ([fieldDic.allKeys containsObject:@"albumNameEnc"]) {
                            NSDictionary *albumNameDic = [fieldDic objectForKey:@"albumNameEnc"];
                            if ([albumNameDic.allKeys containsObject:@"value"]) {
                                albumEntity.albumTitle = [_netClient decode:[albumNameDic objectForKey:@"value"]];
                            }
                        }
                        
                        if ([fieldDic.allKeys containsObject:@"albumNameEnc"]) {
                            NSDictionary *deletedDic = [fieldDic objectForKey:@"isDeleted"];
                            if ([deletedDic.allKeys containsObject:@"value"]) {
                                
                            }
                        }
                        
                        if ([fieldDic.allKeys containsObject:@"albumNameEnc"]) {
                            NSDictionary *expungedDic = [fieldDic objectForKey:@"isExpunged"];
                            if ([expungedDic.allKeys containsObject:@"value"]) {
                                
                            }
                        }
                    }
                    if ([conDic.allKeys containsObject:@"modified"]) {
                        
                    }
                    if ([conDic.allKeys containsObject:@"recordName"]) {
                        albumEntity.clientId = [conDic objectForKey:@"recordName"];
                        albumEntity.recordName = albumEntity.clientId;
                        albumEntity.iCloudAlbumType = @"CPLContainerRelationLiveByPosition";
                    }
                    if ([conDic.allKeys containsObject:@"recordType"]) {
                        albumEntity.type = [conDic objectForKey:@"recordType"];
                    }
                    if ([conDic.allKeys containsObject:@"recordChangeTag"]) {
                        albumEntity.recordChangeTag = [conDic objectForKey:@"recordChangeTag"];
                    }
                    if ([conDic.allKeys containsObject:@"zoneID"]) {
                        NSDictionary *zoneIDDic = [conDic objectForKey:@"zoneID"];
                        if ([zoneIDDic.allKeys containsObject:@"ownerRecordName"]) {
                            albumEntity.ownerRecordName = [zoneIDDic objectForKey:@"ownerRecordName"];
                        }
                        if ([zoneIDDic.allKeys containsObject:@"zoneName"]) {
                            albumEntity.zoneName = [zoneIDDic objectForKey:@"zoneName"];
                        }
                    }
                    
                    //                    _photoCount += albumEntity.photoCounts;
                    [_albumArray addObject:albumEntity];
                    [albumEntity release];
                }
            }
            if (_albumArray != nil) {
                NSMutableString *postStr1 = [NSMutableString stringWithString:@"{\"batch\":["];
                for (int i=0;i<_albumArray.count;i++) {
                    IMBToiCloudPhotoEntity *albumEntity = [_albumArray objectAtIndex:i];
                    if (![albumEntity.type isEqualToString:@"CPLAlbum"]) {
                        continue;
                    }
                    NSString *queryStr = [NSString stringWithFormat:@"{\"query\":{\"recordType\":\"HyperionIndexCountLookup\",\"filterBy\":{\"fieldName\":\"indexCountID\",\"comparator\":\"IN\",\"fieldValue\":{\"value\":[\"CPLContainerRelationNotDeletedByAssetDate:%@\"],\"type\":\"STRING_LIST\"}}},\"zoneID\":{\"zoneName\":\"PrimarySync\"},\"zoneWide\":true,\"resultsLimit\":1}",albumEntity.clientId];
                    [postStr1 appendString:queryStr];
                    if (i == _albumArray.count - 1) {
                        [postStr1 appendString:@"]}"];
                    }else {
                        [postStr1 appendString:@","];
                    }
                }
                
                if (postStr1 != nil) {
                    NSString *pathStr1 = @"/database/1/com.apple.photos.cloud/production/private/internal/records/query/batch?remapEnums=true&getCurrentSyncToken=true&clientBuildNumber=17AHotfix3&clientMasteringNumber=17AHotfix3&dsid=%@";
                    NSDictionary *albumDic1 = [_netClient postInformationContent:@"ckdatabasews" withPath:pathStr1 withPostStr:postStr1];
                    if (albumDic1 != nil) {
                        if ([albumDic1.allKeys containsObject:@"batch"]) {
                            NSArray *albumArr = [albumDic1 objectForKey:@"batch"];
                            for (NSDictionary *detailDic in albumArr) {
                                if ([detailDic.allKeys containsObject:@"records"]) {
                                    NSArray *detailArr = [detailDic objectForKey:@"records"];
                                    for (NSDictionary *conDic in detailArr) {
                                        IMBToiCloudPhotoEntity *albumEntity = nil;
                                        if ([conDic.allKeys containsObject:@"recordName"]) {
                                            NSString *recName = [conDic objectForKey:@"recordName"];
                                            for (IMBToiCloudPhotoEntity *entity in _albumArray) {
                                                if ([recName contains:entity.recordName]) {
                                                    albumEntity = entity;
                                                    break;
                                                }
                                            }
                                        }
                                        if (albumEntity != nil) {
                                            if ([conDic.allKeys containsObject:@"fields"]) {
                                                NSDictionary *fieldDic = [conDic objectForKey:@"fields"];
                                                if ([fieldDic.allKeys containsObject:@"itemCount"]) {
                                                    NSDictionary *itemDic = [fieldDic objectForKey:@"itemCount"];
                                                    if ([itemDic.allKeys containsObject:@"value"]) {
                                                        albumEntity.photoCounts = [[itemDic objectForKey:@"value"] intValue];
                                                        _photoCount += albumEntity.photoCounts;
                                                    }
                                                }
                                            }
                                            if ([conDic.allKeys containsObject:@"recordName"]) {
                                                albumEntity.clientId = [conDic objectForKey:@"recordName"];
                                                NSArray *array = [albumEntity.clientId componentsSeparatedByString:@":"];
                                                if (array.count > 1) {
                                                    albumEntity.recordName = [array objectAtIndex:1];
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        if ([exception.reason isEqualToString:@"Network fault interrupt"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTITY_NETWORK_FAULT_INTERRUPT object:nil userInfo:nil];
        }
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"Create photo detail album exception :%@",exception.reason]];
    }
}

- (void)getPhotoDetail:(IMBToiCloudPhotoEntity *)albumEntity {
    [albumEntity.subArray removeAllObjects];
    NSString *pathStr = @"/database/1/com.apple.photos.cloud/production/private/records/query?remapEnums=true&ckjsBuildVersion=17AProjectDev84&ckjsVersion=2.0.3&getCurrentSyncToken=true&clientBuildNumber=17AHotfix3&clientMasteringNumber=17AHotfix3&dsid=%@";
    int startRank = 0;
    NSMutableArray *assetArr = [[NSMutableArray alloc] init];
    NSMutableArray *masterArr = [[NSMutableArray alloc] init];
    NSMutableArray *recordNameArr = [[NSMutableArray alloc] init];
    
    NSString *recordType = albumEntity.iCloudAlbumType;
    NSString *queryType = albumEntity.recordName;
    if (![albumEntity.type isEqualToString:@"CPLAlbum"]) {
        queryType = [albumEntity.recordName uppercaseString];
    }
    NSString *appendQueryText = @"";
    if ([recordType isEqualToString:@"CPLAssetAndMasterByAddedDate"]) {
        appendQueryText = @"";
        if (_photoArray != nil) {
            [_photoArray release];
            _photoArray = nil;
        }
        _photoArray = [[NSMutableArray alloc] init];
    }else {
        if (![StringHelper stringIsNilOrEmpty:queryType])
        {
            if ([albumEntity.type isEqualToString:@"CPLAlbum"]) {
                appendQueryText = [NSString stringWithFormat:@",{\"fieldName\":\"parentId\",\"comparator\":\"EQUALS\",\"fieldValue\":{\"type\":\"STRING\",\"value\":\"%@\"}}",queryType];
            }else {
                appendQueryText = [NSString stringWithFormat:@",{\"fieldName\":\"smartAlbum\",\"comparator\":\"EQUALS\",\"fieldValue\":{\"type\":\"STRING\",\"value\":\"%@\"}}",queryType];
            }
        }
        else
        {
            appendQueryText = @"";
        }
    }
    int totalCount = albumEntity.photoCounts;
    while (startRank < totalCount) {
        startRank += 100;
        if (startRank > totalCount)
        {
            startRank = totalCount;
        }
        //CPLAssetAndMasterInSmartAlbumByAssetDate-->取相关相册、CPLAssetAndMasterByAddedDate-->取整个相册
        NSString *postStr = [NSString stringWithFormat:@"{\"query\":{\"recordType\":\"%@\",\"filterBy\":[{\"fieldName\":\"startRank\",\"comparator\":\"EQUALS\",\"fieldValue\":{\"value\":%d,\"type\":\"INT64\"}},{\"fieldName\":\"direction\",\"comparator\":\"EQUALS\",\"fieldValue\":{\"value\":\"DESCENDING\",\"type\":\"STRING\"}}%@]},\"zoneID\":{\"zoneName\":\"PrimarySync\"},\"desiredKeys\":[\"resJPEGFullWidth\",\"resJPEGFullHeight\",\"resJPEGFullFileType\",\"resJPEGFullFingerprint\",\"resJPEGFullRes\",\"resJPEGLargeWidth\",\"resJPEGLargeHeight\",\"resJPEGLargeFileType\",\"resJPEGLargeFingerprint\",\"resJPEGLargeRes\",\"resJPEGMedWidth\",\"resJPEGMedHeight\",\"resJPEGMedFileType\",\"resJPEGMedFingerprint\",\"resJPEGMedRes\",\"resJPEGThumbWidth\",\"resJPEGThumbHeight\",\"resJPEGThumbFileType\",\"resJPEGThumbFingerprint\",\"resJPEGThumbRes\",\"resVidFullWidth\",\"resVidFullHeight\",\"resVidFullFileType\",\"resVidFullFingerprint\",\"resVidFullRes\",\"resVidMedWidth\",\"resVidMedHeight\",\"resVidMedFileType\",\"resVidMedFingerprint\",\"resVidMedRes\",\"resVidSmallWidth\",\"resVidSmallHeight\",\"resVidSmallFileType\",\"resVidSmallFingerprint\",\"resVidSmallRes\",\"resSidecarWidth\",\"resSidecarHeight\",\"resSidecarFileType\",\"resSidecarFingerprint\",\"resSidecarRes\",\"itemType\",\"dataClassType\",\"mediaMetaDataType\",\"mediaMetaDataEnc\",\"filenameEnc\",\"originalOrientation\",\"resOriginalWidth\",\"resOriginalHeight\",\"resOriginalFileType\",\"resOriginalFingerprint\",\"resOriginalRes\",\"resOriginalAltWidth\",\"resOriginalAltHeight\",\"resOriginalAltFileType\",\"resOriginalAltFingerprint\",\"resOriginalAltRes\",\"resOriginalVidComplWidth\",\"resOriginalVidComplHeight\",\"resOriginalVidComplFileType\",\"resOriginalVidComplFingerprint\",\"resOriginalVidComplRes\",\"isDeleted\",\"isExpunged\",\"dateExpunged\",\"remappedRef\",\"recordName\",\"recordType\",\"recordChangeTag\",\"masterRef\",\"assetDate\",\"addedDate\",\"isFavorite\",\"isHidden\",\"orientation\",\"duration\",\"assetSubtype\",\"assetSubtypeV2\",\"assetHDRType\",\"burstFlags\",\"burstFlagsExt\",\"burstId\",\"captionEnc\",\"locationEnc\",\"locationV2Enc\",\"locationLatitude\",\"locationLongitude\",\"adjustmentType\",\"vidComplDurValue\",\"vidComplDurScale\",\"vidComplDispValue\",\"vidComplDispScale\",\"vidComplVisibilityState\",\"customRenderedValue\",\"containerId\",\"itemId\",\"position\",\"isKeyAsset\"],\"resultsLimit\":200}",recordType,startRank,appendQueryText];
        
        NSDictionary *photoDic = nil;
        @try {
           photoDic = [_netClient postInformationContent:@"ckdatabasews" withPath:pathStr withPostStr:postStr];
        }
        @catch (NSException *exception) {
            if ([exception.reason isEqualToString:@"Network fault interrupt"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTITY_NETWORK_FAULT_INTERRUPT object:nil userInfo:nil];
            }
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"photo exception :%@",exception.reason]];
            return;
        }
        if (photoDic != nil) {
            if ([photoDic.allKeys containsObject:@"records"]) {
                NSArray *recordArr = [photoDic objectForKey:@"records"];
                for (NSDictionary *detailDic in recordArr) {
                    NSString *recordType = @"";
                    if ([detailDic.allKeys containsObject:@"recordType"]) {
                        recordType = [detailDic objectForKey:@"recordType"];
                    }
                    if ([recordType isEqualToString:@"CPLAsset"]) {
                        NSString *recordName = @"";
                        if ([detailDic.allKeys containsObject:@"recordName"]) {
                            recordName = [detailDic objectForKey:@"recordName"];
                        }
                        if (![StringHelper stringIsNilOrEmpty:recordName]) {
                            if (![recordNameArr containsObject:recordName]) {
                                [assetArr addObject:detailDic];
                                [recordNameArr addObject:recordName];
                            }
                        }
                    }else if ([recordType isEqualToString:@"CPLMaster"]) {
                        [masterArr addObject:detailDic];
                    }
                }
            }
        }
    }
    
    for (int i=0; i<assetArr.count; i++) {
        NSDictionary *assetDic = [assetArr objectAtIndex:i];
        NSString *assetRecordName = @"";
        if ([assetDic.allKeys containsObject:@"fields"]) {
            NSDictionary *fieldsDic = [assetDic objectForKey:@"fields"];
            if ([fieldsDic.allKeys containsObject:@"masterRef"]) {
                NSDictionary *masterRefDic = [fieldsDic objectForKey:@"masterRef"];
                if ([masterRefDic.allKeys containsObject:@"value"]) {
                    NSDictionary *valueDic = [masterRefDic objectForKey:@"value"];
                    if ([valueDic.allKeys containsObject:@"recordName"]) {
                        assetRecordName = [valueDic objectForKey:@"recordName"];
                    }
                }
            }
        }
        
        if (![StringHelper stringIsNilOrEmpty:assetRecordName]) {
            for (NSDictionary *masterDic in masterArr) {
                NSString *masterRecordName = @"";
                if ([masterDic.allKeys containsObject:@"recordName"]) {
                    masterRecordName = [masterDic objectForKey:@"recordName"];
                }
                if ([assetRecordName isEqualToString:masterRecordName]) {
                    IMBToiCloudPhotoEntity *photoEntity = [[IMBToiCloudPhotoEntity alloc] init];
                    if ([assetDic.allKeys containsObject:@"recordName"]) {
                        photoEntity.clientId = [assetDic objectForKey:@"recordName"];
                    }
                    if ([assetDic.allKeys containsObject:@"recordType"]) {
                        photoEntity.type = [assetDic objectForKey:@"recordType"];
                    }
                    if ([assetDic.allKeys containsObject:@"recordChangeTag"]) {
                        photoEntity.recordChangeTag = [assetDic objectForKey:@"recordChangeTag"];
                    }
                    
                    if ([masterDic.allKeys containsObject:@"created"]) {
                        NSDictionary *createDic = [masterDic objectForKey:@"created"];
                        if ([createDic.allKeys containsObject:@"timestamp"]) {
                            long long timestamp = [[createDic objectForKey:@"timestamp"] longLongValue];
                            photoEntity.photoDateData = timestamp / 1000;
                        }
                    }
                    if ([masterDic.allKeys containsObject:@"fields"]) {
                        NSDictionary *fieldDic = [masterDic objectForKey:@"fields"];
                        if ([fieldDic.allKeys containsObject:@"filenameEnc"]) {
                            NSDictionary *valueDic = [fieldDic objectForKey:@"filenameEnc"];
                            if ([valueDic.allKeys containsObject:@"value"]) {
                                photoEntity.photoName = [_netClient decode:[valueDic objectForKey:@"value"]];
                            }
                        }
                        if ([fieldDic.allKeys containsObject:@"isExpunged"]) {
                            NSDictionary *valueDic = [fieldDic objectForKey:@"isExpunged"];
                            if ([valueDic.allKeys containsObject:@"value"]) {
                                photoEntity.isDeleted = [[valueDic objectForKey:@"value"] boolValue];
                            }
                        }
                        if ([fieldDic.allKeys containsObject:@"originalOrientation"]) {
                            NSDictionary *valueDic = [fieldDic objectForKey:@"originalOrientation"];
                            if ([valueDic.allKeys containsObject:@"value"]) {
                                photoEntity.photoRiginal = [[valueDic objectForKey:@"value"] intValue];
                            }
                        }
                        if ([fieldDic.allKeys containsObject:@"resJPEGThumbHeight"]) {
                            NSDictionary *valueDic = [fieldDic objectForKey:@"resJPEGThumbHeight"];
                            if ([valueDic.allKeys containsObject:@"value"]) {
                                photoEntity.thumbHeight = [[valueDic objectForKey:@"value"] intValue];
                            }
                        }
                        if ([fieldDic.allKeys containsObject:@"resJPEGThumbWidth"]) {
                            NSDictionary *valueDic = [fieldDic objectForKey:@"resJPEGThumbWidth"];
                            if ([valueDic.allKeys containsObject:@"value"]) {
                                photoEntity.thumbWidth = [[valueDic objectForKey:@"value"] intValue];
                            }
                        }
                        if ([fieldDic.allKeys containsObject:@"resOriginalHeight"]) {
                            NSDictionary *valueDic = [fieldDic objectForKey:@"resOriginalHeight"];
                            if ([valueDic.allKeys containsObject:@"value"]) {
                                photoEntity.photoHeight = [[valueDic objectForKey:@"value"] intValue];
                            }
                        }
                        if ([fieldDic.allKeys containsObject:@"resOriginalWidth"]) {
                            NSDictionary *valueDic = [fieldDic objectForKey:@"resOriginalWidth"];
                            if ([valueDic.allKeys containsObject:@"value"]) {
                                photoEntity.photoWidth = [[valueDic objectForKey:@"value"] intValue];
                            }
                        }
                        if ([fieldDic.allKeys containsObject:@"resJPEGThumbRes"]) {
                            NSDictionary *valueDic = [fieldDic objectForKey:@"resJPEGThumbRes"];
                            if ([valueDic.allKeys containsObject:@"value"]) {
                                NSDictionary *thumbDic = [valueDic objectForKey:@"value"];
                                if ([thumbDic.allKeys containsObject:@"fileChecksum"]) {
                                    photoEntity.thumbFileName = [[thumbDic objectForKey:@"fileChecksum"] stringByReplacingOccurrencesOfString:@"/" withString:@""];
                                }
                                if ([thumbDic.allKeys containsObject:@"downloadURL"]) {
                                    photoEntity.thumbDownloadUrl = [thumbDic objectForKey:@"downloadURL"];
                                    //                                    [self getPhotoThumbnilDetail:photoEntity];
                                    photoEntity.photoImage = [StringHelper imageNamed:@"photo_show"];
                                }
                            }
                        }
                        if ([fieldDic.allKeys containsObject:@"resOriginalRes"]) {
                            NSDictionary *valueDic = [fieldDic objectForKey:@"resOriginalRes"];
                            if ([valueDic.allKeys containsObject:@"value"]) {
                                NSDictionary *originalDic = [valueDic objectForKey:@"value"];
                                if ([originalDic.allKeys containsObject:@"downloadURL"]) {
                                    photoEntity.oriDownloadUrl = [originalDic objectForKey:@"downloadURL"];
                                }
                                if ([originalDic.allKeys containsObject:@"size"]) {
                                    photoEntity.photoSize = [[originalDic objectForKey:@"size"] longLongValue];
                                }
                            }
                        }
                    }
                    if ([masterDic.allKeys containsObject:@"zoneID"]) {
                        NSDictionary *zoneIDDic = [masterDic objectForKey:@"zoneID"];
                        if ([zoneIDDic.allKeys containsObject:@"ownerRecordName"]) {
                            photoEntity.ownerRecordName = [zoneIDDic objectForKey:@"ownerRecordName"];
                        }
                        if ([zoneIDDic.allKeys containsObject:@"zoneName"]) {
                            photoEntity.zoneName = [zoneIDDic objectForKey:@"zoneName"];
                        }
                    }
                    
                    if ([recordType isEqualToString:@"CPLAssetAndMasterByAddedDate"]) {
                        [_photoArray addObject:photoEntity];
                    }
                    [albumEntity.subArray addObject:photoEntity];
                    [photoEntity release];

                    break;
                }
            }
        }
    }
    
    [assetArr release];
    [masterArr release];
    [recordNameArr release];
}

- (NSData *)getPhotoThumbnilDetail:(NSString *)urlStr {
    NSData *thumbData = nil;
    @try {
        thumbData = [_netClient getiCloudNoteAttachmentUrl:urlStr];
//        if (thumbData != nil) {
//            NSString *downloadPath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:photoEntity.thumbFileName];
//            NSFileManager *fm = [NSFileManager defaultManager];
//            if ([fm fileExistsAtPath:downloadPath]) {
//                [fm removeItemAtPath:downloadPath error:nil];
//            }
//            [fm createFileAtPath:downloadPath contents:nil attributes:nil];
//            NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:downloadPath];
//            [handle writeData:thumbData];
//            [handle closeFile];
//
//            photoEntity.thumbPath = downloadPath;
//        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"read Photo Thumbnil Detail exception :%@",exception.reason]];
    }
    return thumbData;
}

- (BOOL)downloadPhoto:(IMBToiCloudPhotoEntity *)photoEntity withDownloadPath:(NSString *)downloadPath {
    BOOL ret = NO;
    NSData *photoData = nil;
    @try {
        photoData = [_netClient getiCloudNoteAttachmentUrl:photoEntity.oriDownloadUrl];
        if (photoData != nil) {
            NSString *photoName = @"imobie.jpg";
            if (![StringHelper stringIsNilOrEmpty:photoEntity.photoName]) {
                photoName = photoEntity.photoName;
            }
            NSString *filePath = [downloadPath stringByAppendingPathComponent:photoName];
            NSString *otherPath = nil;
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:filePath]) {
              otherPath = [TempHelper getFilePathAlias:filePath];
            }
            if (otherPath != nil) {
                filePath = otherPath;
            }
           BOOL success =  [fm createFileAtPath:filePath contents:nil attributes:nil];
            if (success) {
                NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
                [handle writeData:photoData];
                [handle closeFile];
                ret = YES;
            }
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"download Photo Detail exception :%@",exception.reason]];
    }
    return ret;
}

- (BOOL)uploadPhoto:(NSString *)filePath withContainerId:(NSString *)containerId {
    BOOL ret = NO;
    @try {
        NSString *pathStr = @"/upload?filename=%@&dsid=%@&lastModDate=%lld&timezoneOffset=%d";
        ret = [_netClient uploadFileToiCloud:pathStr withFilePath:filePath withInfoName:@"uploadimagews" withContentType:@"" withIsPhoto:YES];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"upload Photo exception :%@",exception.reason]];
    }
    if (ret && containerId != nil) {
        NSString *successStr = _netClient.downloadService.successStr;
        NSDictionary *successDic = [TempHelper dictionaryWithJsonString:successStr];
        if (successDic != nil) {
            NSMutableArray *photoArr = [NSMutableArray array];
            if ([successDic.allKeys containsObject:@"records"]) {
                NSArray *recordArr = [successDic objectForKey:@"records"];
                for (NSDictionary *dic in recordArr) {
                    if ([dic.allKeys containsObject:@"recordType"]) {
                        NSString *recordType = [dic objectForKey:@"recordType"];
                        if ([recordType isEqualToString:@"CPLAsset"]) {
                            if ([dic.allKeys containsObject:@"recordName"]) {
                                NSString *recordName = [dic objectForKey:@"recordName"];
                                if (![StringHelper stringIsNilOrEmpty:recordName]) {
                                    IMBToiCloudPhotoEntity *entity = [[IMBToiCloudPhotoEntity alloc] init];
                                    entity.clientId = recordName;
                                    [photoArr addObject:entity];
                                    [entity release];
                                }
                            }
                        }
                    }
                }
            }
            if (photoArr != nil) {
                ret = [self addPhotoToAlbum:photoArr withContainerId:containerId];
            }else {
                ret = NO;
            }
        }else {
            ret = NO;
        }
    }
    return ret;
}

- (BOOL)syncTransferPhoto:(IMBToiCloudPhotoEntity *)photoEntity {
    BOOL ret = NO;
    @try {
        NSString *pathStr = @"/upload?filename=%@&dsid=%@&lastModDate=%lld&timezoneOffset=%d";
        NSString *photoName = @"imobie.jpg";
        if (![StringHelper stringIsNilOrEmpty:photoEntity.photoName]) {
            photoName = photoEntity.photoName;
        }
        ret = [_netClient uploadFileToiCloud:pathStr withPhotoData:photoEntity.photoImageData withInfoName:@"uploadimagews" withFileName:photoName];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"upload Photo exception :%@",exception.reason]];
    }
    return ret;
}

- (BOOL)deletePhotos:(NSArray *)deleteArr {
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    NSMutableArray *postArr = [NSMutableArray array];
    for (IMBToiCloudPhotoEntity *entity in deleteArr) {
        NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
        [conDic setObject:@"update" forKey:@"operationType"];
        NSMutableDictionary *recordDic = [NSMutableDictionary dictionary];
        if (![StringHelper stringIsNilOrEmpty:entity.clientId]) {
            [recordDic setObject:entity.clientId forKey:@"recordName"];
        }
        if (![StringHelper stringIsNilOrEmpty:entity.type]) {
            [recordDic setObject:entity.type forKey:@"recordType"];
        }
        if (![StringHelper stringIsNilOrEmpty:entity.recordChangeTag]) {
            [recordDic setObject:entity.recordChangeTag forKey:@"recordChangeTag"];
        }
        NSMutableDictionary *fieldDic = [NSMutableDictionary dictionary];
        [fieldDic setObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"value"] forKey:@"isDeleted"];
        [fieldDic setObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"value"] forKey:@"isExpunged"];
        [recordDic setObject:fieldDic forKey:@"fields"];
        [conDic setObject:recordDic forKey:@"record"];
        [postArr addObject:conDic];
    }
    
    [postDic setObject:postArr forKey:@"operations"];
    [postDic setObject:[NSDictionary dictionaryWithObject:@"PrimarySync" forKey:@"zoneName"] forKey:@"zoneID"];
    [postDic setObject:[NSNumber numberWithBool:YES] forKey:@"atomic"];
    
    NSString *postStr = [TempHelper dictionaryToJson:postDic];
    
    if (postStr != nil) {
        @try {
            NSString *pathStr = @"/database/1/com.apple.photos.cloud/production/private/records/modify?remapEnums=true&ckjsBuildVersion=17AProjectDev84&ckjsVersion=2.0.3&getCurrentSyncToken=true&clientBuildNumber=17AHotfix3&clientMasteringNumber=17AHotfix3&dsid=%@";
            NSDictionary *retDic = [_netClient postInformationContent:@"ckdatabasews" withPath:pathStr withPostStr:postStr];
            if (retDic != nil) {
                if ([retDic.allKeys containsObject:@"records"]) {
                    return YES;
                }
            }
        }
        @catch (NSException *exception) {
             [_logHandle writeInfoLog:[NSString stringWithFormat:@"photo delete exception :%@",exception.reason]];
        }
    }
    return NO;
}

- (BOOL)addPhotoAlbum:(NSString *)albumName {
    BOOL ret = NO;
    CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
    NSString *newGuid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
    NSString *pathStr = @"/database/1/com.apple.photos.cloud/production/private/records/modify?remapEnums=true&ckjsBuildVersion=17AProjectDev84&ckjsVersion=2.0.3&getCurrentSyncToken=true&clientBuildNumber=17AHotfix3&clientMasteringNumber=17AHotfix3&dsid=%@";
    
    NSString *postStr = [NSString stringWithFormat:@"{\"operations\":[{\"operationType\":\"create\",\"record\":{\"recordName\":\"%@\",\"recordType\":\"CPLAlbum\",\"recordChangeTag\":null,\"fields\":{\"albumType\":{\"value\":0},\"albumNameEnc\":{\"value\":\"%@\"},\"position\":{\"value\":%@},\"parentId\":{},\"isDeleted\":{\"value\":0},\"isExpunged\":{\"value\":0}}}}],\"zoneID\":{\"zoneName\":\"PrimarySync\"},\"desiredKeys\":[\"albumType\",\"albumNameEnc\",\"name\",\"position\",\"sortType\",\"sortTypeExt\",\"sortAscending\",\"parentId\",\"isDeleted\",\"isExpunged\",\"dateExpunged\",\"remappedRef\",\"recordName\",\"recordType\",\"recordChangeTag\"],\"atomic\":true}",newGuid,[_netClient encode:albumName],@"9007199254739965"];
    
    if (postStr != nil) {
        @try {
            NSDictionary *retDic = [_netClient postInformationContent:@"ckdatabasews" withPath:pathStr withPostStr:postStr];
            if (retDic != nil) {
                if ([retDic.allKeys containsObject:@"records"]) {
                    NSArray *detailArr = [retDic objectForKey:@"records"];
                    for (NSDictionary *conDic in detailArr) {
                        NSString *recordName = @"";
                        if ([conDic.allKeys containsObject:@"recordName"]) {
                            recordName = [conDic objectForKey:@"recordName"];
                        }
                        if ([StringHelper stringIsNilOrEmpty:recordName] || [recordName isEqualToString:@"----Root-Folder----"] || ![recordName isEqualToString:newGuid]) {
                            continue;
                        }
                        IMBToiCloudPhotoEntity *albumEntity = [[IMBToiCloudPhotoEntity alloc] init];
                        if ([conDic.allKeys containsObject:@"created"]) {
                            NSDictionary *createDic = [conDic objectForKey:@"created"];
                            if ([createDic.allKeys containsObject:@"timestamp"]) {
                                long long timestamp = [[createDic objectForKey:@"timestamp"] longLongValue];
                                albumEntity.photoDateData = timestamp / 1000;
                            }
                        }
                        if ([conDic.allKeys containsObject:@"fields"]) {
                            NSDictionary *fieldDic = [conDic objectForKey:@"fields"];
                            if ([fieldDic.allKeys containsObject:@"albumNameEnc"]) {
                                NSDictionary *albumNameDic = [fieldDic objectForKey:@"albumNameEnc"];
                                if ([albumNameDic.allKeys containsObject:@"value"]) {
                                    albumEntity.albumTitle = [_netClient decode:[albumNameDic objectForKey:@"value"]];
                                }
                            }
                            
                            if ([fieldDic.allKeys containsObject:@"albumNameEnc"]) {
                                NSDictionary *deletedDic = [fieldDic objectForKey:@"isDeleted"];
                                if ([deletedDic.allKeys containsObject:@"value"]) {
                                    
                                }
                            }
                            
                            if ([fieldDic.allKeys containsObject:@"albumNameEnc"]) {
                                NSDictionary *expungedDic = [fieldDic objectForKey:@"isExpunged"];
                                if ([expungedDic.allKeys containsObject:@"value"]) {
                                    
                                }
                            }
                        }
                        if ([conDic.allKeys containsObject:@"modified"]) {
                            
                        }
                        if ([conDic.allKeys containsObject:@"recordName"]) {
                            albumEntity.clientId = [conDic objectForKey:@"recordName"];
                            albumEntity.recordName = albumEntity.clientId;
                            albumEntity.iCloudAlbumType = @"CPLContainerRelationLiveByPosition";
                        }
                        if ([conDic.allKeys containsObject:@"recordType"]) {
                            albumEntity.type = [conDic objectForKey:@"recordType"];
                        }
                        if ([conDic.allKeys containsObject:@"recordChangeTag"]) {
                            albumEntity.recordChangeTag = [conDic objectForKey:@"recordChangeTag"];
                        }
                        if ([conDic.allKeys containsObject:@"zoneID"]) {
                            NSDictionary *zoneIDDic = [conDic objectForKey:@"zoneID"];
                            if ([zoneIDDic.allKeys containsObject:@"ownerRecordName"]) {
                                albumEntity.ownerRecordName = [zoneIDDic objectForKey:@"ownerRecordName"];
                            }
                            if ([zoneIDDic.allKeys containsObject:@"zoneName"]) {
                                albumEntity.zoneName = [zoneIDDic objectForKey:@"zoneName"];
                            }
                        }
                    
                        [_albumArray addObject:albumEntity];
                        [albumEntity release];
                        ret = YES;
                    }
                }
                if ([retDic.allKeys containsObject:@"reason"]) {
                    id obj = [retDic objectForKey:@"reason"];
                    if (obj && [obj isKindOfClass:[NSString class]]) {
                        NSString *reason = (NSString *)obj;
                        if ([reason isEqualToString:@"Zone 'PrimarySync' does not exist"]) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:ICLOUD_ZONE_PRIMARYSYNC_NOT_EXIST_ERROR object:nil userInfo:nil];
                            ret = NO;
                        }
                    }
                }
            }
        }
        @catch (NSException *exception) {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"add photo album :%@",exception.reason]];
        }
    }
    return ret;
}

- (BOOL)deletePhotoAlbum:(IMBToiCloudPhotoEntity *)albumEntity {
    BOOL ret = NO;
    NSString *pathStr = @"/database/1/com.apple.photos.cloud/production/private/records/modify?remapEnums=true&ckjsBuildVersion=17AProjectDev84&ckjsVersion=2.0.3&getCurrentSyncToken=true&clientBuildNumber=17AHotfix3&clientMasteringNumber=17AHotfix3&dsid=%@";
    
    NSString *postStr = [NSString stringWithFormat:@"{\"operations\":[{\"operationType\":\"update\",\"record\":{\"recordName\":\"%@\",\"recordType\":\"CPLAlbum\",\"recordChangeTag\":\"%@\",\"fields\":{\"isDeleted\":{\"value\":1}}}}],\"zoneID\":{\"zoneName\":\"PrimarySync\"},\"desiredKeys\":[\"albumType\",\"albumNameEnc\",\"name\",\"position\",\"sortType\",\"sortTypeExt\",\"sortAscending\",\"parentId\",\"isDeleted\",\"isExpunged\",\"dateExpunged\",\"remappedRef\",\"recordName\",\"recordType\",\"recordChangeTag\"],\"atomic\":true}",albumEntity.recordName, albumEntity.recordChangeTag];
    
    if (postStr != nil) {
        @try {
            NSDictionary *retDic = [_netClient postInformationContent:@"ckdatabasews" withPath:pathStr withPostStr:postStr];
            if (retDic != nil) {
                if ([retDic.allKeys containsObject:@"records"]) {
                    NSArray *recoedArr = [retDic objectForKey:@"records"];
                    for (NSDictionary *recordDic in recoedArr) {
                        if ([recordDic.allKeys containsObject:@"recordName"]) {
                            NSString *recordName = [recordDic objectForKey:@"recordName"];
                            if ([[recordName uppercaseString] isEqualToString:[albumEntity.recordName uppercaseString]]) {
                                if ([_albumArray containsObject:albumEntity]) {
                                    [_albumArray removeObject:albumEntity];
                                }
                                ret = YES;
                                break;
                            }
                        }
                    }
                }
            }
        }
        @catch (NSException *exception) {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"delete photo album :%@",exception.reason]];
        }
    }
    
    return ret;
}

- (BOOL)addPhotoToAlbum:(NSArray *)array withContainerId:(NSString *)containerId {
    BOOL ret = NO;
    NSString *pathStr = @"/database/1/com.apple.photos.cloud/production/private/records/modify?remapEnums=true&ckjsBuildVersion=17AProjectDev84&ckjsVersion=2.0.3&getCurrentSyncToken=true&clientBuildNumber=17AHotfix3&clientMasteringNumber=17AHotfix3&dsid=%@";
    
    NSMutableString *postStr = [NSMutableString stringWithString:@"{\"operations\":["];
    for (int i=0;i<array.count;i++) {
        IMBToiCloudPhotoEntity *entity = [array objectAtIndex:i];
        NSString *queryStr = [NSString stringWithFormat:@"{\"operationType\":\"create\",\"record\":{\"recordName\":\"%@-IN-%@\",\"recordType\":\"CPLContainerRelation\",\"fields\":{\"containerId\":{\"value\":\"%@\"},\"itemId\":{\"value\":\"%@\"},\"position\":{\"value\":1024},\"isKeyAsset\":{\"value\":0},\"isDeleted\":{\"value\":0},\"isExpunged\":{\"value\":0},\"dateExpunged\":{}}}}]",entity.clientId,containerId,containerId,entity.clientId];
        [postStr appendString:queryStr];
        if (i == _albumArray.count - 1) {
            [postStr appendString:@"}],"];
        }else {
            [postStr appendString:@","];
        }
    }
    [postStr appendString:@"\"zoneID\":{\"zoneName\":\"PrimarySync\"},\"desiredKeys\":[\"containerId\",\"itemId\",\"position\",\"isKeyAsset\",\"isDeleted\",\"isExpunged\",\"dateExpunged\",\"remappedRef\",\"recordName\",\"recordType\",\"recordChangeTag\"],\"atomic\":true}"];
    
    if (postStr != nil) {
        @try {
            NSDictionary *retDic = [_netClient postInformationContent:@"ckdatabasews" withPath:pathStr withPostStr:postStr];
            if (retDic != nil) {
                if ([retDic.allKeys containsObject:@"records"]) {
                    NSArray *recordArr = [retDic objectForKey:@"records"];
                    for (NSDictionary *dic in recordArr) {
                        if ([dic.allKeys containsObject:@"recordName"]) {
                            NSString *recordName = [dic objectForKey:@"recordName"];
                            if ([recordName contains:containerId]) {
                                ret = YES;
                                break;
                            }
                        }
                    }
                }
                if ([retDic.allKeys containsObject:@"reason"]) {
                    id obj = [retDic objectForKey:@"reason"];
                    if (obj && [obj isKindOfClass:[NSString class]]) {
                        NSString *reason = (NSString *)obj;
                        if ([reason isEqualToString:@"syncToken operations supported only in SyncZone"]) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:ICLOUD_SUPPORTED_ONLY_IN_SYNCZONE_ERROR object:nil userInfo:nil];
                            ret = NO;
                        }
                    }
                }
            }
        }
        @catch (NSException *exception) {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"add photo to album :%@",exception.reason]];
        }
    }
    
    return ret;
}

#pragma mark - Contacts
- (void)getContactContent {
    @try {
        NSDictionary *conDic = [_netClient getInformationContent:@"contacts" withPath:@"/co/startup?dsid=%@&locale=en_US&order=first,last"];
        if (conDic != nil) {
            if ([conDic.allKeys containsObject:@"prefToken"]) {
                if (_contactPrefToken != nil) {
                    [_contactPrefToken release];
                    _contactPrefToken = nil;
                }
                _contactPrefToken = [[conDic objectForKey:@"prefToken"] retain];
            }
            if ([conDic.allKeys containsObject:@"syncToken"]) {
                if (_contactSyncToken != nil) {
                    [_contactSyncToken release];
                    _contactSyncToken = nil;
                }
                _contactSyncToken = [[conDic objectForKey:@"syncToken"] retain];
            }
            //解析联系人内容：
            if (_contactArray != nil) {
                [_contactArray release];
                _contactArray = nil;
            }
            _contactArray = [[NSMutableArray alloc] init];
            [self parseContactDictionary:conDic];
            
            if ([conDic.allKeys containsObject:@"contactsOrder"]) {
                NSArray *orderArr = [conDic objectForKey:@"contactsOrder"];
                int totalCount = (int)orderArr.count;
                if (totalCount > 500) {
                    int offset = 0;
                    while (offset < totalCount)
                    {
                        offset += 500;
                        if (offset > totalCount) {
                            offset = totalCount;
                        }
                        int limit = 500;
                        NSString *pathStr = [NSString stringWithFormat:@"/co/contacts/?clientBuildNumber=17AHotfix1&clientMasteringNumber=17AHotfix1&clientVersion=2.1&%@&limit=%d&offset=%d&prefToken=%@&syncToken=%@",@"dsid=%@",limit,offset,_contactPrefToken,_contactSyncToken];
                        NSDictionary *singleDic = [_netClient getInformationContent:@"contacts" withPath:pathStr];
                        if (singleDic != nil) {
                            [self parseContactDictionary:singleDic];
                        }
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        if ([exception.reason isEqualToString:@"Network fault interrupt"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTITY_NETWORK_FAULT_INTERRUPT object:nil userInfo:nil];
        }
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"contact exception :%@",exception.reason]];
        if (_contactArray) {
            [_contactArray removeAllObjects];
        }
    }
}

- (void)parseContactDictionary:(NSDictionary *)contactDic {
    if ([contactDic.allKeys containsObject:@"contacts"]) {
        NSArray *contactArray = [contactDic objectForKey:@"contacts"];
        for (NSDictionary *dic in contactArray) {
            if (dic != nil) {
                IMBiCloudContactEntity *entity = [[IMBiCloudContactEntity alloc] init];
                if ([dic.allKeys containsObject:@"etag"]) {
                    entity.etag = [dic objectForKey:@"etag"];
                }
                if ([dic.allKeys containsObject:@"contactId"]) {
                    entity.contactId = [dic objectForKey:@"contactId"];
                }
                if ([dic.allKeys containsObject:@"isCompany"]) {
                    entity.isCompany = [[dic objectForKey:@"isCompany"] boolValue];
                }
                if ([dic.allKeys containsObject:@"birthday"]) {
                    NSDate *date = [DateHelper dateFromString:[dic objectForKey:@"birthday"]  Formate:@"yyyy-MM-dd"];
                    entity.birthday = date;
                }
                if ([dic.allKeys containsObject:@"companyName"]) {
                    entity.companyName = [dic objectForKey:@"companyName"];
                }
                if ([dic.allKeys containsObject:@"department"]) {
                    entity.department = [dic objectForKey:@"department"];
                }
                if ([dic.allKeys containsObject:@"phoneticCompanyName"]) {
                    entity.displayAsCompany = [dic objectForKey:@"phoneticCompanyName"];
                }
                if ([dic.allKeys containsObject:@"firstName"]) {
                    entity.firstName = [dic objectForKey:@"firstName"];
                }
                if ([dic.allKeys containsObject:@"phoneticFirstName"]) {
                    entity.firstNameYomi = [dic objectForKey:@"phoneticFirstName"];
                }
                if ([dic.allKeys containsObject:@"jobTitle"]) {
                    entity.jobTitle = [dic objectForKey:@"jobTitle"];
                }
                if ([dic.allKeys containsObject:@"middleName"]) {
                    entity.middleName = [dic objectForKey:@"middleName"];
                }
                if ([dic.allKeys containsObject:@"lastName"]) {
                    entity.lastName = [dic objectForKey:@"lastName"];
                }
                if ([dic.allKeys containsObject:@"phoneticLastName"]) {
                    entity.lastNameYomi = [dic objectForKey:@"phoneticLastName"];
                }
                if ([dic.allKeys containsObject:@"nickName"]) {
                    entity.nickname = [dic objectForKey:@"nickName"];
                }
                if ([dic.allKeys containsObject:@"notes"]) {
                    entity.notes = [dic objectForKey:@"notes"];
                }
                if ([dic.allKeys containsObject:@"suffix"]) {
                    entity.suffix = [dic objectForKey:@"suffix"];
                }
                if ([dic.allKeys containsObject:@"normalized"]) {
                    entity.normalized = [dic objectForKey:@"normalized"];
                }
                if ([dic.allKeys containsObject:@"prefix"]) {
                    entity.prefix = [dic objectForKey:@"prefix"];
                }
                if (entity.lastName == nil) {
                    entity.lastName = @"";
                }
                if (entity.firstName == nil) {
                    entity.firstName = @"";
                }
                entity.fullName = [NSString stringWithFormat:@"%@ %@",entity.lastName,entity.firstName];
                entity.allName = [NSString stringWithFormat:@"%@ %@",entity.lastName,entity.firstName];
                //获取联系人头像
                if ([dic.allKeys containsObject:@"photo"]) {
                    NSDictionary *imageDic = [dic objectForKey:@"photo"];
                    if (imageDic != nil) {
                        if ([imageDic.allKeys containsObject:@"url"]) {
                            entity.imageUrl = [imageDic objectForKey:@"url"];
                            entity.image = [self getPhotoThumbnilDetail:entity.imageUrl];
                        }
                        if ([imageDic.allKeys containsObject:@"signature"]) {
                            entity.imageSign = [imageDic objectForKey:@"signature"];
                        }
                        if ([imageDic.allKeys containsObject:@"crop"]) {
                            NSDictionary *cropDic = [imageDic objectForKey:@"crop"];
                            if (cropDic != nil) {
                                if ([cropDic.allKeys containsObject:@"x"]) {
                                    entity.imageX = [[cropDic objectForKey:@"x"] intValue];
                                }
                                if ([cropDic.allKeys containsObject:@"y"]) {
                                    entity.imageY = [[cropDic objectForKey:@"y"] intValue];
                                }
                                if ([cropDic.allKeys containsObject:@"width"]) {
                                    entity.imageW = [[cropDic objectForKey:@"width"] intValue];
                                }
                                if ([cropDic.allKeys containsObject:@"height"]) {
                                    entity.imageH = [[cropDic objectForKey:@"height"] intValue];
                                }
                            }
                        }
                    }
                }
                
                //dates内容
                if ([dic.allKeys containsObject:@"dates"]) {
                    NSArray *dateArr = [dic objectForKey:@"dates"];
                    for (NSDictionary *dateDic in dateArr) {
                        if (dateDic != nil) {
                            IMBContactKeyValueEntity *dateEntity = [[IMBContactKeyValueEntity alloc] init];
                            dateEntity.contactCategory = Contact_Date;
                            if ([dateDic.allKeys containsObject:@"field"]) {
                                NSDate *date = [DateHelper dateFromString:[dateDic objectForKey:@"field"] Formate:@"yyyy-MM-dd"];
                                dateEntity.value = date;
                            }
                            if ([dateDic.allKeys containsObject:@"label"]) {
                                dateEntity.label = [dateDic objectForKey:@"label"];
                            }
                            [entity.dateArray addObject:dateEntity];
                            [dateEntity release];
                        }
                    }
                }
                
                //phones内容
                if ([dic.allKeys containsObject:@"phones"]) {
                    NSArray *phoneArr = [dic objectForKey:@"phones"];
                    for (NSDictionary *phoneDic in phoneArr) {
                        if (phoneDic != nil) {
                            IMBContactKeyValueEntity *phoneEntity = [[IMBContactKeyValueEntity alloc] init];
                            phoneEntity.contactCategory = Contact_PhoneNumber;
                            if ([phoneDic.allKeys containsObject:@"field"]) {
                                phoneEntity.value = [phoneDic objectForKey:@"field"];
                            }
                            if ([phoneDic.allKeys containsObject:@"label"]) {
                                phoneEntity.label = [phoneDic objectForKey:@"label"];
                            }
                            [entity.phoneNumberArray addObject:phoneEntity];
                            [phoneEntity release];
                        }
                    }
                }
                
                //urls内容
                if ([dic.allKeys containsObject:@"urls"]) {
                    NSArray *urlArr = [dic objectForKey:@"urls"];
                    for (NSDictionary *urlDic in urlArr) {
                        if (urlDic != nil) {
                            IMBContactKeyValueEntity *urlEntity = [[IMBContactKeyValueEntity alloc] init];
                            urlEntity.contactCategory = Contact_URL;
                            if ([urlDic.allKeys containsObject:@"field"]) {
                                urlEntity.value = [urlDic objectForKey:@"field"];
                            }
                            if ([urlDic.allKeys containsObject:@"label"]) {
                                urlEntity.label = [urlDic objectForKey:@"label"];
                            }
                            [entity.urlArray addObject:urlEntity];
                            [urlEntity release];
                        }
                    }
                }
                
                //relatedNames内容
                if ([dic.allKeys containsObject:@"relatedNames"]) {
                    NSArray *relatedArr = [dic objectForKey:@"relatedNames"];
                    for (NSDictionary *relatedDic in relatedArr) {
                        if (relatedDic != nil) {
                            IMBContactKeyValueEntity *relatedEntity = [[IMBContactKeyValueEntity alloc] init];
                            relatedEntity.contactCategory = Contact_RelatedName;
                            if ([relatedDic.allKeys containsObject:@"field"]) {
                                relatedEntity.value = [relatedDic objectForKey:@"field"];
                            }
                            if ([relatedDic.allKeys containsObject:@"label"]) {
                                relatedEntity.label = [relatedDic objectForKey:@"label"];
                            }
                            [entity.relatedNameArray addObject:relatedEntity];
                            [relatedEntity release];
                        }
                    }
                }
                
                //emailAddresses内容
                if ([dic.allKeys containsObject:@"emailAddresses"]) {
                    NSArray *emailArr = [dic objectForKey:@"emailAddresses"];
                    for (NSDictionary *emailDic in emailArr) {
                        if (emailDic != nil) {
                            IMBContactKeyValueEntity *emailEntity = [[IMBContactKeyValueEntity alloc] init];
                            emailEntity.contactCategory = Contact_EmailAddressNumber;
                            if ([emailDic.allKeys containsObject:@"field"]) {
                                emailEntity.value = [emailDic objectForKey:@"field"];
                            }
                            if ([emailDic.allKeys containsObject:@"label"]) {
                                emailEntity.label = [emailDic objectForKey:@"label"];
                            }
                            [entity.emailAddressArray addObject:emailEntity];
                            [emailEntity release];
                        }
                    }
                }
                
                //IMs内容
                if ([dic.allKeys containsObject:@"IMs"]) {
                    NSArray *imArr = [dic objectForKey:@"IMs"];
                    for (NSDictionary *imDic in imArr) {
                        if (imDic != nil) {
                            IMBContactIMEntity *imEntity = [[IMBContactIMEntity alloc] init];
                            imEntity.contactCategory = Contact_IM;
                            if ([imDic.allKeys containsObject:@"field"]) {
                                NSDictionary *fieldDic = [imDic objectForKey:@"field"];
                                if (fieldDic != nil) {
                                    if ([fieldDic.allKeys containsObject:@"IMService"]) {
                                        imEntity.service = [fieldDic objectForKey:@"IMService"];
                                        
                                    }
                                    if ([fieldDic.allKeys containsObject:@"userName"]) {
                                        imEntity.user = [fieldDic objectForKey:@"userName"];
                                    }
                                }
                            }
                            if ([imDic.allKeys containsObject:@"label"]) {
                                imEntity.label = [imDic objectForKey:@"label"];
                            }
                            [entity.IMArray addObject:imEntity];
                            [imEntity release];
                        }
                    }
                }
                
                //streetAddresses内容
                if ([dic.allKeys containsObject:@"streetAddresses"]) {
                    NSArray *streetArr = [dic objectForKey:@"streetAddresses"];
                    for (NSDictionary *streetDic in streetArr) {
                        if (streetDic != nil) {
                            IMBContactAddressEntity *streetEntity = [[IMBContactAddressEntity alloc] init];
                            streetEntity.contactCategory = Contact_StreetAddress;
                            if ([streetDic.allKeys containsObject:@"field"]) {
                                NSDictionary *fieldDic = [streetDic objectForKey:@"field"];
                                if (fieldDic != nil) {
                                    if ([fieldDic.allKeys containsObject:@"city"]) {
                                        streetEntity.city = [fieldDic objectForKey:@"city"];
                                    }
                                    if ([fieldDic.allKeys containsObject:@"country"]) {
                                        streetEntity.country = [fieldDic objectForKey:@"country"];
                                    }
                                    if ([fieldDic.allKeys containsObject:@"postalCode"]) {
                                        streetEntity.postalCode = [fieldDic objectForKey:@"postalCode"];
                                    }
                                    if ([fieldDic.allKeys containsObject:@"countryCode"]) {
                                        streetEntity.countryCode = [fieldDic objectForKey:@"countryCode"];
                                    }
                                    if ([fieldDic.allKeys containsObject:@"state"]) {
                                        streetEntity.state = [fieldDic objectForKey:@"state"];
                                    }
                                    if ([fieldDic.allKeys containsObject:@"street"]) {
                                        streetEntity.street = [fieldDic objectForKey:@"street"];
                                    }
                                }
                            }
                            if ([streetDic.allKeys containsObject:@"label"]) {
                                streetEntity.label = [streetDic objectForKey:@"label"];
                            }
                            [entity.addressArray addObject:streetEntity];
                        }
                    }
                }
                
                //profiles内容
                if ([dic.allKeys containsObject:@"profiles"]) {
                    NSArray *proArr = [dic objectForKey:@"profiles"];
                    for (NSDictionary *proDic in proArr) {
                        if (proDic != nil) {
                            IMBContactIMEntity *proEntity = [[IMBContactIMEntity alloc] init];
                            proEntity.contactCategory = Contact_Profiles;
                            if ([proDic.allKeys containsObject:@"field"]) {
                                proEntity.service  = [proDic objectForKey:@"field"];
                            }
                            if ([proDic.allKeys containsObject:@"user"]) {
                                proEntity.user = [proDic objectForKey:@"user"];
                            }
                            if ([proDic.allKeys containsObject:@"label"]) {
                                proEntity.label = [proDic objectForKey:@"label"];
                            }
                            [entity.profilesArr addObject:proEntity];
                            [proEntity release];
                        }
                    }
                }
                
                [_contactArray addObject:entity];
                [entity release];
            }
        }
    }
}

- (NSDictionary *)objectToJson:(IMBiCloudContactEntity *)entity {
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    if ([entity isMemberOfClass:[IMBiCloudContactEntity class]]) {
        if (![StringHelper stringIsNilOrEmpty:entity.etag]) {
            [dic setObject:entity.etag forKey:@"etag"];
        }
        [dic setObject:[NSNumber numberWithBool:entity.isCompany] forKey:@"isCompany"];
    }
    
    if (![StringHelper stringIsNilOrEmpty:entity.contactId]) {
        [dic setObject:entity.contactId forKey:@"contactId"];
    }
   
    if (entity.birthday != nil) {
        NSString *dateStr = [DateHelper stringFromFomate:entity.birthday formate:@"yyyy-MM-dd"];
        if (![StringHelper stringIsNilOrEmpty:dateStr]) {
            [dic setObject:dateStr forKey:@"birthday"];
        }
    }
    if (![StringHelper stringIsNilOrEmpty:entity.allName]) {
        [dic setObject:entity.allName forKey:@"allName"];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.companyName]) {
        [dic setObject:entity.companyName forKey:@"companyName"];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.department]) {
        [dic setObject:entity.department forKey:@"department"];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.displayAsCompany]) {
        [dic setObject:entity.displayAsCompany forKey:@"phoneticCompanyName"];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.firstName]) {
        [dic setObject:entity.firstName forKey:@"firstName"];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.firstNameYomi]) {
        [dic setObject:entity.firstNameYomi forKey:@"phoneticFirstName"];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.jobTitle]) {
        [dic setObject:entity.jobTitle forKey:@"jobTitle"];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.middleName]) {
        [dic setObject:entity.middleName forKey:@"middleName"];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.lastName]) {
        [dic setObject:entity.lastName forKey:@"lastName"];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.lastNameYomi]) {
        [dic setObject:entity.lastNameYomi forKey:@"phoneticLastName"];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.nickname]) {
        [dic setObject:entity.nickname forKey:@"nickName"];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.notes]) {
        [dic setObject:entity.notes forKey:@"notes"];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.suffix]) {
        [dic setObject:entity.suffix forKey:@"suffix"];
    }
    if ([entity isMemberOfClass:[IMBiCloudContactEntity class]]) {
        if (![StringHelper stringIsNilOrEmpty:entity.normalized]) {
            [dic setObject:entity.normalized forKey:@"normalized"];
        }
    }
    if ([entity isMemberOfClass:[IMBiCloudContactEntity class]]) {
        if (![StringHelper stringIsNilOrEmpty:entity.prefix]) {
            [dic setObject:entity.prefix forKey:@"prefix"];
        }
    }
    
    
    
    //photo
    if ([entity isMemberOfClass:[IMBiCloudContactEntity class]]) {
        if (entity.image != nil) {
            NSMutableDictionary *photoDic = [[[NSMutableDictionary alloc] init] autorelease];
            NSMutableDictionary *cropDic = [[[NSMutableDictionary alloc] init] autorelease];
            [cropDic setObject:[NSNumber numberWithInt:entity.imageX] forKey:@"x"];
            [cropDic setObject:[NSNumber numberWithInt:entity.imageY] forKey:@"y"];
            [cropDic setObject:[NSNumber numberWithInt:entity.imageW] forKey:@"width"];
            [cropDic setObject:[NSNumber numberWithInt:entity.imageH] forKey:@"height"];
            [photoDic setObject:cropDic forKey:@"crop"];
            if (![StringHelper stringIsNilOrEmpty:entity.imageSign]) {
                [photoDic setObject:entity.imageSign forKey:@"signature"];
            }
            NSString *imageUrl = @"data:image/jpeg;base64,";
            NSString *conImage = [IMBHttpWebResponseUtility base64EncodedStringFrom:entity.image];
            imageUrl = [imageUrl stringByAppendingString:conImage];
            if (![StringHelper stringIsNilOrEmpty:imageUrl]) {
                [photoDic setObject:imageUrl forKey:@"url"];
            }
            
            [dic setObject:photoDic forKey:@"photo"];
        }
    }
    
    //dates内容
    if (entity.dateArray != nil && entity.dateArray.count > 0) {
        NSMutableArray *datesArray = [[[NSMutableArray alloc] init] autorelease];
        for (IMBContactKeyValueEntity *dateEntity in entity.dateArray) {
            NSMutableDictionary *datesDic = [[NSMutableDictionary alloc] init];
            if (dateEntity.value != nil) {
                NSString *dateStr = [DateHelper stringFromFomate:dateEntity.value formate:@"yyyy-MM-dd"];
                if (![StringHelper stringIsNilOrEmpty:dateStr]) {
                    [datesDic setObject:dateStr forKey:@"field"];
                }
            }
            if (![StringHelper stringIsNilOrEmpty:dateEntity.label]) {
                [datesDic setObject:dateEntity.label forKey:@"label"];
            }
            [datesArray addObject:datesDic];
            [datesDic release], datesDic = nil;
        }
        [dic setObject:datesArray forKey:@"dates"];
    }

    //phones内容
    if (entity.phoneNumberArray != nil && entity.phoneNumberArray.count > 0) {
        NSMutableArray *phoneArr = [[[NSMutableArray alloc] init] autorelease];
        for (IMBContactKeyValueEntity *phoneEntity in entity.phoneNumberArray) {
            NSMutableDictionary *phoneDic = [[NSMutableDictionary alloc] init];
            if (phoneEntity.value != nil) {
                [phoneDic setObject:phoneEntity.value forKey:@"field"];
            }
            if (![StringHelper stringIsNilOrEmpty:phoneEntity.label]) {
                [phoneDic setObject:phoneEntity.label forKey:@"label"];
            }
            [phoneArr addObject:phoneDic];
            [phoneDic release], phoneDic = nil;
        }
        [dic setObject:phoneArr forKey:@"phones"];
    };

    //urls内容
    if (entity.urlArray != nil && entity.urlArray.count > 0) {
        NSMutableArray *urlArr = [[[NSMutableArray alloc] init] autorelease];
        for (IMBContactKeyValueEntity *urlEntity in entity.urlArray) {
            NSMutableDictionary *urlDic = [[NSMutableDictionary alloc] init];
            if (urlEntity.value != nil) {
                [urlDic setObject:urlEntity.value forKey:@"field"];
            }
            if (![StringHelper stringIsNilOrEmpty:urlEntity.label]) {
                [urlDic setObject:urlEntity.label forKey:@"label"];
            }
            [urlArr addObject:urlDic];
            [urlDic release], urlDic = nil;
        }
        [dic setObject:urlArr forKey:@"urls"];
    }

    //relatedNames内容
    if (entity.relatedNameArray != nil && entity.relatedNameArray.count > 0) {
        NSMutableArray *relatedArr = [[[NSMutableArray alloc] init] autorelease];
        for (IMBContactKeyValueEntity *relatedEntity in entity.relatedNameArray) {
            NSMutableDictionary *relatedDic = [[NSMutableDictionary alloc] init];
            if (relatedEntity.value != nil) {
                [relatedDic setObject:relatedEntity.value forKey:@"field"];
            }
            if (![StringHelper stringIsNilOrEmpty:relatedEntity.label]) {
                [relatedDic setObject:relatedEntity.label forKey:@"label"];
            }
            [relatedArr addObject:relatedDic];
            [relatedDic release], relatedDic = nil;
        }
        [dic setObject:relatedArr forKey:@"relatedNames"];
    }

    //emailAddresses内容
    if (entity.emailAddressArray != nil && entity.emailAddressArray.count > 0) {
        NSMutableArray *emailArr = [[[NSMutableArray alloc] init] autorelease];
        for (IMBContactKeyValueEntity *emailEntity in entity.emailAddressArray) {
            NSMutableDictionary *emailDic = [[NSMutableDictionary alloc] init];
            if (emailEntity.value != nil) {
                [emailDic setObject:emailEntity.value forKey:@"field"];
            }
            if (![StringHelper stringIsNilOrEmpty:emailEntity.label]) {
                [emailDic setObject:emailEntity.label forKey:@"label"];
            }
            [emailArr addObject:emailDic];
            [emailDic release], emailDic = nil;
        }
        [dic setObject:emailArr forKey:@"emailAddresses"];
    }
    
    //IMs内容
    if (entity.IMArray != nil && entity.IMArray.count > 0) {
        NSMutableArray *imArr = [[[NSMutableArray alloc] init] autorelease];
        for (IMBContactIMEntity *imEntity in entity.IMArray) {
            NSMutableDictionary *imDic = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *fieldDic = [[[NSMutableDictionary alloc] init] autorelease];
            if (![StringHelper stringIsNilOrEmpty:imEntity.service]) {
                [fieldDic setObject:imEntity.service forKey:@"IMService"];
            }
            if (![StringHelper stringIsNilOrEmpty:imEntity.user]) {
                [fieldDic setObject:imEntity.user forKey:@"userName"];
            }
            [imDic setObject:fieldDic forKey:@"field"];
            
            if (![StringHelper stringIsNilOrEmpty:imEntity.label]) {
                [imDic setObject:imEntity.label forKey:@"label"];
            }
            [imArr addObject:imDic];
            [imDic release], imDic = nil;
        }
        [dic setObject:imArr forKey:@"IMs"];
    }
    
    //streetAddresses内容
    if (entity.addressArray != nil && entity.addressArray.count > 0) {
        NSMutableArray *streetArr = [[[NSMutableArray alloc] init] autorelease];
        for (IMBContactAddressEntity *addressEntity in entity.addressArray) {
            NSMutableDictionary *streetDic = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *fieldDic = [[[NSMutableDictionary alloc] init] autorelease];
            if (![StringHelper stringIsNilOrEmpty:addressEntity.city]) {
                [fieldDic setObject:addressEntity.city forKey:@"city"];
            }
            if (![StringHelper stringIsNilOrEmpty:addressEntity.country]) {
                [fieldDic setObject:addressEntity.country forKey:@"country"];
            }
            if (![StringHelper stringIsNilOrEmpty:addressEntity.postalCode]) {
                [fieldDic setObject:addressEntity.postalCode forKey:@"postalCode"];
            }
            if (![StringHelper stringIsNilOrEmpty:addressEntity.countryCode]) {
                [fieldDic setObject:addressEntity.countryCode forKey:@"countryCode"];
            }
            if (![StringHelper stringIsNilOrEmpty:addressEntity.state]) {
                [fieldDic setObject:addressEntity.state forKey:@"state"];
            }
            if (![StringHelper stringIsNilOrEmpty:addressEntity.street]) {
                [fieldDic setObject:addressEntity.street forKey:@"street"];
            }
            [streetDic setObject:fieldDic forKey:@"field"];
            if (![StringHelper stringIsNilOrEmpty:addressEntity.label]) {
                [streetDic setObject:addressEntity.label forKey:@"label"];
            }
            [streetArr addObject:streetDic];
            [streetDic release], streetDic = nil;
        }
        [dic setObject:streetArr forKey:@"streetAddresses"];
    }

    
    //profiles内容
    if ([entity isMemberOfClass:[IMBiCloudContactEntity class]]) {
        if (entity.profilesArr != nil && entity.profilesArr.count > 0) {
            NSMutableArray *proArr = [[[NSMutableArray alloc] init] autorelease];
            for (IMBContactIMEntity *proEntity in entity.profilesArr) {
                NSMutableDictionary *proDic = [[NSMutableDictionary alloc] init];
                if (![StringHelper stringIsNilOrEmpty:proEntity.service]) {
                    [proDic setObject:proEntity.service forKey:@"field"];
                }
                if (![StringHelper stringIsNilOrEmpty:proEntity.user]) {
                    [proDic setObject:proEntity.user forKey:@"user"];
                }
                if (![StringHelper stringIsNilOrEmpty:proEntity.label]) {
                    [proDic setObject:proEntity.label forKey:@"label"];
                }
                [proArr addObject:proDic];
                [proDic release], proDic = nil;
            }
            [dic setObject:proArr forKey:@"profiles"];
        }
    }
    //    NSString *jsonStr = [TempHelper dictionaryToJson:dic];
    return dic;
}

- (void)importContact:(NSArray *)array {
    NSString *pathStr = [@"/co/contacts/card/?clientBuildNumber=16HProject79&clientMasteringNumber=16H71&clientVersion=2.1&dsid=%@" stringByAppendingString:[NSString stringWithFormat:@"&prefToken=%@&syncToken=%@",_contactPrefToken,_contactSyncToken]];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *postArr = [[NSMutableArray alloc] init];
    for (int i=0;i<array.count;i++) {
        IMBiCloudContactEntity *entity = [array objectAtIndex:i];
        NSDictionary *jsonDic = [self objectToJson:entity];
        if (jsonDic != nil) {
            [postArr addObject:jsonDic];
        }
    }
    if (postArr != nil) {
        [postDic setObject:postArr forKey:@"contacts"];
    }
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Contact To iCloud" label:Finish transferCount:postArr.count screenView:@"Contact View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [postArr release];
    NSString *postStr = [TempHelper dictionaryToJson:postDic];
    [postDic release];
    if (postStr != nil) {
        @try {
            NSDictionary *conDic = [_netClient postInformationContent:@"contacts" withPath:pathStr withPostStr:postStr];
            [_delegate transfranDic:conDic];
            if (conDic != nil) {
    
//                if ([conDic.allKeys containsObject:@"prefToken"]) {
//                    if (_contactPrefToken != nil) {
//                        [_contactPrefToken release];
//                        _contactPrefToken = nil;
//                    }
//                    _contactPrefToken = [[conDic objectForKey:@"prefToken"] retain];
//                }
//                if ([conDic.allKeys containsObject:@"syncToken"]) {
//                    if (_contactSyncToken != nil) {
//                        [_contactSyncToken release];
//                        _contactSyncToken = nil;
//                    }
//                    _contactSyncToken = [[conDic objectForKey:@"syncToken"] retain];
//                }
            }
        }
        @catch (NSException *exception) {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"import contact exception :%@",exception.reason]];
        }
    }
}

#pragma mark -- 导入Android Contact
- (BOOL)importAndroidContact:(IMBiCloudContactEntity *)entity {
    NSString *pathStr = [@"/co/contacts/card/?clientBuildNumber=16HProject79&clientMasteringNumber=16H71&clientVersion=2.1&dsid=%@" stringByAppendingString:[NSString stringWithFormat:@"&prefToken=%@&syncToken=%@",_contactPrefToken,_contactSyncToken]];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *postArr = [[NSMutableArray alloc] init];
    NSDictionary *jsonDic = [self objectToJson:entity];
    if (jsonDic != nil) {
        [postArr addObject:jsonDic];
    }
    if (postArr != nil) {
        [postDic setObject:postArr forKey:@"contacts"];
    }
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Contact To iCloud" label:Finish transferCount:postArr.count screenView:@"Contact View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [postArr release];
    NSString *postStr = [TempHelper dictionaryToJson:postDic];
    [postDic release];
    if (postStr != nil) {
        @try {
            NSDictionary *conDic = [_netClient postInformationContent:@"contacts" withPath:pathStr withPostStr:postStr];
            if (conDic != nil) {
                if ([conDic isKindOfClass:[NSDictionary class]]) {
                    if ([conDic.allKeys containsObject:@"contacts"]) {
                        NSArray *contacts = [conDic objectForKey:@"contacts"];
                        if (contacts != nil && [contacts isKindOfClass:[NSArray class]]) {
                            for (NSDictionary *singleDic in contacts) {
                                if (singleDic != nil && [singleDic isKindOfClass:[NSDictionary class]]) {
                                    if ([singleDic.allKeys containsObject:@"contactId"]) {
                                        NSString *contactId = [singleDic objectForKey:@"contactId"];
                                        if (contactId != nil && [contactId isEqualToString:entity.contactId]) {
                                            return YES;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        @catch (NSException *exception) {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"import contact exception :%@",exception.reason]];
        }
    }
    return NO;
}

- (void)editContact:(IMBiCloudContactEntity *)entity {
    @try {
        NSString *pathStr = [@"/co/contacts/card/?clientBuildNumber=16HProject79&clientMasteringNumber=16H71&clientVersion=2.1&dsid=10308962048&method=PUT" stringByAppendingString:[NSString stringWithFormat:@"&prefToken=%@&syncToken=%@",_contactPrefToken,_contactSyncToken]];
        
        NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
        NSDictionary *jsonDic = [self objectToJson:entity];
        if (jsonDic != nil) {
            NSArray *jsonArr = [NSArray arrayWithObject:jsonDic];
            if (jsonArr != nil) {
                [postDic setObject:jsonArr forKey:@"contacts"];
            }
        }
        NSString *postStr = [TempHelper dictionaryToJson:postDic];
        [postDic release];
        if (postStr != nil) {
            NSDictionary *conDic = [_netClient postInformationContent:@"contacts" withPath:pathStr withPostStr:postStr];
            if (conDic != nil) {
                if ([conDic.allKeys containsObject:@"prefToken"]) {
                    if (_contactPrefToken != nil) {
                        [_contactPrefToken release];
                        _contactPrefToken = nil;
                    }
                    _contactPrefToken = [[conDic objectForKey:@"prefToken"] retain];
                }
                if ([conDic.allKeys containsObject:@"syncToken"]) {
                    if (_contactSyncToken != nil) {
                        [_contactSyncToken release];
                        _contactSyncToken = nil;
                    }
                    _contactSyncToken = [[conDic objectForKey:@"syncToken"] retain];
                }
            }
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"edit contact exception :%@",exception.reason]];
    }
}

- (void)deleteContact:(NSArray *)array {
    @try {
        NSString *pathStr = [@"/co/contacts/card/?clientBuildNumber=16HProject79&clientMasteringNumber=16H71&clientVersion=2.1&dsid=%@&method=DELETE" stringByAppendingString:[NSString stringWithFormat:@"&prefToken=%@&syncToken=%@",_contactPrefToken,_contactSyncToken]];
//        NSString *postStr = [NSString stringWithFormat:@"{\"contacts\":[{\"contactId\":\"%@\",\"etag\":\"%@\"}]}",contactId,etag];
        NSMutableString *postStr = [NSMutableString stringWithString:@"{\"contacts\":["];
        for (int i=0;i<array.count;i++) {
            IMBiCloudContactEntity *entity = [array objectAtIndex:i];
            NSString *singStr = [NSString stringWithFormat:@"{\"contactId\":\"%@\",\"etag\":\"%@\"}",entity.contactId,entity.etag];
            [postStr appendString:singStr];
            if (i == array.count - 1) {
                [postStr appendString:@"]}"];
            }else {
                [postStr appendString:@","];
            }
        }
        NSDictionary *conDic = [_netClient postInformationContent:@"contacts" withPath:pathStr withPostStr:postStr];
        
        //删除成功后，_contactPrefToken、_contactSyncToken会变化；
        if (conDic != nil) {
            if ([conDic.allKeys containsObject:@"prefToken"]) {
                if (_contactPrefToken != nil) {
                    [_contactPrefToken release];
                    _contactPrefToken = nil;
                }
                _contactPrefToken = [[conDic objectForKey:@"prefToken"] retain];
            }
            if ([conDic.allKeys containsObject:@"syncToken"]) {
                if (_contactSyncToken != nil) {
                    [_contactSyncToken release];
                    _contactSyncToken = nil;
                }
                _contactSyncToken = [[conDic objectForKey:@"syncToken"] retain];
            }
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"delete contact exception :%@",exception.reason]];
    }
}

#pragma mark - Calendar
- (void)getCalendarContent {
    if (_calendarCollectionArray != nil) {
        [_calendarCollectionArray release];
        _calendarCollectionArray = nil;
    }
    _calendarCollectionArray = [[NSMutableArray alloc] init];
    [self getCalendarCollectionContent];
    
    if (_calendarArray != nil) {
        [_calendarArray release];
        _calendarArray = nil;
    }
    _calendarArray = [[NSMutableArray alloc] init];
    [self getSingleCalendarContent];
}

- (void)getCalendarCollectionContent {
    @try {
        //获取的分组；取出对应的ctag值，在删除时需要用到；
        NSDictionary *calColDic = [_netClient getInformationContent:@"calendar" withPath:@"/ca/startup?clientBuildNumber=16GProject81&clientMasteringNumber=16G76&clientVersion=5.1&dsid=%@&endDate=2018-12-31&lang=en-us&requestID=3&startDate=1970-01-01&usertz=US/Pacific"];
        if (calColDic != nil) {
            if ([calColDic.allKeys containsObject:@"Collection"]) {
                NSArray *collArr = [calColDic objectForKey:@"Collection"];
                int i = 1;
                for (NSDictionary *dic in collArr) {
                    if (dic != nil) {
                        IMBiCloudCalendarCollectionEntity *collEntity = [[IMBiCloudCalendarCollectionEntity alloc] init];
                        if ([dic.allKeys containsObject:@"guid"]) {
                            collEntity.guid = [dic objectForKey:@"guid"];
                        }
                        if ([dic.allKeys containsObject:@"title"]) {
                            collEntity.title = [dic objectForKey:@"title"];
                        }
                        if ([dic.allKeys containsObject:@"ctag"]) {
                            collEntity.ctag = [dic objectForKey:@"ctag"];
                        }
                        if ([dic.allKeys containsObject:@"description"]) {
                            collEntity.description = [dic objectForKey:@"description"];
                        }
                        if ([dic.allKeys containsObject:@"color"]) {
                            collEntity.color = [dic objectForKey:@"color"];
                        }
                        collEntity.tag = i;
                        i ++;
                        [_calendarCollectionArray addObject:collEntity];
                        [collEntity release];
                    }
                }
            }
//            if ([calColDic.allKeys containsObject:@"Alarm"]) {
//                if (_alarmDictionary == nil) {
//                    _alarmDictionary = [[NSMutableDictionary alloc] init];
//                }
//                [_alarmDictionary removeAllObjects];
//                NSArray *alrmArray = [calColDic objectForKey:@"Alarm"];
//                for (NSDictionary *alarmDic in alrmArray) {
//                    NSString *pGuid = [alarmDic objectForKey:@"pGuid"];
//                    NSMutableArray *alarmArray = [_alarmDictionary objectForKey:pGuid];
//                    if (alarmArray == nil) {
//                        [_alarmDictionary setObject:[NSMutableArray arrayWithObject:alarmDic] forKey:pGuid];
//                    }else{
//                        [alarmArray addObject:alarmDic];
//                        [_alarmDictionary setObject:alarmArray forKey:pGuid];
//                    }
//                }
//            }
//            
//            if ([calColDic.allKeys containsObject:@"Recurrence"]) {
//                if (_recurrenceDictionary == nil) {
//                    _recurrenceDictionary = [[NSMutableDictionary alloc] init];
//                }
//                [_recurrenceDictionary removeAllObjects];
//                NSArray *recurrenceArray = [calColDic objectForKey:@"Recurrence"];
//                for (NSDictionary *recurrenceDic in recurrenceArray) {
//                    NSString *guid = [recurrenceDic objectForKey:@"guid"];
//                    [_recurrenceDictionary setObject:recurrenceDic forKey:guid];
//                }
//            }
//            
//            if ([calColDic.allKeys containsObject:@"Invitee"]) {
//                if (_inviteeDictionary == nil) {
//                    _inviteeDictionary = [[NSMutableDictionary alloc] init];
//                }
//                [_inviteeDictionary removeAllObjects];
//                NSArray *inviteeArray = [calColDic objectForKey:@"Invitee"];
//                for (NSDictionary *inviteeDic in inviteeArray) {
//                    NSString *guid = [inviteeDic objectForKey:@"guid"];
//                    [_inviteeDictionary setObject:inviteeDic forKey:guid];
//                }
//            }

            
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"Calendar Collection exception :%@",exception.reason]];
    }
}

- (BOOL)getCalendarCollectionContentName:(NSString *)name {
    @try {
        BOOL res = NO;
        //获取的分组；取出对应的ctag值，在删除时需要用到；
        NSDictionary *calColDic = [_netClient getInformationContent:@"calendar" withPath:@"/ca/startup?clientBuildNumber=16GProject81&clientMasteringNumber=16G76&clientVersion=5.1&dsid=%@&endDate=2018-12-31&lang=en-us&requestID=3&startDate=1970-01-01&usertz=US/Pacific"];
        if (calColDic != nil) {
            if ([calColDic.allKeys containsObject:@"Collection"]) {
                NSArray *collArr = [calColDic objectForKey:@"Collection"];
                for (NSDictionary *dic in collArr) {
                    if (dic != nil) {
                        if ([dic.allKeys containsObject:@"title"]) {
                            NSString *calendarTitle = [dic objectForKey:@"title"];
                            if ([calendarTitle isEqualToString:name]) {
                                res = YES;
                                break;
                            }
                        }
                    }
                }
            }
        }
        return res;
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"Calendar Collection exception :%@",exception.reason]];
    }
}

- (void)getSingleCalendarContent {
    @try {
        //calendar events  ----  startDate和endDate跨度为两年；
        NSDictionary *eventsDic = [_netClient getInformationContent:@"calendar" withPath:@"/ca/events?clientBuildNumber=16GProject81&clientMasteringNumber=16G76&clientVersion=5.1&dsid=%@&endDate=2018-12-31&lang=en-us&requestID=4&startDate=1970-01-17&usertz=US/Pacific"];
        if (eventsDic != nil) {
            if ([eventsDic.allKeys containsObject:@"Event"]) {
                NSArray *eventArr = [eventsDic objectForKey:@"Event"];
                for (NSDictionary *eventDic in eventArr) {
                    if (eventDic != nil) {
                        IMBiCloudCalendarEventEntity *entity = [[IMBiCloudCalendarEventEntity alloc] init];
                        entity.icloudManager = self;
                        if ([eventDic.allKeys containsObject:@"allDay"]) {
                            entity.isallDay = [[eventDic objectForKey:@"allDay"] boolValue];
                        }
                        if ([eventDic.allKeys containsObject:@"guid"]) {
                            entity.guid = [eventDic objectForKey:@"guid"];
                        }
                        if ([eventDic.allKeys containsObject:@"title"]) {
                            NSString *summary = [eventDic objectForKey:@"title"];
                            if (![summary isKindOfClass:[NSNull class]]) {
                                entity.summary = summary;
                            }
                        }
                        if ([eventDic.allKeys containsObject:@"location"]) {
                            NSString *location = [eventDic objectForKey:@"location"];
                            if (![location isKindOfClass:[NSNull class]]) {
                                entity.location = location;
                            }
                        }
                        if ([eventDic.allKeys containsObject:@"duration"]) {
                            entity.duration = [[eventDic objectForKey:@"duration"] intValue];
                        }
                        if ([eventDic.allKeys containsObject:@"pGuid"]) {
                            entity.pGuid = [eventDic objectForKey:@"pGuid"];
                        }
                        if ([eventDic.allKeys containsObject:@"eventStatus"]) {
                            NSString *eventStatus = [eventDic objectForKey:@"eventStatus"];
                            if (![eventStatus isKindOfClass:[NSNull class]]) {
                                entity.eventStatus = eventStatus;
                            }
                        }
                        if ([eventDic.allKeys containsObject:@"etag"]) {
                            entity.etag = [eventDic objectForKey:@"etag"];
                        }
                        if ([eventDic.allKeys containsObject:@"localStartDate"]) {
                            NSArray *dateArr = [eventDic objectForKey:@"localStartDate"];
                            if ([dateArr isKindOfClass:[NSArray class]]) {
                                NSString *dateStr = [self dateArrayToDateString:dateArr];
                                if (dateStr != nil) {
                                    entity.startdate = dateStr;
                                    NSDate *date = [DateHelper dateFromString:dateStr Formate:@"yyyy-MM-dd HH:mm:ss"];
                                    entity.localStartTime = [DateHelper getTimeStampFrom1970Date:date];
                                }
                            }
                        }
                        if ([eventDic.allKeys containsObject:@"localEndDate"]) {
                            NSArray *dateArr = [eventDic objectForKey:@"localEndDate"];
                            if ([dateArr isKindOfClass:[NSArray class]]) {
                                NSString *dateStr = [self dateArrayToDateString:dateArr];
                                if (dateStr != nil) {
                                    entity.enddate = dateStr;
                                    NSDate *date = [DateHelper dateFromString:dateStr Formate:@"yyyy-MM-dd HH:mm:ss"];
                                    entity.localEndTime = [DateHelper getTimeStampFrom1970Date:date];
                                }
                            }
                        }
                        if ([eventDic.allKeys containsObject:@"alarms"]) {
                            [entity setAlarm:[eventDic objectForKey:@"alarms"]];
                        }
                        if ([eventDic.allKeys containsObject:@"invitees"]) {
                            [entity setInvitees:[eventDic objectForKey:@"invitees"]];
                        }
                        if ([eventDic.allKeys containsObject:@"extendedDetailsAreIncluded"]) {
                            entity.extendedDetailsAreIncluded = [[eventDic objectForKey:@"extendedDetailsAreIncluded"] intValue];
                        }
                        if ([eventDic.allKeys containsObject:@"hasAttachments"]) {
                            entity.hasAttachments = [[eventDic objectForKey:@"hasAttachments"] boolValue];
                        }
                        if ([eventDic.allKeys containsObject:@"icon"]) {
                            entity.icon = [[eventDic objectForKey:@"icon"] intValue];
                        }
                        if ([eventDic.allKeys containsObject:@"readOnly"]) {
                            entity.readOnly = [[eventDic objectForKey:@"readOnly"] intValue];
                        }
                        if ([eventDic.allKeys containsObject:@"recurrenceException"]) {
                            entity.recurrenceException = [[eventDic objectForKey:@"recurrenceException"] intValue];
                        }
                        if ([eventDic.allKeys containsObject:@"recurrenceMaster"]) {
                            entity.recurrenceMaster = [[eventDic objectForKey:@"recurrenceMaster"] intValue];
                        }
                        if ([eventDic.allKeys containsObject:@"shouldShowJunkUIWhenAppropriate"]) {
                            entity.shouldShowJunkUIWhenAppropriate = [[eventDic objectForKey:@"shouldShowJunkUIWhenAppropriate"] intValue];
                        }
                        if ([eventDic.allKeys containsObject:@"tz"]) {
                            entity.tz = [eventDic objectForKey:@"tz"];
                        }
                        if ([eventDic.allKeys containsObject:@"recurrence"]) {
                            entity.recurrence = [eventDic objectForKey:@"recurrence"];
                        }
                        if ([eventDic.allKeys containsObject:@"startDate"]) {
                            NSArray *dateArr = [eventDic objectForKey:@"startDate"];
                            if ([dateArr isKindOfClass:[NSArray class]]) {
                                NSString *dateStr = [self dateArrayToDateString:dateArr];
                                if (dateStr != nil) {
                                    NSDate *date = [DateHelper dateFromString:dateStr Formate:@"yyyy-MM-dd HH:mm:ss"];
                                    entity.startCalTime = [DateHelper getTimeStampFrom1970Date:date];
                                }
                            }
                        }
                        if ([eventDic.allKeys containsObject:@"endDate"]) {
                            NSArray *dateArr = [eventDic objectForKey:@"endDate"];
                            if ([dateArr isKindOfClass:[NSArray class]]) {
                                NSString *dateStr = [self dateArrayToDateString:dateArr];
                                if (dateStr != nil) {
                                    NSDate *date = [DateHelper dateFromString:dateStr Formate:@"yyyy-MM-dd HH:mm:ss"];
                                    entity.endCalTime = [DateHelper getTimeStampFrom1970Date:date];
                                }
                            }
                        }
                        [_calendarArray addObject:entity];
                        for (IMBiCloudCalendarCollectionEntity *collectionEntity in _calendarCollectionArray) {
                            if ([collectionEntity.title isEqualToString:@"PC Sync"]) {
                                NSLog(@"");
                            }
                            if ([collectionEntity.guid isEqualToString:entity.pGuid]) {
                                [collectionEntity.subArray addObject:entity];
                                entity.groupTitle = collectionEntity.title;
                                break;
                            }
                        }
                        [entity release];
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        if ([exception.reason isEqualToString:@"Network fault interrupt"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTITY_NETWORK_FAULT_INTERRUPT object:nil userInfo:nil];
        }
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"Calendar exception :%@",exception.reason]];
    }
}


- (BOOL)addCalender:(IMBiCloudCalendarEventEntity *)calendarEvent
{
//测试使用
//    calendarEvent.summary = @"luoleiluoleiluolei22";
//    calendarEvent.url = @"www.baidu.com";
//    calendarEvent.eventdescription = @"jjjjjj";
//    CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
//    NSString *guid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
//    calendarEvent.guid = guid;
    BOOL success = NO;
    IMBiCloudCalendarCollectionEntity *collection = nil;
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *collDic = [self createCalenderCollentionDic:calendarEvent Collection:&collection];
    if (collDic != nil) {
        [postDic setObject:collDic forKey:@"ClientState"];
    }
    NSMutableDictionary *calendardic = [self createEventDic:calendarEvent];
    if (calendardic != nil) {
        [postDic setObject:calendardic forKey:@"Event"];
    }
    NSString *postStr = [TempHelper dictionaryToJson:postDic];
    [postDic release];
    NSString *pathStr = [NSString stringWithFormat:@"/ca/events/%@/%@?clientBuildNumber=16HHotfix4&clientMasteringNumber=16HHotfix4&clientVersion=5.1&%@&lang=en-us&usertz=US/Pacific",collection.guid,calendarEvent.guid,@"dsid=%@"];
    if (postStr != nil) {
        @try {
            NSDictionary *retDic = [_netClient postInformationContent:@"calendar" withPath:pathStr withPostStr:postStr];
            if (retDic != nil) {
                if ([retDic.allKeys containsObject:@"ChangeSet"]) {
                    NSDictionary *changeDic = [retDic objectForKey:@"ChangeSet"];
                    if (changeDic != nil) {
                        if ([changeDic.allKeys containsObject:@"updates"]) {
                            NSDictionary *upDic = [changeDic objectForKey:@"updates"];
                            if ([upDic.allKeys containsObject:@"Event"]) {
                                NSArray *eventArray = [upDic objectForKey:@"Event"];
                                for (NSDictionary *dic in eventArray) {
                                    if([dic.allKeys containsObject:@"guid"]) {
                                        if ([[dic objectForKey:@"guid"] isEqualToString:calendarEvent.guid]) {
                                            success = YES;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        @catch (NSException *exception) {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"deleteCalender exception:%@",exception]];
        }
        @finally {
        }
    }
    return success;
}

- (NSMutableDictionary *)createCalenderCollentionDic:(IMBiCloudCalendarEventEntity *)entity Collection:(IMBiCloudCalendarCollectionEntity **)Collection
{
    NSMutableDictionary *collectionDic = [[NSMutableDictionary alloc] init];
    for (IMBiCloudCalendarCollectionEntity *collection in  _calendarCollectionArray) {
        if ([collection.guid isKindOfClass:[NSNull class]]) {
            continue;
        }
        if ([collection.guid.lowercaseString isEqualToString:entity.pGuid.lowercaseString]) {
            *Collection = collection;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (![StringHelper stringIsNilOrEmpty:collection.guid]) {
                [dic setObject:collection.guid forKey:@"guid"];
            }
            if (![StringHelper stringIsNilOrEmpty:collection.ctag]) {
                [dic setObject:collection.ctag forKey:@"ctag"];
            }
            [collectionDic setObject:[NSArray arrayWithObject:dic] forKey:@"Collections"];
            [collectionDic setObject:[NSNumber numberWithBool:false] forKey:@"fullState"];
            [collectionDic setObject:[NSNumber numberWithLong:1234567890] forKey:@"userTime"];
            [collectionDic setObject:[NSNumber numberWithLong:60] forKey:@"alarmRange"];
            break;
        }
    }
    if (*Collection == nil) {
        if (_calendarCollectionArray.count > 0) {
            *Collection = [_calendarCollectionArray objectAtIndex:0];
        }
    }
    return [collectionDic autorelease];
}

- (BOOL)loadCalendarDetailContent:(IMBiCloudCalendarEventEntity *)entity
{
    BOOL success = NO;
    if (!entity.addDetailContent) {
        NSString *path = [NSString stringWithFormat:@"/ca/eventdetail/%@/%@?clientBuildNumber=16HHotfix4&clientMasteringNumber=16HHotfix4&clientVersion=5.1%@",entity.pGuid,entity.guid,@"&dsid=%@&lang=en-us&usertz=US/Pacific"];
        @try {
            NSDictionary *singleCalDic = [_netClient getInformationContent:@"calendar" withPath:path];
            if ([singleCalDic.allKeys containsObject:@"Recurrence"]) {
                entity.Recurrences = [singleCalDic objectForKey:@"Recurrence"];
            }
            if ([singleCalDic.allKeys containsObject:@"Invitee"]) {
                entity.Invitee = [singleCalDic objectForKey:@"Invitee"];
            }
            if ([singleCalDic.allKeys containsObject:@"Alarm"]) {
                entity.Alarms = [singleCalDic objectForKey:@"Alarm"];
            }
            
            if ([singleCalDic.allKeys containsObject:@"Event"]) {
                entity.addDetailContent = YES;
                success = YES;
                NSArray *eventArray = [singleCalDic objectForKey:@"Event"];
                if ([eventArray count]>0) {
                    NSDictionary *eventDic = [eventArray objectAtIndex:0];
                    id url = [eventDic objectForKey:@"url"];
                    if (![url isKindOfClass:[NSNull class]]) {
                        [entity setUrl:url];
                    }
                    id description = [eventDic objectForKey:@"description"];
                    if (![description isKindOfClass:[NSNull class]]) {
                        [entity setEventdescription:description];
                    }
                }
            }
        }
        @catch (NSException *exception) {
            [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"loadCalendarDetailContent :exception %@",exception]];
        }
        @finally {
            
        }
    }
    return success;
}

- (NSMutableDictionary *)createEventDic:(IMBiCloudCalendarEventEntity *)entity
{
    NSMutableDictionary *entDic = [[NSMutableDictionary alloc] init];
    if (![StringHelper stringIsNilOrEmpty:entity.guid]) {
        [entDic setObject:entity.guid forKey:@"guid"];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.pGuid]) {
        [entDic setObject:entity.pGuid forKey:@"pGuid"];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.etag]) {
        [entDic setObject:entity.etag forKey:@"etag"];
    }
    [entDic setObject:[NSNumber numberWithBool:entity.extendedDetailsAreIncluded] forKey:@"extendedDetailsAreIncluded"];
    [entDic setObject:entity.alarm?:[NSArray array] forKey:@"alarms"];
    [entDic setObject:entity.invitees?:[NSArray array] forKey:@"invitees"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    {
        NSDateComponents *selfCmps = [calendar components:unit fromDate:[DateHelper dateFrom1970:entity.lastModifiedTime]];
        NSInteger year = selfCmps.year;
        NSInteger month = selfCmps.month;
        NSInteger day = selfCmps.day;
        NSInteger hour = selfCmps.hour;
        NSInteger minute = selfCmps.minute;
        if (month<10&&day<10) {
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d0%d0%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"lastModifiedDate"];
        }else if (month<10&&day>=10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d0%d%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"lastModifiedDate"];
        }else if (month>=10&&day<10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d%d0%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"lastModifiedDate"];
        }else if (month>=10&&day>=10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d%d%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"lastModifiedDate"];
        }
    }
    
    {
        NSDateComponents *selfCmps = [calendar components:unit fromDate:[DateHelper dateFrom1970:entity.createdTime]];
        NSInteger year = selfCmps.year;
        NSInteger month = selfCmps.month;
        NSInteger day = selfCmps.day;
        NSInteger hour = selfCmps.hour;
        NSInteger minute = selfCmps.minute;
        if (month<10&&day<10) {
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d0%d0%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"createdDate"];
        }else if (month<10&&day>=10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d0%d%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"createdDate"];
        }else if (month>=10&&day<10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d%d0%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"createdDate"];
        }else if (month>=10&&day>=10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d%d%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"createdDate"];
        }
    }
    
    {
        NSDateComponents *selfCmps = [calendar components:unit fromDate:[NSDate date]];
        NSInteger year = selfCmps.year;
        NSInteger month = selfCmps.month;
        NSInteger day = selfCmps.day;
        NSInteger hour = selfCmps.hour;
        NSInteger minute = selfCmps.minute;
        if (month<10&&day<10) {
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d0%d0%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"updatedByDate"];
        }else if (month<10&&day>=10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d0%d%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"updatedByDate"];
        }else if (month>=10&&day<10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d%d0%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"updatedByDate"];
        }else if (month>=10&&day>=10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d%d%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"updatedByDate"];
        }
    }
    {
        NSDateComponents *selfCmps = [calendar components:unit fromDate:[DateHelper dateFrom1970:entity.endCalTime]];
        NSInteger year = selfCmps.year;
        NSInteger month = selfCmps.month;
        NSInteger day = selfCmps.day;
        NSInteger hour = selfCmps.hour;
        NSInteger minute = selfCmps.minute;
        if (month<10&&day<10) {
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d0%d0%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"endDate"];
        }else if (month<10&&day>=10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d0%d%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"endDate"];
        }else if (month>=10&&day<10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d%d0%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"endDate"];
        }else if (month>=10&&day>=10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d%d%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"endDate"];
        }

    }
    
    {
        NSDateComponents *selfCmps = [calendar components:unit fromDate:[DateHelper dateFrom1970:entity.startCalTime]];
        NSInteger year = selfCmps.year;
        NSInteger month = selfCmps.month;
        NSInteger day = selfCmps.day;
        NSInteger hour = selfCmps.hour;
        NSInteger minute = selfCmps.minute;
        if (month<10&&day<10) {
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d0%d0%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"startDate"];
        }else if (month<10&&day>=10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d0%d%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"startDate"];
        }else if (month>=10&&day<10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d%d0%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"startDate"];
        }else if (month>=10&&day>=10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d%d%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"startDate"];
        }

    }
    
    {
        NSDateComponents *selfCmps = [calendar components:unit fromDate:[DateHelper dateFrom1970:entity.localStartTime]];
        NSInteger year = selfCmps.year;
        NSInteger month = selfCmps.month;
        NSInteger day = selfCmps.day;
        NSInteger hour = selfCmps.hour;
        NSInteger minute = selfCmps.minute;
        
        if (month<10&&day<10) {
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d0%d0%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"localStartDate"];
        }else if (month<10&&day>=10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d0%d%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"localStartDate"];
        }else if (month>=10&&day<10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d%d0%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"localStartDate"];
        }else if (month>=10&&day>=10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d%d%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"localStartDate"];
        }
    }

    {
        NSDateComponents *selfCmps = [calendar components:unit fromDate:[DateHelper dateFrom1970:entity.localEndTime]];
        NSInteger year = selfCmps.year;
        NSInteger month = selfCmps.month;
        NSInteger day = selfCmps.day;
        NSInteger hour = selfCmps.hour;
        NSInteger minute = selfCmps.minute;
        
        if (month<10&&day<10) {
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d0%d0%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"localEndDate"];
        }else if (month<10&&day>=10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d0%d%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"localEndDate"];
        }else if (month>=10&&day<10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d%d0%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"localEndDate"];
        }else if (month>=10&&day>=10){
            [entDic setObject:[NSArray arrayWithObjects:@([[NSString stringWithFormat:@"%d%d%d",year,month,day] longLongValue]),@(year),@(month),@(day),@(hour),@(minute),@(0),nil] forKey:@"localEndDate"];
        }

    }
    [entDic setObject:[NSNumber numberWithBool:entity.isallDay] forKey:@"allDay"];
    [entDic setObject:[NSNumber numberWithInt:entity.duration] forKey:@"duration"];
    if (![StringHelper stringIsNilOrEmpty:entity.eventStatus]) {
        [entDic setObject:entity.eventStatus forKey:@"eventStatus"];
    }
    [entDic setObject:[NSNumber numberWithBool:entity.hasAttachments] forKey:@"hasAttachments"];
    [entDic setObject:[NSNumber numberWithInt:entity.icon] forKey:@"icon"];
    if (![StringHelper stringIsNilOrEmpty:entity.location]) {
        [entDic setObject:entity.location forKey:@"location"];
    }
    
    [entDic setObject:[NSNumber numberWithBool:entity.readOnly] forKey:@"readOnly"];
    if (![StringHelper stringIsNilOrEmpty:entity.recurrence]) {
        [entDic setObject:entity.recurrence forKey:@"recurrence"];
    }
    [entDic setObject:[NSNumber numberWithInt:entity.recurrenceException] forKey:@"recurrenceException"];
    [entDic setObject:[NSNumber numberWithInt:entity.recurrenceMaster] forKey:@"recurrenceMaster"];
    [entDic setObject:[NSNumber numberWithInt:entity.shouldShowJunkUIWhenAppropriate] forKey:@"shouldShowJunkUIWhenAppropriate"];

    if (![StringHelper stringIsNilOrEmpty:entity.summary]) {
        [entDic setObject:entity.summary forKey:@"title"];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.tz]) {
        [entDic setObject:entity.tz forKey:@"tz"];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.eventdescription]) {
        [entDic setObject:entity.eventdescription forKey:@"description"];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.url]) {
        [entDic setObject:entity.url forKey:@"url"];
    }
    return [entDic autorelease];
}

- (BOOL)deleteCalender:(IMBiCloudCalendarEventEntity *)calendarEvent
{
    BOOL success = NO;
    IMBiCloudCalendarCollectionEntity *collection = nil;
    NSString *pathStr = [NSString stringWithFormat:@"/ca/events/%@/%@?clientBuildNumber=16HHotfix4&clientMasteringNumber=16HHotfix4&clientVersion=5.1&%@&ifMatch=%@&lang=en-us&methodOverride=DELETE&usertz=US/Pacific",calendarEvent.pGuid,calendarEvent.guid,@"dsid=%@",calendarEvent.etag];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *collDic = [self createCalenderCollentionDic:calendarEvent Collection:&collection];
    if (collDic != nil) {
        [postDic setObject:collDic forKey:@"ClientState"];
    }
    [postDic setObject:[NSDictionary dictionary] forKey:@"Event"];
    NSString *postStr = [TempHelper dictionaryToJson:postDic];
    [postDic release];
    if (postStr != nil) {
        @try {
            NSDictionary *retDic = [_netClient postInformationContent:@"calendar" withPath:pathStr withPostStr:postStr];
            if (retDic != nil) {
                if ([retDic.allKeys containsObject:@"ChangeSet"]) {
                    success = YES;
                    NSDictionary *ChangeSet = [retDic objectForKey:@"ChangeSet"];
                    NSDictionary *updates = [ChangeSet objectForKey:@"updates"];
                    NSArray *Collection = [updates objectForKey:@"Collection"];
                    if ([Collection count]>=1) {
                        NSDictionary *dic = [Collection objectAtIndex:0];
                        [collection setGuid:[dic objectForKey:@"guid"]];
                        [collection setCtag:[dic objectForKey:@"ctag"]];
                    }
                }
            }
        }
        @catch (NSException *exception) {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"deleteCalender exception:%@",exception]];
        }
    }
    return success;
}
- (BOOL)editCalender:(IMBiCloudCalendarEventEntity *)calendarEvent
{
    IMBiCloudCalendarCollectionEntity *collection = nil;
    BOOL success = NO;
    NSString *pathStr = nil;
    if ([calendarEvent.guid containsString:@"__"]|| calendarEvent.guid.length > 36) {
        pathStr = [NSString stringWithFormat:@"/ca/events/%@/%@/this?clientBuildNumber=17AProject101&clientMasteringNumber=17A77&clientVersion=5.1&%@&ifMatch=%@&lang=zh-cn&methodOverride=PUT&usertz=US/Pacific",calendarEvent.pGuid,calendarEvent.guid,@"dsid=%@",calendarEvent.etag];
    }else{
        pathStr = [NSString stringWithFormat:@"/ca/events/%@/%@?clientBuildNumber=17AProject101&clientMasteringNumber=17A77&clientVersion=5.1&%@&ifMatch=%@&lang=zh-cn&methodOverride=PUT&usertz=US/Pacific",calendarEvent.pGuid,calendarEvent.guid,@"dsid=%@",calendarEvent.etag];
    }
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *collDic = [self createCalenderCollentionDic:calendarEvent Collection:&collection];
    if (collDic != nil) {
        [postDic setObject:collDic forKey:@"ClientState"];
    }
    NSMutableDictionary *calendardic = [self createEventDic:calendarEvent];
    if (calendardic != nil) {
        [postDic setObject:calendardic forKey:@"Event"];
    }
    if (calendarEvent.Recurrences != nil) {
        [postDic setObject:calendarEvent.Recurrences forKey:@"Recurrence"];

    }
    if (calendarEvent.Invitee != nil) {
        [postDic setObject:calendarEvent.Invitee forKey:@"Invitee"];
    }
    if (calendarEvent.Alarms != nil) {
        [postDic setObject:calendarEvent.Alarms forKey:@"Alarm"];
    }
    NSString *postStr = [TempHelper dictionaryToJson:postDic];
    [postDic release];
    if (postStr != nil) {
        @try {
            NSDictionary *retDic = [_netClient postInformationContent:@"calendar" withPath:pathStr withPostStr:postStr];
            if (retDic != nil) {
                if ([retDic.allKeys containsObject:@"ChangeSet"]) {
                    success = YES;
                }
            }
        }
        @catch (NSException *exception) {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"editCalender exception:%@",exception]];
        }
    }
    return success;
}

- (BOOL)addCalenderCollection:(NSString *)collectionName {
    BOOL ret = NO;
    NSDate *dateTime = [NSDate date];
    NSString *startDate = [DateHelper stringFromFomate:dateTime formate:@"yyyy-MM-dd"];
    
    NSDate *dateTime2 = [dateTime dateByAddingTimeInterval:5184000];
    NSString *endDate = [DateHelper stringFromFomate:dateTime2 formate:@"yyyy-MM-dd"];
    CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
    NSString *newGuid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
    NSString *pathStr = [NSString stringWithFormat:@"/ca/collections/%@?clientBuildNumber=17AProject101&clientMasteringNumber=17A77&clientVersion=5.1&%@&endDate=%@&lang=en-us&startDate=%@&usertz=US/Pacific", newGuid, @"dsid=%@", endDate, startDate];
    
    int collectionCount = _calendarCollectionArray != nil ? (int)_calendarCollectionArray.count : 0;
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *collDic = [NSMutableDictionary dictionary];
    [collDic setObject:[NSArray array] forKey:@"Collection"];
    [collDic setObject:[NSNumber numberWithBool:NO] forKey:@"fullState"];
    [collDic setObject:[NSNumber numberWithInt:1234567890] forKey:@"userTime"];
    [collDic setObject:[NSNumber numberWithInt:60] forKey:@"alarmRange"];
    if (collDic != nil) {
        [postDic setObject:collDic forKey:@"ClientState"];
    }
    NSMutableDictionary *entDic = [NSMutableDictionary dictionary];
    [entDic setObject:@"Event" forKey:@"supportedType"];
    [entDic setObject:[NSNumber numberWithBool:YES] forKey:@"extendedDetailsAreIncluded"];
    [entDic setObject:[NSNumber numberWithInt:collectionCount + 1] forKey:@"order"];
    [entDic setObject:@"green" forKey:@"symbolicColor"];
    [entDic setObject:@"#65db39" forKey:@"color"];
    [entDic setObject:newGuid forKey:@"guid"];
    [entDic setObject:collectionName forKey:@"title"];
    [entDic setObject:[NSNull null] forKey:@"participants"];
    [entDic setObject:[NSNull null] forKey:@"meAsParticipant"];
    [entDic setObject:[NSNull null] forKey:@"deferLoading"];
    [entDic setObject:[NSNull null] forKey:@"shareType"];
    [entDic setObject:[NSNull null] forKey:@"etag"];
    [entDic setObject:[NSNull null] forKey:@"ctag"];
    [entDic setObject:@"" forKey:@"shareTitle"];
    [entDic setObject:@"personal" forKey:@"objectType"];
    [entDic setObject:[NSNull null] forKey:@"readOnly"];
    [entDic setObject:[NSNull null] forKey:@"lastModifiedDate"];
    [entDic setObject:[NSNull null] forKey:@"description"];
    [entDic setObject:[NSNull null] forKey:@"sharedUrl"];
    [entDic setObject:[NSNull null] forKey:@"ignoreAlarms"];
    [entDic setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
    [entDic setObject:[NSNull null] forKey:@"ignoreEventUpdates"];
    [entDic setObject:[NSNull null] forKey:@"emailNotification"];
    [entDic setObject:[NSNull null] forKey:@"removeTodos"];
    [entDic setObject:[NSNull null] forKey:@"removeAlarms"];
    [entDic setObject:[NSNull null] forKey:@"isDefault"];
    [entDic setObject:[NSNull null] forKey:@"prePublishedUrl"];
    [entDic setObject:[NSNull null] forKey:@"publishedUrl"];
    [entDic setObject:[NSNull null] forKey:@"isFamily"];
    
    if (entDic != nil) {
        [postDic setObject:entDic forKey:@"Collection"];
    }
    NSString *postStr = [TempHelper dictionaryToJson:postDic];
    [postDic release];
    
    if (postStr != nil) {
        @try {
            NSDictionary *retDic = [_netClient postInformationContent:@"calendar" withPath:pathStr withPostStr:postStr];
            if (retDic != nil) {
                if ([retDic.allKeys containsObject:@"guid"]) {
                    if ([[retDic objectForKey:@"guid"] isEqualToString:newGuid]) {
                        IMBiCloudCalendarCollectionEntity *entity = [[IMBiCloudCalendarCollectionEntity alloc] init];
                        entity.title = collectionName;
                        entity.guid = newGuid;
                        if ([retDic.allKeys containsObject:@"ctag"]) {
                            entity.ctag = [retDic objectForKey:@"ctag"];
                        }
                        entity.tag = _calendarCollectionArray.count + 1;
                        if (_calendarCollectionArray == nil) {
                            _calendarCollectionArray = [[NSMutableArray alloc] init];
                        }
                        [_calendarCollectionArray addObject:entity];
                        [entity release], entity = nil;
                        ret = YES;
                    }
                }
            }
        }
        @catch (NSException *exception) {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"add Calender Collection :%@",exception.reason]];
        }
    }
    
    return ret;
}

- (BOOL)deleteCalenderCollection:(IMBiCloudCalendarCollectionEntity *)entity {
    BOOL ret = NO;
    NSDate *dateTime = [NSDate date];
    NSString *startDate = [DateHelper stringFromFomate:dateTime formate:@"yyyy-MM-dd"];
    
    NSDate *dateTime2 = [dateTime dateByAddingTimeInterval:5184000];
    NSString *endDate = [DateHelper stringFromFomate:dateTime2 formate:@"yyyy-MM-dd"];
    NSString *pathStr = [NSString stringWithFormat:@"/ca/collections/%@?clientBuildNumber=17AProject101&clientMasteringNumber=17A77&clientVersion=5.1&%@&endDate=%@&lang=en-us&methodOverride=DELETE&requestID=8&startDate=%@&usertz=US/Pacific", entity.guid, @"dsid=%@", endDate, startDate];
    
    NSString *postStr = @"{}";
    if (postStr != nil) {
        @try {
            [_netClient postInformationContent:@"calendar" withPath:pathStr withPostStr:postStr];
            [_calendarCollectionArray removeObject:entity];
            ret = YES;
        }
        @catch (NSException *exception) {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"add Calender Collection :%@",exception.reason]];
        }
    }
    
    return ret;
}

#pragma mark - Reminder

- (void)getReminderContent {
    if (_reminderCollectionArray != nil) {
        [_reminderCollectionArray release];
        _reminderCollectionArray = nil;
    }
    _reminderCollectionArray = [[NSMutableArray alloc] init];
    if (_reminderArray != nil) {
        [_reminderArray release];
        _reminderArray = nil;
    }
    _reminderArray = [[NSMutableArray alloc] init];
    [self getNoCompleteReminderContent];
    [self getCompleteReminderContent];
}

//获得的是reminder list 和  未完成的reminder事件
- (void)getNoCompleteReminderContent {
    @try {
        NSDictionary *remDic = [_netClient getInformationContent:@"reminders" withPath:@"/rd/startup?clientBuildNumber=16GProject72&clientMasteringNumber=16G76&clientVersion=4.0&dsid=%@&lang=en-us&usertz=US/Pacific"];
        NSLog(@"-----------%@--------------",remDic);
        if (remDic != nil) {
            if ([remDic.allKeys containsObject:@"Collections"]) {
                NSArray *collArr = [remDic objectForKey:@"Collections"];
                int i = 0;
                for (NSDictionary *dic in collArr) {
                    if (dic != nil) {
                        i ++;
                        IMBiCloudCalendarCollectionEntity *collEntity = [[IMBiCloudCalendarCollectionEntity alloc] init];
                        collEntity.tag = i;
                        if ([dic.allKeys containsObject:@"guid"]) {
                            collEntity.guid = [dic objectForKey:@"guid"];
                        }
                        if ([dic.allKeys containsObject:@"title"]) {
                            collEntity.title = [dic objectForKey:@"title"];
                        }
                        if ([dic.allKeys containsObject:@"ctag"]) {
                            collEntity.ctag = [dic objectForKey:@"ctag"];
                        }
                        [_reminderCollectionArray addObject:collEntity];
                        [collEntity release];
                    }
                }
            }
            if ([remDic.allKeys containsObject:@"Reminders"]) {
                NSArray *remArr = [remDic objectForKey:@"Reminders"];
                for (NSDictionary *dic in remArr) {
                    if (dic != nil) {
                        [self parseReminderDic:dic];
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"No Complete Reminder exception :%@",exception.reason]];
    }
}

//获取完成的reminder事件
- (void)getCompleteReminderContent {
    @try {
        NSDictionary *remComoleteDic = [_netClient getInformationContent:@"reminders" withPath:@"/rd/completed?clientBuildNumber=16GProject72&clientMasteringNumber=16G76&clientVersion=4.0&dsid=%@&lang=en-us&usertz=US/Pacific"];
        NSLog(@"+++++++++++++++%@++++++++++++++++",remComoleteDic);
        if (remComoleteDic != nil) {
            if ([remComoleteDic.allKeys containsObject:@"Reminders"]) {
                NSArray *remArr = [remComoleteDic objectForKey:@"Reminders"];
                for (NSDictionary *dic in remArr) {
                    if (dic != nil) {
                        [self parseReminderDic:dic];
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        if ([exception.reason isEqualToString:@"Network fault interrupt"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTITY_NETWORK_FAULT_INTERRUPT object:nil userInfo:nil];
        }
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"Complete Reminder exception :%@",exception.reason]];
    }
}

- (void)parseReminderDic:(NSDictionary *)dic {
    IMBiCloudCalendarEventEntity *entity = [[IMBiCloudCalendarEventEntity alloc] init];
    entity.isComplete = NO;
    if ([dic.allKeys containsObject:@"guid"]) {
        entity.guid = [dic objectForKey:@"guid"];
    }
    if ([dic.allKeys containsObject:@"title"]) {
        NSString *title = [dic objectForKey:@"title"];
        if (![title isKindOfClass:[NSNull class]]) {
            entity.summary = title;
        }
    }
    if ([dic.allKeys containsObject:@"description"]) {
        NSString *description = [dic objectForKey:@"description"];
        if (![description isKindOfClass:[NSNull class]]) {
            entity.eventdescription = description;
        }
    }
    if ([dic.allKeys containsObject:@"pGuid"]) {
        entity.pGuid = [dic objectForKey:@"pGuid"];
    }
    if ([dic.allKeys containsObject:@"etag"]) {
        entity.etag = [dic objectForKey:@"etag"];
    }
    
    if ([dic.allKeys containsObject:@"createdDateExtended"]) {
        if ([dic objectForKey:@"createdDateExtended"] != [NSNull null]) {
            entity.createdDateExtended = [[dic objectForKey:@"createdDateExtended"] longLongValue];
        }
        
    }
    if ([dic.allKeys containsObject:@"order"]) {
        if ([dic objectForKey:@"order"] != [NSNull null]) {
            entity.order = [[dic objectForKey:@"order"] longLongValue];
        }
        
    }
    if ([dic.allKeys containsObject:@"priority"]) {
        if ([dic objectForKey:@"priority"] != [NSNull null]) {
            entity.priority = [[dic objectForKey:@"priority"] intValue];
        }
        
    }
    if ([dic.allKeys containsObject:@"completedDate"]) {
        NSArray *dateArr = [dic objectForKey:@"completedDate"];
        if ([dateArr isKindOfClass:[NSArray class]]) {
            NSString *dateStr = [self dateArrayToDateString:dateArr];
            if (dateStr != nil) {
                entity.enddate = dateStr;
                NSDate *date = [DateHelper dateFromString:dateStr Formate:@"yyyy-MM-dd HH:mm:ss"];
                entity.completeTime = [DateHelper getTimeStampFrom1970Date:date];
            }
        }
    }
    if ([dic.allKeys containsObject:@"createdDate"]) {
        NSArray *dateArr = [dic objectForKey:@"createdDate"];
        if ([dateArr isKindOfClass:[NSArray class]]) {
            NSString *dateStr = [self dateArrayToDateString:dateArr];
            NSDate *date = [DateHelper dateFromString:dateStr Formate:@"yyyy-MM-dd HH:mm:ss"];
            entity.createdTime = [DateHelper getTimeStampFrom1970Date:date];
        }
        entity.createDate = [NSMutableArray arrayWithArray:dateArr];
    }
    if ([dic.allKeys containsObject:@"dueDate"]) {
        NSArray *dateArr = [dic objectForKey:@"dueDate"];
        if ([dateArr isKindOfClass:[NSArray class]]) {
            NSString *dateStr = [self dateArrayToDateString:dateArr];
            NSDate *date = [DateHelper dateFromString:dateStr Formate:@"yyyy-MM-dd HH:mm:ss"];
            entity.dueTime = [DateHelper getTimeStampFrom1970Date:date];
            entity.dueDate = [NSMutableArray arrayWithArray:dateArr];
        }
    }
    if ([dic.allKeys containsObject:@"dueDateIsAllDay"]) {
        entity.dueDateIsAllDay = [[dic objectForKey:@"dueDateIsAllDay"] boolValue];
    }
    if ([dic.allKeys containsObject:@"lastModifiedDate"]) {
        NSArray *dateArr = [dic objectForKey:@"lastModifiedDate"];
        if ([dateArr isKindOfClass:[NSArray class]]) {
            NSString *dateStr = [self dateArrayToDateString:dateArr];
            NSDate *date = [DateHelper dateFromString:dateStr Formate:@"yyyy-MM-dd HH:mm:ss"];
            entity.lastModifiedTime = [DateHelper getTimeStampFrom1970Date:date];
        }
    }
    if ([dic.allKeys containsObject:@"startDate"]) {
        NSArray *dateArr = [dic objectForKey:@"startDate"];
        if ([dateArr isKindOfClass:[NSArray class]]) {
            NSString *dateStr = [self dateArrayToDateString:dateArr];
            if (dateStr != nil) {
                entity.startdate = dateStr;
                NSDate *date = [DateHelper dateFromString:dateStr Formate:@"yyyy-MM-dd HH:mm:ss"];
                entity.startTime = [DateHelper getTimeStampFrom1970Date:date];
            }
        }
    }
    if ([dic.allKeys containsObject:@"startDateIsAllDay"]) {
        entity.startDateIsAllDay = [[dic objectForKey:@"startDateIsAllDay"] boolValue];
    }
    if ([dic.allKeys containsObject:@"startDateTz"]) {
        entity.startDateTz = [dic objectForKey:@"startDateTz"];
    }
    
    for (IMBiCloudCalendarCollectionEntity* CollectionEntity in _reminderCollectionArray) {
        if ([CollectionEntity.guid isEqualToString:entity.pGuid]) {
            [CollectionEntity.subArray addObject:entity];
            entity.groupTitle = CollectionEntity.title;
            break;
        }
    }
    
    [_reminderArray addObject:entity];
    [entity release];
}

- (NSString *)dateArrayToDateString:(NSArray *)dateArr {
    //yyyy-MM-dd HH:mm:ss
    NSMutableString *dateStr = [[NSMutableString alloc] init];
    for (int i=1;i<dateArr.count;i++) {
        NSString *str = [NSString stringWithFormat:@"%@",[dateArr objectAtIndex:i]];
        if (i == 1) {
            [dateStr appendString:[NSString stringWithFormat:@"%@-",str]];
        }else if (i == 2) {
            if (str.length == 1) {
                str = [NSString stringWithFormat:@"0%@",str];
            }
            [dateStr appendString:[NSString stringWithFormat:@"%@-",str]];
        }else if (i == 3) {
            if (str.length == 1) {
                str = [NSString stringWithFormat:@"0%@",str];
            }
            [dateStr appendString:[NSString stringWithFormat:@"%@ ",str]];
        }else if (i == 4) {
            if (str.length == 1) {
                str = [NSString stringWithFormat:@"0%@",str];
            }
            [dateStr appendString:[NSString stringWithFormat:@"%@:",str]];
        }else  if (i == 5) {
            if (str.length == 1) {
                str = [NSString stringWithFormat:@"0%@",str];
            }
            [dateStr appendString:[NSString stringWithFormat:@"%@:00",str]];
        }
    }
    return [dateStr autorelease];
}

- (BOOL)addReminder:(ReminderAddModel *)remEntity withPguid:(NSString *)pGuid {
    BOOL ret = NO;
    NSString *pathStr = [NSString stringWithFormat:@"/rd/reminders/%@?clientBuildNumber=17AProject80&clientMasteringNumber=17A77&clientVersion=4.0&%@&lang=en-us&usertz=US/Pacific",pGuid,@"dsid=%@"];
    @try {
        NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *collDic = [self createCollentionDic];
        if (collDic != nil) {
            [postDic setObject:collDic forKey:@"ClientState"];
        }
        NSDictionary *entDic = [self createAddReminderDic:remEntity];
        if (entDic != nil) {
            [postDic setObject:entDic forKey:@"Reminders"];
        }
        NSString *postStr = [TempHelper dictionaryToJson:postDic];
        [postDic release];
        
        if (postStr != nil) {
            NSDictionary *retDic = [_netClient postInformationContent:@"reminders" withPath:pathStr withPostStr:postStr];
            if (retDic != nil) {
                if ([retDic.allKeys containsObject:@"ChangeSet"]) {
                    NSDictionary *dic1 = [retDic objectForKey:@"ChangeSet"];
                    if ([dic1.allKeys containsObject:@"updates"]) {
                        NSDictionary *dic2 = [dic1 objectForKey:@"updates"];
                        if ([dic2.allKeys containsObject:@"Reminders"]) {
                            for (NSDictionary *dic in [dic2 objectForKey:@"Reminders"]) {
                                if ([[dic objectForKey:@"guid"] isEqualToString:remEntity.dataModel.guid]) {
                                    ret = YES;
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"add Reminder exception :%@",exception.reason]];
    }
    
    return ret;
}

- (BOOL)addReminderCollection:(NSString *)collectionName {
    BOOL ret = NO;
    CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
    NSString *newGuid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
    NSString *pathStr = [NSString stringWithFormat:@"/rd/collections/%@/?clientBuildNumber=17AProject80&clientMasteringNumber=17A77&clientVersion=4.0&%@&lang=en-us&usertz=US/Pacific", newGuid, @"dsid=%@"];
    int collectionCount = _reminderCollectionArray != nil ? _reminderCollectionArray.count : 0;
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *collDic = [self createCollentionDic];
    if (collDic != nil) {
        [postDic setObject:collDic forKey:@"ClientState"];
    }
    NSMutableDictionary *entDic = [NSMutableDictionary dictionary];
    [entDic setObject:[NSNull null] forKey:@"collectionShareType"];
    [entDic setObject:@"#e0ac00" forKey:@"color"];
    [entDic setObject:[NSNumber numberWithInt:0] forKey:@"completedCount"];
    [entDic setObject:[NSNull null] forKey:@"createdDate"];
    [entDic setObject:[NSNull null] forKey:@"createdDateExtended"];
    [entDic setObject:[NSNull null] forKey:@"ctag"];
    [entDic setObject:[NSNumber numberWithBool:NO] forKey:@"emailNotification"];
    [entDic setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
    [entDic setObject:newGuid forKey:@"guid"];
    [entDic setObject:[NSNull null] forKey:@"lastModifiedDate"];
    [entDic setObject:[NSNumber numberWithInt:collectionCount + 2] forKey:@"order"];
    [entDic setObject:[NSNull null] forKey:@"participants"];
    [entDic setObject:@"yellow" forKey:@"symbolicColor"];
    [entDic setObject:collectionName forKey:@"title"];
    if (entDic != nil) {
        [postDic setObject:entDic forKey:@"Collections"];
    }
    NSString *postStr = [TempHelper dictionaryToJson:postDic];
    [postDic release];
    
    if (postStr != nil) {
        @try {
            NSDictionary *retDic = [_netClient postInformationContent:@"reminders" withPath:pathStr withPostStr:postStr];
            if (_reminderCollectionArray == nil) {
                _reminderArray = [[NSMutableArray alloc] init];
            }
            
            if (retDic != nil) {
                if ([retDic.allKeys containsObject:@"ChangeSet"] ) {
                    NSDictionary *changeDic = [retDic objectForKey:@"ChangeSet"];
                    if ([changeDic.allKeys containsObject:@"inserts"]) {
                        NSDictionary *insertDic = [changeDic objectForKey:@"inserts"];
                        if ([insertDic.allKeys containsObject:@"Collections"]) {
                            NSArray *collecArray = [insertDic objectForKey:@"Collections"];
                            IMBiCloudCalendarCollectionEntity *collEntity = [[IMBiCloudCalendarCollectionEntity alloc] init];
                            for (NSDictionary *dic in collecArray) {
                                if ([dic.allKeys containsObject:@"ctag"]) {
                                    collEntity.ctag = [dic objectForKey:@"ctag"];
                                }
                                if ([dic.allKeys containsObject:@"title"]) {
                                     collEntity.title = [dic objectForKey:@"title"];
                                }
                                if ([dic.allKeys containsObject:@"guid"]) {
                                    if ([[dic objectForKey:@"guid"] isEqualToString:newGuid]) {
                                        collEntity.guid = newGuid;
                                        collEntity.tag = _reminderCollectionArray.count + 1;
                                        [_reminderCollectionArray addObject:collEntity];
                                        ret = YES;
                                        break;
                                    }
                                }
                            }
                            [collEntity release], collEntity = nil;
                        }
                    }
                }
            }
        }
        @catch (NSException *exception) {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"add Reminder Collection :%@",exception.reason]];
        }
    }
    
    return ret;
}

- (BOOL)deleteReminderCollection:(IMBiCloudCalendarCollectionEntity *)entity {
    BOOL ret = NO;
    NSString *pathStr = [NSString stringWithFormat:@"/rd/collections/%@?clientBuildNumber=17AProject80&clientMasteringNumber=17A77&clientVersion=4.0&%@&ifMatch=%@&lang=en-us&methodOverride=DELETE&usertz=US/Pacific", entity.guid, @"dsid=%@",entity.ctag];
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *collDic = [self createCollentionDic];
    if (collDic != nil) {
        [postDic setObject:collDic forKey:@"ClientState"];
    }
    NSMutableDictionary *entDic = [NSMutableDictionary dictionary];
    [entDic setObject:entity.guid forKey:@"guid"];
    if (entDic != nil) {
        [postDic setObject:entDic forKey:@"Collections"];
    }
    NSString *postStr = [TempHelper dictionaryToJson:postDic];
    [postDic release];
    if (postStr != nil) {
        @try {
            NSDictionary *retDic = [_netClient postInformationContent:@"reminders" withPath:pathStr withPostStr:postStr];
            if (retDic != nil) {
                if ([retDic.allKeys containsObject:@"ChangeSet"]) {
                    NSDictionary *changeDic = [retDic objectForKey:@"ChangeSet"];
                    if ([changeDic.allKeys containsObject:@"deletes"]) {
                        NSArray *deleArray = [changeDic objectForKey:@"deletes"];
                        for (NSDictionary *dic in deleArray) {
                            if ([dic.allKeys containsObject:@"guid"]) {
                                if ([[dic objectForKey:@"guid"] isEqualToString:entity.guid]) {
                                    [_reminderCollectionArray removeObject:entity];
                                    ret = YES;
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
        @catch (NSException *exception) {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"delete Reminder Collection :%@",exception.reason]];
        }
    }
    
    return ret;
}

//remArray----是同一集合的reminder，才能一起删除；不同集合下的reminder需要分多次删除
- (BOOL)deleteReminder:(NSArray *)remArray withPguid:(NSString *)pGuid {
    BOOL ret = NO;
    NSString *pathStr = [NSString stringWithFormat:@"/rd/reminders/%@?clientBuildNumber=17AProject80&clientMasteringNumber=17A77&clientVersion=4.0&%@&lang=en-us&methodOverride=DELETE&usertz=US/Pacific",pGuid,@"dsid=%@"];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *collDic = [self createCollentionDic];
    if (collDic != nil) {
        [postDic setObject:collDic forKey:@"ClientState"];
    }
    NSMutableArray *remArr = [[NSMutableArray alloc] init];
    if (remArray != nil && remArray.count > 0) {
        for (IMBiCloudCalendarEventEntity *entity in remArray) {
            NSMutableDictionary *entDic = [[NSMutableDictionary alloc] init];
            if (![StringHelper stringIsNilOrEmpty:entity.etag]) {
                [entDic setObject:entity.etag forKey:@"etag"];
            }
            if (![StringHelper stringIsNilOrEmpty:entity.guid]) {
                [entDic setObject:entity.guid forKey:@"guid"];
            }
            if (![StringHelper stringIsNilOrEmpty:entity.pGuid]) {
                [entDic setObject:entity.pGuid forKey:@"pGuid"];
            }
            if (entDic != nil) {
                [remArr addObject:entDic];
            }
            [entDic release];
        }
    }
    if (remArr != nil) {
        [postDic setObject:remArr forKey:@"Reminders"];
    }
    [remArr release];
    
    NSString *postStr = [TempHelper dictionaryToJson:postDic];
    [postDic release];
    
    if (postStr != nil) {
        @try {
            NSDictionary *retDic = [_netClient postInformationContent:@"reminders" withPath:pathStr withPostStr:postStr];
            if (retDic != nil) {
                if ([retDic.allKeys containsObject:@"ChangeSet"]) {
                    ret = YES;
                }
            }
        }
        @catch (NSException *exception) {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"delete Reminder exception :%@",exception.reason]];;
        }
    }
    
    return ret;
}

- (BOOL)editReminder:(ReminderEditModel *)remEntity withPguid:(NSString *)pGuid {
    BOOL ret = NO;
    NSString *pathStr = [NSString stringWithFormat:@"/rd/reminders/%@?clientBuildNumber=17AProject80&clientMasteringNumber=17A77&clientVersion=4.0&%@&lang=en-us&methodOverride=PUT&usertz=US/Pacific",pGuid,@"dsid=%@"];
    @try {
        NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *collDic = [self createCollentionDic];
        if (collDic != nil) {
            [postDic setObject:collDic forKey:@"ClientState"];
        }
        NSDictionary *entDic = [self createReminderDic:remEntity];
        if (entDic != nil) {
            [postDic setObject:entDic forKey:@"Reminders"];
        }
        NSString *postStr = [TempHelper dictionaryToJson:postDic];
        [postDic release];
        
        if (postStr != nil) {
            NSDictionary *retDic = [_netClient postInformationContent:@"reminders" withPath:pathStr withPostStr:postStr];
            if (retDic != nil) {
                if ([retDic.allKeys containsObject:@"ChangeSet"]) {
                    NSDictionary *dic1 = [retDic objectForKey:@"ChangeSet"];
                    if ([dic1.allKeys containsObject:@"updates"]) {
                        NSDictionary *dic2 = [dic1 objectForKey:@"updates"];
                        if ([dic2.allKeys containsObject:@"Reminders"]) {
                            for (NSDictionary *dic in [dic2 objectForKey:@"Reminders"]) {
                                if ([[dic objectForKey:@"guid"] isEqualToString:remEntity.dataModel.guid]) {
                                    ret = YES;
                                    _editReminderNewEtag = [[NSString stringWithString:[dic objectForKey:@"etag"]] retain];
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"add Reminder exception :%@",exception.reason]];
    }
    return ret;
}

- (NSMutableDictionary *)createCollentionDic {
    NSMutableDictionary *collDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *collArr = [[NSMutableArray alloc] init];
    if (_reminderCollectionArray != nil && _reminderCollectionArray.count > 0) {
        for (IMBiCloudCalendarCollectionEntity *entity in _reminderCollectionArray) {
            NSMutableDictionary *entDic = [[NSMutableDictionary alloc] init];
            if (![StringHelper stringIsNilOrEmpty:entity.ctag]) {
                [entDic setObject:entity.ctag forKey:@"ctag"];
            }
            if (![StringHelper stringIsNilOrEmpty:entity.guid]) {
                [entDic setObject:entity.guid forKey:@"guid"];
            }
            if (entDic != nil) {
                [collArr addObject:entDic];
            }
            [entDic release];
        }
    }
    if (collArr != nil) {
        [collDic setObject:collArr forKey:@"Collections"];
    }
    [collArr release];
    return [collDic autorelease];
}

- (NSDictionary *)createReminderDic:(ReminderEditModel *)remEntity {
    NSMutableDictionary *entDic = [[NSMutableDictionary alloc] init];
    if(![StringHelper stringIsNilOrEmpty:remEntity.dataModel.title]) {
        [entDic setObject:remEntity.dataModel.title forKey:@"title"];
    }
    if (![StringHelper stringIsNilOrEmpty:remEntity.dataModel.description]) {
        [entDic setObject:remEntity.dataModel.description forKey:@"description"];
    }else {
        [entDic setObject:[NSNull null] forKey:@"description"];
    }
    
    if (![StringHelper stringIsNilOrEmpty:remEntity.dataModel.guid]) {
        [entDic setObject:remEntity.dataModel.guid forKey:@"guid"];
    }
    if (![StringHelper stringIsNilOrEmpty:remEntity.dataModel.pGuid]) {
        [entDic setObject:remEntity.dataModel.pGuid forKey:@"pGuid"];
    }
    [entDic setObject:[NSNumber numberWithInt:remEntity.dataModel.priority] forKey:@"priority"];
    
    if (![StringHelper stringIsNilOrEmpty:remEntity.dataModel.recurrence]) {
        [entDic setObject:remEntity.dataModel.recurrence forKey:@"recurrence"];
    }else {
        [entDic setObject:[NSNull null] forKey:@"recurrence"];
    }
    if (remEntity.dataModel.alarms.count >= 1) {
        [entDic setObject:remEntity.dataModel.alarms forKey:@"alarms"];
    }else {
        [entDic setObject:[NSNull null] forKey:@"alarms"];
    }
    
    [entDic setObject:[NSNumber numberWithBool:remEntity.dataModel.startDateIsAllDay] forKey:@"startDateIsAllDay"];
    if (![StringHelper stringIsNilOrEmpty:remEntity.dataModel.completedDate]) {
        [entDic setObject:remEntity.dataModel.completedDate forKey:@"completedDate"];
    }else {
        [entDic setObject:[NSNull null] forKey:@"completedDate"];
    }
    if (remEntity.dataModel.dueDate.count >= 1) {
        [entDic setObject:remEntity.dataModel.dueDate forKey:@"dueDate"];
    }else {
        [entDic setObject:[NSNull null] forKey:@"dueDate"];
    }
    
    [entDic setObject:[NSNumber numberWithBool:remEntity.dataModel.dueDateIsAllDay] forKey:@"dueDateIsAllDay"];
    [entDic setObject:remEntity.dataModel.dueDate forKey:@"dueDate"];
    [entDic setObject:remEntity.creatDate forKey:@"createdDate"];
    [entDic setObject:remEntity.lastModifiedDate forKey:@"lastModifiedDate"];
    if (![StringHelper stringIsNilOrEmpty:remEntity.dataModel.etag ]) {
        [entDic setObject:remEntity.dataModel.etag forKey:@"etag"];
    }else {
        [entDic setObject:[NSNull null] forKey:@"etag"];
    }
    if (![StringHelper stringIsNilOrEmpty:remEntity.dataModel.etag]) {
        [entDic setObject:remEntity.dataModel.etag forKey:@"etag"];
    }else {
        [entDic setObject:[NSNull null] forKey:@"etag"];
    }
    [entDic setObject:[NSNumber numberWithLongLong:remEntity.createdDateExtended] forKey:@"createdDateExtended"];
    if (![StringHelper stringIsNilOrEmpty:remEntity.startdate]) {
        [entDic setObject:remEntity.startdate forKey:@"startDate"];
    }else {
        [entDic setObject:[NSNull null] forKey:@"startDate"];
    }
    if (![StringHelper stringIsNilOrEmpty:remEntity.startDateTz]) {
        [entDic setObject:remEntity.startDateTz forKey:@"startDateTz"];
    }else {
       [entDic setObject:[NSNull null] forKey:@"startDateTz"];
    }
    [entDic setObject:[NSNumber numberWithLongLong:remEntity.order] forKey:@"order"];
    if (![StringHelper stringIsNilOrEmpty:remEntity.oldpGuid]) {
        [entDic setObject:remEntity.oldpGuid forKey:@"oldpGuid"];
    }else {
         [entDic setObject:[NSNull null] forKey:@"oldpGuid"];
    }
    
    
    return [entDic autorelease];
}

- (NSDictionary *)createAddReminderDic:(ReminderAddModel *)remEntity {
    NSMutableDictionary *entDic = [[NSMutableDictionary alloc] init];
    if(![StringHelper stringIsNilOrEmpty:remEntity.dataModel.title]) {
        [entDic setObject:remEntity.dataModel.title forKey:@"title"];
    }
    if (![StringHelper stringIsNilOrEmpty:remEntity.dataModel.description]) {
        [entDic setObject:remEntity.dataModel.description forKey:@"description"];
    }else {
        [entDic setObject:[NSNull null] forKey:@"description"];
    }
    
    if (![StringHelper stringIsNilOrEmpty:remEntity.dataModel.guid]) {
        [entDic setObject:remEntity.dataModel.guid forKey:@"guid"];
    }
    if (![StringHelper stringIsNilOrEmpty:remEntity.dataModel.pGuid]) {
        [entDic setObject:remEntity.dataModel.pGuid forKey:@"pGuid"];
    }
    [entDic setObject:[NSNumber numberWithInt:remEntity.dataModel.priority] forKey:@"priority"];

    if (![StringHelper stringIsNilOrEmpty:remEntity.dataModel.recurrence]) {
        [entDic setObject:remEntity.dataModel.recurrence forKey:@"recurrence"];
    }else {
         [entDic setObject:[NSNull null] forKey:@"recurrence"];
    }
    if (remEntity.dataModel.alarms.count >= 1) {
        [entDic setObject:remEntity.dataModel.alarms forKey:@"alarms"];
    }else {
        [entDic setObject:[NSNull null] forKey:@"alarms"];
    }
    
    [entDic setObject:[NSNumber numberWithBool:remEntity.dataModel.startDateIsAllDay] forKey:@"startDateIsAllDay"];
    if (![StringHelper stringIsNilOrEmpty:remEntity.dataModel.completedDate]) {
        [entDic setObject:remEntity.dataModel.completedDate forKey:@"completedDate"];
    }else {
        [entDic setObject:[NSNull null] forKey:@"completedDate"];
    }
    if (remEntity.dataModel.dueDate.count >= 1) {
        [entDic setObject:remEntity.dataModel.dueDate forKey:@"dueDate"];
    }else {
        [entDic setObject:[NSNull null] forKey:@"dueDate"];
    }
    
    [entDic setObject:[NSNumber numberWithBool:remEntity.dataModel.dueDateIsAllDay] forKey:@"dueDateIsAllDay"];
    [entDic setObject:remEntity.dataModel.dueDate forKey:@"dueDate"];
    return [entDic autorelease];
}

#pragma mark - Notes
- (void)getNoteContent {
    //_loginInfo.loginDic中的webservices包含notes，则为低版本Notes
    if (_notesSyncToken != nil) {
        [_notesSyncToken release];
        _notesSyncToken = nil;
    }
    NSString *disd = [_netClient getContentHostUrl:@"notes"];
    if (![StringHelper stringIsNilOrEmpty:disd] && ![_netClient judgeNoteIsHigh]) {
        _isHigh = NO;
        NSArray *noteIdArr = [self getLowNoteContent];
        [self getLowNoteDetailContent:noteIdArr];
    }else {
        _isHigh = YES;
        NSArray *reNameArr = [self getHighNoteContent];
        [self getHighNoteDetailContent:reNameArr];
    }
}

/*
 {
 "noteId" : "7464BF63-91C8-4A35-AD78-7484804C30B2%Tm90ZXM=%4315",
 "detail" : {
 "content" : “内容”
 },
 "folderName" : "\/",
 "size" : 3114042,
 "subject" : "mac打包dmg制作映像文件详细步骤",
 "attachments" : [
 {
 "size" : 175056,
 "contentId" : "<681C88C9-78F4-4833-B342-5182A3B19E5B>",
 "attachmentId" : "047b515b-d7d0-46f7-8937-278f7025259d",
 "contentType" : "IMAGE\/PNG; x-unix-mode=0644; \r\n\tname=0_2049828_b48c310e4f8f810.png"
 }
 ],
 "dateModified" : "2017-01-19T09:29:28+08:00"
 }
 }
 */
- (NSArray *)getLowNoteContent {
    NSMutableArray *noteIdArr = [[NSMutableArray alloc] init];
    @try {
        NSDictionary *noteslowDic = [_netClient getInformationContent:@"notes" withPath:@"/no/startup/?dsid=%@"];
        if (noteslowDic != nil) {
            if ([noteslowDic.allKeys containsObject:@"syncToken"]) {
                _notesSyncToken = [[noteslowDic objectForKey:@"syncToken"] retain];
                
                if ([noteslowDic.allKeys containsObject:@"notes"]) {
                    NSArray *notesArr = [noteslowDic objectForKey:@"notes"];
                    for (NSDictionary *notesDic in notesArr) {
                        if ([notesDic.allKeys containsObject:@"noteId"]) {
                            NSString *noteId = [notesDic objectForKey:@"noteId"];
                            if (![StringHelper stringIsNilOrEmpty:noteId]) {
                                [noteIdArr addObject:noteId];
                            }
                        }
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        if ([exception.reason isEqualToString:@"Network fault interrupt"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTITY_NETWORK_FAULT_INTERRUPT object:nil userInfo:nil];
        }
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"Low Note exception :%@",exception.reason]];
    }
    return noteIdArr;
}

- (void)getLowNoteDetailContent:(NSArray *)noteReArr {
    if (noteReArr != nil) {
        NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
        NSMutableArray *recordArr = [[NSMutableArray alloc] init];
        for (NSString *reName in noteReArr) {
            NSMutableDictionary *reNameDic = [[NSMutableDictionary alloc] init];
            if (reName != nil) {
                [reNameDic setObject:reName forKey:@"noteId"];
            }
            if (reNameDic != nil) {
                [recordArr addObject:reNameDic];
            }
            [reNameDic release];
        }
        if (recordArr != nil) {
            [postDic setObject:recordArr forKey:@"notes"];
        }
        [recordArr release];
        
        NSString *postStr = [TempHelper dictionaryToJson:postDic];
        if (postStr != nil) {
            NSString *pathStr = [NSString stringWithFormat:@"/no/retrieveNotes?clientBuildNumber=17AProject77&clientMasteringNumber=17A77&%@&syncToken=%@",@"disd=%@",_notesSyncToken];
            @try {
                NSDictionary *detailDic = [_netClient postInformationContent:@"notes" withPath:pathStr withPostStr:postStr];
                if (detailDic != nil) {
                    if (_noteArray != nil) {
                        [_noteArray release];
                        _noteArray = nil;
                    }
                    _noteArray = [[NSMutableArray alloc] init];
                    if ([detailDic.allKeys containsObject:@"notes"]) {
                        NSArray *notesArr = [detailDic objectForKey:@"notes"];
                        for (NSDictionary *notesDic in notesArr) {
                            IMBiCloudNoteModelEntity *entity = [[IMBiCloudNoteModelEntity alloc] init];
                            entity.recordType = @"Note";
                            if ([notesDic.allKeys containsObject:@"noteId"]) {
                                entity.recordName = [notesDic objectForKey:@"noteId"];
                            }
                            if ([notesDic.allKeys containsObject:@"dateModified"]) {
                                NSString *dateStr = [[[notesDic objectForKey:@"dateModified"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] stringByReplacingOccurrencesOfString:@"Z" withString:@""];
                                if ([dateStr contains:@"+"]) {
                                    NSMutableString *mutStr = [NSMutableString stringWithString:dateStr];
                                    if (mutStr.length > 19) {
                                        dateStr = [mutStr substringWithRange:NSMakeRange(0, 19)];
                                    }
                                }
                                
                                NSDate *mdate = [DateHelper dateFromString:dateStr Formate:@"yyyy-MM-dd HH:mm:ss"];
                                entity.modifyDate = [DateHelper getTimeStampFrom1970Date:mdate];
                                entity.modifyDateStr = [DateHelper stringFromFomate:mdate formate:@"yyyy-MM-dd HH:mm:ss"];
                                entity.shortDateStr = [DateHelper stringFromFomate:mdate formate:@"yyyy-MM-dd"];
                                entity.creatDateStr = entity.modifyDateStr;
                            }
                            if ([notesDic.allKeys containsObject:@"subject"]) {
                                entity.title = [StringHelper flattenHTML:[notesDic objectForKey:@"subject"] trimWhiteSpace:YES];
                                entity.summary = entity.title;
                            }
                            if ([notesDic.allKeys containsObject:@"folderNmae"]) {
                                entity.parentRecordName = [notesDic objectForKey:@"folderNmae"];
                            }
                            if ([notesDic.allKeys containsObject:@"size"]) {
                                entity.noteSize = [[notesDic objectForKey:@"size"] longValue];
                            }
                            if ([notesDic.allKeys containsObject:@"attachments"]) {
                                
                            }
                            if ([notesDic.allKeys containsObject:@"detail"]) {
                                NSDictionary *detailDic = [notesDic objectForKey:@"detail"];
                                if (detailDic != nil && [detailDic.allKeys containsObject:@"content"]) {
                                    entity.content = [StringHelper flattenHTML:[detailDic objectForKey:@"content"] trimWhiteSpace:YES];
                                }
                            }
                            [_noteArray addObject:entity];
                            [entity release];
                        }
                    }
                }
            }
            @catch (NSException *exception) {
                [_logHandle writeInfoLog:[NSString stringWithFormat:@"Low Note Detail exception :%@",exception.reason]];
            }
        }
    }else {
        if (_noteArray) {
            [_noteArray removeAllObjects];
        }
    }
}

- (NSMutableArray *)getHighNoteContent {
    NSMutableArray *recordNameArr = [[[NSMutableArray alloc] init] autorelease];
    @try {
        //高版本的note，内容是用base64加密的
        NSDictionary *notesHighDic = [_netClient postInformationContent:@"ckdatabasews" withPath:@"/database/1/com.apple.notes/production/private/changes/zone?clientBuildNumber=16GHotfix7&clientMasteringNumber=16GHotfix7&dsid=%@" withPostStr:@"{\"zones\":[{\"zoneID\":{\"zoneName\":\"Notes\"},\"desiredKeys\":[\"TitleEncrypted\",\"SnippetEncrypted\",\"FirstAttachmentUTIEncrypted\",\"FirstAttachmentThumbnail\",\"FirstAttachmentThumbnailOrientation\",\"ModificationDate\",\"Deleted\",\"Folders\",\"Attachments\",\"ParentFolder\",\"TextDataAsset\",\"Folder\",\"Note\",\"LastViewedModificationDate\"],\"desiredRecordTypes\":[\"Note\",\"Folder\",\"PasswordProtectedNote\",\"User\",\"Users\",\"Note_UserSpecific\"],\"reverse\":true}]}"];
        if (notesHighDic != nil) {
            if ([notesHighDic.allKeys containsObject:@"zones"]) {
                NSArray *zonesArr = [notesHighDic objectForKey:@"zones"];
                if (zonesArr.count > 0) {
                    NSDictionary *zonesDic = [zonesArr objectAtIndex:0];
                    if (zonesDic != nil) {
                        if ([zonesDic.allKeys containsObject:@"syncToken"]) {
                            _notesSyncToken = [[zonesDic objectForKey:@"syncToken"] retain];
                        }
                        
                        if ([zonesDic.allKeys containsObject:@"records"]) {
                            NSArray *notesArr = [zonesDic objectForKey:@"records"];
                            for (NSDictionary *notesDic in notesArr) {
                                if ([notesDic.allKeys containsObject:@"recordType"]) {
                                    NSString *recordType = [notesDic objectForKey:@"recordType"];
                                    if ([recordType isEqualToString:@"Note"]) {
                                        if ([notesDic.allKeys containsObject:@"parent"]) {
                                            NSDictionary *parentDic = [notesDic objectForKey:@"parent"];
                                            if ([parentDic.allKeys containsObject:@"recordName"]) {
                                                NSString *recordName = [parentDic objectForKey:@"recordName"];
                                                if ([recordName isEqualToString:@"TrashFolder-CloudKit"]) {
                                                    continue;
                                                }
                                            }
                                        }
                                        BOOL deleted = NO;
                                        if ([notesDic.allKeys containsObject:@"fields"]) {
                                            NSDictionary *fieldDic = [notesDic objectForKey:@"fields"];
                                            if (fieldDic != nil) {
                                                if ([fieldDic.allKeys containsObject:@"Deleted"]) {
                                                    NSDictionary *deletedtDic = [fieldDic objectForKey:@"Deleted"];
                                                    if (deletedtDic != nil && [deletedtDic.allKeys containsObject:@"value"]) {
                                                        deleted = [[deletedtDic objectForKey:@"value"] boolValue];
                                                    }
//                                                    continue;
                                                }
                                            }
                                        }
                                        if (!deleted) {
                                            if ([notesDic.allKeys containsObject:@"recordName"]) {
                                                NSString *recordName = [notesDic objectForKey:@"recordName"];
                                                if (recordName != nil) {
                                                    [recordNameArr addObject:recordName];
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        if ([exception.reason isEqualToString:@"Network fault interrupt"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTITY_NETWORK_FAULT_INTERRUPT object:nil userInfo:nil];
        }
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"High Note exception :%@",exception.reason]];
    }
    return recordNameArr;
}

- (void)getHighNoteDetailContent:(NSArray *)noteReArr {
    if (noteReArr != nil && noteReArr.count > 0) {
        NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
        NSMutableArray *recordArr = [[NSMutableArray alloc] init];
        for (NSString *reName in noteReArr) {
            NSMutableDictionary *reNameDic = [[NSMutableDictionary alloc] init];
            if (reName != nil) {
                [reNameDic setObject:reName forKey:@"recordName"];
            }
            if (reNameDic != nil) {
                [recordArr addObject:reNameDic];
            }
            [reNameDic release];
        }
        if (recordArr != nil) {
            [postDic setObject:recordArr forKey:@"records"];
        }
        [recordArr release];
        NSDictionary *zoneDic = [NSDictionary dictionaryWithObject:@"Notes" forKey:@"zoneName"];
        [postDic setObject:zoneDic forKey:@"zoneID"];
        
        NSString *postStr = [TempHelper dictionaryToJson:postDic];
        if (postStr != nil) {
            NSString *pathStr = @"/database/1/com.apple.notes/production/private/records/lookup?ckjsBuildVersion=16GProjectDev80&ckjsVersion=2.0.2?clientBuildNumber=16GProject93&clientMasteringNumber&dsid=%@&remapEnums=true";
            @try {
                NSDictionary *detailDic = [_netClient postInformationContent:@"ckdatabasews" withPath:pathStr withPostStr:postStr];
                if (detailDic != nil) {
                    if (_noteArray != nil) {
                        [_noteArray release];
                        _noteArray = nil;
                    }
                    _noteArray = [[NSMutableArray alloc] init];
                    if ([detailDic.allKeys containsObject:@"records"]) {
                        NSArray *notesArr = [detailDic objectForKey:@"records"];
                        for (NSDictionary *notesDic in notesArr) {
                            IMBiCloudNoteModelEntity *entity = [[IMBiCloudNoteModelEntity alloc] init];
                            if ([notesDic.allKeys containsObject:@"recordType"]) {
                                entity.recordType = [notesDic objectForKey:@"recordType"];
                            }
                            if ([entity.recordType isEqualToString:@"Note"]) {
                                if ([notesDic.allKeys containsObject:@"recordName"]) {
                                    entity.recordName = [notesDic objectForKey:@"recordName"];
                                }
                                if ([notesDic.allKeys containsObject:@"recordChangeTag"]) {
                                    entity.recordChangeTag = [notesDic objectForKey:@"recordChangeTag"];
                                }
                                if ([notesDic.allKeys containsObject:@"shortGUID"]) {
                                    entity.shortGUID = [notesDic objectForKey:@"shortGUID"];
                                }
                                if ([notesDic.allKeys containsObject:@"parent"]) {
                                    NSDictionary *parentDic = [notesDic objectForKey:@"parent"];
                                    if (parentDic != nil && [parentDic.allKeys containsObject:@"recordName"]) {
                                        entity.parentRecordName = [parentDic objectForKey:@"recordName"];
                                    }
                                }
                                if ([notesDic.allKeys containsObject:@"created"]) {
                                    NSDictionary *createdDic = [notesDic objectForKey:@"created"];
                                    if (createdDic != nil) {
                                        if ([createdDic.allKeys containsObject:@"timestamp"]) {
                                            entity.createdTimestamp = [[createdDic objectForKey:@"timestamp"] longLongValue];
                                        }
                                        if ([createdDic.allKeys containsObject:@"deviceID"]) {
                                            entity.createdDeviceID = [createdDic objectForKey:@"deviceID"];
                                        }
                                        if ([createdDic.allKeys containsObject:@"userRecordName"]) {
                                            entity.createdUserRecordName = [createdDic objectForKey:@"userRecordName"];
                                        }
                                    }
                                }
                                if ([notesDic.allKeys containsObject:@"modified"]) {
                                    NSDictionary *modifiedDic = [notesDic objectForKey:@"modified"];
                                    if (modifiedDic != nil) {
                                        if ([modifiedDic.allKeys containsObject:@"timestamp"]) {
                                            entity.modifiedTimestamp = [[modifiedDic objectForKey:@"timestamp"] longLongValue];
                                        }
                                        if ([modifiedDic.allKeys containsObject:@"deviceID"]) {
                                            entity.modifiedDeviceID = [modifiedDic objectForKey:@"deviceID"];
                                        }
                                        if ([modifiedDic.allKeys containsObject:@"userRecordName"]) {
                                            entity.modifiedUserRecordName = [modifiedDic objectForKey:@"userRecordName"];
                                        }
                                    }
                                }
                                if ([notesDic.allKeys containsObject:@"fields"]) {
                                    NSDictionary *fieldDic = [notesDic objectForKey:@"fields"];
                                    if (fieldDic != nil) {
                                        if ([fieldDic.allKeys containsObject:@"AttachmentViewType"]) {
                                            NSDictionary *viewTypeDic = [fieldDic objectForKey:@"AttachmentViewType"];
                                            if (viewTypeDic != nil && [viewTypeDic.allKeys containsObject:@"value"]) {
                                                entity.fieldsAttachmentViewTypeValue = [[viewTypeDic objectForKey:@"value"] longLongValue];
                                            }
                                        }
                                        if ([fieldDic.allKeys containsObject:@"ModificationDate"]) {
                                            NSDictionary *dateDic = [fieldDic objectForKey:@"ModificationDate"];
                                            if (dateDic != nil && [dateDic.allKeys containsObject:@"value"]) {
                                                entity.fieldsModificationDateValue = [[dateDic objectForKey:@"value"] longLongValue];
                                                entity.modifyDate = entity.fieldsModificationDateValue / 1000;
                                                entity.modifyDateStr = [DateHelper dateFrom1970ToString:entity.modifyDate withMode:2];
                                                entity.shortDateStr = [DateHelper dateFrom1970ToString:entity.modifyDate withMode:1];
                                            }
                                        }
                                        if ([fieldDic.allKeys containsObject:@"CreationDate"]) {
                                            NSDictionary *dateDic = [fieldDic objectForKey:@"CreationDate"];
                                            if (dateDic != nil && [dateDic.allKeys containsObject:@"value"]) {
                                                entity.fieldsCreationDateValue = [[dateDic objectForKey:@"value"] longLongValue];
                                                entity.creatDate = entity.fieldsCreationDateValue / 1000;
                                                entity.creatDateStr = [DateHelper dateFrom1970ToString:entity.creatDate withMode:2];
                                            }
                                        }
                                        if ([fieldDic.allKeys containsObject:@"Deleted"]) {
                                            NSDictionary *deleteDic = [fieldDic objectForKey:@"Deleted"];
                                            if (deleteDic != nil && [deleteDic.allKeys containsObject:@"value"]) {
                                                entity.fieldsDeletedValue = [[deleteDic objectForKey:@"value"] longLongValue];
                                            }
                                        }
                                        if ([fieldDic.allKeys containsObject:@"FirstAttachmentThumbnailOrientation"]) {
                                            NSDictionary *oriDic = [fieldDic objectForKey:@"FirstAttachmentThumbnailOrientation"];
                                            if (oriDic != nil && [oriDic.allKeys containsObject:@"value"]) {
                                                entity.fieldsFirstAttachmentThumbnailOrientationValue = [[oriDic objectForKey:@"value"] longLongValue];
                                            }
                                        }
                                        if ([fieldDic.allKeys containsObject:@"FirstAttachmentUTIEncrypted"]) {
                                            NSDictionary *encrDic = [fieldDic objectForKey:@"FirstAttachmentUTIEncrypted"];
                                            if (encrDic != nil && [encrDic.allKeys containsObject:@"value"]) {
                                                entity.fieldsFirstAttachmentUTIEncryptedValue = [encrDic objectForKey:@"value"];
                                            }
                                        }
                                        if ([fieldDic.allKeys containsObject:@"FirstAttachmentThumbnail"]) {
                                            NSDictionary *thumbnailDic = [fieldDic objectForKey:@"FirstAttachmentThumbnail"];
                                            if (thumbnailDic != nil && [thumbnailDic.allKeys containsObject:@"value"]) {
                                                NSDictionary *valueDic = [thumbnailDic objectForKey:@"value"];
                                                if (valueDic != nil) {
                                                    if ([valueDic.allKeys containsObject:@"downloadURL"]) {
                                                        entity.fieldsFirstAttachmentThumbnailValueDownloadURL = [valueDic objectForKey:@"downloadURL"];
                                                    }
                                                    if ([valueDic.allKeys containsObject:@"fileChecksum"]) {
                                                        entity.fieldsFirstAttachmentThumbnailValueFileChecksum = [valueDic objectForKey:@"fileChecksum"];
                                                    }
                                                    if ([valueDic.allKeys containsObject:@"referenceChecksum"]) {
                                                        entity.fieldsFirstAttachmentThumbnailValueReferenceChecksum = [valueDic objectForKey:@"referenceChecksum"];
                                                    }
                                                    if ([valueDic.allKeys containsObject:@"size"]) {
                                                        entity.fieldsFirstAttachmentThumbnailValueSize = [[valueDic objectForKey:@"size"] longLongValue];
                                                    }
                                                    if ([valueDic.allKeys containsObject:@"wrappingKey"]) {
                                                        entity.fieldsFirstAttachmentThumbnailValueWrappingKey = [valueDic objectForKey:@"wrappingKey"];
                                                    }
                                                }
                                            }
                                        }
                                        if ([fieldDic.allKeys containsObject:@"SnippetEncrypted"]) {
                                            NSDictionary *snippetDic = [fieldDic objectForKey:@"SnippetEncrypted"];
                                            if (snippetDic != nil && [snippetDic.allKeys containsObject:@"value"]) {
                                                entity.fieldsSnippetEncryptedValue = [snippetDic objectForKey:@"value"];
                                                if (![StringHelper stringIsNilOrEmpty:entity.fieldsSnippetEncryptedValue]) {
                                                    entity.summary = [_netClient decode:entity.fieldsSnippetEncryptedValue];
                                                }
                                            }
                                        }
                                        if ([fieldDic.allKeys containsObject:@"TitleEncrypted"]) {
                                            NSDictionary *titleDic = [fieldDic objectForKey:@"TitleEncrypted"];
                                            if (titleDic != nil && [titleDic.allKeys containsObject:@"value"]) {
                                                entity.fieldsTitleEncryptedValue = [titleDic objectForKey:@"value"];
                                                if (![StringHelper stringIsNilOrEmpty:entity.fieldsTitleEncryptedValue]) {
                                                    entity.title = [_netClient decode:entity.fieldsTitleEncryptedValue];
                                                }
                                            }
                                        }
                                        if ([fieldDic.allKeys containsObject:@"TextDataEncrypted"]) {
                                            NSDictionary *titleDic = [fieldDic objectForKey:@"TextDataEncrypted"];
                                            if (titleDic != nil && [titleDic.allKeys containsObject:@"value"]) {
                                                entity.fieldsTextDataEncryptedValue = [titleDic objectForKey:@"value"];
                                                //note内容需要先解密，在解压，在分析
                                                if (![StringHelper stringIsNilOrEmpty:entity.fieldsTextDataEncryptedValue]) {
                                                    NSData *deData = [IMBHttpWebResponseUtility dataWithBase64EncodedString:entity.fieldsTextDataEncryptedValue];
                                                    NSData *uzipData = [StringHelper uncompressZippedData:deData];
                                                    NSString *noteStr = [StringHelper analysisNoteData:uzipData  withIsCompress:NO];
                                                    entity.content = noteStr;
                                                    [self readNoteAttmachment:uzipData withNoteEntity:entity];
                                                }
                                            }
                                        }
                                        if ([fieldDic.allKeys containsObject:@"Folders"]) {
                                            NSDictionary *foldersDic = [fieldDic objectForKey:@"Folders"];
                                            if (foldersDic != nil && [foldersDic.allKeys containsObject:@"value"]) {
                                                NSArray *folderArr = [foldersDic objectForKey:@"value"];
                                                NSDictionary *valueDic = nil;
                                                if (folderArr.count > 0) {
                                                    valueDic = [folderArr objectAtIndex:0];
                                                }
                                                if (valueDic != nil) {
                                                    if ([valueDic.allKeys containsObject:@"action"]) {
                                                        entity.fieldsFoldersValueAction = [valueDic objectForKey:@"action"];
                                                    }
                                                    if ([valueDic.allKeys containsObject:@"recordName"]) {
                                                        entity.fieldsFoldersValueRecordName = [valueDic objectForKey:@"recordName"];
                                                    }
                                                    if ([valueDic.allKeys containsObject:@"zoneID"]) {
                                                        NSDictionary *zoneDic = [valueDic objectForKey:@"zoneID"];
                                                        if (zoneDic != nil) {
                                                            if ([zoneDic.allKeys containsObject:@"ownerRecordName"]) {
                                                                entity.fieldsFoldersValueZoneIDOwnerRecordName = [zoneDic objectForKey:@"ownerRecordName"];
                                                            }
                                                            if ([zoneDic.allKeys containsObject:@"zoneName"]) {
                                                                entity.fieldsFoldersValueZoneIDZoneName = [zoneDic objectForKey:@"zoneName"];
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        if (![StringHelper stringIsNilOrEmpty:entity.summary] && [StringHelper stringIsNilOrEmpty:entity.title]) {
                                            entity.title = entity.summary;
                                        }
                                    }
                                }
                                [_noteArray addObject:entity];
                            }
                            [entity release];
                        }
                    }
                }
            }
            @catch (NSException *exception) {
                [_logHandle writeInfoLog:[NSString stringWithFormat:@"High Note Detail exception :%@",exception.reason]];
            }
        }
    }else {
        if (_noteArray) {
            [_noteArray removeAllObjects];
        }
    }
}

- (void)readNoteAttmachment:(NSData *)noteDate withNoteEntity:(IMBiCloudNoteModelEntity *)noteEntity {
    if (noteDate.length > 32) {
        NSString *pattern = @"([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}";
        NSData *destData = [noteDate subdataWithRange:NSMakeRange(noteDate.length / 2, noteDate.length / 2)];
        
        NSString *dataStr = [StringHelper dataToString:destData];
        NSString *destStr = [StringHelper stringFromHexStringASCII:dataStr];
        NSArray *matchArr = [destStr componentsMatchedByRegex:pattern];
        if (matchArr != nil && matchArr.count > 0) {
            NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
            NSMutableArray *recordArr = [[NSMutableArray alloc] init];
            for (NSString *match in matchArr) {
                NSMutableDictionary *reNameDic = [[NSMutableDictionary alloc] init];
                if (match != nil) {
                    [reNameDic setObject:match forKey:@"recordName"];
                }
                if (reNameDic != nil) {
                    [recordArr addObject:reNameDic];
                }
                [reNameDic release];
            }
            if (recordArr != nil) {
                [postDic setObject:recordArr forKey:@"records"];
            }
            [recordArr release];
            NSDictionary *zoneDic = [NSDictionary dictionaryWithObject:@"Notes" forKey:@"zoneName"];
            [postDic setObject:zoneDic forKey:@"zoneID"];
            
            NSString *postStr = [TempHelper dictionaryToJson:postDic];
            if (postStr != nil) {
                NSString *pathStr = @"/database/1/com.apple.notes/production/private/records/lookup?ckjsBuildVersion=16GProjectDev80&ckjsVersion=2.0.2?clientBuildNumber=16GProject93&clientMasteringNumber&dsid=%@&remapEnums=true";
                @try {
                    NSDictionary *detailAttachDic = [_netClient postInformationContent:@"ckdatabasews" withPath:pathStr withPostStr:postStr];
                    if (detailAttachDic != nil) {
                        if ([detailAttachDic.allKeys containsObject:@"records"]) {
                            NSArray *detailArr = [detailAttachDic objectForKey:@"records"];
                            for (NSDictionary *attDic in detailArr) {
                                IMBiCloudNoteAttachmentEntity *entity = [[IMBiCloudNoteAttachmentEntity alloc] init];
                                if ([attDic.allKeys containsObject:@"fields"]) {
                                    NSDictionary *fieldDic = [attDic objectForKey:@"fields"];
                                    if ([fieldDic.allKeys containsObject:@"Height"]) {
                                        NSDictionary *heightDic = [fieldDic objectForKey:@"Height"];
                                        if ([heightDic.allKeys containsObject:@"value"]) {
                                            entity.height = [[heightDic objectForKey:@"value"] intValue];
                                        }
                                    }
                                    if ([fieldDic.allKeys containsObject:@"Width"]) {
                                        NSDictionary *widthDic = [fieldDic objectForKey:@"Width"];
                                        if ([widthDic.allKeys containsObject:@"value"]) {
                                            entity.width = [[widthDic objectForKey:@"value"] intValue];
                                        }
                                    }
                                    if ([fieldDic.allKeys containsObject:@"PreviewImages"]) {
                                        NSDictionary *previewImagesDic = [fieldDic objectForKey:@"PreviewImages"];
                                        if ([previewImagesDic.allKeys containsObject:@"value"]) {
                                            NSArray *imageArr = [previewImagesDic objectForKey:@"value"];
                                            for (NSDictionary *imageDic in imageArr) {
                                                IMBAttachDetailEntity *attEntity = [[IMBAttachDetailEntity alloc] init];
                                                if ([imageDic.allKeys containsObject:@"size"]) {
                                                    attEntity.fileSize = [[imageDic objectForKey:@"size"] longLongValue];
                                                }
                                                if ([imageDic.allKeys containsObject:@"fileChecksum"]) {
                                                    attEntity.fileName = [[imageDic objectForKey:@"fileChecksum"] stringByReplacingOccurrencesOfString:@"/" withString:@""];
                                                }
                                                NSString *cacePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:attEntity.fileName];
                                                if ([imageDic.allKeys containsObject:@"downloadURL"]) {
                                                    NSString *downloadUrl = [imageDic objectForKey:@"downloadURL"];
                                                    NSData *thumbData = [_netClient getiCloudNoteAttachmentUrl:downloadUrl];
                                                    
                                                    NSFileManager *fm = [NSFileManager defaultManager];
                                                    if ([fm fileExistsAtPath:cacePath]) {
                                                        [fm removeItemAtPath:cacePath error:nil];
                                                    }
                                                    [fm createFileAtPath:cacePath contents:nil attributes:nil];
                                                    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:cacePath];
                                                    [handle writeData:thumbData];
                                                    [handle closeFile];
                                                    
                                                    attEntity.backUpFilePath = cacePath;
                                                }
                                                [entity.attachDetailList addObject:attEntity];
                                                [attEntity release];
                                            }
                                        }
                                    }
                                }
                                if ([attDic.allKeys containsObject:@"parent"]) {
                                    NSDictionary *parentDic = [attDic objectForKey:@"parent"];
                                    if ([parentDic.allKeys containsObject:@"recordName"]) {
                                        entity.parentRecordName = [parentDic objectForKey:@"recordName"];
                                    }
                                }
                                if ([attDic.allKeys containsObject:@"recordName"]) {
                                    entity.recordName = [attDic objectForKey:@"recordName"];
                                }
                                if ([attDic.allKeys containsObject:@"recordType"]) {
                                    entity.recordType = [attDic objectForKey:@"recordType"];
                                }
                                [noteEntity.attachmentAry addObject:entity];
                                [entity release];
                            }
                        }
                    }
                }@catch (NSException *exception) {
                    [_logHandle writeInfoLog:[NSString stringWithFormat:@"read Note Attmachment Detail exception :%@",exception.reason]];
                }
            }
        }
    }
}

- (BOOL)addNoteData:(NSArray *)noteDataArr {
    BOOL ret = NO;
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    if (_isHigh) {
        ret = [self addHighNoteData:noteDataArr];
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Notes To iCloud" label:Finish transferCount:noteDataArr.count screenView:@"Notes View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }else {
        ret = [self addLowNoteData:noteDataArr];
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Notes To iCloud" label:Finish transferCount:noteDataArr.count screenView:@"Notes View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    return ret;
}

- (BOOL)addHighNoteData:(NSArray *)noteDataArr {
    BOOL ret = NO;
    NSString *pathStr = @"/database/1/com.apple.notes/production/private/records/modify?remapEnums=true&ckjsBuildVersion=17AProjectDev84&ckjsVersion=2.0.3&clientBuildNumber=17AProject82&clientMasteringNumber=17A77&dsid=%@";
    NSString *postStr = [self createHighNoteModifyModel:noteDataArr];
    @try {
        NSDictionary *retDic = [_netClient postInformationContent:@"ckdatabasews" withPath:pathStr withPostStr:postStr];
         [_delegate transfranDic:retDic];
        if (retDic != nil && [retDic.allKeys containsObject:@"records"]) {
            
            ret = YES;
       
        }
    }
    @catch(NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"add High Note exception :%@",exception.reason]];
    }
    
    return ret;
}

- (BOOL)addLowNoteData:(NSArray *)noteDataArr {
    BOOL ret = NO;
    NSString *pathStr = [NSString stringWithFormat:@"/no/createNotes?clientBuildNumber=17AProject77&&clientMasteringNumber=17A77&%@&syncToken=%@",@"dsid=%@",_notesSyncToken];
    NSString *postStr = [self createLowNoteModifyModel:noteDataArr];
    @try {
        NSDictionary *retDic = [_netClient postInformationContent:@"notes" withPath:pathStr withPostStr:postStr];
        [_delegate transfranDic:retDic];
        if (retDic != nil && [retDic.allKeys containsObject:@"notes"]) {
            ret = YES;
        }
    }
    @catch(NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"add High Note exception :%@",exception.reason]];
    }
    
    return ret;
}

- (NSString *)createHighNoteModifyModel:(NSArray *)noteDataArr {
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *operationsArr = [[NSMutableArray alloc] init];
    
    for (IMBUpdateNoteEntity *entity in noteDataArr) {
        NSString *noteData = entity.noteContent;
        NSMutableDictionary *conDic = [[NSMutableDictionary alloc] init];
        [conDic setObject:@"create" forKey:@"operationType"];
        
        NSMutableDictionary *recordDic = [[NSMutableDictionary alloc] init];
        CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
        NSString *recordName = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
        [recordDic setObject:recordName forKey:@"recordName"];
        [recordDic setObject:[NSNumber numberWithBool:YES] forKey:@"createShortGUID"];
        [recordDic setObject:@"Note" forKey:@"recordType"];
        
        NSMutableDictionary *fieldsDic = [[NSMutableDictionary alloc] init];
        long long timeStamp = entity.timeStamp * 1000;
        if (timeStamp == 0) {
            timeStamp = [[NSDate date] timeIntervalSince1970];
        }
        NSDictionary *dateDic = [NSDictionary dictionaryWithObject:[NSNumber numberWithLongLong:timeStamp] forKey:@"value"];
        [fieldsDic setObject:dateDic forKey:@"CreationDate"];
        [fieldsDic setObject:dateDic forKey:@"ModificationDate"];
        NSString *noteTitle = @"";
        if (noteData.length > 20) {
            noteTitle = [noteData substringWithRange:NSMakeRange(0, 20)];
        }else {
            noteTitle = noteData;
        }
        NSDictionary *titleDic = [NSDictionary dictionaryWithObject:[_netClient encode:noteTitle] forKey:@"value"];
        [fieldsDic setObject:titleDic forKey:@"TitleEncrypted"];
        NSString *noteSnippet = @"";
        if (noteData.length > 50) {
            noteSnippet = [noteData substringWithRange:NSMakeRange(0, 50)];
        }else {
            noteSnippet = noteData;
        }
        NSDictionary *snipDic = [NSDictionary dictionaryWithObject:[_netClient encode:noteSnippet] forKey:@"value"];
        [fieldsDic setObject:snipDic forKey:@"SnippetEncrypted"];
        
        NSData *textData = [StringHelper greadData:noteData];
        NSData *zipData = [StringHelper gzipData:textData];
        NSString *enCode = [IMBHttpWebResponseUtility base64EncodedStringFrom:zipData];
        NSDictionary *textDic = [NSDictionary dictionaryWithObject:enCode forKey:@"value"];
        [fieldsDic setObject:textDic forKey:@"TextDataEncrypted"];
        
        NSMutableDictionary *foldersDic = [[NSMutableDictionary alloc] init];
        [foldersDic setObject:@"DefaultFolder-CloudKit" forKey:@"recordName"];
        [foldersDic setObject:@"VALIDATE" forKey:@"action"];
        [foldersDic setObject:[NSDictionary dictionaryWithObject:@"Notes" forKey:@"zoneName"] forKey:@"zoneID"];
        
        NSArray *foldersArr = [NSArray arrayWithObject:foldersDic];
        NSDictionary *valueDic = [NSDictionary dictionaryWithObject:foldersArr forKey:@"value"];
        [fieldsDic setObject:valueDic forKey:@"Folders"];
        [foldersDic release];
        
        if (fieldsDic != nil) {
            [recordDic setObject:fieldsDic forKey:@"fields"];
            [fieldsDic release];
        }
        
        if (recordDic != nil) {
            [conDic setObject:recordDic forKey:@"record"];
            [recordDic release];
        }
        
        if (conDic != nil) {
            [operationsArr addObject:conDic];
            [conDic release];
        }
    }
    
    if (operationsArr != nil) {
        [postDic setObject:operationsArr forKey:@"operations"];
        [operationsArr release];
    }
    
    NSDictionary *zoneDic = [NSDictionary dictionaryWithObject:@"Notes" forKey:@"zoneName"];
    [postDic setObject:zoneDic forKey:@"zoneID"];
    
    NSString *postStr = [TempHelper dictionaryToJson:postDic];
    [postDic release];
    return postStr;
}

- (NSString *)createLowNoteModifyModel:(NSArray *)noteDataArr {
    NSMutableString *postStr = [NSMutableString stringWithString:@"{\"notes\":["];
    for (int i=0;i<noteDataArr.count;i++) {
        IMBUpdateNoteEntity *entity = [noteDataArr objectAtIndex:i];
        NSString *noteData = entity.noteContent;//[noteDataArr objectAtIndex:i];
        
        CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
        NSString *noteId = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
        
        NSString *noteSubject = @"";
        if (noteData.length > 50) {
            noteSubject = [noteData substringWithRange:NSMakeRange(0, 50)];
        }else {
            noteSubject = noteData;
        }
        
        NSDate *nowDate = [NSDate date];
        long long timeStamp = entity.timeStamp;
        if (timeStamp != 0) {
            nowDate = [NSDate dateWithTimeIntervalSince1970:entity.timeStamp];
        }
        NSString *nowStr = [DateHelper stringFromFomate:nowDate formate:@"yyyy-MM-dd"];
        NSString *nowTimeStr = [DateHelper stringFromFomate:nowDate formate:@"HH:mm:ss"];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        int time = (int)zone.secondsFromGMT;
        int hour = time / 3600;
        int min = (time % 3600) / 60;
        NSString *timeStr = [NSString stringWithFormat:@"+%02d:%02d",hour,min];
        nowStr = [[nowStr stringByAppendingString:[@"T" stringByAppendingString:nowTimeStr]] stringByAppendingString:timeStr];
        
//        NSString *postStr = [NSString stringWithFormat:@"{\"notes\":[{\"folderName\":\"/\",\"dateModified\":\"%@\",\"noteId\":\"Notes:%@\",\"detail\":{\"content\":\"<html><head></head><body><div>%@</div></body></html>\"},\"subject\":\"%@\"}]}",nowStr,noteId,noteData,noteSubject];
        
        NSString *singStr = [NSString stringWithFormat:@"{\"folderName\":\"/\",\"dateModified\":\"%@\",\"noteId\":\"Notes:%@\",\"detail\":{\"content\":\"<html><head></head><body><div>%@</div></body></html>\"},\"subject\":\"%@\"}",nowStr,noteId,noteData,noteSubject];
        [postStr appendString:singStr];
        if (i == noteDataArr.count - 1) {
            [postStr appendString:@"]}"];
        }else {
            [postStr appendString:@","];
        }
    }
    return postStr;
}

- (BOOL)deleteNote:(NSArray *)noteArr {
    BOOL ret = NO;
    if (_isHigh) {
        ret = [self deleteHighNote:noteArr];
    }else {
        ret = [self deleteLowNote:noteArr];
    }
    return ret;
}

- (BOOL)deleteHighNote:(NSArray *)noteArr {
    BOOL ret = NO;
    NSString *pathStr = @"/database/1/com.apple.notes/production/private/records/modify?remapEnums=true&ckjsBuildVersion=17AProjectDev84&ckjsVersion=2.0.3&clientBuildNumber=17AProject82&clientMasteringNumber=17A77&dsid=%@";
    NSString *postStr = [self createUpdateHighNotePostString:noteArr withType:@"delete"];
    @try {
        NSDictionary *retDic = [_netClient postInformationContent:@"ckdatabasews" withPath:pathStr withPostStr:postStr];
        if (retDic != nil && [retDic.allKeys containsObject:@"records"]) {
            ret = YES;
        }
    }
    @catch(NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"add High Note exception :%@",exception.reason]];
    }
    
    return ret;
}

- (NSString *)createUpdateHighNotePostString:(NSArray *)noteArr withType:(NSString *)optionType {
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *operationsArr = [[NSMutableArray alloc] init];
    
    for (IMBiCloudNoteModelEntity *entity in noteArr) {
        NSMutableDictionary *conDic = [[NSMutableDictionary alloc] init];
        [conDic setObject:@"update" forKey:@"operationType"];
        
        NSMutableDictionary *recordDic = [[NSMutableDictionary alloc] init];
        [recordDic setObject:entity.recordName forKey:@"recordName"];
        if (![StringHelper stringIsNilOrEmpty:entity.shortGUID]) {
            [recordDic setObject:entity.shortGUID forKey:@"shortGUID"];
        }
        [recordDic setObject:entity.recordType forKey:@"recordType"];
        if (![StringHelper stringIsNilOrEmpty:entity.recordChangeTag]) {
            [recordDic setObject:entity.recordChangeTag forKey:@"recordChangeTag"];
        }
        if (![StringHelper stringIsNilOrEmpty:entity.parentRecordName]) {
            [recordDic setObject:[NSDictionary dictionaryWithObject:entity.parentRecordName forKey:@"recordName"] forKey:@"parent"];
        }
        NSMutableDictionary *fieldsDic = [[NSMutableDictionary alloc] init];
        
        if ([optionType isEqualToString:@"delete"]) {//设置附件字段
//            "FirstAttachmentThumbnailOrientation":{"value":0},
//            "FirstAttachmentUTIEncrypted":{"value":"cHVibGljLmpwZWc="},
//            "AttachmentViewType":{"value":0},
//            "Deleted":{"value":0},
            NSDictionary *deleteDic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"value"];
            [fieldsDic setObject:deleteDic forKey:@"Deleted"];
        }else {//暂不增加附件
            
        }

        NSDictionary *modifiDateDic = [NSDictionary dictionaryWithObject:[NSNumber numberWithLongLong:entity.fieldsModificationDateValue] forKey:@"value"];
        NSDictionary *createDateDic = [NSDictionary dictionaryWithObject:[NSNumber numberWithLongLong:entity.fieldsCreationDateValue] forKey:@"value"];
        [fieldsDic setObject:createDateDic forKey:@"CreationDate"];
        [fieldsDic setObject:modifiDateDic forKey:@"ModificationDate"];
        NSDictionary *titleDic = [NSDictionary dictionaryWithObject:entity.fieldsTitleEncryptedValue forKey:@"value"];
        [fieldsDic setObject:titleDic forKey:@"TitleEncrypted"];
        NSDictionary *snipDic = [NSDictionary dictionaryWithObject:entity.fieldsSnippetEncryptedValue forKey:@"value"];
        [fieldsDic setObject:snipDic forKey:@"SnippetEncrypted"];
        NSDictionary *textDic = [NSDictionary dictionaryWithObject:entity.fieldsTextDataEncryptedValue forKey:@"value"];
        [fieldsDic setObject:textDic forKey:@"TextDataEncrypted"];
        
        NSMutableDictionary *foldersDic = [[NSMutableDictionary alloc] init];
        if ([optionType isEqualToString:@"delete"]) {
            [foldersDic setObject:@"TrashFolder-CloudKit" forKey:@"recordName"];
        }else {
            [foldersDic setObject:@"DefaultFolder-CloudKit" forKey:@"recordName"];
        }
        if (![StringHelper stringIsNilOrEmpty:entity.fieldsFoldersValueAction]) {
            [foldersDic setObject:entity.fieldsFoldersValueAction forKey:@"action"];
        }else {
            [foldersDic setObject:@"VALIDATE" forKey:@"action"];
        }
        NSMutableDictionary *zoneIDDic = [[NSMutableDictionary alloc] init];
        if (![StringHelper stringIsNilOrEmpty:entity.fieldsFoldersValueZoneIDZoneName]) {
            [zoneIDDic setObject:entity.fieldsFoldersValueZoneIDZoneName forKey:@"zoneName"];
        }else {
            [zoneIDDic setObject:@"Notes" forKey:@"zoneName"];
        }
        if (![StringHelper stringIsNilOrEmpty:entity.fieldsFoldersValueZoneIDOwnerRecordName]) {
            [zoneIDDic setObject:entity.fieldsFoldersValueZoneIDOwnerRecordName forKey:@"ownerRecordName"];
        }
        if (zoneIDDic != nil) {
            [foldersDic setObject:zoneIDDic forKey:@"zoneID"];
            [zoneIDDic release];
        }
        
        NSArray *foldersArr = [NSArray arrayWithObject:foldersDic];
        NSDictionary *valueDic = [NSDictionary dictionaryWithObject:foldersArr forKey:@"value"];
        [fieldsDic setObject:valueDic forKey:@"Folders"];
        [foldersDic release];
        
        if (fieldsDic != nil) {
            [recordDic setObject:fieldsDic forKey:@"fields"];
            [fieldsDic release];
        }
        if (recordDic != nil) {
            [conDic setObject:recordDic forKey:@"record"];
            [recordDic release];
        }
        if (conDic != nil) {
            [operationsArr addObject:conDic];
            [conDic release];
        }
    }
    
    if (operationsArr != nil) {
        [postDic setObject:operationsArr forKey:@"operations"];
        [operationsArr release];
    }
    NSDictionary *zoneDic = [NSDictionary dictionaryWithObject:@"Notes" forKey:@"zoneName"];
    [postDic setObject:zoneDic forKey:@"zoneID"];
    
    NSString *postStr = [TempHelper dictionaryToJson:postDic];
    [postDic release];
    return postStr;
}

- (BOOL)deleteLowNote:(NSArray *)noteArr {
    BOOL ret = NO;
    NSString *pathStr = [NSString stringWithFormat:@"/no/deleteNotes?clientBuildNumber=17AProject77&clientMasteringNumber=17A77&%@&syncToken=%@",@"dsid=%@",_notesSyncToken];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *recordArr = [[NSMutableArray alloc] init];
    for (IMBiCloudNoteModelEntity *entity in noteArr) {
        NSMutableDictionary *reNameDic = [[NSMutableDictionary alloc] init];
        if (entity.recordName != nil) {
            [reNameDic setObject:entity.recordName forKey:@"noteId"];
        }
        if (reNameDic != nil) {
            [recordArr addObject:reNameDic];
        }
        [reNameDic release];
    }
    if (recordArr != nil) {
        [postDic setObject:recordArr forKey:@"notes"];
    }
    [recordArr release];

    NSString *postStr = [TempHelper dictionaryToJson:postDic];
    [postDic release];
    @try {
        NSDictionary *retDic = [_netClient postInformationContent:@"notes" withPath:pathStr withPostStr:postStr];
        if (retDic != nil) {
            ret = YES;
        }
    }
    @catch(NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"add High Note exception :%@",exception.reason]];
    }
    
    return ret;
}

#pragma mark - iCloud Drive
- (void)getiCloudDriveContent {
    //获取根目录；
    if (_driveFolderEntity != nil) {
        [_driveFolderEntity release];
        _driveFolderEntity = nil;
    }
    _driveFolderEntity = [[IMBiCloudDriveFolderEntity alloc] init];
    [self getRootFolderContent];
    if (_driveFolderEntity != nil) {
        //获取文件夹内容；
        [self getFolderContent:_driveFolderEntity];
    }
}

- (void)getRootFolderContent {
    @try {
        NSDictionary *rootFolderDic = [_netClient postiCloudDriveContent:@"drivews" withPath:@"/retrieveItemDetails" withPostStr:@"{\"items\":[{\"drivewsid\":\"ROOT\"}]}"];
        if (rootFolderDic != nil) {
            NSDictionary *desDic = (NSDictionary *)rootFolderDic;
            if ([desDic.allKeys containsObject:@"error"]) {
                NSLog(@"error:%d;",[[desDic objectForKey:@"error"] intValue]);
                if ([desDic.allKeys containsObject:@"reason"]) {
                    NSLog(@"error:%d; reason:%@",[[desDic objectForKey:@"error"] intValue],[desDic objectForKey:@"reason"]);
//                    [_logHandle writeInfoLog:[NSString stringWithFormat:@"error:%d; reason:%@",[[errorDic objectForKey:@"error"] intValue],[errorDic objectForKey:@"reason"]]];
                }
                return;
            }
            if ([desDic.allKeys containsObject:@"items"]) {
                NSArray *subArr = [desDic objectForKey:@"items"];
                if (subArr != nil && subArr.count > 0) {
                    [self getRootFolderInfo:subArr withFolderEntity:_driveFolderEntity];
                }
            }
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"icloud Drive Root Folder exception :%@",exception.reason]];
    }
}

//得到根目录的信息，保存在IMBiCloudDriveFolderEntity实体中
- (void)getRootFolderInfo:(NSArray *)rootFolderArr withFolderEntity:(IMBiCloudDriveFolderEntity *)folderEntity {
    if (rootFolderArr.count > 0) {
        NSDictionary *subDic = [rootFolderArr objectAtIndex:0];
        if (subDic != nil) {
            if ([subDic.allKeys containsObject:@"drivewsid"]) {
                [folderEntity setDrivewsid:[subDic objectForKey:@"drivewsid"]];
            }
            if ([subDic.allKeys containsObject:@"docwsid"]) {
                [folderEntity setDocwsid:[subDic objectForKey:@"docwsid"]];
            }
            if ([subDic.allKeys containsObject:@"zone"]) {
                [folderEntity setZone:[subDic objectForKey:@"zone"]];
            }
            if ([subDic.allKeys containsObject:@"name"]) {
                [folderEntity setName:[subDic objectForKey:@"name"]];
            }
            if ([subDic.allKeys containsObject:@"etag"]) {
                [folderEntity setEtag:[subDic objectForKey:@"etag"]];
            }
            if ([subDic.allKeys containsObject:@"type"]) {
                [folderEntity setType:[subDic objectForKey:@"type"]];
            }
        }
    }
}

//获取文件夹下的类容
- (void)getFolderContent:(IMBiCloudDriveFolderEntity *)folderEntity {
    @try {
        if (folderEntity != nil) {
            NSString *postStr = [NSString stringWithFormat:@"[{\"drivewsid\":\"%@\",\"partialData\":false}]",folderEntity.drivewsid];
            NSArray *folderArr = [_netClient postiCloudDriveContent:@"drivews" withPath:@"/retrieveItemDetailsInFolders" withPostStr:postStr];
            if (folderArr != nil) {
                if ([folderArr isKindOfClass:[NSArray class]]) {
                    NSArray *folderArray = (NSArray *)folderArr;
                    if (folderArray.count > 0) {
                        [self getOtherFolderOrFileInfo:folderArray withEntity:folderEntity];
                    }
                }else if ([folderArr isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *desDic = (NSDictionary *)folderArr;
                    if ([desDic.allKeys containsObject:@"error"]) {
                        NSLog(@"error:%d;",[[desDic objectForKey:@"error"] intValue]);
                        if ([desDic.allKeys containsObject:@"reason"]) {
                            NSLog(@"error:%d; reason:%@",[[desDic objectForKey:@"error"] intValue],[desDic objectForKey:@"reason"]);
                            //                    [_logHandle writeInfoLog:[NSString stringWithFormat:@"error:%d; reason:%@",[[errorDic objectForKey:@"error"] intValue],[errorDic objectForKey:@"reason"]]];
                        }
                        return;
                    }
                }
            }else {
                [[IMBLogManager singleton] writeInfoLog:@"iCloud Drive get folder empty"];
            }
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"icloud Drive Folder exception :%@",exception.reason]];
    }
}

- (NSMutableArray *)getContinueDownData
{
    NSMutableArray *continueDownData = [NSMutableArray array];
    NSString *filePath = [[TempHelper getAppDownloadDefaultPath] stringByAppendingPathComponent:@"DriverConfig.plist"];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSArray *dataArray = [dataDic objectForKey:[self.netClient.loginInfo.appleID lowercaseString]];
    for (NSDictionary *dic in dataArray) {
        IMBiCloudDriveFolderEntity *entity = [[IMBiCloudDriveFolderEntity alloc] init];
        [entity setDocwsid:[dic objectForKey:@"docwsid"]];
        [entity setDownloadPath:[dic objectForKey:@"downloadPath"]];
        [entity setExtension:[dic objectForKey:@"extension"]];
        
        NSWorkspace *workSpace = [[NSWorkspace alloc] init];
        NSImage *icon = [workSpace iconForFileType:entity.extension];
        if (icon == nil) {
            icon = [workSpace iconForFileType:@"dll"];
        }
        [icon setSize:NSMakeSize(42, 42)];
        [entity setImage:icon];
        [workSpace release];
        [entity setFinishSize:[[dic objectForKey:@"finishSize"] longLongValue]];
        [entity setName:[dic objectForKey:@"name"]];
        [entity setParentId:[dic objectForKey:@"parentId"]];
        [entity setSize:[[dic objectForKey:@"size"] longLongValue]];
        if (![[dic objectForKey:@"type"] isEqualToString:@"FILE"]) {
            OSType code = UTGetOSTypeFromString((CFStringRef)@"fldr");
            NSImage *picture = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(code)];
            [picture setSize:NSMakeSize(42, 42)];
            [entity setImage:picture];
        }
        [entity setType:[dic objectForKey:@"type"]];
        [entity setZone:[dic objectForKey:@"zone"]];
        [continueDownData addObject:entity];
        [entity release];
    }
    [dataArray release];
    return continueDownData;
}

- (void)deleteContinueDonwData
{
    NSString *filePath = [[TempHelper getAppDownloadDefaultPath] stringByAppendingPathComponent:@"DriverConfig.plist"];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    [dataDic removeObjectForKey:[self.netClient.loginInfo.appleID lowercaseString]];
    [dataDic writeToFile:filePath atomically:YES];
}

//得到其他目录或文件信息，保存在IMBiCloudDriveFolderEntity实体中
- (void)getOtherFolderOrFileInfo:(NSArray *)folderArr withEntity:(IMBiCloudDriveFolderEntity *)entity {
    if (folderArr.count > 0) {
        NSDictionary *subDic = [folderArr objectAtIndex:0];
        if (subDic != nil) {
            if ([subDic.allKeys containsObject:@"parentId"]) {
                [entity setParentId:[subDic objectForKey:@"parentId"]];
            }
            
            if ([entity.type isEqualToString:@"FILE"]) {
                if ([subDic.allKeys containsObject:@"dateModified"]) {
                    [entity setDateModified:[subDic objectForKey:@"dateModified"]];
                }
                if ([subDic.allKeys containsObject:@"size"]) {
                    [entity setSize:[[subDic objectForKey:@"size"] longLongValue]];
                }
                if ([subDic.allKeys containsObject:@"extension"]) {
                    [entity setExtension:[subDic objectForKey:@"extension"]];
                    NSWorkspace *workSpace = [[NSWorkspace alloc] init];
                    NSImage *icon = [workSpace iconForFileType:entity.extension];
                    [icon setSize:NSMakeSize(56, 52)];
                    [entity setImage:icon];
                    [workSpace release];
                } else{
                    NSWorkspace *workSpace = [[NSWorkspace alloc] init];
                    NSImage *icon = [workSpace iconForFileType:@"dll"];
                    [icon setSize:NSMakeSize(56, 52)];
                    [entity setImage:icon];
                    [workSpace release];
                }
            }else {
                OSType code = UTGetOSTypeFromString((CFStringRef)@"fldr");
                NSImage *picture = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(code)];
                [picture setSize:NSMakeSize(56, 52)];
                [entity setImage:picture];
                if ([subDic.allKeys containsObject:@"numberOfItems"]) {
                    [entity setNumberOfItems:[[subDic objectForKey:@"numberOfItems"] intValue]];
                }
                if ([entity.type isEqualToString:@"APP_LIBRARY"]) {
                    if ([subDic.allKeys containsObject:@"maxDepth"]) {
                        [entity setMaxDepth:[subDic objectForKey:@"maxDepth"]];
                    }
                    if ([subDic.allKeys containsObject:@"supportedExtensions"]) {
                        [entity setSupportedExtensions:[subDic objectForKey:@"supportedExtensions"]];
                    }
                }
                if ([subDic.allKeys containsObject:@"items"]) {
                    NSArray *subArr = [subDic objectForKey:@"items"];
                    if (subArr != nil && subArr.count > 0) {
//                        [entity.fileItemsList removeAllObjects];
                        for (int i = 0; i < subArr.count; i++) {
                            NSDictionary *itemDic = [subArr objectAtIndex:i];
                            IMBiCloudDriveFolderEntity *subEntity = nil;// [[IMBiCloudDriveFolderEntity alloc] init];
                            subEntity = [[self getFolderOrFileInfo:itemDic] retain];
                            [entity.fileItemsList addObject:subEntity];
                            [subEntity release];
                            subEntity = nil;
                        }
                    }
                }
            }
        }
    }
}

//得到文件夹或文件信息，保存在IMBiCloudDriveFolderEntity实体中;
- (IMBiCloudDriveFolderEntity *)getFolderOrFileInfo:(NSDictionary *)folderDic {
    IMBiCloudDriveFolderEntity *entity = nil;
    if (folderDic != 0) {
        //        if (subDic != nil) {
        entity = [[[IMBiCloudDriveFolderEntity alloc] init] autorelease];
        if ([folderDic.allKeys containsObject:@"drivewsid"]) {
            [entity setDrivewsid:[folderDic objectForKey:@"drivewsid"]];
        }
        if ([folderDic.allKeys containsObject:@"docwsid"]) {
            [entity setDocwsid:[folderDic objectForKey:@"docwsid"]];
        }
        if ([folderDic.allKeys containsObject:@"zone"]) {
            [entity setZone:[folderDic objectForKey:@"zone"]];
        }
        if ([folderDic.allKeys containsObject:@"name"]) {
            [entity setName:[folderDic objectForKey:@"name"]];
        }
        if ([folderDic.allKeys containsObject:@"etag"]) {
            [entity setEtag:[folderDic objectForKey:@"etag"]];
        }
        if ([folderDic.allKeys containsObject:@"type"]) {
            [entity setType:[folderDic objectForKey:@"type"]];
        }
        if ([folderDic.allKeys containsObject:@"parentId"]) {
            [entity setParentId:[folderDic objectForKey:@"parentId"]];
        }
        
        if ([entity.type isEqualToString:@"FILE"]) {
            if ([folderDic.allKeys containsObject:@"dateModified"]) {
                [entity setDateModified:[folderDic objectForKey:@"dateModified"]];
            }
            if ([folderDic.allKeys containsObject:@"size"]) {
                [entity setSize:[[folderDic objectForKey:@"size"] longLongValue]];
            }
            if ([folderDic.allKeys containsObject:@"extension"]) {
                [entity setExtension:[folderDic objectForKey:@"extension"]];
                NSWorkspace *workSpace = [[NSWorkspace alloc] init];
                NSImage *icon = [workSpace iconForFileType:entity.extension];
                [icon setSize:NSMakeSize(56, 52)];
                [entity setImage:icon];
                [workSpace release];
            }else{
                NSWorkspace *workSpace = [[NSWorkspace alloc] init];
                NSImage *icon = [workSpace iconForFileType:@"dll"];
                [icon setSize:NSMakeSize(56, 52)];
                [entity setImage:icon];
                [workSpace release];
            }
        }else {
            OSType code = UTGetOSTypeFromString((CFStringRef)@"fldr");
            NSImage *picture = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(code)];
            [picture setSize:NSMakeSize(56, 52)];
            [entity setImage:picture];

            if ([entity.type isEqualToString:@"APP_LIBRARY"]) {
                if ([folderDic.allKeys containsObject:@"maxDepth"]) {
                    [entity setMaxDepth:[folderDic objectForKey:@"maxDepth"]];
                }
                if ([folderDic.allKeys containsObject:@"supportedExtensions"]) {
                    [entity setSupportedExtensions:[folderDic objectForKey:@"supportedExtensions"]];
                }
            }
        }
    }
    return entity;
}

#pragma iCloud Drive下载方法
- (void)iCloudDriveDownload:(NSString *)urlStr withPath:(NSString *)path {
    if (_netClient != nil) {
        [_netClient downloadiCloudFile:urlStr withPath:path withStartBytes:0];
    }
}

- (void)iCloudDriveDownload:(NSString *)urlStr withPath:(NSString *)path withStartBytes:(long long)startBytes {
    if (_netClient != nil) {
        [_netClient downloadiCloudFile:urlStr withPath:path withStartBytes:startBytes];
    }
}

//获得iCloudDrive中要被下载的文件的下载信息:docwsid、zone、extension分别对应IMBiCloudDriveFolderEntity实体中得_docwsid、_zone、_extension;   返回url字符串
- (NSString *)getiCloudDriveFileDownloadInfo:(NSString *)docwsid withZone:(NSString *)zone withExtension:(NSString *)extension {
    NSString *urlStr = @"";
    NSString *keyStr = @"";
    @try {
        NSDictionary *ret = [_netClient getiCloudDriveUrl:[NSString stringWithFormat:@"/ws/%@/download/by_id?document_id=%@", zone, docwsid]];
        
        if (ret != nil) {
            if ([extension isEqualToString:@"pages"] || [extension isEqualToString:@"numbers"] || [extension isEqualToString:@"key"]) {
                keyStr = @"package_token";
            }else {
                keyStr = @"data_token";
            }
            if ([ret.allKeys containsObject:keyStr]) {
                NSDictionary *subDic = [ret objectForKey:keyStr];
                if (subDic != nil) {
                    if ([subDic.allKeys containsObject:@"url"]) {
                        urlStr = [subDic objectForKey:@"url"];
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"getiCloudDriveFileDownloadInfo exception :%@",exception.reason]];
    }
    
    return urlStr;
}

#pragma iCloud Drive上传方法
- (BOOL)iCloudDriveUpload:(NSString *)filePath withFileSize:(long long)fileSize withZone:(NSString *)zone withContentType:(NSString *)contentType {
    BOOL ret = NO;
    @try {
        //上传文件到iCloudDrive的准备工作
        //postStr -->请求的post数据："{\"filename\":\"%@\",\"type\":\"FILE\",\"content_type\":\"text/plain\",\"size\":%lld}",fileName, fileSize
        NSString *postStr = [NSString stringWithFormat:@"{\"filename\":\"%@\",\"type\":\"FILE\",\"content_type\":\"%@\",\"size\":%lld}",[filePath lastPathComponent], contentType, fileSize];
        NSArray *retArray = [_netClient postiCloudDriveContent:@"docws" withPath:@"/ws/com.apple.CloudDocs/upload/web" withPostStr:postStr];
        if (retArray != nil && [retArray isKindOfClass:[NSArray class]]) {
            NSDictionary *contentDic = [retArray objectAtIndex:0];
            NSString *urlStr = @"";
            if ([contentDic.allKeys containsObject:@"url"]) {
                urlStr = [contentDic objectForKey:@"url"];
            }
            if ([contentDic.allKeys containsObject:@"document_id"]) {
                _documentID = [contentDic objectForKey:@"document_id"];
            }

            if (![StringHelper stringIsNilOrEmpty:urlStr]) {
                ret = [_netClient uploadFileToiCloud:urlStr withFilePath:filePath withInfoName:@"" withContentType:contentType withIsPhoto:NO];
            }
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"icloud Drive Update exception :%@",exception.reason]];
    }
    return ret;
}

//**********上传完后更新***********
- (NSDictionary *)updateFileAfterUpload:(NSDictionary *)retDic withParentDir:(NSString *)parentDirId withUploadFileName:(NSString *)fileName {
    NSDictionary *desDic = nil;
    @try {
        if (_documentID != nil) {
            desDic = [_netClient updateFileAfterUpload:retDic withRetDocumentID:_documentID withParentDir:parentDirId withUploadFileName:fileName];
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"upload File After Update exception :%@",exception.reason]];
    }
    return desDic;
}


- (void)cancel {
    [_netClient.downloadService cancelConnection];
}

#pragma iCloud Drive删除方法
- (NSDictionary *)deleteiCloudDriveArray:(NSArray *)array {
    NSString *pathStr = @"/deleteItems?clientBuildNumber=17AProject84&clientMasteringNumber=17A77&dsid=%@";
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *postArr = [[NSMutableArray alloc] init];
    for (IMBiCloudDriveFolderEntity *entity in array) {
        NSMutableDictionary *singDic = [[NSMutableDictionary alloc] init];
        if (entity.drivewsid != nil) {
            [singDic setObject:entity.drivewsid forKey:@"drivewsid"];
        }
        if (entity.etag != nil) {
            [singDic setObject:entity.etag forKey:@"etag"];
        }
        if (singDic != nil) {
            [postArr addObject:singDic];
            [singDic release];
        }
    }
    
    if (postArr != nil) {
        [postDic setObject:postArr forKey:@"items"];
        [postArr release];
    }
    
    NSString *postStr = [TempHelper dictionaryToJson:postDic];
    [postDic release];
    
    NSDictionary *retDic = nil;
    @try {
        if (postStr) {
            retDic = [_netClient postInformationContent:@"drivews" withPath:pathStr withPostStr:postStr];
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"delete iCloud Drive exception :%@",exception.reason]];
    }
    
    return retDic;
}

#pragma iCloud Drive创建文件夹方法
- (NSDictionary *)createiCloudDriveFolder:(NSString *)parentDrivewsId withFolderName:(NSString *)folderName {
    NSString *pathStr = @"/createFolders?clientBuildNumber=17AProject84&clientMasteringNumber=17A77&dsid=%@";

    CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
    NSString *clientId = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
    NSString *postStr = [NSString stringWithFormat:@"{\"destinationDrivewsId\":\"%@\",\"folders\":[{\"clientId\":\"%@\",\"name\":\"%@\"}]}",parentDrivewsId,clientId,folderName];
    NSDictionary *retDic = nil;
    @try {
        if (postStr) {
            retDic = [_netClient postInformationContent:@"drivews" withPath:pathStr withPostStr:postStr];
            
            if (retDic != nil) {
                
            }
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"delete iCloud Drive exception :%@",exception.reason]];
    }
    
    return retDic;
}

@end
