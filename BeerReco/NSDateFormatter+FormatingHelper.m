
//
//  NSDateFormatter+FormatingHelper.m
//  Pythia
//
//  Created by Admin on 1/24/13.
//  Copyright (c) 2013 ThreeMind. All rights reserved.
//

#import "NSDateFormatter+FormatingHelper.h"

@implementation NSDateFormatter (FormatingHelper)

+(NSDate*)getDateFromString:(NSString*)string withFormat:(NSString*)format andLocale:(NSString*)locale
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:locale];
    [dateFormatter setLocale:usLocale];
    
    return [dateFormatter dateFromString:string];
}

+(NSString*)getStringFromDate:(NSDate*)date withFormat:(NSString*)format andLocale:(NSString*)locale
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:locale];
    [dateFormatter setLocale:usLocale];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];

    return formattedDateString;
}

+(NSDate*)getDateFromWindowsTimestamp:(NSString*)timestamp
{
    if (timestamp == nil || [timestamp isKindOfClass:[NSNull class]] ||  ![timestamp isKindOfClass:[NSNumber class]])
    {
        return [NSDate dateWithTimeIntervalSinceNow:0];
    }
    
    NSNumber* numValue = (NSNumber*)timestamp;
    
    if (numValue == nil || [numValue isKindOfClass:[NSNull class]])
    {
        return [NSDate dateWithTimeIntervalSinceNow:0];
    }
    
    long long fixedTimestamp = [numValue unsignedLongLongValue] / 1000;
    
    return [NSDate dateWithTimeIntervalSince1970:fixedTimestamp];
}

+(NSNumber*)getWindowsTimestampFromDate:(NSDate*)date
{
    if (date == nil || [date isKindOfClass:([NSNull class])])
    {
        return [NSNumber numberWithLongLong:[NSDate timeIntervalSinceReferenceDate] * 1000];
    }
    
    long long interval = [date timeIntervalSince1970];
    long long windowsInterval = interval * 1000;
    
    return [NSNumber numberWithLongLong:windowsInterval];//[NSString stringWithFormat:@"%d", windowsInterval];
}

+(NSString *)getTimeStringFromSeconds:(int)seconds andPadded:(BOOL)padded
{
    // Return variable.
    NSString *result = @"";
    
    // Int variables for calculation.
    int secs = seconds;
    int tempHour    = 0;
    int tempMinute  = 0;
    int tempSecond  = 0;
    
    NSString *hour      = @"";
    NSString *minute    = @"";
    NSString *second    = @"";
    
    // Convert the seconds to hours, minutes and seconds.
    tempHour    = secs / 3600;
    tempMinute  = secs / 60 - tempHour * 60;
    tempSecond  = secs - (tempHour * 3600 + tempMinute * 60);
    
    hour    = [[NSNumber numberWithInt:tempHour] stringValue];
    minute  = [[NSNumber numberWithInt:tempMinute] stringValue];
    second  = [[NSNumber numberWithInt:tempSecond] stringValue];
    
    // Make time look like 00:00:00 and not 0:0:0    
    if (tempSecond < 10)
    {
        second = [@"0" stringByAppendingString:second];
    }
    
    if ((padded || tempHour != 0) && tempMinute < 10)
    {
        minute = [@"0" stringByAppendingString:minute];
    }

    if (padded && tempHour < 10)
    {
        hour = [@"0" stringByAppendingString:hour];
    }
    
    if (tempHour == 0)
    {        
        //NSLog(@"Result of Time Conversion: %@:%@", minute, second);
        result = [NSString stringWithFormat:@"%@:%@", minute, second];
    }
    else
    {   
        //NSLog(@"Result of Time Conversion: %@:%@:%@", hour, minute, second);
        result = [NSString stringWithFormat:@"%@:%@:%@",hour, minute, second];
    }
    
    return result;
}

+(NSString *)getTimeStringFromSeconds:(int)seconds
{
    return [NSDateFormatter getTimeStringFromSeconds:seconds andPadded:NO];
}

@end 
