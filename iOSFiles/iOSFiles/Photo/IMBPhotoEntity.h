//
//  IMBPhotoEntity.h
//  iMobieTrans
//
//  Created by iMobie on 14-6-16.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBaseEntity.h"

typedef enum AlbumType {
    CameraRoll = 1,
    PhotoStream = 2,
    PhotoLibrary = 3,
    PhotoShare = 4,
    WallPaper = 5,
    OtherAlbum = 6,
    SyncAlbum = 7,
    CreateAlbum = 8,
    VideoAlbum = 9,
    LivePhoto = 10,
    Screenshot = 11,
    Location = 12,
    PhotoSelfies = 13,
    Favorite = 14,
}AlbumTypeEnum;

//luolei add 2014 11 11
typedef enum AlbumSubType {
    OtherType = 1,//默认类型 除开微速摄影，全景图
    TimeLapse = 2,//微速摄影，隶属于VideoAlbum   //iOS8
    Panoramas = 3,//全景图，隶属于CameraRoll    //iOS7及以上
    ContinuousShooting = 4,
    SlowMove = 5,
}AlbumSubType;

typedef enum PhotoType {
    CommonType = 1,//一般图片；
    PhotoVideoType = 2,//photo video;
    PanoramasType = 3,//全景图    //iOS7及以上
    ContinuousShootingType = 4,//连拍图片，iPhone6支持
    TimeLapseType = 5,//微速摄影，隶属于VideoAlbum   //iOS8
    SlowMoveType = 6,//慢放，隶属于VideoAlbum   //iOS8
}PhotoTypeEnum;

@interface IMBPhotoEntity : IMBBaseEntity {
@private
    //album data
    BOOL isSelect;
    int albumZpk;
    int photoCounts;
    int albumKind;
    NSString *albumTitle;
    NSData *albumUUID;
    NSString *albumUUIDString;
    AlbumTypeEnum albumType;
    AlbumSubType albumSubType;
    NSString *photoBurstsID;  //用于连拍
    NSDate *createdDate;//创建时间
    //photo data
    int photoAsset;
    int photoZpk;
    int photoHeight;
    int photoWidth;
    int photoKind;
    int photoKindSubtype;//ios7;
    int photoRiginal;
    long long photoDateData;
    long long photoSize;
    NSDate *photoDate;
    NSString *photoName;
    NSString *photoTitle;
    NSString *photoPath;
    NSData *photoUUID;
    NSString *photoUUIDString;
    NSString *thumbPath;
    //    int libAlbumZpk;
    NSImage *photoImage;
    NSString *allPath;
    NSString *videoPath;
    PhotoTypeEnum photoType;  //判断图片与视频的分类
    NSImage *image;
    int loadingImage;
    NSData *photoImageData;
    NSRect imageRect;
    
    NSData *photoData;//第三个页面photo的data；
    
    BOOL isEditorPhoto;
    NSString *_catchName;
    NSString *_thumbImagePath;
    NSString *_oriPath;
    int _cloudLocalState;//由于判断是iCloud上的图片 3: 本地相机照片 6: iCloud照片  4: Photo Share照片 7: Unkown Format
    NSImage *_iCloudImage;
    NSMutableArray *_cloudPathArray;
    NSString *_toolTip;
    
    BOOL _isexisted;
    
    int kindSubType;  //等于2 是live photo
}
@property (nonatomic ,assign) int kindSubType;
@property (nonatomic,assign)BOOL isexisted;
@property(nonatomic, retain) NSString *oriPath;
@property(nonatomic, retain) NSString *thumbImagePath;
@property(retain, nonatomic) NSMutableArray *cloudPathArray;
@property(assign, nonatomic) int cloudLocalState;
@property(assign, nonatomic) BOOL isSelect;
@property(assign, nonatomic) NSRect imageRect;
@property(retain, nonatomic) NSImage *image;
@property(assign, nonatomic) int albumZpk;
@property(assign, nonatomic) int photoCounts;
@property(assign, nonatomic) int albumKind;
@property(retain, nonatomic) NSString *albumTitle;
@property(retain, nonatomic) NSData *albumUUID;
@property(retain, nonatomic) NSString *albumUUIDString;
@property(assign, nonatomic) AlbumTypeEnum albumType;
@property(assign, nonatomic) AlbumSubType albumSubType;
@property(retain,nonatomic) NSString *photoBurstsID;
@property(assign,nonatomic) NSDate *createdDate;
@property(assign, nonatomic) int photoAsset;
@property(assign, nonatomic) int photoZpk;
@property(assign, nonatomic) int photoHeight;
@property(assign, nonatomic) int photoWidth;
@property(assign, nonatomic) int photoKind;
@property(assign, nonatomic) int photoKindSubtype;
@property(assign, nonatomic) int photoRiginal;
@property(assign, nonatomic) long long photoDateData;
@property(assign, nonatomic) long long photoSize;
@property(retain, nonatomic) NSDate *photoDate;
@property(retain, nonatomic) NSString *photoName;
@property(retain, nonatomic) NSString *photoTitle;
@property(retain, nonatomic) NSString *photoPath;
@property(retain, nonatomic) NSData *photoUUID;
@property(retain, nonatomic) NSString *photoUUIDString;
@property(retain, nonatomic) NSString *thumbPath;
@property(retain, nonatomic) NSImage *photoImage;
@property(retain, nonatomic) NSString *allPath;
@property(retain, nonatomic) NSString *videoPath;
@property(assign, nonatomic) PhotoTypeEnum photoType;

@property(readwrite, nonatomic) int loadingImage;
@property(retain, nonatomic) NSData *photoImageData;
@property(retain, nonatomic) NSData *photoData;
@property(assign, nonatomic) BOOL isEditorPhoto;
@property(nonatomic, retain) NSString *catchName;
@property (nonatomic, retain) NSImage *iCloudImage;
@property (nonatomic, retain) NSString *toolTip;

@end
