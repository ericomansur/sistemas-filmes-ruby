# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🎬 Iniciando seed do CineMatch..."

# Sincronizar gêneros do TMDB
puts "📥 Buscando gêneros do TMDB..."
Genre.sync_from_tmdb

puts "✅ Seed concluído!"
puts "Total de gêneros: #{Genre.count}"