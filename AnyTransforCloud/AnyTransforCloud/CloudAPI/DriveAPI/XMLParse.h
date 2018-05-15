//
//  XMLParse.h
//  DriveSync
//
//  Created by 罗磊 on 2018/4/8.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ParseXMLFinishBlock)(id result);

@interface XMLParse : NSObject<NSXMLParserDelegate>
{
    NSMutableArray *_dataArrays;
    NSMutableDictionary *_currentDic;
    NSString *_currentDicKey;
    ParseXMLFinishBlock _finishBlock;
}

@property (nonatomic,retain)NSMutableArray *dataArrays;
@property (nonatomic,retain)NSMutableDictionary *currentDic;
@property (nonatomic,retain)NSString *currentDicKey;

- (void)decodeXML:(NSString *)xmlString finish:(ParseXMLFinishBlock)finishBlock;
@end
