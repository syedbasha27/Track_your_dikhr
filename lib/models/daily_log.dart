/// Represents the daily log for prayers, dhikr and character deeds
class DailyLog {
  final String date; // 'yyyy-MM-dd'
  final Map<String, bool> prayers;
  final Map<String, int> dhikr;
  final Map<String, bool> character;
  final int noorScore;

  const DailyLog({
    required this.date,
    required this.prayers,
    required this.dhikr,
    required this.character,
    required this.noorScore,
  });

  /// Default empty log for a given date
  factory DailyLog.empty(String date) => DailyLog(
        date: date,
        prayers: {
          'fajr': false,
          'dhuhr': false,
          'asr': false,
          'maghrib': false,
          'isha': false,
        },
        dhikr: {
          'subhanallah': 0,
          'astaghfirullah': 0,
          'la_ilaha': 0,
        },
        character: {
          'anger': false,
          'forgive': false,
          'help': false,
          'backbiting': false,
        },
        noorScore: 0,
      );

  factory DailyLog.fromMap(Map<String, dynamic> map) {
    return DailyLog(
      date: map['date'] as String,
      prayers: Map<String, bool>.from(map['prayers'] as Map),
      dhikr: Map<String, int>.from(
          (map['dhikr'] as Map).map((k, v) => MapEntry(k as String, (v as num).toInt()))),
      character: Map<String, bool>.from(map['character'] as Map),
      noorScore: (map['noor_score'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'date': date,
        'prayers': prayers,
        'dhikr': dhikr,
        'character': character,
        'noor_score': noorScore,
      };

  DailyLog copyWith({
    Map<String, bool>? prayers,
    Map<String, int>? dhikr,
    Map<String, bool>? character,
    int? noorScore,
  }) {
    return DailyLog(
      date: date,
      prayers: prayers ?? Map.from(this.prayers),
      dhikr: dhikr ?? Map.from(this.dhikr),
      character: character ?? Map.from(this.character),
      noorScore: noorScore ?? this.noorScore,
    );
  }
}
