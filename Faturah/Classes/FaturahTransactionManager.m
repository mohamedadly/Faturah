//
//  FaturahTransactionManager.m
//  Pods
//
//  Created by Mohamed Adly on 6/14/16.
//
//

#import "FaturahTransactionManager.h"
#import "FaturahOrder.h"
#import "SKRequest.h"
#import "SKService.h"
#import "SKData.h"
#import <SafariServices/SafariServices.h>


static NSString * const FaturahServicesURL = @"https://services.faturah.com/TokenGeneratorWS.asmx";
static NSString * const FaturahServiceNameSpaceURL = @"http://tempuri.org/";
static NSString * const FaturahTransactionHandlerURL = @"https://gateway.faturah.com/TransactionRequestHandler.aspx";


@interface FaturahTransactionManager ()
{
    __weak id<FaturahTransactionManagerDelegate> currentDelegate;
    FaturahTransaction *currentTranasaction;
}


@end


@implementation FaturahTransactionManager


+ (instancetype)sharedManager
{
    static FaturahTransactionManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[FaturahTransactionManager alloc] init];
    });
    return _sharedManager;
}


-(void) prepareTranscation:(FaturahTransaction *)aTransaction withDelegate:(id<FaturahTransactionManagerDelegate>)aDelegate
{
    //call service to get token
    SKService *soapService = [[SKService alloc] init];
    [soapService performRequest:[self tokenGenerationRequestForTransaction:aTransaction]
                      onSuccess:^(SKService *soapService, SKData *data) {
                          if([data.name isEqualToString:@"GenerateNewMerchantTokenResult"])
                          {
                              aTransaction.token = data.stringValue;
                              [soapService performRequest:[self secureMerchantRequestForTransaction:aTransaction]
                                                onSuccess:^(SKService *soapService, SKData *data) {
                                                    if([data.name isEqualToString:@"IsSecuredMerchantResult"])
                                                    {
                                                        if([data.stringValue isEqualToString:@"true"])
                                                        {
                                                            aTransaction.isSecureMerchant = YES;
                                                        }
                                                        else
                                                        {
                                                            aTransaction.isSecureMerchant = NO;
                                                        }
                                                        [aDelegate transactionManagerDidFinishTransactionPreparation:aTransaction
                                                                                                           withError:nil];
                                                    }
                                                    else
                                                    {
                                                         [aDelegate transactionManagerDidFinishTransactionPreparation:aTransaction withError:[NSError errorWithDomain:@"Faturah" code:1 userInfo:nil]];
                                                    }
                                                } onFailure:^(SKService *soapService, NSError *error) {
                                                     [aDelegate transactionManagerDidFinishTransactionPreparation:aTransaction withError:error];
                                                }];
                          }
                          else
                          {
                              [aDelegate transactionManagerDidFinishTransactionPreparation:aTransaction withError:[NSError errorWithDomain:@"Faturah" code:1 userInfo:nil]];
                          }
                      } onFailure:^(SKService *soapService, NSError *error) {
                          [aDelegate transactionManagerDidFinishTransactionPreparation:aTransaction withError:error];
                      }];
}


-(void)startPayementForTransaction:(FaturahTransaction *)aTransaction fromViewController:(UIViewController *)aviewController withDelegate:(id<FaturahTransactionManagerDelegate>)aDelegate
{
    currentTranasaction = aTransaction;
    currentDelegate = aDelegate;
    
    // Concatenates the product IDs, names .. etc
    NSString *itemsID = [aTransaction.order.orderItemsIDs componentsJoinedByString:@"|"];
    NSString *itemNames = [aTransaction.order.orderItemsNames componentsJoinedByString:@"|"];
    NSString *itemDescriptions = [aTransaction.order.orderItemsDescriptions componentsJoinedByString:@"|"];
    NSString *itemQuantities = [aTransaction.order.orderItemsQuantities componentsJoinedByString:@"|"];
    NSString *itemPrices = [aTransaction.order.orderItemsPrices componentsJoinedByString:@"|"];
    
    //URL
    NSString* urlString = [NSString stringWithFormat:@"%@?mc=%@&mt=%@&dt=%@&a=%@&ProductID=%@&ProductName=%@&ProductDescription=%@&ProductQuantity=%@&ProductPrice=%@&DeliveryCharge=%@&CustomerName=%@&EMail=%@&PhoneNumber=%@&MobileCallbackUrl=%@://callback", FaturahTransactionHandlerURL, aTransaction.merchantCode, aTransaction.token, aTransaction.order.orderDate, [aTransaction.order.orderTotalPrice stringValue], itemsID, itemNames, itemDescriptions, itemQuantities, itemPrices, [aTransaction.order.orderDeliveryCharge stringValue], aTransaction.order.orderCustomerName, aTransaction.order.orderCustomerEmail, aTransaction.order.orderCustomerPhone, aTransaction.urlScheme];
    
    //check for secure merchant
    if(aTransaction.isSecureMerchant)
    {
        aTransaction.message = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@", aTransaction.secureKey, aTransaction.merchantCode, aTransaction.token, [aTransaction.order.orderTotalPrice stringValue], itemsID, itemQuantities, itemPrices, [aTransaction.order.orderDeliveryCharge stringValue], aTransaction.order.orderCustomerName, aTransaction.order.orderCustomerEmail, aTransaction.order.orderCustomerPhone];
        
        //call service to get hash!
        SKService *soapService = [[SKService alloc] init];
        [soapService performRequest:[self secureHashGenerationRequestForTransaction:aTransaction]
                          onSuccess:^(SKService *soapService, SKData *data) {
                              if([data.name isEqualToString:@"GenerateSecureHashResult"])
                              {
                                  [aTransaction setSecureHash:data.stringValue];
                                  
                                  NSString* url = [NSString stringWithFormat:@"%@&vpc_SecureHash=%@", urlString, aTransaction.secureHash];
                                  
                                  [self displayWebViewControllerWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]fromViewController:aviewController];
                                  
                              }
                              else
                              {
                                  NSLog(@"Failed");
                              }
                          } onFailure:^(SKService *soapService, NSError *error) {
                              NSLog(@"%@", error);
                          }];
    }
    else
    {
        [self displayWebViewControllerWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] fromViewController:aviewController];
    }
}


-(void)displayWebViewControllerWithURL:(NSURL*) aURL fromViewController:(UIViewController*) aViewController
{
    SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:aURL];
    [aViewController presentViewController:safari animated:YES completion:nil];
}

#pragma mark - callback
-(BOOL) openURL:(NSURL *)url
{
    if(currentTranasaction && currentDelegate)
    {
       if([url.scheme isEqualToString:currentTranasaction.urlScheme])
       {
           //dismiss web vc
           [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:YES completion:nil];
           
           NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
           NSString* response = @"";
           NSString* status = @"";
           NSString* code = @"";
           NSString* token = @"";
           NSString* lang = @"";
           NSString* ignore = @"";
           NSString* secureHash = @"";
           for (NSURLQueryItem* item in components.queryItems)
           {
               if([item.name isEqualToString:@"Response"])
               {
                   response = item.value;
                   continue;
               }
               else if([item.name isEqualToString:@"status"])
               {
                   status = item.value;
                   continue;
               }
               else if([item.name isEqualToString:@"code"])
               {
                   code = item.value;
                   continue;
               }
               else if([item.name isEqualToString:@"token"])
               {
                   token = item.value;
                   continue;
               }
               else if([item.name isEqualToString:@"lang"])
               {
                   lang = item.value;
                   continue;
               }
               else if([item.name isEqualToString:@"ignore"])
               {
                   ignore = item.value;
                   continue;
               }
               else if([item.name isEqualToString:@"vpc_SecureHash"])
               {
                   secureHash = item.value;
                   continue;
               }
           }
           
           if(currentTranasaction.isSecureMerchant)
           {
               currentTranasaction.message = [NSString stringWithFormat:@"%@&Response=%@&status=%@&code=%@&token=%@&lang=%@&ignore=%@", currentTranasaction.secureKey, response, status, code, currentTranasaction.token, lang, ignore];
               //call service to get hash!
               SKService *soapService = [[SKService alloc] init];
               [soapService performRequest:[self secureHashGenerationRequestForTransaction:currentTranasaction]
                                 onSuccess:^(SKService *soapService, SKData *data) {
                                     if([data.name isEqualToString:@"GenerateSecureHashResult"])
                                     {
                                         if([secureHash isEqualToString:data.stringValue])
                                         {
                                             [self processCallBackIgnore:ignore andStatus:status];
                                         }
                                         else
                                         {
                                             [currentDelegate transactionManagerDidFinishPaymentWithStatus:FaturahPaymentStatusCanceled andError:nil];
                                         }
                                     }
                                     else
                                     {
                                         [currentDelegate transactionManagerDidFinishPaymentWithStatus:FaturahPaymentStatusCanceled andError:nil];
                                     }
                                 } onFailure:^(SKService *soapService, NSError *error) {
                                     [currentDelegate transactionManagerDidFinishPaymentWithStatus:FaturahPaymentStatusCanceled andError:error];
                                 }];
           }
           else
           {
               [self processCallBackIgnore:ignore andStatus:status];
           }
           
           return YES;
       }
    }
    return NO;
}

-(void) processCallBackIgnore:(NSString*) ignore andStatus:(NSString *) status
{
    FaturahPaymentStatus paymentStatus = FaturahPaymentStatusFailed;
    
    switch ([status intValue])
    {
        case 15:
        case 30:
            paymentStatus = FaturahPaymentStatusCompleted;
            break;
        case 1:
        case 18:
            paymentStatus = FaturahPaymentStatusPending;
            break;
        default:
            break;
    }
    
    [currentDelegate transactionManagerDidFinishPaymentWithStatus:paymentStatus andError:nil];
    
    currentDelegate = nil;
    currentTranasaction = nil;
}

#pragma mark - soap services
-(SKRequest*) tokenGenerationRequestForTransaction:(FaturahTransaction*)transaction
{
    SKRequest* request = [[SKRequest alloc] initWithURL:[NSURL URLWithString:FaturahServicesURL]
                                              operation:@"GenerateNewMerchantToken"
                                        andNamespaceURL:[NSURL URLWithString:FaturahServiceNameSpaceURL]];
    [request addInputs:@[[SKData dataWithName:@"merchantCode" andStringValue:transaction.merchantCode]]];
    return request;
}

-(SKRequest*) secureMerchantRequestForTransaction:(FaturahTransaction*)transaction
{
    SKRequest* request = [[SKRequest alloc] initWithURL:[NSURL URLWithString:FaturahServicesURL]
                                              operation:@"IsSecuredMerchant"
                                        andNamespaceURL:[NSURL URLWithString:FaturahServiceNameSpaceURL]];
    [request addInputs:@[[SKData dataWithName:@"merchantCode" andStringValue:transaction.merchantCode]]];
    return request;
}

-(SKRequest*) secureHashGenerationRequestForTransaction:(FaturahTransaction*) transaction
{
    SKRequest* request = [[SKRequest alloc] initWithURL:[NSURL URLWithString:FaturahServicesURL]
                                              operation:@"GenerateSecureHash"
                                        andNamespaceURL:[NSURL URLWithString:FaturahServiceNameSpaceURL]];
    [request addInputs:@[[SKData dataWithName:@"message" andStringValue:transaction.message]]];
    return request;
}

@end
