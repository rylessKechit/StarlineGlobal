import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Core imports
import '../theme/starlane_theme.dart';
import '../router/app_router.dart';
import '../../data/api/api_client.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/client/repositories/activity_repository.dart';

class StarlaneApp extends StatelessWidget {
  const StarlaneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // ✅ CRÉATION DU CLIENT API PARTAGÉ
        final apiClient = StarlaneApiClient(DioClient().dio);
        
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AuthRepository>(
              create: (context) => AuthRepositoryImpl(apiClient: apiClient),
            ),
            // ✅ AJOUT DU ACTIVITY REPOSITORY
            RepositoryProvider<ActivityRepository>(
              create: (context) => ActivityRepositoryImpl(apiClient: apiClient),
            ),
          ],
          child: BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              storage: const FlutterSecureStorage(),
            )..add(AuthStarted()),
            child: MaterialApp.router(
              title: 'Starlane Global',
              debugShowCheckedModeBanner: false,
              theme: StarlaneTheme.lightTheme,
              darkTheme: StarlaneTheme.darkTheme,
              routerConfig: AppRouter.router,
            ),
          ),
        );
      },
    );
  }
}