<?php 

    require "../config/connect.php";

    if($_SERVER['REQUEST_METHOD']=="POST"){

        $res = array();
        $namaProduk = $_POST['namaProduk'];
        $qty = $_POST['qty'];
        $harga = $_POST['harga'];
        $id_user = $_POST['id_user'];

        $insert = mysqli_query(
            $conn,
            "INSERT INTO tb_produk VALUE('','$namaProduk','$qty','$harga',NOW(),'$id_user')"
        );

        if($insert){
            $res['val']=1;
            $res['msg']="Insert Data Has Been Completed";
        } else {
            $res['val']=0;
            $res['msg']='Insert Data Failed';
        }
        echo json_encode($res);
    }

?>