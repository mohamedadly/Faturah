# Faturah

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- iOS 9.0 or later.
- SoapKit

## Installation

- Copy 'Faturah' directory into your project.
- Install 'SoapKit' pod.

# Usage

Check the example project which should be easy to follow

## Set URL Scheme

Add your URL Scheme to the project's plist file.

## Construct a Transaction

```Objective-C
//Create Transaction
FaturahTransaction* transaction = [[FaturahTransaction alloc] init];
[transaction setMerchantCode:@"xxxxxxxxxxxxxxxxxxxxxxxxxxxx1009"];
[transaction setSecureKey:@"c784bdf6-1a06-41ab-8b31-3949752ab1f7"];
[transaction setUrlScheme:@"faturah123"];

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
[[FaturahTransactionManager sharedManager] prepareTranscation:transaction withDelegate:self];

```

## Implement FaturahTransactionManagerDelegate

```Objective-C
- (void) transactionManagerDidFinishTransactionPreparation:(FaturahTransaction*) transaction withError:(NSError*) error
{

}

-(void) transactionManagerDidFinishPaymentWithStatus:(FaturahPaymentStatus)status andError:(NSError *)error
{

}

```

## Author

mohamedadly, eng.mohamed.adly@gmail.com

## License

Faturah is available under the MIT license. See the LICENSE file for more info.
