import 'package:flutter/services.dart';

const String cAppTitle = "Gyroscope Parallax";

const List<String> allowedExtensions = ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png', 'xls', 'xlsx', 'txt'];

cAppOrientation() => SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
