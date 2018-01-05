//
//  IMBCoreAndriodSocket.h
//  
//
//  Created by ding ming on 17/3/16.
//
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

typedef void(^FinishBlock)(NSData *data);

@interface IMBCoreAndriodSocket : NSObject <GCDAsyncSocketDelegate> {
    GCDAsyncSocket *_asyncSocket;
    id _delegate;
    NSMutableData *_receiveData;
    NSMutableData *_headData;
    long long _pacelLen;
    long long _revcTotalSize;
    long long _writeLen;
    FinishBlock _finishBlock;
    BOOL _finished;
    BOOL _isSuccessed;
    BOOL _isHead;
    NSString *_operate;
    BOOL _isSingleQuery;   //判断查询时，是否是单条单条记录返回到客服端的
    
    NSThread *_thread;
}
@property (nonatomic, readwrite) BOOL isSingleQuery;
@property (nonatomic, readwrite) BOOL finished;
@property (nonatomic, readwrite, retain) NSThread *thread;
- (id)initWithDetegate:(id)delegate WithAsyncSocket:(GCDAsyncSocket *)asyncSocket;
//向服务端发起请求内容
- (BOOL)launchRequestContent:(NSString *)content FinishBlock:(void (^)(NSData *))finishBlock;
//向服务器发起请求内容，导出文件用
- (BOOL)launchRequestContent:(NSString *)content FileSize:(long long)fileSize FinishBlock:(void (^)(NSData *))finishBlock;
//向服务器发送请求内容，导入文件用户
- (BOOL)launchRequestContent:(NSString *)content FilePath:(NSString *)filePath FileSize:(long long)fileSize FinishBlock:(void (^)(NSData *))finishBlock;
//向服务端发起请求内容,同步文件用
- (BOOL)launchSyncRequestContent:(NSString *)content FinishBlock:(void (^)(NSData *))finishBlock;
//向服务端发起请求内容,删除文件用
- (BOOL)launchDeleteRequestContent:(NSString *)content FinishBlock:(void (^)(NSData *))finishBlock;

- (void)setStopScan;

@end
