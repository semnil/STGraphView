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
            initWithObjects:[NSNumber numberWithInteger:1],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:50],
                    [NSNumber numberWithInteger:2],
                    [NSNumber numberWithInteger:70],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:50],
                    [NSNumber numberWithInteger:2],
                    [NSNumber numberWithInteger:7],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:30],
                    [NSNumber numberWithInteger:5],
                    [NSNumber numberWithInteger:2],
                    [NSNumber numberWithInteger:7],
                    [NSNumber numberWithInteger:30],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:5],
                    [NSNumber numberWithInteger:2],
                    [NSNumber numberWithInteger:7],
                    [NSNumber numberWithInteger:300],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:5],
                    [NSNumber numberWithInteger:20],
                    [NSNumber numberWithInteger:7],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:5],
                    [NSNumber numberWithInteger:2],
                    [NSNumber numberWithInteger:700],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:30],
                    [NSNumber numberWithInteger:5],
                    [NSNumber numberWithInteger:20],
                    [NSNumber numberWithInteger:7],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:5],
                    [NSNumber numberWithInteger:20],
                    [NSNumber numberWithInteger:70],
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

- (int)numberOfValue
{
    return [_graphValues count];
}
- (float)valueOfIndex:(int)index
{
    return [[_graphValues objectAtIndex:index] floatValue];
}

- (UIColor *)lineColorOfValue
{
    return [UIColor blueColor];
}

- (UIColor *)fillColorOfValue
{
    return [UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:0.6];
}

@end
