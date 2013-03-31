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
@synthesize graphType = _graphType;
@synthesize graphMode = _graphMode;
@synthesize paddingLeft = _paddingLeft;
@synthesize paddingRight = _paddingRight;
@synthesize paddingTop = _paddingTop;
@synthesize paddingBottom = _paddingBottom;
@synthesize unitSring = _unitSring;

- (void)dealloc
{
    if (_unitSring)
        [_unitSring release];
    _unitSring = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // default settings
        _graphType = STGraphViewTypeLine;
        _graphMode = STGraphViewModeCumulative;
        _borderWidth = 1.0f;
        _lineWidth = 2.0f;
        _labelWidth = 30.0f;
        [self setBackgroundColor:[UIColor whiteColor]];
        _paddingLeft = 5.0f;
        _paddingRight = 5.0f;
        _paddingTop = 5.f;
        _paddingBottom = 5.0f;
        _unitSring = @"";
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    int i, num;
    float value = 0, max = 0;
    float scaling;
    CGPoint *points;
    char labelString[256];
    NSString *unitLabelString = [NSString stringWithFormat:@"[%@]", _unitSring];
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W3" size:10.0f];
    CGSize boundingSize = CGSizeMake(100, 20);
    _labelWidth = [unitLabelString sizeWithFont:font constrainedToSize:boundingSize lineBreakMode:NSLineBreakByWordWrapping].width;

    rect = self.bounds;

    // get values
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:0];
    num = [_delegate numberOfValue];
    for (i = 0;i < num;i++) {
        if (_graphMode == STGraphViewModeNormal)
            value = [_delegate valueOfIndex:i];
        else
            value += [_delegate valueOfIndex:i];
        [values addObject:[NSNumber numberWithInteger:value]];
        if (max < value)
            max = value;
    }
    scaling = (rect.size.height - _paddingTop - _paddingBottom) / max * 0.9f;

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

    rect.origin.x += _paddingRight;
    rect.size.width -= _paddingRight + _paddingLeft + _labelWidth;
    rect.origin.y += _paddingTop;
    rect.size.height -= _paddingTop + _paddingBottom;
    
    // plot values
    CGContextBeginPath(context);

    switch (_graphType) {
        case STGraphViewTypeLine:
            CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
            points = calloc(sizeof(CGPoint), num);
            for (i = 0;i < num;i++) {
                value = [[values objectAtIndex:i] intValue];
                
                points[i].x = rect.origin.x + rect.size.width / (num - 1) * i;
                if (i == 0)
                    points[i].x += _lineWidth / 2;
                else if (i == num - 1)
                    points[i].x -= _lineWidth / 2;
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
            
            CGContextSetLineWidth(context, _lineWidth);
            CGContextAddLines(context, points, num);
            free(points);
            CGContextStrokePath(context);
            break;
            
        case STGraphViewTypeBar:
            points = calloc(sizeof(CGPoint), 4);
            for (i = 0;i < num;i++) {
                value = [[values objectAtIndex:i] intValue];
                
                points[0].y = rect.origin.y + rect.size.height - _lineWidth / 2;
                points[3].y = points[0].y;
                points[1].y = rect.origin.y + rect.size.height - (float)value * scaling;
                points[2].y = points[1].y;
                
                points[0].x = rect.origin.x + rect.size.width / (num * 2 + 1) * (i * 2 + 1);
                points[1].x = points[0].x;
                points[2].x = rect.origin.x + rect.size.width / (num * 2 + 1) * (i * 2 + 2);
                points[3].x = points[2].x;
                
                CGContextMoveToPoint(context, points[0].x, points[0].y);
                CGContextAddLineToPoint(context, points[1].x, points[1].y);
                CGContextAddLineToPoint(context, points[2].x, points[2].y);
                CGContextAddLineToPoint(context, points[3].x, points[3].y);
                
                CGContextClosePath(context);
                CGContextSetFillColorWithColor(context, [_delegate fillColorOfValue].CGColor);
                CGContextFillPath(context);
                
                // draw line
                CGContextSetStrokeColorWithColor(context, [_delegate lineColorOfValue].CGColor);
                
                CGContextSetLineCap(context, kCGLineCapRound);
                CGContextSetLineJoin(context, kCGLineJoinRound);
                
                CGContextBeginPath(context);
                
                CGContextSetLineWidth(context, _lineWidth);
                CGContextAddLines(context, points, 4);
                CGContextStrokePath(context);
            }
            free(points);
            break;
            
        default:
            break;
    }
    
    // draw axis
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, _borderWidth);
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
    CGContextStrokePath(context);
    
    // draw max label
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSelectFont(context, "Helvetica", 10, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGAffineTransform affine = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
    CGContextSetTextMatrix(context, affine);
    snprintf(labelString, sizeof(labelString) - 1, "%.0f", max);
    CGContextShowTextAtPoint(context, rect.origin.x + rect.size.width + _paddingRight,
                             rect.origin.y + _paddingTop + rect.size.height * 0.1, labelString, strlen(labelString));
    
    // draw unit label
    [unitLabelString drawAtPoint:CGPointMake(rect.origin.x + rect.size.width + _lineWidth * 2, _paddingTop) withFont:font];

    UIGraphicsEndImageContext();
}


#pragma mark - Property setting methods

- (void)setPaddingWithWidth:(float)width height:(float)height
{
    _paddingLeft = width;
    _paddingRight = width;
    _paddingTop = height;
    _paddingBottom = height;
}

@end
