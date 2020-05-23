# frozen_string_literal: true

require "rubygems"
require "cairo"

Particle = Struct.new(:x, :y, :vx, :vy, :r, :g, :b)

$LX = 400
$LY = 100

steps = 200
$a = Array.new(steps) do |i|
  if i < steps/2
    2
  else
    -2
  end
end

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

      vx = $a.shuffle.dup
      vy = $a.shuffle.dup
      r = rand
      g = rand
      b = rand
      atoms.push Particle.new(x, y, vx, vy, r, g, b)
    end
  end
  atoms
end

def step(atoms, i)
  atoms.each do |a|
    a.x += a.vx[i]
    a.y += a.vy[i]
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

steps.times do |i|
  index = (i + 108) % steps
  filename = format("%04d.png", index)
  puts filename
  step(atoms, i)
  save_png(filename, atoms)
  # puts "#{i} #{atoms[0].x} #{atoms[0].y}"
end
