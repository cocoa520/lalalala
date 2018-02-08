//
//  IMBCoreAndriodSocket.m
//  
//
//  Created by ding ming on 17/3/16.
//
//

#import "IMBCoreAndriodSocket.h"
#import "IMBBigEndianBitConverter.h"
#import "IMBFileHelper.h"

#define FRAGMENTSIZE 1024*1024*2  //2M

@implementation IMBCoreAndriodSocket
@synthesize isSingleQuery = _isSingleQuery;
@synthesize finished = _finished;
@synthesize thread = _thread;
- (id)initWithDetegate:(id)delegate WithAsyncSocket:(GCDAsyncSocket *)asyncSocket {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _asyncSocket = asyncSocket;
        [_asyncSocket setDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    if (_finishBlock != nil) {
        Block_release(_finishBlock);
    }
    if (_headData != nil) {
        [_headData release];
        _headData = nil;
    }
    if (_receiveData != nil) {
        [_receiveData release];
        _receiveData = nil;
    }
    [super dealloc];
}

//向服务端发起请求内容
- (BOOL)launchRequestContent:(NSString *)content FinishBlock:(void (^)(NSData *))finishBlock {
    NSLog(@"isDisconnected：%d",_asyncSocket.isDisconnected);
    NSLog(@"isConnected：%d",_asyncSocket.isConnected);
//    if ([content rangeOfString:@"DEVICE"].location != NSNotFound) {
//        sleep(2);
//    }else {
//        sleep(1);
//    }
    if (_asyncSocket == nil || _asyncSocket.isDisconnected/* || !_asyncSocket.isConnected*/) {
        return NO;
    }
    _operate = @"Query";
    _pacelLen = 0;
    _finished = NO;
    _isSuccessed = NO;
    if (_headData != nil) {
        [_headData release];
        _headData = nil;
    }
    _headData = [[NSMutableData alloc] init];
    if (_receiveData != nil) {
        [_receiveData release];
        _receiveData = nil;
    }
    _receiveData = [[NSMutableData alloc] init];
    if (_finishBlock != nil) {
        Block_release(_finishBlock);
    }
    _finishBlock = Block_copy(finishBlock);
    NSData *bytes = [self getPacelHead:content FragmentLen:0];
    [_asyncSocket writeData:bytes withTimeout:-1 tag:0];
    while (!_finished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return _isSuccessed;
}

//向服务器发起请求内容，导出文件用
- (BOOL)launchRequestContent:(NSString *)content FileSize:(long long)fileSize FinishBlock:(void (^)(NSData *))finishBlock {
//    sleep(1);
    if (_asyncSocket == nil || _asyncSocket.isDisconnected /*|| !_asyncSocket.isConnected*/) {
        return NO;
    }
    _operate = @"Export";
    _pacelLen = fileSize;
    _revcTotalSize = 0;
    _finished = NO;
    _isSuccessed = NO;
    _isHead = NO;
    _writeLen = 10240;
    if (_pacelLen>102400*5) {
        _writeLen = 102400*5;
    }else if (_pacelLen<=102400*5&&_pacelLen>102400){
        _writeLen = 102400*5;
    }else if (_pacelLen<=102400){
        _writeLen = 102400;
    }
    if (_receiveData != nil) {
        [_receiveData release];
        _receiveData = nil;
    }
    _receiveData = [[NSMutableData alloc] init];
    if (_finishBlock != nil) {
        Block_release(_finishBlock);
    }
    _finishBlock = Block_copy(finishBlock);
    NSData *bytes = [self getPacelHead:content FragmentLen:0];
    [_asyncSocket writeData:bytes withTimeout:-1 tag:0];
    while (!_finished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return _isSuccessed;
}

//向服务器发送请求内容，导入文件用户
- (BOOL)launchRequestContent:(NSString *)content FilePath:(NSString *)filePath FileSize:(long long)fileSize FinishBlock:(void (^)(NSData *))finishBlock {
//    sleep(1);
    if (_asyncSocket == nil || _asyncSocket.isDisconnected/* || !_asyncSocket.isConnected*/) {
        return NO;
    }
    _operate = @"Import";
    long long leaveSize = fileSize;
    _isSuccessed = NO;
    if (_finishBlock != nil) {
        Block_release(_finishBlock);
    }
    _finishBlock = Block_copy(finishBlock);
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    while (leaveSize > 0) {
        _finished = NO;
        long long fragmentSize = leaveSize > FRAGMENTSIZE ? FRAGMENTSIZE : leaveSize;
        NSData *bytes = [self getPacelHead:content FragmentLen:(int)fragmentSize];
        [_asyncSocket writeData:bytes withTimeout:-1 tag:0];
        
        NSData *fileData = [readHandle readDataOfLength:fragmentSize];
        NSLog(@"fileData lenght:%lu;  fragmentSize:%lld",(unsigned long)fileData.length,fragmentSize);
        [_asyncSocket writeData:fileData withTimeout:-1 tag:0];
        leaveSize -= fragmentSize;
        while (!_finished) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        _finishBlock(fileData);
    }
    [readHandle closeFile];
    _isSuccessed = YES;
    
    return _isSuccessed;
}

//向服务端发起请求内容,同步文件用
- (BOOL)launchSyncRequestContent:(NSString *)content FinishBlock:(void (^)(NSData *))finishBlock {
//    sleep(1);
    if (_asyncSocket == nil || _asyncSocket.isDisconnected/* || !_asyncSocket.isConnected*/) {
        return NO;
    }
    _operate = @"Sync";
    _finished = NO;
    _isSuccessed = NO;
    if (_finishBlock != nil) {
        Block_release(_finishBlock);
    }
    _finishBlock = Block_copy(finishBlock);
    NSData *bytes = [self getPacelHead:content FragmentLen:0];
    [_asyncSocket writeData:bytes withTimeout:-1 tag:0];
    while (!_finished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return _isSuccessed;
}

//向服务端发起请求内容,删除文件用
- (BOOL)launchDeleteRequestContent:(NSString *)content FinishBlock:(void (^)(NSData *))finishBlock {
//    sleep(1);
    if (_asyncSocket == nil || _asyncSocket.isDisconnected/* || !_asyncSocket.isConnected*/) {
        return NO;
    }
    _operate = @"Delete";
    _finished = NO;
    _isSuccessed = NO;
    if (_finishBlock != nil) {
        Block_release(_finishBlock);
    }
    _finishBlock = Block_copy(finishBlock);
    NSData *bytes = [self getPacelHead:content FragmentLen:0];
    [_asyncSocket writeData:bytes withTimeout:-1 tag:0];
    while (!_finished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return _isSuccessed;
}


// 封装数据包头部
- (NSData *)getPacelHead:(NSString *)content FragmentLen:(int)fragmentLen {
    NSMutableData *totalBytes = [NSMutableData data];
    NSData *contentBytes = [content dataUsingEncoding:NSUTF8StringEncoding];//Encoding.UTF8.GetBytes(content);
    int headLen = htonl((int)0x70F0F0F0);
    NSData *headSignBytes = [NSData dataWithBytes:&headLen length:sizeof(headLen)];
    int fraLen = htonl(fragmentLen);
    NSData *fragmentLenBytes = [NSData dataWithBytes:&fraLen length:sizeof(fraLen)];
    int len = htonl(contentBytes.length);
    NSData *jsonLenBytes = [NSData dataWithBytes:&len length:sizeof(len)];
    [totalBytes appendData:headSignBytes];
    [totalBytes appendData:fragmentLenBytes];
    [totalBytes appendData:jsonLenBytes];
    [totalBytes appendData:contentBytes];
    
    return totalBytes;
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    NSLog(@"didAcceptNewSocket");
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"didConnectToHost");
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
//    NSLog(@"didReadData:%@",sock);
    if (sock == nil || sock.isDisconnected) {
        _isSuccessed = NO;
        //唤醒RunLoop
        [self performSelector:@selector(workup) onThread:_thread withObject:nil waitUntilDone:NO];
        return;
    }
    if (_finished) {
        return;
    }
    int receive_length = (int)data.length;
    if (receive_length > 0) {
        if ([_operate isEqualToString:@"Query"]) {
            if (_isSingleQuery) {
                [self circulReceiveBytes:data];
            }else {
                //把数据头部信息写入headMs
                if (_headData.length < 9) {
                    [_headData appendData:data];
                }
                [_receiveData appendData:data];
                
                //9= 数据包总长度的大小（long =8） + 一个标志位(byte=1)（是否是最后一个包，暂时不考虑到分包，但标志为预留，
                //这里的包不是指的socket通信长度限制而导致的分片，而是服务端我们分包)
                if (_headData.length >= 9 && _pacelLen == 0) {
                    NSData *lenData = [_headData subdataWithRange:NSMakeRange(0, 8)];
                    
                    _pacelLen = [IMBBigEndianBitConverter bigEndianToInt32:(Byte*)lenData.bytes byteLength:(int)lenData.length];
                }
                if (_receiveData.length >= _pacelLen && _pacelLen > 0) {
                    NSData *resultData = [_receiveData subdataWithRange:NSMakeRange(9, _pacelLen - 9)];
//                    NSLog(@"result Data:%@",resultData);
                    _finishBlock(resultData);
                    _isSuccessed = YES;
                    //唤醒RunLoop
                    [self performSelector:@selector(workup) onThread:_thread withObject:nil waitUntilDone:NO];
                }
            }
        }else if([_operate isEqualToString:@"Export"]) {
            if (!_isHead) {
                [_receiveData appendData:data];
                long pacelen = 0;
                int lastpacel = 0;
                long startLen = 0;
                if ([self checkStreamContainsPacel:_receiveData.length withPacelen:&pacelen withLastpacel:&lastpacel withReadPos:startLen]) {
                    _isHead = YES;
                    startLen += 9;
                    NSData *resultData = [_receiveData subdataWithRange:NSMakeRange(startLen, pacelen - 9)];
                    NSString *resultStr = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
                    BOOL isResult = NO;
                    if (resultStr != nil) {
                        NSDictionary *resultDic = [IMBFileHelper dictionaryWithJsonString:resultStr];
                        if ([resultDic.allKeys containsObject:@"code"]) {
                            NSString *codeStr = [resultDic objectForKey:@"code"];
                            if ([codeStr isEqualToString:@"0008"]) {
                                if ([resultDic.allKeys containsObject:@"fileLen"]) {
                                    _pacelLen = [[resultDic objectForKey:@"fileLen"] longLongValue];
                                }
                                isResult = YES;
                            }else {
                                NSLog(@"code error:%@",codeStr);
                            }
                        }
                    }
                    [resultStr release];
                    
                    if (isResult) {
                        if (_receiveData.length - pacelen > 0) {
                            _revcTotalSize += _receiveData.length - pacelen;
                            _finishBlock([_receiveData subdataWithRange:NSMakeRange(pacelen, _receiveData.length - pacelen)]);
                        }
                        if (_revcTotalSize >= _pacelLen) {
                            _isSuccessed = YES;
                            //唤醒RunLoop
                            [self performSelector:@selector(workup) onThread:_thread withObject:nil waitUntilDone:NO];
                            return;
                        }else {
                            [_receiveData resetBytesInRange:NSMakeRange(0, _receiveData.length)];
                            [_receiveData setLength:0];
                        }
                    }else {
                        //结束
                        NSLog(@"file export failed..........");
                        _isSuccessed = NO;
                        //唤醒RunLoop
                        [self performSelector:@selector(workup) onThread:_thread withObject:nil waitUntilDone:YES];
                        return;
                    }
                }
            }else {
                if (!_finished) {
                    _revcTotalSize += receive_length;
                    if (_revcTotalSize >= _pacelLen) {
                        NSData *resultData = [data subdataWithRange:NSMakeRange(0, _pacelLen - (_revcTotalSize - receive_length))];
                        [_receiveData appendData:resultData];
                        _finishBlock(_receiveData);
                        _isSuccessed = YES;
                        //唤醒RunLoop
                        [self performSelector:@selector(workup) onThread:_thread withObject:nil waitUntilDone:NO];
                    }else {
                        [_receiveData appendData:data];
                        if (_receiveData.length >= _writeLen) {
                            _finishBlock(_receiveData);
                            [_receiveData resetBytesInRange:NSMakeRange(0, _receiveData.length)];
                            [_receiveData setLength:0];
                        }
                    }
                }
            }
        }else if ([_operate isEqualToString:@"Import"]) {
            NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if(msg && [msg rangeOfString:@"import_fragment_finished"].location != NSNotFound) {
                _finishBlock(data);
                //唤醒RunLoop
                [self performSelector:@selector(workup) onThread:_thread withObject:nil waitUntilDone:YES];
            }
            [msg release];
        }else if ([_operate isEqualToString:@"Sync"] || [_operate isEqualToString:@"Delete"]) {
            _finishBlock(data);
            _isSuccessed = YES;
            //唤醒RunLoop
            [self performSelector:@selector(workup) onThread:_thread withObject:nil waitUntilDone:NO];
        }
    }
    [sock readDataWithTimeout:-1 tag:0]; //一直监听网络
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"didWriteDataWithTag");
    [sock readDataWithTimeout:-1 tag:0]; //一直监听网络
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSString *errorCode = err.description;
    NSLog(@"errorCode = %@", errorCode);
    _isSuccessed = NO;
    [self performSelector:@selector(workup) onThread:_thread withObject:nil waitUntilDone:NO];
}


// 判断内存流中是否包含完整数据包
- (BOOL)checkStreamContainsPacel:(long)availableBytes withPacelen:(long *)pacelLen withLastpacel:(int *)isLastpacel withReadPos:(long)readPos {
    *pacelLen = 0;
    *isLastpacel = 1;
    
    if (availableBytes > 9) {
        NSData *lenData = [_receiveData subdataWithRange:NSMakeRange(readPos, 8)];
        *pacelLen = [IMBBigEndianBitConverter bigEndianToInt32:(Byte*)lenData.bytes byteLength:(int)lenData.length];
        if (*pacelLen > 0) {
            NSData *sign = [_receiveData subdataWithRange:NSMakeRange(readPos + 8, 1)];
            [sign getBytes:isLastpacel length:sizeof(*isLastpacel)];
            if (*pacelLen <= availableBytes) {
                return true;
            }
        }
    }

    return false;
}

- (void)circulReceiveBytes:(NSData *)recvData {
    [_receiveData appendData:recvData];
    
    int receive_length = (int)_receiveData.length;
    if (receive_length > 0)
    {
        long pacelen = 0;
        int lastpacel = 0;
        long startLen = 0;
        while ([self checkStreamContainsPacel:receive_length withPacelen:&pacelen withLastpacel:&lastpacel withReadPos:startLen]) {
            startLen += 9;
            NSData *resultData = [_receiveData subdataWithRange:NSMakeRange(startLen, pacelen - 9)];
            _finishBlock(resultData);
            startLen = startLen + pacelen - 9;
            receive_length -= pacelen;
            //结束
            if (lastpacel == 0) {
                _isSuccessed = YES;
                //唤醒RunLoop
                [self performSelector:@selector(workup) onThread:_thread withObject:nil waitUntilDone:NO];
                return;
            }
        }
        
        if (receive_length > 0) {
            NSData *surData = [_receiveData subdataWithRange:NSMakeRange(startLen, receive_length)];
//            if (_receiveData != nil) {
//                [_receiveData release];
//                _receiveData = nil;
//            }
//            _receiveData = [[NSMutableData dataWithData:surData] retain];
            [_receiveData resetBytesInRange:NSMakeRange(0, _receiveData.length)];
            [_receiveData setLength:0];
            [_receiveData appendData:surData];
        }else {
//            if (_receiveData != nil) {
//                [_receiveData release];
//                _receiveData = nil;
//            }
//            _receiveData = [[NSMutableData alloc] init];
            [_receiveData resetBytesInRange:NSMakeRange(0, _receiveData.length)];
            [_receiveData setLength:0];
        }
    }
}

- (void)setStopScan {
    _isSuccessed = YES;
    [self performSelector:@selector(workup) onThread:_thread withObject:nil waitUntilDone:NO];
}

- (void)workup {
    NSLog(@"workup");
    _finished = YES;
}

@end
