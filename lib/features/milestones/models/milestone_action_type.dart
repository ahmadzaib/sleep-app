enum MilestoneActionType {
  avatarCreation,
  storyGeneration,
  voiceClone,
  avatarShare;

  /// The string value stored in the `task_type` column in Supabase
  String get value {
    switch (this) {
      case MilestoneActionType.avatarCreation:
        return 'avatar_creation';
      case MilestoneActionType.storyGeneration:
        return 'story_generation';
      case MilestoneActionType.voiceClone:
        return 'voice_clone';
      case MilestoneActionType.avatarShare:
        return 'avatar_share';
    }
  }
}
