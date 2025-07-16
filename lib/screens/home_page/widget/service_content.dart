import '../../../utils/icomoon_code_map.dart';
import '../data_model/theme_customization.dart';
import '../utils/index.dart';

class ServiceGridScreen extends StatelessWidget {
  final List<ServiceModel>? services;
  const ServiceGridScreen(this.services, {super.key});

  IconData _getIcon(String name) {
    final hex = icomoonCodeMap[name];
    if (hex == null) {
      return const IconData(0xe93a, fontFamily: 'IcoMoon');
    }
    return IconData(int.parse((hex), radix: 16), fontFamily: 'IcoMoon');
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: services?.length ?? 0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final service = services?[index];
        return Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                child: Icon(
                  _getIcon(service?.serviceIcon ?? ""),
                  size: 30,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                service?.title ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                service?.description ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
