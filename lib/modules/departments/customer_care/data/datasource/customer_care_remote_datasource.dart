abstract class CustomerCareRemoteDataSource {
  Future<Map<String, dynamic>> getCustomerCareStats();
}

class CustomerCareRemoteDataSourceImpl implements CustomerCareRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getCustomerCareStats() async {
    return {
      'active_tickets': 18,
      'avg_response_time_mins': 8,
      'patient_satisfaction_pct': 94.5,
      'calls_received_today': 150,

      // Redesigned Dashboard Stats
      'total_registrations': 1245,
      'total_registrations_trend': '+18.2% vs last 17 days',
      'total_appointments': 986,
      'total_appointments_trend': '+14.7% vs last 17 days',
      'total_admissions': 156,
      'total_admissions_trend': '+9.5% vs last 17 days',
      'feedback_score': 4.7,
      'feedback_score_trend': '+0.4 vs last 17 days',

      'walk_in_patients': 632,
      'walk_in_patients_trend': '+12.6%',
      'follow_up_visits': 413,
      'follow_up_visits_trend': '+8.4%',
      'avg_waiting_time': 18,
      'avg_waiting_time_trend': '-3 mins',
      'enquiries_handled': 286,
      'enquiries_handled_trend': '+9.7%',

      // Chart Trends
      'registrations_trend_data': [
        120.0,
        132.0,
        145.0,
        160.0,
        172.0,
        153.0,
        163.0,
        200.0,
        140.0,
      ],
      'appointments_trend_data': [
        80.0,
        95.0,
        110.0,
        105.0,
        120.0,
        115.0,
        130.0,
        150.0,
        86.0,
      ],

      // Feedback distribution
      'feedback_excellent_pct': 72.0,
      'feedback_excellent_count': 896,
      'feedback_good_pct': 18.0,
      'feedback_good_count': 224,
      'feedback_average_pct': 7.0,
      'feedback_average_count': 87,
      'feedback_poor_pct': 3.0,
      'feedback_poor_count': 38,
      'feedback_total': 1245,

      // Specialities distribution
      'specialities_data': {
        'General Medicine': 320.0,
        'Orthopedics': 210.0,
        'Pediatrics': 180.0,
        'Dermatology': 150.0,
        'ENT': 120.0,
        'Cardiology': 90.0,
        'Others': 60.0,
      },

      // Dynamic Recent Activities
      'recent_activities': [
        {'message': 'New patient registered', 'time': '10 mins ago'},
        {'message': 'Doctor added successfully', 'time': '1 hour ago'},
        {'message': 'Department updated', 'time': '2 hours ago'},
        {'message': 'User role changed', 'time': '10:30 AM'},
        {'message': 'Billing configuration updated', 'time': '08:15 AM'},
        {'message': 'System backup completed', 'time': '07:30 AM'},
      ],
    };
  }
}
