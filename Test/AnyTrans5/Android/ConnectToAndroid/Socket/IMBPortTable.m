//
//  IMBPortTable.m
//  
//
//  Created by ding ming on 17/3/15.
//
//

#import "IMBPortTable.h"
#import <netinet/in.h>

@implementation IMBPortItem
@synthesize portId = _portId;
@synthesize cPort = _cPort;
@synthesize sPort = _sPort;
@synthesize isUsing = _isUsing;

- (id)init {
    self = [super init];
    if (self) {
        _portId = 0;
        _cPort = 0;
        _sPort = 0;
        _isUsing = NO;
    }
    return self;
}

@end

@implementation IMBPortTable
@synthesize portItem = _portItem;
@synthesize portTableList = _portTableList;

+ (IMBPortTable *)singleton {
    static dispatch_once_t onceToken;
    static IMBPortTable *instance;
    dispatch_once(&onceToken, ^{
        instance = [[IMBPortTable alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _portTableList = [[NSMutableArray alloc] init];
        [self initTable];
    }
    return self;
}

//获得端口资源
- (IMBPortItem *)getPortItem {
    for (IMBPortItem *portItem in _portTableList) {
        if (portItem.isUsing == NO) {
//            NSLog(@"portItem.cPort:%d; portItem.sPort:%d",portItem.cPort,portItem.sPort);
//            if ([self portIsFree:portItem.cPort]) {
                portItem.isUsing = YES;
                return portItem;
//            }
        }
    }
    return nil;
}

//归还端口资源
- (void)releasePort:(int)portId {
    for (IMBPortItem *portItem in _portTableList) {
        if (portItem.portId == portId) {
            portItem.isUsing = NO;
            break;
        }
    }
}

- (void)initTable {
    //分配1000对端口到端口池里面
    for (int i = 0; i < 1000; i++)
    {
        IMBPortItem *portItem = [[IMBPortItem alloc] init];
        portItem.portId = i;
        portItem.sPort = 54518;
        portItem.cPort = 54518 + i; //这些端口可不可以用没有验证
        portItem.isUsing = false;
        [_portTableList addObject:portItem];
        [portItem release];
    }
}

//判断端口是否可用
- (BOOL)portIsFree:(int)port {
    struct sockaddr_in sin;
    int sock = -1;
    int ret = 0;
    int opt = 0;
    
    memset(&sin, 0, sizeof (sin));
    sin.sin_family = PF_INET;
    sin.sin_port = htons(port);
    
    sock = socket (PF_INET, SOCK_STREAM, 0);
    if (sock == -1)
        return NO;
    ret = setsockopt (sock, SOL_SOCKET, SO_REUSEADDR,
                      &opt, sizeof (opt));
    ret = bind (sock, (struct sockaddr *)&sin, sizeof (sin));
    close (sock);
    
    return (ret == 0) ? YES : NO;
}

- (void)dealloc
{
    if (_portTableList != nil) {
        [_portTableList release];
        _portTableList = nil;
    }
    [super dealloc];
}

@end
