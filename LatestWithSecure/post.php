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
    $order->lang = 'en';
    $faturah->order=$order;
    $faturah->order->totalPrice+=$order->deliveryCharge;
    $faturah->token = FaturahUtility::generateToken($faturah->merchantCode);   
    $productIDs=implode('|', $faturah->order->productIDs);
    $productNames=implode('|', $faturah->order->productNames);
    $productDescriptions=implode('|', $faturah->order->productDescriptions);
    $productQuantities=implode('|', $faturah->order->productQuantities);
    $productPrices=implode('|', $faturah->order->productPrices);
    // Checks whether the merchant is secure
    if(FaturahUtility::isSecureMerchant($faturah->merchantCode))
    {
	   $faturah->message = $faturah->secureKey.$faturah->merchantCode.$faturah->token.$faturah->order->totalPrice.$productIDs.$productQuantities.$productPrices.$faturah->order->deliveryCharge.$faturah->order->customerName.$faturah->order->customerEmail.$faturah->order->customerPhoneNumber;
	   $faturah->hash = FaturahUtility::generateSecureHash($faturah->message);
    }
?>
<!DOCTYPE html>
<html>
    <body>
	   <form id="paymentForm" action="https://gateway.faturah.com/TransactionRequestHandler_Post.aspx" method="post">
		  <input name="mc" type="hidden" value="<?=$faturah->merchantCode?>"/>
		  <input name="mt" type="hidden" value="<?=$faturah->token?>"/>
		  <input name="dt" type="hidden" value="<?=$faturah->order->date?>"/>
		  <input name="a" type="hidden" value="<?=$faturah->order->totalPrice?>"/>
		  <input name="ProductID" type="hidden" value="<?=$productIDs?>"/>
		  <input name="ProductName" type="hidden" value="<?=$productNames?>"/>
		  <input name="ProductDescription" type="hidden" value="<?=$productDescriptions?>"/>
		  <input name="ProductQuantity" type="hidden" value="<?=$productQuantities?>"/>
		  <input name="ProductPrice" type="hidden" value="<?=$productPrices?>"/>
		  <input name="DeliveryCharge" type="hidden" value="<?=$faturah->order->deliveryCharge?>"/>
		  <input name="CustomerName" type="hidden" value="<?=$faturah->order->customerName?>"/>
		  <input name="EMail" type="hidden" value="<?=$faturah->order->customerEmail?>"/>
		  <input name="PhoneNumber" type="hidden" value="<?=$faturah->order->customerPhoneNumber?>"/>
		  <input name="vpc_SecureHash" type="hidden" value="<?=$faturah->hash?>"/>
		  <input name="buyButton" type="submit" value="Buy" style="display: none"/>
	   </form>
	   <script type="text/javascript">
		  function processPayment() {
			 document.getElementById('paymentForm').submit();
		  }
		 window.onload = processPayment();
	   </script>
    </body>
</html>