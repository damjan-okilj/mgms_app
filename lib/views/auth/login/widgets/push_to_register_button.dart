import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MGMS/blocs/theme/theme_bloc.dart';
import 'package:MGMS/blocs/theme/theme_state.dart';
import 'package:MGMS/constants/color_constants.dart';
import 'package:MGMS/generated/locale_keys.g.dart';
import 'package:MGMS/views/auth/register/register_view.dart';

class PushToRegisterButton extends StatelessWidget {
  const PushToRegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => const RegisterView(),
              ),
              (route) => false,
            );
          },
          child: Text(
            LocaleKeys.register,
            style: TextStyle(
              color: themeState.isDark
                  ? ColorConstants.darkPrimaryIcon
                  : ColorConstants.lightPrimaryIcon,
            ),
          ).tr(),
        );
      },
    );
  }
}
