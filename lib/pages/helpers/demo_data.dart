class FormKeys {
  static String instructions = "instrucciones";
  static String firstName = "nombre";
  static String lastName = "apellido";
  static String country = "pais";
  static String address = "direccion";
  static String apt = "apt";
  static String city = "ciudad";
  static String postal = "postal";
  static String company = "compania";
  static String email = "email";
  static String phone = "celular";
  static String ccNumber = "ccNumero";
  static String ccName = "ccNombre";
  static String ccCode = "ccCodigo";
  static String ccExpDate = "ccExpFecha";
  static String coupon = "cupon";
}

class CountryData {
  static List<String> _countries = ['Canada', 'Francia', 'Estados Unidos', 'Japon'];
  static List<String> _canadaProvinces = [
    'Alberta',
    'British Columbia',
    'Manitoba',
    'New Brunswick',
    'Newfoundland and Labrador',
    'Northwest Territories',
    'Nova Scotia',
    'Nunavut',
    'Ontario',
    'Prince Edward Island',
    'Quebec',
    'Saskatchewan',
    'Yukon',
  ];

  static List<String> _japanPrefectures = [
    'Hokkaido',
    'Aomori',
    'Iwate',
    'Miyagi',
    'Akita',
    'Yamagata',
    'Fukushima',
    'Ibaraki',
    'Tochigi',
    'Gunma',
    'Saitama',
    'Chiba',
    'Tokyo',
    'Kanagawa',
    'Niigata',
    'Toyama',
    'Ishikawa',
    'Fukui',
    'Yamanashi',
    'Nagano',
    'Gifu',
    'Shizuoka',
    'Aichi',
    'Mie',
    'Shiga',
    'Kyoto',
    'Osaka',
    'Hyogo',
    'Nara',
    'Wakayama',
    'Tottori',
    'Shimane',
    'Okayama',
    'Hiroshima',
    'Yamaguchi',
    'Tokushima',
    'Kagawa',
    'Ehime',
    'Kochi',
    'Fukuoka',
    'Miyazaki',
    'Nagasaki',
    'Kumamoto',
    'Kagoshima',
    'Saga',
    'Oita',
    'Okinawa',
  ];

  static List<String> _usaStates = [
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'California',
    'Colorado',
    'Connecticut',
    'Delaware',
    'Florida',
    'Georgia',
    'Hawaii',
    'Idaho',
    'IllinoisIndiana',
    'Iowa',
    'Kansas',
    'Kentucky',
    'Louisiana',
    'Maine',
    'Maryland',
    'Massachusetts',
    'Michigan',
    'Minnesota',
    'Mississippi',
    'Missouri',
    'MontanaNebraska',
    'Nevada',
    'New Hampshire',
    'New Jersey',
    'New Mexico',
    'New York',
    'North Carolina',
    'North Dakota',
    'Ohio',
    'Oklahoma',
    'Oregon',
    'Pennsylvania',
    'Rhode Island',
    'South Carolina',
    'South Dakota',
    'Tennessee',
    'Texas',
    'Utah',
    'Vermont',
    'Virginia',
    'Washington',
    'West Virginia',
    'Wisconsin',
    'Wyoming'
  ];

  static String getSubdivisionTitle(String? country) {
    String subdivision = '';
    switch (country) {
      case 'Canada':
        subdivision = 'Provincia';
        break;
      case 'Japon':
        subdivision = 'Prefectura';
        break;
      case 'Estados Unidos':
        subdivision = 'Estado';
        break;
      case 'Francia':
        break;
    }
    return subdivision;
  }

  static List<String> getCountries() => _countries;
  static List<String> getSubdivisionList(String subdivision) {
    switch (subdivision) {
      case 'Provincia':
        return _canadaProvinces;
      case 'Prefectura':
        return _japanPrefectures;
      case 'Estado':
        return _usaStates;
      default:
        return [];
    }
  }
}

enum InputType { text, email, number, telephone }

enum CreditCardInputType { number, expirationDate, securityCode }

enum CreditCardNetwork { visa, mastercard, amex }
