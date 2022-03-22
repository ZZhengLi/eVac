import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vaccinationapp/widgets/icons.dart';
import 'package:vaccinationapp/widgets/svg_asset.dart';

class DiscoverSmallCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Color? gradientStartColor;
  final Color? gradientEndColor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Widget? icon;
  final Function? onTap;
  final String? tag;
  const DiscoverSmallCard(
      {Key? key,
      this.title,
      this.subtitle,
      this.gradientStartColor,
      this.gradientEndColor,
      this.height,
      this.width,
      this.borderRadius,
      this.onTap,
      this.icon,
      this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => onTap!(),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              gradientStartColor ?? const Color(0xff441DFC),
              gradientEndColor ?? const Color(0xff4E81EB),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Stack(
          children: [
            SizedBox(
              height: 176.w,
              width: 305.w,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 176.w,
                width: 305.w,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 176.w,
                      width: 305.w,
                      child: const SvgAsset(assetName: AssetName.vectorBottom),
                    ),
                    SizedBox(
                      child: SvgAsset(
                          height: 176.w,
                          width: 305.w,
                          // fit: BoxFit.fitHeight,
                          assetName: AssetName.vectorTop),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
                height: 176.w,
                width: 305.w,
                child: Padding(
                    padding:
                        EdgeInsets.only(left: 20.w, top: 20.w, bottom: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Hero(
                          tag: tag ?? '',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              title!,
                              style: TextStyle(
                                  fontSize: 18.w,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          subtitle!,
                          style: TextStyle(
                              fontSize: 14.w,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        Row(
                          children: [
                            icon ?? Container(),
                          ],
                        )
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
