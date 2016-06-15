//
//  FaturahViewController.m
//  Faturah
//
//  Created by mohamedadly on 06/14/2016.
//  Copyright (c) 2016 mohamedadly. All rights reserved.
//

#import "FaturahViewController.h"
#import "Faturah.h"


@interface FaturahViewController ()

- (IBAction)payButtonClicked:(UIButton *)sender;

@end

@implementation FaturahViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)payButtonClicked:(UIButton *)sender
{
    [[FaturahTransactionManager sharedManager] generateToken];
}
@end
