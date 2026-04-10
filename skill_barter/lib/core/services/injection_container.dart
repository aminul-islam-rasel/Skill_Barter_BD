import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External
  sl.registerLazySingleton(() => Connectivity());

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}
