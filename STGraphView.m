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
@synthesize labelTextFontName = _labelTextFontName;
@synthesize unitSring = _unitSring;

- (void)dealloc
{
    if (_labelTextFontName)
        [_labelTextFontName release];
    _labelTextFontName = nil;
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
        [self setBackgroundColor:[UIColor colorWithWhite:247/255.0 alpha:1.0]];
        _paddingLeft = 5.0f;
        _paddingRight = 5.0f;
        _paddingTop = 5.f;
        _paddingBottom = 5.0f;
        _labelTextSize = 12;
        _labelTextFontName = @"Helvetica";
        _unitSring = @"";
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    int i, j, num;
    float value, max = 0;
    float scaling = 1.0;
    CGPoint *basePoints, *points;
    NSString *labelString, *unitLabelString = [NSString stringWithFormat:@"[%@]", _unitSring];
    UIFont *font = [UIFont fontWithName:_labelTextFontName size:_labelTextSize];
    CGSize boundingSize = CGSizeMake(100, 20);
    boundingSize = [unitLabelString sizeWithFont:font constrainedToSize:boundingSize lineBreakMode:NSLineBreakByWordWrapping];
    float unitLabelWidth = boundingSize.width;
    if (unitLabelWidth > _labelWidth)
        _labelWidth = unitLabelWidth;

    rect = self.bounds;

    // get values
    num = [_delegate numberOfSource];
    NSMutableArray *sources = [NSMutableArray arrayWithCapacity:num];
    for (i = 0;i < num;i++) {
        NSMutableArray *values = [NSMutableArray arrayWithCapacity:[_delegate numberOfValueWithSource:i]];
        value = 0;
        for (j = 0;j < [_delegate numberOfValueWithSource:i];j++) {
            if (_graphMode == STGraphViewModeCumulative || _graphMode == STGraphViewModeCumulativeAll)
                value += [_delegate valueOfIndex:j withSource:i];   // value level cumulation
            else
                value = [_delegate valueOfIndex:j withSource:i];
            [values addObject:[NSNumber numberWithInteger:value]];
            if (max < value)
                max = value;
        }
        [sources addObject:values];
    }
    if (_graphMode == STGraphViewModeCumulativeAll) {
        // source level cumulation
        for (i = 0;i < [sources count] - 1;i++) {
            NSArray *base = [sources objectAtIndex:i];
            NSMutableArray *dest = [sources objectAtIndex:i + 1];
            for (j = 0;j < [dest count];j++) {
                if ([base count] <= j)
                    break;
                value = [(NSNumber *)[base objectAtIndex:j] floatValue] + [(NSNumber *)[dest objectAtIndex:j] floatValue];
                [dest replaceObjectAtIndex:j withObject:[NSNumber numberWithFloat:value]];
                if (max < value)
                    max = value;
            }
        }
    }
    
    // size to fit
    if (max > 0)
        scaling = (rect.size.height - _paddingTop - _paddingBottom) / max * 0.9f;
    NSString *maxLabelString = [NSString stringWithFormat:@"%.0f", max];
    font = [UIFont fontWithName:_labelTextFontName size:_labelTextSize];
    float maxLabelWidth = [maxLabelString sizeWithFont:font constrainedToSize:boundingSize lineBreakMode:NSLineBreakByWordWrapping].width;
    if (maxLabelWidth > _labelWidth)
        _labelWidth = maxLabelWidth;

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
            if (max <= 0)
                break;
            i = 0;
            num = [_delegate numberOfValueWithSource:0];
            basePoints = calloc(sizeof(CGPoint), num);
            for (j = 0;j < num;j++) {
                basePoints[j].x = rect.origin.x + rect.size.width / (num - 1) * j;
                basePoints[j].y = rect.origin.y + rect.size.height;
            }
            for (NSArray *values in sources) {
                CGContextMoveToPoint(context, rect.origin.x, basePoints[0].y);
                points = calloc(sizeof(CGPoint), num);
                for (j = 0;j < num;j++) {
                    value = [[values objectAtIndex:j] intValue];
                    
                    points[j].x = basePoints[j].x;
                    if (j == 0)
                        points[j].x += _lineWidth / 2;
                    else if (j == num - 1)
                        points[j].x -= _lineWidth / 2;
                    points[j].y = rect.origin.y + rect.size.height - (float)value * scaling;
                    CGContextAddLineToPoint(context, points[j].x, points[j].y);
                }
                // fill rect
                for (j = num - 1;j >= 0;j--)
                    CGContextAddLineToPoint(context, basePoints[j].x, basePoints[j].y);
                CGContextClosePath(context);
                CGContextSetFillColorWithColor(context, [_delegate fillColorOfValueWithSource:i].CGColor);
                CGContextFillPath(context);
                
                // draw line
                CGContextSetStrokeColorWithColor(context, [_delegate lineColorOfValueWithSource:i].CGColor);
                
                CGContextSetLineCap(context, kCGLineCapRound);
                CGContextSetLineJoin(context, kCGLineJoinRound);
                
                CGContextBeginPath(context);
                
                CGContextSetLineWidth(context, _lineWidth);
                CGContextAddLines(context, points, num);
                CGContextStrokePath(context);
                
                // reflesh base points
                for (j = 0;j < num;j++) {
                    if (_graphMode == STGraphViewModeNormal)
                        basePoints[j].y = rect.origin.y + rect.size.height;
                    else
                        basePoints[j].y = points[j].y;
                }
                free(points);
                i++;
            }
            free(basePoints);
            break;
            
        case STGraphViewTypeBar:
            if (max <= 0)
                break;
            i = 0;
            for (NSArray *values in sources) {
                basePoints = calloc(sizeof(CGPoint), 1);
                //basePoints[0].x = 0; // not for use
                basePoints[0].y = rect.origin.y + rect.size.height;
                points = calloc(sizeof(CGPoint), 4);
                for (j = 0;j < [values count];j++) {
                    value = [[values objectAtIndex:j] intValue];
                    if (value == 0)
                        continue;
                    
                    points[0].y = basePoints[0].y;
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
                    CGContextSetFillColorWithColor(context, [_delegate fillColorOfValueWithSource:i].CGColor);
                    CGContextFillPath(context);
                    
                    // draw line
                    CGContextSetStrokeColorWithColor(context, [_delegate lineColorOfValueWithSource:i].CGColor);
                    
                    CGContextSetLineCap(context, kCGLineCapRound);
                    CGContextSetLineJoin(context, kCGLineJoinRound);
                    
                    CGContextBeginPath(context);
                    
                    points[0].y -= _lineWidth / 2;
                    points[3].y = points[0].y;
                    points[1].y -= _lineWidth / 2;
                    points[2].y = points[1].y;
                    
                    CGContextSetLineWidth(context, _lineWidth);
                    CGContextAddLines(context, points, 4);
                    CGContextStrokePath(context);
                    
                    // reflesh base points
                    basePoints[0].y = points[1].y;
                }
                free(points);
                free(basePoints);
                i++;
            }
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
    CGContextSelectFont(context, [_labelTextFontName UTF8String], _labelTextSize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGAffineTransform affine = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
    CGContextSetTextMatrix(context, affine);
    labelString = [NSString stringWithFormat:@"%.0f", max];
    [labelString drawAtPoint:CGPointMake(rect.origin.x + rect.size.width + _paddingRight, rect.origin.y + _paddingTop + boundingSize.height / 2) withFont:font];
    
    // draw unit label
    [unitLabelString drawAtPoint:CGPointMake(rect.origin.x + rect.size.width + _lineWidth * 2, _paddingTop / 2) withFont:font];

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
