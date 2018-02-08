//
//  IMBAudioTrack.h
//
//
//  Created by iMobie on 2/6/17.
//
//

#import <Foundation/Foundation.h>
#import "IMBBaseEntity.h"

@interface IMBADAudioTrack : IMBBaseEntity {
@private
    int _trackId;
    NSString *_title;
    NSString *_singer;
    NSString *_album;
    NSString *_url;
    NSString *_name;
    long long _size;
    long long _time;
    int _albumId;
    NSString *_mimeType;
    NSString *_localPath;//导出到本地的路径
}
@property (nonatomic, readwrite) int trackId;
@property (nonatomic, readwrite, retain) NSString *title;
@property (nonatomic, readwrite, retain) NSString *singer;
@property (nonatomic, readwrite, retain) NSString *album;
@property (nonatomic, readwrite, retain) NSString *url;
@property (nonatomic, readwrite, retain) NSString *name;
@property (nonatomic, readwrite) long long size;
@property (nonatomic, readwrite) long long time;
@property (nonatomic, readwrite) int albumId;
@property (nonatomic, readwrite, retain) NSString *mimeType;
@property (nonatomic, readwrite, retain) NSString *localPath;

@end