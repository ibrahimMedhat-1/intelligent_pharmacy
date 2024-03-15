import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intelligent_pharmacy/user/features/doctors_list/view/doctor_details.dart';

import '../../../../../models/doctor_model.dart';

class DoctorListWidget extends StatelessWidget {
  final List<DoctorModel> doctors;

  const DoctorListWidget({required this.doctors, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => DoctorDetails(
                  doctorModel: doctors[index],
                ),
              ),
            );
          },
          child: Hero(
            tag: doctors[index].id!,
            child: AspectRatio(
              aspectRatio: 1 / 1.1,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.grey,
                    )
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        width: double.infinity,
                        imageUrl: doctors[index].image ?? '',
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctors[index].name ?? '',
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(height: 2),
                          ),
                          Text(
                            doctors[index].phoneNo ?? '',
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 2),
                          ),
                          Text(
                            doctors[index].address ?? '',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(height: 3),
                          ),
                          Text(
                            doctors[index].speciality ?? '',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(height: 3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        itemCount: doctors.length,
      ),
    );
  }
}
