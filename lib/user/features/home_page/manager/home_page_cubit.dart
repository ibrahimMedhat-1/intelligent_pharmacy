import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligent_pharmacy/models/category_model.dart';
import 'package:intelligent_pharmacy/models/offers_model.dart';
import 'package:intelligent_pharmacy/models/product_model.dart';
import 'package:intelligent_pharmacy/models/review_model.dart';
import 'package:intelligent_pharmacy/shared/toast.dart';

import '../../../../models/pharmacy_model.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(HomePageInitial());

  static HomePageCubit get(context) => BlocProvider.of(context);
  List<PharmacyModel> pharmacies = [];
  List<PharmacyModel> searchPharmacyList = [];
  TextEditingController searchPharmacyController = TextEditingController();
  void getAllPharmacies() async {
    if (pharmacies.isEmpty) {
      emit(GetPharmacyLoading());
      await FirebaseFirestore.instance
          .collection('pharmacies')
          .orderBy('creationDate')
          .get()
          .then((value) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> element in value.docs) {
          List<ReviewModel> reviews = [];
          List<ProductsModel> products = [];
          List<CategoryModel> categories = [];
          List<OffersModel> offers = [];
          for (var category in element.data()['categories']) {
            categories.add(CategoryModel.fromJson(category));
          }
          element.reference.collection('reviews').get().then((value) {
            for (var element in value.docs) {
              reviews.add(ReviewModel.fromJson(element.data()));
            }
          });
          element.reference.collection('products').get().then((value) {
            for (var element in value.docs) {
              products.add(ProductsModel.fromJson(element.data()));
            }
          });
          element.reference.collection('offers').get().then((value) {
            for (var element in value.docs) {
              offers.add(OffersModel.fromJson(element.data()));
            }
          });
          pharmacies.add(PharmacyModel.fromJson(
            json: element.data(),
            reviews: reviews,
            categories: categories,
            products: products,
            offers: offers,
          ));
          emit(GetPharmacySuccessfully());
        }
      }).catchError((onError) {
        emit(GetPharmacyError());
        showToast(onError.message);
      });
    }
  }

  void searchPharmacies(String value) {
    searchPharmacyList = [];
    for (PharmacyModel pharmacy in pharmacies) {
      if (pharmacy.name!.toLowerCase().contains(value.toLowerCase())) {
        searchPharmacyList.add(pharmacy);
      }
    }
    emit(IsSearchingInMedicineInCategory());
  }

  void isSearching(bool isSearching) {
    if (isSearching) {
      emit(IsSearchingInMedicineInCategory());
    } else {
      searchPharmacyList = [];
      emit(IsNotSearchingInMedicineInCategory());
    }
  }
}
