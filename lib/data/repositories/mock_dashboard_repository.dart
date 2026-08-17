import '../models/analyst.dart';
import '../models/dashboard_data.dart';
import '../models/priority_alert.dart';
import '../models/risk_hotspot.dart';
import '../models/risk_level.dart';
import '../models/spread_row.dart';
import '../models/stat_item.dart';
import 'dashboard_repository.dart';

/// Placeholder data source used until a real backend/AI model is wired
/// up. Replace with an implementation that fetches live data — the
/// screen doesn't need to change at all.
class MockDashboardRepository implements DashboardRepository {
  @override
  Future<DashboardData> fetchDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return const DashboardData(
      title: 'Hyacinth monitoring & forecasting',
      subtitle: 'Early detection, risk prioritization & spread forecasting',
      lastUpdateLabel: '2 hours ago',
      analyst: Analyst(
        name: 'Dr. Sarah',
        role: 'Senior Analyst',
        avatarUrl: 'https://www.figma.com/api/mcp/asset/6e87c441-340b-4422-82e0-6521fd0e9e87.png',
      ),
      stats: [
        StatItem(type: StatType.monitoredSegments, label: 'MONITORED SEGMENTS', value: '126'),
        StatItem(type: StatType.activeAlerts, label: 'ACTIVE ALERTS', value: '23'),
        StatItem(type: StatType.coverageDetected, label: 'COVERAGE DETECTED', value: '18.4%'),
        StatItem(type: StatType.forecastAccuracy, label: 'FORECAST ACCURACY', value: '97.5%'),
      ],
      mapImageUrl: 'https://www.figma.com/api/mcp/asset/86791900-061a-49c3-8818-989a817b8261.png',
      hotspots: [
        RiskHotspot(label: 'Al-Mahmoudiyah (Critical)', level: RiskLevel.critical, dx: 0.18, dy: 0.23),
        RiskHotspot(label: 'Rayah El-Behery (High)', level: RiskLevel.high, dx: 0.51, dy: 0.43),
        RiskHotspot(label: 'Rosetta Branch (Low)', level: RiskLevel.low, dx: 0.30, dy: 0.63),
      ],
      priorityAlerts: [
        PriorityAlert(name: 'Bahr Shebin', subtitle: 'Delta Basin waterway segment', level: RiskLevel.critical, percentLabel: '34%'),
        PriorityAlert(name: 'El-Behiry', subtitle: 'Delta Basin waterway segment', level: RiskLevel.high, percentLabel: '34%'),
        PriorityAlert(name: 'Tanta Canal', subtitle: 'Delta Basin waterway segment', level: RiskLevel.moderate, percentLabel: '34%'),
        PriorityAlert(name: 'Al-Mahmoudya', subtitle: 'Delta Basin waterway segment', level: RiskLevel.critical, percentLabel: '34%'),
        PriorityAlert(name: 'Nasser Canal', subtitle: 'Delta Basin waterway segment', level: RiskLevel.critical, percentLabel: '34%'),
      ],
      spreadRows: [
        SpreadRow(area: 'Nile delta main', segmentId: 'EG-842', level: RiskLevel.critical, growthRateLabel: '+4.8%/week', criticalInLabel: '9 days', coverageFraction: 0.64),
        SpreadRow(area: 'Menoufia Canal', segmentId: 'EG-841', level: RiskLevel.moderate, growthRateLabel: '+4.8%/week', criticalInLabel: '9 days', coverageFraction: 0.64),
        SpreadRow(area: 'Ismailia Canal', segmentId: 'EG-678', level: RiskLevel.high, growthRateLabel: '+4.8%/week', criticalInLabel: '9 days', coverageFraction: 0.64),
      ],
    );
  }
}
