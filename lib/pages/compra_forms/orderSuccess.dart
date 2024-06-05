import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pedido Exitoso'),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              '    Tu pedido ha sido \n procesado con exito!',
              style: TextStyle(
                color: const Color(0xff142047),
                fontSize: 40,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 150),
            Container(
              width: 200, // Ancho del contenedor
              height: 200, // Altura del contenedor
              decoration: BoxDecoration(
                color: Colors.green, // Color de fondo del contenedor
                shape: BoxShape.circle, // Forma del contenedor (círculo)
              ),
              child: Center(
                child: SlideTransitionExample(),
              ),
            ),
          ]),
        ));
  }
}

class SlideTransitionExample extends StatefulWidget {
  const SlideTransitionExample({super.key});

  @override
  State<SlideTransitionExample> createState() => _SlideTransitionExampleState();
}

class _SlideTransitionExampleState extends State<SlideTransitionExample>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: FaIcon(FontAwesomeIcons.check, size: 100, color: Colors.white),
      ),
    );
  }
}
