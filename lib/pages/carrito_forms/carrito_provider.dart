import 'package:flutter/foundation.dart';
import 'package:flutter_ces/pages/home_forms/productosPage.dart';

class CarritoProvider with ChangeNotifier {
  List<Producto> _items = [];

  List<Producto> get items => _items;

  void agregarProducto(Producto producto) {
    int index = _items.indexWhere((item) => item.index == producto.index);

    if (index != -1) {
      _items[index].cantidad += producto.cantidad;
    } else {
      _items.add(producto);
    }
    notifyListeners();
  }

  void incrementarCantidad(int index) {
    int i = _items.indexWhere((item) => item.index == index);
    if (i != -1) {
      _items[i].cantidad++;
      notifyListeners();
    }
  }

  void disminuirCantidad(int index) {
    int i = _items.indexWhere((item) => item.index == index);
    if (i != -1 && _items[i].cantidad > 1) {
      _items[i].cantidad--;
      notifyListeners();
    } else if (_items[i].cantidad == 1) {
      removerProducto(index);
    }
  }

  void removerProducto(int index) {
    _items.removeWhere((item) => item.index == index);
    notifyListeners();
  }

  double get total {
    return _items.fold(0.0, (sum, item) => sum + item.precio * item.cantidad);
  }
}
