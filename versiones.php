<?php 
$con=mysql_connect("localhost","root","root") or die ("no hay conexion");
$base=mysql_select_db("appVersiones",$con) or die("Base de Datos no encontrada");

$nombre = $_POST['nombre'];
$version = $_POST['version'];
$tipo = "ios";
/*
$nombre = "testStyleKit";
$version = "1.0";
$tipo = "ios";*/

$resultValue = array();

    if($nombre != "" && $version != "" && $tipo != ""){
     $sql= "SELECT * FROM versiones WHERE nombre='".$nombre."' AND tipo='".$tipo."'";
     $result= mysql_query($sql, $con);
     $rows = mysql_num_rows($result);
     
         if($rows > 0){
            $row = mysql_fetch_array($result,MYSQL_ASSOC);
                
                     
                     $resultValue['version'] = $row['version'];
                     $resultValue['url'] = $row['url'];                  
                     echo json_encode($resultValue); 
                     
                 
               
                              }
          
     
     }
    else{   
     $resultValue['version'] = "no_existe";
     echo json_encode($resultValue);  
     }  
       
//}*/
?>