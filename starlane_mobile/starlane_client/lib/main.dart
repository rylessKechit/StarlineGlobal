// Path: starlane_mobile/starlane_client/lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';

// Core imports
import 'core/theme/starlane_colors.dart';
import 'core/app/starlane_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ SUPPRIMÉ COMPLÈTEMENT: Plus d'appel à DioClient().initialize()
  // L'initialisation se fait automatiquement dans le constructeur de DioClient
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: StarlaneColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  
  runApp(const StarlaneApp());
}