# 🧠 Milestone System Design — Avatar Flow

## 📌 Overview

This module implements a **gamified milestone progression system** for users.

Each user progresses through milestones by completing tasks.  
A central service (“Milestone Brain”) controls all logic.

---

# 🧱 System Architecture

The system is divided into 3 layers:

## 1. 📦 Data Layer (Database)

### Tables:

#### 🟦 milestones

Defines all stages of progression.

- id
- title
- order_index
- reward

---

#### 🟨 tasks

Defines requirements inside each milestone.

- id
- milestone_id (FK)
- task_type (e.g. avatar_creation, story_generation)
- target_count

---

#### 🟩 user_task_progress

Tracks user actions per task.

- id
- user_id
- task_id
- current_count

---

#### 🟪 user_milestone_progress

Tracks milestone state per user.

- id
- user_id
- milestone_id
- is_unlocked
- is_completed

---

# 👤 User Flow

## 🚀 1. User Signup

When a user creates an account:

- Milestones are initialized for the user
- Only **Milestone 1 is unlocked**
- All progress starts at **0**

---

## 🎯 2. User Performs Action

Example actions:

- Create avatar
- Generate story
- Use voice feature

These actions are NOT tied to UI logic.

They are passed to the system as events:

```text
"user_created_story"
```
