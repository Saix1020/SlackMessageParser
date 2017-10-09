//
//  SLKMessageView2.m
//  SLKMessageDemo
//
//  Created by saix on 2017/9/26.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKMessageAsyncView.h"
#import "SLKMessageParser.h"
#import "SLKMessageToken+Display.h"
#import "SLKMessageComponent.h"
#import "SLKLinkRect.h"
#import "SLKMessageAsyncLayer.h"

@interface SLKMessageAsyncView()
{

}

@end

@implementation SLKMessageAsyncView

+ (Class)layerClass
{
    return [SLKMessageAsyncLayer class];
}

-(void)setComponent:(SLKMessageComponent *)component
{
    [self _setComponent:component];
    ((SLKMessageAsyncLayer*)self.layer).messageComponent = component;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}
-(void)drawComponet
{
    // do nothing
}






@end
