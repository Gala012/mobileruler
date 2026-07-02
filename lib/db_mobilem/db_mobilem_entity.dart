class AppSettingsEntity {
  final int id;
  final bool hasSeenGuide;
  final String defaultLengthUnit;
  final String defaultAreaUnit;
  final double calibrationFactor;
  final String calibrationRefType;
  final String? calibratedAt;

  const AppSettingsEntity({
    this.id = 1,
    this.hasSeenGuide = false,
    this.defaultLengthUnit = 'cm',
    this.defaultAreaUnit = 'cm2',
    this.calibrationFactor = 0,
    this.calibrationRefType = '',
    this.calibratedAt,
  });

  bool get isManuallyCalibrated => calibrationFactor > 0;

  AppSettingsEntity copyWith({
    bool? hasSeenGuide,
    String? defaultLengthUnit,
    String? defaultAreaUnit,
    double? calibrationFactor,
    String? calibrationRefType,
    String? calibratedAt,
  }) {
    return AppSettingsEntity(
      id: id,
      hasSeenGuide: hasSeenGuide ?? this.hasSeenGuide,
      defaultLengthUnit: defaultLengthUnit ?? this.defaultLengthUnit,
      defaultAreaUnit: defaultAreaUnit ?? this.defaultAreaUnit,
      calibrationFactor: calibrationFactor ?? this.calibrationFactor,
      calibrationRefType: calibrationRefType ?? this.calibrationRefType,
      calibratedAt: calibratedAt ?? this.calibratedAt,
    );
  }

  factory AppSettingsEntity.fromMap(Map<String, dynamic> map) {
    return AppSettingsEntity(
      id: map['id'] as int? ?? 1,
      hasSeenGuide: (map['has_seen_guide'] as int? ?? 0) == 1,
      defaultLengthUnit: map['default_length_unit'] as String? ?? 'cm',
      defaultAreaUnit: map['default_area_unit'] as String? ?? 'cm2',
      calibrationFactor: (map['calibration_factor'] as num?)?.toDouble() ?? 0,
      calibrationRefType: map['calibration_ref_type'] as String? ?? '',
      calibratedAt: map['calibrated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'has_seen_guide': hasSeenGuide ? 1 : 0,
      'default_length_unit': defaultLengthUnit,
      'default_area_unit': defaultAreaUnit,
      'calibration_factor': calibrationFactor,
      'calibration_ref_type': calibrationRefType,
      'calibrated_at': calibratedAt,
    };
  }
}

class MeasurementRecordEntity {
  final int? id;
  final String toolType;
  final double value;
  final String unit;
  final String extraJson;
  final String note;
  final String createdAt;

  const MeasurementRecordEntity({
    this.id,
    required this.toolType,
    required this.value,
    required this.unit,
    this.extraJson = '{}',
    this.note = '',
    required this.createdAt,
  });

  factory MeasurementRecordEntity.fromMap(Map<String, dynamic> map) {
    return MeasurementRecordEntity(
      id: map['id'] as int?,
      toolType: map['tool_type'] as String,
      value: (map['value'] as num).toDouble(),
      unit: map['unit'] as String,
      extraJson: map['extra_json'] as String? ?? '{}',
      note: map['note'] as String? ?? '',
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'tool_type': toolType,
      'value': value,
      'unit': unit,
      'extra_json': extraJson,
      'note': note,
      'created_at': createdAt,
    };
  }
}

class UsageStatEntity {
  final int? id;
  final String toolType;
  final int useCount;
  final String? lastUsedAt;

  const UsageStatEntity({
    this.id,
    required this.toolType,
    required this.useCount,
    this.lastUsedAt,
  });

  factory UsageStatEntity.fromMap(Map<String, dynamic> map) {
    return UsageStatEntity(
      id: map['id'] as int?,
      toolType: map['tool_type'] as String,
      useCount: map['use_count'] as int? ?? 0,
      lastUsedAt: map['last_used_at'] as String?,
    );
  }
}

class AchievementBadgeEntity {
  final int? id;
  final String badgeKey;
  final String unlockedAt;

  const AchievementBadgeEntity({
    this.id,
    required this.badgeKey,
    required this.unlockedAt,
  });

  factory AchievementBadgeEntity.fromMap(Map<String, dynamic> map) {
    return AchievementBadgeEntity(
      id: map['id'] as int?,
      badgeKey: map['badge_key'] as String,
      unlockedAt: map['unlocked_at'] as String,
    );
  }
}
