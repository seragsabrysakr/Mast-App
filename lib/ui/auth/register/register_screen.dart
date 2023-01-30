import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mast/app/app_assets.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/app/app_router.dart';
import 'package:mast/app/app_sized_box.dart';
import 'package:mast/app/app_validation.dart';
import 'package:mast/app/constants.dart';
import 'package:mast/app/di/di.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/app/text_style.dart';
import 'package:mast/data/model/auth/user_model.dart';
import 'package:mast/my_app.dart';
import 'package:mast/ui/auth/register/register_cubit.dart';
import 'package:mast/ui/componnents/custom_button.dart';
import 'package:mast/ui/componnents/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool showPassword = true;
  bool showConfirmPassword = true;
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var mobileController = TextEditingController();
  var fatherMobileController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var countryCode = '';

  final _formKey = GlobalKey<FormState>();
  void routeToHome(UserModel user) {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.mainScreen,
            // AppRouter.phoneVerificationScreen,
            arguments: user,
            (Route<dynamic> route) => false));
  }

  bool terms = false;
  bool showTerms = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<RegisterCubit>(),
        child: BlocConsumer<RegisterCubit, FlowState>(
          listener: (context, state) {
            if (state is SuccessState) {
              UserModel? user = RegisterCubit.get(context).userData;
              routeToHome(user!);
            }
            state.flowStateListener(context);
          },
          builder: (context, state) {
            var cubit = RegisterCubit.get(context);
            bool isSuccess = state is SuccessState;

            return state.flowStateBuilder(context,
                screenContent: isSuccess
                    ? const SizedBox()
                    : buildScreenContent(cubit), retry: () {
              registerAction(cubit);
            });
          },
        ),
      ),
    );
  }

  void registerAction(RegisterCubit cubit) {
    cubit.register(
      email: emailController.text,
      name: userNameController.text,
      phone: countryCode,
      password: passwordController.text,
    );
  }

  SingleChildScrollView buildScreenContent(RegisterCubit cubit) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            registerHeader(),
            buildRegisterForm(cubit),
            buildRegisterButton(cubit),
            buildRegisterFooter()
          ],
        ),
      ),
    );
  }

  Column buildRegisterButton(RegisterCubit cubit) {
    return Column(
      children: [
        AppSizedBox.h4,
        CustomButton(
          text: MyApp.tr.newAccount,
          fontsize: 14.sp,
          txtcolor: Colors.black,
          icon: SvgPicture.asset(AppAssets.icNext, color: Colors.black),
          onTap: () {
            if (_formKey.currentState!.validate()) {
              registerAction(cubit);
            }
          },
        ),
        AppSizedBox.h4,
      ],
    );
  }

  Widget registerHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity),
          AppSizedBox.h8,
          Image.asset(
            AppAssets.appLogo,
            scale: .7,
          ),
          Text(
            MyApp.tr.registerNewAccount,
            style: AppTextStyle.getBoldStyle(
                color: AppColors.primaryColor, fontSize: 15.sp),
          ),
          AppSizedBox.h4,
        ],
      ),
    );
  }

  // InkWell buildTerms() {
  //   return InkWell(
  //     onTap: () {
  //       if (!showTerms) {
  //         Navigator.pushNamed(context, AppRouter.termsScreen);
  //       }

  //       setState(() {
  //         showTerms = !showTerms;
  //         terms = !terms;
  //       });
  //     },
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(vertical: 1.5.h),
  //       child: Row(
  //         children: [
  //           AppSizedBox.w10,
  //           terms
  //               ? Icon(
  //                   Icons.check_circle,
  //                   color: AppColors.primaryColor,
  //                   size: 20.sp,
  //                 )
  //               : Icon(
  //                   Icons.circle_outlined,
  //                   color: AppColors.textFieldHintColor,
  //                   size: 20.sp,
  //                 ),
  //           AppSizedBox.w2,
  //           Text(
  //             MyApp.tr.agreeConditions,
  //             style: AppTextStyle.getRegularStyle(
  //                 color: AppColors.primaryColor, fontSize: 10.sp),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Column buildRegisterForm(RegisterCubit cubit) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //username
        CustomTextField(
          action: TextInputAction.next,
          type: TextInputType.text,
          controller: userNameController,
          hint: MyApp.tr.userName,
          validator: (String? value) {
            return Validations.userNameValidation(value);
          },
        ),
        //email
        CustomTextField(
          type: TextInputType.emailAddress,
          action: TextInputAction.next,
          controller: emailController,
          hint: MyApp.tr.email,
          validator: (String? value) {
            return Validations.emailValidation(value);
          },
        ),

        buildPhoneTextField(),
        //password
        CustomTextField(
          type: TextInputType.text,
          action: TextInputAction.next,
          obscure: showPassword,
          suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              child: Icon(
                showPassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              )),
          controller: passwordController,
          hint: MyApp.tr.password,
          validator: (String? value) {
            return Validations.passwordValidation(value);
          },
        ), //password
        CustomTextField(
          type: TextInputType.text,
          action: TextInputAction.done,
          obscure: showConfirmPassword,
          controller: confirmPasswordController,
          hint: MyApp.tr.confirmPassword,
          suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  showConfirmPassword = !showConfirmPassword;
                });
              },
              child: Icon(
                showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              )),
          validator: (String? value) {
            return Validations.confirmValidation(
                value, passwordController.text);
          },
        ),
      ],
    );
  }

  buildPhoneTextField() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 2.h),
        child: IntlPhoneField(
          controller: mobileController,
          showDropdownIcon: false,
          enabled: true,
          initialCountryCode: Constants.initialCountry,
          disableLengthCheck: false,
          flagsButtonMargin: EdgeInsets.symmetric(horizontal: 5.w),
          style: TextStyle(
              fontSize: 15.0.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black),
          decoration: phoneFieldDecoration(),
          onChanged: (phone) {
            print(phone.completeNumber);
            setState(() {
              countryCode = phone.completeNumber;
            });
          },
          onCountryChanged: (country) {
            // setState(() {
            //   countryCode = '+${country.dialCode.toString()}';
            // });
          },
        ),
      ),
    );
  }

  InputDecoration phoneFieldDecoration() {
    return InputDecoration(
        fillColor: Colors.white,
        filled: true,
        alignLabelWithHint: true,
        hintText: MyApp.tr.mobileNumber,
        hintStyle: AppTextStyle.getRegularStyle(
            color: AppColors.textFieldHintColor, fontSize: 13.sp),
        contentPadding: EdgeInsets.symmetric(
          vertical: 1.0.h,
          horizontal: 5.w,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.h),
          borderSide: const BorderSide(color: AppColors.textFieldHintColor),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.h),
            borderSide:
                const BorderSide(color: AppColors.primaryColor, width: 2)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.h),
            borderSide: const BorderSide(color: AppColors.textFieldHintColor)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.h),
          borderSide: const BorderSide(color: Colors.red),
        ));
  }

  Row buildRegisterFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(MyApp.tr.haveAccount,
            style: AppTextStyle.getRegularStyle(
              color: AppColors.textHintColor1,
              fontSize: 13.sp,
            )),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(MyApp.tr.logIn,
              style: AppTextStyle.getBoldStyle(
                color: AppColors.primaryColor,
                fontSize: 12.sp,
              )),
        )
      ],
    );
  }

  showErrorToast(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => popDialog(
        context: context,
        title: MyApp.tr.error,
        content: MyApp.tr.acceptOurTerms,
        boxColor: AppColors.errorColor));
  }
}
