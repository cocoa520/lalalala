//
//  IMBPortTable.h
//  
//
//  Created by ding ming on 17/3/15.
//
//

#import <Foundation/Foundation.h>

@interface IMBPortItem : NSObject {
    int _portId;
    int _cPort;//客服端端口
    int _sPort;//服务端端口
    int _isUsing;//是否正在被使用
}

@property (nonatomic, assign) int portId;
@property (nonatomic, assign) int cPort;//客服端端口
@property (nonatomic, assign) int sPort;//服务端端口
@property (nonatomic, assign) int isUsing;//是否正在被使用

@end

@interface IMBPortTable : NSObject {
    NSMutableArray *_portTableList;
    IMBPortItem *_portItem;
}

@property (nonatomic, retain) NSMutableArray *portTableList;
@property (nonatomic, retain) IMBPortItem *portItem;

+ (IMBPortTable *)singleton;

//获得端口资源
- (IMBPortItem *)getPortItem;
//归还端口资源
- (void)releasePort:(int)portId;

@end
