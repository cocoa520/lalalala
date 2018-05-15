//
//  XMLParse.m
//  DriveSync
//
//  Created by 罗磊 on 2018/4/8.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "XMLParse.h"

@implementation XMLParse
@synthesize dataArrays = _dataArrays;
@synthesize currentDic = _currentDic;
@synthesize currentDicKey = _currentDicKey;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArrays = [[NSMutableArray alloc] init];
        _currentDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)decodeXML:(NSString *)xmlString finish:(ParseXMLFinishBlock)finishBlock;
{
    _finishBlock = [finishBlock copy];
    //初始化NSXMLParse对象
    NSXMLParser * xmlParse = [[[NSXMLParser alloc]initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
    //设置代理
    xmlParse.delegate = self;
    [xmlParse parse];
}

/**
 *    开始解析
 */
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
}
/**
 *  获得首尾结点间内容信息的内容
 *
 *  @param parser 执行回调方法的NSXMLParse对象
 *  @param string 结点间的内容
 *  如果结点之间的内容是结点段，那么返回的string首字符为unichar类型的‘\n’
 *  如果不是结点段，那么直接返回之间的信息内容
 */
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //如果结点内容的第一个字符是‘\n’,表示是包含其他结点的结点
    if (string.length > 0 && [string characterAtIndex:0] != '\n')
    {
        //对当前字典进行初始化赋值
        [self.currentDic setValue:string forKey:self.currentDicKey];
    }
}
/**
 *  XML解析完成进行的回调
 *
 *  @param parser 执行回调方法的NSXMLParse对象
 */
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (_finishBlock) {
        _finishBlock(_dataArrays);
    }
}
- (void)dealloc
{
    Block_release(_finishBlock);
    [_dataArrays release],_dataArrays = nil;
    [_currentDic release],_currentDic = nil;
    [_currentDicKey release],_currentDicKey = nil;
    [super dealloc];
}
@end
