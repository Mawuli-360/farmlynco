import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecommendatioCard extends StatefulWidget {
  const RecommendatioCard({
    super.key,
    required this.title,
    required this.response,
  });

  final String title;
  final String response;

  @override
  State<RecommendatioCard> createState() => _RecommendatioCardState();
}

class _RecommendatioCardState extends State<RecommendatioCard> {
  String formatResponseAsMarkdown(String response) {
    return '''
$response
''';
  }

  String insights = '';

  Future<String> postWeatherInsights() async {
    final url =
        Uri.parse('https://newtonapi-f45t.onrender.com/weather-insights');
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final body = {
      'temperature': '14.1',
      'humidity': '13.5',
      'windspeed': '14.5',
      'pressure': '60.5',
    };

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Request successful, parse the JSON response
        final jsonResponse = json.decode(response.body);
        return jsonResponse['insights'];
        // Handle the response data as needed
      } else {
        // Request failed
        showToast(response.body);
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      showToast('Error: $e');
    }
    return 'Error occurs while loading data from api';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String response = await postWeatherInsights();
        setState(() {
          insights = response;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.h),
        padding: EdgeInsets.all(10.h),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.h),
            color: AppColors.appBgColor,
            border: Border.all(
              color: const Color.fromARGB(144, 50, 137, 122),
            ),
            boxShadow: [
              BoxShadow(
                  color: const Color.fromARGB(26, 0, 0, 0),
                  spreadRadius: 1.5.h,
                  blurRadius: 2.h),
            ]),
        child: Column(
          children: [
            CustomText(
              body: widget.title,
              color: AppColors.headerTitleColor,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            CustomText(
              body: insights,
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }
}
