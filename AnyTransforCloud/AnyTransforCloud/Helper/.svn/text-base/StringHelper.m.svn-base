//
//  StringHelper.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "StringHelper.h"
#import "RegexKitLite.h"
@implementation StringHelper

+ (BOOL)stringIsNilOrEmpty:(NSString*)string {
    if ([string isKindOfClass:[NSNull class]] ) {
        return YES;
    }
    if (string == nil || [string isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
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
    double gbSize = (double)totalSize / 1073741824;
    double mbSize = (double)totalSize / 1048576;
    double kbSize = (double)totalSize / 1024;
    if (totalSize < 1024) {
        return [NSString stringWithFormat:@" %.0f%@", (double)totalSize,CustomLocalizedString(@"Unit_B", nil)];
    } else {
        if (gbSize > 1024) {
            double tSize = (double)totalSize / 1099511627776;
            return [self Rounding:tSize reserved:decimalPoints capacityUnit:CustomLocalizedString(@"Unit_T", nil)];
        }else if (mbSize > 1024) {
            return [self Rounding:gbSize reserved:decimalPoints capacityUnit:CustomLocalizedString(@"Unit_G", nil)];
        } else if (kbSize > 1024) {
            return [self Rounding:mbSize reserved:decimalPoints capacityUnit:CustomLocalizedString(@"Unit_MB", nil)];
        } else {
            return [self Rounding:kbSize reserved:decimalPoints capacityUnit:CustomLocalizedString(@"Unit_KB", nil)];
        }
    }
}

+(NSString*)Rounding:(double)numberSize reserved:(int)decimalPoints capacityUnit:(NSString*)unit {
    switch (decimalPoints) {
        case 1:
            return [NSString stringWithFormat:@" %.1f %@", numberSize, unit];
            break;
            
        case 2:
            return [NSString stringWithFormat:@" %.2f %@", numberSize, unit];
            break;
            
        case 3:
            return [NSString stringWithFormat:@" %.3f %@", numberSize, unit];
            break;
            
        case 4:
            return [NSString stringWithFormat:@" %.4f %@", numberSize, unit];
            break;
            
        default:
            return [NSString stringWithFormat:@" %.2f %@", numberSize, unit];
            break;
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

+ (NSColor *)getColorFromString:(NSString *)str{

    NSArray *array = [str componentsSeparatedByString:@","];
    float r = [[array objectAtIndex:0] floatValue];
    float g = [[array objectAtIndex:1] floatValue];
    float b = [[array objectAtIndex:2] floatValue];
    float a = [[array objectAtIndex:3] floatValue];
    return [NSColor colorWithDeviceRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

+ (NSMutableAttributedString *)setTextWordStyle:(NSString *)promptStr withFont:(NSFont *)font withLineSpacing:(float)lineSpace withAlignment:(NSTextAlignment)alignment withColor:(NSColor *)color {
    NSMutableAttributedString *promptAs = [[NSMutableAttributedString alloc] initWithString:promptStr];
    [promptAs addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0,promptAs.length)];
    [promptAs addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,promptAs.length)];
    [promptAs addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,promptAs.length)];
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:alignment];
    [mutParaStyle setLineSpacing:lineSpace];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [mutParaStyle release], mutParaStyle = nil;
    return [promptAs autorelease];
}

+ (NSRect)calcuTextBounds:(NSString *)text font:(NSFont *)font {
    NSRect textBounds = NSMakeRect(0, 0, 0, 0);
    if (text) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        [paragraphStyle setAlignment:NSCenterTextAlignment];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    font, NSFontAttributeName,
                                    paragraphStyle, NSParagraphStyleAttributeName,
                                    nil];
        NSSize textSize = [as.string sizeWithAttributes:attributes];
        textBounds = NSMakeRect(0, 0, textSize.width, textSize.height);
        [as release];
    }
    return textBounds;
}

+ (NSAttributedString *)setTextWordStyle:(NSString *)promptStr withFont:(NSFont *)font withAlignment:(NSTextAlignment)alignment withLineBreakMode:(NSLineBreakMode)lineBreakMode withColor:(NSColor *)color {
    NSMutableParagraphStyle *textParagraph = [[NSMutableParagraphStyle alloc] init];
    [textParagraph setLineBreakMode:lineBreakMode];
    [textParagraph setAlignment:alignment];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,color,NSForegroundColorAttributeName,textParagraph,NSParagraphStyleAttributeName,nil];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:(promptStr?promptStr:@"") attributes:dic];
    [textParagraph release];
    return [title autorelease];
}

+ (BOOL)checkEmailIsRight:(NSString *)email {
    BOOL ret = NO;
    ret = [email isMatchedByRegex:@"^\\s*([A-Za-z0-9_-]+(\\.\\w+)*@(\\w+\\.)+\\w{2,5})\\s*$"];
    return ret;
}

+ (BOOL)checkPasswordIsRight:(NSString *)password {
    BOOL ret = NO;
    ret = [password isMatchedByRegex:@"^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]{6,30})$"];//^[A-Za-z0-9]+$
    return ret;
}

+ (BOOL)checkEmailIslengthMore:(NSString *)email {
    NSArray *arr = [email componentsSeparatedByString:@"@"];
    NSString *frontStr = [arr objectAtIndex:0];
    if (frontStr.length > 40) {
        return NO;
    }
    return YES;
}

+ (BOOL)checkEmailIslengthShort:(NSString *)email {
    NSArray *arr = [email componentsSeparatedByString:@"@"];
    NSString *frontStr = [arr objectAtIndex:0];
    if (frontStr.length < 6) {
        return NO;
    }
    return YES;
}

@end
