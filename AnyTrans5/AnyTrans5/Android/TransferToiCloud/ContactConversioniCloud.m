//
//  ContactConversioniCloud.m
//  
//
//  Created by JGehry on 7/6/17.
//
//

#import "ContactConversioniCloud.h"
#import "IMBADContactEntity.h"
#import "IMBiCloudContactEntity.h"
#import "DateHelper.h"

@implementation ContactConversioniCloud
@synthesize conversionDict = _conversionDict;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [self setConversionDict:nil];
    [super dealloc];
#endif
}

- (instancetype)init
{
    if (self = [super init]) {
        _conversionDict = [[NSMutableDictionary alloc] init];
        _count = 0;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)conversionToiCloud:(id)entity {
    IMBADContactEntity *adContact = nil;
    IMBiCloudContactEntity *contact = [[IMBiCloudContactEntity alloc] init];
    if ([entity isMemberOfClass:[IMBADContactEntity class]]) {
        adContact = (IMBADContactEntity *)entity;
    }
    if (!adContact.contactName.value) {
        [contact setAllName:[adContact contactSortName]];
    }else {
        [contact setAllName:[[adContact contactName] value]];
    }
    if ([StringHelper stringIsNilOrEmpty:[[adContact contactFirstName] value]] && [StringHelper stringIsNilOrEmpty:[[adContact contactLastName] value]]) {
        [contact setLastName:contact.allName];
    }else {
        [contact setFirstName:[[adContact contactFirstName] value]];
        [contact setLastName:[[adContact contactLastName] value]];
    }
    [contact setMiddleName:[[adContact contactMiddleName] value]];
    [contact setPrefix:[[adContact contactPrefixName] value]];
    [contact setSuffix:[[adContact contactSuffixName] value]];
    [contact setNickname:[[adContact contactNickName] value]];
    [contact setCompanyName:[[adContact companyName] value]];
    [contact setJobTitle:[[adContact companyJob] value]];
    [contact setNotes:[[adContact contactNote] value]];
    [contact setImage:[adContact imageData]];
    for (IMBContactLabelValueEntity *phone in adContact.phoneData) {
        IMBContactKeyValueEntity *labelV = [[IMBContactKeyValueEntity alloc] init];
        [labelV setLabel:[phone lable]];
        [labelV setValue:[phone value]];
        [contact.phoneNumberArray addObject:labelV];
        [labelV release];
        labelV = nil;
    }
    for (IMBContactLabelValueEntity *email in adContact.emailData) {
        IMBContactKeyValueEntity *labelV = [[IMBContactKeyValueEntity alloc] init];
        [labelV setLabel:[email lable]];
        [labelV setValue:[email value]];
        [contact.emailAddressArray addObject:labelV];
        [labelV release];
        labelV = nil;
    }
    
    for (IMBContactLabelValueEntity *website in adContact.websiteData) {
        IMBContactKeyValueEntity *labelV = [[IMBContactKeyValueEntity alloc] init];
        [labelV setLabel:[website lable]];
        [labelV setValue:[website value]];
        [contact.urlArray addObject:labelV];
        [labelV release];
        labelV = nil;
    }
    
    for (IMBContactLabelValueEntity *im in adContact.imData) {
        IMBContactIMEntity *labelIM = [[IMBContactIMEntity alloc] init];
        [labelIM setLabel:[im lable]];
        [labelIM setService:[im lable]];
        [labelIM setUser:[im value]];
        [contact.IMArray addObject:labelIM];
        [labelIM release];
        labelIM = nil;
    }
    for (IMBContactLabelValueEntity *address in adContact.addressData) {
        IMBContactAddressEntity *labelV = [[IMBContactAddressEntity alloc] init];
        [labelV setLabel:[address lable]];
        [labelV setStreet:[address value]];
        [contact.addressArray addObject:labelV];
        [labelV release];
        labelV = nil;
    }
    for (IMBContactLabelValueEntity *relation in adContact.relationData) {
        IMBContactKeyValueEntity *labelV = [[IMBContactKeyValueEntity alloc] init];
        [labelV setLabel:[relation lable]];
        [labelV setValue:[relation value]];
        [contact.relatedNameArray addObject:labelV];
        [labelV release];
        labelV = nil;
    }
    for (IMBContactLabelValueEntity *event in adContact.eventData) {
        IMBContactKeyValueEntity *labelV = [[IMBContactKeyValueEntity alloc] init];
        [labelV setLabel:[event lable]];
        //时间戳，可能需要转换
        NSDate *date = [DateHelper dateFromString:event.value Formate:@"yyyy-MM-dd"];
        [labelV setValue:[NSString stringWithFormat:@"%f",[DateHelper getTimeIntervalSince2001:date]]];
        [contact.dateArray addObject:labelV];
        [labelV release];
        labelV = nil;
    }
    [_conversionDict setObject:contact forKey:[NSString stringWithFormat:@"%d", _count++]];
    [contact release];
    contact = nil;
}

@end
