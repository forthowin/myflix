# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

bob = User.create(email: 'bob@myflix.com', password: 'password', full_name: 'Bob Bo')

cat_com = Category.create(name: 'TV Comedies')
cat_dram = Category.create(name: 'TV Drama')
cat_real = Category.create(name: 'Reality TV')

Video.create(title: 'Monk', description: 'Great show.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: cat_com.id)
Video.create(title: 'Family Guy', description: 'Great show.', small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: cat_com.id)
Video.create(title: 'South Park', description: 'Funny show.', small_cover_url: '/tmp/south_park.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: cat_com.id)
Video.create(title: 'Futarama', description: 'Space travel', small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: cat_com.id)
Video.create(title: 'Futarama', description: 'Space travel', small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: cat_com.id)
Video.create(title: 'Futarama', description: 'Space travel', small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: cat_com.id)
family = Video.create(title: 'Family Guy', description: 'Great show.', small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: cat_com.id)

Video.create(title: 'Monk', description: 'Great show.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: cat_dram.id)
Video.create(title: 'Family Guy', description: 'Great show.', small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: cat_dram.id)
Video.create(title: 'South Park', description: 'Funny show.', small_cover_url: '/tmp/south_park.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: cat_dram.id)

Video.create(title: 'Monk', description: 'Great show.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: cat_real.id)
Video.create(title: 'Family Guy', description: 'Great show.', small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: cat_real.id)
Video.create(title: 'South Park', description: 'Funny show.', small_cover_url: '/tmp/south_park.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: cat_real.id)

Review.create(user: bob, video: family, rating: 5, content: 'This was a good show.')
Review.create(user: bob, video: family, rating: 1, content: 'This was a horrible show.')