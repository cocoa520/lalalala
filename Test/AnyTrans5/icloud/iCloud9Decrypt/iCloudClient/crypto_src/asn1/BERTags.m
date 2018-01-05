//
//  BERTags.m
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BERTags.h"

@implementation BERTags

+ (int)BOOLEAN {
    static int _BOOLEAN = 0;
    @synchronized(self) {
        if (!_BOOLEAN) {
            _BOOLEAN = 1;
        }
    }
    return _BOOLEAN;
}

+ (int)INTEGER {
    static int _INTEGER = 0;
    @synchronized(self) {
        if (!_INTEGER) {
            _INTEGER = 2;
        }
    }
    return _INTEGER;
}

+ (int)BIT_STRING {
    static int _BIT_STRING = 0;
    @synchronized(self) {
        if (!_BIT_STRING) {
            _BIT_STRING = 3;
        }
    }
    return _BIT_STRING;
}

+ (int)OCTET_STRING {
    static int _OCTET_STRING = 0;
    @synchronized(self) {
        if (!_OCTET_STRING) {
            _OCTET_STRING = 4;
        }
    }
    return _OCTET_STRING;
}

+ (int)NULLS {
    static int _NULLS = 0;
    @synchronized(self) {
        if (!_NULLS) {
            _NULLS = 5;
        }
    }
    return _NULLS;
}

+ (int)OBJECT_IDENTIFIER {
    static int _OBJECT_IDENTIFIER = 0;
    @synchronized(self) {
        if (!_OBJECT_IDENTIFIER) {
            _OBJECT_IDENTIFIER = 6;
        }
    }
    return _OBJECT_IDENTIFIER;
}

+ (int)EXTERNAL {
    static int _EXTERNAL = 0;
    @synchronized(self) {
        if (!_EXTERNAL) {
            _EXTERNAL = 8;
        }
    }
    return _EXTERNAL;
}

+ (int)ENUMERATED {
    static int _ENUMERATED = 0;
    @synchronized(self) {
        if (!_ENUMERATED) {
            _ENUMERATED = 10;
        }
    }
    return _ENUMERATED;
}

+ (int)SEQUENCE {
    static int _SEQUENCE = 0;
    @synchronized(self) {
        if (!_SEQUENCE) {
            _SEQUENCE = 16;
        }
    }
    return _SEQUENCE;
}

+ (int)SEQUENCE_OF {
    static int _SEQUENCE_OF = 0;
    @synchronized(self) {
        if (!_SEQUENCE_OF) {
            _SEQUENCE_OF = 16;
        }
    }
    return _SEQUENCE_OF;
}

+ (int)SET {
    static int _SET = 0;
    @synchronized(self) {
        if (!_SET) {
            _SET = 17;
        }
    }
    return _SET;
}

+ (int)SET_OF {
    static int _SET_OF = 0;
    @synchronized(self) {
        if (!_SET_OF) {
            _SET_OF = 17;
        }
    }
    return _SET_OF;
}

+ (int)NUMERIC_STRING {
    static int _NUMERIC_STRING = 0;
    @synchronized(self) {
        if (!_NUMERIC_STRING) {
            _NUMERIC_STRING = 18;
        }
    }
    return _NUMERIC_STRING;
}

+ (int)PRINTABLE_STRING {
    static int _PRINTABLE_STRING = 0;
    @synchronized(self) {
        if (!_PRINTABLE_STRING) {
            _PRINTABLE_STRING = 19;
        }
    }
    return _PRINTABLE_STRING;
}

+ (int)T61_STRING {
    static int _T61_STRING = 0;
    @synchronized(self) {
        if (!_T61_STRING) {
            _T61_STRING = 20;
        }
    }
    return _T61_STRING;
}

+ (int)VIDEOTEX_STRING {
    static int _VIDEOTEX_STRING = 0;
    @synchronized(self) {
        if (!_VIDEOTEX_STRING) {
            _VIDEOTEX_STRING = 21;
        }
    }
    return _VIDEOTEX_STRING;
}

+ (int)IA5_STRING {
    static int _IA5_STRING = 0;
    @synchronized(self) {
        if (!_IA5_STRING) {
            _IA5_STRING = 22;
        }
    }
    return _IA5_STRING;
}

+ (int)UTC_TIME {
    static int _UTC_TIME = 0;
    @synchronized(self) {
        if (!_UTC_TIME) {
            _UTC_TIME = 23;
        }
    }
    return _UTC_TIME;
}

+ (int)GENERALIZED_TIME {
    static int _GENERALIZED_TIME = 0;
    @synchronized(self) {
        if (!_GENERALIZED_TIME) {
            _GENERALIZED_TIME = 24;
        }
    }
    return _GENERALIZED_TIME;
}

+ (int)GRAPHIC_STRING {
    static int _GRAPHIC_STRING = 0;
    @synchronized(self) {
        if (!_GRAPHIC_STRING) {
            _GRAPHIC_STRING = 25;
        }
    }
    return _GRAPHIC_STRING;
}

+ (int)VISIBLE_STRING {
    static int _VISIBLE_STRING = 0;
    @synchronized(self) {
        if (!_VISIBLE_STRING) {
            _VISIBLE_STRING = 26;
        }
    }
    return _VISIBLE_STRING;
}

+ (int)GENERAL_STRING {
    static int _GENERAL_STRING = 0;
    @synchronized(self) {
        if (!_GENERAL_STRING) {
            _GENERAL_STRING = 27;
        }
    }
    return _GENERAL_STRING;
}

+ (int)UNIVERSAL_STRING {
    static int _UNIVERSAL_STRING = 0;
    @synchronized(self) {
        if (!_UNIVERSAL_STRING) {
            _UNIVERSAL_STRING = 28;
        }
    }
    return _UNIVERSAL_STRING;
}

+ (int)BMP_STRING {
    static int _BMP_STRING = 0;
    @synchronized(self) {
        if (!_BMP_STRING) {
            _BMP_STRING = 30;
        }
    }
    return _BMP_STRING;
}

+ (int)UTF8_STRING {
    static int _UTF8_STRING = 0;
    @synchronized(self) {
        if (!_UTF8_STRING) {
            _UTF8_STRING = 12;
        }
    }
    return _UTF8_STRING;
}

+ (int)CONSTRUCTED {
    static int _CONSTRUCTED = 0;
    @synchronized(self) {
        if (!_CONSTRUCTED) {
            _CONSTRUCTED = 32;
        }
    }
    return _CONSTRUCTED;
}

+ (int)APPLICATION {
    static int _APPLICATION = 0;
    @synchronized(self) {
        if (!_APPLICATION) {
            _APPLICATION = 64;
        }
    }
    return _APPLICATION;
}

+ (int)TAGGED {
    static int _TAGGED = 0;
    @synchronized(self) {
        if (!_TAGGED) {
            _TAGGED = 128;
        }
    }
    return _TAGGED;
}

@end
