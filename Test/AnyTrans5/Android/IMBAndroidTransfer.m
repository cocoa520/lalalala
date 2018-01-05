//
//  IMBAndroidTransfer.m
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBAndroidTransfer.h"

@implementation IMBAndroidTransfer

- (id)initWithTransferDataDic:(NSDictionary *)dataDic TransferDelegate:(id<TransferDelegate>)transferDelegate
{
    if (self = [super init]) {
        _transferDic = [dataDic retain];
        _transferDelegate = transferDelegate;
    }
    return self;
}

- (void)dealloc
{
    [_android release],_android = nil;
    [_transferDic release],_transferDic = nil;
    [super dealloc];
}
@end
