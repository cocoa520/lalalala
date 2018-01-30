//
//  IMBSyncPhotoData.h
//  iMobieTrans
//
//  Created by iMobie on 7/11/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBSyncPhotoData : NSObject {
    //album info
    int albumZpk;
    NSString *albumName;
    NSString *albumUUID;
    int albumKind;
    
    //photo info
    int photoZpk;
    NSString *photoUUID;
    long long photoDate;
    NSString *photoName;
    long photoFileSize;
    
    //生成的图片info
    NSString *imagePath;
    NSString *imageUUID;
    
    //缩略图info
    NSString *thumbPath;
    NSString *thumbName;
    
    BOOL _isFavorite;
    long long _photoCreateDate;
}

@property (assign) int albumZpk;
@property (retain) NSString *albumName;
@property (retain) NSString *albumUUID;
@property (assign) int  albumKind;

@property (assign) int photoZpk;
@property (retain) NSString *photoUUID;
@property (assign) long long photoDate;
@property (assign) long photoFileSize;

@property (retain) NSString *photoName;
@property (retain) NSString *imagePath;
@property (retain) NSString *imageUUID;

@property (retain) NSString *thumbPath;
@property (retain) NSString *thumbName;
@property (assign) BOOL isFavorite;
@property (assign) long long photoCreateDate;

@end
