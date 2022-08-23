

import 'package:floor/floor.dart';
import 'package:flutter_shopping_app/floor/entity/cart_product.dart';


@dao
abstract class CartDAO{
  @Query("SELECT * FROM Cart WHERE uid = :uid")
  Stream<List<Cart>> getAllItemCartByUid(String uid);

  @Query("SELECT * FROM Cart WHERE uid = :uid and productId = :productId")
  Future<Cart?> getItemInCartByUid(String uid,int productId);

  @Query("DELETE FROM Cart WHERE uid = :uid")
  Stream<List<Cart>> clearCartByUid(String uid);

  @Query("UPDATE Cart SET uid = :uid")
  Future<void> updateUidCart(String uid);

  @insert
  Future<void> insertCart(Cart product);

  @insert
  Future<int> updateCart(Cart product);

  @insert
  Future<int> deleteCart(Cart product);
}