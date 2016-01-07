# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Person.create(name: "Daniel Roseman", roles: ["primary_developer", "oncall_weekday", "oncall_weekend"], team: "Publishing Platform")
Person.create(name: "Jamie Cobbett", roles: ["primary_developer", "oncall_weekday", "oncall_weekend"], team: "Core Formats")
Person.create(name: "Jenny Duckett", roles: ["primary_developer", "oncall_weekday", "oncall_weekend"], team: "Custom")
Person.create(name: "Richard Boulton", roles: ["primary_developer", "oncall_weekday", "oncall_weekend"], team: "Finding Things")
Person.create(name: "Tom Booth", roles: ["primary_developer", "oncall_weekday", "oncall_weekend"], team: "Other")
Person.create(name: "David Singleton", roles: ["primary_developer"], team: "Core Formats")
Person.create(name: "Tommy Palmer", roles: ["primary_developer"], team: "Publishing Platform")
Person.create(name: "Dai Vaughan", roles: ["primary_developer"], team: "Other")
Person.create(name: "Alex Muller", roles: ["infrastructure_developer", "oncall_weekday", "oncall_weekend"], team: "Infrastructure")
Person.create(name: "Matt Bostock", roles: ["infrastructure_developer", "oncall_weekday", "oncall_weekend"], team: "Infrastructure")
Person.create(name: "Paul Martin", roles: ["infrastructure_developer"], team: "Infrastructure")
Person.create(name: "Elliot Crosby-McCollough", roles: ["supplemental_developer"], team: "Publishing Platform")
Person.create(name: "Issy Long", roles: ["supplemental_developer"], team: "Custom")
Person.create(name: "Brendan Butler", roles: ["supplemental_developer"], team: "Custom")
Person.create(name: "Simon Hughesdon", roles: ["supplemental_developer"], team: "Custom")
Person.create(name: "Jack Scotti", roles: ["supplemental_developer"], team: "Finding Things")
Person.create(name: "Paul Bowsher", roles: ["supplemental_developer"], team: "Core Formats")
Person.create(name: "Ben Lovell", roles: ["supplemental_developer"], team: "Core Formats")
Person.create(name: "Paul Hayes", roles: ["supplemental_developer"], team: "Core Formats")
Person.create(name: "Stuart Gale", roles: ["supplemental_developer"], team: "Finding Things")
Person.create(name: "Tatiana Soukiassian", roles: ["supplemental_developer"], team: "Core Formats")
Person.create(name: "Tijmen Brommet", roles: ["supplemental_developer"], team: "Finding Things")
Person.create(name: "Stephen Richards", roles: ["supplemental_developer"], team: "Finding Things")
Person.create(name: "Brad Wright", roles: ["oncall_weekday", "oncall_weekend"], team: "Other")
Person.create(name: "bob Walker", roles: ["oncall_weekday", "oncall_weekend"], team: "Infrastructure")
