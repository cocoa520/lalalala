//
//  EACTags.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "EACTags.h"

@implementation EACTags

+ (int)OBJECT_IDENTIFIER {
    static int _OBJECT_IDENTIFIER = 0;
    @synchronized(self) {
        if (!_OBJECT_IDENTIFIER) {
            _OBJECT_IDENTIFIER = 6;
        }
    }
    return _OBJECT_IDENTIFIER;
}

+ (int)COUNTRY_CODE_NATIONAL_DATA {
    static int _COUNTRY_CODE_NATIONAL_DATA = 0;
    @synchronized(self) {
        if (!_COUNTRY_CODE_NATIONAL_DATA) {
            _COUNTRY_CODE_NATIONAL_DATA = 65;
        }
    }
    return _COUNTRY_CODE_NATIONAL_DATA;
}

+ (int)ISSUER_IDENTIFICATION_NUMBER {
    static int _ISSUER_IDENTIFICATION_NUMBER = 0;
    @synchronized(self) {
        if (!_ISSUER_IDENTIFICATION_NUMBER) {
            _ISSUER_IDENTIFICATION_NUMBER = 2;
        }
    }
    return _ISSUER_IDENTIFICATION_NUMBER;
}

+ (int)CARD_SERVICE_DATA {
    static int _CARD_SERVICE_DATA = 0;
    @synchronized(self) {
        if (!_CARD_SERVICE_DATA) {
            _CARD_SERVICE_DATA = 67;
        }
    }
    return _CARD_SERVICE_DATA;
}

+ (int)INITIAL_ACCESS_DATA {
    static int _INITIAL_ACCESS_DATA = 0;
    @synchronized(self) {
        if (!_INITIAL_ACCESS_DATA) {
            _INITIAL_ACCESS_DATA = 68;
        }
    }
    return _INITIAL_ACCESS_DATA;
}

+ (int)CARD_ISSUER_DATA {
    static int _CARD_ISSUER_DATA = 0;
    @synchronized(self) {
        if (!_CARD_ISSUER_DATA) {
            _CARD_ISSUER_DATA = 69;
        }
    }
    return _CARD_ISSUER_DATA;
}

+ (int)PRE_ISSUING_DATA {
    static int _PRE_ISSUING_DATA = 0;
    @synchronized(self) {
        if (!_PRE_ISSUING_DATA) {
            _PRE_ISSUING_DATA = 70;
        }
    }
    return _PRE_ISSUING_DATA;
}

+ (int)CARD_CAPABILITIES {
    static int _CARD_CAPABILITIES = 0;
    @synchronized(self) {
        if (!_CARD_CAPABILITIES) {
            _CARD_CAPABILITIES = 71;
        }
    }
    return _CARD_CAPABILITIES;
}

+ (int)STATUS_INFORMATION {
    static int _STATUS_INFORMATION = 0;
    @synchronized(self) {
        if (!_STATUS_INFORMATION) {
            _STATUS_INFORMATION = 72;
        }
    }
    return _STATUS_INFORMATION;
}

+ (int)EXTENDED_HEADER_LIST {
    static int _EXTENDED_HEADER_LIST = 0;
    @synchronized(self) {
        if (!_EXTENDED_HEADER_LIST) {
            _EXTENDED_HEADER_LIST = 77;
        }
    }
    return _EXTENDED_HEADER_LIST;
}

+ (int)APPLICATION_IDENTIFIER {
    static int _APPLICATION_IDENTIFIER = 0;
    @synchronized(self) {
        if (!_APPLICATION_IDENTIFIER) {
            _APPLICATION_IDENTIFIER = 79;
        }
    }
    return _APPLICATION_IDENTIFIER;
}

+ (int)APPLICATION_LABEL {
    static int _APPLICATION_LABEL = 0;
    @synchronized(self) {
        if (!_APPLICATION_LABEL) {
            _APPLICATION_LABEL = 80;
        }
    }
    return _APPLICATION_LABEL;
}

+ (int)FILE_REFERENCE {
    static int _FILE_REFERENCE = 0;
    @synchronized(self) {
        if (!_FILE_REFERENCE) {
            _FILE_REFERENCE = 81;
        }
    }
    return _FILE_REFERENCE;
}

+ (int)COMMAND_TO_PERFORM {
    static int _COMMAND_TO_PERFORM = 0;
    @synchronized(self) {
        if (!_COMMAND_TO_PERFORM) {
            _COMMAND_TO_PERFORM = 82;
        }
    }
    return _COMMAND_TO_PERFORM;
}

+ (int)DISCRETIONARY_DATA {
    static int _DISCRETIONARY_DATA = 0;
    @synchronized(self) {
        if (!_DISCRETIONARY_DATA) {
            _DISCRETIONARY_DATA = 83;
        }
    }
    return _DISCRETIONARY_DATA;
}

+ (int)OFFSET_DATA_OBJECT {
    static int _OFFSET_DATA_OBJECT = 0;
    @synchronized(self) {
        if (!_OFFSET_DATA_OBJECT) {
            _OFFSET_DATA_OBJECT = 84;
        }
    }
    return _OFFSET_DATA_OBJECT;
}

+ (int)TRACK1_APPLICATION {
    static int _TRACK1_APPLICATION = 0;
    @synchronized(self) {
        if (!_TRACK1_APPLICATION) {
            _TRACK1_APPLICATION = 86;
        }
    }
    return _TRACK1_APPLICATION;
}

+ (int)TRACK2_APPLICATION {
    static int _TRACK2_APPLICATION = 0;
    @synchronized(self) {
        if (!_TRACK2_APPLICATION) {
            _TRACK2_APPLICATION = 87;
        }
    }
    return _TRACK2_APPLICATION;
}

+ (int)TRACK3_APPLICATION {
    static int _TRACK3_APPLICATION = 0;
    @synchronized(self) {
        if (!_TRACK3_APPLICATION) {
            _TRACK3_APPLICATION = 88;
        }
    }
    return _TRACK3_APPLICATION;
}

+ (int)CARD_EXPIRATION_DATA {
    static int _CARD_EXPIRATION_DATA = 0;
    @synchronized(self) {
        if (!_CARD_EXPIRATION_DATA) {
            _CARD_EXPIRATION_DATA = 89;
        }
    }
    return _CARD_EXPIRATION_DATA;
}

+ (int)PRIMARY_ACCOUNT_NUMBER {
    static int _PRIMARY_ACCOUNT_NUMBER = 0;
    @synchronized(self) {
        if (!_PRIMARY_ACCOUNT_NUMBER) {
            _PRIMARY_ACCOUNT_NUMBER = 90;
        }
    }
    return _PRIMARY_ACCOUNT_NUMBER;
}

+ (int)NAME {
    static int _NAME = 0;
    @synchronized(self) {
        if (!_NAME) {
            _NAME = 91;
        }
    }
    return _NAME;
}

+ (int)TAG_LIST {
    static int _TAG_LIST = 0;
    @synchronized(self) {
        if (!_TAG_LIST) {
            _TAG_LIST = 92;
        }
    }
    return _TAG_LIST;
}

+ (int)HEADER_LIST {
    static int _HEADER_LIST = 0;
    @synchronized(self) {
        if (!_HEADER_LIST) {
            _HEADER_LIST = 93;
        }
    }
    return _HEADER_LIST;
}

+ (int)LOGIN_DATA {
    static int _LOGIN_DATA = 0;
    @synchronized(self) {
        if (!_LOGIN_DATA) {
            _LOGIN_DATA = 94;
        }
    }
    return _LOGIN_DATA;
}

+ (int)CARDHOLDER_NAME {
    static int _CARDHOLDER_NAME = 0;
    @synchronized(self) {
        if (!_CARDHOLDER_NAME) {
            _CARDHOLDER_NAME = 32;
        }
    }
    return _CARDHOLDER_NAME;
}

+ (int)TRACK1_CARD {
    static int _TRACK1_CARD = 0;
    @synchronized(self) {
        if (!_TRACK1_CARD) {
            _TRACK1_CARD = 24353;
        }
    }
    return _TRACK1_CARD;
}

+ (int)TRACK2_CARD {
    static int _TRACK2_CARD = 0;
    @synchronized(self) {
        if (!_TRACK2_CARD) {
            _TRACK2_CARD = 24354;
        }
    }
    return _TRACK2_CARD;
}

+ (int)TRACK3_CARD {
    static int _TRACK3_CARD = 0;
    @synchronized(self) {
        if (!_TRACK3_CARD) {
            _TRACK3_CARD = 24355;
        }
    }
    return _TRACK3_CARD;
}

+ (int)APPLICATION_EXPIRATION_DATE {
    static int _APPLICATION_EXPIRATION_DATE = 0;
    @synchronized(self) {
        if (!_APPLICATION_EXPIRATION_DATE) {
            _APPLICATION_EXPIRATION_DATE = 36;
        }
    }
    return _APPLICATION_EXPIRATION_DATE;
}

+ (int)APPLICATION_EFFECTIVE_DATE {
    static int _APPLICATION_EFFECTIVE_DATE = 0;
    @synchronized(self) {
        if (!_APPLICATION_EFFECTIVE_DATE) {
            _APPLICATION_EFFECTIVE_DATE = 37;
        }
    }
    return _APPLICATION_EFFECTIVE_DATE;
}

+ (int)CARD_EFFECTIVE_DATE {
    static int _CARD_EFFECTIVE_DATE = 0;
    @synchronized(self) {
        if (!_CARD_EFFECTIVE_DATE) {
            _CARD_EFFECTIVE_DATE = 24358;
        }
    }
    return _CARD_EFFECTIVE_DATE;
}

+ (int)INTERCHANGE_CONTROL {
    static int _INTERCHANGE_CONTROL = 0;
    @synchronized(self) {
        if (!_INTERCHANGE_CONTROL) {
            _INTERCHANGE_CONTROL = 24359;
        }
    }
    return _INTERCHANGE_CONTROL;
}

+ (int)COUNTRY_CODE {
    static int _COUNTRY_CODE = 0;
    @synchronized(self) {
        if (!_COUNTRY_CODE) {
            _COUNTRY_CODE = 24360;
        }
    }
    return _COUNTRY_CODE;
}

+ (int)INTERCHANGE_PROFILE {
    static int _INTERCHANGE_PROFILE = 0;
    @synchronized(self) {
        if (!_INTERCHANGE_PROFILE) {
            _INTERCHANGE_PROFILE = 41;
        }
    }
    return _INTERCHANGE_PROFILE;
}

+ (int)CURRENCY_CODE {
    static int _CURRENCY_CODE = 0;
    @synchronized(self) {
        if (!_CURRENCY_CODE) {
            _CURRENCY_CODE = 24362;
        }
    }
    return _CURRENCY_CODE;
}

+ (int)DATE_OF_BIRTH {
    static int _DATE_OF_BIRTH = 0;
    @synchronized(self) {
        if (!_DATE_OF_BIRTH) {
            _DATE_OF_BIRTH = 24363;
        }
    }
    return _DATE_OF_BIRTH;
}

+ (int)CARDHOLDER_NATIONALITY {
    static int _CARDHOLDER_NATIONALITY = 0;
    @synchronized(self) {
        if (!_CARDHOLDER_NATIONALITY) {
            _CARDHOLDER_NATIONALITY = 24364;
        }
    }
    return _CARDHOLDER_NATIONALITY;
}

+ (int)LANGUAGE_PREFERENCES {
    static int _LANGUAGE_PREFERENCES = 0;
    @synchronized(self) {
        if (!_LANGUAGE_PREFERENCES) {
            _LANGUAGE_PREFERENCES = 24365;
        }
    }
    return _LANGUAGE_PREFERENCES;
}

+ (int)CARDHOLDER_BIOMETRIC_DATA {
    static int _CARDHOLDER_BIOMETRIC_DATA = 0;
    @synchronized(self) {
        if (!_CARDHOLDER_BIOMETRIC_DATA) {
            _CARDHOLDER_BIOMETRIC_DATA = 24366;
        }
    }
    return _CARDHOLDER_BIOMETRIC_DATA;
}

+ (int)PIN_USAGE_POLICY {
    static int _PIN_USAGE_POLICY = 0;
    @synchronized(self) {
        if (!_PIN_USAGE_POLICY) {
            _PIN_USAGE_POLICY = 24367;
        }
    }
    return _PIN_USAGE_POLICY;
}

+ (int)SERVICE_CODE {
    static int _SERVICE_CODE = 0;
    @synchronized(self) {
        if (!_SERVICE_CODE) {
            _SERVICE_CODE = 24368;
        }
    }
    return _SERVICE_CODE;
}

+ (int)TRANSACTION_COUNTER {
    static int _TRANSACTION_COUNTER = 0;
    @synchronized(self) {
        if (!_TRANSACTION_COUNTER) {
            _TRANSACTION_COUNTER = 24370;
        }
    }
    return _TRANSACTION_COUNTER;
}

+ (int)TRANSACTION_DATE {
    static int _TRANSACTION_DATE = 0;
    @synchronized(self) {
        if (!_TRANSACTION_DATE) {
            _TRANSACTION_DATE = 24371;
        }
    }
    return _TRANSACTION_DATE;
}

+ (int)CARD_SEQUENCE_NUMBER {
    static int _CARD_SEQUENCE_NUMBER = 0;
    @synchronized(self) {
        if (!_CARD_SEQUENCE_NUMBER) {
            _CARD_SEQUENCE_NUMBER = 24372;
        }
    }
    return _CARD_SEQUENCE_NUMBER;
}

+ (int)SEX {
    static int _SEX = 0;
    @synchronized(self) {
        if (!_SEX) {
            _SEX = 24373;
        }
    }
    return _SEX;
}

+ (int)CURRENCY_EXPONENT {
    static int _CURRENCY_EXPONENT = 0;
    @synchronized(self) {
        if (!_CURRENCY_EXPONENT) {
            _CURRENCY_EXPONENT = 24374;
        }
    }
    return _CURRENCY_EXPONENT;
}

+ (int)STATIC_INTERNAL_AUTHENTIFICATION_ONE_STEP {
    static int _STATIC_INTERNAL_AUTHENTIFICATION_ONE_STEP = 0;
    @synchronized(self) {
        if (!_STATIC_INTERNAL_AUTHENTIFICATION_ONE_STEP) {
            _STATIC_INTERNAL_AUTHENTIFICATION_ONE_STEP = 55;
        }
    }
    return _STATIC_INTERNAL_AUTHENTIFICATION_ONE_STEP;
}

+ (int)SIGNATURE {
    static int _SIGNATURE = 0;
    @synchronized(self) {
        if (!_SIGNATURE) {
            _SIGNATURE = 24375;
        }
    }
    return _SIGNATURE;
}

+ (int)STATIC_INTERNAL_AUTHENTIFICATION_FIRST_DATA {
    static int _STATIC_INTERNAL_AUTHENTIFICATION_FIRST_DATA = 0;
    @synchronized(self) {
        if (!_STATIC_INTERNAL_AUTHENTIFICATION_FIRST_DATA) {
            _STATIC_INTERNAL_AUTHENTIFICATION_FIRST_DATA = 24376;
        }
    }
    return _STATIC_INTERNAL_AUTHENTIFICATION_FIRST_DATA;
}

+ (int)STATIC_INTERNAL_AUTHENTIFICATION_SECOND_DATA {
    static int _STATIC_INTERNAL_AUTHENTIFICATION_SECOND_DATA = 0;
    @synchronized(self) {
        if (!_STATIC_INTERNAL_AUTHENTIFICATION_SECOND_DATA) {
            _STATIC_INTERNAL_AUTHENTIFICATION_SECOND_DATA = 24377;
        }
    }
    return _STATIC_INTERNAL_AUTHENTIFICATION_SECOND_DATA;
}

+ (int)DYNAMIC_INTERNAL_AUTHENTIFICATION {
    static int _DYNAMIC_INTERNAL_AUTHENTIFICATION = 0;
    @synchronized(self) {
        if (!_DYNAMIC_INTERNAL_AUTHENTIFICATION) {
            _DYNAMIC_INTERNAL_AUTHENTIFICATION = 24378;
        }
    }
    return _DYNAMIC_INTERNAL_AUTHENTIFICATION;
}

+ (int)DYNAMIC_EXTERNAL_AUTHENTIFICATION {
    static int _DYNAMIC_EXTERNAL_AUTHENTIFICATION = 0;
    @synchronized(self) {
        if (!_DYNAMIC_EXTERNAL_AUTHENTIFICATION) {
            _DYNAMIC_EXTERNAL_AUTHENTIFICATION = 24379;
        }
    }
    return _DYNAMIC_EXTERNAL_AUTHENTIFICATION;
}

+ (int)DYNAMIC_MUTUAL_AUTHENTIFICATION {
    static int _DYNAMIC_MUTUAL_AUTHENTIFICATION = 0;
    @synchronized(self) {
        if (!_DYNAMIC_MUTUAL_AUTHENTIFICATION) {
            _DYNAMIC_MUTUAL_AUTHENTIFICATION = 24380;
        }
    }
    return _DYNAMIC_MUTUAL_AUTHENTIFICATION;
}

+ (int)CARDHOLDER_PORTRAIT_IMAGE {
    static int _CARDHOLDER_PORTRAIT_IMAGE = 0;
    @synchronized(self) {
        if (!_CARDHOLDER_PORTRAIT_IMAGE) {
            _CARDHOLDER_PORTRAIT_IMAGE = 24384;
        }
    }
    return _CARDHOLDER_PORTRAIT_IMAGE;
}

+ (int)ELEMENT_LIST {
    static int _ELEMENT_LIST = 0;
    @synchronized(self) {
        if (!_ELEMENT_LIST) {
            _ELEMENT_LIST = 24385;
        }
    }
    return _ELEMENT_LIST;
}

+ (int)ADDRESS {
    static int _ADDRESS = 0;
    @synchronized(self) {
        if (!_ADDRESS) {
            _ADDRESS = 24386;
        }
    }
    return _ADDRESS;
}

+ (int)CARDHOLDER_HANDWRITTEN_SIGNATURE {
    static int _CARDHOLDER_HANDWRITTEN_SIGNATURE = 0;
    @synchronized(self) {
        if (!_CARDHOLDER_HANDWRITTEN_SIGNATURE) {
            _CARDHOLDER_HANDWRITTEN_SIGNATURE = 24387;
        }
    }
    return _CARDHOLDER_HANDWRITTEN_SIGNATURE;
}

+ (int)APPLICATION_IMAGE {
    static int _APPLICATION_IMAGE = 0;
    @synchronized(self) {
        if (!_APPLICATION_IMAGE) {
            _APPLICATION_IMAGE = 24388;
        }
    }
    return _APPLICATION_IMAGE;
}

+ (int)DISPLAY_IMAGE {
    static int _DISPLAY_IMAGE = 0;
    @synchronized(self) {
        if (!_DISPLAY_IMAGE) {
            _DISPLAY_IMAGE = 24389;
        }
    }
    return _DISPLAY_IMAGE;
}

+ (int)TIMER {
    static int _TIMER = 0;
    @synchronized(self) {
        if (!_TIMER) {
            _TIMER = 24390;
        }
    }
    return _TIMER;
}

+ (int)MESSAGE_REFERENCE {
    static int _MESSAGE_REFERENCE = 0;
    @synchronized(self) {
        if (!_MESSAGE_REFERENCE) {
            _MESSAGE_REFERENCE = 24391;
        }
    }
    return _MESSAGE_REFERENCE;
}

+ (int)CARDHOLDER_PRIVATE_KEY {
    static int _CARDHOLDER_PRIVATE_KEY = 0;
    @synchronized(self) {
        if (!_CARDHOLDER_PRIVATE_KEY) {
            _CARDHOLDER_PRIVATE_KEY = 24392;
        }
    }
    return _CARDHOLDER_PRIVATE_KEY;
}

+ (int)CARDHOLDER_PUBLIC_KEY {
    static int _CARDHOLDER_PUBLIC_KEY = 0;
    @synchronized(self) {
        if (!_CARDHOLDER_PUBLIC_KEY) {
            _CARDHOLDER_PUBLIC_KEY = 24393;
        }
    }
    return _CARDHOLDER_PUBLIC_KEY;
}

+ (int)CERTIFICATION_AUTHORITY_PUBLIC_KEY {
    static int _CERTIFICATION_AUTHORITY_PUBLIC_KEY = 0;
    @synchronized(self) {
        if (!_CERTIFICATION_AUTHORITY_PUBLIC_KEY) {
            _CERTIFICATION_AUTHORITY_PUBLIC_KEY = 24394;
        }
    }
    return _CERTIFICATION_AUTHORITY_PUBLIC_KEY;
}

+ (int)DEPRECATED {
    static int _DEPRECATED = 0;
    @synchronized(self) {
        if (!_DEPRECATED) {
            _DEPRECATED = 24395;
        }
    }
    return _DEPRECATED;
}

+ (int)CERTIFICATE_HOLDER_AUTHORIZATION {
    static int _CERTIFICATE_HOLDER_AUTHORIZATION = 0;
    @synchronized(self) {
        if (!_CERTIFICATE_HOLDER_AUTHORIZATION) {
            _CERTIFICATE_HOLDER_AUTHORIZATION = 24396;
        }
    }
    return _CERTIFICATE_HOLDER_AUTHORIZATION;
}

+ (int)INTEGRATED_CIRCUIT_MANUFACTURER_ID {
    static int _INTEGRATED_CIRCUIT_MANUFACTURER_ID = 0;
    @synchronized(self) {
        if (!_INTEGRATED_CIRCUIT_MANUFACTURER_ID) {
            _INTEGRATED_CIRCUIT_MANUFACTURER_ID = 24397;
        }
    }
    return _INTEGRATED_CIRCUIT_MANUFACTURER_ID;
}

+ (int)CERTIFICATE_CONTENT {
    static int _CERTIFICATE_CONTENT = 0;
    @synchronized(self) {
        if (!_CERTIFICATE_CONTENT) {
            _CERTIFICATE_CONTENT = 24398;
        }
    }
    return _CERTIFICATE_CONTENT;
}

+ (int)UNIFORM_RESOURCE_LOCATOR {
    static int _UNIFORM_RESOURCE_LOCATOR = 0;
    @synchronized(self) {
        if (!_UNIFORM_RESOURCE_LOCATOR) {
            _UNIFORM_RESOURCE_LOCATOR = 24400;
        }
    }
    return _UNIFORM_RESOURCE_LOCATOR;
}

+ (int)ANSWER_TO_RESET {
    static int _ANSWER_TO_RESET = 0;
    @synchronized(self) {
        if (!_ANSWER_TO_RESET) {
            _ANSWER_TO_RESET = 24401;
        }
    }
    return _ANSWER_TO_RESET;
}

+ (int)HISTORICAL_BYTES {
    static int _HISTORICAL_BYTES = 0;
    @synchronized(self) {
        if (!_HISTORICAL_BYTES) {
            _HISTORICAL_BYTES = 24402;
        }
    }
    return _HISTORICAL_BYTES;
}

+ (int)DIGITAL_SIGNATURE {
    static int _DIGITAL_SIGNATURE = 0;
    @synchronized(self) {
        if (!_DIGITAL_SIGNATURE) {
            _DIGITAL_SIGNATURE = 24381;
        }
    }
    return _DIGITAL_SIGNATURE;
}

+ (int)APPLICATION_TEMPLATE {
    static int _APPLICATION_TEMPLATE = 0;
    @synchronized(self) {
        if (!_APPLICATION_TEMPLATE) {
            _APPLICATION_TEMPLATE = 97;
        }
    }
    return _APPLICATION_TEMPLATE;
}

+ (int)FCP_TEMPLATE {
    static int _FCP_TEMPLATE = 0;
    @synchronized(self) {
        if (!_FCP_TEMPLATE) {
            _FCP_TEMPLATE = 98;
        }
    }
    return _FCP_TEMPLATE;
}

+ (int)WRAPPER {
    static int _WRAPPER = 0;
    @synchronized(self) {
        if (!_WRAPPER) {
            _WRAPPER = 99;
        }
    }
    return _WRAPPER;
}

+ (int)FMD_TEMPLATE {
    static int _FMD_TEMPLATE = 0;
    @synchronized(self) {
        if (!_FMD_TEMPLATE) {
            _FMD_TEMPLATE = 100;
        }
    }
    return _FMD_TEMPLATE;
}

+ (int)CARDHOLDER_RELATIVE_DATA {
    static int _CARDHOLDER_RELATIVE_DATA = 0;
    @synchronized(self) {
        if (!_CARDHOLDER_RELATIVE_DATA) {
            _CARDHOLDER_RELATIVE_DATA = 101;
        }
    }
    return _CARDHOLDER_RELATIVE_DATA;
}

+ (int)CARD_DATA {
    static int _CARD_DATA = 0;
    @synchronized(self) {
        if (!_CARD_DATA) {
            _CARD_DATA = 102;
        }
    }
    return _CARD_DATA;
}

+ (int)AUTHENTIFICATION_DATA {
    static int _AUTHENTIFICATION_DATA = 0;
    @synchronized(self) {
        if (!_AUTHENTIFICATION_DATA) {
            _AUTHENTIFICATION_DATA = 103;
        }
    }
    return _AUTHENTIFICATION_DATA;
}

+ (int)SPECIAL_USER_REQUIREMENTS {
    static int _SPECIAL_USER_REQUIREMENTS = 0;
    @synchronized(self) {
        if (!_SPECIAL_USER_REQUIREMENTS) {
            _SPECIAL_USER_REQUIREMENTS = 104;
        }
    }
    return _SPECIAL_USER_REQUIREMENTS;
}

+ (int)LOGIN_TEMPLATE {
    static int _LOGIN_TEMPLATE = 0;
    @synchronized(self) {
        if (!_LOGIN_TEMPLATE) {
            _LOGIN_TEMPLATE = 106;
        }
    }
    return _LOGIN_TEMPLATE;
}

+ (int)QUALIFIED_NAME {
    static int _QUALIFIED_NAME = 0;
    @synchronized(self) {
        if (!_QUALIFIED_NAME) {
            _QUALIFIED_NAME = 107;
        }
    }
    return _QUALIFIED_NAME;
}

+ (int)CARDHOLDER_IMAGE_TEMPLATE {
    static int _CARDHOLDER_IMAGE_TEMPLATE = 0;
    @synchronized(self) {
        if (!_CARDHOLDER_IMAGE_TEMPLATE) {
            _CARDHOLDER_IMAGE_TEMPLATE = 108;
        }
    }
    return _CARDHOLDER_IMAGE_TEMPLATE;
}

+ (int)APPLICATION_IMAGE_TEMPLATE {
    static int _APPLICATION_IMAGE_TEMPLATE = 0;
    @synchronized(self) {
        if (!_APPLICATION_IMAGE_TEMPLATE) {
            _APPLICATION_IMAGE_TEMPLATE = 109;
        }
    }
    return _APPLICATION_IMAGE_TEMPLATE;
}

+ (int)APPLICATION_RELATED_DATA {
    static int _APPLICATION_RELATED_DATA = 0;
    @synchronized(self) {
        if (!_APPLICATION_RELATED_DATA) {
            _APPLICATION_RELATED_DATA = 110;
        }
    }
    return _APPLICATION_RELATED_DATA;
}

+ (int)FCI_TEMPLATE {
    static int _FCI_TEMPLATE = 0;
    @synchronized(self) {
        if (!_FCI_TEMPLATE) {
            _FCI_TEMPLATE = 111;
        }
    }
    return _FCI_TEMPLATE;
}

+ (int)DISCRETIONARY_DATA_OBJECTS {
    static int _DISCRETIONARY_DATA_OBJECTS = 0;
    @synchronized(self) {
        if (!_DISCRETIONARY_DATA_OBJECTS) {
            _DISCRETIONARY_DATA_OBJECTS = 115;
        }
    }
    return _DISCRETIONARY_DATA_OBJECTS;
}

+ (int)COMPATIBLE_TAG_ALLOCATION_AUTHORITY {
    static int _COMPATIBLE_TAG_ALLOCATION_AUTHORITY = 0;
    @synchronized(self) {
        if (!_COMPATIBLE_TAG_ALLOCATION_AUTHORITY) {
            _COMPATIBLE_TAG_ALLOCATION_AUTHORITY = 120;
        }
    }
    return _COMPATIBLE_TAG_ALLOCATION_AUTHORITY;
}

+ (int)COEXISTANT_TAG_ALLOCATION_AUTHORITY {
    static int _COEXISTANT_TAG_ALLOCATION_AUTHORITY = 0;
    @synchronized(self) {
        if (!_COEXISTANT_TAG_ALLOCATION_AUTHORITY) {
            _COEXISTANT_TAG_ALLOCATION_AUTHORITY = 121;
        }
    }
    return _COEXISTANT_TAG_ALLOCATION_AUTHORITY;
}

+ (int)SECURITY_SUPPORT_TEMPLATE {
    static int _SECURITY_SUPPORT_TEMPLATE = 0;
    @synchronized(self) {
        if (!_SECURITY_SUPPORT_TEMPLATE) {
            _SECURITY_SUPPORT_TEMPLATE = 122;
        }
    }
    return _SECURITY_SUPPORT_TEMPLATE;
}

+ (int)SECURITY_ENVIRONMENT_TEMPLATE {
    static int _SECURITY_ENVIRONMENT_TEMPLATE = 0;
    @synchronized(self) {
        if (!_SECURITY_ENVIRONMENT_TEMPLATE) {
            _SECURITY_ENVIRONMENT_TEMPLATE = 123;
        }
    }
    return _SECURITY_ENVIRONMENT_TEMPLATE;
}

+ (int)DYNAMIC_AUTHENTIFICATION_TEMPLATE {
    static int _DYNAMIC_AUTHENTIFICATION_TEMPLATE = 0;
    @synchronized(self) {
        if (!_DYNAMIC_AUTHENTIFICATION_TEMPLATE) {
            _DYNAMIC_AUTHENTIFICATION_TEMPLATE = 124;
        }
    }
    return _DYNAMIC_AUTHENTIFICATION_TEMPLATE;
}

+ (int)SECURE_MESSAGING_TEMPLATE {
    static int _SECURE_MESSAGING_TEMPLATE = 0;
    @synchronized(self) {
        if (!_SECURE_MESSAGING_TEMPLATE) {
            _SECURE_MESSAGING_TEMPLATE = 125;
        }
    }
    return _SECURE_MESSAGING_TEMPLATE;
}

+ (int)NON_INTERINDUSTRY_DATA_OBJECT_NESTING_TEMPLATE {
    static int _NON_INTERINDUSTRY_DATA_OBJECT_NESTING_TEMPLATE = 0;
    @synchronized(self) {
        if (!_NON_INTERINDUSTRY_DATA_OBJECT_NESTING_TEMPLATE) {
            _NON_INTERINDUSTRY_DATA_OBJECT_NESTING_TEMPLATE = 126;
        }
    }
    return _NON_INTERINDUSTRY_DATA_OBJECT_NESTING_TEMPLATE;
}

+ (int)DISPLAY_CONTROL {
    static int _DISPLAY_CONTROL = 0;
    @synchronized(self) {
        if (!_DISPLAY_CONTROL) {
            _DISPLAY_CONTROL = 32544;
        }
    }
    return _DISPLAY_CONTROL;
}

+ (int)CARDHOLDER_CERTIFICATE {
    static int _CARDHOLDER_CERTIFICATE = 0;
    @synchronized(self) {
        if (!_CARDHOLDER_CERTIFICATE) {
            _CARDHOLDER_CERTIFICATE = 33;
        }
    }
    return _CARDHOLDER_CERTIFICATE;
}

+ (int)CV_CERTIFICATE {
    static int _CV_CERTIFICATE = 0;
    @synchronized(self) {
        if (!_CV_CERTIFICATE) {
            _CV_CERTIFICATE = 32545;
        }
    }
    return _CV_CERTIFICATE;
}

+ (int)CARDHOLER_REQUIREMENTS_INCLUDED_FEATURES {
    static int _CARDHOLER_REQUIREMENTS_INCLUDED_FEATURES = 0;
    @synchronized(self) {
        if (!_CARDHOLER_REQUIREMENTS_INCLUDED_FEATURES) {
            _CARDHOLER_REQUIREMENTS_INCLUDED_FEATURES = 32546;
        }
    }
    return _CARDHOLER_REQUIREMENTS_INCLUDED_FEATURES;
}

+ (int)CARDHOLER_REQUIREMENTS_EXCLUDED_FEATURES {
    static int _CARDHOLER_REQUIREMENTS_EXCLUDED_FEATURES = 0;
    @synchronized(self) {
        if (!_CARDHOLER_REQUIREMENTS_EXCLUDED_FEATURES) {
            _CARDHOLER_REQUIREMENTS_EXCLUDED_FEATURES = 32547;
        }
    }
    return _CARDHOLER_REQUIREMENTS_EXCLUDED_FEATURES;
}

+ (int)BIOMETRIC_DATA_TEMPLATE {
    static int _BIOMETRIC_DATA_TEMPLATE = 0;
    @synchronized(self) {
        if (!_BIOMETRIC_DATA_TEMPLATE) {
            _BIOMETRIC_DATA_TEMPLATE = 32558;
        }
    }
    return _BIOMETRIC_DATA_TEMPLATE;
}

+ (int)DIGITAL_SIGNATURE_BLOCK {
    static int _DIGITAL_SIGNATURE_BLOCK = 0;
    @synchronized(self) {
        if (!_DIGITAL_SIGNATURE_BLOCK) {
            _DIGITAL_SIGNATURE_BLOCK = 32573;
        }
    }
    return _DIGITAL_SIGNATURE_BLOCK;
}

+ (int)CARDHOLDER_PRIVATE_KEY_TEMPLATE {
    static int _CARDHOLDER_PRIVATE_KEY_TEMPLATE = 0;
    @synchronized(self) {
        if (!_CARDHOLDER_PRIVATE_KEY_TEMPLATE) {
            _CARDHOLDER_PRIVATE_KEY_TEMPLATE = 32584;
        }
    }
    return _CARDHOLDER_PRIVATE_KEY_TEMPLATE;
}

+ (int)CARDHOLDER_PUBLIC_KEY_TEMPLATE {
    static int _CARDHOLDER_PUBLIC_KEY_TEMPLATE = 0;
    @synchronized(self) {
        if (!_CARDHOLDER_PUBLIC_KEY_TEMPLATE) {
            _CARDHOLDER_PUBLIC_KEY_TEMPLATE = 73;
        }
    }
    return _CARDHOLDER_PUBLIC_KEY_TEMPLATE;
}

+ (int)CERTIFICATE_HOLDER_AUTHORIZATION_TEMPLATE {
    static int _CERTIFICATE_HOLDER_AUTHORIZATION_TEMPLATE = 0;
    @synchronized(self) {
        if (!_CERTIFICATE_HOLDER_AUTHORIZATION_TEMPLATE) {
            _CERTIFICATE_HOLDER_AUTHORIZATION_TEMPLATE = 76;
        }
    }
    return _CERTIFICATE_HOLDER_AUTHORIZATION_TEMPLATE;
}

+ (int)CERTIFICATE_CONTENT_TEMPLATE {
    static int _CERTIFICATE_CONTENT_TEMPLATE = 0;
    @synchronized(self) {
        if (!_CERTIFICATE_CONTENT_TEMPLATE) {
            _CERTIFICATE_CONTENT_TEMPLATE = 78;
        }
    }
    return _CERTIFICATE_CONTENT_TEMPLATE;
}

+ (int)CERTIFICATE_BODY {
    static int _CERTIFICATE_BODY = 0;
    @synchronized(self) {
        if (!_CERTIFICATE_BODY) {
            _CERTIFICATE_BODY = 78;
        }
    }
    return _CERTIFICATE_BODY;
}

+ (int)BIOMETRIC_INFORMATION_TEMPLATE {
    static int _BIOMETRIC_INFORMATION_TEMPLATE = 0;
    @synchronized(self) {
        if (!_BIOMETRIC_INFORMATION_TEMPLATE) {
            _BIOMETRIC_INFORMATION_TEMPLATE = 32608;
        }
    }
    return _BIOMETRIC_INFORMATION_TEMPLATE;
}

+ (int)BIOMETRIC_INFORMATION_GROUP_TEMPLATE {
    static int _BIOMETRIC_INFORMATION_GROUP_TEMPLATE = 0;
    @synchronized(self) {
        if (!_BIOMETRIC_INFORMATION_GROUP_TEMPLATE) {
            _BIOMETRIC_INFORMATION_GROUP_TEMPLATE = 32609;
        }
    }
    return _BIOMETRIC_INFORMATION_GROUP_TEMPLATE;
}

+ (int)getTag:(int)paramInt {
    return [EACTags decodeTag:paramInt];
}

+ (int)getTagNo:(int)paramInt {
    for (int i = 24; i >= 0; i -= 8) {
        if ((255 << i & paramInt)) {
            return (255 << i ^ 0xFFFFFFFF) & paramInt;
        }
    }
    return 0;
}

+ (int)encodeTag:(ASN1ApplicationSpecific *)paramASN1ApplicationSpecific {
    int i = 64;
    BOOL result = [paramASN1ApplicationSpecific isConstructed];
    if (result) {
        i |= 0x20;
    }
    int j = [paramASN1ApplicationSpecific getApplicationTag];
    if (j > 31) {
        i |= 0x1F;
        i <<= 8;
        int k = j & 0x7F;
        i |= k;
        j >>= 7;
        while (j > 0) {
            i |= 0x80;
            i <<= 8;
            k = j & 0x7F;
            j >>= 7;
        }
    }else {
        i |= j;
    }
    return i;
}

+ (int)decodeTag:(int)paramInt {
    int i = 0;
    int j = 0;
    for (int k = 24; k >= 0; k -= 8) {
        int m = paramInt >> k & 0xFF;
        if (m) {
            if (j) {
                i <<= 7;
                i |= m & 0x7F;
            }else if ((m & 0x1F) == 31) {
                j = 1;
            }else {
                return m & 0x1F;
            }
        }
    }
    return i;
}

@end
