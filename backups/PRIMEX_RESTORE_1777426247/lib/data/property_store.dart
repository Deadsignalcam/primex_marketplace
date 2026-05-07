class PropertyItem {
  final String title;
  final String location;
  final String price;
  final String status;
  final String type;

  PropertyItem({
    required this.title,
    required this.location,
    required this.price,
    required this.status,
    required this.type,
  });
}

class PropertyStore {
  static final List<PropertyItem> properties = [
    PropertyItem(
      title: "541 Pine St",
      location: "Johnstown, PA 15902 • 4 Beds • 2 Baths",
      price: "\$125,000",
      status: "For Sale",
      type: "Single Family",
    ),
    PropertyItem(title: "123 Main Street", location: "Johnstown, PA", price: "\$145,000", status: "Available", type: "Residential"),
    PropertyItem(title: "10 Acres Residential Land", location: "Blair County, PA", price: "\$89,000", status: "Available", type: "Land"),
    PropertyItem(title: "456 Oakwood Drive", location: "Altoona, PA", price: "\$225,000", status: "Pending", type: "Residential"),
    PropertyItem(title: "789 Pinecrest Lane", location: "State College, PA", price: "\$175,000", status: "Sold", type: "Residential"),
    PropertyItem(title: "25 Acres Farmland", location: "Cambria County, PA", price: "\$120,000", status: "Available", type: "Land"),
    PropertyItem(title: "Multi-Family Duplex", location: "Ebensburg, PA", price: "\$199,000", status: "Available", type: "Multi-Family"),
    PropertyItem(title: "Commercial Corner Lot", location: "Somerset, PA", price: "\$310,000", status: "Available", type: "Commercial"),
  ];
}
