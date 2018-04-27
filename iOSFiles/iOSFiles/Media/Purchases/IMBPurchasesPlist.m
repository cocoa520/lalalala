//
//  IMBPurchasesPlist.m
//  iMobieTrans
//
//  Created by zhang yang on 13-7-13.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBPurchasesPlist.h"
#import "IMBIPod.h"
#import "IMBDeviceInfo.h"
#import "IMBFileSystem.h"
#import "IMBSession.h"
#import "IMBTrack.h"

@implementation IMBPurchasesPlist

- (id)initWithiPod:(IMBiPod *)iPod {
    self = [super init];
    if (self) {
        _iPod = iPod;
    }
    return self;
}

-(NSMutableArray*) getPurchasesFromPlist {
    NSMutableArray *tracks = [[[NSMutableArray alloc] init] autorelease];
    if (_iPod.deviceInfo.isIOSDevice )
    {
        //IMBPurchasesInfo *purchasesInfo = [[[IMBPurchasesInfo alloc] init] autorelease];
        //1.生成PurchasesInfo.
        NSString *infoPath = nil;
        infoPath = [_iPod.fileSystem.driveLetter stringByAppendingPathComponent:@"Purchases/StorePurchasesInfo.plist"];
        //TODO 这个地方需要弄这个update的时间吗。
        /*
        if ([_iPod.fileSystem fileExistsAtPath:infoPath])
        {
            IPhoneFileInfo info = iPhone.GetFileInfo(infoPath);
            string EditedTime = info.LastEdited.ToString();
            if (!string.IsNullOrEmpty(EditedTime) && EditedTime != "0")
            {
                EditedTime = EditedTime.Length > 10 ? EditedTime.Substring(0, 10) : EditedTime;
                pInfo.LastUpdateTime = Helpers.GetDateTimeFromTimeStamp1970(long.Parse(EditedTime), Convert.ToInt64(_iPod.DeviceInfo.TimeZoneOffsetFromUTC));
            }
        }
        */
        NSString *purchasesPath = [_iPod.fileSystem.driveLetter stringByAppendingPathComponent:@"Purchases"];
        NSArray *fileInfos = [_iPod.fileSystem getItemInDirectory:purchasesPath];
        for (AMFileEntity *file in fileInfos) {
            @try {
                if (file.FileType == AMRegularFile && [@"plist" isEqualToString:[file.FilePath pathExtension]] && file.FileSize > 0) {
                    
                    IMBTrack *track = [self getPurchasesTrackFromPlist:file.FilePath];
                    if (track != nil)
                    {
                        [tracks addObject:track];
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception.description);
            }
        }
        /*
        if (purchasesInfo.purchasesTracks.count > 0) {
            purchasesInfo.hasPurchases = true;
        }
        */
        
    }

    return tracks;
}

- (IMBTrack*) getPurchasesTrackFromPlist:(NSString*)filePath {
    NSString *localPath = [[_iPod.session sessionFolderPath] stringByAppendingPathComponent:[filePath lastPathComponent]];
    [_iPod.fileSystem copyRemoteFile:filePath toLocalFile:localPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:localPath ]) {
        NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:localPath];
        IMBTrack *track = [[[IMBTrack alloc] init] autorelease];
        //FilePath
        if ([plistDic objectForKey:@"com.apple.iTunesStore.downloadInfo"])
        {
            NSDictionary *dnloadInfo = [plistDic objectForKey:@"com.apple.iTunesStore.downloadInfo"];
            if ([dnloadInfo objectForKey:@"mediaAssetFilename"])
            {
                track.filePath = [@"Purchases" stringByAppendingPathComponent:[dnloadInfo objectForKey:@"mediaAssetFilename"]];
                if ([_iPod.fileSystem fileExistsAtPath:[_iPod.fileSystem.driveLetter stringByAppendingPathComponent:track.filePath]])
                {
                    track.FileIsExist = true;
                }
            }
            
            
            if ([dnloadInfo objectForKey:@"trackPersistentID"])
            {
                //TODO 读出来会不会为负数而导致不匹配
                track.dbID = [(NSNumber*)[dnloadInfo objectForKey:@"trackPersistentID"] longLongValue];
            }
            
            //artworkAssetFilename
            if ([dnloadInfo objectForKey:@"artworkAssetFilename"])
            {
                
                NSString *artworkFileName = [@"Purchases" stringByAppendingPathComponent:[dnloadInfo objectForKey:@"artworkAssetFilename"]];
                if ([_iPod.fileSystem fileExistsAtPath:[_iPod.fileSystem.driveLetter stringByAppendingPathComponent:artworkFileName]])
                {
                    track.artworkPath = artworkFileName;
                }
                
            }
        }
        return track;
    }
    return nil;
}
    
@end
