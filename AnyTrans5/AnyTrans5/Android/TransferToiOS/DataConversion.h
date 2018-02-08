//
//  DataConversion.h
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#ifndef AnyTrans_DataConversion_h
#define AnyTrans_DataConversion_h
//数据转换协议
@protocol DataConversion <NSObject>
- (id)dataConversion:(id)entity;
@end
#endif
