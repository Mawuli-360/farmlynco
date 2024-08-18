import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/helper/extensions/language_extension.dart';
import 'package:farmlynco/shared/common_widgets/common_provider/language_provider.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/util/custom_loading_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';

class AboutUsScreen extends ConsumerWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String aboutUsHtml = '''
      
      <p>Welcome to our <span>farmlynco app</span>, a revolutionary platform designed to empower farmers by connecting them directly to buyers. Our goal is to enhance the agricultural value chain by facilitating seamless interactions between farmers and buyers, thereby increasing resource optimization and market access.</p>
      <p>Our app provides a user-friendly interface that allows farmers to list their products, manage their inventories, and negotiate directly with buyers. This not only helps in reducing the time and effort involved in finding the right market but also ensures fair pricing and better profit margins for the farmers.</p>
      <p>For buyers, our app offers a reliable source of high-quality agricultural products directly from the producers. This direct connection helps in ensuring transparency and trust in the procurement process, making it easier to source fresh and organic products.</p>
      <p>We believe in the power of technology to transform the agricultural sector and are committed to supporting farmers in optimizing their resources, reducing waste, and maximizing their earnings.</p>
      <p><strong>Version:</strong> 1.0.0</p>
    ''';
    final targetLanguage = ref.watch(currentLanguage);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "About Us",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<String>(
          future: aboutUsHtml.translateToString(targetLanguage),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CustomLoadingScale());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Html(data: snapshot.data ?? aboutUsHtml);
            }
          },
        ),
      ),
    );
  }
}
