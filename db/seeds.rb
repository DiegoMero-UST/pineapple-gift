# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create the 4 available prizes
prizes_data = [
  {
    name: "Coloring Book",
    description: "A beautiful coloring book with intricate designs to help you relax and unwind."
  },
  {
    name: "Tape Measurer",
    description: "A high-quality retractable tape measure perfect for DIY projects and home improvement."
  },
  {
    name: "Phone Stand",
    description: "An adjustable phone stand that works great for video calls, watching content, or hands-free use."
  },
  {
    name: "Coffee Mug",
    description: "A premium ceramic coffee mug perfect for your morning brew or favorite hot beverage."
  }
]

prizes_data.each do |prize_data|
  Prize.find_or_create_by!(name: prize_data[:name]) do |prize|
    prize.description = prize_data[:description]
  end
end
