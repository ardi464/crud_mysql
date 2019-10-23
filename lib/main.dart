import 'package:crudflutter/view/home.dart';
import 'package:crudflutter/view/product.dart';
import 'package:crudflutter/view/profile.dart';
import 'package:crudflutter/view/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'modal/api.dart';

void main() {
  runApp(
    MaterialApp(
      title: "CRUD Mahasiswa",
      theme: ThemeData(primaryColor: Colors.green),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    ),
  );
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus {
  notSignIn,
  signIn,
}

class _LoginPageState extends State<LoginPage> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String username, password;
  final _key = new GlobalKey<FormState>();

  bool _securetext = true;

  showHide() {
    setState(() {
      _securetext = !_securetext;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  cekUser(e) {
    if (e.isEmpty) {
      return "Please Insert";
    }
  }

  login() async {
    final res = await http.post(BaseUrl.login,
        body: {"username": username, "password": password});
    final data = jsonDecode(res.body);
    int value = data['val'];
    String msg = data['msg'];
    String userApi = data['username'];
    String namaApi = data['nama'];
    String idApi = data['id_user'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, userApi, namaApi, idApi);
      });
      print(msg);
    } else {
      print(msg);
    }
  }

  savePref(int value, String userApi, String namaApi, String idApi) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setInt("value", value);
      pref.setString("username", userApi);
      pref.setString("nama", namaApi);
      pref.setString("id_user", idApi);
      pref.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      value = pref.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setInt("value", null);
      pref.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(
            title: Text("Halaman Login"),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Form(
            key: _key,
            child: ListView(
              padding: EdgeInsets.all(20.0),
              children: <Widget>[
                TextFormField(
                  validator: (e) {
                    return cekUser(e);
                  },
                  onSaved: (e) => username = e,
                  decoration: InputDecoration(labelText: "Username"),
                ),
                TextFormField(
                  obscureText: _securetext,
                  onSaved: (e) => password = e,
                  decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        onPressed: showHide,
                        icon: Icon(_securetext
                            ? Icons.visibility_off
                            : Icons.visibility),
                      )),
                ),
                RaisedButton(
                  onPressed: () {
                    check();
                  },
                  child: Text("Login"),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Center(child: Text("Create New Account")),
                )
              ],
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return MainMenu(signOut);
        break;
    }
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String username, password, nama;
  final _key = new GlobalKey<FormState>();

  bool _securetext = true;

  showHide() {
    setState(() {
      _securetext = !_securetext;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }

  cekUser(e) {
    if (e.isEmpty) {
      return "Please Insert this field";
    }
  }

  save() async {
    final res = await http.post(BaseUrl.register,
        body: {"username": username, "password": password, "nama": nama});
    final data = jsonDecode(res.body);
    int value = data['val'];
    String pesan = data['msg'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            TextFormField(
              validator: (e) {
                return cekUser(e);
              },
              onSaved: (e) => nama = e,
              decoration: InputDecoration(labelText: "Nama"),
            ),
            TextFormField(
              validator: (e) {
                return cekUser(e);
              },
              onSaved: (e) => username = e,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextFormField(
              validator: (e) {
                return cekUser(e);
              },
              obscureText: _securetext,
              onSaved: (e) => password = e,
              decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    onPressed: showHide,
                    icon: Icon(
                        _securetext ? Icons.visibility_off : Icons.visibility),
                  )),
            ),
            RaisedButton(
              onPressed: () {
                check();
              },
              child: Text(
                "Register",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String username, nama;

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username");
      nama = pref.getString("nama");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Selamat Datang, $username"),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(Icons.lock_open),
            )
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              InkWell(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("HOME"),
                  ),
                ),
              ),
              InkWell(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("PRODUCT"),
                  ),
                ),
              ),
              InkWell(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("USER"),
                  ),
                ),
              ),
              InkWell(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("PROFILE"),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[Home(), Product(), User(), Profile()],
        ),
        bottomNavigationBar: TabBar(
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(style: BorderStyle.none)),
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home),
              text: "Home",
            ),
            Tab(
              icon: Icon(Icons.list),
              text: "Product",
            ),
            Tab(
              icon: Icon(Icons.grade),
              text: "Users",
            ),
            Tab(
              icon: Icon(Icons.people),
              text: "Profil",
            )
          ],
        ),
      ),
    );
  }
}
