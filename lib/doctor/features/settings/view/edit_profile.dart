import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligent_pharmacy/doctor/features/settings/manager/doctor_edit_profile_cubit.dart';

import '../../../../shared/utils/constants.dart';

class DoctorEditProfile extends StatelessWidget {
  const DoctorEditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorEditProfileCubit()..initialize(),
      child: BlocConsumer<DoctorEditProfileCubit, DoctorEditProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          final DoctorEditProfileCubit cubit = DoctorEditProfileCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            cubit.changeImage(context);
                          },
                          child: CircleAvatar(
                            radius: 80,
                            foregroundImage: cubit.imageFile != null
                                ? FileImage(cubit.imageFile!)
                                : NetworkImage('https:${Constants.doctorModel!.image ?? ''}')
                                    as ImageProvider,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'name'),
                          controller: cubit.nameController,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'phone'),
                          keyboardType: TextInputType.phone,
                          controller: cubit.phoneController,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Address'),
                          controller: cubit.addressController,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text('Speciality'),
                            Expanded(
                              child: DropdownButton(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  value: cubit.specialityValue,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'other',
                                      child: Text('other'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Bones',
                                      child: Text('Bones'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'General',
                                      child: Text('General'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Dentist',
                                      child: Text('Dentist'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    cubit.changeSpeciality(value);
                                  }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'bio'),
                          controller: cubit.bioController,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                MaterialButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: const Text('Save'),
                  onPressed: () {
                    cubit.saveData(context);
                  },
                ),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
