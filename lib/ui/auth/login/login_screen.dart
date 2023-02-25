import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mast/app/app_assets.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/app/app_router.dart';
import 'package:mast/app/app_sized_box.dart';
import 'package:mast/app/app_validation.dart';
import 'package:mast/app/di/di.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/app/text_style.dart';
import 'package:mast/data/storage/local/app_prefs.dart';
import 'package:mast/my_app.dart';
import 'package:mast/ui/auth/login/login_cubit.dart';
import 'package:mast/ui/componnents/custom_button.dart';
import 'package:mast/ui/componnents/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  void routeToHome() {
    getIt<AppPreferences>().isUserLogin = true;
    navigateTo(AppRouter.mainScreen);
  }

  void navigateTo(String route, {Object? arguments}) {
    WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context)
        .pushNamedAndRemoveUntil(route, arguments: arguments, (Route<dynamic> route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocProvider(
        create: (context) => getIt<LoginCubit>(),
        child: BlocConsumer<LoginCubit, FlowState>(
          listener: (context, state) {
            state.flowStateListener(context);
            if (state is SuccessState) {
              routeToHome();
            }
          },
          builder: (context, state) {
            var cubit = LoginCubit.get(context);
            bool isSuccess = state is SuccessState;
            return state.flowStateBuilder(context,
                screenContent: isSuccess ? const SizedBox() : buildScreenContent(cubit), retry: () {
              loginAction(cubit);
            });
          },
        ),
      ),
    );
  }

  void loginAction(LoginCubit cubit) {
    cubit.login(email: emailController.text, password: passwordController.text);
  }

  Widget buildScreenContent(LoginCubit cubit) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildLogInHeader(),
            buildLogInForm(),
            buildLogInProcces(cubit),
            buildLogInFooter(),
            TextButton(
              onPressed: () {
                navigateTo(AppRouter.mainScreen);
              },
              child: Text('الدخول كضيف',
                  style: AppTextStyle.getBoldStyle(
                    color: Colors.black,
                    fontSize: 13.sp,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Column buildLogInProcces(LoginCubit cubit) {
    return Column(
      children: [
        AppSizedBox.h2,
        CustomButton(
          text: MyApp.tr.logIn,
          fontsize: 14.sp,
          txtcolor: Colors.black,
          onTap: () {
            if (_formKey.currentState!.validate()) {
              loginAction(cubit);
            }
          },
        ),
        AppSizedBox.h1,
        AppSizedBox.h8,
      ],
    );
  }

  InkWell buildRememberMe() {
    return InkWell(
      onTap: () {
        setState(() {
          rememberMe = !rememberMe;
        });
      },
      child: Row(
        children: [
          AppSizedBox.w10,
          rememberMe
              ? Icon(
                  Icons.check_circle,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                )
              : Icon(
                  Icons.circle_outlined,
                  color: AppColors.textFieldHintColor,
                  size: 20.sp,
                ),
          AppSizedBox.w2,
          Text(
            MyApp.tr.rememberMe,
            style: AppTextStyle.getBoldStyle(color: AppColors.blackColor, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Column buildLogInHeader() {
    return Column(
      children: [
        const SizedBox(width: double.infinity),
        AppSizedBox.h12,
        Image.asset(
          AppAssets.appLogo,
          scale: .7,
        ),
        AppSizedBox.h4,
      ],
    );
  }

  Row buildLogInFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(MyApp.tr.doNotHaveAccount,
            style: AppTextStyle.getRegularStyle(
              color: AppColors.textHintColor1,
              fontSize: 13.sp,
            )),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.registerScreen);
          },
          child: Text(MyApp.tr.newAccount,
              style: AppTextStyle.getBoldStyle(
                color: AppColors.primaryColor,
                fontSize: 13.sp,
              )),
        ),
      ],
    );
  }

  Column buildLogInForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomTextField(
            action: TextInputAction.next,
            controller: emailController,
            type: TextInputType.emailAddress,
            hint: MyApp.tr.emailOrPhone,
            prefix: SvgPicture.asset(
              AppAssets.icEmail,
              color: AppColors.primaryColor,
            ),
            validator: (String? value) {
              return Validations.emailValidation(value);
            }),
        CustomTextField(
          action: TextInputAction.done,
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
          prefix: SvgPicture.asset(
            AppAssets.icPassword,
            color: AppColors.primaryColor,
          ),
          validator: (String? value) {
            return Validations.passwordValidation(value);
          },
        ),
        AppSizedBox.h1,
        TextButton(
          onPressed: () {
            // Navigator.pushNamed(context, AppRouter.verifyUserExistScreen);
          },
          child: Text(MyApp.tr.forgetPassWord,
              style: AppTextStyle.getBoldStyle(
                color: AppColors.blackColor,
                fontSize: 12.sp,
              )),
        ),
        AppSizedBox.h8,
      ],
    );
  }

  String? screenValidation(String? value) {
    bool isPhone = (Validations.isPhoneValid(value) && !Validations.isEmailValid(value));
    if (!Validations.isEmailValid(value) && !Validations.isPhoneValid(value)) {
      return MyApp.tr.emailOrPhoneValidation;
    }
    if (isPhone && value!.length != 11) {
      return MyApp.tr.emailOrPhoneValidation;
    }
    if (value!.contains(' ')) {
      return MyApp.tr.removeSpace;
    }
    return null;
  }
}
