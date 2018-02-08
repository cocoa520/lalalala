//
//  IMBContactManager.m
//  ParseiPhoneInfoDemo
//
//  Created by Pallas on 4/15/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBContactManager.h"
#import "NSDictionary+Category.h"
#import "IMBContactHelper.h"
//#import "IMBExportSetting.h"
#import "RegexKitLite.h"
#import <AddressBook/AddressBook.h>
#import "StringHelper.h"

@implementation IMBContactManager
@synthesize allPersionDic = _allPersionDic;
@synthesize allPersionDicFromSqlite = _allPersionDicFromSqlite;
@synthesize similarDic = _similarDic;
@synthesize redundancyDic = _redundancyDic;
@synthesize allContactArray = _allContactArray;
@synthesize allContactArrayFormSqlite = _allContactArrayFromSqlite;
@synthesize allContactBaseInfoArray = _allContactBaseInfoArray;
@synthesize exportPath = _exportPath;

- (id)initWithAMDevice:(AMDevice*)device1 {
    self = [super init];
    if (self) {
        [super initWithAMDevice:device1];
        allDomains = [[NSMutableArray alloc] init];
        [allDomains addObject:DOMAIN_CONTACT];
        [allDomains addObject:DOMAIN_COMMON_CONTACT];
        [allDomains addObject:DOMAIN_ANCHOR];
        [allDomains addObject:DOMAIN_DATE];
        [allDomains addObject:DOMAIN_URL];
        [allDomains addObject:DOMAIN_STREET_ADDRESS];
        [allDomains addObject:DOMAIN_PHONE_NUMBER];
        [allDomains addObject:DOMAIN_EMAIL_ADDRESS];
        [allDomains addObject:DOMAIN_RELATED_NAME];
        [allDomains addObject:DOMAIN_IM];
        [allDomains addObject:DOMAIN_MOBILE_SYNC];
        deviceHandle = [device retain];
        fm = [NSFileManager defaultManager];
    }
    return self;
}


- (void)dealloc {
    if (allDomains != nil) {
        [allDomains release];
        allDomains = nil;
    }
    
    if (deviceHandle != nil) {
        [deviceHandle release];
        deviceHandle =nil;
    }
    
    if (_allPersionDic != nil) {
        [_allPersionDic release];
        _allPersionDic = nil;
    }
    
    if (_allPersionDicFromSqlite != nil) {
        [_allPersionDicFromSqlite release];
        _allPersionDicFromSqlite = nil;
    }
    
    if (_similarDic != nil) {
        [_similarDic release];
        _similarDic = nil;
    }
    
    if (_redundancyDic != nil) {
        [_redundancyDic release];
        _redundancyDic = nil;
    }
    
    if (_addressBookConnection != nil) {
        [_addressBookConnection close];
        [_addressBookConnection release];
        _addressBookConnection = nil;
    }
    
    if (_addressBookImagesConnection != nil) {
        [_addressBookConnection close];
        [_addressBookImagesConnection release];
        _addressBookImagesConnection = nil;
    }
    
    [super dealloc];
}

+ (BOOL)checkContactValidWithIPod:(IMBiPod *)ipod{
    return [super checkItemsValidWithIPod:ipod itemKey:@"Contacts"];
}

- (void)queryAllContact{
    [[IMBLogManager singleton] writeInfoLog:@"queryAllContact begin!"];
    if (_allPersionDic != nil) {
        [_allPersionDic release];
        _allPersionDic = nil;
    }
    if (_allContactArray != nil) {
        [_allContactArray removeAllObjects];
        [_allContactArray release];
        _allContactArray = nil;
    }
    
    _allPersionDic = [[NSMutableDictionary alloc] init];
    _allContactArray = [[NSMutableArray alloc]init];
    
    NSArray *message;
    NSArray *retArray;

    retArray = [mobileSync startQuerySessionWithDomain:DOMAIN_COMMON_CONTACT];
    

    
    for (id item in retArray) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            NSDictionary *tmpDic = item;
            NSArray *allKey = [tmpDic allKeys];
            if (allKey != nil && [allKey count] > 0) {
                for (NSString *key in allKey) {
                    if ([key.lowercaseString rangeOfString:@"group"].location != NSNotFound) {
                        continue;
                    }
                    NSMutableDictionary *contactDic = [[NSMutableDictionary alloc] init];
                    [contactDic setValue:[tmpDic valueForKey:key] forKey:DOMAIN_CONTACT];
                    [_allPersionDic setValue:contactDic forKey:key];
                    [contactDic release];
                }
            }
        }
    }
    
    message = [NSArray arrayWithObjects:
               @"SDMessageAcknowledgeChangesFromDevice",
               DOMAIN_COMMON_CONTACT,
               nil];
    
    while (YES) {
        if (mobileSync == nil || _threadBreak) {
            break;
        }
        retArray = [mobileSync getData:message waitingReply:YES];
        if ([[retArray objectAtIndex:0] isEqualToString:@"SDMessageDeviceReadyToReceiveChanges"]) {
            break;
        } else {
            // 得到每个联系人的其他信息
            NSDictionary *allDetailDic = [self getDetailItem:retArray];
            NSArray *allDetailKey = [allDetailDic allKeys];
            
            [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"queryAllContact allDetailKey count:%lu",(unsigned long)allDetailKey.count]];
            for (NSString *akey in allDetailKey) {
                // 取出联系人的信息资料
                NSDictionary *singleDetailDic = [allDetailDic valueForKey:akey];
                NSArray *singleDetailKey = [singleDetailDic allKeys];
                
                // e.g com.apple.contacts.Phone Number
                NSString *reName = nil;
                if ([singleDetailKey containsObject:RECORD_ENTITY_NAME]) {
                    reName = [singleDetailDic objectForKey:RECORD_ENTITY_NAME];
                }
                
                NSArray *contactKeyArray = nil;
                if ([singleDetailKey containsObject:ITEM_CONTACT_KEY]) {
                    contactKeyArray = [singleDetailDic objectForKey:ITEM_CONTACT_KEY];
                }
                
                for (NSString *contactKey in contactKeyArray) {
                    NSMutableDictionary *persionDic = [_allPersionDic valueForKey:contactKey];
                    NSMutableDictionary *tmpDic = nil;
                    NSArray *entityNameKeys = [persionDic allKeys];
                    if ([entityNameKeys containsObject:reName]) {
                        tmpDic = [[persionDic objectForKey:reName] retain];
                    } else {
                        tmpDic = [[NSMutableDictionary alloc] init];
                        [persionDic setObject:tmpDic forKey:reName];
                    }
                    [tmpDic setObject:[allDetailDic valueForKey:akey] forKey:akey];
                    [tmpDic release];
                }
            }
        }
    }
    
    [mobileSync endSessionWithDomain:DOMAIN_COMMON_CONTACT];

    for (NSString *keystring in _allPersionDic.allKeys) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[_allPersionDic objectForKey:keystring],keystring, nil];
        IMBContactEntity *entity = nil;

        if (entity == nil) {
            if([[dic.allKeys objectAtIndex:0] isEqualToString:@"149"]){
                NSLog(@"123");
            }
            entity = [[[IMBContactEntity alloc]init] autorelease];
            [entity dicToObject:dic];
            
            NSString *allname;
            if (![entity.firstName isEqualToString:@""]) {
                allname = [[entity.firstName stringByAppendingString:@" "] stringByAppendingString:entity.lastName];
            }else {
                allname = entity.lastName;
            }
            if (![StringHelper stringIsNilOrEmpty:entity.allName]) {
                allname = entity.allName;
            }
            if ([allname isEqualToString:@""]) {
                allname = CustomLocalizedString(@"contact_id_48", nil);
            }
            [entity setAllName:allname];
        }
        [_allContactArray addObject:entity];
    }
    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"allcontactCount:%lu",(unsigned long)_allContactArray.count]];
     [[IMBLogManager singleton] writeInfoLog:@"queryAllContact end!"];
}

- (NSDictionary*)getDetailItem:(NSArray*)message {
    NSDictionary *detailDic = nil;
    for (id item in message) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            detailDic = item;
        }
    }
    return detailDic;
}

- (BOOL)insertContact:(IMBContactEntity*)addContentEntity {
    NSMutableDictionary *addDic = [[NSMutableDictionary alloc]initWithDictionary:[addContentEntity objectToDic]];
    NSDictionary *retDic = nil;
    
    NSArray *retArray = nil;
    [mobileSync startModifySessionWithDomain:DOMAIN_COMMON_CONTACT withDomainAnchor:DOMAIN_ANCHOR];
    
    /****************** 添加联人的com.apple.contacts.Contact值 ******************/
    NSObject *value = [[addDic objectForKey:addContentEntity.contactId] retain];
    if (addContentEntity.contactId != nil) {
        [addDic removeObjectForKey:addContentEntity.contactId];
    }
    if (value != nil) {
        [addDic setObject:value forKey:[NSString stringWithFormat:@"%ld",NSIntegerMax]];
        [value release];
    }
    retArray = [self postAddContact:addDic];
    
    if (retArray != nil) {
        retDic = [self getDetailItem:retArray];
        if (retDic != nil) {
            NSMutableDictionary *personDic = nil;
            // 返回的是添加进去的ID，这时候需要去重新构建所有的信息
            NSArray *randKeys = [retDic allKeys];
            if (randKeys != nil && [randKeys count] > 0) {
                for (NSString *randKey in randKeys) {
                    NSString *pidKey = [retDic objectForKey:randKey];
                    
                    // 对每一个添加的域进行修改
                    personDic = [addDic objectForKey:randKey];
                    NSArray *domainKeys = [personDic allKeys];
                    if ([domainKeys count] > 0) {
                        for (NSString *domainKey in domainKeys) {
                            if ([domainKey isEqualToString:DOMAIN_CONTACT]) {
                                continue;
                            }
                            increNum = 0;
                            [self postAddExtraToContact:domainKey addContent:addDic newPidKey:pidKey];
                        }
                    }
                    
                    // 将新增的联系人添加到所有的联系人记录里面去,但是里面的数据不匹配,要么匹配要么获取
                    // [_allPersionDic setObject:personDic forKey:pidKey];
                }
            } else {
                retDic = nil;
            }
        } else {
            retDic = nil;
        }
    }
    [mobileSync endSessionWithDomain:DOMAIN_COMMON_CONTACT];
    return YES;
}

- (NSArray*)postAddContact:(NSMutableDictionary*)addContent {
    NSArray *retArray = nil;
    
    NSMutableArray *contactArray = [[NSMutableArray alloc] init];
    [contactArray addObject:@"SDMessageProcessChanges"];
    [contactArray addObject:DOMAIN_COMMON_CONTACT];
    
    NSMutableDictionary *totalContactDic = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *personDic = nil;
    for (NSString *pidKey in addContent) {
        //取出整个联系人修改过的信息
        personDic = [addContent objectForKey:pidKey];
        
        NSDictionary *tmpcontactDic = [personDic objectForKey:DOMAIN_CONTACT];
        NSMutableDictionary *newContactDic = [NSMutableDictionary dictionaryWithDictionary:tmpcontactDic];
        [totalContactDic setObject:newContactDic forKey:pidKey];
    }
    
    [contactArray addObject:totalContactDic];
    [totalContactDic release];
    
    [contactArray addObject:[NSNumber numberWithBool:YES]];
    
    NSMutableDictionary *pullDic = [[NSMutableDictionary alloc] init];
    [pullDic setObject:[NSNumber numberWithBool:YES] forKey:@"SyncDeviceLinkAllRecordsOfPulledEntityTypeSentKey"];
    [pullDic setObject:[NSArray arrayWithObjects:DOMAIN_CONTACT, @"com.apple.contacts.Group", nil] forKey:@"SyncDeviceLinkEntityNamesKey"];
    [contactArray addObject:pullDic];
    [pullDic release];
    
    retArray = [mobileSync getData:contactArray waitingReply:YES];
    [contactArray release];
    return retArray;
}

- (void)postAddExtraToContact:(NSString*)domain addContent:(NSMutableDictionary*)addContent newPidKey:(NSString*)newPidKey {
    NSMutableArray *domainKeyArray = [[NSMutableArray alloc] init];
    [domainKeyArray addObject:@"SDMessageProcessChanges"];
    [domainKeyArray addObject:DOMAIN_COMMON_CONTACT];
    
    NSMutableArray *domainContentArray = [[NSMutableArray alloc] init];
    [domainContentArray addObject:@"SDMessageProcessChanges"];
    [domainContentArray addObject:DOMAIN_COMMON_CONTACT];
    
    NSMutableDictionary *totalDomainDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *totalDomainKeyDic = [[NSMutableDictionary alloc] init];
    
    NSString *preKeyFormat = nil;
    BOOL singleFlag = YES;
    if ([domain isEqualToString:DOMAIN_EMAIL_ADDRESS]) {
        preKeyFormat = @"4/%@/%d";
        singleFlag = YES;
    } else if ([domain isEqualToString:DOMAIN_PHONE_NUMBER]) {
        preKeyFormat = @"3/%@/%d";
        singleFlag = YES;
    } else if ([domain isEqualToString:DOMAIN_STREET_ADDRESS]) {
        preKeyFormat = @"5/%@/%d";
        singleFlag = YES;
    } else if ([domain isEqualToString:DOMAIN_RELATED_NAME]) {
        preKeyFormat = @"23/%@/%d";
        singleFlag = YES;
    } else if ([domain isEqualToString:DOMAIN_IM]) {
        preKeyFormat = @"13/%@/%d";
        singleFlag = YES;
    } else if ([domain isEqualToString:DOMAIN_DATE]) {
        preKeyFormat = @"12/%@/%d";
        singleFlag = NO;
    } else if ([domain isEqualToString:DOMAIN_URL]) {
        preKeyFormat = @"22/%@/%d";
        singleFlag = YES;
    }
    
    NSMutableDictionary *personDic = nil;
    for (NSString *pidKey in addContent) {
        personDic = [addContent objectForKey:pidKey];
        
        // 得到要附加的联系人域数据
        NSMutableDictionary *extraDomainDic = [[personDic objectForKey:domain] retain];
        
        NSString *preKey = nil;
        for (int i = 0; i < 100; i++) {
            preKey = [NSString stringWithFormat:preKeyFormat, newPidKey, i];
            [totalDomainKeyDic setObject:preKey forKey:preKey];
        }
        
        // 检查附加段是否有数据
        if (extraDomainDic == nil || [[extraDomainDic allKeys] count] == 0) {
            [extraDomainDic release];
            return;
        }
        
        if (extraDomainDic != nil && [[extraDomainDic allKeys] count] > 0) {
            // 取出每一段的实际数据内容 key就是x/x/x
            for (NSString *key in extraDomainDic) {
                NSMutableDictionary *extraSingleDic = [[extraDomainDic objectForKey:key] retain];
                NSMutableDictionary *domainDic =[[NSMutableDictionary alloc] init];
                NSArray *esKeys = [extraSingleDic allKeys];
                for (NSString *eskey in esKeys) {
                    if ([eskey isEqualToString:ITEM_CONTACT_KEY]) {
                        [domainDic setObject:[NSArray arrayWithObjects:newPidKey, nil] forKey:eskey];
                    } else {
                        id value = [[extraSingleDic objectForKey:eskey] retain];
                        if (value != nil) {
                            [domainDic setObject:value forKey:eskey];
                        }
                        [value release];
                    }
                }
                [extraSingleDic release];
                // 生成新的Key
                NSString *newKey = [NSString stringWithFormat:@"%d", increNum];
                increNum += 1;
                [totalDomainDic setObject:domainDic forKey:newKey];
                [domainDic release];
            }
        }
        [extraDomainDic release];
    }
    
    [domainKeyArray addObject:totalDomainKeyDic];
    [domainContentArray addObject:[[[NSDictionary alloc] initWithDictionary:totalDomainDic] autorelease]];
    
    [domainKeyArray addObject:[NSNumber numberWithBool:singleFlag]];
    [domainContentArray addObject:[NSNumber numberWithBool:singleFlag]];
    
    [totalDomainDic release];
    [totalDomainKeyDic release];
    
    NSMutableDictionary *pullDic;
    pullDic = [[NSMutableDictionary alloc] init];
    [pullDic setObject:[NSNumber numberWithBool:YES] forKey:@"SyncDeviceLinkAllRecordsOfPulledEntityTypeSentKey"];
    [pullDic setObject:[NSArray arrayWithObjects:domain, nil] forKey:@"SyncDeviceLinkEntityNamesKey"];
    [domainKeyArray addObject:pullDic];
    [domainContentArray addObject:pullDic];
    [pullDic release];
    
    NSArray *retArray = [mobileSync getData:domainKeyArray waitingReply:YES];
    [domainKeyArray release];
    
    retArray = [mobileSync getData:domainContentArray waitingReply:YES];
    [domainContentArray release];
}

- (BOOL)modifyContact:(IMBContactBaseEntity*)modifiedEntity {
    //    NSArray *message = nil;
    //    NSArray *retArray = nil;
    NSMutableDictionary *modifiedContent = [[NSMutableDictionary alloc]initWithDictionary:[modifiedEntity objectToDic]];
    [mobileSync startModifySessionWithDomain:DOMAIN_COMMON_CONTACT withDomainAnchor:DOMAIN_ANCHOR];
    /****************** 修改联人的com.apple.contacts.Contact值 ******************/
    if([[[modifiedContent objectForKey:[[modifiedContent allKeys] objectAtIndex:0]] allKeys] containsObject:DOMAIN_CONTACT]) {
        [self postContact:modifiedContent];
    }
    /****************** 修改联人的其他值 ******************/
    NSMutableDictionary *personDic = nil;
    for (NSString *pidKey in modifiedContent) {
        personDic = [modifiedContent objectForKey:pidKey];
        NSArray *domainKeys = [personDic allKeys];
        if ([domainKeys count] > 0) {
            // 将没有传进来的域全部清除
            for (NSString *domainKey in allDomains) {
                if ([domainKey isEqualToString:DOMAIN_CONTACT] || [domainKeys containsObject:domainKey]) {
                    continue;
                }
                increNum = 0;
                [self clearMessageFromDevice:domainKey withPidKey:pidKey];
            }
            for (NSString *domainKey in domainKeys) {
                if ([domainKey isEqualToString:DOMAIN_CONTACT]) {
                    continue;
                }
                increNum = 0;
                [self postModifyMessageToDevice:domainKey modifyContent:modifiedContent];
            }
        }
    }
    [mobileSync endSessionWithDomain:DOMAIN_COMMON_CONTACT];
    return YES;
}


- (BOOL)delContract:(NSArray*)contactEntityArray  {
    NSArray *retArray = nil;
    [mobileSync startDeleteSessionWithDomain:DOMAIN_COMMON_CONTACT withDomainAnchor:DOMAIN_ANCHOR];
    NSArray *delContent = [self prepareDelData:contactEntityArray];
    retArray = [mobileSync getData:delContent waitingReply:NO];
    [mobileSync endSessionWithDomain:DOMAIN_COMMON_CONTACT];
    return YES;
}

- (void)postContact:(NSMutableDictionary*)modifyContent{
    NSArray *retArray = nil;
    
    NSMutableArray *contactArray = [[NSMutableArray alloc] init];
    [contactArray addObject:@"SDMessageProcessChanges"];
    [contactArray addObject:DOMAIN_COMMON_CONTACT];
    
    NSMutableDictionary *totalContactDic = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *personDic = nil;
    NSString *pidKey = [modifyContent.allKeys objectAtIndex:0];
    //取出整个联系人修改过的信息
    personDic = [modifyContent objectForKey:pidKey];
    
    NSMutableDictionary *contactDic =[[NSMutableDictionary alloc] init];
    NSDictionary *tmpcontactDic = [personDic objectForKey:DOMAIN_CONTACT];
    NSMutableDictionary *newContactDic = [NSMutableDictionary dictionaryWithDictionary:tmpcontactDic];
    if (newContactDic != nil) {
        NSArray *allKeys = [newContactDic allKeys];
        for (NSString *key in allKeys) {
            id value = [newContactDic objectForKey:key];
            if (value != nil) {
                [contactDic setObject:value forKey:key];
            }
            [newContactDic removeObjectForKey:key];
        }
    }
    
    
    [totalContactDic setObject:contactDic forKey:pidKey];
    [contactDic release];
    
    [contactArray addObject:totalContactDic];
    [totalContactDic release];
    
    [contactArray addObject:[NSNumber numberWithBool:YES]];
    
    NSMutableDictionary *pullDic = [[NSMutableDictionary alloc] init];
    [pullDic setObject:[NSNumber numberWithBool:YES] forKey:@"SyncDeviceLinkAllRecordsOfPulledEntityTypeSentKey"];
    [pullDic setObject:[NSArray arrayWithObjects:DOMAIN_CONTACT, @"com.apple.contacts.Group", nil] forKey:@"SyncDeviceLinkEntityNamesKey"];
    [contactArray addObject:pullDic];
    [pullDic release];
    
    retArray = [mobileSync getData:contactArray waitingReply:YES];
    [contactArray release];
}

- (void)postContact:(NSMutableDictionary*)modifyContent orgPersionDic:(NSMutableDictionary*)orgPersionDic {
    NSArray *retArray = nil;
    NSMutableArray *contactArray = [[NSMutableArray alloc] init];
    [contactArray addObject:@"SDMessageProcessChanges"];
    [contactArray addObject:@"com.apple.Contacts"];
    
    NSMutableDictionary *totalContactDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *personDic = nil;
    for (NSString *pidKey in modifyContent) {
        //取出整个联系人修改过的信息
        personDic = [modifyContent objectForKey:pidKey];
        
        NSMutableDictionary *contactDic =[[NSMutableDictionary alloc] init];
        NSMutableDictionary *oldContactDic = [[orgPersionDic objectForKey:DOMAIN_CONTACT] retain];
        NSDictionary *tmpcontactDic = [personDic objectForKey:DOMAIN_CONTACT];
        NSMutableDictionary *newContactDic = [NSMutableDictionary dictionaryWithDictionary:tmpcontactDic];
        if (oldContactDic == nil) {
            if (newContactDic != nil) {
                NSArray *allKeys = [newContactDic allKeys];
                for (NSString *key in allKeys) {
                    id value = [newContactDic objectForKey:key];
                    if (value != nil) {
                        [contactDic setObject:value forKey:key];
                    }
                    [newContactDic removeObjectForKey:key];
                }
            }
        } else {
            for (NSString *key in oldContactDic) {
                NSArray *nkeys = [newContactDic allKeys];
                if ([nkeys containsObject:key]) {
                    id value = [newContactDic objectForKey:key];
                    if (value != nil) {
                        [contactDic setObject:value forKey:key];
                    }
                    [newContactDic removeObjectForKey:key];
                } else {
                    [contactDic setObject:[oldContactDic valueForKey:key] forKey:key];
                }
            }
            if ([newContactDic count] > 0) {
                for (NSString *key in newContactDic) {
                    [contactDic setObject:[newContactDic valueForKey:key] forKey:key];
                }
            }
        }
        
        [oldContactDic release];
        
        [totalContactDic setObject:contactDic forKey:pidKey];
        [contactDic release];
    }
    
    [contactArray addObject:totalContactDic];
    [totalContactDic release];
    
    [contactArray addObject:[NSNumber numberWithBool:YES]];
    
    NSMutableDictionary *pullDic = [[NSMutableDictionary alloc] init];
    [pullDic setObject:[NSNumber numberWithBool:YES] forKey:@"SyncDeviceLinkAllRecordsOfPulledEntityTypeSentKey"];
    [pullDic setObject:[NSArray arrayWithObjects:DOMAIN_CONTACT, @"com.apple.contacts.Group", nil] forKey:@"SyncDeviceLinkEntityNamesKey"];
    [contactArray addObject:pullDic];
    [pullDic release];
    
    retArray = [mobileSync getData:contactArray waitingReply:YES];
    [contactArray release];
}

- (void)postModifyMessageToDevice:(NSString*)domain modifyContent:(NSMutableDictionary*)modifyContent {
    NSMutableArray *domainKeyArray = [[NSMutableArray alloc] init];
    [domainKeyArray addObject:@"SDMessageProcessChanges"];
    [domainKeyArray addObject:DOMAIN_COMMON_CONTACT];
    
    NSMutableArray *domainContentArray = [[NSMutableArray alloc] init];
    [domainContentArray addObject:@"SDMessageProcessChanges"];
    [domainContentArray addObject:DOMAIN_COMMON_CONTACT];
    
    NSMutableDictionary *totalDomainDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *totalDomainKeyDic = [[NSMutableDictionary alloc] init];
    
    NSString *preKeyFormat = nil;
    BOOL singleFlag = YES;
    if ([domain isEqualToString:DOMAIN_EMAIL_ADDRESS]) {
        preKeyFormat = @"4/%@/%d";
        singleFlag = YES;
    } else if ([domain isEqualToString:DOMAIN_PHONE_NUMBER]) {
        preKeyFormat = @"3/%@/%d";
        singleFlag = YES;
    } else if ([domain isEqualToString:DOMAIN_STREET_ADDRESS]) {
        preKeyFormat = @"5/%@/%d";
        singleFlag = YES;
    } else if ([domain isEqualToString:DOMAIN_RELATED_NAME]) {
        preKeyFormat = @"23/%@/%d";
        singleFlag = YES;
    } else if ([domain isEqualToString:DOMAIN_IM]) {
        preKeyFormat = @"13/%@/%d";
        singleFlag = YES;
    } else if ([domain isEqualToString:DOMAIN_DATE]) {
        preKeyFormat = @"12/%@/%d";
        singleFlag = NO;
    } else if ([domain isEqualToString:DOMAIN_URL]) {
        preKeyFormat = @"22/%@/%d";
        singleFlag = YES;
    }
    
    NSMutableDictionary *personDic = nil;
    NSString *pidKey = [modifyContent.allKeys objectAtIndex:0];
    personDic = [modifyContent objectForKey:pidKey];
    // 得到修改个人的域数据
    NSMutableDictionary *newDomainDic = [NSMutableDictionary dictionaryWithDictionary:[personDic objectForKey:domain]];
    
    NSString *preKey = nil;
    for (int i = 0; i < 100; i++) {
        preKey = [NSString stringWithFormat:preKeyFormat, pidKey, i];
        [totalDomainKeyDic setObject:preKey forKey:preKey];
    }
    
    
    // 在修改完老数据的同时,增加新的数据纪录,在修改老记录完成后,将修改的新纪录从对象中移出后剩下的新纪录处理
    if (newDomainDic != nil && [newDomainDic count] > 0) {
        // key就是x/x/x
        for (NSString *key in newDomainDic) {
            NSString *newKey = [NSString stringWithFormat:@"%d", increNum];
            increNum += 1;
            [totalDomainDic setObject:[newDomainDic valueForKey:key] forKey:newKey];
        }
    }
    
    [domainKeyArray addObject:totalDomainKeyDic];
    [domainContentArray addObject:[[[NSDictionary alloc] initWithDictionary:totalDomainDic] autorelease]];
    
    [domainKeyArray addObject:[NSNumber numberWithBool:singleFlag]];
    [domainContentArray addObject:[NSNumber numberWithBool:singleFlag]];
    
    [totalDomainDic release];
    [totalDomainKeyDic release];
    
    NSMutableDictionary *pullDic;
    pullDic = [[NSMutableDictionary alloc] init];
    [pullDic setObject:[NSNumber numberWithBool:YES] forKey:@"SyncDeviceLinkAllRecordsOfPulledEntityTypeSentKey"];
    [pullDic setObject:[NSArray arrayWithObjects:domain, nil] forKey:@"SyncDeviceLinkEntityNamesKey"];
    [domainKeyArray addObject:pullDic];
    [domainContentArray addObject:pullDic];
    [pullDic release];
    
    
    
    NSArray *retArray = [mobileSync getData:domainKeyArray waitingReply:YES];
    [domainKeyArray release];
    
    retArray = [mobileSync getData:domainContentArray waitingReply:YES];
    [domainContentArray release];
}

- (void)clearMessageFromDevice:(NSString*)domain withPidKey:(NSString*)pidKey {
    NSMutableArray *domainKeyArray = [[NSMutableArray alloc] init];
    [domainKeyArray addObject:@"SDMessageProcessChanges"];
    [domainKeyArray addObject:DOMAIN_COMMON_CONTACT];
    
    NSMutableArray *domainContentArray = [[NSMutableArray alloc] init];
    [domainContentArray addObject:@"SDMessageProcessChanges"];
    [domainContentArray addObject:DOMAIN_COMMON_CONTACT];
    
    NSMutableDictionary *totalDomainDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *totalDomainKeyDic = [[NSMutableDictionary alloc] init];
    
    NSString *preKeyFormat = nil;
    BOOL singleFlag = YES;
    if ([domain isEqualToString:DOMAIN_EMAIL_ADDRESS]) {
        preKeyFormat = @"4/%@/%d";
        singleFlag = YES;
    } else if ([domain isEqualToString:DOMAIN_PHONE_NUMBER]) {
        preKeyFormat = @"3/%@/%d";
        singleFlag = YES;
    } else if ([domain isEqualToString:DOMAIN_STREET_ADDRESS]) {
        preKeyFormat = @"5/%@/%d";
        singleFlag = YES;
    } else if ([domain isEqualToString:DOMAIN_RELATED_NAME]) {
        preKeyFormat = @"23/%@/%d";
        singleFlag = YES;
    } else if ([domain isEqualToString:DOMAIN_IM]) {
        preKeyFormat = @"13/%@/%d";
        singleFlag = YES;
    } else if ([domain isEqualToString:DOMAIN_DATE]) {
        preKeyFormat = @"12/%@/%d";
        singleFlag = NO;
    } else if ([domain isEqualToString:DOMAIN_URL]) {
        preKeyFormat = @"22/%@/%d";
        singleFlag = YES;
    } else {
        [domainKeyArray release];
        [domainContentArray release];
        [totalDomainDic release];
        [totalDomainKeyDic release];
        return;
    }
    
    NSString *preKey = nil;
    for (int i = 0; i < 100; i++) {
        preKey = [NSString stringWithFormat:preKeyFormat, pidKey, i];
        [totalDomainKeyDic setObject:preKey forKey:preKey];
    }
    
    [domainKeyArray addObject:totalDomainKeyDic];
    [domainContentArray addObject:[[[NSDictionary alloc] initWithDictionary:totalDomainDic] autorelease]];
    
    [domainKeyArray addObject:[NSNumber numberWithBool:singleFlag]];
    [domainContentArray addObject:[NSNumber numberWithBool:singleFlag]];
    
    [totalDomainDic release];
    [totalDomainKeyDic release];
    
    NSMutableDictionary *pullDic;
    pullDic = [[NSMutableDictionary alloc] init];
    [pullDic setObject:[NSNumber numberWithBool:YES] forKey:@"SyncDeviceLinkAllRecordsOfPulledEntityTypeSentKey"];
    [pullDic setObject:[NSArray arrayWithObjects:domain, nil] forKey:@"SyncDeviceLinkEntityNamesKey"];
    [domainKeyArray addObject:pullDic];
    [domainContentArray addObject:pullDic];
    [pullDic release];
    
    NSArray *retArray = [mobileSync getData:domainKeyArray waitingReply:YES];
    [domainKeyArray release];
    
    retArray = [mobileSync getData:domainContentArray waitingReply:YES];
    [domainContentArray release];
}

- (NSArray*)prepareDelData:(NSArray*)contactEntityArray {
    NSMutableArray *delArray = [[NSMutableArray alloc] init];
    [delArray addObject:@"SDMessageProcessChanges"];
    [delArray addObject:DOMAIN_COMMON_CONTACT];
    
    NSMutableDictionary *delDetail = [[NSMutableDictionary alloc] init];
    for (IMBContactEntity *contactEntity in contactEntityArray) {
        NSString *cid = [contactEntity.entityID stringValue];
        NSLog(@"=====cid:%@",cid);
        if (cid != nil) {
            [delDetail setValue:@"___EmptyParameterString___" forKey:cid];
        }
    }
    [delArray addObject:delDetail];
    
    [delArray addObject:[NSNumber numberWithBool:YES]];
    
    NSMutableDictionary *pullDic = [[NSMutableDictionary alloc] init];
    [pullDic setObject:[NSNumber numberWithBool:YES] forKey:@"SyncDeviceLinkAllRecordsOfPulledEntityTypeSentKey"];
    [pullDic setObject:[NSArray arrayWithObjects:DOMAIN_CONTACT, @"com.apple.contacts.Group", nil] forKey:@"SyncDeviceLinkEntityNamesKey"];
    [delArray addObject:pullDic];
    [pullDic release];
    
    [delArray autorelease];
    return delArray;
}

#pragma mark - 通过数据库去获取联系人
- (BOOL)getContactSqlite:(NSString*)cacheFilePath {
    BOOL ret = NO;
    AMFileRelay *fileRelay = [deviceHandle newAMFileRelay];
    NSOutputStream *outStream = [[NSOutputStream alloc] initToFileAtPath:cacheFilePath append:YES];
    if ([fileRelay getFileSet:@"UserDatabases" into:outStream]) {
        ret = YES;
    } else {
        ret = NO;
    }
    [outStream release];
    [fileRelay release];
    return ret;
}

// 从备份中或者通过FileRelay取得联系人的数据表
- (void)getContactSqlitePathFileRelay {
    if (_addressBookConnection != nil) {
        [_addressBookConnection release];
        _addressBookConnection = nil;
    }
    if (_addressBookImagesConnection != nil) {
        [_addressBookImagesConnection release];
        _addressBookImagesConnection = nil;
    }
    NSString *appTempFolderPath = [TempHelper getAppTempPath];
    NSString *filePath = [appTempFolderPath stringByAppendingPathComponent:@"UserDataBase.tar"];
    [self getContactSqlite:filePath];
    NSString *decompressionFolder = [appTempFolderPath stringByAppendingPathComponent:@"FileRelay"];
    // 解压压缩包
    if ([fm fileExistsAtPath:decompressionFolder]) {
        [fm removeItemAtPath:decompressionFolder error:nil];
    }
    
    if (![fm fileExistsAtPath:decompressionFolder]) {
        [fm createDirectoryAtPath:decompressionFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [TempHelper unTarFile:filePath unTarPath:nil toDestFolder:decompressionFolder];
    sleep(1);
    if ([fm fileExistsAtPath:filePath]) {
        [fm removeItemAtPath:filePath error:nil];
    }
    
    if ([fm fileExistsAtPath:decompressionFolder]) {
        addressBookFilePath = [decompressionFolder stringByAppendingPathComponent:@"var/mobile/Library/AddressBook/AddressBook.sqlitedb"];
        addressBookImagesFilePath = [decompressionFolder stringByAppendingPathComponent:@"var/mobile/Library/AddressBook/AddressBookImages.sqlitedb"];
        if ([fm fileExistsAtPath:addressBookFilePath]) {
            tmpAddressBookFilePath = addressBookFilePath;
        } else {
            addressBookFilePath = [decompressionFolder stringByAppendingPathComponent:@"private/var/mobile/Library/AddressBook/AddressBook.sqlitedb"];
            if ([fm fileExistsAtPath:addressBookFilePath]) {
                tmpAddressBookFilePath = addressBookFilePath;
            } else {
                tmpAddressBookFilePath = nil;
            }
        }
        
        if ([fm fileExistsAtPath:addressBookImagesFilePath]) {
            tmpAddressBookImagesFilePath = addressBookImagesFilePath;
        } else {
            addressBookImagesFilePath = [decompressionFolder stringByAppendingPathComponent:@"private/var/mobile/Library/AddressBook/AddressBookImages.sqlitedb"];
            if ([fm fileExistsAtPath:addressBookImagesFilePath]) {
                tmpAddressBookImagesFilePath = addressBookImagesFilePath;
            } else {
                tmpAddressBookImagesFilePath = nil;
            }
        }
    }
    
    // todo打开连接之前对Sqlite进行备份,在这里只是对其进行一次合并。
    if ([fm fileExistsAtPath:tmpAddressBookFilePath]) {
        _addressBookConnection = [[FMDatabase databaseWithPath:tmpAddressBookFilePath] retain];
        if ([_addressBookConnection open]) {
            sqlite3_exec([_addressBookConnection sqliteHandle], "pragma journal_mode = WAL", NULL, NULL, NULL);
            [_addressBookConnection close];
        }
        [_addressBookConnection release];
        if ([fm fileExistsAtPath:[tmpAddressBookFilePath stringByAppendingString:@"-shm"]]) {
            [fm removeItemAtPath:[tmpAddressBookFilePath stringByAppendingString:@"-shm"] error:nil];
        }
        if ([fm fileExistsAtPath:[tmpAddressBookFilePath stringByAppendingString:@"-wal"]]) {
            [fm removeItemAtPath:[tmpAddressBookFilePath stringByAppendingString:@"-wal"] error:nil];
        }
    }
    
    if ([fm fileExistsAtPath:tmpAddressBookImagesFilePath]) {
        _addressBookImagesConnection = [[FMDatabase databaseWithPath:tmpAddressBookImagesFilePath] retain];
        if ([_addressBookImagesConnection open]) {
            sqlite3_exec([_addressBookImagesConnection sqliteHandle], "pragma journal_mode = WAL", NULL, NULL, NULL);
            [_addressBookImagesConnection close];
        }
        [_addressBookImagesConnection release];
        if ([fm fileExistsAtPath:[tmpAddressBookImagesFilePath stringByAppendingString:@"-shm"]]) {
            [fm removeItemAtPath:[tmpAddressBookImagesFilePath stringByAppendingString:@"-shm"] error:nil];
        }
        if ([fm fileExistsAtPath:[tmpAddressBookImagesFilePath stringByAppendingString:@"-wal"]]) {
            [fm removeItemAtPath:[tmpAddressBookImagesFilePath stringByAppendingString:@"-wal"] error:nil];
        }
    }
    
    // 打开数据库连接
    if ([fm fileExistsAtPath:tmpAddressBookFilePath]) {
        _addressBookConnection = [[FMDatabase databaseWithPath:tmpAddressBookFilePath] retain];
        if ([_addressBookConnection open]) {
            [_addressBookConnection setShouldCacheStatements:NO];
            [_addressBookConnection setTraceExecution:NO];
        }
    } else {
        _addressBookConnection = nil;
    }
    
    if ([fm fileExistsAtPath:tmpAddressBookImagesFilePath]) {
        _addressBookImagesConnection = [[FMDatabase databaseWithPath:tmpAddressBookImagesFilePath] retain];
        if ([_addressBookImagesConnection open]) {
            [_addressBookImagesConnection setShouldCacheStatements:NO];
            [_addressBookImagesConnection setTraceExecution:NO];
        }
    } else {
        _addressBookImagesConnection = nil;
    }
}

- (FMDatabase *)getAddressBookConnection{
    return _addressBookConnection;
}

- (FMDatabase *)getAddressBookImageConnection{
    return _addressBookImagesConnection;
}

// 从数据库中查询出所有的联系人信息
- (void)queryAllPersionFromSqlite {
    // 查询出所有的联系人记录
    if (_allPersionDicFromSqlite != nil) {
        [_allPersionDicFromSqlite release];
        _allPersionDicFromSqlite = nil;
    }
    if (_allContactArrayFromSqlite != nil){
        [_allContactArrayFromSqlite release];
        _allContactArrayFromSqlite = nil;
    }
    _allPersionDicFromSqlite = [[NSMutableDictionary alloc] init];
    _allContactArrayFromSqlite = [[NSMutableArray alloc]init];
    
    NSString *selectCmd = @"select ROWID from ABPerson;";
    FMResultSet *rs = [_addressBookConnection executeQuery:selectCmd];
    while ([rs next]) {
        IMBContactEntity *entity = [[IMBContactEntity alloc]init];
        int rowid = [rs intForColumn:@"ROWID"];
        entity.contactId = [NSString stringWithFormat:@"%d",rowid];
        entity.entityID = [NSNumber numberWithInteger:rowid];
        NSMutableDictionary *dic = [self queryPersionFromSqliteByContactID:rowid];
        [_allPersionDicFromSqlite setObject:dic forKey:[NSString stringWithFormat:@"%d", rowid]];
        NSMutableDictionary *mutdic = [[NSMutableDictionary alloc]init];
        [mutdic setObject:dic forKey:entity.contactId];
        [entity dicToObject:mutdic];
        [_allContactArrayFromSqlite addObject:entity];
        [entity release];
        [mutdic release];
    }
    [rs close];
    NSLog(@"allContactArray:%lu",(unsigned long)_allContactArrayFromSqlite.count);
}

// 从数据库中查询出所有联系人的基本信息
- (NSMutableDictionary *)queryAllPersionBaseInfoFromSqlite {
    NSMutableDictionary *allPersonDic = [[[NSMutableDictionary alloc] init] autorelease];
    if (_allContactBaseInfoArray) {
        [_allContactBaseInfoArray release];
        _allContactBaseInfoArray = nil;
    }
    _allContactBaseInfoArray = [[NSMutableArray alloc]init];
    // 查询出所有的联系人记录
    NSString *selectCmd = @"select ROWID from ABPerson;";
    FMResultSet *rs = [_addressBookConnection executeQuery:selectCmd];
    while ([rs next]) {
        IMBContactEntity *entity = [[IMBContactEntity alloc]init];
        int rowid = [rs intForColumn:@"ROWID"];
        entity.entityID = [NSNumber numberWithInteger:rowid];
        entity.contactId = [entity.entityID stringValue];
        NSDictionary *dictionay = [self queryContact:rowid];
        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]init];
        [allPersonDic setObject:dictionay forKey:[NSString stringWithFormat:@"%d", rowid]];
        [mutDic setObject:dictionay forKey:[NSNumber numberWithInt:rowid]];
        [entity dicToObject:mutDic];
        [_allContactBaseInfoArray addObject:entity];
        [mutDic release];
        [entity release];
    }
    [rs close];
    return allPersonDic;
}

// 根据联系人ID查询出联系人信息
- (NSMutableDictionary*)queryPersionFromSqliteByContactID:(int)contactID {
    NSMutableDictionary *_singlePersonDic = [self queryContact:contactID];
    
    NSDictionary *params;
    
    // 查询出所有的Lable标签
    //NSMutableArray *labelValueArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *labelValueDic =[[NSMutableDictionary alloc] init];
    NSString *selectCmd = @"select rowid,value from ABMultiValueLabel;";
    FMResultSet *rs = nil;
    rs = [_addressBookConnection executeQuery:selectCmd];
    while ([rs next]) {
        int rowid = [rs intForColumn:@"rowid"];
        NSString *valueStr = [rs stringForColumn:@"value"];
        if (![TempHelper stringIsNilOrEmpty:valueStr]) {
            valueStr = [[[valueStr stringByReplacingOccurrencesOfString:@"_$!<" withString:@""] stringByReplacingOccurrencesOfString:@">!$_" withString:@""] lowercaseString];
            if ([valueStr hasSuffix:@"page"]) {
                NSRange range = [valueStr rangeOfString:@"page"];
                NSMutableString *string=[NSMutableString stringWithString:valueStr];
                [string insertString:@" " atIndex:range.location];
                valueStr = string;
            } else if ([valueStr hasSuffix:@"fax"]) {
                NSRange range = [valueStr rangeOfString:@"fax"];
                NSMutableString *string=[NSMutableString stringWithString:valueStr];
                [string insertString:@" " atIndex:range.location];
                valueStr = string;
            }
            [labelValueDic setObject:valueStr forKey:[NSString stringWithFormat:@"%d", rowid]];
        }
    }
    [rs close];
    
    // 查询出所有的EntryKey
    NSMutableDictionary *entryKeyDic = [[NSMutableDictionary alloc] init];
    selectCmd = @"select rowid,value from ABMultiValueEntryKey;";
    rs = [_addressBookConnection executeQuery:selectCmd];
    while ([rs next]) {
        int rowid = [rs intForColumn:@"rowid"];
        NSString *valueStr = [rs stringForColumn:@"value"];
        if (![TempHelper stringIsNilOrEmpty:valueStr]) {
            valueStr = [valueStr lowercaseString];
            if ([valueStr hasSuffix:@"code"]) {
                NSRange range = [valueStr rangeOfString:@"code"];
                NSMutableString *string=[NSMutableString stringWithString:valueStr];
                [string insertString:@" " atIndex:range.location];
                valueStr = string;
            }
            if ([valueStr isEqualToString:@"zip"]) {
                valueStr = ITEM_POSTAL_CODE_KEY;
            } else if ([valueStr isEqualToString:@"username"]) {
                valueStr = ITEM_USER_KEY;
            }
            [entryKeyDic setObject:valueStr forKey:[NSString stringWithFormat:@"%d", rowid]];
        }
    }
    [rs close];
    
    
    FMResultSet *mvRs = nil;
    NSString *dKeyFomat = @"%d/%d/%d";
    NSString *dKey = nil;
    
    // 查询出该联系人中包含的所有属性
    selectCmd = @"select property from ABMultiValue where record_id=:record_id;";
    params = [NSDictionary dictionaryWithObjectsAndKeys:
              [NSNumber numberWithLongLong:contactID], @"record_id"
              , nil];
    rs = [_addressBookConnection executeQuery:selectCmd withParameterDictionary:params];
    while ([rs next]) {
        int property = [rs intForColumn:@"property"];
        // 查询出所有的属性值中的记录
        selectCmd = @"select UID,identifier,label,value from ABMultiValue where record_id=:record_id and property=:property;";
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  [NSNumber numberWithLongLong:contactID], @"record_id",
                  [NSNumber numberWithInt:property], @"property"
                  , nil];
        
        mvRs = [_addressBookConnection executeQuery:selectCmd withParameterDictionary:params];
        switch (property) {
            case 3:
            {
                // DOMAIN_PHONE_NUMBER
                NSMutableDictionary *phoneNumbersDic = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *phoneNumberDic = nil;
                while ([mvRs next]) {
                    phoneNumberDic = [[NSMutableDictionary alloc] init];
                    int identifier = [mvRs intForColumn:@"identifier"];
                    int label = [mvRs intForColumn:@"label"];
                    NSString *value = [mvRs stringForColumn:@"value"];
                    
                    dKey = [NSString stringWithFormat:dKeyFomat, property, contactID, identifier];
                    [phoneNumberDic setObject:DOMAIN_PHONE_NUMBER forKey:RECORD_ENTITY_NAME];
                    [phoneNumberDic setObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", contactID], nil] forKey:ITEM_CONTACT_KEY];
                    
                    NSString *typeStr = nil;
                    if ([[labelValueDic allKeys] count] >= label) {
                        typeStr = [[labelValueDic objectForKey:[NSString stringWithFormat:@"%d", label]] lowercaseString];
                        if ([typeStr isEqualToString:@"iphone"]) {
                            [phoneNumberDic setObject:@"iPhone" forKey:ITEM_LABEL_KEY];
                            typeStr = @"other";
                        }
                    } else {
                        typeStr = @"other";
                    }
                    [phoneNumberDic setObject:typeStr forKey:ITEM_TYPE_KEY];
                    [phoneNumberDic setObject:value forKey:ITEM_VALUE_KEY];
                    [phoneNumbersDic setObject:phoneNumberDic forKey:dKey];
                    [phoneNumberDic release];
                }
                [_singlePersonDic setValue:phoneNumbersDic forKey:DOMAIN_PHONE_NUMBER];
                [phoneNumbersDic release];
                break;
            }
            case 4:
            {
                // DOMAIN_EMAIL_ADDRESS
                NSMutableDictionary *emailAddressesDic = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *emailAddressDic = nil;
                while ([mvRs next]) {
                    emailAddressDic = [[NSMutableDictionary alloc] init];
                    int identifier = [mvRs intForColumn:@"identifier"];
                    int label = [mvRs intForColumn:@"label"];
                    NSString *value = [mvRs stringForColumn:@"value"];
                    
                    dKey = [NSString stringWithFormat:dKeyFomat, property, contactID, identifier];
                    [emailAddressDic setObject:DOMAIN_EMAIL_ADDRESS forKey:RECORD_ENTITY_NAME];
                    [emailAddressDic setObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", contactID], nil] forKey:ITEM_CONTACT_KEY];
                    
                    NSString *typeStr = nil;
                    if ([[labelValueDic allKeys] count] >= label) {
                        typeStr = [[labelValueDic objectForKey:[NSString stringWithFormat:@"%d", label]] lowercaseString];
                    } else {
                        typeStr = @"other";
                    }
                    [emailAddressDic setObject:typeStr forKey:ITEM_TYPE_KEY];
                    [emailAddressDic setObject:value forKey:ITEM_VALUE_KEY];
                    [emailAddressesDic setObject:emailAddressDic forKey:dKey];
                    [emailAddressDic release];
                }
                [_singlePersonDic setValue:emailAddressesDic forKey:DOMAIN_EMAIL_ADDRESS];
                [emailAddressesDic release];
                break;
            }
            case 5:
            {
                // DOMAIN_STREET_ADDRESS
                NSMutableDictionary *streetAddressesDic = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *streetAddressDic = nil;
                FMResultSet *saRS = nil;
                while ([mvRs next]) {
                    streetAddressDic = [[NSMutableDictionary alloc] init];
                    int uid = [mvRs intForColumn:@"UID"];
                    int identifier = [mvRs intForColumn:@"identifier"];
                    int label = [mvRs intForColumn:@"label"];
                    
                    dKey = [NSString stringWithFormat:dKeyFomat, property, contactID, identifier];
                    [streetAddressDic setObject:DOMAIN_STREET_ADDRESS forKey:RECORD_ENTITY_NAME];
                    [streetAddressDic setObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", contactID], nil] forKey:ITEM_CONTACT_KEY];
                    
                    NSString *typeStr = nil;
                    if ([[labelValueDic allKeys] count] >= label) {
                        typeStr = [[labelValueDic objectForKey:[NSString stringWithFormat:@"%d", label]] lowercaseString];
                    } else {
                        typeStr = @"other";
                    }
                    [streetAddressDic setObject:typeStr forKey:ITEM_TYPE_KEY];
                    
                    // 根据uid查询出对应的值对象
                    selectCmd = @"select key,value from ABMultiValueEntry where parent_id=:parent_id";
                    params = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithLongLong:uid], @"parent_id"
                              , nil];
                    saRS = [_addressBookConnection executeQuery:selectCmd withParameterDictionary:params];
                    while ([saRS next]) {
                        int keyInt = [saRS intForColumn:@"key"];
                        NSString *value = [saRS stringForColumn:@"value"];
                        if ([[entryKeyDic allKeys] count] >= keyInt) {
                            NSString *keyStr = [entryKeyDic objectForKey:[NSString stringWithFormat:@"%d", keyInt]];
                            [streetAddressDic setObject:value forKey:keyStr];
                        }
                    }
                    [saRS close];
                    [streetAddressesDic setObject:streetAddressDic forKey:dKey];
                    [streetAddressDic release];
                }
                [_singlePersonDic setValue:streetAddressesDic forKey:DOMAIN_STREET_ADDRESS];
                [streetAddressesDic release];
                break;
            }
            case 12:
            {
                // DOMAIN_DATE
                NSMutableDictionary *datesDic = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *dateDic = nil;
                while ([mvRs next]) {
                    dateDic = [[NSMutableDictionary alloc] init];
                    int identifier = [mvRs intForColumn:@"identifier"];
                    int label = [mvRs intForColumn:@"label"];
                    NSString *value = [mvRs stringForColumn:@"value"];
                    
                    dKey = [NSString stringWithFormat:dKeyFomat, property, contactID, identifier];
                    [dateDic setObject:DOMAIN_DATE forKey:RECORD_ENTITY_NAME];
                    [dateDic setObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", contactID], nil] forKey:ITEM_CONTACT_KEY];
                    
                    NSString *typeStr = nil;
                    if ([[labelValueDic allKeys] count] >= label) {
                        typeStr = [[labelValueDic objectForKey:[NSString stringWithFormat:@"%d", label]] lowercaseString];
                    } else {
                        typeStr = @"other";
                    }
                    [dateDic setObject:typeStr forKey:ITEM_TYPE_KEY];
                    
                    if (![TempHelper stringIsNilOrEmpty:value]) {
                        int valueInt = [value intValue];
                        NSDate *valueDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:valueInt];
                        [dateDic setObject:valueDate forKey:ITEM_VALUE_KEY];
                        /*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSString *valueDateStr = [dateFormatter stringFromDate:valueDate];
                        [dateDic setObject:valueDateStr forKey:ITEM_VALUE_KEY];
                        [dateFormatter release];*/
                    }
                    
                    [datesDic setObject:dateDic forKey:dKey];
                    [dateDic release];
                }
                [_singlePersonDic setValue:datesDic forKey:DOMAIN_DATE];
                [datesDic release];
                break;
            }
            case 13:
            {
                // DOMAIN_IM
                NSMutableDictionary *imesDic = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *imDic = nil;
                FMResultSet *imRS = nil;
                while ([mvRs next]) {
                    imDic = [[NSMutableDictionary alloc] init];
                    int uid = [mvRs intForColumn:@"UID"];
                    int identifier = [mvRs intForColumn:@"identifier"];
                    int label = [mvRs intForColumn:@"label"];
                    
                    dKey = [NSString stringWithFormat:dKeyFomat, property, contactID, identifier];
                    [imDic setObject:DOMAIN_IM forKey:RECORD_ENTITY_NAME];
                    [imDic setObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", contactID], nil] forKey:ITEM_CONTACT_KEY];
                    
                    NSString *typeStr = nil;
                    if ([[labelValueDic allKeys] count] >= label) {
                        typeStr = [[labelValueDic objectForKey:[NSString stringWithFormat:@"%d", label]] lowercaseString];
                    } else {
                        typeStr = @"other";
                    }
                    [imDic setObject:typeStr forKey:ITEM_TYPE_KEY];
                    
                    // 根据uid查询出对应的值对象
                    selectCmd = @"select key,value from ABMultiValueEntry where parent_id=:parent_id";
                    params = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithLongLong:uid], @"parent_id"
                              , nil];
                    imRS = [_addressBookConnection executeQuery:selectCmd withParameterDictionary:params];
                    while ([imRS next]) {
                        int keyInt = [imRS intForColumn:@"key"];
                        NSString *value = [imRS stringForColumn:@"value"];
                        if ([[entryKeyDic allKeys] count] >= keyInt) {
                            NSString *keyStr = [entryKeyDic objectForKey:[NSString stringWithFormat:@"%d", keyInt]];
                            [imDic setObject:value forKey:keyStr];
                        }
                    }
                    [imRS close];
                    [imesDic setObject:imDic forKey:dKey];
                    [imDic release];
                }
                [_singlePersonDic setValue:imesDic forKey:DOMAIN_IM];
                [imesDic release];
                break;
            }
            case 22: {
                // com.apple.contacts.URL
                NSMutableDictionary *urlsDic = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *urlDic = nil;
                while ([mvRs next]) {
                    urlDic = [[NSMutableDictionary alloc] init];
                    int identifier = [mvRs intForColumn:@"identifier"];
                    int label = [mvRs intForColumn:@"label"];
                    NSString *value = [mvRs stringForColumn:@"value"];
                    
                    dKey = [NSString stringWithFormat:dKeyFomat, property, contactID, identifier];
                    [urlDic setObject:DOMAIN_URL forKey:RECORD_ENTITY_NAME];
                    [urlDic setObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", contactID], nil] forKey:ITEM_CONTACT_KEY];
                    
                    NSString *typeStr = nil;
                    if ([[labelValueDic allKeys] count] >= label) {
                        typeStr = [[labelValueDic objectForKey:[NSString stringWithFormat:@"%d", label]] lowercaseString];
                    } else {
                        typeStr = @"other";
                    }
                    [urlDic setObject:typeStr forKey:ITEM_TYPE_KEY];
                    [urlDic setObject:value forKey:ITEM_VALUE_KEY];
                    
                    [urlsDic setObject:urlDic forKey:dKey];
                    [urlDic release];
                }
                [_singlePersonDic setValue:urlsDic forKey:DOMAIN_URL];
                [urlsDic release];
                break;
            }
            case 23:
            {
                // DOMAIN_RELATED_NAME
                NSMutableDictionary *relatedNamesDic = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *relatedNameDic = nil;
                while ([mvRs next]) {
                    relatedNameDic = [[NSMutableDictionary alloc] init];
                    int identifier = [mvRs intForColumn:@"identifier"];
                    int label = [mvRs intForColumn:@"label"];
                    NSString *value = [mvRs stringForColumn:@"value"];
                    
                    dKey = [NSString stringWithFormat:dKeyFomat, property, contactID, identifier];
                    [relatedNameDic setObject:DOMAIN_RELATED_NAME forKey:RECORD_ENTITY_NAME];
                    [relatedNameDic setObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", contactID], nil] forKey:ITEM_CONTACT_KEY];
                    
                    NSString *typeStr = nil;
                    if ([[labelValueDic allKeys] count] >= label) {
                        typeStr = [[labelValueDic objectForKey:[NSString stringWithFormat:@"%d", label]] lowercaseString];
                    } else {
                        typeStr = @"other";
                    }
                    [relatedNameDic setObject:typeStr forKey:ITEM_TYPE_KEY];
                    [relatedNameDic setObject:value forKey:ITEM_VALUE_KEY];
                    
                    [relatedNamesDic setObject:relatedNameDic forKey:dKey];
                    [relatedNameDic release];
                }
                [_singlePersonDic setValue:relatedNamesDic forKey:DOMAIN_RELATED_NAME];
                [relatedNamesDic release];
                break;
            }
            case 44:
            {
                NSMutableDictionary *urlsDic = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *urlDic = nil;
                FMResultSet *rnRS = nil;
                while ([mvRs next]) {
                    urlDic = [[NSMutableDictionary alloc] init];
                    int uid = [mvRs intForColumn:@"UID"];
                    int identifier = [mvRs intForColumn:@"identifier"];
                    int label = [mvRs intForColumn:@"label"];
                    
                    dKey = [NSString stringWithFormat:dKeyFomat, property, contactID, identifier];
                    [urlDic setObject:DOMAIN_URL forKey:RECORD_ENTITY_NAME];
                    [urlDic setObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", contactID], nil] forKey:ITEM_CONTACT_KEY];
                    
                    NSString *typeStr = nil;
                    if ([[labelValueDic allKeys] count] >= label) {
                        typeStr = [[labelValueDic objectForKey:[NSString stringWithFormat:@"%d", label]] lowercaseString];
                    } else {
                        typeStr = @"other";
                    }
                    [urlDic setObject:typeStr forKey:ITEM_TYPE_KEY];
                    
                    // 根据uid查询出对应的值对象
                    selectCmd = @"select key,value from ABMultiValueEntry where parent_id=:parent_id";
                    params = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithLongLong:uid], @"parent_id"
                              , nil];
                    rnRS = [_addressBookConnection executeQuery:selectCmd withParameterDictionary:params];
                    while ([rnRS next]) {
                        int keyInt = [rnRS intForColumn:@"key"];
                        NSString *value = [rnRS stringForColumn:@"value"];
                        if ([[entryKeyDic allKeys] count] >= keyInt) {
                            NSString *keyStr = [entryKeyDic objectForKey:[NSString stringWithFormat:@"%d", keyInt]];
                            [urlDic setObject:value forKey:keyStr];
                        }
                    }
                    [rnRS close];
                    [urlsDic setObject:urlDic forKey:dKey];
                    [urlDic release];
                }
                [_singlePersonDic setValue:urlsDic forKey:DOMAIN_URL];
                [urlsDic release];
                break;
            }
            default:
                break;
        }
        [mvRs close];
    }
    [rs close];
    
    [labelValueDic release];
    [entryKeyDic release];
    
    return _singlePersonDic;
}

- (void)exportToContacts:(NSArray *)contactArray
{
    NSArray *array = [NSArray arrayWithArray:contactArray];
    
    int totalItem = (int)[array count];
    int successNum = 0;
    BOOL isOutOfCount = NO;//[IMBHelper determinWhetherIsOutOfTransferCount];
    if (!isOutOfCount) {
        
//        [nc postNotificationName:COPYINGNOTIFICATION object:[NSNumber numberWithInt:FileTypeIcon]];
//        [nc postNotificationName:NOTIFY_TRANSCATEGORY object:CustomLocalizedString(@"Export_id_5", nil) userInfo:nil];
        for (int i = 0;i<totalItem;i++) {
            //基本数据类型
            if (_threadBreak == YES) {
                break;
            }

            IMBContactEntity *contact = [array objectAtIndex:i];
            NSString *fileName = [NSString stringWithFormat:@"%@%@",contact.lastName,contact.firstName];
//            int currItemIndex = i+1;
//            BOOL IsNeedAnimation = YES;
//            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                         fileName,@"Message",
//                                         [NSNumber numberWithInt:currItemIndex], @"CurItemIndex",
//                                         [NSNumber numberWithBool:IsNeedAnimation],@"IsNeedAnimation",
//                                         [NSNumber numberWithInt:totalItem], @"TotalItemCount",
//                                         nil];
//            [nc postNotificationName:NOTIFY_CURRENT_MESSAGE object:fileName];
//            [nc postNotificationName:NOTIFY_TRANSCOUNTPROGRESS object:@"MSG_COM_Total_Progress" userInfo:info];

            ABPerson *person = [[ABPerson alloc] init];
        
            if (contact.firstName != nil) {
                [person setValue:contact.firstName forProperty:kABFirstNameProperty];
            }
            if (contact.middleName != nil) {
                [person setValue:contact.middleName forProperty:kABMiddleNameProperty];
            }
            if (contact.lastName != nil) {
                [person setValue:contact.lastName forProperty:kABLastNameProperty];
            }
            if (contact.firstNameYomi != nil) {
                [person setValue:contact.firstNameYomi forProperty:kABFirstNamePhoneticProperty];
            }
            if (contact.lastNameYomi != nil) {
                [person setValue:contact.lastNameYomi forProperty:kABLastNamePhoneticProperty];
            }
            if (contact.birthday != nil) {
                [person setValue:contact.birthday forProperty:kABBirthdayProperty];
            }
            if (contact.jobTitle != nil) {
                [person setValue:contact.jobTitle forProperty:kABJobTitleProperty];
            }
            if (contact.nickname != nil) {
                [person setValue:contact.nickname forProperty:kABNicknameProperty];
            }
            if (contact.title != nil) {
                [person setValue:contact.title forProperty:kABTitleProperty];
            }
            if (contact.suffix != nil) {
                [person setValue:contact.suffix forProperty:kABSuffixProperty];
            }
            if (contact.notes != nil) {
                [person setValue:contact.notes forProperty:kABNoteProperty];
            }
            if (contact.companyName != nil) {
                [person setValue:contact.companyName forProperty:kABOrganizationProperty];
            }
            if (contact.department != nil) {
                [person setValue:contact.department forProperty:kABDepartmentProperty];
            }
            ABMutableMultiValue *phone = [[ABMutableMultiValue alloc] init];
            //其他数据phoneNumber
            for (IMBContactKeyValueEntity *phoneNumber in contact.phoneNumberArray) {
                
                if (phoneNumber.label != nil) {
                    
                    [phone addValue:phoneNumber.value?phoneNumber.value:@"" withLabel:phoneNumber.label];
                }else
                {
                    [phone addValue:phoneNumber.value?phoneNumber.value:@"" withLabel:phoneNumber.type];
                }
                
            }
            
            if (phone.count>0) {
                [person setValue:phone forProperty:kABPhoneProperty];
            }
            [phone release];
            ////email
            ABMutableMultiValue *memail = [[ABMutableMultiValue alloc] init];
            for (IMBContactKeyValueEntity *email in contact.emailAddressArray) {
                
                if (email.label != nil) {
                    
                    [memail addValue:email.value?email.value:@"" withLabel:email.label];
                }else
                {
                    [memail addValue:email.value?email.value:@"" withLabel:email.type];
                }
                
            }
            if (memail.count>0) {
                [person setValue:memail forProperty:kABEmailProperty];
            }
            [memail release];
            //related
            ABMutableMultiValue *mrelated = [[ABMutableMultiValue alloc] init];
            for (IMBContactKeyValueEntity *relate in contact.relatedNameArray) {
                
                if (relate.label != nil) {
                    
                    [mrelated addValue:relate.value?relate.value:@"" withLabel:relate.label];
                }else
                {
                    [mrelated addValue:relate.value?relate.value:@"" withLabel:relate.type];
                }
                
            }
            if (mrelated.count>0) {
                [person setValue:mrelated forProperty:kABRelatedNamesProperty];
            }
            [mrelated release];
            //url
            ABMutableMultiValue *murl = [[ABMutableMultiValue alloc] init];
            for (IMBContactKeyValueEntity *url in contact.urlArray) {
                
                if (url.label != nil) {
                    
                    [murl addValue:url.value?url.value:@"" withLabel:url.label];
                }else
                {
                    [murl addValue:url.value?url.value:@"" withLabel:url.type];
                }
                
            }
            if (murl.count>0) {
                [person setValue:murl forProperty:kABURLsProperty];
            }
            [murl release];
            //date
            ABMutableMultiValue *mdate = [[ABMutableMultiValue alloc] init];
            for (IMBContactKeyValueEntity *date in contact.dateArray) {
                
                if (date.label != nil) {
                    
                    [mdate addValue:date.value?date.value:@"" withLabel:date.label];
                }else
                {
                    [mdate addValue:date.value?date.value:@"" withLabel:date.type];
                }
                
            }
            if (mdate.count>0) {
                [person setValue:mdate forProperty:kABOtherDatesProperty];
            }
            [mdate release];
            //address
            ABMutableMultiValue *contactValue = [[ABMutableMultiValue alloc] init];
            for (IMBContactAddressEntity *addressEntity in contact.addressArray) {
                NSMutableDictionary *address = [[NSMutableDictionary alloc] initWithCapacity:0];
                if (addressEntity.street != nil) {
                    [address setObject:addressEntity.street forKey:kABAddressStreetKey];
                }
                if (addressEntity.city != nil) {
                    [address setObject:addressEntity.city forKey:kABAddressCityKey];
                }
                if (addressEntity.state != nil) {
                    [address setObject:addressEntity.state forKey:kABAddressStateKey];
                }
                if (addressEntity.postalCode != nil) {
                    [address setObject:addressEntity.postalCode forKey:kABAddressZIPKey];
                }
                if (addressEntity.country != nil) {
                    [address setObject:addressEntity.country forKey:kABAddressCountryKey];
                }
                
                if (addressEntity.label != nil) {
                    [contactValue addValue:address withLabel:addressEntity.label];
                    [address release];
                }else
                {
                    [contactValue addValue:address withLabel:addressEntity.type];
                    [address release];
                }
            }
            if ([contactValue count]>0) {
                [person setValue:contactValue forKey:kABAddressProperty];
            }
            [contactValue release];
            //IM
            ABMutableMultiValue *imValue = [[ABMutableMultiValue alloc] init];
            for (IMBContactIMEntity *imEntity in contact.IMArray) {
                NSMutableDictionary *im = [[NSMutableDictionary alloc] initWithCapacity:0];
                if (imEntity.user != nil) {
                    [im setObject:imEntity.user forKey:kABInstantMessageUsernameKey];
                }
                if (imEntity.service != nil) {
                    [im setObject:imEntity.service forKey:kABInstantMessageServiceKey];
                }
                if (imEntity.label != nil) {
                    [imValue addValue:im withLabel:imEntity.label];
                    
                }else
                {
                    [imValue addValue:im withLabel:imEntity.type];
                }
                [im release];
            }
            if (imValue.count>0) {
                [person setValue:imValue forKey:kABInstantMessageProperty];
            }
            [imValue release];
            if ( [[ABAddressBook sharedAddressBook] addRecord:person]) {
                if ([[ABAddressBook sharedAddressBook] save]) {
                    
                    [_transResult setMediaSuccessCount:([_transResult mediaSuccessCount] + 1)];
                    [_transResult recordMediaResult:fileName resultStatus:TransSuccess messageID:@"MSG_PlaylistResult_Success"];
                    _progressCounter.prepareAnalysisSuccessCount++;
                    successNum++;
//                    BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//                    if (isOutOfCount) {
//                        break;
//                    }

                    
                }
            }
           
            
            
        }
//        if (_softWareInfo != nil && _softWareInfo.isNeedRegister&&_softWareInfo.isRegistered == false) {
//            [_softWareInfo addLimitCount:_transResult.mediaSuccessCount];
//        }
        sleep(2);
//        NSDictionary *infor = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:successNum],@"successNum",[NSNumber numberWithInt:FileResultTypeIcon],@"transferType", nil];
//        [nc postNotificationName:NOTIFY_TRANSCOMPLETE object:CustomLocalizedString(@"MSG_COM_Transfer_Completed", nil) userInfo:infor];

    
    }

    
}

- (void)importContactVCF:(NSArray *)importPathArray
{
    //解析文件
    NSFileManager *manager = [NSFileManager defaultManager];
    NSMutableArray *contactsArray = [NSMutableArray array];
    for (NSURL *url in importPathArray) {
        NSString *path = [url path];
        NSData *data = [manager contentsAtPath:path];
        NSString *vcfStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSMutableArray *contactArray = [self parseVCF:vcfStr];
        [contactsArray addObjectsFromArray:contactArray];
        [vcfStr release];
    }
   
//    int totalItem = (int)[contactsArray count];
    int successNum = 0;
    BOOL isOutOfCount = NO;//[IMBHelper determinWhetherIsOutOfTransferCount];
    if (!isOutOfCount) {
//        [nc postNotificationName:COPYINGNOTIFICATION object:[NSNumber numberWithInt:FileTypeIcon]];
//        [nc postNotificationName:NOTIFY_TRANSCATEGORY object:CustomLocalizedString(@"Import_id_1", nil) userInfo:nil];
        for (int i=0;i<[contactsArray count];i++) {
            if (_threadBreak == YES) {
                break;
            }
            [self openMobileSync];
            IMBContactEntity *contact = [contactsArray objectAtIndex:i];
            NSString *fileName = contact.fullName;
//            int currItemIndex = i+1;
//            BOOL IsNeedAnimation = YES;
//            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                         fileName,@"Message",
//                                         [NSNumber numberWithInt:currItemIndex], @"CurItemIndex",
//                                         [NSNumber numberWithBool:IsNeedAnimation],@"IsNeedAnimation",
//                                         [NSNumber numberWithInt:totalItem], @"TotalItemCount",
//                                         nil];
//            [nc postNotificationName:NOTIFY_CURRENT_MESSAGE object:fileName];
//            [nc postNotificationName:NOTIFY_TRANSCOUNTPROGRESS object:@"MSG_COM_Total_Progress" userInfo:info];
            BOOL success = [self modifyContact:contact];
            if (success) {
                 successNum++;
                [_transResult setMediaSuccessCount:([_transResult mediaSuccessCount] + 1)];
                [_transResult recordMediaResult:fileName resultStatus:TransSuccess messageID:@"MSG_PlaylistResult_Success"];
                _progressCounter.prepareAnalysisSuccessCount++;
            }
//            BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//            if (isOutOfCount) {
//                break;
//            }
            [self closeMobileSync];
            

        }
        sleep(1);
//        NSDictionary *infor = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:successNum],@"successNum",[NSNumber numberWithInt:FileResultTypeIcon],@"transferType", nil];
//        [nc postNotificationName:NOTIFY_TRANSCOMPLETE object:CustomLocalizedString(@"MSG_COM_Transfer_Completed", nil) userInfo:infor];
   
    }
   
}

/*
 N: Last Name;FirstName;MiddleName;Prefix;Suffix;
 FN: fullName;
 NICKNAME:nickname
 X-PHONETIC-FIRST-NAME:phoneticFistName
 X-PHONETIC-LAST-NAME:phoneticlastName
 X-PHONETIC-MIDDLE-NAME:phoneticMiddleName
 ORG:companyName;department
 TITLE:job title
 NOTE:note
 BADY:birthday
 ADR:;;street;city;province;postal code;country
 IMPP;X-SERVICE-TYPE=MSN;type=HOME;type=pref:msnim:15665666
 IMPP;X-SERVICE-TYPE=QQ;type=WORK:x-apple:673651520
 自定义impp
 */
//解析
- (NSMutableArray *)parseVCF:(NSString *)vcgString
{
    NSArray *lines = [vcgString componentsSeparatedByString:@"\n"];
    NSMutableArray *contactArray = [NSMutableArray array];
    IMBContactEntity *entity = nil;
    int a1=0; //地址
    int b1=0;//电话
    int c1=0;//email
    int d1=0;//url
    int e1=0;//related
    int f1=0;//date
    int g1=0; //IMP
    for(int i = 0;i<[lines count];i++)
    {
        NSString *line = [lines objectAtIndex:i];
        
        if ([line hasPrefix:@"BEGIN:"]) {
            entity = [[IMBContactEntity alloc] init];
        }else if ([line hasPrefix:@"N:"]||[line hasPrefix:@"N;"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            if ([upperComponents count]>=2) {
                NSArray *names = [[upperComponents objectAtIndex:1] componentsSeparatedByString:@";"];
                for (int i = 0;i<[names count];i++) {
                    
                    if (i==0) {
                        NSString *name = [names objectAtIndex:i];
                        NSString *aname = [name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        [entity setLastName:[aname stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==1)
                    {
                        NSString *name = [names objectAtIndex:i];
                        NSString *aname = [name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        [entity setFirstName:[aname stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==2)
                    {
                        NSString *name = [names objectAtIndex:i];
                        NSString *aname = [name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        [entity setMiddleName:[aname stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==3)
                    {
                        NSString *name = [names objectAtIndex:i];
                        NSString *aname = [name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        [entity setTitle:[aname stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==4)
                    {
                        NSString *name = [names objectAtIndex:i];
                        NSString *aname = [name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];

                        [entity setSuffix:[aname stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }
                    
                }
                
            }
        }else if ([line hasPrefix:@"FN"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setFullName:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
            
        }
        else if ([line hasPrefix:@"NOTE"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setNotes:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
            
            
        }else if ([line hasPrefix:@"ORG"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            if ([upperComponents count]>=2) {
                NSArray *companys = [[upperComponents objectAtIndex:1] componentsSeparatedByString:@";"];
                for (int i = 0;i<[companys count];i++) {
                    
                    if (i==0) {
                        [entity setCompanyName:[[companys objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==1)
                    {
                        [entity setDepartment:[[companys objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }
                }
                
            }
        }else if ([line hasPrefix:@"BDAY:"])//基本数据
        {
            //取数组最后一个为birthday
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            id birthday = [upperComponents lastObject];
            if ([birthday isKindOfClass:[NSString class]]) {
                //将birthday转换成NSDate
                birthday = [birthday stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *date = [formatter dateFromString:birthday];
                [entity setBirthday:date];
            }
        }else if ([line hasPrefix:@"TITLE:"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setJobTitle:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        }else if ([line hasPrefix:@"NICKNAME:"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setNickname:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        }else if ([line hasPrefix:@"X-PHONETIC-FIRST-NAME:"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setFirstNameYomi:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        }else if ([line hasPrefix:@"X-PHONETIC-LAST-NAME:"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setLastNameYomi:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        }else if ([line hasPrefix:@"ADR"])//地址 没有自定义 label为空
        {
            IMBContactAddressEntity *addressEntity = [[IMBContactAddressEntity alloc] init];
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            if ([upperComponents count]>=2) {
                
                NSArray *typeArray = [[upperComponents objectAtIndex:0] componentsSeparatedByString:@";"];
                if ([typeArray count]==0) {
                    [addressEntity setType:@"other"];
                }
                for (int i = 0;i< [typeArray count];i++) {
                    if (i == 1) {
                        NSArray *arr = [[typeArray objectAtIndex:i] componentsSeparatedByString:@"="];
                        if ([arr count]>=2) {
                            [addressEntity setType:((NSString *)[arr lastObject]).lowercaseString];
                        }else
                        {
                            [addressEntity setType:@"other"];
                        }
                    }
                }
                
                
                NSArray *addressArray = [[upperComponents objectAtIndex:1] componentsSeparatedByString:@";"];
                for (int i = 0;i<[addressArray count];i++) {
                    
                    if (i==2) {
                        [addressEntity setStreet:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==3)
                    {
                        [addressEntity setCity:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==4)
                    {
                        [addressEntity setState:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==5)
                    {
                        [addressEntity setPostalCode:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==6)
                    {
                        [addressEntity setCountry:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }
                }
                [addressEntity setEntityID:[NSNumber numberWithInt:a1]];
                a1++;
                [addressEntity setContactCategory:Contact_StreetAddress];
                [entity.addressArray addObject:addressEntity];
                [addressEntity release];
                
            }
            
            
        }else if ([line hasPrefix:@"IMPP;"])//IM 没有自定义
        {
            IMBContactIMEntity *imentity = [[IMBContactIMEntity alloc] init];
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [imentity setUser:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
            if ([upperComponents count]>0) {
                NSString *str = [upperComponents objectAtIndex:0];
                NSArray *arr = [str componentsSeparatedByString:@";"];
                for (int i=0;i<[arr count];i++) {
                    NSString *subStr = nil;
                    if (i==1) {
                        subStr = [arr objectAtIndex:i];
                        NSArray *subArray = [subStr componentsSeparatedByString:@"="];
                        [imentity setService:[subArray lastObject]];
                    }else if (i==2)
                    {
                        subStr = [arr objectAtIndex:i];
                        NSArray *subArray = [subStr componentsSeparatedByString:@"="];
                        [imentity setType:((NSString *)[subArray lastObject]).lowercaseString];
                    }
                }
            }
            [imentity setContactCategory:Contact_IM];
            [imentity setEntityID:[NSNumber numberWithInt:g1]];
            g1++;
            [entity.IMArray addObject:imentity];
            [imentity release];
            
        }else if([line hasPrefix:@"URL;"])//url 没有自定义
        {
            IMBContactKeyValueEntity *urlEntity = [[IMBContactKeyValueEntity alloc] init];
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [urlEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
            if ([upperComponents count]>=1) {
                NSString *str = [upperComponents objectAtIndex:0];
                NSArray *arr = [str componentsSeparatedByString:@";"];
                for (int i=0;i<[arr count];i++) {
                    NSString *subStr = nil;
                    if (i==1) {
                        subStr = [arr objectAtIndex:i];
                        NSArray *subArray = [subStr componentsSeparatedByString:@"="];
                        [urlEntity setType:((NSString *)[subArray lastObject]).lowercaseString];
                    }
                }
                
            }
            [urlEntity setEntityID:[NSNumber numberWithInt:d1]];
            d1++;
            [urlEntity setContactCategory:Contact_URL];
            [entity.urlArray addObject:urlEntity];
            [urlEntity release];
            
        }else if ([line hasPrefix:@"TEL;"])
        {
            IMBContactKeyValueEntity *telEntity = [[IMBContactKeyValueEntity alloc] init];
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [telEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];

            if ([upperComponents count]>=1) {
                NSString *str = [upperComponents objectAtIndex:0];
                NSArray *arr = [str componentsSeparatedByString:@";"];
                for (int i=0;i<[arr count];i++) {
                    NSString *subStr = nil;
                    if (i==1) {
                        subStr = [arr objectAtIndex:i];
                        NSArray *subArray = [subStr componentsSeparatedByString:@"="];
                        NSString *type = [subArray lastObject];
                        if ([type isEqualToString:@"CELL"]||[type isEqualToString:@"IPHONE"]) {
                            [telEntity setType:@"mobile"];
                        }else
                        {
                            [telEntity setType:((NSString *)[subArray lastObject]).lowercaseString];
                        }
                        
                    }
                }
                
            }
            [telEntity setEntityID:[NSNumber numberWithInt:b1]];
            b1++;
            [telEntity setContactCategory:Contact_PhoneNumber];
            [entity.phoneNumberArray addObject:telEntity];
            [telEntity release];
            
        }else if ([line hasPrefix:@"EMAIL;"])
        {
            IMBContactKeyValueEntity *emailEntity = [[IMBContactKeyValueEntity alloc] init];
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [emailEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];

            if ([upperComponents count]>=1) {
                NSString *str = [upperComponents objectAtIndex:0];
                NSArray *arr = [str componentsSeparatedByString:@";"];
                for (int i=0;i<[arr count];i++) {
                    NSString *subStr = nil;
                    if (i==2) {
                        subStr = [arr objectAtIndex:i];
                        NSArray *subArray = [subStr componentsSeparatedByString:@"="];
                        [emailEntity setType:((NSString *)[subArray lastObject]).lowercaseString];
                    }
                }
                
            }
            [emailEntity setContactCategory:Contact_EmailAddressNumber];
            [emailEntity setEntityID:[NSNumber numberWithInt:c1]];
            c1++;
            [entity.emailAddressArray addObject:emailEntity];
            [emailEntity release];
        }
        else if ([line hasPrefix:@"item"])
        {
            //地址
            NSString *adrReg = @"item\\w+.ADR:*";
            //电话
            NSString *phoneReg = @"item\\w+.TEL:*";
            //email
            NSString *emailReg = @"item\\w+.EMAIL:*";
            //url
            NSString *urlReg = @"item\\w+.URL:*";
            //related
            NSString *relatedReg = @"item\\w+.X-ABRELATEDNAMES:*";
            //date
            NSString *dateReg = @"item\\w+.X-ABDATE:*";
            //IMPP
            NSString *imppReg = @"item\\w+.IMPP:*";
            //date
           
            if ([line isMatchedByRegex:adrReg]) {
                IMBContactAddressEntity *addressEntity = [[IMBContactAddressEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                if ([upperComponents count]>=2) {
                    
                    NSArray *addressArray = [[upperComponents objectAtIndex:1] componentsSeparatedByString:@";"];
                    for (int i = 0;i<[addressArray count];i++) {
                        
                        if (i==2) {
                            [addressEntity setStreet:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                        }else if (i==3)
                        {
                            [addressEntity setCity:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                        }else if (i==4)
                        {
                            [addressEntity setState:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                        }else if (i==5)
                        {
                            [addressEntity setPostalCode:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                        }else if (i==6)
                        {
                            [addressEntity setCountry:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                        }
                    }
                    
                    
                }
                addressEntity.type = @"other";
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [addressEntity setLabel:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];

                    i++;
                }
                [addressEntity setContactCategory:Contact_StreetAddress];
                [addressEntity setEntityID:[NSNumber numberWithInt:a1]];
                a1++;
                [entity.addressArray addObject:addressEntity];
                
            }else if ([line isMatchedByRegex:phoneReg])
            {
                IMBContactKeyValueEntity *phoneEntity = [[IMBContactKeyValueEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                [phoneEntity setValue:[[upperComponents lastObject]stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [phoneEntity setLabel:[[arr lastObject]stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    i++;
                }
                [phoneEntity setType:@"other"];
                [phoneEntity setEntityID:[NSNumber numberWithInt:b1]];
                b1++;
                [phoneEntity setContactCategory:Contact_PhoneNumber];
                [entity.phoneNumberArray addObject:phoneEntity];
                [phoneEntity release];
                
            }else if ([line isMatchedByRegex:emailReg])
            {
                IMBContactKeyValueEntity *emailEntity = [[IMBContactKeyValueEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                [emailEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [emailEntity setLabel:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    i++;
                }
                [emailEntity setType:@"other"];
                [emailEntity setEntityID:[NSNumber numberWithInt:c1]];
                c1++;
                [emailEntity setContactCategory:Contact_EmailAddressNumber];
                [entity.emailAddressArray addObject:emailEntity];
                [emailEntity release];
                
            }else if ([line isMatchedByRegex:urlReg])
            {
                IMBContactKeyValueEntity *urlEntity = [[IMBContactKeyValueEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                [urlEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [urlEntity setLabel:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    i++;
                }
                [urlEntity setType:@"other"];
                [urlEntity setEntityID:[NSNumber numberWithInt:d1]];
                d1++;
                [urlEntity setContactCategory:Contact_URL];
                [entity.urlArray addObject:urlEntity];
                [urlEntity release];
                
            }else if ([line isMatchedByRegex:relatedReg])
            {
                //item17.X-ABRELATEDNAMES;type=pref:sister
                //item17.X-ABLabel:_$!<Sister>!$_
                IMBContactKeyValueEntity *relatedEntity = [[IMBContactKeyValueEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                [relatedEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [relatedEntity setLabel:[self getValueInangle:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]]];
                    i++;
                }
                [relatedEntity setType:@"other"];
                [relatedEntity setEntityID:[NSNumber numberWithInt:e1]];
                e1++;
                [relatedEntity setContactCategory:Contact_RelatedName];
                [entity.relatedNameArray addObject:relatedEntity];
                [relatedEntity release];
                
            }else if ([line isMatchedByRegex:dateReg])
            {
                //item5.X-ABDATE;X-APPLE-OMIT-YEAR=1604;type=pref:1604-11-17
                //item5.X-ABLabel:_$!<Other>!$_
                IMBContactKeyValueEntity *dateEntity = [[IMBContactKeyValueEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                NSString *strDate = [[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *date = [formatter dateFromString:strDate];
                [dateEntity setValue:date];
                [formatter release];
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [dateEntity setLabel:[self getValueInangle:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]]];

                    i++;
                }
                [dateEntity setType:@"other"];
                [dateEntity setEntityID:[NSNumber numberWithInt:f1]];
                f1++;
                [dateEntity setContactCategory:Contact_Date];
                [entity.dateArray addObject:dateEntity];
                [dateEntity release];
            }else if ([line isMatchedByRegex:imppReg])
            {
                //item15.IMPP;X-SERVICE-TYPE=AIM:aim:15665666
                //item15.X-ABLabel:luoluo
                IMBContactIMEntity *imEntity = [[IMBContactIMEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                [imEntity setUser:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];                if ([upperComponents count]>0) {
                    NSArray *subArr = [[upperComponents objectAtIndex:0] componentsSeparatedByString:@";"];
                    if ([subArr count]>=2) {
                        NSArray *subArr1 = [[subArr objectAtIndex:1] componentsSeparatedByString:@"="];
                        [imEntity setService:[[subArr1 lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }
                }
                
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [imEntity setLabel:[self getValueInangle:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]]];

                    i++;
                }
                [imEntity setType:@"other"];
                [imEntity setEntityID:[NSNumber numberWithInt:g1]];
                g1++;
                [imEntity setContactCategory:Contact_IM];
                [entity.IMArray addObject:imEntity];
                [imEntity release];
                
            }
        }else if ([line hasPrefix:@"END:"]&&entity != nil)
        {
            [contactArray addObject:entity];
            [entity release];
            entity = nil;
        }
        
    }
    return contactArray;
}
//去得<>里面的值
- (NSString *)getValueInangle:(NSString *)str
{
    NSScanner *theScanner = [NSScanner scannerWithString:str];
    NSString *text = nil;
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
    }
    if ([text hasPrefix:@"<"]) {
        text = [text stringByReplacingOccurrencesOfString:@"<" withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@">" withString:@""];
        return text;
    }else
    {
        return str;
    }
}

// 从数据库查询联系人的基本信息
- (NSMutableDictionary*)queryContact:(int)contactID {
    NSMutableDictionary *contactsDic = nil;;
    if (_addressBookConnection != nil) {
        contactsDic = [[[NSMutableDictionary alloc] init] autorelease];
        FMResultSet *rs = nil;
        
        NSString *selectCmd = @"select ROWID,First,Last,Middle,FirstPhonetic,MiddlePhonetic,LastPhonetic,Organization,Department,Note,Kind,Birthday,JobTitle,Nickname,Prefix,Suffix from ABPerson where ROWID=:rowid;";
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithLongLong:contactID], @"rowid",
                               nil];
        rs = [_addressBookConnection executeQuery:selectCmd withParameterDictionary:param];
        
        NSMutableDictionary *contactDic = nil;
        while ([rs next]) {
            contactDic = [[NSMutableDictionary alloc] init];
            //NSString *cKey = [NSString stringWithFormat:@"%d", [rs intForColumn:@"ROWID"]];
            
            [contactDic setObject:DOMAIN_CONTACT forKey:RECORD_ENTITY_NAME];
            
            NSString *firstname = [rs stringForColumn:@"First"];
            if (![TempHelper stringIsNilOrEmpty:firstname]) {
                [contactDic setObject:firstname forKey:RECORD_FIRST_NAME];
            }
            NSString *firstnameyomi = [rs stringForColumn:@"FirstPhonetic"];
            if (![TempHelper stringIsNilOrEmpty:firstnameyomi]) {
                [contactDic setObject:firstnameyomi forKey:RECORD_FIRST_NAME_YOMI];
            }
            NSString *middlename = [rs stringForColumn:@"Middle"];
            if (![TempHelper stringIsNilOrEmpty:middlename]) {
                [contactDic setObject:middlename forKey:RECORD_MIDDLE_NAME];
            }
            NSString *lastname = [rs stringForColumn:@"Last"];
            if (![TempHelper stringIsNilOrEmpty:lastname]) {
                [contactDic setObject:lastname forKey:RECORD_LAST_NAME];
            }
            NSString *lastnameyomi = [rs stringForColumn:@"LastPhonetic"];
            if (![TempHelper stringIsNilOrEmpty:lastnameyomi]) {
                [contactDic setObject:lastnameyomi forKey:RECORD_LAST_NAME_YOMI];
            }
            NSString *nickname = [rs stringForColumn:@"Nickname"];
            if (![TempHelper stringIsNilOrEmpty:nickname]) {
                [contactDic setObject:nickname forKey:RECORD_NICK_NAME];
            }
            NSString *suffix = [rs stringForColumn:@"Suffix"];
            if (![TempHelper stringIsNilOrEmpty:suffix]) {
                [contactDic setObject:suffix forKey:RECORD_SUFFIX];
            }
            NSString *title = [rs stringForColumn:@"Prefix"];
            if (![TempHelper stringIsNilOrEmpty:title]) {
                [contactDic setObject:title forKey:RECORD_TITLE];
            }
            NSString *companyname = [rs stringForColumn:@"Organization"];
            if (![TempHelper stringIsNilOrEmpty:companyname]) {
                [contactDic setObject:companyname forKey:RECORD_COMPANY_NAME];
            }
            NSString *department = [rs stringForColumn:@"Department"];
            if (![TempHelper stringIsNilOrEmpty:department]) {
                [contactDic setObject:department forKey:RECORD_DEPARTMENT];
            }
            NSString *jobtitle = [rs stringForColumn:@"JobTitle"];
            if (![TempHelper stringIsNilOrEmpty:jobtitle]) {
                [contactDic setObject:jobtitle forKey:RECORD_JOB_NAME];
            }
            NSString *birthdayIntStr = [rs stringForColumn:@"Birthday"];
            if (![TempHelper stringIsNilOrEmpty:birthdayIntStr]) {
                int birthday = [birthdayIntStr intValue];
                NSDate *birDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:birthday];
                [contactDic setObject:birDate forKey:RECORD_BIRTHDAY];
            }
            NSString *notes = [rs stringForColumn:@"Note"];
            if (![TempHelper stringIsNilOrEmpty:notes]) {
                [contactDic setObject:notes forKey:RECORD_NOTES];
            }
            // 根据ROWID查询出该联系人的缩略图
            NSString *imgSelectCmd =  @"select data from ABFullSizeImage where record_id=:rowid;";
            FMResultSet *imgRS = [_addressBookImagesConnection executeQuery:imgSelectCmd withParameterDictionary:param];
            while ([imgRS next]) {
                if (![imgRS columnIsNull:@"data"]) {
                    NSImage *image = [imgRS objectForColumnName:@"data"];
                    if (image != nil) {
                        [contactDic setObject:image forKey:RECORD_IMAGE];
                    }
                }
            }
            [imgRS close];
            [contactsDic setObject:contactDic forKey:DOMAIN_CONTACT];
            [contactDic release];
        }
        [rs close];
    }
    return contactsDic;
}

#pragma mark -对外公布的函数
// 查询出相似联系人的记录
- (void)queryImilarContact {
    if (_similarDic == nil) {
        _similarDic = [[NSMutableDictionary alloc] init];
    } else {
        [_similarDic removeAllObjects];
    }
    [self openMobileSync];
    [self queryAllContact];
    [self closeMobileSync];
    
    NSMutableArray *checkedContactIDArray = [[NSMutableArray alloc] init];
    NSLog(@"%@",_allPersionDic );
    if (_allPersionDic != nil) {
        NSArray *allPKey = [_allPersionDic allKeys];
        for (NSString *pKey in allPKey) {
            if ([checkedContactIDArray containsObject:pKey]) {
                continue;
            }
            
            NSMutableDictionary *personDic = [_allPersionDic valueForKey:pKey];
            
            NSArray *domainKeyArray = [personDic allKeys];
            NSMutableDictionary *imilarDictionary = [[NSMutableDictionary alloc] init];
            // 比较联系人的姓名,查找出相似的联系人
            if ([domainKeyArray containsObject:DOMAIN_CONTACT]) {
                NSMutableDictionary *contactDic = [personDic valueForKey:DOMAIN_CONTACT];
                NSArray *vKeys = [contactDic allKeys];
                
                NSString *firstName = nil;
                NSString *lastName = nil;
                NSString *middleName = nil;
                if ([vKeys containsObject:RECORD_FIRST_NAME]) {
                    firstName = [contactDic valueForKey:RECORD_FIRST_NAME];
                } else {
                    firstName = @"";
                }
                if ([vKeys containsObject:RECORD_LAST_NAME]) {
                    lastName = [contactDic valueForKey:RECORD_LAST_NAME];
                } else {
                    lastName = @"";
                }
                if ([vKeys containsObject:RECORD_MIDDLE_NAME]) {
                    middleName = [contactDic valueForKey:RECORD_MIDDLE_NAME];
                } else {
                    middleName = @"";
                }
                
                NSMutableDictionary *eachPersonDic = nil;
                for (id key in _allPersionDic) {
                    if ([key isEqualToString:pKey] || [checkedContactIDArray containsObject:key]) {
                        continue;
                    }
                    eachPersonDic = [_allPersionDic objectForKey:key];
                    if ([[eachPersonDic allKeys] containsObject:DOMAIN_CONTACT]) {
                        contactDic = [eachPersonDic valueForKey:DOMAIN_CONTACT];
                        vKeys = [contactDic allKeys];
                        NSString *firstName1 = nil;
                        NSString *lastName1 = nil;
                        NSString *middleName1 = nil;
                        
                        if ([vKeys containsObject:RECORD_FIRST_NAME]) {
                            firstName1 = [contactDic valueForKey:RECORD_FIRST_NAME];
                        } else {
                            firstName1 = @"";
                        }
                        if ([vKeys containsObject:RECORD_LAST_NAME]) {
                            lastName1 = [contactDic valueForKey:RECORD_LAST_NAME];
                        } else {
                            lastName1 = @"";
                        }
                        if ([vKeys containsObject:RECORD_MIDDLE_NAME]) {
                            middleName1 = [contactDic valueForKey:RECORD_MIDDLE_NAME];
                        } else {
                            middleName1 = @"";
                        }
                        
                        if ([firstName isEqualToString:firstName1] && [lastName isEqualToString:lastName1] && [middleName isEqualToString:middleName1]) {
                            if (![checkedContactIDArray containsObject:key]) {
                                [checkedContactIDArray addObject:key];
                            }
                            NSArray *imilarAllKey = [imilarDictionary allKeys];
                            if ([imilarAllKey containsObject:key]) {
                                // 如果已经存在了
                                NSMutableDictionary *valueDic = [imilarDictionary valueForKey:key];
                                NSMutableDictionary *contactValueDic = [[NSMutableDictionary alloc] init];
                                [contactValueDic setObject:firstName forKey:RECORD_FIRST_NAME];
                                [contactValueDic setObject:lastName forKey:RECORD_LAST_NAME];
                                [contactValueDic setObject:middleName forKey:RECORD_MIDDLE_NAME];
                                [valueDic setObject:contactValueDic forKey:DOMAIN_CONTACT];
                                [contactValueDic release];
                                contactValueDic = nil;
                            } else {
                                // 如果一次都没有加入
                                NSMutableDictionary *valueDic = [[NSMutableDictionary alloc] init];
                                NSMutableDictionary *contactValueDic = [[NSMutableDictionary alloc] init];
                                [contactValueDic setObject:firstName forKey:RECORD_FIRST_NAME];
                                [contactValueDic setObject:lastName forKey:RECORD_LAST_NAME];
                                [contactValueDic setObject:middleName forKey:RECORD_MIDDLE_NAME];
                                [valueDic setObject:contactValueDic forKey:DOMAIN_CONTACT];
                                [contactValueDic release];
                                contactValueDic = nil;
                                [imilarDictionary setObject:valueDic forKey:key];
                                [valueDic release];
                                valueDic = nil;
                            }
                        }
                    }
                }
            }
            
            // 比较电话号码,查找出相似的联系人
            if ([domainKeyArray containsObject:DOMAIN_PHONE_NUMBER]) {
                NSMutableDictionary *telNumbersDic = [personDic valueForKey:DOMAIN_PHONE_NUMBER];
                NSArray *iKeys = [telNumbersDic allKeys];
                for (NSString *iKey in iKeys) {
                    NSMutableDictionary *telNumberDic = [telNumbersDic valueForKey:iKey];
                    NSArray *vKeys = [telNumberDic allKeys];
                    if ([vKeys containsObject:ITEM_VALUE_KEY]) {
                        NSString *value = [telNumberDic valueForKey:ITEM_VALUE_KEY];
                        
                        NSMutableDictionary *eachPersonDic = nil;
                        for (id key in _allPersionDic) {
                            if ([key isEqualToString:pKey] || [checkedContactIDArray containsObject:key]) {
                                continue;
                            }
                            eachPersonDic = [_allPersionDic objectForKey:key];
                            if ([[eachPersonDic allKeys] containsObject:DOMAIN_PHONE_NUMBER]) {
                                NSMutableDictionary *phoneNumberDic = [eachPersonDic objectForKey:DOMAIN_PHONE_NUMBER];
                                for (id eachKey in phoneNumberDic) {
                                    NSMutableDictionary *eachDic = [phoneNumberDic objectForKey:eachKey];
                                    if ([eachDic.allKeys containsObject:ITEM_VALUE_KEY]) {
                                        NSString *value1 = [eachDic valueForKey:ITEM_VALUE_KEY];
                                        if ([value isEqualToString:value1]) {
                                            if (![checkedContactIDArray containsObject:key]) {
                                                [checkedContactIDArray addObject:key];
                                            }
                                            NSArray *imilarAllKey = [imilarDictionary allKeys];
                                            if ([imilarAllKey containsObject:key]) {
                                                // 如果已经存在了
                                                NSMutableDictionary *valueDic = [imilarDictionary valueForKey:key];
                                                NSMutableDictionary *phoneNumValueDic = [[NSMutableDictionary alloc] init];
                                                [phoneNumValueDic setObject:value forKey:ITEM_VALUE_KEY];
                                                [valueDic setObject:phoneNumValueDic forKey:DOMAIN_PHONE_NUMBER];
                                                [phoneNumValueDic release];
                                                phoneNumValueDic = nil;
                                            } else {
                                                // 如果一次都没有加入
                                                NSMutableDictionary *valueDic = [[NSMutableDictionary alloc] init];
                                                NSMutableDictionary *phoneNumValueDic = [[NSMutableDictionary alloc] init];
                                                [phoneNumValueDic setObject:value forKey:ITEM_VALUE_KEY];
                                                [valueDic setObject:phoneNumValueDic forKey:DOMAIN_PHONE_NUMBER];
                                                [phoneNumValueDic release];
                                                phoneNumValueDic = nil;
                                                [imilarDictionary setObject:valueDic forKey:key];
                                                [valueDic release];
                                                valueDic = nil;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // 比较电子邮件,查找出相似的练习人
            if ([domainKeyArray containsObject:DOMAIN_EMAIL_ADDRESS]) {
                NSMutableDictionary *emailAddrsDic = [personDic valueForKey:DOMAIN_EMAIL_ADDRESS];
                NSArray *iKeys = [emailAddrsDic allKeys];
                for (NSString *iKey in iKeys) {
                    NSMutableDictionary *emailAddrDic = [emailAddrsDic valueForKey:iKey];
                    NSArray *vKeys = [emailAddrDic allKeys];
                    if ([vKeys containsObject:ITEM_VALUE_KEY]) {
                        NSString *value = [emailAddrDic valueForKey:ITEM_VALUE_KEY];
                        
                        NSMutableDictionary *eachPersonDic = nil;
                        for (id key in _allPersionDic) {
                            if ([key isEqualToString:pKey] || [checkedContactIDArray containsObject:key]) {
                                continue;
                            }
                            eachPersonDic = [_allPersionDic objectForKey:key];
                            if ([[eachPersonDic allKeys] containsObject:DOMAIN_EMAIL_ADDRESS]) {
                                NSMutableDictionary *emailAddressDic = [eachPersonDic objectForKey:DOMAIN_EMAIL_ADDRESS];
                                for (id eachKey in emailAddressDic) {
                                    NSMutableDictionary *eachDic = [emailAddressDic objectForKey:eachKey];
                                    if ([eachDic.allKeys containsObject:ITEM_VALUE_KEY]) {
                                        NSString *value1 = [eachDic valueForKey:ITEM_VALUE_KEY];
                                        if ([value isEqualToString:value1]) {
                                            if (![checkedContactIDArray containsObject:key]) {
                                                [checkedContactIDArray addObject:key];
                                            }
                                            NSArray *imilarAllKey = [imilarDictionary allKeys];
                                            if ([imilarAllKey containsObject:key]) {
                                                // 如果已经存在了
                                                NSMutableDictionary *valueDic = [imilarDictionary valueForKey:key];
                                                NSMutableDictionary *eamilValueDic = [[NSMutableDictionary alloc] init];
                                                [eamilValueDic setObject:value forKey:ITEM_VALUE_KEY];
                                                [valueDic setObject:eamilValueDic forKey:DOMAIN_EMAIL_ADDRESS];
                                                [eamilValueDic release];
                                                eamilValueDic = nil;
                                            } else {
                                                // 如果一次都没有加入
                                                NSMutableDictionary *valueDic = [[NSMutableDictionary alloc] init];
                                                NSMutableDictionary *eamilValueDic = [[NSMutableDictionary alloc] init];
                                                [eamilValueDic setObject:value forKey:ITEM_VALUE_KEY];
                                                [valueDic setObject:eamilValueDic forKey:DOMAIN_EMAIL_ADDRESS];
                                                [eamilValueDic release];
                                                eamilValueDic = nil;
                                                [imilarDictionary setObject:valueDic forKey:key];
                                                [valueDic release];
                                                valueDic = nil;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if (imilarDictionary != nil && imilarDictionary.allKeys.count > 0) {
                [_similarDic setObject:imilarDictionary forKey:pKey];
            }
            [imilarDictionary release];
            imilarDictionary = nil;
        }
    }
    [checkedContactIDArray release];
    checkedContactIDArray = nil;
}

- (NSMutableArray *)compareContact:(NSString*)contactKey allContactDic:(NSMutableDictionary*)allContactDic {
    return nil;
}

// 查询出联系人的冗余的记录
- (void)queryRedundancyItemInContact {
    _redundancyDic = [[NSMutableDictionary alloc] init];
    if (_allPersionDicFromSqlite == nil) {
        [self queryAllPersionFromSqlite];
    }
    if (_allPersionDicFromSqlite != nil) {
        NSArray *allPKey = [_allPersionDicFromSqlite allKeys];
        for (NSString *pKey in allPKey) {
            NSMutableDictionary *personDic = [_allPersionDicFromSqlite valueForKey:pKey];
            
            NSMutableDictionary *redundancyDictionary = [[NSMutableDictionary alloc] init];
            // 遍历联系人中的所有的域项
            NSArray *domainKeyArray = [personDic allKeys];
            for (NSString *dKey in domainKeyArray) {
                if ([dKey isEqualToString:DOMAIN_CONTACT]) {
                    continue;
                } else if ([dKey isEqualToString:DOMAIN_IM]) {
                    NSMutableDictionary *domainDic = [personDic valueForKey:dKey];
                    NSArray *iKeys = [domainDic allKeys];
                    NSMutableDictionary *redundancyKeyDic = [[NSMutableDictionary alloc] init];
                    // 依次遍历所有的键中重复内容的键
                    for (NSString *iKey in iKeys) {
                        NSMutableArray *redundancyArray = [self compareIM:iKey allIMDic:domainDic];
                        if (redundancyArray != nil && [redundancyArray count] > 0) {
                            [redundancyKeyDic setObject:redundancyArray forKey:iKey];
                        }
                    }
                    //将遍历出来的冗余的键加入进域中
                    if (redundancyKeyDic != nil && [[redundancyKeyDic allKeys] count] > 0) {
                        [redundancyDictionary setObject:redundancyKeyDic forKey:dKey];
                    }
                    [redundancyKeyDic release];
                } else if ([dKey isEqualToString:DOMAIN_STREET_ADDRESS]) {
                    NSMutableDictionary *domainDic = [personDic valueForKey:dKey];
                    NSArray *iKeys = [domainDic allKeys];
                    NSMutableDictionary *redundancyKeyDic = [[NSMutableDictionary alloc] init];
                    // 依次遍历所有的键中重复内容的键
                    for (NSString *iKey in iKeys) {
                        NSMutableArray *redundancyArray = [self compareStreetAddress:iKey allStreetAddressDic:domainDic];
                        if (redundancyArray != nil && [redundancyArray count] > 0) {
                            [redundancyKeyDic setObject:redundancyArray forKey:iKey];
                        }
                    }
                    //将遍历出来的冗余的键加入进域中
                    if (redundancyKeyDic != nil && [[redundancyKeyDic allKeys] count] > 0) {
                        [redundancyDictionary setObject:redundancyKeyDic forKey:dKey];
                    }
                    [redundancyKeyDic release];
                } else if ([dKey isEqualToString:DOMAIN_URL]) {
                    NSMutableDictionary *domainDic = [personDic valueForKey:dKey];
                    NSArray *iKeys = [domainDic allKeys];
                    NSMutableDictionary *redundancyKeyDic = [[NSMutableDictionary alloc] init];
                    // 依次遍历所有的键中重复内容的键
                    for (NSString *iKey in iKeys) {
                        NSMutableArray *redundancyArray = [self compareIM:iKey allIMDic:domainDic];
                        if (redundancyArray != nil && [redundancyArray count] > 0) {
                            [redundancyKeyDic setObject:redundancyArray forKey:iKey];
                        }
                    }
                    //将遍历出来的冗余的键加入进域中
                    if (redundancyKeyDic != nil && [[redundancyKeyDic allKeys] count] > 0) {
                        [redundancyDictionary setObject:redundancyKeyDic forKey:dKey];
                    }
                    [redundancyKeyDic release];
                } else {
                    NSMutableDictionary *domainDic = [personDic valueForKey:dKey];
                    NSArray *iKeys = [domainDic allKeys];
                    NSMutableDictionary *redundancyKeyDic = [[NSMutableDictionary alloc] init];
                    for (NSString *iKey in iKeys) {
                        NSMutableArray *redundancyArray = [self compareDomain:iKey allDomainDic:domainDic];
                        if (redundancyArray != nil && [redundancyArray count] > 0) {
                            [redundancyKeyDic setObject:redundancyArray forKey:iKey];
                        }
                    }
                    
                    if (redundancyKeyDic != nil && [[redundancyKeyDic allKeys] count] > 0) {
                        [redundancyDictionary setObject:redundancyKeyDic forKey:dKey];
                    }
                    [redundancyKeyDic release];
                    redundancyKeyDic = nil;
                }
            }
            if (redundancyDictionary != nil && [redundancyDictionary count] > 0) {
                [_redundancyDic setObject:redundancyDictionary forKey:pKey];
            }
            [redundancyDictionary release];
        }
    }
}

// 比较联系地址
- (NSMutableArray *)compareStreetAddress:(NSString*)streetAddressDicKey allStreetAddressDic:(NSMutableDictionary*)allStreetAddressDic {
    NSMutableArray *redundancyKeyArray = [[[NSMutableArray alloc] init] autorelease];
    // 取出当前要比较的联系人的值
    NSMutableDictionary *streetAddressDic = [allStreetAddressDic valueForKey:streetAddressDicKey];
    NSArray *vKeys = [streetAddressDic allKeys];
    NSString *country = nil;
    NSString *city = nil;
    NSString *countryCode = nil;
    NSString *state = nil;
    NSString *zip = nil;
    NSString *street = nil;
    if ([vKeys containsObject:ITEM_COUNTRY_KEY]) {
        country = [streetAddressDic valueForKey:ITEM_COUNTRY_KEY];
    } else {
        country = @"";
    }
    if ([vKeys containsObject:ITEM_CITY_KEY]) {
        city = [streetAddressDic valueForKey:ITEM_CITY_KEY];
    } else {
        city = @"";
    }
    if ([vKeys containsObject:ITEM_COUNTRY_CODE_KEY]) {
        countryCode = [streetAddressDic valueForKey:ITEM_COUNTRY_CODE_KEY];
    } else {
        countryCode = @"";
    }
    if ([vKeys containsObject:ITEM_STATE_KEY]) {
        state = [streetAddressDic valueForKey:ITEM_STATE_KEY];
    } else {
        state = @"";
    }
    if ([vKeys containsObject:ITEM_POSTAL_CODE_KEY]) {
        zip = [streetAddressDic valueForKey:ITEM_POSTAL_CODE_KEY];
    } else {
        zip = @"";
    }
    if ([vKeys containsObject:ITEM_STREET_KEY]) {
        street = [streetAddressDic valueForKey:ITEM_STREET_KEY];
    } else {
        street = @"";
    }
    
    NSArray *saKeys = [allStreetAddressDic allKeys];
    for (NSString *saKey in saKeys) {
        NSString *country1 = nil;
        NSString *city1 = nil;
        NSString *countryCode1 = nil;
        NSString *state1 = nil;
        NSString *zip1 = nil;
        NSString *street1 = nil;
        NSMutableDictionary *itemDic = [allStreetAddressDic valueForKey:saKey];
        vKeys = [itemDic allKeys];
        if ([vKeys containsObject:ITEM_COUNTRY_KEY]) {
            country1 = [itemDic valueForKey:ITEM_COUNTRY_KEY];
        } else {
            country1 = @"";
        }
        if ([vKeys containsObject:ITEM_CITY_KEY]) {
            city1 = [itemDic valueForKey:ITEM_CITY_KEY];
        } else {
            city1 = @"";
        }
        if ([vKeys containsObject:ITEM_COUNTRY_CODE_KEY]) {
            countryCode1 = [itemDic valueForKey:ITEM_COUNTRY_CODE_KEY];
        } else {
            countryCode1 = @"";
        }
        if ([vKeys containsObject:ITEM_STATE_KEY]) {
            state1 = [itemDic valueForKey:ITEM_STATE_KEY];
        } else {
            state1 = @"";
        }
        if ([vKeys containsObject:ITEM_POSTAL_CODE_KEY]) {
            zip1 = [itemDic valueForKey:ITEM_POSTAL_CODE_KEY];
        } else {
            zip1 = @"";
        }
        if ([vKeys containsObject:ITEM_STREET_KEY]) {
            street1 = [itemDic valueForKey:ITEM_STREET_KEY];
        } else {
            street1 = @"";
        }
        if ([country isEqualToString:country1] &&
            [city isEqualToString:city1] &&
            [countryCode isEqualToString:countryCode1] &&
            [state isEqualToString:state1] &&
            [zip isEqualToString:zip1] &&
            [street isEqualToString:street1]) {
            // 将相同的部分的键加入数组中
            if (![saKey isEqualToString:streetAddressDicKey]) {
                [redundancyKeyArray addObject:saKey];
            }
        }
    }
    return redundancyKeyArray;
}

// 比较IM
- (NSMutableArray *)compareIM:(NSString*)imDicKey allIMDic:(NSMutableDictionary*)allIMDic {
    NSMutableArray *redundancyKeyArray = [[[NSMutableArray alloc] init] autorelease];
    // 取出当前要比较的联系人的值
    NSMutableDictionary *imDic = [allIMDic valueForKey:imDicKey];
    NSArray *vKeys = [imDic allKeys];
    NSString *service = nil;
    NSString *user = nil;
    if ([vKeys containsObject:ITEM_SERVICE_KEY]) {
        service = [imDic valueForKey:ITEM_SERVICE_KEY];
    } else {
        service = @"";
    }
    if ([vKeys containsObject:ITEM_USER_KEY]) {
        user = [imDic valueForKey:ITEM_USER_KEY];
    } else {
        user = @"";
    }
    
    NSArray *imKeys = [allIMDic allKeys];
    for (NSString *imKey in imKeys) {
        NSString *service1 = nil;
        NSString *user1 = nil;
        
        NSMutableDictionary *itemDic = [allIMDic valueForKey:imKey];
        vKeys = [itemDic allKeys];
        if ([vKeys containsObject:ITEM_SERVICE_KEY]) {
            service1 = [itemDic valueForKey:ITEM_SERVICE_KEY];
        } else {
            service1 = @"";
        }
        if ([vKeys containsObject:ITEM_USER_KEY]) {
            user1 = [itemDic valueForKey:ITEM_USER_KEY];
        } else {
            user1 = @"";
        }
        if ([service isEqualToString:service1] &&
            [user isEqualToString:user1]) {
            // 将相同的部分的键加入数组中
            if (![imKey isEqualToString:imDicKey]) {
                [redundancyKeyArray addObject:imKey];
            }
        }
    }
    return redundancyKeyArray;
}

// 比较URL
- (NSMutableArray *)compareURL:(NSString*)urlDicKey allURLDic:(NSMutableDictionary*)allURLDic {
    NSMutableArray *redundancyKeyArray = [[[NSMutableArray alloc] init] autorelease];
    // 取出当前要比较的联系人的值
    NSMutableDictionary *urlDic = [allURLDic valueForKey:urlDicKey];
    NSArray *vKeys = [urlDic allKeys];
    NSString *service = nil;
    NSString *user = nil;
    if ([vKeys containsObject:ITEM_SERVICE_KEY]) {
        service = [urlDic valueForKey:ITEM_SERVICE_KEY];
    } else {
        service = @"";
    }
    if ([vKeys containsObject:ITEM_USER_KEY]) {
        user = [urlDic valueForKey:ITEM_USER_KEY];
    } else {
        user = @"";
    }
    
    NSArray *urlKeys = [allURLDic allKeys];
    for (NSString *urlKey in urlKeys) {
        NSString *service1 = nil;
        NSString *user1 = nil;
        
        NSMutableDictionary *itemDic = [allURLDic valueForKey:urlKey];
        vKeys = [itemDic allKeys];
        if ([vKeys containsObject:ITEM_SERVICE_KEY]) {
            service1 = [itemDic valueForKey:ITEM_SERVICE_KEY];
        } else {
            service1 = @"";
        }
        if ([vKeys containsObject:ITEM_USER_KEY]) {
            user1 = [itemDic valueForKey:ITEM_USER_KEY];
        } else {
            user1 = @"";
        }
        if ([service isEqualToString:service1] &&
            [user isEqualToString:user1]) {
            // 将相同的部分的键加入数组中
            if (![urlKey isEqualToString:urlDicKey]) {
                [redundancyKeyArray addObject:urlKey];
            }
        }
    }
    return redundancyKeyArray;
}

// 比较地域下面的相似的信息
- (NSMutableArray *)compareDomain:(NSString*)checkKey allDomainDic:(NSMutableDictionary *)allDomainDic {
    NSMutableArray *redundancyKeyArray = [[[NSMutableArray alloc] init] autorelease];
    // 取出当前要比较的联系人的值
    NSMutableDictionary *checkDic = [allDomainDic valueForKey:checkKey];
    NSArray *vKeys = [checkDic allKeys];
    NSString *value = nil;
    if ([vKeys containsObject:ITEM_VALUE_KEY]) {
        value = [checkDic valueForKey:ITEM_VALUE_KEY];
    } else {
        value = @"";
    }
    
    NSArray *allKeys = [allDomainDic allKeys];
    for (NSString *key in allKeys) {
        NSString *value1 = nil;
        
        NSMutableDictionary *itemDic = [allDomainDic valueForKey:key];
        vKeys = [itemDic allKeys];
        if ([vKeys containsObject:ITEM_VALUE_KEY]) {
            value1 = [itemDic valueForKey:ITEM_VALUE_KEY];
        } else {
            value1 = @"";
        }
        if ([value isEqualToString:value1]) {
            // 将相同的部分的键加入数组中
            if (![checkKey isEqualToString:key]) {
                [redundancyKeyArray addObject:key];
            }
        }
    }
    return redundancyKeyArray;
}

#pragma mark - 对联系人数据进行合并及其清理
// 合并后的数据结构
- (NSMutableDictionary *)getMergeDic:(NSMutableDictionary*)imilarContact mainContactKey:(NSString*)mainContactKey {
    NSMutableDictionary *mergeDic = [[[NSMutableDictionary alloc] init] autorelease];
    if (_allPersionDic != nil) {
        NSArray *pKeys = [_allPersionDic allKeys];
        if ([pKeys containsObject:mainContactKey]) {
            NSMutableDictionary *personDic = [[_allPersionDic valueForKey:mainContactKey] mutableDeepCopy];
            // 遍历所有的相似项目,相似项中不会有主要的联系人信息
            NSArray *ipKeys = [imilarContact allKeys];
            for (NSString *ipKey in ipKeys) {
                NSMutableDictionary *iPersonDic = [_allPersionDic valueForKey:ipKey];
                
                // 遍历下面所有的域
                NSArray *idKeys = [iPersonDic allKeys];
                NSArray *dKeys = [personDic allKeys];
                for (NSString *idKey in idKeys) {
                    if ([idKey isEqualToString:DOMAIN_CONTACT]) {
                        // 这里需要的是加入主联系人不存在的个人信息进去,并更新数据库
                        NSMutableDictionary *domainDic = [personDic valueForKey:idKey];
                        NSMutableDictionary *iDomainDic = [iPersonDic valueForKey:idKey];
                        NSArray *valueKeys = [domainDic allKeys];
                        NSArray *iValueKeys = [iDomainDic allKeys];
                        for (NSString *iValueKey in iValueKeys) {
                            if ([valueKeys containsObject:iValueKey]) {
                                continue;
                            }
                            NSString *valueStr = [iDomainDic objectForKey:iValueKey];
                            [domainDic setObject:valueStr forKey:iValueKey];
                        }
                        continue;
                    }
                    int i = 0;
                    int property = 0;
                    NSString *itemKeyFormat = @"%d/%d/%d";
                    // 如果包含了该域,就进行遍历，如果没有包含该域，就进行添加
                    if (![dKeys containsObject:idKey]) {
                        // 在这里只需要将相似的联系人的信息弄提取到主联系人里面就可以了
                        NSMutableDictionary *domainDic = [[NSMutableDictionary alloc] init];
                        NSMutableDictionary *iDomainDic = [iPersonDic valueForKey:idKey];
                        NSString *itemKey = nil;
                        NSArray *iItemKeys = [iDomainDic allKeys];
                        // itemKey就是类似3/1/0这样的
                        for (NSString *iItemKey in iItemKeys) {
                            NSMutableDictionary *itemDic = [[NSMutableDictionary alloc] init];
                            NSMutableDictionary *iItemDic = [iDomainDic valueForKey:iItemKey];
                            
                            // 取出对应的属性值
                            if (property == 0) {
                                NSArray *numArray = [iItemKey componentsSeparatedByString:@"/"];
                                if ([numArray count] == 3) {
                                    property = [[numArray objectAtIndex:0] intValue];
                                }
                            }
                            
                            NSArray *valueKeys = [iItemDic allKeys];
                            // 如果该项有值,才向主域添加
                            if ([valueKeys count] > 0) {
                                for (NSString *valueKey in valueKeys) {
                                    if (![valueKey isEqualToString:ITEM_CONTACT_KEY]) {
                                        [itemDic setObject:[iItemDic valueForKey:valueKey] forKey:valueKey];
                                    } else {
                                        [itemDic setObject:[NSArray arrayWithObjects:mainContactKey, nil] forKey:ITEM_CONTACT_KEY];
                                    }
                                }
                                
                                itemKey = [NSString stringWithFormat:itemKeyFormat, property, [mainContactKey intValue], i];
                                [domainDic setObject:itemDic forKey:itemKey];
                                i += 1;
                            }
                            
                            [itemDic release];
                        }
                        [personDic setObject:domainDic forKey:idKey];
                        [domainDic release];
                    } else {
                        // 在这里需要一项一项的比较
                        NSMutableDictionary *iDomainDic = [iPersonDic valueForKey:idKey];
                        NSMutableDictionary *domainDic = [personDic valueForKey:idKey];
                        
                        // 找出所有主域中的排名最大的一个及其已经存在的type
                        NSMutableArray *exsitTypes = [[NSMutableArray alloc] init];
                        if (i == 0) {
                            int maxNum = 0;
                            NSArray *itemKeys = [domainDic allKeys];
                            for (NSString *itemKey in itemKeys) {
                                NSArray *numArray = [itemKey componentsSeparatedByString:@"/"];
                                if ([numArray count] == 3) {
                                    if (property == 0) {
                                        property = [[numArray objectAtIndex:0] intValue];
                                    }
                                    i = [[numArray objectAtIndex:2] intValue];
                                    if (maxNum < i) {
                                        maxNum = i;
                                    }
                                }
                                
                                NSDictionary *itemDic= [domainDic objectForKey:itemKey];
                                NSArray *valueKeys = [itemDic allKeys];
                                if ([valueKeys containsObject:ITEM_TYPE_KEY]) {
                                    NSString *typeStr = [itemDic valueForKey:ITEM_TYPE_KEY];
                                    if (![TempHelper stringIsNilOrEmpty:typeStr]) {
                                        [exsitTypes addObject:typeStr];
                                    }
                                }
                            }
                            i = maxNum + 1;
                        }
                        
                        NSString *itemKey = nil;
                        NSArray *iItemKeys = [iDomainDic allKeys];
                        // iItemKey就是类似3/1/0这样的
                        for (NSString *iItemKey in iItemKeys) {
                            // 取出每一项的Dic数据传入主联系人对应的域中进行处理
                            NSMutableDictionary *iItemDic = [iDomainDic valueForKey:iItemKey];
                            // 检查此项是否在主域下面存,主要是该值是否需要添加进主域,如果不存在就添加进主域里面,如果里面存,则不需要再添加重复的了
                            if (![self checkItemInMainDomain:iItemDic mainDomain:domainDic domianName:idKey]) {
                                NSMutableDictionary *itemDic = [[NSMutableDictionary alloc] init];
                                NSArray *valueKays = [iItemDic allKeys];
                                for (NSString *valueKay in valueKays) {
                                    if ([valueKay isEqualToString:ITEM_CONTACT_KEY]) {
                                        [itemDic setObject:[NSArray arrayWithObjects:mainContactKey, nil] forKey:ITEM_CONTACT_KEY];
                                    } else if ([valueKay isEqualToString:ITEM_TYPE_KEY]) {
                                        NSString *iTypeStr = [iItemDic valueForKey:valueKay];
                                        if ([exsitTypes containsObject:iTypeStr]) {
                                            [itemDic setObject:@"other" forKey:valueKay];
                                        } else {
                                            [itemDic setObject:iTypeStr forKey:valueKay];
                                        }
                                    } else {
                                        [itemDic setObject:[iItemDic valueForKey:valueKay] forKey:valueKay];
                                    }
                                }
                                
                                itemKey = [NSString stringWithFormat:itemKeyFormat, property, [mainContactKey intValue], i];
                                [domainDic setObject:itemDic forKey:itemKey];
                                [itemDic release];
                                i += 1;
                            }
                        }
                        
                        [exsitTypes release];
                    }
                }
            }
            
            [mergeDic setObject:personDic forKey:mainContactKey];
        }
    }
    return mergeDic;
}

// 合并联系人数据
- (void)mergerContact:(NSMutableDictionary*)imilarContact mergeDic:(NSMutableDictionary *)mergeDic {
    if (_allPersionDic != nil) {
        NSArray *pKeys = [_allPersionDic allKeys];
        NSString *mainContactKey = nil;
        if (mergeDic != nil && mergeDic.allKeys.count > 0) {
            mainContactKey = [mergeDic.allKeys objectAtIndex:0];
        }
        
        if (![TempHelper stringIsNilOrEmpty:mainContactKey] && [pKeys containsObject:mainContactKey]) {
            // 先将相似的练习人进行数据清理
            NSArray *mergeKeys = nil;
            if (imilarContact != nil && [[imilarContact allKeys] count] > 0) {
                NSArray *pKeys = [imilarContact allKeys];
                mergeKeys = pKeys;
                for (NSString *pKey in pKeys) {
                    [self clearContact:pKey];
                }
            }
            // 将主联系人数据进行清理
            [self clearContact:mainContactKey];
            
            // 进行合并删除
//            NSMutableDictionary *personDic = [_allPersionDic valueForKey:mainContactKey];
            [self openMobileSync];
//            [self modifyContact:mergeDic orgPersionDic:personDic];
            [self closeMobileSync];
            [self openMobileSync];
            [self delContract:mergeKeys];
            [self closeMobileSync];
        }
    }
}

// 清理联系人冗余数据
- (void)clearContact:(NSString*)contactKey {
    // 清理联系人主要是把冗余的部分剔除掉
    if (_allPersionDicFromSqlite != nil) {
        NSArray *pKeys = [_allPersionDicFromSqlite allKeys];
        if ([pKeys containsObject:contactKey]) {
            NSMutableDictionary *modifyDic = [[NSMutableDictionary alloc] init];
            
            NSMutableDictionary *redundancyPerson = nil;
            // 查询出该联系人的冗余的信息
            if (_redundancyDic == nil) {
                [self queryRedundancyItemInContact];
            }
            if (_redundancyDic != nil) {
                NSArray *redundancyKeys = [_redundancyDic allKeys];
                if ([redundancyKeys containsObject:contactKey]) {
                    redundancyPerson = [_redundancyDic valueForKey:contactKey];
                }
            }
            
            if (redundancyPerson != nil) {
                // 得到联系人的详细信息
                NSMutableDictionary *personDic = [_allPersionDicFromSqlite valueForKey:contactKey];
                // 根据冗余段修改各段中的值
                NSArray *rdKeys = [redundancyPerson allKeys];
                NSArray *dKeys = [personDic allKeys];
                
                // 遍历每个联系人下面的Domain段（如com.apple.contacts.Email Address）
                for (NSString *rdKey in rdKeys) {
                    NSMutableArray *removeArray = [[ NSMutableArray alloc] init];
                    NSMutableDictionary *rdomainDic =[redundancyPerson valueForKey:rdKey];
                    if (![dKeys containsObject:rdKey]) {
                        continue;
                    }
                    NSMutableDictionary *domainDic = [personDic valueForKey:rdKey];
                    NSArray *riKeys = [rdomainDic allKeys];
                    NSArray *iKeys = [domainDic allKeys];
                    // 遍历Domin的下一级子项（如4/1/0的键值对象）
                    for (NSString *riKey in riKeys) {
                        // 得到键下面保存的具体数据（在这里是冗余的数据键）
                        NSArray *driArray = [rdomainDic valueForKey:riKey];
                        if (![iKeys containsObject:riKey]) {
                            continue;
                        }
                        // 依次去删除下面的keyValue下面对应的联系的的记录
                        for (NSString *keyValue in driArray) {
                            if ([removeArray containsObject:keyValue]) {
                                continue;
                            }
                            // 查找域字段是否包含该段,如果不包含,就跳过继续
                            if (![iKeys containsObject:keyValue]) {
                                continue;
                            }
                            // 清空冗余的键里面的内容
                            NSMutableDictionary *contentDic = [domainDic valueForKey:keyValue];
                            [contentDic removeAllObjects];
                            
                            // 操作完成后移出冗余数据下面的键
                            [rdomainDic removeObjectForKey:keyValue];
                            [removeArray addObject:keyValue];
                        }
                    }
                    [removeArray release];
                }
               
                [modifyDic setObject:personDic forKey:contactKey];
                [self openMobileSync];
//                [self modifyContact:modifyDic orgPersionDic:personDic];
                [self closeMobileSync];
            }
            
            [modifyDic release];
        }
    }
}

// 检查相似项的数据是否在主
- (BOOL)checkItemInMainDomain:(NSMutableDictionary*)item mainDomain:(NSMutableDictionary*)mainDomain domianName:(NSString*)domainName {
    BOOL isExsit = NO;
    if (mainDomain != nil) {
        if ([domainName isEqualToString:DOMAIN_STREET_ADDRESS]) {
            NSArray *vKeys = [item allKeys];
            NSString *country = nil;
            NSString *city = nil;
            NSString *countryCode = nil;
            NSString *state = nil;
            NSString *zip = nil;
            NSString *street = nil;
            if ([vKeys containsObject:ITEM_COUNTRY_KEY]) {
                country = [item valueForKey:ITEM_COUNTRY_KEY];
            } else {
                country = @"";
            }
            if ([vKeys containsObject:ITEM_CITY_KEY]) {
                city = [item valueForKey:ITEM_CITY_KEY];
            } else {
                city = @"";
            }
            if ([vKeys containsObject:ITEM_COUNTRY_CODE_KEY]) {
                countryCode = [item valueForKey:ITEM_COUNTRY_CODE_KEY];
            } else {
                countryCode = @"";
            }
            if ([vKeys containsObject:ITEM_STATE_KEY]) {
                state = [item valueForKey:ITEM_STATE_KEY];
            } else {
                state = @"";
            }
            if ([vKeys containsObject:ITEM_POSTAL_CODE_KEY]) {
                zip = [item valueForKey:ITEM_POSTAL_CODE_KEY];
            } else {
                zip = @"";
            }
            if ([vKeys containsObject:ITEM_STREET_KEY]) {
                street = [item valueForKey:ITEM_STREET_KEY];
            } else {
                street = @"";
            }
            
            NSArray *saKeys = [mainDomain allKeys];
            for (NSString *saKey in saKeys) {
                NSString *country1 = nil;
                NSString *city1 = nil;
                NSString *countryCode1 = nil;
                NSString *state1 = nil;
                NSString *zip1 = nil;
                NSString *street1 = nil;
                NSMutableDictionary *itemDic = [mainDomain valueForKey:saKey];
                vKeys = [itemDic allKeys];
                if ([vKeys containsObject:ITEM_COUNTRY_KEY]) {
                    country1 = [itemDic valueForKey:ITEM_COUNTRY_KEY];
                } else {
                    country1 = @"";
                }
                if ([vKeys containsObject:ITEM_CITY_KEY]) {
                    city1 = [itemDic valueForKey:ITEM_CITY_KEY];
                } else {
                    city1 = @"";
                }
                if ([vKeys containsObject:ITEM_COUNTRY_CODE_KEY]) {
                    countryCode1 = [itemDic valueForKey:ITEM_COUNTRY_CODE_KEY];
                } else {
                    countryCode1 = @"";
                }
                if ([vKeys containsObject:ITEM_STATE_KEY]) {
                    state1 = [itemDic valueForKey:ITEM_STATE_KEY];
                } else {
                    state1 = @"";
                }
                if ([vKeys containsObject:ITEM_POSTAL_CODE_KEY]) {
                    zip1 = [itemDic valueForKey:ITEM_POSTAL_CODE_KEY];
                } else {
                    zip1 = @"";
                }
                if ([vKeys containsObject:ITEM_STREET_KEY]) {
                    street1 = [itemDic valueForKey:ITEM_STREET_KEY];
                } else {
                    street1 = @"";
                }
                if ([country isEqualToString:country1] &&
                    [city isEqualToString:city1] &&
                    [countryCode isEqualToString:countryCode1] &&
                    [state isEqualToString:state1] &&
                    [zip isEqualToString:zip1] &&
                    [street isEqualToString:street1]) {
                    isExsit = YES;
                    break;
                }
            }
        } else if ([domainName isEqualToString:DOMAIN_IM]) {
            NSArray *vKeys = [item allKeys];
            NSString *service = nil;
            NSString *user = nil;
            if ([vKeys containsObject:ITEM_SERVICE_KEY]) {
                service = [item valueForKey:ITEM_SERVICE_KEY];
            } else {
                service = @"";
            }
            if ([vKeys containsObject:ITEM_USER_KEY]) {
                user = [item valueForKey:ITEM_USER_KEY];
            } else {
                user = @"";
            }
            
            NSArray *imKeys = [mainDomain allKeys];
            for (NSString *imKey in imKeys) {
                NSString *service1 = nil;
                NSString *user1 = nil;
                
                NSMutableDictionary *itemDic = [mainDomain valueForKey:imKey];
                vKeys = [itemDic allKeys];
                if ([vKeys containsObject:ITEM_SERVICE_KEY]) {
                    service1 = [itemDic valueForKey:ITEM_SERVICE_KEY];
                } else {
                    service1 = @"";
                }
                if ([vKeys containsObject:ITEM_USER_KEY]) {
                    user1 = [itemDic valueForKey:ITEM_USER_KEY];
                } else {
                    user1 = @"";
                }
                if ([service isEqualToString:service1] &&
                    [user isEqualToString:user1]) {
                    isExsit = YES;
                    break;
                }
            }
            
        } else if ([domainName isEqualToString:DOMAIN_URL]) {
            NSArray *vKeys = [item allKeys];
            NSString *service = nil;
            NSString *user = nil;
            if ([vKeys containsObject:ITEM_SERVICE_KEY]) {
                service = [item valueForKey:ITEM_SERVICE_KEY];
            } else {
                service = @"";
            }
            if ([vKeys containsObject:ITEM_USER_KEY]) {
                user = [item valueForKey:ITEM_USER_KEY];
            } else {
                user = @"";
            }
            
            NSArray *urlKeys = [mainDomain allKeys];
            for (NSString *urlKey in urlKeys) {
                NSString *service1 = nil;
                NSString *user1 = nil;
                
                NSMutableDictionary *itemDic = [mainDomain valueForKey:urlKey];
                vKeys = [itemDic allKeys];
                if ([vKeys containsObject:ITEM_SERVICE_KEY]) {
                    service1 = [itemDic valueForKey:ITEM_SERVICE_KEY];
                } else {
                    service1 = @"";
                }
                if ([vKeys containsObject:ITEM_USER_KEY]) {
                    user1 = [itemDic valueForKey:ITEM_USER_KEY];
                } else {
                    user1 = @"";
                }
                if ([service isEqualToString:service1] &&
                    [user isEqualToString:user1]) {
                    isExsit = YES;
                    break;
                }
            }
        } else {
            NSArray *vKeys = [item allKeys];
            NSString *value = nil;
            if ([vKeys containsObject:ITEM_VALUE_KEY]) {
                value = [item valueForKey:ITEM_VALUE_KEY];
            } else {
                value = @"";
            }
            
            NSArray *itemKeys = [mainDomain allKeys];
            for (NSString *itemKey in itemKeys) {
                NSString *value1 = nil;
                NSMutableDictionary *itemDic = [mainDomain valueForKey:itemKey];
                vKeys = [itemDic allKeys];
                if ([vKeys containsObject:ITEM_VALUE_KEY]) {
                    value1 = [itemDic valueForKey:ITEM_VALUE_KEY];
                } else {
                    value1 = @"";
                }
                if ([value isEqualTo:value1]) {
                    isExsit = YES;
                    break;
                }
            }
        }
    }
    return isExsit;
}

@end
