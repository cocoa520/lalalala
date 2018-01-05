//
//  IMBNewTrack.h
//  iMobieTrans
//
//  Created by Pallas on 1/6/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"

@interface IMBNewTrack : NSObject {
@private
    NSString *_title;
    NSString *_artist;
    NSString *_album;
    NSString *_comments;
    NSString *_genre;
    uint _length;
    uint _bitrate;
    NSString *_composer;
    NSString *_descriptionText;
    uint _trackNumber;
    uint _year;
    uint _albumTrackCount;
    uint _discNumber;
    uint _totalDiscCount;
    NSString *_albumArtist;
    BOOL _isVideo;
    NSString *_artworkFile;
    int _sampleRate;
    long _durationFrame;
    int _audioChannels;
    int _playCount;
    int _rating;
    uint _lastPalyed;
    NSString *_fileExtension;
    uint _fileSize;
    NSString *_uuid;
    
    
    NSString *_filePath;
    MediaTypeEnum _dBMediaType;
    NSString *_bookFileName;
    NSString *_packageHashID;
    BOOL _isToDevice;
    NSData *_artworkData;
    NSString *_publisherUniqueID;

    
    
}
@property (nonatomic, readwrite, copy) NSString *publisherUniqueID;
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *artist;
@property (nonatomic, readwrite, copy) NSString *album;
@property (nonatomic, readwrite, copy) NSString *comments;
@property (nonatomic, readwrite, copy) NSString *genre;
@property (nonatomic, readwrite, copy) NSString *uuid;
@property (nonatomic, assign) BOOL isToDevice;

@property (nonatomic, readwrite) uint length;
@property (nonatomic, readwrite) uint bitrate;
@property (nonatomic, readwrite, copy) NSString *composer;
@property (nonatomic, readwrite, copy) NSString *descriptionText;
@property (nonatomic, readwrite) uint trackNumber;
@property (nonatomic, readwrite) uint year;
@property (nonatomic, readwrite) uint albumTrackCount;
@property (nonatomic, readwrite) uint discNumber;
@property (nonatomic, readwrite) uint totalDiscCount;
@property (nonatomic, readwrite, copy) NSString *albumArtist;
@property (nonatomic, readwrite) BOOL isVideo;
@property (nonatomic, readwrite, copy) NSString *artworkFile;
@property (nonatomic, readwrite) int sampleRate;
@property (nonatomic, getter = durationFrame, readonly) long durationFrame;
@property (nonatomic, readwrite) int audioChannels;
@property (nonatomic, readwrite) int playCount;
@property (nonatomic, readwrite) int rating;
@property (nonatomic, readwrite) uint lastPalyed;

@property (nonatomic, readwrite, copy) NSString *filePath;
@property (nonatomic, readwrite) MediaTypeEnum dBMediaType;
@property (nonatomic, readwrite, copy) NSString *bookFileName;
@property (nonatomic, readwrite, copy) NSString *fileExtension;
@property (nonatomic, readwrite) uint fileSize;
@property (nonatomic, readwrite, copy) NSString *packageHashID;
@property (nonatomic, readwrite, copy) NSData *artworkData;

- (long)durationFrame;

@end
