//
//  IMBIDGenerator.m
//  iMobieTrans
//
//  Created by Pallas on 1/6/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBIDGenerator.h"
#import "IMBIPod.h"
#import "IMBTracklist.h"
#import "IMBTrack.h"
#import "IMBArtworkDB.h"
#import "IMBFileSystem.h"

@implementation IMBIDGenerator

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithIPod:(IMBiPod*)ipod {
    self = [self init];
    if (self) {
        iPod = ipod;
        _lastTrackID = 0;
        _lastDBID = 0;
        if ([[iPod tracks] trackArray] != nil) {
            int trackCount = (int)[[[iPod tracks] trackArray] count];
            IMBTrack *track = nil;
            for (int i = 0; i < trackCount; i++) {
                track = [[[iPod tracks] trackArray] objectAtIndex:i];
                if ([track iD] > _lastTrackID) {
                    _lastTrackID = [track iD];
                }
                
                if ([track dbID] > _lastDBID) {
                    _lastDBID = [track dbID];
                }
            }
        }
    }
    return self;
}

- (int)getNewTrackID {
    @synchronized(self){
        _lastTrackID++;
        return _lastTrackID;
    }
}

- (int64_t)getNewDBID {
    @synchronized(self){
        _lastDBID++;
        return _lastDBID;
    }
}

- (NSString*)getNewIPodFilePath:(IMBTrack*)track fileExtension:(NSString*)fileExtension {
    NSString *filePath = nil;
    NSString *folderName = nil;
    long num = random();
    folderName = [NSString stringWithFormat:@"F%02i", (int)(num % 50)];
    if ([track mediaType] == Ringtone) {
        filePath = [[iPod fileSystem] combinePath:[[iPod fileSystem] iPodControlPath] pathComponent:@"Ringtones"];
    } else if (track.mediaType == PDFBooks || track.mediaType == Books) {
        filePath = @"Books";
    } else {
        filePath = [[[iPod fileSystem] combinePath:[[iPod fileSystem] iPodControlPath] pathComponent:@"Music"] stringByAppendingPathComponent:folderName];
    }
    NSString *randomFileName = [[self getNewRandomFileName] stringByAppendingPathExtension:fileExtension];
    filePath = [filePath stringByAppendingPathComponent:randomFileName];
    NSRange range = [filePath rangeOfString:[[iPod fileSystem] driveLetter]];
    NSUInteger location = range.location;
    NSUInteger len = range.length;
    if (location == 0) {
        filePath = [filePath substringFromIndex:len];
    }
    filePath = [filePath stringByReplacingOccurrencesOfString:@"/" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,1)];
    return filePath;
}

- (NSString*)getNewRandomFileName {
    char charArr[5];
    
    for (int i = 0; i < 4; i++) {
        long num = random();
        charArr[i] = (int)num % 52;
        if (charArr[i] < 26) {
            charArr[i] += (91 - 26);
        } else {
            charArr[i] += (123 - 52);
        }
    }
    charArr[4] ='\0';
    return [[NSString stringWithCString:charArr encoding:NSUTF8StringEncoding] uppercaseString];
}

- (uint)getNewArtworkID {
    uint newArtworkID = 0;
    newArtworkID = [[iPod artworkDB] nextImageID];
    [[iPod artworkDB] setNextImageID:(newArtworkID + 1)];
    return newArtworkID;
}

- (int)getNewPodcastGroupID {
    _lastPodcastGroupID++;
    return _lastPodcastGroupID;
}

- (int64_t)getMaxTrackDBID {
    // ToDo 从数据库中取出设备的东西
    
    return 0;
}

@end
