//
//  DriveItem.m
//  DriveSync
//
//  Created by 罗磊 on 2017/12/6.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import "DriveItem.h"
//#import "AFURLRequestSerialization.h"
#if __has_include(<AFNetworking/AFURLRequestSerialization.h>)
#import <AFNetworking/AFURLRequestSerialization.h>
#else
#import "AFURLRequestSerialization.h"
#endif

@implementation DriveItem
@synthesize progress = _progress;
@synthesize state = _state;
@synthesize speed = _speed;
@synthesize error = _error;
@synthesize urlString = _urlString;
@synthesize headerParam = _headerParam;
@synthesize fileName = _fileName;
@synthesize httpMethod = _httpMethod;
@synthesize parentPath = _parentPath;
@synthesize itemIDOrPath = _itemIDOrPath;
@synthesize fileSize = _fileSize;
@synthesize currentSize = _currentSize;
@synthesize parent = _parent;
@synthesize isFolder = _isFolder;
@synthesize isBigFile = _isBigFile;
@synthesize isConstructingData = _isConstructingData;
//@synthesize constructingData = _constructingData;
//@synthesize constructingDataDriveName = _constructingDataDriveName;
//@synthesize constructingDataLength = _constructingDataLength;
@synthesize localPath = _localPath;
@synthesize requestAPI = _requestAPI;
@synthesize uploadParent = _uploadParent;
@synthesize driveTodriveProgress = _driveTodriveProgress;
@synthesize childArray = _childArray;
@synthesize toDriveName = _toDriveName;
@synthesize zone = _zone;
@synthesize docwsID = _docwsID;


- (NSString *)identifier
{
    NSString *identifier = nil;
    if (_isFolder) {
        identifier = [_itemIDOrPath stringByAppendingString:_toDriveName?:@""];
    }else{
        identifier = [[_urlString stringByAppendingString:_itemIDOrPath?:_docwsID] stringByAppendingString:_toDriveName?:@""];
    }
    
    return identifier;
}
-(void)dealloc
{
    [_urlString release],_urlString = nil;
    [_headerParam  release],_headerParam = nil;
    [_fileName release],_fileName = nil;
    [_httpMethod release],_httpMethod = nil;
    [_parentPath release],_parentPath = nil;
    [_itemIDOrPath release],_itemIDOrPath = nil;
    [_error release],_error = nil;
    [_localPath release],_localPath = nil;
    [_requestAPI release],_requestAPI = nil;
//    [_constructingDataDriveName release],_constructingDataDriveName = nil;
    [_uploadParent release],_uploadParent = nil;
    [_childArray release],_childArray = nil;
//    [_constructingData release],_constructingData = nil;
    [super dealloc];
}
@end
