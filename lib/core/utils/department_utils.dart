import 'package:flutter_screenutil/flutter_screenutil.dart';

enum Department{
  customerCare,
  marketing,
  finance,
  purchase,
  pharmacy,
  hr
  
}


Department? getDepartment(String value) {
  final text = value.toLowerCase();

  final mapping = {
    Department.customerCare: 'customer',
    Department.marketing: 'marketing',
    Department.finance: 'finance',
    Department.purchase: 'purchase',
    Department.pharmacy: 'pharmacy',
    Department.hr: 'hr',
  };

  for (final entry in mapping.entries) {
    if (text.contains(entry.value)) {
      return entry.key;
    }
  }

  return null;
}
(double padding,int crossCount) getGridInfo({required double width}){
  double screenWidth=ScreenUtil().screenWidth;
  double maxWidth=screenWidth-20.r;
  int crossCount=maxWidth~/width;
  double padding = (screenWidth - (crossCount * width)) / (crossCount + 1);
  return (padding, crossCount);

}