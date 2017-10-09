//
//  SLKLinkRect.m
//  SLKMessageDemo
//
//  Created by saix on 2017/9/29.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKLinkRect.h"

@implementation SLKLinkRect

-(instancetype)initWithUrl:(NSString*)url
{
    return [self initWithUrl:url andAction:nil];
}

-(instancetype)initWithUrl:(NSString*)url andAction:(SLKLinkActionBlock)action
{
    self = [super init];
    if (self) {
        self.url = url;
        self.action = action;
    }
    return self;
}


-(NSMutableArray*)rects
{
    if (!_rects) {
        _rects = [NSMutableArray new];
    }
    return _rects;
}


-(void)addRect:(CGRect)rect
{
    [self.rects addObject:[NSValue valueWithCGRect:rect]];
}

-(BOOL)containsPoint:(CGPoint)point
{
    for(NSValue* vrect in self.rects){
        if (CGRectContainsPoint(vrect.CGRectValue, point)) {
            return YES;
        }
    }
    return NO;
}

-(void)tapped
{
    if (self.action) {
        self.action(self.url);
    }
}

@end
