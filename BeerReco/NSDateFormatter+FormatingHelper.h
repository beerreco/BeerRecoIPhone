//
//  NSDateFormatter+FormatingHelper.h
//  Pythia
//
//  Created by Admin on 1/24/13.
//  Copyright (c) 2013 ThreeMind. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DateFormat_ShortDate @"MMM d',' yyyy"
#define DateFormat_ShortDateAtTime @"MMM d',' yyyy 'at' h':'mm a"

#define Locale_US @"en_US"

@interface NSDateFormatter (FormatingHelper)

+(NSDate*)getDateFromString:(NSString*)string withFormat:(NSString*)format andLocale:(NSString*)locale;

+(NSString*)getStringFromDate:(NSDate*)date withFormat:(NSString*)format andLocale:(NSString*)locale;

+(NSDate*)getDateFromWindowsTimestamp:(NSString*)timestamp;

+(NSNumber*)getWindowsTimestampFromDate:(NSDate*)date;

+(NSString *)getTimeStringFromSeconds:(int)seconds andPadded:(BOOL)padded;

+(NSString *)getTimeStringFromSeconds:(int) seconds;

@end
