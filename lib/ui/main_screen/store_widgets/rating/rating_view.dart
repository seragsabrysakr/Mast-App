import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mast/app/app_colors.dart';
import 'package:mast/app/app_sized_box.dart';
import 'package:mast/app/di/di.dart';
import 'package:mast/app/extensions.dart';
import 'package:mast/app/state_renderer/request_builder.dart';
import 'package:mast/app/state_renderer/state_renderer_impl.dart';
import 'package:mast/app/text_style.dart';
import 'package:mast/data/model/home/store_model.dart';
import 'package:mast/ui/componnents/custom_button.dart';
import 'package:mast/ui/componnents/custom_text_field.dart';
import 'package:mast/ui/main_screen/store_widgets/rating/rating_cubit.dart';

class AddProductReviewScreen extends StatefulWidget {
  final StoreModel store;
  const AddProductReviewScreen({Key? key, required this.store}) : super(key: key);

  @override
  State<AddProductReviewScreen> createState() => _AddProductReviewScreenState();
}

class _AddProductReviewScreenState extends State<AddProductReviewScreen> {
  var rating = 0.0;
  TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.store.title ?? '',
          style: AppTextStyle.getBoldStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.blackColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: BlocProvider(
              create: (context) => getIt<RatingCubit>(),
              child: RequestBuilder<RatingCubit>(
                retry: (context, cubit) {},
                listener: (context, cubit) {
                  if (cubit.state is SuccessState) {
                    Navigator.pop(context);
                  }
                },
                contentBuilder: (context, cubit) {
                  return buildScreenContent(context, cubit);
                },
              )),
        ),
      ),
    );
  }

  Column buildScreenContent(BuildContext context, RatingCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: double.infinity,
        ),
        AppSizedBox.h6,
        Text(
          'تقييم المتجر',
          style: AppTextStyle.getRegularStyle(
            color: AppColors.blackColor,
            fontSize: 20.sp,
          ),
        ),
        AppSizedBox.h2,
        Text(
          'من فضلك قم بتقييم المتجر',
          style: AppTextStyle.getRegularStyle(
            color: AppColors.blackColor,
            fontSize: 12.sp,
          ),
        ),
        Text(
          'بواسطة النجوم أدناه',
          style: AppTextStyle.getRegularStyle(
            color: AppColors.blackColor,
            fontSize: 12.sp,
          ),
        ),
        AppSizedBox.h2,
        RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          unratedColor: Colors.grey.shade200,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.orange,
          ),
          onRatingUpdate: (value) {
            setState(() {
              rating = value;
            });
            print(rating);
          },
        ),
        AppSizedBox.h1,
        CustomTextField(
            controller: controller,
            max: 8,
            min: 8,
            radius: 2,
            hint: 'الرجاء اضافة المحتوي ',
            validator: (String? value) {
              if (value == null && value!.isEmpty) {
                return 'الرجاء اضافة المحتوي ';
              }
            }),
        AppSizedBox.h1,
        CustomButton(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              cubit.addRating(
                  comment: controller.text,
                  shopRating: rating.toString(),
                  shopId: widget.store.id.toString());
            }
          },
          fontsize: 13.sp,
          radius: .5,
          butcolor: AppColors.primaryColor,
          txtcolor: Colors.white,
          fontweight: FontWeight.w500,
          text: 'إرسال',
          height: 6,
          width: 80,
        ),
      ],
    );
  }
}
