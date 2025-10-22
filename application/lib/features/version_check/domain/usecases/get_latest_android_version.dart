import 'package:clean_quote_tab_todo/features/version_check/domain/repos/version_repository.dart';

class GetLatestAndroidVersion {
  final VersionRepository repo;

  GetLatestAndroidVersion(this.repo);

  Future<String> call() async {
    return await repo.getLatestAndroidVersion();
  }
}