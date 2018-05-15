//
//  StringHelper.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "StringHelper.h"
//#import "RegexKitLite.h"
//#import "IMBSoftWareInfo.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+Category.h"
#import "IMBZipHelper.h"

@implementation StringHelper

+ (BOOL)stringIsNilOrEmpty:(NSString*)string {
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (string == nil || [string isEqualToString:@""]  ) {
        return YES;
    } else {
        return NO;
    }
}

//计算text的size
+ (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize {
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle setAlignment:NSCenterTextAlignment];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSFont fontWithName:@"Helvetica Neue" size:fontSize], NSFontAttributeName,
                                paragraphStyle, NSParagraphStyleAttributeName,
                                nil];
    NSSize textSize = [as.string sizeWithAttributes:attributes];
    NSRect textBounds = NSMakeRect(0, 0, textSize.width, textSize.height);
    [as release];
    return textBounds;
}

+ (NSString*)getTimeString:(long)totalLength {
    if (totalLength < 1000) {
        return @"";
    }
    int hours = (int)(totalLength / 3600000 );
    int remain = totalLength % 3600000;
    int minutes = (int)(remain / 60000);
    int seconds = (remain % 60000) / 1000;
    
    NSString *timeStr = @"";
    if (hours > 0) {
        timeStr  = [NSString stringWithFormat:@"%02d:%02d:%02d", hours,minutes, seconds] ;
    } else {
        timeStr  = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds] ;
    }
    return timeStr;
}

+(NSString*)getFileSizeString:(long long)totalSize reserved:(int)decimalPoints {
    double mbSize = (double)totalSize / 1048576;
    double kbSize = (double)totalSize / 1024;
    if (totalSize < 1024) {
        return [NSString stringWithFormat:@" %.0f%@", (double)totalSize,@"B"];
    } else {
        if (mbSize > 1024) {
            double gbSize = (double)totalSize / 1073741824;
            return [self Rounding:gbSize reserved:decimalPoints capacityUnit:@"GB"];
        } else if (kbSize > 1024) {
            return [self Rounding:mbSize reserved:decimalPoints capacityUnit:@"MB"];
        } else {
            return [self Rounding:kbSize reserved:decimalPoints capacityUnit:@"KB"];
        }
    }
}

+(NSString*)Rounding:(double)numberSize reserved:(int)decimalPoints capacityUnit:(NSString*)unit {
    switch (decimalPoints) {
        case 1:
            return [NSString stringWithFormat:@"%.1f %@", numberSize, unit];
            break;
            
        case 2:
            return [NSString stringWithFormat:@"%.2f %@", numberSize, unit];
            break;
            
        case 3:
            return [NSString stringWithFormat:@"%.3f %@", numberSize, unit];
            break;
            
        case 4:
            return [NSString stringWithFormat:@"%.4f %@", numberSize, unit];
            break;
            
        default:
            return [NSString stringWithFormat:@"%.2f %@", numberSize, unit];
            break;
    }
}

+ (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim {
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    
    NSString *text = nil;
    NSString *space = nil;
    NSString *line = nil;
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        if ([text isEqualToString:@"<div"]) {
            html = [html stringByReplacingOccurrencesOfString:
                    [ NSString stringWithFormat:@"%@>", text]
                                                   withString:@"\n"];
        }else
        {
            
            html = [html stringByReplacingOccurrencesOfString:
                    [ NSString stringWithFormat:@"%@>", text]
                                                   withString:@""];
        }
        
        
    }
    NSScanner *spaceScanner = [NSScanner scannerWithString:html];
    while ([spaceScanner isAtEnd] == NO) {
        
        [spaceScanner scanUpToString:@"&nbsp" intoString:NULL] ;
        // find end of tag
        [spaceScanner scanUpToString:@";" intoString:&space] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@;", space]
                                               withString:@" "];
        
        
    }
    
    NSScanner *lineScanner = [NSScanner scannerWithString:html];
    while ([lineScanner isAtEnd] == NO) {
        
        [lineScanner scanUpToString:@"<br" intoString:NULL] ;
        // find end of tag
        [lineScanner scanUpToString:@">" intoString:&line] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>;", line]
                                               withString:@"\n"];
        
        
    }
    
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}

//检查文件是否是图片
+ (BOOL)checkFileIsPicture:(NSString *)fileName {
    BOOL checkResult = false;
    if (fileName != nil) {
        NSString *extensionName = [fileName pathExtension];
        extensionName = [extensionName lowercaseString];
        if ([extensionName isEqualToString:@"png"] || [extensionName isEqualToString:@"jpg"] || [extensionName isEqualToString:@"gif"] || [extensionName isEqualToString:@"bmp"] || [extensionName isEqualToString:@"tiff"]|| [extensionName isEqualToString:@"pcx"]|| [extensionName isEqualToString:@"tga"]|| [extensionName isEqualToString:@"exif"]|| [extensionName isEqualToString:@"fpx"]|| [extensionName isEqualToString:@"svg"]|| [extensionName isEqualToString:@"psd"]|| [extensionName isEqualToString:@"cdr"] || [extensionName isEqualToString:@"pcd"] || [extensionName isEqualToString:@"dxf"] || [extensionName isEqualToString:@"ufo"] || [extensionName isEqualToString:@"eps"] || [extensionName isEqualToString:@"raw"] || [extensionName isEqualToString:@"ai"]) {
            checkResult = true;
        }
    }
    return checkResult;
}


+(NSString *)getStringFirstWord:(NSString *)oriStr {
    NSString *pinYinResult = [NSString string];
    // 按照数据模型中 row 的个数循环
    if (![StringHelper stringIsNilOrEmpty:oriStr]) {
        NSString *str = [oriStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        //        if (oriStr.length >= 1) {
        //            if ([[oriStr substringToIndex:1] isEqualToString:@"\n"]) {
        //                str = [oriStr stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        //            }else {
        //                str = oriStr;
        //            }
        //        }else {
        //            str = oriStr;
        //
        if (![StringHelper stringIsNilOrEmpty:str]) {
            if ([self judgeIsChineseWord:str]) {
                pinYinResult = [pinYinResult stringByAppendingString:@"ZZZZ"];
            }
            for ( int j = 0 ;j < oriStr.length ; j++) {
                NSString *singlePinyinLetter = [[ NSString stringWithFormat: @"%c" ,pinyinFirstLetter([oriStr characterAtIndex:j])] uppercaseString];
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
        }
    }
    return pinYinResult;
}

char pinyinFirstLetter(unsigned short hanzi) {
    int index = hanzi - HANZI_START;
    if (index >= 0&& index <= HANZI_COUNT)
    {
        return firstLetterArray[index];
    }
    else
    {
        return hanzi;
    }
}

+(BOOL)judgeIsChineseWord:(NSString *)oriStr {
    NSRange range=NSMakeRange(0,1);
    NSString *subString=[oriStr substringWithRange:range];
    const char *cString=[subString UTF8String];
    if (cString == NULL) {
        return NO;
    }else {
        if (strlen(cString)==3) {
            return YES;
        }else {
            return NO;
        }
    }
}

+ (NSString *)dataToString:(NSData *)data {
    char *bytes = (char *)data.bytes;
    NSMutableString *contentStr = [NSMutableString string];
    for (int i = 0; i < data.length; i++)
    {
        [contentStr appendFormat:@"%02x", ((unsigned char*)bytes)[i]];
    }
    if (contentStr.length == 0)
    {
        return @"";
    }
    return contentStr;
}

+ (NSString *)stringFromHexString:(NSString *)hexString {
    NSString *unicodeString = @"";
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    if (![StringHelper stringIsNilOrEmpty:hexString]) {
        for (int i = 0; i < [hexString length] - 1; i += 2) {
            @autoreleasepool {
                if (i + 2 > hexString.length) {
                    break;
                }
                unsigned int anInt;
                NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
                NSScanner * scanner = [NSScanner scannerWithString:hexCharStr];
                [scanner scanHexInt:&anInt];
                if (anInt == 0) {
                    anInt = 32;
                }
                myBuffer[i / 2] = (char)anInt;
            }
        }
        
        //替换非法字符
        //    NSData *data = [NSData dataWithBytes:myBuffer length:strlen(myBuffer)];
        //    NSData *tarData = [self replaceNoUtf8:data];
        
        unicodeString = [NSString stringWithCString:myBuffer encoding:4];
        NSLog(@"------字符串=======%@",unicodeString);
        free(myBuffer);
        if (unicodeString == nil) {
            unicodeString = @"";
        }
    }
    

    return unicodeString;
}

+ (NSString *)stringFromHexStringASCII:(NSString *)hexString {
    if ([StringHelper stringIsNilOrEmpty:hexString]) {
        return nil;
    }
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        @autoreleasepool {
            if (i + 2 > hexString.length) {
                break;
            }
            unsigned int anInt;
            NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
            NSScanner * scanner = [NSScanner scannerWithString:hexCharStr];
            [scanner scanHexInt:&anInt];
            if (anInt == 0) {
                anInt = 32;
            }
            myBuffer[i / 2] = (char)anInt;
        }
    }
    
//    NSLog(@"myBuffer:%s",myBuffer);
    
    //替换非法字符
    //    NSData *data = [NSData dataWithBytes:myBuffer length:strlen(myBuffer)];
    //    NSData *tarData = [self replaceNoUtf8:data];
    
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:1];
    NSLog(@"------字符串=======%@",unicodeString);
    free(myBuffer);
    if (unicodeString == nil) {
        unicodeString = @"";
    }
    return unicodeString;
}

+ (NSData *)replaceNoUtf8:(NSData *)data {
    char aa[] = {' ',' ',' ',' ',' ',' '};                      //utf8最多6个字符，当前方法未使用
    NSMutableData *md = [NSMutableData dataWithData:data];
    int loc = 0;
    while(loc < [md length])
    {
        char buffer;
        [md getBytes:&buffer range:NSMakeRange(loc, 1)];
        if((buffer & 0x80) == 0)
        {
            loc++;
            continue;
        }
        else if((buffer & 0xE0) == 0xC0) //判断第一个字节110
        {
            /*loc++;
             if (loc >= [md length]) {
             break;
             }
             [md getBytes:&buffer range:NSMakeRange(loc, 1)];
             if((buffer & 0xC0) == 0x80) //判断第二个字节10
             {
             loc++;
             continue;
             }
             loc--;*/
            int count = 1;
            BOOL success = [self replaceSingleNOUft8:md withIndex:loc withCount:count];
            if (success) {
                loc += (count + 1);
                continue;
            }
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else if((buffer & 0xF0) == 0xE0) //判断的第一个字节 1110
        {
            /*loc++;
             if (loc >= [md length]) {
             break;
             }
             [md getBytes:&buffer range:NSMakeRange(loc, 1)];
             if((buffer & 0xC0) == 0x80) //判断的第二个字节 10
             {
             loc++;
             if (loc >= [md length]) {
             break;
             }
             [md getBytes:&buffer range:NSMakeRange(loc, 1)];
             if((buffer & 0xC0) == 0x80) //判断的第三个字节 10
             {
             loc++;
             continue;
             }
             loc--;
             }
             loc--;*/
            int count = 2;
            BOOL success = [self replaceSingleNOUft8:md withIndex:loc withCount:count];
            if (success) {
                loc += (count + 1);
                continue;
            }
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }else if((buffer & 0xF8) == 0xF0) {
            /*loc++;
             if (loc >= [md length]) {
             break;
             }
             [md getBytes:&buffer range:NSMakeRange(loc, 1)];
             
             
             
             
             if((buffer & 0xC0) == 0x80) //判断的第二个字节 10
             {
             loc++;
             if (loc >= [md length]) {
             break;
             }
             [md getBytes:&buffer range:NSMakeRange(loc, 1)];
             if((buffer & 0xC0) == 0x80) //判断的第三个字节 10
             {
             loc++;
             if (loc >= [md length]) {
             break;
             }
             [md getBytes:&buffer range:NSMakeRange(loc, 1)];
             if((buffer & 0xC0) == 0x80) //判断的第四个字节 10
             {
             loc++;
             continue;
             }
             continue;
             }
             loc--;
             }
             loc--;*/
            int count = 3;
            BOOL success = [self replaceSingleNOUft8:md withIndex:loc withCount:count];
            if (success) {
                loc += (count + 1);
                continue;
            }
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }else if((buffer & 0xFC) == 0xF8) {
            int count = 4;
            BOOL success = [self replaceSingleNOUft8:md withIndex:loc withCount:count];
            if (success) {
                loc += (count + 1);
                continue;
            }
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }else if((buffer & 0xFE) == 0xFC) {
            int count = 5;
            BOOL success = [self replaceSingleNOUft8:md withIndex:loc withCount:count];
            if (success) {
                loc += (count + 1);
                continue;
            }
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else
        {
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
    }
    
    return md;
}

+(BOOL)replaceSingleNOUft8:(NSMutableData *)md withIndex:(int)curIndex withCount:(int)count {
    char buffer;
    for (int i=0; i<count; i++) {
        int nextIndex = curIndex + i + 1;
        if (nextIndex >= [md length]) {
            return NO;
        }
        [md getBytes:&buffer range:NSMakeRange(nextIndex, 1)];
        if((buffer & 0xC0) != 0x80) //判断字节是否是 10 开头
        {
            return NO;
        }
    }
    return YES;
}
//计算文字的尺寸
//+ (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize {
//    NSRect textBounds = NSMakeRect(0, 0, 0, 0);
//    if (text) {
//        NSAttributedString *as = [[NSAttributedString alloc] initWithString:text];
//        NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
//        [paragraphStyle setAlignment:NSLeftTextAlignment];
//        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [NSFont fontWithName:@"Helvetica Neue" size:fontSize], NSFontAttributeName,
//                                    paragraphStyle, NSParagraphStyleAttributeName,
//                                    nil];
//        NSSize textSize = [text sizeWithAttributes:attributes];
//        textBounds = NSMakeRect(0, 0, textSize.width, textSize.height);
//        [as release];
//    }
//    return textBounds;
//}

//+ (NSMutableAttributedString*)measureForStringDrawing:(NSString*)myString withFont:(NSFont*)font withLineSpacing:(float)lineSpacing withMaxWidth:(float)maxWidth withSize:(NSSize*)size withColor:(NSColor*)color {
//    NSMutableAttributedString *retStr = [[NSMutableAttributedString alloc] initWithString:myString];
//    
//    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:myString] autorelease];
//    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(maxWidth, FLT_MAX)] autorelease];
//    
//    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
//    [layoutManager addTextContainer:textContainer];
//    [textStorage addLayoutManager:layoutManager];
//    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
//    [textParagraph setLineSpacing:lineSpacing];
//    [textParagraph setLineBreakMode:NSLineBreakByWordWrapping];
//    [textParagraph setAlignment:NSCenterTextAlignment];
//    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, font, NSFontAttributeName, color,NSForegroundColorAttributeName, [NSColor clearColor], NSBackgroundColorAttributeName, nil];
//    
//    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
//    [textContainer setLineFragmentPadding:lineSpacing];
//    [retStr addAttributes:fontDic range:NSMakeRange(0, textStorage.length)];
//    (void) [layoutManager glyphRangeForTextContainer:textContainer];
//    NSSize tmpSize = [layoutManager usedRectForTextContainer:textContainer].size;
//    (*size).width = ceil(tmpSize.width);
//    (*size).height = ceil(tmpSize.height);
//    return retStr;
//}

//+ (NSMutableAttributedString*)measureForStringDrawing:(NSString*)myString withFont:(NSFont*)font withLineSpacing:(float)lineSpacing withMaxWidth:(float)maxWidth withSize:(NSSize*)size withColor:(NSColor*)color withAlignment:(NSTextAlignment)alignment {
//    NSMutableAttributedString *retStr = [[NSMutableAttributedString alloc] initWithString:myString];
//    
//    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:myString] autorelease];
//    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(maxWidth, FLT_MAX)] autorelease];
//    
//    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
//    [layoutManager addTextContainer:textContainer];
//    [textStorage addLayoutManager:layoutManager];
//    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
//    [textParagraph setLineSpacing:lineSpacing];
//    [textParagraph setLineBreakMode:NSLineBreakByWordWrapping];
//    [textParagraph setAlignment:alignment];
//    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, font, NSFontAttributeName, color,NSForegroundColorAttributeName, [NSColor clearColor], NSBackgroundColorAttributeName, nil];
//    
//    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
//    [textContainer setLineFragmentPadding:lineSpacing];
//    [retStr addAttributes:fontDic range:NSMakeRange(0, textStorage.length)];
//    (void) [layoutManager glyphRangeForTextContainer:textContainer];
//    NSSize tmpSize = [layoutManager usedRectForTextContainer:textContainer].size;
//    (*size).width = ceil(tmpSize.width);
//    (*size).height = ceil(tmpSize.height);
//    return retStr;
//}
//末尾是省略号。。。
//+ (NSMutableAttributedString*)TruncatingTailForStringDrawing:(NSString*)myString withFont:(NSFont*)font withLineSpacing:(float)lineSpacing withMaxWidth:(float)maxWidth withSize:(NSSize*)size withColor:(NSColor*)color withAlignment:(NSTextAlignment)alignment {
//    NSMutableAttributedString *retStr = [[[NSMutableAttributedString alloc] initWithString:myString] autorelease];
//    
//    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:myString] autorelease];
//    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(maxWidth, FLT_MAX)] autorelease];
//    
//    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
//    [layoutManager addTextContainer:textContainer];
//    [textStorage addLayoutManager:layoutManager];
//    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
//    [textParagraph setLineSpacing:lineSpacing];
//    [textParagraph setLineBreakMode:NSLineBreakByTruncatingTail];
//    [textParagraph setAlignment:alignment];
//    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, font, NSFontAttributeName, color,NSForegroundColorAttributeName, [NSColor clearColor], NSBackgroundColorAttributeName, nil];
//    
//    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
//    [textContainer setLineFragmentPadding:lineSpacing];
//    [retStr addAttributes:fontDic range:NSMakeRange(0, textStorage.length)];
//    (void) [layoutManager glyphRangeForTextContainer:textContainer];
//    NSSize tmpSize = [layoutManager usedRectForTextContainer:textContainer].size;
//    (*size).width = ceil(tmpSize.width);
//    (*size).height = ceil(tmpSize.height);
//    return retStr;
//}


+ (NSImage*) getDeviceImage:(IPodFamilyEnum)iPodFamily {
    switch (iPodFamily) {
        case iPod_Gen1_Gen2:
            return [NSImage imageNamed:@"device_ipod_gen"];
            break;
        case iPod_Gen3:
            return [NSImage imageNamed:@"device_ipod_gen"];
            break;
        case iPod_Gen4:
        case iPod_Gen4_2:
            return [NSImage imageNamed:@"device_ipod_gen"];
            break;
        case iPod_Gen5:
            return [NSImage imageNamed:@"device_ipod_gen"];
            break;
        case iPod_Mini:
            return [NSImage imageNamed:@"device_ipod_mini"];
            break;
        case iPod_Nano_Gen1:
            return [NSImage imageNamed:@"device_ipod_nano"];
            break;
        case iPod_Nano_Gen2:
            return [NSImage imageNamed:@"device_ipod_nano"];
            break;
        case iPod_Classic:
            return [NSImage imageNamed:@"device_ipod_classic"];
            break;
        case iPod_Nano_Gen3:
            return [NSImage imageNamed:@"device_ipod_nano"];
            break;
        case iPod_Nano_Gen4:
            return [NSImage imageNamed:@"device_ipod_nano"];
            break;
        case iPod_Nano_Gen5:
            return [NSImage imageNamed:@"device_ipod_nano"];
            break;
        case iPod_Nano_Gen6:
            return [NSImage imageNamed:@"device_ipod_nano"];
            break;
        case iPod_Nano_Gen7:
            return [NSImage imageNamed:@"device_ipod_nano"];
            break;
        case iPod_Shuffle_Gen1:
            return [NSImage imageNamed:@"device_ipod_shuffle"];
            break;
        case iPod_Shuffle_Gen2:
            return [NSImage imageNamed:@"device_ipod_shuffle"];
            break;
        case iPod_Shuffle_Gen3:
            return [NSImage imageNamed:@"device_ipod_shuffle"];
            break;
        case iPod_Shuffle_Gen4:
            return [NSImage imageNamed:@"device_ipod_shuffle"];
            break;
        case iPod_Touch_1:
            return [NSImage imageNamed:@"device_ipod_touch"];
            break;
        case iPod_Touch_2:
            return [NSImage imageNamed:@"device_ipod_touch"];
            break;
        case iPod_Touch_3:
            return [NSImage imageNamed:@"device_ipod_touch"];
            break;
        case iPod_Touch_4:
            return [NSImage imageNamed:@"device_ipod_touch"];
            break;
        case iPod_Touch_5:
            return [NSImage imageNamed:@"device_ipod_touch"];
            break;
        case iPod_Touch_6:
            return [NSImage imageNamed:@"device_ipod_touch"];
            break;
        case iPhone:
            return [NSImage imageNamed:@"device_iphone"];
            break;
        case iPhone_3G:
            return [NSImage imageNamed:@"device_iphone"];
            break;
        case iPhone_3GS:
            return [NSImage imageNamed:@"device_iphone"];
            break;
        case iPhone_4:
            return [NSImage imageNamed:@"device_iphone"];
            break;
        case iPhone_4S:
            return [NSImage imageNamed:@"device_iphone"];
            break;
        case iPhone_5:
            return [NSImage imageNamed:@"device_iphone"];
            break;
        case iPhone_5S:
            return [NSImage imageNamed:@"device_iphone"];
            break;
        case iPhone_5C:
            return [NSImage imageNamed:@"device_iphone"];
            break;
        case iPhone_6:
            return [NSImage imageNamed:@"device_iphone"];
            break;
        case iPhone_6_Plus:
            return [NSImage imageNamed:@"device_iphone"];
            break;
        case iPhone_6S:
        case iPhone_SE:
        case iPhone_7:
        case iPhone_7_Plus:
        case iPhone_8:
        case iPhone_8_Plus:
        case iPhone_X:
            return [NSImage imageNamed:@"device_iphonex"];
            break;
        case iPhone_6S_Plus:
            return [NSImage imageNamed:@"device_iphone"];
            break;
            
        case iPad_1:
            return [NSImage imageNamed:@"device_ipad"];
            break;
        case iPad_2:
            return [NSImage imageNamed:@"device_ipad"];
            break;
        case The_New_iPad:
            return [NSImage imageNamed:@"device_ipad"];
            break;
        case iPad_4:
            return [NSImage imageNamed:@"device_ipad"];
            break;
        case iPad_Air:
            return [NSImage imageNamed:@"device_ipad"];
            break;
        case iPad_Air2:
            return [NSImage imageNamed:@"device_ipad"];
            break;
        case iPad_mini:
            return [NSImage imageNamed:@"device_ipad"];
            break;
        case iPad_mini_2:
            return [NSImage imageNamed:@"device_ipad"];
            break;
        case iPad_mini_3:
        case iPad_mini_4:
        case iPad_5:
        case iPad_6:
        case iPad_Pro:
            return [NSImage imageNamed:@"device_ipad"];
            break;
        case iPod_Unknown:
            return [NSImage imageNamed:@"default_ipod"];
            break;
        case general_Android:
            return [NSImage imageNamed:@"device_android"];
            break;
        case general_iCloud:
            return [NSImage imageNamed:@"device_icloud"];
            break;
        case general_Add_Content:
            return [NSImage imageNamed:@"device_icloudadd"];
            break;
        default:
            return [NSImage imageNamed:@"default_iphone"];
            break;
    }
}

+ (NSImage *)getBackupDevcieImage:(IPodFamilyEnum)iPodFamily {
    switch (iPodFamily) {
        case iPod_Gen1_Gen2:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Gen3:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Gen4:
        case iPod_Gen4_2:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Gen5:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Mini:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Nano_Gen1:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Nano_Gen2:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Classic:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Nano_Gen3:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Nano_Gen4:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Nano_Gen5:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Nano_Gen6:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Nano_Gen7:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Shuffle_Gen1:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Shuffle_Gen2:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Shuffle_Gen3:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Shuffle_Gen4:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Touch_1:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Touch_2:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Touch_3:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Touch_4:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Touch_5:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPod_Touch_6:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPhone:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPhone_3G:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPhone_3GS:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPhone_4:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPhone_4S:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPhone_5:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPhone_5S:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPhone_5C:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPhone_6:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPhone_6_Plus:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
        case iPhone_6S:
        case iPhone_SE:
        case iPhone_7:
        case iPhone_7_Plus:
        case iPhone_8:
        case iPhone_8_Plus:
        case iPhone_X:
            return [NSImage imageNamed:@"airbackup_iphonex"];
            break;
        case iPhone_6S_Plus:
            return [NSImage imageNamed:@"airbackup_iphone"];
            break;
            
        case iPad_1:
            return [NSImage imageNamed:@"airbackup_ipad"];
            break;
        case iPad_2:
            return [NSImage imageNamed:@"airbackup_ipad"];
            break;
        case The_New_iPad:
            return [NSImage imageNamed:@"airbackup_ipad"];
            break;
        case iPad_4:
            return [NSImage imageNamed:@"airbackup_ipad"];
            break;
        case iPad_Air:
            return [NSImage imageNamed:@"airbackup_ipad"];
            break;
        case iPad_Air2:
            return [NSImage imageNamed:@"airbackup_ipad"];
            break;
        case iPad_mini:
            return [NSImage imageNamed:@"airbackup_ipad"];
            break;
        case iPad_mini_2:
            return [NSImage imageNamed:@"airbackup_ipad"];
            break;
        case iPad_mini_3:
        case iPad_mini_4:
        case iPad_5:
        case iPad_6:
        case iPad_Pro:
            return [NSImage imageNamed:@"airbackup_ipad"];
            break;
        default:
            return [NSImage imageNamed:@"airbackup_unrecognized"];
            break;
    }
}

+ (NSString *)createDifferentfileName:(NSString *)filePath {
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSString *fileName = [filePath lastPathComponent];
    NSString *newfilePath = nil;
    NSString *extension = [filePath pathExtension];
    int i = 1;
    //没有扩展名
    if (extension == nil||[extension isEqualToString:@""]) {
        while (1) {
            NSString  *newfileName = [NSString stringWithFormat:@"%@(%d)",fileName,i];
            newfilePath = [filePath stringByReplacingOccurrencesOfString:fileName withString:newfileName];
            
            if (![fileMan fileExistsAtPath:newfilePath]) {
                break;
            }
            i++;
        }
    }else //有扩展名
    {
        NSString *Name = [fileName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",extension] withString:@""];
        while (1) {
            NSString  *newfileName = [NSString stringWithFormat:@"%@(%d).%@",Name,i,extension];
            newfilePath = [filePath stringByReplacingOccurrencesOfString:fileName withString:newfileName];
            if (![fileMan fileExistsAtPath:newfilePath]) {
                break;
            }
            
            i++;
        }
    }
    return newfilePath;
    
}

//NSdata转化为NSString
+ (NSString *)NSDatatoNSString:(NSData*)data {
	Byte bit[data.length];
    [data getBytes:bit length:[data length]];
	NSString *hexStr = @"";
    for (int i=0; i<data.length; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bit[i]&0xff];
        if ([newHexStr length] == 1) {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }else{
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
	return hexStr;
}

//+ (NSMutableAttributedString *)setSingleTextAttributedString:(NSString *)string withFont:(NSFont *)font withColor:(NSColor *)color {
//    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:string];
//    [as addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0,as.length)];
//    [as addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,as.length)];
//    [as addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,as.length)];
//    return [as autorelease];
//}

+ (NSString*)getCategeryStr:(CategoryNodesEnum)category {
    NSString *categoryStr = nil;
    if (category == Category_CameraRoll){
        categoryStr = CustomLocalizedString(@"MenuItem_id_10", nil);
    }else if (category == Category_PhotoLibrary){
        categoryStr = CustomLocalizedString(@"MenuItem_id_12", nil);
    }else if (category == Category_PhotoStream){
        categoryStr = CustomLocalizedString(@"MenuItem_id_11", nil);
    }else if (category == Category_Applications){
        categoryStr = CustomLocalizedString(@"MenuItem_id_14", nil);
    }else if (category == Category_iBooks){
        categoryStr = CustomLocalizedString(@"MenuItem_id_13", nil);
    }else if (category == Category_System){
        categoryStr = CustomLocalizedString(@"MenuItem_id_30", nil);
    }else if (category == Category_Media){
        categoryStr = CustomLocalizedString(@"MenuItem_id_28", nil);
    }else if (category == Category_Video){
        categoryStr = CustomLocalizedString(@"MenuItem_id_29", nil);
    }else if (category == Category_Photos){
        categoryStr = CustomLocalizedString(@"MenuItem_id_9", nil);
    }else if (category == Category_Photos){
        categoryStr = CustomLocalizedString(@"MenuItem_id_20", nil);
    }else {
        categoryStr = CustomLocalizedString(@"MenuItem_id_81", nil);
    }
    return categoryStr;
}

+ (NSColor *)getColorFromString:(NSString *)str{

    NSArray *array = [str componentsSeparatedByString:@","];
    float r = [[array objectAtIndex:0] floatValue];
    float g = [[array objectAtIndex:1] floatValue];
    float b = [[array objectAtIndex:2] floatValue];
    float a = [[array objectAtIndex:3] floatValue];
    return [NSColor colorWithDeviceRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

+ (NSImage *)imageNamed:(NSString *)name {
    NSImage *image = [[NSBundle mainBundle] imageForResource:name];
    return image;
}

+ (NSString *)md5ForFile:(NSString*)filePath {
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    const char *cStr = (const char *)data.bytes;
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, data.length, digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (BOOL)chirstmasActivity {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSDate *nowDate = [self getInternetDate];
    if (!nowDate) {
        NSDate *newDate = [NSDate date];
        NSDateFormatter *formatOne = [[NSDateFormatter alloc] init];
        [formatOne setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT-0800"]];
        [formatOne setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        NSString *newDateOne = [formatOne stringFromDate:newDate];
        nowDate = [dateFormat dateFromString:newDateOne];
        [formatOne release];
        formatOne = nil;
    }
    
    NSDate *startDate = [dateFormat dateFromString:@"12/22/2017 00:00:00"];
    NSDate *endDate = [dateFormat dateFromString:@"01/03/2018 00:00:00"];
    NSTimeInterval secOne = [nowDate timeIntervalSinceDate:startDate];
    NSTimeInterval secTwo = [nowDate timeIntervalSinceDate:endDate];
    if (secOne >= 0 && secTwo < 0) {
        return YES;
    }
    [dateFormat release];
    dateFormat = nil;
    return NO;
}

+ (NSDate *)getInternetDate {
    NSString *urlString = @"http://m.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 2];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    date = [date substringFromIndex:5];
    date = [date substringToIndex:[date length]-4];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    NSDate *netDate = [dMatter dateFromString:date];
    [dMatter release];
    dMatter = nil;
    
    NSTimeZone *zone = [NSTimeZone timeZoneWithAbbreviation:@"GMT-0800"];
    NSInteger interval = [zone secondsFromGMTForDate: netDate];
    NSDate *localeDate = [netDate  dateByAddingTimeInterval: interval];
    return localeDate;
}


+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate {
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate] autorelease];
    return destinationDateNow;
}

+ (NSString *)getUTCFormateLocalDateStr:(NSString *)localDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
//    //输出格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    [dateFormatter release];
    return dateString;
}

+ (NSString *)getUTCFormateLocalDate:(NSDate *)dateNow {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateNowStr = [dateFormatter stringFromDate:dateNow];
    [dateFormatter release];
    return dateNowStr;
}

//解析Noto的content
+ (NSString *)analysisNoteData:(NSData *)noteData withIsCompress:(BOOL)isdeCompress {
    NSData *decompressData = nil;
    if (isdeCompress) {
        decompressData = [self uncompressZippedData:noteData];//ZipHelper.Decompress(noteData);
    }else {
        decompressData = noteData;
    }
    
    if (decompressData == nil) {
        return @"";
    }
    NSInteger fileLength = decompressData.length - 4;
    int Offset = 2;
    if (fileLength > 128) {
        //Paging
        Offset = Offset + 2;
    }else {
        Offset = Offset + 1;
    }
    Offset = Offset + 5;
    NSInteger fileMinLength = decompressData.length - 12;
    
    if (fileMinLength > 128) {
        Offset = Offset + 2;
    }else {
        Offset = Offset + 1;
    }
    Offset = Offset + 2;
    char *bytes = (char *)decompressData.bytes;
    NSMutableString *noteContent = [NSMutableString string];// List<byte> noteContent = new List<byte>();
    for (int i = Offset; i < decompressData.length; i++)
    {
        NSString *text16 = [NSString stringWithFormat:@"%02x",(unsigned char)bytes[i]];
        if ([text16 isEqualToString:@"1a"])
        {
            break;
        }
        [noteContent appendFormat:@"%02x", ((unsigned char*)bytes)[i]];
    }
    if (noteContent.length == 0)
    {
        return @"";
    }
    
    NSString *contentStr = @"";
    if (noteContent.length - 1 > 128)
    {
        if (noteContent.length >= 2) {
            contentStr = [noteContent stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""];
        }
    }else {
        if (noteContent.length >= 1) {
            contentStr = [noteContent stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
        }
    }
    NSString *noteStr = [StringHelper stringFromHexString:contentStr];
    return noteStr;
}
+ (NSData *)uncompressZippedData:(NSData *)compressedData
{
    if ([compressedData length] == 0) return compressedData;
    unsigned full_length = [compressedData length];
    unsigned half_length = [compressedData length] / 2;
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = [compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }
}
//创建Note的content
+(NSData *)greadData:(NSString *)noteContent{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DataPlist" ofType:@"plist"];
    NSMutableDictionary *noteDataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSMutableData *headByte = [NSMutableData data];
    int i = 8;
    NSData *data1 = [NSData dataWithBytes:&i length:1];
    [headByte appendData:data1];
    i = 0;
    NSData *data2 = [NSData dataWithBytes:&i length:1];
    [headByte appendData:data2];
    i = 18;
    NSData *data3 = [NSData dataWithBytes:&i length:1];
    [headByte appendData:data3];
    
    NSMutableData *unknownByte = [NSMutableData data];
    i = 8;
    NSData *unknowndata1 = [NSData dataWithBytes:&i length:1];
    [unknownByte appendData:unknowndata1];
    i = 0;
    NSData *unknowndata2 = [NSData dataWithBytes:&i length:1];
    [unknownByte appendData:unknowndata2];
    i = 16;
    NSData *unknowndata3 = [NSData dataWithBytes:&i length:1];
    [unknownByte appendData:unknowndata3];
    i = 0;
    NSData *unknowndata4 = [NSData dataWithBytes:&i length:1];
    [unknownByte appendData:unknowndata4];
    
    NSMutableData *identifbyte = [NSMutableData data];
    i = 26;
    NSData *iden = [NSData dataWithBytes:&i length:1];
    [identifbyte appendData:iden];
    
    NSMutableData *unknownbyte1 = [NSMutableData data];
    i = 18;
    NSData *unData = [NSData dataWithBytes:&i length:1];
    [unknownbyte1 appendData:unData];
    
    NSMutableData *lenbytes = [NSMutableData data];
    NSData* noteData = [noteContent dataUsingEncoding:NSUTF8StringEncoding];
    if (noteData.length < 128) {
        i = noteData.length;
        NSData *iden = [NSData dataWithBytes:&i length:1];
        [lenbytes appendData:iden];
    }else{
        int pageCount = noteData.length/128;
        int firstbytes = noteData.length - (pageCount -1)*128;
        NSData *iden = [NSData dataWithBytes:&firstbytes length:1];
        NSData *iden1 = [NSData dataWithBytes:&pageCount length:1];
        [lenbytes appendData:iden];
        [lenbytes appendData:iden1];
    }
    NSData *sectionBytes = [noteDataDic objectForKey:@"NoteData1"];
    
    NSMutableData *section1List = [NSMutableData data];
    i = 40;
    NSData *sectionData = [NSData dataWithBytes:&i length:1];
    [section1List appendData:sectionData];
    i = 1;
    NSData *sectionData1 = [NSData dataWithBytes:&i length:1];
    [section1List appendData:sectionData1];
    i = 26;
    NSData *sectionData2 = [NSData dataWithBytes:&i length:1];
    [section1List appendData:sectionData2];
    
    int charCount = noteContent.length;
    BOOL isPaging = charCount >=128? YES : NO;
    NSMutableData *charCountList = [NSMutableData data];
    if (isPaging) {
        i = 17;
        NSData *sectionData2 = [NSData dataWithBytes:&i length:1];
        [section1List appendData:sectionData2];
    }else{
        i = 16;
        NSData *sectionData2 = [NSData dataWithBytes:&i length:1];
        [section1List appendData:sectionData2];
    }
    [section1List appendData:[noteDataDic objectForKey:@"NoteData2"]];
    
    if (isPaging) {
        int pageCount = charCount / 128;
        int firstPageBytes = charCount - (pageCount -1) *128;
        NSData *sectionData1 = [NSData dataWithBytes:&firstPageBytes length:1];
        NSData *sectionData2 = [NSData dataWithBytes:&pageCount length:1];
        [charCountList appendData:sectionData1];
        [charCountList appendData:sectionData2];
    }else{
        NSData *sectionData2 = [NSData dataWithBytes:&charCount length:1];
        [charCountList appendData:sectionData2];
    }
    [section1List appendData:charCountList];
    [section1List appendData:[noteDataDic objectForKey:@"NoteData3"]];
    
    NSMutableData *section2List = [NSMutableData data];
    i = 40;
    NSData *section2Data = [NSData dataWithBytes:&i length:1];
    [section2List appendData:section2Data];
    
    i = 2;
    NSData *section2Data2 = [NSData dataWithBytes:&i length:1];
    [section2List appendData:section2Data2];
    
    i = 26;
    NSData *section2Data3 = [NSData dataWithBytes:&i length:1];
    [section2List appendData:section2Data3];
    [section2List appendData:[noteDataDic objectForKey:@"NoteData4"]];
    if (isPaging) {
        i = 29;
        NSData *section2Data2 = [NSData dataWithBytes:&i length:1];
        [section2List appendData:section2Data2];
        
        i = 10;
        NSData *section2Data3 = [NSData dataWithBytes:&i length:1];
        [section2List appendData:section2Data3];
    }else{
        i = 28;
        NSData *section2Data2 = [NSData dataWithBytes:&i length:1];
        [section2List appendData:section2Data2];
        
        i = 10;
        NSData *section2Data3 = [NSData dataWithBytes:&i length:1];
        [section2List appendData:section2Data3];
    }
    NSMutableData *endSectionList = [NSMutableData data];
    if (isPaging) {
        i = 27;
        NSData *section2Data2 = [NSData dataWithBytes:&i length:1];
        [endSectionList appendData:section2Data2];
        
        i = 10;
        NSData *section2Data3 = [NSData dataWithBytes:&i length:1];
        [endSectionList appendData:section2Data3];
    }else{
        i = 26;
        NSData *section2Data2 = [NSData dataWithBytes:&i length:1];
        [endSectionList appendData:section2Data2];
        
        i = 10;
        NSData *section2Data3 = [NSData dataWithBytes:&i length:1];
        [endSectionList appendData:section2Data3];
    }
    [endSectionList appendData:[noteDataDic objectForKey:@"NoteData5"]];
    if (isPaging) {
        i = 18;
        NSData *section2Data2 = [NSData dataWithBytes:&i length:1];
        [endSectionList appendData:section2Data2];
        
        i = 03;
        NSData *section2Data3 = [NSData dataWithBytes:&i length:1];
        [endSectionList appendData:section2Data3];
    }else{
        i = 18;
        NSData *section2Data2 = [NSData dataWithBytes:&i length:1];
        [endSectionList appendData:section2Data2];
        
        i = 02;
        NSData *section2Data3 = [NSData dataWithBytes:&i length:1];
        [endSectionList appendData:section2Data3];
    }
    i = 8;
    NSData *secti= [NSData dataWithBytes:&i length:1];
    [endSectionList appendData:secti];
    [endSectionList appendData:charCountList];
    
    [endSectionList appendData:[noteDataDic objectForKey:@"NoteData6"]];
    
    NSMutableData *endBytes = [NSMutableData data];
    i = 8;
    NSData *endData = [NSData dataWithBytes:&i length:1];
    [endBytes appendData:endData];
    [endBytes appendData:charCountList];
    
    if (charCount == noteData.length) {
        i = 18;
        NSData *secti= [NSData dataWithBytes:&i length:1];
        [endBytes appendData:secti];
        
        i = 02;
        NSData *secti1= [NSData dataWithBytes:&i length:1];
        [endBytes appendData:secti1];
        
        i = 24;
        NSData *secti2= [NSData dataWithBytes:&i length:1];
        [endBytes appendData:secti2];
        
        i = 01;
        NSData *secti3 = [NSData dataWithBytes:&i length:1];
        [endBytes appendData:secti3];
    }else{
        i = 18;
        NSData *secti2= [NSData dataWithBytes:&i length:1];
        [endBytes appendData:secti2];
        
        i = 0;
        NSData *secti3 = [NSData dataWithBytes:&i length:1];
        [endBytes appendData:secti3];
    }
    int endCount = endBytes.length;
    NSData *endCountData = [NSData dataWithBytes:&endCount length:1];
    [endSectionList appendData:endCountData];
    [endSectionList appendData:endBytes];
    
    NSMutableData *datas = [NSMutableData data];
    int countentLength = unknownbyte1.length + lenbytes.length + noteData.length + sectionBytes.length + section1List.length + section2List.length + endSectionList.length;
    //    NSData *countentData = [NSData dataWithBytes:&countentLength length:1];
    //    [datas appendData:countentData];
    [datas appendData:headByte];
    
    int totalLength = countentLength +unknownByte.length + identifbyte.length;
    totalLength = countentLength >=128 ? totalLength +2 : totalLength + 1;
    if (totalLength >=128) {
        int pageCount = totalLength / 128;
        int firstPageBytes = totalLength - (pageCount -1) *128;
        NSData *countentData1 = [NSData dataWithBytes:&firstPageBytes length:1];
        NSData *countentData2 = [NSData dataWithBytes:&pageCount length:1];
        [datas appendData:countentData1];
        [datas appendData:countentData2];
    }else{
        NSData *countentData = [NSData dataWithBytes:&totalLength length:1];
        [datas appendData:countentData];
    }
    [datas appendData:unknownByte];
    [datas appendData:identifbyte];
    if (countentLength >=128) {
        int pageCount = countentLength /128;
        int firstbyes = countentLength - (pageCount -1)*128;
        NSData *secti2 = [NSData dataWithBytes:&firstbyes length:1];
        NSData *secti3 = [NSData dataWithBytes:&pageCount length:1];
        [datas appendData:secti2];
        [datas appendData:secti3];
    }else{
        NSData *secti3 = [NSData dataWithBytes:&countentLength length:1];
        [datas appendData:secti3];
    }
    [datas appendData:unknownbyte1];
    [datas appendData:lenbytes];
    [datas appendData:noteData];
    [datas appendData:sectionBytes];
    [datas appendData:section1List];
    [datas appendData:section2List];
    [datas appendData:endSectionList];
    return datas;
}

+(NSData*) gzipData:(NSData*)pUncompressedData {
    if (!pUncompressedData || [pUncompressedData length] == 0)
    {
        NSLog(@"%s: Error: Can't compress an empty or null NSData object.", __func__);
        return nil;
    }
    
    z_stream zlibStreamStruct;
    zlibStreamStruct.zalloc    = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so
    zlibStreamStruct.zfree     = Z_NULL; // that when we call deflateInit2 they will be
    zlibStreamStruct.opaque    = Z_NULL; // updated to use default allocation functions.
    zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far
    zlibStreamStruct.next_in   = (Bytef*)[pUncompressedData bytes]; // Pointer to input bytes
    zlibStreamStruct.avail_in  = [pUncompressedData length]; // Number of input bytes left to process
    
    int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
    if (initError != Z_OK)
    {
        NSString *errorMsg = nil;
        switch (initError)
        {
            case Z_STREAM_ERROR:
                errorMsg = @"Invalid parameter passed in to function.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Insufficient memory.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        NSLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        [errorMsg release];
        return nil;
    }
    
    // Create output memory buffer for compressed data. The zlib documentation states that
    // destination buffer size must be at least 0.1% larger than avail_in plus 12 bytes.
    NSMutableData *compressedData = [NSMutableData dataWithLength:[pUncompressedData length] * 1.01 + 12];
    
    int deflateStatus;
    do
    {
        // Store location where next byte should be put in next_out
        zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;
        
        // Calculate the amount of remaining free space in the output buffer
        // by subtracting the number of bytes that have been written so far
        // from the buffer's total capacity
        zlibStreamStruct.avail_out = [compressedData length] - zlibStreamStruct.total_out;
        deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
        
    } while ( deflateStatus == Z_OK );
    
    // Check for zlib error and convert code to usable error message if appropriate
    if (deflateStatus != Z_STREAM_END)
    {
        NSString *errorMsg = nil;
        switch (deflateStatus)
        {
            case Z_ERRNO:
                errorMsg = @"Error occured while reading file.";
                break;
            case Z_STREAM_ERROR:
                errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
                break;
            case Z_DATA_ERROR:
                errorMsg = @"The deflate data was invalid or incomplete.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Memory could not be allocated for processing.";
                break;
            case Z_BUF_ERROR:
                errorMsg = @"Ran out of output buffer for writing compressed bytes.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        NSLog(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        [errorMsg release];
        // Free data structures that were dynamically created for the stream.
        deflateEnd(&zlibStreamStruct);
        return nil;
    }
    // Free data structures that were dynamically created for the stream.
    deflateEnd(&zlibStreamStruct);
    [compressedData setLength: zlibStreamStruct.total_out];
    return compressedData;
}

+ (NSSortDescriptor *)creatChineseSortDescriptorWithkey:(NSString *)key WithAscending:(BOOL)ascending {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending comparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = @"";
        for (int i = 0; i < [(NSString *)obj1 length]; i ++) {
            char ch = pinyinFirstLetter([(NSString *)obj1 characterAtIndex:i]);
            str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@"%c", ch]];
        }
        NSString *str2 = @"";
        for (int i = 0; i < [(NSString *)obj2 length]; i ++) {
            char ch = pinyinFirstLetter([(NSString *)obj2 characterAtIndex:i]);
            str2 = [str2 stringByAppendingString:[NSString stringWithFormat:@"%c", ch]];
        }
        return [[str1 lowercaseString] compare:[str2 lowercaseString]];
    }];
    return sortDescriptor;
}

+ (NSString *)getSortString:(NSString *)oriStr {
    NSString *sortStr = @"";
    if (![StringHelper stringIsNilOrEmpty:oriStr]) {
        for (int i = 0; i < [oriStr length]; i ++) {
            char ch = pinyinFirstLetter([oriStr characterAtIndex:i]);
            sortStr = [sortStr stringByAppendingString:[NSString stringWithFormat:@"%c", ch]];
        }
    }
    return [sortStr lowercaseString];
}


//末尾是省略号。。。
+ (NSMutableAttributedString*)TruncatingTailForStringDrawing:(NSString*)myString withFont:(NSFont*)font withLineSpacing:(float)lineSpacing withMaxWidth:(float)maxWidth withSize:(NSSize*)size withColor:(NSColor*)color withAlignment:(NSTextAlignment)alignment {
    NSMutableAttributedString *retStr = [[[NSMutableAttributedString alloc] initWithString:myString] autorelease];
    
    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:myString] autorelease];
    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(maxWidth, FLT_MAX)] autorelease];
    
    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:lineSpacing];
    [textParagraph setLineBreakMode:NSLineBreakByTruncatingTail];
    [textParagraph setAlignment:alignment];
    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, font, NSFontAttributeName, color,NSForegroundColorAttributeName, [NSColor clearColor], NSBackgroundColorAttributeName, nil];
    
    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:lineSpacing];
    [retStr addAttributes:fontDic range:NSMakeRange(0, textStorage.length)];
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    NSSize tmpSize = [layoutManager usedRectForTextContainer:textContainer].size;
    (*size).width = ceil(tmpSize.width);
    (*size).height = ceil(tmpSize.height);
    return retStr;
}

+ (FileTypeEnum)getFileFormatWithExtension:(NSString *)extension {
    
    NSArray *imageArr = @[@"png",@"jpg",@"gif",@"bmp",@"jpeg",@"tiff"];
    for (NSString *str in imageArr) {
        if ([str isEqualToString:extension]) {
            return ImageFile;
        }
    }
    NSArray *musicArr = @[@"mp3",@"m4a",@"wma",@"wav",@"rm",@"mdi",@"m4r",@"m4b",@"m4p",@"flac",@"amr",@"ogg",@"ac3",@"ape",@"aac",@"mka",@"wv"];
    for (NSString *str in musicArr) {
        if ([str isEqualToString:extension]) {
            return MusicFile;
        }
    }
    
    NSArray *movieArr = @[@"mp4",@"m4v",@"mov",@"wmv",@"rmvb",@"mkv",@"avi",@"flv",@"rm",@"3gp",@"mpg",@"webm"];
    for (NSString *str in movieArr) {
        if ([str isEqualToString:extension]) {
            return MovieFile;
        }
    }
    if ([extension isEqualToString:@"txt"]) {
        return TxtFile;
    }else if ([extension isEqualToString:@"doc"] || [extension isEqualToString:@"docx"]) {
        return DocFile;
    }else if ([extension isEqualToString:@"zip"]) {
        return ZIPFile;
    }else if ([extension isEqualToString:@"dmg"]) {
        return dmgFile;
    }else if ([extension isEqualToString:@"epub"] || [extension isEqualToString:@"pdf"]) {
        return BookFile;
    }else if ([extension isEqualToString:@"ppt"] || [extension isEqualToString:@"pptx"]) {
        return PPtFile;
    }else if ([extension isEqualToString:@"xlsx"]) {
        return excelFile;
    }else if ([extension isEqualToString:@"vcf"]) {
        return contactFile;
    }
    return CommonFile;
}

@end
