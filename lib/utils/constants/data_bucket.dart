import 'package:drawing_app/utils/imports/general_import.dart';

// Where the data of the app is stored

// Flag to track if undo is available
bool canUndo = false;
// Flag to track if redo is available
bool canRedo = false;

bool isEraserMode = false;

bool isExpanded = false;

double strokeWidth = 5;
List<Stroke> strokes = [];
List<Stroke> redoStack = [];
Stroke? currentStroke;

bool isDrawing = false;

