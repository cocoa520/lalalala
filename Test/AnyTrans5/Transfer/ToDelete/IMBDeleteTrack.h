//
//  IMBDeleteTrack.h
//  AnyTrans
//
//  Created by LuoLei on 16-8-4.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseDelete.h"
/**
 可以删除ringtone voicememos book media  PhotoLibrary Albums
 */
@interface IMBDeleteTrack : IMBBaseDelete
{
   NSMutableArray *_categoryNodesArray;
   CategoryNodesEnum _categoryNodes;
}
/**
 删除 voicememos book PhotoLibrary Albums 需要重构为track对象
 */
- (id)initWithIPod:(IMBiPod *)ipod deleteArray:(NSMutableArray *)deleteArray Category:(CategoryNodesEnum)category;
@end
