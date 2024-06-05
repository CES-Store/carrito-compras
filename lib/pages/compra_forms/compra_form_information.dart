import 'package:flutter/material.dart';
import 'package:flutter_ces/pages/home_forms/demo.dart';
import 'package:provider/provider.dart';
import '../../components/section_title.dart';
import '../../components/stack_pages_route.dart';
import '../../components/submit_button.dart';
import '../helpers/demo_data.dart';
import '../../form_inputs/dropdown_menu.dart';
import '../../form_inputs/text_input.dart';
import '../helpers/form_mixin.dart';
import '../helpers/form_page.dart';
import 'compra_form_payment.dart';
import 'compra_form_summary.dart';
import '../helpers/styles.dart';

class CompraFormInformation extends StatefulWidget {
  final double? pageSize;
  final bool isHidden;

  const CompraFormInformation({Key? key, this.pageSize, this.isHidden = false}) : super(key: key);

  @override
  _CompraFormInformationState createState() => _CompraFormInformationState();
}

class _CompraFormInformationState extends State<CompraFormInformation> with FormMixin {
  final _formKey = GlobalKey<FormState>();

  late SharedFormState formState;
  Map<String, String> get values => formState.valuesByName;
  String get _selectedCountry => _getFormValue(FormKeys.country);

  //String _country;
  ValueNotifier<String> _country = ValueNotifier('');
  late String _countrySubdivisionKey;
  late List<String> _countries;

  @override
  void initState() {
    super.initState();
    _countries = CountryData.getCountries();
    formState = Provider.of<SharedFormState>(context, listen: false);
    if (!values.containsKey(FormKeys.country)) {
      // if not value, set default country
      _country = ValueNotifier(_countries[2]);
      values[FormKeys.country] = _country.value;
    }
    _updateCountrySubdivision(_selectedCountry);
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilding information @ ${DateTime.now().millisecondsSinceEpoch}");
    return FormPage(
      formKey: _formKey,
      isHidden: widget.isHidden,
      pageSizeProportion: widget.pageSize ?? 0.85,
      title: 'Informacion',
      children: <Widget>[
        //All countries share the a title and country selector at the top of the form
        FormSectionTitle('Informacion de Contacto'),
        //Email Input
        _buildText(FormKeys.email, type: InputType.email, required: true),
        FormSectionTitle('Direccion de Entrega'),
        //Country selector
        AppDropdownMenu(
          key: ValueKey(FormKeys.country),
          label: 'Pais / Region',
          options: _countries,
          defaultOption: _selectedCountry,
          onValidate: onItemValidate,
        ),

        //Inject the country-specific fields into the list,
        ..._buildCountrySpecificFormElements(),

        //Phone number is always last
        _buildText(FormKeys.phone, title: "Numero de Celular", type: InputType.telephone),

        SubmitButton(
            isErrorVisible: isFormErrorVisible,
            child: Text('Continuar al pago', style: Styles.submitButtonText),
            percentage: formCompletion,
            onPressed: () => _handleSubmit(context)),
      ],
    );
  }

  AppDropdownMenu _buildSubdivisionDropdown() {
    return AppDropdownMenu(
        key: ValueKey(_countrySubdivisionKey),
        label: _countrySubdivisionKey,
        defaultOption: _getFormValue(_countrySubdivisionKey),
        options: CountryData.getSubdivisionList(_countrySubdivisionKey),
        onValidate: onItemValidate);
  }

  List<Widget> _buildCountrySpecificFormElements() {
    var postalTitle = _selectedCountry == "Estados Unidos" ? "Zip Code" : "Codigo Postal";
    List<Widget> elements = [];
    switch (_selectedCountry) {
      case 'Estados Unidos':
      case 'Canada':
        elements = [
          _buildText(FormKeys.firstName),
          _buildText(FormKeys.lastName, required: true),
          _buildText(FormKeys.address, required: true),
          _buildText(FormKeys.apt, title: "Apartamento, suite, etc."),
          _buildText(FormKeys.city, required: true),
          _buildSubdivisionDropdown(),
          _buildText(FormKeys.postal, title: postalTitle, required: true),
        ];
        break;
      case 'Japon':
        elements = [
          _buildText(FormKeys.company),
          _buildText(FormKeys.lastName, required: true),
          _buildText(FormKeys.firstName),
          _buildText(FormKeys.postal, title: postalTitle, required: true),
          _buildSubdivisionDropdown(),
          _buildText(FormKeys.city, required: true),
          _buildText(FormKeys.address, required: true),
          _buildText(FormKeys.apt, title: "Apartamento, suite, etc."),
        ];
        break;
      case 'Francia':
        elements = [
          _buildText(FormKeys.firstName),
          _buildText(FormKeys.lastName, required: true),
          _buildText(FormKeys.company),
          _buildText(FormKeys.address, required: true),
          _buildText(FormKeys.apt, title: "Apartamento, suite, etc."),
          _buildText(FormKeys.postal, title: postalTitle, required: true),
          _buildText(FormKeys.city, required: true),
        ];
        break;
    }
    return elements;
  }

  TextInput _buildText(String key, {String? title, bool required = false, InputType type = InputType.text}) {
    title = title ?? _snakeToTitleCase(key);
    // Register the input validity
    if (!validInputsMap.containsKey(key)) validInputsMap[key] = !required;
    return TextInput(
      key: ValueKey(key),
      helper: title,
      type: type,
      initialValue: _getFormValue(key),
      onValidate: onItemValidate,
      onChange: onItemChange,
      isRequired: required,
      valueNotifier: _country,
    );
  }

  @override
  void onItemValidate(String key, bool isValid, {String? value}) {
    if (value == null) return;
    // update the input validity
    validInputsMap[key] = isValid;
    bool hasChanged = values[key] != value;
    values[key] = value;
    // on country updated
    if (key == FormKeys.country && hasChanged) {
      _country.value = value;
      validInputsMap.clear();
      _updateCountrySubdivision(value);
      onItemChange(key, value);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        formCompletion = countValidItems() / validInputsMap.length;
        if (formCompletion == 1) isFormErrorVisible = false;
      });
    });
  }

  @override
  //Update cached values each time the form changes
  void onItemChange(String key, String value) {
    values[key] = value;
  }

  String _snakeToTitleCase(String value) {
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
    List<String> words = value.split("_");
    words = words.map((w) => capitalize(w)).toList();
    return words.join(" ");
  }

  String _getFormValue(String name) => values[name] ?? "";

  void _updateCountrySubdivision(String country) {
    //Invalidate input maps
    validInputsMap.clear();
    //Get the key for this country
    _countrySubdivisionKey = CountryData.getSubdivisionTitle(country);
    //Select default is nothing is currently set
    if (!values.containsKey(_countrySubdivisionKey) && _countrySubdivisionKey.isNotEmpty) {
      values[_countrySubdivisionKey] = CountryData.getSubdivisionList(_countrySubdivisionKey)[0];
    }
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() == true && formCompletion == 1) {
      Navigator.push(
          context,
          StackPagesRoute(previousPages: [
            CompraFormSummary(isHidden: true, pageSize: .85),
            CompraFormInformation(isHidden: true, pageSize: .85),
          ], enterPage: CompraFormPayment()));
    } else
      setState(() {
        isFormErrorVisible = true;
      });
  }
}
