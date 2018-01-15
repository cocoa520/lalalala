//
//  IMBListContainerHeader.m
//  MediaTrans
//
//  Created by Pallas on 12/16/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBListContainerHeader.h"

@implementation IMBListContainerHeader
@synthesize type = _type;

#pragma mark - 初始化和释放方法
-(id)init{
    self = [super init];
    if(self){
        identifierLength = 4;
        _requiredHeaderSize = 16;
    }
    return self;
}

-(void)dealloc{
    free(_identifier);
    if (_childElement != nil) {
        [_childElement release];
        _childElement = nil;
    }
    [super dealloc];
}

#pragma mark - 重写方法
- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    iPod = ipod;
    currPosition = [super read:iPod reader:reader currPosition:currPosition];
    
    int readLength = 0;
    readLength = 4;
    identifierLength = readLength;
    _identifier = (char*)malloc(readLength + 1);
    memset(_identifier, 0, malloc_size(_identifier));
    [reader getBytes:_identifier range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_headerSize);
    [reader getBytes:&_headerSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    [self validateHeader:@"mhsd"];
    
    readLength = sizeof(_sectionSize);
    [reader getBytes:&_sectionSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    int _typeInt;
    readLength = sizeof(_typeInt);
    [reader getBytes:&_typeInt range:NSMakeRange(currPosition, readLength)];
    _type = (MHSDSectionTypeEnum)_typeInt;
    currPosition += readLength;
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
    
    switch (_type) {
        case Albums:
            _childElement = [[IMBAlbumListContainer alloc] initWithParent:self];
            break;
        case Tracks:
            _childElement = [[IMBTrackListContainer alloc] initWithParent:self];
            break;
        case Playlists:
            _childElement = [[IMBPlaylistListContainer alloc] initWithParent:self];
            break;
        case PlaylistsV2:
            _childElement = [[IMBPlaylistListV2Container alloc] initWithParent:self];
            break;
        case Type5:
            //_childElement = [];
            //break;
        case Type6:
            //_childElement = [];
            //break;
        default:
            _childElement = [[IMBUnknownListContainer alloc] initWithParent:self];
            break;
    }
    currPosition = [_childElement read:iPod reader:reader currPosition:currPosition];
    return currPosition;
}

-(void)write:(NSMutableData *)writer{
    _sectionSize = [self getSectionSize];
    
    identifierLength = 4;
    _identifier = (char*)malloc(identifierLength + 1);
    memset(_identifier, 0, malloc_size(_identifier));
    memcpy(_identifier, "mhsd", malloc_size(_identifier));
    [writer appendBytes:_identifier length:identifierLength];
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    [writer appendBytes:&_sectionSize length:sizeof(_sectionSize)];
    [writer appendBytes:&_type length:sizeof(_type)];
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    
    [_childElement write:writer];
}

-(int)getSectionSize{
    return [_childElement getSectionSize];
}

#pragma mark - 实现声明方法
-(IMBBaseDatabaseElement*)getListContainer{
    return _childElement;
}

#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif

@end
