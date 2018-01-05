//
//  ProfessionInfo.m
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ProfessionInfo.h"
#import "DERTaggedObject.h"
#import "DERPrintableString.h"
#import "DERSequence.h"
#import "DEROctetString.h"

@interface ProfessionInfo ()

@property (nonatomic, readwrite, retain) NamingAuthority *namingAuthority;
@property (nonatomic, readwrite, retain) ASN1Sequence *professionItems;
@property (nonatomic, readwrite, retain) ASN1Sequence *professionOIDs;
@property (nonatomic, readwrite, retain) NSString *registrationNumber;
@property (nonatomic, readwrite, retain) ASN1OctetString *addProfessionInfo;

@end

@implementation ProfessionInfo
@synthesize namingAuthority = _namingAuthority;
@synthesize professionItems = _professionItems;
@synthesize professionOIDs = _professionOIDs;
@synthesize registrationNumber = _registrationNumber;
@synthesize addProfessionInfo = _addProfessionInfo;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_namingAuthority) {
        [_namingAuthority release];
        _namingAuthority = nil;
    }
    if (_professionItems) {
        [_professionItems release];
        _professionItems = nil;
    }
    if (_professionOIDs) {
        [_professionOIDs release];
        _professionOIDs = nil;
    }
    if (_registrationNumber) {
        [_registrationNumber release];
        _registrationNumber = nil;
    }
    if (_addProfessionInfo) {
        [_addProfessionInfo release];
        _addProfessionInfo = nil;
    }
    [super dealloc];
#endif
}

+ (ASN1ObjectIdentifier *)Rechtsanwltin {
    static ASN1ObjectIdentifier *_Rechtsanwltin = nil;
    @synchronized(self) {
        if (!_Rechtsanwltin) {
            _Rechtsanwltin = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.1", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _Rechtsanwltin;
}

+ (ASN1ObjectIdentifier *)Rechtsanwalt {
    static ASN1ObjectIdentifier *_Rechtsanwalt = nil;
    @synchronized(self) {
        if (!_Rechtsanwalt) {
            _Rechtsanwalt = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.2", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _Rechtsanwalt;
}

+ (ASN1ObjectIdentifier *)Rechtsbeistand {
    static ASN1ObjectIdentifier *_Rechtsbeistand = nil;
    @synchronized(self) {
        if (!_Rechtsbeistand) {
            _Rechtsbeistand = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.3", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _Rechtsbeistand;
}

+ (ASN1ObjectIdentifier *)Steuerberaterin {
    static ASN1ObjectIdentifier *_Steuerberaterin = nil;
    @synchronized(self) {
        if (!_Steuerberaterin) {
            _Steuerberaterin = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.4", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _Steuerberaterin;
}

+ (ASN1ObjectIdentifier *)Steuerberater {
    static ASN1ObjectIdentifier *_Steuerberater = nil;
    @synchronized(self) {
        if (!_Steuerberater) {
            _Steuerberater = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.5", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _Steuerberater;
}

+ (ASN1ObjectIdentifier *)Steuerbevollmchtigte {
    static ASN1ObjectIdentifier *_Steuerbevollmchtigte = nil;
    @synchronized(self) {
        if (!_Steuerbevollmchtigte) {
            _Steuerbevollmchtigte = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.6", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _Steuerbevollmchtigte;
}

+ (ASN1ObjectIdentifier *)Steuerbevollmchtigter {
    static ASN1ObjectIdentifier *_Steuerbevollmchtigter = nil;
    @synchronized(self) {
        if (!_Steuerbevollmchtigter) {
            _Steuerbevollmchtigter = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.7", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _Steuerbevollmchtigter;
}

+ (ASN1ObjectIdentifier *)Notarin {
    static ASN1ObjectIdentifier *_Notarin = nil;
    @synchronized(self) {
        if (!_Notarin) {
            _Notarin = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.8", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _Notarin;
}

+ (ASN1ObjectIdentifier *)Notar {
    static ASN1ObjectIdentifier *_Notar = nil;
    @synchronized(self) {
        if (!_Notar) {
            _Notar = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.9", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _Notar;
}

+ (ASN1ObjectIdentifier *)Notarvertreterin {
    static ASN1ObjectIdentifier *_Notarvertreterin = nil;
    @synchronized(self) {
        if (!_Notarvertreterin) {
            _Notarvertreterin = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.10", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _Notarvertreterin;
}

+ (ASN1ObjectIdentifier *)Notarvertreter {
    static ASN1ObjectIdentifier *_Notarvertreter = nil;
    @synchronized(self) {
        if (!_Notarvertreter) {
            _Notarvertreter = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.11", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _Notarvertreter;
}

+ (ASN1ObjectIdentifier *)Notariatsverwalterin {
    static ASN1ObjectIdentifier *_Notariatsverwalterin = nil;
    @synchronized(self) {
        if (!_Notariatsverwalterin) {
            _Notariatsverwalterin = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.12", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _Notariatsverwalterin;
}

+ (ASN1ObjectIdentifier *)Notariatsverwalter {
    static ASN1ObjectIdentifier *_Notariatsverwalter = nil;
    @synchronized(self) {
        if (!_Notariatsverwalter) {
            _Notariatsverwalter = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.13", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _Notariatsverwalter;
}

+ (ASN1ObjectIdentifier *)Wirtschaftsprferin {
    static ASN1ObjectIdentifier *_Wirtschaftsprferin = nil;
    @synchronized(self) {
        if (!_Wirtschaftsprferin) {
            _Wirtschaftsprferin = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.14", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _Wirtschaftsprferin;
}

+ (ASN1ObjectIdentifier *)Wirtschaftsprfer {
    static ASN1ObjectIdentifier *_Wirtschaftsprfer = nil;
    @synchronized(self) {
        if (!_Wirtschaftsprfer) {
            _Wirtschaftsprfer = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.15", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _Wirtschaftsprfer;
}

+ (ASN1ObjectIdentifier *)VereidigteBuchprferin {
    static ASN1ObjectIdentifier *_VereidigteBuchprferin = nil;
    @synchronized(self) {
        if (!_VereidigteBuchprferin) {
            _VereidigteBuchprferin = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.16", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _VereidigteBuchprferin;
}

+ (ASN1ObjectIdentifier *)VereidigterBuchprfer {
    static ASN1ObjectIdentifier *_VereidigterBuchprfer = nil;
    @synchronized(self) {
        if (!_VereidigterBuchprfer) {
            _VereidigterBuchprfer = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.17", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _VereidigterBuchprfer;
}

+ (ASN1ObjectIdentifier *)Patentanwltin {
    static ASN1ObjectIdentifier *_Patentanwltin = nil;
    @synchronized(self) {
        if (!_Patentanwltin) {
            _Patentanwltin = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.18", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _Patentanwltin;
}

+ (ASN1ObjectIdentifier *)Patentanwalt {
    static ASN1ObjectIdentifier *_Patentanwalt = nil;
    @synchronized(self) {
        if (!_Patentanwalt) {
            _Patentanwalt = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.19", [NamingAuthority id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern]]];
        }
    }
    return _Patentanwalt;
}

+ (ProfessionInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ProfessionInfo class]]) {
        return (ProfessionInfo *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[ProfessionInfo alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] > 5) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        ASN1Encodable *localASN1Encodable = (ASN1Encodable *)[localEnumeration nextObject];
        if ([localASN1Encodable isKindOfClass:[ASN1TaggedObject class]]) {
            if ([((ASN1TaggedObject *)localASN1Encodable) getTagNo] != 0) {
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad tag number: %d", [((ASN1TaggedObject *)localASN1Encodable) getTagNo]] userInfo:nil];
            }
            self.namingAuthority = [NamingAuthority getInstance:(ASN1TaggedObject *)localASN1Encodable paramBoolean:YES];
            localASN1Encodable = (ASN1Encodable *)[localEnumeration nextObject];
        }
        self.professionItems = [ASN1Sequence getInstance:localASN1Encodable];
        if (localASN1Encodable) {
            if ([localASN1Encodable isKindOfClass:[ASN1Sequence class]]) {
                self.professionOIDs = [ASN1Sequence getInstance:localASN1Encodable];
            }else if ([localASN1Encodable isKindOfClass:[DERPrintableString class]]) {
                self.registrationNumber = [[DERPrintableString getInstance:localASN1Encodable] getString];
            }else if ([localASN1Encodable isKindOfClass:[ASN1OctetString class]]) {
                self.addProfessionInfo = [ASN1OctetString getInstance:localASN1Encodable];
            }else {
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad object encountered: %s", object_getClassName(paramASN1Sequence)] userInfo:nil];
            }
        }
        if (localASN1Encodable) {
            if ([localASN1Encodable isKindOfClass:[DERPrintableString class]]) {
                self.registrationNumber = [[DERPrintableString getInstance:localASN1Encodable] getString];
            }else if ([localASN1Encodable isKindOfClass:[DEROctetString class]]) {
                self.addProfessionInfo = [DEROctetString getInstance:localASN1Encodable];
            }else {
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad object encountered: %s", object_getClassName(paramASN1Sequence)] userInfo:nil];
            }
        }
        if (localASN1Encodable) {
            if ([localASN1Encodable isKindOfClass:[DEROctetString class]]) {
                self.addProfessionInfo = [DEROctetString getInstance:localASN1Encodable];
            }else {
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad object encountered: %s", object_getClassName(paramASN1Sequence)] userInfo:nil];
            }
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamNamingAuthority:(NamingAuthority *)paramNamingAuthority paramArrayOfDirectoryString:(NSMutableArray *)paramArrayOfDirectoryString paramArrayOfASN1ObjectIdentifier:(NSMutableArray *)paramArrayOfASN1ObjectIdentifier paramString:(NSString *)paramString paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        self.namingAuthority = paramNamingAuthority;
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        for (int i = 0; i != paramArrayOfDirectoryString.count; i++) {
            [localASN1EncodableVector add:paramArrayOfDirectoryString[i]];
        }
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
        self.professionItems = sequence;
        if (paramArrayOfASN1ObjectIdentifier) {
            localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
            for (int i = 0; i != paramArrayOfASN1ObjectIdentifier.count; i++) {
                [localASN1EncodableVector add:paramArrayOfASN1ObjectIdentifier[i]];
            }
            ASN1Sequence *oidsSequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
            self.professionOIDs = oidsSequence;
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (oidsSequence) [oidsSequence release]; oidsSequence = nil;
#endif
        }
        self.registrationNumber = paramString;
        self.addProfessionInfo = paramASN1OctetString;
#if !__has_feature(objc_arc)
        if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
        if (sequence) [sequence release]; sequence = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.namingAuthority) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.namingAuthority];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    [localASN1EncodableVector add:self.professionItems];
    if (self.professionOIDs) {
        [localASN1EncodableVector add:self.professionOIDs];
    }
    if (self.registrationNumber) {
        ASN1Encodable *encodable = [[DERPrintableString alloc] initParamString:self.registrationNumber paramBoolean:YES];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    if (self.addProfessionInfo) {
        [localASN1EncodableVector add:self.addProfessionInfo];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (ASN1OctetString *)getAddProfessionInfo {
    return self.addProfessionInfo;
}

- (NamingAuthority *)getNamingAuthority {
    return self.namingAuthority;
}

- (NSMutableArray *)getProfessionItems {
    NSMutableArray *arrayOfDirectoryString = [[[NSMutableArray alloc] initWithSize:(int)[self.professionItems size]] autorelease];
    int i = 0;
    NSEnumerator *localEnumeration = [self.professionItems getObjects];
    id localObject = nil;
    while (localObject = [localEnumeration nextObject]) {
        arrayOfDirectoryString[i++] = [DirectoryString getInstance:localObject];
    }
    return arrayOfDirectoryString;
}

- (NSMutableArray *)getProfessionOIDs {
    if (!self.professionOIDs) {
        return [[[NSMutableArray alloc] initWithSize:0] autorelease];
    }
    NSMutableArray *arrayOfASN1ObjectIdentifier = [[[NSMutableArray alloc] initWithSize:(int)[self.professionOIDs size]] autorelease];
    int i = 0;
    NSEnumerator *localEnumeration = [self.professionOIDs getObjects];
    id localObject = nil;
    while (localObject = [localEnumeration nextObject]) {
        arrayOfASN1ObjectIdentifier[i++] = [ASN1ObjectIdentifier getInstance:localObject];
    }
    return arrayOfASN1ObjectIdentifier;
}

- (NSString *)getRegistrationNumber {
    return self.registrationNumber;
}

@end
