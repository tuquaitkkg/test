
#import "NSDate+zeroTimeDate.h"

@implementation NSDate (zeroTimeDate)
+ (NSDate *)zeroTimeDate:(NSDate *)inDate {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inDate];
    return [calendar dateFromComponents:components];
}
@end
