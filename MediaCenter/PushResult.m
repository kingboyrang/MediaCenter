//
//  Push.m
//  Eland
//
//  Created by aJia on 13/10/9.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "PushResult.h"
#import "CacheHelper.h"
@implementation PushResult
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.ID forKey:@"ID"];
    [encoder encodeObject:self.GUID forKey:@"GUID"];
    [encoder encodeObject:self.Author forKey:@"Author"];
    [encoder encodeObject:self.Created forKey:@"Created"];
    [encoder encodeObject:self.Subject forKey:@"Subject"];
    [encoder encodeObject:self.Body forKey:@"Body"];
    
    [encoder encodeObject:self.Source forKey:@"Source"];
    [encoder encodeObject:self.Category forKey:@"Category"];
    [encoder encodeObject:self.Receive forKey:@"Receive"];
    [encoder encodeObject:self.Immediate forKey:@"Immediate"];
    [encoder encodeObject:self.SendTime forKey:@"SendTime"];
    [encoder encodeObject:self.StartTime forKey:@"StartTime"];
    [encoder encodeObject:self.AuthToken forKey:@"AuthToken"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        self.ID=[aDecoder decodeObjectForKey:@"ID"];
        self.GUID=[aDecoder decodeObjectForKey:@"GUID"];
        self.Author=[aDecoder decodeObjectForKey:@"Author"];
        self.Created=[aDecoder decodeObjectForKey:@"Created"];
        self.Subject=[aDecoder decodeObjectForKey:@"Subject"];
        self.Body=[aDecoder decodeObjectForKey:@"Body"];
        
        self.Source=[aDecoder decodeObjectForKey:@"Source"];
        self.Category=[aDecoder decodeObjectForKey:@"Category"];
        self.Receive=[aDecoder decodeObjectForKey:@"Receive"];
        self.Immediate=[aDecoder decodeObjectForKey:@"Immediate"];
        self.SendTime=[aDecoder decodeObjectForKey:@"SendTime"];
        self.StartTime=[aDecoder decodeObjectForKey:@"StartTime"];
        self.AuthToken=[aDecoder decodeObjectForKey:@"AuthToken"];
    }
    return self;
}
+(PushResult*)PushResultWithGuid:(NSString*)guid{
    PushResult *entity=[[[PushResult alloc] init] autorelease];
    entity.ID=@"";
    entity.GUID=guid;
    entity.Author=@"";
    entity.Created=@"";
    entity.Subject=@"";
    entity.Body=@"";
    
    entity.Source=@"";
    entity.Category=@"";
    entity.Receive=@"";
    entity.Immediate=@"";
    entity.SendTime=@"";
    entity.StartTime=@"";
    entity.AuthToken=@"";
    return entity;
}
-(NSString*)getPropertyValue:(NSString*)field{
    if (field==nil||[field length]==0) {
        return @"";
    }
    return field;
}
-(NSString*)HtmlBody{
    if (_Body&&[_Body length]>0) {
        NSString *str=[_Body stringByReplacingOccurrencesOfString:@"<url>" withString:@""];
        str=[str stringByReplacingOccurrencesOfString:@"</url>" withString:@""];
        return str;
    }
    return @"";
}
//通报时间
-(NSString*)formatDataTw{
    NSString *date=[self getPropertyValue:self.SendTime];
    if ([date length]==0) {return @"";}
    date=[date stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSRange range = [date  rangeOfString:@":" options:NSBackwardsSearch];
    if (range.location!=NSNotFound) {
        int pos=range.location;
        date=[date substringWithRange:NSMakeRange(0, pos)];
    }
    int y=[[date substringWithRange:NSMakeRange(0, 4)] intValue];
    return [NSString stringWithFormat:@"%d%@",y-1911,[date stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""]];
}
+(BOOL)existsPushResultWithGuid:(NSString*)guid index:(int*)pos{
    NSArray *arr=[CacheHelper readCacheCasePush];
    if (arr&&[arr count]>0) {
        NSString *match=[NSString stringWithFormat:@"SELF.GUID =='%@'",guid];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:match];
        NSArray *results = [arr filteredArrayUsingPredicate:predicate];
        if (results&&[results count]>0) {
            *pos=[arr indexOfObject:[results objectAtIndex:0]];
            return YES;
        }
    }
    *pos=-1;
    return NO;
}
@end
