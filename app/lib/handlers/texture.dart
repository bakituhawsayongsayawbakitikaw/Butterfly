part of 'handler.dart';

class TextureHandler extends PastingHandler<TextureTool> {
  TextureHandler(super.data);

  @override
  List<PadElement> transformElements(Rect rect, String layer) {
    if (rect.isEmpty) return [];

    return [
      TextureElement(
        firstPosition: rect.topLeft.toPoint(),
        secondPosition: rect.bottomRight.toPoint(),
        texture: data.texture,
        layer: layer,
      ),
    ];
  }

  @override
  double get constraintedAspectRatio => data.constrainedAspectRatio;
  @override
  double get constraintedHeight => data.constrainedHeight;
  @override
  double get constraintedWidth => data.constrainedWidth;
}
