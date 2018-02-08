//
//  IMBMessageEntity.h
//  
//
//  Created by JGehry on 2/15/17.
//
//

#import <Foundation/Foundation.h>
#import "IMBBaseEntity.h"
#import "IMBCheckBtn.h"

@interface IMBSMSAddressEntity : IMBBaseEntity {
@private
    NSString *_address;//电话号码
    int _type;//
    int _charset;//电话号码编码 106
}

/**
 *  address;//电话号码
 *  type;//
 *  charset;//电话号码编码 106
 */

@property (nonatomic, readwrite, retain) NSString *address;//电话号码
@property (nonatomic, readwrite) int type;//
@property (nonatomic, readwrite) int charset;//电话号码编码 106

@end

@interface IMBSMSPartEntity : IMBBaseEntity {
@private
    int _partId;
    int _seq;//标志part的顺序，若ct为application/smil，则为-1，否则为0
    NSString *_ct;//附件attaType的取值  "application/smil"    "image/jpeg"  "image/bmp" "image/gif" "image/jpg" "image/png"    文本附件  "text/plain"  音频附件 "audio/后缀名"  视屏附件 "video/后缀名"
    NSString *_partname;
    NSImage *_photoImage;
    BOOL _isLoad;
    int _chset;//编码 106
    NSString *_cid;
    NSString *_cl;
    NSString *_text; //文本
    NSData *_data; //附件
    NSString *_localPath;//附件本地路径
}

/**
 *  partId
 *  seq;            标志part的顺序，若ct为application/smil，则为-1，否则为0
 *  ct;             附件attaType的取值  "application/smil"    "image/jpeg"  "image/bmp" "image/gif" "image/jpg" "image/png"    文本附件  "text/plain"  音频附件 "audio/后缀名"  视屏附件 "video/后缀名"
 *  partname;
 *  chset;          编码 106
 *  cid;
 *  cl;
 *  text;           文本
 *  data;           附件，附件是查询出MMS之后，再去请求查询的；
 *  localPath;     附件本地路径
 */

@property (nonatomic, readwrite) int partId;
@property (nonatomic, readwrite) int seq;
@property (nonatomic, readwrite, retain) NSString *ct;
@property (nonatomic, readwrite, retain) NSString *partname;
@property (nonatomic, readwrite, retain) NSImage *photoImage;
@property (nonatomic, readwrite) BOOL isLoad;
@property (nonatomic, readwrite) int chset;
@property (nonatomic, readwrite, retain) NSString *cid;
@property (nonatomic, readwrite, retain) NSString *cl;
@property (nonatomic, readwrite, retain) NSString *text;
@property (nonatomic, readwrite, retain) NSData *data;
@property (nonatomic, readwrite, retain) NSString *localPath;//附件本地路径

@end

@interface IMBADMessageEntity : IMBBaseEntity {
@private
    int _msId;  //短信序号
    int _threadId;  //会话id
    long long _date;  //短信创建时间 时间戳
    long long _sortDate; //用户时间戳排序
    NSString *_address;//对方电话号码
    BOOL _read;//是否阅读0未读，1已读
    int _status;//短信状态-1接收，0complete,64pending,128failed
    int _type;//短信类型 1收件箱 2 发件箱 3 草稿箱 4待发箱 5 发送失败 6待发送队列 （如开启飞行模式）
    NSString *_body;//短信内容
    int _smsType; //SMS:0  MMS: 1
    /*
     * 以下MMS的属性内容
     */
    
    int _msgBox; //彩信类型
    //public String  m_id;  //由彩信服务器分配的消息id; 使用type字段代替
    NSString *_sub; //彩信主题
    int _subCs; //此条彩信主题编码 106为UTF-8
    NSString *_ctT; //彩信对应的content-Type  一般为application/vnd.wap.multipart.related
    NSString *_mCls;//此条彩信的用途 auto，advertisement，personal，informational
    int _version;//此条彩信对应的MMS协议的版本号，1.0 16，1.1 17，1.2 18，1.3 19
    int _pri;//此条彩信的优先级，normal 129，low 128，high 130
    int _mSize;//大小
    NSString *_trId;//事务标识
    NSMutableArray *_addrList;//装有addr数组的对象IMBSMSAddressEntity
    NSMutableArray *_partList;//装有part数组的对象IMBSMSPartEntity
    IMBCheckBtn *_checkBtn;
}

/**
 *  id;             短信序号
 *  threadId;       会话id
 *  date;           短信创建时间 时间戳；MMS的时间是10位（秒）时间戳，SMS的时间是13位（毫秒）时间戳
 *  _sortDate;      用户时间戳排序
 *  address;        对方电话号码
 *  read;           是否阅读0未读，1已读
 *  status;         短信状态-1接收，0complete,64pending,128failed
 *  type;           短信类型 1收件箱 2 发件箱 3 草稿箱
 *  body;           短信内容
 *  smsType;        SMS:0  MMS: 1
 
 以下MMS的属性内容
 *  msgBox;         彩信类型
 *  sub;            彩信主题
 *  subCs;          此条彩信主题编码 106为UTF-8
 *  ctT;            彩信对应的content-Type  一般为application/vnd.wap.multipart.related
 *  mCls;           此条彩信的用途 auto，advertisement，personal，informational
 *  version;        此条彩信对应的MMS协议的版本号，1.0 16，1.1 17，1.2 18，1.3 19
 *  pri;            此条彩信的优先级，normal 129，low 128，high 130
 *  mSize;          大小
 *  trId;           事务标识
 *  addrList;       装有addr数组的对象
 *  partList;       装有part数组的对象
 */

@property (nonatomic, retain) IMBCheckBtn *checkBtn;
@property (nonatomic, readwrite) int msId;
@property (nonatomic, readwrite) int threadId;
@property (nonatomic, readwrite) long long date;
@property (nonatomic, readwrite) long long sortDate;
@property (nonatomic, readwrite, retain) NSString *address;
@property (nonatomic, readwrite) BOOL read;
@property (nonatomic, readwrite) int status;
@property (nonatomic, readwrite) int type;
@property (nonatomic, readwrite, retain) NSString *body;
@property (nonatomic, readwrite) int smsType;
/*
 * 以下MMS的属性内容
 */

@property (nonatomic, readwrite) int msgBox;
@property (nonatomic, readwrite, retain) NSString *sub;
@property (nonatomic, readwrite) int subCs;
@property (nonatomic, readwrite, retain) NSString *ctT;
@property (nonatomic, readwrite, retain) NSString *mCls;
@property (nonatomic, readwrite) int version;
@property (nonatomic, readwrite) int pri;
@property (nonatomic, readwrite) int mSize;
@property (nonatomic, readwrite, retain) NSString *trId;
@property (nonatomic, readwrite, retain) NSMutableArray *addrList;
@property (nonatomic, readwrite, retain) NSMutableArray *partList;

@end

@interface IMBThreadsEntity : IMBBaseEntity {
    int _type; //是否是群发  0-普通会话 1群发
    int _threadId;  //INTEGER 会话id，他关联到sms表中的thread_id字段
    long long _date; //时间戳
    int _messageCount;//message条数 包括sms和mms
    NSString *_snippet;//为最后收到/发出的信息
    NSString *_lastMsgTime;//最后一条消息的时间
    NSMutableArray *_recipients; //存放的是电话号码数组,如果是群发 数组个数大于1 如果是单发 数组个数等于1
    NSString *_threadsname;//会话显示的名字
    NSMutableArray *_messageList;//sms数组的对象
    NSData *_headerImage;//联系人头像
    NSString *_sortNameStr;
    int _googleThreadId;
}

/**
 *  type;           是否是群发  0-普通会话 1群发
 *  threadId;       INTEGER 会话id，他关联到sms表中的thread_id字段
 *  date;           时间戳
 *  messageCount;   message条数 包括sms和mms
 *  snippet;        为最后收到/发出的信息
 *  recipients;     存放的是电话号码数组,如果是群发 数组个数大于1 如果是单发 数组个数等于1
 *  threadsname;    会话显示的名字
 *  messageList;    sms数组的对象IMBMessageEntity
 *  headerImage;    联系人头像
 */

@property (nonatomic, readwrite) int type;
@property (nonatomic, readwrite) int threadId;
@property (nonatomic, readwrite) int googleThreadId;
@property (nonatomic, readwrite) long long date;
@property (nonatomic, readwrite) int messageCount;
@property (nonatomic, readwrite, retain) NSString *snippet;
@property (nonatomic, readwrite, retain) NSString *lastMsgTime;
@property (nonatomic, readwrite, retain) NSMutableArray *recipients;
@property (nonatomic, readwrite, retain) NSString *threadsname;
@property (nonatomic, readwrite, retain) NSMutableArray *messageList;
@property (nonatomic, readwrite, retain) NSData *headerImage;
@property (nonatomic, readwrite, retain) NSString *sortNameStr;
- (void)dictionaryToObject:(NSDictionary *)msgDic;
- (NSDictionary *)objectToDictionary:(IMBThreadsEntity *)entity;

@end
