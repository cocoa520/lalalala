//
//  IMBVideoTrack.m
//
//
//  Created by iMoibe on 2/6/17.
//
//

#import "IMBADVideoTrack.h"

@implementation IMBADVideoTrack
@synthesize trackId = _trackId;
@synthesize title = _title;
@synthesize singer = _singer;
@synthesize album = _album;
@synthesize url = _url;
@synthesize size = _size;
@synthesize time = _time;
@synthesize addTimeShowStr = _addTimeShowStr;
@synthesize addTime = _addTime;
@synthesize localPath = _localPath;
@synthesize name = _name;

- (void)dealloc
{
    if (_title != nil) {
        [_title release];
        _title = nil;
    }
    if (_url != nil) {
        [_url release];
        _url = nil;
    }
    if (_addTimeShowStr != nil) {
        [_addTimeShowStr release];
        _addTimeShowStr = nil;
    }
    if (_localPath != nil) {
        [_localPath release];
        _localPath = nil;
    }
    if (_singer != nil) {
        [_singer release];
        _singer = nil;
    }
    if (_album != nil) {
        [_album release];
        _album = nil;
    }
    if (_name != nil) {
        [_name release];
        _name = nil;
    }
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        _trackId = 0;
        _addTime = 0;
        _size = 0;
        _time = 0;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    if (_title != nil) {
        [_title release];
        _title = nil;
    }
    _title = [title retain];
}

- (void)setName:(NSString *)name {
    if (_name != nil) {
        [_name release];
        _name = nil;
    }
    _name = [name retain];
}

- (void)setUrl:(NSString *)url {
    if (_url != nil) {
        [_url release];
        _url = nil;
    }
    _url = [url retain];
}

- (void)setAddTimeShowStr:(NSString *)addTimeShowStr {
    if (_addTimeShowStr != nil) {
        [_addTimeShowStr release];
        _addTimeShowStr = nil;
    }
    _addTimeShowStr = [addTimeShowStr retain];
}

- (void)setLocalPath:(NSString *)localPath {
    if (_localPath != nil) {
        [_localPath release];
        _localPath = nil;
    }
    _localPath = [localPath retain];
}

- (void)setSinger:(NSString *)singer {
    if (_singer != nil) {
        [_singer release];
        _singer = nil;
    }
    _singer = [singer retain];
}
- (void)setAlbum:(NSString *)album {
    if (_album != nil) {
        [_album release];
        _album = nil;
    }
    _album = [album retain];
}


@end
