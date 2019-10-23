<?php 

    require "../config/connect.php";

    if($_SERVER['REQUEST_METHOD']=="POST"){

        $res = array();
        $namaProduk = $_POST['namaProduk'];
        $qty = $_POST['qty'];
        $harga = $_POST['harga'];
        $id_produk = $_POST['id'];

        $update = mysqli_query(
            $conn,
            "UPDATE tb_produk SET nama_produk = '$namaProduk', qty='$qty', harga='$harga' 
            WHERE id_produk = '$id_produk' "
        );

        if($update){
            $res['val']=1;
            $res['msg']="Edit Data Has Been Completed";
        } else {
            $res['val']=0;
            $res['msg']='Edit Data Failed';
        }
        echo json_encode($res);
    }

?>