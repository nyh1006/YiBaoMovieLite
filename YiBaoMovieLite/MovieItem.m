//
//  MovieItem.m
//  OnlineTicket
//
//  Created by MaKai on 12-11-19.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "MovieItem.h"

@implementation MovieItem
@synthesize movieId = _movieId;
@synthesize movieName = _movieName;
@synthesize duration = _duration;
@synthesize director = _director;
@synthesize cast = _cast;
@synthesize thumbnailString = _thumbnailString;
@synthesize thumbnail = _thumbnail;
@synthesize poster = _poster;
@synthesize movieDate = _movieDate;
@synthesize movieClass = _movieClass;
@synthesize movieArea = _movieArea;
@synthesize movieDescription = _movieDescription;
@synthesize showCount = _showCount;
@synthesize trailerURL = _trailerURL;

- (void)dealloc
{
    [_movieId release];
    [_movieName release];
    [_director release];
    [_cast release];
    [_thumbnailString release];
    [_thumbnail release];
    [_poster release];
    [_movieDate release];
    [_movieClass release];
    [_movieArea release];
    [_movieDescription release];
    [_trailerURL release];
    
    [super dealloc];
}
@end
