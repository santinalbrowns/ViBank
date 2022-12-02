import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibank/auth/auth.dart';
import 'package:vibank/authentication/bloc/authentication_bloc.dart';
import 'package:vibank/home/home_view.dart';
import 'package:vibank/repo/auth_repo.dart';
import 'package:vibank/repo/user_repo.dart';
import 'package:vibank/splash/view/splash_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepo()),
        RepositoryProvider(create: (context) => UserRepo()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
              authRepo: RepositoryProvider.of<AuthRepo>(context),
              userRepo: RepositoryProvider.of<UserRepo>(context),
            )..add(BootstrapAuthentication()),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get navigator => navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: lightTheme(),
      darkTheme: dartTheme(),
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationSuccess) {
              navigator.pushAndRemoveUntil(
                RootScreen.route(),
                (route) => false,
              );
            }

            if (state is AuthenticationFailed) {
              navigator.pushAndRemoveUntil(
                RootScreen.route(),
                (route) => false,
              );
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }

  ThemeData lightTheme() {
    final baseTheme = ThemeData(brightness: Brightness.light);

    return baseTheme.copyWith(
        primaryColor: const Color.fromRGBO(0, 162, 114, 1),
        splashColor: const Color.fromRGBO(0, 162, 114, 1),
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: const Color.fromRGBO(249, 249, 249, 1),
          foregroundColor: Colors.black,
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(249, 249, 249, 1),
        chipTheme: const ChipThemeData().copyWith(
          backgroundColor: const Color.fromARGB(228, 228, 228, 227),
          iconTheme: const IconThemeData().copyWith(
            size: 16,
          ),
          pressElevation: 0,
          selectedColor: Colors.black,
        ),
        radioTheme: const RadioThemeData().copyWith(
          fillColor: MaterialStateColor.resolveWith(
            (states) => Colors.black,
          ),
        ));
  }

  ThemeData dartTheme() {
    final baseTheme = ThemeData(brightness: Brightness.dark);

    return baseTheme.copyWith(
      primaryColor: const Color.fromRGBO(0, 162, 114, 1),
      splashColor: const Color.fromRGBO(0, 162, 114, 1),
      backgroundColor: Colors.black,
      scaffoldBackgroundColor: const Color.fromRGBO(22, 22, 23, 1),
      appBarTheme: const AppBarTheme().copyWith(
        backgroundColor: const Color.fromRGBO(28, 28, 30, 1),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData().copyWith(
        backgroundColor: const Color.fromRGBO(28, 28, 30, 1),
      ),
    );
  }
}
