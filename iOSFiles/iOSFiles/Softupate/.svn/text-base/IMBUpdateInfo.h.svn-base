//
//  IMBUpdateInfo.h
//  UpdatePlistWrite
//
//  Created by Pallas on 12/30/12.
//  Copyright (c) 2012 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IMBDownloadUrlInfo;

@interface IMBUpdateInfo : NSObject {
    
    NSString *_itunesVersion;
    NSString *_minBuildDate;
    NSString *_version;
    NSString *_iOSversion;
    NSString *_buildDate;
    BOOL _isMustUpdate;
    BOOL _isauto;
    
    NSMutableArray *_updateLogArray;
    
}

@property (nonatomic, readwrite) BOOL isauto;
@property (nonatomic, readwrite) BOOL isMustUpdate;
@property (nonatomic, readwrite, retain) NSString *itunesVersion;
@property (nonatomic, readwrite, retain) NSString *minBuildDate;
@property (nonatomic, readwrite, retain) NSString *version;
@property (nonatomic, readwrite, retain) NSString *iOSversion;
@property (nonatomic, readwrite, retain) NSString *buildDate;
@property (nonatomic, readwrite, retain) NSMutableArray *updateLogArray;


@end

@interface IMBUpdateLogDetail : NSObject {
    NSString *_language;
    NSString *_updateUrl;
    NSArray *_updateLogs;
}

@property (nonatomic, readwrite, retain) NSString *language;
@property (nonatomic, readwrite, retain) NSString *updateUrl;
@property (nonatomic, readwrite, retain) NSArray *updateLogs;

@end

@interface IMBActivityInfo : NSObject {
    NSMutableArray *_iosmoverArray;
    IMBDownloadUrlInfo *_icloudUrlInfo;
    IMBDownloadUrlInfo *_downloadUrlInfo;
    
    NSString *_iosBtnWord;
    NSString *_iosDescriptionWord;
    NSString *_iosTitleWord;
    NSString *_iosSubTitleWord;
}

@property (nonatomic, readwrite, retain) NSMutableArray *iosmoverArray;
@property (nonatomic, readwrite, retain) IMBDownloadUrlInfo *icloudUrlInfo;
@property (nonatomic, readwrite, retain) IMBDownloadUrlInfo *downloadUrlInfo;
@property (nonatomic, readwrite, retain) NSString *iosBtnWord;
@property (nonatomic, readwrite, retain) NSString *iosDescriptionWord;
@property (nonatomic, readwrite, retain) NSString *iosTitleWord;
@property (nonatomic, readwrite, retain) NSString *iosSubTitleWord;

@end

@interface IMBDownloadUrlInfo : NSObject {
    NSString *_moveVideoUrl;
    NSString *_convertVideoUrl;
    NSString *_migrateMediaUrl;
    NSString *_transferUrl;
    NSString *_gatherUrl;
    int _downloadCount;
}

@property (nonatomic, readwrite, retain) NSString *moveVideoUrl;
@property (nonatomic, readwrite, retain) NSString *convertVideoUrl;
@property (nonatomic, readwrite, retain) NSString *migrateMediaUrl;
@property (nonatomic, readwrite, retain) NSString *transferUrl;
@property (nonatomic, readwrite, retain) NSString *gatherUrl;
@property (nonatomic, readwrite) int downloadCount;

@end
