<?php 

    require "../config/connect.php";

    if($_SERVER['REQUEST_METHOD']=="POST"){

        $res = array();
        $username = $_POST['username'];
        $password = md5($_POST['password']);
        
        $cek = mysqli_fetch_array(
                mysqli_query(
                    $conn,
                    "SELECT * FROM tb_user WHERE username = '$username' AND password = '$password'"
                )
            );
        
        if(isset($cek)){
            $res['val']=1;
            $res['msg']='Login Success';
            $res['username']=$cek['username'];
            $res['nama']=$cek['nama'];
            $res['id_user']=$cek['id_user'];
        } else {
            $res['val']=0;
            $res['msg']='Login Failed';
        }
        echo json_encode($res);
    }

?>