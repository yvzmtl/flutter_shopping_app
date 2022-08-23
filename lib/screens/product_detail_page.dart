

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shopping_app/const/const.dart';
import 'package:flutter_shopping_app/const/utils.dart';
import 'package:flutter_shopping_app/floor/entity/cart_product.dart';
import 'package:flutter_shopping_app/floor/dao/cart_dao.dart';
import 'package:flutter_shopping_app/model/product.dart';
import 'package:flutter_shopping_app/network/api_request.dart';
import 'package:flutter_shopping_app/state/state_management.dart';
import 'package:flutter_shopping_app/widget/size_widget.dart';


class ProductDetailPage extends ConsumerWidget{

  final CartDAO dao;


  ProductDetailPage({required this.dao});

  final _fetchProductDetail = FutureProvider.family<Product,int>((ref,id) async{
    var result = await fetchProductDetail(id);
    return result;
  });

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    var productDetailApiResult = watch(_fetchProductDetail(context.read(productSelected).state.productId));

    var _productSizeSelected = watch(productSizeSelected).state; //tekrar değişiklik olduğunda dinle

    return Scaffold(

      body: Builder(
        builder: (context){
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: productDetailApiResult.when(
                    loading: ()=> const Center(child: CircularProgressIndicator(),),
                    error: (error,stack) => Center(child: Text("$error"),),
                    data: (products) => SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CarouselSlider(items: products.productImages.map((e) => Builder(
                                builder: (context){
                                  return Container(child: Image(image:NetworkImage(e.imgUrl),fit: BoxFit.fill,),);
                                },
                              )).toList(),
                                options: CarouselOptions(
                                  height: MediaQuery.of(context).size.height/3*2.5,
                                  autoPlay: true,
                                  viewportFraction: 1,
                                  initialPage: 0,
                                ),
                              ),
                            ],
                          ),
                          /* Ürünün ismi  */
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text("${products.productName}",
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                          ),

                          /* Ürünün Fiyatı  */
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child:  Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text.rich(TextSpan(children: [
                                  TextSpan(
                                    text: products.productOldPrice == 0 ? "" : "${products.productOldPrice}",
                                    style: TextStyle(color: Colors.grey,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                  TextSpan(
                                    text: "\$${products.productNewPrice}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ]),
                                ),
                              ],
                            ),
                          ),

                          /* Ürünün Kısa Detay  */
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text("${products.productShortDescription}",
                              style: TextStyle(fontSize: 16,fontStyle: FontStyle.italic),
                              textAlign: TextAlign.justify,),
                          ),

                          // Boyutlar
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text("Boyut",
                              style: TextStyle(fontSize: 20,
                                  decoration: TextDecoration.underline,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.justify,),
                          ),

                          products.productSizes != null
                              ? Wrap(
                            children: products.productSizes.map((size) =>
                                GestureDetector(
                                  onTap: size.number > 0 ? (){
                                    //eğer boyut > 0 sa, ekleyebileceğiz
                                    context.read(productSizeSelected).state = size;
                                  }: null,
                                  child: SizeWidget(
                                      sizeModel: SizeModel(isSelected:_productSizeSelected.size == size.size, productSizes: size),productSizes: size),
                                )
                            ).toList(),
                          )
                              :Container(),

                          /* uyarı mesajı  */
                          // _productSizeSelected.number != null && _productSizeSelected.number == 0 ?
                          // Center(
                          //   child: Text("Beden Tükendi",
                          //     style: TextStyle(fontSize: 20,color: Colors.red),),
                          // )
                          //     :Container(),

                          _productSizeSelected.number != null && _productSizeSelected.number <= 5  ?
                          Center(
                            child: Text("Bu bedenden stokta sadece ${_productSizeSelected.number} adet kaldı",
                              style: TextStyle(fontSize: 20,color: Colors.red),),
                          )
                              :Container(),

                          /* buton  */
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 8, right: 8),
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.black
                                  ),
                                  onPressed: _productSizeSelected.size == null ? null :() async {
                                    try{
                                      //ürünü getir
                                      var cartProduct = await dao.getItemInCartByUid(NOT_SIGN_IN, products.productId);
                                      if(cartProduct != null){
                                        //sepette zaten ürün varsa
                                        cartProduct.quantity+=1;
                                        await dao.updateCart(cartProduct);
                                        showSnackBarWithViewBag(context,"Sepet başarıyla güncellendi");
                                      }
                                      else{
                                        Cart cart =  Cart(
                                            productId : products.productId,
                                            price : products.productNewPrice,
                                            quantity : 1,
                                            size: _productSizeSelected.size!.sizeName,
                                            imageUrl : products.productImages[0].imgUrl,
                                            name: products.productName,
                                            uid: NOT_SIGN_IN,
                                            code:products.productCode
                                        );
                                        await dao.insertCart(cart);
                                        showSnackBarWithViewBag(context,"Ürün sepete eklendi");
                                      }
                                    }
                                    catch(e){
                                      showOnlySnackBar(context,"$e");
                                      print("$e");
                                    }
                                  },
                                  child: Text("Sepete ekle", style: TextStyle(color: Colors.white),),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 8, right: 8),
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.black
                                        ),
                                        onPressed: ()=>print("İstek listesine ekle"),
                                        // onPressed: ()=>{},
                                        child: Text("İstek Listesi", style: TextStyle(color: Colors.white),),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.grey
                                        ),
                                        onPressed: ()=>print("beni haberdar et"),
                                        // onPressed: ()=>{},
                                        child: Text("Beni Haberdar Et", style: TextStyle(color: Colors.white),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text("Ürün Özellikleri",
                              style: TextStyle(fontSize: 20,
                                  decoration: TextDecoration.underline,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.justify,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text("${products.productDescription}",
                              style: TextStyle(fontSize: 16,fontStyle: FontStyle.italic),
                              textAlign: TextAlign.justify,),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


}