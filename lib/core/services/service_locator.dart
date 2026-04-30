import 'package:avatar_flow/core/dio/dio_client.dart';
import 'package:avatar_flow/core/services/background_removal_service.dart';
import 'package:avatar_flow/core/services/voice_clone_service.dart';
import 'package:avatar_flow/core/services/storage_service.dart';
import 'package:avatar_flow/features/auth/services/auth_service.dart';
import 'package:avatar_flow/features/avatar/repo/avatar_repo.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Core
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Services
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<VoiceCloneService>(() => VoiceCloneService());
  getIt.registerLazySingleton<SupabaseStorageService>(
    () => SupabaseStorageService(),
  );
  getIt.registerLazySingleton<BackgroundRemovalService>(
    () => BackgroundRemovalService(getIt<DioClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<AvatarRepo>(() => AvatarRepo());
}
