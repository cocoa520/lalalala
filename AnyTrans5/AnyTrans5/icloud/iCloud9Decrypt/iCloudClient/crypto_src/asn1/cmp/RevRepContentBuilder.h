//
//  RevRepContentBuilder.h
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKIStatusInfo.h"
#import "CertIdCRMF.h"
#import "CertificateList.h"
#import "RevRepContent.h"

@interface RevRepContentBuilder : NSObject {
    ASN1EncodableVector *_status;
    ASN1EncodableVector *_revCerts;
    ASN1EncodableVector *_crls;
}

@property (nonatomic, readwrite, retain) ASN1EncodableVector *status;
@property (nonatomic, readwrite, retain) ASN1EncodableVector *revCerts;
@property (nonatomic, readwrite, retain) ASN1EncodableVector *crls;

- (RevRepContentBuilder *)add:(PKIStatusInfo *)paramPKIStatusInfo;
- (RevRepContentBuilder *)add:(PKIStatusInfo *)paramPKIStatusInfo paramCertId:(CertIdCRMF *)paramCertId;
- (RevRepContentBuilder *)addCrl:(CertificateList *)paramCertificateList;
- (RevRepContent *)build;

@end
