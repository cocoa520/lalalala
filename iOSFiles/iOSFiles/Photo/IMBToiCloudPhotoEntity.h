//
//  IMBToiCloudPhotoEntity.h
//  AnyTrans
//
//  Created by JGehry on 7/18/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "IMBPhotoEntity.h"

@interface IMBToiCloudPhotoEntity : IMBPhotoEntity {
    NSString *_clientId;
    NSString *_iCloudAlbumType;
    NSString *_recordName;
    NSString *_iCloudDescription;
    NSString *_serverId;
    NSString *_type;
    NSString *_oriDownloadUrl;
    NSString *_thumbDownloadUrl;
    NSString *_thumbFileName;
    NSString *_ownerRecordName;
    NSString *_zoneName;
    NSString *_recordChangeTag;
    NSMutableArray *_subArray;
    
    BOOL _isloading;
    BOOL _isFavorite;
    int _thumbHeight;
    int _thumbWidth;
}

@property (nonatomic, readwrite, retain) NSString *clientId;
@property (nonatomic, readwrite, retain) NSString *iCloudAlbumType;
@property (nonatomic, readwrite, retain) NSString *recordName;
@property (nonatomic, readwrite, retain) NSString *iCloudDescription;
@property (nonatomic, readwrite, retain) NSString *serverId;
@property (nonatomic, readwrite, retain) NSString *type;
@property (nonatomic, readwrite, retain) NSString *oriDownloadUrl;
@property (nonatomic, readwrite, retain) NSString *thumbDownloadUrl;
@property (nonatomic, readwrite, retain) NSString *thumbFileName;
@property (nonatomic, readwrite, retain) NSString *ownerRecordName;
@property (nonatomic, readwrite, retain) NSString *zoneName;
@property (nonatomic, readwrite, retain) NSString *recordChangeTag;
@property (nonatomic, readwrite, retain) NSMutableArray *subArray;
@property (nonatomic, assign) BOOL isloading;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) int thumbHeight;
@property (nonatomic, assign) int thumbWidth;

@end
