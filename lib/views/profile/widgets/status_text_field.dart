import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';
import 'package:template_app_bloc/constants/app_constants.dart';
import 'package:template_app_bloc/constants/color_constants.dart';
import 'package:template_app_bloc/generated/locale_keys.g.dart';

class StatusTextFieldWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function(String) onStatusChanged;
  final String? initialStatus;
  final List<String> status;
  final bool enabled;
  const StatusTextFieldWidget({
    super.key,
    required this.textEditingController,
    required this.onStatusChanged,
    required this.status,
    this.initialStatus,
    this.enabled = true,
  });

  @override
  State<StatusTextFieldWidget> createState() => _StatusTextFieldWidgetState();
}

class _StatusTextFieldWidgetState extends State<StatusTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
        return CupertinoTextField(
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return CupertinoActionSheet(
                  title: const Text("STATUS"),
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(LocaleKeys.close).tr(),
                  ),
                  actions: widget.status
                      .map(
                        (status) => CupertinoActionSheetAction(
                          onPressed: () async {
                            widget.onStatusChanged(status);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(status),
                              widget.initialStatus == status ? const Icon(CupertinoIcons.checkmark) : const SizedBox(),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            );
          },
          decoration: BoxDecoration(
            color: Colors.transparent
          ),
          controller: widget.textEditingController,
          placeholder: LocaleKeys.gender.tr(),
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          padding: const EdgeInsets.all(10),
          style: const TextStyle(
            color: CupertinoDynamicColor.withBrightness(
              color: Colors.black,
              darkColor: CupertinoColors.black,
            ),
          ),
          readOnly: true,
          enabled: widget.enabled,
          suffix: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              CupertinoIcons.forward,
            ),
          ),
          cursorColor: CupertinoColors.activeBlue,
        );
  }
}
