import 'package:flutter/material.dart';
import 'package:intelligent_pharmacy/user/features/pharmacy_details/view/widgets/pharmacy_details_widget/bottom_more_products.dart';
import 'package:intelligent_pharmacy/user/features/pharmacy_details/view/widgets/pharmacy_details_widget/top_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/doctor_model.dart';
import 'doctor_chat_page.dart';

class DoctorDetails extends StatelessWidget {
  final DoctorModel doctorModel;

  const DoctorDetails({super.key, required this.doctorModel});

  @override
  Widget build(BuildContext context) {
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
            SafeArea(child: TopImageWidget(tag: doctorModel.id!, image: doctorModel.image ?? '')),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorModel.name ?? '',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    InkWell(
                      onTap: () async {
                        await launchUrl(Uri.parse('tel://${doctorModel.phoneNo}'));
                      },
                      child: Text(
                        doctorModel.phoneNo ?? '',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Text(
                      'Address',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(),
                    ),
                    InkWell(
                      onTap: () async {
                        launchUrl(
                          Uri.parse(
                              'https://www.google.com/maps/search/?api=1&query=${doctorModel.addressLatitude!},${doctorModel.addressLongitude!}'),
                        );
                      },
                      child: Text(
                        doctorModel.address ?? '',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Text(
                      'Speciality',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(),
                    ),
                    Text(
                      doctorModel.speciality ?? '',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'Bio',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            height: 2,
                          ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                              child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              doctorModel.bio ?? '',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          )),
                        );
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width - 40,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 0),
                                blurRadius: 3,
                              ),
                            ]),
                        child: Text(doctorModel.bio ?? ''),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomWidget(
              text: 'Let\'s Chat',
              buttonText: 'Chat Now',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => DoctorChatPage(
                            doctorModel: doctorModel,
                          )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
