import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crudflutter/modal/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProduct extends StatefulWidget {
  final VoidCallback reload;
  AddProduct(this.reload);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String namaProduk, qty, harga, idUser;
  final _key = new GlobalKey<FormState>();

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idUser = pref.getString("id_user");
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    final res = await http.post(BaseUrl.add, body: {
      "namaProduk": namaProduk,
      "qty": qty,
      "harga": harga,
      "id_user": idUser
    });

    final data = jsonDecode(res.body);
    int value = data['val'];
    if (value == 1) {
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            TextFormField(
              onSaved: (e) => namaProduk = e,
              decoration: InputDecoration(labelText: "Nama Produk"),
            ),
            TextFormField(
              onSaved: (e) => qty = e,
              decoration: InputDecoration(labelText: "Qty"),
            ),
            TextFormField(
              onSaved: (e) => harga = e,
              decoration: InputDecoration(labelText: "Harga"),
            ),
            RaisedButton(
                onPressed: () {
                  check();
                },
                child: Text(
                  "Simpan",
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor)
          ],
        ),
      ),
    );
  }
}
