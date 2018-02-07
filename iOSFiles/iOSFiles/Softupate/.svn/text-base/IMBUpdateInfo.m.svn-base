//
//  IMBUpdateInfo.m
//  UpdatePlistWrite
//
//  Created by Pallas on 12/30/12.
//  Copyright (c) 2012 iMobie Inc. All rights reserved.
//

#import "IMBUpdateInfo.h"

@implementation IMBUpdateInfo
@synthesize buildDate = _buildDate;
@synthesize iOSversion = _iOSversion;
@synthesize itunesVersion = _itunesVersion;
@synthesize minBuildDate = _minBuildDate;
@synthesize version = _version;
@synthesize updateLogArray = _updateLogArray;
@synthesize isMustUpdate = _isMustUpdate;
@synthesize isauto = _isauto;

- (id)init {
    self = [super init];
    if (self) {
        _updateLogArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_updateLogArray release];
    [super dealloc];
}

@end

@implementation IMBUpdateLogDetail
@synthesize language = _language;
@synthesize updateLogs = _updateLogs;
@synthesize updateUrl = _updateUrl;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end

@implementation IMBActivityInfo
@synthesize iosmoverArray = _iosmoverArray;
@synthesize icloudUrlInfo = _icloudUrlInfo;
@synthesize downloadUrlInfo = _downloadUrlInfo;
@synthesize iosBtnWord = _iosBtnWord;
@synthesize iosDescriptionWord = _iosDescriptionWord;
@synthesize iosTitleWord = _iosTitleWord;
@synthesize iosSubTitleWord = _iosSubTitleWord;

- (id)init {
    if (self = [super init]) {
        _iosmoverArray = [[NSMutableArray alloc] init];
        _icloudUrlInfo = [[IMBDownloadUrlInfo alloc] init];
        _downloadUrlInfo = [[IMBDownloadUrlInfo alloc] init];
    }
    return self;
}

- (void)setIosBtnWord:(NSString *)iosBtnWord {
    if (_iosBtnWord) {
        [_iosBtnWord release];
        _iosBtnWord = nil;
    }
    _iosBtnWord = [iosBtnWord retain];
}

- (void)setIosDescriptionWord:(NSString *)iosDescriptionWord {
    if (_iosDescriptionWord) {
        [_iosDescriptionWord release];
        _iosDescriptionWord = nil;
    }
    _iosDescriptionWord = [iosDescriptionWord retain];
}

- (void)setIosTitleWord:(NSString *)iosTitleWord {
    if (_iosTitleWord) {
        [_iosTitleWord release];
        _iosTitleWord = nil;
    }
    _iosTitleWord = [iosTitleWord retain];
}

- (void)setIosSubTitleWord:(NSString *)iosSubTitleWord {
    if (_iosSubTitleWord) {
        [_iosSubTitleWord release];
        _iosSubTitleWord = nil;
    }
    _iosSubTitleWord = [iosSubTitleWord retain];
}

- (void)dealloc {
    if (_iosBtnWord) {
        [_iosBtnWord release];
        _iosBtnWord = nil;
    }
    if (_iosDescriptionWord) {
        [_iosDescriptionWord release];
        _iosDescriptionWord = nil;
    }
    if (_iosTitleWord) {
        [_iosTitleWord release];
        _iosTitleWord = nil;
    }
    if (_iosSubTitleWord) {
        [_iosSubTitleWord release];
        _iosSubTitleWord = nil;
    }
    [_iosmoverArray release], _iosmoverArray = nil;
    [_icloudUrlInfo release], _icloudUrlInfo = nil;
    [_downloadUrlInfo release], _downloadUrlInfo = nil;
    [super dealloc];
}

@end

@implementation IMBDownloadUrlInfo
@synthesize moveVideoUrl = _moveVideoUrl;
@synthesize convertVideoUrl = _convertVideoUrl;
@synthesize migrateMediaUrl = _migrateMediaUrl;
@synthesize transferUrl = _transferUrl;
@synthesize downloadCount = _downloadCount;
@synthesize gatherUrl = _gatherUrl;

- (id)init {
    if (self = [super init]) {
        _downloadCount = 2;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
