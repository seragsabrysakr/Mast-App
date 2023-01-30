import 'package:flutter/material.dart';

import 'package:mast/app/extensions.dart';
import 'package:mast/app/text_style.dart';
import 'package:intl/intl.dart' as intl;

class CustomSearch extends StatefulWidget {
  final TextEditingController controller;
  final Color? color;
  final Function(String)? onSearchTextChanged;
  final Function(String)? onSubmit;
  VoidCallback? onTap;
  FocusNode? focus;
  double? width;
  double? higth;
  String? hint;
  VoidCallback? search;
  bool enabled;
  bool isSearch;

  CustomSearch(
      {Key? key,
      required this.controller,
      this.onTap,
      this.search,
      this.focus,
      this.hint,
      this.width = 88,
      this.higth = 10,
      this.enabled = true,
      this.isSearch = false,
      required this.onSearchTextChanged,
      this.color = Colors.white,
      this.onSubmit})
      : super(key: key);

  @override
  State<CustomSearch> createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
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

  final ValueNotifier<TextDirection> _textDir = ValueNotifier(TextDirection.ltr);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.higth?.h,
      width: widget.width?.w,
      child: ValueListenableBuilder<TextDirection>(
          valueListenable: _textDir,
          builder: (context, value, child) {
            if (widget.controller.text.trim().length < 100) {
              final dir = getDirection(widget.controller.text);
              if (dir != value) _textDir.value = dir;
            }
            return TextField(
              textAlignVertical: TextAlignVertical.top,
              style: AppTextStyle.getRegularStyle(color: Colors.black, fontSize: 12.sp),
              textDirection: value,
              cursorColor: Colors.black,
              focusNode: widget.focus,
              controller: widget.controller,
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
                if (widget.onSearchTextChanged != null) {
                  widget.onSearchTextChanged!(input);
                }
              },
              onSubmitted: widget.onSubmit,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                enabled: widget.enabled,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 5.w),
                hintText: '     ابحث عن متجرك المفضل',
                hintStyle: AppTextStyle.getRegularStyle(color: Colors.grey),
                hintTextDirection: TextDirection.rtl,
                filled: true,
                fillColor: widget.color,
                suffixIconConstraints: BoxConstraints(minHeight: 4.h, minWidth: 4.h),
                suffixIcon: IconButton(
                  onPressed: widget.search,
                  icon: Icon(
                    Icons.search,
                    size: 20.sp,
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(5.h),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(5.h),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(5.h),
                ),
              ),
            );
          }),
    );
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

class FilterItem {
  final String text;
  bool value;

  FilterItem({required this.text, this.value = false});
}
