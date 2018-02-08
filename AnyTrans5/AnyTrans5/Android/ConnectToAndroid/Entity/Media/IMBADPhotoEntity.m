//
//  IMBPhotoEntity.m
//
//
//  Created by iMoibe on 2/6/17.
//
//

#import "IMBADPhotoEntity.h"

@implementation IMBADPhotoEntity
@synthesize photoId = _photoId;
@synthesize url = _url;
@synthesize size = _size;
@synthesize time = _time;
@synthesize name = _name;
@synthesize height = _height;
@synthesize width = _width;
@synthesize thumbnilId = _thumbnilId;
@synthesize thumbnilUrl = _thumbnilUrl;
@synthesize thumbnilSize = _thumbnilSize;
@synthesize mimeType = _mimeType;
@synthesize loadingImage = _loadingImage;
@synthesize isLoad = _isLoad;
@synthesize photoImage = _photoImage;
@synthesize title = _title;

- (void)dealloc
{
    if (_name != nil) {
        [_name release];
        _name = nil;
    }
    if (_url != nil) {
        [_url release];
        _url = nil;
    }
    if (_thumbnilUrl != nil) {
        [_thumbnilUrl release];
        _thumbnilUrl = nil;
    }
    if (_mimeType != nil) {
        [_mimeType release];
        _mimeType = nil;
    }
    if (_photoImage != nil) {
        [_photoImage release];
        _photoImage = nil;
    }
    if (_title != nil) {
        [_title release];
        _title = nil;
    }
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        _photoId = 0;
        _size = 0;
        _time = 0;
        _height = 0;
        _width = 0;
        _thumbnilId = 0;
        _thumbnilSize = 0;
        _isLoad = NO;
        _loadingImage = NO;
    }
    return self;
}

- (void)setName:(NSString *)name {
    if (_name != nil) {
        [_name release];
        _name = nil;
    }
    _name = [name retain];
}

- (void)setTitle:(NSString *)title {
    if (_title != nil) {
        [_title release];
        _title = nil;
    }
    _title = [title retain];
}

- (void)setUrl:(NSString *)url {
    if (_url != nil) {
        [_url release];
        _url = nil;
    }
    _url = [url retain];
}

- (void)setThumbnilUrl:(NSString *)thumbnilUrl {
    if (_thumbnilUrl != nil) {
        [_thumbnilUrl release];
        _thumbnilUrl = nil;
    }
    _thumbnilUrl = [thumbnilUrl retain];
}

- (void)setMimeType:(NSString *)mimeType {
    if (_mimeType != nil) {
        [_mimeType release];
        _mimeType = nil;
    }
    _mimeType = [mimeType retain];
}

- (void)setPhotoImage:(NSImage *)photoImage {
    if (_photoImage != nil) {
        [_photoImage release];
        _photoImage = nil;
    }
    _photoImage = [photoImage retain];
}

@end

@implementation IMBADAlbumEntity
@synthesize albumName = _albumName;
@synthesize count = _count;
@synthesize size = _size;
@synthesize photoArray = _photoArray;
@synthesize isAppAlbum = _isAppAlbum;

- (id)init {
    if (self = [super init]) {
        _albumName = nil;
        _count = 0;
        _size = 0;
        _photoArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setAlbumName:(NSString *)albumName {
    if (_albumName != nil) {
        [_albumName release];
        _albumName = nil;
    }
    _albumName = [albumName retain];
}

- (void)dealloc
{
    if (_albumName != nil) {
        [_albumName release];
        _albumName = nil;
    }
    if (_photoArray != nil) {
        [_photoArray release];
        _photoArray = nil;
    }
    [super dealloc];
}

@end
