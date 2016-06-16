//
//  FaturahViewController.m
//  Faturah
//
//  Created by mohamedadly on 06/14/2016.
//  Copyright (c) 2016 mohamedadly. All rights reserved.
//

#import "FaturahViewController.h"
#import <Faturah/Faturah.h>



@interface FaturahViewController () <FaturahTransactionManagerDelegate>

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
    //Create Transaction
    FaturahTransaction* transaction = [[FaturahTransaction alloc] init];
    [transaction setMerchantCode:@"xxxxxxxxxxxxxxxxxxxxxxxxxxxx1000"];
    [transaction setSecureKey:@"c784bdf6-1a06-41ab-8b31-3949752ab1f7"];
    
    //Create Order
    FaturahOrder *order = [[FaturahOrder alloc] init];
    [order addItem:[FaturahOrderItem itemWithID:@"1"
                                        andName:@"Nokia Mobile"
                                 andDescription:@"Nokia Mobile 6600 Silver Color"
                                    andQuantity:[NSNumber numberWithInt:1]
                                       andPrice:[NSNumber numberWithInt:10]]];
    [order addItem:[FaturahOrderItem itemWithID:@"2"
                                        andName:@"LG LCD"
                                 andDescription:@"LG LCD 37 Inch Wide"
                                    andQuantity:[NSNumber numberWithInt:1]
                                       andPrice:[NSNumber numberWithInt:10]]];
    [order addItem:[FaturahOrderItem itemWithID:@"3"
                                        andName:@"Laptop DELL"
                                 andDescription:@"Laptop DELL Inspiron 5012 Black Color"
                                    andQuantity:[NSNumber numberWithInt:2]
                                       andPrice:[NSNumber numberWithInt:15]]];
    [order setOrderDeliveryCharge:[NSNumber numberWithInt:5]];
    [order setOrderCustomerName:@"John Doe"];
    [order setOrderCustomerEmail:@"email@website.com"];
    [order setOrderCustomerPhone:@"0123456789"];
    [order setOrderLanguage:@"ar"];
    
    //Set Order
    [transaction setOrder:order];
    
    //Prepare Transaction
    [[FaturahTransactionManager sharedManager] prepareTranscation:transaction
                                                     withDelegate:self];
}

#pragma mark - FaturahTransactionManagerDelegate
- (void) transactionManagerDidFinishTransactionPreparation:(FaturahTransaction*) transaction withError:(NSError*) error
{
    NSLog(@"%@", error);
}

@end
