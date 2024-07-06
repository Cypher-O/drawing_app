import 'package:drawing_app/utils/imports/general_import.dart';

class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key});

  @override
  State<DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BaseModel>.reactive(
      viewModelBuilder: () => BaseModel(this),
      disposeViewModel: false,
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            actions: [
              IconButton(
                icon: Icon(isEraserMode ? Iconsax.eraser_1 : Iconsax.brush_14),
                onPressed: viewModel.toggleEraserMode,
                tooltip: isEraserMode ? brushLabel : eraserLabel,
              ),
              IconButton(
                icon: const Icon(Iconsax.undo),
                onPressed:
                    canUndo ? viewModel.undo : null, // Disable if can't undo
                tooltip: undoLabel,
              ),
              IconButton(
                icon: const Icon(Iconsax.redo),
                onPressed:
                    canRedo ? viewModel.redo : null, // Disable if can't redo
                tooltip: redoLabel,
              ),
              IconButton(
                icon: const Icon(Iconsax.trash),
                onPressed: canUndo
                    ? viewModel.clearBoard
                    : null, // Disable if nothing to clear
                tooltip: clearBoardLabel,
              ),
            ],
          ),
          body: Stack(
            children: [
              GestureDetector(
                key: const Key('drawingArea'),
                onPanStart: viewModel.onPanStart,
                onPanUpdate: viewModel.onPanUpdate,
                onPanEnd: viewModel.onPanEnd,
                child: CustomPaint(
                  painter: DrawingPainter(
                    strokes,
                    currentStroke,
                    AppColors.whiteColor,
                    isEraserMode,
                    isDrawing ? currentStroke?.points.last : null,
                  ),
                  size: Size.infinite,
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: buildColorPalette(context, viewModel),
              ),
              Positioned(
                right: 16,
                top: MediaQuery.of(context).size.height / 2 - 100,
                child: SlideTransition(
                    position: viewModel.sliderAnimation,
                    child: buildVerticalStrokeSlider(viewModel)),
              ),
              Positioned(
                  right: 16,
                  top: MediaQuery.of(context).size.height / 3 - 100,
                  child: FullScreenToggle(
                    onPressed: viewModel.toggleFullScreen,
                  )),
              Positioned(
                left: 0,
                top: 80,
                child: SlideTransition(
                    position: viewModel.paletteAnimation,
                    child: buildBackgroundColorPalette(context, viewModel)),
              ),
            ],
          ),
        );
      },
    );
  }
}
