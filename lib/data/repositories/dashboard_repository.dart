import '../models/dashboard_data.dart';

/// Contract for anything that can supply dashboard data.
///
/// To plug in a real backend or an AI model later, write a new class
/// that implements this interface (e.g. `AiDashboardRepository`),
/// have it call your API/model and parse the response into
/// [DashboardData] (using `DashboardData.fromJson` if it returns JSON),
/// then swap the single line in `main.dart` that constructs the
/// repository. Nothing in the UI layer needs to change.
abstract class DashboardRepository {
  Future<DashboardData> fetchDashboardData();
}
