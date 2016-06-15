//
//  FaturahOrderItem.h
//  Pods
//
//  Created by Mohamed Adly on 6/15/16.
//
//

#import <Foundation/Foundation.h>

@interface FaturahOrderItem : NSObject

//item properties
@property (nonatomic, strong) NSString* itemID;
@property (nonatomic, strong) NSString* itemName;
@property (nonatomic, strong) NSString* itemDescription;
@property (nonatomic, strong) NSNumber* itemQuantity;
@property (nonatomic, strong) NSNumber* itemPrice;

//create new item
+ (instancetype)itemWithID:(NSString*) itemID
                   andName:(NSString*) itemName
            andDescription:(NSString*) itemDescription
               andQuantity:(NSNumber*) itemQuantity
                  andPrice:(NSNumber*) itemPrice;

@end
