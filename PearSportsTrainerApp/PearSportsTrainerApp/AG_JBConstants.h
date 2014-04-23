//
//  AG_JBConstants.h
//  PearSportsTrainerApp
//
//  Created by Alfonso Garza on 4/23/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#ifndef PearSportsTrainerApp_AG_JBConstants_h
#define PearSportsTrainerApp_AG_JBConstants_h

#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define kJBColorBarChartControllerBackground UIColorFromHex(0x313131)
#define kJBColorBarChartBackground UIColorFromHex(0x3c3c3c)
#define kJBColorBarChartBarBlue UIColorFromHex(0x08bcef)
#define kJBColorBarChartBarGreen UIColorFromHex(0x34b234)
#define kJBColorBarChartHeaderSeparatorColor UIColorFromHex(0x686868)

#endif
