

import 'package:flutter/material.dart';
import 'package:flutter_elegant_number_button/flutter_elegant_number_button.dart';
import 'package:flutter_shopping_app/const/const.dart';
import 'package:flutter_shopping_app/floor/entity/cart_product.dart';
import 'package:flutter_shopping_app/floor/dao/cart_dao.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class CartDetail extends StatefulWidget {
  final CartDAO dao;
  const CartDetail({Key? key, required this.dao}) : super(key: key);

  @override
  _CartDetailState createState() => _CartDetailState();
}

class _CartDetailState extends State<CartDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sepet Detayı"),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back),),
      ),
      body: StreamBuilder(
        stream: widget.dao.getAllItemCartByUid(NOT_SIGN_IN),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          var items = snapshot.data as List<Cart>;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: items == null ? 0 : items.length,
                    itemBuilder: (context,index){
                      return Slidable(
                        child: Card(
                          elevation: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    child: Image(
                                      image: NetworkImage(items[index].imageUrl),
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8, right: 8),
                                          child: Text(items[index].name,
                                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                          ),

                                        ), //product name
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8, right: 8,top: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(
                                                Icons.monetization_on,color: Colors.grey, size: 16,),
                                              Container(
                                                margin: const EdgeInsets.only(left: 8),
                                                child: Text("${items[index].price}",
                                                  style: TextStyle(fontWeight: FontWeight.bold),),

                                              ),
                                            ],
                                          ),

                                        ), // product price
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8, right: 8,top: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text("Boyut ${items[index].size}",
                                                style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                                maxLines: 2,
                                              ),
                                            ],
                                          ),

                                        ),// product size

                                      ],
                                    ),
                                  ),
                                ),
                                Center(
                                  child: ElegantNumberButton(
                                    initialValue: items[index].quantity,
                                    minValue: 1,
                                    maxValue: 100,
                                    buttonSizeHeight: 20,
                                    buttonSizeWidth: 25,
                                    color: Colors.white38,
                                    decimalPlaces: 0,
                                    onChanged: (value) async{
                                      print("${value}");
                                      setState(() {
                                        items[index].quantity = value.toInt();
                                      });

                                      await widget.dao.updateCart(items[index]);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ) ,
                        ),

                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        secondaryActions: [
                          IconSlideAction(
                            caption: "Sil",
                            icon: Icons.delete,
                            color: Colors.red,
                            onTap: () async {
                              await widget.dao.deleteCart(items[index]);
                            },
                          )
                        ],
                      );
                    }),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Toplam",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          Text("\$${items.length > 0
                              ? items.map((e) => e.price * e.quantity).reduce((value, element) => value + element).toStringAsFixed(2)
                              : 0}")
                        ],
                      ),
                      Divider(thickness: 1,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Teslimat ücreti",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          Text("\$${items.length > 0
                              ? (items.map((e) => e.price * e.quantity).reduce((value, element) => value + element)*0.1).toStringAsFixed(2)
                              : 0}")
                        ],
                      ),
                      Divider(thickness: 1,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Genel Toplam",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          Text("\$${items.length > 0
                              ? ((items.map((e) => e.price * e.quantity).reduce((value, element) => value + element))
                              +items.map((e) => e.price * e.quantity).reduce((value, element) => value + element)*0.1).toStringAsFixed(2)
                              : 0}",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },

      ),

    );
  }
}
