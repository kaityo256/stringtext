# frozen_string_literal: true

require "rubygems"
require "cairo"

Particle = Struct.new(:x, :y, :vx, :vy, :r, :g, :b)

$LX = 400
$LY = 100

def get_particles
  atoms = []
  format = Cairo::FORMAT_RGB24
  width = $LX
  height = $LY
  surface = Cairo::ImageSurface.new(format, width, height)
  context = Cairo::Context.new(surface)
  context.set_source_rgb(0, 0, 0)
  context.rectangle(0, 0, width, height)
  context.fill
  context.set_source_rgb(1, 1, 1)
  context.select_font_face("Meiryo")
  context.move_to(5, 90)
  context.font_size = 96
  context.show_text("スパコン")
  height.times do |y|
    width.times do |x|
      i = x + y * width
      next if surface.data[i*4].ord ==0

      vx = [-1, 1, -2, 2].sample
      vy = [-1, 1, -0.5, 0.5, -0.25, 0.25, 0.75, -0.75].sample
      r = rand
      g = rand
      b = rand
      atoms.push Particle.new(x, y, vx, vy, r, g, b)
    end
  end
  atoms
end

def step(atoms)
  dt = 2.0
  atoms.each do |a|
    a.x += a.vx*dt
    a.y += a.vy*dt
    a.x += $LX if a.x < 0
    a.y += $LY if a.y < 0
    a.x -= $LX if a.x > $LX
    a.y -= $LY if a.y > $LY
  end
end

def save_png(filename, atoms)
  format = Cairo::FORMAT_RGB24
  width = 800
  height = 200
  surface = Cairo::ImageSurface.new(format, width, height)
  context = Cairo::Context.new(surface)
  context.set_source_rgb(0, 0, 0)
  context.rectangle(0, 0, width, height)
  context.fill
  atoms.each do |a|
    x = a.x*2.to_i
    y = a.y*2.to_i
    context.set_source_rgb(a.r, a.g, a.b)
    # context.set_source_rgb(1, 1, 1)
    context.circle(x, y, 1.3)
    context.fill
  end
  surface.write_to_png(filename)
end

atoms = get_particles

iter = 200
iter.times do |i|
  index = (i + 108) % iter
  filename = format("img%03d.png", index)
  puts filename
  step(atoms)
  save_png(filename, atoms)
end
