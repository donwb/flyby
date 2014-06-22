//
//  constants.h
//  NoSdk
//
//  Created by Don Browning on 5/29/14.
//  Copyright (c) 2014 Don Browning. All rights reserved.
//

#ifndef NoSdk_constants_h
#define NoSdk_constants_h

//#define RUN_LOCAL

#ifdef RUN_LOCAL
#define BASE_URL @"http://localhost:3000/"
#else
#define BASE_URL @"http://flyby.cfapps.io/"
#endif

#endif
