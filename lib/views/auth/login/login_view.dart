import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MGMS/api/api.dart';
import 'package:MGMS/blocs/auth/login/login_bloc.dart';
import 'package:MGMS/blocs/auth/login/login_event.dart';
import 'package:MGMS/blocs/auth/login/login_state.dart';
import 'package:MGMS/blocs/auth/register/register_state.dart';
import 'package:MGMS/blocs/profile/profile_bloc.dart';
import 'package:MGMS/blocs/profile/profile_event.dart';
import 'package:MGMS/blocs/theme/theme_bloc.dart';
import 'package:MGMS/blocs/theme/theme_state.dart';
import 'package:MGMS/components/custom_text_field.dart';
import 'package:MGMS/constants/color_constants.dart';
import 'package:MGMS/generated/locale_keys.g.dart';
import 'package:MGMS/helpers/app_helper.dart';
import 'package:MGMS/models/http_response_model.dart';
import 'package:MGMS/views/auth/password/forgot_password_view.dart';
import 'package:MGMS/views/auth/login/widgets/background_widget.dart';
import 'package:MGMS/views/auth/login/widgets/login_button.dart';
import 'package:MGMS/views/auth/login/widgets/push_to_register_button.dart';
import 'package:MGMS/views/auth/login/widgets/title_widget.dart';
import 'package:MGMS/views/auth/verify/verify_view.dart';
import 'package:MGMS/views/home/home_view.dart';
import 'package:MGMS/views/navigation/navigation_view.dart';
import 'package:MGMS/views/splash/splash_view.dart';
part "login_view_mixin.dart";

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with LoginViewMixin {
  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              const BackgroundWidget(),
              CupertinoPageScaffold(
                backgroundColor: Colors.transparent,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(40),
                    child: SafeArea(
                      child: BlocListener<LoginBloc, LoginState>(
                        listener: (context, state) {
                          _listener(state);
                        },
                        child: BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                const TitleWidget(),
                                const SizedBox(height: 10),
                                LoginButton(
                                  isLoading: state.isLoading,
                                  onPressed: () async {
                                    int result = await login(context);
                                    if (result == 200) {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const NavigationView(),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
