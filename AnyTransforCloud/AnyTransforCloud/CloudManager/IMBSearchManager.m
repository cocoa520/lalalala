//
//  IMBSearchManager.m
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/5/10.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBSearchManager.h"
#import "IMBBaseManager.h"
#import "StringHelper.h"
#import "IMBCloudManager.h"
#define DownSearchCount @"100" //一次搜索内容的个数
@implementation IMBSearchManager
@synthesize delegate = _delegate;
@synthesize isCancel = _isCancel;

- (id)init {
    if (self=[super init]) {
        _searchAry = [[NSMutableArray alloc]init];
    }
    return self;
}

+ (IMBSearchManager*)singleton {
    static IMBSearchManager *_singleton = nil;
    @synchronized(self) {
        if (_singleton == nil) {
            _singleton = [[IMBSearchManager alloc] init];
        }
    }
    return _singleton;
}

#pragma mark - 搜索
- (void)searchName:(NSString*)name WithCloudDriveID:(NSString *)driveID WithFileType:(FileTypeEnum)fileTypeEnum WithDate:(DateTypeEnum)dateTypeEnum {
    [_searchAry removeAllObjects];
    _fileTypeEnum = fileTypeEnum;
    _dateTypeEntum = dateTypeEnum;
    _searchName = name;
    if ([StringHelper stringIsNilOrEmpty:driveID]) {
        IMBCloudManager *cloudManager = [IMBCloudManager singleton];
        NSMutableDictionary *managerDic = [cloudManager cloudManagerDic];
        for (IMBBaseManager *manager in managerDic.allValues) {
            if (_isCancel) {
                return;
            }
//            if ([manager.baseDrive.driveType isEqualToString:GoogleDriveCSEndPointURL]||[manager.baseDrive.driveType isEqualToString:OneDriveCSEndPointURL]||[manager.baseDrive.driveType isEqualToString:DropboxCSEndPointURL]||[manager.baseDrive.driveType isEqualToString:BoxCSEndPointURL]) {
//                 if ([manager.baseDrive.driveType isEqualToString:DropboxCSEndPointURL])
//                 {
                     [manager setSearchDelegete:self];
                     [manager searchContent:name withLimit:DownSearchCount withPageIndex:@""];
//                 }
//            }
        }
    }else {
        IMBCloudManager *cloudManager = [IMBCloudManager singleton];
        ;
        IMBBaseManager *manage = [cloudManager getCloudManager:[cloudManager getBindDrive:driveID]];
        [manage setSearchDelegete:self];
        [manage searchContent:name withLimit:DownSearchCount withPageIndex:@""];
    }
}

#pragma mark - 搜索完成结果
- (void)loadDriveComplete:(NSMutableArray *)ary withNextPageToken:(NSString *)nextString withManager:(IMBBaseManager *) baseManager {
    if (_isCancel) {
        return;
    }
    [_searchAry removeAllObjects];
    for (IMBDriveModel *model in ary) {
        BOOL isFileType = NO;
        if (_dateTypeEntum != AnytimeEnum) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *resDate = [formatter dateFromString:model.createdDateString];
            if (resDate !=nil) {
                isFileType = [self isWithinTimeRange:_dateTypeEntum withDate:resDate];
            }
        }else {
            isFileType = YES;
        }
        BOOL isSearchFile = NO;
        if (_fileTypeEnum == AllFile) {
            isSearchFile = YES;
        }else if (model.fileTypeEnum == _fileTypeEnum) {
            isSearchFile = YES;
        }
        if (isSearchFile && isFileType) {
            [_searchAry addObject:model];
        }
    }
    if ([nextString isKindOfClass:[NSString class]]) {
        NSString *tmpString = (NSString *)nextString;
        if (![StringHelper stringIsNilOrEmpty:tmpString]) {
            [baseManager searchContent:_searchName withLimit:DownSearchCount withPageIndex:tmpString];
        }else {
        }
        if ([_delegate respondsToSelector:@selector(searchDataComplete:)]) {
            [_delegate searchDataComplete:_searchAry];
        }
    }else {
        int temTag = (int)nextString;
        if (temTag != 0) {
            [baseManager searchContent:_searchName withLimit:DownSearchCount withPageIndex:[NSString stringWithFormat:@"%d",temTag]];
        }else {
            
        }
        if ([_delegate respondsToSelector:@selector(searchDataComplete:)]) {
            [_delegate searchDataComplete:_searchAry];
        }
    }
}

- (void)loadDriveDataFail {
    if (_isCancel) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(searchDataFail)]) {
        [_delegate searchDataFail];
    }
}

- (BOOL)isWithinTimeRange:(DateTypeEnum)fileTypeEnum withDate:(NSDate *)date {
   NSInteger dayCount = [self getDaysFrom:date To:[NSDate date]];
    if (fileTypeEnum == ToDayEnum) {
        if (dayCount == 0) {
            return YES;
        }
    }else if (fileTypeEnum == YesterdayEnum) {
        if (dayCount == 1) {
            return YES;
        }
    }else if (fileTypeEnum == Last7Enum) {
        if (dayCount <= 7) {
            return YES;
        }
    }else if (fileTypeEnum == Last30Enum) {
        if (dayCount <= 30) {
            return YES;
        }
    }
    return NO;
}

- (NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    [gregorian release];
    gregorian = nil;
    return dayComponents.day;
}

#pragma mark - 搜索结果
- (void)getFolderInfoFileID:(NSString *)fileID WithBaseManager:(IMBBaseManager *)baseManager {
    _baseManager = baseManager;
    if (_pathAry) {
        [_pathAry release];
        _pathAry = nil;
    }
    _pathAry = [[NSMutableArray alloc]init];
    [baseManager getFolderInfo:fileID];
    [baseManager setSearchDelegete:self];
}

- (void)getFolderComplete:(NSMutableArray *)ary {
    if (ary.count > 0) {
        NSString *fileID = [ary objectAtIndex:0];
        [_pathAry addObject:fileID];
        [_baseManager getFolderInfo:fileID];
    }else {
        if ([_delegate respondsToSelector:@selector(searchChooseResultsComplete:)]) {
            [_delegate searchChooseResultsComplete:_pathAry];
        }
    }
}

- (void)dealloc {
    [super dealloc];
    if (_searchAry) {
        [_searchAry release];
        _searchAry = nil;
    }
}

@end
