//
//  STUCMethod.h
//  iPodSCSIInfoRead
//
//  Created by Pallas on 3/27/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#ifndef iPodSCSIInfoRead_STUCMethod_h
#define iPodSCSIInfoRead_STUCMethod_h

#include <Carbon/Carbon.h>
#include <CoreFoundation/CoreFoundation.h>
#include <IOKit/IOKitLib.h>
#include <IOKit/scsi/SCSITaskLib.h>
#include <IOKit/scsi/SCSICommandOperationCodes.h>

// IO_OBJECT_NULL was added in Mac OS X 10.4. If it's not defined in the headers, define it ourselves.
// This allows the same code to build using the 10.4u SDK for Intel-based systems and earlier SDKs for backwards compatibility
// with PowerPC-based systems.
#ifndef IO_OBJECT_NULL
#define IO_OBJECT_NULL ((io_object_t) 0)
#endif

// define a struct to contain the CodePage data we will be retrieving
typedef struct SCSICmd_INQUIRY_CodePageData
{
	UInt8		Padding1;
	UInt8		CodePage;
	UInt8		Padding2;
	UInt8		DataSize;
	char		Data[251];
} SCSICmd_INQUIRY_CodePageData;

bool ExecuteVPDInquiryUsingSTUC(SCSITaskDeviceInterface **interface, UInt32 inCodePage, SCSICmd_INQUIRY_CodePageData *inqBuffer);

void CreateDeviceInterfaceUsingSTUC(io_object_t scsiDevice, IOCFPlugInInterface ***thePlugInInterface, SCSITaskDeviceInterface ***theInterface);

void GetiPodXML(io_service_t scsiDevice, const char* filePath);

void CreateMatchingDictionaryForSTUC(CFMutableDictionaryRef *matchingDict);

boolean_t FindiPodsUsingSTUC(mach_port_t masterPort, io_iterator_t *iterator);

#endif
