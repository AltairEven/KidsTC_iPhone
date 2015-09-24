

#import <Foundation/Foundation.h>

@interface NSError (Ext)

+ (NSError*) ErrorWithCode:(int)code description:(NSString*)description;
+ (NSError*) ErrorWithCode:(int)code description:(NSString*)description userinfo:(NSDictionary*)userinfo;

@end
