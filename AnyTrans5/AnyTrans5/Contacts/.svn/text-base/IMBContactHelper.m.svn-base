//
//  IMBContactHelper.m
//  iMobieTrans
//
//  Created by iMobie on 2/24/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBContactHelper.h"

@implementation IMBContactHelper

+(void)arrayWithEnumeratedDic:(NSDictionary *)dic inArray:(NSMutableArray *)array{
    for (NSString *key in dic.allKeys) {
        NSMutableDictionary *dateDic = [[NSMutableDictionary alloc]init];
        [dateDic setObject:[dic objectForKey:key] forKey:key];
        IMBContactKeyValueEntity *dateEntity = [[IMBContactKeyValueEntity alloc]init];
        [dateEntity dicToObject:dateDic];
        [array addObject:dateEntity];
        [dateDic release];
        [dateEntity release];
    }
}

+ (void)arrayWithEnumeratedIMDic:(NSDictionary *)dic inArray:(NSMutableArray *)array{
    for (NSString *key in dic.allKeys) {
        @autoreleasepool {
            NSMutableDictionary *imDic = [[NSMutableDictionary alloc]init];
            [imDic setObject:[dic objectForKey:key] forKey:key];
            IMBContactIMEntity *imEntity = [[IMBContactIMEntity alloc]init];
            [imEntity dicToObject:imDic];
            [array addObject:imEntity];
            [imDic release];
            [imEntity release];
            
        }
    }
}

+(void)arrayWithEnumeratedAddrDic:(NSDictionary *)dic inArray:(NSMutableArray *)array{
    for (NSString *key in dic.allKeys) {
        NSMutableDictionary *addrDic = [[NSMutableDictionary alloc]init];
        [addrDic setObject:[dic objectForKey:key] forKey:key];
        IMBContactAddressEntity *addrEntity = [[IMBContactAddressEntity alloc]init];
        [addrEntity dicToObject:addrDic];
        [array addObject:addrEntity];

        [addrDic release];
        [addrEntity release];

    }
}
+(IMBContactEntity*)assemblyEntityToContactEntity:(IMBContactBaseEntity *)entity inToContactEntity:(IMBContactEntity*)contEntity{
    IMBContactEntity *contactEntity = nil;
    if (contEntity != nil) {
        contactEntity = [[contEntity mutableCopy]autorelease];
    }
    if ([entity isKindOfClass:[IMBContactEntity class]]) {
        if (contactEntity == nil) {
            contactEntity = (IMBContactEntity *)entity;
            contactEntity.contactId = entity.contactId;
            contactEntity.entityID =  [NSNumber numberWithInt:(int)[entity.contactId integerValue]];
            if (contactEntity.displayAsCompany == nil) {
                contactEntity.displayAsCompany = CustomLocalizedString(@"contact_id_95", nil);
            }
        }
    }
    else{
        if (contactEntity == nil) {
            contactEntity = [[[IMBContactEntity alloc]init] autorelease];
            contactEntity.displayAsCompany = CustomLocalizedString(@"contact_id_95", nil);;
            contactEntity.contactId = entity.contactId;
            contactEntity.entityID =  [NSNumber numberWithInt:(int)[entity.contactId integerValue]];
        }

        switch (entity.contactCategory) {
            case Contact_PhoneNumber:
            {
                [contactEntity.phoneNumberArray addObject:entity];
            }
                break;
            case Contact_EmailAddressNumber:
            {
                [contactEntity.emailAddressArray addObject:entity];
            }
                break;
            case Contact_RelatedName:
            {
                [contactEntity.relatedNameArray addObject:entity];
            }
                break;
            case Contact_URL:
            {
                [contactEntity.urlArray addObject:entity];
            }
                break;
            case Contact_Date:
            {
                [contactEntity.dateArray addObject:entity];
            }
                break;
            case Contact_IM:
            {
                [contactEntity.IMArray addObject:entity];
            }
                break;
            case Contact_StreetAddress:
            {
                [contactEntity.addressArray addObject:entity];
            }
            default:
                break;
        }
    }
    return contactEntity;
}

//输入的日期字符串形如：@"1992-05-21 13:08:08"
+ (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    [dateFormatter release];
    
    return destDate;
}

+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    [dateFormatter release];
    
    return destDateString;
    
}


@end
