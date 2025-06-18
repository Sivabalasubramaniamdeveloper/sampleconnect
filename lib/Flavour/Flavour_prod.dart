import 'flavor_config.dart';
import 'package:sampleconnect/main.dart' as sample_connect;

Future<void> main() async {
  FlavorConfig.appFlavor = Flavor.prod;
  await sample_connect.main();
}