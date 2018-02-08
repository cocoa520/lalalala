//
//  IMBPhotoEntity.h
//
//
//  Created by iMobie on 2/6/17.
//
//

#import <Foundation/Foundation.h>
#import "IMBBaseEntity.h"

@interface IMBADPhotoEntity : IMBBaseEntity {
@private
    int _photoId;
    int _thumbnilId;
    NSString *_url;
    NSString *_thumbnilUrl;
    NSString *_name;//有后缀的名字
    NSString *_title;//没有后缀的名字
    NSString *_mimeType;
    long long _size;
    long long _thumbnilSize;
    long long _time;
    int _width;
    int _height;
    BOOL _loadingImage;
    BOOL _isLoad;
    NSImage *_photoImage;
}
@property (nonatomic, readwrite) int photoId;
@property (nonatomic, readwrite, retain) NSString *url;
@property (nonatomic, readwrite, retain) NSString *name;
@property (nonatomic, readwrite, retain) NSString *title;
@property (nonatomic, readwrite) long long size;
@property (nonatomic, readwrite) long long time;
@property (nonatomic, readwrite) int width;
@property (nonatomic, readwrite) int height;
@property (nonatomic, readwrite) int thumbnilId;
@property (nonatomic, readwrite, retain) NSString *thumbnilUrl;
@property (nonatomic, readwrite) long long thumbnilSize;
@property (nonatomic, readwrite, retain) NSString *mimeType;
@property (nonatomic, assign) BOOL loadingImage;
@property (nonatomic, assign) BOOL isLoad;
@property (nonatomic, retain) NSImage *photoImage;

@end

@interface IMBADAlbumEntity : IMBBaseEntity {
@private
    NSString *_albumName;
    BOOL _isAppAlbum;
    int _count;
    long long _size;
    NSMutableArray *_photoArray;
}

@property (nonatomic, readwrite, retain) NSString *albumName;
@property (nonatomic, readwrite) BOOL isAppAlbum;
@property (nonatomic, readwrite) int count;
@property (nonatomic, readwrite) long long size;
@property (nonatomic, readwrite, retain) NSMutableArray *photoArray;

@end