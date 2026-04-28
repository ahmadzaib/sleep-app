import 'dart:async';
import 'dart:io';

import 'package:avatar_flow/core/config/appconfig.dart';
import 'package:avatar_flow/core/constants/db_constants.dart';
import 'package:avatar_flow/core/debug/debug_point.dart';
import 'package:avatar_flow/core/dio/dio_client.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/services/background_removal_service.dart';
import 'package:avatar_flow/core/services/storage_service.dart';
import 'package:avatar_flow/core/utils/toast_utils.dart';
import 'package:avatar_flow/features/avatar/models/avatar_model.dart';
import 'package:avatar_flow/features/avatar/models/trait_model.dart';
import 'package:avatar_flow/features/avatar/providers/avatars_provider.dart';
import 'package:avatar_flow/features/avatar/repo/avatar_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class CreateAvatarProvider extends ChangeNotifier {
  final AvatarRepo _avatarRepo = AvatarRepo();
  final BackgroundRemovalService _backgroundRemovalService =
      BackgroundRemovalService(DioClient());

  // -------------------------
  // Avatar fields
  // -------------------------
  int currentIndex = 0;
  String avatarName = "Lilian";
  String selectedGender = "Female";
  List<TraitModel> traits = [
    TraitModel(id: 1, name: "Adventurous"),
    TraitModel(id: 2, name: "Charismatic"),
  ];
  String selectedVoice = "Voice 1";
  String prompt = "";
  String? _avatarImagePath; // Local file path for preview
  String? get avatarImagePath => _avatarImagePath;
  String? _avatarImageUrl; // Supabase Storage public URL
  String? get avatarImageUrl => _avatarImageUrl;
  bool _isCreating = false;
  bool _isPreparingPreview = false;

  bool get isCreating => _isCreating;
  bool get isPreparingPreview => _isPreparingPreview;

  void setAvatarImagePath(String? path, {String? url}) {
    _avatarImagePath = path;
    _avatarImageUrl = url;
    DebugPoint.log('Avatar image set - path: $path, url: $url');
    notifyListeners();
  }

  // -------------------------
  // Voice clone - step/page control
  // -------------------------
  final PageController voicePageController = PageController();
  int currentVoiceStep = 0;
  static const int totalVoiceSteps = 3;
  bool isAgreed = false;

  // -------------------------
  // Voice source selection
  // -------------------------
  static const String defaultVoiceId = 'default_voice';
  static const String defaultVoiceName = 'Default Voice';

  String? _selectedSampleVoiceId;
  String? get selectedSampleVoiceId => _selectedSampleVoiceId;

  bool get hasRecordedVoice => audioPath != null;
  bool get hasSampleVoice => _selectedSampleVoiceId != null;
  bool get isUsingDefaultVoice => !hasRecordedVoice && !hasSampleVoice;

  String get effectiveVoiceName {
    if (hasRecordedVoice) return voiceName.isNotEmpty ? voiceName : 'My Voice';
    if (hasSampleVoice) return _selectedSampleVoiceId!;
    return defaultVoiceName;
  }

  // -------------------------
  // Voice recording state
  // -------------------------
  bool isRecording = false;
  String? audioPath;
  String? transcript;
  Duration? voiceDuration;
  Duration recordingElapsed = Duration.zero;
  String voiceName = '';

  /// Select a sample voice (clears recorded voice)
  void selectSampleVoice(String voiceId) {
    _selectedSampleVoiceId = voiceId;
    // Clear recorded voice when sample is selected
    audioPath = null;
    voiceName = '';
    notifyListeners();
  }

  /// Clear sample voice selection
  void clearSampleVoice() {
    _selectedSampleVoiceId = null;
    notifyListeners();
  }

  /// Set recorded voice (clears sample selection)
  void setRecordedVoice(String path, {String? name}) {
    audioPath = path;
    if (name != null) voiceName = name;
    // Clear sample when recording is set
    _selectedSampleVoiceId = null;
    notifyListeners();
  }

  /// Use default voice (clears both)
  void useDefaultVoice() {
    audioPath = null;
    voiceName = '';
    _selectedSampleVoiceId = null;
    notifyListeners();
  }

  // -------------------------
  // Edit mode
  // -------------------------
  int? _editingAvatarId;
  int? get editingAvatarId => _editingAvatarId;
  bool get isEditMode => _editingAvatarId != null;

  /// Load an existing avatar's data into all fields for editing
  void loadAvatarForEdit(AvatarModel avatar) {
    _editingAvatarId = avatar.id;
    avatarName = avatar.name;
    selectedGender = avatar.gender;
    traits = List<TraitModel>.from(avatar.traits);
    _avatarImageUrl = avatar.avatarUrl;
    _avatarImagePath = null; // no local path for existing avatars
    if (avatar.voiceId != null) {
      _selectedSampleVoiceId = avatar.voiceId;
    }
    DebugPoint.log('Loaded avatar for edit: ${avatar.name} (id: ${avatar.id})');
    notifyListeners();
  }

  static final List<TraitModel> traitSuggestions = [
    TraitModel(id: 1, name: 'Adventurous'),
    TraitModel(id: 2, name: 'Brave'),
    TraitModel(id: 3, name: 'Bold'),
    TraitModel(id: 4, name: 'Calm'),
    TraitModel(id: 5, name: 'Charismatic'),
    TraitModel(id: 6, name: 'Cheerful'),
    TraitModel(id: 7, name: 'Curious'),
    TraitModel(id: 8, name: 'Creative'),
    TraitModel(id: 9, name: 'Fearless'),
    TraitModel(id: 10, name: 'Friendly'),
    TraitModel(id: 11, name: 'Kind'),
    TraitModel(id: 12, name: 'Loyal'),
    TraitModel(id: 13, name: 'Playful'),
    TraitModel(id: 14, name: 'Smart'),
    TraitModel(id: 15, name: 'Wise'),
  ];

  final AudioRecorder _recorder = AudioRecorder();
  Timer? _recordingTimer;
  DateTime? _recordingStartAt;

  // -------------------------
  // Avatar field methods
  // -------------------------
  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void updateName(String name) {
    avatarName = name;
    notifyListeners();
  }

  void updateGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  void addTrait(TraitModel trait) {
    if (!traits.any((t) => t.name == trait.name)) {
      traits.add(trait);
      notifyListeners();
    }
  }

  void removeTrait(String traitName) {
    traits.removeWhere((t) => t.name == traitName);
    notifyListeners();
  }

  void toggleTrait(TraitModel trait) {
    if (traits.any((t) => t.name == trait.name)) {
      traits.removeWhere((t) => t.name == trait.name);
    } else {
      traits.add(trait);
    }
    notifyListeners();
  }

  void updateVoice(String voice) {
    selectedVoice = voice;
    selectSampleVoice(voice); // Use new method that handles mutual exclusion
  }

  void updatePrompt(String newPrompt) {
    prompt = newPrompt;
    notifyListeners();
  }

  // -------------------------
  // Voice clone step methods
  // -------------------------
  void nextVoiceStep() {
    if (currentVoiceStep < totalVoiceSteps - 1) {
      setVoiceStep(currentVoiceStep + 1);
    }
  }

  void previousVoiceStep() {
    if (currentVoiceStep > 0) {
      setVoiceStep(currentVoiceStep - 1);
    }
  }

  void setVoiceStep(int step) {
    if (step < 0 || step >= totalVoiceSteps || step == currentVoiceStep) return;
    currentVoiceStep = step;
    voicePageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  void toggleAgreement(bool val) {
    isAgreed = val;
    notifyListeners();
  }

  // -------------------------
  // Voice recording methods
  // -------------------------
  Future<void> startRecording() async {
    if (isRecording) return;

    final micGranted = await Permission.microphone.request();
    if (!micGranted.isGranted) return;

    final dir = await getTemporaryDirectory();
    final filePath =
        '${dir.path}/clone_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000),
      path: filePath,
    );

    audioPath = null;
    transcript = null;
    voiceDuration = null;
    recordingElapsed = Duration.zero;
    isRecording = true;
    _recordingStartAt = DateTime.now();
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      final start = _recordingStartAt;
      if (start == null) return;
      recordingElapsed = DateTime.now().difference(start);
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> stopRecording() async {
    if (!isRecording) return;

    final path = await _recorder.stop();
    _recordingTimer?.cancel();

    isRecording = false;
    _recordingStartAt = null;
    voiceDuration = recordingElapsed;
    if (voiceDuration == null || voiceDuration == Duration.zero) {
      voiceDuration = const Duration(seconds: 1);
    }
    transcript =
        'Your voice recording is ready. Tap play to preview or retake if needed.';

    // Use new method that handles mutual exclusion
    setRecordedVoice(path ?? '');
  }

  Future<void> retakeRecording() async {
    _recordingTimer?.cancel();
    if (isRecording) {
      await _recorder.stop();
    }

    isRecording = false;
    audioPath = null;
    voiceName = '';
    transcript = null;
    voiceDuration = null;
    recordingElapsed = Duration.zero;
    _recordingStartAt = null;
    // Note: We don't clear sample voice here, user can switch between them
    notifyListeners();
  }

  void updateVoiceName(String value) {
    voiceName = value.trim();
    notifyListeners();
  }

  // -------------------------
  // ElevenLabs API - Voice Cloning
  // -------------------------
  static String get _elevenLabsApiKey => AppConfig.elevenLabsApiKey;
  static String get _elevenLabsEndpoint =>
      '${AppConfig.elevenLabsEndpoint}/voices/add';

  /// Upload voice to ElevenLabs and get voice ID
  /// Returns voice ID based on source: recorded (cloned), sample (used as-is), or default
  Future<String?> getOrCreateVoiceId() async {
    // If using default voice, return default ID
    if (isUsingDefaultVoice) {
      DebugPoint.log('Using default voice: $defaultVoiceId');
      return defaultVoiceId;
    }

    // If using sample voice, return the sample voice ID
    if (hasSampleVoice) {
      DebugPoint.log('Using sample voice: $_selectedSampleVoiceId');
      return _selectedSampleVoiceId;
    }

    // If recorded voice, clone it to ElevenLabs
    if (hasRecordedVoice && audioPath != null) {
      try {
        // Check API key first
        DebugPoint.log(
          'ElevenLabs API Key configured: ${_elevenLabsApiKey.isNotEmpty}',
        );
        DebugPoint.log(
          'ElevenLabs API Key length: ${_elevenLabsApiKey.length}',
        );

        if (_elevenLabsApiKey.isEmpty) {
          ToastUtils.error(
            'ElevenLabs API key not configured. Check .env file',
          );
          return null;
        }

        ToastUtils.show('Cloning your voice with ElevenLabs...');
        DebugPoint.log('Cloning voice from file: ${audioPath!}');

        final dio = DioClient();
        final file = File(audioPath!);

        // Create multipart form data
        final formData = FormData.fromMap({
          'name': voiceName.isNotEmpty ? voiceName : avatarName,
          'description': 'Voice cloned for $avatarName',
          'files': await MultipartFile.fromFile(
            file.path,
            filename: 'voice_sample.mp3',
          ),
        });

        final response = await dio.dio.post(
          _elevenLabsEndpoint,
          data: formData,
          options: Options(headers: {'xi-api-key': _elevenLabsApiKey}),
        );

        DebugPoint.log('ElevenLabs Response status: ${response.statusCode}');
        DebugPoint.debug('Response data: ${response.data}');

        if (response.statusCode == 200) {
          final voiceId = response.data['voice_id'];
          DebugPoint.log('Voice cloned successfully! ID: $voiceId');
          ToastUtils.success('Voice cloned successfully!');
          return voiceId;
        } else {
          DebugPoint.error('Failed to clone voice: ${response.statusCode}');
          ToastUtils.error('Failed to clone voice: ${response.statusCode}');
          return null;
        }
      } catch (e) {
        DebugPoint.error('ElevenLabs API Error: $e');
        ToastUtils.error('ElevenLabs API Error: $e');
        return null;
      }
    }

    return null;
  }

  // -------------------------
  // Update avatar
  // -------------------------
  Future<void> updateAvatar() async {
    if (_editingAvatarId == null) {
      ToastUtils.error('No avatar selected for update');
      return;
    }

    if (avatarName.trim().isEmpty) {
      ToastUtils.error('Please enter a name for your avatar');
      return;
    }

    _isCreating = true;
    notifyListeners();

    try {
      // If a new local image was picked, upload it first
      String? storageUrl = _avatarImageUrl;
      if (_avatarImagePath != null) {
        final file = File(_avatarImagePath!);
        if (await file.exists()) {
          ToastUtils.show('Uploading image...');
          storageUrl = await SupabaseStorageService.uploadImage(
            file: file,
            bucketName: DBConstansts.avatars,
          );
          if (storageUrl != null) {
            _avatarImageUrl = storageUrl;
          } else {
            ToastUtils.error('Failed to upload image');
            return;
          }
        }
      }

      final updated = AvatarModel(
        id: _editingAvatarId,
        name: avatarName,
        gender: selectedGender,
        traits: traits,
        avatarUrl: storageUrl ?? '',
        voiceId: _selectedSampleVoiceId,
        voiceTerm: isAgreed,
      );

      await _avatarRepo.updateAvatar(updated);

      DebugPoint.log('Avatar updated: $avatarName (id: $_editingAvatarId)');
      ToastUtils.success('Avatar "$avatarName" updated!');

      // Refresh list
      try {
        final ctx = NavigationService.context;
        if (ctx != null) {
          ctx.read<AvatarsProvider>().fetchAvatars();
        }
      } catch (_) {}

      _editingAvatarId = null;
      NavigationService.pop();
    } catch (e) {
      DebugPoint.error('Failed to update avatar: $e');
      ToastUtils.error('Failed to update avatar: $e');
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  // -------------------------
  // Create avatar with voice
  // -------------------------
  Future<void> createAvatar() async {
    DebugPoint.log('Creating avatar...');
    DebugPoint.log('Avatar name: $avatarName');
    DebugPoint.log('Avatar image path: $avatarImagePath');
    DebugPoint.log('Avatar image URL: $avatarImageUrl');
    DebugPoint.log(
      'Voice source: ${hasRecordedVoice
          ? "recorded"
          : hasSampleVoice
          ? "sample"
          : "default"}',
    );

    if (avatarName.trim().isEmpty) {
      ToastUtils.error('Please enter a name for your avatar');
      return;
    }

    _isCreating = true;
    notifyListeners();

    // TODO: Voice ID generation - commented for now
    // String? voiceId = await getOrCreateVoiceId();
    // DebugPoint.log('Voice ID result: $voiceId');

    try {
      // Step 1: Upload image to Supabase Storage (BG already removed in preview)
      String? storageUrl = avatarImageUrl;

      if (storageUrl == null && _avatarImagePath != null) {
        DebugPoint.log('Uploading avatar image to Supabase Storage...');
        ToastUtils.show('Uploading image...');

        final file = File(_avatarImagePath!);
        if (await file.exists()) {
          storageUrl = await SupabaseStorageService.uploadImage(
            file: file,
            bucketName: DBConstansts.avatars,
          );

          if (storageUrl != null) {
            DebugPoint.log('Image uploaded to storage: $storageUrl');
            _avatarImageUrl = storageUrl;
            notifyListeners();
          } else {
            DebugPoint.error('Failed to upload image to storage');
            ToastUtils.error('Failed to upload image');
            return;
          }
        } else {
          DebugPoint.error('Local image file not found: $_avatarImagePath');
          ToastUtils.error('Image file not found');
          return;
        }
      }

      if (storageUrl == null || storageUrl.isEmpty) {
        DebugPoint.error('No avatar image URL available');
        ToastUtils.error('No avatar image available');
        return;
      }

      // Step 2: Build avatar model with storage URL
      final avatar = AvatarModel(
        name: avatarName,
        gender: selectedGender,
        traits: traits,
        avatarUrl: storageUrl,
        voiceId: null, // TODO: add voice ID when voice cloning is enabled
        voiceTerm: isAgreed,
      );

      DebugPoint.log('Creating avatar in database...');
      DebugPoint.log('Avatar data: ${avatar.toJson()}');

      // Step 3: Save avatar to database
      final createdAvatar = await _avatarRepo.createAvatar(avatar);

      DebugPoint.log(
        'Avatar created successfully - ID: ${createdAvatar.id}, Name: ${createdAvatar.name}',
      );
      ToastUtils.success('Avatar "$avatarName" created successfully!');
      reset();

      // Refresh avatars list
      try {
        final ctx = NavigationService.context;
        if (ctx != null) {
          ctx.read<AvatarsProvider>().fetchAvatars();
        }
      } catch (_) {}

      NavigationService.goNamed(AppRoutes.bottomNavbar);
    } catch (e) {
      DebugPoint.error('Failed to create avatar: $e');
      ToastUtils.error('Failed to create avatar: $e');
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  /// Prepare avatar for preview by removing background
  /// Shows loading screen and returns true if successful
  Future<bool> prepareAvatarForPreview() async {
    if (_avatarImagePath == null) {
      ToastUtils.error('No avatar image available');
      return false;
    }

    _isPreparingPreview = true;
    notifyListeners();

    try {
      final file = File(_avatarImagePath!);
      if (!await file.exists()) {
        ToastUtils.error('Image file not found');
        return false;
      }

      DebugPoint.log('Removing image background via remove.bg...');

      final removedBgPath = await _backgroundRemovalService.removeBackground(
        file,
      );
      if (removedBgPath != null) {
        DebugPoint.log('Background removed for preview: $removedBgPath');
        _avatarImagePath = removedBgPath;
        notifyListeners();
        return true;
      } else {
        DebugPoint.log('BG removal failed or skipped, using original');
        // Still return true since we have the original image
        return true;
      }
    } catch (e) {
      DebugPoint.error('Failed to prepare avatar for preview: $e');
      ToastUtils.error('Failed to process avatar image');
      return false;
    } finally {
      _isPreparingPreview = false;
      notifyListeners();
    }
  }

  /// Reset all fields after avatar creation
  void reset() {
    // Avatar fields
    currentIndex = 0;
    avatarName = '';
    selectedGender = 'Female';
    traits = [];
    selectedVoice = 'Voice 1';
    prompt = '';
    _avatarImagePath = null;
    _avatarImageUrl = null;
    _editingAvatarId = null;

    // Voice clone step
    currentVoiceStep = 0;
    isAgreed = false;

    // Voice source selection
    _selectedSampleVoiceId = null;

    // Voice recording state
    isRecording = false;
    audioPath = null;
    transcript = null;
    voiceDuration = null;
    recordingElapsed = Duration.zero;
    voiceName = '';

    // Reset page controller
    if (voicePageController.hasClients) {
      voicePageController.jumpToPage(0);
    }

    DebugPoint.log('CreateAvatarProvider reset');
    notifyListeners();
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _recorder.dispose();
    voicePageController.dispose();
    super.dispose();
  }
}
