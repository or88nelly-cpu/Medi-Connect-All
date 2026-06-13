import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/features/dash_board/domain/entities/invoice_entity.dart';
import 'package:medi_connect/features/dash_board/domain/use_cases/admin_operations_usecases.dart';

// Events
abstract class AdminBillingEvent {}

class LoadBillingDetails extends AdminBillingEvent {}

// States
abstract class AdminBillingState {}

class AdminBillingInitial extends AdminBillingState {}

class AdminBillingLoading extends AdminBillingState {}

class AdminBillingLoaded extends AdminBillingState {
  final List<InvoiceEntity> invoices;
  final Map<String, double> summary;
  AdminBillingLoaded({required this.invoices, required this.summary});
}

class AdminBillingError extends AdminBillingState {
  final String message;
  AdminBillingError(this.message);
}

// Bloc
class AdminBillingBloc extends Bloc<AdminBillingEvent, AdminBillingState> {
  final GetInvoicesUseCase _getInvoices;
  final GetBillingSummaryUseCase _getSummary;

  AdminBillingBloc({
    required GetInvoicesUseCase getInvoices,
    required GetBillingSummaryUseCase getSummary,
  })  : _getInvoices = getInvoices,
        _getSummary = getSummary,
        super(AdminBillingInitial()) {
    on<LoadBillingDetails>(_onLoadBillingDetails);
  }

  Future<void> _onLoadBillingDetails(
      LoadBillingDetails event, Emitter<AdminBillingState> emit) async {
    emit(AdminBillingLoading());
    final invoicesResult = await _getInvoices();
    final summaryResult = await _getSummary();

    invoicesResult.fold(
      (failure) => emit(AdminBillingError(failure.message)),
      (invoices) {
        summaryResult.fold(
          (failure) => emit(AdminBillingError(failure.message)),
          (summary) => emit(AdminBillingLoaded(invoices: invoices, summary: summary)),
        );
      },
    );
  }
}
