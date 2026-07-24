import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/features/admin/home/data/models/admin_dashboard_module_model.dart';

/// Contract for fetching Admin Control Center module data.
abstract class AdminHomeRemoteDataSource {
  Future<List<AdminDashboardModuleModel>> getDashboardModules();
}

/// Implementation of AdminHomeRemoteDataSource delivering dynamic control center module data.
@LazySingleton(as: AdminHomeRemoteDataSource)
class AdminHomeRemoteDataSourceImpl implements AdminHomeRemoteDataSource {
  @override
  Future<List<AdminDashboardModuleModel>> getDashboardModules() async {
    // Return the 16 core Control Center modules matching the specification design
    return [
      AdminDashboardModuleModel(
        id: 'hospital',
        title: 'Hospital',
        description: 'Manage hospital details, settings and branches',
        countText: '3 Hospitals',
        iconKey: 'hospital',
        colorHex: AppColors.controlCenterBlueAccent.toARGB32(),
        accentColorHex: AppColors.controlCenterBlue.toARGB32(),
        routeName: RouteNames.adminSettings,
      ),
      AdminDashboardModuleModel(
        id: 'departments',
        title: 'Departments',
        description: 'Manage all departments in your hospital',
        countText: '24 Departments',
        iconKey: 'departments',
        colorHex: AppColors.controlCenterPurple.toARGB32(),
        accentColorHex: AppColors.controlCenterPurpleAccent.toARGB32(),
        routeName: RouteNames.departmentDetails,
      ),
      AdminDashboardModuleModel(
        id: 'specialisations',
        title: 'Specialisations',
        description: 'Manage department specialisations',
        countText: '58 Specialisations',
        iconKey: 'specialisations',
        colorHex: AppColors.controlCenterEmerald.toARGB32(),
        accentColorHex: AppColors.controlCenterEmeraldAccent.toARGB32(),
        routeName: RouteNames.specialities,
      ),
      AdminDashboardModuleModel(
        id: 'doctors',
        title: 'Doctors',
        description: 'Manage doctors and their profiles',
        countText: '86 Doctors',
        iconKey: 'doctors',
        colorHex: AppColors.controlCenterOrange.toARGB32(),
        accentColorHex: AppColors.controlCenterOrangeAccent.toARGB32(),
        routeName: '/admin/doctors',
      ),
      AdminDashboardModuleModel(
        id: 'staff',
        title: 'Staff',
        description: 'Manage all hospital staff members',
        countText: '156 Staff',
        iconKey: 'staff',
        colorHex: AppColors.controlCenterPink.toARGB32(),
        accentColorHex: AppColors.controlCenterPinkAccent.toARGB32(),
        routeName: '/staff/dashboard',
      ),
      AdminDashboardModuleModel(
        id: 'patients',
        title: 'Patients',
        description: 'Manage patient records and information',
        countText: '1,248 Patients',
        iconKey: 'patients',
        colorHex: AppColors.controlCenterCyan.toARGB32(),
        accentColorHex: AppColors.controlCenterCyanAccent.toARGB32(),
        routeName: '/patient/dashboard',
      ),
      AdminDashboardModuleModel(
        id: 'appointments',
        title: 'Appointments',
        description: 'Manage appointments and schedules',
        countText: '342 Appointments',
        iconKey: 'appointments',
        colorHex: AppColors.controlCenterBlueAccent.toARGB32(),
        accentColorHex: AppColors.controlCenterBlue.toARGB32(),
        routeName: RouteNames.appointments,
      ),
      AdminDashboardModuleModel(
        id: 'beds',
        title: 'Beds & Rooms',
        description: 'Manage beds and room availability',
        countText: '120 Beds',
        iconKey: 'beds',
        colorHex: AppColors.controlCenterViolet.toARGB32(),
        accentColorHex: AppColors.controlCenterVioletAccent.toARGB32(),
        routeName: '/admin/rooms',
      ),
      AdminDashboardModuleModel(
        id: 'billing',
        title: 'Billing',
        description: 'Manage billing, invoices and payments',
        countText: '512 Invoices',
        iconKey: 'billing',
        colorHex: AppColors.controlCenterAmber.toARGB32(),
        accentColorHex: AppColors.controlCenterAmberAccent.toARGB32(),
        routeName: RouteNames.payments,
      ),
      AdminDashboardModuleModel(
        id: 'pharmacy',
        title: 'Pharmacy',
        description: 'Manage medicines and inventory',
        countText: '1,235 Medicines',
        iconKey: 'pharmacy',
        colorHex: AppColors.controlCenterGreen.toARGB32(),
        accentColorHex: AppColors.controlCenterGreenAccent.toARGB32(),
        routeName: '/admin/pharmacy',
      ),
      AdminDashboardModuleModel(
        id: 'laboratory',
        title: 'Laboratory',
        description: 'Manage laboratories and test services',
        countText: '48 Labs',
        iconKey: 'laboratory',
        colorHex: AppColors.controlCenterRose.toARGB32(),
        accentColorHex: AppColors.controlCenterRoseAccent.toARGB32(),
        routeName: '/admin/laboratory',
      ),
      AdminDashboardModuleModel(
        id: 'equipment',
        title: 'Equipment',
        description: 'Manage medical equipment and assets',
        countText: '215 Equipment',
        iconKey: 'equipment',
        colorHex: AppColors.controlCenterSky.toARGB32(),
        accentColorHex: AppColors.controlCenterSkyAccent.toARGB32(),
        routeName: '/admin/equipment',
      ),
      AdminDashboardModuleModel(
        id: 'insurance',
        title: 'Insurance',
        description: 'Manage insurance providers and claims',
        countText: '32 Providers',
        iconKey: 'insurance',
        colorHex: AppColors.controlCenterIndigo.toARGB32(),
        accentColorHex: AppColors.controlCenterIndigoAccent.toARGB32(),
        routeName: '/admin/insurance',
      ),
      AdminDashboardModuleModel(
        id: 'ambulance',
        title: 'Ambulance',
        description: 'Manage ambulances and drivers',
        countText: '18 Ambulances',
        iconKey: 'ambulance',
        colorHex: AppColors.controlCenterAmber.toARGB32(),
        accentColorHex: AppColors.controlCenterAmberAccent.toARGB32(),
        routeName: '/admin/ambulance',
      ),
      AdminDashboardModuleModel(
        id: 'roles',
        title: 'Roles & Permissions',
        description: 'Manage roles and access permissions',
        countText: '12 Roles',
        iconKey: 'roles',
        colorHex: AppColors.controlCenterBlueAccent.toARGB32(),
        accentColorHex: AppColors.controlCenterBlue.toARGB32(),
        routeName: '/admin/roles',
      ),
      AdminDashboardModuleModel(
        id: 'settings',
        title: 'System Settings',
        description: 'Manage system settings and preferences',
        countText: 'System Settings',
        iconKey: 'settings',
        colorHex: AppColors.controlCenterGreen.toARGB32(),
        accentColorHex: AppColors.controlCenterGreenAccent.toARGB32(),
        routeName: RouteNames.adminSettings,
      ),
    ];
  }
}
