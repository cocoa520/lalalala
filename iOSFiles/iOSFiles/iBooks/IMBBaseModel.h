//
//  BaseModel.h
//  MTWeibo
//  所有对象实体的基类

//  Weibo
//
//  Created by luolei on 13-10-24.


#import <Foundation/Foundation.h>
#import "IMBBaseEntity.h"

@interface IMBBaseModel : IMBBaseEntity <NSCoding>{

}

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;
- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串

@end
