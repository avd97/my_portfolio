import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/features/admin/bloc/admin_bloc.dart';
import 'package:my_portfolio/features/admin/screen/admin_access_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_portfolio/features/web/screen/home_page.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
// 👇 Add this line explicitly
  FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: "https://my-portfolio-24582-default-rtdb.firebaseio.com");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abhishek Deshpande',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      /// ✅ FIX HERE
      home: kIsWeb
          ? const HomePage() // load HomePage on web
          : BlocProvider(
              create: (context) => AdminBloc(),
              child: const AdminAccessScreen(), // load AdminAccessScreen on Android/iOS
            ),
    );
  }
}
