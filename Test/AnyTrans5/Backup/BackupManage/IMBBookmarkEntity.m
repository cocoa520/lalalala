//
//  IMBBookmarks.m
//  iMobieTrans
//
//  Created by iMobie on 14-2-18.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBookmarkEntity.h"

@implementation IMBBookmarkEntity
@synthesize btn = _btn;
@synthesize bookMarksId        = _bookMarksId;
@synthesize url                = _url;
@synthesize name               = _name;
@synthesize position           = _position;
@synthesize parent             = _parent;
@synthesize isFolder           = _isFolder;
@synthesize childBookmarkArray = _childBookmarkArray;
@synthesize isEditable         = _isEditable;
@synthesize isDeletable        = _isDeletable;
@synthesize isHidden           = _isHidden;
@synthesize orderIndex         = _orderIndex;
@synthesize isFirstDir         = _isFirstDir;
@synthesize hassubFolder       = _hassubFolder;
@synthesize allBookmarkArray   = _allBookmarkArray;
@synthesize subFolderArray     = _subFolderArray;
@synthesize parentNode         = _parentNode;
@synthesize bookId = _bookId;
@synthesize parentNum = _parentNum;
@synthesize delegate = _delegate;

//创建一个目录
- (id)initWithFolderName:(NSString *)name
{
    self = [self init];
    if (self) {
        _isFolder = YES;
        self.name = name;
    }
    return self;
}
//创建一个书签
- (id)initBookmarkWithName:(NSString *)name url:(NSString *)url
{
    self = [self init];
    if (self) {
        _isFolder = NO;
        self.url  = url;
        self.name = name;
    }
    return self;

}

- (void)setBtn:(HoverButton *)btn {
    _btn = [btn retain];
    [btn setTarget:self];
    [btn setAction:@selector(cancel:)];
}

- (void)cancel:(id)sender{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(cancelBookMark:)]) {
        [_delegate cancelBookMark:self];
    }
}

-(id)initWithDataDic:(NSDictionary*)data{
	if (self = [self init]) {
		[self setAttributes:data];
	}
	return self;
}

- (void)setName:(NSString *)name
{
    if (_name != name) {
        [_name release];
        _name = [name copy];
    }
}

- (NSMutableArray *)childBookmarkArray
{
    if (_childBookmarkArray == nil) {
        _childBookmarkArray = [[NSMutableArray array] retain];
    }
    return _childBookmarkArray;
}

- (NSMutableArray *)allBookmarkArray
{
    if (_allBookmarkArray == nil) {
        _allBookmarkArray = [[NSMutableArray array] retain];
    }
    return _allBookmarkArray;
}
- (id)init
{
    self = [super init];
    if (self) {
        _hassubFolder = NO;
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"**************************\nName:%@\nURL:%@\n**************************\n",_name,_url];
}

- (NSString *)descriptionCSV1
{
    return [NSString stringWithFormat:@"Name,URL\n%@,%@\n",_name,_url];
    
}

- (NSString *)descriptionCSV
{
    return [NSString stringWithFormat:@"%@,%@\n",_name,_url];
    
}

- (void)dealloc
{
    [_btn release];
    [_bookMarksId release];
    [_url release];
    [_name release];
    [_position release];
    [_parent release];
    [_childBookmarkArray release];
    [_allBookmarkArray release];
    [_subFolderArray release];
    [super dealloc];
}
@end
