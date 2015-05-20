CSV.generate do |csv|
  csv << [
    "Organization Name",
    "Location Name",
    "Description",
    "Emails",
    "Hours",
    "Languages",
    "Short Description",
    "URLs",
  ]

  Location.all.each do |location|
    csv << [
      location.organization.name.to_s,
      location.name.to_s,
      location.description.to_s,
      location.emails.join(", "),
      location.hours.to_s,
      location.languages.join(", "),
      location.short_desc.to_s,
      location.urls.join(", "),
    ]
  end
end
