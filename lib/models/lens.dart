enum LensOption { singleVision, bifocal, progressive }

class Lens {
  String prism;
  String pupillaryDistance;
  double rightSphere;
  double leftSphere;
  double rightCylinder;
  double leftCylinder;
  double rightAxis;
  double leftAxis;

  Lens({
    required this.prism,
    required this.pupillaryDistance,
    required this.rightSphere,
    required this.leftSphere,
    required this.rightCylinder,
    required this.leftCylinder,
    required this.rightAxis,
    required this.leftAxis,
  });

  Map<String, dynamic> toMap() {
    return {
      'prism': prism,
      'pupillaryDistance': pupillaryDistance,
      'rightSphere': rightSphere,
      'leftSphere': leftSphere,
      'rightCylinder': rightCylinder,
      'leftCylinder': leftCylinder,
      'rightAxis': rightAxis,
      'leftAxis': leftAxis,
    };
  }

  factory Lens.fromMap(Map<String, dynamic> map) {
    return Lens(
      prism: map['prism'],
      pupillaryDistance: map['pupillaryDistance'],
      rightSphere: map['rightSphere'],
      leftSphere: map['leftSphere'],
      rightCylinder: map['rightCylinder'],
      leftCylinder: map['leftCylinder'],
      rightAxis: map['rightAxis'],
      leftAxis: map['leftAxis'],
    );
  }
}
