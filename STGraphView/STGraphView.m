//
//  STGraphView.m
//  STGraphView
//
//  Created by Shinone Tetsuya on 2013/02/24.
//  Copyright (c) 2013 Shinone Tetsuya. All rights reserved.
//

#import "STGraphView.h"

@implementation STGraphView
@synthesize delegate = _delegate;
@synthesize paddingWidth = _paddingWidth;
@synthesize paddingHeight = _paddingHeight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // default settings
        [self setBackgroundColor:[UIColor whiteColor]];
        _paddingWidth = 20.0f;
        _paddingHeight = 20.0f;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    int i, num, value, max = 0;
    float scaling;
    CGPoint points[32];

    rect = self.bounds;

    // get values
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:0];
    num = [_delegate numberOfValue];
    //points = malloc(sizeof(CGPoint));
    for (i = 0;i < num;i++) {
        value = [_delegate valueOfIndex:i];
        [values addObject:[NSNumber numberWithInteger:value]];
        if (max < value)
            max = value;
    }
    scaling = (rect.size.height - _paddingHeight * 2) / max * 0.9f;

    // draw
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);

    // fill background
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextSetFillColorWithColor(context, [self backgroundColor].CGColor);
    CGContextFillPath(context);

    rect.origin.x += _paddingWidth;
    rect.size.width -= _paddingWidth * 2;
    rect.origin.y += _paddingHeight;
    rect.size.height -= _paddingHeight * 2;

    // plot values
    CGContextBeginPath(context);

    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
    for (i = 0;i < num;i++) {
        value = [[values objectAtIndex:i] intValue];

        points[i].x = rect.origin.x + rect.size.width / (num - 1) * i;
        points[i].y = rect.origin.y + rect.size.height - (float)value * scaling;
        CGContextAddLineToPoint(context, points[i].x, points[i].y);
    }
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, [_delegate fillColorOfValue].CGColor);
    CGContextFillPath(context);

    // draw line
    CGContextSetStrokeColorWithColor(context, [_delegate lineColorOfValue].CGColor);

    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);

    CGContextBeginPath(context);

    CGContextSetLineWidth(context, 3);
    CGContextAddLines(context, points, num);
    //free(points);
    CGContextStrokePath(context);

    // draw axis
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 2);
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
    CGContextStrokePath(context);

    UIGraphicsEndImageContext();
}


#pragma mark - Property setting methods

- (void)setPaddingWithWidth:(float)width height:(float)height
{
    _paddingWidth = width;
    _paddingHeight = height;
}

@end
