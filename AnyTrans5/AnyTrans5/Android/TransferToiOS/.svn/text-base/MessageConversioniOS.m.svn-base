//
//  MessageConversioniOS.m
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "MessageConversioniOS.h"
#import "IMBSMSChatDataEntity.h"
#import "IMBADMessageEntity.h"
#import "DateHelper.h"
#import "IMBAndroid.h"
#import "IMBLogManager.h"
@implementation MessageConversioniOS
- (id)dataConversion:(id)entity
{
    IMBThreadsEntity *thread = (IMBThreadsEntity *)entity;
    IMBSMSChatDataEntity *chat = [[IMBSMSChatDataEntity alloc] init];
    if (thread.type == 0) {
        //普单发 需要我们自己构建chat_identifier
        if (thread.recipients.count == 1) {
            chat.chatIdentifier = [thread.recipients objectAtIndex:0];
        }
    }else{
        //群发chat70128064118777265  需要自己构建chat70128064118777265
        NSString *randomStr = [MessageConversioniOS generate18weishu];
        NSString *chatidentify = [@"chat" stringByAppendingString:randomStr];
        chat.chatIdentifier = chatidentify;
        if (thread.recipients.count >1) {
            [chat.addressArray addObjectsFromArray:thread.recipients];
        }
    }
    chat.handleService = @"SMS";
    //IMBADMessageEntity 中的date是从1970年开始的时间戳  并且是毫秒
    //IMBMessageDataEntity msgDate是从2001年开始的
    for (IMBADMessageEntity *admessage in thread.messageList) {
        IMBMessageDataEntity *message = [[IMBMessageDataEntity alloc] init];
        if ([DateHelper getDateLength:admessage.date] == 10) {
            message.msgDate = [DateHelper timeIntervalFrom1970To2001:(double)(admessage.date)];

        }else if ([DateHelper getDateLength:admessage.date] == 13){
            message.msgDate = [DateHelper timeIntervalFrom1970To2001:(double)(admessage.date/1000.0)];
        }
    
        message.isRead = admessage.read;
        if (message.isRead) {
            message.msgReadDate = message.msgDate;
        }
        if (admessage.type == 1) {
            message.isSent = 0;//收件箱
        }else{
            message.isSent = 1;//发件箱
        }
        if (admessage.smsType == 0) {
            //短信
            message.msgText = admessage.body;
            if (message.msgText.length > 0) {
                [chat.msgModelList addObject:message];
            }
            [message release];
        }else{
           //彩信  将彩信转化为短信 附件暂时不用导入
            [message release],message = nil;
            message.msgText = @"";
            IMBMessageDataEntity *amessage = nil;
            BOOL isText = NO;
            BOOL isAttach = NO;
            for (IMBSMSPartEntity *part in admessage.partList) {
                if ([part.ct hasPrefix:@"text"]) {
                    if (!isText) {
                        message = [[IMBMessageDataEntity alloc] init];
                        if ([DateHelper getDateLength:admessage.date] == 10) {
                            message.msgDate = [DateHelper timeIntervalFrom1970To2001:(double)(admessage.date)];
                            
                        }else if ([DateHelper getDateLength:admessage.date] == 13){
                            message.msgDate = [DateHelper timeIntervalFrom1970To2001:(double)(admessage.date/1000.0)];
                        }
                        message.isRead = admessage.read;
                        if (message.isRead) {
                            message.msgReadDate = message.msgDate;
                        }
                        if (admessage.type == 1) {
                            message.isSent = 0;//收件箱
                        }else{
                            message.isSent = 1;//发件箱
                        }
                    }
                    message.msgText = [message.msgText stringByAppendingString:part.text?:@""];
                    if (![chat.msgModelList containsObject:message]) {
                        [chat.msgModelList addObject:message];
                        [message release];
                    }
                    isText = YES;
                    isAttach = NO;
                }else if ([[part.ct lowercaseString] hasPrefix:@"image"]||[[part.ct lowercaseString] hasPrefix:@"audio"]||[[part.ct lowercaseString] hasPrefix:@"video"]){
                    amessage = [[IMBMessageDataEntity alloc] init];
                    if ([DateHelper getDateLength:admessage.date] == 10) {
                        amessage.msgDate = [DateHelper timeIntervalFrom1970To2001:(double)(admessage.date)];
                        
                    }else if ([DateHelper getDateLength:admessage.date] == 13){
                        amessage.msgDate = [DateHelper timeIntervalFrom1970To2001:(double)(admessage.date/1000.0)];
                    }
                    amessage.isRead = admessage.read;
                    if (amessage.isRead) {
                        amessage.msgReadDate = message.msgDate;
                    }
                    if (admessage.type == 1) {
                        amessage.isSent = 0;//收件箱
                    }else{
                        amessage.isSent = 1;//发件箱
                    }
                    IMBSMSAttachmentEntity *attachment = [[IMBSMSAttachmentEntity alloc] init];
                    attachment.attGUID = [MessageConversioniOS createGUID];
                    attachment.createDate = amessage.msgDate;
                    attachment.startDate = 0;
                    //构建附件路径
                    NSString *extension = @"jpg";
                    NSString *uti = @"";
                    NSString *mime_type = @"";
                    if ([[part.ct lowercaseString] hasPrefix:@"image"]) {
                        extension = [[part.ct lowercaseString] stringByReplacingOccurrencesOfString:@"image/" withString:@""];
                        if ([extension isEqualToString:@"jpg"]||[extension isEqualToString:@"jpeg"]) {
                            uti = @"public.jpeg";
                            mime_type = @"image/jpeg";
                        }else if ([extension isEqualToString:@"png"]){
                            uti = @"public.png";
                            mime_type = @"image/png";
                        }else if ([extension isEqualToString:@"gif"]){
                            uti = @"com.compuserve.gif";
                            mime_type = @"image/gif";
                        }else{
                            uti = [@"public." stringByAppendingString:extension];
                            mime_type = part.ct;
                        }
                    }else if ([[part.ct lowercaseString] hasPrefix:@"audio"]){
                        extension = [[part.ct lowercaseString] stringByReplacingOccurrencesOfString:@"audio/" withString:@""];
                        if ([extension isEqualToString:@"amr"]){
                            uti = @"org.3gpp.adaptive-multi-rate-audio";
                            mime_type = @"audio/amr";
                        }else if ([extension isEqualToString:@"mp3"]||[extension isEqualToString:@"mpeg"]){
                            uti = @"public.mp3";
                            mime_type = @"audio/mpeg";
                            extension = @"mp3";
                        }else {
                            uti = [@"public." stringByAppendingString:extension];
                            mime_type = part.ct;
                        }
                    }else if ([[part.ct lowercaseString] hasPrefix:@"video"]){
                        extension = [[part.ct lowercaseString] stringByReplacingOccurrencesOfString:@"video/" withString:@""];
                        if ([extension isEqualToString:@"mov"]){
                            uti = @"com.apple.quicktime-movie";
                            mime_type = @"video/quicktime";
                        }else if ([extension isEqualToString:@"mp4"]){
                            uti = @"public.mpeg-4";
                            mime_type = @"video/mp4";
                        }else {
                            uti = [@"public." stringByAppendingString:extension];
                            mime_type = part.ct;
                        }
                    }
                    NSString *fileName = [self getAttachfilename:attachment extension:extension];
                    attachment.fileName = [@"~/" stringByAppendingPathComponent:fileName];
                    attachment.utiName = uti;
                    attachment.mimeType = mime_type;
                    attachment.transferState = 5;
                    attachment.isOutgoing = 1;
                    attachment.transferName = [fileName lastPathComponent];
                    if (!part.isLoad) {
                        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"loading attachName %@",fileName]];
                        //需要下载
                        [_android.adSMS getAttachmentContent:part withPath:nil];
                        if (![[NSFileManager defaultManager] fileExistsAtPath:part.localPath]) {
                            continue;
                        }
                    }
                    attachment.attachLoaction = part.localPath;
                    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:attachment.attachLoaction  error:nil];
                    attachment.totalBytes = [[fileAttributes objectForKey:NSFileSize] longLongValue];
                    [amessage.attachmentList addObject:attachment];
                    [attachment release];
                    if (![chat.msgModelList containsObject:amessage]) {
                        [chat.msgModelList addObject:amessage];
                        [amessage release];
                    }
                    isAttach = YES;
                    isText = NO;
                }
            }
        }
    }
    return [chat autorelease];
}

- (NSString *)getAttachfilename:(IMBSMSAttachmentEntity *)attach  extension:(NSString *)extension
{
    NSString *fileName = nil;
    NSString *basePath = @"Library/SMS/Attachments";
    NSString *parentPath1 = [basePath stringByAppendingPathComponent:[MessageConversioniOS generatezimuAndshuzi]];
    NSString *parentPath2 = [parentPath1 stringByAppendingPathComponent:[MessageConversioniOS generate2weishu:2]];
    NSString *parentPath3 = [parentPath2 stringByAppendingPathComponent:attach.attGUID];
    [attach.parentPathArray addObject:parentPath1];
    [attach.parentPathArray addObject:parentPath2];
    [attach.parentPathArray addObject:parentPath3];
    fileName = [parentPath3 stringByAppendingPathComponent:[NSString stringWithFormat:@"IMG_%@.%@",[MessageConversioniOS generate2weishu:4],extension]];
    return fileName;
}

+ (NSString *)createGUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}

+ (NSString *)generate18weishu
{
    NSString *strRandom = @"";
    for (int i=0; i<18; i++) {
        strRandom = [ strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    return strRandom;
}

//随机生成n位数字
+ (NSString *)generate2weishu:(int)weishu
{
    NSString *strRandom = @"";
    for (int i=0; i<weishu; i++) {
        strRandom = [ strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    return strRandom;
}

//随机生成一位ABCDEF中的字母
+ (NSString *)shuffledAlphabet {
    NSString *alphabet = @"ABCDEF";
    
    // Get the characters into a C array for efficient shuffling
    NSUInteger numberOfCharacters = [alphabet length];
    unichar *characters = calloc(numberOfCharacters, sizeof(unichar));
    [alphabet getCharacters:characters range:NSMakeRange(0, numberOfCharacters)];
    
    // Perform a Fisher-Yates shuffle
    for (NSUInteger i = 0; i < numberOfCharacters; ++i) {
        NSUInteger j = (arc4random_uniform(numberOfCharacters - i) + i);
        unichar c = characters[i];
        characters[i] = characters[j];
        characters[j] = c;
    }
    // Turn the result back into a string
    NSString *result = [NSString stringWithCharacters:characters length:1];
    free(characters);
    return result;
}

//随机生成一位数字加字母
+ (NSString *)generatezimuAndshuzi
{
    NSString *str = @"";
    str = [str stringByAppendingString:[MessageConversioniOS generate2weishu:1]];
    str = [str stringByAppendingString:[[MessageConversioniOS shuffledAlphabet] lowercaseString]];
    return str;
}

@end
