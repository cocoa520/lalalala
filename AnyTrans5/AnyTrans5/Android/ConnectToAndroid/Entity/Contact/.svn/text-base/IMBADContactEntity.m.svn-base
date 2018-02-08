//
//  IMBContactEntity.m
//  
//
//  Created by JGehry on 2/17/17.
//
//

#import "IMBADContactEntity.h"
#import "IMBHelper.h"
@implementation IMBADContactEntity
@synthesize contactID = _contactID;
@synthesize contactName = _contactName;
@synthesize contactFirstName = _contactFirstName;
@synthesize contactLastName = _contactLastName;
@synthesize contactPrefixName = _contactPrefixName;
@synthesize contactMiddleName = _contactMiddleName;
@synthesize contactSuffixName = _contactSuffixName;
@synthesize contactNickName = _contactNickName;
@synthesize contactPhone = _contactPhone;
@synthesize contactEmail = _contactEmail;
@synthesize contactMembership = _contactMembership;
@synthesize contactIsDelete = _contactIsDelete;
@synthesize contactSortName = _contactSortName;
@synthesize imageData = _imageData;
@synthesize isImage = _isImage;
@synthesize structuredName = _structuredName;
@synthesize contactNote = _contactNote;
@synthesize phoneData = _phoneData;
@synthesize addressData = _addressData;
@synthesize emailData = _emailData;
@synthesize eventData = _eventData;
@synthesize imData = _imData;
@synthesize relationData = _relationData;
@synthesize websiteData = _websiteData;
@synthesize companyJob = _companyJob;
@synthesize companyName = _companyName;
@synthesize rawContactID = _rawContactID;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_phoneData != nil) {
        [_phoneData release];
        _phoneData = nil;
    }
    if (_emailData != nil) {
        [_emailData release];
        _emailData = nil;
    }
    if (_websiteData != nil) {
        [_websiteData release];
        _websiteData = nil;
    }
    if (_imData != nil) {
        [_imData release];
        _imData = nil;
    }
    if (_addressData != nil) {
        [_addressData release];
        _addressData = nil;
    }
    if (_eventData != nil) {
        [_eventData release];
        _eventData = nil;
    }
    if (_relationData != nil) {
        [_relationData release];
        _relationData = nil;
    }
    if (_contactName != nil) {
        [_contactName release];
        _contactName = nil;
    }
    if (_contactFirstName != nil) {
        [_contactFirstName release];
        _contactFirstName = nil;
    }
    if (_contactLastName != nil) {
        [_contactLastName release];
        _contactLastName = nil;
    }
    if (_contactPrefixName != nil) {
        [_contactPrefixName release];
        _contactPrefixName = nil;
    }
    if (_contactMiddleName != nil) {
        [_contactMiddleName release];
        _contactMiddleName = nil;
    }
    if (_contactSuffixName != nil) {
        [_contactSuffixName release];
        _contactSuffixName = nil;
    }
    if (_contactNickName != nil) {
        [_contactNickName release];
        _contactNickName = nil;
    }
    if (_contactPhone != nil) {
        [_contactPhone release];
        _contactPhone = nil;
    }
    if (_contactEmail != nil) {
        [_contactEmail release];
        _contactEmail = nil;
    }
    if (_contactMembership != nil) {
        [_contactMembership release];
        _contactMembership = nil;
    }
    if (_contactIsDelete != nil) {
        [_contactIsDelete release];
        _contactIsDelete = nil;
    }
    if (_imageData != nil) {
        [_imageData release];
        _imageData = nil;
    }
    if (_contactNote != nil) {
        [_contactNote release];
        _contactNote = nil;
    }
    if (_structuredName != nil) {
        [_structuredName release];
        _structuredName = nil;
    }
    if (_companyName != nil) {
        [_companyName release];
        _companyName = nil;
    }
    if (_companyJob != nil) {
        [_companyJob release];
        _companyJob = nil;
    }
    if (_contactSortName != nil) {
        [_contactSortName release];
        _contactSortName = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)init
{
    if (self = [super init]) {
        _phoneData = [[NSMutableArray alloc] init];
        _emailData = [[NSMutableArray alloc] init];
        _websiteData = [[NSMutableArray alloc] init];
        _imData = [[NSMutableArray alloc] init];
        _addressData = [[NSMutableArray alloc] init];
        _eventData = [[NSMutableArray alloc] init];
        _relationData = [[NSMutableArray alloc] init];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)setImageData:(NSData *)imageData {
    if (_imageData != nil) {
        [_imageData release];
        _imageData = nil;
    }
    _imageData = [imageData retain];
}

- (void)setContactSortName:(NSString *)contactSortName {
    if (_contactSortName != nil) {
        [_contactSortName release];
        _contactSortName = nil;
    }
    _contactSortName = [contactSortName retain];
}

- (void)unifiedArrangementName:(BOOL)isDelete {
    if (self.contactName != nil && ![IMBHelper stringIsNilOrEmpty:self.contactName.value]) {
        self.contactSortName = self.contactName.value;
        if (self.structuredName == nil) {
            self.structuredName = [[IMBContactLabelValueEntity alloc] init];
        }
        if ([IMBHelper stringIsNilOrEmpty:self.structuredName.value]) {
            self.structuredName.value = self.contactName.value;
        }
    }else {
        if (self.structuredName != nil && ![IMBHelper stringIsNilOrEmpty:self.structuredName.value]) {
            self.contactSortName = self.structuredName.value;
        }else {
            NSMutableString *nameStr = [NSMutableString string];
            if ((self.contactFirstName != nil && ![IMBHelper stringIsNilOrEmpty:self.contactFirstName.value]) || (self.contactMiddleName != nil && ![IMBHelper stringIsNilOrEmpty:self.contactMiddleName.value]) || (self.contactLastName != nil && ![IMBHelper stringIsNilOrEmpty:self.contactLastName.value])) {
                if (self.contactFirstName != nil && ![IMBHelper stringIsNilOrEmpty:self.contactFirstName.value]) {
                    [nameStr appendString:self.contactFirstName.value];
                }
                if (self.contactMiddleName != nil && ![IMBHelper stringIsNilOrEmpty:self.contactMiddleName.value]) {
                    [nameStr appendString:@" "];
                    [nameStr appendString:self.contactMiddleName.value];
                }
                if (self.contactLastName != nil && ![IMBHelper stringIsNilOrEmpty:self.contactLastName.value]) {
                    [nameStr appendString:@" "];
                    [nameStr appendString:self.contactLastName.value];
                }
            }else {
                if (self.contactPrefixName != nil && ![IMBHelper stringIsNilOrEmpty:self.contactPrefixName.value]) {
                    [nameStr appendString:self.contactPrefixName.value];
                }
                if (self.contactSuffixName != nil && ![IMBHelper stringIsNilOrEmpty:self.contactSuffixName.value]) {
                    [nameStr appendString:@" "];
                    [nameStr appendString:self.contactSuffixName.value];
                }
            }
            if (![IMBHelper stringIsNilOrEmpty:nameStr]) {
                self.contactSortName = nameStr;
            }
        }
    }
    if (isDelete) {
        if ([IMBHelper stringIsNilOrEmpty:self.contactSortName]) {
            self.contactSortName = CustomLocalizedString(@"Common_id_10", nil);
        }
    }
    self.sortStr = [StringHelper getSortString:self.contactSortName];
}

- (NSDictionary *)objectToDictionary:(IMBADContactEntity *)entity {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (entity.isDeleted) {
        if (entity.isHaveExistAndDeleted) {
            [dic setObject:[NSString stringWithFormat:@"%d",entity.rawContactID] forKey:@"rowContactId"];
            [dic setObject:[NSString stringWithFormat:@"%d",entity.contactID] forKey:@"id"];
        }else {
            [dic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"rowContactId"];
            [dic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"id"];
        }
    }
    if (entity.contactName != nil) {
        if (entity.contactName.value != nil) {
            NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
            [conDic setObject:[NSNumber numberWithBool:entity.contactName.isDeleted] forKey:@"isdelete"];
            [conDic setObject:entity.contactName.value forKey:@"value"];
            [dic setObject:conDic forKey:@"displayname"];
        }
    }
    if (entity.contactNote != nil) {
        if (entity.contactNote.value != nil) {
            NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
            [conDic setObject:[NSNumber numberWithBool:entity.contactNote.isDeleted] forKey:@"isdelete"];
            [conDic setObject:entity.contactNote.value forKey:@"value"];
            [dic setObject:conDic forKey:@"note"];
        }
    }
    if (entity.structuredName != nil) {
        if (entity.structuredName.value != nil) {
            NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
            [conDic setObject:[NSNumber numberWithBool:entity.structuredName.isDeleted] forKey:@"isdelete"];
            [conDic setObject:entity.structuredName.value forKey:@"value"];
            [dic setObject:conDic forKey:@"structuredname"];
        }
    }
    if (entity.contactNickName != nil) {
        if (entity.contactNickName.value != nil) {
            NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
            [conDic setObject:[NSNumber numberWithBool:entity.contactNickName.isDeleted] forKey:@"isdelete"];
            [conDic setObject:entity.contactNickName.value forKey:@"value"];
            [dic setObject:conDic forKey:@"nickname"];
        }
    }
    if (entity.contactMiddleName != nil) {
        if (entity.contactMiddleName.value != nil) {
            NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
            [conDic setObject:[NSNumber numberWithBool:entity.contactMiddleName.isDeleted] forKey:@"isdelete"];
            [conDic setObject:entity.contactMiddleName.value forKey:@"value"];
            [dic setObject:conDic forKey:@"middleName"];
        }
    }
    if (entity.contactSuffixName != nil) {
        if (entity.contactSuffixName.value != nil) {
            NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
            [conDic setObject:[NSNumber numberWithBool:entity.contactSuffixName.isDeleted] forKey:@"isdelete"];
            [conDic setObject:entity.contactSuffixName.value forKey:@"value"];
            [dic setObject:conDic forKey:@"namePostfix"];
        }
    }
    if (entity.contactPrefixName != nil) {
        if (entity.contactPrefixName.value != nil) {
            NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
            [conDic setObject:[NSNumber numberWithBool:entity.contactPrefixName.isDeleted] forKey:@"isdelete"];
            [conDic setObject:entity.contactPrefixName.value forKey:@"value"];
            [dic setObject:conDic forKey:@"namePrefix"];
        }
    }
    if (entity.contactFirstName != nil) {
        if (entity.contactFirstName.value != nil) {
            NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
            [conDic setObject:[NSNumber numberWithBool:entity.contactFirstName.isDeleted] forKey:@"isdelete"];
            [conDic setObject:entity.contactFirstName.value forKey:@"value"];
            [dic setObject:conDic forKey:@"firstName"];
        }
    }
    if (entity.contactLastName != nil) {
        if (entity.contactLastName.value != nil) {
            NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
            [conDic setObject:[NSNumber numberWithBool:entity.contactLastName.isDeleted] forKey:@"isdelete"];
            [conDic setObject:entity.contactLastName.value forKey:@"value"];
            [dic setObject:conDic forKey:@"lastName"];
        }
    }
    if (entity.companyName != nil) {
        if (entity.companyName.value != nil) {
            NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
            [conDic setObject:[NSNumber numberWithBool:entity.companyName.isDeleted] forKey:@"isdelete"];
            [conDic setObject:entity.companyName.value forKey:@"value"];
            [dic setObject:conDic forKey:@"companyName"];
        }
    }
    if (entity.companyJob != nil) {
        if (entity.companyJob.value != nil) {
            NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
            [conDic setObject:[NSNumber numberWithBool:entity.companyJob.isDeleted] forKey:@"isdelete"];
            [conDic setObject:entity.companyJob.value forKey:@"value"];
            [dic setObject:conDic forKey:@"companyJob"];
        }
    }

    [dic setObject:[NSNumber numberWithBool:entity.isImage] forKey:@"isImage"];
    
    if (entity.phoneData.count > 0) {
        NSMutableArray *phonArr = [NSMutableArray array];
        for (IMBContactLabelValueEntity *labelEntity in entity.phoneData) {
            NSMutableDictionary *labelDic = [NSMutableDictionary dictionary];
            if (labelEntity.lable != nil) {
                [labelDic setObject:labelEntity.lable forKey:@"lable"];
            }
            if (labelEntity.value != nil) {
                [labelDic setObject:labelEntity.value forKey:@"value"];
            }
            [labelDic setObject:[NSNumber numberWithBool:labelEntity.isDeleted] forKey:@"isdelete"];
            [labelDic setObject:[NSString stringWithFormat:@"%d",labelEntity.lacleType] forKey:@"labletype"];
            [phonArr addObject:labelDic];
        }
        [dic setObject:phonArr forKey:@"phoneData"];
    }
    if (entity.emailData.count > 0) {
        NSMutableArray *emailArr = [NSMutableArray array];
        for (IMBContactLabelValueEntity *labelEntity in entity.emailData) {
            NSMutableDictionary *labelDic = [NSMutableDictionary dictionary];
            if (labelEntity.lable != nil) {
                [labelDic setObject:labelEntity.lable forKey:@"lable"];
            }
            if (labelEntity.value != nil) {
                [labelDic setObject:labelEntity.value forKey:@"value"];
            }
            [labelDic setObject:[NSNumber numberWithBool:labelEntity.isDeleted] forKey:@"isdelete"];
            [labelDic setObject:[NSString stringWithFormat:@"%d",labelEntity.lacleType] forKey:@"labletype"];
            [emailArr addObject:labelDic];
        }
        [dic setObject:emailArr forKey:@"emailData"];
    }
    if (entity.websiteData.count > 0) {
        NSMutableArray *webArr = [NSMutableArray array];
        for (IMBContactLabelValueEntity *labelEntity in entity.websiteData) {
            NSMutableDictionary *labelDic = [NSMutableDictionary dictionary];
            if (labelEntity.value != nil) {
                [labelDic setObject:labelEntity.value forKey:@"value"];
            }
            [labelDic setObject:[NSNumber numberWithBool:labelEntity.isDeleted] forKey:@"isdelete"];
            [webArr addObject:labelDic];
        }
        [dic setObject:webArr forKey:@"websiteData"];
    }
    if (entity.imData.count > 0) {
        NSMutableArray *imArr = [NSMutableArray array];
        for (IMBContactLabelValueEntity *labelEntity in entity.imData) {
            NSMutableDictionary *labelDic = [NSMutableDictionary dictionary];
            if (labelEntity.lable != nil) {
                [labelDic setObject:labelEntity.lable forKey:@"lable"];
            }
            if (labelEntity.value != nil) {
                [labelDic setObject:labelEntity.value forKey:@"value"];
            }
            [labelDic setObject:[NSNumber numberWithBool:labelEntity.isDeleted] forKey:@"isdelete"];
            [labelDic setObject:[NSString stringWithFormat:@"%d",labelEntity.lacleType] forKey:@"labletype"];
            [imArr addObject:labelDic];
        }
        [dic setObject:imArr forKey:@"imData"];
    }
    if (entity.addressData.count > 0) {
        NSMutableArray *addressArr = [NSMutableArray array];
        for (IMBContactLabelValueEntity *labelEntity in entity.addressData) {
            NSMutableDictionary *labelDic = [NSMutableDictionary dictionary];
            if (labelEntity.lable != nil) {
                [labelDic setObject:labelEntity.lable forKey:@"lable"];
            }
            if (labelEntity.value != nil) {
                [labelDic setObject:labelEntity.value forKey:@"value"];
            }
            [labelDic setObject:[NSNumber numberWithBool:labelEntity.isDeleted] forKey:@"isdelete"];
            [labelDic setObject:[NSString stringWithFormat:@"%d",labelEntity.lacleType] forKey:@"labletype"];
            [addressArr addObject:labelDic];
        }
        [dic setObject:addressArr forKey:@"addressData"];
    }
    if (entity.eventData.count > 0) {
        NSMutableArray *eventArr = [NSMutableArray array];
        for (IMBContactLabelValueEntity *labelEntity in entity.eventData) {
            NSMutableDictionary *labelDic = [NSMutableDictionary dictionary];
            if (labelEntity.lable != nil) {
                [labelDic setObject:labelEntity.lable forKey:@"lable"];
            }
            if (labelEntity.value != nil) {
                [labelDic setObject:labelEntity.value forKey:@"value"];
            }
            [labelDic setObject:[NSNumber numberWithBool:labelEntity.isDeleted] forKey:@"isdelete"];
            [labelDic setObject:[NSString stringWithFormat:@"%d",labelEntity.lacleType] forKey:@"labletype"];
            [eventArr addObject:labelDic];
        }
        [dic setObject:eventArr forKey:@"eventData"];
    }
    if (entity.relationData.count > 0) {
        NSMutableArray *relationArr = [NSMutableArray array];
        for (IMBContactLabelValueEntity *labelEntity in entity.relationData) {
            NSMutableDictionary *labelDic = [NSMutableDictionary dictionary];
            if (labelEntity.lable != nil) {
                [labelDic setObject:labelEntity.lable forKey:@"lable"];
            }
            if (labelEntity.value != nil) {
                [labelDic setObject:labelEntity.value forKey:@"value"];
            }
            [labelDic setObject:[NSNumber numberWithBool:labelEntity.isDeleted] forKey:@"isdelete"];
            [labelDic setObject:[NSString stringWithFormat:@"%d",labelEntity.lacleType] forKey:@"labletype"];
            [relationArr addObject:labelDic];
        }
        [dic setObject:relationArr forKey:@"relationData"];
    }
    
    return dic;
}

- (void)dictionaryToObject:(NSDictionary *)msgDic {
    if ([msgDic.allKeys containsObject:@"id"]) {
        self.contactID = [[msgDic objectForKey:@"id"] intValue];
    }if ([msgDic.allKeys containsObject:@"rowContactId"]) {
        self.rawContactID = [[msgDic objectForKey:@"rowContactId"] intValue];
    }
    if ([msgDic.allKeys containsObject:@"displayname"]) {
        self.contactName = [[IMBContactLabelValueEntity alloc] init];
        NSDictionary *retDic = [msgDic objectForKey:@"displayname"];
        if ([retDic.allKeys containsObject:@"value"]) {
            self.contactName.value = [retDic objectForKey:@"value"];
        }
    }
    if ([msgDic.allKeys containsObject:@"note"]) {
        self.contactNote = [[IMBContactLabelValueEntity alloc] init];
        NSDictionary *retDic = [msgDic objectForKey:@"note"];
        if ([retDic.allKeys containsObject:@"value"]) {
            self.contactNote.value = [retDic objectForKey:@"value"];
        }
    }
    if ([msgDic.allKeys containsObject:@"structuredname"]) {
        self.structuredName = [[IMBContactLabelValueEntity alloc] init];
        NSDictionary *retDic = [msgDic objectForKey:@"structuredname"];
        if ([retDic.allKeys containsObject:@"value"]) {
            self.structuredName.value = [retDic objectForKey:@"value"];
        }
    }
    if ([msgDic.allKeys containsObject:@"nickname"]) {
        self.contactNickName = [[IMBContactLabelValueEntity alloc] init];
        NSDictionary *retDic = [msgDic objectForKey:@"nickname"];
        if ([retDic.allKeys containsObject:@"value"]) {
            self.contactNickName.value = [retDic objectForKey:@"value"];
        }
    }
    if ([msgDic.allKeys containsObject:@"middleName"]) {
        self.contactMiddleName = [[IMBContactLabelValueEntity alloc] init];
        NSDictionary *retDic = [msgDic objectForKey:@"middleName"];
        if ([retDic.allKeys containsObject:@"value"]) {
            self.contactMiddleName.value = [retDic objectForKey:@"value"];
        }
    }
    if ([msgDic.allKeys containsObject:@"namePostfix"]) {
        self.contactSuffixName = [[IMBContactLabelValueEntity alloc] init];
        NSDictionary *retDic = [msgDic objectForKey:@"namePostfix"];
        if ([retDic.allKeys containsObject:@"value"]) {
            self.contactSuffixName.value = [retDic objectForKey:@"value"];
        }
    }
    if ([msgDic.allKeys containsObject:@"namePrefix"]) {
        self.contactPrefixName = [[IMBContactLabelValueEntity alloc] init];
        NSDictionary *retDic = [msgDic objectForKey:@"namePrefix"];
        if ([retDic.allKeys containsObject:@"value"]) {
            self.contactPrefixName.value = [retDic objectForKey:@"value"];
        }
    }
    if ([msgDic.allKeys containsObject:@"firstName"]) {
        self.contactFirstName = [[IMBContactLabelValueEntity alloc] init];
        NSDictionary *retDic = [msgDic objectForKey:@"firstName"];
        if ([retDic.allKeys containsObject:@"value"]) {
            self.contactFirstName.value = [retDic objectForKey:@"value"];
        }
    }
    if ([msgDic.allKeys containsObject:@"lastName"]) {
        self.contactLastName = [[IMBContactLabelValueEntity alloc] init];
        NSDictionary *retDic = [msgDic objectForKey:@"lastName"];
        if ([retDic.allKeys containsObject:@"value"]) {
            self.contactLastName.value = [retDic objectForKey:@"value"];
        }
    }
    if ([msgDic.allKeys containsObject:@"isImage"]) {
        self.isImage = [[msgDic objectForKey:@"isImage"] boolValue];
    }
    if ([msgDic.allKeys containsObject:@"companyName"]) {
        self.companyName = [[IMBContactLabelValueEntity alloc] init];
        NSDictionary *retDic = [msgDic objectForKey:@"companyName"];
        if ([retDic.allKeys containsObject:@"value"]) {
            self.companyName.value = [retDic objectForKey:@"value"];
        }
    }
    if ([msgDic.allKeys containsObject:@"companyJob"]) {
        self.companyJob = [[IMBContactLabelValueEntity alloc] init];
        NSDictionary *retDic = [msgDic objectForKey:@"companyJob"];
        if ([retDic.allKeys containsObject:@"value"]) {
            self.companyJob.value = [retDic objectForKey:@"value"];
        }
    }
    [self unifiedArrangementName:NO];
    if ([msgDic.allKeys containsObject:@"phoneData"]) {
        NSArray *phoneArr = [msgDic objectForKey:@"phoneData"];
        for (NSDictionary *dic in phoneArr) {
            IMBContactLabelValueEntity *entity = [[IMBContactLabelValueEntity alloc] init];
            if ([dic.allKeys containsObject:@"lable"]) {
                entity.lable = [dic objectForKey:@"lable"];
            }else {
                entity.lable = CustomLocalizedString(@"contactLable_phone", nil);
            }
            if ([dic.allKeys containsObject:@"value"]) {
                entity.value = [dic objectForKey:@"value"];
            }
            if ([dic.allKeys containsObject:@"labletype"]) {
                entity.lacleType = [[dic objectForKey:@"labletype"] intValue];
            }
            [self.phoneData addObject:entity];
            [entity release];
        }
    }
    if ([msgDic.allKeys containsObject:@"emailData"]) {
        NSArray *emailArr = [msgDic objectForKey:@"emailData"];
        for (NSDictionary *dic in emailArr) {
            IMBContactLabelValueEntity *entity = [[IMBContactLabelValueEntity alloc] init];
            if ([dic.allKeys containsObject:@"lable"]) {
                entity.lable = [dic objectForKey:@"lable"];
            }else {
                entity.lable = CustomLocalizedString(@"contactLable_email", nil);
            }
            if ([dic.allKeys containsObject:@"value"]) {
                entity.value = [dic objectForKey:@"value"];
            }
            if ([dic.allKeys containsObject:@"labletype"]) {
                entity.lacleType = [[dic objectForKey:@"labletype"] intValue];
            }
            [self.emailData addObject:entity];
            [entity release];
        }
    }
    if ([msgDic.allKeys containsObject:@"websiteData"]) {
        NSArray *websiteArr = [msgDic objectForKey:@"websiteData"];
        if (websiteArr != nil) {
            for (NSDictionary *dic in websiteArr) {
                IMBContactLabelValueEntity *entity = [[IMBContactLabelValueEntity alloc] init];
                if ([dic.allKeys containsObject:@"value"]) {
                    entity.value = [dic objectForKey:@"value"];
                }
                entity.lable = CustomLocalizedString(@"contactLable_website", nil);
                [self.websiteData addObject:entity];
                [entity release];
            }
        }
    }
    if ([msgDic.allKeys containsObject:@"imData"]) {
        NSArray *imArr = [msgDic objectForKey:@"imData"];
        for (NSDictionary *dic in imArr) {
            IMBContactLabelValueEntity *entity = [[IMBContactLabelValueEntity alloc] init];
            if ([dic.allKeys containsObject:@"lable"]) {
                entity.lable = [dic objectForKey:@"lable"];
            }else {
                entity.lable = CustomLocalizedString(@"contactLable_im", nil);
            }
            if ([dic.allKeys containsObject:@"value"]) {
                entity.value = [dic objectForKey:@"value"];
            }
            if ([dic.allKeys containsObject:@"labletype"]) {
                entity.lacleType = [[dic objectForKey:@"labletype"] intValue];
            }
            [self.imData addObject:entity];
            [entity release];
        }
    }
    if ([msgDic.allKeys containsObject:@"addressData"]) {
        NSArray *addressArr = [msgDic objectForKey:@"addressData"];
        for (NSDictionary *dic in addressArr) {
            IMBContactLabelValueEntity *entity = [[IMBContactLabelValueEntity alloc] init];
            if ([dic.allKeys containsObject:@"lable"]) {
                entity.lable = [dic objectForKey:@"lable"];
            }else {
                entity.lable = CustomLocalizedString(@"contactLable_postaddress", nil);
            }
            if ([dic.allKeys containsObject:@"value"]) {
                entity.value = [dic objectForKey:@"value"];
            }
            if ([dic.allKeys containsObject:@"labletype"]) {
                entity.lacleType = [[dic objectForKey:@"labletype"] intValue];
            }
            [self.addressData addObject:entity];
            [entity release];
        }
    }
    if ([msgDic.allKeys containsObject:@"eventData"]) {
        NSArray *eventArr = [msgDic objectForKey:@"eventData"];
        for (NSDictionary *dic in eventArr) {
            IMBContactLabelValueEntity *entity = [[IMBContactLabelValueEntity alloc] init];
            if ([dic.allKeys containsObject:@"lable"]) {
                entity.lable = [dic objectForKey:@"lable"];
            }else {
                entity.lable = CustomLocalizedString(@"contactLable_event", nil);
            }
            if ([dic.allKeys containsObject:@"value"]) {
                entity.value = [dic objectForKey:@"value"];
            }
            if ([dic.allKeys containsObject:@"labletype"]) {
                entity.lacleType = [[dic objectForKey:@"labletype"] intValue];
            }
            [self.eventData addObject:entity];
            [entity release];
        }
    }
    if ([msgDic.allKeys containsObject:@"relationData"]) {
        NSArray *relationArr = [msgDic objectForKey:@"relationData"];
        for (NSDictionary *dic in relationArr) {
            IMBContactLabelValueEntity *entity = [[IMBContactLabelValueEntity alloc] init];
            if ([dic.allKeys containsObject:@"lable"]) {
                entity.lable = [dic objectForKey:@"lable"];
            }else {
                entity.lable = CustomLocalizedString(@"contactLable_relation", nil);
            }
            if ([dic.allKeys containsObject:@"value"]) {
                entity.value = [dic objectForKey:@"value"];
            }
            if ([dic.allKeys containsObject:@"labletype"]) {
                entity.lacleType = [[dic objectForKey:@"labletype"] intValue];
            }
            [self.relationData addObject:entity];
            [entity release];
        }
    }
}

@end

@implementation IMBContactLabelValueEntity
@synthesize lable = _lable;
@synthesize value = _value;
@synthesize lacleType = _lacleType;

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc
{
    if (_lable != nil) {
        [_lable release];
        _lable = nil;
    }
    if (_value != nil) {
        [_value release];
        _value = nil;
    }
    [super dealloc];
}

- (void)setLable:(NSString *)lable {
    if (_lable != nil) {
        [_lable release];
        _lable = nil;
    }
    _lable = [lable retain];
}

- (void)setValue:(NSString *)value {
    if (_value != nil) {
        [_value release];
        _value = nil;
    }
    _value = [value retain];
}

@end

@implementation IMBContactMimeTypeEntity
@synthesize cid = _cid;
@synthesize type = _type;

@end
