import 'package:flutter/material.dart';

class InputTable extends StatelessWidget {
  const InputTable({
    super.key,
    required this.rightSphere,
    required this.leftSphere,
    required this.rightCylinder,
    required this.leftCylinder,
    required this.rightAxis,
    required this.leftAxis,
  });

  final TextEditingController rightSphere;
  final TextEditingController leftSphere;
  final TextEditingController rightCylinder;
  final TextEditingController leftCylinder;
  final TextEditingController rightAxis;
  final TextEditingController leftAxis;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(80),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        const TableRow(
          children: [
            Padding(padding: EdgeInsets.all(8.0), child: Text('')),
            Padding(padding: EdgeInsets.all(8.0), child: Center(child: Text('Right'))),
            Padding(padding: EdgeInsets.all(8.0), child: Center(child: Text('Left'))),
          ],
        ),
        TableRow(
          children: [
            const Padding(padding: EdgeInsets.all(8.0), child: Text('Sphere')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: rightSphere,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: '0.00'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: leftSphere,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: '0.00'),
              ),
            ),
          ],
        ),
        // Repeat for Cylinder and Axis
      ],
    );
  }
}
