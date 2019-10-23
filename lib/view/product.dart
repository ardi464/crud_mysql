import 'dart:convert';

import 'package:crudflutter/modal/api.dart';
import 'package:crudflutter/modal/produkModel.dart';
import 'package:crudflutter/view/addProduct.dart';
import 'package:crudflutter/view/editProduct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  var loading = false;
  final list = new List<ProdukModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final res = await http.get(BaseUrl.lihat);
    if (res.contentLength == 2) {
    } else {
      final data = jsonDecode(res.body);
      data.forEach((api) {
        final ab = new ProdukModel(
          api['id_produk'],
          api['nama_produk'],
          api['qty'],
          api['harga'],
          api['date'],
          api['id_user'],
          api['nama'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    _lihatData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddProduct(_lihatData)));
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
        ),
        body: RefreshIndicator(
          onRefresh: _lihatData,
          key: _refresh,
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      x.namaProduk,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10.0)),
                                    Text("Jumlah : ${x.qty}"),
                                    Text("Harga : Rp.${x.harga}"),
                                    Text("Nama Pemilik : ${x.nama}")
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditProduct(x, _lihatData)),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ));
  }
}
