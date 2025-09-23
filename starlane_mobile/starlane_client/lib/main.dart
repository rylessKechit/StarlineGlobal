import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Core imports
import 'core/theme/starlane_colors.dart';
import 'core/app/starlane_app.dart';
import 'data/api/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation du client API
  DioClient().initialize();
  
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
  
  runApp(const StarlaneApp());
}