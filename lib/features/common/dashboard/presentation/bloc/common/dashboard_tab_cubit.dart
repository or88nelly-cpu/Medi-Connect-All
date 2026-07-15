import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class DashboardTabCubit extends Cubit<int> {
  DashboardTabCubit() : super(0);

  void setTab(int index) => emit(index);
}
