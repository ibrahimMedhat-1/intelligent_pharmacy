import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligent_pharmacy/models/pharmacy_model.dart';
import 'package:intelligent_pharmacy/user/features/pharmacy_details/view/pharmacy_products.dart';
import 'package:intelligent_pharmacy/user/features/pharmacy_details/view/review_page.dart';
import 'package:intelligent_pharmacy/user/features/pharmacy_details/view/widgets/pharmacy_details_widget/bottom_more_products.dart';
import 'package:intelligent_pharmacy/user/features/pharmacy_details/view/widgets/pharmacy_details_widget/category_item.dart';
import 'package:intelligent_pharmacy/user/features/pharmacy_details/view/widgets/pharmacy_details_widget/review_item.dart';
import 'package:intelligent_pharmacy/user/features/pharmacy_details/view/widgets/pharmacy_details_widget/top_image.dart';

import '../manager/pharmacy_details_cubit/pharmacy_details_cubit.dart';

class PharmacyDetails extends StatelessWidget {
  final PharmacyModel pharmacyModel;

  const PharmacyDetails({
    super.key,
    required this.pharmacyModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PharmacyDetailsCubit(),
      child: BlocConsumer<PharmacyDetailsCubit, PharmacyDetailsState>(
        listener: (context, state) {},
        builder: (context, state) {
          final PharmacyDetailsCubit cubit = PharmacyDetailsCubit.get(context);
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(child: TopImageWidget(tag: pharmacyModel.id!, image: pharmacyModel.image!)),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pharmacyModel.name!,
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(),
                          ),
                          InkWell(
                            onTap: () {
                              cubit.callPharmacy(pharmacyModel.phoneNo!);
                            },
                            child: Text(
                              pharmacyModel.phoneNo!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          Text(
                            'Categories',
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: pharmacyModel.categories!
                                  .map((e) => CategoryItem(
                                        categoryModel: e,
                                        productsModel: pharmacyModel.products!,
                                        offers: pharmacyModel.offers!,
                                      ))
                                  .toList(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Reviews',
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      height: 1,
                                    ),
                              ),
                              MaterialButton(
                                shape: const CircleBorder(side: BorderSide(color: Colors.blueAccent)),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) => AddReviewPage(pharmacyModel: pharmacyModel)));
                                },
                              )
                            ],
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: pharmacyModel.reviews!.map((e) => ReviewItem(reviewModel: e)).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BottomWidget(
                    text: 'More Products',
                    buttonText: 'More',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (builder) => PharmacyProductsPage(pharmacyModel)),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
