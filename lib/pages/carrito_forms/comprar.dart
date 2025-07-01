import 'package:flutter/material.dart';
import 'package:flutter_ces/pages/home_forms/compraPage.dart';
import 'package:flutter_ces/pages/home_forms/productosPage.dart';
import 'package:provider/provider.dart';

import 'carrito_provider.dart';

class Comprar extends StatelessWidget {
  final Producto producto;

  const Comprar({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Provider.of<CarritoProvider>(context, listen: false)
                  .agregarProducto(producto);
            },
            icon: Icon(Icons.shopping_cart),
            label: Text('Agregar al carrito'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              backgroundColor: Colors.green,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Provider.of<CarritoProvider>(context, listen: false)
                  .agregarProducto(producto);
            },
            icon: Icon(Icons.attach_money),
            label: Text('Comprar ahora'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
