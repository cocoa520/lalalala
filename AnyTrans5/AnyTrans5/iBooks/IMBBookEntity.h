//
//  IMBBookEntity.h
//  iMobieTrans
//
//  Created by iMobie on 14-3-17.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBaseModel.h"

@interface IMBBookEntity : IMBBaseModel
{
    NSString   *_bookID;       //对应plist文件的persistence id
    NSString   *_author;       //对应artist
    int        _size;
    NSString   *_extension;    //对应书的扩展名 extension
    NSString   *_bookName;     //对应name
    NSString   *_album;
    NSString   *_genre;        //书的分类
    NSString   *_collectionID; //集合ID
    NSString   *_path;
    NSString   *_coverPath;     //封面路径
    NSString   *_fullPath;      //全路径
    NSString   *_kind;
    NSString   *_packageHash;
    NSString   *_mimeType;
    NSString   *_publisherUniqueID;
    NSNumber   *_dataBaseKey;
    NSImage    *_coverImage;
    BOOL       _isPurchase;
    BOOL       _hasArtwork;
    BOOL       _isProtected;
    BOOL       _isAdd;
    NSString   *_bookTitle;

}

@property(nonatomic,copy)NSString *bookID;
@property(nonatomic,copy)NSString *author;
@property(nonatomic,assign)int    size;
@property(nonatomic,copy)NSString *extension;
@property(nonatomic,copy)NSString *bookName;
@property(nonatomic,copy)NSString *genre;
@property(nonatomic,copy)NSString *collectionID;
@property(nonatomic,copy)NSString *path;
@property(nonatomic,copy)NSString *bookTitle;
@property(nonatomic,copy)NSString *kind;
@property(nonatomic,copy)NSString *packageHash;
@property(nonatomic,copy)NSString *mimeType;
@property(nonatomic,copy)NSString *publisherUniqueID;
@property(nonatomic,copy)NSString *album;
@property(nonatomic,retain)NSNumber *dataBaseKey;
@property(nonatomic,copy)NSString *coverPath;
@property(nonatomic,retain)NSImage *coverImage;
@property(nonatomic,assign)BOOL isPurchase;
@property(nonatomic,copy)NSString *fullPath;
@property(nonatomic,assign)BOOL hasArtwork;
@property(nonatomic,assign)BOOL isProtected;
@property(nonatomic,assign)BOOL isAdd;

@end
