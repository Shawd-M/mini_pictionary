import '../services/auth_service.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'package:my_pic/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Controller/auth_controller.dart';
import '../Controller/user_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {
  final _formkey = GlobalKey<FormState>();
  final AuthController _auth = AuthController();
  final UserController _user = UserController();

  String pseudo = 'joseph_d';
  String email = 'joseph_d@etna-alternance.net';
  String pwd = 'etna';
  String confirmPwd = 'etna';

  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: const Text('Créer un compte'),
      ),
      body: Container(
          decoration: const BoxDecoration(
              ),
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Entrez votre email',
                      ),
                      onChanged: (val) {
                        setState(() => email = val);
                      }),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: 'Entrez votre mot de passe',
                      ),
                      onChanged: (val) {
                        setState(() => pwd = val);
                      }),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Pseudo',
                        hintText: 'Entrez votre pseudo',
                      ),
                      onChanged: (val) {
                        setState(() => pseudo = val);
                      }),
                  
                  Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: 400.0,
                      height: 40.0,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                            if (email.isNotEmpty && pwd.isNotEmpty && pseudo.isNotEmpty) {
                              dynamic result = await _auth.registerWithEmail(email, pwd);
                              if (result != false) {
                                await _user.createUser(email, pseudo);
                                Navigator.pop(context);
                              } else {
                                setState(() => error =
                                    'Email ou mot de passe invalide');
                              }
                            } else {
                                setState(() => error =
                                    'Veuillez remplie le formulaire');
                            }
                        },
                        child: const Text('Inscription'),
                      )),
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
