import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/app/app_router.dart';
import 'package:mast/app/app_sized_box.dart';
import 'package:mast/app/di/di.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/app/text_style.dart';
import 'package:mast/data/model/auth/user_model.dart';
import 'package:mast/data/storage/local/app_prefs.dart';
import 'package:mast/my_app.dart';
import 'package:mast/ui/auth/otp/otp_cubit.dart';
import 'package:mast/ui/componnents/custom_button.dart';
import 'package:pinput/pinput.dart';

class PhoneVerificationScreen extends StatefulWidget {
  UserModel user;
  PhoneVerificationScreen({Key? key, required this.user}) : super(key: key);
  var isCall = false;
  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final Pinput _pinPutController = const Pinput();
  String? _otp;
  Timer? _timer;
  bool timeDown = true;
  int start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          setState(() {
            timeDown = false;
            timer.cancel();
          });
        } else {
          setState(() {
            timeDown = true;
            start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  final defaultPinTheme = PinTheme(
    width: 90.w,
    height: 50,
    textStyle: const TextStyle(
        fontSize: 20,
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w500),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.textHintColor1, width: 2),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  void navigateTo(String route, {Object? arguments}) {
    WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context)
        .pushNamedAndRemoveUntil(route, (Route<dynamic> route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocProvider(
        create: (context) => getIt<PhoneVerificationCubit>(),
        child: BlocConsumer<PhoneVerificationCubit, FlowState>(
          listener: (context, state) {
            state.flowStateListener(context);
            if (state is SuccessState) {
              var cubit = PhoneVerificationCubit.get(context);
              if (state.message == MyApp.tr.verifyCode) {
                cubit.verifyUserPhone(phone: widget.user.phone!, code: _otp!);
              }
              if (state.message == MyApp.tr.success) {
                var user = widget.user;
                user.isActive = true;
                getIt<AppPreferences>().isUserLogin = true;
                getIt<AppPreferences>().userDataModel = user;
                navigateTo(AppRouter.mainScreen);
              }
            }
          },
          builder: (context, state) {
            var cubit = PhoneVerificationCubit.get(context);
            bool isSuccess = state is SuccessState;

            return state.flowStateBuilder(context,
                screenContent: isSuccess
                    ? const SizedBox()
                    : buildScreenContent(context, cubit),
                retry: () {});
          },
        ),
      ),
    );
  }

  SafeArea buildScreenContent(
      BuildContext context, PhoneVerificationCubit cubit) {
    _sendOtp(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _otpHeader(),
            AppSizedBox.h3,
            _otpInput(),
            AppSizedBox.h3,
            _otpProcess(context, cubit),
            _otpFooter(),
          ],
        ),
      ),
    );
  }

  _otpHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: double.infinity),
        AppSizedBox.h8,
        Icon(
          Icons.phone_android_sharp,
          color: AppColors.primaryColor,
          size: 100,
        ),
        AppSizedBox.h4,
        Text(MyApp.tr.confirmCodeHeader1,
            style: AppTextStyle.getBoldStyle(
              color: AppColors.blackColor,
              fontSize: 12.sp,
            )),
        AppSizedBox.h1,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(MyApp.tr.confirmCodeHeader2,
                style: AppTextStyle.getRegularStyle(
                  color: AppColors.textHintColor2,
                  fontSize: 10.sp,
                )),
            Text(widget.user.phone!,
                style: AppTextStyle.getRegularStyle(
                  color: AppColors.primaryColor,
                  fontSize: 12.sp,
                )),
          ],
        ),
        AppSizedBox.h3,
      ],
    );
  }

  _otpProcess(BuildContext context, PhoneVerificationCubit cubit) {
    return Column(
      children: [
        CustomButton(
          butcolor: AppColors.primaryColor,
          fontweight: FontWeight.w600,
          txtcolor: Colors.white,
          onTap: () {
            if (_otp != null) {
              cubit.verifySmsCode(_otp!);
            }
          },
          fontsize: 15.sp,
          text: MyApp.tr.confirm,
        ),
        AppSizedBox.h8,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(MyApp.tr.otpNotReceive,
                style: AppTextStyle.getBoldStyle(
                  color: AppColors.textHintColor2,
                  fontSize: 12.sp,
                )),
            AppSizedBox.w3,
            GestureDetector(
              onTap: () {
                if (!timeDown) {
                  cubit.sendOtp(widget.user.phone!);
                  setState(() {
                    startTimer();
                    timeDown = true;
                    start = 60;
                  });
                }
              },
              child: Text(MyApp.tr.clickHere,
                  style: AppTextStyle.getBoldStyle(
                    color: !timeDown
                        ? AppColors.primaryColor
                        : AppColors.textHintColor2,
                    fontSize: 12.sp,
                  )),
            ),
            AppSizedBox.w2,
            if (timeDown)
              Text('(${MyApp.tr.tryAfter} $start ثانية)',
                  style: AppTextStyle.getBoldStyle(
                    color: AppColors.textHintColor2,
                    fontSize: 12.sp,
                  )),
          ],
        ),
      ],
    );
  }

  _otpFooter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSizedBox.h3,
      ],
    );
  }

  Widget _otpInput() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        margin: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Pinput(
          crossAxisAlignment: CrossAxisAlignment.center,
          length: 6,
          defaultPinTheme: defaultPinTheme,
          validator: (s) {
            setState(() {
              _otp = s;
            });
            return null;
          },
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
          onCompleted: (pin) => print(pin),
        ),
      ),
    );
  }

  void _sendOtp(BuildContext context) {
    if (!widget.isCall) {
      widget.isCall = true;
      PhoneVerificationCubit.get(context).sendOtp(widget.user.phone!);
    }
  }
}
