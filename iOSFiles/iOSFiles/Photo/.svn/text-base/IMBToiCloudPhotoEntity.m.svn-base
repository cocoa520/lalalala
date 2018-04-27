//
//  IMBToiCloudPhotoEntity.m
//  AnyTrans
//
//  Created by JGehry on 7/18/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "IMBToiCloudPhotoEntity.h"

@implementation IMBToiCloudPhotoEntity
@synthesize clientId = _clientId;
@synthesize iCloudAlbumType =_iCloudAlbumType;
@synthesize recordName = _recordName;
@synthesize iCloudDescription = _iCloudDescription;
@synthesize serverId = _serverId;
@synthesize type = _type;
@synthesize oriDownloadUrl = _oriDownloadUrl;
@synthesize thumbDownloadUrl = _thumbDownloadUrl;
@synthesize thumbFileName = _thumbFileName;
@synthesize ownerRecordName = _ownerRecordName;
@synthesize zoneName = _zoneName;
@synthesize recordChangeTag = _recordChangeTag;
@synthesize subArray = _subArray;

- (id)init
{
    if (self = [super init]) {
        _clientId = @"";
        _iCloudDescription = @"";
        _type = @"";
        _serverId = @"";
        _isFavorite = NO;
        _oriDownloadUrl = @"";
        _thumbDownloadUrl = @"";
        _thumbHeight = 0;
        _thumbWidth = 0;
        _ownerRecordName = @"";
        _zoneName = @"";
        _thumbFileName = @"dm";
        _recordChangeTag = @"";
        _recordName = @"";
        _iCloudAlbumType = @"";
        _subArray = [[NSMutableArray alloc] init];
        return self;
    }else {
        return nil;
    }
}

- (void)dealloc
{
    [_subArray release],_subArray = nil;
    [super dealloc];
}

@end
