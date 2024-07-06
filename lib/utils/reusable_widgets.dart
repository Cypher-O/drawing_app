import 'package:drawing_app/utils/imports/general_import.dart';

Widget buildColorPalette(BuildContext context, BaseModel viewModel) {
  return Container(
    height: 60,
    width: MediaQuery.of(context).size.width - 32,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
    ),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: colors.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: _buildColorChooser(viewModel, colors[index])),
        );
      },
    ),
  );
}

// Build the background color palette on the left side
Widget buildBackgroundColorPalette(BuildContext context, BaseModel viewModel) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    height: 52,
    width: isExpanded ? MediaQuery.of(context).size.width * 0.5 : 52,
    decoration: BoxDecoration(
      color: Colors.grey[100]!,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(16.0),
        bottomRight: Radius.circular(16.0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isExpanded)
          Expanded(
            child: ListView.builder(
              reverse: true,
              scrollDirection: Axis.horizontal,
              itemCount: backgroundColors.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildBackgroundColorChooser(
                      viewModel, backgroundColors[index]),
                );
              },
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildSettingsIcon(viewModel),
        ),
      ],
    ),
  );
}

// Build the vertical stroke width slider
Widget buildVerticalStrokeSlider(BaseModel viewModel) {
  return RotatedBox(
    quarterTurns: 3,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const RotatedBox(
            quarterTurns: 5,
            child: Icon(Icons.line_weight_rounded, size: 24),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 150,
            child: Slider(
              min: 1,
              max: 25,
              divisions: 19,
              value: strokeWidth,
              onChanged: (value) {
                viewModel.updateStrokeWidth(value);
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildColorChooser(BaseModel viewModel, Color color) {
  bool isSelected = AppColors.blackColor == color;
  return GestureDetector(
    onTap: () {
      viewModel.setSelectedColor(color);
    },
    child: Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 1,
            ),
        ],
      ),
    ),
  );
}

Widget _buildBackgroundColorChooser(BaseModel viewModel, Color color) {
  bool isSelected = AppColors.whiteColor == color;
  return GestureDetector(
    onTap: () {
      viewModel.setSelectedBackGroundColor(color);
    },
    child: Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 1,
            ),
        ],
      ),
    ),
  );
}

Widget _buildSettingsIcon(BaseModel viewModel) {
  return GestureDetector(
    onTap: () {
      viewModel.toggleExpanded();
    },
    child: Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[500]!, width: 3),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            isExpanded ? Icons.arrow_back_ios_rounded : Iconsax.setting_44,
            key: ValueKey<bool>(isExpanded),
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}


class FullScreenToggle extends StatelessWidget {
  final VoidCallback onPressed;

  const FullScreenToggle({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.fullscreen),
    );
  }
}
