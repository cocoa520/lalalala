//
//  IMBTransferError.h
//  AnyTrans
//
//  Created by m on 17/9/26.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBTransferError : NSObject
{
    NSMutableArray *_errorArrayM;
}
@property (nonatomic, retain) NSMutableArray *errorArrayM;

+ (IMBTransferError*)singleton;
- (void)removeAllError;//移除所有的失败内容
- (void)addAnErrorWithErrorName:(NSString *)errorName WithErrorReson:(NSString *)errorReson;
@end

@interface IMBError : NSObject
{
    NSString *_name;
    NSString *_reason;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *reson;

@end