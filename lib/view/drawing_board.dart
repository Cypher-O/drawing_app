import 'package:drawing_app/utils/imports/general_import.dart';

class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key});

  @override
  State<DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late BaseModel viewModel;
  final GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    viewModel.handleAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BaseModel>.reactive(
      viewModelBuilder: () => BaseModel(this),
      onViewModelReady: (viewModel) {
        this.viewModel = viewModel;
        viewModel.loadDrawing();
      },
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            actions: [
              CustomIconButton(
                icon: isEraserMode ? Iconsax.eraser_1 : Iconsax.brush_14,
                size: 18,
                onPressed: viewModel.toggleEraserMode,
                tooltip: isEraserMode ? brushLabel : eraserLabel,
              ),
              CustomIconButton(
                icon: Iconsax.undo,
                size: 18,

                onPressed: viewModel.hasStrokes
                    ? viewModel.undo
                    : null, // Disable if can't undo
                tooltip: undoLabel,
              ),
              CustomIconButton(
                icon: Iconsax.redo,
                size: 18,
                onPressed:
                    canRedo ? viewModel.redo : null, // Disable if can't redo
                tooltip: redoLabel,
              ),
              CustomIconButton(
                icon: Iconsax.save_2,
                onPressed: viewModel.hasStrokes
                    ? () => viewModel.saveDrawingToGallery(context, globalKey)
                    : null,
                tooltip: saveLabel,
              ),
              IconButton(
                icon: const Icon(
                  Iconsax.trash,
                  size: 18,
                ),
                onPressed: viewModel.hasStrokes
                    ? viewModel.clearBoard
                    : null, // Disable if nothing to clear
                tooltip: clearBoardLabel,
              ),
            ],
          ),
          body: Stack(
            children: [
              RepaintBoundary(
                key: globalKey,
                child: GestureDetector(
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
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: SlideTransition(
                  position: viewModel.colorPaletteAnimation,
                  child: buildColorPalette(
                    context,
                    viewModel,
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: MediaQuery.of(context).size.height / 3 - 100,
                child: SlideTransition(
                  position: viewModel.sliderAnimation,
                  child: buildVerticalStrokeSlider(
                    viewModel,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 80,
                child: SlideTransition(
                  position: viewModel.paletteAnimation,
                  child: buildBackgroundColorPalette(
                    context,
                    viewModel,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
