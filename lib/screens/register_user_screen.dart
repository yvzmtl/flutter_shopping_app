

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;

class RegisterPage extends ConsumerWidget{

  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();


  @override
  //T Function<T>(ProviderBase<Object,T> provider) watch
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      key: _scaffoldkey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
              children: [
                Center(child: Text("KAYIT OL",
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24),),),
                SizedBox(height: 10,),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: "Ad"),),
                SizedBox(height: 10,),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(hintText: "Telefon"),),
                SizedBox(height: 10,),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(hintText: "Adres"),),
              ],
            ),
          ),
        ),
      ),
    );

  }




}