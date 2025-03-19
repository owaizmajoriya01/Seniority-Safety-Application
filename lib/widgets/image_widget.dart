import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Widget for displaying image with inbuilt loader and error handler.
///
/// This widget can display image from [File] , URl, and [Uint8List].
///
/// If all parameters are passed, then image is selected in order of [file],[imagePath],[imageUrl],[imageData] and [svgAssetName].
class ImageWidget extends StatelessWidget {
  /// before passing [file] , check if its image file.
  ///
  /// if it is invalid type , this widget will return 'Image not Found' ui.
  final File? file;

  ///Image path
  final String? imagePath;

  /// before passing [imageUrl] , check if its valid url.
  ///
  /// if [imageUrl] is invalid , this widget will return 'Image not Found' ui.
  final String? imageUrl;

  ///path of svg asset.
  ///
  ///path that points to valid svg.
  final String? svgAssetName;
  final Uint8List? imageData;

  ///used to restrict image size.
  final Size? size;

  ///BoxFit for image.
  final BoxFit? boxFit;

  final BorderRadius? borderRadius;

  ///callback function when error occurred while loading image.
  final void Function(Object exception, StackTrace? stacktrace)? onError;

  const ImageWidget({
    Key? key,
    this.file,
    this.imageUrl,
    this.imageData,
    this.size,
    this.boxFit,
    this.onError,
    this.svgAssetName,
    this.borderRadius,
    this.imagePath,
  }) : super(key: key);

  static const baseUrl = "";

  String get _formattedImageUrl {
    return imageUrl ??"";
    if (imageUrl == null || imageUrl!.isEmpty) {
      return "";
    }
    if (imageUrl!.startsWith('http')) {
      return imageUrl!;
    } else {
      return baseUrl + imageUrl!;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (file != null) {
      child = Image.file(
        file!,
        width: size?.height,
        height: size?.width,
        fit: boxFit,
        errorBuilder: _errorBuilder,
        frameBuilder: _frameBuilder,
      );
    } else if (imagePath != null) {
      child = Image.file(
        File(imagePath!),
        width: size?.height,
        height: size?.width,
        fit: boxFit,
        errorBuilder: _errorBuilder,
        frameBuilder: _frameBuilder,
      );
    } else if (imageUrl != null) {
      debugPrint('Debug ImageWidget.build : $imageUrl');
      debugPrint('Debug ImageWidget.build : $_formattedImageUrl');
      child = Image.network(
        _formattedImageUrl,
        width: size?.height,
        height: size?.width,
        fit: boxFit,
        loadingBuilder: _loadingBuilder,
        errorBuilder: _errorBuilder,
        frameBuilder: _frameBuilder,
      );
    } else if (imageData != null) {
      child = Image.memory(
        imageData!,
        width: size?.height,
        height: size?.width,
        fit: boxFit,
        errorBuilder: _errorBuilder,
        frameBuilder: _frameBuilder,
      );
    } else if (svgAssetName != null && svgAssetName!.isNotEmpty) {
      child = SvgPicture.asset(
        svgAssetName!,
        width: size?.height,
        height: size?.width,
      );
    } else {
      child = const FittedBox(fit: BoxFit.contain, child: ImageNotFound());
    }

    if (borderRadius == null) {
      return SizedBox(width: size?.height, height: size?.width, child: child);
    } else {
      return SizedBox(
        width: size?.height,
        height: size?.width,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: child,
        ),
      );
    }
  }

  Widget _loadingBuilder(context, widget, chunk) {
    if (chunk?.cumulativeBytesLoaded == chunk?.expectedTotalBytes) {
      return widget;
    } else {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: SizedBox(
            height: 32,
            width: 32,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }

  Widget _errorBuilder(context, object, stackTrace) {
    onError?.call(object, stackTrace);
    return const FittedBox(fit: BoxFit.scaleDown, child: ImageNotFound());
  }

  Widget _frameBuilder(BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
    if (wasSynchronouslyLoaded) {
      return child;
    }
    return AnimatedOpacity(
      opacity: frame == null ? 0 : 1,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
      child: child,
    );
  }
}

class ImageNotFound extends StatelessWidget {
  const ImageNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.broken_image_rounded),
        Text(
          "Not\n Found",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 8),
        )
      ],
    );
  }
}

class ImageOrIconWidget extends StatelessWidget {
  const ImageOrIconWidget({Key? key, this.imageUrl, this.icon, this.size = const Size(16, 16), this.borderRadius = 2})
      : super(key: key);

  final String? imageUrl;

  ///[icon] is used when [imageUrl] is null.
  ///
  /// default value for [icon] is Icons.person
  final Icon? icon;

  ///icon and image size
  ///
  /// default value for [size] is Size(16,16)
  final Size size;

  ///border radius for icon as well as image
  ///
  /// default value for [borderRadius] is 2
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    debugPrint('Debug ImageOrIconWidget.build :$imageUrl ');
    if (imageUrl != null && isUrlValid) {
      return ImageWidget(
        imageUrl: imageUrl,
        size: size,
        borderRadius: BorderRadius.circular(borderRadius),
      );
    } else if (icon == null) {
      return Container(
        decoration: BoxDecoration(color: const Color(0xfff5f5f5), borderRadius: BorderRadius.circular(borderRadius)),
        padding: const EdgeInsets.all(2),
        child: Icon(
          Icons.person,
          size: size.height,
        ),
      );
    } else {
      return SizedBox.fromSize(size: size, child: icon);
    }
  }

  bool get isUrlValid {
    return imageUrl?.startsWith("http") == true||imageUrl?.startsWith("https") == true || imageUrl?.startsWith("www") == true;
  }
}

class ProfileImage extends StatelessWidget {
  final String? url;
  final String name;

  const ProfileImage({super.key, required this.url, required this.name});

  @override
  Widget build(BuildContext context) {
    return url != null && url!.isNotEmpty
        ? Image.network(url!)
        : CircleAvatar(
            backgroundColor: _generateColor(name),
            child: Text(
              _generateInitials(name),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          );
  }

  String _generateInitials(String name) {
    var names = name.split(" ");
    if (names.length > 1) {
      return "${names[0][0]}${names[1][0]}";
    } else {
      return name[0];
    }
  }

  Color _generateColor(String name) {
    final int hash = name.hashCode;
    final double hue = (360.0 * hash / (pow(2, 32)));
    return HSVColor.fromAHSV(1.0, hue, 0.5, 0.7).toColor();
  }
}
