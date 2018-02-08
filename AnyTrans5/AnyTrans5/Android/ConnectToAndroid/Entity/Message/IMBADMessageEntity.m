//
//  IMBMessageEntity.m
//  
//
//  Created by JGehry on 2/15/17.
//
//

#import "IMBADMessageEntity.h"
#import "IMBHelper.h"

@implementation IMBSMSAddressEntity
@synthesize address = _address;
@synthesize type = _type;
@synthesize charset = _charset;

- (id)init {
    if (self = [super init]) {
        _type = 0;
        _charset = 0;
    }
    return self;
}

- (void)setAddress:(NSString *)address {
    if (_address != nil) {
        [_address release];
        _address = nil;
    }
    _address = [address retain];
}

- (void)dealloc {
    if (_address != nil) {
        [_address release];
        _address = nil;
    }
    [super dealloc];
}

@end

@implementation IMBSMSPartEntity
@synthesize partId = _partId;
@synthesize seq = _seq;
@synthesize ct = _ct;
@synthesize partname = _partname;
@synthesize chset = _chset;
@synthesize cid = _cid;
@synthesize cl = _cl;
@synthesize text = _text;
@synthesize data = _data;
@synthesize localPath = _localPath;
@synthesize photoImage = _photoImage;
@synthesize isLoad = _isLoad;

- (id)init {
    if (self = [super init]) {
        _partId = 0;
        _seq = 0;
        _chset = 0;
        _isLoad = NO;
    }
    return self;
}

- (void)setCt:(NSString *)ct {
    if (_ct != nil) {
        [_ct release];
        _ct = nil;
    }
    _ct = [ct retain];
}

- (void)setPartname:(NSString *)partname {
    if (_partname != nil) {
        [_partname release];
        _partname = nil;
    }
    _partname = [partname retain];
}

- (void)setCid:(NSString *)cid {
    if (_cid != nil) {
        [_cid release];
        _cid = nil;
    }
    _cid = [cid retain];
}

- (void)setCl:(NSString *)cl {
    if (_cl != nil) {
        [_cl release];
        _cl = nil;
    }
    _cl = [cl retain];
}

- (void)setText:(NSString *)text {
    if (_text != nil) {
        [_text release];
        _text = nil;
    }
    _text = [text retain];
}

- (void)setData:(NSData *)data {
    if (_data != nil) {
        [_data release];
        _data = nil;
    }
    _data = [data retain];
}

- (void)setLocalPath:(NSString *)localPath {
    if (_localPath != nil) {
        [_localPath release];
        _localPath = nil;
    }
    _localPath = [localPath retain];
}

- (void)dealloc
{
    if (_ct != nil) {
        [_ct release];
        _ct = nil;
    }
    if (_partname != nil) {
        [_partname release];
        _partname = nil;
    }
    if (_cid != nil) {
        [_cid release];
        _cid = nil;
    }
    if (_cl != nil) {
        [_cl release];
        _cl = nil;
    }
    if (_text != nil) {
        [_text release];
        _text = nil;
    }
    if (_data != nil) {
        [_data release];
        _data = nil;
    }
    if (_localPath != nil) {
        [_localPath release];
        _localPath = nil;
    }
    if (_photoImage != nil) {
        [_photoImage release];
        _photoImage = nil;
    }
    [super dealloc];
}

@end

@implementation IMBADMessageEntity
@synthesize msId = _msId;
@synthesize threadId = _threadId;
@synthesize date = _date;
@synthesize address = _address;
@synthesize read = _read;
@synthesize status = _status;
@synthesize type = _type;
@synthesize body = _body;
@synthesize smsType = _smsType;
@synthesize msgBox = _msgBox;
@synthesize sub = _sub;
@synthesize subCs = _subCs;
@synthesize ctT = _ctT;
@synthesize mCls = _mCls;
@synthesize version = _version;
@synthesize pri = _pri;
@synthesize mSize = _mSize;
@synthesize trId = _trId;
@synthesize addrList = _addrList;
@synthesize partList = _partList;
@synthesize checkBtn = _checkBtn;
@synthesize sortDate = _sortDate;

- (void)dealloc {
    if (_addrList != nil) {
        [_addrList release];
        _addrList = nil;
    }
    if (_partList != nil) {
        [_partList release];
        _partList = nil;
    }
    if (_address != nil) {
        [_address release];
        _address = nil;
    }
    if (_body != nil) {
        [_body release];
        _body = nil;
    }
    if (_sub != nil) {
        [_sub release];
        _sub = nil;
    }
    if (_ctT != nil) {
        [_ctT release];
        _ctT = nil;
    }
    if (_mCls != nil) {
        [_mCls release];
        _mCls = nil;
    }
    if (_trId != nil) {
        [_trId release];
        _trId = nil;
    }
    if (_checkBtn != nil) {
        [_checkBtn release];
        _checkBtn = nil;
    }
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
        _msId = 0;
        _threadId = 0;
        _date = 0;
        _read = NO;
        _status = 0;
        _type = 0;
        _smsType = 0;
        _msgBox = 0;
        _subCs = 0;
        _version = 0;
        _pri = 0;
        _mSize = 0;
        _sortDate = 0;
        _checkBtn = [[IMBCheckBtn alloc] init];;
        [_checkBtn setFrameSize:NSMakeSize(18, 18)];
        [_checkBtn setState:NSOnState];
        _addrList = [[NSMutableArray alloc] init];
        _partList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setSortDate:(long long)sortDate {
    if ([IMBHelper getDateLength:sortDate] <= 10) {
        _sortDate = sortDate * 1000;
    }else {
        _sortDate = sortDate;
    }
}

- (void)setAddress:(NSString *)address {
    if (_address != nil) {
        [_address release];
        _address = nil;
    }
    _address = [address retain];
}

- (void)setBody:(NSString *)body {
    if (_body != nil) {
        [_body release];
        _body = nil;
    }
    _body = [body retain];
}

- (void)setSub:(NSString *)sub {
    if (_sub != nil) {
        [_sub release];
        _sub = nil;
    }
    _sub = [sub retain];
}

- (void)setCtT:(NSString *)ctT {
    if (_ctT != nil) {
        [_ctT release];
        _ctT = nil;
    }
    _ctT = [ctT retain];
}

- (void)setMCls:(NSString *)mCls {
    if (_mCls != nil) {
        [_mCls release];
        _mCls = nil;
    }
    _mCls = [mCls retain];
}

- (void)setTrId:(NSString *)trId {
    if (_trId != nil) {
        [_trId release];
        _trId = nil;
    }
    _trId = [trId retain];
}

@end

@implementation IMBThreadsEntity
@synthesize type = _type;
@synthesize threadId = _threadId;
@synthesize date = _date;
@synthesize messageCount = _messageCount;
@synthesize snippet = _snippet;
@synthesize lastMsgTime = _lastMsgTime;
@synthesize recipients = _recipients;
@synthesize threadsname = _threadsname;
@synthesize messageList = _messageList;
@synthesize headerImage = _headerImage;
@synthesize sortNameStr = _sortNameStr;
@synthesize googleThreadId = _googleThreadId;
- (id)init {
    if (self = [super init]) {
        _type = 0;
        _threadId = 0;
        _date = 0;
        _messageCount = 0;
        _googleThreadId = 0;
        _lastMsgTime = @"";
        _sortNameStr = @"";
        _recipients = [[NSMutableArray alloc] init];
        _messageList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setSnippet:(NSString *)snippet {
    if (_snippet != nil) {
        [_snippet release];
        _snippet = nil;
    }
    _snippet = [snippet retain];
}

- (void)setLastMsgTime:(NSString *)lastMsgTime {
    if (_lastMsgTime != nil) {
        [_lastMsgTime release];
        _lastMsgTime = nil;
    }
    _lastMsgTime = [lastMsgTime retain];
}

- (void)setThreadsname:(NSString *)threadsname {
    if (_threadsname != nil) {
        [_threadsname release];
        _threadsname = nil;
    }
    _threadsname = [threadsname retain];
}

- (void)setHeaderImage:(NSData *)headerImage {
    if (_headerImage != nil) {
        [_headerImage release];
        _headerImage = nil;
    }
    _headerImage = [headerImage retain];
}

- (void)dictionaryToObject:(NSDictionary *)msgDic {
    if ([msgDic.allKeys containsObject:@"date"]) {
        self.date = [[msgDic objectForKey:@"date"] longLongValue];
    }
    if ([msgDic.allKeys containsObject:@"id"]) {
        self.threadId = [[msgDic objectForKey:@"id"] intValue];
    }
    if ([msgDic.allKeys containsObject:@"message_count"]) {
        self.messageCount = [[msgDic objectForKey:@"message_count"] intValue];
    }
    if ([msgDic.allKeys containsObject:@"type"]) {
        self.type = [[msgDic objectForKey:@"type"] intValue];
    }
    if ([msgDic.allKeys containsObject:@"snippet"]) {
        self.snippet = [msgDic objectForKey:@"snippet"];
    }
    if ([msgDic.allKeys containsObject:@"threadsname"]) {
        self.threadsname = [msgDic objectForKey:@"threadsname"];
    }
    if ([msgDic.allKeys containsObject:@"recipients"]) {
        NSArray *list = [msgDic objectForKey:@"recipients"];
        if (list != nil) {
            [self.recipients addObjectsFromArray:list];
        }
    }
    if ([msgDic.allKeys containsObject:@"headerImage"]) {
        NSString *headerStr = [msgDic objectForKey:@"headerImage"];
        NSData *data = [headerStr dataUsingEncoding:NSUTF8StringEncoding];
        self.headerImage = data;
    }
    if ([msgDic.allKeys containsObject:@"messageList"]) {
        NSArray *list = [msgDic objectForKey:@"messageList"];
        if (list != nil) {
            for (NSDictionary *smsDic in list) {
                IMBADMessageEntity *mesEntity = [[IMBADMessageEntity alloc] init];
                if ([smsDic.allKeys containsObject:@"_id"]) {
                    mesEntity.msId = [[smsDic objectForKey:@"_id"] intValue];
                }
                if ([smsDic.allKeys containsObject:@"address"]) {
                    mesEntity.address = [smsDic objectForKey:@"address"];
                }
                if ([smsDic.allKeys containsObject:@"body"]) {
                    mesEntity.body = [smsDic objectForKey:@"body"];
                }
                if ([smsDic.allKeys containsObject:@"read"]) {
                    mesEntity.read = [[smsDic objectForKey:@"read"] boolValue];
                }
                if ([smsDic.allKeys containsObject:@"smsType"]) {
                    mesEntity.smsType = [[smsDic objectForKey:@"smsType"] intValue];
                }
                if ([smsDic.allKeys containsObject:@"status"]) {
                    mesEntity.status = [[smsDic objectForKey:@"status"] intValue];
                }
                if ([smsDic.allKeys containsObject:@"thread_id"]) {
                    mesEntity.threadId = [[smsDic objectForKey:@"thread_id"] intValue];
                }
                if ([smsDic.allKeys containsObject:@"type"]) {
                    mesEntity.type = [[smsDic objectForKey:@"type"] intValue];
                }
                if ([smsDic.allKeys containsObject:@"date"]) {
                    mesEntity.date = [[smsDic objectForKey:@"date"] longLongValue];
                    [mesEntity setSortDate:mesEntity.date];
                }
                if (mesEntity.smsType == 1) {//等于1，是彩信
                    if ([smsDic.allKeys containsObject:@"ct_t"]) {
                        mesEntity.ctT = [smsDic objectForKey:@"ct_t"];
                    }
                    if ([smsDic.allKeys containsObject:@"m_cls"]) {
                        mesEntity.mCls = [smsDic objectForKey:@"m_cls"];
                    }
                    if ([smsDic.allKeys containsObject:@"m_size"]) {
                        mesEntity.mSize = [[smsDic objectForKey:@"m_size"] intValue];
                    }
                    if ([smsDic.allKeys containsObject:@"msg_box"]) {
                        mesEntity.msgBox = mesEntity.type;//[[smsDic objectForKey:@"msg_box"] intValue];
                    }
                    if ([smsDic.allKeys containsObject:@"pri"]) {
                        mesEntity.pri = [[smsDic objectForKey:@"pri"] intValue];
                    }
                    if ([smsDic.allKeys containsObject:@"sub"]) {
                        mesEntity.sub = [smsDic objectForKey:@"sub"];
                    }
                    if ([smsDic.allKeys containsObject:@"sub_cs"]) {
                        mesEntity.subCs = [[smsDic objectForKey:@"sub_cs"] intValue];
                    }
                    if ([smsDic.allKeys containsObject:@"tr_id"]) {
                        mesEntity.trId = [smsDic objectForKey:@"tr_id"];
                    }
                    if ([smsDic.allKeys containsObject:@"v"]) {
                        mesEntity.version = [[smsDic objectForKey:@"v"] intValue];
                    }
                    if ([smsDic.allKeys containsObject:@"addrList"]) {
                        NSArray *addrList = [smsDic objectForKey:@"addrList"];
                        for (NSDictionary *addrDic in addrList) {
                            IMBSMSAddressEntity *addrEntity = [[IMBSMSAddressEntity alloc] init];
                            if ([addrDic.allKeys containsObject:@"address"]) {
                                addrEntity.address = [addrDic objectForKey:@"address"];
                            }
                            if ([addrDic.allKeys containsObject:@"charset"]) {
                                addrEntity.charset = [[addrDic objectForKey:@"charset"] intValue];
                            }
                            if ([addrDic.allKeys containsObject:@"type"]) {
                                addrEntity.type = [[addrDic objectForKey:@"type"] intValue];
                            }
                            [mesEntity.addrList addObject:addrEntity];
                            [addrEntity release];
                        }
                    }
                    if ([smsDic.allKeys containsObject:@"partList"]) {
                        NSArray *partList = [smsDic objectForKey:@"partList"];
                        for (NSDictionary *partDic in partList) {
                            IMBSMSPartEntity *partEntity = [[IMBSMSPartEntity alloc] init];
                            if ([partDic.allKeys containsObject:@"chset"]) {
                                partEntity.chset = [[partDic objectForKey:@"chset"] intValue];
                            }
                            if ([partDic.allKeys containsObject:@"cid"]) {
                                partEntity.cid = [partDic objectForKey:@"cid"];
                            }
                            if ([partDic.allKeys containsObject:@"cl"]) {
                                partEntity.cl = [partDic objectForKey:@"cl"];
                            }
                            if ([partDic.allKeys containsObject:@"id"]) {
                                partEntity.partId = [[partDic objectForKey:@"id"] intValue];
                            }
                            if ([partDic.allKeys containsObject:@"seq"]) {
                                partEntity.seq = [[partDic objectForKey:@"seq"] intValue];
                            }
                            if ([partDic.allKeys containsObject:@"text"]) {
                                partEntity.text = [partDic objectForKey:@"text"];
                            }
                            if ([partDic.allKeys containsObject:@"ct"]) {
                                partEntity.ct = [partDic objectForKey:@"ct"];
                            }
                            if ([partDic.allKeys containsObject:@"partname"]) {
                                partEntity.partname = [partDic objectForKey:@"partname"];
                            }
                            [mesEntity.partList addObject:partEntity];
                            [partEntity release];
                        }
                    }
                }
                [self.messageList addObject:mesEntity];
                [mesEntity release];
            }
        }
    }
    self.messageCount = (int)self.messageList.count;
    self.selectedCount = self.messageCount;
}

- (NSDictionary *)objectToDictionary:(IMBThreadsEntity *)entity {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[NSString stringWithFormat:@"%d",entity.threadId] forKey:@"id"];
    if (entity.date != 0) {
        [dic setObject:[NSNumber numberWithLongLong:entity.date] forKey:@"date"];
    }
    [dic setObject:[NSNumber numberWithLongLong:entity.messageCount] forKey:@"message_count"];
    [dic setObject:[NSNumber numberWithLongLong:entity.type] forKey:@"type"];
    if (entity.snippet != nil) {
        [dic setObject:entity.snippet forKey:@"snippet"];
    }
    if (entity.threadsname != nil) {
        [dic setObject:entity.threadsname forKey:@"threadsname"];
    }
    if (entity.recipients != nil) {
        [dic setObject:entity.recipients forKey:@"recipients"];
    }else {
        [dic setObject:[NSArray arrayWithObject:[NSNumber numberWithLongLong:entity.date]] forKey:@"recipients"];
    }
    if (entity.headerImage != nil) {
        [dic setObject:entity.headerImage forKey:@"headerImage"];
    }
    if (entity.messageList != nil && entity.messageList.count > 0) {
        NSMutableArray *mesList = [NSMutableArray array];
        for (IMBADMessageEntity *mesEntity in entity.messageList) {
            NSMutableDictionary *mesDic = [NSMutableDictionary dictionary];
            [mesDic setObject:[NSNumber numberWithInt:mesEntity.msId] forKey:@"_id"];
            if (mesEntity.address != nil) {
                [mesDic setObject:mesEntity.address forKey:@"address"];
            }
            if (mesEntity.body != nil) {
                [mesDic setObject:mesEntity.body forKey:@"body"];
            }
            if (mesEntity.date != 0) {
                [mesDic setObject:[NSNumber numberWithLongLong:mesEntity.date] forKey:@"date"];
            }
            [mesDic setObject:[NSNumber numberWithInt:mesEntity.read] forKey:@"read"];
            [mesDic setObject:[NSNumber numberWithInt:mesEntity.smsType] forKey:@"smsType"];
            [mesDic setObject:[NSNumber numberWithInt:mesEntity.status] forKey:@"status"];
            [mesDic setObject:[NSNumber numberWithInt:mesEntity.threadId] forKey:@"thread_id"];
            [mesDic setObject:[NSNumber numberWithInt:mesEntity.type] forKey:@"type"];
            if (mesEntity.smsType == 1) {//等于1，是彩信
                if (mesEntity.ctT != nil) {
                    [mesDic setObject:mesEntity.ctT forKey:@"ct_t"];
                }
                if (mesEntity.mCls != nil) {
                    [mesDic setObject:mesEntity.mCls forKey:@"m_cls"];
                }
                [mesDic setObject:[NSNumber numberWithInt:mesEntity.mSize] forKey:@"m_size"];
                [mesDic setObject:[NSNumber numberWithInt:mesEntity.msgBox] forKey:@"msg_box"];
                [mesDic setObject:[NSNumber numberWithInt:mesEntity.pri] forKey:@"pri"];
                if (mesEntity.sub != nil) {
                    [mesDic setObject:mesEntity.sub forKey:@"sub"];
                }
                [mesDic setObject:[NSNumber numberWithInt:mesEntity.subCs] forKey:@"sub_cs"];
                if (mesEntity.trId != nil) {
                    [mesDic setObject:mesEntity.trId forKey:@"tr_id"];
                }
                [mesDic setObject:[NSNumber numberWithInt:mesEntity.version] forKey:@"v"];
                if (mesEntity.addrList != nil && mesEntity.addrList.count > 0) {
                    NSMutableArray *addrArr = [NSMutableArray array];
                    for (IMBSMSAddressEntity *addrEntity in mesEntity.addrList) {
                        NSMutableDictionary *addrDic = [NSMutableDictionary dictionary];
                        if (addrEntity.address != nil) {
                            [addrDic setObject:addrEntity.address forKey:@"address"];
                        }
                        [addrDic setObject:[NSNumber numberWithInt:addrEntity.charset] forKey:@"charset"];
                        [addrDic setObject:[NSNumber numberWithInt:addrEntity.type] forKey:@"type"];
                        [addrArr addObject:addrDic];
                    }
                    [mesDic setObject:addrArr forKey:@"addrList"];
                }
                if (mesEntity.partList != nil && mesEntity.partList.count > 0) {
                    NSMutableArray *partArr = [NSMutableArray array];
                    for (IMBSMSPartEntity *partEntity in mesEntity.partList) {
                        NSMutableDictionary *partDic = [NSMutableDictionary dictionary];
                        if (partEntity.cid != nil) {
                            [partDic setObject:partEntity.cid forKey:@"cid"];
                        }
                        if (partEntity.cl != nil) {
                            [partDic setObject:partEntity.cl forKey:@"cl"];
                        }
                        [partDic setObject:[NSNumber numberWithInt:partEntity.chset] forKey:@"chset"];
                        [partDic setObject:[NSNumber numberWithInt:partEntity.partId] forKey:@"id"];
                        if (partEntity.text != nil) {
                            [partDic setObject:partEntity.text forKey:@"text"];
                        }
                        if (partEntity.ct != nil) {
                            [partDic setObject:partEntity.ct forKey:@"ct"];
                        }
                        if (partEntity.partname != nil) {
                            [partDic setObject:partEntity.partname forKey:@"partname"];
                        }
                        [partDic setObject:[NSNumber numberWithInt:partEntity.seq] forKey:@"seq"];
                        //附件内容没有加入....
                        
                        [partArr addObject:partDic];
                    }
                    [mesDic setObject:partArr forKey:@"partList"];
                }
            }
            [mesList addObject:mesDic];
        }
        [dic setObject:mesList forKey:@"messageList"];
    }
    
    return dic;
}

- (void)dealloc {
    if (_snippet != nil) {
        [_snippet release];
        _snippet = nil;
    }
    if (_threadsname != nil) {
        [_threadsname release];
        _threadsname = nil;
    }
    if (_headerImage != nil) {
        [_headerImage release];
        _headerImage = nil;
    }
    if (_lastMsgTime != nil) {
        [_lastMsgTime release];
        _lastMsgTime = nil;
    }
    [super dealloc];
}

@end
