//
//  FaturahTransactionManager.m
//  Pods
//
//  Created by Mohamed Adly on 6/14/16.
//
//

#import "FaturahTransactionManager.h"
#import "SoapKit.h"
#import "FaturahOrder.h"

static NSString * const FaturahServicesURL = @"https://services.faturah.com/TokenGeneratorWS.asmx";


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



-(void)generateToken
{
//    SKRequest *request = [[SKRequest alloc] initWithURL:[NSURL URLWithString:FaturahServicesURL]
//                                              operation:@"GenerateNewMerchantToken"
//                                        andNamespaceURL:[NSURL URLWithString:@"http://tempuri.org/"]];
//    [request addInputs:@[[SKData dataWithName:@"merchantCode" andStringValue:@"xxxxxxxxxxxxxxxxxxxxxxxxxxxx1000"]]];
//    
//    SKService *soapService = [[SKService alloc] init];
//    [soapService performRequest:request onSuccess:^(SKService *soapService, SKData *data) {
//        NSLog(@"Name:  %@",data.name);
//        NSLog(@"Value: %@",data.stringValue);
//    } onFailure:^(SKService *soapService, NSError *error) {
//        NSLog(@"Error: %@",[error localizedDescription]);
//    }];
    
    FaturahOrder *order = [[FaturahOrder alloc] init];
    
}

@end
