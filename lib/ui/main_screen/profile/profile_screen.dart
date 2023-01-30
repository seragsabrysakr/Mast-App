import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mast/app/app_assets.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/app/app_router.dart';
import 'package:mast/app/app_validation.dart';
import 'package:mast/app/constants.dart';
import 'package:mast/app/di/di.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/app/text_style.dart';
import 'package:mast/data/storage/local/app_prefs.dart';
import 'package:mast/my_app.dart';
import 'package:mast/ui/componnents/custom_button.dart';
import 'package:mast/ui/componnents/custom_text_field.dart';
import 'package:mast/ui/main_screen/main_screen.dart';
import 'package:mast/ui/main_screen/profile/country.dart';
import 'package:mast/ui/main_screen/profile/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String id = 'Profile screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'صباح الخير';
    }
    if (hour < 17) {
      return 'مساء الخير';
    }
    return 'مساء الخير';
  }

  var userModel = getIt<AppPreferences>().userDataModel;
  bool isLogIn = getIt<AppPreferences>().isUserLogin;
  bool showPassword = true;
  bool showConfirmPassword = true;
  var nameController =
      TextEditingController(text: getIt<AppPreferences>().userDataModel?.name);
  var emailController =
      TextEditingController(text: getIt<AppPreferences>().userDataModel?.email);
  var phoneController = TextEditingController();
  var passController = TextEditingController(text: '');
  var confirmPassController = TextEditingController(text: '');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var countryCode = '';
  var initialCode = '';

  @override
  void initState() {
    CountryCode? myCountry = Countries.getCountryCodeAndPhone(
        getIt<AppPreferences>().userDataModel?.phone ?? '');
    initialCode = myCountry?.code.toString() ?? Constants.initialCountry;
    phoneController =
        TextEditingController(text: myCountry?.splitPhone.toString() ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildScreenBody();
  }

  buildPhoneTextField() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 2.h),
        child: IntlPhoneField(
          controller: phoneController,
          showDropdownIcon: false,
          enabled: false,
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

  BlocProvider<ProfileCubit> buildScreenBody() {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: BlocConsumer<ProfileCubit, FlowState>(
        listener: (context, state) {
          state.flowStateListener(context);

          if (state is SuccessState) {
            var cubit = ProfileCubit.get(context);
            userModel = cubit.user;
            var userM = cubit.user;
            getIt<AppPreferences>().userDataModel = userModel;
          }
        },
        builder: (context, state) {
          ProfileCubit profileCubit = ProfileCubit.get(context);
          return state.flowStateBuilder(context,
              screenContent: !isLogIn
                  ? buildNoUserView()
                  : buildScreenContent(profileCubit, context), retry: () {
            profileCubit.updateProfile(
              nameController.text,
              countryCode.isEmpty ? userModel?.phone ?? '' : countryCode,
              emailController.text,
            );
          });
        },
      ),
    );
  }

  SingleChildScrollView buildScreenContent(
      ProfileCubit profileCubit, BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 8.h),
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _profileHeader(),
              _profileForm(),
              _profileFooter(profileCubit, context),
            ],
          ),
        ),
      ),
    );
  }

  buildNoUserView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.appLogo,
            width: 100.w,
            height: 30.h,
            scale: .3,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            'لا يوجد حساب مسجل',
            style: AppTextStyle.getRegularStyle(
                color: AppColors.primaryColor, fontSize: 15.sp),
          ),
          TextButton(
            onPressed: () {
              navigateTo( AppRouter.loginScreen);
            },
            child: Text(
              'تسجيل الدخول',
              style: AppTextStyle.getRegularStyle(
                  color: Colors.black, fontSize: 15.sp),
            ),
          ),
        ],
      ),
    );
  }

  _profileHeader() {
    String? text =
        userModel?.name?.length != 1 ? userModel?.name?.substring(0, 1) : '';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 4.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            children: [
              SizedBox(
                width: 5.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(greeting(),
                      style: AppTextStyle.getRegularStyle(
                          color: AppColors.textFieldHintColor,
                          fontSize: 12.sp)),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
      ],
    );
  }

  _profileForm() {
    return Column(
      children: [
        CustomTextField(
            width: 80.w,
            controller: nameController,
            type: TextInputType.name,
            action: TextInputAction.next,
            radius: 30,
            hint: MyApp.tr.userName,
            validator: (String? value) {
              return Validations.userNameValidation(value);
            }),
        CustomTextField(
            width: 80.w,
            controller: emailController,
            type: TextInputType.emailAddress,
            action: TextInputAction.next,
            radius: 30,
            hint: MyApp.tr.email,
            validator: (String? value) {
              return Validations.emailValidation(value);
            }),
        buildPhoneTextField(),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }
  void navigateTo(String route, {Object? arguments}) {
    WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(MainScreen.mainContext,)
        .pushNamedAndRemoveUntil(
        route, arguments: arguments, (Route<dynamic> route) => false));
  }
  _profileFooter(ProfileCubit profileCubit, BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 2.h,
        ),
        CustomButton(
          height: 6,
          width: 80,
          butcolor: AppColors.primaryColor,
          fontweight: FontWeight.w400,
          txtcolor: Colors.black,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            // ProfileCubit.get(context).updateProfile(
            //   nameController.text,
            //   countryCode.isEmpty ? userModel?.phone ?? '' : countryCode,
            //   emailController.text,
            // );
          },
          fontsize: 12.sp,
          text: MyApp.tr.save,
        ),
        SizedBox(
          height: 4.h,
        ),
      ],
    );
  }
}
