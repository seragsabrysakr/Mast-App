import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:mast/ui/componnents/custom_button.dart';
import 'package:mast/ui/componnents/custom_text_field.dart';
import 'package:mast/ui/main_screen/store_widgets/add_store/add_store_cubit.dart';
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
  String initialType = '1';
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
        create: (context) => getIt<AddStoresCubit>(),
        child: BlocConsumer<AddStoresCubit, FlowState>(
          listener: (context, state) {
            bool isSuccess = state is SuccessState;
            if (isSuccess) {
              Navigator.pop(context);
            }
            state.flowStateListener(context);
          },
          builder: (context, state) {
            var cubit = AddStoresCubit.get(context);
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

  SingleChildScrollView buildScreenContent(AddStoresCubit cubit) {
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
            AppSizedBox.h4,
            buildRegisterForm(cubit),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                    height: 6.3,
                    width: 30,
                    text: 'محل',
                    onTap: () {
                      setState(() {
                        initialType = '1';
                      });
                    },
                    txtcolor: initialType == '1' ? Colors.black : Colors.white,
                    borderColor: initialType == '1' ? Colors.yellow : Colors.grey,
                    butcolor: initialType == '1' ? Colors.yellow : Colors.grey),
                CustomButton(
                    height: 6.3,
                    width: 30,
                    text: 'متجر الكتروني',
                    onTap: () {
                      setState(() {
                        initialType = '2';
                      });
                    },
                    txtcolor: initialType == '2' ? Colors.black : Colors.white,
                    borderColor: initialType == '2' ? Colors.yellow : Colors.grey,
                    butcolor: initialType == '2' ? Colors.yellow : Colors.grey),
              ],
            ),
            buildRegisterButton(cubit),
          ],
        ),
      ),
    );
  }

  Widget btn1(BuildContext context) {
    return MaterialButton(
      color: Colors.grey[300],
      minWidth: 40.w,
      onPressed: () => Dialogs.materialDialog(
          title: "اختر صوره المتجر",
          color: Colors.white,
          context: context,
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

  Column buildRegisterButton(AddStoresCubit cubit) {
    return Column(
      children: [
        AppSizedBox.h4,
        CustomButton(
          text: 'تأكيد',
          fontsize: 14.sp,
          txtcolor: Colors.black,
          onTap: () {
            if (DocumentHelper.pickedImage == null) {
              showErrorToast(context);
            } else {
              if (_formKey.currentState!.validate()) {
                cubit.addStores(
                    image: DocumentHelper.pickedImage!,
                    title: titleController.text,
                    description: descriptionController.text,
                    url: urlController.text,
                    type: initialType);
              }
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

  Column buildRegisterForm(AddStoresCubit cubit) {
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
          radius: 4,
          validator: (String? value) {
            return Validations.descriptionValidation(value);
          },
        ),
        CustomTextField(
          type: TextInputType.url,
          action: TextInputAction.next,
          controller: urlController,
          hint: 'رابط المتجر',
          validator: (String? value) {
            return Validations.urlValidation(value ?? '');
          },
        ),
      ],
    );
  }

  showErrorToast(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => popDialog(
        context: context,
        title: MyApp.tr.error,
        content: 'يرجي اختيار صورة المتجر',
        boxColor: AppColors.errorColor));
  }
}
