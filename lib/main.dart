import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';
import 'package:my_portfolio/core/theme_cubit.dart';
import 'package:my_portfolio/features/admin/bloc/admin_bloc.dart';
import 'package:my_portfolio/features/admin/screen/admin_access_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_portfolio/features/web/bloc/home_page_bloc.dart';
import 'package:my_portfolio/features/web/bloc/services_bloc.dart';
import 'package:my_portfolio/features/web/screen/home_page.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
// 👇 Add this line explicitly
  FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: "https://my-portfolio-24582-default-rtdb.firebaseio.com");

  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'Abhishek Deshpande',

          debugShowCheckedModeBanner: false,

          themeMode: themeMode,

          // theme: ThemeData(
          //   brightness: Brightness.light,
          //   colorScheme: ColorScheme.fromSeed(
          //     seedColor: Colors.teal,
          //     brightness: Brightness.light,
          //   ),
          //   scaffoldBackgroundColor: Colors.white,
          // ),
          //
          // darkTheme: ThemeData(
          //   brightness: Brightness.dark,
          //   colorScheme: ColorScheme.fromSeed(
          //     seedColor: Colors.teal,
          //     brightness: Brightness.dark,
          //   ),
          //   scaffoldBackgroundColor: const Color(0xFF121212),
          // ),

          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,

          home: kIsWeb
              ? MultiBlocProvider(
            providers: [
              BlocProvider<HomePageBloc>(
                create: (_) => HomePageBloc()
                  ..add(const InitializeHomePageEvent()),
              ),
              BlocProvider<ServicesBloc>(
                create: (_) => ServicesBloc(),
              ),
            ],
            child: const HomePage(),
          )
              : BlocProvider(
            create: (context) => AdminBloc(),
            child: const AdminAccessScreen(),
          ),
        );
      },
    );
  }
}
