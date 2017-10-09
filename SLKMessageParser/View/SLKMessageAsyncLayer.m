//
//  SLKMessageAsyncLayer.m
//  SLKMessageParser
//
//  Created by saix on 2017/10/9.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKMessageAsyncLayer.h"
#import <libkern/OSAtomic.h>
#import <UIKit/UIKit.h>

#pragma -- copy from YYText
static dispatch_queue_t YYTextAsyncLayerGetDisplayQueue() {
#define MAX_QUEUE_COUNT 16
    static int queueCount;
    static dispatch_queue_t queues[MAX_QUEUE_COUNT];
    static dispatch_once_t onceToken;
    static int32_t counter = 0;
    dispatch_once(&onceToken, ^{
        queueCount = (int)[NSProcessInfo processInfo].activeProcessorCount;
        queueCount = queueCount < 1 ? 1 : queueCount > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : queueCount;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            for (NSUInteger i = 0; i < queueCount; i++) {
                dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
                queues[i] = dispatch_queue_create("com.ibireme.text.render", attr);
            }
        } else {
            for (NSUInteger i = 0; i < queueCount; i++) {
                queues[i] = dispatch_queue_create("com.ibireme.text.render", DISPATCH_QUEUE_SERIAL);
                dispatch_set_target_queue(queues[i], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
            }
        }
    });
    uint32_t cur = (uint32_t)OSAtomicIncrement32(&counter);
    return queues[(cur) % queueCount];
#undef MAX_QUEUE_COUNT
}

static dispatch_queue_t YYTextAsyncLayerGetReleaseQueue() {
#ifdef YYDispatchQueuePool_h
    return YYDispatchQueueGetForQOS(NSQualityOfServiceDefault);
#else
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
#endif
}

/// a thread safe incrementing counter.
@interface _YYTextSentinel : NSObject
/// Returns the current value of the counter.
@property (atomic, readonly) int32_t value;
/// Increase the value atomically. @return The new value.
- (int32_t)increase;
@end

@implementation _YYTextSentinel {
    int32_t _value;
}
- (int32_t)value {
    return _value;
}
- (int32_t)increase {
    return OSAtomicIncrement32(&_value);
}
@end


@interface SLKMessageAsyncLayer()
{
    _YYTextSentinel *_sentinel;
}

@end

@implementation SLKMessageAsyncLayer
- (instancetype)init {
    self = [super init];
    static CGFloat scale; //global
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    self.contentsScale = scale;
    _sentinel = [_YYTextSentinel new];
    return self;
}

- (void)dealloc {
    [_sentinel increase];
}

- (void)setNeedsDisplay {
    [self _cancelAsyncDisplay];
    [super setNeedsDisplay];
}

- (void)_cancelAsyncDisplay {
    [_sentinel increase];
}

-(void)display
{
    super.contents = super.contents;
    CGSize size = self.bounds.size;
    BOOL opaque = self.opaque;
    CGFloat scale = self.contentsScale;
    CGColorRef backgroundColor = (opaque && self.backgroundColor) ? CGColorRetain(self.backgroundColor) : NULL;
    _YYTextSentinel *sentinel = _sentinel;
    int32_t value = sentinel.value;
    
    BOOL (^isCancelled)() = ^BOOL() {
        BOOL cancelled = value != sentinel.value;
        if (cancelled) {
            NSLog(@"async display cancelled!");
        }
        return cancelled;
    };
    
    dispatch_async(YYTextAsyncLayerGetDisplayQueue(), ^(){
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (opaque && context) {
            CGContextSaveGState(context); {
                if (!backgroundColor || CGColorGetAlpha(backgroundColor) < 1) {
                    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                    CGContextFillPath(context);
                }
                if (backgroundColor) {
                    CGContextSetFillColorWithColor(context, backgroundColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                    CGContextFillPath(context);
                }
            } CGContextRestoreGState(context);
            CGColorRelease(backgroundColor);
        }
        [self.messageComponent drawWithContent:context];
        if (isCancelled()) {
            UIGraphicsEndImageContext();
            return;
        }
        
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (isCancelled()) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isCancelled()) {
                
            }
            else {
                self.contents = (__bridge id)(image.CGImage);
            }
        });
    });
    
}

@end


