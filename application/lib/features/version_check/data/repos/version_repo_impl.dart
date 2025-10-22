import 'package:clean_quote_tab_todo/features/version_check/data/sources/version_remote_data_source.dart';
import 'package:clean_quote_tab_todo/features/version_check/domain/repos/version_repository.dart';

class VersionRepoImpl implements VersionRepository{
  final VersionRemoteDataSource remoteDataSource;

  VersionRepoImpl(this.remoteDataSource);

  @override
  Future<String> getLatestAndroidVersion() async {
    try{
      return await remoteDataSource.getLatestAndroidVersion();
    }
    catch (e){
      rethrow;
    }
  }
}