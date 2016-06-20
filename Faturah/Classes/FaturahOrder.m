//
//  FaturahOrder.m
//  Pods
//
//  Created by Mohamed Adly on 6/14/16.
//
//

#import "FaturahOrder.h"

@implementation FaturahOrder

-(instancetype) init
{
    if(self = [super init])
    {
        //init total price
        self.orderTotalPrice = [NSNumber numberWithInt:0];
        
        //order date
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM/dd/Y hh:mm:ss a";
        self.orderDate = [dateFormatter stringFromDate:[NSDate date]];
        
        //init arrays
        self.orderItems = [NSMutableArray array];
        self.orderItemsIDs = [NSMutableArray array];
        self.orderItemsNames = [NSMutableArray array];
        self.orderItemsDescriptions = [NSMutableArray array];
        self.orderItemsQuantities = [NSMutableArray array];
        self.orderItemsPrices = [NSMutableArray array];
    }
    return self;
}


-(void) addItem:(FaturahOrderItem *)aItem
{
    double itemTotalPrice = aItem.itemPrice.doubleValue * aItem.itemQuantity.doubleValue;
    self.orderTotalPrice = [NSNumber numberWithDouble:self.orderTotalPrice.doubleValue + itemTotalPrice];
    
    [self.orderItems addObject:aItem];
    [self.orderItemsIDs addObject:aItem.itemID];
    [self.orderItemsNames addObject:aItem.itemName];
    [self.orderItemsDescriptions addObject:aItem.itemDescription];
    [self.orderItemsQuantities addObject:aItem.itemQuantity];
    [self.orderItemsPrices addObject:aItem.itemPrice];
}

@end
