// ignore_for_file: prefer_collection_literals, prefer_const_constructors

import 'package:intl/intl.dart';

class CountryModel {
  int? status;
  String? message;
  List<CountryList>? data;

  CountryModel({this.status, this.message, this.data});

  CountryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CountryList>[];
      json['data'].forEach((v) {
        data!.add(CountryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CountryList {
  int? id;
  String? iso;
  String? name;
  String? niceName;
  String? iso3;
  int? numCode;
  String? phoneCode;
  int? icon;

  CountryList({this.id, this.iso, this.name, this.niceName, this.iso3, this.numCode, this.phoneCode, this.icon});

  CountryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iso = json['iso'];
    name = json['name'];
    niceName = json['nice_name'];
    iso3 = json['iso3'];
    numCode = json['num_code'];
    phoneCode = json['phone_code'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['iso'] = iso;
    data['name'] = name;
    data['nice_name'] = niceName;
    data['iso3'] = iso3;
    data['num_code'] = numCode;
    data['phone_code'] = phoneCode;
    data['icon'] = icon;
    return data;
  }
}

class AllListCountry {
  String countryCode;
  String countryName;
  String countryNumber;
  String countryIOS;

  AllListCountry({required this.countryCode, required this.countryName, required this.countryNumber, required this.countryIOS});
}

List<AllListCountry> countryList = [
  AllListCountry(countryCode: "93", countryName: "Afghanistan", countryNumber: "1", countryIOS: "AF"),
  AllListCountry(countryCode: "355", countryName: "Albania", countryNumber: "2", countryIOS: "AL"),
  AllListCountry(countryCode: "213", countryName: "Algeria", countryNumber: "3", countryIOS: "DZ"),
  AllListCountry(countryCode: "1684", countryName: "American Samoa", countryNumber: "4", countryIOS: "AS"),
  AllListCountry(countryCode: "376", countryName: "Andorra", countryNumber: "5", countryIOS: "AD"),
  AllListCountry(countryCode: "244", countryName: "Angola", countryNumber: "6", countryIOS: "AO"),
  AllListCountry(countryCode: "1264", countryName: "Anguilla", countryNumber: "7", countryIOS: "AI"),
  AllListCountry(countryCode: "672", countryName: "Antarctica", countryNumber: "8", countryIOS: "AQ"),
  AllListCountry(countryCode: "1268", countryName: "Antigua and Barbuda", countryNumber: "9", countryIOS: "AG"),
  AllListCountry(countryCode: "54", countryName: "Argentina", countryNumber: "10", countryIOS: "AR"),
  AllListCountry(countryCode: "374", countryName: "Armenia", countryNumber: "11", countryIOS: "AM"),
  AllListCountry(countryCode: "297", countryName: "Aruba", countryNumber: "12", countryIOS: "AW"),
  AllListCountry(countryCode: "61", countryName: "Australia", countryNumber: "13", countryIOS: "AU"),
  AllListCountry(countryCode: "43", countryName: "Austria", countryNumber: "14", countryIOS: "AT"),
  AllListCountry(countryCode: "994", countryName: "Azerbaijan", countryNumber: "15", countryIOS: "AZ"),
  AllListCountry(countryCode: "1242", countryName: "Bahamas", countryNumber: "16", countryIOS: "BS"),
  AllListCountry(countryCode: "973", countryName: "Bahrain", countryNumber: "17", countryIOS: "BH"),
  AllListCountry(countryCode: "880", countryName: "Bangladesh", countryNumber: "18", countryIOS: "BD"),
  AllListCountry(countryCode: "1246", countryName: "Barbados", countryNumber: "19", countryIOS: "BB"),
  AllListCountry(countryCode: "375", countryName: "Belarus", countryNumber: "20", countryIOS: "BY"),
  AllListCountry(countryCode: "32", countryName: "Belgium", countryNumber: "21", countryIOS: "BE"),
  AllListCountry(countryCode: "501", countryName: "Belize", countryNumber: "22", countryIOS: "BZ"),
  AllListCountry(countryCode: "229", countryName: "Benin", countryNumber: "23", countryIOS: "BJ"),
  AllListCountry(countryCode: "1441", countryName: "Bermuda", countryNumber: "24", countryIOS: "BM"),
  AllListCountry(countryCode: "975", countryName: "Bhutan", countryNumber: "25", countryIOS: "BT"),
  AllListCountry(countryCode: "591", countryName: "Bolivia", countryNumber: "26", countryIOS: "BO"),
  AllListCountry(countryCode: "387", countryName: "Bosnia and Herzegovina", countryNumber: "27", countryIOS: "BA"),
  AllListCountry(countryCode: "267", countryName: "Botswana", countryNumber: "28", countryIOS: "BW"),
  AllListCountry(countryCode: "0", countryName: "Bouvet Island", countryNumber: "29", countryIOS: "BV"),
  AllListCountry(countryCode: "55", countryName: "Brazil", countryNumber: "30", countryIOS: "BR"),
  AllListCountry(countryCode: "246", countryName: "British Indian Ocean Territory", countryNumber: "31", countryIOS: "IO"),
  AllListCountry(countryCode: "1284", countryName: "British Virgin Islands", countryNumber: "32", countryIOS: "VG"),
  AllListCountry(countryCode: "359", countryName: "Bulgaria", countryNumber: "33", countryIOS: "BG"),
  AllListCountry(countryCode: "226", countryName: "Burkina Faso", countryNumber: "34", countryIOS: "BF"),
  AllListCountry(countryCode: "257", countryName: "Burundi", countryNumber: "35", countryIOS: "BI"),
  AllListCountry(countryCode: "855", countryName: "Cambodia", countryNumber: "36", countryIOS: "KH"),
  AllListCountry(countryCode: "237", countryName: "Cameroon", countryNumber: "37", countryIOS: "CM"),
  AllListCountry(countryCode: "1", countryName: "Canada", countryNumber: "38", countryIOS: "CA"),
  AllListCountry(countryCode: "238", countryName: "Cape Verde", countryNumber: "39", countryIOS: "CV"),
  AllListCountry(countryCode: "1345", countryName: "Cayman Islands", countryNumber: "40", countryIOS: "KY"),
  AllListCountry(countryCode: "236", countryName: "Central African Republic", countryNumber: "41", countryIOS: "CF"),
  AllListCountry(countryCode: "235", countryName: "Chad", countryNumber: "42", countryIOS: "TD"),
  AllListCountry(countryCode: "56", countryName: "Chile", countryNumber: "43", countryIOS: "CL"),
  AllListCountry(countryCode: "86", countryName: "China", countryNumber: "44", countryIOS: "CN"),
  AllListCountry(countryCode: "61", countryName: "Christmas Island", countryNumber: "45", countryIOS: "CX"),
  AllListCountry(countryCode: "61", countryName: "Cocos Islands", countryNumber: "46", countryIOS: "CC"),
  AllListCountry(countryCode: "57", countryName: "Colombia", countryNumber: "47", countryIOS: "CO"),
  AllListCountry(countryCode: "269", countryName: "Comoros", countryNumber: "48", countryIOS: "KM"),
  AllListCountry(countryCode: "178", countryName: "Congo", countryNumber: "49", countryIOS: "CG"),
  AllListCountry(countryCode: "242", countryName: "Congo, The Democratic Republic of the", countryNumber: "50", countryIOS: "CD"),
  AllListCountry(countryCode: "682", countryName: "Cook Islands", countryNumber: "51", countryIOS: "CK"),
  AllListCountry(countryCode: "506", countryName: "Costa Rica", countryNumber: "52", countryIOS: "CR"),
  AllListCountry(countryCode: "225", countryName: "Cote D'Ivoire", countryNumber: "53", countryIOS: "CI"),
  AllListCountry(countryCode: "385", countryName: "Croatia", countryNumber: "54", countryIOS: "HR"),
  AllListCountry(countryCode: "53", countryName: "Cuba", countryNumber: "55", countryIOS: "CU"),
  AllListCountry(countryCode: "357", countryName: "Cyprus", countryNumber: "56", countryIOS: "CY"),
  AllListCountry(countryCode: "420", countryName: "Czech Republic", countryNumber: "57", countryIOS: "CZ"),
  AllListCountry(countryCode: "45", countryName: "Denmark", countryNumber: "58", countryIOS: "DK"),
  AllListCountry(countryCode: "253", countryName: "Djibouti", countryNumber: "59", countryIOS: "DJ"),
  AllListCountry(countryCode: "1767", countryName: "Dominica", countryNumber: "60", countryIOS: "DM"),
  AllListCountry(countryCode: "1809", countryName: "Dominican Republic", countryNumber: "61", countryIOS: "DO"),
  AllListCountry(countryCode: "593", countryName: "Ecuador", countryNumber: "62", countryIOS: "EC"),
  AllListCountry(countryCode: "20", countryName: "Egypt", countryNumber: "63", countryIOS: "EG"),
  AllListCountry(countryCode: "503", countryName: "El Salvador", countryNumber: "64", countryIOS: "SV"),
  AllListCountry(countryCode: "240", countryName: "Equatorial Guinea", countryNumber: "65", countryIOS: "GQ"),
  AllListCountry(countryCode: "291", countryName: "Eritrea", countryNumber: "66", countryIOS: "ER"),
  AllListCountry(countryCode: "372", countryName: "Estonia", countryNumber: "67", countryIOS: "EE"),
  AllListCountry(countryCode: "251", countryName: "Ethiopia", countryNumber: "68", countryIOS: "ET"),
  AllListCountry(countryCode: "500", countryName: "Falkland Islands", countryNumber: "69", countryIOS: "FK"),
  AllListCountry(countryCode: "298", countryName: "Faroe Islands", countryNumber: "70", countryIOS: "FO"),
  AllListCountry(countryCode: "679", countryName: "Fiji", countryNumber: "71", countryIOS: "FJ"),
  AllListCountry(countryCode: "358", countryName: "Finland", countryNumber: "72", countryIOS: "FI"),
  AllListCountry(countryCode: "33", countryName: "France", countryNumber: "73", countryIOS: "FR"),
  AllListCountry(countryCode: "594", countryName: "French Guiana", countryNumber: "74", countryIOS: "GF"),
  AllListCountry(countryCode: "689", countryName: "French Polynesia", countryNumber: "75", countryIOS: "PF"),
  AllListCountry(countryCode: "0", countryName: "French Southern", countryNumber: "76", countryIOS: "TF"),
  AllListCountry(countryCode: "241", countryName: "Gabon", countryNumber: "77", countryIOS: "GA"),
  AllListCountry(countryCode: "220", countryName: "Gambia", countryNumber: "78", countryIOS: "GM"),
  AllListCountry(countryCode: "995", countryName: "Georgia", countryNumber: "79", countryIOS: "GE"),
  AllListCountry(countryCode: "49", countryName: "Germany", countryNumber: "80", countryIOS: "DE"),
  AllListCountry(countryCode: "233", countryName: "Ghana", countryNumber: "81", countryIOS: "GH"),
  AllListCountry(countryCode: "350", countryName: "Gibraltar", countryNumber: "82", countryIOS: "GI"),
  AllListCountry(countryCode: "30", countryName: "Greece", countryNumber: "83", countryIOS: "GR"),
  AllListCountry(countryCode: "299", countryName: "Greenland", countryNumber: "84", countryIOS: "GL"),
  AllListCountry(countryCode: "1473", countryName: "Grenada", countryNumber: "85", countryIOS: "GD"),
  AllListCountry(countryCode: "1473", countryName: "Guadeloupe", countryNumber: "86", countryIOS: "GP"),
  AllListCountry(countryCode: "1671", countryName: "Guam", countryNumber: "87", countryIOS: "GU"),
  AllListCountry(countryCode: "44", countryName: "Guernsey", countryNumber: "88", countryIOS: "GG"),
  AllListCountry(countryCode: "224", countryName: "Guinea", countryNumber: "89", countryIOS: "GN"),
  AllListCountry(countryCode: "245", countryName: "Guinea-Bissau", countryNumber: "90", countryIOS: "GW"),
  AllListCountry(countryCode: "592", countryName: "Guyana", countryNumber: "91", countryIOS: "GY"),
  AllListCountry(countryCode: "509", countryName: "Haiti", countryNumber: "92", countryIOS: "HT"),
  AllListCountry(countryCode: "0", countryName: "Heard Island and McDonald Islands", countryNumber: "93", countryIOS: "HM"),
  AllListCountry(countryCode: "39", countryName: "Holy See (Vatican City State)", countryNumber: "94", countryIOS: "VA"),
  AllListCountry(countryCode: "504", countryName: "Honduras", countryNumber: "95", countryIOS: "HN"),
  AllListCountry(countryCode: "852", countryName: "Hong Kong", countryNumber: "96", countryIOS: "HK"),
  AllListCountry(countryCode: "36", countryName: "Hungary", countryNumber: "97", countryIOS: "HU"),
  AllListCountry(countryCode: "354", countryName: "Iceland", countryNumber: "98", countryIOS: "IS"),
  AllListCountry(countryCode: "91", countryName: "India", countryNumber: "99", countryIOS: "IN"),
  AllListCountry(countryCode: "62", countryName: "Indonesia", countryNumber: "100", countryIOS: "ID"),
  AllListCountry(countryCode: "98", countryName: "Iran, Islamic Republic of", countryNumber: "101", countryIOS: "IR"),
  AllListCountry(countryCode: "964", countryName: "Iraq", countryNumber: "102", countryIOS: "IQ"),
  AllListCountry(countryCode: "353", countryName: "Ireland", countryNumber: "103", countryIOS: "IE"),
  AllListCountry(countryCode: "972", countryName: "Israel", countryNumber: "104", countryIOS: "IL"),
  AllListCountry(countryCode: "39", countryName: "Italy", countryNumber: "105", countryIOS: "IT"),
  AllListCountry(countryCode: "1876", countryName: "Jamaica", countryNumber: "106", countryIOS: "JM"),
  AllListCountry(countryCode: "81", countryName: "Japan", countryNumber: "107", countryIOS: "JP"),
  AllListCountry(countryCode: "962", countryName: "Jordan", countryNumber: "108", countryIOS: "JO"),
  AllListCountry(countryCode: "7", countryName: "Kazakhstan", countryNumber: "109", countryIOS: "KZ"),
  AllListCountry(countryCode: "254", countryName: "Kenya", countryNumber: "110", countryIOS: "KE"),
  AllListCountry(countryCode: "686", countryName: "Kiribati", countryNumber: "111", countryIOS: "KI"),
  AllListCountry(countryCode: "850", countryName: "Korea, Democratic People's Republic of", countryNumber: "112", countryIOS: "KP"),
  AllListCountry(countryCode: "82", countryName: "Korea, Republic of", countryNumber: "113", countryIOS: "KR"),
  AllListCountry(countryCode: "965", countryName: "Kuwait", countryNumber: "114", countryIOS: "KW"),
  AllListCountry(countryCode: "996", countryName: "Kyrgyzstan", countryNumber: "115", countryIOS: "KG"),
  AllListCountry(countryCode: "856", countryName: "Lao People's Democratic Republic", countryNumber: "116", countryIOS: "LA"),
  AllListCountry(countryCode: "371", countryName: "Latvia", countryNumber: "117", countryIOS: "LV"),
  AllListCountry(countryCode: "961", countryName: "Lebanon", countryNumber: "118", countryIOS: "LB"),
  AllListCountry(countryCode: "266", countryName: "Lesotho", countryNumber: "119", countryIOS: "LS"),
  AllListCountry(countryCode: "231", countryName: "Liberia", countryNumber: "120", countryIOS: "LR"),
  AllListCountry(countryCode: "218", countryName: "Libyan Arab Jamahiriya", countryNumber: "121", countryIOS: "LY"),
  AllListCountry(countryCode: "423", countryName: "Liechtenstein", countryNumber: "122", countryIOS: "LI"),
  AllListCountry(countryCode: "370", countryName: "Lithuania", countryNumber: "123", countryIOS: "LT"),
  AllListCountry(countryCode: "352", countryName: "Luxembourg", countryNumber: "124", countryIOS: "LU"),
  AllListCountry(countryCode: "853", countryName: "Macau", countryNumber: "125", countryIOS: "MO"),
  AllListCountry(countryCode: "389", countryName: "Macedonia, The Former Yugoslav Republic of", countryNumber: "126", countryIOS: "MK"),
  AllListCountry(countryCode: "261", countryName: "Madagascar", countryNumber: "127", countryIOS: "MG"),
  AllListCountry(countryCode: "265", countryName: "Malawi", countryNumber: "128", countryIOS: "MW"),
  AllListCountry(countryCode: "60", countryName: "Malaysia", countryNumber: "129", countryIOS: "MY"),
  AllListCountry(countryCode: "960", countryName: "Maldives", countryNumber: "130", countryIOS: "MV"),
  AllListCountry(countryCode: "223", countryName: "Mali", countryNumber: "131", countryIOS: "ML"),
  AllListCountry(countryCode: "356", countryName: "Malta", countryNumber: "132", countryIOS: "MT"),
  AllListCountry(countryCode: "692", countryName: "Marshall Islands", countryNumber: "133", countryIOS: "MH"),
  AllListCountry(countryCode: "596", countryName: "Martinique", countryNumber: "134", countryIOS: "MQ"),
  AllListCountry(countryCode: "222", countryName: "Mauritania", countryNumber: "135", countryIOS: "MR"),
  AllListCountry(countryCode: "230", countryName: "Mauritius", countryNumber: "136", countryIOS: "MU"),
  AllListCountry(countryCode: "262", countryName: "Mayotte", countryNumber: "137", countryIOS: "YT"),
  AllListCountry(countryCode: "52", countryName: "Mexico", countryNumber: "138", countryIOS: "MX"),
  AllListCountry(countryCode: "691", countryName: "Micronesia, Federated States of", countryNumber: "139", countryIOS: "FM"),
  AllListCountry(countryCode: "373", countryName: "Moldova, Republic of", countryNumber: "140", countryIOS: "MD"),
  AllListCountry(countryCode: "377", countryName: "Monaco", countryNumber: "141", countryIOS: "MC"),
  AllListCountry(countryCode: "976", countryName: "Mongolia", countryNumber: "142", countryIOS: "MN"),
  AllListCountry(countryCode: "1664", countryName: "Montserrat", countryNumber: "143", countryIOS: "MS"),
  AllListCountry(countryCode: "212", countryName: "Morocco", countryNumber: "144", countryIOS: "MA"),
  AllListCountry(countryCode: "258", countryName: "Mozambique", countryNumber: "145", countryIOS: "MZ"),
  AllListCountry(countryCode: "95", countryName: "Myanmar", countryNumber: "146", countryIOS: "MM"),
  AllListCountry(countryCode: "264", countryName: "Namibia", countryNumber: "147", countryIOS: "NA"),
  AllListCountry(countryCode: "674", countryName: "Nauru", countryNumber: "148", countryIOS: "NR"),
  AllListCountry(countryCode: "977", countryName: "Nepal", countryNumber: "149", countryIOS: "NP"),
  AllListCountry(countryCode: "31", countryName: "Netherlands", countryNumber: "150", countryIOS: "NL"),
  AllListCountry(countryCode: "599", countryName: "Netherlands Antilles", countryNumber: "151", countryIOS: "AN"),
  AllListCountry(countryCode: "687", countryName: "New Caledonia", countryNumber: "152", countryIOS: "NC"),
  AllListCountry(countryCode: "64", countryName: "New Zealand", countryNumber: "153", countryIOS: "NZ"),
  AllListCountry(countryCode: "505", countryName: "Nicaragua", countryNumber: "154", countryIOS: "NI"),
  AllListCountry(countryCode: "227", countryName: "Niger", countryNumber: "155", countryIOS: "NE"),
  AllListCountry(countryCode: "234", countryName: "Nigeria", countryNumber: "156", countryIOS: "NG"),
  AllListCountry(countryCode: "683", countryName: "Niue", countryNumber: "157", countryIOS: "NU"),
  AllListCountry(countryCode: "672", countryName: "Norfolk Island", countryNumber: "158", countryIOS: "NF"),
  AllListCountry(countryCode: "1670", countryName: "Northern Mariana Islands", countryNumber: "159", countryIOS: "MP"),
  AllListCountry(countryCode: "47", countryName: "Norway", countryNumber: "160", countryIOS: "NO"),
  AllListCountry(countryCode: "968", countryName: "Oman", countryNumber: "161", countryIOS: "OM"),
  AllListCountry(countryCode: "92", countryName: "Pakistan", countryNumber: "162", countryIOS: "PK"),
  AllListCountry(countryCode: "680", countryName: "Palau", countryNumber: "163", countryIOS: "PW"),
  AllListCountry(countryCode: "970", countryName: "Palestinian Territory, Occupied", countryNumber: "164", countryIOS: "PS"),
  AllListCountry(countryCode: "507", countryName: "Panama", countryNumber: "165", countryIOS: "PA"),
  AllListCountry(countryCode: "675", countryName: "Papua New Guinea", countryNumber: "166", countryIOS: "PG"),
  AllListCountry(countryCode: "595", countryName: "Paraguay", countryNumber: "167", countryIOS: "PY"),
  AllListCountry(countryCode: "51", countryName: "Peru", countryNumber: "168", countryIOS: "PE"),
  AllListCountry(countryCode: "63", countryName: "Philippines", countryNumber: "169", countryIOS: "PH"),
  AllListCountry(countryCode: "64", countryName: "Pitcairn", countryNumber: "170", countryIOS: "PN"),
  AllListCountry(countryCode: "48", countryName: "Poland", countryNumber: "171", countryIOS: "PL"),
  AllListCountry(countryCode: "351", countryName: "Portugal", countryNumber: "172", countryIOS: "PT"),
  AllListCountry(countryCode: "1787", countryName: "Puerto Rico", countryNumber: "173", countryIOS: "PR"),
  AllListCountry(countryCode: "974", countryName: "Qatar", countryNumber: "174", countryIOS: "QA"),
  AllListCountry(countryCode: "262", countryName: "Reunion", countryNumber: "175", countryIOS: "RE"),
  AllListCountry(countryCode: "40", countryName: "Romania", countryNumber: "176", countryIOS: "RO"),
  AllListCountry(countryCode: "70", countryName: "Russian Federation", countryNumber: "177", countryIOS: "RU"),
  AllListCountry(countryCode: "250", countryName: "Rwanda", countryNumber: "178", countryIOS: "RW"),
  AllListCountry(countryCode: "290", countryName: "Saint Helena", countryNumber: "179", countryIOS: "SH"),
  AllListCountry(countryCode: "1869", countryName: "Saint Kitts and Nevis", countryNumber: "180", countryIOS: "KN"),
  AllListCountry(countryCode: "1758", countryName: "Saint Lucia", countryNumber: "181", countryIOS: "LC"),
  AllListCountry(countryCode: "508", countryName: "Saint Pierre and Miquelon", countryNumber: "182", countryIOS: "PM"),
  AllListCountry(countryCode: "1784", countryName: "Saint Vincent and the Grenadines", countryNumber: "183", countryIOS: "VC"),
  AllListCountry(countryCode: "685", countryName: "Samoa", countryNumber: "184", countryIOS: "WS"),
  AllListCountry(countryCode: "378", countryName: "San Marino", countryNumber: "185", countryIOS: "SM"),
  AllListCountry(countryCode: "239", countryName: "Sao Tome and Principe", countryNumber: "186", countryIOS: "ST"),
  AllListCountry(countryCode: "966", countryName: "Saudi Arabia", countryNumber: "187", countryIOS: "SA"),
  AllListCountry(countryCode: "221", countryName: "Senegal", countryNumber: "188", countryIOS: "SN"),
  AllListCountry(countryCode: "381", countryName: "Serbia and Montenegro", countryNumber: "189", countryIOS: "CS"),
  AllListCountry(countryCode: "248", countryName: "Seychelles", countryNumber: "190", countryIOS: "SC"),
  AllListCountry(countryCode: "232", countryName: "Sierra Leone", countryNumber: "191", countryIOS: "SL"),
  AllListCountry(countryCode: "65", countryName: "Singapore", countryNumber: "192", countryIOS: "SG"),
  AllListCountry(countryCode: "421", countryName: "Slovakia", countryNumber: "193", countryIOS: "SK"),
  AllListCountry(countryCode: "386", countryName: "Slovenia", countryNumber: "194", countryIOS: "SI"),
  AllListCountry(countryCode: "677", countryName: "Solomon Islands", countryNumber: "195", countryIOS: "SB"),
  AllListCountry(countryCode: "252", countryName: "Somalia", countryNumber: "196", countryIOS: "SO"),
  AllListCountry(countryCode: "27", countryName: "South Africa", countryNumber: "197", countryIOS: "ZA"),
  AllListCountry(countryCode: "82", countryName: "South Georgia and The South Sandwich Islands", countryNumber: "198", countryIOS: "GS"),
  AllListCountry(countryCode: "34", countryName: "Spain", countryNumber: "199", countryIOS: "ES"),
  AllListCountry(countryCode: "94", countryName: "Sri Lanka", countryNumber: "200", countryIOS: "LK"),
  AllListCountry(countryCode: "249", countryName: "Sudan", countryNumber: "201", countryIOS: "SD"),
  AllListCountry(countryCode: "597", countryName: "Suriname", countryNumber: "202", countryIOS: "SR"),
  AllListCountry(countryCode: "47", countryName: "Svalbard and Jan Mayen", countryNumber: "203", countryIOS: "SJ"),
  AllListCountry(countryCode: "268", countryName: "Swaziland", countryNumber: "204", countryIOS: "SZ"),
  AllListCountry(countryCode: "46", countryName: "Sweden", countryNumber: "205", countryIOS: "SE"),
  AllListCountry(countryCode: "41", countryName: "Switzerland", countryNumber: "206", countryIOS: "CH"),
  AllListCountry(countryCode: "963", countryName: "Syria Arab Republic", countryNumber: "207", countryIOS: "SY"),
  AllListCountry(countryCode: "886", countryName: "Taiwan, Province of China", countryNumber: "208", countryIOS: "TW"),
  AllListCountry(countryCode: "992", countryName: "Tajikistan", countryNumber: "209", countryIOS: "TJ"),
  AllListCountry(countryCode: "255", countryName: "Tanzania, United Republic of", countryNumber: "210", countryIOS: "TZ"),
  AllListCountry(countryCode: "66", countryName: "Thailand", countryNumber: "211", countryIOS: "TH"),
  AllListCountry(countryCode: "670", countryName: "Timor-Leste", countryNumber: "212", countryIOS: "TL"),
  AllListCountry(countryCode: "228", countryName: "Togo", countryNumber: "213", countryIOS: "TG"),
  AllListCountry(countryCode: "690", countryName: "Tokelau", countryNumber: "214", countryIOS: "TK"),
  AllListCountry(countryCode: "676", countryName: "Tonga", countryNumber: "215", countryIOS: "TO"),
  AllListCountry(countryCode: "1868", countryName: "Trinidad and Tobago", countryNumber: "216", countryIOS: "TT"),
  AllListCountry(countryCode: "216", countryName: "Tunisia", countryNumber: "217", countryIOS: "TN"),
  AllListCountry(countryCode: "90", countryName: "Turkey", countryNumber: "218", countryIOS: "TR"),
  AllListCountry(countryCode: "993", countryName: "Turkmenistan", countryNumber: "219", countryIOS: "TM"),
  AllListCountry(countryCode: "1-649", countryName: "Turks and Caicos Islands", countryNumber: "220", countryIOS: "TC"),
  AllListCountry(countryCode: "688", countryName: "Tuvalu", countryNumber: "221", countryIOS: "TV"),
  AllListCountry(countryCode: "256", countryName: "Uganda", countryNumber: "222", countryIOS: "UG"),
  AllListCountry(countryCode: "380", countryName: "Ukraine", countryNumber: "223", countryIOS: "UA"),
  AllListCountry(countryCode: "971", countryName: "United Arab Emirates", countryNumber: "224", countryIOS: "AE"),
  AllListCountry(countryCode: "44", countryName: "United Kingdom", countryNumber: "225", countryIOS: "GB"),
  AllListCountry(countryCode: "1", countryName: "United States", countryNumber: "226", countryIOS: "US"),
  AllListCountry(countryCode: "1", countryName: "United States Minor Outlying Islands", countryNumber: "227", countryIOS: "UM"),
  AllListCountry(countryCode: "598", countryName: "Uruguay", countryNumber: "228", countryIOS: "UY"),
  AllListCountry(countryCode: "998", countryName: "Uzbekistan", countryNumber: "229", countryIOS: "UZ"),
  AllListCountry(countryCode: "678", countryName: "Vanuatu", countryNumber: "230", countryIOS: "VU"),
  AllListCountry(countryCode: "58", countryName: "Venezuela", countryNumber: "231", countryIOS: "VE"),
  AllListCountry(countryCode: "84", countryName: "Viet Nam", countryNumber: "232", countryIOS: "VN"),
  AllListCountry(countryCode: "1284", countryName: "Virgin Islands, British", countryNumber: "233", countryIOS: "VG"),
  AllListCountry(countryCode: "1340", countryName: "Virgin Islands, U.S.", countryNumber: "234", countryIOS: "VI"),
  AllListCountry(countryCode: "681", countryName: "Wallis and Futuna", countryNumber: "235", countryIOS: "WF"),
  AllListCountry(countryCode: "212", countryName: "Western Sahara", countryNumber: "236", countryIOS: "EH"),
  AllListCountry(countryCode: "967", countryName: "Yemen", countryNumber: "237", countryIOS: "YE"),
  AllListCountry(countryCode: "260", countryName: "Zambia", countryNumber: "238", countryIOS: "ZM"),
  AllListCountry(countryCode: "263", countryName: "Zimbabwe", countryNumber: "239", countryIOS: "ZW"),
];

// create a country code mapping
Map<String, String> countryNameToISO = {
  "Afghanistan": "AF",
  "Albania": "AL",
  "Algeria": "DZ",
  "American Samoa": "AS",
  "Andorra": "AD",
  "Angola": "AO",
  "Anguilla": "AI",
  "Antarctica": "AQ",
  "Antigua and Barbuda": "AG",
  "Argentina": "AR",
  "Armenia": "AM",
  "Aruba": "AW",
  "Australia": "AU",
  "Austria": "AT",
  "Azerbaijan": "AZ",
  "Bahamas": "BS",
  "Bahrain": "BH",
  "Bangladesh": "BD",
  "Barbados": "BB",
  "Belarus": "BY",
  "Belgium": "BE",
  "Belize": "BZ",
  "Benin": "BJ",
  "Bermuda": "BM",
  "Bhutan": "BT",
  "Bolivia": "BO",
  "Bosnia and Herzegovina": "BA",
  "Botswana": "BW",
  "Bouvet Island": "BV",
  "Brazil": "BR",
  "British Indian Ocean Territory": "IO",
  "Brunei Darussalam": "BN",
  "Bulgaria": "BG",
  "Burkina Faso": "BF",
  "Burundi": "BI",
  "Cambodia": "KH",
  "Cameroon": "CM",
  "Canada": "CA",
  "Cape Verde": "CV",
  "Cayman Islands": "KY",
  "Central African Republic": "CF",
  "Chad": "TD",
  "Chile": "CL",
  "China": "CN",
  "Christmas Island": "CX",
  "Cocos (Keeling) Islands": "CC",
  "Colombia": "CO",
  "Comoros": "KM",
  "Congo": "CG",
  "Congo, The Democratic Republic of the": "CD",
  "Cook Islands": "CK",
  "Costa Rica": "CR",
  "Cote D'Ivoire": "CI",
  "Croatia": "HR",
  "Cuba": "CU",
  "Cyprus": "CY",
  "Czech Republic": "CZ",
  "Denmark": "DK",
  "Djibouti": "DJ",
  "Dominica": "DM",
  "Dominican Republic": "DO",
  "Ecuador": "EC",
  "Egypt": "EG",
  "El Salvador": "SV",
  "Equatorial Guinea": "GQ",
  "Eritrea": "ER",
  "Estonia": "EE",
  "Ethiopia": "ET",
  "Falkland Islands (Malvinas)": "FK",
  "Faroe Islands": "FO",
  "Fiji": "FJ",
  "Finland": "FI",
  "France": "FR",
  "French Guiana": "GF",
  "French Polynesia": "PF",
  "French Southern Territories": "TF",
  "Gabon": "GA",
  "Gambia": "GM",
  "Georgia": "GE",
  "Germany": "DE",
  "Ghana": "GH",
  "Gibraltar": "GI",
  "Greece": "GR",
  "Greenland": "GL",
  "Grenada": "GD",
  "Guadeloupe": "GP",
  "Guam": "GU",
  "Guatemala": "GT",
  "Guernsey": "GG",
  "Guinea": "GN",
  "Guinea-Bissau": "GW",
  "Guyana": "GY",
  "Haiti": "HT",
  "Heard Island and Mcdonald Islands": "HM",
  "Holy See (Vatican City State)": "VA",
  "Honduras": "HN",
  "Hong Kong": "HK",
  "Hungary": "HU",
  "Iceland": "IS",
  "India": "IN",
  "Indonesia": "ID",
  "Iran, Islamic Republic Of": "IR",
  "Iraq": "IQ",
  "Ireland": "IE",
  "Israel": "IL",
  "Italy": "IT",
  "Jamaica": "JM",
  "Japan": "JP",
  "Jersey": "JE",
  "Jordan": "JO",
  "Kazakhstan": "KZ",
  "Kenya": "KE",
  "Kiribati": "KI",
  "Korea, Democratic People'S Republic of": "KP",
  "Korea, Republic of": "KR",
  "Kuwait": "KW",
  "Kyrgyzstan": "KG",
  "Lao People'S Democratic Republic": "LA",
  "Latvia": "LV",
  "Lebanon": "LB",
  "Lesotho": "LS",
  "Liberia": "LR",
  "Libyan Arab Jamahiriya": "LY",
  "Liechtenstein": "LI",
  "Lithuania": "LT",
  "Luxembourg": "LU",
  "Macao": "MO",
  "Macedonia, The Former Yugoslav Republic of": "MK",
  "Madagascar": "MG",
  "Malawi": "MW",
  "Malaysia": "MY",
  "Maldives": "MV",
  "Mali": "ML",
  "Malta": "MT",
  "Marshall Islands": "MH",
  "Martinique": "MQ",
  "Mauritania": "MR",
  "Mauritius": "MU",
  "Mayotte": "YT",
  "Mexico": "MX",
  "Micronesia, Federated States of": "FM",
  "Moldova, Republic of": "MD",
  "Monaco": "MC",
  "Mongolia": "MN",
  "Montserrat": "MS",
  "Morocco": "MA",
  "Mozambique": "MZ",
  "Myanmar": "MM",
  "Namibia": "NA",
  "Nauru": "NR",
  "Nepal": "NP",
  "Netherlands": "NL",
  "Netherlands Antilles": "AN",
  "New Caledonia": "NC",
  "New Zealand": "NZ",
  "Nicaragua": "NI",
  "Niger": "NE",
  "Nigeria": "NG",
  "Niue": "NU",
  "Norfolk Island": "NF",
  "Northern Mariana Islands": "MP",
  "Norway": "NO",
  "Oman": "OM",
  "Pakistan": "PK",
  "Palau": "PW",
  "Palestinian Territory, Occupied": "PS",
  "Panama": "PA",
  "Papua New Guinea": "PG",
  "Paraguay": "PY",
  "Peru": "PE",
  "Philippines": "PH",
  "Pitcairn": "PN",
  "Poland": "PL",
  "Portugal": "PT",
  "Puerto Rico": "PR",
  "Qatar": "QA",
  "Reunion": "RE",
  "Romania": "RO",
  "Russian Federation": "RU",
  "RWANDA": "RW",
  "Saint Helena": "SH",
  "Saint Kitts and Nevis": "KN",
  "Saint Lucia": "LC",
  "Saint Pierre and Miquelon": "PM",
  "Saint Vincent and the Grenadines": "VC",
  "Samoa": "WS",
  "San Marino": "SM",
  "Sao Tome and Principe": "ST",
  "Saudi Arabia": "SA",
  "Senegal": "SN",
  "Serbia and Montenegro": "CS",
  "Seychelles": "SC",
  "Sierra Leone": "SL",
  "Singapore": "SG",
  "Slovakia": "SK",
  "Slovenia": "SI",
  "Solomon Islands": "SB",
  "Somalia": "SO",
  "South Africa": "ZA",
  "South Georgia and the South Sandwich Islands": "GS",
  "Spain": "ES",
  "Sri Lanka": "LK",
  "Sudan": "SD",
  "Suriname": "SR",
  "Svalbard and Jan Mayen": "SJ",
  "Swaziland": "SZ",
  "Sweden": "SE",
  "Switzerland": "CH",
  "Syrian Arab Republic": "SY",
  "Taiwan, Province of China": "TW",
  "Tajikistan": "TJ",
  "Tanzania, United Republic of": "TZ",
  "Thailand": "TH",
  "Timor-Leste": "TL",
  "Togo": "TG",
  "Tokelau": "TK",
  "Tonga": "TO",
  "Trinidad and Tobago": "TT",
  "Tunisia": "TN",
  "Turkey": "TR",
  "Turkmenistan": "TM",
  "Turks and Caicos Islands": "TC",
  "Tuvalu": "TV",
  "Uganda": "UG",
  "Ukraine": "UA",
  "United Arab Emirates": "AE",
  "United Kingdom": "GB",
  "United States": "US",
  "United States Minor Outlying Islands": "UM",
  "Uruguay": "UY",
  "Uzbekistan": "UZ",
  "Vanuatu": "VU",
  "Venezuela": "VE",
  "Viet Nam": "VN",
  "Virgin Islands, British": "VG",
  "Virgin Islands, U.S.": "VI",
  "Wallis and Futuna": "WF",
  "Western Sahara": "EH",
  "Yemen": "YE",
  "Zambia": "ZM",
  "Zimbabwe": "ZW",
};

class DateGenerator {
  static List<String> generateDatesFrom1945() {
    final startDate = DateTime(1945);
    final currentDate = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final List<String> dates = [];

    for (var date = startDate; date.isBefore(currentDate); date = date.add(Duration(days: 1))) {
      dates.add(dateFormat.format(date));
    }

    return dates;
  }
}