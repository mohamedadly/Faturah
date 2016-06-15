//
//  FaturahOrderItem.m
//  Pods
//
//  Created by Mohamed Adly on 6/15/16.
//
//

#import "FaturahOrderItem.h"

@implementation FaturahOrderItem

+(instancetype)itemWithID:(NSString *)itemID
                  andName:(NSString *)itemName
           andDescription:(NSString *)itemDescription
              andQuantity:(NSNumber *)itemQuantity
                 andPrice:(NSNumber *)itemPrice
{
    FaturahOrderItem *item = [[FaturahOrderItem alloc] init];
    [item setItemID:itemID];
    [item setItemName:itemName];
    [item setItemDescription:itemDescription];
    [item setItemQuantity:itemQuantity];
    [item setItemPrice:itemPrice];
    return item;
}

@end
