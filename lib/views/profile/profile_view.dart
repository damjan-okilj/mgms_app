import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MGMS/api/api.dart';
import 'package:MGMS/blocs/auth/login/login_bloc.dart';
import 'package:MGMS/blocs/auth/login/login_state.dart';
import 'package:MGMS/blocs/profile/profile_bloc.dart';
import 'package:MGMS/blocs/profile/profile_event.dart';
import 'package:MGMS/blocs/profile/profile_state.dart';
import 'package:MGMS/blocs/theme/theme_bloc.dart';
import 'package:MGMS/blocs/theme/theme_state.dart';
import 'package:MGMS/components/custom_trailing.dart';
import 'package:MGMS/constants/app_constants.dart';
import 'package:MGMS/constants/color_constants.dart';
import 'package:MGMS/generated/locale_keys.g.dart';
import 'package:MGMS/helpers/app_helper.dart';
import 'package:MGMS/helpers/ui_helper.dart';
import 'package:MGMS/views/navigation/navigation_view.dart';
import 'package:MGMS/views/profile/widgets/birthday_text_field.dart';
import 'package:MGMS/views/profile/widgets/gender_text_field.dart';
import 'package:MGMS/views/profile/widgets/image_dialog.dart';
import 'package:MGMS/views/profile/widgets/profile_photo_widget.dart';
import 'package:MGMS/views/profile/widgets/profile_text_field.dart';
import 'package:MGMS/widgets/custom_scaffold.dart';
import 'package:MGMS/widgets/unauthenticated_user_widget.dart';
part "profile_view_mixin.dart";

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with ProfileViewMixin {
  User? me;
  @override
  void initState() {
    // TODO: implement initState
    fetchMe().then((value) => setState(() {
          me = value;
        }));
    print(me?.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileBloc profileBloc = BlocProvider.of<ProfileBloc>(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            return BlocListener<ProfileBloc, ProfileState>(
              listener: (context, profileState) {
                _listener(profileState);
              },
              child: PopScope(
                canPop: !profileState.isLoading,
                child: CustomScaffold(
                  title: LocaleKeys.profile,
                  trailing: CustomTrailing(
                    showLoadingIndicator: true,
                    text: LocaleKeys.done,
                    isLoading: me == null ? true : profileState.isLoading,
                    onPressed: () {
                      if (_checkValues() && me != null) {
                        profileState.user!.firstName =
                            firstNameTextEditingController.text.trim();
                        profileState.user!.lastName =
                            lastNameTextEditingController.text.trim();
                        profileState.user!.dateOfBirth = _selectedDate!;
                        profileState.user!.gender = _selectedGender!;
                        profileBloc.add(UpdateUser(user: profileState.user!));
                      } else {
                        AppHelper.showErrorMessage(
                            context: context,
                            content: LocaleKeys.please_fill_in_all_fields.tr());
                      }
                    },
                  ),
                  children: [
                    me != null
                        ? Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: themeState.isDark
                                        ? ColorConstants.darkItem
                                        : ColorConstants.lightItem,
                                    borderRadius: UIHelper.borderRadius,
                                  ),
                                  child: Column(children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CupertinoButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                showCupertinoDialog(
                                                  barrierDismissible: true,
                                                  context: context,
                                                  builder: (context) {
                                                    return ImageDialog(
                                                        imageUrl:
                                                            'https://media.istockphoto.com/id/1298261537/vector/blank-man-profile-head-icon-placeholder.jpg?s=2048x2048&w=is&k=20&c=arvyysiz2VuiQBB2DRZY0eXRu3169OlNJiSlqhupWF0=');
                                                  },
                                                );
                                              },
                                              child: ProfilePhotoWidget(
                                                  imageUrl:
                                                      'https://media.istockphoto.com/id/1298261537/vector/blank-man-profile-head-icon-placeholder.jpg?s=2048x2048&w=is&k=20&c=arvyysiz2VuiQBB2DRZY0eXRu3169OlNJiSlqhupWF0='),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: const Text(LocaleKeys
                                                        .enter_your_info)
                                                    .tr(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        CupertinoButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              barrierDismissible: true,
                                              context: context,
                                              builder: (context) {
                                                return ImageDialog(
                                                    imageUrl:
                                                        'https://media.istockphoto.com/id/1298261537/vector/blank-man-profile-head-icon-placeholder.jpg?s=2048x2048&w=is&k=20&c=arvyysiz2VuiQBB2DRZY0eXRu3169OlNJiSlqhupWF0=');
                                              },
                                            );
                                          },
                                          padding: EdgeInsets.zero,
                                          child: Text(
                                            LocaleKeys.edit,
                                            style: TextStyle(
                                              color: themeState.isDark
                                                  ? ColorConstants
                                                      .darkPrimaryIcon
                                                  : ColorConstants
                                                      .lightPrimaryIcon,
                                            ),
                                          ).tr(),
                                        ),
                                      ],
                                    ),
                                  ])),
                            ],
                          )
                        : const UnauthenticatedUserWidget(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
