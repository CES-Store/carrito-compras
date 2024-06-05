import 'package:flutter/material.dart';
import 'package:flutter_ces/pages/compra_forms/orderSuccess.dart';
import '../helpers/demo_data.dart';
import 'package:provider/provider.dart';

import '../../components/section_separator.dart';
import '../../components/stack_pages_route.dart';
import '../../components/submit_button.dart';
import '../home_forms/demo.dart';
import '../helpers/form_page.dart';
import 'compra_form_information.dart';
import '../helpers/styles.dart';

class CompraFormSummary extends StatelessWidget {
  final double? pageSize;
  final bool isHidden;

  const CompraFormSummary({Key? key, this.pageSize, this.isHidden = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormPage(
      pageSizeProportion: pageSize ?? 0.85,
      isHidden: isHidden,
      title: 'Resumen de Pedido',
      children: <Widget>[
        _buildOrderSummary(),
        Separator(),
        _buildOrderInfo(),
        Separator(),
        _buildOrderTotal(),
        _buildOrderSpecialInstructions(context),
        SubmitButton(
          padding: EdgeInsets.symmetric(horizontal: Styles.hzPadding),
          child: Text('Siguiente', style: Styles.submitButtonText),
          onPressed: () => _handleSubmit(context),
        ),
      ],
    );
  }

  void _handleSubmit(BuildContext context) {
    Navigator.push(
      context,
      StackPagesRoute(
        previousPages: [CompraFormSummary(pageSize: .85, isHidden: true)],
        enterPage: OrderSuccessPage(),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              width: 135,
              height: 135,
              decoration: BoxDecoration(
                  border: Border.all(color: Styles.grayColor),
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                      image: AssetImage('assets/control2.png'))),
            ),
            Positioned(
                top: -10,
                right: -10,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Styles.grayColor,
                  ),
                  child: Center(child: Text('1', style: Styles.imageBatch)),
                )),
          ],
        ),
        SizedBox(width: 36),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Dual \nSense \nControl', style: Styles.productName),
            Text('\$70.00', style: Styles.productPrice)
          ],
        )
      ],
    );
  }

  Widget _buildOrderInfo() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Subtotal', style: Styles.orderLabel),
            Text('\$70.00', style: Styles.orderPrice),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Entrega', style: Styles.orderLabel),
            Text('GRATIS', style: Styles.orderPrice),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderTotal() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Total', style: Styles.orderTotalLabel),
          Text('\$70.00', style: Styles.orderTotal),
        ],
      ),
    );
  }

  Widget _buildOrderSpecialInstructions(BuildContext context) {
    String name = 'Informacion adicional';
    SharedFormState sharedState =
        Provider.of<SharedFormState>(context, listen: false);
    var values = sharedState.valuesByName;
    return TextFormField(
      onChanged: (value) => values[FormKeys.instructions] = value,
      initialValue: values.containsKey(FormKeys.instructions)
          ? values[FormKeys.instructions]
          : "",
      style: Styles.inputLabel,
      decoration: Styles.getInputDecoration(helper: name),
      minLines: 4,
      maxLines: 6,
    );
  }
}
