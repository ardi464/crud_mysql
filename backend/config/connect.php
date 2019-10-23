<?php 

    define("HOST","localhost");
    define("USER","root");
    define("PASS","");
    define("DB","test_crud");

    $conn = mysqli_connect(HOST,USER,PASS,DB) or die("Connection Error");

?>