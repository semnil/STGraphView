//
//  STViewController.m
//  STGraphViewTest
//
//  Created by Shinone Tetsuya on 2013/02/24.
//  Copyright (c) 2013 Shinone Tetsuya. All rights reserved.
//

#import "STViewController.h"
#import "STGraphView.h"

@interface STViewController ()

@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _graphValues = [[NSArray alloc]
            initWithObjects:
                    [NSNumber numberWithInteger:10],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:5],
                    [NSNumber numberWithInteger:20],
                    [NSNumber numberWithInteger:7],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:5],
                    [NSNumber numberWithInteger:20],
                    [NSNumber numberWithInteger:7],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:5],
                    [NSNumber numberWithInteger:2],
                    [NSNumber numberWithInteger:7],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:5],
                    [NSNumber numberWithInteger:20],
                    [NSNumber numberWithInteger:7],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:5],
                    [NSNumber numberWithInteger:20],
                    [NSNumber numberWithInteger:7],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:5],
                    [NSNumber numberWithInteger:20],
                    [NSNumber numberWithInteger:7],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:5],
                    [NSNumber numberWithInteger:20],
                    [NSNumber numberWithInteger:7],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:5],
                    [NSNumber numberWithInteger:20],
                    [NSNumber numberWithInteger:7],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:5],
                    [NSNumber numberWithInteger:2],
                    [NSNumber numberWithInteger:7],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:5],
                    [NSNumber numberWithInteger:2],
                    [NSNumber numberWithInteger:7],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:5],
                    [NSNumber numberWithInteger:2],
                    [NSNumber numberWithInteger:7],
                    [NSNumber numberWithInteger:3],
                    nil];

    STGraphView *graphView = [[[STGraphView alloc] initWithFrame:CGRectMake(0, 50, 320, 250)] autorelease];
    [graphView setDelegate:self];
    // for line graph
    [graphView setGraphMode:STGraphViewModeCumulativeAll];
    // for bar graph
    //[graphView setGraphMode:STGraphViewModeCumulative];
    //[graphView setGraphType:STGraphViewTypeBar];
    [graphView setUnitSring:@"sec(s)"];
    [self.view addSubview:graphView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (_graphValues != nil)
        [_graphValues release];

    [super dealloc];
}

#pragma mark - STGraphView delegate

- (int)numberOfSource
{
    return 7;
}

- (int)numberOfValueWithSource:(int)source
{
    return [_graphValues count] / 7;
}
- (float)valueOfIndex:(int)index withSource:(int)source
{
    return [[_graphValues objectAtIndex:source * 7 + index] floatValue];
}

- (UIColor *)lineColorOfValueWithSource:(int)source
{
    UIColor *color = [UIColor blackColor];
    switch (source) {
        case 0:
            color = [UIColor colorWithRed:0.25 green:0.25 blue:0.75 alpha:1];
            break;
        case 1:
            color = [UIColor colorWithRed:0.75 green:0.25 blue:0.25 alpha:1];
            break;
        case 2:
            color = [UIColor colorWithRed:0.25 green:0.75 blue:0.25 alpha:1];
            break;
        case 3:
            color = [UIColor colorWithRed:0.5 green:0.5 blue:0.8 alpha:1];
            break;
        case 4:
            color = [UIColor colorWithRed:0.8 green:0.5 blue:0.5 alpha:1];
            break;
        case 5:
            color = [UIColor colorWithRed:0.5 green:0.8 blue:0.5 alpha:1];
            break;
        case 6:
            color = [UIColor colorWithRed:1 green:0.75 blue:0.75 alpha:1];
            break;
        case 7:
            color = [UIColor colorWithRed:0.75 green:1 blue:0.75 alpha:1];
            break;
    }
    return color;
}

- (UIColor *)fillColorOfValueWithSource:(int)source
{
    UIColor *color = [UIColor whiteColor];
    switch (source) {
        case 0:
            color = [UIColor colorWithRed:0.25 green:0.25 blue:0.75 alpha:0.6];
            break;
        case 1:
            color = [UIColor colorWithRed:0.75 green:0.25 blue:0.25 alpha:0.6];
            break;
        case 2:
            color = [UIColor colorWithRed:0.25 green:0.75 blue:0.25 alpha:0.6];
            break;
        case 3:
            color = [UIColor colorWithRed:0.5 green:0.5 blue:0.8 alpha:0.6];
            break;
        case 4:
            color = [UIColor colorWithRed:0.8 green:0.5 blue:0.5 alpha:0.6];
            break;
        case 5:
            color = [UIColor colorWithRed:0.5 green:0.8 blue:0.5 alpha:0.6];
            break;
        case 6:
            color = [UIColor colorWithRed:1 green:0.75 blue:0.75 alpha:0.6];
            break;
        case 7:
            color = [UIColor colorWithRed:0.75 green:1 blue:0.75 alpha:0.6];
            break;
    }
    return color;
}

@end
