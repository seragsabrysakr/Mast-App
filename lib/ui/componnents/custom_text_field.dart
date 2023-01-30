import 'package:flutter/material.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/text_style.dart';
import 'package:intl/intl.dart' as intl;

class CustomTextField extends StatefulWidget {
  final bool obscure;
  final bool align;
  final bool enable;
  final int? max;
  final int? min;
  final double? width;
  final String? Function(String?)? validator;
  final String? hint;
  final TextEditingController controller;

  final Widget? prefix;
  final Widget? suffixIcon;
  final TextInputType? type;
  final VoidCallback? onTapPassword;
  final void Function(String)? onChange;
  final double radius;

  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextInputAction? action;

  const CustomTextField({
  required  this.controller,
    this.align = false,
    this.enable = true,
    this.action,
    this.focusNode,
    required this.hint,
    this.max = 1,
    this.min,
    this.obscure = false,
    this.onChange,
    this.type,
    required this.validator,
    this.onTapPassword,
    Key? key,
    this.prefix,
    this.onTap,
    this.radius = 18,
    this.width,
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isRTL(String text) {
    return intl.Bidi.detectRtlDirectionality(text);
  }
@override
  void initState() {
    super.initState();
    bool isR = isRTL(widget.controller.text);
    if (isR) {
      _textDir.value = TextDirection.rtl;
    } else {
      _textDir.value = TextDirection.ltr;
    }
  }
  final ValueNotifier<TextDirection> _textDir =
  ValueNotifier(TextDirection.ltr);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          borderRadius: BorderRadius.circular(widget.radius.h),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(widget.radius.h)),
            width: widget.width ?? size.width * .8,
            child: ValueListenableBuilder<TextDirection>(
                valueListenable: _textDir,
                builder: (context, value, child) {
                  if (widget.controller.text.trim().length < 100) {
                    final dir = getDirection(widget.controller.text);
                    if (dir != value) _textDir.value = dir;
                  }
                  return TextFormField(
                    textDirection: widget.align ? TextDirection.rtl : value,
                    enabled: widget.enable,
                    onChanged: (input) {
                      if (input.trim().length < 100) {
                        final dir = getDirection(input);
                        if (dir != value) _textDir.value = dir;
                      }
                      bool isR = isRTL(input);
                      if (isR) {
                        _textDir.value = TextDirection.rtl;
                      } else {
                        _textDir.value = TextDirection.ltr;
                      }
                      if (widget.onChange != null) {
                        widget.onChange!(input);
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: widget.action,
                    onTap: widget.onTap,
                    focusNode: widget.focusNode,
                    maxLines: widget.max,
                    minLines: widget.min,
                    obscuringCharacter: '*',
                    controller: widget.controller,
                    cursorColor: AppColors.primaryColor,
                    style:
                    AppTextStyle.getBoldStyle(color: AppColors.blackColor, fontSize: 13.sp),
                    keyboardType: widget.type,
                    textAlignVertical: TextAlignVertical.center,
                    obscureText: widget.obscure,
                    validator: widget.validator,
                    decoration: buildInputDecoration(),
                  );
                }
                    ),
          ),
        ),
        SizedBox(
          height: 1.5.h,
        )
      ],
    );
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 1.1.h),

        // errorText: '',
        fillColor: Colors.white,
        filled: true,
        alignLabelWithHint: true,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 25,
          minHeight: 25,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 25,
          minHeight: 25,
        ),
        suffixIcon: Padding(
          padding: EdgeInsetsDirectional.only(start: 3.w, end: 5.w),
          child: widget.suffixIcon,
        ),
        prefixIcon: GestureDetector(
          onTap: widget.onTapPassword,
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: 5.w, end: 3.w),
            child: widget.prefix,
          ),
        ),
        hintText: widget.hint!,
        hintStyle: AppTextStyle.getRegularStyle(
            color: widget.enable ? AppColors.textFieldHintColor : AppColors.blackColor,
            fontSize: 13.sp),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius.h),
            borderSide: const BorderSide(color: AppColors.textFieldHintColor)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius.h),
            borderSide: const BorderSide(color: AppColors.primaryColor)),
        // disabledBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(radius.h),
        //     borderSide: const BorderSide(color: AppColors.primaryColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius.h),
            borderSide: const BorderSide(color: AppColors.primaryColor, width: 2)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius.h),
          borderSide: const BorderSide(color: Colors.red),
        ));
  }

  TextDirection getDirection(String v) {
    final string = v.trim();
    if (string.isEmpty) return TextDirection.ltr;
    final firstUnit = string.codeUnitAt(0);
    if (firstUnit > 0x0600 && firstUnit < 0x06FF ||
        firstUnit > 0x0750 && firstUnit < 0x077F ||
        firstUnit > 0x07C0 && firstUnit < 0x07EA ||
        firstUnit > 0x0840 && firstUnit < 0x085B ||
        firstUnit > 0x08A0 && firstUnit < 0x08B4 ||
        firstUnit > 0x08E3 && firstUnit < 0x08FF ||
        firstUnit > 0xFB50 && firstUnit < 0xFBB1 ||
        firstUnit > 0xFBD3 && firstUnit < 0xFD3D ||
        firstUnit > 0xFD50 && firstUnit < 0xFD8F ||
        firstUnit > 0xFD92 && firstUnit < 0xFDC7 ||
        firstUnit > 0xFDF0 && firstUnit < 0xFDFC ||
        firstUnit > 0xFE70 && firstUnit < 0xFE74 ||
        firstUnit > 0xFE76 && firstUnit < 0xFEFC ||
        firstUnit > 0x10800 && firstUnit < 0x10805 ||
        firstUnit > 0x1B000 && firstUnit < 0x1B0FF ||
        firstUnit > 0x1D165 && firstUnit < 0x1D169 ||
        firstUnit > 0x1D16D && firstUnit < 0x1D172 ||
        firstUnit > 0x1D17B && firstUnit < 0x1D182 ||
        firstUnit > 0x1D185 && firstUnit < 0x1D18B ||
        firstUnit > 0x1D1AA && firstUnit < 0x1D1AD ||
        firstUnit > 0x1D242 && firstUnit < 0x1D244) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }
}
