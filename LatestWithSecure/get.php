<?php
    /*
    * Represents the post request to the transaction handler 
    *
    * @author Hisham Bin Ateya
    */
    require_once 'Faturah.php';
    // Sets the merchant information
    $faturah = new Faturah();
    $faturah->merchantCode ='xxxxxxxxxxxxxxxxxxxxxxxxxxxx1000';
    $faturah->secureKey = 'c784bdf6-1a06-41ab-8b31-3949752ab1f7';
    // Initialize the cutomer orders
    $rate = 1; // Remove the commented line if you are using other than (SAR) FaturahUtility::convertCurrency('USD');
    $order = new Order();
    $order->addItem('1', 'Nokia Mobile', 'Nokia Mobile 6600 Silver Color', '1', 10*$rate);
    $order->addItem('2', 'LG LCD', 'LG LCD 37 Inch Wide', '1', 10*$rate);
    $order->addItem('3', 'Laptop DELL', 'Laptop DELL Inspiron 5012 Black Color', '2', 15*$rate);
    $order->deliveryCharge = 5*$rate;
    $order->customerName= 'cutomer name';
    $order->customerEmail= 'customer@domain.com';
    $order->customerPhoneNumber = '1234567890';
    $order->lang = 'ar';
    $faturah->order=$order;
    $faturah->order->totalPrice+=$order->deliveryCharge;
    $faturah->token = FaturahUtility::generateToken($faturah->merchantCode);   
    // Concatenates the product IDs, names .. etc
    $productIDs = implode('|', $faturah->order->productIDs);
    $productNames = implode('|', $faturah->order->productNames);
    $productDescriptions = implode('|', $faturah->order->productDescriptions);
    $productQuantities = implode('|', $faturah->order->productQuantities);
    $productPrices = implode('|', $faturah->order->productPrices);
    // Constructs the transaction handler url
    $url = sprintf("https://gateway.faturah.com/TransactionRequestHandler.aspx?mc=%s&mt=%s&dt=%s&a=%s&ProductID=%s&ProductName=%s&ProductDescription=%s&ProductQuantity=%s&ProductPrice=%s&DeliveryCharge=%s&CustomerName=%s&EMail=%s&PhoneNumber=%s",$faturah->merchantCode, $faturah->token, $faturah->order->date, $faturah->order->totalPrice, $productIDs, $productNames, $productDescriptions, $productQuantities, $productPrices, $faturah->order->deliveryCharge, $faturah->order->customerName, $faturah->order->customerEmail, $faturah->order->customerPhoneNumber);
    // Checks whether the merchant is secure
    if(FaturahUtility::isSecureMerchant($faturah->merchantCode))
    {
	   $faturah->message = $faturah->secureKey.$faturah->merchantCode.$faturah->token.$faturah->order->totalPrice.$productIDs.$productQuantities.$productPrices.$faturah->order->deliveryCharge.$faturah->order->customerName.$faturah->order->customerEmail.$faturah->order->customerPhoneNumber;
	   $faturah->hash = FaturahUtility::generateSecureHash($faturah->message);
	   //$url .= sprintf("&vpc_SecureHash=%s&securemessage=%s",$faturah->hash,$faturah->message);
	   $url .= "&vpc_SecureHash=".$faturah->hash;
    }
    header("location: $url");