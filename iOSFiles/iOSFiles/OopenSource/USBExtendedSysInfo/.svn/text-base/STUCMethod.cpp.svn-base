//
//  STUCMethod.cpp
//  iPodSCSIInfoRead
//
//  Created by Pallas on 3/27/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#include "STUCMethod.h"

bool ExecuteVPDInquiryUsingSTUC(SCSITaskDeviceInterface **interface, UInt32 inCodePage, SCSICmd_INQUIRY_CodePageData *inqBuffer)
{
    SCSITaskStatus					taskStatus;
    SCSI_Sense_Data					senseData;
    SCSICommandDescriptorBlock		cdb;
    SCSITaskInterface				**task = NULL;
    IOReturn						kr = kIOReturnSuccess;
    IOVirtualRange					*range = NULL;
    UInt64							transferCount = 0;
    UInt32							transferCountHi = 0;
    UInt32							transferCountLo = 0;
    
	assert(interface != NULL);
    
    // Create a task now that we have exclusive access.
    task = (*interface)->CreateSCSITask(interface);
    
    if (task == NULL) {
        fprintf(stderr, "xxxxxxxx CreateSCSITask returned NULL.\n");
		return false;
    }
    else {
        
        // Zero the buffer.  We set it to be the max data size, even though we may not receive this much back in inqBuffer->Data.
        bzero(inqBuffer, sizeof(SCSICmd_INQUIRY_CodePageData));
        
        // Allocate a virtual range for the buffer. If we had more than 1 scatter-gather entry,
        // we would allocate more than 1 IOVirtualRange.
        range = (IOVirtualRange *) malloc(sizeof(IOVirtualRange));
        if (range == NULL) {
            fprintf(stderr, "xxxxxxxx Could not malloc an IOVirtualRange\n" );
        }
        
        // Zero the senseData and CDB.
        bzero(&senseData, sizeof(senseData));
        bzero(cdb, sizeof(cdb));
        
        // Set up the range. The address is just the buffer's address. The length is our request size.
        range->address = (IOVirtualAddress) inqBuffer;
        range->length = sizeof(SCSICmd_INQUIRY_CodePageData);
        
        // We're going to execute an INQUIRY to the device.
		// see http://en.wikipedia.org/wiki/SCSI_Inquiry_Command for more info on the format of the SCSI INQUIRY command
        cdb[0] = kSCSICmd_INQUIRY;
		
		cdb[1] = 1; // set the EVPD flag to 1 so that the target will return Vital Product Data
		cdb[2] = inCodePage; // set byte 2 to be the codepage we want to retrieve
		
        cdb[4] = sizeof(SCSICmd_INQUIRY_CodePageData); // the size of the data we want to retrieve
        
        // Set the actual cdb in the task.
        kr = (*task)->SetCommandDescriptorBlock(task, cdb, kSCSICDBSize_6Byte);
        if (kr != kIOReturnSuccess) {
            fprintf(stderr, "xxxxxxxx Error setting CDB. (0x%08x)\n", kr);
        }
        
        // Set the scatter-gather entry in the task.
        kr = (*task)->SetScatterGatherEntries(task, range, 1, sizeof(SCSICmd_INQUIRY_CodePageData),
                                              kSCSIDataTransfer_FromTargetToInitiator);
        if (kr != kIOReturnSuccess) {
            fprintf(stderr, "xxxxxxxx Error setting scatter-gather entries. (0x%08x)\n", kr);
        }
        
        // Set the timeout in the task
        kr = (*task)->SetTimeoutDuration(task, 10000);
        if (kr != kIOReturnSuccess) {
            fprintf(stderr, "xxxxxxxx Error setting timeout. (0x%08x)\n", kr);
        }
        
        // Send it!
        kr = (*task)->ExecuteTaskSync(task, &senseData, &taskStatus, &transferCount);
        if (kr != kIOReturnSuccess) {
            fprintf(stderr, "xxxxxxxx Error executing task. (0x%08x)\n", kr);
        }
        
        // Get the transfer counts
        transferCountHi = ((transferCount >> 32) & 0xFFFFFFFF);
        transferCountLo = (transferCount & 0xFFFFFFFF);
        
        // Be a good citizen and clean up.
        free(range);
        
        // Release the task interface.
        (*task)->Release(task);
        
		// return a boolean to indicate if we got the data or not
        return (taskStatus == kSCSITaskStatus_GOOD);
        
    }
}

// 在这里主要是根据io_object_t创建TaskDeviceInterface
void CreateDeviceInterfaceUsingSTUC(io_object_t scsiDevice,
                                    IOCFPlugInInterface ***thePlugInInterface,
                                    SCSITaskDeviceInterface ***theInterface)
{
    kern_return_t			kr = kIOReturnSuccess;
    IOCFPlugInInterface		**plugInInterface = NULL;
    SCSITaskDeviceInterface	**interface = NULL;
    HRESULT					plugInResult = S_OK;
    SInt32					score = 0;
    
    assert(scsiDevice != IO_OBJECT_NULL);
    
    // Create the base interface of type IOCFPlugInInterface.
    // This object will be used to create the SCSI device interface object.
    kr = IOCreatePlugInInterfaceForService(scsiDevice,
                                           kIOSCSITaskDeviceUserClientTypeID,
                                           kIOCFPlugInInterfaceID,
                                           &plugInInterface,
                                           &score);
    
    if (kr != kIOReturnSuccess) {
        fprintf(stderr, "xxxxxxxx Couldn't create a plugin interface for the io_service_t. (0x%08x)\n", kr);
    }
    else {
        // Query the base plugin interface for an instance of the specific SCSI device interface
        // object.
        plugInResult = (*plugInInterface)->QueryInterface(plugInInterface,
                                                          CFUUIDGetUUIDBytes(kIOSCSITaskDeviceInterfaceID),
                                                          (LPVOID *) &interface);
        
        if (plugInResult != S_OK) {
            fprintf(stderr, "xxxxxxxx Couldn't create SCSI device interface. (%ld)\n", plugInResult);
        }
    }
    
    // Set the return values.
    *thePlugInInterface = plugInInterface;
    *theInterface = interface;
}

// 在这里主要是通过io_service_t创建XML文件
void GetiPodXML(io_service_t scsiDevice, const char* filePath) {
    IOCFPlugInInterface		**plugInInterface = NULL;
    SCSITaskDeviceInterface	**interface = NULL;
	
	// Create an interface to this iPod, so that we can send it a SCSI Inquiry command
	CreateDeviceInterfaceUsingSTUC(scsiDevice,
								   &plugInInterface,
								   &interface);
	
	// if we got an interface, then try and get the xml
	if (interface != NULL) {
        
		// get the XML
		kern_return_t	kr = kIOReturnSuccess;
        
		assert(interface != NULL);
		
		// Get exclusive access for the device if we can. This must be done
		// before any SCSITasks can be created and sent to the device.
		kr = (*interface)->ObtainExclusiveAccess(interface);
        
		if (kr != kIOReturnSuccess) {
			fprintf(stderr, "xxxxxxxx ObtainExclusiveAccess failed. (0x%08x)\n", kr);
		} else {
            
			// Execute a VPD INQUIRY command on the device to get the codepages of the hidden XML document
            
			// allocate a buffer for the codepage list output
			SCSICmd_INQUIRY_CodePageData CodePagesList;
			bool GotCodePagesList = false;
			
			// request the data on the codepages of the XML
			// this list of codepages is stored in codepage 0xC0
			GotCodePagesList = ExecuteVPDInquiryUsingSTUC(interface, 0xC0, &CodePagesList);
            
			// check we got the codepage and that we got the same codepage number back - this is a sign that we have some data to retrieve
			if (GotCodePagesList && CodePagesList.CodePage == 0xC0) {
                
				// allocate a codepage data structure for retrieving each page (will be re-used)
				SCSICmd_INQUIRY_CodePageData ThisCodePage;
                
				// a tracker bool for each attempt
				bool GotThisCodePage = false;
                
				// get each data codepage
                FILE *file;
                if ((file = fopen(filePath, "wb+")) != NULL) {
                    
                    for (UInt32 i = 0; i < CodePagesList.DataSize; i++) {
                        
                        // request the XML string data for this codepage (the number of which is in CodePagesList.Data[i])
                        GotThisCodePage = ExecuteVPDInquiryUsingSTUC(interface, CodePagesList.Data[i], &ThisCodePage);
                        
                        if (GotThisCodePage) {
                            
                            // print this chunk of XML to the standard output
                            // we will have received ThisCodePage.DataSize chars in ThisCodePage.Data,
                            // although we don't use ThisCodePage.DataSize for this simple call to fprintf
                            
                            fwrite(ThisCodePage.Data, 1, ThisCodePage.DataSize, file);
                            fprintf(stderr, "%s", ThisCodePage.Data);
                            
                        } else {
                            
                            // end the loop
                            i = CodePagesList.DataSize;
                            
                        }
                        
                    }
                  
                    fflush(file);
                    fclose(file);
                }
                
			}
            
			// done with the interface now, so release our exclusive access to it
			kr = (*interface)->ReleaseExclusiveAccess(interface);
			
			if (kr != kIOReturnSuccess) {
				fprintf(stderr, "xxxxxxxx ReleaseExclusiveAccess failed. (0x%08x)\n", kr);
			}
            
		}
        
		(*interface)->Release(interface);
	}
	
	// if we have a plugin interface, then release it
	if (plugInInterface != NULL) {
		IODestroyPlugInInterface(plugInInterface);
	}
    
}

// 创建匹配的目录
void CreateMatchingDictionaryForSTUC(CFMutableDictionaryRef *matchingDict)
{
    CFMutableDictionaryRef 	subDict;
    
    assert(matchingDict != NULL);
    
    // Create the dictionaries
    *matchingDict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks,
                                              &kCFTypeDictionaryValueCallBacks);
    if (*matchingDict != NULL) {
        subDict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks,
                                            &kCFTypeDictionaryValueCallBacks);
        
        if (subDict != NULL) {
            // Create a dictionary with the "SCSITaskDeviceCategory" key with the appropriate value
            // for the device type we're interested in.
            // for iPods, this key is "iPodUserClientDevice"
            CFDictionarySetValue(subDict, CFSTR(kIOPropertySCSITaskDeviceCategory),
                                 CFSTR("iPodUserClientDevice"));
        }
        
        // Add the dictionary to the main dictionary with the key "IOPropertyMatch" to
        // narrow the search to the above dictionary.
        CFDictionarySetValue(*matchingDict, CFSTR(kIOPropertyMatchKey), subDict);
        
        CFRelease(subDict);
    }
}

// 查找使用STUC的iPods
boolean_t FindiPodsUsingSTUC(mach_port_t masterPort,
                             io_iterator_t *iterator)
{
    CFMutableDictionaryRef	matchingDict = NULL;
    boolean_t				result = false;
    
    // Set up a matching dictionary to search the I/O Registry for SCSI devices
    // we are interested in
    CreateMatchingDictionaryForSTUC(&matchingDict);
    
    //NSMutableDictionary *dic = (NSMutableDictionary*)matchingDict;
    
    if (matchingDict == NULL) {
        fprintf(stderr, "xxxxxxxx Couldn't create a matching dictionary.\n");
    }
    else {
		kern_return_t	kr;
        
        // Now search I/O Registry for matching devices.
        kr = IOServiceGetMatchingServices(masterPort, matchingDict, iterator);
        
        if (*iterator && kr == kIOReturnSuccess) {
            result = true;
        }
    }
    
    // IOServiceGetMatchingServices consumes a reference to the
    // matching dictionary, so we don't need to release the dictionary ref.
    
    return result;
}