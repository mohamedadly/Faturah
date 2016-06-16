<?php  
    /*
    * Represents the faturah client 
    *
    * @author Hisham Bin Ateya
    */
    class Faturah{
	   public $merchantCode;
	   public $secureKey;
	   public $token;
	   public $order;
	   public $message;
	   public $hash;
    }
    /*
    * Wapper for Faturah web service
    *
    * @author Hisham Bin Ateya
    */
    class FaturahService{
	   const URL='https://Services.faturah.com/TokenGeneratorWS.asmx?wsdl';
	   private static $client;

	   private function __construct(){
		  //self::$client= new SoapClient(self::URL);
	   }
	   
	   public static function call($name,$params)
	   {
		  self::$client= new SoapClient(self::URL);
		  return self::$client->__soapCall($name, $params);
	   }
    }
    /*
    * Utility class that facilitates the communication with other components
    *
    * @author Hisham Bin Ateya
    */
    class FaturahUtility{
	   public static function generateToken($code){
		  $params = array('GenerateNewMerchantToken'=>array('merchantCode'=>$code));
		  return FaturahService::call('GenerateNewMerchantToken', $params)->GenerateNewMerchantTokenResult;
	   }
    
	   public static function isSecureMerchant($code){
		  $params = array('IsSecuredMerchant'=>array("merchantCode"=>$code));
		  return FaturahService::call('IsSecuredMerchant', $params)->IsSecuredMerchantResult;
	   }
    
	   public static function generateSecureHash($message){
		  $params = array('GenerateSecureHash'=>array("message"=>$message));
		  return FaturahService::call('GenerateSecureHash', $params)->GenerateSecureHashResult;
	   }
    
	   public static function constructMessage($key, $code, $token, $order){
		  $productIDs=implode('|', $order->productIDs);
		  $productQuantities=implode('|', $order->productQuantities);
		  $productPrices=implode('|', $order->productPrices);
		  return $key.$code.$token.$order->totalPrice.$order->deliveryCharge.$productIDs.$productQuantities.$productPrices.$order->email.$order->lang;
	   }
	   
	   public static function convertCurrency($from, $to='SAR'){
		  $client= new SoapClient("http://www.webservicex.net/CurrencyConvertor.asmx?WSDL");
		  $params = array('ConversionRate'=>array('FromCurrency'=>$from, 'ToCurrency'=>$to));
		  return $client->__soapCall("ConversionRate", $params)->ConversionRateResult;
	   }
	   
	   public function alert($msg){
		  echo '<script type="text/javascript">alert("'.$msg.'");</script>';
	   }
    }
    /*
    * Represents the customer order 
    *
    * @author Hisham Bin Ateya
    */
    class Order{
	   public $products=array();
	   public $productIDs=array();
	   public $productNames=array();
	   public $productDescriptions=array();
	   public $productQuantities=array();
	   public $productPrices=array();
	   public $deliveryCharge;
	   public $totalPrice;
	   public $customerName;
	   public $date;
	   public $customerEmail;
	   public $customerPhoneNumber;
	   public $lang;
	   
	   function __construct(){
		  $this->date = date('m/d/Y h:i:s A');
		  $this->totalPrice=0;
	   }
	   
	   public function addItem($id, $name, $description, $qunatity, $price){
		  $product=new Product();
		  $product->id=$id;
		  $product->name=$name;
		  $product->description=$description;
		  $product->quantity=$qunatity;
		  $product->price=$price;
		  $this->totalPrice += $product->price*$product->quantity;
		  array_push($this->products, $product);
		  array_push($this->productIDs, $product->id);
		  array_push($this->productNames, $product->name);
		  array_push($this->productDescriptions, $product->description);
		  array_push($this->productQuantities, $product->quantity);
		  array_push($this->productPrices, $product->price);
	   }
    }
    /*
    * Represents the product
    *
    * @author Hisham Bin Ateya
    */
    class Product{
	   public $id;
	   public $name;
	   public $description;
	   public $quantity;
	   public $price;
    }
?>