<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title></title>
    </head>
    <body dir="rtl">
	   
    </body>
</html>

<?php
    require_once 'Faturah.php';
    /*
    * Sets the merchant information 
    *
    * @author Hisham Bin Ateya
    */
    $fatura = new Faturah();
    $fatura->merchantCode ='xxxxxxxxxxxxxxxxxxxxxxxxxxxx1000';
    $fatura->secureKey = 'c784bdf6-1a06-41ab-8b31-3949752ab1f7';
    $fatura->token = $_GET["token"];
    if(FaturahUtility::isSecureMerchant($fatura->merchantCode))
    {
	  $fatura->message = sprintf("%s&Response=%s&status=%s&code=%s&token=%s&lang=%s&ignore=%s", $fatura->secureKey,$_GET["Response"],$_GET["status"],$_GET["code"],$fatura->token,$_GET["lang"],$_GET["ignore"]);
	  $fatura->hash = FaturahUtility::generateSecureHash($fatura->message);
	  if($_GET["vpc_SecureHash"]!=$fatura->hash){
		 FaturahUtility::alert("The transaction is cancelled!!");
		 header("refresh:1; url=thankyoupage.php"); 
		 exit();
	  }
    }
     if ($_GET["ignore"]=="0")
		  {
			 switch($_GET["status"]){
				case '15':
				case '30':
				    FaturahUtility::alert("The transaction is completed!!");
				    break;
				case '1':
				case '18':
				     FaturahUtility::alert("The transaction is pending!!");
				    break;
				default:
				     FaturahUtility::alert("The transaction is failed!!");
			 }
		  }
	else if ($_GET["ignore"]=="1")
		  {
			  switch($_GET["status"]){
				case '15':
				case '30':
				   FaturahUtility::alert("The transaction is completed!!");
				case '1':
				case '18':
				    FaturahUtility::alert("The transaction is pending!!");
				    break;
				default:
				    FaturahUtility::alert("The transaction is failed!!");
			 }
		  }
		  // Redirect to thank you page
		  header("refresh:1; url=thankyoupage.php"); 
?>