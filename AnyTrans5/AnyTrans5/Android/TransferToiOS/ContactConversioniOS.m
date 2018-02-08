//
//  ContactConversioniOS.m
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "ContactConversioniOS.h"
#import "IMBADContactEntity.h"
#import "IMBAddressBookDataEntity.h"
#import "DateHelper.h"
#import "IMBContactEntity.h"
#import "NSString+Category.h"
@implementation ContactConversioniOS
- (id)dataConversion:(id)entity
{
    return [self conversionContactEntity:entity];
}

- (id)conversionContactEntity:(id)entity
{
    IMBADContactEntity *adContact = (IMBADContactEntity *)entity;
    IMBContactEntity *contact = [[IMBContactEntity alloc] init];
    if (adContact.contactName.value == nil) {
        contact.allName = adContact.contactSortName;
    }else{
        contact.allName = adContact.contactName.value;
    }
    contact.image = adContact.imageData;
    contact.firstName = adContact.contactFirstName.value;
    contact.middleName = adContact.contactMiddleName.value;
    contact.lastName = adContact.contactLastName.value;
    contact.suffix = adContact.contactSuffixName.value;
    contact.title = adContact.contactPrefixName.value; //title表示前缀
    contact.nickname = adContact.contactNickName.value;
    contact.companyName = adContact.companyName.value;
    contact.jobTitle = adContact.companyJob.value;
    contact.notes = adContact.contactNote.value;
    if (contact.firstName.length==0 && contact.firstName.length==0 &&contact.firstName.length==0) {
        contact.firstName = adContact.contactSortName;
    }
    int entityID = 0;
    for (IMBContactLabelValueEntity *phone in adContact.phoneData) {
        IMBContactKeyValueEntity *labelV = [[IMBContactKeyValueEntity alloc] init];
        labelV.entityID = @(entityID);
        entityID++;
        labelV.contactCategory = Contact_PhoneNumber;
        labelV.label = phone.lable;
        labelV.value = phone.value;
        [contact.phoneNumberArray addObject:labelV];
        [labelV release];
    }
    entityID = 0;
    for (IMBContactLabelValueEntity *email in adContact.emailData) {
        IMBContactKeyValueEntity *labelV = [[IMBContactKeyValueEntity alloc] init];
        labelV.entityID = @(entityID);
        entityID++;
        labelV.contactCategory = Contact_EmailAddressNumber;
        labelV.label = email.lable;
        labelV.value = email.value;
        [contact.emailAddressArray addObject:labelV];
        [labelV release];
    }
    entityID = 0;
    for (IMBContactLabelValueEntity *website in adContact.websiteData) {
        IMBContactKeyValueEntity *labelV = [[IMBContactKeyValueEntity alloc] init];
        labelV.entityID = @(entityID);
        entityID++;
        labelV.contactCategory = Contact_URL;
        labelV.label = website.lable;
        labelV.value = website.value;
        [contact.urlArray addObject:labelV];
        [labelV release];
    }
    entityID = 0;
    for (IMBContactLabelValueEntity *im in adContact.imData) {
        IMBContactIMEntity *labelV = [[IMBContactIMEntity alloc] init];
        labelV.entityID = @(entityID);
        entityID++;
        labelV.contactCategory = Contact_IM;
        labelV.label = @"other";
        labelV.service = im.lable;
        labelV.user = im.value;
        [contact.IMArray addObject:labelV];
        [labelV release];
    }
    entityID = 0;
    for (IMBContactLabelValueEntity *address in adContact.addressData) {
        IMBContactAddressEntity *labelV = [[IMBContactAddressEntity alloc] init];
        labelV.entityID = @(entityID);
        entityID++;
        labelV.contactCategory = Contact_StreetAddress;
        labelV.label = address.lable;
        labelV.street = address.value;
        [contact.addressArray addObject:labelV];
        [labelV release];
    }
    entityID = 0;
    for (IMBContactLabelValueEntity *relation in adContact.relationData) {
        IMBContactKeyValueEntity *labelV = [[IMBContactKeyValueEntity alloc] init];
        labelV.entityID = @(entityID);
        entityID++;
        labelV.contactCategory = Contact_RelatedName;
        labelV.label = relation.lable;
        labelV.value = relation.value;
        [contact.relatedNameArray addObject:labelV];
        [labelV release];
    }
    entityID = 0;
    for (IMBContactLabelValueEntity *event in adContact.eventData) {
        IMBContactKeyValueEntity *labelV = [[IMBContactKeyValueEntity alloc] init];
        labelV.entityID = @(entityID);
        entityID++;
        labelV.contactCategory = Contact_Date;
        labelV.label = event.lable;
        //NSDate类型，需要转换
        NSDate *date = nil;
        NSString *dataStr = event.value;
        if ([dataStr contains:@"-"]) {
            date = [DateHelper getNowDateFromatAnDate:[DateHelper dateFromString:event.value Formate:@"yyyy-MM-dd"]];
        }else{
            date = [DateHelper getNowDateFromatAnDate:[DateHelper dateFromString:event.value Formate:@"yyyyMMdd"]];
        }
        labelV.value =  date;
        [contact.dateArray addObject:labelV];
        [labelV release];
    }
    return [contact autorelease];
}


@end
