import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MGMS/api/api.dart';
import 'package:MGMS/blocs/auth/login/login_bloc.dart';
import 'package:MGMS/blocs/auth/login/login_event.dart';
import 'package:MGMS/blocs/auth/login/login_state.dart';
import 'package:MGMS/blocs/profile/profile_bloc.dart';
import 'package:MGMS/blocs/profile/profile_state.dart';
import 'package:MGMS/blocs/theme/theme_bloc.dart';
import 'package:MGMS/blocs/theme/theme_event.dart';
import 'package:MGMS/blocs/theme/theme_state.dart';
import 'package:MGMS/globals/globals.dart' as globals;
import 'package:MGMS/constants/color_constants.dart';
import 'package:MGMS/constants/supported_locales.dart';
import 'package:MGMS/generated/locale_keys.g.dart';
import 'package:MGMS/helpers/ui_helper.dart';
import 'package:MGMS/views/auth/login/login_view.dart';
import 'package:MGMS/views/profile/profile_view.dart';
import 'package:MGMS/views/profile/widgets/profile_photo_widget.dart';
import 'package:MGMS/views/settings/widgets/list_section_widet.dart';
import 'package:MGMS/views/settings/widgets/list_tile_widget.dart';
import 'package:MGMS/widgets/custom_scaffold.dart';
import 'package:MGMS/widgets/unauthenticated_user_widget.dart';
part "settings_view_mixin.dart";

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  final bool loggedIn = true;
  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> with SettingsViewMixin {
  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            return BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                return CustomScaffold(
                  onRefresh: () async {
                    await Future<void>.delayed(
                      const Duration(milliseconds: 1000),
                    );
                  },
                  title: LocaleKeys.settings,
                  children: [
                    widget.loggedIn != false
                        ? Column(
                            children: [
                              ListSectionWidget(
                                hasLeading: false,
                                dividerMargin: 0,
                                children: [
                                  CupertinoListTile(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                const ProfileView()),
                                      );
                                    },
                                    padding: const EdgeInsets.all(10),
                                    backgroundColorActivated: themeState.isDark
                                        ? ColorConstants
                                            .darkBackgroundColorActivated
                                        : ColorConstants
                                            .lightBackgroundColorActivated,
                                    title: Text(
                                      '${globals.first_name} ${globals.last_name}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ),
                                    ),
                                    subtitle: Text(globals.email),
                                    leadingSize: UIHelper.deviceWidth * 0.12,
                                    leading: ProfilePhotoWidget(
                                        imageUrl:
                                            "https://media.istockphoto.com/id/1298261537/vector/blank-man-profile-head-icon-placeholder.jpg?s=2048x2048&w=is&k=20&c=arvyysiz2VuiQBB2DRZY0eXRu3169OlNJiSlqhupWF0="),
                                    trailing: Icon(
                                      CupertinoIcons.forward,
                                      color: themeState.isDark
                                          ? ColorConstants.darkSecondaryIcon
                                          : ColorConstants.lightSecondaryIcon,
                                    ),
                                  ),
                                ],
                              ),
                              ListSectionWidget(
                                children: [
                                  ListTileWidget(
                                    title: LocaleKeys.theme.tr(),
                                    leadingIcon: CupertinoIcons.sun_min_fill,
                                    leadingColor: CupertinoColors.systemBlue,
                                    onTap: () => _showSelectThemeSheet(context),
                                  ),
                                  ListTileWidget(
                                    title: LocaleKeys.language.tr(),
                                    leadingIcon: CupertinoIcons.globe,
                                    leadingColor: CupertinoColors.systemGreen,
                                    onTap: () =>
                                        _showSelectLanguageSheet(context),
                                  ),
                                ],
                              ),
                              ListSectionWidget(
                                children: [
                                  ListTileWidget(
                                    title: LocaleKeys.logout.tr(),
                                    leadingIcon:
                                        CupertinoIcons.square_arrow_left_fill,
                                    leadingColor: CupertinoColors.systemRed,
                                    onTap: () =>
                                        _showLogOutDialog(context, loginBloc),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const UnauthenticatedUserWidget(),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
