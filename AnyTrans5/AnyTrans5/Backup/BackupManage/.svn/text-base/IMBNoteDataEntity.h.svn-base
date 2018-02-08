//
//  IMBNoteDataEntity.h
//  PhoneRescue
//
//  Created by iMobie023 on 16-3-23.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBBaseEntity.h"

@interface IMBNoteDataEntity : IMBBaseEntity
{
@private
    int _zpk;
    //内容类型
    int _contentType;
    //删除标志
    int _deleteFlag;
    //创建日期
    long long _creationDate;
    //修改日期
    long long _modificationDate;
    //作者
    NSString *_author;
    NSData *_guid;
    //服务ID
    NSString *_serverID;
    //概要
    NSString *_summary;
    //标题
    NSString *_title;
    //内容
    NSString *_content;
    
    NSData *_contentData;
    NSMutableArray *_attachmentList;//附件
}
@property (assign, nonatomic) int zpk;
@property (assign, nonatomic) int contentType;
@property (assign, nonatomic) int deleteFlag;
@property (assign, nonatomic) long  long creationDate;
@property (assign, nonatomic) long long modificationDate;
@property (retain, nonatomic) NSString *author;
@property (retain, nonatomic) NSString *serverID;
@property (retain, nonatomic) NSString *summary;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSData *guid;
@property (nonatomic, readwrite, retain) NSData *contentData;
@property (nonatomic, readwrite, retain) NSMutableArray *attachmentList;
@end


@interface IMBNoteAttachmentEntity : IMBBaseEntity {
    int _attachmentId;
    int _zpk;
    int _mediaId;
    long long _date;
    long long _fileSize;
    NSString *_fileName;
    NSString *_identifier;
    
    NSMutableArray *_allAttachId;//identify
    NSMutableArray *_allPreviewId;
    // 保存的是IMBAttachDetailModel对象
    NSMutableArray *_attachDetailList;
}

@property (nonatomic, readwrite) int attachmentId;
@property (nonatomic, readwrite) int mediaId;
@property (nonatomic,assign)int zpk;
@property (nonatomic, readwrite) long long date;
@property (nonatomic, readwrite) long long fileSize;
@property (nonatomic, readwrite, retain) NSString *fileName;
@property (nonatomic, readwrite, retain) NSString *identifier;
@property (nonatomic, readwrite, retain) NSMutableArray *attachDetailList;
@property (nonatomic, readwrite, retain) NSMutableArray *allAttachId;
@property (nonatomic, readwrite, retain) NSMutableArray *allPreviewId;

@end

@interface IMBNoteModelEntity : IMBBaseEntity {
@private
    NSString *_noteKey;
    NSString *_contentType;
    
//    //内容类型
    int _zcontentType;
//    //删除标志
    int _zdeletedFlag;
//    //创建日期
    long long _creatDate;
//    //修改日期
    long long _modifyDate;
    //    //创建日期
    NSString *_creatDateStr;
    //    //修改日期
    NSString *_modifyDateStr;
    NSString *_shortDateStr;
//    //作者
    NSString *_author;
    NSData *_guid;
//    //服务ID
    NSString *_serverID;
//    //概要
    NSString *_summary;
//    //标题
    NSString *_title;
//    //内容
    NSString *_content;
    int _rowID;
    int _mediaId;
    NSMutableArray *_attachmentAry;
    NSData *_contentData;
    long _noteSize;
    int _zpk;
    //插入要赋的值
    NSString *_zcreaTionDate;
    NSString *_zmodificationDate;
    NSString *_ztitle;
    NSString *_zsnippet;
    NSString *_ZLOCALVERSIONDATE;
    
    int _zaccount;
    NSString *_zidentifier;
   
    int _zcloudsyncingobject;
    
    BOOL _isNew;

}
@property (nonatomic, readwrite) BOOL isNew;

@property (nonatomic, readwrite, retain) NSString *noteKey;
@property (nonatomic, readwrite, retain) NSString *contentType;

@property (nonatomic, retain) NSString *serverID;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, assign) int zpk;
@property (nonatomic, assign) int zaccount;
@property (nonatomic, retain) NSString *zidentifier;
@property (nonatomic, retain) NSString *zsnippet;
@property (nonatomic, assign) int zcloudsyncingobject;
@property (nonatomic, retain) NSString *ZLOCALVERSIONDATE;
@property (nonatomic, assign) int rowID;
@property (nonatomic, assign) int mediaId;
@property (nonatomic, assign) long long modifyDate;
@property (nonatomic, retain) NSMutableArray *attachmentAry;;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSData *contentData;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, assign) long noteSize;
@property (nonatomic, assign) long long creatDate;
@property (nonatomic, assign) int zcontentType;
@property (nonatomic, assign) int zdeletedFlag;
@property (nonatomic, retain) NSString *zcreaTionDate;
@property (nonatomic, retain) NSString *zmodificationDate;
@property (nonatomic, retain) NSString *ztitle;
@property (nonatomic, retain) NSData *guid;
@property (nonatomic, retain) NSString *modifyDateStr;
@property (nonatomic, retain) NSString *creatDateStr;
@property (nonatomic, retain) NSString *shortDateStr;
@end
