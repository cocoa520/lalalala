//
//  PKIXNameConstraintValidator.m
//  crypto
//
//  Created by JGehry on 7/11/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKIXNameConstraintValidator.h"
#import "DERIA5String.h"
#import "X500Name.h"
#import "ASN1OctetString.h"
#import "ASN1Sequence.h"
#import "Arrays.h"

@interface PKIXNameConstraintValidator ()

@property (nonatomic, readwrite, retain) NSSet *excludedSubtreesDN;
@property (nonatomic, readwrite, retain) NSSet *excludedSubtreesDNS;
@property (nonatomic, readwrite, retain) NSSet *excludedSubtreesEmail;
@property (nonatomic, readwrite, retain) NSSet *excludedSubtreesURI;
@property (nonatomic, readwrite, retain) NSSet *excludedSubtreesIP;
@property (nonatomic, readwrite, retain) NSSet *permittedSubtreesDN;
@property (nonatomic, readwrite, retain) NSSet *permittedSubtreesDNS;
@property (nonatomic, readwrite, retain) NSSet *permittedSubtreesEmail;
@property (nonatomic, readwrite, retain) NSSet *permittedSubtreesURI;
@property (nonatomic, readwrite, retain) NSSet *permittedSubtreesIP;

@end

@implementation PKIXNameConstraintValidator
@synthesize excludedSubtreesDN = _excludedSubtreesDN;
@synthesize excludedSubtreesDNS = _excludedSubtreesDNS;
@synthesize excludedSubtreesEmail = _excludedSubtreesEmail;
@synthesize excludedSubtreesURI = _excludedSubtreesURI;
@synthesize excludedSubtreesIP = _excludedSubtreesIP;
@synthesize permittedSubtreesDN = _permittedSubtreesDN;
@synthesize permittedSubtreesDNS = _permittedSubtreesDNS;
@synthesize permittedSubtreesEmail = _permittedSubtreesEmail;
@synthesize permittedSubtreesURI = _permittedSubtreesURI;
@synthesize permittedSubtreesIP = _permittedSubtreesIP;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_excludedSubtreesDN) {
        [_excludedSubtreesDN release];
        _excludedSubtreesDN = nil;
    }
    if (_excludedSubtreesDNS) {
        [_excludedSubtreesDNS release];
        _excludedSubtreesDNS = nil;
    }
    if (_excludedSubtreesEmail) {
        [_excludedSubtreesEmail release];
        _excludedSubtreesEmail = nil;
    }
    if (_excludedSubtreesURI) {
        [_excludedSubtreesURI release];
        _excludedSubtreesURI = nil;
    }
    if (_excludedSubtreesIP) {
        [_excludedSubtreesIP release];
        _excludedSubtreesIP = nil;
    }
    if (_permittedSubtreesDN) {
        [_permittedSubtreesDN release];
        _permittedSubtreesDN = nil;
    }
    if (_permittedSubtreesDNS) {
        [_permittedSubtreesDNS release];
        _permittedSubtreesDNS = nil;
    }
    if (_permittedSubtreesEmail) {
        [_permittedSubtreesEmail release];
        _permittedSubtreesEmail = nil;
    }
    if (_permittedSubtreesURI) {
        [_permittedSubtreesURI release];
        _permittedSubtreesURI = nil;
    }
    if (_permittedSubtreesIP) {
        [_permittedSubtreesIP release];
        _permittedSubtreesIP = nil;
    }
    [super dealloc];
#endif
}

+ (BOOL)withinDNSubtree:(ASN1Sequence *)paramASN1Sequence1 paramASN1Sequence2:(ASN1Sequence *)paramASN1Sequence2 {
    if ([paramASN1Sequence1 size] < 1) {
        return NO;
    }
    if ([paramASN1Sequence2 size] > [paramASN1Sequence1 size]) {
        return NO;
    }
    for (int i = (int)[paramASN1Sequence2 size] - 1; i >= 0; i--) {
        if (![[paramASN1Sequence2 getObjectAt:i] isEqual:[paramASN1Sequence1 getObjectAt:i]]) {
            return NO;
        }
    }
    return YES;
}

+ (NSString *)extractHostFromURL:(NSString *)paramString {
    NSString *str = nil;
    return str;
}

+ (NSMutableData *)max:(NSMutableData *)paramArrayOfByte1 paramArrayOfByte2:(NSMutableData *)paramArrayOfByte2 {
    for (int i = 0; i < paramArrayOfByte1.length; i++) {
        if ((((Byte *)[paramArrayOfByte1 bytes])[i] & 0xFFFF) > (((Byte *)[paramArrayOfByte2 bytes])[i] & 0xFFFF)) {
            return paramArrayOfByte1;
        }
    }
    return paramArrayOfByte2;
}

+ (NSMutableData *)min:(NSMutableData *)paramArrayOfByte1 paramArrayOfByte2:(NSMutableData *)paramArrayOfByte2 {
    for (int i = 0; i < paramArrayOfByte1.length; i++) {
        if ((((Byte *)[paramArrayOfByte1 bytes])[i] & 0xFFFF) < (((Byte *)[paramArrayOfByte2 bytes])[i] & 0xFFFF)) {
            return paramArrayOfByte1;
        }
    }
    return paramArrayOfByte2;
}

+ (int)compareTo:(NSMutableData *)paramArrayOfByte1 paramArrayOfByte2:(NSMutableData *)paramArrayOfByte2 {
    if ([Arrays areEqualWithByteArray:paramArrayOfByte1 withB:paramArrayOfByte2]) {
        return 0;
    }
    if ([Arrays areEqualWithByteArray:[PKIXNameConstraintValidator max:paramArrayOfByte1 paramArrayOfByte2:paramArrayOfByte2] withB:paramArrayOfByte1]) {
        return 1;
    }
    return -1;
}

+ (NSMutableData *)or:(NSMutableData *)paramArrayOfByte1 paramArrayOfByte2:(NSMutableData *)paramArrayOfByte2 {
    NSMutableData *arrayOfByte = [[[NSMutableData alloc] initWithSize:(int)[paramArrayOfByte1 length]] autorelease];
    for (int i = 0; i < [paramArrayOfByte1 length]; i++) {
        ((Byte *)[arrayOfByte bytes])[i] = (((Byte *)[paramArrayOfByte1 bytes])[i] | ((Byte *)[paramArrayOfByte2 bytes])[i]);
    }
    return arrayOfByte;
}

- (void)checkPermitted:(GeneralName *)paramGeneralName {
    switch ([paramGeneralName getTagNo]) {
        case 1:
            [self checkPermittedEmail:self.permittedSubtreesEmail paramString:[self extractNameAsString:paramGeneralName]];
            break;
        case 2:
            [self checkPermittedDNS:self.permittedSubtreesDNS paramString:[[DERIA5String getInstance:[paramGeneralName getName]] getString]];
            break;
        case 4:
            [self checkPermittedDN:[X500Name getInstance:[paramGeneralName getName]]];
            break;
        case 6:
            [self checkPermittedURI:self.permittedSubtreesURI paramString:[[DERIA5String getInstance:[paramGeneralName getName]] getString]];
            break;
        case 7: {
            NSMutableData *arrayOfByte = [[ASN1OctetString getInstance:[paramGeneralName getName]] getOctets];
            [self checkPermittedIP:self.permittedSubtreesIP paramArrayOfByte:arrayOfByte];
        }
        default:
            break;
    }
}

- (void)checkExcluded:(GeneralName *)paramGeneralName {
    switch ([paramGeneralName getTagNo]) {
        case 1:
            [self checkExcludedEmail:self.excludedSubtreesEmail paramString:[self extractNameAsString:paramGeneralName]];
            break;
        case 2:
            [self checkExcludedDNS:self.excludedSubtreesDNS paramString:[[DERIA5String getInstance:[paramGeneralName getName]] getString]];
            break;
        case 4:
            [self checkExcludedDN:[X500Name getInstance:[paramGeneralName getName]]];
            break;
        case 6:
            [self checkExcludedURI:self.excludedSubtreesURI paramString:[[DERIA5String getInstance:[paramGeneralName getName]] getString]];
            break;
        case 7: {
            NSMutableData *arrayOfByte = [[ASN1OctetString getInstance:[paramGeneralName getName]] getOctets];
            [self checkExcludedIP:self.excludedSubtreesIP paramArrayOfByte:arrayOfByte];
        }
        default:
            break;
    }
}

- (void)intersectPermittedSubtree:(GeneralSubtree *)paramGeneralSubtree {
    NSMutableArray *tmpAry = [[NSMutableArray alloc] initWithObjects:paramGeneralSubtree, nil];
    [self intersectPermittedSubtreeArrayOf:tmpAry];
#if !__has_feature(objc_arc)
    if (tmpAry) [tmpAry release]; tmpAry = nil;
#endif
}

- (void)intersectPermittedSubtreeArrayOf:(NSMutableArray *)paramArrayOfGeneralSubtree {
    NSMutableDictionary *localHashMap = [[NSMutableDictionary alloc] init];
    id localObject;
    for (int i = 0; i != paramArrayOfGeneralSubtree.count; i++) {
        localObject = paramArrayOfGeneralSubtree[i];
    }
}

- (void)intersectEmptyPermittedSubtree:(int)paramInt {
    switch (paramInt) {
        case 1: {
            NSMutableSet *emailSet = [[NSMutableSet alloc] init];
            self.permittedSubtreesEmail = emailSet;
#if !__has_feature(objc_arc)
    if (emailSet) [emailSet release]; emailSet = nil;
#endif
        }
            break;
        case 2: {
            NSMutableSet *dnsSet = [[NSMutableSet alloc] init];
            self.permittedSubtreesDNS = dnsSet;
#if !__has_feature(objc_arc)
            if (dnsSet) [dnsSet release]; dnsSet = nil;
#endif
        }
            break;
        case 4: {
            NSMutableSet *dnSet = [[NSMutableSet alloc] init];
            self.permittedSubtreesDN = dnSet;
#if !__has_feature(objc_arc)
            if (dnSet) [dnSet release]; dnSet = nil;
#endif
        }
            break;
        case 6: {
            NSMutableSet *urlSet = [[NSMutableSet alloc] init];
            self.permittedSubtreesURI = urlSet;
#if !__has_feature(objc_arc)
            if (urlSet) [urlSet release]; urlSet = nil;
#endif
        }
            break;
        case 7: {
            NSMutableSet *ipSet = [[NSMutableSet alloc] init];
            self.permittedSubtreesIP = ipSet;
#if !__has_feature(objc_arc)
            if (ipSet) [ipSet release]; ipSet = nil;
#endif
        }
        default:
            break;
    }
}

- (void)addExcludedSubtree:(GeneralSubtree *)paramGeneralSubtree {
    GeneralName *localGeneralName = [paramGeneralSubtree getBase];
    switch ([localGeneralName getTagNo]) {
        case 1:
            self.excludedSubtreesEmail = [self unionEmail:self.excludedSubtreesEmail paramString:[self extractNameAsString:localGeneralName]];
            break;
        case 2:
            self.excludedSubtreesDNS = [self unionDNS:self.excludedSubtreesDNS paramString:[self extractNameAsString:localGeneralName]];
            break;
        case 4:
            self.excludedSubtreesDN = [self unionDN:self.excludedSubtreesDN paramASN1Sequence:(ASN1Sequence *)[[localGeneralName getName] toASN1Primitive]];
            break;
        case 6:
            self.excludedSubtreesURI = [self unionURI:self.excludedSubtreesURI paramString:[self extractNameAsString:localGeneralName]];
            break;
        case 7:
            self.excludedSubtreesIP = [self unionIP:self.excludedSubtreesIP paramArrayOfByte:[[ASN1OctetString getInstance:[localGeneralName getName]] getOctets]];
        default:
            break;
    }
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[PKIXNameConstraintValidator class]]) {
        return NO;
    }
    PKIXNameConstraintValidator *localPKIXNameConstraintValidator = (PKIXNameConstraintValidator *)object;
#pragma mark Collection
    return NO;
}

- (NSString *)toString {
    NSString *str = @"";
    str = [NSString stringWithFormat:@"%@permitted:\n", str];
    if (self.permittedSubtreesDN) {
        str = [NSString stringWithFormat:@"%@DN:\n", str];
        str = [NSString stringWithFormat:@"%@%@\n", str, [NSString stringWithFormat:@"%@", self.permittedSubtreesDN]];
    }
    if (self.permittedSubtreesDNS) {
        str = [NSString stringWithFormat:@"%@DNS:\n", str];
        str = [NSString stringWithFormat:@"%@%@\n", str, [NSString stringWithFormat:@"%@", self.permittedSubtreesDNS]];
    }
    if (self.permittedSubtreesEmail) {
        str = [NSString stringWithFormat:@"%@Email:\n", str];
        str = [NSString stringWithFormat:@"%@%@\n", str, [NSString stringWithFormat:@"%@", self.permittedSubtreesEmail]];
    }
    if (self.permittedSubtreesURI) {
        str = [NSString stringWithFormat:@"%@URI:\n", str];
        str = [NSString stringWithFormat:@"%@%@\n", str, [NSString stringWithFormat:@"%@", self.permittedSubtreesURI]];
    }
    if (self.permittedSubtreesIP) {
        str = [NSString stringWithFormat:@"%@IP:\n", str];
        str = [NSString stringWithFormat:@"%@%@\n", str, [self stringifyIPCollection:self.permittedSubtreesIP]];
    }
    str = [NSString stringWithFormat:@"%@excluded:\n", str];
    if (self.excludedSubtreesDN) {
        str = [NSString stringWithFormat:@"%@DN:\n", str];
        str = [NSString stringWithFormat:@"%@%@\n", str, [NSString stringWithFormat:@"%@", self.excludedSubtreesDN]];
    }
    if (self.excludedSubtreesDNS) {
        str = [NSString stringWithFormat:@"%@DNS:\n", str];
        str = [NSString stringWithFormat:@"%@%@\n", str, [NSString stringWithFormat:@"%@", self.excludedSubtreesDNS]];
    }
    if (self.excludedSubtreesEmail) {
        str = [NSString stringWithFormat:@"%@Email:\n", str];
        str = [NSString stringWithFormat:@"%@%@\n", str, [NSString stringWithFormat:@"%@", self.excludedSubtreesEmail]];
    }
    if (self.excludedSubtreesURI) {
        str = [NSString stringWithFormat:@"%@URI:\n", str];
        str = [NSString stringWithFormat:@"%@%@\n", str, [NSString stringWithFormat:@"%@", self.excludedSubtreesURI]];
    }
    if (self.excludedSubtreesIP) {
        str = [NSString stringWithFormat:@"%@IP:\n", str];
        str = [NSString stringWithFormat:@"%@%@\n", str, [self stringifyIPCollection:self.excludedSubtreesIP]];
    }
    return nil;
}

- (void)checkPermittedDN:(X500Name *)paramX500Name {
    [self checkPermittedDN:self.permittedSubtreesDN paramASN1Sequence:[ASN1Sequence getInstance:[paramX500Name toASN1Primitive]]];
}

- (void)checkPermittedDN:(NSSet *)paramSet paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence {
    if (!paramSet) {
        return;
    }
    if (!paramSet && ([paramASN1Sequence size] == 0)) {
        return;
    }
    NSEnumerator *localIterator = [paramSet objectEnumerator];
    ASN1Sequence *localASN1Sequence = nil;
    while (localASN1Sequence = [localIterator nextObject]) {
        if ([PKIXNameConstraintValidator withinDNSubtree:paramASN1Sequence paramASN1Sequence2:localASN1Sequence]) {
            return;
        }
    }
    @throw [NSException exceptionWithName:NSGenericException reason:@"Subject distinguished name is not from a permitted subtree" userInfo:nil];
}

- (void)checkExcludedDN:(X500Name *)paramX500Name {
    [self checkExcludedDN:self.excludedSubtreesDN paramASN1Sequence:[ASN1Sequence getInstance:paramX500Name]];
}

- (void)checkExcludedDN:(NSSet *)paramSet paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence {
    if (!paramSet) {
        return;
    }
    NSEnumerator *localIterator = [paramSet objectEnumerator];
    ASN1Sequence *localASN1Sequence = nil;
    while (localASN1Sequence = [localIterator nextObject]) {
        if ([PKIXNameConstraintValidator withinDNSubtree:paramASN1Sequence paramASN1Sequence2:localASN1Sequence]) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"Subject distinguished name is from an excluded subtree" userInfo:nil];
        }
    }
}

- (void)checkPermittedEmail:(NSSet *)paramSet paramString:(NSString *)paramString {
    if (!paramSet) {
        return;
    }
    NSEnumerator *localIterator = [paramSet objectEnumerator];
    NSString *str = nil;
    while (str = [localIterator nextObject]) {
        if ([self emailIsConstrained:paramString paramString2:str]) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"Email address is from an excluded subtree." userInfo:nil];
        }
    }
}

- (void)checkExcludedEmail:(NSSet *)paramSet paramString:(NSString *)paramString {
    
}

- (void)checkPermittedIP:(NSSet *)paramSet paramArrayOfByte:(NSMutableData *)paramArrayOfByte {
    if (!paramSet) {
        return;
    }
    NSEnumerator *localIterator = [paramSet objectEnumerator];
    NSMutableData *arrayOfByte = nil;
    while (arrayOfByte =[localIterator nextObject]) {
        if ([self isIPConstrained:paramArrayOfByte paramArrayOfByte2:arrayOfByte]) {
            return;
        }
    }
    if (([paramArrayOfByte length] == 0) && ([paramSet count] == 0)) {
        return;
    }
    @throw [NSException exceptionWithName:NSGenericException reason:@"IP is not from a permitted subtree." userInfo:nil];
}

- (void)checkExcludedIP:(NSSet *)paramSet paramArrayOfByte:(NSMutableData *)paramArrayOfByte {
    if (!paramSet) {
        return;
    }
    NSEnumerator *localIterator = [paramSet objectEnumerator];
    NSMutableData *arrayOfByte = nil;
    while (arrayOfByte =[localIterator nextObject]) {
        if ([self isIPConstrained:paramArrayOfByte paramArrayOfByte2:arrayOfByte]) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"IP is from an excluded subtree." userInfo:nil];
        }
    }
}

- (void)checkPermittedDNS:(NSSet *)paramSet paramString:(NSString *)paramString {
    if (!paramSet) {
        return;
    }
    NSEnumerator *localIterator = [paramSet objectEnumerator];
    NSString *str = nil;
    while (str = [localIterator nextObject]) {
        if ([self withinDomain:paramString paramString2:str] || [paramString isEqualToString:str]) {
            return;
        }
    }
    if (([paramString length] == 0) && ([paramSet count] == 0)) {
        return;
    }
    @throw [NSException exceptionWithName:NSGenericException reason:@"DNS is not from a permitted subtree." userInfo:nil];
}

- (void)checkExcludedDNS:(NSSet *)paramSet paramString:(NSString *)paramString {
    if (!paramSet) {
        return;
    }
    NSEnumerator *localIterator = [paramSet objectEnumerator];
    NSString *str = nil;
    while (str = [localIterator nextObject]) {
        if ([self withinDomain:paramString paramString2:str] || [paramString isEqualToString:str]) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"DNS is from an excluded subtree." userInfo:nil];
        }
    }
}

- (void)checkPermittedURI:(NSSet *)paramSet paramString:(NSString *)paramString {
    if (!paramSet) {
        return;
    }
    NSEnumerator *localIterator = [paramSet objectEnumerator];
    NSString *str = nil;
    while (str = [localIterator nextObject]) {
        if ([self isUriConstrained:paramString paramString2:str]) {
            return;
        }
    }
    if (([paramString length] == 0) && ([paramSet count] == 0)) {
        return;
    }
    @throw [NSException exceptionWithName:NSGenericException reason:@"URI is not from a permitted subtree." userInfo:nil];
}

- (void)checkExcludedURI:(NSSet *)paramSet paramString:(NSString *)paramString {
    if (!paramSet) {
        return;
    }
    NSEnumerator *localIterator = [paramSet objectEnumerator];
    NSString *str = nil;
    while (str = [localIterator nextObject]) {
        if ([self isUriConstrained:paramString paramString2:str]) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"URI is from an excluded subtree." userInfo:nil];
        }
    }
}

- (NSSet *)intersectDN:(NSSet *)paramSet1 paramSet2:(NSSet *)paramSet2 {
    NSMutableSet *localHashSet = [[[NSMutableSet alloc] init] autorelease];
    NSEnumerator *localIterator1 = [paramSet2 objectEnumerator];
    ASN1Sequence *localASN1Sequence1 = nil;
    while (localASN1Sequence1 = [localIterator1 nextObject]) {
        localASN1Sequence1 = [ASN1Sequence getInstance:[[[((GeneralSubtree *)[localIterator1 nextObject]) getBase] getName] toASN1Primitive]];
        if (!paramSet1) {
            if (localASN1Sequence1) {
                [localHashSet addObject:localASN1Sequence1];
            }
        }else {
            NSEnumerator *localIterator2 = [paramSet1 objectEnumerator];
            ASN1Sequence *localASN1Sequence2 = nil;
            while (localASN1Sequence2 = [localIterator2 nextObject]) {
                if ([PKIXNameConstraintValidator withinDNSubtree:localASN1Sequence1 paramASN1Sequence2:localASN1Sequence2]) {
                    [localHashSet addObject:localASN1Sequence1];
                }else if ([PKIXNameConstraintValidator withinDNSubtree:localASN1Sequence2 paramASN1Sequence2:localASN1Sequence1]) {
                    [localHashSet addObject:localASN1Sequence2];
                }
            }
        }
    }
    return localHashSet;
}

- (NSSet *)unionDN:(NSSet *)paramSet paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence {
    if (!paramSet) {
        if (!paramASN1Sequence) {
            return paramSet;
        }
        [((NSMutableSet *)paramSet) addObject:paramASN1Sequence];
        return paramSet;
    }
    NSMutableSet *localHashSet = [[[NSMutableSet alloc] init] autorelease];
    NSEnumerator *localIterator = [paramSet objectEnumerator];
    ASN1Sequence *localASN1Sequence = nil;
    while (localASN1Sequence = [localIterator nextObject]) {
        if ([PKIXNameConstraintValidator withinDNSubtree:paramASN1Sequence paramASN1Sequence2:localASN1Sequence]) {
            [localHashSet addObject:localASN1Sequence];
        }else if ([PKIXNameConstraintValidator withinDNSubtree:localASN1Sequence paramASN1Sequence2:paramASN1Sequence]) {
            [localHashSet addObject:paramASN1Sequence];
        }else {
            [localHashSet addObject:localASN1Sequence];
            [localHashSet addObject:paramASN1Sequence];
        }
    }
    return localHashSet;
}

- (NSSet *)intersectEmail:(NSSet *)paramSet1 paramSet2:(NSSet *)paramSet2 {
    NSMutableSet *localHashSet = [[[NSMutableSet alloc] init] autorelease];
    NSEnumerator *localIterator1 = [paramSet2 objectEnumerator];
    NSString *str1 = nil;
    while (str1 = [localIterator1 nextObject]) {
        str1 = [self extractNameAsString:[((GeneralSubtree *)[localIterator1 nextObject]) getBase]];
        if (!paramSet1) {
            if (str1) {
                [localHashSet addObject:str1];
            }
        }else {
            NSEnumerator *localIterator2 = [paramSet1 objectEnumerator];
            NSString *str2 = nil;
            while (str2 = [localIterator2 nextObject]) {
                [self intersectEmail:str1 paramString2:str2 paramSet:localHashSet];
            }
        }
    }
    return localHashSet;
}
                 
- (void)intersectEmail:(NSString *)paramString1 paramString2:(NSString *)paramString2 paramSet:(NSSet *)paramSet {
    
}

- (NSSet *)unionEmail:(NSSet *)paramSet paramString:(NSString *)paramString {
    if (!paramSet) {
        if (!paramString) {
            return paramSet;
        }
        [((NSMutableSet *)paramSet) addObject:paramString];
        return paramSet;
    }
    NSMutableSet *localHashSet = [[[NSMutableSet alloc] init] autorelease];
    NSEnumerator *localIterator = [paramSet objectEnumerator];
    NSString *str = nil;
    while (str = [localIterator nextObject]) {
        [self unionEmail:str paramString2:paramString paramSet:localHashSet];
    }
    return localHashSet;
}

- (void)unionEmail:(NSString *)paramString1 paramString2:(NSString *)paramString2 paramSet:(NSSet *)paramSet {
    
}

- (NSString *)extractNameAsString:(GeneralName *)paramGeneralName {
    return [[DERIA5String getInstance:[paramGeneralName getName]] getString];
}

- (NSSet *)intersectDNS:(NSSet *)paramSet1 paramSet2:(NSSet *)paramSet2 {
    NSMutableSet *localHashSet = [[[NSMutableSet alloc] init] autorelease];
    NSEnumerator *localIterator1 = [paramSet2 objectEnumerator];
    NSString *str1 = nil;
    while (str1 = [localIterator1 nextObject]) {
        str1 = [self extractNameAsString:[((GeneralSubtree *)[localIterator1 nextObject]) getBase]];
        if (!paramSet1) {
            if (str1) {
                [localHashSet addObject:str1];
            }
        }else {
            NSEnumerator *localIterator2 = [paramSet1 objectEnumerator];
            NSString *str2 = nil;
            while (str2 = [localIterator2 nextObject]) {
                if ([self withinDomain:str2 paramString2:str1]) {
                    [localHashSet addObject:str2];
                }else if ([self withinDomain:str1 paramString2:str2]) {
                    [localHashSet addObject:str1];
                }
            }
        }
    }
    return localHashSet;
}

- (NSSet *)unionDNS:(NSSet *)paramSet paramString:(NSString *)paramString {
    if (!paramSet) {
        if (!paramString) {
            return paramSet;
        }
        [((NSMutableSet *)paramSet) addObject:paramString];
        return paramSet;
    }
    NSMutableSet *localHashSet = [[[NSMutableSet alloc] init] autorelease];
    NSEnumerator *localIterator = [paramSet objectEnumerator];
    NSString *str = nil;
    while (str = [localIterator nextObject]) {
        if ([self withinDomain:str paramString2:paramString]) {
            [localHashSet addObject:paramString];
        }else if ([self withinDomain:paramString paramString2:str]) {
            [localHashSet addObject:str];
        }else {
            [localHashSet addObject:str];
            [localHashSet addObject:paramString];
        }
    }
    return localHashSet;
}

- (NSSet *)intersectURI:(NSSet *)paramSet1 paramSet2:(NSSet *)paramSet2 {
    NSMutableSet *localHashSet = [[[NSMutableSet alloc] init] autorelease];
    NSEnumerator *localIterator1 = [paramSet2 objectEnumerator];
    NSString *str1 = nil;
    while (str1 = [localIterator1 nextObject]) {
        str1 = [self extractNameAsString:[((GeneralSubtree *)[localIterator1 nextObject]) getBase]];
        if (!paramSet1) {
            if (str1) {
                [localHashSet addObject:str1];
            }
        }else {
            NSEnumerator *localIterator2 = [paramSet1 objectEnumerator];
            NSString *str2 = nil;
            while (str2 = [localIterator2 nextObject]) {
                [self intersectURI:str2 paramString2:str1 paramSet:localHashSet];
            }
        }
    }
    return localHashSet;
}

- (void)intersectURI:(NSString *)paramString1 paramString2:(NSString *)paramString2 paramSet:(NSSet *)paramSet {
    
}

- (NSSet *)unionURI:(NSSet *)paramSet paramString:(NSString *)paramString {
    if (!paramSet) {
        if (!paramString) {
            return paramSet;
        }
        [((NSMutableSet *)paramSet) addObject:paramString];
        return paramSet;
    }
    NSMutableSet *localHashSet = [[[NSMutableSet alloc] init] autorelease];
    NSEnumerator *localIterator = [paramSet objectEnumerator];
    NSString *str = nil;
    while (str = [localIterator nextObject]) {
        [self unionURI:str paramString2:paramString paramSet:localHashSet];
    }
    return localHashSet;
}

- (void)unionURI:(NSString *)paramString1 paramString2:(NSString *)paramString2 paramSet:(NSSet *)paramSet {
    
}

- (NSSet *)intersectIP:(NSSet *)paramSet1 paramSet2:(NSSet *)paramSet2 {
    NSMutableSet *localHashSet = [[[NSMutableSet alloc] init] autorelease];
    NSEnumerator *localIterator1 = [paramSet2 objectEnumerator];
    NSMutableData *arrayOfByte1 = nil;
    while (arrayOfByte1 = [localIterator1 nextObject]) {
        arrayOfByte1 = [[ASN1OctetString getInstance:[[((GeneralSubtree *)[localIterator1 nextObject]) getBase] getName]] getOctets];
        if (!paramSet1) {
            if (arrayOfByte1) {
                [localHashSet addObject:arrayOfByte1];
            }
        }else {
            NSEnumerator *localIterator2 = [paramSet1 objectEnumerator];
            NSMutableData *arrayOfByte2 = nil;
            while (arrayOfByte2 = [localIterator2 nextObject]) {
                [localHashSet addObject:[self intersectIPRange:arrayOfByte2 paramArrayOfByte2:arrayOfByte1]];
            }
        }
    }
    return localHashSet;
}

- (NSSet *)unionIP:(NSSet *)paramSet paramArrayOfByte:(NSMutableData *)paramArrayOfByte {
    if (!paramSet) {
        if (!paramArrayOfByte) {
            return paramSet;
        }
        [((NSMutableSet *)paramSet) addObject:paramArrayOfByte];
        return paramSet;
    }
    NSMutableSet *localHashSet = [[[NSMutableSet alloc] init] autorelease];
    NSEnumerator *localIterator = [paramSet objectEnumerator];
    NSMutableData *arrayOfByte = nil;
    while (arrayOfByte = [localIterator nextObject]) {
        [localHashSet addObject:[self unionIPRange:arrayOfByte paramArrayOfByte2:paramArrayOfByte]];
    }
    return localHashSet;
}

- (NSString *)stringifyIPCollection:(NSSet *)paramSet {
    return nil;
}

- (NSSet *)intersectIPRange:(NSMutableData *)paramArrayOfByte1 paramArrayOfByte2:(NSMutableData *)paramArrayOfByte2 {
    return nil;
}

- (NSSet *)unionIPRange:(NSMutableData *)paramArrayOfByte1 paramArrayOfByte2:(NSMutableData *)paramArrayOfByte2 {
    return nil;
}

- (NSMutableData *)ipWithSubnetMask:(NSMutableData *)paramArrayOfByte1 paramArrayOfByte2:(NSMutableData *)paramArrayOfByte2 {
    int i = (int)[paramArrayOfByte1 length];
    NSMutableData *arrayOfByte = [[[NSMutableData alloc] initWithSize:(i * 2)] autorelease];
    [arrayOfByte copyFromIndex:0 withSource:paramArrayOfByte1 withSourceIndex:0 withLength:i];
    [arrayOfByte copyFromIndex:i withSource:paramArrayOfByte2 withSourceIndex:0 withLength:i];
    return arrayOfByte;
}

- (NSMutableArray *)extractIPsAndSubnetMasks:(NSMutableData *)paramArrayOfByte1 paramArrayOfByte2:(NSMutableData *)paramArrayOfByte2 {
    int i = ((int)[paramArrayOfByte1 length]) / 2;
    NSMutableData *arrayOfByte1 = [[NSMutableData alloc] initWithSize:i];
    NSMutableData *arrayOfByte2 = [[NSMutableData alloc] initWithSize:i];
    [arrayOfByte1 copyFromIndex:0 withSource:paramArrayOfByte1 withSourceIndex:0 withLength:i];
    [arrayOfByte2 copyFromIndex:0 withSource:paramArrayOfByte1 withSourceIndex:i withLength:i];
    NSMutableData *arrayOfByte3 = [[NSMutableData alloc] initWithSize:i];
    NSMutableData *arrayOfByte4 = [[NSMutableData alloc] initWithSize:i];
    [arrayOfByte3 copyFromIndex:0 withSource:paramArrayOfByte2 withSourceIndex:0 withLength:i];
    [arrayOfByte4 copyFromIndex:0 withSource:paramArrayOfByte2 withSourceIndex:i withLength:i];
    NSMutableArray *tmpAry = [[NSMutableArray alloc] init];
    [tmpAry addObject:arrayOfByte1];
    [tmpAry addObject:arrayOfByte2];
    [tmpAry addObject:arrayOfByte3];
    [tmpAry addObject:arrayOfByte4];
    NSMutableArray *returnAray = [[[NSMutableArray alloc] init] autorelease];
    [returnAray addObjectsFromArray:tmpAry];
#if !__has_feature(objc_arc)
    if (arrayOfByte1) [arrayOfByte1 release]; arrayOfByte1 = nil;
    if (arrayOfByte2) [arrayOfByte2 release]; arrayOfByte2 = nil;
    if (arrayOfByte3) [arrayOfByte3 release]; arrayOfByte3 = nil;
    if (arrayOfByte4) [arrayOfByte4 release]; arrayOfByte4 = nil;
    if (tmpAry) [tmpAry release]; tmpAry = nil;
#endif
    return returnAray;
}

- (NSSet *)minMaxIPs:(NSMutableData *)paramArrayOfByte1 paramArrayOfByte2:(NSMutableData *)paramArrayOfByte2 paramArrayOfByte3:(NSMutableData *)paramArrayOfByte3 paramArrayOfByte4:(NSMutableData *)paramArrayOfByte4 {
    return nil;
}

- (BOOL)emailIsConstrained:(NSString *)paramString1 paramString2:(NSString *)paramString2 {
    return NO;
}

- (BOOL)isIPConstrained:(NSMutableData *)paramArrayOfByte1 paramArrayOfByte2:(NSMutableData *)paramArrayOfByte2 {
    int i = (int)[paramArrayOfByte1 length];
    if (i != ((int)[paramArrayOfByte2 length] / 2)) {
        return NO;
    }
    NSMutableData *arrayOfByte1 = [[NSMutableData alloc] initWithSize:i];
    [arrayOfByte1 copyFromIndex:0 withSource:paramArrayOfByte2 withSourceIndex:i withLength:i];
    NSMutableData *arrayOfByte2 = [[NSMutableData alloc] initWithSize:i];
    NSMutableData *arrayOfByte3 = [[NSMutableData alloc] initWithSize:i];
    for (int j = 0; j < i; j++) {
        ((Byte *)[arrayOfByte2 bytes])[j] = (Byte)(((Byte *)[paramArrayOfByte2 bytes])[j] & ((Byte *)[arrayOfByte1 bytes])[j]);
        ((Byte *)[arrayOfByte3 bytes])[j] = (Byte)(((Byte *)[paramArrayOfByte1 bytes])[j] & ((Byte *)[arrayOfByte1 bytes])[j]);
    }
    BOOL areEqual = [Arrays areEqualWithByteArray:(NSData *)arrayOfByte2 withB:(NSData *)arrayOfByte3];
#if !__has_feature(objc_arc)
    if (arrayOfByte1) [arrayOfByte1 release]; arrayOfByte1 = nil;
    if (arrayOfByte2) [arrayOfByte2 release]; arrayOfByte2 = nil;
    if (arrayOfByte3) [arrayOfByte3 release]; arrayOfByte3 = nil;
#endif
    return areEqual;
}

- (BOOL)withinDomain:(NSString *)paramString1 paramString2:(NSString *)paramString2 {
    return NO;
}

- (BOOL)isUriConstrained:(NSString *)paramString1 paramString2:(NSString *)paramString2 {
    return NO;
}

- (int)hashCollection:(NSSet *)coll {
    if (!coll) {
        return 0;
    }
    int hash = 0;
    NSEnumerator *it1 = [coll objectEnumerator];
    id obj = nil;
    while (obj = [it1 nextObject]) {
        id o = obj;
        if ([o isKindOfClass:[NSMutableData class]]) {
            hash += [Arrays getHashCodeWithByteArray:(NSMutableData *)o];
        }else {
            hash += [o hash];
        }
    }
    return hash;
}

- (NSUInteger)hash {
    return [self hashCollection:self.excludedSubtreesDN]
    + [self hashCollection:self.excludedSubtreesDNS]
    + [self hashCollection:self.excludedSubtreesEmail]
    + [self hashCollection:self.excludedSubtreesIP]
    + [self hashCollection:self.excludedSubtreesURI]
    + [self hashCollection:self.permittedSubtreesDN]
    + [self hashCollection:self.permittedSubtreesDNS]
    + [self hashCollection:self.permittedSubtreesEmail]
    + [self hashCollection:self.permittedSubtreesIP]
    + [self hashCollection:self.permittedSubtreesURI];
}

@end
