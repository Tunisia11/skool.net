import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/cubits/auth/auth_cubit.dart';
import 'package:skool/firebase_options.dart';
import 'package:skool/repositories/auth_repository.dart';
import 'package:skool/screens/landing_page.dart';
import 'package:skool/widgets/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: MaterialApp(
          title: 'Skool',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2CBCE9)),
            useMaterial3: true,
            textTheme: GoogleFonts.cairoTextTheme(),
          ),
          // RTL Support for Arabic
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar', 'AE'), // Arabic
            Locale('en', 'EN'), // English
          ],
          locale: const Locale('ar', 'AE'), // Force Arabic

          home: const AuthWrapper(),
        ),
      ),
    );
  }
}
