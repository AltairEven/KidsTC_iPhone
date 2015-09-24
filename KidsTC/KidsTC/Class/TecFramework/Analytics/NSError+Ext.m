
#import "NSError+Ext.h"

@implementation NSError (Icson)

+ (NSError *)ErrorWithCode:(int)code
                   description:(NSString *)description 
                      userinfo:(NSDictionary *)userinfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:userinfo];
    [dict setValue:description forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:@"DefaultError" code:code userInfo:dict];
}

+ (NSError *)ErrorWithCode:(int)code description:(NSString *)description
{
    return [NSError ErrorWithCode:code description:description userinfo:nil];
}

@end
