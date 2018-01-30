//
//  IMBBookEntity.m
//  iMobieTrans
//
//  Created by iMobie on 14-3-17.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBookEntity.h"

@implementation IMBBookEntity
@synthesize bookID = _bookID;
@synthesize author = _author;
@synthesize size = _size;
@synthesize extension = _extension;
@synthesize bookName = _bookName;
@synthesize genre= _genre;
@synthesize collectionID = _collectionID;
@synthesize path =_path;
@synthesize isPurchase = _isPurchase;
@synthesize dataBaseKey = _dataBaseKey;
@synthesize coverPath = _coverPath;
@synthesize coverImage = _coverImage;
@synthesize bookTitle = _bookTitle;
@synthesize fullPath = _fullPath;
@synthesize kind = _kind;
@synthesize packageHash = _packageHash;
@synthesize mimeType = _mimeType;
@synthesize publisherUniqueID = _publisherUniqueID;
@synthesize hasArtwork = _hasArtwork;
@synthesize isProtected = _isProtected;
@synthesize album = _album;
@synthesize isAdd = _isAdd;
- (NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapAtt = @{
                             @"bookID":@"Persistent ID",
                             @"author":@"Artist",
                             @"bookName":@"Name",
                             @"path":@"Path",
                             @"genre":@"Genre",
                             @"dataBaseKey":@"s",
                             @"kind":@"Kind",
                             @"packageHash":@"Package Hash",
                             @"mimeType":@"MIME Type",
                             @"publisherUniqueID":@"Publisher Unique ID",
                             @"album":@"Album"
                             };
    return mapAtt;
}


- (void)dealloc
{
    [_bookID release];
    [_author release];
    [_extension release];
    [_bookName release];
    [_genre release];
    [_collectionID release];
    [_path release];
    [_dataBaseKey release];
    [_coverPath release];
    [_coverImage release];
    [_fullPath release];
    [_kind release];
    [_packageHash release];
    [_mimeType release];
    [_publisherUniqueID release];
    [_album release];
    [super dealloc];
}
@end
