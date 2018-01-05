//
//  KeyBagType.m
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import "KeyBagType.h"

@implementation KeyBagType

NSString * const KeyBagTypeIdentifier(KeyBagTypeEnum keyBagType) {
    switch (keyBagType) {
        case SYSTEM:
            return @"System";
        case BACKUP:
            return @"Backup";
        case ESCROW:
            return @"Escrow";
        case OTA:
            return @"OTA (icloud)";
        default:
            return @"";
    }
}

@end
