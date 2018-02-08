//
//  IMBAudioTrack.m
//
//
//  Created by iMoibe on 2/6/17.
//
//

#import "IMBADAudioTrack.h"

@implementation IMBADAudioTrack
@synthesize trackId = _trackId;
@synthesize title = _title;
@synthesize singer = _singer;
@synthesize album = _album;
@synthesize url = _url;
@synthesize size = _size;
@synthesize time = _time;
@synthesize albumId = _albumId;
@synthesize name = _name;
@synthesize mimeType = _mimeType;
@synthesize localPath = _localPath;

- (void)dealloc
{
    if (_title != nil) {
        [_title release];
        _title = nil;
    }
    if (_singer != nil) {
        [_singer release];
        _singer = nil;
    }
    if (_url != nil) {
        [_url release];
        _url = nil;
    }
    if (_album != nil) {
        [_album release];
        _album = nil;
    }
    if (_name != nil) {
        [_name release];
        _name = nil;
    }
    if (_mimeType != nil) {
        [_mimeType release];
        _mimeType = nil;
    }
    if (_localPath != nil) {
        [_localPath release];
        _localPath = nil;
    }
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        _trackId = 0;
        _albumId = 0;
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

- (void)setSinger:(NSString *)singer {
    if (_singer != nil) {
        [_singer release];
        _singer = nil;
    }
    _singer = [singer retain];
}

- (void)setUrl:(NSString *)url {
    if (_url != nil) {
        [_url release];
        _url = nil;
    }
    _url = [url retain];
}

- (void)setAlbum:(NSString *)album {
    if (_album != nil) {
        [_album release];
        _album = nil;
    }
    _album = [album retain];
}

- (void)setName:(NSString *)name {
    if (_name != nil) {
        [_name release];
        _name = nil;
    }
    _name = [name retain];
}

- (void)setMimeType:(NSString *)mimeType {
    if (_mimeType != nil) {
        [_mimeType release];
        _mimeType = nil;
    }
    _mimeType = [mimeType retain];
}

- (void)setLocalPath:(NSString *)localPath {
    if (_localPath != nil) {
        [_localPath release];
        _localPath = nil;
    }
    _localPath = [localPath retain];
}

@end
