// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:chat_app/features/authentication/pages/Authentication_page.dart';
import 'package:chat_app/features/authentication/pages/sign_up_page.dart';
import 'package:chat_app/features/home/pages/home_page.dart';
import 'package:chat_app/features/home/pages/profile_page.dart';
import 'package:chat_app/features/home/pages/user_list_page.dart';
import 'package:chat_app/features/home/providers/chats_provider.dart';
import 'package:chat_app/features/home/providers/user_provider.dart';
import 'package:chat_app/l10n/l10n.dart';
import 'package:chat_app/services/app_service.dart';
import 'package:chat_app/utils/app_theme.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    AppService.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ChatsProvider()),
      ],
      child: DynamicColorBuilder(
        builder: (ColorScheme? lightColorScheme, ColorScheme? darkColorScheme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(lightColorScheme),
            darkTheme: AppTheme.darkTheme(darkColorScheme),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  Provider.of<UserProvider>(context, listen: false).getUsers();
                  // Future.delayed(
                  //   const Duration(seconds: 2),
                  //   () {},
                  // );
                  // AppService.instance.currentUser =
                  //     Provider.of<UserProvider>(context).getUserById(
                  //   FirebaseAuth.instance.currentUser!.uid,
                  // );
                  Future.delayed(
                    const Duration(seconds: 2),
                    () {},
                  );
                  return const HomePage();
                } else {
                  return const AuthenticationPage();
                }
              },
            ),
            routes: {
              HomePage.routeName: (context) => const HomePage(),
              SignUpPage.routeName: (context) => const SignUpPage(),
              ProfilePage.routeName: (context) => const ProfilePage(),
              UserListPage.routeName: (context) => const UserListPage(),
              AuthenticationPage.routeName: (context) =>
                  const AuthenticationPage(),
            },
          );
        },
      ),
    );
  }
}
