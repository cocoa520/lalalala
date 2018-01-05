//
//  IMBVideoTrack.h
//
//
//  Created by iMobie on 2/6/17.
//
//

#import <Foundation/Foundation.h>
#import "IMBBaseEntity.h"

@interface IMBADVideoTrack : IMBBaseEntity {
@private
    long long _addTime;
    NSString *_addTimeShowStr;
    int _trackId;
    NSString *_url;
    NSString *_title;//没有后缀的名字
    NSString *_name;//有后缀的名字
    NSString *_singer;
    NSString *_album;
    long long _size;
    long long _time;
    NSString *_localPath;//导出到本地的路径
}
@property (nonatomic, readwrite) int trackId;
@property (nonatomic, readwrite, retain) NSString *title;
@property (nonatomic, readwrite, retain) NSString *name;
@property (nonatomic, readwrite, retain) NSString *singer;
@property (nonatomic, readwrite, retain) NSString *album;
@property (nonatomic, readwrite, retain) NSString *addTimeShowStr;
@property (nonatomic, readwrite, retain) NSString *url;
@property (nonatomic, readwrite) long long size;
@property (nonatomic, readwrite) long long time;
@property (nonatomic, readwrite) long long addTime;
@property (nonatomic, readwrite, retain) NSString *localPath;

@end