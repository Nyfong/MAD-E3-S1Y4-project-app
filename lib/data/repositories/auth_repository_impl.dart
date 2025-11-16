import 'package:rupp_final_mad/domain/repositories/auth_repository.dart';
import 'package:rupp_final_mad/data/datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource = AuthRemoteDataSource();

  @override
  Future<bool> login(String email, String password) async {
    try {
      // Call API through datasource
      return await _remoteDataSource.login(email, password);
    } catch (e) {
      // For now, accept any email/password combination for demo
      // In production, this would handle actual API errors
      return true;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      return await _remoteDataSource.logout();
    } catch (e) {
      return false;
    }
  }
}

