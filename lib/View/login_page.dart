import 'package:flutter/material.dart';
import 'register_page.dart';
import 'menu_page.dart';
import '../Controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final AuthController _auth = AuthController();

  String email = 'joseph_d@etna-alternance.net';
  String password = 'etna';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: '/Users/joseph_d/my_pic/assets/icons/tom.png',
                    child: Container(
                      margin: const EdgeInsets.only(top: 100),
                      height: 125.0,
                      width: 125.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(62.5),
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('/Users/joseph_d/my_pic/assets/icons/tom.png'))),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Entrez votre email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) {
                        setState(() => email = val);
                      }),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: 'Entrez votre mot de passe',
                      ),
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => password = val);
                      }),
                  const SizedBox(height: 12.0),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: 400.0,
                    height: 40.0,
                    child: TextButton(
                            style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              dynamic result = await _auth.loginWithEmail(email, password);
                              if (result == true) {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const MenuScreen()));
                            } else {
                              setState(() =>
                                  error = 'email ou mot de passe incorrect');
                            }
                            },
                            child: const Text('Connexion'),
                          ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    width: 400.0,
                    height: 40.0,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const RegisterScreen()));
                        },
                      child: const Text('Aucun compte ? S\'inscrire'),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
