import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mast/app/app_assets.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/app/app_sized_box.dart';
import 'package:mast/app/app_validation.dart';
import 'package:mast/app/di/di.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/helpers/image_helper.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/app/text_style.dart';
import 'package:mast/my_app.dart';
import 'package:mast/ui/auth/register/register_cubit.dart';
import 'package:mast/ui/componnents/custom_button.dart';
import 'package:mast/ui/componnents/custom_text_field.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class AddStoreScreen extends StatefulWidget {
  const AddStoreScreen({Key? key}) : super(key: key);

  @override
  State<AddStoreScreen> createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {
  bool showPassword = true;
  bool showConfirmPassword = true;
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var urlController = TextEditingController();
  String initialType = 'محل';
  List<String> types = ['محل', 'متجر الكتروني'];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'أضافة متجر',
          style: AppTextStyle.getBoldStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.blackColor,
          ),
          onPressed: () {
            DocumentHelper.endUploadFile();
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocProvider(
        create: (context) => getIt<RegisterCubit>(),
        child: BlocConsumer<RegisterCubit, FlowState>(
          listener: (context, state) {
            state.flowStateListener(context);
          },
          builder: (context, state) {
            var cubit = RegisterCubit.get(context);
            bool isSuccess = state is SuccessState;
            return state.flowStateBuilder(context,
                screenContent: isSuccess ? const SizedBox() : buildScreenContent(cubit), retry: () {
              // registerAction(cubit);
            });
          },
        ),
      ),
    );
  }

  // void registerAction(RegisterCubit cubit) {
  //   cubit.register(
  //     email: emailController.text,
  //     name: userNameController.text,
  //     phone: countryCode,
  //     password: passwordController.text,
  //   );
  // }

  SingleChildScrollView buildScreenContent(RegisterCubit cubit) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppSizedBox.h4,
            const SizedBox(
              width: double.infinity,
            ),
            ClipOval(
              child: CircleAvatar(
                radius: 6.3.h,
                child: DocumentHelper.pickedImage == null
                    ? Container(
                        color: Colors.yellow,
                      )
                    : Image.file(
                        DocumentHelper.pickedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
              ),
            ),
            btn1(context),
            // buildRegisterForm(cubit),
            // buildRegisterButton(cubit),
          ],
        ),
      ),
    );
  }

  Widget btn1(BuildContext context) {
    return MaterialButton(
      color: Colors.grey[300],
      minWidth: 300,
      onPressed: () => Dialogs.materialDialog(
          title: "اختر صوره المتجر",
          color: Colors.white,
          context: context,
          dialogWidth: kIsWeb ? 0.3 : null,
          onClose: (value) => print("returned value is '$value'"),
          actions: [
            IconsButton(
              onPressed: () {
                DocumentHelper.pickImage(PickImageFromEnum.camera, context)
                    .then((value) => setState(() {}));
              },
              text: "الكاميرا",
              iconData: Icons.camera_alt,
              color: Colors.yellow,
              textStyle: const TextStyle(color: Colors.black),
              iconColor: Colors.white,
            ),
            IconsButton(
              onPressed: () {
                DocumentHelper.pickImage(PickImageFromEnum.gallery, context)
                    .then((value) => setState(() {}));
              },
              text: "المعرض",
              iconData: Icons.camera,
              color: Colors.yellow,
              textStyle: const TextStyle(color: Colors.black),
              iconColor: Colors.white,
            ),
          ]),
      child: Text("اختر صورة "),
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
              // registerAction(cubit);
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
          AppSizedBox.h4,
        ],
      ),
    );
  }

  Column buildRegisterForm(RegisterCubit cubit) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //username
        CustomTextField(
          action: TextInputAction.next,
          type: TextInputType.text,
          controller: titleController,
          hint: "اسم المتجر",
          validator: (String? value) {
            return Validations.userNameValidation(value);
          },
        ),
        //email
        CustomTextField(
          type: TextInputType.emailAddress,
          action: TextInputAction.next,
          max: 5,
          min: 3,
          controller: descriptionController,
          hint: "الوصف",
          validator: (String? value) {
            return Validations.emailValidation(value);
          },
        ),
        CustomTextField(
          type: TextInputType.url,
          action: TextInputAction.next,
          controller: urlController,
          hint: 'رابط المتجر',
          validator: (String? value) {
            return Validations.emailValidation(value);
          },
        ),
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
