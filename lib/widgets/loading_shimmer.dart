import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer._({required this.itemBuilder, required this.itemCount});

  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;

  factory LoadingShimmer.list({int itemCount = 3}) {
    return LoadingShimmer._(
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ShimmerBox(width: double.infinity, height: 16),
            const SizedBox(height: 8),
            const _ShimmerBox(width: 120, height: 16),
            const SizedBox(height: 16),
            const _ShimmerBox(width: double.infinity, height: 200),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == double.infinity
          ? MediaQuery.of(context).size.width
          : width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}


