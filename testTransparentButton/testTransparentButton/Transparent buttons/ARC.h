//
//  ARC.h
//  TestObjectDescription
//
//  Created by Soleil on 4/4/14.
//  Copyright (c) 2014 GMO Runsystem. All rights reserved.
//

#ifndef TestObjectDescription_ARC_h
#define TestObjectDescription_ARC_h

/*
 ARC_RETAIN(p) should be after "="
 ARC_RELEASE not require ';' at tail.
 */

#define ARC_ENABLED __has_feature(objc_arc)
#if ARC_ENABLED
    #define ARC_RETAIN(p)   p
    #define ARC_RELEASE(p)  p = nil;
    #define ARC_AUTO_RELEASE(p) p
    #define ARC_STRONG_OR_RETAIN   strong
#else
    #define ARC_RETAIN(p)   [ p retain ]
    #define ARC_RELEASE(p)  { if (p) {[ p release ]; p = nil; }}
    #define ARC_STRONG_OR_RETAIN   retain
    #define ARC_AUTO_RELEASE(p) [ p autorelease ]
#endif

#endif
