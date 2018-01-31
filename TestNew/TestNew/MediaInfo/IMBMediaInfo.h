//
//  IMBMediaInfo.h
//  iMobieTrans
//
//  Created by iMobie on 5/4/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HowToUse.h"
#import "NSData+Base64.h"


@class IMBMediaInfo;


@interface IMBMediaInfo : NSObject{
    BOOL _validTags;
    BOOL _validAudioProperties;
    BOOL _isVideo;
    NSString *_path;
    
    NSString *_title;
    NSString *_artist;
    NSString *_albumArtist;
    NSString *_album;
    NSString *_comment;
    NSString *_genre;
    NSNumber *_track;
    NSNumber *_year;
    
    NSNumber *_length;
    NSNumber *_sampleRate;
    NSNumber *_bitRate;
    NSNumber *_channels;
    NSNumber *_fileSize;
    NSString *_artworkPath;
    NSString *_composer;
    BOOL _isGotMetaData;
    
    NSString *AppleStoreAccount;
    NSString *AppleStoreCatalogID;
    
    NSData *_artworkData;
    
    NSNumber *_videowidth;
    NSNumber *_videoheight;
    
}
@property (nonatomic,assign)BOOL isVideo;
@property (nonatomic,retain) NSNumber *videowidth;
@property (nonatomic,retain) NSNumber *videoheight;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain)NSString *albumArtist;
@property (nonatomic, retain) NSString *artworkPath;
@property (nonatomic, retain)  NSString *AppleStoreAccount;
@property (nonatomic, retain)  NSString *AppleStoreCatalogID;
@property (nonatomic) BOOL validTags;
@property (nonatomic) BOOL validAudioProperties;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *album;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSString *genre;
@property (nonatomic, retain) NSString *composer;
@property (nonatomic, retain) NSNumber *track;
@property (nonatomic, retain) NSNumber *year;

@property (nonatomic, retain) NSNumber *length;
@property (nonatomic, retain) NSNumber *sampleRate;
@property (nonatomic, retain) NSNumber *bitRate;
@property (nonatomic, retain) NSNumber *channels;
@property (nonatomic, retain) NSNumber *fileSize;
@property (nonatomic) BOOL isGotMetaData;

@property (nonatomic, retain) NSData *artworkData;

//- (NSString*)getArtwork:(NSString*)filePath;
- (void)openWithFilePath:(NSString *)filePath;
+ (IMBMediaInfo *)singleton;

@end
