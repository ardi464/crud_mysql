<?php 

    require "../config/connect.php";

    $res = array();

    $sql = mysqli_query($conn, "SELECT a.* , b.nama FROM tb_produk a INNER JOIN tb_user b ON a.id_user = b.id_user");

    while($dt = mysqli_fetch_array($sql)){
        $data['id_produk'] = $dt['id_produk'];
        $data['nama_produk'] = $dt['nama_produk'];
        $data['qty'] = $dt['qty'];
        $data['harga'] = $dt['harga'];
        $data['date'] = $dt['date'];
        $data['id_user'] = $dt['id_user'];
        $data['nama'] = $dt['nama'];

        array_push($res, $data);
    }

    echo json_encode($res);
?>