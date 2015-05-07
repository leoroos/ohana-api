CSV.generate do |csv|
  csv << [
    "Organization Name",
  ]

  @organizations.each do |organization|
    csv << [
      organization.name,
    ]
  end
end
