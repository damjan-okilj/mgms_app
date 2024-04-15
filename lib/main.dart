import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:MGMS/api/api.dart';
import 'package:MGMS/blocs/auth/login/login_bloc.dart';
import 'package:MGMS/blocs/auth/register/register_bloc.dart';
import 'package:MGMS/blocs/profile/profile_bloc.dart';
import 'package:MGMS/blocs/theme/theme_bloc.dart';
import 'package:MGMS/blocs/theme/theme_event.dart';
import 'package:MGMS/blocs/theme/theme_state.dart';
import 'package:MGMS/constants/supported_locales.dart';
import 'package:MGMS/generated/codegen_loader.g.dart';
import 'package:MGMS/helpers/ui_helper.dart';
import 'package:MGMS/services/theme_service.dart';
import 'package:MGMS/services/user_service.dart';
import 'package:MGMS/views/navigation/navigation_view.dart';
import 'package:MGMS/views/splash/splash_view.dart';
import 'package:web_socket_channel/io.dart';
import 'package:MGMS/globals/globals.dart' as globals;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await dotenv.load();
  await ThemeService.getTheme();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var loggedIn = prefs.getBool('loggedIn');
  var access_token = prefs.getString('access_token');
  var email = prefs.getString('email');
  try {
    var user = await fetchMe();
    globals.role = user.type;
    globals.email = user.email;
    globals.first_name = user.first_name;
    globals.last_name = user.last_name;
  } catch (e) {
    loggedIn = false;
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => LoginBloc(userService: UserService())),
        BlocProvider(
            create: (context) => RegisterBloc(userService: UserService())),
        BlocProvider(
            create: (context) => ProfileBloc(userService: UserService())),
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: EasyLocalization(
        supportedLocales: SuppertedLocales.supportedLocales,
        path: 'assets/translations',
        assetLoader: const CodegenLoader(),
        child:
            MyApp(loggedIn: loggedIn, access_token: access_token, email: email),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key, this.loggedIn, this.access_token, this.email});
  bool? loggedIn = false;
  String? access_token;
  String? email;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeBloc themeBloc;

  void fetchEverything() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    themeBloc = BlocProvider.of<ThemeBloc>(context);
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = ThemeService.isDark;
    if (ThemeService.useDeviceTheme) {
      isDarkMode = brightness == Brightness.dark;
    }
    themeBloc.add(ChangeTheme(
        useDeviceTheme: ThemeService.useDeviceTheme, isDark: isDarkMode));

    super.initState();
    if (widget.loggedIn == true && !kIsWeb) {
      print('maybe');
      FlutterLocalNotificationsPlugin notifications =
          FlutterLocalNotificationsPlugin();
      var androidInit = AndroidInitializationSettings('ic_launcher');
      var channel = IOWebSocketChannel.connect(
          'ws://172.16.63.32:80/ws/notify/${widget.email}',
          headers: {"Authorization": widget.access_token});
      var _message = TextEditingController();
      var init = InitializationSettings(android: androidInit);
      notifications.initialize(init).then((done) => {
            channel.stream.listen((event) {
              notifications.show(
                  1,
                  "New task",
                  json.decode(event)['message'],
                  NotificationDetails(
                      android: AndroidNotificationDetails("mgms_0", "MGMS")));
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
    themeBloc.add(ChangeTheme(
        useDeviceTheme: ThemeService.useDeviceTheme, isDark: isDarkMode));
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
        home: widget.loggedIn == true
            ? const NavigationView()
            : const SplashView(),
      );
    });
  }
}
