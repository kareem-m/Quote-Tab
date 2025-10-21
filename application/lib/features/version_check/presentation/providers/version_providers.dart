import 'dart:developer';

import 'package:clean_quote_tab_todo/features/version_check/data/repos/version_repo_impl.dart';
import 'package:clean_quote_tab_todo/features/version_check/data/sources/version_remote_data_source.dart';
import 'package:clean_quote_tab_todo/features/version_check/domain/repos/version_repository.dart';
import 'package:clean_quote_tab_todo/features/version_check/domain/usecases/get_latest_android_version.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum VersionStatus {
  upToDate, updateRequired
}

final versionDataSourceProvider = Provider<VersionRemoteDataSource>((ref){
  return VersionRemoteDataSource();
});

final versionRepoProvider = Provider<VersionRepository>((ref){
  return VersionRepoImpl(ref.watch(versionDataSourceProvider));
});

final getLatestAndroidVerisonProvider = Provider((ref){
  return GetLatestAndroidVersion(ref.watch(versionRepoProvider));
});

final packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return await PackageInfo.fromPlatform();
});

final versionCheckProvider = FutureProvider<VersionStatus>((ref) async {
  final packageInfo = await ref.watch(packageInfoProvider.future);
  final currentVersion = packageInfo.version;

  final latestVersion = await ref.watch(getLatestAndroidVerisonProvider).call();

  log('Current Version: $currentVersion');
  log('Latest Version: $latestVersion');

  if (currentVersion == latestVersion){
    return VersionStatus.upToDate;
  }
  else {
    return VersionStatus.updateRequired;
  }
});