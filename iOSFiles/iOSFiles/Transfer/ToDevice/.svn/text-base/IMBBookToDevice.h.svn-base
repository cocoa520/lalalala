//
//  IMBBookToDevice.h
//  iMobieTrans
//
//  Created by iMobie on 8/14/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBaseTransfer.h"
#import "IMBiPod.h"
#import "IMBDeviceInfo.h"
#import "IMBFileSystem.h"

@interface IMBBookToDevice : IMBBaseTransfer {
    NSMutableArray *bookEntityList;
    IMBiPod *_srcIpod;
    
    NSString *slocalPath;
    NSString *tlocalPath;
    NSMutableArray *plistModelList;
    int _currentItem;
}

@property (nonatomic,assign) int currentItem;

- (id)initWithSrcIpod:(IMBiPod *)srcIpod desIpod:(IMBiPod *)desIpod bookList:(NSArray*)bookList Delegate:(id)delegate;
- (BOOL)prepareData;

@end

@interface BookPlistModel : NSObject{
    NSString *_album;
    NSString *_artist;
    NSString *_extension;
    NSString *_genre;
    BOOL _hasArtwork;
    BOOL _isProtected;
    NSString *_kind;
    NSString *_MIMEType;
    NSString *_name;
    NSString *_packageHash;
    NSString *_path;
    NSString *_persistentID;
    NSString *_publisherUniqueID;
}

@property (nonatomic,retain) NSString *album;
@property (nonatomic,retain) NSString *artist;
@property (nonatomic,retain) NSString *extension;
@property (nonatomic,retain) NSString *genre;
@property (nonatomic,assign) BOOL hasArtwork;
@property (nonatomic,assign) BOOL isProtected;
@property (nonatomic,assign) NSString *kind;
@property (nonatomic,assign) NSString *MIMEType;
@property (nonatomic,assign) NSString *name;
@property (nonatomic,assign) NSString *packageHash;
@property (nonatomic,assign) NSString *path;
@property (nonatomic,assign) NSString *persistentID;
@property (nonatomic,assign) NSString *publisherUniqueID;

@end