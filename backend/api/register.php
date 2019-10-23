<?php 

    require "../config/connect.php";

    if($_SERVER['REQUEST_METHOD']=="POST"){

        $res = array();
        $username = $_POST['username'];
        $password = md5($_POST['password']);
        $nama = $_POST['nama'];

        $cek = mysqli_fetch_array(
                mysqli_query(
                    $conn,
                    "SELECT * FROM tb_user WHERE username = '$username'"
                )
            );
        
        if(isset($cek)){
            $res['value']=2;
            $res['msg']="Sorry, Username Has Been Registered";
        } else{
            $insert = mysqli_query(
                $conn,
                "INSERT INTO tb_user VALUE('','$username','$password','$nama',1,NOW())"
            );

            if($insert){
                $res['val']=1;
                $res['msg']="Register Has Been Completed";
            } else {
                $res['val']=0;
                $res['msg']='Register Failed';
            }
        }
        echo json_encode($res);
    }

?>