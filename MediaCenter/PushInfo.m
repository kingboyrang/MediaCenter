//
//  PushInfo.m
//  CaseSearch
//
//  Created by aJia on 12/11/26.
//  Copyright (c) 2012年 rang. All rights reserved.
//

#import "PushInfo.h"
#import "FileHelper.h"
#import "GDataXMLNode.h"
@implementation PushInfo
@synthesize Groups,Accounts,Apps,Title,Content;

+(void)writeToPushFile:(NSMutableDictionary*)dic{
    if ([dic count]==0) {
        return;
    }
    NSMutableArray *arr=[AppHelper fileNameToPush];
    BOOL b=YES;
    for (NSDictionary *item in arr) {
        if ([[item objectForKey:@"GUID"] isEqualToString:[dic objectForKey:@"GUID"]]) {
            b=NO;
            break;
        }
    }
    if (b) {
        [arr addObject:dic];
        [FileHelper ContentToFile:arr withFileName:@"MediaCenterPush.plist"];//写入文件中
    }
}
+(NSMutableDictionary*)PushToDictionary:(NSString*)xml{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    NSError *error=nil;
    GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
    if (error) {
        [document release];
        return dic;
    }
    GDataXMLElement* rootNode = [document rootElement];
    NSArray *rootChilds=[rootNode children];
    for (GDataXMLNode *node in rootChilds){
        [dic setValue:[node stringValue] forKey:node.name];
    }
    return dic;
}
+(NSMutableDictionary*)PushStringToDictionary:(NSString*)str{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    int i=0;
    NSRange r=[str rangeOfString:@"|"];
    while (r.location!=NSNotFound) {
        int pos=r.location;
        if (i==0) {
            [dic setValue:[str substringWithRange:NSMakeRange(0, pos)] forKey:@"Type"];
        }
        if(i==1){
          [dic setValue:[str substringWithRange:NSMakeRange(0, pos)] forKey:@"GUID"];
        }
        
        str=[str stringByReplacingCharactersInRange:NSMakeRange(0, pos+1) withString:@""];
        r=[str rangeOfString:@"|"];
        i++;
    }
    [dic setValue:str forKey:@"Title"];
    return dic;
}
//使用的是这个方法
/*****推播信息的两种格式
 ***9|guid|标题
 ***1|guid|密码|编号|类别名称
 ****/
+(NSMutableDictionary*)PushCheckStringToDictionary:(NSString*)str{
    NSArray *arr=[str componentsSeparatedByString:@"|"];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if ([arr count]==3) {
        [dic setValue:[arr objectAtIndex:0] forKey:@"Type"];
        [dic setValue:[arr objectAtIndex:1] forKey:@"GUID"];
        [dic setValue:[arr objectAtIndex:2] forKey:@"Title"];
    }else{
        if ([arr count]==5) {
            [dic setValue:[arr objectAtIndex:0] forKey:@"Type"];
            [dic setValue:[arr objectAtIndex:1] forKey:@"GUID"];
            [dic setValue:[arr objectAtIndex:2] forKey:@"PWD"];
            NSString *msg=[NSString stringWithFormat:@"%@%@",[arr objectAtIndex:3],[arr objectAtIndex:4]];
            [dic setValue:msg forKey:@"Title"];
            
        }else{
            [dic setValue:@"1" forKey:@"Type"];
            [dic setValue:@"" forKey:@"GUID"];
            [dic setValue:@"" forKey:@"Title"];
        }
    }
    return dic;

    
}
+(NSDictionary*)ItemPushDictionary:(NSString*)guid{
    NSDictionary *dic=[NSDictionary dictionary];
    NSMutableArray *arr=[AppHelper fileNameToPush];
    for (NSDictionary *item in arr) {
        if ([[item objectForKey:@"GUID"] isEqualToString:guid]) {
            dic=item;
            break;
        }
    }
    return dic;
}
+(NSString*)formatCreateTime:(NSString*)date{
    if (date==nil||date==NULL||[date length]==0) {
        return @"";
    }
    date=[date stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSRange range = [date  rangeOfString:@":" options:NSBackwardsSearch];
    if (range.location!=NSNotFound) {
        int pos=range.location;
        date=[date substringWithRange:NSMakeRange(0, pos)];
    }
    return date;
    //int y=[[date substringWithRange:NSMakeRange(0, 4)] intValue];
    //return [NSString stringWithFormat:@"%d%@",y-1911,[date stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""]];
    
}
@end

