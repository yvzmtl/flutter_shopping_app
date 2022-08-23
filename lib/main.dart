//--no-sound-null-safety

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shopping_app/floor/dao/cart_dao.dart';
import 'package:flutter_shopping_app/floor/database/database.dart';
import 'package:flutter_shopping_app/model/category.dart';
import 'package:flutter_shopping_app/network/api_request.dart';
import 'package:flutter_shopping_app/screens/cart_detail.dart';
import 'package:flutter_shopping_app/screens/product_detail_page.dart';
import 'package:flutter_shopping_app/screens/product_list_screens.dart';
import 'package:flutter_shopping_app/screens/register_user_screen.dart';
import 'package:flutter_shopping_app/state/state_management.dart';
import 'package:page_transition/page_transition.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('cart_shopping_app.db').build();
  final dao = database.cartDao;

  runApp(ProviderScope(child: MyApp(dao: dao,)));
}

class MyApp extends StatelessWidget {

  CartDAO dao;


  MyApp({required this.dao});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings){
        switch(settings.name)
        {
          case "/productList":
            return PageTransition(
                type: PageTransitionType.fade,
                child: ProductListPage(),
                settings: settings
            );
            break;
          case "/productDetail":
            return PageTransition(
                type: PageTransitionType.fade,
                child: ProductDetailPage(dao:dao),
                settings: settings
            );
            break;
          case "/cartDetail":
            return PageTransition(
                type: PageTransitionType.fade,
                child: CartDetail(dao:dao),
                settings: settings
            );
            break;
          case "/registerUser":
            return PageTransition(
                type: PageTransitionType.fade,
                child: RegisterPage(),
                settings: settings
            );
            break;
          default:
            return null;
        }
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget{

  final _fetchBanner = FutureProvider((ref) async {
    var result = await fetchBanner();
    return result;
  });

  final _fetchFeatureImg = FutureProvider((ref) async {
    var result = await fetchFeatureImages();
    return result;
  });

  final _fetchCategories = FutureProvider((ref) async {
    var result = await fetchCategories();
    return result;
  });

  final _initFirebase = FutureProvider((ref) async {
    var result = await Firebase.initializeApp();
    return result;
  });

  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, T Function<T>(ProviderBase<Object,T> provider) watch) {

    var bannerApiResult = watch(_fetchBanner);
    var featureImgApiResult = watch(_fetchFeatureImg);
    var categoriesApiResult = watch(_fetchCategories);
    var initApp = watch(_initFirebase);

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
                          children: _buildList(context, categories[index]),
                        ),
                      ),
                    );
                  }),
          loading: ()=> const Center(child: CircularProgressIndicator(),),
          error: (error,stack) => Center(child: Text("$error"),),
        ),
      ),
      body: SafeArea(
        child: Column(children: [
          // drawer button
          //Feature
          featureImgApiResult.when(
              data: (featureImages)=>
                  Stack(

                    children: [
                      CarouselSlider(
                        items: featureImages.map((e) =>
                            Builder(builder: (context) =>
                                Container(child: Image(
                                  image: NetworkImage(e.featureImgUrl),
                                  fit: BoxFit.cover,),),)).toList(),
                        options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            initialPage: 0,
                            viewportFraction: 1
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.menu, color: Colors.white,),

                            onPressed: ()=> _scaffoldkey.currentState!.openDrawer(),
                          ),
                          SizedBox(height:50),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.navigate_before,size: 50,color: Colors.white,),
                              Icon(Icons.navigate_next,size: 50,color: Colors.white,),
                            ],
                          ),
                        ],)
                    ],
                  ),
              loading: ()=> const Center(child: CircularProgressIndicator(),),
              error: (error,stack) => Center(child: Text("$error"),)
          ),

          Expanded(
            child: bannerApiResult.when(
                data: (bannerImages)=>
                    ListView.builder(
                        itemCount: bannerImages.length,
                        itemBuilder:(context,index){
                          return Container(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image(
                                  image: NetworkImage(
                                      bannerImages[index].bannerImgUrl),
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  color: Color(0xDD333639),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(bannerImages[index].bannerText,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } ),
                loading: ()=> const Center(child: CircularProgressIndicator(),),
                error: (error,stack)=> Center(child: Text("$error"),)),
          ),
        ],),
      ),
    );
  }

  _buildList(BuildContext context, MyCategory category) {
    var list = new List<Widget>.empty(growable: true);
    category.subCategories.forEach((element) {
      list.add(
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(element.subCategoryName,
              style: TextStyle(fontSize: 12),),
          ),
          onTap: (){
            context.read(subCategorySelected).state = element;
            Navigator.of(context).pushNamed("/productList");
          },
        ),
      );
    });
    return list;
  }

}

