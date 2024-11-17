import 'package:clothing_store/views/product_detail_view.dart';
import 'package:flutter/foundation.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  
  List<CartItem> get items => _items;
  
  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }
  
  void addItem(CartItem cartItem) {
    _items.add(cartItem);
    notifyListeners();
  }
  
  void removeItem(CartItem cartItem) {
    _items.removeWhere((item) => 
      item.product.id == cartItem.product.id && 
      item.size == cartItem.size
    );
    notifyListeners();
  }
  
  void updateQuantity(CartItem cartItem, int newQuantity) {
    final index = _items.indexWhere((item) => 
      item.product.id == cartItem.product.id && 
      item.size == cartItem.size
    );
    if (index != -1) {
      _items[index] = CartItem(
        product: cartItem.product,
        quantity: newQuantity,
        size: cartItem.size,
      );
      notifyListeners();
    }
  }

  void clearCart() {}
}