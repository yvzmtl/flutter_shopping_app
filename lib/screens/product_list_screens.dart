

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shopping_app/const/utils.dart';
import 'package:flutter_shopping_app/model/category.dart';
import 'package:flutter_shopping_app/model/product.dart';
import 'package:flutter_shopping_app/network/api_request.dart';
import 'package:flutter_shopping_app/state/state_management.dart';
import 'package:flutter_shopping_app/widget/product_card.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;

class ProductListPage extends ConsumerWidget{

  final _fetchCategories = FutureProvider((ref) async {
    var result = await fetchCategories();
    return result;
  });

  final _fetchProductBySubCategory = FutureProvider.family<List<Product>,int>((ref,subCategoryId) async{
    var result = await fetchProductBySubCategory(subCategoryId);
    return result;
  });

  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    var categoriesApiResult = watch(_fetchCategories);

    var productApiResult = watch(_fetchProductBySubCategory(context.read(subCategorySelected).state.subCategoryId));

    var userWatch = watch(userLogged);

    return Scaffold(
      key: _scaffoldkey,
      drawer: Drawer(
        child: categoriesApiResult.when(
          data: (categories)=>
              ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context,index){
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ExpansionTile(
                          title: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(categories[index].categoryImg),
                              ),
                              SizedBox(width: 30,),
                              categories[index].categoryName.length <= 10
                                  ? Text(categories[index].categoryName)
                                  : Text(categories[index].categoryName,
                                style: TextStyle(fontSize: 12),),
                            ],
                          ),
                          children: _buildList(categories[index]),
                        ),
                      ),
                    );
                  }),
          loading: ()=> const Center(child: CircularProgressIndicator(),),
          error: (error,stack) => Center(child: Text("$error"),),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: ()=> _scaffoldkey.currentState!.openDrawer(),
                      icon: Icon(
                          Icons.menu,size: 35,color: Colors.black),
                    ),
                    Text("ALIŞVERİŞ UYGULAMASI",
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),

                    Row(
                      children: [
                        FutureBuilder(
                          future: _checkLoginState(context),
                          builder: (context,snapshot){
                            var user = snapshot.data as FirebaseAuth.User;
                            return IconButton(
                              icon: Icon(
                                  user == null ? Icons.account_circle_outlined : Icons.exit_to_app,
                                  size: 35,color: Colors.black),
                              onPressed: () => processLogin(context),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                              Icons.shopping_bag_outlined,size: 35,color: Colors.black),
                          onPressed: ()=> Navigator.of(context).pushNamed("/cartDetail"),
                        ),
                      ],
                    ),

                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.amberAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text("${context.read(subCategorySelected).state.subCategoryName}"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: productApiResult.when(
                loading: ()=> const Center(child: CircularProgressIndicator(),),
                error: (error,stack) => Center(child: Text("$error"),),
                data: (products) => GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  childAspectRatio: 0.46,
                  children: products.map((e) => ProductCard(product:e)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildList(MyCategory category) {
    var list = new List<Widget>.empty(growable: true);
    category.subCategories.forEach((element) {
      list.add(Padding(padding: const EdgeInsets.all(8),
        child: Text(element.subCategoryName,
          style: TextStyle(fontSize: 12),),
      ),
      );
    });
    return list;
  }

  Future<FirebaseAuth.User?> _checkLoginState(context) async{
    if(FirebaseAuth.FirebaseAuth.instance.currentUser != null){
      FirebaseAuth.FirebaseAuth.instance.currentUser!.getIdToken()
          .then((token){
        print("Token : $token");
        var result =  findUser(FirebaseAuth.FirebaseAuth.instance.currentUser!.uid, token.toString());
        if(result == "User Not Found"){
          //register code
          Navigator.pushNamed(context, "/registerUser");
        }
        else{
          print(result);
        }
      });
    }
    return FirebaseAuth.FirebaseAuth.instance.currentUser;
  }

  processLogin(BuildContext context) async{
    var user = FirebaseAuth.FirebaseAuth.instance.currentUser;
    if(user == null){
      FlutterAuthUi.startUi(items: [AuthUiProvider.phone], tosAndPrivacyPolicy: TosAndPrivacyPolicy(
          tosUrl: "",
          privacyPolicyUrl: "")).then((firebaseUser) {
        //refresh state
        context.read(userLogged).state = FirebaseAuth.FirebaseAuth.instance.currentUser;
      }).catchError((e){
        // if(e is PlatformException){}
        showOnlySnackBar(context, "${e.message ?? "Bilinmeyen hata"}");
      });
    }
    else{
      var result = await FlutterAuthUi.signOut();
      if(result as bool){
        showOnlySnackBar(context, "Çıkış başarılı");
        //refresh
        context.read(userLogged).state = FirebaseAuth.FirebaseAuth.instance.currentUser;
      }
      else{
        showOnlySnackBar(context, "Çıkış sırasında bir hata oluştu");
      }
    }
  }

}