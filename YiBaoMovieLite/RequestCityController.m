//
//  requestCityController.m
//  YiBaoMovieLite
//
//  Created by MaKai on 13-1-5.
//  Copyright (c) 2013年 MaKai. All rights reserved.
//

#import "RequestCityController.h"
#import "MovieConstants.h"
#import "GDataXMLNode.h"

@implementation RequestCityController
@synthesize downloader = _downloader;
@synthesize responseData = _responseData;
@synthesize responseCitys = _responseCitys;

- (void)dealloc 
{
    [_downloader release];
    [_responseData release];
    [_responseCitys release];
    
    [super dealloc];
}

- (void)requestCitys
{
    NSString *fullpath = [[NSBundle mainBundle] pathForResource:@"request-cinema" ofType:@"xml"];
    NSString *requestString = [[[NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"$_MOVIEID" withString:@""] stringByReplacingOccurrencesOfString:@"$_CITYNAME" withString:@""];
    NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kMovieAPILocation]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = requestData;
    
    self.downloader.delegate = nil;
    DownLoadController *downloader = [[DownLoadController alloc] initWithRequest:request];
    downloader.delegate = self;
    self.downloader = downloader;
    [downloader beginAsyncRequest];
    [downloader release];
}

- (void)responseReceived:(NSMutableData *)responseData
{
    self.responseData = responseData;
    [self downLoadFinish];
}

- (void)downLoadFinish
{
    NSLog(@"%@",[[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] autorelease]);
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.responseData options:0 error:nil];
    NSArray *nodes = [document nodesForXPath:@"//root//body//rows//wp_cinema" error:nil];
    if (nodes && [nodes count]>0) {
        self.responseCitys = [NSMutableArray array];
        for (GDataXMLElement *node in nodes) {
            NSString *cityName = [[node attributeForName:@"location"] stringValue];
            [self.responseCitys addObject:cityName];
        }
        for (int i=0; i<self.responseCitys.count; i++) {
            NSString *referenceCity = [self.responseCitys objectAtIndex:i];
            for (int j=i+1; j<self.responseCitys.count; ) {
                if ([referenceCity isEqualToString:[self.responseCitys objectAtIndex:j]]) {
                    [self.responseCitys removeObjectAtIndex:j];
                }
                else {
                    j++;
                }
            }
        }
    }
    else {
        self.responseCitys = [NSMutableArray array];
    }
    [document release];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.responseCitys forKey:@"citys"];
}

@end
