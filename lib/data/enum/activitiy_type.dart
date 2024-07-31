enum ActivityType {
  RUN,
  WALK,
  HIKE,
  RIDE,
  SWIM,
  WORKOUT,
  HIIT,
  OTHER
}

String typeName(ActivityType type) {
  return '$type'.split('.').last;
}