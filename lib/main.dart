import 'dart:convert';
import 'dart:ffi';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template_app_bloc/blocs/auth/login/login_bloc.dart';
import 'package:template_app_bloc/blocs/auth/register/register_bloc.dart';
import 'package:template_app_bloc/blocs/profile/profile_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_event.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';
import 'package:template_app_bloc/constants/supported_locales.dart';
import 'package:template_app_bloc/generated/codegen_loader.g.dart';
import 'package:template_app_bloc/helpers/ui_helper.dart';
import 'package:template_app_bloc/services/theme_service.dart';
import 'package:template_app_bloc/services/user_service.dart';
import 'package:template_app_bloc/views/navigation/navigation_view.dart';
import 'package:template_app_bloc/views/splash/splash_view.dart';
import 'package:web_socket_channel/io.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  await dotenv.load();
  await ThemeService.getTheme();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc(userService: UserService())),
        BlocProvider(create: (context) => RegisterBloc(userService: UserService())),
        BlocProvider(create: (context) => ProfileBloc(userService: UserService())),
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: EasyLocalization(
        supportedLocales: SuppertedLocales.supportedLocales,
        path: 'assets/translations',
        assetLoader: const CodegenLoader(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  late ThemeBloc themeBloc;
  var loggedIn;
  var access_token;

  void fetchEverything() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedIn = prefs.getBool('loggedIn');
    access_token = prefs.getString('access_token');
  }

  @override
  void initState() {
    themeBloc = BlocProvider.of<ThemeBloc>(context);
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = ThemeService.isDark;
    if (ThemeService.useDeviceTheme) {
      isDarkMode = brightness == Brightness.dark;
    }
    themeBloc.add(ChangeTheme(useDeviceTheme: ThemeService.useDeviceTheme, isDark: isDarkMode));

    super.initState();
    if(loggedIn == true){
      FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();
      var androidInit = AndroidInitializationSettings('launch_background');
      var channel = IOWebSocketChannel.connect('ws://172.16.63.32:8000/ws/notify/damjan.okilj@studen-global.com', headers: {"Auhtorization": access_token});
      var _message  = TextEditingController();
      var init = InitializationSettings(android: androidInit);
      notifications.initialize(init).then((done) => {
        channel.stream.listen((event) {
          notifications.show(
            0,
            "New notification",
            json.decode(event)['message'],
            NotificationDetails(
              android: AndroidNotificationDetails(
                  "mgms_0", "MGMS"
              )
            )
          );
        })
      });
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    var brightness = MediaQuery.of(context).platformBrightness;
    await ThemeService.getTheme();

    bool isDarkMode = ThemeService.isDark;
    if (ThemeService.useDeviceTheme) {
      isDarkMode = brightness == Brightness.dark;
    }
    themeBloc.add(ChangeTheme(useDeviceTheme: ThemeService.useDeviceTheme, isDark: isDarkMode));
  }

  @override
  Widget build(BuildContext context) {
    UIHelper.initialize(context);
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themeState) {
      return CupertinoApp(
        navigatorKey: navigatorKey,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'Template App',
        theme: ThemeService.buildTheme(themeState),
        debugShowCheckedModeBanner: false,
        home: loggedIn == true ? const NavigationView() : const SplashView(),
      );
    });
  }
}
