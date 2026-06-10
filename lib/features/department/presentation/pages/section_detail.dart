import 'package:flutter/material.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/features/department/data/models/department_model.dart';

class SectionDetail extends StatelessWidget {
  const SectionDetail({super.key, required this.section});
  final DepartmentModel section;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      customAppbar: CommonAppBar(
        title: section.name,
        
      ),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}
