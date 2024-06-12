import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intelligent_pharmacy/authentication/view/login_page.dart';
import 'package:intelligent_pharmacy/doctor/layout/view/doctor_layout.dart';
import 'package:intelligent_pharmacy/firebase_options.dart';
import 'package:intelligent_pharmacy/models/doctor_model.dart';
import 'package:intelligent_pharmacy/shared/network/cache_keys.dart';
import 'package:intelligent_pharmacy/shared/network/cached_preference.dart';
import 'package:intelligent_pharmacy/shared/utils/constants.dart';
import 'package:intelligent_pharmacy/user/features/profile/manager/profile_cubit/profile_cubit.dart';
import 'package:intelligent_pharmacy/user/layout/layout.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/user_model.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: 'AIzaSyAyq8J9URJd5YiOE02tS8bgnDPYwOrNr-I');
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    CacheHelper.init(),
  ]);
  Permission.camera.request();
  if ((await CacheHelper.getData(key: CacheKeys.userId)) != null) {
    Constants.userModel = UserModel.fromJson(jsonDecode(await CacheHelper.getData(key: CacheKeys.userId)));
  } else if ((await CacheHelper.getData(key: CacheKeys.doctorId)) != null) {
    Constants.doctorModel =
        DoctorModel.fromCache(jsonDecode(await CacheHelper.getData(key: CacheKeys.doctorId)));
  }
  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()..getUserData()),
        ],
        child: MaterialApp(
          title: 'Pharmacy App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.black87,
              ),
            ),
            textTheme: TextTheme(
              titleLarge: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
            useMaterial3: true,
          ),
          themeMode: ThemeMode.light,
          // home: const LoginPage(),
          home: Constants.userModel == null && Constants.doctorModel == null
              ? const LoginPage()
              : Constants.userModel != null
                  ? const UserLayout()
                  : const DoctorLayout(),
        ),
      ),
    );
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    debugPrint('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    debugPrint('onClose -- ${bloc.runtimeType}');
  }
}
