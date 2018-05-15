//
//  GooglePhotoAlbumsListXMLParse.m
//  DriveSync
//
//  Created by 罗磊 on 2018/4/8.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "GooglePhotosAlbumsListXMLParse.h"

@implementation GooglePhotosAlbumsListXMLParse

#pragma - mark  NSXMLParserDelegate
/**
 *  准备解析结点进行的回调
 *  在此处可以获取每个xml结点所传递的信息，如(xmlns--类似命名空间)
 *
 *  @param parser        执行回调方法的NSXMLParser对象
 *  @param elementName   结点的字符串描述(如name..)
 *  @param namespaceURI  命名空间的统一资源标志符字符串描述
 *  @param qName         命名空间的字符串描述
 *  @param attributeDict 参数字典
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict
{
    if ([elementName isEqualToString:@"entry"])
    {
        //新建一个索引为elementName的key字典
        NSMutableDictionary * elementNameDictionary = [NSMutableDictionary dictionary];
        //将数据添加到当前数组
        [self.dataArrays addObject:elementNameDictionary];
        //记录当前进行操作的结点字典
        self.currentDic = elementNameDictionary;
    }else if (![elementName isEqualToString:@"entry"])//排除表示不是entry的子节点
    {
        //记录当前的结点值
        self.currentDicKey = elementName;
        
        //设置当前element的值,先附初始值
        [self.currentDic addEntriesFromDictionary:@{elementName:@""}];
    }
}

/**
 *  某个结点解析完毕进行的回调
 *
 *  @param parser       执行回调方法的NSXMLParse对象
 *  @param elementName  结点的字符串描述(如name..)
 *  @param namespaceURI 命名空间的统一资源标志符字符串描述
 *  @param qName        命名空间的字符串描述
 */
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //只有结束Person的时候清除相关数据
    if ([elementName isEqualToString:@"entry"])
    {
        //只有结束entry的时候清除相关数据
        self.currentDic = nil;
        self.currentDicKey = nil;
    }
}
@end
