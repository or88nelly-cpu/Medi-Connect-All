import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/modules/patient/speciality/presentation/bloc/speciality_bloc.dart';
import 'package:medi_connect/modules/patient/speciality/presentation/widgets/speciality_horizontal_list.dart';

class SpecialityListHome extends StatefulWidget {
  const SpecialityListHome({super.key});

  @override
  State<SpecialityListHome> createState() => _SpecialityListHomeState();
}

class _SpecialityListHomeState extends State<SpecialityListHome> {
  @override
  void initState() {
    super.initState();
    context.read<SpecialityBloc>().add(LoadSpecialities());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<SpecialityBloc, SpecialityState>(
      builder: (context, state) {
        if (state is SpecialityLoading || state is SpecialityInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SpecialityError) {
          final error = state.failure.message;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF160912) : Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              children: [
                Text(
                  "Failed to load specialties $error",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      context.read<SpecialityBloc>().add(LoadSpecialities()),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        final list = state is SpecialitiesLoaded
            ? state.specialities
            : (state is SpecialityActionSuccess ? state.updatedList : []);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SpecialityHorizontalList(
            specialities: list.cast(),
            title: "Hospital Specialties",
            isAdmin: true,
          ),
        );
      },
    );
  }
}
