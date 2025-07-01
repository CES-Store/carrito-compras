import 'package:flutter/material.dart';
import 'package:flutter_ces/components/stack_pages_route.dart';
import 'package:flutter_ces/pages/compra_forms/compra_form_summary.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'carrito_provider.dart';

class CarritoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoProvider>(context);
    bool isCarritoVacio = carrito.items.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart,
              color: Color(0xFF011B55),
            ),
            SizedBox(width: 8),
            Text(
              'Carrito de Compras',
              style: TextStyle(
                color: Color(0xFF011B55),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: carrito.items.length,
              itemBuilder: (ctx, i) {
                final producto = carrito.items[i];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Image.asset(
                          producto.imagen,
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                producto.nombre,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                producto.info,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '\$${producto.precio}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.green),
                              onPressed: () {
                                carrito.incrementarCantidad(producto.index);
                              },
                            ),
                            Text(
                              '${producto.cantidad}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.remove, color: Colors.red),
                              onPressed: () {
                                carrito.disminuirCantidad(producto.index);
                              },
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            carrito.removerProducto(producto.index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1, thickness: 1),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${carrito.total}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF011B55),
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      isCarritoVacio ? null : () => _handleSubmit(context),
                  child: Text('Finalizar Compra'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor:
                        isCarritoVacio ? Colors.grey : Color(0xFF011B55),
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit(BuildContext context) {
    Navigator.push(
      context,
      StackPagesRoute(
        previousPages: [CarritoPage()],
        enterPage: CompraFormSummary(),
      ),
    );
  }
}
