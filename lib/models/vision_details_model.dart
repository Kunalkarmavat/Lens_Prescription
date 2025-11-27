class VisionDetails {
  int? id;
  int? personalInfoId;

  double? rightSphere;
  double? leftSphere;

  double? rightNearAdd;
  double? leftNearAdd;

  bool? intermediateAdd; // ✅ checkbox → boolean

  double? rightCylinder;
  double? leftCylinder;

  int? rightAxis;
  int? leftAxis;

  bool? prism; // ✅ stored as INTEGER (1/0) in DB

  String? rightHorizontalPrism;
  String? leftHorizontalPrism;
  String? rightVerticalPrism;
  String? leftVerticalPrism;

  bool? pupillaryDistance; // ✅ stored as INTEGER (1/0)
  
  int? singlePd;
  double? rightDistancePd;
  double? leftDistancePd;

  String? note;

  VisionDetails({
    this.id,
    this.personalInfoId,
    this.rightSphere,
    this.leftSphere,
    this.rightNearAdd,
    this.leftNearAdd,
    this.intermediateAdd = false,
    this.rightCylinder,
    this.leftCylinder,
    this.rightAxis,
    this.leftAxis,
    this.prism = false,
    this.rightHorizontalPrism,
    this.leftHorizontalPrism,
    this.rightVerticalPrism,
    this.leftVerticalPrism,
    this.pupillaryDistance = false,
    this.singlePd,
    this.rightDistancePd,
    this.leftDistancePd,
    this.note,
  });

  // 🔹 Convert Model → Map (for Database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'personal_info_id': personalInfoId,
      'right_sphere': rightSphere,
      'left_sphere': leftSphere,
      'right_near_add': rightNearAdd,
      'left_near_add': leftNearAdd,
      'intermediate_add': (intermediateAdd ?? false) ? 1 : 0, // ✅ bool → int
      'right_cylinder': rightCylinder,
      'left_cylinder': leftCylinder,
      'right_axis': rightAxis,
      'left_axis': leftAxis,
      'prism': (prism ?? false) ? 1 : 0, // ✅ bool → int
      'right_horizontal_prism': rightHorizontalPrism,
      'left_horizontal_prism': leftHorizontalPrism,
      'right_vertical_prism': rightVerticalPrism,
      'left_vertical_prism': leftVerticalPrism,
      'pupillary_distance': (pupillaryDistance ?? false) ? 1 : 0, // ✅ bool → int
      'single_pd': singlePd,
      'right_distance_pd': rightDistancePd,
      'left_distance_pd': leftDistancePd,
      'note': note,
    };
  }

  // 🔹 Convert Map → Model (for Reading from DB)
  factory VisionDetails.fromMap(Map<String, dynamic> map) {
    return VisionDetails(
      id: map['id'],
      personalInfoId: map['personal_info_id'],
      rightSphere: map['right_sphere'] != null ? map['right_sphere'] * 1.0 : null,
      leftSphere: map['left_sphere'] != null ? map['left_sphere'] * 1.0 : null,
      rightNearAdd: map['right_near_add'] != null ? map['right_near_add'] * 1.0 : null,
      leftNearAdd: map['left_near_add'] != null ? map['left_near_add'] * 1.0 : null,
      intermediateAdd: map['intermediate_add'] == 1, // ✅ int → bool
      rightCylinder: map['right_cylinder'] != null ? map['right_cylinder'] * 1.0 : null,
      leftCylinder: map['left_cylinder'] != null ? map['left_cylinder'] * 1.0 : null,
      rightAxis: map['right_axis'],
      leftAxis: map['left_axis'],
      prism: map['prism'] == 1, // ✅ int → bool
      rightHorizontalPrism: map['right_horizontal_prism'],
      leftHorizontalPrism: map['left_horizontal_prism'],
      rightVerticalPrism: map['right_vertical_prism'],
      leftVerticalPrism: map['left_vertical_prism'],
      pupillaryDistance: map['pupillary_distance'] == 1, // ✅ int → bool
      singlePd: map['single_pd'],
      rightDistancePd: map['right_distance_pd'] != null ? map['right_distance_pd'] * 1.0 : null,
      leftDistancePd: map['left_distance_pd'] != null ? map['left_distance_pd'] * 1.0 : null,
      note: map['note'],
    );
  }
}
