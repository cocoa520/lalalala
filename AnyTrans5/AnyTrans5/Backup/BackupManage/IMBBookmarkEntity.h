//
//  IMBBookmarks.h
//  iMobieTrans
//
//  Created by iMobie on 14-2-18.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IMBBaseModel.h"
#import "HoverButton.h"
@interface IMBBookmarkEntity : IMBBaseModel {

    int _bookId;
    int _parentNum;
    NSString          *_bookMarksId;
    NSString          *_url;
    NSString          *_name;
    NSNumber          *_position;
    NSArray           *_parent;
    NSMutableArray    *_childBookmarkArray;
    NSMutableArray    *_subFolderArray;
    NSMutableArray    *_allBookmarkArray;
    BOOL              _isFolder;
    BOOL              _isEditable;
    BOOL              _isHidden;
    BOOL              _isDeletable;
    int               _orderIndex;
    BOOL              _isFirstDir;  //是否是第一级目录
    BOOL              _hassubFolder;
    //扩展
    IMBBookmarkEntity *_parentNode;
    HoverButton *_btn;
    id _delegate;
    
}
@property(nonatomic,retain)NSMutableArray    *childBookmarkArray;
@property(nonatomic,retain)NSMutableArray    *subFolderArray;
@property(nonatomic,retain)NSMutableArray    *allBookmarkArray;
@property(nonatomic,copy)NSString            *bookMarksId;
@property(nonatomic,copy)NSString            *url;
@property(nonatomic,copy)NSString            *name;
@property(nonatomic,retain)NSNumber          *position;
@property(nonatomic,retain)NSArray           *parent;
@property(nonatomic,assign)BOOL              isFolder;
@property(nonatomic,assign)BOOL              isEditable;
@property(nonatomic,assign)BOOL              isHidden;
@property(nonatomic,assign)BOOL              isDeletable;
@property(nonatomic,assign)BOOL              isFirstDir;
@property(nonatomic,assign)BOOL              hassubFolder;
@property(nonatomic,assign)int               orderIndex;
@property(nonatomic,assign)IMBBookmarkEntity *parentNode;
@property(nonatomic,assign)int bookId;
@property(nonatomic,assign)int parentNum;
@property(nonatomic,retain) HoverButton *btn;
@property(nonatomic,retain) id delegate;
//创建一个目录
- (id)initWithFolderName:(NSString *)name;
//创建一个书签
- (id)initBookmarkWithName:(NSString *)name url:(NSString *)url;
- (NSString *)descriptionCSV1;
- (NSString *)descriptionCSV;
- (void)cancelBookMark:(IMBBookmarkEntity *)bookMark;
@end
