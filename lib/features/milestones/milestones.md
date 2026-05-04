# 🧠 Milestone System Design — Avatar Flow

## 📌 Overview

This module implements a **gamified milestone progression system** for users.

Each user progresses through milestones by completing tasks.
A central repository (`MilestoneRepository`) controls all logic via a single entry point.

---

# 🧱 System Architecture

## 1. 📦 Data Layer (Database)

### Tables:

#### 🟦 milestones

Defines all stages of progression.

- id
- title
- order_index
- reward

#### 🟨 tasks

Defines the requirement inside each milestone (one task per milestone).

- id
- milestone_id (FK → milestones)
- task_type (e.g. `avatar_creation`, `story_generation`, `voice_clone`, `avatar_share`)
- target_count

#### 🟩 user_task_progress

Tracks how many times a user has performed the task action.

- id
- user_id
- task_id (FK → tasks)
- current_count

#### 🟪 user_milestone_progress

Tracks milestone state per user.

- id
- user_id
- milestone_id (FK → milestones)
- is_unlocked
- is_completed

---

## 2. 🧩 Code Layer

### `MilestoneActionType` (enum)

Single source of truth for all action type strings.
Maps to the `task_type` column in Supabase.

```dart
enum MilestoneActionType {
  avatarCreation,   // 'avatar_creation'
  storyGeneration,  // 'story_generation'
  voiceClone,       // 'voice_clone'
  avatarShare,      // 'avatar_share'
}
```

### `MilestoneRepository`

Registered as a lazy singleton via `get_it`.
Single entry point: `handleAction`.

### `MilestonesProvider`

Fetches and exposes milestone data to the UI.
Auto-seeds `user_milestone_progress` on first load if no rows exist.
Exposes `currentMilestone` — the active unlocked, incomplete milestone.

---

# 👤 User Flow

## 🚀 1. User Opens Milestones Screen (or Avatar Screen)

- `MilestonesProvider.fetchMilestones()` is called
- Fetches all rows from `milestones` table
- Checks if `user_milestone_progress` rows exist for this user
- If **empty** → seeds one row per milestone, only `order_index = 1` is unlocked
- Fetches `tasks` and `user_task_progress` to build progress state

---

## 🎯 2. User Performs an Action

Actions are fired from feature providers using the service locator:

```dart
getIt<MilestoneRepository>().handleAction(
  userId: userId,
  action: MilestoneActionType.avatarCreation,
);
```

Currently wired:

- **Avatar created** → `MilestoneActionType.avatarCreation` (in `CreateAvatarProvider`)

To wire additional actions:

- **Story generated** → `MilestoneActionType.storyGeneration`
- **Voice cloned** → `MilestoneActionType.voiceClone`
- **Avatar shared** → `MilestoneActionType.avatarShare`

---

## ⚙️ 3. `handleAction` Internal Flow

```
handleAction(userId, action)
  │
  ├─ 1. _getActiveMilestone(userId)
  │      → query user_milestone_progress WHERE is_unlocked=true AND is_completed=false
  │      → joins milestones(*) to get order_index
  │
  ├─ 2. _getTask(milestoneId)
  │      → query tasks WHERE milestone_id = milestoneId
  │
  ├─ 3. Check action matches task_type → abort if mismatch
  │
  ├─ 4. _incrementTask(userId, taskId)
  │      → if no row in user_task_progress → INSERT current_count = 1
  │      → if row exists → UPDATE current_count + 1
  │
  ├─ 5. _checkMilestoneCompletion(userId, taskId, targetCount)
  │      → query user_task_progress for current_count
  │      → return current_count >= targetCount
  │
  └─ 6. If completed:
         ├─ _completeMilestone(userId, milestoneId)
         │    → UPDATE is_completed=true, is_unlocked=false
         │
         └─ _unlockNextMilestone(userId, currentOrder)
              → query milestones WHERE order_index > currentOrder LIMIT 1
              → UPDATE user_milestone_progress SET is_unlocked=true
                WHERE milestone_id = nextMilestoneId
```

---

## 🖥️ 4. UI

### Milestones Screen

- Shows all milestones as tiles with 3 states:
  - 🔒 **Locked** — grey, no progress bar
  - ▶️ **Active** — primary color, progress bar, task info
  - ✅ **Completed** — green, check badge

### Home AppBar (Shield Icon)

- Shows current milestone `order_index` (e.g. `1`, `2`, `3`)
- Tapping navigates to Milestones Screen

### Avatar Screen AppBar Milestone Tile

- Shows current milestone title and progress bar
- Uses `MilestonesProvider.currentMilestone`

---

## ⚠️ Known Requirements

- RLS must be **disabled** (or policies added) on:
  - `milestones`
  - `tasks`
  - `user_task_progress`
  - `user_milestone_progress`
- `user_milestone_progress` should have a unique constraint on `(user_id, milestone_id)` to prevent duplicate seeding
