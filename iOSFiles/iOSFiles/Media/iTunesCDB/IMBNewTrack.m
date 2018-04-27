//
//  IMBNewTrack.m
//  iMobieTrans
//
//  Created by Pallas on 1/6/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBNewTrack.h"

@implementation IMBNewTrack
@synthesize title = _title;
@synthesize artist = _artist;
@synthesize album = _album;
@synthesize comments = _comments;
@synthesize genre = _genre;
@synthesize length = _length;
@synthesize bitrate = _bitrate;
@synthesize composer = _composer;
@synthesize descriptionText = _descriptionText;
@synthesize trackNumber = _trackNumber;
@synthesize year = _year;
@synthesize albumTrackCount = _albumTrackCount;
@synthesize discNumber = _discNumber;
@synthesize totalDiscCount = _totalDiscCount;
@synthesize albumArtist = _albumArtist;
@synthesize isVideo = _isVideo;
@synthesize artworkFile = _artworkFile;
@synthesize sampleRate = _sampleRate;
@synthesize audioChannels = _audioChannels;
@synthesize playCount = _playCount;
@synthesize rating = _rating;
@synthesize lastPalyed = _lastPalyed;
@synthesize filePath = _filePath;
@synthesize dBMediaType = _dBMediaType;
@synthesize bookFileName = _bookFileName;
@synthesize durationFrame = _durationFrame;
@synthesize fileExtension = _fileExtension;
@synthesize uuid = _uuid;
@synthesize isToDevice = _isToDevice;
@synthesize packageHashID = _packageHashID;
@synthesize artworkData = _artworkData;
@synthesize publisherUniqueID = _publisherUniqueID;
- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (long)durationFrame {
    return (long)([self sampleRate] * [self length]);
}

- (void)mediaType{

}

@end
