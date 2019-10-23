import 'dart:convert';

import 'package:crudflutter/modal/api.dart';
import 'package:crudflutter/modal/produkModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProduct extends StatefulWidget {
  final ProdukModel model;
  final VoidCallback reload;

  EditProduct(this.model, this.reload);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  String namaProduk, qty, harga;
  final _key = new GlobalKey<FormState>();

  TextEditingController txtNama, txtQty, txtHarga;

  setup() {
    txtNama = TextEditingController(text: widget.model.namaProduk);
    txtQty = TextEditingController(text: widget.model.qty);
    txtHarga = TextEditingController(text: widget.model.harga);
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    final res = await http.post(BaseUrl.edit, body: {
      "namaProduk": namaProduk,
      "qty": qty,
      "harga": harga,
      "id": widget.model.idProduk
    });

    final data = jsonDecode(res.body);
    int value = data['val'];
    String msg = data['msg'];
    if (value == 1) {
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      print(msg);
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.namaProduk),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            TextFormField(
              controller: txtNama,
              onSaved: (e) => namaProduk = e,
              decoration: InputDecoration(labelText: "Nama Produk"),
            ),
            TextFormField(
              controller: txtQty,
              onSaved: (e) => qty = e,
              decoration: InputDecoration(labelText: "Qty"),
            ),
            TextFormField(
              controller: txtHarga,
              onSaved: (e) => harga = e,
              decoration: InputDecoration(labelText: "Harga"),
            ),
            RaisedButton(
                onPressed: () {
                  check();
                },
                child: Text(
                  "Edit Data",
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor)
          ],
        ),
      ),
    );
  }
}
